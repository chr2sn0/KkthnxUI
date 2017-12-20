local K, C, L = unpack(select(2, ...))

local Module = K:NewModule("Artifact_DataBar", "AceEvent-3.0")

local _G = _G
local format, gsub, strmatch, strfind = string.format, string.gsub, string.match, string.find
local tonumber, select, pcall = tonumber, select, pcall

local AP_NAME = format("%s|r", ARTIFACT_POWER)
local ARTIFACT_POWER = ARTIFACT_POWER
local ARTIFACT_POWER_TOOLTIP_BODY = ARTIFACT_POWER_TOOLTIP_BODY
local BreakUpLargeNumbers = BreakUpLargeNumbers
local C_ArtifactUI_GetEquippedArtifactInfo = C_ArtifactUI.GetEquippedArtifactInfo
local GetContainerItemInfo = GetContainerItemInfo
local GetContainerItemLink = GetContainerItemLink
local GetContainerNumSlots = GetContainerNumSlots
local GetItemSpell = GetItemSpell
local GetSpellInfo = GetSpellInfo
local HasArtifactEquipped = HasArtifactEquipped
local HideUIPanel = HideUIPanel
local InCombatLockdown = InCombatLockdown
local IsArtifactPowerItem = IsArtifactPowerItem
local MainMenuBar_GetNumArtifactTraitsPurchasableFromXP = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP
local ShowUIPanel = ShowUIPanel
local SocketInventoryItem = SocketInventoryItem

local ArtifactFont = K.GetFont(C["DataBars"].Font)
local ArtifactTexture = K.GetTexture(C["DataBars"].Texture)

local AnchorY

function Module:UpdateArtifact(event, unit)
	if not C["DataBars"].ArtifactEnable then return end

	if (event == "UNIT_INVENTORY_CHANGED" and unit ~= "player") then
		return
	end

	if (event == "PLAYER_ENTERING_WORLD") then
		self.artifactBar.eventFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end

	local bar = self.artifactBar
	local showArtifact = HasArtifactEquipped()

	if not showArtifact then
		bar:Hide()
	elseif showArtifact and not InCombatLockdown() then
		bar:Show()

		local _, _, _, _, totalXP, pointsSpent, _, _, _, _, _, _, artifactTier = C_ArtifactUI_GetEquippedArtifactInfo()
		local _, xp, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP, artifactTier)

		bar.statusBar:SetMinMaxValues(0, xpForNextPoint)
		bar.statusBar:SetValue(xp)

		local text = format("%d%%", xp / xpForNextPoint * 100)

		bar.text:SetText(text)
	end
end

function Module:ArtifactBar_OnEnter()
	GameTooltip:ClearLines()
	GameTooltip_SetDefaultAnchor(GameTooltip, self)

	local _, _, artifactName, _, totalXP, pointsSpent, _, _, _, _, _, _, artifactTier = C_ArtifactUI_GetEquippedArtifactInfo()
	local numPointsAvailableToSpend, xp, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP, artifactTier)

	GameTooltip:AddDoubleLine(ARTIFACT_POWER, artifactName, nil, nil, nil, 0.90, 0.80,	0.50)
	GameTooltip:AddLine(" ")

	local remaining = xpForNextPoint - xp
	local apInBags = self.BagArtifactPower

	GameTooltip:AddDoubleLine("XP:", format(" %s / %s (%d%%)", K.ShortValue(xp), K.ShortValue(xpForNextPoint), xp/xpForNextPoint * 100), 1, 1, 1)
	GameTooltip:AddDoubleLine("Remaining:", format(" %s (%d%% - %d %s)", K.ShortValue(xpForNextPoint - xp), remaining / xpForNextPoint * 100, 20 * remaining / xpForNextPoint, "Bars"), 1, 1, 1)
	if (numPointsAvailableToSpend > 0) then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(format(ARTIFACT_POWER_TOOLTIP_BODY, numPointsAvailableToSpend), nil, nil, nil, true)
	end

	GameTooltip:Show()
end

function Module:ArtifactBar_OnLeave()
	GameTooltip:Hide()
end

