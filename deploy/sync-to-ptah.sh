#!/usr/bin/env bash
# Deploy repo skills to the ptah box (Hermes agent) over Tailscale SSH.
# Copies ONLY repo-owned files (SKILL.md and, if present, a references/ dir from
# the repo). Never touches box-local files: profile.md, state/, triage logs.
set -euo pipefail

HOST="ptah@ptah"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# skill name in repo -> target dir on box (Hermes categorizes skills)
declare -A TARGETS=(
  ["news-digest"]="research/news-digest"
)

for skill in "${!TARGETS[@]}"; do
  src="$REPO_ROOT/skills/$skill"
  dst=".hermes/skills/${TARGETS[$skill]}"
  [ -f "$src/SKILL.md" ] || { echo "skip $skill: no SKILL.md"; continue; }
  ssh "$HOST" "mkdir -p $dst"
  scp -q "$src/SKILL.md" "$HOST:$dst/SKILL.md"
  echo "deployed $skill -> $HOST:$dst"
done

echo "done. Box-local files (profile.md, state/, references/) untouched."
