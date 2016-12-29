local K, C, L = unpack(select(2, ...))

local DataText = K.DataTexts
local NameColor = DataText.NameColor
local ValueColor = DataText.ValueColor

local tonumber = tonumber
local format = format
local date = date

local GetGameTime = GetGameTime
local EuropeString = "%s%02d|r:%s%02d|r"
local UKString = "%s%d|r:%s%02d|r %s%s|r"
local CurrentHour
local CurrentMin
local tslu = 1

local RaidFormat1 = "%s - %s (%d/%d)" -- Siege of Orgrimmar - Mythic (10/14)
local RaidFormat2 = "%s - %s" -- Siege of Orgrimmar - Mythic
local DayHourMinute = "%dd, %dh, %dm"
local HourMinute = "%dh, %dm"
local MinuteSecond = "%dm, %ds"

local AMPM = {
	TIMEMANAGER_PM,
	TIMEMANAGER_AM,
}

local function ConvertTime(Hour, Minute)
	local AmPm
	if C.DataText.Time24Hr == true then
		return Hour, Minute, -1
	else
		if Hour >= 12 then
			if Hour > 12 then Hour = Hour - 12 end
			AmPm = 1
		else
			if Hour == 0 then Hour = 12 end
			AmPm = 2
		end
	end
	return Hour, Minute, AmPm
end

local function CalculateTimeValues(tooltip)
	if (tooltip and C.DataText.LocalTime) or (not tooltip and not C.DataText.LocalTime) then
		return ConvertTime(GetGameTime())
	else
		local dateTable = date("*t")
		return ConvertTime(dateTable["hour"], dateTable["min"])
	end
end

local GetResetTime = function(seconds)
	local Days, Hours, Minutes, Seconds = ChatFrame_TimeBreakDown(floor(seconds))

	if (Days > 0) then
		return format(DayHourMinute, Days, Hours, Minutes) -- 7d, 2h, 5m
	elseif (Hours > 0) then
		return format(HourMinute, Hours, Minutes) -- 12h, 32m
	else
		return format(MinuteSecond, Minutes, Seconds) -- 5m, 42s
	end
end

local tslu = 3
local Update = function(self, t)
	tslu = tslu - t

	if (tslu > 0) then
		return
	end

	local Hour, Minute, AmPm = CalculateTimeValues(false)

	if (CurrentHour == Hour and CurrentMin == Minute and CurrentAmPm == AmPm) and not (tslu < -15000) then
		int = 5
		return
	end

	if (AmPm == -1) then
		self.Text:SetFormattedText(EuropeString, DataText.ValueColor, Hour, DataText.ValueColor, Minute)
	else
		self.Text:SetFormattedText(UKString, DataText.ValueColor, Hour, DataText.ValueColor, Minute, DataText.NameColor, AMPM[AmPm])
	end

	CurrentHour = Hour
	CurrentMin = Minute
	CurrentAmPm = AmPm

	tslu = 5
end

local OnEnter = function(self)
	GameTooltip:SetOwner(self:GetTooltipAnchor())
	GameTooltip:ClearLines()

	local SavedInstances = GetNumSavedInstances()
	local SavedWorldBosses = GetNumSavedWorldBosses()

	if (SavedWorldBosses > 0) then
		GameTooltip:AddLine("World Bosses")

		for i = 1, SavedWorldBosses do
			local Name, _, Reset = GetSavedWorldBossInfo(i)

			if (Name and Reset) then
				local ResetTime = GetResetTime(Reset)

				GameTooltip:AddDoubleLine(Name, ResetTime, 1, 1, 1, 1, 1, 1)
			end
		end
	end

	if ((SavedWorldBosses > 0) and (SavedInstances > 0)) then
		-- Spacing
		GameTooltip:AddLine(" ")
	end

	if (SavedInstances > 0) then
		GameTooltip:AddLine("Saved Raids")

		for i = 1, SavedInstances do
			local Name, _, Reset, _, Locked, Extended, _, IsRaid, _, Difficulty, MaxBosses, DefeatedBosses = GetSavedInstanceInfo(i)

			if (IsRaid and Name and (Locked or Extended)) then
				local ResetTime = GetResetTime(Reset)

				if (MaxBosses and MaxBosses > 0) and (DefeatedBosses and DefeatedBosses > 0) then
					GameTooltip:AddDoubleLine(format(RaidFormat1, Name, Difficulty, DefeatedBosses, MaxBosses), ResetTime, 1, 1, 1, 1, 1, 1)
				else
					GameTooltip:AddDoubleLine(format(RaidFormat2, Name, Difficulty), ResetTime, 1, 1, 1, 1, 1, 1)
				end

				GameTooltip:AddLine(' ')
			end
		end
	end

	local Hour, Minute, AmPm = CalculateTimeValues(true)

	if AmPm == -1 then
		GameTooltip:AddDoubleLine(C.DataText.LocalTime and TIMEMANAGER_TOOLTIP_REALMTIME or TIMEMANAGER_TOOLTIP_LOCALTIME,
		format(string.join("", "%02d", ":|r%02d"), Hour, Minute), 1, 1, 1, {r = 0.3, g = 1, b = 0.3})
	else
		GameTooltip:AddDoubleLine(C.DataText.LocalTime and TIMEMANAGER_TOOLTIP_REALMTIME or TIMEMANAGER_TOOLTIP_LOCALTIME,
		format(string.join("", "", "%d", ":|r%02d", " %s|r"), Hour, Minute, AMPM[AmPm]), 1, 1, 1, {r = 0.3, g = 1, b = 0.3})
end

	GameTooltip:Show()
end

local OnLeave = function()
	GameTooltip:Hide()
end

local Enable = function(self)
	self:SetScript("OnUpdate", Update)
	self:SetScript("OnMouseUp", GameTimeFrame_OnClick)
	self:SetScript("OnEnter", OnEnter)
	self:SetScript("OnLeave", OnLeave)
	self:Update(1)
	RequestRaidInfo()
end

local Disable = function(self)
	self.Text:SetText("")
	self:SetScript("OnUpdate", nil)
	self:SetScript("OnEnter", nil)
	self:SetScript("OnLeave", nil)
end

DataText:Register(L.DataText.Time, Enable, Disable, Update)