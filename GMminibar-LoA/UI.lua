local AAM=GMMPandaria548
local L=AAM.L or {}
local COMMANDS_PER_PAGE=20

local BUTTON_STYLES={
 normal={0.025,0.04,0.055,1,0.48,0.43,0.31,1,0.92,0.78,0.28},
 utility={0.025,0.09,0.11,1,0.12,0.63,0.68,1,0.43,0.92,0.95},
 reward={0.035,0.105,0.055,1,0.30,0.67,0.30,1,0.66,0.95,0.45},
 danger={0.13,0.045,0.025,1,0.72,0.25,0.12,1,1,0.48,0.25},
 active={0.035,0.16,0.18,1,0.18,0.88,0.92,1,1,0.82,0.24},
 disabled={0.025,0.03,0.035,0.94,0.14,0.16,0.18,0.8,0.40,0.42,0.43},
}
local function style(b,name)
 local s=BUTTON_STYLES[name] or BUTTON_STYLES.normal; b.aamStyle=name or "normal"; b:SetBackdropColor(s[1],s[2],s[3],s[4]); b:SetBackdropBorderColor(s[5],s[6],s[7],s[8]); if b.aamLabel then b.aamLabel:SetTextColor(s[9],s[10],s[11]) end
end
local function makeButton(parent,w,h,text)
 local b=CreateFrame("Button",nil,parent); b:SetSize(w,h); b:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=12,edgeSize=9,insets={left=2,right=2,top=2,bottom=2}})
 local f=b:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); f:SetPoint("LEFT",6,0); f:SetPoint("RIGHT",-6,0); f:SetJustifyH("CENTER"); b.aamLabel=f; b.SetText=function(self,v) self.aamText=v or ""; self.aamLabel:SetText(self.aamText) end; b.GetText=function(self) return self.aamText or "" end; b:SetText(text or ""); style(b,"normal")
 b:SetScript("OnMouseDown",function(self) if self:IsEnabled() then self:SetBackdropColor(0.025,0.26,0.30,1) end end); b:SetScript("OnMouseUp",function(self) if self:IsEnabled() then style(self,self.aamStyle) end end); return b
end
local function makeEdit(parent,name,w,h)
 local e=CreateFrame("EditBox",name,parent); e:SetSize(w,h); e:SetAutoFocus(false); e:SetFontObject(ChatFontNormal); e:SetTextInsets(7,7,1,1); e:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=12,edgeSize=8,insets={left=2,right=2,top=2,bottom=2}}); e:SetBackdropColor(0.025,0.035,0.045,0.98); e:SetBackdropBorderColor(0.20,0.33,0.38,0.95); e:SetScript("OnEditFocusGained",function(self) self:SetBackdropBorderColor(0.15,0.72,0.78,1) end); e:SetScript("OnEditFocusLost",function(self) self:SetBackdropBorderColor(0.20,0.33,0.38,0.95) end); e:SetScript("OnEscapePressed",function(self) self:ClearFocus() end); return e
end
local function semantic(entry)
 if entry.action then return "utility" end
 local c=string.lower(entry[2] or "")
 if string.find(c,".die",1,true) or string.find(c,"delete",1,true) or string.find(c,"shutdown",1,true) then return "danger" end
 if string.find(c,".additem",1,true) or string.find(c,".learn",1,true) or string.find(c,".levelup",1,true) or string.find(c,".revive",1,true) then return "reward" end
 if string.find(c,".gm ",1,true) or string.find(c,".cheat",1,true) or string.find(c,".modify speed",1,true) then return "utility" end
 return "normal"
