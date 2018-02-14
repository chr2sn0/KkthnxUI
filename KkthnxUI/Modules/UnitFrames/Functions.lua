local K, C, L = unpack(select(2, ...))
if C["Unitframe"].Enable ~= true and C["Raidframe"].Enable ~= true then return end

-- Lua API
local _G = _G
local pairs = pairs
local string_format = string.format
local table_insert = table.insert

-- Wow API
local CreateFrame = _G.CreateFrame
local DEAD = _G.DEAD
local GetSpellInfo = _G.GetSpellInfo
local PLAYER_OFFLINE = _G.PLAYER_OFFLINE
local PlaySound = _G.PlaySound
local PlaySound = _G.PlaySound
local UnitExists = _G.UnitExists
local UnitHealth = _G.UnitHealth
local UnitHealthMax = _G.UnitHealthMax
local UnitIsConnected = _G.UnitIsConnected
local UnitIsDead = _G.UnitIsDead
local UnitIsDeadOrGhost = _G.UnitIsDeadOrGhost
local UnitIsEnemy = _G.UnitIsEnemy
local UnitIsFriend = _G.UnitIsFriend
local UnitIsGhost = _G.UnitIsGhost
local UnitIsPVP = _G.UnitIsPVP
local UnitIsPVPFreeForAll = _G.UnitIsPVPFreeForAll
local UnitSelectionColor = _G.UnitSelectionColor

-- Global variables that we don"t cache, list them here for mikk"s FindGlobals script
-- GLOBALS: UnitFrame_OnLeave, UnitFrame_OnEnter

local _, ns = ...
local oUF = ns.oUF or oUF
if not oUF then return end
local colors = K.Colors

local Module = CreateFrame("Frame")
Module:SetScript("OnEvent", function(self, event, ...)
	return self[event] and self[event](self, event, ...)
end)

-- AuraWatch
local RaidBuffsPosition = {
	TOPLEFT = {6, 1},
	TOPRIGHT = {-6, 1},
	BOTTOMLEFT = {6, 1},
	BOTTOMRIGHT = {-6, 1},
	LEFT = {6, 1},
	RIGHT = {-6, 1},
	TOP = {0, 0},
	BOTTOM = {0, 0},
}

function K.UpdateAllElements(frame)
	for _, v in ipairs(frame.__elements) do
		v(frame, "UpdateElement", frame.unit)
	end
end

function K.MultiCheck(check, ...)
	for i = 1, select("#", ...) do
		if (check == select(i, ...)) then
			return true
		end
	end

	return false
end

local function UpdatePortraitColor(self, unit, min, max)
	if C["Unitframe"].PortraitStyle.Value == "ThreeDPortraits" then return end

	if (not UnitIsConnected(unit)) then
		self.Portrait:SetVertexColor(0.5, 0.5, 0.5, 0.7)
	elseif (UnitIsDead(unit)) then
		self.Portrait:SetVertexColor(0.35, 0.35, 0.35, 0.7)
	elseif (UnitIsGhost(unit)) then
		self.Portrait:SetVertexColor(0.3, 0.3, 0.9, 0.7)
	elseif (max == 0 or min/max * 100 < 25) then
		if (UnitIsPlayer(unit)) then
			if (unit ~= "player") then
				self.Portrait:SetVertexColor(1, 0, 0, 0.7)
			end
		end
	else
		self.Portrait:SetVertexColor(1, 1, 1, 1)
	end
end

-- PostUpdateHealth
function K.PostUpdateHealth(self, unit, cur, min, max)
	if self.Portrait and not C["Unitframe"].PortraitStyle.Value == "ThreeDPortraits" then
		UpdatePortraitColor(self, unit, cur, max)
	end
end

