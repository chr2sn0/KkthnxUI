local K, C = unpack(select(2, ...))

local _G = _G
local pairs = _G.pairs
local select = _G.select

local CharacterHandsSlot = _G.CharacterHandsSlot
local CharacterHeadSlot = _G.CharacterHeadSlot
local CharacterMainHandSlot = _G.CharacterMainHandSlot
local CharacterModelFrame = _G.CharacterModelFrame
local CharacterSecondaryHandSlot = _G.CharacterSecondaryHandSlot
local CharacterStatsPane = _G.CharacterStatsPane
local GetInventoryItemLink = _G.GetInventoryItemLink
local HideUIPanel = _G.HideUIPanel
local IsCosmeticItem = _G.IsCosmeticItem
local hooksecurefunc = _G.hooksecurefunc
local unpack = _G.unpack

local function UpdateAzeriteItem(self)
	if not self.styled then
		self.styled = true

		self.AzeriteTexture:SetAlpha(0)
		self.RankFrame.Texture:SetTexture()
		self.RankFrame.Label:SetPoint("TOPLEFT", self, 2, -1)
		self.RankFrame.Label:SetTextColor(1, 0.5, 0)
		self.RankFrame.Label:SetFontObject(KkthnxUIFontOutline)
		self.RankFrame.Label:SetFont(select(1, self.RankFrame.Label:GetFont()), 13, select(3, self.RankFrame.Label:GetFont()))
	end
end

local function UpdateAzeriteEmpoweredItem(self)
	self.AzeriteTexture:SetAtlas("AzeriteIconFrame")
	self.AzeriteTexture:SetAllPoints()
	self.AzeriteTexture:SetTexCoord(unpack(K.TexCoords))
	self.AzeriteTexture:SetDrawLayer("BORDER", 1)
end

local function UpdateCosmetic(self)
	local itemLink = GetInventoryItemLink("player", self:GetID())
	self.IconOverlay:SetShown(itemLink and IsCosmeticItem(itemLink))
end

local function ReskinPaperDollSidebar()
	for i = 1, #PAPERDOLL_SIDEBARS do
		local tab = _G["PaperDollSidebarTab"..i]

		if tab and not tab.styled then
			if i == 1 then
				for i = 1, 4 do
					local region = select(i, tab:GetRegions())
					region:SetTexCoord(0.16, 0.86, 0.16, 0.86)
					region.SetTexCoord = K.Noop
				end
			end

			tab.bg = CreateFrame("Frame", nil, tab)
			tab.bg:SetFrameLevel(tab:GetFrameLevel())
			tab.bg:SetAllPoints(tab)
			tab.bg:CreateBorder(nil, nil, nil, nil, nil, 255/255, 223/255, 0/255, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true)

			tab.Icon:SetAllPoints(tab.bg)
			tab.Hider:SetAllPoints(tab.bg)
			tab.Highlight:SetPoint("TOPLEFT", tab.bg, "TOPLEFT", 1, -1)
			tab.Highlight:SetPoint("BOTTOMRIGHT", tab.bg, "BOTTOMRIGHT", -1, 1)
			tab.Highlight:SetColorTexture(1, 1, 1, .25)
			tab.Hider:SetColorTexture(.3, .3, .3, .4)
			tab.TabBg:SetAlpha(0)

			tab.styled = true
		end
	end
end

local function UpdateFactionSkins()
	for i = 1, NUM_FACTIONS_DISPLAYED, 1 do
		local statusbar = _G["ReputationBar"..i.."ReputationBar"]
		if statusbar then
			statusbar:SetStatusBarTexture(K.GetTexture(C["UITextures"].SkinTextures))
		end
	end
end

