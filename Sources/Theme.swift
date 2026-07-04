import SwiftUI
import SafariServices
import UIKit

// MARK: - Palette
// Neutral academic warmth, adaptive to light/dark. Light mode is a warm parchment/ink
// scheme; dark mode is a warm dark-parchment scheme with lighter accents so they stay
// legible as text on the dark ground. The horns / debate roles keep muted, equal-weight
// hues so neither side reads as "winning" by color.
private func adaptive(_ light: (Double, Double, Double), _ dark: (Double, Double, Double)) -> Color {
    Color(uiColor: UIColor { trait in
        let c = trait.userInterfaceStyle == .dark ? dark : light
        return UIColor(red: c.0, green: c.1, blue: c.2, alpha: 1)
    })
}

extension Color {
    static let parchment     = adaptive((0.96, 0.94, 0.89), (0.13, 0.12, 0.11))
    static let parchmentCard = adaptive((0.99, 0.98, 0.955), (0.19, 0.17, 0.15))
    static let ink           = adaptive((0.17, 0.17, 0.18), (0.92, 0.90, 0.85))
    static let inkSoft       = adaptive((0.38, 0.37, 0.36), (0.66, 0.63, 0.58))
    static let slate         = adaptive((0.24, 0.36, 0.46), (0.56, 0.70, 0.82))

    static let argument      = adaptive((0.27, 0.42, 0.56), (0.56, 0.71, 0.86)) // cool blue
    static let response      = adaptive((0.34, 0.48, 0.39), (0.60, 0.76, 0.63)) // sage green
    static let counter       = adaptive((0.45, 0.45, 0.47), (0.68, 0.68, 0.72)) // neutral grey
    static let hinge         = adaptive((0.80, 0.52, 0.25), (0.90, 0.66, 0.40)) // contested-hinge amber
}

// MARK: - Reusable text styles
extension Font {
    static func serifTitle(_ size: CGFloat) -> Font { .system(size: size, weight: .semibold, design: .serif) }
}

// MARK: - Verse reference badge (monospace pill)
struct VerseBadge: View {
    let ref: String
    var body: some View {
        Text(ref)
            .font(.system(.caption, design: .monospaced).weight(.medium))
            .foregroundStyle(Color.slate)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Color.slate.opacity(0.10), in: Capsule())
    }
}

// MARK: - Role / category tag
struct Tag: View {
    let text: String
    var color: Color = .inkSoft
    var body: some View {
        Text(text)
            .font(.caption2.weight(.medium))
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.12), in: Capsule())
    }
}

// MARK: - Parchment card container
struct Card<Content: View>: View {
    var accent: Color? = nil
    @ViewBuilder var content: Content
    var body: some View {
        VStack(alignment: .leading, spacing: 10) { content }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(Color.parchmentCard, in: RoundedRectangle(cornerRadius: 14))
            .overlay(alignment: .leading) {
                if let accent {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(accent)
                        .frame(width: 4)
                        .padding(.vertical, 6)
                }
            }
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.ink.opacity(0.06)))
    }
}

// MARK: - Tappable Arabic-term chip → glossary popover
struct TermChip: View {
    let term: String
    @State private var show = false
    private var entry: GlossaryTerm? { AppContent.glossary.first { $0.term.lowercased() == term.lowercased() } }
    var body: some View {
        Button { show.toggle() } label: {
            Text(term)
                .font(.system(.subheadline, design: .serif).italic())
                .lineLimit(1)
                .foregroundStyle(Color.slate)
                .padding(.horizontal, 10).padding(.vertical, 4)
                .background(Color.slate.opacity(0.08), in: Capsule())
                .overlay(Capsule().stroke(Color.slate.opacity(0.25)))
        }
        .buttonStyle(.plain)
        .popover(isPresented: $show) {
            VStack(alignment: .leading, spacing: 8) {
                Text(entry?.term ?? term).font(.serifTitle(20))
                Text(entry?.definition ?? "No definition available.").font(.callout).foregroundStyle(Color.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)   // wrap & grow, don't truncate
            }
            .padding(20).frame(width: 280)
            .presentationCompactAdaptation(.popover)
        }
    }
}

