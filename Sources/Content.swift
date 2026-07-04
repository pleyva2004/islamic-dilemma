import SwiftUI

// MARK: - Models

enum VerseCluster: String, CaseIterable, Identifiable {
    case affirmation  = "Affirmation"
    case unchangeable = "Unchangeable Word"
    case tahrif       = "Tahrif / Distortion"
    case contested    = "The Contested Claim"
    var id: String { rawValue }
    var color: Color {
        switch self {
        case .affirmation:  return .argument
        case .unchangeable: return .slate
        case .tahrif:       return .response
        case .contested:    return .hinge
        }
    }
}

struct Verse: Identifiable {
    var id: String { ref }
    let ref: String              // "Q5:47"
    let cluster: VerseCluster
    let paraphrase: String
    let role: String             // e.g. "Premise 2 · central text"
    let keyTerm: String?         // Arabic term to surface
    let crossRefs: [String]      // related refs (Quran or Bible)
    let hinge: Bool              // a contested joint of the argument
    let apologist: String?       // "how it's used" — argument side
    let responder: String?       // "how it's read" — response side
}

enum CardRole: String {
    case argument = "Argument", response = "Response", counter = "Counter-reply"
    var color: Color {
        switch self {
        case .argument: return .argument
        case .response: return .response
        case .counter:  return .counter
        }
    }
}

struct DebateCard: Identifiable {
    let id = UUID()
    let role: CardRole
    let text: String
    let attribution: String
}

struct DebateTopic: Identifiable {
    let id = UUID()
    let title: String
    let cards: [DebateCard]
}

struct Premise: Identifiable {
    let id = UUID()
    let number: String
    let title: String
    let body: String
    let verses: [String]
}

struct GlossaryTerm: Identifiable {
    var id: String { term }
    let term: String
    let definition: String
}

struct QuizItem: Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
    let correct: Int
    let explanation: String
}

// MARK: - Content
// Verse refs verified against the Hafs/Cairo (1924) numbering; manuscript dates
// reflect the reviewed corrections (Vaticanus ~325–350 CE, 1QIsaa as a range,
// P52 flagged contested). English is paraphrase-level.

enum AppContent {

    static let oneSentence =
    "If the Quran (a) calls the Torah and Gospel genuine revelation, (b) tells 7th-century Jews and Christians to judge by those very scriptures, and (c) says no one can change God's words — then the Bible of Muhammad's day was either corrupt (so the Quran endorsed corrupt books) or intact (so it was textually the Bible we have today, which denies the Quran's Jesus). Either way, the argument concludes, the Quran is caught."

    static let premises: [Premise] = [
        Premise(number: "1", title: "Affirmation",
                body: "The Quran repeatedly calls the Torah (Tawrat) and Gospel (Injil) genuine revelation from the same God, and says it confirms — musaddiq — what came before it.",
                verses: ["Q5:44", "Q5:46", "Q3:3", "Q2:136", "Q4:163"]),
        Premise(number: "2", title: "Command",
                body: "In Muhammad's own time (~610–632 CE) the Quran tells Jews and Christians to judge by and uphold their own scriptures — present tense, not merely a claim about the past.",
                verses: ["Q5:47", "Q5:43", "Q5:68", "Q10:94"]),
        Premise(number: "3", title: "Preservation",
                body: "God's words cannot be altered. The argument applies this to the earlier revelation too: if God's word is unchangeable, the Torah and Gospel could not have been lost before Muhammad.",
                verses: ["Q6:115", "Q10:64", "Q18:27"]),
    ]

