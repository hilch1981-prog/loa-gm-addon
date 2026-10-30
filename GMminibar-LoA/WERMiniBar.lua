local A = GMMPandaria548
local icons = "Interface\\Icons\\"
local slots = {
  {"menu", "INV_Misc_Book_09", "GM 메뉴", "menu"},
  {"bank", "INV_Misc_Bag_08", "은행 · Ctrl+클릭: 가방", "bank"},
  {"quests", "INV_Misc_Book_07", "진행 퀘스트 도우미", "questhelper"},
  {"travel", "INV_Misc_Map_01", "순간이동 목록", "teleports"},
  {"revive", "Spell_Holy_Resurrection", "자신 부활", nil, true},
  {"gm", "INV_Misc_Food_54", "GM 모드 요청 켜기 / 끄기", nil, true},
  {"god", "Spell_Holy_PowerWordShield", "무적 요청 켜기 / 끄기", nil, true},
  {"visible", "Ability_Stealth", "GM 숨김 요청 / 표시 요청", nil, true},
  {"kill", "Ability_BackStab", "선택 대상 처치"},
  {"fly", "Spell_Magic_FeatherFall", "자신 비행 요청 켜기 / 끄기", nil, true},
  {"speed", "Ability_Rogue_Sprint", "자신 이동속도 3배 / 1배", nil, true},
  {"items", "INV_Misc_Bag_10_Blue", "아이템 검색", "items"},
  {"spells", "INV_Misc_Book_11", "스펠 검색", "spells"},
  {"profession", "Trade_Engineering", "전문기술 도구", "profession"},
}
A.WERMiniSlots = slots

local function db()
  GMMPandariaDB = GMMPandariaDB or {}
  local d = GMMPandariaDB
  d.werMini = type(d.werMini) == "table" and d.werMini or {}
  d.werMini.bindings = type(d.werMini.bindings) == "table" and d.werMini.bindings or {}
  local scale = tonumber(d.werMini.scale) or 1
  if scale ~= scale then scale = 1 end
  d.werMini.scale = math.max(.65, math.min(1.60, scale))
  return d.werMini, d
end

local function panel(frame)
  frame:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", tile=true, tileSize=16,
    edgeSize=10, insets={left=3,right=3,top=3,bottom=3}})
  frame:SetBackdropColor(.025,.035,.05,.96)
  frame:SetBackdropBorderColor(.75,.55,.19,1)
end

function A:WERApplyBindings()
  if not self.werMini or (InCombatLockdown and InCombatLockdown()) then return end
  local d, saved = db()
  ClearOverrideBindings(self.werMini)
  if saved.toolbarVisible == false then return end
  for key, button in pairs(self.werMini.buttons) do
    local binding = d.bindings[key]
    if type(binding) == "string" and binding ~= "" then
      SetOverrideBindingClick(self.werMini, true, binding, button:GetName(), "LeftButton")
    end
  end
end

function A:WERBindPopup(key)
  if not self:WERCanEdit() then return end
  local popup = self.werBindPopup
  if not popup then
    popup = CreateFrame("Frame", "GMMPandariaBindingDialog", UIParent)
    self.werBindPopup = popup
    popup:SetSize(390,110); popup:SetPoint("CENTER"); popup:SetFrameStrata("DIALOG")
    panel(popup); popup:EnableKeyboard(true)
    popup.text = popup:CreateFontString(nil,"OVERLAY","GameFontNormal")
    popup.text:SetPoint("TOP",0,-16); popup.text:SetWidth(360)
    local hint = popup:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
    hint:SetPoint("TOP",0,-45); hint:SetWidth(360)
    hint:SetText("키를 누르세요. Ctrl/Alt/Shift 조합 가능\nDelete: 해제 · Esc: 취소")
    popup:SetScript("OnKeyDown",function(self,keyName)
      if keyName == "ESCAPE" then self:Hide(); return end
      if not A:WERCanEdit() then self:Hide(); return end
      if keyName:match("^[LR]SHIFT$") or keyName:match("^[LR]CTRL$") or keyName:match("^[LR]ALT$") then return end
      local d = db()
      if keyName == "DELETE" then d.bindings[self.slot] = nil
      else
        local binding = (IsControlKeyDown() and "CTRL-" or "") ..
          (IsAltKeyDown() and "ALT-" or "") .. (IsShiftKeyDown() and "SHIFT-" or "") .. keyName
        for slot, old in pairs(d.bindings) do if old == binding then d.bindings[slot] = nil end end
        d.bindings[self.slot] = binding
      end
      A:WERApplyBindings(); self:Hide()
    end)
    self:RegisterSpecialFrame("GMMPandariaBindingDialog")
  end
  popup.slot = key; popup.text:SetText("미니바 단축키: " .. key); popup:Show()
