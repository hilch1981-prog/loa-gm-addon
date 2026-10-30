local AAM=GMMPandaria548
local L=AAM.L or {}
local PAGE_SIZE=12
local function mk(parent,w,h,text)
  local b=CreateFrame("Button",nil,parent); b:SetSize(w,h); b:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=12,edgeSize=9,insets={left=2,right=2,top=2,bottom=2}}); b:SetBackdropColor(0.025,0.04,0.055,1); b:SetBackdropBorderColor(0.48,0.43,0.31,1)
  local f=b:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); f:SetPoint("LEFT",6,0); f:SetPoint("RIGHT",-6,0); f:SetJustifyH("CENTER"); f:SetTextColor(0.92,0.78,0.28); b.f=f; b.SetText=function(self,v) self.f:SetText(v or "") end; b:SetText(text); return b
end
local function active(b,on) if on then b:SetBackdropColor(0.035,0.16,0.18,1); b:SetBackdropBorderColor(0.18,0.88,0.92,1) else b:SetBackdropColor(0.025,0.04,0.055,1); b:SetBackdropBorderColor(0.48,0.43,0.31,1) end end
local function edit(parent,name,w,h) local e=CreateFrame("EditBox",name,parent); e:SetSize(w,h); e:SetAutoFocus(false); e:SetFontObject(ChatFontNormal); e:SetTextInsets(7,7,1,1); e:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=12,edgeSize=8,insets={left=2,right=2,top=2,bottom=2}}); e:SetBackdropColor(0.025,0.035,0.045,0.98); e:SetBackdropBorderColor(0.20,0.33,0.38,0.95); e:SetScript("OnEscapePressed",function(self) self:ClearFocus() end); return e end

local frame=CreateFrame("Frame","GMMPandaria548PlayerBrowserFrame",UIParent); AAM:RegisterSpecialFrame("GMMPandaria548PlayerBrowserFrame"); AAM:RegisterFeatureFrame(frame)
frame:SetSize(620,445); frame:SetPoint("CENTER"); frame:SetFrameStrata("DIALOG"); frame:SetMovable(true); frame:EnableMouse(true); frame:RegisterForDrag("LeftButton"); frame:SetClampedToScreen(true); frame:Hide(); frame:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=16,edgeSize=14,insets={left=4,right=4,top=4,bottom=4}}); frame:SetBackdropColor(0.018,0.025,0.035,0.98); frame:SetBackdropBorderColor(0.72,0.52,0.18,1); frame:SetScript("OnDragStart",function(self) self:StartMoving() end); frame:SetScript("OnDragStop",function(self) self:StopMovingOrSizing() end)
local close=CreateFrame("Button",nil,frame,"UIPanelCloseButton"); close:SetPoint("TOPRIGHT",-5,-5)
local title=frame:CreateFontString(nil,"OVERLAY","GameFontNormalLarge"); title:SetPoint("TOPLEFT",16,-14); title:SetTextColor(1,0.78,0.25); title:SetText(L.playerBrowserTitle or "Online Player Browser")
local note=frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); note:SetPoint("TOPLEFT",16,-37); note:SetTextColor(0.30,0.86,0.86); note:SetText(L.playerBrowserNote or "Uses the 5.4.8 /who list so player names do not have to be memorized.")
local back=mk(frame,72,20,L.gmMenu or "GM Menu"); back:SetPoint("TOPRIGHT",-42,-36); back:SetScript("OnClick",function() frame:Hide(); if AAM.TogglePanel then AAM:TogglePanel(true) end end)
local search=edit(frame,"GMMPandaria548WhoSearch",330,24); search:SetPoint("TOPLEFT",16,-66); search:SetMaxLetters(60)
local refresh=mk(frame,72,24,L.refresh or "Refresh"); refresh:SetPoint("LEFT",search,"RIGHT",8,0)
local count=frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); count:SetWidth(180); count:SetJustifyH("RIGHT"); count:SetPoint("RIGHT",frame,"RIGHT",-16,-78)
local rows={}; local players={}; local selected=nil; local offset=0
for i=1,PAGE_SIZE do local b=mk(frame,588,21,""); b:SetPoint("TOPLEFT",16,-103-(i-1)*23); b.f:SetJustifyH("LEFT"); b:SetScript("OnClick",function(self) search:ClearFocus(); selected=self.player; AAM:RefreshPlayerSelection() end); rows[i]=b end
local selectedText=frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); selectedText:SetWidth(235); selectedText:SetJustifyH("LEFT"); selectedText:SetPoint("BOTTOMLEFT",16,39)
local actions={}
local function action(i,text,fmt) local b=mk(frame,76,22,text); b:SetPoint("BOTTOMRIGHT",frame,"BOTTOMRIGHT",-16-(5-i)*82,14); b.fmt=fmt; b:SetScript("OnClick",function(self) search:ClearFocus(); if selected then AAM:SendCommand(string.format(self.fmt,selected.name)) end end); actions[i]=b end
action(1,L.appear or "Appear",".appear %s"); action(2,L.summon or "Summon",".summon %s"); action(3,L.reviveButton or "Revive",".revive %s"); action(4,"PInfo",".pinfo %s"); action(5,L.freeze or "Freeze",".freeze %s")
local prev=mk(frame,54,18,"◀"); prev:SetPoint("BOTTOMLEFT",16,14); local page=frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); page:SetWidth(60); page:SetJustifyH("CENTER"); page:SetPoint("LEFT",prev,"RIGHT",2,0); local nextb=mk(frame,54,18,"▶"); nextb:SetPoint("LEFT",page,"RIGHT",2,0)

