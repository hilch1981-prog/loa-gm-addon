local AAM = GMMPandaria548
AAM.Data = AAM.Data or {}

local function lower(value)
  return string.lower(tostring(value or ""))
end

local function compact(value)
  value = lower(value)
  value = string.gsub(value, "%s+", "")
  value = string.gsub(value, "[%-%_']", "")
  return value
end

function AAM:GetDataFavorites(kind)
  GMMPandariaDB = GMMPandariaDB or {}
  GMMPandariaDB.dataFavorites = GMMPandariaDB.dataFavorites or {}
  GMMPandariaDB.dataFavorites[kind] = GMMPandariaDB.dataFavorites[kind] or {}
  return GMMPandariaDB.dataFavorites[kind]
end

function AAM:IsDataFavorite(kind, id)
  return self:GetDataFavorites(kind)[tostring(tonumber(id) or id or "")] and true or false
end

function AAM:ToggleDataFavorite(kind, row)
  if not row then return false end
  local id = tostring(tonumber(row[1]) or row[1] or "")
  if id == "" then return false end
  local favorites = self:GetDataFavorites(kind)
  if favorites[id] then
    favorites[id] = nil
    self:Print((self.L and self.L.favoriteRemoved or "Favorite removed") .. ": " .. tostring(self:GetDataDisplayName(kind, row) or id))
    return false
  end
  favorites[id] = true
  self:Print((self.L and self.L.favoriteAdded or "Favorite added") .. ": " .. tostring(self:GetDataDisplayName(kind, row) or id))
  return true
end

function AAM:GetTeleportMeta(row)
  if not row then return nil end
  local canonical = tostring(row[2] or "")
  return self.TeleportMeta and self.TeleportMeta[canonical] or nil
end

function AAM:GetTeleportDisplayName(row)
  if not row then return "" end
  local canonical = tostring(row[2] or "")
  local meta = self:GetTeleportMeta(row)
  local locale = GetLocale and GetLocale() or "enUS"
  if meta then
    return meta[locale] or meta.enUS or meta.koKR or canonical
  end
  return canonical
end

function AAM:GetDataDisplayName(kind, row)
  if kind == "Teleports" then return self:GetTeleportDisplayName(row) end
  return tostring(row and row[2] or "")
end

function AAM:GetTeleportGroup(row)
  if not row then return "other" end
  local meta = self:GetTeleportMeta(row)
  if meta and meta.group then return meta.group end
  local mapId = tonumber(row[3]) or -1
  if mapId == 870 or mapId == 1064 or mapId == 1126 or mapId == 1135 or mapId == 1144 or mapId == 1099 or mapId == 1050 or mapId == 1031 then
    return "pandaria"
  elseif mapId == 0 then
    return "eastern"
  elseif mapId == 1 then
    return "kalimdor"
  elseif mapId == 530 then
    return "outland"
  elseif mapId == 571 then
    return "northrend"
  end
  return "other"
end

function AAM:IsTeleportPopular(row)
  local meta = self:GetTeleportMeta(row)
  return meta and meta.popular and true or false
end

function AAM:TeleportMatches(row, query)
  query = tostring(query or ""):match("^%s*(.-)%s*$")
  if query == "" then return true end
  local numeric = tonumber(query)
  if numeric and tonumber(row[1]) == numeric then return true end
  local q = compact(query)
  local canonical = tostring(row[2] or "")
  local display = self:GetTeleportDisplayName(row)
  if string.find(compact(canonical), q, 1, true) or string.find(compact(display), q, 1, true) then return true end
  local meta = self:GetTeleportMeta(row)
  if meta and meta.aliases then
    for _, alias in ipairs(meta.aliases) do
      if string.find(compact(alias), q, 1, true) then return true end
    end
  end
  return false
end

