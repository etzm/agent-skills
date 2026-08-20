#!/usr/bin/env bash
# Deploy repo skills to the ptah box (Hermes agent) over Tailscale SSH.
# Copies ONLY repo-owned files (SKILL.md). Never touches box-local files:
# profile.md, state/, references/ (triage logs).
# Plain lists, no bash-4 features: macOS ships bash 3.2.
set -euo pipefail

HOST="ptah@ptah"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# "repo-skill-name:target-dir-on-box" (Hermes categorizes skills)
MAPPINGS="
news-digest:research/news-digest
"

for mapping in $MAPPINGS; do
  skill="${mapping%%:*}"
  target="${mapping#*:}"
  src="$REPO_ROOT/skills/$skill"
  dst=".hermes/skills/$target"
  [ -f "$src/SKILL.md" ] || { echo "skip $skill: no SKILL.md"; continue; }
  ssh "$HOST" "mkdir -p $dst"
  scp -q "$src/SKILL.md" "$HOST:$dst/SKILL.md"
  echo "deployed $skill -> $HOST:$dst"
done

echo "done. Box-local files (profile.md, state/, references/) untouched."
