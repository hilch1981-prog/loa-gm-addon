local AAM = GMMPandaria548
local L = AAM.L or {}
local PAGE_SIZE = 10

local function trim(v) return tostring(v or ""):match("^%s*(.-)%s*$") end
local function lower(v) return string.lower(tostring(v or "")) end
local function makeButton(parent, w, h, text)
  local b = CreateFrame("Button", nil, parent)
  b:SetSize(w, h)
  b:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background", edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", tile=true, tileSize=12, edgeSize=9, insets={left=2,right=2,top=2,bottom=2}})
  b:SetBackdropColor(0.025,0.04,0.055,1); b:SetBackdropBorderColor(0.48,0.43,0.31,1)
  local f=b:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); f:SetPoint("LEFT",6,0); f:SetPoint("RIGHT",-6,0); f:SetJustifyH("CENTER"); f:SetTextColor(0.92,0.78,0.28)
  b.label=f; b.SetText=function(self,v) self.label:SetText(v or "") end; b:SetText(text or "")
  return b
end
local function setActive(b, on)
  if on then b:SetBackdropColor(0.035,0.16,0.18,1); b:SetBackdropBorderColor(0.18,0.88,0.92,1)
  else b:SetBackdropColor(0.025,0.04,0.055,1); b:SetBackdropBorderColor(0.48,0.43,0.31,1) end
end
local function makeEdit(parent, name, w, h)
  local e=CreateFrame("EditBox",name,parent); e:SetSize(w,h); e:SetAutoFocus(false); e:SetFontObject(ChatFontNormal); e:SetTextInsets(7,7,1,1)
  e:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=12,edgeSize=8,insets={left=2,right=2,top=2,bottom=2}})
  e:SetBackdropColor(0.025,0.035,0.045,0.98); e:SetBackdropBorderColor(0.20,0.33,0.38,0.95)
  e:SetScript("OnEscapePressed",function(self) self:ClearFocus() end)
  return e
end

local function questIdFromLog(index)
  -- MoP 5.4.8 still uses the pre-6.0 quest-log contract:
  -- title, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID.
  -- Do not use the 6.0+ return ordering here.
  local title, level, _, _, isHeader, _, isComplete, _, questID = GetQuestLogTitle(index)
  if isHeader then return nil, title, level, isComplete, true end
  if questID and tonumber(questID) and tonumber(questID) > 0 then return tonumber(questID), title, level, isComplete, false end
  if GetQuestLink then
    local ok, link = pcall(GetQuestLink, index)
    if ok and link then
      local id = tonumber(string.match(link, "quest:(%d+)"))
      if id then return id, title, level, isComplete, false end
    end
  end
  return nil, title, level, isComplete, false
end

function AAM:GetActiveQuestRows(filter)
  local out, q = {}, lower(trim(filter))
  local count = GetNumQuestLogEntries and GetNumQuestLogEntries() or 0
  for i=1,count do
    local id,title,level,complete,header=questIdFromLog(i)
    if not header and id then
      if q=="" or tonumber(q)==id or string.find(lower(title),q,1,true) then
        out[#out+1]={id=id,title=title or ("Quest "..id),level=tonumber(level) or 0,complete=complete,logIndex=i}
      end
    end
  end
  return out
end

local frame=CreateFrame("Frame","GMMPandaria548QuestHelperFrame",UIParent)
AAM:RegisterSpecialFrame("GMMPandaria548QuestHelperFrame"); AAM:RegisterFeatureFrame(frame)
frame:SetSize(620,445); frame:SetPoint("CENTER"); frame:SetFrameStrata("DIALOG"); frame:SetMovable(true); frame:EnableMouse(true); frame:RegisterForDrag("LeftButton"); frame:SetClampedToScreen(true); frame:Hide()
frame:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=16,edgeSize=14,insets={left=4,right=4,top=4,bottom=4}})
frame:SetBackdropColor(0.018,0.025,0.035,0.98); frame:SetBackdropBorderColor(0.72,0.52,0.18,1)
frame:SetScript("OnDragStart",function(self) self:StartMoving() end); frame:SetScript("OnDragStop",function(self) self:StopMovingOrSizing() end)
local close=CreateFrame("Button",nil,frame,"UIPanelCloseButton"); close:SetPoint("TOPRIGHT",-5,-5)
local title=frame:CreateFontString(nil,"OVERLAY","GameFontNormalLarge"); title:SetPoint("TOPLEFT",16,-14); title:SetTextColor(1,0.78,0.25); title:SetText(L.questHelperTitle or "MoP Quest Helper")
local note=frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); note:SetPoint("TOPLEFT",16,-37); note:SetTextColor(0.30,0.86,0.86); note:SetText(L.activeQuests or "Active quests")
local back=makeButton(frame,72,20,L.gmMenu or "GM Menu"); back:SetPoint("TOPRIGHT",-42,-36); back:SetScript("OnClick",function() frame:Hide(); if AAM.TogglePanel then AAM:TogglePanel(true) end end)
local search=makeEdit(frame,"GMMPandaria548QuestSearch",300,24); search:SetPoint("TOPLEFT",16,-66); search:SetMaxLetters(120)
local refresh=makeButton(frame,72,24,L.refresh or "Refresh"); refresh:SetPoint("LEFT",search,"RIGHT",8,0)
local allQuests=makeButton(frame,120,24,L.allQuests or "All quests"); allQuests:SetPoint("LEFT",refresh,"RIGHT",8,0); allQuests:SetBackdropColor(0.025,0.09,0.11,1); allQuests:SetBackdropBorderColor(0.12,0.63,0.68,1)
local countText=frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); countText:SetWidth(82); countText:SetJustifyH("RIGHT"); countText:SetPoint("RIGHT",frame,"RIGHT",-16,-78)

