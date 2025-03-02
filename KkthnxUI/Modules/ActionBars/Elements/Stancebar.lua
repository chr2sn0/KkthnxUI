local K, C = unpack(select(2, ...))
local Module = K:GetModule("ActionBar")

local _G = _G
local table_insert = _G.table.insert

local CreateFrame = _G.CreateFrame
local NUM_STANCE_SLOTS = _G.NUM_STANCE_SLOTS
local RegisterStateDriver = _G.RegisterStateDriver
local UIParent = _G.UIParent

local cfg = C.Bars.BarStance
local margin, padding = C.Bars.BarMargin, C.Bars.BarPadding

local function SetFrameSize(frame, size, num)
	size = size or frame.buttonSize
	num = num or frame.numButtons

	frame:SetWidth(num * size + (num - 1) * margin + 2 * padding)
	frame:SetHeight(size + 2 * padding + 2)
	if not frame.mover then
		frame.mover = K.Mover(frame, "StanceBar", "StanceBar", frame.Pos)
	else
		frame.mover:SetSize(frame:GetSize())
	end

	if not frame.SetFrameSize then
		frame.buttonSize = size
		frame.numButtons = num
		frame.SetFrameSize = SetFrameSize
	end
end

function Module:CreateStancebar()
	local num = NUM_STANCE_SLOTS
	local buttonList = {}
	local layout = C["ActionBar"].Layout.Value

	local frame = CreateFrame("Frame", "KKUI_ActionBarStance", UIParent, "SecureHandlerStateTemplate")
	if layout == 2 then
		frame.Pos = {"BOTTOM", UIParent, "BOTTOM", -60, 164}
	elseif layout == 3 then
		frame.Pos = {"BOTTOM", UIParent, "BOTTOM", -60, 44}
	else
		frame.Pos = {"BOTTOMLEFT", KKUI_ActionBar3, "TOPLEFT", 0, 6}
	end

	if C["ActionBar"].StanceBar then
		_G.StanceBarFrame:SetParent(frame)
		_G.StanceBarFrame:EnableMouse(false)
		_G.StanceBarLeft:SetTexture(nil)
		_G.StanceBarMiddle:SetTexture(nil)
		_G.StanceBarRight:SetTexture(nil)

		for i = 1, num do
			local button = _G["StanceButton"..i]
			table_insert(buttonList, button)
			table_insert(Module.buttons, button)
			button:ClearAllPoints()

			if i == 1 then
				button:SetPoint("BOTTOMLEFT", frame, padding, padding + 1)
			else
				local previous = _G["StanceButton"..i-1]
				button:SetPoint("LEFT", previous, "RIGHT", margin, 0)
			end
		end
	end

	PossessBarFrame:SetParent(frame)
	PossessBarFrame:EnableMouse(false)
	PossessBackground1:SetTexture(nil)
	PossessBackground2:SetTexture(nil)

	for i = 1, NUM_POSSESS_SLOTS do
		local button = _G["PossessButton"..i]
		table_insert(buttonList, button)
		button:ClearAllPoints()

		if i == 1 then
			button:SetPoint("BOTTOMLEFT", frame, padding, padding + 1)
		else
			local previous = _G["PossessButton"..i - 1]
			button:SetPoint("LEFT", previous, "RIGHT", margin, 0)
		end
	end

	frame.buttonList = buttonList
	SetFrameSize(frame, cfg.size, num)

	frame.frameVisibility = "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show"
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)

	if cfg.fader then
		Module.CreateButtonFrameFader(frame, buttonList, cfg.fader)
	end
end