    static let verses: [Verse] = [
        // Affirmation
        Verse(ref: "Q3:3", cluster: .affirmation, paraphrase: "God sent down the Torah and Gospel as guidance; the Quran confirms (musaddiq) what came before it.", role: "Premise 1", keyTerm: "musaddiq", crossRefs: ["Q2:97", "Q5:48"], hinge: true,
              apologist: "‘Confirming what is before it’ treats the Torah and Gospel present in the 7th century as genuine, authoritative revelation.",
              responder: "Musaddiq confirms the divine origin and monotheistic core of the earlier revelation — not the textual integrity of any manuscript."),
        Verse(ref: "Q5:43", cluster: .affirmation, paraphrase: "Why do they seek your judgment while they have the Torah, in which is the judgment of Allah?", role: "Premise 2", keyTerm: nil, crossRefs: ["Q5:47", "Q5:68"], hinge: false, apologist: nil, responder: nil),
        Verse(ref: "Q5:44", cluster: .affirmation, paraphrase: "We sent down the Torah, in which was guidance and light; by it the prophets judged.", role: "Premise 1", keyTerm: "Tawrat", crossRefs: ["Q5:46"], hinge: false, apologist: nil, responder: nil),
        Verse(ref: "Q5:46", cluster: .affirmation, paraphrase: "We gave Jesus the Gospel, containing guidance and light, confirming the Torah before it.", role: "Premise 1", keyTerm: "Injil", crossRefs: ["Q5:47", "Q57:27"], hinge: false, apologist: nil, responder: nil),
        Verse(ref: "Q5:47", cluster: .affirmation, paraphrase: "So let the People of the Gospel judge by what Allah has revealed therein.", role: "Premise 2 · central text", keyTerm: nil, crossRefs: ["Q5:43", "Q5:68", "Q7:157", "Q61:6"], hinge: true,
              apologist: "A present-tense command in Muhammad's lifetime — you cannot be told to obey a book whose text is unreliable, so it endorses the Gospel's reliability.",
              responder: "Read as contextual / ad hominem: judge rightly by what remained authentic and it points to the coming prophet (cf. Q7:157, Q61:6) — not a standing warranty on the whole canon."),
        Verse(ref: "Q5:48", cluster: .affirmation, paraphrase: "The Quran confirms the scripture before it and is a criterion (muhaymin) over it.", role: "Premise 1 / supersession", keyTerm: "muhaymin", crossRefs: ["Q3:3", "Q15:9"], hinge: true,
              apologist: "The Quran confirms the earlier scripture — vouching for what its audience physically held.",
              responder: "Muhaymin makes the Quran guardian and criterion over prior scripture; with naskh it supersedes, so the earlier text's survival is theologically optional."),
        Verse(ref: "Q5:66", cluster: .affirmation, paraphrase: "Had they upheld the Torah and the Gospel, they would have been provided for from above and below.", role: "Premise 2", keyTerm: nil, crossRefs: ["Q5:68"], hinge: false, apologist: nil, responder: nil),
        Verse(ref: "Q5:68", cluster: .affirmation, paraphrase: "You stand on nothing until you uphold the Torah, the Gospel, and what was revealed to you from your Lord.", role: "Premise 2", keyTerm: nil, crossRefs: ["Q5:47", "Q5:66"], hinge: false, apologist: nil, responder: nil),
        Verse(ref: "Q10:94", cluster: .affirmation, paraphrase: "If you are in doubt, ask those who have been reading the Scripture before you.", role: "Premise 2", keyTerm: nil, crossRefs: ["Q5:47"], hinge: true,
              apologist: "Points the doubter to the prior Scripture and its readers as a reliable check — presupposing a trustworthy text.",
              responder: "A rhetorical assurance addressed to a hypothetical doubter; it need not certify every extant copy."),
        Verse(ref: "Q29:46", cluster: .affirmation, paraphrase: "We believe in what was revealed to us and revealed to you; our God and your God is one.", role: "Premise 1", keyTerm: nil, crossRefs: ["Q2:136"], hinge: false, apologist: nil, responder: nil),
        Verse(ref: "Q2:136", cluster: .affirmation, paraphrase: "Believe in what was revealed to Moses, Jesus, and the prophets, without distinction.", role: "Premise 1", keyTerm: nil, crossRefs: ["Q4:136"], hinge: false, apologist: nil, responder: nil),
        Verse(ref: "Q4:136", cluster: .affirmation, paraphrase: "Believe in the Book He sent down before.", role: "Premise 1", keyTerm: nil, crossRefs: ["Q2:136"], hinge: false, apologist: nil, responder: nil),
        Verse(ref: "Q4:163", cluster: .affirmation, paraphrase: "We gave David the Psalms (Zabur).", role: "Premise 1", keyTerm: "Zabur", crossRefs: ["Q17:55"], hinge: false, apologist: nil, responder: nil),
        Verse(ref: "Q17:55", cluster: .affirmation, paraphrase: "We gave David the Psalms (Zabur).", role: "Premise 1", keyTerm: "Zabur", crossRefs: ["Q4:163"], hinge: false, apologist: nil, responder: nil),
        Verse(ref: "Q2:97", cluster: .affirmation, paraphrase: "The revelation, brought down by Gabriel, confirms what came before it.", role: "Premise 1", keyTerm: "musaddiq", crossRefs: ["Q3:3"], hinge: false, apologist: nil, responder: nil),
        Verse(ref: "Q7:157", cluster: .affirmation, paraphrase: "They find the coming (unlettered) prophet described with them in the Torah and the Gospel.", role: "Premise 1 / response", keyTerm: nil, crossRefs: ["Q61:6", "Q5:47"], hinge: false, apologist: nil, responder: nil),
        Verse(ref: "Q61:6", cluster: .affirmation, paraphrase: "Jesus foretells a messenger to come after him, whose name is Ahmad.", role: "response", keyTerm: nil, crossRefs: ["Q7:157"], hinge: false, apologist: nil, responder: nil),
        // Unchangeable word
        Verse(ref: "Q6:34", cluster: .unchangeable, paraphrase: "There is no changing the words of Allah.", role: "Premise 3", keyTerm: nil, crossRefs: ["Q6:115", "Q10:64"], hinge: false, apologist: nil, responder: nil),
        Verse(ref: "Q6:115", cluster: .unchangeable, paraphrase: "The word of your Lord is fulfilled in truth and justice; none can alter His words.", role: "Premise 3", keyTerm: nil, crossRefs: ["Q10:64", "Q18:27", "Q15:9"], hinge: true,
              apologist: "If God's word cannot be altered, then the earlier revelation — also His word — could not have been textually lost before Muhammad.",
              responder: "‘God's words’ most naturally denotes His decree, promise, or the Quran itself (cf. Q15:9) — not a guarantee that Biblical copies were never changed."),
        Verse(ref: "Q10:64", cluster: .unchangeable, paraphrase: "There is no change in the words of Allah.", role: "Premise 3", keyTerm: nil, crossRefs: ["Q6:115"], hinge: false, apologist: nil, responder: nil),
        Verse(ref: "Q18:27", cluster: .unchangeable, paraphrase: "None can alter His words.", role: "Premise 3", keyTerm: nil, crossRefs: ["Q6:115"], hinge: false, apologist: nil, responder: nil),
        Verse(ref: "Q15:9", cluster: .unchangeable, paraphrase: "We sent down the Reminder, and We are its guardian.", role: "response / supersession", keyTerm: nil, crossRefs: ["Q5:48"], hinge: false, apologist: nil, responder: nil),
        // Tahrif
        Verse(ref: "Q2:75", cluster: .tahrif, paraphrase: "A group heard the word of Allah, then knowingly distorted it after understanding it.", role: "tahrif", keyTerm: "yuharrifun", crossRefs: ["Q4:46", "Q5:13"], hinge: false, apologist: nil, responder: nil),
        Verse(ref: "Q2:79", cluster: .tahrif, paraphrase: "Woe to those who write the scripture with their own hands, then say ‘this is from Allah,’ for a small gain.", role: "tahrif · strongest text-tampering verse", keyTerm: nil, crossRefs: ["Q3:78"], hinge: true,
              apologist: "The one verse most naturally read as physical tampering — but even so it names a group, not the wholesale loss of the Torah and Gospel.",
              responder: "Read alongside the other tahrif verses as concealment and false attribution — the Quran alleging distortion, which is exactly the Muslim position."),
        Verse(ref: "Q3:78", cluster: .tahrif, paraphrase: "A party twist their tongues with the Scripture so you think it is from the Book, but it is not.", role: "tahrif", keyTerm: nil, crossRefs: ["Q2:75"], hinge: false, apologist: nil, responder: nil),
        Verse(ref: "Q4:46", cluster: .tahrif, paraphrase: "Some distort words from their places (yuharrifuna al-kalim).", role: "tahrif", keyTerm: "yuharrifun", crossRefs: ["Q5:13", "Q5:41"], hinge: true,
              apologist: "Cited for corruption of the Scripture by the People of the Book.",
              responder: "Al-Tabari and al-Razi read this as distorting sense, reading, and placement — corruption of meaning (tahrif al-ma'ani), not erasing manuscripts."),
        Verse(ref: "Q5:13", cluster: .tahrif, paraphrase: "They distort words from their places and forgot a portion of what they were reminded of.", role: "tahrif", keyTerm: "yuharrifun", crossRefs: ["Q4:46", "Q5:14"], hinge: true,
              apologist: "Read as loss and alteration of the earlier scripture's content.",
              responder: "Central to the meaning-distortion defense: distortion of reading and interpretation, plus concealment (kitman)."),
        Verse(ref: "Q5:14", cluster: .tahrif, paraphrase: "The Christians too forgot a portion of what they were reminded of, so enmity was cast among them.", role: "tahrif", keyTerm: nil, crossRefs: ["Q5:13"], hinge: false, apologist: nil, responder: nil),
        Verse(ref: "Q5:41", cluster: .tahrif, paraphrase: "They distort words after their places have been set.", role: "tahrif", keyTerm: "yuharrifun", crossRefs: ["Q4:46"], hinge: false, apologist: nil, responder: nil),
        // Contested claim
        Verse(ref: "Q4:157", cluster: .contested, paraphrase: "They did not kill him nor crucify him, but it was made to appear so to them.", role: "the claim the intact Bible contradicts", keyTerm: nil, crossRefs: ["Matthew 27", "Mark 15", "Luke 23", "John 19"], hinge: true,
              apologist: "Horn B: an intact 7th-century Bible teaches the crucifixion — the Gospel accounts (Matthew 27, Mark 15, Luke 23, John 19) — directly contradicting this verse, plus Jesus's divinity and sonship.",
              responder: "The Quranic Injil is the revelation given to Jesus, not the four Gospels written about him — so the contradiction assumes the two are identical."),
    ]