end
local function iconFor(entry)
 local a=entry.action; local c=string.lower(entry[2] or "")
 if a=="teleports" or a=="teleportFavorites" then return "Interface\\Icons\\INV_Misc_Map_01" end
 if a=="items" then return "Interface\\Icons\\INV_Misc_Bag_10_Blue" end
 if a=="quests" or a=="questhelper" then return "Interface\\Icons\\INV_Misc_Book_07" end
 if a=="creatures" then return "Interface\\Icons\\INV_Misc_Head_Dragon_01" end
 if a=="spells" then return "Interface\\Icons\\INV_Misc_Book_09" end
 if a=="players" then return "Interface\\Icons\\INV_Misc_GroupLooking" end
 if a=="bank" then return "Interface\\Icons\\INV_Misc_Bag_10_Blue" end
 if a=="revive" or string.find(c,".revive",1,true) then return "Interface\\Icons\\Spell_Holy_Resurrection" end
 if string.find(c,"fly",1,true) then return "Interface\\Icons\\Ability_Druid_FlightForm" end
 if string.find(c,"speed",1,true) then return "Interface\\Icons\\Ability_Rogue_Sprint" end
 if string.find(c,".additem",1,true) then return "Interface\\Icons\\INV_Misc_Bag_10_Blue" end
 if string.find(c,".learn",1,true) then return "Interface\\Icons\\INV_Misc_Book_09" end
 if string.find(c,".quest",1,true) then return "Interface\\Icons\\INV_Misc_Note_02" end
 if string.find(c,".npc",1,true) then return "Interface\\Icons\\INV_Misc_Head_Dragon_01" end
 return "Interface\\Icons\\INV_Misc_Gear_01"
end

local frame=CreateFrame("Frame","GMMPandaria548Frame",UIParent); AAM:RegisterSpecialFrame("GMMPandaria548Frame")
frame:SetSize(520,405); frame:SetPoint("CENTER"); frame:SetFrameStrata("DIALOG"); frame:SetMovable(true); frame:EnableMouse(true); frame:SetClampedToScreen(true); frame:RegisterForDrag("LeftButton"); frame:Hide(); frame:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=16,edgeSize=14,insets={left=4,right=4,top=4,bottom=4}}); frame:SetBackdropColor(0.018,0.025,0.035,0.97); frame:SetBackdropBorderColor(0.72,0.52,0.18,1)
frame:SetScript("OnDragStart",function(self) self:StartMoving() end); frame:SetScript("OnDragStop",function(self) self:StopMovingOrSizing(); local p,_,rp,x,y=self:GetPoint(); GMMPandariaDB=GMMPandariaDB or {}; GMMPandariaDB.point=p; GMMPandariaDB.relativePoint=rp; GMMPandariaDB.x=x; GMMPandariaDB.y=y end)
local creatorIcon=frame:CreateTexture(nil,"ARTWORK"); creatorIcon:SetTexture("Interface\\Icons\\INV_Misc_Gear_01"); creatorIcon:SetSize(28,28); creatorIcon:SetPoint("TOPLEFT",14,-7)
local title=frame:CreateFontString(nil,"OVERLAY","GameFontNormalLarge"); title:SetPoint("TOPLEFT",48,-12); title:SetTextColor(1,0.78,0.25); title:SetText(L.shellTitle or "GM Addon [Pandaria 5.4.8]")
local subtitle=frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); subtitle:SetPoint("TOPLEFT",48,-34); subtitle:SetTextColor(0.30,0.86,0.86); subtitle:SetText((L.shellSubtitle or "MOP_V2_Repack edition").."  |  "..AAM.version)
local close=CreateFrame("Button",nil,frame,"UIPanelCloseButton"); close:SetPoint("TOPRIGHT",-5,-5)
local line=frame:CreateTexture(nil,"ARTWORK"); line:SetTexture(0.72,0.52,0.18,0.85); line:SetPoint("TOPLEFT",12,-53); line:SetPoint("TOPRIGHT",-12,-53); line:SetHeight(1)

local groupLabelKeys={general="groupGeneral",cheats="groupCheats",player="groupPlayer",modify="groupModify",spells="groupSpells",items="groupItems",lookup="groupLookup",teleport="groupTeleport",quest="groupQuest",npc="groupNpc",server="groupServer"}
local tabs={}; local commandButtons={}; local currentGroup="general"; local currentPage=1
local function localizedGroup(g) return L[groupLabelKeys[g.key] or ""] or g.label end

local function hideTooltip() GameTooltip:Hide() end
local function showTooltip(self)
 local e=self.entry; if not e then return end; GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); GameTooltip:SetText(AAM:GetCommandLabel(e),1,0.82,0); if e.hint then GameTooltip:AddLine(e.hint,1,1,1,true) end; if e[3] then GameTooltip:AddLine((L.arg or "Argument")..": "..e[3],0.55,0.88,0.95,true) end; if self.favorite then GameTooltip:AddLine(L.rightClickUnfavorite or "Right click: remove quick slot",1,0.72,0.25) else GameTooltip:AddLine(L.rightClickFavorite or "Right click: add quick slot",0.72,0.72,0.72) end; GameTooltip:Show()
end

