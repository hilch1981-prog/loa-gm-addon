# GM MINI BAR — Pandaria / LoA v1.0.0

# # 한국어

**LoA Pandaria / WoW 5.4.8(18414),Interface 50400,Lua 5.1**용 최초 공개 배포입니다. 기존 SkyFire용 MoP 저장소와 구분하며 `GMminibar-LoA` 폴더와 **GM MINI BAR[판다리아-LoA]** 이름을 유지합니다.

- 14슬롯 미니바,GM 도구,아이템/퀘스트/NPC/순간이동 검색,스펠/플레이어 검색,전문기술,은행/기본 가방 연결을 포함합니다.
- 설치 파일은 **GMminibar_LoA_MoP_5.4.8_v1.0.0.zip 하나**입니다. 안의 `GMminibar-LoA` 폴더를 `Interface/AddOns`에 넣으세요. 기존 설치는 폴더를 백업/교체하고 `WTF`는 보존하세요.
- 한·영 안내,코어별 저장소 링크,실제 한글 판다리아 화면,출처와 검증 범위를 포함했습니다. MPQ/DLL/SQL/서버 교체가 필요하지 않습니다.

검증:Lua 5.1 구문24파일,5개 로케일 각각115개 모의 검사,명시적 파일 SHA·ZIP CRC·단일 폴더/내용 일치. 실제 원본 한글 클라이언트에서 미니바·GM 메뉴 열기/닫기·LoA 표시를 확인했습니다. 해당 화면은 개발1.3.1-mop548이며 공개1.0.0은 버전 두 곳/줄바꿈/문서를 정리한 배포본입니다. 기능 본문·검색 목록·저장 변수는 보존했습니다.

전체 명령·실제 보안 가방 동작·모든 퀘스트/착지/전문기술 단계·다른 언어 게임·다른 사용자 동시 적용은 미검증입니다. 일부 UI 문자열은 한글 고정이고 중국어/러시아어 팩은 부분 번역입니다. 서버 명령과 GM 권한이 필요하며 애드온이 권한을 부여하지 않습니다.

# # English

Initial public baseline for **LoA Pandaria / WoW 5.4.8(18414),Interface 50400,Lua 5.1**. Separate from the existing SkyFire MoP edition. Install only **GMminibar_LoA_MoP_5.4.8_v1.0.0.zip**,placing its single `GMminibar-LoA` folder in `Interface/AddOns`. Keep `WTF` to preserve settings. No MPQ,DLL,SQL import or server binary replacement is required.

Includes the14-slot minibar,GM utilities,offline item/quest/creature/travel catalogs,spell/player browsers,quest/profession tools and bank/client-bag routing. Bilingual guides and actual Pandaria screenshots document the exact scope.

Validation:24 Lua 5.1 syntax files;115 mocked contracts per each of5 locales;explicit source integrity,ZIP CRC and single-folder content verification. Actual Korean-client observation covers menu/minibar rendering and opening/closing only. The screenshot shows development1.3.1-mop548;public1.0.0 preserves its function bodies/catalogs/settings and changes two version literals,their line endings and documentation. No fresh all-feature gameplay claim is made.

All commands,protected inventory actions,all quests/landings/profession ranks,complete non-Korean localization and multiplayer remain unverified. Some LoA labels remain Korean;Chinese/Russian packs are partial. Appropriate server GM permissions are required.
