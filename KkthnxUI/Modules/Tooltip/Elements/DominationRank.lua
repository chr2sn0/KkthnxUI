local K, C = unpack(select(2, ...))
local Module = K:GetModule("Tooltip")

local _G = _G
local select = _G.select
local string_format = _G.string.format
local string_find = _G.string.find
local string_match = _G.string.match
local tonumber = _G.tonumber

local GetItemInfo = _G.GetItemInfo
local GetItemInfoFromHyperlink = _G.GetItemInfoFromHyperlink

local DOMI_RANK_STRING = "%s (%d/5)"
local nameCache = {}

Module.DomiRankData = {}
Module.DomiIndexData = {}
Module.DomiDataByGroup = {
	[1] = {
		[187079] = 1, -- 泽德碎片
		[187292] = 2, -- 不祥泽德碎片
		[187301] = 3, -- 荒芜泽德碎片
		[187310] = 4, -- 预感泽德碎片
		[187320] = 5, -- 征兆泽德碎片
	},
	[2] = {
		[187076] = 1, -- 欧兹碎片
		[187291] = 2, -- 不祥欧兹碎片
		[187300] = 3, -- 荒芜欧兹碎片
		[187309] = 4, -- 预感欧兹碎片
		[187319] = 5, -- 征兆欧兹碎片
	},
	[3] = {
		[187073] = 1, -- 迪兹碎片
		[187290] = 2, -- 不祥迪兹碎片
		[187299] = 3, -- 荒芜迪兹碎片
		[187308] = 4, -- 预感迪兹碎片
		[187318] = 5, -- 征兆迪兹碎片
	},
	[4] = {
		[187071] = 1, -- 泰尔碎片
		[187289] = 2, -- 不祥泰尔碎片
		[187298] = 3, -- 荒芜泰尔碎片
		[187307] = 4, -- 预感泰尔碎片
		[187317] = 5, -- 征兆泰尔碎片
	},
	[5] = {
		[187065] = 1, -- 基尔碎片
		[187288] = 2, -- 不祥基尔碎片
		[187297] = 3, -- 荒芜基尔碎片
		[187306] = 4, -- 预感基尔碎片
		[187316] = 5, -- 征兆基尔碎片
	},
	[6] = {
		[187063] = 1, -- 克尔碎片
		[187287] = 2, -- 不祥克尔碎片
		[187296] = 3, -- 荒芜克尔碎片
		[187305] = 4, -- 预感克尔碎片
		[187315] = 5, -- 征兆克尔碎片
	},
	[7] = {
		[187061] = 1, -- 雷弗碎片
		[187286] = 2, -- 不祥雷弗碎片
		[187295] = 3, -- 荒芜雷弗碎片
		[187304] = 4, -- 预感雷弗碎片
		[187314] = 5, -- 征兆雷弗碎片
	},
	[8] = {
		[187059] = 1, -- 亚斯碎片
		[187285] = 2, -- 不祥亚斯碎片
		[187294] = 3, -- 荒芜亚斯碎片
		[187303] = 4, -- 预感亚斯碎片
		[187313] = 5, -- 征兆亚斯碎片
	},
	[9] = {
		[187057] = 1, -- 贝克碎片
		[187284] = 2, -- 不祥贝克碎片
		[187293] = 3, -- 荒芜贝克碎片
		[187302] = 4, -- 预感贝克碎片
		[187312] = 5, -- 征兆贝克碎片
	},
}

local domiTextureIDs = {
	[457655] = true,
	[1003591] = true,
	[1392550] = true,
}

for index, value in pairs(Module.DomiDataByGroup) do
	for itemID, rank in pairs(value) do
		Module.DomiRankData[itemID] = rank
		Module.DomiIndexData[itemID] = index
	end
end

function Module:GetDomiName(itemID)
	local name = nameCache[itemID]
	if not name then
		name = GetItemInfo(itemID)
		nameCache[itemID] = name
	end

	return name
end

function Module:Domination_UpdateText(name, rank)
	local tex = _G[self:GetName().."Texture1"]
	local texture = tex and tex:IsShown() and tex:GetTexture()
	if texture and domiTextureIDs[texture] then
		local textLine = select(2, tex:GetPoint())
		local text = textLine and textLine:GetText()
		if text then
			textLine:SetText(text.."|n"..string_format(DOMI_RANK_STRING, name, rank))
		end
	end
end

function Module:Domination_CheckStatus()
	local _, link = self:GetItem()
	if not link then
		return
	end

	local itemID = GetItemInfoFromHyperlink(link)
	local rank = itemID and Module.DomiRankData[itemID]

	if rank then
		-- Domi rank on gems
		local textLine = _G[self:GetName().."TextLeft2"]
		local text = textLine and textLine:GetText()
		if text and string_find(text, "|cFF66BBFF") then
			textLine:SetFormattedText(DOMI_RANK_STRING, text, rank)
		end
	else
		-- Domi rank on gears
		local gemID = string_match(link, "item:%d+:%d*:(%d*):")
		itemID = tonumber(gemID)
		rank = itemID and Module.DomiRankData[itemID]
		if rank then
			local name = Module:GetDomiName(itemID)
			Module.Domination_UpdateText(self, name, rank)
		end
	end
end

function Module:CreateDominationRank()
	if not C["Tooltip"].DominationRank then
        return
    end

	GameTooltip:HookScript("OnTooltipSetItem", Module.Domination_CheckStatus)
	ItemRefTooltip:HookScript("OnTooltipSetItem", Module.Domination_CheckStatus)
	ShoppingTooltip1:HookScript("OnTooltipSetItem", Module.Domination_CheckStatus)
	EmbeddedItemTooltip:HookScript("OnTooltipSetItem", Module.Domination_CheckStatus)
end