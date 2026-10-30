-- WER REPACK MOP / Lua 5.1 / client 5.4.8 (18414).
local A = GMMPandaria548
A.werToggles = {}
if A.L then
  A.L.title = "GM MINI BAR[판다리아-LoA]"
  A.L.shellTitle = "GM MINI BAR[판다리아-LoA]"
  A.L.shellSubtitle = "WER REPACK MOP · LoA 5.4.8 (18414)"
  A.L.minimapTitle = "GM MINI BAR[판다리아-LoA]"
end
for _, group in ipairs(A.CommandGroups or {}) do
  for _, entry in ipairs(group.commands or {}) do
    if entry.hint then entry.hint = entry.hint:gsub("Chipa", "WER REPACK MOP") end
  end
end

function A:SendCommand(command)
  if type(command) ~= "string" then return false end
  command = command:match("^%s*(.-)%s*$")
  if command == "" then return false end
  if command:sub(1, 1) ~= "." then command = "." .. command end
  if #command > 240 or command:find("%c") or command:sub(1, 2) == ".." then
    self:Print("한 줄의 GM 명령을 240바이트 이내로 입력하세요.", true)
    return false
  end
  -- This core parses commands before guild membership and ordinary dead-chat checks
  -- (src/server/game/Handlers/ChatHandler.cpp). Only revival uses this transport.
  local dead = UnitIsDeadOrGhost and UnitIsDeadOrGhost("player")
  local revive = command == ".revive" or command:match("^%.revive%s")
  SendChatMessage(command, dead and revive and "GUILD" or "SAY")
  self.history = self.history or {}
  table.insert(self.history, 1, command)
  while #self.history > 30 do table.remove(self.history) end
  if GMMPandariaDB then GMMPandariaDB.history = self.history end
  self:Print((self.L and self.L.sent or "전송") .. ": " .. command)
  if self.RefreshHistory then self:RefreshHistory() end
  return true
end

function A:WERCanEdit()
  if InCombatLockdown and InCombatLockdown() then
    self:Print("전투가 끝난 뒤 미니바 설정을 변경하세요.", true)
    return false
  end
  return true
end

function A:WERToggle(key, on, off)
  local nextValue = not self.werToggles[key]
  if self:SendCommand(nextValue and on or off) then
    self.werToggles[key] = nextValue
    return true
  end
  return false
end

-- Module files load after this compatibility layer; adapt revival after load.
function A:WERAdaptModules()
  function self:ReviveSmart(playerName)
    local name = tostring(playerName or ""):match("^%s*(.-)%s*$")
    if name == "" then name = UnitName("player") end
    if not name or name == "" or #name > 60 or name:find("[%s%c]") then
      self:Print("부활시킬 캐릭터 이름을 확인하세요.", true)
      return false
    end
    -- Naming the player keeps an unrelated selected target unchanged.
    return self:SendCommand(".revive " .. name)
  end
  local revive = self:GetRuntimeModule("revive")
  if revive then
    revive.status = "wer-mop-adapted"
    revive.notes = "Named-player revive; GUILD command transport while dead; GUI test pending"
  end
end

A:RegisterRuntimeModule("wer-compat", {
  status = "source-adapted", runtime = "WERCompat.lua", gameTestPending = true,
  notes = "Single-line command validation, session toggle requests, named revival",
})
