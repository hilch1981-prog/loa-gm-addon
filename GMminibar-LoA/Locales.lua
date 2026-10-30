GMMPandaria548 = GMMPandaria548 or {}
local AAM = GMMPandaria548

local locale = GetLocale and GetLocale() or "enUS"

local enUS = {
  title="GM MINI BAR", subtitle="MoP 5.4.8 / Build 18414", shellTitle="GM Addon [Pandaria 5.4.8]", shellSubtitle="MOP_V2_Repack edition",
  arg="Argument", run="Run", cancel="Cancel", send="Send", raw="Raw command", search="Filter", searchButton="Search", refresh="Refresh", ready="Ready", sent="Sent", selected="Selected",
  gmMenu="GM Menu", rightClickFavorite="Right click: assign to quick slot", rightClickUnfavorite="Right click: remove from quick slot", quickslotHint="Right click a GM command to assign it here.",
  groupGeneral="General", groupCheats="Cheats", groupPlayer="Player", groupModify="Modify", groupSpells="Spells", groupItems="Items", groupLookup="Lookup", groupTeleport="Teleport", groupQuest="Quest", groupNpc="NPC", groupServer="Server",
  note="Commands are matched to MOP_V2_Repack source.", listHint="Tip: use the selectable Item / Quest / NPC / Spell / Player / Teleport lists instead of memorizing IDs or English names.", argumentRequired="Argument required",
  minimapTitle="GM MINI BAR", minimapLeft="Left click: GM panel", minimapRight="Right click: Teleports", minimapMiddle="Middle click: Favorite teleports", minimapDrag="Drag: Move around minimap", favoriteAdded="Favorite added", favoriteRemoved="Favorite removed",
  dataBrowserButton="MoP Data", dataBrowserTitle="MoP Data Browser", dataBrowserSubtitle="MOP_V2_Repack localized index", dataHelp="Search localized name or exact ID. Select a row, then use the action buttons.", chooseFromList="Choose an entry from the list.",
  items="Items", quests="Quests", creatures="NPC/Creatures", teleports="Teleports", previous="Previous", next="Next", favorites="Favorites",
  allCount="%d-%d / matched %d", favoritesCount="%d-%d / favorites %d", favoritesSubtitle="Favorite teleports | Right click to remove", teleportClickHelp="Left click: teleport | Right click: favorite", teleportCanonicalNote="Localized label/search -> server canonical game_tele name",
  add="Add", addOne="Add x1", addFive="Add x5", complete="Complete", reward="Reward", remove="Remove", removeOne="Remove x1", serverLookup="Lookup", goTo="Go", spawn="Spawn", extraAction="Extra",
  questHelperTitle="MoP Quest Helper", activeQuests="Active quests", allQuests="All quests", questItemStartDetected="Item-started quest detected. Adding start item %d.", questUseStartItem="The quest starts from an item. Use the added item in your bag to start it normally.", questItemStartNoId="This quest starts from an item. Check the server message for the suggested .additem command.",
  itemBrowserTitle="MoP Item Browser", itemBrowserHelp="Search by localized name or item ID. Hover a row for the native item tooltip.", qualityMin="Q≥", itemLevelMin="iLv≥", classId="Class",
  spellBrowserTitle="MoP Spell Browser", spellBrowserNote="Builds a localized spell index from the 5.4.8 client. No spell ID memorization required.", spellScanProgress="Index %d%% | %d found", chooseSpell="Choose a spell from the list.", learn="Learn", cast="Cast", aura="Aura", unlearn="Unlearn",
  playerBrowserTitle="Online Player Browser", playerBrowserNote="Uses the 5.4.8 /who list and selected target so player names do not have to be memorized.", choosePlayer="Choose a player from the list.", onlineResults="results", currentTarget="Current target", selfPlayer="Self", appear="Appear", summon="Summon", freeze="Freeze", whoUnavailable="/who API unavailable",
  professionTitle="MoP Profession Tools", bankButton="Bank", reviveButton="Revive", learnRecipes="Learn recipes", set600="Set 600", maxSkill="Max skills", learnAllCrafts="All crafts", professionLocaleNote="The server command uses the profession name from the active client/server DBC locale.", bankLoadFailed="Bank UI could not be loaded",
  flight="Flight", flightHint="Toggle GM flight", kill="Kill", killHint="Kill selected target", god="God", godHint="Toggle god mode", visibility="Visibility", visibilityHint="Toggle GM visibility", speed="Speed", speedHint="Toggle movement speed x1/x3",
  uiReset="UI positions reset", aamopUiOnly="/gmmop controls the UI. Use /gmcmd for raw GM commands."
}

