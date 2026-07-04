import SwiftUI

// Post-walkthrough root: a clean Home landing that opens into the tabbed sections.
struct ExplorerView: View {
    @State private var entered = false
    var body: some View {
        if entered {
            TabsView(onHome: { entered = false })
        } else {
            HomeLanding(onEnter: { entered = true })
        }
    }
}

// MARK: - Home landing (no nav bar, like the walkthrough welcome)

struct HomeLanding: View {
    let onEnter: () -> Void
    @AppStorage("didFinishWalkthrough") private var didFinish = true
    @State private var showBalance = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 8) {
                    Image(systemName: "book.closed").font(.system(size: 42)).foregroundStyle(Color.slate)
                    Text("The Islamic Dilemma").font(.serifTitle(34))
                    Text("A balanced look at a well-known argument and the responses to it.")
                        .font(.title3).foregroundStyle(Color.inkSoft)
                }

                Card {
                    Text("In one sentence").font(.serifTitle(18))
                    Text(AppContent.oneSentence).font(.system(.subheadline, design: .serif))
                }

                Button(action: onEnter) {
                    Label("Begin at the Fork", systemImage: "arrow.right.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent).controlSize(.large)

                Card {
                    Text("Find your way around").font(.serifTitle(18))
                    navRow("arrow.triangle.branch", "Fork", "The argument as a tappable diagram.")
                    navRow("text.book.closed", "Verses", "Every Quran & Bible reference, both sides.")
                    navRow("bubble.left.and.bubble.right", "Responses", "Argument, response, counter.")
                    navRow("ellipsis.circle", "More", "Glossary, a short quiz, sources.")
                    Text("From any section, tap the house button in the top-left to come back here.")
                        .font(.caption).foregroundStyle(Color.inkSoft).padding(.top, 4)
                }

                VStack(spacing: 14) {
                    Button { didFinish = false } label: {
                        Label("Replay the walkthrough", systemImage: "arrow.counterclockwise")
                            .lineLimit(1)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 4)
                    }.buttonStyle(.bordered).controlSize(.large)

                    Button { showBalance = true } label: {
                        Label("Reading this fairly", systemImage: "scalemass")
                            .font(.footnote)
                    }
                }
                .padding(.top, 4)
            }
            .padding(20)
        }
        .background(Color.parchment.ignoresSafeArea())
        .sheet(isPresented: $showBalance) { BalanceSheet() }
    }
    private func navRow(_ icon: String, _ title: String, _ sub: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon).foregroundStyle(Color.slate).frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline)
                Text(sub).font(.caption).foregroundStyle(Color.inkSoft)
            }
        }
    }
}

// MARK: - Tabbed sections

struct TabsView: View {
    let onHome: () -> Void
    var body: some View {
        TabView {
            ForkTab(onHome: onHome)
                .tabItem { Label("Fork", systemImage: "arrow.triangle.branch") }
            VersesTab(onHome: onHome)
                .tabItem { Label("Verses", systemImage: "text.book.closed") }
            ResponsesTab(onHome: onHome)
                .tabItem { Label("Responses", systemImage: "bubble.left.and.bubble.right") }
            MoreTab(onHome: onHome)
                .tabItem { Label("More", systemImage: "ellipsis.circle") }
        }
    }
}

// MARK: - Fork tab (interactive diagram hub)