end

function A:WERMiniAction(key)
  if key == "menu" then if self:WERCanEdit() then self:TogglePanel() end; return end
  if key == "bank" then
    if not self:WERCanEdit() then return end
    if IsControlKeyDown() and ToggleAllBags then ToggleAllBags() else self:OpenAction("bank") end
    return
  end
  for _, slot in ipairs(slots) do
    if slot[1] == key and slot[4] then
      if self:WERCanEdit() then self:OpenAction(slot[4]) end
      return
    end
  end
  if key == "kill" then
    if not UnitExists("target") or UnitIsUnit("target","player") then
      self:Print("처치할 대상을 선택하세요. 자신은 처치하지 않습니다.",true); return
    end
    if UnitIsDeadOrGhost("target") then return end
    return self:SendCommand(".die")
  end
  if not UnitIsUnit("target","player") then
    self:Print("자신 대상 지정이 확인되지 않아 명령을 보내지 않았습니다.",true); return
  end
  if key == "revive" then return self:ReviveSmart()
  elseif key == "gm" then return self:WERToggle(key,".gm on",".gm off")
  elseif key == "god" then return self:SendCommand(".cheat god")
  elseif key == "visible" then return self:WERToggle(key,".gm visible off",".gm visible on")
  elseif key == "fly" then return self:WERToggle(key,".gm fly on",".gm fly off")
  elseif key == "speed" then return self:WERToggle(key,".modify speed all 3",".modify speed all 1") end
end

function A:WERResetMini()
  if not self:WERCanEdit() or not self.werMini then return end
  local d = db()
  local p = d.point
  self.werMini:ClearAllPoints()
  if type(p) == "table" and type(p[1]) == "string" and tonumber(p[2]) and tonumber(p[3]) then
    self.werMini:SetPoint(p[1],UIParent,p[1],p[2],p[3])
  else self.werMini:SetPoint("TOP",UIParent,"TOP",0,-80) end
  self.werMini:SetScale(d.scale)
end

function A:WERSetScale(value)
  if not self:WERCanEdit() then return end
  local d = db(); d.scale = math.max(.65,math.min(1.60,tonumber(value) or 1))
  self:WERResetMini()
end