tinsert(C.defaultThemes, function()
	if CharacterFrame:IsShown() then
		HideUIPanel(CharacterFrame)
	end

	CharacterModelFrame:StripTextures(true)

	for _, slot in pairs({PaperDollItemsFrame:GetChildren()}) do
		if slot:IsObjectType("Button") or slot:IsObjectType("ItemButton") then
			slot:StripTextures()
			slot:CreateBorder()
			slot:StyleButton(slot)
			slot.icon:SetTexCoord(unpack(K.TexCoords))
			slot:SetSize(36, 36)

			if slot.popoutButton:GetPoint() == "TOP" then
				slot.popoutButton:SetPoint("TOP", slot, "BOTTOM", 0, 2)
			else
				slot.popoutButton:SetPoint("LEFT", slot, "RIGHT", -2, 0)
			end

			slot.ignoreTexture:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-LeaveItem-Transparent")
			slot.IconOverlay:SetAtlas("CosmeticIconFrame")
			slot.IconOverlay:SetPoint("TOPLEFT", 1, -1)
			slot.IconOverlay:SetPoint("BOTTOMRIGHT", -1, 1)

			slot.IconBorder:SetAlpha(0)

			hooksecurefunc(slot.IconBorder, "SetVertexColor", function(_, r, g, b)
				slot.KKUI_Border:SetVertexColor(r, g, b)
			end)

			hooksecurefunc(slot.IconBorder, "Hide", function()
				slot.KKUI_Border:SetVertexColor(1, 1, 1)
			end)

			hooksecurefunc(slot, "DisplayAsAzeriteItem", UpdateAzeriteItem)
			hooksecurefunc(slot, "DisplayAsAzeriteEmpoweredItem", UpdateAzeriteEmpoweredItem)
		end
	end

	hooksecurefunc("PaperDollItemSlotButton_Update", function(slot)
		local highlight = slot:GetHighlightTexture()
		highlight:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
		highlight:SetBlendMode("ADD")
		highlight:SetAllPoints()

		UpdateCosmetic(slot)
	end)

	CharacterHeadSlot:SetPoint("TOPLEFT", CharacterFrame.Inset, "TOPLEFT", 6, -6)
	CharacterHandsSlot:SetPoint("TOPRIGHT", CharacterFrame.Inset, "TOPRIGHT", -6, -6)
	CharacterMainHandSlot:SetPoint("BOTTOMLEFT", CharacterFrame.Inset, "BOTTOMLEFT", 176, 5)
	CharacterSecondaryHandSlot:ClearAllPoints()
	CharacterSecondaryHandSlot:SetPoint("BOTTOMRIGHT", CharacterFrame.Inset, "BOTTOMRIGHT", -176, 5)

	CharacterModelFrame:SetSize(0, 0)
	CharacterModelFrame:ClearAllPoints()
	CharacterModelFrame:SetPoint("TOPLEFT", CharacterFrame.Inset, 0, 0)
	CharacterModelFrame:SetPoint("BOTTOMRIGHT", CharacterFrame.Inset, 0, 20)
	CharacterModelFrame:SetCamDistanceScale(1.1)

	hooksecurefunc("CharacterFrame_Expand", function()
		CharacterFrame:SetSize(640, 431) -- 540 + 100, 424 + 7
		CharacterFrame.Inset:SetPoint("BOTTOMRIGHT", CharacterFrame, "BOTTOMLEFT", 432, 4)

		CharacterFrame.Inset.Bg:SetTexture("Interface\\DressUpFrame\\DressingRoom"..K.Class)
		CharacterFrame.Inset.Bg:SetTexCoord(0.00195312, 0.935547, 0.00195312, 0.978516)
		CharacterFrame.Inset.Bg:SetHorizTile(false)
		CharacterFrame.Inset.Bg:SetVertTile(false)
	end)

	hooksecurefunc("CharacterFrame_Collapse", function()
		CharacterFrame:SetHeight(424)
		CharacterFrame.Inset:SetPoint("BOTTOMRIGHT", CharacterFrame, "BOTTOMLEFT", 332, 4)

		CharacterFrame.Inset.Bg:SetTexture("Interface\\FrameGeneral\\UI-Background-Marble", "REPEAT", "REPEAT")
		CharacterFrame.Inset.Bg:SetTexCoord(0, 1, 0, 1)
		CharacterFrame.Inset.Bg:SetHorizTile(true)
		CharacterFrame.Inset.Bg:SetVertTile(true)
	end)

	CharacterLevelText:SetFontObject(KkthnxUIFont)

	local CharItemLvLValue = CharacterStatsPane.ItemLevelFrame.Value
	CharItemLvLValue:SetFontObject(KkthnxUIFont)
	CharItemLvLValue:SetFont(select(1, CharItemLvLValue:GetFont()), 18, select(3, CharItemLvLValue:GetFont()))

	-- Titles
	_G.PaperDollTitlesPane:HookScript('OnShow', function()
		for _, object in pairs(_G.PaperDollTitlesPane.buttons) do
			object.BgTop:SetTexture()
			object.BgBottom:SetTexture()
			object.BgMiddle:SetTexture()
			object.text:SetFontObject(KkthnxUIFont)
			object.text:SetFont(select(1, object.text:GetFont()), 11, select(3, object.text:GetFont()))

			if not object.text.hooked then
				object.text.hooked = true

				hooksecurefunc(object.text, "SetFont", function(txt, font)
					if font ~= KkthnxUIFont then
						txt:SetFontObject(KkthnxUIFont)
						txt:SetFont(select(1, txt:GetFont()), 11, select(3, txt:GetFont()))
					end
				end)
			end
		end
	end)

	CharacterStatsPane.ClassBackground:ClearAllPoints()
	CharacterStatsPane.ClassBackground:SetHeight(CharacterStatsPane.ClassBackground:GetHeight() + 6)
	CharacterStatsPane.ClassBackground:SetParent(CharacterFrameInsetRight)
	CharacterStatsPane.ClassBackground:SetPoint("CENTER")

	-- Buttons used to toggle between equipment manager, titles, and character stats
	hooksecurefunc("PaperDollFrame_UpdateSidebarTabs", ReskinPaperDollSidebar)

	-- Reskin Reputation Statusbars
	hooksecurefunc("ExpandFactionHeader", UpdateFactionSkins)
	hooksecurefunc("CollapseFactionHeader", UpdateFactionSkins)
	hooksecurefunc("ReputationFrame_Update", UpdateFactionSkins)
end)