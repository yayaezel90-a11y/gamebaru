#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
for mod in "$APP_DIR"/modules/*.sh; do # shellcheck source=/dev/null
  source "$mod"
done
trap 'err "Terjadi kesalahan pada baris $LINENO. Lihat logs/toolkit.log"; pause' ERR

menu(){
  header
  cat <<MENU
${BOLD}Dashboard${NC}
$(progress_bar "$(date +%S)" 59 24)
Storage: $(df -h "$HOME" 2>/dev/null | awk 'NR==2{print $3"/"$2" ("$5")"}')   RAM: $(free -h 2>/dev/null | awk '/Mem:/{print $3"/"$2}')

${CYAN}[01]${NC} Informasi Perangkat        ${CYAN}[26]${NC} Cek Harga Emas
${CYAN}[02]${NC} Monitor Baterai           ${CYAN}[27]${NC} Cek Kurs Dollar
${CYAN}[03]${NC} Monitor RAM               ${CYAN}[28]${NC} Cek Alamat IP
${CYAN}[04]${NC} Monitor CPU               ${CYAN}[29]${NC} Informasi Jaringan
${CYAN}[05]${NC} Monitor Penyimpanan       ${CYAN}[30]${NC} DNS Lookup
${CYAN}[06]${NC} Analisis Storage          ${CYAN}[31]${NC} Ping Checker
${CYAN}[07]${NC} Pembersih Storage         ${CYAN}[32]${NC} Website Status Checker
${CYAN}[08]${NC} Backup Foto               ${CYAN}[33]${NC} Download Manager
${CYAN}[09]${NC} Backup Video              ${CYAN}[34]${NC} YouTube Downloader
${CYAN}[10]${NC} Backup Download           ${CYAN}[35]${NC} Audio Downloader
${CYAN}[11]${NC} Restore Backup            ${CYAN}[36]${NC} Video Downloader
${CYAN}[12]${NC} QR Code Generator         ${CYAN}[37]${NC} File Search
${CYAN}[13]${NC} QR Code Reader            ${CYAN}[38]${NC} Duplicate File Finder
${CYAN}[14]${NC} Password Generator        ${CYAN}[39]${NC} ZIP Compressor
${CYAN}[15]${NC} Password Manager Offline  ${CYAN}[40]${NC} ZIP Extractor
${CYAN}[16]${NC} Catatan Rahasia           ${CYAN}[41]${NC} PDF Merger
${CYAN}[17]${NC} To Do List                ${CYAN}[42]${NC} PDF Splitter
${CYAN}[18]${NC} Kalender                  ${CYAN}[43]${NC} Image Compressor
${CYAN}[19]${NC} Stopwatch                 ${CYAN}[44]${NC} Image Converter
${CYAN}[20]${NC} Pomodoro Timer            ${CYAN}[45]${NC} Watermark Image
${CYAN}[21]${NC} Konverter Mata Uang       ${CYAN}[46]${NC} Rename Banyak File
${CYAN}[22]${NC} Kalkulator                ${CYAN}[47]${NC} APK Information
${CYAN}[23]${NC} Konverter Unit            ${CYAN}[48]${NC} Installed Apps Viewer
${CYAN}[24]${NC} Cek Cuaca                 ${CYAN}[49]${NC} Update Toolkit
${CYAN}[25]${NC} Cek Gempa BMKG            ${CYAN}[50]${NC} Settings
${CYAN}[99]${NC} Statistik Penggunaan      ${CYAN}[00]${NC} Exit
MENU
}

route(){
case "$1" in
  01|1) show_device_info;; 02|2) monitor_battery;; 03|3) monitor_ram;; 04|4) monitor_cpu;; 05|5) monitor_storage;;
  06|6) storage_analysis;; 07|7) clean_storage;; 08|8) backup_photos;; 09|9) backup_videos;; 10) backup_download;; 11) restore_backup;;
  12) qr_generate;; 13) qr_read;; 14) password_generator;; 15) password_manager;; 16) secret_notes;; 17) todo_list;; 18) calendar_view;; 19) stopwatch;; 20) pomodoro;;
  21) currency_convert;; 22) calculator;; 23) unit_converter;; 24) weather_check;; 25) quake_bmkg;; 26) gold_price;; 27) dollar_rate;; 28) ip_check;;
  29) network_info;; 30) dns_lookup;; 31) ping_checker;; 32) website_status;; 33) download_manager;; 34) youtube_downloader;; 35) audio_downloader;; 36) video_downloader;;
  37) file_search;; 38) duplicate_finder;; 39) zip_compressor;; 40) zip_extractor;; 41) pdf_merger;; 42) pdf_splitter;; 43) image_compressor;; 44) image_converter;;
  45) watermark_image;; 46) bulk_rename;; 47) apk_info;; 48) installed_apps;; 49) update_toolkit;; 50) settings_menu;; 99) show_stats;; 00|0|exit|q) ok "Sampai jumpa!"; exit 0;;
  *) err "Pilihan tidak dikenal: $1"; sleep 1;;
esac
}

main(){ log "Started toolkit"; while true; do menu; read -r -p "Pilih menu: " choice; route "${choice:-}"; done; }
main "$@"
