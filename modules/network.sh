#!/data/data/com.termux/files/usr/bin/bash
quake_bmkg(){ header; record_usage "Cek Gempa BMKG"; curl -fsSL https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json | jq -r '.Infogempa.gempa | "Tanggal: \(.Tanggal) \(.Jam)\nMagnitudo: \(.Magnitude)\nKedalaman: \(.Kedalaman)\nWilayah: \(.Wilayah)\nPotensi: \(.Potensi)"' 2>/dev/null || err "Gagal mengambil data BMKG"; pause; }
gold_price(){ header; record_usage "Cek Harga Emas"; curl -fsSL https://logam-mulia-api.vercel.app/prices/anekalogam | jq '.[0] // .' 2>/dev/null || echo "Sumber harga emas tidak tersedia. Cek situs Logam Mulia resmi."; pause; }
dollar_rate(){ header; record_usage "Cek Kurs Dollar"; curl -fsSL 'https://api.exchangerate.host/convert?from=USD&to=IDR&amount=1' | jq -r '"1 USD = \(.result) IDR"' 2>/dev/null || err "Gagal mengambil kurs"; pause; }
ip_check(){ header; record_usage "Cek Alamat IP"; echo "Public IP:"; curl -fsSL https://api.ipify.org; echo; echo "Local:"; ip addr show 2>/dev/null | awk '/inet /{print $2, $NF}'; pause; }
network_info(){ header; record_usage "Informasi Jaringan"; ip addr show 2>/dev/null; echo; ip route 2>/dev/null; pause; }
dns_lookup(){ header; record_usage "DNS Lookup"; local d; d=$(ask "Domain" "google.com"); (dig "$d" || nslookup "$d" || host "$d") 2>/dev/null; pause; }
ping_checker(){ header; record_usage "Ping Checker"; local h; h=$(ask "Host" "google.com"); ping -c 4 "$h"; pause; }
website_status(){ header; record_usage "Website Status Checker"; local u; u=$(ask "URL" "https://google.com"); curl -L -o /dev/null -s -w 'HTTP %{http_code}\nDNS %{time_namelookup}s\nConnect %{time_connect}s\nTotal %{time_total}s\n' "$u"; pause; }
