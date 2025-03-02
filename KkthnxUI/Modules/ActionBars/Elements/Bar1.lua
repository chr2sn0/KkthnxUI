local K, C, L = unpack(select(2, ...))
local Module = K:NewModule("ActionBar")

local _G = _G
local next = _G.next
local table_insert = _G.table.insert

local CreateFrame = _G.CreateFrame
local GetActionTexture = _G.GetActionTexture
local NUM_ACTIONBAR_BUTTONS = _G.NUM_ACTIONBAR_BUTTONS
local RegisterStateDriver = _G.RegisterStateDriver
local UIParent = _G.UIParent

local cfg = C.Bars.Bar1
local margin, padding = C.Bars.BarMargin, C.Bars.BarPadding

local function UpdateActionbarScale(bar)
	local frame = _G["KKUI_Action"..bar]
	if not frame then return end

	local size = frame.buttonSize * C["ActionBar"].Scale
	frame:SetFrameSize(size)
	for _, button in pairs(frame.buttonList) do
		button:SetSize(size, size)
		button.Name:SetScale(C["ActionBar"].Scale)
		button.Count:SetScale(C["ActionBar"].Scale)
		button.HotKey:SetScale(C["ActionBar"].Scale)
	end
end

function Module:UpdateAllScale()
	if not C["ActionBar"].Enable then
		return
	end

	UpdateActionbarScale("Bar1")
	UpdateActionbarScale("Bar2")
	UpdateActionbarScale("Bar3")
	UpdateActionbarScale("Bar4")
	UpdateActionbarScale("Bar5")

	UpdateActionbarScale("BarExit")
	UpdateActionbarScale("BarPet")
	UpdateActionbarScale("BarStance")
end

local function SetFrameSize(frame, size, num)
	size = size or frame.buttonSize
	num = num or frame.numButtons

	local layout = C["ActionBar"].Layout.Value
	if layout == 3 then
		frame:SetWidth(3 * size + (3 - 1) * margin + 2 * padding)
		frame:SetHeight(4 * size + (4 - 1) * margin + 2 * padding)
	else
		frame:SetWidth(num * size + (num - 1) * margin + 2 * padding)
		frame:SetHeight(size + 2 * padding)
	end

	if not frame.mover then
		frame.mover = K.Mover(frame, L["Main Actionbar"], "Bar1", frame.Pos)
	else
		frame.mover:SetSize(frame:GetSize())
	end

	if not frame.SetFrameSize then
		frame.buttonSize = size
		frame.numButtons = num
		frame.SetFrameSize = SetFrameSize
	end
end

function Module:CreateBar1()
	local num = NUM_ACTIONBAR_BUTTONS
	local buttonList = {}
	local layout = C["ActionBar"].Layout.Value

	local frame = CreateFrame("Frame", "KKUI_ActionBar1", UIParent, "SecureHandlerStateTemplate")

	if layout == 3 then
		frame.Pos = {"BOTTOM", UIParent, "BOTTOM", -305, 124}
	else
		frame.Pos = {"BOTTOM", UIParent, "BOTTOM", 0, 4}
	end

	for i = 1, num do
		local button = _G["ActionButton"..i]
		table_insert(buttonList, button)
		table_insert(Module.buttons, button)
		button:SetParent(frame)
		button:ClearAllPoints()

		if layout == 3 then
			if i == 1 then
				button:SetPoint("TOPLEFT", frame, padding, padding)
			elseif (i - 1) % 3 == 0 then
				local previous = _G["ActionButton"..i - 3]
				button:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, margin * (-1))
			else
				local previous = _G["ActionButton"..i - 1]
				button:SetPoint("LEFT", previous, "RIGHT", margin, 0)
			end
		else
			if i == 1 then
				button:SetPoint("BOTTOMLEFT", frame, padding, padding)
			else
				local previous = _G["ActionButton"..i - 1]
				button:SetPoint("LEFT", previous, "RIGHT", margin, 0)
			end
		end
	end

	frame.buttonList = buttonList
	SetFrameSize(frame, cfg.size, num)

	frame.frameVisibility = "[petbattle] hide; show"
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)

	if cfg.fader then
		Module.CreateButtonFrameFader(frame, buttonList, cfg.fader)
	end

	local actionPage = "[bar:6]6;[bar:5]5;[bar:4]4;[bar:3]3;[bar:2]2;[overridebar]14;[shapeshift]13;[vehicleui]12;[possessbar]12;[bonusbar:5]11;[bonusbar:4]10;[bonusbar:3]9;[bonusbar:2]8;[bonusbar:1]7;1"
	local buttonName = "ActionButton"
	for i, button in next, buttonList do
		frame:SetFrameRef(buttonName..i, button)
	end

	frame:Execute(([[
	buttons = table.new()
	for i = 1, %d do
		table.insert(buttons, self:GetFrameRef("%s"..i))
	end
	]]):format(num, buttonName))

	frame:SetAttribute("_onstate-page", [[
	for _, button in next, buttons do
		button:SetAttribute("actionpage", newstate)
	end
	]])
	RegisterStateDriver(frame, "page", actionPage)

	local function FixActionBarTexture()
		for _, button in next, buttonList do
			local action = button.action
			if action < 120 then
				break
			end

			local icon = button.icon
			local texture = GetActionTexture(action)
			if texture then
				icon:SetTexture(texture)
				icon:Show()
			else
				icon:Hide()
			end
			Module.UpdateButtonStatus(button)
		end
	end
	K:RegisterEvent("SPELL_UPDATE_ICON", FixActionBarTexture)
	K:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR", FixActionBarTexture)
	K:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR", FixActionBarTexture)
end

function Module:OnEnable()
	Module.buttons = {}

	self:CreateMicroMenu()

	if not C["ActionBar"].Enable then
		return
	end

	if IsAddOnLoaded("Dominos") or IsAddOnLoaded("Bartender4") or IsAddOnLoaded("RazerNaga") then
		return
	end

	self:CreateBar1()
	self:CreateBar2()
	self:CreateBar3()
	self:CreateBar4()
	self:CreateBar5()
	self:CreateCustomBar()
	self:CreateExtrabar()
	self:CreateLeaveVehicle()
	self:CreatePetbar()
	self:CreateStancebar()
	self:HideBlizz()
	self:CreateBarSkin()
	self:UpdateAllScale()
end