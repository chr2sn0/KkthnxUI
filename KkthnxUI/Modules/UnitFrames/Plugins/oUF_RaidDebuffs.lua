local K = unpack(select(2, ...))
local oUF = K.oUF or oUF

local _G = _G
local addon = {}

K.oUF_RaidDebuffs = addon
_G.oUF_RaidDebuffs = K.oUF_RaidDebuffs

if not _G.oUF_RaidDebuffs then
	_G.oUF_RaidDebuffs = addon
end

local type, pairs, wipe = type, pairs, wipe

local GetActiveSpecGroup = GetActiveSpecGroup
local GetSpecialization = GetSpecialization
local GetSpellInfo = GetSpellInfo
local UnitAura = UnitAura
local UnitCanAttack = UnitCanAttack
local UnitIsCharmed = UnitIsCharmed

local debuff_data = {}
addon.DebuffData = debuff_data
addon.ShowDispellableDebuff = true
addon.FilterDispellableDebuff = true
addon.MatchBySpellName = false
addon.priority = 10

local function add(spell, priority, stackThreshold)
	if addon.MatchBySpellName and type(spell) == "number" then
		spell = GetSpellInfo(spell)
	end

	if spell then
		debuff_data[spell] = {
			priority = (addon.priority + priority),
			stackThreshold = stackThreshold,
		}
	end
end

function addon:RegisterDebuffs(t)
	for spell in pairs(t) do
		if type(t[spell]) == "boolean" then
			local oldValue = t[spell]
			t[spell] = {enable = oldValue, priority = 0, stackThreshold = 0}
		else
			if t[spell].enable then
				add(spell, t[spell].priority or 0, t[spell].stackThreshold or 0)
			end
		end
	end
end

function addon:ResetDebuffData()
	wipe(debuff_data)
end

local DispellColor = {
	["Magic"]	= {0.2, 0.6, 1},
	["Curse"]	= {0.6, 0, 1},
	["Disease"]	= {0.6, 0.4, 0},
	["Poison"]	= {0, 0.6, 0},
	["none"] = {1, 1, 1},
}

local DispellPriority = {
	["Magic"]	= 4,
	["Curse"]	= 3,
	["Disease"]	= 2,
	["Poison"]	= 1,
}

local DispellFilter
do
	local dispellClasses = {
		["PRIEST"] = {
			["Magic"] = true,
			["Disease"] = true,
		},

		["SHAMAN"] = {
			["Magic"] = false,
			["Curse"] = true,
			["Poison"] = true,
			["Disease"] = true,
		},

		["PALADIN"] = {
			["Poison"] = true,
			["Magic"] = true,
			["Disease"] = true,
		},

		["DRUID"] = {
			["Magic"] = false,
			["Curse"] = true,
			["Poison"] = true,
			["Disease"] = false,
		},

		["MAGE"] = {
			["Curse"] = true,
		},

		["MONK"] = {
			["Magic"] = false,
			["Disease"] = true,
			["Poison"] = true,
		},
	}

	DispellFilter = dispellClasses[select(2, UnitClass("player"))] or {}
end

local function CheckTalentTree(tree)
	local activeGroup = GetActiveSpecGroup()
	if activeGroup and GetSpecialization(false, false, activeGroup) then
		return tree == GetSpecialization(false, false, activeGroup)
	end
end

local playerClass = select(2, UnitClass("player"))
local function CheckSpec(_, event, levels)
	-- Not interested in gained points from leveling
	if event == "CHARACTER_POINTS_CHANGED" and levels > 0 then
		return
	end

	-- Check for certain talents to see if we can dispel magic or not
	if playerClass == "PALADIN" then
		if CheckTalentTree(1) then
			DispellFilter.Magic = true
		else
			DispellFilter.Magic = false
		end
	elseif playerClass == "SHAMAN" then
		if CheckTalentTree(3) then
			DispellFilter.Magic = true
		else
			DispellFilter.Magic = false
		end
	elseif playerClass == "DRUID" then
		if CheckTalentTree(4) then
			DispellFilter.Magic = true
		else
			DispellFilter.Magic = false
		end
	elseif playerClass == "MONK" then
		if CheckTalentTree(2) then
			DispellFilter.Magic = true
		else
			DispellFilter.Magic = false
		end
	end
end

