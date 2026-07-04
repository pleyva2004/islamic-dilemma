# The Islamic Dilemma: Source Document

This is the **root reference** for the theory and data the app presents. `Sources/Content.swift`
is the app's runtime source of truth; this document mirrors and explains it in prose so the
argument, the responses, and every verse/term can be reviewed in one place, independent of the code.

**Balance commitment.** This is a *reference explainer, not a verdict*. Every claim is attributed to
who makes it ("Apologists argue", "Responders answer", "Historians note"), every argument is
paired with its strongest response, and the app never declares a winner. Quran quotations are
**paraphrase-level** and use standard **Hafs / Cairo (1924)** verse numbering; translations differ
(Sahih International, Yusuf Ali, Pickthall), so verify wording in a chosen translation before quoting.

---

## 1. The argument in one sentence

> If the Quran (a) calls the Torah and Gospel genuine revelation, (b) tells 7th-century Jews and
> Christians to judge by those very scriptures, and (c) says no one can change God's words, then the
> Bible of Muhammad's day was either corrupt (so the Quran endorsed corrupt books) or intact (so it was
> textually the Bible we have today, which denies the Quran's Jesus). Either way, the argument
> concludes, the Quran is caught.

The argument comes from **Christian apologetics / debate** (popularized by David Wood / Acts 17
Apologetics), not from neutral scholarship. The app pairs it with the Muslim scholarly responses on
equal footing.

---

## 2. The theory: a constructive dilemma

Logical form:

```
(A ∨ B), (A → problem₁), (B → problem₂)  ⊢  problem₁ ∨ problem₂
```

Valid **only if** the disjunction `A ∨ B` is genuinely exhaustive. The bare *corrupt / not-corrupt*
fork is validly exhaustive as text-state; the false-dichotomy charge targets the *loaded* horns (see §4).

### The three premises

| # | Name | Claim | Verses |
|---|------|-------|--------|
| P1 | **Affirmation** | The Quran repeatedly calls the Torah (*Tawrat*) and Gospel (*Injil*) genuine revelation from the same God, and says it *confirms* (*musaddiq*) what came before it. | Q5:44, Q5:46, Q3:3, Q2:136, Q4:163 |
| P2 | **Command** | In Muhammad's own time (~610–632 CE) the Quran tells Jews and Christians to *judge by* and *uphold* their own scriptures. This is present tense, not merely a claim about the past. | Q5:47, Q5:43, Q5:68, Q10:94 |
| P3 | **Preservation** | God's words cannot be altered. The argument applies this to the earlier revelation too: if God's word is unchangeable, the Torah and Gospel could not have been lost before Muhammad. | Q6:115, Q10:64, Q18:27 |

### The fork

Put the three premises together and the argument forces a question with only two answers about the
Bible **of Muhammad's day**: was it already corrupt then, or still reliable then?

- **Horn A: Corrupt then.** Then the Quran praised as "guidance and light" (Q5:44) books that were
  adulterated, and commanded people to judge by a corrupted text (Q5:47). So it endorsed error.
- **Horn B: Reliable then.** Then that Bible is textually essentially today's Bible (the manuscript
  record predates Muhammad by centuries). But today's Bible teaches what Islam denies: that Jesus was
  crucified (contrast Q4:157), is divine, and is the Son of God.

**Pre-Islamic manuscript evidence** (the textual record the fork turns on):

