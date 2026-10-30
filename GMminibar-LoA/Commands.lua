GMMPandaria548 = GMMPandaria548 or {}
local AAM = GMMPandaria548

local function entry(label, command, argument, action, hint)
  local e = { label or "", command, argument }
  e.action = action
  e.hint = hint
  return e
end

AAM.CommandGroups = {
  { key="general", label="General", commands={
    entry("GM ON", ".gm on"), entry("GM OFF", ".gm off"), entry("Fly ON", ".gm fly on"), entry("Fly OFF", ".gm fly off"),
    entry("Visible ON", ".gm visible on"), entry("Visible OFF", ".gm visible off"), entry("GM Chat ON", ".gm chat on"), entry("GM Chat OFF", ".gm chat off"),
    entry("GM List", ".gm ingame"), entry("GPS", ".gps"), entry("Commands", ".commands"), entry("Save", ".save"),
    entry("Repair", ".repairitems"), entry("Bank", nil, nil, "bank"), entry("Revive", nil, nil, "revive"),
  }},
  { key="cheats", label="Cheats", commands={
    entry("God ON", ".cheat god on"), entry("God OFF", ".cheat god off"), entry("Power ON", ".cheat power on"), entry("Power OFF", ".cheat power off"),
    entry("Cooldown ON", ".cheat cooldown on"), entry("Cooldown OFF", ".cheat cooldown off"), entry("Casttime ON", ".cheat casttime on"), entry("Casttime OFF", ".cheat casttime off"),
    entry("Waterwalk ON", ".cheat waterwalk on"), entry("Waterwalk OFF", ".cheat waterwalk off"), entry("Explore ON", ".cheat explore on"), entry("Explore OFF", ".cheat explore off"),
    entry("Taxi ON", ".cheat taxi on"), entry("Taxi OFF", ".cheat taxi off"), entry("Cheat status", ".cheat status"),
  }},
  { key="player", label="Player", commands={
    entry("Online players", nil, nil, "players", "Choose an online player instead of memorizing the name."),
    entry("Appear", ".appear %s", "player", nil, "If a player target is selected, its name is pre-filled."),
    entry("Summon", ".summon %s", "player"), entry("Recall", ".recall %s", "player (optional)"),
    entry("Revive", ".revive %s", "player (optional)"), entry("Freeze", ".freeze %s", "player [seconds]"), entry("Unfreeze", ".unfreeze %s", "player"),
    entry("PInfo", ".pinfo %s", "player (optional)"), entry("Combat stop", ".combatstop %s", "player (optional)"),
    entry("Level up", ".levelup %s", "levels"), entry("Character level", ".character level %s", "level"),
    entry("Rename", ".character rename %s", "player"), entry("Customize", ".character customize %s", "player"),
  }},
  { key="modify", label="Modify", commands={
    entry("Level +1", ".levelup 1"), entry("Level +5", ".levelup 5"), entry("Level +10", ".levelup 10"),
    entry("Money", ".modify money %s", "copper"), entry("HP", ".modify hp %s", "hp"), entry("Mana", ".modify mana %s", "mana"),
    entry("Rage", ".modify rage %s", "rage"), entry("Energy", ".modify energy %s", "energy"), entry("Runic", ".modify runicpower %s", "amount"),
    entry("Honor", ".modify honor %s", "amount"), entry("Phase", ".modify phase %s", "phaseMask"), entry("Scale", ".modify scale %s", "scale"),
    entry("Currency", ".modify currency %s", "currencyId amount"), entry("Speed x1", ".modify speed all 1"), entry("Speed x3", ".modify speed all 3"),
    entry("Speed all", ".modify speed all %s", "rate"), entry("Speed fly", ".modify speed fly %s", "rate"),
    entry("Morph", ".morph %s", "displayId"), entry("Demorph", ".demorph"),
  }},
  { key="spells", label="Spells", commands={
    entry("Spell list / search", nil, nil, "spells", "Search the MoP client spell table by localized name or ID."),
    entry("Cast", ".cast %s", "spellId"), entry("Aura", ".aura %s", "spellId"), entry("Unaura", ".unaura %s", "spellId"),
    entry("Cooldown one", ".cooldown %s", "spellId"), entry("Cooldown all", ".cooldown"), entry("Learn", ".learn %s", "spellId"),
    entry("Learn all ranks", ".learn %s all", "spellId"), entry("Unlearn", ".unlearn %s", "spellId"),
    entry("Class spells", ".learn all my spells"), entry("Class + talents", ".learn all my class"), entry("All talents", ".learn all my talents"),
    entry("All recipes", ".learn all recipes %s", "profession (optional)"), entry("Max skill", ".maxskill"),
  }},
  { key="items", label="Items", commands={
    entry("Item list / search", nil, nil, "items", "Search the Chipa MoP item index by Korean/localized name or ID."),
    entry("Add item", ".additem %s", "itemId [count]"), entry("Remove item", ".removeitem %s", "itemId [count]"),
    entry("Add item set", ".additemset %s", "itemSetId"), entry("Lookup item", ".lookup item %s", "name"), entry("Lookup itemset", ".lookup itemset %s", "name"),
  }},
  { key="lookup", label="Lookup", commands={
    entry("Item browser", nil, nil, "items"), entry("Quest browser", nil, nil, "quests"), entry("NPC browser", nil, nil, "creatures"), entry("Spell browser", nil, nil, "spells"),
    entry("Area", ".lookup area %s", "text"), entry("Creature", ".lookup creature %s", "text"), entry("Quest", ".lookup quest %s", "text"),
    entry("Spell", ".lookup spell %s", "text"), entry("Skill", ".lookup skill %s", "text"), entry("Teleport", ".lookup tele %s", "text"), entry("Map", ".lookup map %s", "text"),
  }},
  { key="teleport", label="Teleport", commands={
    entry("Teleport list", nil, nil, "teleports", "Korean labels and aliases are mapped to the server's canonical game_tele name."),
    entry("Favorites", nil, nil, "teleportFavorites"), entry("Tele by name", ".tele %s", "server location"), entry("Tele player", ".tele name %s", "player location"),
    entry("Go creature entry", nil, nil, "creatures", "Choose a creature entry from the list; the addon sends .go creature id <entry>."),
    entry("Go creature GUID", ".go creature %s", "spawn GUID"), entry("Go object", ".go object %s", "guid"), entry("Go XYZ", ".go %s", "x y z [map]"), entry("Recall", ".recall"),
  }},
  { key="quest", label="Quest", commands={
    entry("Quest list / search", nil, nil, "quests", "Choose a quest by localized title instead of memorizing the quest ID."),
    entry("Active quest helper", nil, nil, "questhelper"), entry("Lookup quest", ".lookup quest %s", "text"),
    entry("Add by ID", ".quest add %s", "questId"), entry("Complete", ".quest complete %s", "questId"),
    entry("Reward", ".quest reward %s", "questId"), entry("Remove", ".quest remove %s", "questId"),
  }},
  { key="npc", label="NPC", commands={
    entry("NPC / creature list", nil, nil, "creatures", "Search Chipa creature_template by localized name or entry."),
    entry("Lookup creature", ".lookup creature %s", "name"), entry("NPC info", ".npc info"), entry("NPC near", ".npc near %s", "distance"),
    entry("NPC add", ".npc add %s", "entry"), entry("NPC delete", ".npc delete"), entry("NPC move", ".npc move"),
    entry("Set level", ".npc set level %s", "level"), entry("Set faction", ".npc set factionid %s", "factionId"), entry("Set model", ".npc set model %s", "displayId"),
    entry("Respawn", ".respawn"),
  }},
  { key="server", label="Server", commands={
    entry("Save all", ".saveall"), entry("Server info", ".server info"), entry("Server motd", ".server motd"), entry("Reload all", ".reload all"),
  }},
}

