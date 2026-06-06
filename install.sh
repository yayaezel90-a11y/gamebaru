#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

APP_NAME="Android Master Toolkit"
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PREFIX_DIR="${PREFIX:-/data/data/com.termux/files/usr}"
BIN_DIR="$PREFIX_DIR/bin"

info(){ printf '\033[1;36m[INFO]\033[0m %s\n' "$*"; }
warn(){ printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }
fail(){ printf '\033[1;31m[FAIL]\033[0m %s\n' "$*"; exit 1; }

info "Installing $APP_NAME dependencies..."
if command -v pkg >/dev/null 2>&1; then
  pkg update -y
  pkg upgrade -y
  pkg install -y git curl wget python nodejs jq zip unzip ffmpeg imagemagick coreutils findutils openssl termux-api dnsutils procps util-linux zbar
else
  warn "pkg not found. Install dependencies manually: git curl wget python nodejs jq zip unzip ffmpeg imagemagick openssl dnsutils zbar"
fi

if command -v python >/dev/null 2>&1; then
  info "Installing Python helper packages..."
  python -m pip install --upgrade pip >/dev/null 2>&1 || true
  python -m pip install --upgrade qrcode[pil] pillow pypdf requests yt-dlp >/dev/null 2>&1 || warn "Some Python packages failed to install; related features will show guidance."
fi

mkdir -p "$APP_DIR"/{modules,config,backups,logs,assets,tmp}
chmod +x "$APP_DIR"/*.sh "$APP_DIR"/modules/*.sh 2>/dev/null || true

mkdir -p "$BIN_DIR"
cat > "$BIN_DIR/toolkit" <<WRAP
#!/data/data/com.termux/files/usr/bin/bash
cd "$APP_DIR" && bash "$APP_DIR/toolkit.sh" "\$@"
WRAP
chmod +x "$BIN_DIR/toolkit"

info "Installation complete. Run: toolkit"