    static let topics: [DebateTopic] = [
        DebateTopic(title: "Does the Quran vouch for the text, or the message?", cards: [
            DebateCard(role: .argument, text: "Musaddiq (‘confirming’) and bayna yadayhi (‘between the hands’) most naturally reference the scripture physically present in the 7th century.", attribution: "Apologists — Wood, Shamoun"),
            DebateCard(role: .response, text: "Musaddiq confirms the divine origin and monotheistic core of the earlier revelation — not the textual integrity of any manuscript.", attribution: "Responders — Ally, Ataie"),
            DebateCard(role: .counter, text: "But present-tense commands to ‘judge by’ and ‘uphold’ a book presuppose a usable, reliable text.", attribution: "Apologists"),
        ]),
        DebateTopic(title: "Corrupt vs. reliable — is that really the only choice?", cards: [
            DebateCard(role: .argument, text: "As bare text-state, corrupt / not-corrupt are contradictories, so the fork is exhaustive — there is no third option.", attribution: "Apologists"),
            DebateCard(role: .response, text: "Tahrif al-nass vs al-ma'ani opens a third state: authentic text, distorted handling. Al-Tabari (d. 923) and al-Razi (d. 1210) lean this way.", attribution: "Classical scholars"),
            DebateCard(role: .counter, text: "A meaning-only reading still concedes the text was intact. Note: the false-dichotomy charge targets the loaded horns — the bare corrupt/not-corrupt fork is validly exhaustive.", attribution: "Apologists / logic check"),
        ]),
        DebateTopic(title: "Is ‘judge by the Gospel’ (Q5:47) a warranty or an ad hominem?", cards: [
            DebateCard(role: .argument, text: "It is a present-tense divine command to judge by the Gospel — a standing endorsement of its reliability in Muhammad's day.", attribution: "Apologists"),
            DebateCard(role: .response, text: "It addresses Christians by their own accepted standard; judge rightly and it points to the coming prophet (Q7:157, Q61:6) — not a timeless warranty.", attribution: "Responders — Ataie, Ally"),
            DebateCard(role: .counter, text: "You cannot coherently be commanded to obey a book whose text is unreliable.", attribution: "Apologists"),
        ]),
        DebateTopic(title: "Do the preservation verses even refer to the Bible?", cards: [
            DebateCard(role: .argument, text: "‘None can change God's words’ (Q6:115, Q18:27) applies to all His revelation — including the Torah and Gospel He calls His word.", attribution: "Apologists"),
            DebateCard(role: .response, text: "‘God's words’ most naturally means His decree or the Quran itself (cf. Q15:9), not a guarantee about Biblical copies in human custody.", attribution: "Responders"),
            DebateCard(role: .counter, text: "But the Quran calls the earlier books God's word too, so the promise should cover them.", attribution: "Apologists"),
        ]),
        DebateTopic(title: "Is the Injil the four Gospels?", cards: [
            DebateCard(role: .argument, text: "The Quran praises the Gospel present with the Christians — i.e. the text they actually held and were told to judge by.", attribution: "Apologists"),
            DebateCard(role: .response, text: "The Quranic Injil is the singular revelation given TO Jesus (Q5:46), not four Gospels written ABOUT him plus letters — so affirming it does not affirm the canonical NT.", attribution: "Responders — Ataie, Ally"),
            DebateCard(role: .counter, text: "Even so, Q5:47 tells the People of the Gospel to judge by what they possessed.", attribution: "Apologists"),
        ]),
        DebateTopic(title: "Muhaymin + naskh — does Islam even need the Bible intact?", cards: [
            DebateCard(role: .argument, text: "The dilemma assumes the Quran's endorsement requires the prior scripture to be authentic and preserved.", attribution: "Apologists"),
            DebateCard(role: .response, text: "Q5:48 calls the Quran muhaymin — guardian and criterion over prior scripture; with naskh (abrogation) it supersedes, so their textual survival is theologically optional.", attribution: "Responders — Qadhi, Hijab"),
            DebateCard(role: .counter, text: "Then why does the Quran command people to uphold and judge by them at all?", attribution: "Apologists"),
        ]),
        DebateTopic(title: "What does the manuscript record actually settle?", cards: [
            DebateCard(role: .argument, text: "Pre-Islamic manuscripts — the Great Isaiah Scroll (1QIsaa, ~150–100 BCE), Codex Sinaiticus (~330–360 CE), Codex Vaticanus (~325–350 CE), the Syriac Peshitta, ~5,800 Greek NT manuscripts — show today's Bible is textually the 7th-century Bible.", attribution: "Historians"),
            DebateCard(role: .response, text: "They close the ‘post-7th-century forgery’ door — but leave pre-Islamic loss, or an ‘original lost Injil,’ underdetermined. Manuscripts can neither confirm nor deny that.", attribution: "Neutral summary"),
            DebateCard(role: .counter, text: "‘No wholesale rewrite’ is sound; ‘identical in every detail’ overstates it (vocalization, canon boundaries, and three known interpolations vary). And P52's tight ~125 CE date is itself contested (Nongbri: 2nd–3rd c.).", attribution: "Text critics — Metzger, Ehrman, Parker"),
        ]),
    ]

