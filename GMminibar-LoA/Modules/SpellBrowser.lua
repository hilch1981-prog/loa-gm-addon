local AAM=GMMPandaria548
local L=AAM.L or {}
local PAGE_SIZE=12
local MAX_SPELL_ID=180000
local SCAN_PER_FRAME=450

AAM.SpellIndex=AAM.SpellIndex or {}
AAM.SpellScanNext=AAM.SpellScanNext or 1
AAM.SpellScanDone=AAM.SpellScanDone or false

local function lower(v) return string.lower(tostring(v or "")) end
local function trim(v) return tostring(v or ""):match("^%s*(.-)%s*$") end
local function mkButton(parent,w,h,text)
  local b=CreateFrame("Button",nil,parent); b:SetSize(w,h); b:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=12,edgeSize=9,insets={left=2,right=2,top=2,bottom=2}}); b:SetBackdropColor(0.025,0.04,0.055,1); b:SetBackdropBorderColor(0.48,0.43,0.31,1)
  local fs=b:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); fs:SetPoint("LEFT",6,0); fs:SetPoint("RIGHT",-6,0); fs:SetJustifyH("CENTER"); fs:SetTextColor(0.92,0.78,0.28); b.txt=fs; b.SetText=function(self,v) self.txt:SetText(v or "") end; b:SetText(text); return b
end
local function setActive(b,on) if on then b:SetBackdropColor(0.035,0.16,0.18,1); b:SetBackdropBorderColor(0.18,0.88,0.92,1) else b:SetBackdropColor(0.025,0.04,0.055,1); b:SetBackdropBorderColor(0.48,0.43,0.31,1) end end
local function edit(parent,name,w,h) local e=CreateFrame("EditBox",name,parent); e:SetSize(w,h); e:SetAutoFocus(false); e:SetFontObject(ChatFontNormal); e:SetTextInsets(7,7,1,1); e:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=12,edgeSize=8,insets={left=2,right=2,top=2,bottom=2}}); e:SetBackdropColor(0.025,0.035,0.045,0.98); e:SetBackdropBorderColor(0.20,0.33,0.38,0.95); e:SetScript("OnEscapePressed",function(self) self:ClearFocus() end); return e end

local frame=CreateFrame("Frame","GMMPandaria548SpellBrowserFrame",UIParent); AAM:RegisterSpecialFrame("GMMPandaria548SpellBrowserFrame"); AAM:RegisterFeatureFrame(frame)
frame:SetSize(620,450); frame:SetPoint("CENTER"); frame:SetFrameStrata("DIALOG"); frame:SetMovable(true); frame:EnableMouse(true); frame:RegisterForDrag("LeftButton"); frame:SetClampedToScreen(true); frame:Hide(); frame:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=16,edgeSize=14,insets={left=4,right=4,top=4,bottom=4}}); frame:SetBackdropColor(0.018,0.025,0.035,0.98); frame:SetBackdropBorderColor(0.72,0.52,0.18,1); frame:SetScript("OnDragStart",function(self) self:StartMoving() end); frame:SetScript("OnDragStop",function(self) self:StopMovingOrSizing() end)
local close=CreateFrame("Button",nil,frame,"UIPanelCloseButton"); close:SetPoint("TOPRIGHT",-5,-5)
local title=frame:CreateFontString(nil,"OVERLAY","GameFontNormalLarge"); title:SetPoint("TOPLEFT",16,-14); title:SetTextColor(1,0.78,0.25); title:SetText(L.spellBrowserTitle or "MoP Spell Browser")
local note=frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); note:SetPoint("TOPLEFT",16,-37); note:SetTextColor(0.30,0.86,0.86); note:SetText(L.spellBrowserNote or "Builds a localized Spell.dbc index from the 5.4.8 client; no spell ID memorization required.")
local back=mkButton(frame,72,20,L.gmMenu or "GM Menu"); back:SetPoint("TOPRIGHT",-42,-36); back:SetScript("OnClick",function() frame:Hide(); if AAM.TogglePanel then AAM:TogglePanel(true) end end)
local search=edit(frame,"GMMPandaria548SpellSearch",330,24); search:SetPoint("TOPLEFT",16,-65); search:SetMaxLetters(100)
local searchBtn=mkButton(frame,72,24,L.searchButton or "Search"); searchBtn:SetPoint("LEFT",search,"RIGHT",8,0)
local progress=frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); progress:SetWidth(180); progress:SetJustifyH("RIGHT"); progress:SetPoint("RIGHT",frame,"RIGHT",-16,-77)

local rows={}; local matches={}; local selected=nil; local offset=0
for i=1,PAGE_SIZE do
  local b=mkButton(frame,588,21,""); b:SetPoint("TOPLEFT",16,-101-(i-1)*23); b.txt:SetJustifyH("LEFT"); b.idx=i
  b:SetScript("OnClick",function(self) search:ClearFocus(); selected=self.spell; AAM:RefreshSpellBrowserSelection() end)
  b:SetScript("OnEnter",function(self) if not self.spell then return end; GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); if GameTooltip.SetSpellByID then local ok=pcall(GameTooltip.SetSpellByID,GameTooltip,self.spell.id); if not ok then GameTooltip:SetText(self.spell.name) end else GameTooltip:SetText(self.spell.name) end; GameTooltip:Show() end); b:SetScript("OnLeave",function() GameTooltip:Hide() end); rows[i]=b
end

