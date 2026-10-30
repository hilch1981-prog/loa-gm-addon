local AAM=GMMPandaria548
local L=AAM.L or {}

function AAM:ReviveSmart(playerName)
  playerName=tostring(playerName or ""):match("^%s*(.-)%s*$")
  local selfDead=(UnitIsDeadOrGhost and UnitIsDeadOrGhost("player")) or (UnitIsDead and UnitIsDead("player")) or (UnitIsGhost and UnitIsGhost("player"))
  if selfDead and playerName=="" and ClearTarget then pcall(ClearTarget) end
  if playerName~="" then return self:SendCommand(".revive "..playerName) end
  return self:SendCommand(".revive")
end

SLASH_GMMPANDARIAREVIVE1="/gmmrevive"; SlashCmdList.GMMPANDARIAREVIVE=function(msg) AAM:ReviveSmart(msg) end
AAM:RegisterRuntimeModule("revive",{status="partial",runtime="Modules/Revive.lua",notes="core-native .revive; dead-chat transport still requires MoP client certification",gameTestPending=true})