function AAM:GetGroup(key)
  for _, group in ipairs(self.CommandGroups or {}) do
    if group.key == key then return group end
  end
end

function AAM:BuildCommand(entry, argument)
  local format = entry and entry[2]
  if not format then return nil, "action" end
  if not string.find(format, "%s", 1, true) then return format end
  argument = (argument or ""):match("^%s*(.-)%s*$")
  if argument == "" then
    if entry[3] and string.find(entry[3], "optional", 1, true) then
      return (format:gsub(" %%s", ""))
    end
    return nil, entry[3] or "argument required"
  end
  return string.format(format, argument)
end

local koLabels = {
  ["GM ON"]="GM 켜기", ["GM OFF"]="GM 끄기", ["Fly ON"]="비행 켜기", ["Fly OFF"]="비행 끄기", ["Visible ON"]="GM 표시", ["Visible OFF"]="GM 숨김",
  ["GM Chat ON"]="GM 채팅 켜기", ["GM Chat OFF"]="GM 채팅 끄기", ["GM List"]="접속 GM 목록", ["Commands"]="명령 목록", ["Save"]="캐릭터 저장", ["Repair"]="장비 수리", ["Bank"]="은행", ["Revive"]="부활",
  ["God ON"]="무적 켜기", ["God OFF"]="무적 끄기", ["Power ON"]="자원 치트 켜기", ["Power OFF"]="자원 치트 끄기", ["Cooldown ON"]="재사용시간 치트 켜기", ["Cooldown OFF"]="재사용시간 치트 끄기",
  ["Casttime ON"]="시전시간 치트 켜기", ["Casttime OFF"]="시전시간 치트 끄기", ["Waterwalk ON"]="수면 걷기 켜기", ["Waterwalk OFF"]="수면 걷기 끄기", ["Explore ON"]="지도 밝히기", ["Explore OFF"]="지도 복원", ["Taxi ON"]="비행경로 모두 열기", ["Taxi OFF"]="비행경로 복원", ["Cheat status"]="치트 상태",
  ["Online players"]="온라인 플레이어 목록", ["Appear"]="플레이어에게 이동", ["Summon"]="플레이어 소환", ["Recall"]="귀환", ["Freeze"]="플레이어 동결", ["Unfreeze"]="동결 해제", ["PInfo"]="플레이어 정보", ["Combat stop"]="전투 종료", ["Level up"]="레벨 올리기", ["Character level"]="레벨 설정", ["Rename"]="이름 변경 허용", ["Customize"]="외형 변경 허용",
  ["Level +1"]="레벨 +1", ["Level +5"]="레벨 +5", ["Level +10"]="레벨 +10", ["Money"]="돈 수정", ["Mana"]="마나 수정", ["Rage"]="분노 수정", ["Energy"]="기력 수정", ["Runic"]="룬마력 수정", ["Honor"]="명예 수정", ["Phase"]="페이즈 수정", ["Scale"]="크기 수정", ["Currency"]="화폐 수정", ["Speed x1"]="이동속도 1배", ["Speed x3"]="이동속도 3배", ["Speed all"]="이동속도 직접 설정", ["Speed fly"]="비행속도 직접 설정", ["Morph"]="변신", ["Demorph"]="변신 해제",
  ["Spell list / search"]="스펠 목록 / 검색", ["Cast"]="시전", ["Aura"]="오라 적용", ["Unaura"]="오라 제거", ["Cooldown one"]="스펠 재사용시간 초기화", ["Cooldown all"]="전체 재사용시간 초기화", ["Learn"]="스펠 배우기", ["Learn all ranks"]="모든 랭크 배우기", ["Unlearn"]="스펠 삭제", ["Class spells"]="직업 스펠 전체", ["Class + talents"]="직업 스펠 + 특성", ["All talents"]="특성 전체", ["All recipes"]="전문기술 도안 전체", ["Max skill"]="숙련도 최대",
  ["Item list / search"]="아이템 목록 / 검색", ["Add item"]="아이템 추가", ["Remove item"]="아이템 제거", ["Add item set"]="아이템 세트 추가", ["Lookup item"]="아이템 서버 검색", ["Lookup itemset"]="아이템세트 서버 검색", ["Item browser"]="아이템 브라우저", ["Quest browser"]="퀘스트 브라우저", ["NPC browser"]="NPC 브라우저", ["Spell browser"]="스펠 브라우저",
  ["Area"]="지역 검색", ["Creature"]="NPC 검색", ["Quest"]="퀘스트 검색", ["Spell"]="스펠 검색", ["Skill"]="기술 검색", ["Teleport"]="순간이동 검색", ["Map"]="맵 검색",
  ["Teleport list"]="순간이동 목록", ["Favorites"]="즐겨찾기", ["Tele by name"]="순간이동 직접 입력", ["Tele player"]="플레이어 위치로 이동", ["Go creature entry"]="NPC 목록에서 이동", ["Go creature GUID"]="NPC Spawn GUID로 이동", ["Go object"]="오브젝트로 이동", ["Go XYZ"]="좌표로 이동",
  ["Quest list / search"]="퀘스트 목록 / 검색", ["Active quest helper"]="진행 퀘스트 도우미", ["Lookup quest"]="퀘스트 서버 검색", ["Add by ID"]="ID로 퀘스트 추가", ["Complete"]="완료", ["Reward"]="보상", ["Remove"]="제거",
  ["NPC / creature list"]="NPC / 크리처 목록", ["Lookup creature"]="NPC 서버 검색", ["NPC info"]="선택 NPC 정보", ["NPC near"]="주변 NPC 검색", ["NPC add"]="NPC 생성", ["NPC delete"]="NPC 삭제", ["NPC move"]="NPC 이동", ["Set level"]="NPC 레벨 설정", ["Set faction"]="NPC 진영 설정", ["Set model"]="NPC 모델 설정", ["Respawn"]="리스폰",
  ["Save all"]="전체 저장", ["Server info"]="서버 정보", ["Server motd"]="서버 MOTD", ["Reload all"]="전체 리로드",
}

function AAM:GetCommandLabel(entry)
  local label = entry and entry[1] or ""
  if GetLocale and GetLocale() == "koKR" then return koLabels[label] or label end
  return label
end
