local ADDON_NAME = ...

GMMPandaria548 = GMMPandaria548 or {}
local AAM = GMMPandaria548
AAM.version = "1.0.0"
AAM.history = AAM.history or {}
AAM.RuntimeModules = AAM.RuntimeModules or {}
AAM.FeatureFrames = AAM.FeatureFrames or {}

function AAM:RegisterRuntimeModule(key, info)
  if type(key) ~= "string" or key == "" then return nil end
  self.RuntimeModules[key] = info or {}
  return self.RuntimeModules[key]
end

function AAM:GetRuntimeModule(key)
  return self.RuntimeModules and self.RuntimeModules[key]
end

function AAM:RegisterSpecialFrame(name)
  if type(name) ~= "string" or name == "" then return end
  UISpecialFrames = UISpecialFrames or {}
  for _, existing in ipairs(UISpecialFrames) do
    if existing == name then return end
  end
  table.insert(UISpecialFrames, name)
end

function AAM:RegisterFeatureFrame(frame)
  if not frame then return end
  for _, existing in ipairs(self.FeatureFrames) do
    if existing == frame then return end
  end
  table.insert(self.FeatureFrames, frame)
end

function AAM:HideFeatureFrames(except)
  for _, frame in ipairs(self.FeatureFrames or {}) do
    if frame and frame ~= except and frame.IsShown and frame:IsShown() then
      frame:Hide()
    end
  end
end

function AAM:ShowFeatureFrame(frame)
  if not frame then return end
  self:HideFeatureFrames(frame)
  if GMMPandaria548Frame and GMMPandaria548Frame ~= frame and GMMPandaria548Frame:IsShown() then
    GMMPandaria548Frame:Hide()
  end
  frame:Show()
end

function AAM:Print(message, isError)
  local prefix = isError and "|cffff6666GM MINI BAR:|r " or "|cffffd24aGM MINI BAR:|r "
  DEFAULT_CHAT_FRAME:AddMessage(prefix .. tostring(message))
end

function AAM:RunAfter(delay, callback)
  delay = tonumber(delay) or 0
  if C_Timer and C_Timer.After then
    C_Timer.After(delay, callback)
    return
  end
  local timer = CreateFrame("Frame")
  local elapsed = 0
  timer:SetScript("OnUpdate", function(self, delta)
    elapsed = elapsed + (delta or 0)
    if elapsed >= delay then
      self:SetScript("OnUpdate", nil)
      callback()
    end
  end)
end

function AAM:SendCommand(command)
  command = type(command) == "string" and command:match("^%s*(.-)%s*$") or ""
  if command == "" then return false end
  if command:sub(1, 1) ~= "." then command = "." .. command end
  SendChatMessage(command, "SAY")
  table.insert(self.history, 1, command)
  while #self.history > 30 do table.remove(self.history) end
  if GMMPandariaDB then GMMPandariaDB.history = self.history end
  self:Print((self.L and self.L.sent or "Sent") .. ": " .. command)
  if self.RefreshHistory then self:RefreshHistory() end
  return true
end

function AAM:ResetPosition()
  local frame = GMMPandaria548Frame
  if frame then
    frame:ClearAllPoints()
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  end
  local toolbar = GMMPandaria548Toolbar
  if toolbar then
    toolbar:ClearAllPoints()
    toolbar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 92)
  end
  if GMMPandariaDB then
    local db = GMMPandariaDB
    db.point, db.relativePoint, db.x, db.y = "CENTER", "CENTER", 0, 0
    db.toolbarPoint, db.toolbarRelativePoint, db.toolbarX, db.toolbarY = nil, nil, nil, nil
  end
end

function AAM:QuestAddSmart(questId)
  questId = tonumber(questId)
  if not questId then return false end
  local token = tostring(questId) .. ":" .. tostring(GetTime and GetTime() or 0)
  self.pendingQuestAdd = { id = questId, started = GetTime and GetTime() or 0, token = token, awaitingStartItem = false }
  local sent = self:SendCommand(".quest add " .. questId)
  self:RunAfter(5.0, function()
    local pending = AAM.pendingQuestAdd
    if pending and pending.token == token then AAM.pendingQuestAdd = nil end
  end)
  return sent
end

local function parseQuestStartItem(message)
  if not message then return nil end
  local item = string.match(message, "%.additem%s+([0-9]+)")
  if item then return tonumber(item) end
  return nil
end

