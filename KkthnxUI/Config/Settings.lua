local _, C = unpack(select(2, ...))

local _G = _G

local GUILD = _G.GUILD
local NONE = _G.NONE
local PLAYER = _G.PLAYER

-- Actionbar
C["ActionBar"] = {
	["Cooldowns"] = true,
	["Count"] = true,
	["CustomBar"] = false,
	["CustomBarButtonSize"] = 34,
	["CustomBarNumButtons"] = 12,
	["CustomBarNumPerRow"] = 12,
	["DecimalCD"] = true,
	["Scale"] = 1,
	["Enable"] = true,
	["FadeCustomBar"] = false,
	["FadeMicroBar"] = false,
	["FadeRightBar"] = false,
	["FadeRightBar2"] = false,
	["Hotkey"] = true,
	["Macro"] = true,
	["MicroBar"] = true,
	["OverrideWA"] = false,
	["PetBar"] = true,
	["StanceBar"] = true,
	["Layout"] = {
		["Options"] = {
			["Layout 1 (Default)"] = 1,
			["Layout 2"] = 2,
			["Layout 3"] = 3,
			["Layout 4"] = 4,
		},
		["Value"] = 1
	},
}

-- Announcements
C["Announcements"] = {
	["AlertInChat"] = false,
	["AlertInWild"] = false,
	["BrokenAlert"] = false,
	["DispellAlert"] = false,
	["HealthAlert"] = false,
	["InstAlertOnly"] = true,
	["InterruptAlert"] = false,
	["ItemAlert"] = false,
	["KillingBlow"] = false,
	["OnlyCompleteRing"] = false,
	["OwnDispell"] = true,
	["OwnInterrupt"] = true,
	["PullCountdown"] = true,
	["PvPEmote"] = false,
	["QuestNotifier"] = false,
	["QuestProgress"] = false,
	["RareAlert"] = false,
	["ResetInstance"] = true,
	["SaySapped"] = false,
	["AlertChannel"] = {
		["Options"] = {
			[EMOTE] = 6,
			[PARTY.." / "..RAID] = 2,
			[PARTY] = 1,
			[RAID] = 3,
			[SAY] = 4,
			[YELL] = 5,
		},
		["Value"] = 2
	},
}

-- Automation
C["Automation"] = {
	["AutoBlockStrangerInvites"] = false,
	["AutoCollapse"] = false,
	["AutoDeclineDuels"] = false,
	["AutoDeclinePetDuels"] = false,
	["AutoDisenchant"] = false,
	["AutoGoodbye"] = false,
	["AutoInvite"] = false,
	["AutoOpenItems"] = false,
	["AutoPartySync"] = false,
	["AutoQuest"] = false,
	["AutoRelease"] = false,
	["AutoResurrect"] = false,
	["AutoResurrectThank"] = false,
	["AutoReward"] = false,
	["AutoScreenshot"] = false,
	["AutoSetRole"] = false,
	["AutoSkipCinematic"] = false,
	["AutoSummon"] = false,
	["AutoTabBinder"] = false,
	["NoBadBuffs"] = false,
	["WhisperInvite"] = "inv+",
}

C["Inventory"] = {
	["AutoSell"] = true,
	["BagBar"] = true,
	["BagBarMouseover"] = false,
	["BagsItemLevel"] = false,
	["BagsWidth"] = 10,
	["BankWidth"] = 12,
	["DeleteButton"] = true,
	["Enable"] = true,
	["FilterAnima"] = true,
	["FilterAzerite"] = false,
	["FilterCollection"] = true,
	["FilterConsumable"] = true,
	["FilterEquipSet"] = false,
	["FilterEquipment"] = true,
	["FilterFavourite"] = true,
	["FilterGoods"] = false,
	["FilterJunk"] = true,
	["FilterLegendary"] = true,
	["FilterQuest"] = true,
	["FilterRelic"] = false,
	["GatherEmpty"] = false,
	["IconSize"] = 34,
	["ItemFilter"] = true,
	["MutliRows"] = true,
	["PetTrash"] = true,
	["ReverseSort"] = false,
	["ShowNewItem"] = true,
	["SpecialBagsColor"] = false,
	["UpgradeIcon"] = true,
	["AutoRepair"] = {
		["Options"] = {
			[NONE] = 0,
			[GUILD] = 1,
			[PLAYER] = 2,
		},
		["Value"] = 2
	},
}