function K.CreateAuraWatchIcon(icon)
	if icon.icon and not icon.hideIcon then
		icon:SetBackdrop(K.TwoPixelBorder)
		icon.icon:SetPoint("TOPLEFT", icon, 1, -1)
		icon.icon:SetPoint("BOTTOMRIGHT", icon, -1, 1)
		icon.icon:SetTexCoord(.08, .92, .08, .92)
		icon.icon:SetDrawLayer("ARTWORK")

		if (icon.cd) then
			icon.cd:SetHideCountdownNumbers(true)
			icon.cd:SetReverse(true)
		end

		if icon.overlay then
			icon.overlay:SetTexture()
		end
	end
end

function K.CreateAuraWatch(self)
	local auras = CreateFrame("Frame", nil, self)
	auras:SetPoint("TOPLEFT", self.Health, 2, -2)
	auras:SetPoint("BOTTOMRIGHT", self.Health, -2, 2)
	auras.presentAlpha = 1
	auras.missingAlpha = 0
	auras.icons = {}
	auras.PostCreateIcon = K.CreateAuraWatchIcon
	auras.strictMatching = true

	local buffs = {}

	if K.RaidBuffs["ALL"] then
		for key, value in pairs(K.RaidBuffs["ALL"]) do
			table_insert(buffs, value)
		end
	end

	if K.RaidBuffs[K.Class] then
		for key, value in pairs(K.RaidBuffs[K.Class]) do
			table_insert(buffs, value)
		end
	end

	if buffs then
		for key, spell in pairs(buffs) do
			local icon = CreateFrame("Frame", nil, auras)
			icon.spellID = spell[1]
			icon.anyUnit = spell[4]
			icon:SetWidth(C["Raidframe"].AuraWatchIconSize)
			icon:SetHeight(C["Raidframe"].AuraWatchIconSize)
			icon:SetPoint(spell[2], 0, 0)

			local tex = icon:CreateTexture(nil, "OVERLAY")
			tex:SetAllPoints(icon)
			tex:SetTexture(C["Media"].Blank)
			if spell[3] then
				tex:SetVertexColor(unpack(spell[3]))
			else
				tex:SetVertexColor(0.8, 0.8, 0.8)
			end

			local count = icon:CreateFontString(nil, "OVERLAY")
			count:SetFont(C["Media"].Font, 8, "THINOUTLINE")
			count:SetPoint("CENTER", unpack(RaidBuffsPosition[spell[2]]))
			icon.count = count

			auras.icons[spell[1]] = icon
		end
	end

	self.AuraWatch = auras
end

Module:RegisterEvent("PLAYER_TARGET_CHANGED")
Module:RegisterEvent("PLAYER_FOCUS_CHANGED")
Module:RegisterUnitEvent("UNIT_FACTION", "player")

local function CreateTargetSound(unit)
	if UnitExists(unit) then
		if UnitIsEnemy(unit, "player") then
			PlaySound(PlaySoundKitID and "Igcreatureaggroselect" or SOUNDKIT.IG_CREATURE_AGGRO_SELECT)
		elseif UnitIsFriend("player", unit) then
			PlaySound(PlaySoundKitID and "Igcharacternpcselect" or SOUNDKIT.IG_CHARACTER_NPC_SELECT)
		else
			PlaySound(PlaySoundKitID and "Igcreatureneutralselect" or SOUNDKIT.IG_CREATURE_NEUTRAL_SELECT)
		end
	else
		PlaySound(PlaySoundKitID and "igcreatureaggrodeselect" or SOUNDKIT.INTERFACE_SOUND_LOST_TARGET_UNIT)
	end
end

function Module:PLAYER_FOCUS_CHANGED(event)
	CreateTargetSound("focus")
end

function Module:PLAYER_TARGET_CHANGED(event)
	CreateTargetSound("target")
end

local announcedPVP
function Module:UNIT_FACTION(event, unit)
	if UnitIsPVPFreeForAll("player") or UnitIsPVP("player") then
		if not announcedPVP then
			announcedPVP = true
			PlaySound(PlaySoundKitID and "IgPVPUpdate" or SOUNDKIT.IG_PVP_UPDATE)
		end
	else
		announcedPVP = nil
	end
end