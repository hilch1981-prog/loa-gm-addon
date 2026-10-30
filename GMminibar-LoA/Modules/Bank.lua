local AAM=GMMPandaria548
local L=AAM.L or {}

local function ensureBankFrame()
  if not BankFrame then
    if UIParentLoadAddOn then pcall(UIParentLoadAddOn,"Blizzard_BankUI") end
    if not BankFrame and LoadAddOn then pcall(LoadAddOn,"Blizzard_BankUI") end
  end
  return BankFrame ~= nil
end

local function savePoint()
  if not BankFrame or not GMMPandariaDB then return end
  local point,_,relativePoint,x,y=BankFrame:GetPoint(1)
  GMMPandariaDB.bankPoint=point; GMMPandariaDB.bankRelativePoint=relativePoint; GMMPandariaDB.bankX=x; GMMPandariaDB.bankY=y
end

local function prepare()
  if not ensureBankFrame() then return false end
  if AAM.bankPrepared then return true end
  BankFrame:SetMovable(true); BankFrame:EnableMouse(true); BankFrame:SetClampedToScreen(true); BankFrame:RegisterForDrag("LeftButton")
  local oldStart=BankFrame:GetScript("OnDragStart"); local oldStop=BankFrame:GetScript("OnDragStop")
  BankFrame:SetScript("OnDragStart",function(self) if oldStart then pcall(oldStart,self) end; self:StartMoving() end)
  BankFrame:SetScript("OnDragStop",function(self) self:StopMovingOrSizing(); savePoint(); if oldStop then pcall(oldStop,self) end end)
  AAM.bankPrepared=true; return true
end

local function restorePoint()
  if not BankFrame then return end
  local db=GMMPandariaDB
  if db and db.bankPoint then BankFrame:ClearAllPoints(); BankFrame:SetPoint(db.bankPoint,UIParent,db.bankRelativePoint or db.bankPoint,db.bankX or 0,db.bankY or 0) end
end

function AAM:ToggleBank()
  if BankFrame and BankFrame:IsShown() then savePoint(); if HideUIPanel then HideUIPanel(BankFrame) else BankFrame:Hide() end; return end
  if not prepare() then self:Print(L.bankLoadFailed or "Bank UI could not be loaded"); return end
  self.bankOpenRequested=true
  self:SendCommand(".bank")
end

local event=CreateFrame("Frame"); event:RegisterEvent("PLAYER_LOGIN"); event:RegisterEvent("BANKFRAME_OPENED"); event:RegisterEvent("BANKFRAME_CLOSED")
event:SetScript("OnEvent",function(_,e)
  if e=="PLAYER_LOGIN" then prepare(); return end
  if e=="BANKFRAME_OPENED" then AAM.bankOpenRequested=nil; prepare(); restorePoint() elseif e=="BANKFRAME_CLOSED" then AAM.bankOpenRequested=nil; savePoint() end
end)
SLASH_GMMPANDARIABANK1="/gmmbank"; SlashCmdList.GMMPANDARIABANK=function() AAM:ToggleBank() end
AAM:RegisterRuntimeModule("bank",{status="adapted",runtime="Modules/Bank.lua",serverEvidence=".bank -> SendShowBank(player GUID)",gameTestPending=true})
