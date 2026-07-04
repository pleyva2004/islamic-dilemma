import SwiftUI

struct WalkthroughView: View {
    let onFinish: () -> Void
    @State private var step = 0
    private let total = 4

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TabView(selection: $step) {
                    WelcomePage(onSkip: onFinish).tag(0)
                    PremisesPage().tag(1)
                    ForkPage().tag(2)
                    ResponsesPage().tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: step)

                bottomBar
            }
            .background(Color.parchment.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Skip to Explorer", action: onFinish)
                        .font(.footnote)
                }
            }
        }
    }

    private var bottomBar: some View {
        VStack(spacing: 10) {
            // Slim progress
            HStack(spacing: 6) {
                ForEach(0..<total, id: \.self) { i in
                    Capsule()
                        .fill(i <= step ? Color.slate : Color.slate.opacity(0.2))
                        .frame(height: 4)
                }
            }
            HStack {
                Text("Step \(step + 1) of \(total)")
                    .font(.caption).foregroundStyle(Color.inkSoft)
                Spacer()
                if step > 0 {
                    Button("Back") { withAnimation { step -= 1 } }
                        .buttonStyle(.bordered)
                }
                Button(step == total - 1 ? "Explore freely" : "Continue") {
                    if step == total - 1 { onFinish() } else { withAnimation { step += 1 } }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(.horizontal, 20).padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }
}

// MARK: - Page 1
private struct WelcomePage: View {
    let onSkip: () -> Void
    @State private var showBalance = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Image(systemName: "book.closed")
                        .font(.system(size: 40)).foregroundStyle(Color.slate)
                    Text("The Islamic Dilemma").font(.serifTitle(34))
                    Text("A step-by-step walkthrough of a well-known argument, and the responses to it.")
                        .font(.title3).foregroundStyle(Color.inkSoft)
                }
                Tag(text: "About 8 minutes", color: .slate)

                Card {
                    Text("How this works").font(.serifTitle(20))
                    row("1.circle", "Build the argument", "See its premises one piece at a time.")
                    row("2.circle", "Hear the responses", "Muslim scholars answer, presented just as fairly.")
                    row("3.circle", "Explore freely", "The whole app opens as a reference to roam.")
                }

                Card(accent: .hinge) {
                    Text("Ground rules").font(.serifTitle(20))
                    bullet("This argument comes from debate and street apologetics, popularized by David Wood / Acts 17 Apologetics, not neutral scholarship. We pair it with the responses on equal footing.")
                    bullet("Both traditions hold these texts sacred; we quote with care.")
                    bullet("Quran quotations are paraphrase-level and use Hafs / Cairo (1924) verse numbering.")
                    bullet("Nothing here decides the question for you. The judgment is yours.")
                }

                Button { showBalance = true } label: {
                    Label("Reading this fairly", systemImage: "scalemass").font(.footnote)
                }
            }
            .padding(20)
        }
        .sheet(isPresented: $showBalance) { BalanceSheet() }
    }
    private func row(_ icon: String, _ title: String, _ sub: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon).foregroundStyle(Color.slate).font(.title3)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline)
                Text(sub).font(.subheadline).foregroundStyle(Color.inkSoft)
            }
        }
    }
    private func bullet(_ t: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•").foregroundStyle(Color.hinge)
            Text(t).font(.subheadline).foregroundStyle(Color.ink)
        }
    }
}

// MARK: - Page 2
private struct PremisesPage: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("The question in one sentence").font(.serifTitle(26))
                Card {
                    Text(AppContent.oneSentence)
                        .font(.system(.body, design: .serif))
                }
                FlowLayout(spacing: 8) {
                    ForEach(["tahrif", "musaddiq", "Tawrat", "Injil", "Zabur"], id: \.self) { TermChip(term: $0) }
                }
                .padding(.vertical, 2)

                Text("The three premises").font(.serifTitle(22))
                ForEach(Array(AppContent.premises.enumerated()), id: \.element.id) { idx, p in
                    Card(accent: .argument) {
                        HStack {
                            Text("Premise \(p.number)").font(.caption.weight(.bold)).foregroundStyle(Color.argument)
                            Text("· \(p.title)").font(.caption).foregroundStyle(Color.inkSoft)
                            Spacer()
                            if idx == 1 { Tag(text: "~610–632 CE", color: .hinge) }
                        }
                        Text(p.body).font(.subheadline)
                        FlowRow(p.verses)
                        Text("This is the argument's view. The responses come next.")
                            .font(.caption2).italic().foregroundStyle(Color.inkSoft)
                    }
                }
            }
            .padding(20)
        }
    }
}

