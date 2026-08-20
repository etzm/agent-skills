# agent-skills

Curated, provenance-visible skills for personal AI agents. Written for
[Hermes Agent](https://github.com/NousResearch/hermes-agent) (SKILL.md format, also
readable by Claude Code and OpenClaw-style agents), refined continuously against real
daily use on an always-on personal agent.

This is a working collection, not a dump: each skill earns its place, every borrowed
mechanism is credited in [PROVENANCE.md](PROVENANCE.md), and the reasoning behind
changes is recorded in [lab/](lab/) as dated notes. The refinement history is the
product as much as the skills are.

## Design principles

1. **Skill/profile split.** Skills are generic machinery; the person lives in a
   private `profile.md` next to the skill on the agent (never in this repo — see
   `.gitignore`). Fork the skill, write your profile, done.
2. **Budget first.** Attention is the scarce resource. Skills enforce hard output
   caps and fail closed: a thin day produces silence, not filler.
3. **Noise is the enemy.** Source-quality tiers, heavy-rotation damping, and
   novelty state files exist so the agent never mimics a headline ticker.
4. **Serendipity is a feature.** A digest that only confirms known interests is a
   curation failure; skills reserve room for the genuinely surprising.
5. **Provenance fully visible.** Adapted mechanisms are credited; lab notes explain
   why every rule exists.

## Skills

| Skill | What it does |
|---|---|
| [news-digest](skills/news-digest/SKILL.md) | Profile-driven news digest with reading-time budget, source tiers, rotation damping, novelty state, coherence self-check, and a serendipity slot. |

## Using a skill

1. Copy the skill directory into your agent's skills tree.
2. Copy `profile.example.md` to `profile.md` beside it and fill it in.
3. Keep `profile.md` and `state/` out of any public repo.

## Licensing

Dual-licensed:

- **Skill texts and documentation** (all `.md` files): [CC-BY-4.0](LICENSE-CC-BY-4.0)
  — reuse freely, attribution required.
- **Code** (scripts under `deploy/` and inside skills): [MIT](LICENSE-MIT).

Provenance obligations flow the other way too: this repo adapts concepts from
noncommercially licensed projects without copying their text; see
[PROVENANCE.md](PROVENANCE.md) for the ledger.