local function UpdateDebuff(self, name, icon, count, debuffType, duration, expiration, _, stackThreshold)
	local f = self.RaidDebuffs

	if name and (count >= stackThreshold) then
		f.icon:SetTexture(icon)
		f.icon:Show()
		f.duration = duration

		if f.count then
			if count and (count > 1) then
				f.count:SetText(count)
				f.count:Show()
			else
				f.count:SetText("")
				f.count:Hide()
			end
		end

		if f.timer then
			if duration and (duration > 0) and f:GetSize() > 20 then
				f.expiration = expiration
				f.nextUpdate = 0
				f:SetScript("OnUpdate", K.CooldownOnUpdate)
				f.timer:Show()
			else
				f:SetScript("OnUpdate", nil)
				f.timer:Hide()
			end
		end

		if f.cd then
			if duration and (duration > 0) then
				f.cd:SetCooldown(expiration - duration, duration)
				f.cd:Show()
			else
				f.cd:Hide()
			end
		end

		local c = DispellColor[debuffType] or DispellColor.none
		if f.KKUI_Border then
			f.KKUI_Border:SetVertexColor(c[1], c[2], c[3])
		end

		f:Show()
	else
		f:Hide()
	end
end

local function Update(self, _, unit)
	if unit ~= self.unit then return end
	local _name, _icon, _count, _dtype, _duration, _expiration, _spellId, _
	local _priority, priority = 0, 0
	local _stackThreshold = 0

	local isCharmed = UnitIsCharmed(unit) -- store if the unit its charmed, mind controlled units (Imperial Vizier Zor"lok: Convert)
	local canAttack = UnitCanAttack("player", unit) -- store if we cand attack that unit, if its so the unit its hostile (Amber-Shaper Un"sok: Reshape Life)

	for i = 1, 40 do
		local name, icon, count, debuffType, duration, expirationTime, _, _, _, spellId = UnitAura(unit, i, "HARMFUL")
		if (not name) then
			break
		end

		-- we coudln"t dispell if the unit its charmed, or its not friendly
		if addon.ShowDispellableDebuff and (self.RaidDebuffs.showDispellableDebuff ~= false) and debuffType and (not isCharmed) and (not canAttack) then
			if addon.FilterDispellableDebuff then
				DispellPriority[debuffType] = (DispellPriority[debuffType] or 0) + addon.priority -- Make Dispell buffs on top of Boss Debuffs
				priority = DispellFilter[debuffType] and DispellPriority[debuffType] or 0
				if priority == 0 then
					debuffType = nil
				end
			else
				priority = DispellPriority[debuffType] or 0
			end

			if priority > _priority then
				_priority, _name, _icon, _count, _dtype, _duration, _expiration, _spellId = priority, name, icon, count, debuffType, duration, expirationTime, spellId
			end
		end

		local debuff
		if self.RaidDebuffs.onlyMatchSpellID then
			debuff = debuff_data[spellId]
		else
			if debuff_data[spellId] then
				debuff = debuff_data[spellId]
			else
				debuff = debuff_data[name]
			end
		end

		priority = debuff and debuff.priority
		if priority and not self.RaidDebuffs.BlackList[spellId] and (priority > _priority) then
			_priority, _name, _icon, _count, _dtype, _duration, _expiration, _spellId = priority, name, icon, count, debuffType, duration, expirationTime, spellId
		end
	end

	if self.RaidDebuffs.forceShow then
		priority = 6
		_spellId = 356667
		_name, _, _icon = GetSpellInfo(_spellId)
		_count, _dtype, _duration, _expiration, _stackThreshold = 2, "Magic", 10, GetTime()+10, 0
	end

	if _name then
		_stackThreshold = debuff_data[addon.MatchBySpellName and _name or _spellId] and debuff_data[addon.MatchBySpellName and _name or _spellId].stackThreshold or _stackThreshold
	end

	UpdateDebuff(self, _name, _icon, _count, _dtype, _duration, _expiration, _spellId, _stackThreshold)

	--Reset the DispellPriority
	DispellPriority["Magic"] = 4
	DispellPriority["Curse"] = 3
	DispellPriority["Disease"] = 2
	DispellPriority["Poison"] = 1
end

local function Enable(self)
	if self.RaidDebuffs then
		self:RegisterEvent("PLAYER_TALENT_UPDATE", CheckSpec, true)
		self:RegisterEvent("CHARACTER_POINTS_CHANGED", CheckSpec, true)
		self:RegisterEvent("UNIT_AURA", Update)

		self.RaidDebuffs.BlackList = self.RaidDebuffs.BlackList or {
			[105171] = true, -- Deep Corruption
			[108220] = true, -- Deep Corruption
			[116095] = true, -- Disable, Slow
			[137637] = true, -- Warbringer, Slow
		}

		return true
	end
end

local function Disable(self)
	if self.RaidDebuffs then
		self:UnregisterEvent("PLAYER_TALENT_UPDATE", CheckSpec, true)
		self:UnregisterEvent("CHARACTER_POINTS_CHANGED", CheckSpec, true)
		self:UnregisterEvent("UNIT_AURA", Update)

		self.RaidDebuffs:Hide()
	end
end

oUF:AddElement("RaidDebuffs", Update, Enable, Disable)