function AAM:ReadWhoResults()
  players={}
  local selfName=UnitName and UnitName("player")
  if selfName then players[#players+1]={name=selfName,level=(UnitLevel and UnitLevel("player")) or 0,class=(UnitClass and UnitClass("player")) or "",zone=L.selfPlayer or "Self"} end
  if UnitExists and UnitExists("target") and UnitIsPlayer and UnitIsPlayer("target") then local n=UnitName("target"); if n and n~=selfName then players[#players+1]={name=n,level=UnitLevel("target") or 0,class=(UnitClass("target")) or "",zone=L.currentTarget or "Current target"} end end
  local countWho=0; if GetNumWhoResults then countWho=select(1,GetNumWhoResults()) or 0 end
  local seen={}; for _,p in ipairs(players) do seen[p.name]=true end
  for i=1,countWho do local name,guild,level,race,class,zone=GetWhoInfo(i); if name and not seen[name] then players[#players+1]={name=name,guild=guild or "",level=tonumber(level) or 0,race=race or "",class=class or "",zone=zone or ""}; seen[name]=true end end
end
function AAM:RefreshPlayerSelection()
  for _,b in ipairs(rows) do active(b,b.player==selected) end
  if selected then selectedText:SetText((L.selected or "Selected")..": "..selected.name); for _,b in ipairs(actions) do b:Show() end else selectedText:SetText(L.choosePlayer or "Choose a player from the list."); for _,b in ipairs(actions) do b:Hide() end end
end
function AAM:RenderPlayers(reset)
  search:ClearFocus(); if reset then offset=0; selected=nil end; self:ReadWhoResults(); local total=#players; if offset>=total and total>0 then offset=math.max(0,total-PAGE_SIZE) end
  for i=1,PAGE_SIZE do local p=players[offset+i]; local b=rows[i]; b.player=p; if p then b:SetText(string.format("%s  Lv:%d  %s  %s",p.name,p.level or 0,p.class or "",p.zone or "")); b:Show() else b:Hide() end end
  count:SetText(string.format("%d %s",total,L.onlineResults or "results")); page:SetText(total>0 and string.format("%d/%d",math.floor(offset/PAGE_SIZE)+1,math.max(1,math.ceil(total/PAGE_SIZE))) or "0/0"); self:RefreshPlayerSelection()
end
function AAM:RequestWho()
  search:ClearFocus(); if SetWhoToUI then pcall(SetWhoToUI,1) end
  if SendWho then pcall(SendWho,search:GetText() or "") else self:Print(L.whoUnavailable or "/who API unavailable",true) end
  self:RunAfter(1.5,function() if frame:IsShown() then AAM:RenderPlayers(true) end end)
end
refresh:SetScript("OnClick",function() AAM:RequestWho() end); search:SetScript("OnEnterPressed",function(self) self:ClearFocus(); AAM:RequestWho() end)
prev:SetScript("OnClick",function() search:ClearFocus(); offset=math.max(0,offset-PAGE_SIZE); selected=nil; AAM:RenderPlayers(false) end); nextb:SetScript("OnClick",function() search:ClearFocus(); if offset+PAGE_SIZE<#players then offset=offset+PAGE_SIZE; selected=nil; AAM:RenderPlayers(false) end end)
local events=CreateFrame("Frame"); events:RegisterEvent("WHO_LIST_UPDATE"); events:SetScript("OnEvent",function() if frame:IsShown() then AAM:RenderPlayers(true) end end)
frame:SetScript("OnShow",function() AAM:RenderPlayers(true); AAM:RequestWho() end); frame:SetScript("OnHide",function() search:ClearFocus(); if SetWhoToUI then pcall(SetWhoToUI,0) end end)
function AAM:ShowPlayerBrowser() self:ShowFeatureFrame(frame) end
AAM:RegisterRuntimeModule("player-browser",{status="mop-adapted",runtime="Modules/PlayerBrowser.lua",source="MoP 5.4.8 WHO_LIST_UPDATE/GetWhoInfo",gameTestPending=true})
