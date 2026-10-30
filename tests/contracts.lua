-- Execute every TOC entry with a mocked WoW engine. This does not certify rendering.
local frames, chat, messages, bindings = {}, {}, {}, {}
local combat, dead, selected, ctrl, alt, shift = false, false, "enemy", false, false, false
local assertions = 0
local function check(value, why) assertions = assertions + 1; assert(value, why) end
local methods = {}
local function object(name)
  local frame = {name=name, shown=true, scripts={}, events={}, attributes={}}
  setmetatable(frame,{__index=function(_,key)
    if methods[key] then return methods[key] end
    if key:match("^Set") or key:match("^Register") or key:match("^Enable") or key:match("^Disable") or
       key:match("^Clear") or key:match("^Start") or key:match("^Stop") or key:match("^Add") or
       key:match("^Highlight") or key:match("^Lock") or key:match("^Unlock") then return function() end end
  end})
  if name then _G[name] = frame end
  return frame
end
function methods:GetName() return self.name end
function methods:CreateFontString(name) return object(name) end
function methods:CreateTexture(name) return object(name) end
function methods:SetScript(key,callback) self.scripts[key] = callback end
function methods:GetScript(key) return self.scripts[key] end
function methods:RegisterEvent(key) self.events[key] = true end
function methods:SetAttribute(key,value) self.attributes[key] = value end
function methods:SetPoint(...) self.point = {...} end
function methods:ClearAllPoints() self.point = nil end
function methods:GetPoint() return unpack(self.point or {"CENTER",UIParent,"CENTER",0,0}) end
function methods:SetScale(value) self.scale = value end
function methods:GetScale() return self.scale or 1 end
function methods:GetEffectiveScale() return self.scale or 1 end
function methods:SetSize(w,h) self.width,self.height = w,h end
function methods:SetWidth(w) self.width = w end
function methods:GetWidth() return self.width or 100 end
function methods:GetHeight() return self.height or 100 end
function methods:SetText(value) self.text = value end
function methods:GetText() return self.text or "" end
function methods:Show()
  local old = self.shown; self.shown = true
  if not old and self.scripts.OnShow then self.scripts.OnShow(self) end
end
function methods:Hide()
  local old = self.shown; self.shown = false
  if old and self.scripts.OnHide then self.scripts.OnHide(self) end