function AAM:GetCommandFavorites()
 GMMPandariaDB=GMMPandariaDB or {}; GMMPandariaDB.commandFavorites=GMMPandariaDB.commandFavorites or {}; return GMMPandariaDB.commandFavorites
end
function AAM:EntryKey(e) return e.action and ("action:"..e.action) or ("cmd:"..tostring(e[2] or e[1])) end
function AAM:FindEntry(key)
 for _,g in ipairs(self.CommandGroups or {}) do for _,e in ipairs(g.commands or {}) do if self:EntryKey(e)==key then return e end end end
end
function AAM:IsEntryFavorite(e) local key=self:EntryKey(e); for i,v in ipairs(self:GetCommandFavorites()) do if v==key then return i end end end
function AAM:ToggleEntryFavorite(e)
 local fav=self:GetCommandFavorites(); local i=self:IsEntryFavorite(e); if i then table.remove(fav,i) else table.insert(fav,1,self:EntryKey(e)); while #fav>2 do table.remove(fav) end end; if self.RefreshQuickSlots then self:RefreshQuickSlots() end; if self.RenderCommands then self:RenderCommands(currentGroup,currentPage) end
end

local prompt=CreateFrame("Frame","GMMPandaria548ArgumentFrame",UIParent); AAM:RegisterSpecialFrame("GMMPandaria548ArgumentFrame"); prompt:SetSize(390,185); prompt:SetPoint("CENTER",UIParent,"CENTER",0,70); prompt:SetFrameStrata("FULLSCREEN_DIALOG"); prompt:EnableMouse(true); prompt:Hide(); prompt:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=16,edgeSize=14,insets={left=4,right=4,top=4,bottom=4}}); prompt:SetBackdropColor(0.018,0.025,0.035,0.99); prompt:SetBackdropBorderColor(0.95,0.58,0.10,1)
local pt=prompt:CreateFontString(nil,"OVERLAY","GameFontNormalLarge"); pt:SetPoint("TOPLEFT",16,-15); pt:SetTextColor(1,0.82,0.18)
local pd=prompt:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); pd:SetPoint("TOPLEFT",16,-45); pd:SetWidth(358); pd:SetHeight(48); pd:SetJustifyH("LEFT"); pd:SetJustifyV("TOP")
local pe=makeEdit(prompt,"GMMPandaria548ArgumentEdit",358,24); pe:SetPoint("TOPLEFT",16,-100); pe:SetMaxLetters(180)
local pr=makeButton(prompt,170,24,L.run or "Run"); pr:SetPoint("BOTTOMLEFT",16,15); style(pr,"reward"); local pc=makeButton(prompt,170,24,L.cancel or "Cancel"); pc:SetPoint("BOTTOMRIGHT",-16,15); style(pc,"danger")
local pendingEntry=nil
local function submitPrompt()
 if not pendingEntry then prompt:Hide(); return end; local value=pe:GetText() or ""; pe:ClearFocus(); local cmd,need=AAM:BuildCommand(pendingEntry,value); if not cmd then pd:SetText((L.argumentRequired or "Argument required")..": "..tostring(need)); pe:SetFocus(); return end; prompt:Hide(); if pendingEntry[2]==".quest add %s" and tonumber(value) and AAM.QuestAddSmart then AAM:QuestAddSmart(tonumber(value)) else AAM:SendCommand(cmd) end; pendingEntry=nil
end
pr:SetScript("OnClick",submitPrompt); pc:SetScript("OnClick",function() pe:ClearFocus(); prompt:Hide(); pendingEntry=nil end); pe:SetScript("OnEnterPressed",submitPrompt); pe:SetScript("OnEscapePressed",function(self) self:ClearFocus(); prompt:Hide(); pendingEntry=nil end)

function AAM:OpenAction(action)
 if action=="teleports" then self:ShowDataBrowser("Teleports",false)
 elseif action=="teleportFavorites" then self:ShowDataBrowser("Teleports",true)
 elseif action=="items" then self:ShowDataBrowser("Items",false)
 elseif action=="quests" then self:ShowDataBrowser("Quests",false)
 elseif action=="questhelper" then if self.ShowQuestHelper then self:ShowQuestHelper() end
 elseif action=="creatures" then self:ShowDataBrowser("Creatures",false)
 elseif action=="spells" then if self.ShowSpellBrowser then self:ShowSpellBrowser() end
 elseif action=="players" then if self.ShowPlayerBrowser then self:ShowPlayerBrowser() end
 elseif action=="bank" then if self.ToggleBank then self:ToggleBank() end
 elseif action=="revive" then if self.ReviveSmart then self:ReviveSmart() end
 elseif action=="profession" then if self.ShowProfessionInfo then self:ShowProfessionInfo() end end
