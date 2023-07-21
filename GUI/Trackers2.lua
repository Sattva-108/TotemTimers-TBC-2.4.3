local TotemTimers_GUI_ShieldButtonOptions = {TT_LIGHTNING_SHIELD, TT_WATER_SHIELD, TT_EARTH_SHIELD,TT_TOTEMIC_CALL,}

function TotemTimers_GUI_DropdownShieldButton_OnLoad(arg1)
	local info = {}
	info.notCheckable = 1
	info.func = TotemTimers_GUI_DropdownShieldButton_OnClick
	for _, text in pairs(TotemTimers_GUI_ShieldButtonOptions) do
		info.text = text
		info.arg1 = text
		info.arg2 = this
		UIDropDownMenu_AddButton(info)
	end
end

function TotemTimers_GUI_DropdownShieldButton_OnClick(value, frame)
	if frame:GetName() == "TotemTimers_GUI_DropdownShieldLeftButtonButton" then
		TotemTimers_Settings.ShieldLeftButton = value
		TotemTimers_ProcessSetting("ShieldLeftButton")
	elseif frame:GetName() == "TotemTimers_GUI_DropdownShieldRightButtonButton" then
		TotemTimers_Settings.ShieldRightButton = value
		TotemTimers_ProcessSetting("ShieldRightButton")
	elseif frame:GetName() == "TotemTimers_GUI_DropdownShieldMiddleButtonButton" then
		TotemTimers_Settings.ShieldMiddleButton = value
		TotemTimers_ProcessSetting("ShieldMiddleButton")
	end
	TotemTimers_GUI_Trackers2:Hide()
	TotemTimers_GUI_Trackers2:Show()
end

function TotemTimers_GUI_DropdownShieldLeftButton_OnShow()
	UIDropDownMenu_SetText(TotemTimers_Settings.ShieldLeftButton, this)
end
function TotemTimers_GUI_DropdownShieldRightButton_OnShow()
	UIDropDownMenu_SetText(TotemTimers_Settings.ShieldRightButton, this)
end
function TotemTimers_GUI_DropdownShieldMiddleButton_OnShow()
	UIDropDownMenu_SetText(TotemTimers_Settings.ShieldMiddleButton, this)
end

local TotemTimers_GUI_EarthShieldButtonOptions = {"focus", "target", "targettarget", "player"}

function TotemTimers_GUI_DropdownEarthShieldButton_OnLoad(arg1)
	local info = {}
	info.notCheckable = 1
	info.func = TotemTimers_GUI_DropdownEarthShieldButton_OnClick
	for _, text in pairs(TotemTimers_GUI_EarthShieldButtonOptions) do
		info.text = text
		info.arg1 = text
		info.arg2 = this
		UIDropDownMenu_AddButton(info)
	end
end

function TotemTimers_GUI_DropdownEarthShieldButton_OnClick(value, frame)
	if frame:GetName() == "TotemTimers_GUI_DropdownEarthShieldLeftButtonButton" then
		TotemTimers_Settings.EarthShieldLeftButton = value
		TotemTimers_ProcessSetting("EarthShieldLeftButton")
	elseif frame:GetName() == "TotemTimers_GUI_DropdownEarthShieldRightButtonButton" then
		TotemTimers_Settings.EarthShieldRightButton = value
		TotemTimers_ProcessSetting("EarthShieldRightButton")
	elseif frame:GetName() == "TotemTimers_GUI_DropdownEarthShieldMiddleButtonButton" then
		TotemTimers_Settings.EarthShieldMiddleButton = value
		TotemTimers_ProcessSetting("EarthShieldMiddleButton")
	elseif frame:GetName() == "TotemTimers_GUI_DropdownEarthShieldButton4Button" then
		TotemTimers_Settings.EarthShieldButton4 = value
		TotemTimers_ProcessSetting("EarthShieldButton4")	end
	TotemTimers_GUI_Trackers2:Hide()
	TotemTimers_GUI_Trackers2:Show()
end


function TotemTimers_GUI_DropdownEarthShieldLeftButton_OnShow()
	UIDropDownMenu_SetText(TotemTimers_Settings.EarthShieldLeftButton, this)
end
function TotemTimers_GUI_DropdownEarthShieldRightButton_OnShow()
	UIDropDownMenu_SetText(TotemTimers_Settings.EarthShieldRightButton, this)
end
function TotemTimers_GUI_DropdownEarthShieldMiddleButton_OnShow()
	UIDropDownMenu_SetText(TotemTimers_Settings.EarthShieldMiddleButton, this)
end
function TotemTimers_GUI_DropdownEarthShieldButton4_OnShow()
	UIDropDownMenu_SetText(TotemTimers_Settings.EarthShieldButton4, this)
end


local TotemTimers_GUI_WeaponBuffs = {TT_ROCKBITER_WEAPON, TT_WINDFURY_WEAPON, TT_FLAMETONGUE_WEAPON, TT_FROSTBRAND_WEAPON}

function TotemTimers_GUI_DropdownWeaponBuffLeftClick_OnLoad()
	local info = {}
	info.notCheckable = 1
	info.func = TotemTimers_GUI_DropdownWeaponBuffLeftClick_OnClick
	for _,buff in pairs(TotemTimers_GUI_WeaponBuffs) do
		--if spellIDs[buff]>0 then
			info.text = buff
			info.arg1 = buff
			UIDropDownMenu_AddButton(info)
		--end
	end
end

