local K, C = unpack(select(2, ...))

-- Lua
local _G = _G

local GetInventoryItemLink = _G.GetInventoryItemLink
local HideUIPanel = _G.HideUIPanel
local IsCosmeticItem = _G.IsCosmeticItem
local PanelTemplates_GetSelectedTab = _G.PanelTemplates_GetSelectedTab
local UnitClass = _G.UnitClass
local hooksecurefunc = _G.hooksecurefunc

local function UpdateCosmetic(self)
	local unit = InspectFrame.unit
	local itemLink = unit and GetInventoryItemLink(unit, self:GetID())
	self.IconOverlay:SetShown(itemLink and IsCosmeticItem(itemLink))
	self.IconOverlay:SetPoint("TOPLEFT", 1, -1)
	self.IconOverlay:SetPoint("BOTTOMRIGHT", -1, 1)
end

C.themes["Blizzard_InspectUI"] = function()
	if InspectFrame:IsShown() then
		HideUIPanel(InspectFrame)
	end

	InspectModelFrame:StripTextures(true)

	for _, slot in pairs({InspectPaperDollItemsFrame:GetChildren()}) do
		if slot:IsObjectType("Button") or slot:IsObjectType("ItemButton") then
			slot:StripTextures()
			slot:CreateBorder()
			slot:StyleButton()
			slot.icon:SetTexCoord(unpack(K.TexCoords))
			slot:SetSize(36, 36)

			slot.IconBorder:SetAlpha(0)
			hooksecurefunc(slot.IconBorder, "SetVertexColor", function(_, r, g, b)
				slot.KKUI_Border:SetVertexColor(r, g, b)
			end)

			hooksecurefunc(slot.IconBorder, "Hide", function()
				slot.KKUI_Border:SetVertexColor(1, 1, 1)
			end)
		end
	end

	hooksecurefunc("InspectPaperDollItemSlotButton_Update", function(button)
		button.icon:SetShown(button.hasItem)
		UpdateCosmetic(button)
	end)

	InspectHeadSlot:SetPoint("TOPLEFT", InspectFrame.Inset, "TOPLEFT", 6, -6)
	InspectHandsSlot:SetPoint("TOPRIGHT", InspectFrame.Inset, "TOPRIGHT", -6, -6)
	InspectMainHandSlot:SetPoint("BOTTOMLEFT", InspectFrame.Inset, "BOTTOMLEFT", 176, 5)
	InspectSecondaryHandSlot:ClearAllPoints()
	InspectSecondaryHandSlot:SetPoint("BOTTOMRIGHT", InspectFrame.Inset, "BOTTOMRIGHT", -176, 5)

	InspectModelFrame:SetSize(0, 0)
	InspectModelFrame:ClearAllPoints()
	InspectModelFrame:SetPoint("TOPLEFT", InspectFrame.Inset, 0, 0)
	InspectModelFrame:SetPoint("BOTTOMRIGHT", InspectFrame.Inset, 0, 30)
	InspectModelFrame:SetCamDistanceScale(1.1)

	-- Adjust the inset based on tabs
	local OnInspectSwitchTabs = function(newID)
		local tabID = newID or PanelTemplates_GetSelectedTab(InspectFrame)
		if tabID == 1 then
			InspectFrame:SetSize(438, 431) -- 338 + 100, 424 + 7
			InspectFrame.Inset:SetPoint("BOTTOMRIGHT", InspectFrame, "BOTTOMLEFT", 432, 4)

			local _, targetClass = UnitClass("target")
			if targetClass then
				InspectFrame.Inset.Bg:SetTexture("Interface\\DressUpFrame\\DressingRoom"..targetClass)
				InspectFrame.Inset.Bg:SetTexCoord(0.00195312, 0.935547, 0.00195312, 0.978516)
				InspectFrame.Inset.Bg:SetHorizTile(false)
				InspectFrame.Inset.Bg:SetVertTile(false)
			end
		else
			InspectFrame:SetSize(338, 424)
			InspectFrame.Inset:SetPoint("BOTTOMRIGHT", InspectFrame, "BOTTOMLEFT", 332, 4)

			InspectFrame.Inset.Bg:SetTexture("Interface\\FrameGeneral\\UI-Background-Marble", "REPEAT", "REPEAT")
			InspectFrame.Inset.Bg:SetTexCoord(0, 1, 0, 1)
			InspectFrame.Inset.Bg:SetHorizTile(true)
			InspectFrame.Inset.Bg:SetVertTile(true)
		end
	end

	-- Hook it to tab switches
	hooksecurefunc("InspectSwitchTabs", OnInspectSwitchTabs)
	-- Call it once to apply it from the start
	OnInspectSwitchTabs(1)
end