local selectedText=frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); selectedText:SetWidth(250); selectedText:SetJustifyH("LEFT"); selectedText:SetPoint("BOTTOMLEFT",16,40)
local actions={}
local function action(i,text,command)
  local b=mkButton(frame,72,22,text); b:SetPoint("BOTTOMRIGHT",frame,"BOTTOMRIGHT",-16-(5-i)*78,14); b.cmd=command; b:SetScript("OnClick",function(self) search:ClearFocus(); if selected then AAM:SendCommand(string.format(self.cmd,selected.id)) end end); actions[i]=b
end
action(1,L.learn or "Learn",".learn %d"); action(2,L.cast or "Cast",".cast %d"); action(3,L.aura or "Aura",".aura %d"); action(4,L.unlearn or "Unlearn",".unlearn %d"); action(5,L.serverLookup or "Lookup",".lookup spell id %d")
local prev=mkButton(frame,54,18,"◀"); prev:SetPoint("BOTTOMLEFT",16,14); local page=frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); page:SetWidth(60); page:SetJustifyH("CENTER"); page:SetPoint("LEFT",prev,"RIGHT",2,0); local nextb=mkButton(frame,54,18,"▶"); nextb:SetPoint("LEFT",page,"RIGHT",2,0)

local function buildMatches()
  matches={}; local q=trim(search:GetText()); local n=tonumber(q); local ql=lower(q)
  if n then
    local name,rank,icon=GetSpellInfo(n); if name then matches[1]={id=n,name=name,rank=rank or "",icon=icon} end
  else
    for _,s in ipairs(AAM.SpellIndex) do if q=="" or string.find(lower(s.name),ql,1,true) or (s.rank and string.find(lower(s.rank),ql,1,true)) then matches[#matches+1]=s end end
  end
end
function AAM:RefreshSpellBrowserSelection()
  for _,b in ipairs(rows) do setActive(b,b.spell==selected) end
  if selected then selectedText:SetText((L.selected or "Selected")..": ["..selected.id.."] "..selected.name..((selected.rank and selected.rank~="") and (" - "..selected.rank) or "")); for _,b in ipairs(actions) do b:Show() end else selectedText:SetText(L.chooseSpell or "Choose a spell from the list."); for _,b in ipairs(actions) do b:Hide() end end
end
function AAM:RefreshSpellBrowser(reset)
  search:ClearFocus(); if reset then offset=0; selected=nil end; buildMatches(); local total=#matches; if offset>=total and total>0 then offset=math.max(0,total-PAGE_SIZE) end
  for i=1,PAGE_SIZE do local s=matches[offset+i]; local b=rows[i]; b.spell=s; if s then b:SetText(string.format("[%d] %s%s",s.id,s.name,(s.rank and s.rank~="") and ("  "..s.rank) or "")); b:Show() else b:Hide() end end
  page:SetText(total>0 and string.format("%d/%d",math.floor(offset/PAGE_SIZE)+1,math.max(1,math.ceil(total/PAGE_SIZE))) or "0/0")
  local pct=math.floor(math.min(100,(AAM.SpellScanNext-1)/MAX_SPELL_ID*100)); progress:SetText(string.format((L.spellScanProgress or "Index %d%% | %d found"),pct,#AAM.SpellIndex)); self:RefreshSpellBrowserSelection()
end

local scanner=CreateFrame("Frame"); scanner:Hide(); local refreshCounter=0
scanner:SetScript("OnUpdate",function(self)
  if AAM.SpellScanDone then self:Hide(); return end
  local first=AAM.SpellScanNext; local last=math.min(MAX_SPELL_ID,first+SCAN_PER_FRAME-1)
  for id=first,last do local name,rank,icon=GetSpellInfo(id); if name then AAM.SpellIndex[#AAM.SpellIndex+1]={id=id,name=name,rank=rank or "",icon=icon} end end
  AAM.SpellScanNext=last+1; refreshCounter=refreshCounter+1
  if AAM.SpellScanNext>MAX_SPELL_ID then AAM.SpellScanDone=true; self:Hide() end
  if frame:IsShown() and (refreshCounter%12==0 or AAM.SpellScanDone) then AAM:RefreshSpellBrowser(false) end
end)
function AAM:StartSpellIndexScan() if self.SpellScanDone then return end; scanner:Show() end
searchBtn:SetScript("OnClick",function() AAM:RefreshSpellBrowser(true) end); search:SetScript("OnEnterPressed",function(self) self:ClearFocus(); AAM:RefreshSpellBrowser(true) end)
prev:SetScript("OnClick",function() search:ClearFocus(); offset=math.max(0,offset-PAGE_SIZE); selected=nil; AAM:RefreshSpellBrowser(false) end); nextb:SetScript("OnClick",function() search:ClearFocus(); if offset+PAGE_SIZE<#matches then offset=offset+PAGE_SIZE; selected=nil; AAM:RefreshSpellBrowser(false) end end)
frame:SetScript("OnShow",function() AAM:StartSpellIndexScan(); AAM:RefreshSpellBrowser(true) end); frame:SetScript("OnHide",function() search:ClearFocus(); GameTooltip:Hide() end)
function AAM:ShowSpellBrowser() self:ShowFeatureFrame(frame) end
AAM:RegisterRuntimeModule("spell-browser",{status="mop-adapted",runtime="Modules/SpellBrowser.lua",source="MoP 5.4.8 client GetSpellInfo incremental index",gameTestPending=true})