local function completeItemStartedQuestFallback(self, itemId)
  local pending = self.pendingQuestAdd
  if not pending or not itemId then return false end
  self.pendingQuestAdd = nil
  self:Print(string.format((self.L and self.L.questItemStartDetected) or "Item-started quest detected. Adding start item %d.", itemId))
  self:SendCommand(".additem " .. itemId)
  self:Print((self.L and self.L.questUseStartItem) or "Use the added item from your bag to start the quest normally.")
  return true
end

function AAM:HandleSystemMessage(message)
  message = tostring(message or "")
  local pending = self.pendingQuestAdd
  if not pending then return end

  -- MOP_V2_Repack may emit the explanation and the suggested `.additem` as
  -- separate system-chat lines.  Once the first line says the quest starts
  -- from an item, accept the item id from the next line as well.
  local itemId = parseQuestStartItem(message)
  if itemId and pending.awaitingStartItem then
    completeItemStartedQuestFallback(self, itemId)
    return
  end

  local lower = string.lower(message)
  local itemStarted = string.find(lower, "started from item", 1, true)
    or string.find(lower, "start quest in normal way", 1, true)
    or (string.find(message, "아이템", 1, true) and string.find(message, "퀘스트", 1, true))
  if itemStarted then
    if itemId then
      completeItemStartedQuestFallback(self, itemId)
    else
      pending.awaitingStartItem = true
      self:RunAfter(2.0, function()
        local current = AAM.pendingQuestAdd
        if current and current.token == pending.token and current.awaitingStartItem then
          AAM:Print((AAM.L and AAM.L.questItemStartNoId) or "This quest starts from an item. Check the server message for the suggested .additem command.", true)
        end
      end)
    end
  end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("CHAT_MSG_SYSTEM")
eventFrame:SetScript("OnEvent", function(_, event, ...)
  if event == "ADDON_LOADED" then
    local name = ...
    if name ~= ADDON_NAME then return end
    GMMPandariaDB = GMMPandariaDB or {}
    local db = GMMPandariaDB
    db.point = db.point or "CENTER"
    db.relativePoint = db.relativePoint or "CENTER"
    db.x = db.x or 0
    db.y = db.y or 0
    db.lastGroup = db.lastGroup or "general"
    db.lastPage = tonumber(db.lastPage) or 1
    db.history = db.history or {}
    db.dataFavorites = db.dataFavorites or {}
    db.commandFavorites = db.commandFavorites or {}
    db.toolbarVisible = db.toolbarVisible ~= false
    AAM.history = db.history
  elseif event == "CHAT_MSG_SYSTEM" then
    AAM:HandleSystemMessage(...)
  end
end)

SLASH_GMMPANDARIA1 = "/gmmop"
SlashCmdList.GMMPANDARIA = function(msg)
  msg = (msg or ""):match("^%s*(.-)%s*$")
  local lower = string.lower(msg)
  if lower == "show" then
    if AAM.TogglePanel then AAM:TogglePanel(true) elseif GMMPandaria548Frame then GMMPandaria548Frame:Show() end
  elseif lower == "hide" then
    if GMMPandaria548Frame then GMMPandaria548Frame:Hide() end
  elseif lower == "reset" or lower == "resetui" then
    AAM:ResetPosition()
    if AAM.ResetMinimapButton then AAM:ResetMinimapButton() end
    AAM:Print(AAM.L and AAM.L.uiReset or "UI positions reset")
  elseif lower == "icon" then
    if AAM.ToggleMinimapButton then AAM:ToggleMinimapButton() end
  elseif lower == "bar" or lower == "toolbar" then
    if AAM.ToggleToolbar then AAM:ToggleToolbar() end
  elseif lower == "help" then
    AAM:Print("/gmmop - toggle panel")
    AAM:Print("/gmmop show | hide | icon | bar | reset | help")
    AAM:Print("/gmcmd <.command> - send raw GM command")
  elseif msg == "" then
    if AAM.TogglePanel then AAM:TogglePanel()
    elseif GMMPandaria548Frame and GMMPandaria548Frame:IsShown() then GMMPandaria548Frame:Hide()
    elseif GMMPandaria548Frame then GMMPandaria548Frame:Show() end
  else
    AAM:Print(AAM.L and AAM.L.aamopUiOnly or "Use /gmcmd for raw GM commands.")
  end
end

SLASH_GMMPANDARIARAW1 = "/gmcmd"
SlashCmdList.GMMPANDARIARAW = function(msg)
  msg = (msg or ""):match("^%s*(.-)%s*$")
  if msg == "" then
    AAM:Print("/gmcmd <.command>")
    return
  end
  AAM:SendCommand(msg)
end