    static let glossary: [GlossaryTerm] = [
        GlossaryTerm(term: "Tahrif", definition: "Distortion / alteration. Splits into two doctrines below — which one the Quran's ‘distortion’ verses assert is the disputed hinge of the whole debate."),
        GlossaryTerm(term: "Tahrif al-nass", definition: "Corruption of the actual written text — words added, deleted, or altered. Ibn Hazm (d. 1064) was its leading classical champion, a minority view for centuries."),
        GlossaryTerm(term: "Tahrif al-ma'ani", definition: "Corruption of meaning — mistranslation, concealment, false interpretation, distorted reading — while the written words may stand. The historically prominent classical lean (al-Tabari, al-Razi)."),
        GlossaryTerm(term: "Musaddiq", definition: "‘Confirming.’ The Quran calls itself musaddiq of what came before it (Q3:3, Q5:48). Whether this confirms the message or certifies the manuscript is contested."),
        GlossaryTerm(term: "Muhaymin", definition: "‘Guardian / overseer / criterion’ (Q5:48). Renderings differ; a translation choice, not a factual dispute. Grounds the supersession response."),
        GlossaryTerm(term: "Naskh", definition: "Abrogation — later revelation superseding earlier rulings. Combined with muhaymin, the frame that the Quran stands over and supersedes prior scripture."),
        GlossaryTerm(term: "Bayna yadayhi", definition: "‘Between the hands’ — an idiom for what came before / is present. Apologists read it as the physically-present scripture; responders as the reality of prior revelation."),
        GlossaryTerm(term: "Yuharrifun", definition: "‘They distort’ — the verb in the tahrif verses (Q2:75, Q4:46, Q5:13, Q5:41). Its scope (text vs. reading/meaning) is exactly what classical scholars split over."),
        GlossaryTerm(term: "Injil", definition: "The Gospel — in the Quran, the singular revelation given to Jesus (Q5:46), which many Muslim scholars distinguish from the four canonical Gospels."),
        GlossaryTerm(term: "Tawrat", definition: "The Torah revealed to Moses, called ‘guidance and light’ (Q5:44)."),
        GlossaryTerm(term: "Zabur", definition: "The Psalms given to David (Q4:163, Q17:55)."),
        GlossaryTerm(term: "Kitman", definition: "Concealment — hiding parts of the revelation. Cited in the meaning-distortion reading of the tahrif verses."),
        GlossaryTerm(term: "Tawatur", definition: "Mass, parallel transmission across a community. Al-Razi argued the Torah's wide tawatur made wholesale textual corruption implausible."),
        GlossaryTerm(term: "Constructive dilemma", definition: "The argument's logical form: (A ∨ B), (A → problem₁), (B → problem₂) ⊢ problem₁ ∨ problem₂. Valid only if the disjunction is truly exhaustive."),
        GlossaryTerm(term: "Interpolation", definition: "The text-critical sense of ‘corruption’: bounded later scribal additions — e.g. Mark 16:9–20, John 7:53–8:11, and the Comma Johanneum (1 John 5:7–8) — to an otherwise recoverable text, not a substituted book."),
    ]