end
function methods:IsShown() return self.shown end
function methods:IsVisible() return self.shown end
function methods:GetCenter() return 100,100 end
function methods:GetFrameLevel() return 1 end
function methods:GetNormalTexture() return object() end
function methods:GetHighlightTexture() return object() end
function methods:GetChecked() return self.checked end
function methods:SetChecked(value) self.checked = value end
function methods:SetFocus() self.focus = true end
function methods:ClearFocus() self.focus = false end
function CreateFrame(_,name,parent,template)
  local frame = object(name); frame.parent,frame.template = parent,template
  frames[#frames+1] = frame; return frame
end
UIParent=object("UIParent"); Minimap=object("Minimap"); BankFrame=object("BankFrame")
GameTooltip=object("GameTooltip"); UISpecialFrames={}; SlashCmdList={}; StaticPopupDialogs={}
DEFAULT_CHAT_FRAME={AddMessage=function(_,text) messages[#messages+1]=text end}
function GetLocale() return arg[2] or "koKR" end
function GetBuildInfo() return "5.4.8","18414","",50400 end
function GetTime() return 10 end
time=os.time
function UnitName(unit) return unit == "player" and "검증캐릭터" or "대상" end
function UnitExists(unit) return unit == "player" or selected ~= nil end
function UnitIsUnit(left,right)
  local a = left == "target" and selected or left
  local b = right == "target" and selected or right
  return a == b
end
function UnitIsDeadOrGhost(unit) return unit == "player" and dead or false end
function InCombatLockdown() return combat end
function IsControlKeyDown() return ctrl end
function IsAltKeyDown() return alt end
function IsShiftKeyDown() return shift end
function SendChatMessage(text,channel) chat[#chat+1]={text,channel} end
function ClearOverrideBindings(frame) bindings={} end
function SetOverrideBindingClick(frame,priority,binding,name,button) bindings[binding]={name,button} end
function ToggleAllBags() _G.bagsToggled = true end
function GetNumQuestLogEntries() return 0,0 end
function GetQuestLogTitle() return nil end
function GetNumQuestLeaderBoards() return 0 end
function HideUIPanel(frame) frame:Hide() end
function hooksecurefunc() end

-- Simulate an independently installed Trinity addon. The new addon must not overwrite it.
local legacyNamespace={marker="Trinity-existing"}
local legacySettings={point="BOTTOM",history={"legacy command"}}
local legacyHandler=function() end
AzerothAdminMoP=legacyNamespace; AzerothAdminMoPDB=legacySettings
local legacyFrame=object("AzerothAdminMoPFrame")
SlashCmdList.AZEROTHADMINMOP=legacyHandler
SLASH_AZEROTHADMINMOP1="/aamop"
SLASH_AZEROTHADMINMOPDB1="/aadb"

local root = assert(arg[1],"addon folder required")
local toc = assert(io.open(root.."/GMminibar-LoA.toc","r")):read("*a")
local loaded=0
for line in toc:gmatch("[^\r\n]+") do
  if not line:match("^%s*#") and line:match("%S") then
    local file = line:match("^%s*(.-)%s*$"):gsub("\\","/")
    local fn,error = loadfile(root.."/"..file)
    check(fn ~= nil,"Lua 5.1 syntax / missing TOC entry: "..file..": "..tostring(error))
    fn("GMminibar-LoA"); loaded=loaded+1
  end
end
local function emit(event,...)
  local count = #frames
  for i=1,count do
    local frame=frames[i]
    if frame.events[event] and frame.scripts.OnEvent then frame.scripts.OnEvent(frame,event,...) end
  end
end
emit("ADDON_LOADED","GMminibar-LoA"); emit("PLAYER_LOGIN")
local A=GMMPandaria548
check(AzerothAdminMoP==legacyNamespace,"Existing Trinity namespace preserved")
check(AzerothAdminMoPDB==legacySettings and legacySettings.point=="BOTTOM","Existing Trinity settings preserved")
check(AzerothAdminMoPFrame==legacyFrame,"Existing Trinity frame preserved")
check(SlashCmdList.AZEROTHADMINMOP==legacyHandler and SLASH_AZEROTHADMINMOP1=="/aamop","Existing Trinity slash preserved")
check(A.L.title=="GM MINI BAR[판다리아-LoA]","Legion-family Korean display name")
check(A.version=="1.0.0","Renamed release version")
check(toc:find("## X-Core: Legends-of-Azeroth-Pandaria-5.4.8 + Playerbots",1,true)~=nil,"LoA core metadata retained")
check(SLASH_GMMPANDARIA1=="/gmmop" and SLASH_GMMPANDARIARAW1=="/gmcmd","Independent slash commands")
check(SLASH_GMMPANDARIADB1=="/gmmdb","Independent database browser slash")
check(SLASH_AZEROTHADMINMOPDB1=="/aadb","Existing Trinity database browser slash preserved")
check(toc:find("## SavedVariables: GMMPandariaDB",1,true)~=nil,"Independent saved variables")

check(A.werMini and A.werMini:IsShown(),"Minibar created on login")
check(not GMMPandaria548Toolbar:IsShown(),"Legacy toolbar hidden")
local count=0
for key,button in pairs(A.werMini.buttons) do
  count=count+1
  check(button.template=="SecureActionButtonTemplate","Secure button: "..key)
  check(button.scripts.PostClick~=nil,"Click handler: "..key)
end
check(count==14,"14 slots")
check(#chat==0,"Loading addon never sends GM commands")
local function click(key,mouse)
  local button=A.werMini.buttons[key]
  if mouse=="LeftButton" and button.attributes.type1=="target" then selected=button.attributes.unit1 end
  button.scripts.PostClick(button,mouse)
end
check(A:SendCommand("  server info  "),"Normalize command")
check(chat[#chat][1]==".server info" and chat[#chat][2]=="SAY","Normalized local GM command")
for _,invalid in ipairs({".save\n.die", ".save\r.die", ".save\t", "..die", string.rep("가",81)}) do
  local before=#chat
  -- Outer whitespace is deliberately trimmed; an embedded tab remains invalid.
  if invalid==".save\t" then invalid=".save\t.die" end
  check(not A:SendCommand(invalid) and #chat==before,"Reject invalid command")
end
check(not A:SendCommand(nil),"Reject nonstring command")
for i=1,35 do A:SendCommand(".server info") end
check(#A.history==30,"Bound command history")
selected="enemy"; click("fly","LeftButton")
check(selected=="player" and chat[#chat][1]==".gm fly on","Flight uses secure self target")
click("fly","LeftButton"); check(chat[#chat][1]==".gm fly off","Flight off")
selected="enemy"; click("speed","LeftButton")
check(selected=="player" and chat[#chat][1]==".modify speed all 3","Speed targets self")
click("speed","LeftButton"); check(chat[#chat][1]==".modify speed all 1","Speed reset")
click("god","LeftButton"); check(chat[#chat][1]==".cheat god","God uses server toggle")
click("gm","LeftButton"); check(chat[#chat][1]==".gm on","GM on")
click("gm","LeftButton"); check(chat[#chat][1]==".gm off","GM off")
click("visible","LeftButton"); check(chat[#chat][1]==".gm visible off","Hide GM")
click("visible","LeftButton"); check(chat[#chat][1]==".gm visible on","Show GM")
local before=#chat; selected=nil; click("kill","LeftButton")
check(#chat==before,"No-target kill blocked")
selected="player"; click("kill","LeftButton"); check(#chat==before,"Self kill blocked")
selected="enemy"; click("kill","LeftButton")
check(selected=="enemy" and chat[#chat][1]==".die","Kill preserves selected target")
dead=true; click("revive","LeftButton")
check(chat[#chat][1]==".revive 검증캐릭터" and chat[#chat][2]=="GUILD","Dead revive transport")
dead=false; selected="enemy"; A:ReviveSmart()
check(selected=="enemy" and chat[#chat][1]==".revive 검증캐릭터","Named revive preserves target")
local originalOpen=A.OpenAction; local opened
A.OpenAction=function(_,key) opened=key end
for _,pair in ipairs({{"bank","bank"},{"quests","questhelper"},{"travel","teleports"},{"items","items"},{"spells","spells"},{"profession","profession"}}) do
  selected="enemy"; click(pair[1],"LeftButton")
  check(opened==pair[2] and selected=="enemy","Browser routing preserves target: "..pair[1])
end
ctrl=true; click("bank","LeftButton"); check(bagsToggled,"Ctrl bank opens bags"); ctrl=false
A.OpenAction=originalOpen
selected="enemy"; before=#chat; click("fly","RightButton")
check(selected=="enemy" and #chat==before and A.werBindPopup:IsShown(),"Right-click only opens binding editor")
ctrl=true; A.werBindPopup.scripts.OnKeyDown(A.werBindPopup,"F8"); ctrl=false
check(bindings["CTRL-F8"][1]=="GMMPandariaSlot_fly","Binding installed")
click("speed","RightButton"); ctrl=true; A.werBindPopup.scripts.OnKeyDown(A.werBindPopup,"F8"); ctrl=false
check(GMMPandariaDB.werMini.bindings.fly==nil and bindings["CTRL-F8"][1]=="GMMPandariaSlot_speed","Duplicate binding moves slot")
SlashCmdList.GMMPANDARIAMINI("hide")
check(not A.werMini:IsShown() and next(bindings)==nil,"Hide also clears override bindings")
SlashCmdList.GMMPANDARIAMINI("show")
check(A.werMini:IsShown() and bindings["CTRL-F8"]~=nil,"Show restores bindings")
A:WERSetScale(9); check(A.werMini.scale==1.60,"Scale upper bound")
A:WERSetScale(.1); check(A.werMini.scale==.65,"Scale lower bound")
local savedScale=A.werMini.scale; combat=true; emit("PLAYER_REGEN_DISABLED")
A:WERSetScale(1.2); A:WERBindPopup("fly")
check(A.werMini.scale==savedScale and not A.werBindPopup:IsShown(),"Combat blocks layout and binding edits")
selected="enemy"; click("fly","LeftButton")
check(selected=="player" and chat[#chat][1]==".gm fly on","Preconfigured hardware action works during combat in mock")
combat=false; emit("PLAYER_REGEN_ENABLED"); A:ResetPosition()
check(A.werMini.scale==1 and A.werMini.point[1]=="TOP","Reset minibar position and scale")
for key,expected in pairs({Items=80064,Quests=18028,Creatures=57518,Teleports=1602}) do
  check(#A.Data[key]==expected,"DB index count: "..key)
  local row=A.Data[key][math.floor(expected/2)]
  local matches=A:SearchData(key,tostring(row[1]),100,0,false)
  local found=false; for _,candidate in ipairs(matches) do if candidate[1]==row[1] then found=true end end
  check(found,"DB ID search: "..key)
end
print(string.format("PASS: %d assertions; %d TOC Lua files loaded; 14 slots; real generated indexes. Mock engine only; GUI and gameplay unverified.",assertions,loaded))
