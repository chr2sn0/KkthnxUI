local K, C = unpack(select(2, ...))
local Module = K:GetModule("Tooltip")

-- Sourced: Cloudy Unit Info (Cloudyfa)

local _G = _G
local string_find = _G.string.find
local string_format = _G.string.format
local string_split = _G.string.split
local select = _G.select

local CreateFrame = _G.CreateFrame
local GameTooltip = _G.GameTooltip
local GetAverageItemLevel = _G.GetAverageItemLevel
local GetInspectSpecialization = _G.GetInspectSpecialization
local GetInventoryItemLink = _G.GetInventoryItemLink
local GetInventoryItemTexture = _G.GetInventoryItemTexture
local GetItemGem = _G.GetItemGem
local GetItemInfo = _G.GetItemInfo
local GetSpecialization = _G.GetSpecialization
local GetSpecializationInfo = _G.GetSpecializationInfo
local GetSpecializationInfoByID = _G.GetSpecializationInfoByID
local GetTime = _G.GetTime
local HEIRLOOMS = _G.HEIRLOOMS
local IsShiftKeyDown = _G.IsShiftKeyDown
local LE_ITEM_QUALITY_ARTIFACT = _G.LE_ITEM_QUALITY_ARTIFACT
local LE_ITEM_QUALITY_HEIRLOOM = _G.LE_ITEM_QUALITY_HEIRLOOM
local LFG_LIST_LOADING = _G.LFG_LIST_LOADING
local SPECIALIZATION = _G.SPECIALIZATION
local STAT_AVERAGE_ITEM_LEVEL = _G.STAT_AVERAGE_ITEM_LEVEL
local UnitClass = _G.UnitClass
local UnitExists = _G.UnitExists
local UnitGUID = _G.UnitGUID
local UnitIsDeadOrGhost = _G.UnitIsDeadOrGhost
local UnitIsPlayer = _G.UnitIsPlayer
local UnitIsUnit = _G.UnitIsUnit
local UnitIsVisible = _G.UnitIsVisible
local UnitOnTaxi = _G.UnitOnTaxi

local specPrefix = SPECIALIZATION..": "..K.InfoColor
local levelPrefix = STAT_AVERAGE_ITEM_LEVEL..": "..K.InfoColor
local isPending = LFG_LIST_LOADING
local resetTime, frequency = 900, .5
local cache, weapon, currentUNIT, currentGUID = {}, {}

function Module:InspectOnUpdate(elapsed)
	self.elapsed = (self.elapsed or frequency) + elapsed
	if self.elapsed > frequency then
		self.elapsed = 0
		self:Hide()
		ClearInspectPlayer()

		if currentUNIT and UnitGUID(currentUNIT) == currentGUID then
			K:RegisterEvent("INSPECT_READY", Module.GetInspectInfo)
			NotifyInspect(currentUNIT)
		end
	end
end

local updater = CreateFrame("Frame")
updater:SetScript("OnUpdate", Module.InspectOnUpdate)
updater:Hide()

function Module:ResetUnit(btn)
	if btn == "LSHIFT" and UnitExists("mouseover") then
		GameTooltip:SetUnit("mouseover")
	end
end
K:RegisterEvent("MODIFIER_STATE_CHANGED", Module.ResetUnit)

function Module:GetInspectInfo(...)
	if self == "UNIT_INVENTORY_CHANGED" then
		local unit = ...
		if UnitGUID(unit) == currentGUID then
			Module:InspectUnit(unit, true)
		end
	elseif self == "INSPECT_READY" then
		local guid = ...
		if guid == currentGUID then
			local spec = Module:GetUnitSpec(currentUNIT)
			local level = Module:GetUnitItemLevel(currentUNIT)
			cache[guid].spec = spec
			cache[guid].level = level
			cache[guid].getTime = GetTime()

			if spec and level then
				Module:SetupSpecLevel(spec, level)
			else
				Module:InspectUnit(currentUNIT, true)
			end
		end
		K:UnregisterEvent(self, Module.GetInspectInfo)
	end
end
K:RegisterEvent("UNIT_INVENTORY_CHANGED", Module.GetInspectInfo)

function Module:SetupSpecLevel(spec, level)
	local _, unit = GameTooltip:GetUnit()
	if not unit or UnitGUID(unit) ~= currentGUID then
		return
	end

	local specLine, levelLine
	for i = 2, GameTooltip:NumLines() do
		local line = _G["GameTooltipTextLeft"..i]
		local text = line:GetText()
		if text and string_find(text, specPrefix) then
			specLine = line
		elseif text and string_find(text, levelPrefix) then
			levelLine = line
		end
	end

	spec = specPrefix..(spec or isPending)
	if specLine then
		specLine:SetText(spec)
	else
		GameTooltip:AddLine(spec)
	end

	level = levelPrefix..(level or isPending)
	if levelLine then
		levelLine:SetText(level)
	else
		GameTooltip:AddLine(level)
	end
end