    static let quiz: [QuizItem] = [
        QuizItem(question: "What does Premise 2 (Q5:47) claim?",
                 options: ["The Quran tells 7th-century People of the Book to judge by their own scriptures", "The Bible was written after Muhammad", "Christians must convert to Islam"],
                 correct: 0, explanation: "Q5:47: ‘Let the People of the Gospel judge by what Allah has revealed therein’ — present tense, in Muhammad's day."),
        QuizItem(question: "What are the two horns of the fork?",
                 options: ["Old vs. New Testament", "Corrupt then / reliable then", "Sunni vs. Shia"],
                 correct: 1, explanation: "The argument forks on the state of the Bible in Muhammad's lifetime: already corrupt, or still reliable."),
        QuizItem(question: "Which is corruption of the written text?",
                 options: ["Tahrif al-ma'ani", "Tahrif al-nass", "Naskh"],
                 correct: 1, explanation: "Tahrif al-nass = the actual text altered. Tahrif al-ma'ani = meaning/interpretation distorted while the words stand."),
        QuizItem(question: "Which fact does the manuscript record settle?",
                 options: ["That the Bible is divinely inspired", "That there was no wholesale post-7th-century rewrite", "That the Quran is corrupted"],
                 correct: 1, explanation: "Pre-Islamic manuscripts rule out a post-7th-century forgery — but leave pre-Islamic loss and the ‘original Injil’ question underdetermined."),
        QuizItem(question: "Does this app conclude the argument definitively wins?",
                 options: ["Yes", "No — both sides are left standing for you to weigh"],
                 correct: 1, explanation: "It's a serious argument with serious answers, not a knockout for either side. The judgment is yours."),
    ]
}