local packs = {
  enUS = enUS,
  koKR = {
    title="GM MINI BAR", subtitle="판다리아 5.4.8 / 빌드 18414", shellTitle="GM 애드온 [판다리아 5.4.8]", shellSubtitle="MOP_V2_Repack 전용",
    arg="인수", run="실행", cancel="취소", send="전송", raw="직접 명령", search="검색", searchButton="검색", refresh="새로고침", ready="준비", sent="전송", selected="선택",
    gmMenu="GM 메뉴", rightClickFavorite="우클릭: 퀵슬롯 등록", rightClickUnfavorite="우클릭: 퀵슬롯 해제", quickslotHint="GM 명령을 우클릭하면 여기에 등록됩니다.",
    groupGeneral="일반", groupCheats="치트", groupPlayer="플레이어", groupModify="수정", groupSpells="스펠", groupItems="아이템", groupLookup="검색", groupTeleport="순간이동", groupQuest="퀘스트", groupNpc="NPC", groupServer="서버",
    note="MOP_V2_Repack 소스의 명령 체계에 맞춘 버전입니다.", listHint="아이템/퀘스트/NPC/스펠/플레이어/순간이동은 ID나 영문명을 외우지 말고 목록에서 선택하세요.", argumentRequired="인수가 필요합니다",
    minimapTitle="GM MINI BAR", minimapLeft="좌클릭: GM 패널", minimapRight="우클릭: 순간이동 목록", minimapMiddle="가운데 클릭: 즐겨찾기 순간이동", minimapDrag="드래그: 미니맵 둘레로 이동", favoriteAdded="즐겨찾기 등록", favoriteRemoved="즐겨찾기 해제",
    dataBrowserButton="MoP 데이터", dataBrowserTitle="MoP 데이터 브라우저", dataBrowserSubtitle="MOP_V2_Repack 한글/로컬 인덱스", dataHelp="한글/로컬 이름 또는 정확한 ID로 검색하고 목록에서 선택하세요.", chooseFromList="목록에서 항목을 선택하세요.",
    items="아이템", quests="퀘스트", creatures="NPC/크리처", teleports="순간이동", previous="이전", next="다음", favorites="즐겨찾기",
    allCount="%d-%d / 검색결과 %d", favoritesCount="%d-%d / 즐겨찾기 %d", favoritesSubtitle="즐겨찾기 순간이동 | 우클릭으로 해제", teleportClickHelp="좌클릭: 이동 | 우클릭: 즐겨찾기", teleportCanonicalNote="한글 표시/검색 → 서버 canonical game_tele 이름으로 전송",
    add="추가", addOne="1개 추가", addFive="5개 추가", complete="완료", reward="보상", remove="제거", removeOne="1개 제거", serverLookup="서버 검색", goTo="이동", spawn="소환", extraAction="추가 기능",
    questHelperTitle="MoP 퀘스트 도우미", activeQuests="진행 중 퀘스트", allQuests="전체 퀘스트 목록", questItemStartDetected="아이템으로 시작하는 퀘스트입니다. 시작 아이템 %d번을 자동 지급합니다.", questUseStartItem="가방에 지급된 시작 아이템을 사용해서 퀘스트를 정상 시작하세요.", questItemStartNoId="아이템 시작 퀘스트입니다. 서버 메시지의 .additem 안내를 확인하세요.",
    itemBrowserTitle="MoP 아이템 브라우저", itemBrowserHelp="한글/로컬 이름 또는 아이템 ID로 검색합니다. 마우스를 올리면 게임 기본 아이템 툴팁을 표시합니다.", qualityMin="품질≥", itemLevelMin="템렙≥", classId="분류",
    spellBrowserTitle="MoP 스펠 브라우저", spellBrowserNote="5.4.8 클라이언트의 로컬 스펠 이름을 자동 인덱싱합니다. Spell ID를 외울 필요가 없습니다.", spellScanProgress="인덱스 %d%% | %d개 발견", chooseSpell="목록에서 스펠을 선택하세요.", learn="배우기", cast="시전", aura="오라", unlearn="삭제",
    playerBrowserTitle="온라인 플레이어 목록", playerBrowserNote="5.4.8 /who 목록과 현재 선택 대상을 사용합니다. 캐릭터 이름을 외울 필요가 없습니다.", choosePlayer="목록에서 플레이어를 선택하세요.", onlineResults="명", currentTarget="현재 선택 대상", selfPlayer="내 캐릭터", appear="이동", summon="소환", freeze="동결", whoUnavailable="/who API를 사용할 수 없습니다.",
    professionTitle="MoP 전문기술 도구", bankButton="은행", reviveButton="부활", learnRecipes="도안 배우기", set600="600 설정", maxSkill="숙련 최대", learnAllCrafts="전체 제작", professionLocaleNote="서버 소스 기준 현재 세션 DBC 로케일의 전문기술명을 그대로 사용합니다.", bankLoadFailed="은행 UI를 불러오지 못했습니다.",
    flight="비행", flightHint="GM 비행 켜기/끄기", kill="처치", killHint="선택 대상을 즉시 처치", god="무적", godHint="God 모드 켜기/끄기", visibility="투명", visibilityHint="GM 표시/투명 전환", speed="속도", speedHint="이동속도 1배/3배 전환",
    uiReset="UI 위치를 초기화했습니다.", aamopUiOnly="/gmmop은 UI 전용입니다. 직접 GM 명령은 /gmcmd을 사용하세요."
  },
  zhCN = { shellTitle="GM插件 [熊猫人之谜 5.4.8]", shellSubtitle="MOP_V2_Repack 专用", groupGeneral="常规", groupCheats="作弊", groupPlayer="玩家", groupModify="修改", groupSpells="法术", groupItems="物品", groupLookup="查询", groupTeleport="传送", groupQuest="任务", groupNpc="NPC", groupServer="服务器", gmMenu="GM菜单", items="物品", quests="任务", creatures="NPC/生物", teleports="传送", searchButton="搜索", previous="上一页", next="下一页" },
  zhTW = { shellTitle="GM插件 [潘達利亞 5.4.8]", shellSubtitle="MOP_V2_Repack 專用", groupGeneral="一般", groupCheats="作弊", groupPlayer="玩家", groupModify="修改", groupSpells="法術", groupItems="物品", groupLookup="查詢", groupTeleport="傳送", groupQuest="任務", groupNpc="NPC", groupServer="伺服器", gmMenu="GM選單", items="物品", quests="任務", creatures="NPC/生物", teleports="傳送", searchButton="搜尋", previous="上一頁", next="下一頁" },
  ruRU = { shellTitle="GM Addon [Pandaria 5.4.8]", shellSubtitle="MOP_V2_Repack", groupGeneral="Общее", groupCheats="Читы", groupPlayer="Игрок", groupModify="Изменить", groupSpells="Заклинания", groupItems="Предметы", groupLookup="Поиск", groupTeleport="Телепорт", groupQuest="Задания", groupNpc="NPC", groupServer="Сервер", gmMenu="GM меню", items="Предметы", quests="Задания", creatures="NPC/Существа", teleports="Телепорты", searchButton="Поиск", previous="Назад", next="Далее" },
}

local selected = packs[locale] or enUS
if selected ~= enUS then setmetatable(selected, { __index = enUS }) end
AAM.L = selected