struct ForkTab: View {
    let onHome: () -> Void
    @State private var showContested = false
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    Text("A Christian apologetic argument popularized by David Wood (Acts 17 Apologetics): three Quranic commitments are said to force an either/or about the 7th-century Bible where both options embarrass Islam. Muslim responders dispute the reading of every premise.")
                        .font(.footnote).foregroundStyle(Color.inkSoft)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 8)

                    Toggle("Show where this is contested", isOn: $showContested.animation())
                        .font(.subheadline).tint(.hinge)
                        .padding(.bottom, 12)

                    node("Premise 1 · Affirmation", "The Quran calls the Torah & Gospel genuine revelation.", ["Q5:44", "Q5:46", "Q3:3"], .argument,
                         contested: showContested ? "‘Confirm’ (musaddiq) may mean the message, not the manuscript." : nil)
                    connector
                    node("Premise 2 · Command", "7th-c. Jews & Christians told to judge by their own scriptures.", ["Q5:47", "Q5:68", "Q5:43"], .argument,
                         contested: showContested ? "May be ad hominem (judge by your own book), not a warranty." : nil)
                    connector
                    node("Premise 3 · Preservation", "None can change God's words.", ["Q6:115", "Q18:27"], .argument,
                         contested: showContested ? "‘God's words’ may mean His decree or the Quran, not the Bible." : nil)
                    connector
                    node("Inference", "Therefore the scriptures of ~610–632 CE were EITHER already corrupt OR still reliable.", [], .slate, contested: nil)
                    connector

                    HStack(alignment: .top, spacing: 12) {
                        node("Horn A", "Corrupt then → the Quran endorsed & commanded obedience to a falsified text.", [], .counter,
                             contested: showContested ? "tahrif al-nass vs al-ma'ani opens a third option." : nil)
                        node("Horn B", "Reliable then → that text ≈ today's Bible, which teaches the crucifixion (contra Q4:157), Jesus's divinity & the Trinity.", ["Q4:157"], .argument,
                             contested: showContested ? "Manuscripts rule out only a post-7th-c. rewrite." : nil)
                    }
                    connector
                    node("Close", "Constructive dilemma: both horns are said to damage Islam, so either way the Quran is caught.", [], .slate, contested: nil)

                    Text("This is the skeleton only. Soundness is contested and lives in the Responses tab. The bare corrupt/not-corrupt fork is validly exhaustive; the false-dichotomy charge targets the loaded horns.")
                        .font(.caption).foregroundStyle(Color.inkSoft)
                        .padding(.top, 16)
                }
                .padding(20)
            }
            .background(Color.parchment.ignoresSafeArea())
            .explorerBar("The Fork", onHome: onHome)
        }
    }

    private var connector: some View {
        Rectangle().fill(Color.slate.opacity(0.35)).frame(width: 2, height: 22)
    }

    private func node(_ title: String, _ body: String, _ verses: [String], _ accent: Color, contested: String?) -> some View {
        NavigationLink {
            NodeDetail(title: title, detail: body, verses: verses, accent: accent)
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                Text(title).font(.serifTitle(16)).foregroundStyle(accent)
                Text(body).font(.caption).foregroundStyle(Color.ink).fixedSize(horizontal: false, vertical: true)
                if !verses.isEmpty {
                    HStack(spacing: 4) { ForEach(verses, id: \.self) { VerseBadge(ref: $0) } }
                }
                if let contested {
                    Label(contested, systemImage: "exclamationmark.bubble")
                        .font(.caption2).foregroundStyle(Color.hinge)
                        .padding(.top, 2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(Color.parchmentCard, in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(accent.opacity(0.4)))
        }
        .buttonStyle(.plain)
    }
}

private struct NodeDetail: View {
    let title: String; let detail: String; let verses: [String]; let accent: Color
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(title).font(.serifTitle(24)).foregroundStyle(accent)
                Text(detail).font(.body)
                if !verses.isEmpty {
                    Text("Verses").font(.caption.weight(.semibold)).foregroundStyle(Color.inkSoft)
                    ForEach(verses, id: \.self) { ref in
                        if let v = AppContent.verses.first(where: { $0.ref == ref }) {
                            NavigationLink { VerseDetail(verse: v) } label: {
                                HStack { VerseBadge(ref: ref); Text(v.paraphrase).font(.caption).foregroundStyle(Color.ink); Spacer(); Image(systemName: "chevron.right").font(.caption2).foregroundStyle(Color.inkSoft) }
                            }.buttonStyle(.plain)
                        } else { VerseBadge(ref: ref) }
                    }
                }
                Text("See the Verses and Responses tabs for the full treatment of this joint.")
                    .font(.footnote).italic().foregroundStyle(Color.inkSoft)
            }
            .padding(20)
        }
        .background(Color.parchment.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Verses tab

struct VersesTab: View {
    let onHome: () -> Void
    @State private var selected: VerseCluster? = nil
    @State private var query = ""

    private var filtered: [Verse] {
        AppContent.verses.filter { v in
            (selected == nil || v.cluster == selected) &&
            (query.isEmpty || v.ref.localizedCaseInsensitiveContains(query) || v.paraphrase.localizedCaseInsensitiveContains(query))
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                        TextField("Reference or keyword", text: $query)
                        if !query.isEmpty {
                            Button { query = "" } label: { Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary) }
                                .buttonStyle(.plain)
                        }
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            chip("All", selected == nil, .slate) { selected = nil }
                            ForEach(VerseCluster.allCases) { c in
                                chip(shortName(c), selected == c, c.color) { selected = c }
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                }
                Section {
                    ForEach(filtered) { v in
                        NavigationLink { VerseDetail(verse: v) } label: { row(v) }
                    }
                } footer: {
                    Text("English shown is paraphrase-level; verify wording in your chosen translation. Hafs / Cairo (1924) numbering.")
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.parchment.ignoresSafeArea())
            .explorerBar("Verses", onHome: onHome)
        }
    }

    private func row(_ v: Verse) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack { VerseBadge(ref: v.ref); if v.hinge { Tag(text: "contested hinge", color: .hinge) }; Spacer() }
            Text(v.paraphrase).font(.subheadline).foregroundStyle(Color.ink)
            Tag(text: v.role, color: v.cluster.color)
        }
        .padding(.vertical, 2)
    }

    private func chip(_ label: String, _ on: Bool, _ color: Color, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label).font(.footnote.weight(.medium))
                .foregroundStyle(on ? .white : color)
                .padding(.horizontal, 12).padding(.vertical, 6)
                .background(on ? color : color.opacity(0.12), in: Capsule())
        }.buttonStyle(.plain)
    }

    private func shortName(_ c: VerseCluster) -> String {
        switch c {
        case .affirmation: return "Affirmation"
        case .unchangeable: return "Unchangeable"
        case .tahrif: return "Tahrif"
        case .contested: return "Contested"
        }
    }
}

