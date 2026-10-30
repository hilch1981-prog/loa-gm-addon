local AAM = GMMPandaria548

-- Keep all feature-window lifecycle in Core.lua.  This module only provides the
-- cross-module routing layer; it must never replace AAM:HideFeatureFrames().
function AAM:OpenFeature(key)
  if key == "quest" or key == "questhelper" then
    if self.ShowQuestHelper then self:ShowQuestHelper() end
  elseif key == "quests" then
    if self.ShowDataBrowser then self:ShowDataBrowser("Quests", false) end
  elseif key == "items" then
    if self.ShowDataBrowser then self:ShowDataBrowser("Items", false) end
  elseif key == "profession" then
    if self.ShowProfessionInfo then self:ShowProfessionInfo() end
  elseif key == "bank" then
    if self.ToggleBank then self:ToggleBank() end
  elseif key == "revive" then
    if self.ReviveSmart then self:ReviveSmart() end
  elseif key == "teleports" then
    if self.ShowDataBrowser then self:ShowDataBrowser("Teleports", false) end
  elseif key == "teleportFavorites" then
    if self.ShowDataBrowser then self:ShowDataBrowser("Teleports", true) end
  elseif key == "creatures" then
    if self.ShowDataBrowser then self:ShowDataBrowser("Creatures", false) end
  elseif key == "spells" then
    if self.ShowSpellBrowser then self:ShowSpellBrowser() end
  elseif key == "players" then
    if self.ShowPlayerBrowser then self:ShowPlayerBrowser() end
  end
end

AAM:RegisterRuntimeModule("integrations", {
  status = "mop-adapted",
  runtime = "Modules/Integrations.lua",
  gameTestPending = true,
})