function TotemTimers_GUI_DropdownWeaponBuffLeftClick_OnClick(value)
	TotemTimers_Settings.MainEnchant1 = value
	UIDropDownMenu_SetText(value, TotemTimers_GUI_DropdownWeaponBuffLeftClick)
	TotemTimers_SetWeaponEnchants()
end

function TotemTimers_GUI_DropdownWeaponBuffLeftClick_OnShow()
	UIDropDownMenu_Initialize(this, TotemTimers_GUI_DropdownWeaponBuffLeftClick_OnLoad)
	UIDropDownMenu_SetText(TotemTimers_Settings.MainEnchant1, TotemTimers_GUI_DropdownWeaponBuffLeftClick)	
end

function TotemTimers_GUI_DropdownWeaponBuffShiftLeftClick_OnLoad()
	local info = {}
	info.notCheckable = 1
	info.func = TotemTimers_GUI_DropdownWeaponBuffShiftLeftClick_OnClick
	for _,buff in pairs(TotemTimers_GUI_WeaponBuffs) do
		--if spellIDs[buff]>0 then
			info.text = buff
			info.arg1 = buff
			UIDropDownMenu_AddButton(info)
		--end
	end
end

function TotemTimers_GUI_DropdownWeaponBuffShiftLeftClick_OnClick(value)
	TotemTimers_Settings.ShiftMainEnchant1 = value
	UIDropDownMenu_SetText(value, TotemTimers_GUI_DropdownWeaponBuffShiftLeftClick)
	TotemTimers_SetWeaponEnchants()
end

function TotemTimers_GUI_DropdownWeaponBuffShiftLeftClick_OnShow()
	UIDropDownMenu_Initialize(this, TotemTimers_GUI_DropdownWeaponBuffShiftLeftClick_OnLoad)
	UIDropDownMenu_SetText(TotemTimers_Settings.ShiftMainEnchant1, TotemTimers_GUI_DropdownWeaponBuffShiftLeftClick)	
end


function TotemTimers_GUI_DropdownWeaponBuffRightClick_OnLoad()
	local info = {}
	info.notCheckable = 1
	info.func = TotemTimers_GUI_DropdownWeaponBuffRightClick_OnClick
	for _,buff in pairs(TotemTimers_GUI_WeaponBuffs) do
		--if spellIDs[buff]>0 then
			info.text = buff
			info.arg1 = buff
			UIDropDownMenu_AddButton(info)
		--end
	end
end

function TotemTimers_GUI_DropdownWeaponBuffRightClick_OnClick(value)
	TotemTimers_Settings.MainEnchant2 = value
	UIDropDownMenu_SetText(value, TotemTimers_GUI_DropdownWeaponBuffRightClick)
	TotemTimers_SetWeaponEnchants()
end

function TotemTimers_GUI_DropdownWeaponBuffRightClick_OnShow()
	UIDropDownMenu_Initialize(this, TotemTimers_GUI_DropdownWeaponBuffRightClick_OnLoad)
	UIDropDownMenu_SetText(TotemTimers_Settings.MainEnchant2, TotemTimers_GUI_DropdownWeaponBuffRightClick)	
end


function TotemTimers_GUI_DropdownWeaponBuffShiftRightClick_OnLoad()
	local info = {}
	info.notCheckable = 1
	info.func = TotemTimers_GUI_DropdownWeaponBuffShiftRightClick_OnClick
	for _,buff in pairs(TotemTimers_GUI_WeaponBuffs) do
		--if spellIDs[buff]>0 then
			info.text = buff
			info.arg1 = buff
			UIDropDownMenu_AddButton(info)
		--end
	end
end

function TotemTimers_GUI_DropdownWeaponBuffShiftRightClick_OnClick(value)
	TotemTimers_Settings.ShiftMainEnchant2 = value
	UIDropDownMenu_SetText(value, TotemTimers_GUI_DropdownWeaponBuffShiftRightClick)
	TotemTimers_SetWeaponEnchants()
end

function TotemTimers_GUI_DropdownWeaponBuffShiftRightClick_OnShow()
	UIDropDownMenu_Initialize(this, TotemTimers_GUI_DropdownWeaponBuffShiftRightClick_OnLoad)
	UIDropDownMenu_SetText(TotemTimers_Settings.ShiftMainEnchant2, TotemTimers_GUI_DropdownWeaponBuffShiftRightClick)	
end

local modifiers = {"shift", "ctrl", "alt"}

function TotemTimers_GUI_DropdownWeaponBuffModifier_OnLoad()
	local info = {}
	info.notCheckable = 1
	info.func = TotemTimers_GUI_DropdownWeaponBuffModifier_OnClick
	for _,key in pairs(modifiers) do
		info.text = key
		info.arg1 = key
		UIDropDownMenu_AddButton(info)
	end
end

function TotemTimers_GUI_DropdownWeaponBuffModifier_OnClick(value)
	TotemTimers_Settings.WeaponBuffModifier = value
	UIDropDownMenu_SetText(value, TotemTimers_GUI_DropdownWeaponBuffModifier)
	TotemTimers_SetWeaponEnchants()
end

function TotemTimers_GUI_DropdownWeaponBuffModifier_OnShow()
	UIDropDownMenu_Initialize(this, TotemTimers_GUI_DropdownWeaponBuffModifier_OnLoad)
	UIDropDownMenu_SetText(TotemTimers_Settings.WeaponBuffModifier, TotemTimers_GUI_DropdownWeaponBuffModifier)	
end
