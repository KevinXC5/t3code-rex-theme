#!/usr/bin/env bash
set -euo pipefail

THEME_ID="rex"
RAW_URL="https://raw.githubusercontent.com/KevinXC5/t3code-rex-theme/main/${THEME_ID}.json"
T3_USERDATA_DIR="${T3_USERDATA_DIR:-${HOME}/.t3/userdata}"
THEMES_DIR="${T3_USERDATA_DIR}/themes"
TARGET_FILE="${THEMES_DIR}/${THEME_ID}.json"
SETTINGS_FILE="${T3_USERDATA_DIR}/settings.json"
ACTIVATE=0

for arg in "$@"; do
  case "$arg" in
    --activate|--apply)
      ACTIVATE=1
      ;;
    -h|--help)
      cat <<'EOF'
Usage: install.sh [--activate]

Install the Rex theme for T3 Code into ~/.t3/userdata/themes/rex.json.

Options:
  --activate, --apply   Also set defaultTheme="rex" in ~/.t3/userdata/settings.json
  -h, --help            Show this help message
EOF
      exit 0
      ;;
    *)
      echo "Unknown option: $arg" >&2
      exit 1
      ;;
  esac
done

mkdir -p "$THEMES_DIR"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
LOCAL_THEME="${SCRIPT_DIR}/${THEME_ID}.json"

if [[ -n "$SCRIPT_DIR" && -f "$LOCAL_THEME" ]]; then
  cp "$LOCAL_THEME" "$TARGET_FILE"
  echo "Installed from local file -> $TARGET_FILE"
else
  TMP_FILE="$(mktemp)"
  trap 'rm -f "$TMP_FILE"' EXIT
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$RAW_URL" -o "$TMP_FILE"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$TMP_FILE" "$RAW_URL"
  else
    echo "Error: curl or wget is required to download ${THEME_ID}.json." >&2
    exit 1
  fi
  mv "$TMP_FILE" "$TARGET_FILE"
  echo "Downloaded and installed -> $TARGET_FILE"
fi

if command -v python3 >/dev/null 2>&1; then
  python3 - "$TARGET_FILE" <<'PY'
import json, sys
from pathlib import Path
data = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
assert data.get("name") == "Rex" and isinstance(data.get("css"), str)
PY
fi

if [[ "$ACTIVATE" -eq 1 ]]; then
  if command -v python3 >/dev/null 2>&1; then
    python3 - "$SETTINGS_FILE" "$THEME_ID" <<'PY'
import json, shutil, sys
from datetime import datetime, timezone
from pathlib import Path

settings_path = Path(sys.argv[1])
theme_id = sys.argv[2]
settings = {}
if settings_path.exists():
    shutil.copy2(settings_path, settings_path.with_suffix(".json.bak-theme"))
    settings = json.loads(settings_path.read_text(encoding="utf-8"))
settings["defaultTheme"] = theme_id
settings["defaultThemeSetAt"] = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%S.000Z")
settings_path.write_text(json.dumps(settings, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print(f"Activated defaultTheme={theme_id} in {settings_path}")
PY
  else
    echo "Notice: python3 not found; please select 'Rex' manually in T3 Code -> Settings -> Appearance."
  fi
else
  echo "Done! Open T3 Code -> Settings -> Appearance and select 'Rex' (or re-run with --activate)."
fi
