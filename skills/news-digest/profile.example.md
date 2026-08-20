# News digest profile — EXAMPLE

Copy this file to `profile.md` next to SKILL.md on your agent, and fill it in.
`profile.md` is personal and must never be committed to a public repo (this repo's
.gitignore refuses it by name). The skill will not run without a profile.

## Tier A — the reader's beat

The topics you actively work on and want depth over breadth for. Be specific; these
drive search queries. Examples:

- Open-source hardware for field biology; low-cost lab instrumentation
- EU research funding policy, especially Horizon successor programs
- Battery chemistry beyond lithium-ion

## Tier B — general interests and regions

- Major international politics and security — breakout shifts only (the skill's noise
  filters apply on top of whatever is listed here)
- Economy and markets: one item at most, only if consequential
- Regions with practical everyday relevance, with a note on why, e.g.:
  - "Portugal national news (resident, Lisbon)"
  - "Bavaria regional news (family)"

The skill adds a serendipity slot (striking science outside Tier A) on its own; you do
not need to list it.

## Beat feeds

RSS/Atom feeds specific to your beat, tried before the skill's general core, e.g.:

- https://retractionwatch.com/feed/
- http://export.arxiv.org/rss/q-bio

## Defaults and delivery

- language: en            # or de, fr, ...
- ratio: 60/40            # beat vs general
- channel: Telegram       # plain-text constraints assumed regardless
- tts_provider: edge
- tts_voices: en-US-GuyNeural (en), de-DE-ConradNeural (de)

## Muted topics

Standing `-topic` exclusions, e.g.:

- celebrity news
- sports
