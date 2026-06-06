#!/data/data/com.termux/files/usr/bin/bash
qr_generate(){ header; record_usage "QR Code Generator"; need python || { pause; return; }; local text out; text=$(ask "Teks/URL"); out=$(ask "Output PNG" "$APP_DIR/assets/qr_$(date +%s).png"); python - "$text" "$out" <<'PY'
import qrcode, sys
img=qrcode.make(sys.argv[1]); img.save(sys.argv[2]); print(sys.argv[2])
PY
ok "QR dibuat: $out"; pause; }
qr_read(){ header; record_usage "QR Code Reader"; local img; img=$(ask "Path gambar QR"); if command -v zbarimg >/dev/null 2>&1; then zbarimg "$img"; else err "QR reader membutuhkan zbarimg/pyzbar yang tidak selalu tersedia di Termux. Install zbar jika tersedia."; fi; pause; }
password_generator(){ header; record_usage "Password Generator"; local len; len=$(ask "Panjang password" "24"); tr -dc 'A-Za-z0-9!@#$%^&*()_+-=' </dev/urandom | head -c "$len"; echo; pause; }
master_key(){ local key="$CONFIG_DIR/master.key"; if [[ ! -f "$key" ]]; then umask 077; openssl rand -hex 32 > "$key"; fi; cat "$key"; }
pass_file="$CONFIG_DIR/passwords.enc"; notes_file="$CONFIG_DIR/secret_notes.enc"
enc_edit(){ local file="$1" title="$2" tmp="$TMP_DIR/secure_$$.txt"; header; record_usage "$title"; need openssl || { pause; return; }; [[ -f "$file" ]] && openssl enc -aes-256-cbc -pbkdf2 -d -in "$file" -out "$tmp" -pass pass:"$(master_key)" 2>/dev/null || true; run_editor "$tmp"; openssl enc -aes-256-cbc -pbkdf2 -salt -in "$tmp" -out "$file" -pass pass:"$(master_key)"; shred -u "$tmp" 2>/dev/null || rm -f "$tmp"; ok "Tersimpan terenkripsi: $file"; pause; }
password_manager(){ enc_edit "$pass_file" "Password Manager Offline"; }
secret_notes(){ enc_edit "$notes_file" "Catatan Rahasia Terenkripsi"; }
todo_list(){ header; record_usage "To Do List"; run_editor "$CONFIG_DIR/todo.txt"; }
calendar_view(){ header; record_usage "Kalender"; cal -3; pause; }
stopwatch(){ header; record_usage "Stopwatch"; echo "Tekan Ctrl+C untuk berhenti."; local s=0; while true; do printf '\r%02d:%02d:%02d' $((s/3600)) $(((s/60)%60)) $((s%60)); sleep 1; s=$((s+1)); done; }
pomodoro(){ header; record_usage "Pomodoro Timer"; local min; min=$(ask "Durasi fokus menit" "25"); local sec=$((min*60)); while ((sec>0)); do printf '\rSisa %02d:%02d' $((sec/60)) $((sec%60)); sleep 1; sec=$((sec-1)); done; printf '\nWaktu istirahat!\n'; termux-vibrate -d 700 2>/dev/null || true; pause; }
currency_convert(){ header; record_usage "Konverter Mata Uang"; local amt from to rate; amt=$(ask "Jumlah" "1"); from=$(ask "Dari" "${CURRENCY_BASE:-USD}"); to=$(ask "Ke" "${CURRENCY_TARGET:-IDR}"); rate=$(curl -fsSL "https://api.exchangerate.host/convert?from=$from&to=$to&amount=$amt" | jq -r '.result // empty' 2>/dev/null); [[ -n "$rate" ]] && echo "$amt $from = $rate $to" || err "Gagal mengambil kurs"; pause; }
calculator(){ header; record_usage "Kalkulator"; local expr; expr=$(ask "Ekspresi matematika"); python - <<PY
import math
env={k:getattr(math,k) for k in dir(math) if not k.startswith('_')}
env["__builtins__"]={} 
print(eval(${expr@Q}, env, {}))
PY
pause; }
unit_converter(){ header; record_usage "Konverter Unit"; echo "Contoh: meter->km, c->f, kg->lb"; local v t; v=$(ask "Nilai" "1"); t=$(ask "Tipe" "meter-km"); python - "$v" "$t" <<'PY'
import sys
v=float(sys.argv[1]); t=sys.argv[2].lower(); conv={'meter-km':v/1000,'km-meter':v*1000,'c-f':v*9/5+32,'f-c':(v-32)*5/9,'kg-lb':v*2.2046226218,'lb-kg':v/2.2046226218}
print(conv.get(t,'Tipe belum didukung'))
PY
pause; }
weather_check(){ header; record_usage "Cek Cuaca"; local city; city=$(ask "Kota" "${WEATHER_CITY:-Jakarta}"); curl -fsSL "https://wttr.in/${city// /+}?format=3" || err "Gagal mengambil cuaca"; echo; pause; }
