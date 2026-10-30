local AAM = GMMPandaria548
local L = AAM.L or {}

local PAGE_SIZE = 12
local BUTTON_STYLES = {
  normal={0.025,0.04,0.055,1,0.48,0.43,0.31,1,0.92,0.78,0.28},
  utility={0.025,0.09,0.11,1,0.12,0.63,0.68,1,0.43,0.92,0.95},
  active={0.035,0.16,0.18,1,0.18,0.88,0.92,1,1,0.82,0.24},
  reward={0.035,0.105,0.055,1,0.30,0.67,0.30,1,0.66,0.95,0.45},
  danger={0.13,0.045,0.025,1,0.72,0.25,0.12,1,1,0.48,0.25},
}

local function styleButton(button, name)
  local s=BUTTON_STYLES[name] or BUTTON_STYLES.normal
  button.aamStyle=name or "normal"
  button:SetBackdropColor(s[1],s[2],s[3],s[4]); button:SetBackdropBorderColor(s[5],s[6],s[7],s[8])
  if button.aamLabel then button.aamLabel:SetTextColor(s[9],s[10],s[11]) end
end
local function button(parent,w,h,text)
  local b=CreateFrame("Button",nil,parent); b:SetSize(w,h)
  b:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=12,edgeSize=9,insets={left=2,right=2,top=2,bottom=2}})
  local fs=b:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); fs:SetPoint("LEFT",6,0); fs:SetPoint("RIGHT",-6,0); fs:SetJustifyH("CENTER"); b.aamLabel=fs
  b.SetText=function(self,v) self.aamText=v or ""; self.aamLabel:SetText(self.aamText) end; b.GetText=function(self) return self.aamText or "" end
  b:SetText(text or ""); styleButton(b,"normal")
  b:SetScript("OnMouseDown",function(self) if self:IsEnabled() then self:SetBackdropColor(0.025,0.26,0.30,1) end end)
  b:SetScript("OnMouseUp",function(self) if self:IsEnabled() then styleButton(self,self.aamStyle) end end)
  return b
end
local function editBox(parent,name,w,h)
  local e=CreateFrame("EditBox",name,parent); e:SetSize(w,h); e:SetAutoFocus(false); e:SetFontObject(ChatFontNormal); e:SetTextInsets(7,7,1,1)
  e:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=12,edgeSize=8,insets={left=2,right=2,top=2,bottom=2}})
  e:SetBackdropColor(0.025,0.035,0.045,0.98); e:SetBackdropBorderColor(0.20,0.33,0.38,0.95)
  e:SetScript("OnEditFocusGained",function(self) self:SetBackdropBorderColor(0.15,0.72,0.78,1) end)
  e:SetScript("OnEditFocusLost",function(self) self:SetBackdropBorderColor(0.20,0.33,0.38,0.95) end)
  e:SetScript("OnEscapePressed",function(self) self:ClearFocus() end)
  return e
end

local frame=CreateFrame("Frame","GMMPandaria548DataBrowser",UIParent)
AAM:RegisterSpecialFrame("GMMPandaria548DataBrowser"); AAM:RegisterFeatureFrame(frame)
frame:SetSize(650,470); frame:SetPoint("CENTER"); frame:SetFrameStrata("DIALOG"); frame:SetMovable(true); frame:EnableMouse(true); frame:RegisterForDrag("LeftButton"); frame:SetClampedToScreen(true); frame:Hide()
frame:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=16,edgeSize=14,insets={left=4,right=4,top=4,bottom=4}})
frame:SetBackdropColor(0.018,0.025,0.035,0.98); frame:SetBackdropBorderColor(0.72,0.52,0.18,1)
frame:SetScript("OnDragStart",function(self) self:StartMoving() end); frame:SetScript("OnDragStop",function(self) self:StopMovingOrSizing() end)
local close=CreateFrame("Button",nil,frame,"UIPanelCloseButton"); close:SetPoint("TOPRIGHT",-5,-5)
local title=frame:CreateFontString(nil,"OVERLAY","GameFontNormalLarge"); title:SetPoint("TOPLEFT",16,-14); title:SetTextColor(1,0.78,0.25); title:SetText(L.dataBrowserTitle or "MoP Data Browser")
local subtitle=frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); subtitle:SetPoint("TOPLEFT",16,-37); subtitle:SetTextColor(0.30,0.86,0.86); subtitle:SetText(L.dataBrowserSubtitle or "MOP_V2_Repack localized index")
local back=button(frame,72,20,L.gmMenu or "GM Menu"); back:SetPoint("TOPRIGHT",frame,"TOPRIGHT",-42,-36); styleButton(back,"utility")
back:SetScript("OnClick",function() frame:Hide(); if AAM.TogglePanel then AAM:TogglePanel(true) end end)

