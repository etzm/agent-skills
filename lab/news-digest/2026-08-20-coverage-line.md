# 2026-08-20 — v2.1.0: coverage line

## Input

The reader received a digest from a peer agent — a minutes-style summary of a
group conversation — and rated its format highly. Its structure: an explicit
coverage window with timezone, then typed plain-text sections (summary /
decisions and working rules / action items with named owners / links), signed
by the agent.

## What was adopted into this skill

Only the coverage line. Chat and html modes now state
`Coverage: {window start} to {window end} ({IANA timezone})` under the header.
Rationale: a digest series is only auditable if each edition declares the exact
span it gathered against — otherwise stories can silently fall between two
editions (or be double-covered) and the reader cannot tell. Audio mode strips
the line (and links) before TTS.

## What was deliberately NOT adopted

- **Decisions / action-item sections**: those are conversation-digest genre,
  not news-digest genre. News has no owners and no working rules. They belong
  in the private morning-brief wrapper that invokes this skill (where mail,
  calendar, and inbound agent digests live) and in a possible future
  `chat-digest` skill using that skeleton fused with this skill's discipline
  (word budget, materiality gate, cut footer, no-fabrication rules).
- **Unbudgeted length**: the peer format has no reading-time cap and its
  summary/decisions sections partially overlap. The budget stays the hard
  constraint here.

## Origin note on the peer format

Surveyed for provenance: it matches no published template (checked the
Hermes automation blueprints, the community skill directory, and popular
agent-brain repos). It is standard board-meeting-minutes structure adapted to
plain-text email — a shape models converge on when asked to digest a group
discussion — so there is nothing further to credit.
