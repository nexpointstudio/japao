from pathlib import Path
import hashlib, json

root = Path(__file__).resolve().parents[2]
files = [root / 'AMAHARA_BIBLIA_MESTRA_COMPLETA.md', *sorted((root / 'amahara_vertical_slice').rglob('*'))]
rows = [{'path': str(p.relative_to(root)), 'bytes': p.stat().st_size, 'sha256': hashlib.sha256(p.read_bytes()).hexdigest()} for p in files if p.is_file()]
dest = root / 'Amahara_Godot/docs/source_manifest.json'
if dest.exists():
    old = json.loads(dest.read_text(encoding='utf-8'))
    assert rows == old, 'Original sources changed'
    print(f'PRESERVATION PASS: {len(rows)} original files unchanged')
else:
    dest.write_text(json.dumps(rows, indent=2, ensure_ascii=False), encoding='utf-8')
    print(f'Inventoried {len(rows)} sources')