end
function AAM:ExecuteEntry(e)
 if not e then return end; if e.action then self:OpenAction(e.action); return end
 local fmt=e[2]; if not fmt then return end
 if not string.find(fmt,"%s",1,true) then self:SendCommand(fmt); return end
 local hint=string.lower(e[3] or "")
 if string.find(hint,"player",1,true) and UnitExists and UnitExists("target") and UnitIsPlayer and UnitIsPlayer("target") then local name=UnitName("target"); if name then local cmd=self:BuildCommand(e,name); if cmd then self:SendCommand(cmd); return end end end
 if string.find(hint,"optional",1,true) then local cmd=self:BuildCommand(e,""); if cmd then self:SendCommand(cmd); return end end
 pendingEntry=e; pt:SetText(self:GetCommandLabel(e) or L.arg or "Argument"); pd:SetText((e.hint or ((L.arg or "Argument")..": "..tostring(e[3] or ""))).."\n"..(L.listHint or "Tip: Item/Quest/NPC/Spell/Player/Teleport tabs provide selectable lists.")); pe:SetText(""); prompt:Show(); pe:SetFocus()
end

for i,g in ipairs(AAM.CommandGroups or {}) do local b=makeButton(frame,78,21,localizedGroup(g)); local col=(i-1)%6; local row=math.floor((i-1)/6); b:SetPoint("TOPLEFT",15+col*82,-64-row*24); b.groupKey=g.key; b:SetScript("OnClick",function(self) AAM:RenderCommands(self.groupKey,1) end); tabs[i]=b end
local area=CreateFrame("Frame",nil,frame); area:SetSize(484,250); area:SetPoint("TOPLEFT",18,-116)
for i=1,COMMANDS_PER_PAGE do local b=makeButton(area,231,22,""); local col=(i-1)%2; local row=math.floor((i-1)/2); b:SetPoint("TOPLEFT",col*247,-row*25); local ic=b:CreateTexture(nil,"ARTWORK"); ic:SetSize(15,15); ic:SetPoint("LEFT",7,0); b.icon=ic; b.aamLabel:ClearAllPoints(); b.aamLabel:SetPoint("LEFT",26,0); b.aamLabel:SetPoint("RIGHT",-28,0); local star=b:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); star:SetPoint("RIGHT",-7,0); b.star=star; b:RegisterForClicks("LeftButtonUp","RightButtonUp"); b:SetScript("OnEnter",showTooltip); b:SetScript("OnLeave",hideTooltip); b:SetScript("OnClick",function(self,mouse) if not self.entry then return end; if mouse=="RightButton" then AAM:ToggleEntryFavorite(self.entry) else AAM:ExecuteEntry(self.entry) end end); commandButtons[i]=b end
local prev=makeButton(frame,54,18,"◀"); prev:SetPoint("BOTTOMRIGHT",-130,14); local page=frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); page:SetWidth(58); page:SetJustifyH("CENTER"); page:SetPoint("LEFT",prev,"RIGHT",2,0); local nextb=makeButton(frame,54,18,"▶"); nextb:SetPoint("LEFT",page,"RIGHT",2,0)
prev:SetScript("OnClick",function() AAM:RenderCommands(currentGroup,currentPage-1) end); nextb:SetScript("OnClick",function() AAM:RenderCommands(currentGroup,currentPage+1) end)
function AAM:RenderCommands(groupKey,pageNo)
 local g=self:GetGroup(groupKey) or self.CommandGroups[1]; if not g then return end; currentGroup=g.key; local total=#(g.commands or {}); local pages=math.max(1,math.ceil(total/COMMANDS_PER_PAGE)); currentPage=math.max(1,math.min(pages,tonumber(pageNo) or 1)); GMMPandariaDB=GMMPandariaDB or {}; GMMPandariaDB.lastGroup=currentGroup; GMMPandariaDB.lastPage=currentPage
 for _,t in ipairs(tabs) do style(t,t.groupKey==currentGroup and "active" or "normal") end
 for i=1,COMMANDS_PER_PAGE do local idx=(currentPage-1)*COMMANDS_PER_PAGE+i; local e=g.commands[idx]; local b=commandButtons[i]; b.entry=e; if e then b:SetText(self:GetCommandLabel(e)); b.icon:SetTexture(iconFor(e)); b.favorite=self:IsEntryFavorite(e) and true or false; b.star:SetText(b.favorite and "★" or ""); style(b,semantic(e)); b:Show() else b:Hide() end end
 page:SetText(pages>1 and (currentPage.."/"..pages) or ""); if pages>1 then prev:Show(); nextb:Show() else prev:Hide(); nextb:Hide() end
