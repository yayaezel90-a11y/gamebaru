#!/data/data/com.termux/files/usr/bin/bash
apk_info(){ header; record_usage "APK Information"; local apk; apk=$(ask "Path APK"); if command -v aapt >/dev/null 2>&1; then aapt dump badging "$apk" | head -40; else echo "aapt tidak tersedia. Info dasar:"; file "$apk"; unzip -l "$apk" | head -30; fi; pause; }
installed_apps(){ header; record_usage "Installed Apps Viewer"; if command -v termux-application-list >/dev/null 2>&1; then termux-application-list | jq -r '.[] | "\(.app_name) - \(.package_name)"'; else pm list packages 2>/dev/null || err "Butuh Termux:API atau akses pm."; fi; pause; }
update_toolkit(){ bash "$APP_DIR/update.sh"; pause; }
settings_menu(){ header; record_usage "Settings"; echo "File settings: $SETTINGS_FILE"; echo; cat "$SETTINGS_FILE"; echo; read -r -p "Edit settings? [y/N] " a; [[ "$a" =~ ^[Yy] ]] && run_editor "$SETTINGS_FILE"; }
