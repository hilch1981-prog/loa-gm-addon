"""Create one deterministic install ZIP from the explicit source manifest."""
from pathlib import Path
import hashlib,json,zipfile
ROOT=Path(__file__).resolve().parents[1]
def main():
    release=json.loads((ROOT/'release.json').read_text(encoding='utf-8'))
    manifest=json.loads((ROOT/'addon-manifest.json').read_text(encoding='utf-8'))
    files={p.relative_to(ROOT).as_posix() for p in (ROOT/release['folder']).rglob('*') if p.is_file()}
    assert files==set(manifest)
    payload={}
    for name,expected in manifest.items():
        assert name.startswith('GMminibar-LoA/') and '..' not in Path(name).parts
        payload[name]=(ROOT/name).read_bytes()
        assert hashlib.sha256(payload[name]).hexdigest()==expected,name
    (ROOT/'dist').mkdir(exist_ok=True);output=ROOT/'dist'/release['asset']
    # ZIP_STORED keeps exact bytes across zlib and zlib-ng/Python platforms.
    # The initial compressed candidate passed content checks but had a different
    # archive hash on Linux. The public asset must be reproducible everywhere.
    with zipfile.ZipFile(output,'w',zipfile.ZIP_STORED) as archive:
        for name,data in sorted(payload.items()):
            info=zipfile.ZipInfo(name,(2026,10,30,0,0,0));info.compress_type=zipfile.ZIP_STORED
            info.create_system=3;info.external_attr=0o100644<<16
            archive.writestr(info,data)
    with zipfile.ZipFile(output) as archive:
        assert archive.testzip() is None and set(archive.namelist())==set(manifest)
        assert all(n.startswith('GMminibar-LoA/') for n in archive.namelist())
        for name,expected in manifest.items():assert hashlib.sha256(archive.read(name)).hexdigest()==expected
    result=dict(asset=output.name,files=len(manifest),singleAddonFolder=True,sha256=hashlib.sha256(output.read_bytes()).hexdigest(),bytes=output.stat().st_size)
    if release.get('assetSha256'):assert release['assetSha256']==result['sha256'],'Package does not match recorded release asset.'
    if release.get('assetBytes'):assert release['assetBytes']==result['bytes']
    print(json.dumps(result))
if __name__=='__main__':main()
