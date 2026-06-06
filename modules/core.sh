#!/data/data/com.termux/files/usr/bin/bash
: "${APP_DIR:=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
CONFIG_DIR="$APP_DIR/config"; LOG_DIR="$APP_DIR/logs"; BACKUP_DIR="$APP_DIR/backups"; TMP_DIR="$APP_DIR/tmp"
SETTINGS_FILE="$CONFIG_DIR/settings.conf"; STATS_FILE="$CONFIG_DIR/stats.tsv"; LOG_FILE="$LOG_DIR/toolkit.log"
mkdir -p "$CONFIG_DIR" "$LOG_DIR" "$BACKUP_DIR" "$TMP_DIR" "$APP_DIR/assets"
[[ -f "$SETTINGS_FILE" ]] || cat > "$SETTINGS_FILE" <<SETTINGS
CURRENCY_BASE=USD
CURRENCY_TARGET=IDR
WEATHER_CITY=Jakarta
DOWNLOAD_DIR=$HOME/storage/downloads
BACKUP_DIR=$BACKUP_DIR
EDITOR=nano
SETTINGS
# shellcheck disable=SC1090
source "$SETTINGS_FILE" 2>/dev/null || true
RED=$'\033[0;31m'; GREEN=$'\033[0;32m'; YELLOW=$'\033[1;33m'; BLUE=$'\033[0;34m'; MAGENTA=$'\033[0;35m'; CYAN=$'\033[0;36m'; BOLD=$'\033[1m'; DIM=$'\033[2m'; NC=$'\033[0m'
log(){ printf '[%s] %s\n' "$(date '+%F %T')" "$*" >> "$LOG_FILE"; }
err(){ printf "${RED}Error:${NC} %s\n" "$*"; log "ERROR: $*"; }
ok(){ printf "${GREEN}%s${NC}\n" "$*"; log "OK: $*"; }
info(){ printf "${CYAN}%s${NC}\n" "$*"; }
pause(){ printf "\n${DIM}Tekan Enter untuk kembali...${NC}"; read -r _; }
need(){ command -v "$1" >/dev/null 2>&1 || { err "Perintah '$1' belum tersedia. Jalankan bash install.sh"; return 1; }; }
android_storage_hint(){ [[ -d "$HOME/storage" ]] || printf "${YELLOW}Tip:${NC} jalankan 'termux-setup-storage' agar akses storage Android aktif.\n"; }
clear_screen(){ printf '\033c'; }
logo(){
cat <<'LOGO'
    ___              __          _     __  ___           __           
   /   |  ____  ____/ /_________(_)___/ / /   |  ____  / /__________ 
  / /| | / __ \/ __  / ___/ __ `/ / __  / /| | / __ \/ __/ ___/ __ \
 / ___ |/ / / / /_/ / /  / /_/ / / /_/ / ___ |/ / / / /_/ /  / /_/ /
/_/  |_/_/ /_/\__,_/_/   \__,_/_/\__,_/_/  |_/_/ /_/\__/_/   \____/ 
                    MASTER TOOLKIT FOR TERMUX
LOGO
}
header(){ clear_screen; printf "${CYAN}${BOLD}"; logo; printf "${NC}\n${DIM}%s | %s${NC}\n\n" "$(date '+%A, %d %B %Y %H:%M')" "$(uname -o 2>/dev/null || echo Android)"; }
spinner(){ local pid=$1 msg=${2:-Loading}; local spin='|/-\\'; local i=0; while kill -0 "$pid" 2>/dev/null; do i=$(((i+1)%4)); printf '\r%s %s' "$msg" "${spin:$i:1}"; sleep .1; done; printf '\r%s done.   \n' "$msg"; }
progress_bar(){ local cur=$1 total=$2 width=${3:-30}; local pct=0 fill=0; cur=$((10#$cur)); total=$((10#$total)); (( total > 0 )) && pct=$((cur*100/total)); fill=$((pct*width/100)); printf '['; printf '%*s' "$fill" '' | tr ' ' '#'; printf '%*s' $((width-fill)) '' | tr ' ' '-'; printf '] %3d%%\n' "$pct"; }
record_usage(){ local key="$1"; printf '%s\t%s\n' "$(date '+%F %T')" "$key" >> "$STATS_FILE"; }
show_stats(){ header; info "Statistik Penggunaan"; if [[ -s "$STATS_FILE" ]]; then awk -F'\t' '{c[$2]++} END{for(k in c) printf "%4d  %s\n",c[k],k}' "$STATS_FILE" | sort -rn | head -20; else echo "Belum ada statistik."; fi; pause; }
ask(){ local prompt="$1" default="${2:-}" ans; read -r -p "$prompt${default:+ [$default]}: " ans; printf '%s' "${ans:-$default}"; }
run_editor(){ "${EDITOR:-nano}" "$1"; }
