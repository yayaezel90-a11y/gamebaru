#!/data/data/com.termux/files/usr/bin/bash
file_search(){ header; record_usage "File Search"; local dir pat; dir=$(ask "Folder" "$HOME/storage/shared"); pat=$(ask "Nama/pola" "*.jpg"); find "$dir" -iname "$pat" 2>/dev/null | head -200; pause; }
duplicate_finder(){ header; record_usage "Duplicate File Finder"; local dir; dir=$(ask "Folder" "$HOME/storage/shared"); find "$dir" -type f -size +0c -print0 2>/dev/null | xargs -0 sha256sum 2>/dev/null | sort | awk 'seen[$1]++{print "DUP",$0}'; pause; }
zip_compressor(){ header; record_usage "ZIP Compressor"; local src out; src=$(ask "File/folder sumber"); out=$(ask "Output zip" "archive_$(date +%s).zip"); zip -r "$out" "$src"; pause; }
zip_extractor(){ header; record_usage "ZIP Extractor"; local z out; z=$(ask "File zip"); out=$(ask "Folder output" "extracted_${z%.zip}"); mkdir -p "$out"; unzip "$z" -d "$out"; pause; }
pdf_merger(){ header; record_usage "PDF Merger"; local out files; out=$(ask "Output PDF" "merged.pdf"); files=$(ask "Input PDF dipisah spasi"); python - "$out" $files <<'PY'
import sys
from pypdf import PdfWriter
w=PdfWriter()
for f in sys.argv[2:]: w.append(f)
w.write(sys.argv[1]); w.close(); print(sys.argv[1])
PY
pause; }
pdf_splitter(){ header; record_usage "PDF Splitter"; local f out; f=$(ask "Input PDF"); out=$(ask "Folder output" "split_pdf"); mkdir -p "$out"; python - "$f" "$out" <<'PY'
import sys, pathlib
from pypdf import PdfReader, PdfWriter
r=PdfReader(sys.argv[1]); out=pathlib.Path(sys.argv[2])
for i,p in enumerate(r.pages,1):
    w=PdfWriter(); w.add_page(p); fn=out/f'page_{i:03d}.pdf'; w.write(str(fn)); print(fn)
PY
pause; }
bulk_rename(){ header; record_usage "Rename Banyak File"; local dir prefix i=1 ext f; dir=$(ask "Folder" "."); prefix=$(ask "Prefix baru" "file"); for f in "$dir"/*; do [[ -f "$f" ]] || continue; ext="${f##*.}"; mv -i "$f" "$dir/${prefix}_$(printf '%03d' "$i").$ext"; i=$((i+1)); done; ok "Selesai"; pause; }