function Module:GetUnitItemLevel(unit)
	if not unit or UnitGUID(unit) ~= currentGUID then
		return
	end

	local class = select(2, UnitClass(unit))
	local ilvl, boa, total, haveWeapon, twohand = 0, 0, 0, 0, 0
	local delay, mainhand, offhand, hasArtifact
	weapon[1], weapon[2] = 0, 0

	for i = 1, 17 do
		if i ~= 4 then
			local itemTexture = GetInventoryItemTexture(unit, i)

			if itemTexture then
				local itemLink = GetInventoryItemLink(unit, i)

				if not itemLink then
					delay = true
				else
					local _, _, quality, level, _, _, _, _, slot = GetItemInfo(itemLink)
					if (not quality) or (not level) then
						delay = true
					else
						if quality == LE_ITEM_QUALITY_HEIRLOOM then
							boa = boa + 1
						end

						if unit ~= "player" then
							level = K.GetItemLevel(itemLink) or level
							if i < 16 then
								total = total + level
							elseif i > 15 and quality == LE_ITEM_QUALITY_ARTIFACT then
								local relics = {select(4, string_split(":", itemLink))}
								for i = 1, 3 do
									local relicID = relics[i] ~= "" and relics[i]
									local relicLink = select(2, GetItemGem(itemLink, i))
									if relicID and not relicLink then
										delay = true
										break
									end
								end
							end

							if i == 16 then
								if quality == LE_ITEM_QUALITY_ARTIFACT then
									hasArtifact = true
								end

								weapon[1] = level
								haveWeapon = haveWeapon + 1
								if slot == "INVTYPE_2HWEAPON" or slot == "INVTYPE_RANGED" or (slot == "INVTYPE_RANGEDRIGHT" and class == "HUNTER") then
									mainhand = true
									twohand = twohand + 1
								end
							elseif i == 17 then
								weapon[2] = level
								haveWeapon = haveWeapon + 1
								if slot == "INVTYPE_2HWEAPON" then
									offhand = true
									twohand = twohand + 1
								end
							end
						end
					end
				end
			end
		end
	end

	if not delay then
		if unit == "player" then
			ilvl = select(2, GetAverageItemLevel())
		else
			if hasArtifact or twohand == 2 then
				local higher = max(weapon[1], weapon[2])
				total = total + higher * 2
			elseif twohand == 1 and haveWeapon == 1 then
				total = total + weapon[1] * 2 + weapon[2] * 2
			elseif twohand == 1 and haveWeapon == 2 then
				if mainhand and weapon[1] >= weapon[2] then
					total = total + weapon[1] * 2
				elseif offhand and weapon[2] >= weapon[1] then
					total = total + weapon[2] * 2
				else
					total = total + weapon[1] + weapon[2]
				end
			else
				total = total + weapon[1] + weapon[2]
			end
			ilvl = total / 16
		end

		if ilvl > 0 then
			ilvl = string_format("%.1f", ilvl)
		end

		if boa > 0 then
			ilvl = ilvl.." |cff00ccff("..boa..HEIRLOOMS..")"
		end
	else
		ilvl = nil
	end

	return ilvl
end

function Module:GetUnitSpec(unit)
	if not unit or UnitGUID(unit) ~= currentGUID then
		return
	end

	local specName
	if unit == "player" then
		local specIndex = GetSpecialization()
		if specIndex then
			specName = select(2, GetSpecializationInfo(specIndex))
		end
	else
		local specID = GetInspectSpecialization(unit)
		if specID and specID > 0 then
			specName = select(2, GetSpecializationInfoByID(specID))
		end
	end

	return specName
end

function Module:InspectUnit(unit, forced)
	local spec, level

	if UnitIsUnit(unit, "player") then
		spec = self:GetUnitSpec("player")
		level = self:GetUnitItemLevel("player")
		self:SetupSpecLevel(spec, level)
	else
		if not unit or UnitGUID(unit) ~= currentGUID then
			return
		end

		if not UnitIsPlayer(unit) then
			return
		end

		local currentDB = cache[currentGUID]
		spec = currentDB.spec
		level = currentDB.level
		self:SetupSpecLevel(spec, level)

		if not C["Tooltip"].SpecLevelByShift and IsShiftKeyDown() then
			forced = true
		end

		if spec and level and not forced and (GetTime() - currentDB.getTime < resetTime) then
			updater.elapsed = frequency
			return
		end

		if not UnitIsVisible(unit) or UnitIsDeadOrGhost("player") or UnitOnTaxi("player") then
			return
		end

		if InspectFrame and InspectFrame:IsShown() then
			return
		end

		self:SetupSpecLevel()
		updater:Show()
	end
end

function Module:InspectUnitSpecAndLevel(unit)
	if C["Tooltip"].SpecLevelByShift and not IsShiftKeyDown() then
		return
	end

	if not unit or not CanInspect(unit) then
		return
	end

	currentUNIT, currentGUID = unit, UnitGUID(unit)
	if not cache[currentGUID] then
		cache[currentGUID] = {}
	end

	Module:InspectUnit(unit)
end