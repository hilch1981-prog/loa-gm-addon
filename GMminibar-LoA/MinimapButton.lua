local AAM = GMMPandaria548
local L = AAM.L or {}
local DEFAULT_ANGLE = 225
local RADIUS = 78

local function atan2(y, x)
  if math.atan2 then return math.atan2(y, x) end
  if x > 0 then return math.atan(y / x) end
  if x < 0 and y >= 0 then return math.atan(y / x) + math.pi end
  if x < 0 and y < 0 then return math.atan(y / x) - math.pi end
  if x == 0 and y > 0 then return math.pi / 2 end
  if x == 0 and y < 0 then return -math.pi / 2 end
  return 0
end

local function positionButton(button, angle)
  angle = tonumber(angle) or DEFAULT_ANGLE
  local radians = math.rad(angle)
  button:ClearAllPoints()
  button:SetPoint("CENTER", Minimap, "CENTER", math.cos(radians) * RADIUS, math.sin(radians) * RADIUS)
end

function AAM:CreateMinimapButton()
  if self.minimapButton or not Minimap then return end
  GMMPandariaDB = GMMPandariaDB or {}

  local button = CreateFrame("Button", "GMMPandaria548MinimapButton", Minimap)
  button:SetSize(34, 34)
  button:SetFrameStrata("MEDIUM")
  button:SetFrameLevel((Minimap:GetFrameLevel() or 0) + 8)
  button:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp")
  button:RegisterForDrag("LeftButton")
  button:SetMovable(false)
  positionButton(button, GMMPandariaDB.minimapAngle)

  local icon = button:CreateTexture(nil, "ARTWORK")
  icon:SetTexture("Interface\\Icons\\INV_Misc_Gear_01")
  icon:SetSize(23, 23)
  icon:SetPoint("CENTER", 0, 0)
  icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

  local border = button:CreateTexture(nil, "OVERLAY")
  border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
  border:SetSize(54, 54)
  border:SetPoint("TOPLEFT", -10, 10)
  button.aamBorder = border

  local highlight = button:CreateTexture(nil, "HIGHLIGHT")
  highlight:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
  highlight:SetBlendMode("ADD")
  highlight:SetSize(34, 34)
  highlight:SetPoint("CENTER", 0, 0)

  button:SetScript("OnEnter", function(self)
    if self.aamBorder then self.aamBorder:SetVertexColor(0.35, 1, 1, 1) end
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:SetText(L.minimapTitle or "GM MINI BAR", 1, 0.82, 0.18)
    GameTooltip:AddLine(L.minimapLeft or "Left click: GM panel", 1, 1, 1)
    GameTooltip:AddLine(L.minimapRight or "Right click: Teleports", 1, 1, 1)
    GameTooltip:AddLine(L.minimapMiddle or "Middle click: Favorite teleports", 1, 1, 1)
    GameTooltip:AddLine(L.minimapDrag or "Drag: Move around minimap", 0.72, 0.72, 0.72)
    GameTooltip:Show()
  end)
  button:SetScript("OnLeave", function(self)
    if self.aamBorder then self.aamBorder:SetVertexColor(1, 1, 1, 1) end
    GameTooltip:Hide()
  end)
  button:SetScript("OnClick", function(_, mouseButton)
    if mouseButton == "RightButton" then
      if AAM.ShowDataBrowser then AAM:ShowDataBrowser("Teleports", false) end
    elseif mouseButton == "MiddleButton" then
      if AAM.ShowDataBrowser then AAM:ShowDataBrowser("Teleports", true) end
    else
      if AAM.TogglePanel then AAM:TogglePanel() end
    end
  end)

  button:SetScript("OnDragStart", function(self)
    self.aamDragging = true
    self:SetScript("OnUpdate", function(dragButton)
      if not dragButton.aamDragging then return end
      local mx, my = Minimap:GetCenter()
      local cx, cy = GetCursorPosition()
      local scale = UIParent:GetEffectiveScale() or 1
      cx, cy = cx / scale, cy / scale
      if not mx or not my then return end
      local angle = math.deg(atan2(cy - my, cx - mx))
      GMMPandariaDB.minimapAngle = angle
      positionButton(dragButton, angle)
    end)
  end)
  button:SetScript("OnDragStop", function(self)
    self.aamDragging = false
    self:SetScript("OnUpdate", nil)
  end)

  self.minimapButton = button
  if GMMPandariaDB.minimapHidden then button:Hide() else button:Show() end
end

function AAM:ToggleMinimapButton()
  if not self.minimapButton then self:CreateMinimapButton() end
  if not self.minimapButton then return end
  GMMPandariaDB = GMMPandariaDB or {}
  if self.minimapButton:IsShown() then
    self.minimapButton:Hide(); GMMPandariaDB.minimapHidden = true
  else
    self.minimapButton:Show(); GMMPandariaDB.minimapHidden = false
  end
end

function AAM:ResetMinimapButton()
  GMMPandariaDB = GMMPandariaDB or {}
  GMMPandariaDB.minimapAngle = DEFAULT_ANGLE
  GMMPandariaDB.minimapHidden = false
  if not self.minimapButton then self:CreateMinimapButton() end
  if not self.minimapButton then return end
  positionButton(self.minimapButton, DEFAULT_ANGLE)
  self.minimapButton:Show()
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(_, event)
  if event == "PLAYER_LOGIN" then AAM:CreateMinimapButton() end
end)
