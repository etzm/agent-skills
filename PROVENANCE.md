# Provenance

Every borrowed mechanism in this repo is credited here. Ideas are not copyrightable,
but honesty is the point of this file: this collection exists because other people
published their work, and the refinement history only means something if its inputs
are visible.

Rule for contributions: adapt mechanisms freely, never copy prose from incompatibly
licensed sources. Where a source is noncommercial-licensed, only the concept was
taken and the text here was written from scratch.

## news-digest

- **Novelty gating via a sent-headlines state file, and delta-first headlines for
  continuing stories** — adapted from
  [SeanLF/claude-rss-news-digest](https://github.com/SeanLF/claude-rss-news-digest)
  (`select.md`, `write.md`). That repo is PolyForm Noncommercial; concepts only,
  wording is original.
- **Coherence self-check before delivery** (no world-state from model memory, no
  fabricated causal links, no attribution upgrades, headline entity binding) —
  adapted from the same repo's `coherence.md` adversarial fact-check pass, reduced
  from a multi-agent pipeline to a single self-check suitable for a SKILL.md.
- **Anti-overstatement checklist** — adapted from the same repo's WRITE-stage rules.
- **"What was cut" transparency footer** — adapted from the same repo's
  `not_covered_blurb`.
- **Fail-closed materiality gate ("silence over noise")** — adapted from the
  `market-morning-brief` skill in
  [LeoYeAI/openclaw-master-skills](https://github.com/LeoYeAI/openclaw-master-skills).
- **Cross-day continuity via previous-digest state** — concept also present in
  [iliane5/meridian](https://github.com/iliane5/meridian), which does it with an
  embedding/clustering pipeline; this skill uses the lightweight prompt-side variant.
- **Source-quality tiers, noise filters (rotation damper, curated-journal conflicts,
  accidents rule), serendipity slot, reading-time budget mechanics** — original to
  this repo, developed against triage feedback (see `lab/news-digest/`).

## Surveyed but not (yet) adopted

- HN comment mining (top substantive / dissenting-with-traction / practitioner
  comment per story) —
  [BankrBot/skills, aeon-hacker-news-digest](https://github.com/BankrBot/skills).
- Per-source 7-day health tracking and unified multi-source config —
  [draco-agent tech-news-digest via LeoYeAI/openclaw-master-skills](https://github.com/LeoYeAI/openclaw-master-skills).
- Karpathy's curated 92-feed list (via the HN Popularity Contest dataset) — packaged
  in [HarrisHan/ai-daily-digest](https://github.com/HarrisHan/ai-daily-digest).
- Preference-elicitation interview that generates the briefing prompt —
  [mohitagw15856/pm-claude-skills, morning-intelligence](https://github.com/mohitagw15856/pm-claude-skills).
- Verified-empty cache contract (a missing cache must report "couldn't read", never
  render as "all clear") —
  [sonichi/sutando, morning-briefing](https://github.com/sonichi/sutando).
