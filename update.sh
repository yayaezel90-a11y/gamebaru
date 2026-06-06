#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$APP_DIR"
printf '\033[1;36mUpdating Android Master Toolkit...\033[0m\n'
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git pull --ff-only
  bash install.sh
else
  printf 'This directory is not a Git repository. Download the latest release manually.\n' >&2
  exit 1
fi
