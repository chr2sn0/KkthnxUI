local _, C = unpack(select(2, ...))

local _G = _G

local C_EncounterJournal_GetSectionInfo = _G.C_EncounterJournal.GetSectionInfo

C.NameplateWhiteList = {
	-- Buffs
	[642] = true,	-- 圣盾术
	[1022] = true,	-- 保护之手
	[23920] = true,	-- 法术反射
	[45438] = true,	-- 寒冰屏障
	[186265] = true,	-- 灵龟守护

	-- Debuffs
	[2094] = true,	-- 致盲
	[10326] = true,	-- 超度邪恶
	[20549] = true,	-- 战争践踏
	[107079] = true,	-- 震山掌
	[117405] = true,	-- 束缚射击
	[127797] = true,	-- 乌索尔旋风
	[272295] = true,	-- 悬赏

	-- Mythic +
	[228318] = true,	-- 激怒
	[226510] = true,	-- 血池
	[343553] = true,	-- 万噬之怨
	[343502] = true,	-- 鼓舞光环

	-- Dungeons
	[320293] = true,	-- 伤逝剧场，融入死亡
	[331510] = true,	-- 伤逝剧场，死亡之愿
	[333241] = true,	-- 伤逝剧场，暴脾气
	[336449] = true,	-- 凋魂之殇，玛卓克萨斯之墓
	[336451] = true,	-- 凋魂之殇，玛卓克萨斯之壁
	[333737] = true,	-- 凋魂之殇，凝结之疾
	[328175] = true,	-- 凋魂之殇，凝结之疾
	[340357] = true,	-- 凋魂之殇，急速感染
	[228626] = true,	-- 彼界，怨灵之瓮
	[344739] = true,	-- 彼界，幽灵
	[333227] = true,	-- 彼界，不死之怒
	[326450] = true,	-- 赎罪大厅，忠心的野兽
	[343558] = true,	-- 通灵战潮，病态凝视
	[343470] = true,	-- 通灵战潮，碎骨之盾
	[328351] = true,	-- 通灵战潮，染血长枪
	[322433] = true,	-- 赤红深渊，石肤术
	[321402] = true,	-- 赤红深渊，饱餐
	[327416] = true,	-- 晋升高塔，心能回灌
	[317936] = true,	-- 晋升高塔，弃誓信条
	[327812] = true,	-- 晋升高塔，振奋英气
	[339917] = true,	-- 晋升高塔，命运之矛
	[323149] = true,	-- 仙林，黑暗之拥
	[322569] = true,	-- 仙林，兹洛斯之手
	[355147] = true,	-- 集市，鱼群鼓舞
	[355057] = true,	-- 集市，鱼人战吼
	[351088] = true,	-- 集市，圣物联结
	[355640] = true,	-- 集市，重装方阵
	[355783] = true,	-- 集市，力量增幅
	[347840] = true,	-- 集市，野性
	[347015] = true,	-- 集市，强化防御
	-- Raids
	[334695] = true,	-- 动荡能量，猎手
	[345902] = true,	-- 破裂的联结，猎手
	[346792] = true,	-- 罪触之刃，猩红议会
}

C.NameplateBlackList = {
	[15407] = true, -- 精神鞭笞
	[51714] = true, -- 锋锐之霜
	[199721] = true, -- 腐烂光环
	[214968] = true, -- 死灵光环
	[214975] = true, -- 抑心光环
	[273977] = true, -- 亡者之握
	[276919] = true, -- 承受压力
	[206930] = true, -- 心脏打击
}

local function GetSectionInfo(id)
	return C_EncounterJournal_GetSectionInfo(id).title
end

C.NameplateCustomUnits = {
	[179823] = true,	-- 圣物收集者，刻希亚
	[179565] = true,	-- 圣物饕餮者，刻希亚
	-- Nzoth vision
	[153401] = true, 	-- 克熙尔支配者
	[157610] = true, 	-- 克熙尔支配者
	[156795] = true, 	-- 军情七处线人
	-- Dungeons
	[120651] = true, 	-- 大米，爆炸物
	[174773] = true, 	-- 大米，怨毒影魔
	[169498] = true,	-- 凋魂之殇，魔药炸弹
	[170851] = true,	-- 凋魂之殇，易爆魔药炸弹
	[165556] = true,	-- 赤红深渊，瞬息具象
	[170234] = true,	-- 伤逝剧场，压制战旗
	[164464] = true,	-- 伤逝剧场，卑劣的席拉
	[165251] = true,	-- 仙林，幻影仙狐
	[171341] = true,	-- 彼界，幼鹤
	[175576] = true,	-- 集市，监禁
	[179733] = true,	-- 集市，鱼串
	-- Raids
	[175992] = true,	-- 猩红议会，忠实的侍从
	[GetSectionInfo(21953)] = true,	-- 凯子，灵能灌注者
}

C.NameplateShowPowerList = {
	[165556] = true,
	[GetSectionInfo(22339)] = true,
}