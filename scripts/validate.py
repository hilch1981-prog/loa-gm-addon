"""Validate the explicit release, source manifest, Lua5.1 and mocked contracts."""
from pathlib import Path
import hashlib,json,os,re,shutil,subprocess
ROOT=Path(__file__).resolve().parents[1]
ADDON=ROOT/'GMminibar-LoA'
def digest(data):return hashlib.sha256(data).hexdigest()
def main():
    release=json.loads((ROOT/'release.json').read_text(encoding='utf-8'))
    manifest=json.loads((ROOT/'addon-manifest.json').read_text(encoding='utf-8'))
    files={p.relative_to(ROOT).as_posix() for p in ADDON.rglob('*') if p.is_file()}
    assert files==set(manifest),'Deliberately update manifest before validating changed addon files.'
    for name,expected in manifest.items():assert digest((ROOT/name).read_bytes())==expected,name
    toc=(ADDON/'GMminibar-LoA.toc').read_text(encoding='utf-8-sig')
    assert re.search(r'^## Interface: 50400$',toc,re.M)
    assert f'## Version: {release["version"]}' in toc
    assert '## SavedVariables: GMMPandariaDB' in toc
    assert '## X-Core: Legends-of-Azeroth-Pandaria-5.4.8 + Playerbots' in toc
    assert f'AAM.version = "{release["version"]}"' in (ADDON/'Core.lua').read_text(encoding='utf-8')
    entries=[s.strip().replace('\\','/') for s in toc.splitlines() if s.strip() and not s.lstrip().startswith('#')]
    assert len(entries)==len(set(entries))==24
    luaFiles=sorted(ADDON.rglob('*.lua'))
    assert {p.relative_to(ADDON).as_posix() for p in luaFiles}==set(entries)
    for name in entries:assert name in {p.relative_to(ADDON).as_posix() for p in ADDON.rglob('*') if p.is_file()},name
    provenance=json.loads((ROOT/'docs/development-source.json').read_text(encoding='utf-8'))
    for name,expected in provenance['originalFiles'].items():
        if name in provenance['versionOnlyFiles']:
            text=(ADDON/name).read_text(encoding='utf-8').replace('1.0.0','1.3.1-mop548')
            assert digest(text.encode('utf-8'))==provenance['normalizedDevelopmentSha256'][name],name
        else:assert digest((ADDON/name).read_bytes())==expected,name
    tool=os.environ.get('LUA51_BIN') or shutil.which('lua5.1') or shutil.which('lua')
    assert tool,'Install Lua5.1 or set LUA51_BIN; no silent mock-only fallback.'
    version=subprocess.run([tool,'-v'],capture_output=True,text=True,encoding='utf-8')
    assert 'Lua 5.1' in version.stdout+version.stderr
    subprocess.run([tool,str(ROOT/'tests/syntax.lua'),*[str(p) for p in luaFiles]],check=True,cwd=ROOT)
    outcomes=[]
    for locale in ('koKR','enUS','zhCN','zhTW','ruRU'):
        run=subprocess.run([tool,str(ROOT/'tests/contracts.lua'),str(ADDON),locale],check=True,cwd=ROOT,capture_output=True,text=True,encoding='utf-8')
        assert 'PASS: 115 assertions' in run.stdout,run.stdout
        outcomes.append(dict(locale=locale,assertions=115,scope='Mocked APIs and preserved contracts, not translation/gameplay acceptance'))
        print(locale+': '+run.stdout.strip())
    missing=[];links=0
    for p in ROOT.rglob('*.md'):
        if any(part in ('.git','dist') for part in p.relative_to(ROOT).parts):continue
        for match in re.finditer(r'\[[^\]\n]*\]\(([^)\n]+)\)',p.read_text(encoding='utf-8-sig')):
            target=match.group(1).split('#')[0].strip('<>')
            if not target or re.match(r'^(https?:|mailto:)',target):continue
            links+=1
            if not (p.parent/target).exists():missing.append((str(p.relative_to(ROOT)),target))
    assert not missing,missing
    secret=re.compile(r'(?<![A-Za-z])[A-Za-z]:[\\/]|(?:ghp_|github_pat_|sk-proj-|nvapi-)[A-Za-z0-9_\-]{20,}')
    for p in ROOT.rglob('*'):
        if not p.is_file() or any(s in ('.git','dist','.validation','__pycache__') for s in p.relative_to(ROOT).parts):continue
        assert p.suffix.lower() not in ('.exe','.dll','.mpq','.sql','.gz','.zip','.log','.pyc'),p.name
        if p.suffix.lower() in ('.lua','.toc','.md','.json','.py','.yml','.txt'):
            assert not secret.search(p.read_text(encoding='utf-8-sig')),f'Private path/token pattern: {p.relative_to(ROOT)}'
    result=dict(luaVersion='5.1',syntaxFiles=len(luaFiles),mocked=outcomes,addonFiles=len(files),localDocumentationLinks=links,missingLinks=0,gameplayAcceptance=False)
    (ROOT/'.validation').mkdir(exist_ok=True)
    (ROOT/'.validation/result.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(result))
if __name__=='__main__':main()
