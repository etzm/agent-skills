# 2026-08-21 — Triage capture and promotion: v2.2.0

## Why

The founding triage (2026-08-20, 12 items) was a one-off sitting that produced
v2.0.0's noise filters — and then the loop stopped. Nothing captured verdicts
after that day, so taste learning had no path from reader reaction back into the
skill. Three sources shaped the fix:

- **Saeloun's gbrain/gstack write-up** (blog.saeloun.com, 2026-04-29): memory is
  not "store more", it is "promote the right thing" — signals graduate from raw
  notes to permanent instructions only as patterns repeat.
- **gbrain issue #669** (garrytan/gbrain): a user's field report of what
  unaudited agent memory decays into — stale entries, no expiry, no owner. The
  90-day drop rule and the "staging area, not a second memory" framing answer it.
- **Survivorship-bias reasoning:** the founding triage could only judge what was
  shown. Misses — stories the reader learned elsewhere first — are the sharpest
  taste signal and had no capture path at all.

## What changed in v2.2.0

New "Triage and promotion" section:

1. Continuous capture to `state/triage.log`
   (`YYYY-MM-DD | verdict | category | item`), fed by reader reactions rather
   than triage sittings: `keep`, `noise`, `cut-wrong` (disputing the `Cut:`
   footer — the footer existed since v2.0.0 but responses were never harvested),
   `miss`, and `±topic` tunable use.
2. Categories name the selection machinery touched (`rotation`, `conflict`,
   `accident`, `tier`, `serendipity`, `beat`, `budget`) so clustering is
   countable: three same-direction verdicts in one category → proposed rule
   change.
3. Promotion protocol: propose to the reader with log lines as evidence, never
   adopt silently; adopted changes land in the source repo with a dated note
   (deployed copies are overwritten by sync — box-local edits are lost by
   design); entries unclustered after 90 days drop.
4. Each pass ends by testing one open question from the latest dated note
   against the month's evidence — the founding note's open questions now have an
   owner.

## Open questions

- Does reply-time capture actually fire? The skill triggers on digest requests;
  a bare "that was noise" reply hours later may not load it. Watch the first
  weeks; if verdicts go unlogged, the capture rule may need to live somewhere
  always-loaded (profile or agent memory).
- Is three the right promotion threshold at this reader's digest frequency?
- Carried from the founding note, still untested: rotation-damper repeat
  leakage; serendipity pool depth.
