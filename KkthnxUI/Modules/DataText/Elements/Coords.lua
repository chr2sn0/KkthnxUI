local K, C, L = unpack(select(2, ...))
local Module = K:GetModule("Infobar")

local _G = _G
local string_format = _G.string.format

local COMBAT_ZONE = _G.COMBAT_ZONE
local CONTESTED_TERRITORY = _G.CONTESTED_TERRITORY
local C_Map_GetBestMapForUnit = _G.C_Map.GetBestMapForUnit
local FACTION_CONTROLLED_TERRITORY = _G.FACTION_CONTROLLED_TERRITORY
local FACTION_STANDING_LABEL4 = _G.FACTION_STANDING_LABEL4
local FREE_FOR_ALL_TERRITORY = _G.FREE_FOR_ALL_TERRITORY
local GameTooltip = _G.GameTooltip
local GetSubZoneText = _G.GetSubZoneText
local GetZonePVPInfo = _G.GetZonePVPInfo
local GetZoneText = _G.GetZoneText
local IsInInstance = _G.IsInInstance
local SANCTUARY_TERRITORY = _G.SANCTUARY_TERRITORY
local UnitExists = _G.UnitExists
local UnitIsPlayer = _G.UnitIsPlayer
local UnitName = _G.UnitName
local ZONE = _G.ZONE

local coordX = 0
local coordY = 0
local faction
local pvpType
local subzone
local zone

local zoneInfo = {
	arena = {FREE_FOR_ALL_TERRITORY, {0.84, 0.03, 0.03}},
	combat = {COMBAT_ZONE, {0.84, 0.03, 0.03}},
	contested = {CONTESTED_TERRITORY, {0.9, 0.85, 0.05}},
	friendly = {FACTION_CONTROLLED_TERRITORY, {0.05, 0.85, 0.03}},
	hostile = {FACTION_CONTROLLED_TERRITORY, {0.84, 0.03, 0.03}},
	neutral = {string_format(FACTION_CONTROLLED_TERRITORY, FACTION_STANDING_LABEL4), {0.9, 0.85, 0.05}},
	sanctuary = {SANCTUARY_TERRITORY, {0.035, 0.58, 0.84}}
}

local function formatCoords()
	return string_format("%.1f, %.1f", coordX * 100, coordY * 100)
end

local function OnUpdate(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed > 0.1 then
		local x, y = K.GetPlayerMapPos(C_Map_GetBestMapForUnit("player"))
		if x then
			coordX, coordY = x, y
			Module.CoordsDataTextFrame.Text:SetText(string_format("%s", formatCoords()))
			Module.CoordsDataTextFrame:SetScript("OnUpdate", OnUpdate)
			Module.CoordsDataTextFrame:Show()
		else
			coordX, coordY = 0, 0
			Module.CoordsDataTextFrame.Text:SetText(string_format("%s", formatCoords()))
			Module.CoordsDataTextFrame:SetScript("OnUpdate", nil)
			Module.CoordsDataTextFrame:Hide()
		end

		self.elapsed = 0
	end
end

local function OnEvent()
	subzone = GetSubZoneText()
	zone = GetZoneText()
	pvpType, _, faction = GetZonePVPInfo()
	pvpType = pvpType or "neutral"
end

local function OnEnter()
	GameTooltip:SetOwner(Module.CoordsDataTextFrame, "ANCHOR_BOTTOM", 0, -15)
	GameTooltip:ClearLines()

	if pvpType and not IsInInstance() then
		local r, g, b = unpack(zoneInfo[pvpType][2])
		if zone and subzone and subzone ~= "" then
			GameTooltip:AddLine(K.GreyColor..ZONE..":|r "..zone, r, g, b)
			GameTooltip:AddLine(K.GreyColor.."SubZone"..":|r "..subzone, r, g, b)
		else
			GameTooltip:AddLine(K.GreyColor..ZONE..":|r "..zone, r, g, b)
		end
		GameTooltip:AddLine(string_format(K.GreyColor.."PvPType"..":|r "..zoneInfo[pvpType][1], faction or ""), r, g, b)
	end

	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(K.LeftButton..L["WorldMap"], 0.6, 0.8, 1)
	GameTooltip:AddLine(K.RightButton.."Send My Pos", 0.6, 0.8, 1)
	GameTooltip:Show()
end

local function OnLeave()
	GameTooltip:Hide()
end

local function OnMouseUp(_, btn)
	if btn == "LeftButton" then
		ToggleWorldMap()
	elseif btn == "RightButton" then
		local hasUnit = UnitExists("target") and not UnitIsPlayer("target")
		local unitName = nil
		if hasUnit then
			unitName = UnitName("target")
		end

		ChatFrame_OpenChat(string_format("%s: %s %s (%s) %s", "My Position", zone, subzone or "", formatCoords(), unitName or ""), SELECTED_DOCK_FRAME)
	end
end

function Module:CreateCoordsDataText()
	if not C["DataText"].Coords then
		return
	end

	Module.CoordsDataTextFrame = CreateFrame("Button", nil, UIParent)
	Module.CoordsDataTextFrame:SetPoint("TOP", UIParent, "TOP", 0, -40)
	Module.CoordsDataTextFrame:SetSize(20, 20)

	Module.CoordsDataTextFrame.Texture = Module.CoordsDataTextFrame:CreateTexture(nil, "BACKGROUND")
	Module.CoordsDataTextFrame.Texture:SetPoint("CENTER", Module.CoordsDataTextFrame, "CENTER", 0, 0)
	Module.CoordsDataTextFrame.Texture:SetAtlas("Navigation-Tracked-Icon")
	Module.CoordsDataTextFrame.Texture:SetSize(15, 20)
	Module.CoordsDataTextFrame.Texture:SetAlpha(0.8)

	Module.CoordsDataTextFrame.Text = Module.CoordsDataTextFrame:CreateFontString(nil, "ARTWORK")
	Module.CoordsDataTextFrame.Text:SetFontObject(K.GetFont(C["UIFonts"].DataTextFonts))
	Module.CoordsDataTextFrame.Text:SetPoint("CENTER", Module.CoordsDataTextFrame.Texture, "CENTER", 0, -14)

	Module.CoordsDataTextFrame:RegisterEvent("ZONE_CHANGED", OnEvent)
	Module.CoordsDataTextFrame:RegisterEvent("ZONE_CHANGED_INDOORS", OnEvent)
	Module.CoordsDataTextFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA", OnEvent)
	Module.CoordsDataTextFrame:RegisterEvent("PLAYER_ENTERING_WORLD", OnEvent)

	Module.CoordsDataTextFrame:SetScript("OnMouseUp", OnMouseUp)
	Module.CoordsDataTextFrame:SetScript("OnUpdate", OnUpdate)
	Module.CoordsDataTextFrame:SetScript("OnLeave", OnLeave)
	Module.CoordsDataTextFrame:SetScript("OnEnter", OnEnter)
	Module.CoordsDataTextFrame:SetScript("OnEvent", OnEvent)

	K.Mover(Module.CoordsDataTextFrame, "CoordsDataText", "CoordsDataText", {"TOP", UIParent, "TOP", 0, -40})
end