function A:WERCreateMini()
  if self.werMini or not self:WERCanEdit() then return end
  self:WERAdaptModules()
  local frame = CreateFrame("Frame","GMMPandariaMiniBar",UIParent)
  self.werMini = frame; frame.buttons = {}
  frame:SetSize(554,38); panel(frame); frame:SetMovable(true)
  frame:SetClampedToScreen(true); frame:SetFrameStrata("MEDIUM")
  local grip = CreateFrame("Button",nil,frame)
  grip:SetSize(18,32); grip:SetPoint("LEFT",2,0); grip:RegisterForDrag("LeftButton")
  local mark = grip:CreateFontString(nil,"OVERLAY","GameFontNormal")
  mark:SetPoint("CENTER"); mark:SetText("⋮")
  grip:SetScript("OnDragStart",function() if A:WERCanEdit() then frame:StartMoving() end end)
  grip:SetScript("OnDragStop",function()
    frame:StopMovingOrSizing(); local p,_,_,x,y = frame:GetPoint()
    local d = db(); d.point = {p,x,y}
  end)
  local offset = 22
  for _, slot in ipairs(slots) do
    local key, icon, title, selfTarget = slot[1], slot[2], slot[3], slot[5]
    local width = key == "menu" and 74 or 31
    local button = CreateFrame("Button","GMMPandariaSlot_"..key,frame,"SecureActionButtonTemplate")
    frame.buttons[key] = button; button:SetSize(width,29); button:SetPoint("LEFT",offset,0)
    offset = offset + width + 3; panel(button)
    if key == "menu" then
      local text = button:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
      text:SetPoint("CENTER"); text:SetText("GM 메뉴")
    else
      local texture = button:CreateTexture(nil,"ARTWORK")
      texture:SetPoint("TOPLEFT",3,-3); texture:SetPoint("BOTTOMRIGHT",-3,3)
      texture:SetTexture(icons..icon)
    end
    button:RegisterForClicks("LeftButtonUp","RightButtonUp")
    if selfTarget then button:SetAttribute("type1","target"); button:SetAttribute("unit1","player") end
    button:SetScript("PostClick",function(_,mouse)
      if mouse == "RightButton" then A:WERBindPopup(key)
      elseif mouse == "LeftButton" then A:WERMiniAction(key) end
    end)
    button:SetScript("OnEnter",function(self)
      GameTooltip:SetOwner(self,"ANCHOR_TOP"); GameTooltip:SetText(title,1,.82,0)
      local d = db(); local binding = d.bindings[key]
      GameTooltip:AddLine("우클릭: 단축키 설정" .. (binding and (" · "..binding) or ""),1,1,1)
      if selfTarget then GameTooltip:AddLine("클릭 시 자신을 대상으로 지정합니다.",.7,.8,1,true) end
      GameTooltip:Show()
    end)
    button:SetScript("OnLeave",function() GameTooltip:Hide() end)
  end
  -- Width follows the actual number of slots, leaving room for scale controls.
  frame:SetWidth(offset + 24)
  for index, label in ipairs({"+","−"}) do
    local delta = index == 1 and .05 or -.05
    local button = CreateFrame("Button",nil,frame,"UIPanelButtonTemplate")
    button:SetSize(20,15); button:SetPoint("TOPRIGHT",-3,index == 1 and -3 or -20)
    button:SetText(label)
    button:SetScript("OnClick",function() local d = db(); A:WERSetScale(d.scale + delta) end)
  end
  if GMMPandaria548Toolbar then GMMPandaria548Toolbar:Hide() end
  self:WERResetMini()
  local _, saved = db()
  if saved.toolbarVisible == false then frame:Hide() else frame:Show() end
  self:WERApplyBindings()
end

function A:ToggleToolbar()
  if not self:WERCanEdit() then return end
  if not self.werMini then self:WERCreateMini() end
  local _, saved = db()
  saved.toolbarVisible = not self.werMini:IsShown()
  if saved.toolbarVisible then self.werMini:Show() else self.werMini:Hide() end
  self:WERApplyBindings()
end

local originalReset = A.ResetPosition
function A:ResetPosition()
  if not self:WERCanEdit() then return end
  originalReset(self)
  local d = db(); d.point = nil; d.scale = 1
  self:WERResetMini()
end

local event = CreateFrame("Frame")
event:RegisterEvent("PLAYER_LOGIN"); event:RegisterEvent("PLAYER_REGEN_ENABLED")
event:RegisterEvent("PLAYER_REGEN_DISABLED")
event:SetScript("OnEvent",function(_,name)
  if name == "PLAYER_REGEN_DISABLED" then
    if A.werBindPopup then A.werBindPopup:Hide() end
  else
    if not A.werMini then A:WERCreateMini() else A:WERApplyBindings() end
    if GMMPandaria548Toolbar then GMMPandaria548Toolbar:Hide() end
  end
end)

SLASH_GMMPANDARIAMINI1 = "/gmbar"; SLASH_GMMPANDARIAMINI2 = "/gmminibar"
SlashCmdList.GMMPANDARIAMINI = function(text)
  text = tostring(text or ""):match("^%s*(.-)%s*$"):lower()
  if text == "reset" then A:ResetPosition()
  elseif text == "hide" or text == "show" then
    if not A:WERCanEdit() then return end
    local _, saved = db(); saved.toolbarVisible = text == "show"
    if not A.werMini then A:WERCreateMini()
    elseif saved.toolbarVisible then A.werMini:Show() else A.werMini:Hide() end
    A:WERApplyBindings()
  elseif text:match("^scale%s+") then A:WERSetScale(tonumber(text:match("^scale%s+(.+)$")))
  elseif text == "" then A:TogglePanel()
  else A:Print("/gmbar · /gmbar show|hide|reset · /gmbar scale 0.65~1.60") end
end

A:RegisterRuntimeModule("wer-minibar", {
  status="implemented", runtime="WERMiniBar.lua", gameTestPending=true,
  notes="14 slots, secure self targeting, drag/scale, saved per-slot bindings",
})