end

-- WotLK 3.5.0-style persistent quick toolbar (the "mini bar").
local toolbar=CreateFrame("Frame","GMMPandaria548Toolbar",UIParent); toolbar:SetSize(500,32); toolbar:SetPoint("BOTTOM",UIParent,"BOTTOM",0,92); toolbar:SetFrameStrata("HIGH"); toolbar:SetMovable(true); toolbar:EnableMouse(true); toolbar:SetClampedToScreen(true); toolbar:RegisterForDrag("LeftButton"); toolbar:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=16,edgeSize=12,insets={left=3,right=3,top=3,bottom=3}}); toolbar:SetBackdropColor(0.005,0.008,0.012,0.98); toolbar:SetBackdropBorderColor(0.95,0.58,0.10,1)
toolbar:SetScript("OnDragStart",function(self) self:StartMoving() end); toolbar:SetScript("OnDragStop",function(self) self:StopMovingOrSizing(); GMMPandariaDB=GMMPandariaDB or {}; local p,_,rp,x,y=self:GetPoint(); GMMPandariaDB.toolbarPoint=p; GMMPandariaDB.toolbarRelativePoint=rp; GMMPandariaDB.toolbarX=x; GMMPandariaDB.toolbarY=y end)
local function iconButton(x,icon,titleText,hint,fn)
 local b=CreateFrame("Button",nil,toolbar); b:SetSize(28,24); b:SetPoint("LEFT",x,0); b:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=8,edgeSize=8,insets={left=2,right=2,top=2,bottom=2}}); b:SetBackdropColor(0.13,0.085,0.025,1); b:SetBackdropBorderColor(0.95,0.63,0.12,1); local t=b:CreateTexture(nil,"ARTWORK"); t:SetPoint("TOPLEFT",3,-3); t:SetPoint("BOTTOMRIGHT",-3,3); t:SetTexture(icon); b.aamIcon=t; b:SetScript("OnClick",fn); b:SetScript("OnEnter",function(self) self:SetBackdropColor(0.11,0.31,0.39,1); GameTooltip:SetOwner(self,"ANCHOR_TOP"); GameTooltip:SetText(titleText,1,0.82,0); GameTooltip:AddLine(hint,1,1,1,true); GameTooltip:Show() end); b:SetScript("OnLeave",function(self) self:SetBackdropColor(0.13,0.085,0.025,1); GameTooltip:Hide() end); return b
