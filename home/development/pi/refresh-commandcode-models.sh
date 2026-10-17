#!/usr/bin/env bash
# Refresh commandcode-models.json, the snapshot of CommandCode's model list that
# home/pi/default.nix turns into pi's models.json.
#
# GET /provider/v1/models needs no credentials, so this is just a fetch. Run it
# whenever models are added upstream or a context window changes, then commit the
# result and `home-manager switch`.
#
# Only the fetch is impure; the actual build stays hermetic and offline because
# default.nix reads the committed snapshot instead of the network.
set -euo pipefail

url="https://api.commandcode.ai/provider/v1/models"
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
out="$dir/commandcode-models.json"

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

curl -fsS --max-time 30 "$url" > "$tmp"

# Sort by id so a refresh produces a minimal, reviewable diff.
python3 - "$tmp" "$out" <<'PY'
import json, sys
src, dst = sys.argv[1], sys.argv[2]
doc = json.load(open(src))
doc["data"].sort(key=lambda model: model["id"])
with open(dst, "w") as handle:
    json.dump(doc, handle, indent=2)
    handle.write("\n")
print(f"{len(doc['data'])} models")
PY

echo "wrote $out"
