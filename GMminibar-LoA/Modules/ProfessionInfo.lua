local AAM=GMMPandaria548
local L=AAM.L or {}
local locale=GetLocale and GetLocale() or "enUS"
local professions={
  {171,"Alchemy","연금술","炼金术","煉金術","Алхимия"},{164,"Blacksmithing","대장기술","锻造","鍛造","Кузнечное дело"},
  {333,"Enchanting","마법부여","附魔","附魔","Наложение чар"},{202,"Engineering","기계공학","工程学","工程學","Инженерное дело"},
  {182,"Herbalism","약초채집","草药学","草藥學","Травничество"},{773,"Inscription","주문각인","铭文","銘文","Начертание"},
  {755,"Jewelcrafting","보석세공","珠宝加工","珠寶設計","Ювелирное дело"},{165,"Leatherworking","가죽세공","制皮","製皮","Кожевничество"},
  {186,"Mining","채광","采矿","採礦","Горное дело"},{393,"Skinning","무두질","剥皮","剝皮","Снятие шкур"},
  {197,"Tailoring","재봉술","裁缝","裁縫","Портняжное дело"},{185,"Cooking","요리","烹饪","烹飪","Кулинария"},
  {129,"First Aid","응급치료","急救","急救","Первая помощь"},{356,"Fishing","낚시","钓鱼","釣魚","Рыбная ловля"},
  {794,"Archaeology","고고학","考古学","考古學","Археология"},
}
local function displayName(p)
  if locale=="koKR" then return p[3] elseif locale=="zhCN" then return p[4] elseif locale=="zhTW" then return p[5] elseif locale=="ruRU" then return p[6] end
  return p[2]
end
-- MOP_V2_Repack cs_learn.cpp searches SkillLineEntry::name using the session
-- DBC locale.  Therefore the localized display name is also the correct
-- command value for `.learn all recipes <profession>`.
local function commandName(p) return displayName(p) end
local function makeButton(parent,w,h,text)
  local b=CreateFrame("Button",nil,parent); b:SetSize(w,h); b:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=12,edgeSize=9,insets={left=2,right=2,top=2,bottom=2}}); b:SetBackdropColor(0.025,0.04,0.055,1); b:SetBackdropBorderColor(0.48,0.43,0.31,1)
  local f=b:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); f:SetPoint("LEFT",6,0); f:SetPoint("RIGHT",-6,0); f:SetJustifyH("CENTER"); f:SetTextColor(0.92,0.78,0.28); b.label=f; b.SetText=function(self,v) self.label:SetText(v or "") end; b:SetText(text or ""); return b
end
local function setActive(b,on) if on then b:SetBackdropColor(0.035,0.16,0.18,1); b:SetBackdropBorderColor(0.18,0.88,0.92,1) else b:SetBackdropColor(0.025,0.04,0.055,1); b:SetBackdropBorderColor(0.48,0.43,0.31,1) end end

local frame=CreateFrame("Frame","GMMPandaria548ProfessionFrame",UIParent); AAM:RegisterSpecialFrame("GMMPandaria548ProfessionFrame"); AAM:RegisterFeatureFrame(frame)
frame:SetSize(620,445); frame:SetPoint("CENTER"); frame:SetFrameStrata("DIALOG"); frame:SetMovable(true); frame:EnableMouse(true); frame:RegisterForDrag("LeftButton"); frame:SetClampedToScreen(true); frame:Hide(); frame:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=16,edgeSize=14,insets={left=4,right=4,top=4,bottom=4}}); frame:SetBackdropColor(0.018,0.025,0.035,0.98); frame:SetBackdropBorderColor(0.72,0.52,0.18,1); frame:SetScript("OnDragStart",function(self) self:StartMoving() end); frame:SetScript("OnDragStop",function(self) self:StopMovingOrSizing() end)
local close=CreateFrame("Button",nil,frame,"UIPanelCloseButton"); close:SetPoint("TOPRIGHT",-5,-5)
local title=frame:CreateFontString(nil,"OVERLAY","GameFontNormalLarge"); title:SetPoint("TOPLEFT",16,-14); title:SetTextColor(1,0.78,0.25); title:SetText(L.professionTitle or "MoP Profession Tools")
local note=frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); note:SetPoint("TOPLEFT",16,-37); note:SetWidth(470); note:SetTextColor(0.30,0.86,0.86); note:SetText(L.professionLocaleNote or "Uses the server session DBC locale name.")
local back=makeButton(frame,72,20,L.gmMenu or "GM Menu"); back:SetPoint("TOPRIGHT",-42,-36); back:SetScript("OnClick",function() frame:Hide(); if AAM.TogglePanel then AAM:TogglePanel(true) end end)
local selected=professions[1]; local buttons={}
local selectedText=frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); selectedText:SetPoint("TOPLEFT",16,-66); selectedText:SetTextColor(0.92,0.88,0.68)
for i,p in ipairs(professions) do
  local col=(i-1)%3; local row=math.floor((i-1)/3); local b=makeButton(frame,188,27,displayName(p)); b:SetPoint("TOPLEFT",16+col*196,-94-row*34); b.prof=p
  b:SetScript("OnClick",function(self) selected=self.prof; for _,x in ipairs(buttons) do setActive(x,x.prof==selected) end; selectedText:SetText((L.selected or "Selected")..": "..displayName(selected).."  [Skill "..selected[1].."]") end); buttons[i]=b
end
local function action(x,text,fn,kind)
  local b=makeButton(frame,135,24,text); b:SetPoint("BOTTOMLEFT",x,16); if kind=="utility" then b:SetBackdropColor(0.025,0.09,0.11,1); b:SetBackdropBorderColor(0.12,0.63,0.68,1) elseif kind=="reward" then b:SetBackdropColor(0.035,0.105,0.055,1); b:SetBackdropBorderColor(0.30,0.67,0.30,1) end; b:SetScript("OnClick",fn); return b
end
action(16,L.learnRecipes or "Learn recipes",function() AAM:SendCommand(".learn all recipes "..commandName(selected)) end,"reward")
action(159,L.set600 or "Set 600",function() AAM:SendCommand(string.format(".setskill %d 600 600",selected[1])) end,"reward")
action(302,L.maxSkill or "Max skills",function() AAM:SendCommand(".maxskill") end,"utility")
action(445,L.learnAllCrafts or "All crafts",function() AAM:SendCommand(".learn all crafts") end,"utility")
selectedText:SetText((L.selected or "Selected")..": "..displayName(selected).."  [Skill "..selected[1].."]"); setActive(buttons[1],true)

function AAM:ShowProfessionInfo() self:ShowFeatureFrame(frame) end
SLASH_GMMPANDARIAPROF1="/gmmprof"; SlashCmdList.GMMPANDARIAPROF=function() if frame:IsShown() then frame:Hide() else AAM:ShowProfessionInfo() end end
AAM:RegisterRuntimeModule("profession-info",{status="mop-adapted",runtime="Modules/ProfessionInfo.lua",source="MOP_V2_Repack cs_learn.cpp session DBC locale",gameTestPending=true})