-- Buffs & Debuffs
C["Auras"] = {
	["BuffSize"] = 30,
	["BuffsPerRow"] = 16,
	["DebuffSize"] = 34,
	["DebuffsPerRow"] = 16,
	["Enable"] = true,
	["Reminder"] = false,
	["ReverseBuffs"] = false,
	["ReverseDebuffs"] = false,
	["TotemSize"] = 32,
	["Totems"] = true,
	["VerticalTotems"] = true,
}

-- Chat
C["Chat"] = {
	["BlockSpammer"] = true,
	["Background"] = true,
	["BlockAddonAlert"] = false,
	["BlockStranger"] = false,
	["ChatFilterList"] = "%*",
	["ChatFilterWhiteList"] = "",
	["ChatItemLevel"] = true,
	["ChatMenu"] = true,
	["Emojis"] = false,
	["Enable"] = true,
	["EnableFilter"] = true,
	["Fading"] = true,
	["FadingTimeVisible"] = 100,
	["FilterMatches"] = 1,
	["Freedom"] = true,
	["Height"] = 150,
	["Lock"] = true,
	["LogMax"] = 0,
	["LootIcons"] = false,
	["OldChatNames"] = false,
	["RoleIcons"] = false,
	["Sticky"] = false,
	["WhisperColor"] = true,
	["Width"] = 392,
	["TimestampFormat"] = {
		["Options"] = {
			["Disable"] = 1,
			["03:27 PM"] = 2,
			["03:27:32 PM"] = 3,
			["15:27"] = 4,
			["15:27:32"] = 5,
		},
		["Value"] = 1
	},
}

-- DataBars
C["DataBars"] = {
	["Enable"] = true,
	["ExperienceColor"] = {0, 0.4, 1, .8},
	["Height"] = 14,
	["HonorColor"] = {240/255, 114/255, 65/255},
	["MouseOver"] = false,
	["RestedColor"] = {1, 0, 1, 0.2},
	["TrackHonor"] = false,
	["Width"] = 190,
	["Text"] = {
		["Options"] = {
			["NONE"] = 0,
			["PERCENT"] = 1,
			["CURMAX"] = 2,
			["CURPERC"] = 3,
			["CUR"] = 4,
			["REM"] = 5,
			["CURREM"] = 6,
			["CURPERCREM"] = 7,
		},
		["Value"] = 1
	},
}

-- Datatext
C["DataText"] = {
	["Coords"] = false,
	["Friends"] = false,
	["Gold"] = false,
	["Guild"] = false,
	["GuildSortBy"] = 1,
	["GuildSortOrder"] = true,
	["HideText"] = true,
	["IconColor"] = {102/255, 157/255, 255/255},
	["Latency"] = true,
	["Location"] = true,
	["System"] = true,
	["Time"] = true,
}

C["AuraWatch"] = {
	["Enable"] = true,
	["ClickThrough"] = false,
	["IconScale"] = 1,
	["DeprecatedAuras"] = false,
	["QuakeRing"] = false,
	["InternalCD"] = {},
	["AuraList"] = {
		["Switcher"] = {},
		["IgnoreSpells"] = {},
	},
}