struct VerseDetail: View {
    let verse: Verse
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack { VerseBadge(ref: verse.ref); Tag(text: verse.role, color: verse.cluster.color); Spacer() }
                Text("“\(verse.paraphrase)”")
                    .font(.system(.title3, design: .serif))
                if let term = verse.keyTerm {
                    HStack(spacing: 8) { Text("Key term:").font(.caption).foregroundStyle(Color.inkSoft); TermChip(term: term) }
                }

                ReadLink(ref: verse.ref)

                Card(accent: .argument) {
                    Label("How apologists use it", systemImage: "arrow.up.forward").font(.subheadline.weight(.semibold)).foregroundStyle(Color.argument)
                    Text(verse.apologist ?? defaultApologist(verse.cluster)).font(.subheadline)
                }
                Card(accent: .response) {
                    Label("How responders read it", systemImage: "arrow.uturn.left").font(.subheadline.weight(.semibold)).foregroundStyle(Color.response)
                    Text(verse.responder ?? defaultResponder(verse.cluster)).font(.subheadline)
                }

                if !verse.crossRefs.isEmpty {
                    Text(isBible(verse.crossRefs.first!) ? "Bible cross-references" : "Related").font(.caption.weight(.semibold)).foregroundStyle(Color.inkSoft)
                    HStack(spacing: 6) {
                        ForEach(verse.crossRefs, id: \.self) { ref in
                            if let v = AppContent.verses.first(where: { $0.ref == ref }) {
                                NavigationLink { VerseDetail(verse: v) } label: { VerseBadge(ref: ref) }
                            } else if let url = AppContent.readerURL(for: ref) {
                                SafariLink(primary: url, fallback: AppContent.readerFallbackURL(for: ref)) { VerseBadge(ref: ref) }
                            } else {
                                VerseBadge(ref: ref)
                            }
                        }
                    }
                    if isBible(verse.crossRefs.first!) {
                        Text("Tap to read the passage in full (NRSVUE + original Greek) on BibleGateway.")
                            .font(.caption2).foregroundStyle(Color.inkSoft)
                    }
                }
            }
            .padding(20)
        }
        .background(Color.parchment.ignoresSafeArea())
        .navigationTitle(verse.ref)
        .navigationBarTitleDisplayMode(.inline)
    }
    private func isBible(_ s: String) -> Bool { !s.hasPrefix("Q") }
    private func defaultApologist(_ c: VerseCluster) -> String {
        switch c {
        case .affirmation: return "Cited to show the Quran endorses the earlier scriptures as genuine and available in Muhammad's day."
        case .unchangeable: return "Applied to the earlier revelation: if God's word can't be altered, the Torah/Gospel could not have been lost before Muhammad."
        case .tahrif: return "A meaning-only reading of these ‘distortion’ verses concedes the text itself was intact."
        case .contested: return "The intact 7th-century Bible teaches what Islam denies here."
        }
    }
    private func defaultResponder(_ c: VerseCluster) -> String {
        switch c {
        case .affirmation: return "Read as confirming the original revelation and its divine origin, not certifying every extant manuscript."
        case .unchangeable: return "‘God's words’ most naturally means His decree or the Quran itself (cf. Q15:9), not a guarantee about Biblical copies."
        case .tahrif: return "The Quran itself alleges the custodians distorted the scripture; affirming its origin while accusing its handlers is one coherent position."
        case .contested: return "Assumes the Quranic Injil and the canonical Gospels are the same text."
        }
    }
}

