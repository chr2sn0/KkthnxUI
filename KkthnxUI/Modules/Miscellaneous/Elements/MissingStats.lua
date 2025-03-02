local K, C = unpack(select(2, ...))
local Module = K:GetModule("Miscellaneous")

local _G = _G
local math_max = _G.math.max
local string_format = _G.string.format

local BreakUpLargeNumbers = _G.BreakUpLargeNumbers
local C_PaperDollInfo_GetMinItemLevel = _G.C_PaperDollInfo.GetMinItemLevel
local CreateFrame = _G.CreateFrame
local GetAverageItemLevel = _G.GetAverageItemLevel
local GetMeleeHaste = _G.GetMeleeHaste
local hooksecurefunc = _G.hooksecurefunc
local IsAddOnLoaded = _G.IsAddOnLoaded
local PaperDollFrame_SetLabelAndText = _G.PaperDollFrame_SetLabelAndText
local UnitAttackSpeed = _G.UnitAttackSpeed

function Module:CreateImprovedStats()
	if not C["Misc"].ImprovedStats then
		return
	end

	if IsAddOnLoaded("DejaCharacterStats") then
		return
	end

	local statPanel = CreateFrame("Frame", nil, CharacterFrameInsetRight)
	statPanel:SetSize(200, 350)
	statPanel:SetPoint("TOP", 0, -5)

	local scrollFrame = CreateFrame("ScrollFrame", nil, statPanel, "UIPanelScrollFrameTemplate")
	scrollFrame:SetAllPoints()
	scrollFrame.ScrollBar:Hide()
	scrollFrame.ScrollBar.Show = K.Noop

	local stat = CreateFrame("Frame", nil, scrollFrame)
	stat:SetSize(200, 1)
	scrollFrame:SetScrollChild(stat)

	CharacterStatsPane:ClearAllPoints()
	CharacterStatsPane:SetParent(stat)
	CharacterStatsPane:SetAllPoints(stat)

	hooksecurefunc("PaperDollFrame_UpdateSidebarTabs", function()
		if (not _G[PAPERDOLL_SIDEBARS[1].frame]:IsShown()) then
			statPanel:Hide()
		else
			statPanel:Show()
		end
	end)

	-- Change default data
	PAPERDOLL_STATCATEGORIES = {
		[1] = {
			categoryFrame = "AttributesCategory",
			stats = {
				[1] = {stat = "STRENGTH", primary = LE_UNIT_STAT_STRENGTH},
				[2] = {stat = "AGILITY", primary = LE_UNIT_STAT_AGILITY},
				[3] = {stat = "INTELLECT", primary = LE_UNIT_STAT_INTELLECT},
				[4] = {stat = "STAMINA"},
				[5] = {stat = "ARMOR"},
				[6] = {stat = "STAGGER", hideAt = 0, roles = {"TANK" }},
				[7] = {stat = "ATTACK_DAMAGE", primary = LE_UNIT_STAT_STRENGTH, roles = { "TANK", "DAMAGER" }},
				[8] = {stat = "ATTACK_AP", hideAt = 0, primary = LE_UNIT_STAT_STRENGTH, roles = { "TANK", "DAMAGER" }},
				[9] = {stat = "ATTACK_ATTACKSPEED", primary = LE_UNIT_STAT_STRENGTH, roles = { "TANK", "DAMAGER" }},
				[10] = {stat = "ATTACK_DAMAGE", primary = LE_UNIT_STAT_AGILITY, roles = { "TANK", "DAMAGER" }},
				[11] = {stat = "ATTACK_AP", hideAt = 0, primary = LE_UNIT_STAT_AGILITY, roles = { "TANK", "DAMAGER" }},
				[12] = {stat = "ATTACK_ATTACKSPEED", primary = LE_UNIT_STAT_AGILITY, roles = { "TANK", "DAMAGER" }},
				[13] = {stat = "SPELLPOWER", hideAt = 0, primary = LE_UNIT_STAT_INTELLECT},
				[14] = {stat = "MANAREGEN", hideAt = 0, primary = LE_UNIT_STAT_INTELLECT},
				[15] = {stat = "ENERGY_REGEN", hideAt = 0, primary = LE_UNIT_STAT_AGILITY},
				[16] = {stat = "RUNE_REGEN", hideAt = 0, primary = LE_UNIT_STAT_STRENGTH},
				[17] = {stat = "FOCUS_REGEN", hideAt = 0, primary = LE_UNIT_STAT_AGILITY},
				[18] = {stat = "MOVESPEED"},
			},
		},

		[2] = {
			categoryFrame = "EnhancementsCategory",
			stats = {
				{stat = "CRITCHANCE", hideAt = 0},
				{stat = "HASTE", hideAt = 0},
				{stat = "MASTERY", hideAt = 0},
				{stat = "VERSATILITY", hideAt = 0},
				{stat = "LIFESTEAL", hideAt = 0},
				{stat = "AVOIDANCE", hideAt = 0},
				{stat = "SPEED", hideAt = 0},
				{stat = "DODGE", roles = {"TANK"}},
				{stat = "PARRY", hideAt = 0, roles = {"TANK"}},
				{stat = "BLOCK", hideAt = 0, showFunc = C_PaperDollInfo.OffhandHasShield},
			},
		},
	}

	PAPERDOLL_STATINFO["ENERGY_REGEN"].updateFunc = function(statFrame, unit)
		statFrame.numericValue = 0
		PaperDollFrame_SetEnergyRegen(statFrame, unit)
	end

	PAPERDOLL_STATINFO["RUNE_REGEN"].updateFunc = function(statFrame, unit)
		statFrame.numericValue = 0
		PaperDollFrame_SetRuneRegen(statFrame, unit)
	end

	PAPERDOLL_STATINFO["FOCUS_REGEN"].updateFunc = function(statFrame, unit)
		statFrame.numericValue = 0
		PaperDollFrame_SetFocusRegen(statFrame, unit)
	end

	function PaperDollFrame_SetAttackSpeed(statFrame, unit)
		local meleeHaste = GetMeleeHaste()
		local speed, offhandSpeed = UnitAttackSpeed(unit)
		local displaySpeed = string_format("%.2f", speed)
		if offhandSpeed then
			offhandSpeed = string_format("%.2f", offhandSpeed)
		end
		if offhandSpeed then
			displaySpeed = BreakUpLargeNumbers(displaySpeed).." / "..offhandSpeed
		else
			displaySpeed = BreakUpLargeNumbers(displaySpeed)
		end
		PaperDollFrame_SetLabelAndText(statFrame, WEAPON_SPEED, displaySpeed, false, speed)

		statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..string_format(PAPERDOLLFRAME_TOOLTIP_FORMAT, ATTACK_SPEED).." "..displaySpeed..FONT_COLOR_CODE_CLOSE
		statFrame.tooltip2 = string_format(STAT_ATTACK_SPEED_BASE_TOOLTIP, BreakUpLargeNumbers(meleeHaste))
		statFrame:Show()
	end

	hooksecurefunc("PaperDollFrame_SetItemLevel", function(statFrame, unit)
		if unit ~= "player" then
			return
		end

		local avgItemLevel, avgItemLevelEquipped = GetAverageItemLevel()
		local minItemLevel = C_PaperDollInfo_GetMinItemLevel()
		local displayItemLevel = math_max(minItemLevel or 0, avgItemLevelEquipped)
		displayItemLevel = string_format("%.1f", displayItemLevel)
		avgItemLevel = string_format("%.1f", avgItemLevel)

		if displayItemLevel ~= avgItemLevel then
			displayItemLevel = displayItemLevel.." / "..avgItemLevel
		end

		PaperDollFrame_SetLabelAndText(statFrame, STAT_AVERAGE_ITEM_LEVEL, displayItemLevel, false, displayItemLevel)
	end)
end

Module:RegisterMisc("ImprovedStats", Module.CreateImprovedStats)