| Manuscript | Date | Read online |
|------------|------|-------------|
| Great Isaiah Scroll (1QIsaᵃ) | ~150–100 BCE | [Digital Dead Sea Scrolls, Israel Museum](https://dss.collections.imj.org.il/isaiah) |
| Codex Vaticanus | ~325–350 CE | [Vatican Library (DigiVatLib)](https://digi.vatlib.it/view/MSS_Vat.gr.1209) |
| Codex Sinaiticus | ~330–360 CE | [Codex Sinaiticus Project](https://codexsinaiticus.org/en/) |
| Syriac Peshitta | pre-Islamic | [Dukhrana Peshitta reader](https://dukhrana.com/peshitta/) |
| ~5,800 Greek NT manuscripts | collectively | [CSNTM digitized library](https://www.csntm.org) |

In the app these are tappable in the **Inference** node of the Fork, not inside Horn B: they are the
shared, contested evidence the "corrupt then vs reliable then" fork turns on. Apologists use them to
close the "corrupt then" escape (forcing Horn B); responders answer that they rule out only a
*post*-7th-century rewrite, not pre-Islamic loss.

### The close

Horn A means the Quran endorsed a corrupt book; Horn B means the endorsed book refutes the Quran's
Jesus. Since (the argument claims) those are the only two options, either way it concludes the Quran
is caught.

### An honest note

This is the argument as its proponents see it, often used as a debate trap. The app deliberately does
**not** treat it as settled. Whether corrupt-vs-reliable is really the only choice, and what "corrupt"
and "confirm" even mean, is exactly where the responses push back (§4), with equal room.

---

## 3. Key concepts (glossary)

| Term | Meaning |
|------|---------|
| **Tahrif** | Distortion / alteration. Splits into the two doctrines below; which one the Quran's "distortion" verses assert is the disputed hinge of the whole debate. |
| **Tahrif al-nass** | Corruption of the actual **written text**: words added, deleted, or altered. Ibn Hazm (d. 1064) was its leading classical champion; a minority view for centuries. |
| **Tahrif al-ma'ani** | Corruption of **meaning**: mistranslation, concealment, false interpretation, or distorted reading, while the written words may stand. The historically prominent classical lean (al-Tabari, al-Razi). |
| **Musaddiq** | "Confirming." The Quran calls itself *musaddiq* of what came before it (Q3:3, Q5:48). Whether this confirms the *message* or certifies the *manuscript* is contested. |
| **Muhaymin** | "Guardian / overseer / criterion" (Q5:48). Grounds the supersession response. |
| **Naskh** | Abrogation: later revelation superseding earlier rulings. With *muhaymin*, the frame that the Quran stands over and supersedes prior scripture. |
| **Bayna yadayhi** | "Between the hands," an idiom for what came before or is present. Apologists read it as the physically-present scripture; responders as the reality of prior revelation. |
| **Yuharrifun** | "They distort," the verb in the tahrif verses (Q2:75, Q4:46, Q5:13, Q5:41). Its scope (text vs. reading/meaning) is exactly what classical scholars split over. |
| **Injil** | The Gospel. In the Quran, the singular revelation given **to** Jesus (Q5:46), which many Muslim scholars distinguish from the four canonical Gospels. |
| **Tawrat** | The Torah revealed to Moses, called "guidance and light" (Q5:44). |
| **Zabur** | The Psalms given to David (Q4:163, Q17:55). |
| **Kitman** | Concealment: hiding parts of the revelation. Cited in the meaning-distortion reading of the tahrif verses. |
| **Tawatur** | Mass, parallel transmission across a community. Al-Razi argued the Torah's wide *tawatur* made wholesale textual corruption implausible. |
| **Constructive dilemma** | The argument's logical form (see §2). Valid only if the disjunction is truly exhaustive. |
| **Interpolation** | The text-critical sense of "corruption": bounded later scribal additions such as Mark 16:9–20, John 7:53–8:11, or the Comma Johanneum (1 John 5:7–8), added to an otherwise recoverable text rather than a substituted book. |

---

## 4. The Muslim responses, at their strongest

Muslim scholars, classical and modern, argue the dilemma packs in hidden assumptions.

1. **Two kinds of corruption.** *Tahrif al-nass* (text) vs *tahrif al-ma'ani* (meaning) opens a third
   option the fork skips: *authentic text, distorted handling*. The prominent classical readings
   (al-Tabari, al-Razi) leaned toward meaning. (Ibn Hazm is the famous textual-corruption exception.)
2. **"Confirm" means the message, not the manuscript.** *Musaddiq* (Q3:3, Q5:48) affirms the divine
   origin and monotheistic core of the earlier revelation, not that every 7th-century copy was
   textually perfect.
3. **"Judge by it" can be contextual or *ad hominem*.** Q5:47 may address Christians by their own
   accepted standard, pointing to what remained authentic and to the coming prophet (cf. Q7:157,
   Q61:6), not a timeless warranty on the whole canon.
4. **The Injil is not the four Gospels.** The Quran's *Injil* is the revelation given to Jesus (Q5:46);
   the New Testament is four Gospels written *about* him plus letters.
5. **The Quran already alleges tampering.** Q2:75, Q2:79, Q3:78, Q4:46, Q5:13 accuse custodians of
   distortion. So affirming the origin while accusing the custodians is one coherent position.
6. **The Quran supersedes anyway.** Q5:48 calls it *muhaymin* (guardian / criterion) over prior
   scripture, and Q15:9 says the Quran itself is divinely protected. So Islam does not need the earlier
   text intact.

### Where it actually stands

Historians can settle one narrow fact: the manuscript record shows **no wholesale rewrite** of the
Bible after the 7th century (*not* "identical in every detail"). That lands against the strongest
"text-was-swapped" version of *tahrif*. But the rest is underdetermined. A Muslim can consistently
hold the text is old and unrewritten yet was distorted, or the true *Injil* lost, *before* the 7th
century, which manuscripts can neither confirm nor deny. **A serious argument with serious answers,
not a knockout for either side.**

---

## 5. Verse data

Each verse below is the app's **paraphrase** (not a translation), tagged by cluster, with the
apologist/responder reading given for the contested "hinge" verses. Verify wording against a chosen
translation. **⚑ = contested hinge** of the argument.

### Cluster: Affirmation

| Ref | Paraphrase | Role | Key term |
|-----|------------|------|----------|
| Q3:3 ⚑ | God sent down the Torah and Gospel as guidance; the Quran confirms (*musaddiq*) what came before it. | Premise 1 | musaddiq |
| Q5:43 | Why do they seek your judgment while they have the Torah, in which is the judgment of Allah? | Premise 2 | |
| Q5:44 | We sent down the Torah, in which was guidance and light; by it the prophets judged. | Premise 1 | Tawrat |
| Q5:46 | We gave Jesus the Gospel, containing guidance and light, confirming the Torah before it. | Premise 1 | Injil |
| Q5:47 ⚑ | So let the People of the Gospel judge by what Allah has revealed therein. | Premise 2 · central text | |
| Q5:48 ⚑ | The Quran confirms the scripture before it and is a criterion (*muhaymin*) over it. | Premise 1 / supersession | muhaymin |
| Q5:66 | Had they upheld the Torah and the Gospel, they would have been provided for from above and below. | Premise 2 | |
| Q5:68 | You stand on nothing until you uphold the Torah, the Gospel, and what was revealed to you. | Premise 2 | |
| Q10:94 ⚑ | If you are in doubt, ask those who have been reading the Scripture before you. | Premise 2 | |
| Q29:46 | We believe in what was revealed to us and revealed to you; our God and your God is one. | Premise 1 | |
| Q2:136 | Believe in what was revealed to Moses, Jesus, and the prophets, without distinction. | Premise 1 | |
| Q4:136 | Believe in the Book He sent down before. | Premise 1 | |
| Q4:163 | We gave David the Psalms (*Zabur*). | Premise 1 | Zabur |
| Q17:55 | We gave David the Psalms (*Zabur*). | Premise 1 | Zabur |
| Q2:97 | The revelation, brought down by Gabriel, confirms what came before it. | Premise 1 | musaddiq |
| Q7:157 | They find the coming (unlettered) prophet described with them in the Torah and the Gospel. | Premise 1 / response | |
| Q61:6 | Jesus foretells a messenger to come after him, whose name is Ahmad. | response | |

Hinge readings:
- **Q3:3.** *Apologists:* "confirming what is before it" treats the 7th-century Torah/Gospel as
  genuine, authoritative revelation. *Responders:* *musaddiq* confirms divine origin and the
  monotheistic core, not the textual integrity of any manuscript.
- **Q5:47.** *Apologists:* a present-tense command in Muhammad's lifetime; you cannot be told to obey
  a book whose text is unreliable. *Responders:* read as contextual or *ad hominem*, judging rightly by
  what remained authentic and pointing to the coming prophet (Q7:157, Q61:6), not a standing warranty.
- **Q5:48.** *Apologists:* the Quran confirms the earlier scripture, vouching for what its audience
  physically held. *Responders:* *muhaymin* makes the Quran guardian/criterion; with *naskh* it
  supersedes, so the earlier text's survival is theologically optional.
- **Q10:94.** *Apologists:* points the doubter to prior Scripture and its readers as a reliable check.
  *Responders:* a rhetorical assurance to a hypothetical doubter; need not certify every extant copy.

### Cluster: Unchangeable Word

| Ref | Paraphrase | Role |
|-----|------------|------|
| Q6:34 | There is no changing the words of Allah. | Premise 3 |
| Q6:115 ⚑ | The word of your Lord is fulfilled in truth and justice; none can alter His words. | Premise 3 |
| Q10:64 | There is no change in the words of Allah. | Premise 3 |
| Q18:27 | None can alter His words. | Premise 3 |
| Q15:9 | We sent down the Reminder, and We are its guardian. | response / supersession |

- **Q6:115.** *Apologists:* if God's word cannot be altered, the earlier revelation (also His word)
  could not have been textually lost before Muhammad. *Responders:* "God's words" most naturally means
  His decree, promise, or the Quran itself (cf. Q15:9), not a guarantee about Biblical copies.

### Cluster: Tahrif / Distortion

| Ref | Paraphrase | Role | Key term |
|-----|------------|------|----------|
| Q2:75 | A group heard the word of Allah, then knowingly distorted it after understanding it. | tahrif | yuharrifun |
| Q2:79 ⚑ | Woe to those who write the scripture with their own hands, then say "this is from Allah," for a small gain. | tahrif · strongest text-tampering verse | |
| Q3:78 | A party twist their tongues with the Scripture so you think it is from the Book, but it is not. | tahrif | |
| Q4:46 ⚑ | Some distort words from their places (*yuharrifuna al-kalim*). | tahrif | yuharrifun |
| Q5:13 ⚑ | They distort words from their places and forgot a portion of what they were reminded of. | tahrif | yuharrifun |
| Q5:14 | The Christians too forgot a portion of what they were reminded of, so enmity was cast among them. | tahrif | |
| Q5:41 | They distort words after their places have been set. | tahrif | yuharrifun |

- **Q2:79.** *Apologists:* the one verse most naturally read as physical tampering, but even so it
  names a group, not the wholesale loss of the Torah and Gospel. *Responders:* read alongside the other
  tahrif verses as concealment and false attribution, the Quran itself alleging distortion, which is
  the Muslim position.
- **Q4:46.** *Apologists:* cited for corruption of the Scripture by the People of the Book.
  *Responders:* al-Tabari and al-Razi read this as distorting sense, reading, and placement: corruption
  of meaning (*tahrif al-ma'ani*), not erasing manuscripts.
- **Q5:13.** *Apologists:* loss and alteration of the earlier scripture's content. *Responders:*
  central to the meaning-distortion defense: distortion of reading and interpretation, plus
  concealment (*kitman*).

### Cluster: The Contested Claim

| Ref | Paraphrase | Cross-references |
|-----|------------|------------------|
| Q4:157 ⚑ | They did not kill him nor crucify him, but it was made to appear so to them. | Matthew 27, Mark 15, Luke 23, John 19 |

- **Q4:157.** *Apologists (Horn B):* an intact 7th-century Bible teaches the crucifixion (the Gospel
  passion narratives), directly contradicting this verse, plus Jesus's divinity and sonship.
  *Responders:* the Quranic *Injil* is the revelation given to Jesus, not the four Gospels written
  about him, so the contradiction assumes the two are identical.

---

## 6. Read the verses yourself

Every reference in the app is tappable and opens in an in-app browser. Sources were chosen to be
reputable **and sect-neutral**, each with an independent failover:

| | Primary | Fallback |
|--|---------|----------|
| **Quran** (`Q5:47`) | [Quran.com](https://quran.com/5/47) (Uthmani/Hafs Arabic, user-selectable translation) | [Al-Quran Cloud](https://alquran.cloud/ayah/5:47) (Tanzil-sourced) |
| **Bible** (`Matthew 27`) | [BibleGateway](https://www.biblegateway.com/passage/?search=Matthew%2027&version=NRSVUE) (ecumenical NRSVUE, 200+ versions plus Greek/Hebrew) | [BibleHub](https://biblehub.com/matthew/27.htm) (Greek/Hebrew interlinear) |

Deliberately avoided: the Saudi-state readers (King Fahd Complex, QuranEnc) for a Salafi editorial
lean, and fragment-routed SPAs (Tanzil, STEP Bible) for fragile deep links.

---

## 7. Sources & scholarship

- **Argument advanced by:** David Wood / Acts 17 Apologetics, Sam Shamoun (Answering Islam), Jay Smith
  (Speakers' Corner), Matt Slick (CARM).
- **Responded to by:** *Classical:* Ibn Hazm, al-Tabari, al-Razi, al-Ghazali, Ibn Taymiyya.
  *Contemporary:* Shabir Ally, Yasir Qadhi, Ali Ataie, Mohammed Hijab.
- **Bible manuscript scholarship:** Metzger / Ehrman, Tov, Parker.
- **Quranic-milieu scholarship:** Reynolds, Griffith, Neuwirth, Sinai.

### Known limits

- Quran refs use **Hafs / Cairo (1924)** numbering; English is paraphrase-level.
- Manuscript dates are paleographic / radiocarbon estimates; P52's tight ~125 CE date is contested
  (Nongbri: 2nd–3rd c.).
- "7th-c. Bible = today's Bible" means **no wholesale rewrite**, not identity in every detail.
  Vocalization, canon boundaries, and known interpolations (e.g. Mark 16:9–20, John 7:53–8:11, the
  Comma Johanneum) vary.

---

## 8. Voices from the debates (pipeline-enriched)

> **Auto-enriched.** The entries below are extracted from parsed debate and lecture transcripts by
> the pipeline in [`../scripts/`](../scripts/); see [`log.md`](log.md) for the provenance of each
> (source video, date, what was added). Everything here is **attributed to a named speaker and
> source — inclusion is not endorsement.** The balance rule still holds: apologist and responder
> voices are added on equal footing, and nothing here declares a winner. This section is the
> **staging area**; vetted material is promoted up into §2–§5 (and then `Sources/Content.swift`)
> during human review.

_No sources parsed yet — run the pipeline to populate this section._

---

*This document is the human-readable mirror of `Sources/Content.swift`. When the app's content
changes, update both.*