// MARK: - Page 3
private struct ForkPage: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("The fork").font(.serifTitle(26))
                Text("Put the three premises together and the argument forces a question with only two answers about the Bible of Muhammad's day: was it already corrupt then, or still reliable then? As bare text-state these are contradictories, so the argument treats the fork as exhaustive.")
                    .font(.subheadline).foregroundStyle(Color.inkSoft)

                Card(accent: .counter) {
                    Text("Horn A: Corrupt then").font(.serifTitle(18)).foregroundStyle(Color.counter)
                    Text("Then the Quran praised as ‘guidance and light’ (Q5:44) books that were adulterated, and commanded people to judge by a corrupted text (Q5:47). So it endorsed error.")
                        .font(.subheadline)
                }
                Card(accent: .argument) {
                    Text("Horn B: Reliable then").font(.serifTitle(18)).foregroundStyle(Color.argument)
                    Text("Then that Bible is textually essentially today's Bible; the manuscript record predates Muhammad by centuries. But today's Bible teaches what Islam denies: that Jesus was crucified (contrast Q4:157), is divine, and is the Son of God.")
                        .font(.subheadline)
                    Divider()
                    Text("Pre-Islamic manuscript evidence").font(.caption.weight(.semibold)).foregroundStyle(Color.inkSoft)
                    ForEach(AppContent.manuscripts) { ManuscriptLink(m: $0) }
                }

                Card {
                    Text("The close: a constructive dilemma").font(.serifTitle(18))
                    Text("Horn A means the Quran endorsed a corrupt book; Horn B means the endorsed book refutes the Quran's Jesus. Since (the argument claims) those are the only two options, either way it concludes the Quran is caught.")
                        .font(.subheadline)
                    Text("(A ∨ B), (A → problem₁), (B → problem₂) ⊢ problem₁ ∨ problem₂")
                        .font(.system(.caption, design: .monospaced)).foregroundStyle(Color.slate)
                }

                Card(accent: .hinge) {
                    Label("An honest note", systemImage: "hand.raised")
                        .font(.subheadline.weight(.semibold)).foregroundStyle(Color.hinge)
                    Text("This is the argument as its proponents see it, often used as a debate trap. We are deliberately not treating it as settled. Whether corrupt-vs-reliable is really the only choice, and what ‘corrupt’ and ‘confirm’ even mean, is exactly where the responses push back next, with equal room.")
                        .font(.subheadline)
                }
            }
            .padding(20)
        }
    }
}

// MARK: - Page 4
private struct ResponsesPage: View {
    private let responses: [(String, String)] = [
        ("Two kinds of corruption", "Tahrif al-nass = altering the written text; tahrif al-ma'ani = distorting meaning or interpretation while the words stand. The prominent classical readings (al-Tabari, al-Razi) leaned toward meaning, opening a third option the fork skips: authentic text, distorted handling. (Ibn Hazm is the famous textual-corruption exception, a minority for centuries.)"),
        ("‘Confirm’ means the message, not the manuscript", "Musaddiq (Q3:3, Q5:48) affirms the divine origin and monotheistic core of the earlier revelation, not that every 7th-century copy was textually perfect."),
        ("‘Judge by it’ can be contextual or ad hominem", "Q5:47 may address Christians by their own accepted standard, pointing to what remained authentic (cf. Q7:157, Q61:6), not a timeless warranty on the whole canon."),
        ("The Injil is not the four Gospels", "The Quran's Injil is the revelation given to Jesus (Q5:46); the New Testament is four Gospels written about him plus letters."),
        ("The Quran already alleges tampering", "Q2:75, Q2:79, Q3:78, Q4:46, Q5:13 accuse custodians of distortion. So affirming the origin while accusing the custodians is one coherent position."),
        ("The Quran supersedes anyway", "Q5:48 calls it muhaymin (guardian / criterion) over prior scripture, and Q15:9 says the Quran itself is divinely protected. So Islam does not need the earlier text intact."),
    ]
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("The responses, at their strongest").font(.serifTitle(26))
                Text("Muslim scholars, classical and modern, argue the dilemma packs in hidden assumptions.")
                    .font(.subheadline).foregroundStyle(Color.inkSoft)

                ForEach(Array(responses.enumerated()), id: \.offset) { i, r in
                    Card(accent: .response) {
                        Text("\(i + 1). \(r.0)").font(.serifTitle(17)).foregroundStyle(Color.response)
                        Text(r.1).font(.subheadline)
                    }
                }

                FlowLayout(spacing: 8) {
                    ForEach(["tahrif al-nass", "tahrif al-ma'ani", "muhaymin", "naskh"], id: \.self) { TermChip(term: $0.contains("nass") ? "Tahrif al-nass" : $0.contains("ma'ani") ? "Tahrif al-ma'ani" : $0.capitalized) }
                }

                Text("Named voices: Shabir Ally, Yasir Qadhi, Ali Ataie, Mohammed Hijab (contemporary); Ibn Hazm, al-Tabari, al-Razi (classical).")
                    .font(.caption).foregroundStyle(Color.inkSoft)

                Card(accent: .slate) {
                    Text("Where it actually stands").font(.serifTitle(18))
                    Text("Historians can settle one narrow fact: the manuscript record shows **no wholesale rewrite** of the Bible after the 7th century (not ‘identical in every detail’). That lands against the strongest ‘text-was-swapped’ version of tahrif. But the rest is underdetermined. A Muslim can consistently hold the text is old and unrewritten yet was distorted, or the true Injil lost, before the 7th century, which manuscripts can neither confirm nor deny. And the fork is exhaustive only for bare text-state.")
                        .font(.subheadline)
                    Text("A serious argument with serious answers, not a knockout for either side. Neither side is declared the winner here.")
                        .font(.subheadline.weight(.medium))
                    Text("You've walked the whole path. The Explorer is now unlocked.")
                        .font(.caption).italic().foregroundStyle(Color.inkSoft)
                }
            }
            .padding(20)
        }
    }
}

// MARK: - Simple wrapping row of verse badges
struct FlowRow: View {
    let refs: [String]
    init(_ refs: [String]) { self.refs = refs }
    var body: some View {
        // ponytail: fixed 3-col grid instead of a full flow-layout; upgrade to
        // Layout-based wrapping only if labels overflow on the narrowest device.
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), alignment: .leading), count: 3), spacing: 6) {
            ForEach(refs, id: \.self) { VerseBadge(ref: $0) }
        }
    }
}
