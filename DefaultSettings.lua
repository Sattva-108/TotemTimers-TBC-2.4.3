-- Copyright (c) 2007 Xianghar
-- This code is not to be reproduced or modified without permission from author
if not TotemTimers_Settings then TotemTimers_Settings = {} end

local Default_Settings = {
	Show = true,
	Flash = 10,
	ExpirationWarning = true,
	ExpirationNotification = true,
	DestroyedNotification = true,
	ShieldNotification = true,
	EarthShieldNotification = true,
	WeaponNotification = true,
	Recast = true,
	FlashRed = true,
	ProcFlash = true,
	Tooltips = true,
	MiniIcons = true,
	Reincarnation = true,
	Arrange = "vertical",
	Style = "sticky",
	Time = "ct",
	Msg = "tt",
	Order = {AIR_TOTEM_SLOT, EARTH_TOTEM_SLOT, WATER_TOTEM_SLOT, FIRE_TOTEM_SLOT},
	Visible1 = true, Visible2 = true, Visible3 = true, Visible4 = true,
	MouseOver = true,
	WarningTime = 10,
	EarthShoutText = TT_EARTH_ELEMENTAL_SHOUT,
	FireShoutText = TT_FIRE_ELEMENTAL_SHOUT,
	ManaShoutText = TT_MANA_TIDE_SHOUT,
	TimerSize = 32,
	TimeHeight = 10,
	ShowBar = true,
	TrackerSize = 30,
	TrackerTimeHeight = 10,
	Spacing = 0,
	TrackerSpacing = 5,
	ShieldTracker = true,
	EarthShieldTracker = true,
	TrackerArrange = "horizontal",
	LastMainEnchant = TT_ROCKBITER_WEAPON,
	LastOffEnchant = TT_ROCKBITER_WEAPON,
	MainEnchant = true,
	MainEnchant1 = TT_ROCKBITER_WEAPON,
	MainEnchant2 = TT_WINDFURY_WEAPON,
	ShiftMainEnchant1 = TT_FLAMETONGUE_WEAPON,
	ShiftMainEnchant2 = TT_FROSTBRAND_WEAPON,
	LastMainEnchants = {},
	LastOffEnchants = {},
	WeaponBuffModifier = "shift",
	BarDirection = "auto",
	BarBindings = true,
	ShowTotemsAsBuffs = false,
	HideDefaultTotemFrame = true,
	ShowPartyBuffs = true,
	ShowPlayerBuffDot = true,
	PartyBuffSide = "top",
	FocusElementals = true,
	Version = 8.001,
	ShowEarthElementalButton = true,
	ShowFireElementalButton = true,
	ShowManaTideButton = true,
	TotemTwisting = false,
	SwitchAgiWf = false,
	DiasbleMenuDelay = false,
	ShieldLeftButton = TT_LIGHTNING_SHIELD,
	ShieldRightButton = TT_WATER_SHIELD,
	ShieldMiddleButton = TT_TOTEMIC_CALL,
	EarthShieldLeftButton = "focus", 
	EarthShieldRightButton = "target",
	EarthShieldMiddleButton = "targettarget",
	EarthShieldButton4 = "player",
	TimeFont = "Fonts\\FRIZQT__.TTF",
	TimeSpacing = 0,
	TrackerTimeSpacing = 0,
	TimePos = "bottom",
	TrackerTimePos = "bottom",
	ColorTimerBars = false,
	TimerBarTexture = "Interface\TargetingFrame\UI-StatusBar",
	HideBlizzTimers = true,
}
	
function TotemTimers_LoadDefaultSettings()
	local TotemTimers_Settings = TotemTimers_Settings

	for k,v in pairs(Default_Settings) do
		if TotemTimers_Settings[k] == nil then
			TotemTimers_Settings[k] = v
		end
	end
	
	if not TotemTimers_Order then TotemTimers_Order = {} end
	local TotemTimers_Order = TotemTimers_Order

	for i=1,4 do
		if not TotemTimers_Order[i] then 
			TotemTimers_Order[i] = {}
		end
	end
	
	for totem,_ in pairs(TotemData) do
		local found = false
		for k,v in pairs(TotemTimers_Order[TotemData[totem].element]) do
			if v == totem then found = true end
		end
		if not found then table.insert(TotemTimers_Order[TotemData[totem].element], totem) end
	end
end
