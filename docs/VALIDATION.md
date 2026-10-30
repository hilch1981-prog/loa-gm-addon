# Validation / 검증

Target:WoW 5.4.8(18414),Interface 50400,Lua 5.1,LoA Pandaria. `scripts/validate.py` verifies:

- Matching folder/TOC/interface/version and SavedVariables identity.
- Exact,explicit `addon-manifest.json` file set and SHA256;no silent regeneration.
- Every24 TOC Lua file compiled by Lua 5.1 and loaded by a mocked WoW API.
- 115 assertions for each of5 locales;not actual locale/gameplay acceptance.
- Original development-file hashes and version-only normalized comparison.
- Local Markdown links and absence of common private path/token/binary patterns.

`scripts/package.py` packages exactly one `GMminibar-LoA` directory,checks ZIP CRC and every file's digest,and verifies the recorded release asset hash. ZIP timestamps/order/permissions are deterministic. The archive uses standard ZIP_STORED entries to avoid zlib/zlib-ng platform differences;it remains a normal extractable ZIP. The initial compressed candidate was not released because Linux CI produced a different archive hash despite matching payloads. No runtime,server/client executable,SQL dump or account configuration is packaged.

The actual Korean client's menu opening/closing and LoA label are historical screen observations from development1.3.1-mop548. They remain separate from mock results and public1.0.0 packaging. [Game record](../GMminibar-LoA/GAME_TEST.md) · [Screenshots](SCREENSHOTS.md).

개발판의 기능 본문·목록·설정 이름을 보존해 최초 공개판1.0.0으로 등록합니다. 자동 검사와 실제 게임 확인은 서로 대체하지 않습니다. 모든 명령·보안 가방 동작·착지·전문기술 단계·다른 언어 게임·파티 동시 적용은 미검증입니다.