local kindDefs={{"Items",L.items or "Items"},{"Quests",L.quests or "Quests"},{"Creatures",L.creatures or "NPC"},{"Teleports",L.teleports or "Teleports"}}
local currentKind="Items"; local favoritesOnly=false; local groupFilter="all"; local offset=0; local results={}; local hasMore=false; local selected=nil; local rowButtons={}; local kindButtons={}; local groupButtons={}

for i,info in ipairs(kindDefs) do
  local b=button(frame,145,22,info[2]); b:SetPoint("TOPLEFT",16+(i-1)*154,-62); b.kind=info[1]
  b:SetScript("OnClick",function(self) currentKind=self.kind; favoritesOnly=false; groupFilter=(currentKind=="Teleports" and "popular" or "all"); offset=0; selected=nil; if AAM.DataBrowserSearch then AAM.DataBrowserSearch:SetText(""); AAM.DataBrowserSearch:ClearFocus() end; AAM:RefreshDataBrowser() end)
  kindButtons[i]=b
end

local search=editBox(frame,"GMMPandaria548DataSearch",360,24); AAM.DataBrowserSearch=search; search:SetPoint("TOPLEFT",16,-94); search:SetMaxLetters(120)
local searchBtn=button(frame,72,24,L.searchButton or "Search"); searchBtn:SetPoint("LEFT",search,"RIGHT",8,0); styleButton(searchBtn,"utility")
local countText=frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); countText:SetWidth(170); countText:SetJustifyH("RIGHT"); countText:SetPoint("RIGHT",frame,"RIGHT",-16,-106)

local groupBar=CreateFrame("Frame",nil,frame); groupBar:SetSize(618,45); groupBar:SetPoint("TOPLEFT",16,-124)
local groupKeys={"favorites","popular","capitals","pandaria","instances","eastern","kalimdor","outland","northrend","other","all"}
local function groupLabel(key)
  if key=="favorites" then return L.favorites or "Favorites" end
  local locale=GetLocale and GetLocale() or "enUS"; local pack=AAM.TeleportGroupNames and (AAM.TeleportGroupNames[locale] or AAM.TeleportGroupNames.enUS)
  return pack and pack[key] or key
end
for i,key in ipairs(groupKeys) do
  local b=button(groupBar,96,19,groupLabel(key)); local col=(i-1)%6; local row=math.floor((i-1)/6); b:SetPoint("TOPLEFT",col*103,-row*22); b.groupKey=key
  b:SetScript("OnClick",function(self) search:ClearFocus(); offset=0; selected=nil; if self.groupKey=="favorites" then favoritesOnly=true; groupFilter="all" else favoritesOnly=false; groupFilter=self.groupKey end; AAM:RefreshDataBrowser() end)
  groupButtons[i]=b
end

