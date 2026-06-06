#!/data/data/com.termux/files/usr/bin/bash
backup_dir(){ local src="$1" name="$2"; header; record_usage "Backup $name"; android_storage_hint; [[ -d "$src" ]] || { err "Folder sumber tidak ditemukan: $src"; pause; return; }; local dest="${BACKUP_DIR:-$APP_DIR/backups}/${name}_$(date +%Y%m%d_%H%M%S)"; mkdir -p "$dest"; rsync -a --info=progress2 "$src"/ "$dest"/ 2>/dev/null || cp -a "$src"/. "$dest"/; ok "Backup tersimpan: $dest"; pause; }
backup_photos(){ backup_dir "$HOME/storage/dcim/Camera" "photos"; }
backup_videos(){ backup_dir "$HOME/storage/movies" "videos"; }
backup_download(){ backup_dir "$HOME/storage/downloads" "downloads"; }
restore_backup(){ header; record_usage "Restore Backup"; local src dest; find "${BACKUP_DIR:-$APP_DIR/backups}" -maxdepth 1 -type d -printf '%f\n' 2>/dev/null | sort; src=$(ask "Nama/path backup"); [[ "$src" != /* ]] && src="${BACKUP_DIR:-$APP_DIR/backups}/$src"; dest=$(ask "Folder tujuan" "$HOME/storage/downloads/restored"); [[ -d "$src" ]] || { err "Backup tidak ditemukan"; pause; return; }; mkdir -p "$dest"; cp -a "$src"/. "$dest"/; ok "Restore selesai ke $dest"; pause; }
