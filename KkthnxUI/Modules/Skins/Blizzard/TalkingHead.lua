local K, C = unpack(select(2, ...))

local _G = _G

C.themes["Blizzard_TalkingHeadUI"] = function()
	local TalkingHeadFrame = _G.TalkingHeadFrame

	TalkingHeadFrame:SetScale(0.9)

	local portraitFrame = TalkingHeadFrame.PortraitFrame
	portraitFrame:StripTextures()
	portraitFrame.Portrait:SetAtlas(nil)
	portraitFrame.Portrait.SetAtlas = K.Noop

	local model = TalkingHeadFrame.MainFrame.Model
	model:SetPoint("TOPLEFT", 30, -27)
	model:SetSize(100, 100)
	model.PortraitBg:SetAtlas(nil)
	model.PortraitBg.SetAtlas = K.Noop
	model:CreateBorder()

	local name = TalkingHeadFrame.NameFrame.Name
	name:SetTextColor(1, 0.8, 0)
	name.SetTextColor = K.Noop
	name:SetShadowColor(0, 0, 0, 0)

	local text = TalkingHeadFrame.TextFrame.Text
	text:SetTextColor(1, 1, 1)
	text.SetTextColor = K.Noop
	text:SetShadowColor(0, 0, 0, 0)

	local closeButton = TalkingHeadFrame.MainFrame.CloseButton
	closeButton:SkinCloseButton()
	closeButton:ClearAllPoints()
	closeButton:SetPoint("TOPRIGHT", -25, -25)
end