local rowsFrame=CreateFrame("Frame",nil,frame); rowsFrame:SetSize(618,260); rowsFrame:SetPoint("TOPLEFT",16,-175)
for i=1,PAGE_SIZE do
  local b=button(rowsFrame,618,20,""); b:SetPoint("TOPLEFT",0,-(i-1)*21); b:RegisterForClicks("LeftButtonUp","RightButtonUp"); b.aamIndex=i
  b.aamLabel:SetJustifyH("LEFT")
  b:SetScript("OnClick",function(self,mouseButton)
    search:ClearFocus(); local row=self.row; if not row then return end
    if currentKind=="Teleports" then
      if mouseButton=="RightButton" then AAM:DataAction("Teleports",row,"favorite"); AAM:RefreshDataBrowser() else AAM:DataAction("Teleports",row,"teleport") end
    else
      selected=row; AAM:RefreshDataBrowserSelection()
    end
  end)
  b:SetScript("OnEnter",function(self)
    if not self.row then return end
    if currentKind=="Items" and GameTooltip then
      GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); local ok=pcall(GameTooltip.SetHyperlink,GameTooltip,"item:"..tostring(self.row[1])); if not ok then GameTooltip:SetText(AAM:DescribeDataRow(currentKind,self.row)) end; GameTooltip:Show()
    else
      GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); GameTooltip:SetText(AAM:GetDataDisplayName(currentKind,self.row),1,0.82,0); GameTooltip:AddLine(AAM:DescribeDataRow(currentKind,self.row),1,1,1,true); GameTooltip:Show()
    end
  end)
  b:SetScript("OnLeave",function() GameTooltip:Hide() end)
  rowButtons[i]=b
end

local selectedText=frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); selectedText:SetWidth(370); selectedText:SetJustifyH("LEFT"); selectedText:SetPoint("BOTTOMLEFT",16,39)
local actionButtons={}
local function action(index,text,style,fn)
  local b=button(frame,82,22,text); b:SetPoint("BOTTOMRIGHT",frame,"BOTTOMRIGHT",-16-(5-index)*88,14); styleButton(b,style or "utility"); b:SetScript("OnClick",function() search:ClearFocus(); if selected then fn(selected) end end); actionButtons[index]=b; return b
end
action(1,L.add or "Add","reward",function(row) AAM:DataAction(currentKind,row,"primary") end)
action(2,L.complete or "Complete","reward",function(row) AAM:DataAction(currentKind,row,"complete") end)
action(3,L.remove or "Remove","danger",function(row) AAM:DataAction(currentKind,row,"remove") end)
action(4,L.serverLookup or "Lookup","utility",function(row) AAM:DataAction(currentKind,row,"lookup") end)
action(5,L.extraAction or "Extra","utility",function(row)
  if currentKind=="Items" then AAM:DataAction(currentKind,row,"primary",5)
  elseif currentKind=="Quests" then AAM:DataAction(currentKind,row,"reward")
  elseif currentKind=="Creatures" then AAM:DataAction(currentKind,row,"spawn") end
end)

local prev=button(frame,54,18,"◀"); prev:SetPoint("BOTTOMLEFT",16,14); local pageText=frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); pageText:SetWidth(75); pageText:SetJustifyH("CENTER"); pageText:SetPoint("LEFT",prev,"RIGHT",2,0); local nextb=button(frame,54,18,"▶"); nextb:SetPoint("LEFT",pageText,"RIGHT",2,0)
prev:SetScript("OnClick",function() search:ClearFocus(); offset=math.max(0,offset-PAGE_SIZE); selected=nil; AAM:RefreshDataBrowser() end); nextb:SetScript("OnClick",function() search:ClearFocus(); if hasMore then offset=offset+PAGE_SIZE; selected=nil; AAM:RefreshDataBrowser() end end)

