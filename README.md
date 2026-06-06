# Android Master Toolkit

Android Master Toolkit adalah aplikasi terminal multi-tools untuk pengguna Android yang berjalan di Termux. Toolkit ini menyediakan dashboard modern, menu 50 fitur, logging, statistik penggunaan, konfigurasi modular, backup, pengolahan file/media, utilitas jaringan, dan produktivitas offline.

## Instalasi

```bash
pkg update -y
pkg upgrade -y
pkg install git -y
git clone https://github.com/USERNAME/android-master-toolkit.git
cd android-master-toolkit
bash install.sh
```

Setelah instalasi, buka aplikasi dari mana saja dengan:

```bash
toolkit
```

> Untuk fitur yang membaca storage Android, jalankan `termux-setup-storage` sekali dan berikan izin akses file.
> Untuk fitur baterai/aplikasi, instal aplikasi pendamping **Termux:API** dan jalankan `pkg install termux-api`.

## Dependensi Otomatis

Installer memasang paket Termux berikut:

- git
- curl
- wget
- python
- nodejs
- jq
- zip
- unzip
- ffmpeg
- imagemagick
- coreutils/findutils/openssl/termux-api/dnsutils/procps/util-linux/zbar pendukung runtime

Installer juga mencoba memasang paket Python: `qrcode[pil]`, `pillow`, `pypdf`, `requests`, dan `yt-dlp`.

## Fitur Utama

1. Informasi Perangkat
2. Monitor Baterai
3. Monitor RAM
4. Monitor CPU
5. Monitor Penyimpanan
6. Analisis Storage
7. Pembersih Storage
8. Backup Foto
9. Backup Video
10. Backup Download
11. Restore Backup
12. QR Code Generator
13. QR Code Reader
14. Password Generator
15. Password Manager Offline
16. Catatan Rahasia Terenkripsi
17. To Do List
18. Kalender
19. Stopwatch
20. Pomodoro Timer
21. Konverter Mata Uang
22. Kalkulator
23. Konverter Unit
24. Cek Cuaca
25. Cek Gempa BMKG
26. Cek Harga Emas
27. Cek Kurs Dollar
28. Cek Alamat IP
29. Informasi Jaringan
30. DNS Lookup
31. Ping Checker
32. Website Status Checker
33. Download Manager
34. YouTube Downloader
35. Audio Downloader
36. Video Downloader
37. File Search
38. Duplicate File Finder
39. ZIP Compressor
40. ZIP Extractor
41. PDF Merger
42. PDF Splitter
43. Image Compressor
44. Image Converter
45. Watermark Image
46. Rename Banyak File
47. APK Information
48. Installed Apps Viewer
49. Update Toolkit
50. Settings

## Struktur Proyek

```text
android-master-toolkit/
├── install.sh
├── uninstall.sh
├── update.sh
├── toolkit.sh
├── modules/
│   ├── apps.sh
│   ├── backup.sh
│   ├── core.sh
│   ├── device.sh
│   ├── files.sh
│   ├── media.sh
│   ├── network.sh
│   ├── productivity.sh
│   └── storage.sh
├── config/
├── backups/
├── logs/
├── assets/
└── README.md
```

## Arsitektur

- `toolkit.sh` adalah entrypoint dan router menu.
- `modules/core.sh` berisi warna terminal, logo ASCII, logging, statistik, settings, progress bar, dan helper umum.
- Modul lain memisahkan fitur berdasarkan domain: perangkat, storage, backup, produktivitas, jaringan, media, file, dan aplikasi.
- `config/settings.conf` dibuat otomatis saat runtime dan dapat diedit dari menu Settings.
- `logs/toolkit.log` mencatat aktivitas dan error.
- `backups/` menyimpan hasil backup default.

## Keamanan Data

- Password manager dan catatan rahasia disimpan terenkripsi AES-256-CBC menggunakan `openssl` dan key lokal di `config/master.key`.
- Backup, konfigurasi, dan log tidak dihapus oleh `uninstall.sh` agar data pengguna tidak hilang tanpa sengaja.
- Jangan commit isi `config/`, `backups/`, `logs/`, `tmp/`, atau data pribadi ke repository publik.

## Update

Dari menu pilih `[49] Update Toolkit`, atau jalankan:

```bash
bash update.sh
```

## Uninstall

```bash
bash uninstall.sh
```

Perintah ini menghapus launcher `toolkit` dan folder runtime sementara. Folder project, backup, konfigurasi, dan log tetap dipertahankan.