// MARK: - Wrapping flow layout
// Places subviews left to right, wrapping to a new row when the next would overflow —
// so variable-width chips form neat rows instead of a squeezed HStack that wraps text.
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0, y: CGFloat = 0, rowHeight: CGFloat = 0
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x > 0, x + size.width > maxWidth { x = 0; y += rowHeight + spacing; rowHeight = 0 }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        return CGSize(width: maxWidth == .infinity ? max(0, x - spacing) : maxWidth, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX, y = bounds.minY, rowHeight: CGFloat = 0
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x > bounds.minX, x + size.width > bounds.maxX { x = bounds.minX; y += rowHeight + spacing; rowHeight = 0 }
            view.place(at: CGPoint(x: x, y: y), anchor: .topLeading, proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

// MARK: - In-app browser (SFSafariViewController) with a Done button + live failover
// SFSafariViewController must be PRESENTED MODALLY, not embedded in a SwiftUI .sheet —
// embedded it renders blank and its Done button can't dismiss. So we present it from the
// top view controller via UIKit; Done then works natively. If the primary source fails
// its initial load, we dismiss and re-present on the fallback source.
@MainActor
enum InAppBrowser {
    // ponytail: single retained delegate — SFVC.delegate is weak, and only one browser
    // is ever open at a time here. Make it a set if that ever changes.
    private static var keepAlive: Coordinator?

    static func open(_ primary: URL, fallback: URL? = nil) {
        guard let top = UIApplication.topPresentedViewController() else { return }
        let coordinator = Coordinator(fallback: fallback)
        keepAlive = coordinator
        let vc = SFSafariViewController(url: primary)
        vc.delegate = coordinator
        top.present(vc, animated: true)
    }

    @MainActor
    final class Coordinator: NSObject, SFSafariViewControllerDelegate {
        let fallback: URL?
        private var swapped = false
        init(fallback: URL?) { self.fallback = fallback }

        func safariViewController(_ c: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
            // ponytail: only a hard load failure flips to the fallback; an HTTP error page
            // still "loads successfully". One swap, no tertiary source.
            guard !didLoadSuccessfully, !swapped, let fallback else { return }
            swapped = true
            let presenter = c.presentingViewController
            c.dismiss(animated: false) { [weak self] in
                guard let self else { return }
                let vc = SFSafariViewController(url: fallback)
                vc.delegate = self
                presenter?.present(vc, animated: false)
            }
        }

        func safariViewControllerDidFinish(_ c: SFSafariViewController) {
            InAppBrowser.keepAlive = nil
        }
    }
}

extension UIApplication {
    static func topPresentedViewController() -> UIViewController? {
        let root = shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController
        var top = root
        while let presented = top?.presentedViewController { top = presented }
        return top
    }
}

// MARK: - "Read it yourself" tap target — opens the in-app browser
struct SafariLink<Label: View>: View {
    let primary: URL
    var fallback: URL?
    let label: Label
    init(primary: URL, fallback: URL? = nil, @ViewBuilder label: () -> Label) {
        self.primary = primary
        self.fallback = fallback
        self.label = label()
    }
    var body: some View {
        Button { InAppBrowser.open(primary, fallback: fallback) } label: { label }
            .buttonStyle(.plain)
    }
}

// MARK: - Manuscript reading link
// A pre-Islamic manuscript row that opens its authoritative digital archive in-app.
struct ManuscriptLink: View {
    let m: Manuscript
    var body: some View {
        if let url = URL(string: m.url) {
            SafariLink(primary: url, fallback: m.fallback.flatMap { URL(string: $0) }) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    VStack(alignment: .leading, spacing: 1) {
                        Text(m.name).font(.subheadline.weight(.semibold)).foregroundStyle(Color.slate)
                        Text(m.source).font(.caption2).foregroundStyle(Color.inkSoft)
                    }
                    Spacer(minLength: 8)
                    Text(m.date).font(.system(.caption2, design: .monospaced)).foregroundStyle(Color.slate)
                    Image(systemName: "arrow.up.right").font(.caption2).foregroundStyle(Color.inkSoft)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 8).padding(.horizontal, 10)
                .background(Color.parchmentCard, in: RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.slate.opacity(0.15)))
            }
        }
    }
}