function AAM:SearchData(kind, query, limit, offset, favoritesOnly, groupFilter)
  local source = self.Data and self.Data[kind]
  if type(source) ~= "table" then return {}, false, 0 end
  query = tostring(query or ""):match("^%s*(.-)%s*$")
  local q = lower(query)
  limit = math.max(1, tonumber(limit) or 12)
  offset = math.max(0, tonumber(offset) or 0)
  local numeric = tonumber(q)

  -- Teleports are only ~1.6k rows, so collect and sort them for a useful
  -- capital/Pandaria first page.  Other data sets stream to avoid allocating a
  -- second copy of the 80k item index on every search.
  if kind == "Teleports" then
    local candidates = {}
    for _, row in ipairs(source) do
      local id = tonumber(row[1]) or 0
      local queryMatches = self:TeleportMatches(row, query)
      local favoriteMatches = not favoritesOnly or self:IsDataFavorite(kind, id)
      local groupMatches = true
      if groupFilter and groupFilter ~= "all" then
        if groupFilter == "popular" then groupMatches = self:IsTeleportPopular(row)
        else groupMatches = self:GetTeleportGroup(row) == groupFilter end
      end
      if queryMatches and favoriteMatches and groupMatches then candidates[#candidates + 1] = row end
    end
    if groupFilter == "popular" or groupFilter == "capitals" or groupFilter == "pandaria" or favoritesOnly then
      table.sort(candidates, function(a, b)
        local ca, cb = tostring(a[2] or ""), tostring(b[2] or "")
        local pa = (AAM.TeleportPriority and AAM.TeleportPriority[ca]) or 99999
        local pb = (AAM.TeleportPriority and AAM.TeleportPriority[cb]) or 99999
        if pa ~= pb then return pa < pb end
        return AAM:GetTeleportDisplayName(a) < AAM:GetTeleportDisplayName(b)
      end)
    end
    local out = {}
    for i = offset + 1, math.min(#candidates, offset + limit) do out[#out + 1] = candidates[i] end
    return out, #candidates > offset + limit, #candidates
  end

  local out, matched = {}, 0
  for _, row in ipairs(source) do
    local id = tonumber(row[1]) or 0
    local name = tostring(row[2] or "")
    local queryMatches = q == "" or (numeric and id == numeric) or string.find(lower(name), q, 1, true)
    local favoriteMatches = not favoritesOnly or self:IsDataFavorite(kind, id)
    if queryMatches and favoriteMatches then
      matched = matched + 1
      if matched > offset and #out < limit then out[#out + 1] = row end
    end
  end
  return out, matched > offset + limit, matched
end

function AAM:DataAction(kind, row, action, amount)
  if not row then return end
  local id = tonumber(row[1]) or 0
  action = action or "primary"
  if kind == "Items" then
    if action == "remove" then
      self:SendCommand(".removeitem " .. id .. " " .. tostring(tonumber(amount) or 1))
    elseif action == "lookup" then
      self:SendCommand(".lookup item " .. tostring(row[2] or id))
    else
      self:SendCommand(".additem " .. id .. " " .. tostring(tonumber(amount) or 1))
    end
  elseif kind == "Quests" then
    if action == "complete" then self:SendCommand(".quest complete " .. id)
    elseif action == "reward" then self:SendCommand(".quest reward " .. id)
    elseif action == "remove" then self:SendCommand(".quest remove " .. id)
    elseif action == "lookup" then self:SendCommand(".lookup quest " .. tostring(row[2] or id))
    else self:QuestAddSmart(id) end
  elseif kind == "Creatures" then
    if action == "spawn" then self:SendCommand(".npc add " .. id)
    elseif action == "lookup" then self:SendCommand(".lookup creature " .. tostring(row[2] or id))
    else
      -- MOP_V2_Repack cs_go.cpp: a bare number is a spawn GUID. Template entry
      -- navigation must use the explicit `id` selector.
      self:SendCommand(".go creature id " .. id)
    end
  elseif kind == "Teleports" then
    if action == "favorite" then
      self:ToggleDataFavorite(kind, row)
    else
      local canonical = tostring(row[2] or "")
      if canonical ~= "" then self:SendCommand(".tele " .. canonical) end
    end
  end
end

function AAM:DescribeDataRow(kind, row)
  if kind == "Items" then
    return string.format("[%d] %s  iLv:%s Req:%s Q:%s", row[1] or 0, row[2] or "", row[4] or 0, row[5] or 0, row[3] or 0)
  elseif kind == "Quests" then
    return string.format("[%d] %s  Lv:%s Min:%s Zone:%s", row[1] or 0, row[2] or "", row[3] or 0, row[4] or 0, row[5] or 0)
  elseif kind == "Creatures" then
    return string.format("[%d] %s  Lv:%s-%s Rank:%s", row[1] or 0, row[2] or "", row[3] or 0, row[4] or 0, row[5] or 0)
  elseif kind == "Teleports" then
    local display = self:GetTeleportDisplayName(row)
    local canonical = tostring(row[2] or "")
    if display ~= canonical then
      return string.format("%s  |cffa9a9a9[%s]|r  Map:%s", display, canonical, row[3] or 0)
    end
    return string.format("%s  Map:%s", canonical, row[3] or 0)
  end
  return tostring(row[2] or row[1] or "")
end
