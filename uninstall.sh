#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PREFIX_DIR="${PREFIX:-/data/data/com.termux/files/usr}"
read -r -p "Remove Android Master Toolkit launcher and generated runtime files? [y/N] " ans
case "${ans:-N}" in
  y|Y|yes|YES)
    rm -f "$PREFIX_DIR/bin/toolkit"
    rm -rf "$APP_DIR/tmp"
    printf 'Uninstalled launcher. Project folder, backups, config, and logs were kept.\n'
    ;;
  *) printf 'Cancelled.\n' ;;
esac