// MARK: - "Read it yourself" external link
// Opens the verse in a reputable, sect-neutral online reader (Quran.com / BibleGateway)
// so the user reads the full original text + a translation, not just the app's paraphrase.
struct ReadLink: View {
    let ref: String
    private var isQuran: Bool { ref.hasPrefix("Q") }
    private var site: String { isQuran ? "Quran.com" : "BibleGateway" }
    private var sub: String { isQuran ? "Arabic + your choice of translation" : "original languages + 200+ translations" }
    var body: some View {
        if let url = AppContent.readerURL(for: ref) {
            SafariLink(primary: url, fallback: AppContent.readerFallbackURL(for: ref)) {
                HStack(spacing: 10) {
                    Image(systemName: "book").font(.subheadline)
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Read \(ref) on \(site)").font(.subheadline.weight(.semibold))
                        Text(sub).font(.caption2).foregroundStyle(Color.inkSoft)
                    }
                    Spacer()
                    Image(systemName: "arrow.up.right").font(.caption)
                }
                .foregroundStyle(Color.slate)
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(Color.slate.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.slate.opacity(0.2)))
            }
        }
    }
}

// MARK: - "Reading this fairly" balance sheet (reachable everywhere)
struct BalanceSheet: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("This app walks through a **Christian apologetics** argument (popularized by David Wood / Acts 17 Apologetics) and the **Muslim scholarly responses** to it, on equal footing. It is a reference explainer, not a verdict.")
                    Divider()
                    Label("Every argument is paired with its strongest response, and every response with its counter-reply. Both traditions are steelmanned in their own voice.", systemImage: "scalemass")
                    Label("Claims are owned by who makes them (“Apologists argue”, “Responders answer”, “Historians note”), never asserted by the app.", systemImage: "quote.opening")
                    Label("Quran quotations are paraphrase-level (translations differ: Sahih International, Yusuf Ali, Pickthall) and use standard Hafs / Cairo (1924) verse numbering.", systemImage: "text.book.closed")
                    Label("Nothing here decides the question for you. The judgment is yours.", systemImage: "person.fill.questionmark")
                }
                .font(.callout)
                .foregroundStyle(Color.ink)
                .padding(20)
            }
            .background(Color.parchment)
            .navigationTitle("Reading this fairly")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
        }
    }
}

// MARK: - Go-home action (environment)
// Lets drill-in detail screens (which show a system back button, not the explorer
// top bar) jump straight to the Home landing.
private struct GoHomeKey: EnvironmentKey { static let defaultValue: () -> Void = {} }
extension EnvironmentValues {
    var goHome: () -> Void {
        get { self[GoHomeKey.self] }
        set { self[GoHomeKey.self] = newValue }
    }
}

// MARK: - Light/dark appearance toggle
// Overrides the system appearance (stored in @AppStorage "appearance"). The icon
// reflects the current effective scheme: tap the sun to go light, the moon to go dark.
struct AppearanceToggle: View {
    @AppStorage("appearance") private var appearance = "system"
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        Button {
            appearance = (scheme == .dark) ? "light" : "dark"
        } label: {
            Image(systemName: scheme == .dark ? "sun.max.fill" : "moon.fill")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.slate)
                .frame(width: 38, height: 38)
                .background(Color.parchmentCard, in: Circle())
                .overlay(Circle().stroke(Color.ink.opacity(0.08)))
        }
        .accessibilityLabel("Toggle light or dark mode")
    }
}

// MARK: - Explorer top bar
// A custom top bar (NOT the system nav bar): home button top-left, title centered,
// balance button top-right. The system nav bar is hidden on the screen this is
// applied to, so drill-in detail screens still get their own back arrow.
struct ExplorerBar: ViewModifier {
    let title: String
    let onHome: () -> Void
    @State private var showBalance = false
    func body(content: Content) -> some View {
        content
            .toolbar(.hidden, for: .navigationBar)
            .safeAreaInset(edge: .top, spacing: 0) {
                HStack {
                    barButton("house.fill", "Home", action: onHome)
                    Spacer()
                    Text(title).font(.serifTitle(17)).foregroundStyle(Color.ink)
                    Spacer()
                    barButton("scalemass", "Reading this fairly") { showBalance = true }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.parchment)
                .overlay(alignment: .bottom) { Divider().opacity(0.5) }
            }
            .sheet(isPresented: $showBalance) { BalanceSheet() }
    }
    private func barButton(_ icon: String, _ label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.slate)
                .frame(width: 38, height: 38)
                .background(Color.parchmentCard, in: Circle())
                .overlay(Circle().stroke(Color.ink.opacity(0.08)))
        }
        .accessibilityLabel(label)
    }
}
extension View {
    func explorerBar(_ title: String, onHome: @escaping () -> Void) -> some View {
        modifier(ExplorerBar(title: title, onHome: onHome))
    }
}