end
iconButton(5,"Interface\\Icons\\Ability_Druid_FlightForm",L.flight or "Flight",L.flightHint or "Toggle GM flight",function() GMMPandariaDB=GMMPandariaDB or {}; GMMPandariaDB.flight=not GMMPandariaDB.flight; AAM:SendCommand(GMMPandariaDB.flight and ".gm fly on" or ".gm fly off") end)
iconButton(35,"Interface\\Icons\\Ability_Rogue_Eviscerate",L.kill or "Kill",L.killHint or "Kill selected target",function() AAM:SendCommand(".die") end)
iconButton(65,"Interface\\Icons\\Spell_Holy_PowerWordShield",L.god or "God",L.godHint or "Toggle god mode",function() GMMPandariaDB=GMMPandariaDB or {}; GMMPandariaDB.god=not GMMPandariaDB.god; AAM:SendCommand(GMMPandariaDB.god and ".cheat god on" or ".cheat god off") end)
iconButton(95,"Interface\\Icons\\Ability_Stealth",L.visibility or "Visibility",L.visibilityHint or "Toggle GM visibility",function() GMMPandariaDB=GMMPandariaDB or {}; GMMPandariaDB.invisible=not GMMPandariaDB.invisible; AAM:SendCommand(GMMPandariaDB.invisible and ".gm visible off" or ".gm visible on") end)
iconButton(125,"Interface\\Icons\\Ability_Rogue_Sprint",L.speed or "Speed",L.speedHint or "Toggle speed x3",function() GMMPandariaDB=GMMPandariaDB or {}; GMMPandariaDB.speed3=not GMMPandariaDB.speed3; AAM:SendCommand(GMMPandariaDB.speed3 and ".modify speed all 3" or ".modify speed all 1") end)
iconButton(155,"Interface\\Icons\\INV_Misc_Map_01",L.teleports or "Teleports",L.teleportClickHelp or "Open teleport list",function() AAM:OpenAction("teleports") end)
iconButton(185,"Interface\\Icons\\INV_Misc_Note_01",L.favorites or "Favorites",L.favoritesSubtitle or "Open favorite teleports",function() AAM:OpenAction("teleportFavorites") end)
iconButton(215,"Interface\\Icons\\INV_Misc_Book_07",L.quests or "Quests",L.questHelperTitle or "Quest helper",function() AAM:OpenAction("questhelper") end)
iconButton(245,"Interface\\Icons\\INV_Misc_Bag_10_Blue",L.bankButton or "Bank",L.bankLoadFailed or "Open remote bank",function() AAM:OpenAction("bank") end)
iconButton(275,"Interface\\Icons\\Trade_Engineering",L.professionTitle or "Professions",L.professionLocaleNote or "Profession tools",function() AAM:OpenAction("profession") end)
iconButton(305,"Interface\\Icons\\INV_Misc_Bag_10_Blue",L.items or "Items",L.itemBrowserTitle or "Item browser",function() AAM:OpenAction("items") end)
local gm=makeButton(toolbar,82,22,L.gmMenu or "GM Menu"); gm:SetPoint("LEFT",338,0); style(gm,"utility"); gm:SetScript("OnClick",function() AAM:TogglePanel() end)
local quick={}
for i=1,2 do local b=iconButton(430+(i-1)*30,"Interface\\Icons\\INV_Misc_QuestionMark","Quick slot "..i,L.quickslotHint or "Right click a GM command to assign",function(self) if self.entry then AAM:ExecuteEntry(self.entry) end end); quick[i]=b end
function AAM:RefreshQuickSlots()
 local fav=self:GetCommandFavorites()
 for i=1,2 do
  local b=quick[i]; local e=fav[i] and self:FindEntry(fav[i]); b.entry=e
  if b.aamIcon then b.aamIcon:SetTexture(e and iconFor(e) or "Interface\\Icons\\INV_Misc_QuestionMark") end
 end
end
function AAM:ToggleToolbar() GMMPandariaDB=GMMPandariaDB or {}; if toolbar:IsShown() then toolbar:Hide(); GMMPandariaDB.toolbarVisible=false else toolbar:Show(); GMMPandariaDB.toolbarVisible=true end end

function AAM:TogglePanel(forceShow)
 if forceShow or not frame:IsShown() then self:HideFeatureFrames(nil); if prompt:IsShown() then prompt:Hide() end; frame:Show(); self:RenderCommands((GMMPandariaDB and GMMPandariaDB.lastGroup) or "general",(GMMPandariaDB and GMMPandariaDB.lastPage) or 1) else frame:Hide() end
end
frame:SetScript("OnShow",function(self) if GMMPandariaDB then self:ClearAllPoints(); self:SetPoint(GMMPandariaDB.point or "CENTER",UIParent,GMMPandariaDB.relativePoint or "CENTER",GMMPandariaDB.x or 0,GMMPandariaDB.y or 0) end; AAM:RenderCommands((GMMPandariaDB and GMMPandariaDB.lastGroup) or "general",(GMMPandariaDB and GMMPandariaDB.lastPage) or 1) end)
frame:SetScript("OnHide",function() pe:ClearFocus() end)

local login=CreateFrame("Frame"); login:RegisterEvent("PLAYER_LOGIN"); login:SetScript("OnEvent",function()
 if GMMPandariaDB and GMMPandariaDB.toolbarPoint then toolbar:ClearAllPoints(); toolbar:SetPoint(GMMPandariaDB.toolbarPoint,UIParent,GMMPandariaDB.toolbarRelativePoint or GMMPandariaDB.toolbarPoint,GMMPandariaDB.toolbarX or 0,GMMPandariaDB.toolbarY or 0) end
 if GMMPandariaDB and GMMPandariaDB.toolbarVisible==false then toolbar:Hide() else toolbar:Show() end
 AAM:RefreshQuickSlots()
end)
AAM:RenderCommands("general",1)
