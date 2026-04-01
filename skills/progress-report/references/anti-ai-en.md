# English De-AI Rules

Reference: [Humanizer](https://github.com/blader/humanizer)

## Core principle

LLMs gravitate toward statistically likely phrasing that sounds plausible to the widest audience. The result: inflated vocabulary, mechanical structure, and a "polished" tone that no human actually writes in for a casual progress update. De-AI means rewriting — not just swapping synonyms.

## Five categories (29 patterns)

### Content patterns (6)

1. **Significance inflation** — "pivotal moment", "groundbreaking", "transformative"
   - Just say what happened
2. **Notability name-dropping** — vague mentions of prestigious sources without context
   - Either cite specifically or don't mention
3. **Superficial -ing analyses** — "symbolizing", "reflecting", "showcasing" without substance
   - Expand with evidence or remove
4. **Promotional language** — "breathtaking", "remarkable", "cutting-edge"
   - Use neutral descriptions
5. **Vague attributions** — "experts believe", "studies show" (no specific source)
   - Name the paper or say "I think"
6. **Formulaic challenges** — "despite challenges, continues to thrive"
   - Say what the actual problem is

### Language patterns (7)

7. **AI vocabulary** — high-frequency LLM words:
   - additionally, furthermore, moreover, notably, importantly
   - leverage, utilize, facilitate, implement, showcase
   - landscape, paradigm, robust, comprehensive, innovative
   - delve, explore, navigate, underscore, foster
   - Replace with plain English: also, use, help, do, show
8. **Copula avoidance** — "serves as", "features", "boasts" instead of "is", "has"
   - Use simple verbs
9. **Negative parallelism** — "it's not just X, it's Y"
   - Just state Y directly
10. **Rule of three** — forcing exactly three items everywhere
    - Use the natural number of items
11. **Synonym cycling** — "method" → "approach" → "strategy" → "technique" in one paragraph
    - Just repeat the clearest word
12. **False ranges** — "from X to Y" spanning unrelated topics
    - List items directly
13. **Passive voice / subjectless fragments** — hiding the actor
    - Name who did what when it helps

### Style patterns (9)

14. **Em dash overuse** — multiple dashes in one sentence
15. **Boldface overuse** — everything is **bold**
16. **Inline-header lists** — "**Label:** description"
17. **Title case headings** — "Strategic Negotiations And Partnerships"
    - Use sentence case in progress reports
18. **Emojis** — decorative emoji in formal contexts
19. **Curly quotes** — smart quotes in technical writing
20. **Hyphenated pairs** — "cross-functional", "data-driven" in casual context
21. **Persuasive authority tropes** — "at its core", "what truly matters"
    - Just say the thing
22. **Signposting** — "let's dive in", "here's what you need to know"
    - Start with the content

### Communication patterns (3)

23. **Chatbot artifacts** — "I hope this helps!", "feel free to ask"
24. **Cutoff disclaimers** — "while details are limited in available sources"
25. **Sycophantic tone** — "great question!", "absolutely!"

### Filler & hedging (4)

26. **Filler phrases** — "in order to" → "to", "due to the fact that" → "because"
27. **Excessive hedging** — "could potentially possibly" → "may"
28. **Generic conclusions** — "the future looks bright" → specific next steps
29. **Fragmented headers** — header + one-sentence explanation that just restates the header

## Progress report specifics

- **not a paper**: progress updates are casual — contractions, incomplete sentences, informal tone are all fine
- **keep jargon**: technical terms stay, remove only decorative language
- **imperfect is human**: real humans leave typos, use run-on sentences, skip transitions
- **punctuation is loose**: not every comma needs to be perfect, people skip periods in chat
- **lowercase is ok**: especially in chat and slides, not everything needs to be capitalized