function AAM:RefreshDataBrowserSelection()
  for _,b in ipairs(rowButtons) do if b.row==selected then styleButton(b,"active") else styleButton(b,"normal") end end
  for _,b in ipairs(actionButtons) do b:Hide() end
  if currentKind=="Teleports" then selectedText:SetText(L.teleportClickHelp or "Left click: teleport | Right click: favorite"); return end
  if not selected then selectedText:SetText(L.chooseFromList or "Choose an entry from the list."); return end
  selectedText:SetText((L.selected or "Selected")..": "..AAM:GetDataDisplayName(currentKind,selected).." ["..tostring(selected[1]).."]")
  if currentKind=="Items" then
    actionButtons[1]:SetText(L.addOne or "Add x1"); actionButtons[1]:Show(); actionButtons[3]:SetText(L.removeOne or "Remove x1"); actionButtons[3]:Show(); actionButtons[4]:Show(); actionButtons[5]:SetText(L.addFive or "Add x5"); actionButtons[5]:Show()
  elseif currentKind=="Quests" then
    actionButtons[1]:SetText(L.add or "Add"); actionButtons[1]:Show(); actionButtons[2]:SetText(L.complete or "Complete"); actionButtons[2]:Show(); actionButtons[3]:Show(); actionButtons[4]:Show(); actionButtons[5]:SetText(L.reward or "Reward"); actionButtons[5]:Show()
  elseif currentKind=="Creatures" then
    actionButtons[1]:SetText(L.goTo or "Go"); actionButtons[1]:Show(); actionButtons[4]:Show(); actionButtons[5]:SetText(L.spawn or "Spawn"); actionButtons[5]:Show()
  end
end

function AAM:RefreshDataBrowser()
  search:ClearFocus()
  local matched; results,hasMore,matched=self:SearchData(currentKind,search:GetText(),PAGE_SIZE,offset,favoritesOnly,groupFilter)
  local first=#results>0 and offset+1 or 0
  local last=offset+#results
  local countFormat=(favoritesOnly and (L.favoritesCount or "%d-%d / favorites %d")) or (L.allCount or "%d-%d / matched %d")
  countText:SetText(string.format(countFormat,first,last,matched or 0))
  pageText:SetText(string.format("%d",math.floor(offset/PAGE_SIZE)+1))
  local isTele=currentKind=="Teleports"; if isTele then groupBar:Show() else groupBar:Hide() end
  for _,b in ipairs(kindButtons) do styleButton(b,b.kind==currentKind and "active" or "normal") end
  if isTele then
    for _,b in ipairs(groupButtons) do local active=(b.groupKey=="favorites" and favoritesOnly) or (not favoritesOnly and b.groupKey==groupFilter); styleButton(b,active and "active" or "normal") end
    subtitle:SetText(L.teleportCanonicalNote or "Localized label/search -> server canonical game_tele name")
  else subtitle:SetText(L.dataBrowserSubtitle or "MOP_V2_Repack localized index") end
  local rowStart=isTele and -175 or -133; rowsFrame:ClearAllPoints(); rowsFrame:SetPoint("TOPLEFT",16,rowStart)
  for i=1,PAGE_SIZE do local b=rowButtons[i]; local row=results[i]; b.row=row; if row then local fav=(currentKind=="Teleports" and self:IsDataFavorite(currentKind,row[1])); b:SetText((fav and "★ " or "")..self:DescribeDataRow(currentKind,row)); b:Show() else b:Hide() end end
  self:RefreshDataBrowserSelection()
end

searchBtn:SetScript("OnClick",function() search:ClearFocus(); offset=0; selected=nil; AAM:RefreshDataBrowser() end)
search:SetScript("OnEnterPressed",function(self) self:ClearFocus(); offset=0; selected=nil; AAM:RefreshDataBrowser() end)
frame:SetScript("OnHide",function() search:ClearFocus(); GameTooltip:Hide() end)

function AAM:ShowDataBrowser(kind, favorites)
  for _,d in ipairs(kindDefs) do if d[1]==kind then currentKind=kind end end
  favoritesOnly=currentKind=="Teleports" and favorites and true or false; groupFilter=currentKind=="Teleports" and (favoritesOnly and "all" or "popular") or "all"; offset=0; selected=nil; search:SetText(""); search:ClearFocus(); self:ShowFeatureFrame(frame); self:RefreshDataBrowser()
end

SLASH_GMMPANDARIADB1="/gmmdb"
SlashCmdList.GMMPANDARIADB=function() if frame:IsShown() then frame:Hide() else AAM:ShowDataBrowser("Teleports",false) end end