local rows,data={},{}; local selected=nil; local offset=0
for i=1,PAGE_SIZE do
  local b=makeButton(frame,588,23,""); b:SetPoint("TOPLEFT",16,-105-(i-1)*25); b.label:SetJustifyH("LEFT"); b.idx=i
  b:SetScript("OnClick",function(self) search:ClearFocus(); selected=self.quest; AAM:RefreshQuestHelperSelection() end)
  rows[i]=b
end

local selectedText=frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); selectedText:SetWidth(245); selectedText:SetJustifyH("LEFT"); selectedText:SetPoint("BOTTOMLEFT",16,40)
local actions={}
local function action(i,text,fn)
  local b=makeButton(frame,76,22,text); b:SetPoint("BOTTOMRIGHT",frame,"BOTTOMRIGHT",-16-(4-i)*82,14)
  b:SetScript("OnClick",function() search:ClearFocus(); if selected then fn(selected) end end); actions[i]=b
end
action(1,L.complete or "Complete",function(q) AAM:SendCommand(".quest complete "..q.id) end)
action(2,L.reward or "Reward",function(q) AAM:SendCommand(".quest reward "..q.id) end)
action(3,L.remove or "Remove",function(q) AAM:SendCommand(".quest remove "..q.id) end)
action(4,L.serverLookup or "Lookup",function(q) AAM:SendCommand(".lookup quest "..q.id) end)
local prev=makeButton(frame,54,18,"◀"); prev:SetPoint("BOTTOMLEFT",16,14)
local page=frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); page:SetWidth(60); page:SetJustifyH("CENTER"); page:SetPoint("LEFT",prev,"RIGHT",2,0)
local nextb=makeButton(frame,54,18,"▶"); nextb:SetPoint("LEFT",page,"RIGHT",2,0)

function AAM:RefreshQuestHelperSelection()
  for _,b in ipairs(rows) do setActive(b,b.quest==selected) end
  if selected then
    selectedText:SetText((L.selected or "Selected")..": ["..selected.id.."] "..selected.title)
    for _,b in ipairs(actions) do b:Show() end
  else
    selectedText:SetText(L.chooseFromList or "Choose an entry from the list.")
    for _,b in ipairs(actions) do b:Hide() end
  end
end

function AAM:RefreshQuestHelper(reset)
  search:ClearFocus(); if reset then offset=0; selected=nil end
  data=self:GetActiveQuestRows(search:GetText()); local total=#data
  if offset>=total and total>0 then offset=math.max(0,total-PAGE_SIZE) end
  for i=1,PAGE_SIZE do
    local q=data[offset+i]; local b=rows[i]; b.quest=q
    if q then
      local state=(q.complete==1 or q.complete==true) and ("  |cff66ff66"..(L.complete or "Complete").."|r") or ""
      b:SetText(string.format("[%d] %s  Lv:%d%s",q.id,q.title,q.level,state)); b:Show()
    else b:Hide() end
  end
  countText:SetText(string.format("%d",total)); page:SetText(total>0 and string.format("%d/%d",math.floor(offset/PAGE_SIZE)+1,math.max(1,math.ceil(total/PAGE_SIZE))) or "0/0")
  self:RefreshQuestHelperSelection()
end

refresh:SetScript("OnClick",function() AAM:RefreshQuestHelper(true) end)
allQuests:SetScript("OnClick",function() search:ClearFocus(); if AAM.ShowDataBrowser then AAM:ShowDataBrowser("Quests",false) end end)
search:SetScript("OnEnterPressed",function(self) self:ClearFocus(); AAM:RefreshQuestHelper(true) end)
prev:SetScript("OnClick",function() search:ClearFocus(); offset=math.max(0,offset-PAGE_SIZE); selected=nil; AAM:RefreshQuestHelper(false) end)
nextb:SetScript("OnClick",function() search:ClearFocus(); if offset+PAGE_SIZE<#data then offset=offset+PAGE_SIZE; selected=nil; AAM:RefreshQuestHelper(false) end end)
frame:SetScript("OnShow",function() AAM:RefreshQuestHelper(true) end)
frame:SetScript("OnHide",function() search:ClearFocus() end)
local events=CreateFrame("Frame"); events:RegisterEvent("QUEST_LOG_UPDATE"); events:SetScript("OnEvent",function() if frame:IsShown() then AAM:RefreshQuestHelper(false) end end)

function AAM:ShowQuestHelper() self:ShowFeatureFrame(frame) end
SLASH_GMMPANDARIAQUEST1="/gmmquest"
SlashCmdList.GMMPANDARIAQUEST=function() if frame:IsShown() then frame:Hide() else AAM:ShowQuestHelper() end end

AAM:RegisterRuntimeModule("quest-helper",{
  status="mop-adapted",
  runtime="Modules/QuestHelper.lua",
  source="MoP quest log + MOP_V2_Repack quest commands; item-start fallback in Core.lua",
  gameTestPending=true,
})