-- General
C["General"] = {
	["AutoScale"] = true,
	["ColorTextures"] = false,
	["MissingTalentAlert"] = true,
	["MoveBlizzardFrames"] = false,
	["NoErrorFrame"] = false,
	["NoTutorialButtons"] = false,
	["TexturesColor"] = {1, 1, 1},
	["UIScale"] = 0.71111,
	["UseGlobal"] = false,
	["VersionCheck"] = true,
	["BorderStyle"] = {
		["Options"] = {
			["KkthnxUI"] = "KkthnxUI",
			["AzeriteUI"] = "AzeriteUI",
			["KkthnxUI_Pixel"] = "KkthnxUI_Pixel",
			["KkthnxUI_Blank"] = "KkthnxUI_Blank",
		},
		["Value"] = "KkthnxUI"
	},
	["NumberPrefixStyle"] = {
		["Options"] = {
			["Standard: b/m/k"] = 1,
			["Asian: y/w"] = 2,
			["Full Digits"] = 3,
		},
		["Value"] = 1
	},
	["Profiles"] = {
		["Options"] = {},
	},
}

-- Loot
C["Loot"] = {
	["AutoConfirm"] = false,
	["AutoGreed"] = false,
	["Enable"] = true,
	["FastLoot"] = false,
	["GroupLoot"] = true,
}

-- Minimap
local BlipMedia = "Interface\\AddOns\\KkthnxUI\\Media\\MiniMap\\"
C["Minimap"] = {
	["Calendar"] = true,
	["Enable"] = true,
	["ShowRecycleBin"] = true,
	["Size"] = 190,
	["RecycleBinPosition"] = {
		["Options"] = {
			["BottomLeft"] = 1,
			["BottomRight"] = 2,
			["TopLeft"] = 3,
			["TopRight"] = 4,
		},
		["Value"] = "BottomLeft"
	},
	["LocationText"] = {
		["Options"] = {
			["Always Display"] = "SHOW",
			["Hide"] = "Hide",
			["Minimap Mouseover"] = "MOUSEOVER",
		},
		["Value"] = "MOUSEOVER"
	},
	["BlipTexture"] = {
		["Options"] = {
			["Default"] = "Interface\\MiniMap\\ObjectIconsAtlas",
			["Blank"] =  BlipMedia.."Blip-Blank",
			["Blizzard Big R"] =  BlipMedia.."Blip-BlizzardBigR",
			["Blizzard Big"] = BlipMedia.."Blip-BlizzardBig",
			["Charmed"] =  BlipMedia.."Blip-Charmed",
			["Glass Spheres"] =  BlipMedia.."Blip-GlassSpheres",
			["Nandini New"] =  BlipMedia.."Blip-Nandini-New",
			["Nandini"] =  BlipMedia.."Blip-Nandini",
			["SolidSpheres"] =  BlipMedia.."Blip-SolidSpheres",
		},
		["Value"] = "Interface\\MiniMap\\ObjectIconsAtlas"
	},
}

-- Miscellaneous
C["Misc"] = {
	["AFKCamera"] = false,
	["AutoBubbles"] = false,
	["ColorPicker"] = false,
	["EasyMarking"] = false,
	["EnhancedFriends"] = false,
	["EnhancedMail"] = false,
	["GemEnchantInfo"] = false,
	["HideBanner"] = false,
	["HideBossEmote"] = false,
	["ImprovedStats"] = false,
	["ItemLevel"] = false,
	["MDGuildBest"] = false,
	["MailSaver"] = false,
	["MailTarget"] = "",
	["MawThreatBar"] = true,
	["MouseTrail"] = false,
	["MouseTrailColor"] = {1, 1, 1, 0.6},
	["NoTalkingHead"] = false,
	["ParagonColor"] = {0, .5, .9},
	["ParagonEnable"] = false,
	["ParagonToast"] = false,
	["ParagonToastFade"] = 5,
	["ParagonToastSound"] = false,
	["PriorityStats"] = false,
	["ShowWowHeadLinks"] = false,
	["SlotDurability"] = false,
	["TradeTabs"] = false,
	["ParagonText"] = {
		["Options"] = {
			["Paragon".." (100/10000)"] = 1,
			["Exalted".." (100/10000)"] = 2,
			["Paragon".." x 1".." (100/10000)"] = 3,
			["100 (100/10000)"] = 4,
			["100/10000"] = 5,
			["9900"] = 6,
		},
		["Value"] = 1
	},
	["MouseTrailTexture"] = {
		["Options"] = {
			["Circle"] = "Interface\\AddOns\\KkthnxUI\\Media\\Textures\\Aura73",
			["Star"] = "Interface\\Cooldown\\Star4",
		},
		["Value"] = "Interface\\AddOns\\KkthnxUI\\Media\\Textures\\Aura73"
	},
	["ShowMarkerBar"] = {
		["Options"] = {
			["Grids"] = 1,
			["Horizontal"] = 2,
			["Vertical"] = 3,
			[DISABLE] = 4,
		},
		["Value"] = 4
	},
}

