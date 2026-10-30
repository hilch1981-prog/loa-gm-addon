local AAM = GMMPandaria548

-- Advanced filtering remains available to future item-info panels, but the
-- user-facing browser is the common WotLK-style data window so Item/Quest/NPC
-- lists share one layout and never overlap the GM root frame.
function AAM:SearchItemsAdvanced(query, minQuality, minItemLevel, classId, offset, limit)
  local source = self.Data and self.Data.Items or {}
  local q = tostring(query or ""):match("^%s*(.-)%s*$")
  local qLower = string.lower(q)
  local numeric = tonumber(q)
  minQuality = tonumber(minQuality)
  minItemLevel = tonumber(minItemLevel)
  classId = tonumber(classId)
  offset = math.max(0, tonumber(offset) or 0)
  limit = math.max(1, tonumber(limit) or 12)

  local out, matched = {}, 0
  for _, row in ipairs(source) do
    local id = tonumber(row[1]) or 0
    local name = tostring(row[2] or "")
    local quality = tonumber(row[3]) or 0
    local itemLevel = tonumber(row[4]) or 0
    local itemClass = tonumber(row[6]) or 0
    local textOk = q == "" or (numeric and id == numeric) or string.find(string.lower(name), qLower, 1, true)
    local filterOk = (not minQuality or quality >= minQuality)
      and (not minItemLevel or itemLevel >= minItemLevel)
      and (not classId or itemClass == classId)
    if textOk and filterOk then
      matched = matched + 1
      if matched > offset and #out < limit then out[#out + 1] = row end
    end
  end
  return out, matched > offset + limit, matched
end

function AAM:ShowItemBrowser()
  if self.ShowDataBrowser then self:ShowDataBrowser("Items", false) end
end

SLASH_GMMPANDARIAITEM1 = "/gmmitem"
SlashCmdList.GMMPANDARIAITEM = function()
  if GMMPandaria548DataBrowser and GMMPandaria548DataBrowser:IsShown() then
    GMMPandaria548DataBrowser:Hide()
  else
    AAM:ShowItemBrowser()
  end
end

AAM:RegisterRuntimeModule("item-browser", {
  status = "mop-adapted",
  runtime = "Modules/ItemBrowser.lua",
  source = "MOP_V2_Repack generated item index + MoP native GameTooltip",
  gameTestPending = true,
})
