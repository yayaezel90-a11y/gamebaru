#!/data/data/com.termux/files/usr/bin/bash
show_device_info(){ header; record_usage "Informasi Perangkat"; android_storage_hint; printf "${BOLD}Informasi Perangkat${NC}\n"; 
  echo "Nama perangkat : $(getprop ro.product.manufacturer 2>/dev/null) $(getprop ro.product.model 2>/dev/null)";
  echo "Android Version: $(getprop ro.build.version.release 2>/dev/null) (SDK $(getprop ro.build.version.sdk 2>/dev/null))";
  echo "CPU            : $(getprop ro.hardware 2>/dev/null || uname -m) / $(uname -m)";
  awk '/MemTotal|MemAvailable/{printf "%-14s: %.2f GB\n",$1,$2/1024/1024}' /proc/meminfo 2>/dev/null;
  df -h "$HOME" /sdcard 2>/dev/null | awk 'NR==1||NR>1{print}';
  battery_health; pause; }
battery_json(){ if command -v termux-battery-status >/dev/null 2>&1; then termux-battery-status 2>/dev/null; else echo '{}'; fi; }
battery_health(){ local j; j=$(battery_json); if command -v jq >/dev/null 2>&1; then echo "Battery Health : $(jq -r '.health // "unknown"' <<<"$j")"; else echo "Battery Health : install jq"; fi; }
monitor_battery(){ header; record_usage "Monitor Baterai"; local j; j=$(battery_json); if [[ "$j" == "{}" ]]; then err "termux-api belum aktif atau aplikasi Termux:API belum terpasang."; pause; return; fi; jq -r '"Persentase    : \(.percentage)%\nSuhu          : \(.temperature)°C\nStatus        : \(.status)\nHealth        : \(.health)\nPlugged       : \(.plugged)"' <<<"$j"; echo "Estimasi waktu : tergantung pola penggunaan dan tidak tersedia akurat dari Android API."; pause; }
monitor_ram(){ header; record_usage "Monitor RAM"; free -h 2>/dev/null || awk '/MemTotal|MemFree|MemAvailable|SwapTotal|SwapFree/{print}' /proc/meminfo; pause; }
monitor_cpu(){ header; record_usage "Monitor CPU"; echo "CPU: $(getprop ro.hardware 2>/dev/null || uname -m)"; echo "Core: $(nproc 2>/dev/null || echo unknown)"; top -b -n 1 2>/dev/null | head -20 || ps -eo pid,pcpu,pmem,args | sort -k2 -nr | head; pause; }
monitor_storage(){ header; record_usage "Monitor Penyimpanan"; df -h "$HOME" /sdcard 2>/dev/null; pause; }