C["Nameplate"] = {
	["AKSProgress"] = false,
	["AuraSize"] = 26,
	["CastbarGlow"] = true,
	["ClassAuras"] = true,
	["ClassIcon"] = false,
	["ColoredTarget"] = true,
	["CustomColor"] = {0, 0.8, 0.3},
	["CustomUnitColor"] = true,
	["CustomUnitList"] = "",
	["DPSRevertThreat"] = false,
	["Distance"] = 42,
	["Enable"] = true,
	["ExecuteRatio"] = 0,
	["ExplosivesScale"] = false,
	["FriendlyCC"] = false,
	["FullHealth"] = false,
	["HealthTextSize"] = 13,
	["HostileCC"] = true,
	["InsecureColor"] = {1, 0, 0},
	["InsideView"] = true,
	["MaxAuras"] = 5,
	["MinAlpha"] = 1,
	["MinScale"] = 1,
	["NameOnly"] = true,
	["NameTextSize"] = 13,
	["NameplateClassPower"] = true,
	["OffTankColor"] = {0.2, 0.7, 0.5},
	["PPGCDTicker"] = true,
	["PPHeight"] = 5,
	["PPHideOOC"] = true,
	["PPIconSize"] = 32,
	["PPOnFire"] = false,
	["PPPHeight"] = 6,
	["PPPowerText"] = true,
	["PPWidth"] = 175,
	["PlateHeight"] = 13,
	["PlateWidth"] = 184,
	["PowerUnitList"] = "",
	["QuestIndicator"] = true,
	["SecureColor"] = {1, 0, 1},
	["ShowPlayerPlate"] = false,
	["Smooth"] = false,
	["TankMode"] = false,
	["TargetColor"] = {0, 0.6, 1},
	["TargetIndicatorColor"] = {1, 1, 0},
	["TransColor"] = {1, 0.8, 0},
	["VerticalSpacing"] = 0.7,
	["AuraFilter"] = {
		["Options"] = {
			["White & Black List"] = 1,
			["List & Player"] = 2,
			["List & Player & CCs"] = 3,
		},
		["Value"] = 3
	},
	["TargetIndicator"] = {
		["Options"] = {
			["Disable"] = 1,
			["Top Arrow"] = 2,
			["Right Arrow"] = 3,
			["Border Glow"] = 4,
			["Top Arrow + Glow"] = 5,
			["Right Arrow + Glow"] = 6,
		},
		["Value"] = 4
	},
	["TargetIndicatorTexture"] = {
		["Options"] = {
			["Blue Arrow 2".."|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\BlueArrow2:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\BlueArrow2]],
			["Blue Arrow".."|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\BlueArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\BlueArrow]],
			["Neon Blue Arrow".."|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\NeonBlueArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\NeonBlueArrow]],
			["Neon Green Arrow".."|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\NeonGreenArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\NeonGreenArrow]],
			["Neon Pink Arrow".."|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\NeonPinkArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\NeonPinkArrow]],
			["Neon Red Arrow".."|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\NeonRedArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\NeonRedArrow]],
			["Neon Purple Arrow".."|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\NeonPurpleArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\NeonPurpleArrow]],
			["Purple Arrow".."|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\PurpleArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\PurpleArrow]],
			["Red Arrow 2".."|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\RedArrow2.tga:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\RedArrow2]],
			["Red Arrow".."|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\RedArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\RedArrow]],
			["Red Chevron Arrow".."|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\RedChevronArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\RedChevronArrow]],
			["Red Chevron Arrow2".."|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\RedChevronArrow2:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\RedChevronArrow2]],
		},
		["Value"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\NeonBlueArrow]]
	},
}

C["PulseCooldown"] = {
	["AnimScale"] = 1.5,
	["Enable"] = false,
	["HoldTime"] = 0.5,
	["Size"] = 75,
	["Sound"] = false,
	["Threshold"] = 3,
}

-- Skins
C["Skins"] = {
	["Bartender4"] = false,
	["BigWigs"] = false,
	["BlizzardFrames"] = true,
	["ButtonForge"] = false,
	["ChatBubbleAlpha"] = 0.9,
	["ChatBubbles"] = true,
	["ChocolateBar"] = false,
	["DeadlyBossMods"] = false,
	["Details"] = false,
	["Dominos"] = false,
	["Hekili"] = false,
	["RareScanner"] = false,
	["Skada"] = false,
	["Spy"] = false,
	["TalkingHeadBackdrop"] = true,
	["TellMeWhen"] = false,
	["TitanPanel"] = false,
	["WeakAuras"] = false,
}

-- Tooltip
C["Tooltip"] = {
	["ClassColor"] = false,
	["CombatHide"] = false,
	["ConduitInfo"] = false,
	["Cursor"] = false,
	["DominationRank"] = false,
	["Enable"] = true,
	["FactionIcon"] = false,
	["HideJunkGuild"] = true,
	["HideRank"] = true,
	["HideRealm"] = true,
	["HideTitle"] = true,
	["Icons"] = true,
	["LFDRole"] = false,
	["MDScore"] = true,
	["ShowIDs"] = false,
	["SpecLevelByShift"] = true,
	["TargetBy"] = true,

	-- Testing
	["Raids"] = true,
	["Castle Nathria"] = true,
	["Sanctum of Domination"] = true,

	["Special"] = false,
	["Shadowlands Keystone Master: Season One"] = false,
	["Shadowlands Keystone Master: Season Two"] = true,

	["Mythics"] = false,
	["The Necrotic Wake"] = true,
	["Plaguefall"] = true,
	["Mists of Tirna Scithe"] = true,
	["Halls of Atonement"] = true,
	["Theater of Pain"] = true,
	["De Other Side"] = true,
	["Spires of Ascension"] = true,
	["Sanguine Depths"] = true,
	["Tazavesh, the Veiled Market"] = true
}

-- Fonts
C["UIFonts"] = {
	["ActionBarsFonts"] = "KkthnxUI Outline",
	["AuraFonts"] = "KkthnxUI Outline",
	["ChatFonts"] = "KkthnxUI",
	["DataBarsFonts"] = "KkthnxUI",
	["DataTextFonts"] = "KkthnxUI",
	["FilgerFonts"] = "KkthnxUI Outline",
	["GeneralFonts"] = "KkthnxUI",
	["InventoryFonts"] = "KkthnxUI Outline",
	["MinimapFonts"] = "KkthnxUI",
	["NameplateFonts"] = "KkthnxUI",
	["QuestTrackerFonts"] = "KkthnxUI",
	["SkinFonts"] = "KkthnxUI",
	["TooltipFonts"] = "KkthnxUI",
	["UnitframeFonts"] = "KkthnxUI",
	-- Font Sizes Will Go Here (Not Sure How Much I Care About Improving This)
	["QuestFontSize"] = 11,
}

-- Textures
C["UITextures"] = {
	["DataBarsTexture"] = "KkthnxUI",
	["FilgerTextures"] = "KkthnxUI",
	["GeneralTextures"] = "KkthnxUI",
	["HealPredictionTextures"] = "KkthnxUI",
	["LootTextures"] = "KkthnxUI",
	["NameplateTextures"] = "KkthnxUI",
	["QuestTrackerTexture"] = "KkthnxUI",
	["SkinTextures"] = "KkthnxUI",
	["TooltipTextures"] = "KkthnxUI",
	["UnitframeTextures"] = "KkthnxUI",
}

-- Unitframe
C["Unitframe"] = {
	["AllTextScale"] = 1, -- Testing

	["AdditionalPower"] = false,
	["AutoAttack"] = true,
	["CastClassColor"] = false,
	["CastReactionColor"] = false,
	["CastbarLatency"] = true,
	["ClassResources"] = true,
	["CombatFade"] = false,
	["CombatText"] = false,
	["DebuffHighlight"] = true,
	["Enable"] = true,
	["FCTOverHealing"] = false,
	["GlobalCooldown"] = true,
	["HotsDots"] = true,
	["OnlyShowPlayerDebuff"] = false,

	-- Player
	["PlayerBuffs"] = false,
	["PlayerCastbar"] = true,
	["PlayerCastbarIcon"] = true,
	["PlayerCastbarHeight"] = 26,
	["PlayerCastbarWidth"] = 260,
	["PlayerDeBuffs"] = false,
	["PlayerHealthHeight"] = 32,
	["PlayerHealthWidth"] = 180,
	["PlayerPowerHeight"] = 14,
	["PlayerPowerPrediction"] = true,

	["PvPIndicator"] = true,
	["ResurrectSound"] = false,
	["ShowHealPrediction"] = true,
	["ShowPlayerLevel"] = true,
	["ShowPlayerName"] = false,
	["Smooth"] = false,
	["Stagger"] = true,
	["Swingbar"] = false,
	["SwingbarTimer"] = false,

	-- Target
	["TargetHealthHeight"] = 32,
	["TargetHealthWidth"] = 180,
	["TargetPowerHeight"] = 14,
	["TargetBuffs"] = true,
	["TargetBuffsPerRow"] = 6,
	["TargetCastbar"] = true,
	["TargetCastbarIcon"] = true,
	["TargetCastbarHeight"] = 30,
	["TargetCastbarWidth"] = 260,
	["TargetDebuffs"] = true,
	["TargetDebuffsPerRow"] = 5,

	-- Focus
	["FocusBuffs"] = true,
	["FocusCastbar"] = true,
	["FocusCastbarHeight"] = 24,
	["FocusCastbarIcon"] = true,
	["FocusCastbarWidth"] = 208,
	["FocusDebuffs"] = true,
	["FocusHealthHeight"] = 32,
	["FocusHealthWidth"] = 180,
	["FocusPowerHeight"] = 14,

	-- TargetOfTarget
	["TargetTargetHealthHeight"] = 16,
	["TargetTargetHealthWidth"] = 90,
	["TargetTargetPowerHeight"] = 8,
	["HideTargetOfTargetLevel"] = false,
	["HideTargetOfTargetName"] = false,
	["HideTargetofTarget"] = false,

	-- Pet
	["PetHealthHeight"] = 16,
	["PetHealthWidth"] = 90,
	["PetPowerHeight"] = 8,
	["HidePetLevel"] = false,
	["HidePetName"] = false,
	["HidePet"] = false,

	-- FocusTarget
	["FocusTargetHealthHeight"] = 16,
	["FocusTargetHealthWidth"] = 90,
	["FocusTargetPowerHeight"] = 8,
	["HideFocusTargetLevel"] = false,
	["HideFocusTargetName"] = false,
	["HideFocusTarget"] = false,

	["HealthbarColor"] = {
		["Options"] = {
			["Dark"] = "Dark",
			["Value"] = "Value",
			["Class"] = "Class",
		},
		["Value"] = "Class"
	},
	["PortraitStyle"] = {
		["Options"] = {
			["Overlay Portrait"] = "OverlayPortrait",
			["3D Portraits"] = "ThreeDPortraits",
			["Class Portraits"] = "ClassPortraits",
			["New Class Portraits"] = "NewClassPortraits",
			["Default Portraits"] = "DefaultPortraits",
			["No Portraits"] = "NoPortraits"
		},
		["Value"] = "DefaultPortraits"
	},
}

C["Party"] = {
	["CastbarIcon"] = false,
	["Castbars"] = false,
	["Enable"] = true,
	["HealthHeight"] =  20,
	["HealthWidth"] = 134,
	["PortraitTimers"] = false,
	["PowerHeight"] = 10,
	["ShowBuffs"] = true,
	["ShowHealPrediction"] = true,
	["ShowPartySolo"] = false,
	["ShowPet"] = false,
	["ShowPlayer"] = true,
	["Smooth"] = false,
	["TargetHighlight"] = false,
	["HealthbarColor"] = {
		["Options"] = {
			["Dark"] = "Dark",
			["Value"] = "Value",
			["Class"] = "Class",
		},
		["Value"] = "Class"
	},
}

C["Boss"] = {
	["CastbarIcon"] = true,
	["Castbars"] = true,
	["Enable"] = true,
	["Smooth"] = false,
	["HealthHeight"] =  20,
	["HealthWidth"] = 134,
	["PowerHeight"] = 10,
	["YOffset"] = 54,
	["HealthbarColor"] = {
		["Options"] = {
			["Dark"] = "Dark",
			["Value"] = "Value",
			["Class"] = "Class",
		},
		["Value"] = "Class"
	},
}

C["Arena"] = {
	["CastbarIcon"] = true,
	["Castbars"] = true,
	["Enable"] = true,
	["Smooth"] = false,
	["HealthHeight"] =  20,
	["HealthWidth"] = 134,
	["PowerHeight"] = 10,
	["YOffset"] = 54,
	["HealthbarColor"] = {
		["Options"] = {
			["Dark"] = "Dark",
			["Value"] = "Value",
			["Class"] = "Class",
		},
		["Value"] = "Class"
	},
}

-- Raidframe
C["Raid"] = {
	["SpecRaidPos"] = false,
	["DebuffWatch"] = true,
	["DebuffWatchDefault"] = true,
	["DesaturateBuffs"] = false,
	["Enable"] = true,
	["Height"] = 44,
	["HorizonRaid"] = false,
	["MainTankFrames"] = true,
	["ManabarShow"] = false,
	["NumGroups"] = 6,
	["RaidUtility"] = true,
	["ReverseRaid"] = false,
	["ShowHealPrediction"] = true,
	["ShowNotHereTimer"] = true,
	["ShowRaidSolo"] = false,
	["ShowTeamIndex"] = false,
	["Smooth"] = false,
	["TargetHighlight"] = false,
	["Width"] = 70,
	["RaidBuffsStyle"] = {
		["Options"] = {
			["Aura Track"] = "Aura Track",
			["Standard"] = "Standard",
			["None"] = "None",
		},
		["Value"] = "Aura Track",
	},
	["RaidBuffs"] = {
		["Options"] = {
			["Only my buffs"] = "Self",
			["Only castable buffs"] = "Castable",
			["All buffs"] = "All",
		},
		["Value"] = "Self",
	},
	["AuraTrack"] = true,
	["AuraTrackIcons"] = true,
	["AuraTrackSpellTextures"] = true,
	["AuraTrackThickness"] = 5,

	["HealthbarColor"] = {
		["Options"] = {
			["Dark"] = "Dark",
			["Value"] = "Value",
			["Class"] = "Class",
		},
		["Value"] = "Class"
	},
	["HealthFormat"] = {
		["Options"] = {
			["Disable HP"] = 1,
			["Health Percentage"] = 2,
			["Health Remaining"] = 3,
			["Health Lost"] = 4,
		},
		["Value"] = 1
	},
}

-- Worldmap
C["WorldMap"] = {
	["AlphaWhenMoving"] = 0.35,
	["Coordinates"] = true,
	["FadeWhenMoving"] = true,
	["MapRevealGlow"] = true,
	["MapRevealGlowColor"] = {0.7, 0.7, 0.7},
	["SmallWorldMap"] = true,
}