function Module:ArtifactBar_OnClick()
	if not ArtifactFrame or not ArtifactFrame:IsShown() then
		ShowUIPanel(SocketInventoryItem(16))
	elseif ArtifactFrame and ArtifactFrame:IsShown() then
		HideUIPanel(ArtifactFrame)
	end
end

function Module:UpdateArtifactDimensions()
	self.artifactBar:SetSize(Minimap:GetWidth() or C["DataBars"].ExperienceWidth, C["DataBars"].ExperienceHeight)
	self.artifactBar.text:SetFont(C["Media"].Font, C["Media"].FontSize - 1, C["DataBars"].Outline and "OUTLINE" or "", "CENTER")
	self.artifactBar.text:SetShadowOffset(C["DataBars"].Outline and 0 or 1.25, C["DataBars"].Outline and -0 or -1.25)
end

function Module:EnableDisable_ArtifactBar()
	if C["DataBars"].ArtifactEnable then
		self:RegisterEvent("ARTIFACT_XP_UPDATE", "UpdateArtifact")
		self:RegisterEvent("UNIT_INVENTORY_CHANGED", "UpdateArtifact")
		self:RegisterEvent("BAG_UPDATE_DELAYED", "UpdateArtifact")

		self:UpdateArtifact()
	else
		self:UnregisterEvent("ARTIFACT_XP_UPDATE")
		self:UnregisterEvent("UNIT_INVENTORY_CHANGED")
		self:UnregisterEvent("BAG_UPDATE_DELAYED")

		self.artifactBar:Hide()
	end
end

function Module:OnEnable()
	if K.Level ~= MAX_PLAYER_LEVEL then
		AnchorY = -24
	else
		AnchorY = -6
	end

	self.artifactBar = CreateFrame("Button", "KkthnxUI_ArtifactBar", UIParent)
	self.artifactBar:SetPoint("TOP", Minimap, "BOTTOM", 0, AnchorY)
	self.artifactBar:SetScript("OnEnter", Module.ArtifactBar_OnEnter)
	self.artifactBar:SetScript("OnLeave", Module.ArtifactBar_OnLeave)
	self.artifactBar:SetScript("OnClick", Module.ArtifactBar_OnClick)
	self.artifactBar:SetFrameStrata("LOW")
	self.artifactBar:Hide()

	self.artifactBar.statusBar = CreateFrame("StatusBar", nil, self.artifactBar)
	self.artifactBar.statusBar:SetAllPoints()
	self.artifactBar.statusBar:SetStatusBarTexture(ArtifactTexture)
	self.artifactBar.statusBar:SetStatusBarColor(.901, .8, .601)
	self.artifactBar.statusBar:SetMinMaxValues(0, 325)
	self.artifactBar.statusBar:SetTemplate("Transparent")

	self.artifactBar.text = self.artifactBar.statusBar:CreateFontString(nil, "OVERLAY")
	self.artifactBar.text:SetFont(C["Media"].Font, C["Media"].FontSize - 1, C["DataBars"].Outline and "OUTLINE" or "", "CENTER")
	self.artifactBar.text:SetShadowOffset(C["DataBars"].Outline and 0 or 1.25, C["DataBars"].Outline and -0 or -1.25)
	self.artifactBar.text:SetPoint("CENTER")

	self.artifactBar.spark = self.artifactBar.statusBar:CreateTexture(nil, "ARTWORK", nil, 1)
	self.artifactBar.spark:SetWidth(12)
	self.artifactBar.spark:SetHeight(self.artifactBar.statusBar:GetHeight() * 3)
	self.artifactBar.spark:SetTexture(C["Media"].Spark)
	self.artifactBar.spark:SetBlendMode("ADD")
	self.artifactBar.spark:SetPoint("CENTER", self.artifactBar.statusBar:GetStatusBarTexture(), "RIGHT", 0, 0)

	self.artifactBar.eventFrame = CreateFrame("Frame")
	self.artifactBar.eventFrame:Hide()
	self.artifactBar.eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
	self.artifactBar.eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
	self.artifactBar.eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	self.artifactBar.eventFrame:SetScript("OnEvent", function(self, event) Module:UpdateArtifact(event) end)

	self:UpdateArtifactDimensions()
	K.Movers:RegisterFrame(self.artifactBar)
	self:EnableDisable_ArtifactBar()
end