// MARK: - Responses tab (argument / response / counter decks)

struct ResponsesTab: View {
    let onHome: () -> Void
    var body: some View {
        NavigationStack {
            List(AppContent.topics) { topic in
                NavigationLink { DeckView(topic: topic) } label: {
                    HStack(spacing: 6) {
                        ForEach(topic.cards) { c in Circle().fill(c.role.color).frame(width: 8, height: 8) }
                        Text(topic.title).font(.subheadline).padding(.leading, 4)
                    }
                    .padding(.vertical, 4)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.parchment.ignoresSafeArea())
            .explorerBar("Responses", onHome: onHome)
        }
    }
}

struct DeckView: View {
    let topic: DebateTopic
    @State private var page = 0
    var body: some View {
        VStack(spacing: 12) {
            Text(topic.title).font(.serifTitle(20)).multilineTextAlignment(.center)
                .padding(.horizontal, 20).padding(.top, 8)

            TabView(selection: $page) {
                ForEach(Array(topic.cards.enumerated()), id: \.element.id) { i, card in
                    VStack(alignment: .leading, spacing: 14) {
                        Tag(text: card.role.rawValue, color: card.role.color)
                        ScrollView {
                            Text(card.text)
                                .font(.system(.title3, design: .serif))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Text(card.attribution).font(.caption).foregroundStyle(Color.inkSoft)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(card.role.color.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(card.role.color.opacity(0.4)))
                    .padding(.horizontal, 20)
                    .tag(i)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            Label("This is contested, not concluded. Swipe through all three roles.", systemImage: "arrow.left.arrow.right")
                .font(.caption).foregroundStyle(Color.inkSoft)
                .padding(.bottom, 12)
        }
        .background(Color.parchment.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - More tab (glossary, quiz, about)

struct MoreTab: View {
    let onHome: () -> Void
    @AppStorage("didFinishWalkthrough") private var didFinish = true
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink { GlossaryView() } label: { Label("Glossary", systemImage: "character.book.closed") }
                    NavigationLink { QuizView() } label: { Label("Check your understanding", systemImage: "checkmark.circle") }
                    NavigationLink { AboutView() } label: { Label("About & Sources", systemImage: "info.circle") }
                }
                Section {
                    Button { didFinish = false } label: { Label("Replay the walkthrough", systemImage: "arrow.counterclockwise") }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.parchment.ignoresSafeArea())
            .explorerBar("More", onHome: onHome)
        }
    }
}

struct GlossaryView: View {
    @State private var query = ""
    private var terms: [GlossaryTerm] {
        query.isEmpty ? AppContent.glossary : AppContent.glossary.filter { $0.term.localizedCaseInsensitiveContains(query) || $0.definition.localizedCaseInsensitiveContains(query) }
    }
    var body: some View {
        List {
            ForEach(terms) { t in
                DisclosureGroup {
                    Text(t.definition).font(.subheadline).foregroundStyle(Color.ink)
                } label: {
                    Text(t.term).font(.system(.headline, design: .serif))
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color.parchment.ignoresSafeArea())
        .navigationTitle("Glossary")
        .searchable(text: $query, prompt: "Search terms")
    }
}

struct QuizView: View {
    @State private var picks: [Int: Int] = [:]
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("A light check: no grading, no winner declared.")
                    .font(.subheadline).foregroundStyle(Color.inkSoft)
                ForEach(Array(AppContent.quiz.enumerated()), id: \.element.id) { qi, item in
                    Card {
                        Text(item.question).font(.headline)
                        ForEach(Array(item.options.enumerated()), id: \.offset) { oi, opt in
                            let chosen = picks[qi]
                            Button { picks[qi] = oi } label: {
                                HStack {
                                    Image(systemName: icon(chosen: chosen, option: oi, correct: item.correct))
                                        .foregroundStyle(color(chosen: chosen, option: oi, correct: item.correct))
                                    Text(opt).font(.subheadline).foregroundStyle(Color.ink)
                                    Spacer()
                                }
                            }.buttonStyle(.plain)
                        }
                        if let chosen = picks[qi] {
                            Text(chosen == item.correct ? "✓ \(item.explanation)" : "Not quite. \(item.explanation)")
                                .font(.caption)
                                .foregroundStyle(chosen == item.correct ? Color.response : Color.hinge)
                                .padding(.top, 4)
                        }
                    }
                }
                if score.answered == AppContent.quiz.count {
                    Text("\(score.right) of \(AppContent.quiz.count), nicely done. Remember: the argument itself is left for you to weigh.")
                        .font(.subheadline.weight(.medium)).foregroundStyle(Color.slate)
                }
            }
            .padding(20)
        }
        .background(Color.parchment.ignoresSafeArea())
        .navigationTitle("Understanding")
        .navigationBarTitleDisplayMode(.inline)
    }
    private var score: (answered: Int, right: Int) {
        let right = picks.filter { AppContent.quiz[$0.key].correct == $0.value }.count
        return (picks.count, right)
    }
    private func icon(chosen: Int?, option: Int, correct: Int) -> String {
        guard let chosen else { return "circle" }
        if option == correct { return "checkmark.circle.fill" }
        if option == chosen { return "xmark.circle.fill" }
        return "circle"
    }
    private func color(chosen: Int?, option: Int, correct: Int) -> Color {
        guard let chosen else { return .inkSoft }
        if option == correct { return .response }
        if option == chosen { return .hinge }
        return .inkSoft
    }
}

struct AboutView: View {
    var body: some View {
        List {
            Section("What this is") {
                Text("A reference explainer for a contested apologetic argument, not a verdict. Every argument is paired with its strongest response; both traditions are steelmanned.")
                    .font(.subheadline)
            }
            Section("Argument advanced by") {
                Text("David Wood / Acts 17 Apologetics, Sam Shamoun (Answering Islam), Jay Smith (Speakers' Corner), Matt Slick (CARM).").font(.subheadline)
            }
            Section("Responded to by") {
                Text("Classical: Ibn Hazm, al-Tabari, al-Razi, al-Ghazali, Ibn Taymiyya. Contemporary: Shabir Ally, Yasir Qadhi, Ali Ataie, Mohammed Hijab.").font(.subheadline)
            }
            Section("On the sources") {
                Text("Quran refs use Hafs / Cairo (1924) numbering; English is paraphrase-level (check Sahih International, Yusuf Ali, Pickthall). Bible manuscript facts from Metzger/Ehrman, Tov, Parker; Quranic-milieu scholarship from Reynolds, Griffith, Neuwirth, Sinai.").font(.subheadline)
            }
            Section("Read the verses yourself") {
                Text("Tap any reference to open it in full. The Quran opens on Quran.com (standard Uthmani/Hafs Arabic with your choice of translation); the Bible opens on BibleGateway (ecumenical NRSVUE plus 200+ translations and the original Greek/Hebrew). Both are mainstream and impose no sect-specific rendering: you read the text and pick the translation.").font(.subheadline)
            }
            Section("Known limits") {
                Text("Manuscript dates are paleographic / radiocarbon estimates; P52's tight ~125 CE date is contested (Nongbri). ‘7th-c. Bible = today's Bible’ means no wholesale rewrite, not identity in every detail.").font(.subheadline)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color.parchment.ignoresSafeArea())
        .navigationTitle("About & Sources")
        .navigationBarTitleDisplayMode(.inline)
    }
}
