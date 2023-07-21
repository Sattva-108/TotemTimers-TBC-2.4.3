local spellIDs = TotemTimers_SpellIDs

function TotemTimers_GUI_OnLoad()
	DEFAULT_CHAT_FRAME:AddMessage("TotemTimers_GUI: loaded")
	local ver = GetAddOnMetadata("TotemTimers", "Version")
	if ver then 
		TotemTimers_GUIHeaderText:SetText(TT_GUI_HEADER.." "..ver)
	end
end

function TotemTimers_GUI_UpdateTabs()
	TotemTimers_GUIFrame.selectedTab = tonumber(TotemTimers_GUIFrame.selectedTab) or 1
	for i=1,4 do
		if i == TotemTimers_GUIFrame.selectedTab then
			getglobal("TotemTimers_GUIFramePage"..i):Show()
		else
			getglobal("TotemTimers_GUIFramePage"..i):Hide()
		end
	end
end

function TotemTimers_GUI_ShowTooltip(textvar, istext)
	local text = textvar
	if not istext then text = getglobal(textvar) end
	if text then
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
		GameTooltip:SetText(text, 1,1,1,1,1)
	end
end


-- arrange dropdown menu
local TotemTimers_GUI_ArrangeOptions = {
	["vertical"] = TT_GUI_VERTICAL,
	["horizontal"] = TT_GUI_HORIZONTAL,
	["box"] = TT_GUI_BOX
}

function TotemTimers_GUI_DropdownArrange_OnLoad()
	local info = {}
	info.notCheckable = 1
	info.func = TotemTimers_GUI_DropdownArrange_OnClick
	for option, text in pairs(TotemTimers_GUI_ArrangeOptions) do
		info.text = text
		info.arg1 = option
		UIDropDownMenu_AddButton(info)
	end
end

function TotemTimers_GUI_DropdownArrange_OnClick(value)
	TotemTimers_Settings.Arrange = value
	TotemTimers_Settings.BarDirection = "auto"
	UIDropDownMenu_SetText(TotemTimers_GUI_ArrangeOptions[value], TotemTimers_GUI_DropdownArrange);	
	TotemTimers_ReorderElements()
end

function TotemTimers_GUI_DropdownArrange_OnShow()
	UIDropDownMenu_SetText(TotemTimers_GUI_ArrangeOptions[TotemTimers_Settings.Arrange], TotemTimers_GUI_DropdownArrange);	
end


-- style dropdown menu
local TotemTimers_GUI_StyleOptions = {
	["sticky"] = TT_GUI_STICKY,
	["element"] = TT_GUI_ELEMENT,
	["fixed"] = TT_GUI_FIXED,
	["buff"] = TT_GUI_BUFF
}

function TotemTimers_GUI_DropdownStyle_OnLoad()
	local info = {}
	info.notCheckable = 1
	info.func = TotemTimers_GUI_DropdownStyle_OnClick
	for option, text in pairs(TotemTimers_GUI_StyleOptions) do
		info.text = text
		info.arg1 = option
		UIDropDownMenu_AddButton(info)
	end
end

function TotemTimers_GUI_DropdownStyle_OnClick(value)
	TotemTimers_Settings.Style = value
	UIDropDownMenu_SetText(TotemTimers_GUI_StyleOptions[value], TotemTimers_GUI_DropdownStyle)
	TotemTimers_ProcessSetting("Style")
	for _,element in pairs({"earth", "fire", "water", "air"}) do
		TotemTimers_Buttons[element]:Show()
	end
	TotemTimers_UpdateAllButtons()
	TotemTimers_GUIFrame:Hide()
	TotemTimers_GUIFrame:Show()
end

function TotemTimers_GUI_DropdownStyle_OnShow()
	--if not TotemTimers_Settings.Recast then
		--TotemTimers_GUI_StyleOptions["buff"] = TT_GUI_BUFF
	--else
		--TotemTimers_GUI_StyleOptions["buff"] = nil
		--if TotemTimers_Settings.Style == "buff" then TotemTimers_Settings.Style = "sticky" end
	--end
	UIDropDownMenu_Initialize(this, TotemTimers_GUI_DropdownStyle_OnLoad)
	UIDropDownMenu_SetText(TotemTimers_GUI_StyleOptions[TotemTimers_Settings.Style], TotemTimers_GUI_DropdownStyle)	
end

-- time dropdown menu
local TotemTimers_GUI_TimeOptions = {
	["ct"] = TT_GUI_CT,
	["blizz"] = TT_GUI_BLIZZARD,
}

function TotemTimers_GUI_DropdownTime_OnLoad()
	local info = {}
	info.notCheckable = 1
	info.func = TotemTimers_GUI_DropdownTime_OnClick
	for option, text in pairs(TotemTimers_GUI_TimeOptions) do
		info.text = text
		info.arg1 = option
		UIDropDownMenu_AddButton(info)
	end
end

function TotemTimers_GUI_DropdownTime_OnClick(value)
	TotemTimers_Settings.Time = value
	UIDropDownMenu_SetText(TotemTimers_GUI_TimeOptions[value], TotemTimers_GUI_DropdownTime);	
end

function TotemTimers_GUI_DropdownTime_OnShow()
	UIDropDownMenu_SetText(TotemTimers_GUI_TimeOptions[TotemTimers_Settings.Time], TotemTimers_GUI_DropdownTime);	
end



-- msg dropdown menu
local TotemTimers_GUI_MsgOptions = {
	["tt"] = TT_GUI_TT,
	["sct"] = TT_GUI_SCT,
	["msbt"] = TT_GUI_MSBT,
	["parrot"] = TT_GUI_PARROT,
	["chat"] = TT_GUI_CHAT,
}

function TotemTimers_GUI_DropdownMsg_OnLoad()
	local info = {}
	info.notCheckable = 1
	info.func = TotemTimers_GUI_DropdownMsg_OnClick
	for option, text in pairs(TotemTimers_GUI_MsgOptions) do
		info.text = text
		info.arg1 = option
		UIDropDownMenu_AddButton(info)
	end
end

function TotemTimers_GUI_DropdownMsg_OnClick(value)
	TotemTimers_Settings.Msg = value
	UIDropDownMenu_SetText(TotemTimers_GUI_MsgOptions[value], TotemTimers_GUI_DropdownMsg)	
end

function TotemTimers_GUI_DropdownMsg_OnShow()
	UIDropDownMenu_SetText(TotemTimers_GUI_MsgOptions[TotemTimers_Settings.Msg], TotemTimers_GUI_DropdownMsg)	
end


-- order dropdown menu
local TotemTimers_GUI_OrderOptions = {
	["earth"] = TT_EARTH,
	["fire"] = TT_FIRE,
	["water"] = TT_WATER,
	["air"] = TT_AIR,
}

function TotemTimers_GUI_DropdownOrder_OnLoad()
	local info = {}
	info.notCheckable = 1
	local nr = string.gsub(this:GetName(), "TotemTimers_GUI_DropdownOrder(%d).*", "%1")
	info.func = TotemTimers_GUI_DropdownOrder_OnClick
	for option, text in pairs(TotemTimers_GUI_OrderOptions) do
		info.text = text
		info.arg1 = option
		info.arg2 = tonumber(nr)
		UIDropDownMenu_AddButton(info)
	end
end

function TotemTimers_GUI_DropdownOrder_OnClick(value, nr)
	local fromnr = 0;
	for i=1,4 do
		if TotemTimers_Settings.Order[i] == value then fromnr = i end
	end
	TotemTimers_Settings.Order[fromnr] = TotemTimers_Settings.Order[nr]
	TotemTimers_Settings.Order[nr] = value
	TotemTimers_GUIFrame:Hide()
	TotemTimers_GUIFrame:Show()
	TotemTimers_ReorderElements()
	TotemTimers_UpdateMacro()
end

function TotemTimers_GUI_DropdownOrder_OnShow()
	local nr = string.gsub(this:GetName(), "TotemTimers_GUI_DropdownOrder", "")
	UIDropDownMenu_SetText(TotemTimers_GUI_OrderOptions[TotemTimers_Settings.Order[tonumber(nr)]], this)	
end


local TotemTimers_GUI_BarDirections = {
	["auto"] = TT_GUI_AUTO,
	["left"] = TT_GUI_LEFT,
	["right"] = TT_GUI_RIGHT,
	["up"] = TT_GUI_UP,
	["down"] = TT_GUI_DOWN,
}

function TotemTimers_GUI_DropdownBarDirection_OnLoad()
	local info = {}
	info.notCheckable = 1
	info.func = TotemTimers_GUI_DropdownBardirection_OnClick
	info.text = TT_GUI_AUTO
	info.arg1 = "auto"
	UIDropDownMenu_AddButton(info)
	if TotemTimers_Settings.Arrange == "horizontal" then
		for k,v in pairs({"up", "down"}) do
			info.text = TotemTimers_GUI_BarDirections[v]
			info.arg1 = v
			UIDropDownMenu_AddButton(info)
		end
	else
		for k,v in pairs({"left", "right"}) do
			info.text = TotemTimers_GUI_BarDirections[v]
			info.arg1 = v
			UIDropDownMenu_AddButton(info)
		end
	end
end

function TotemTimers_GUI_DropdownBardirection_OnClick(value)
	TotemTimers_Settings.BarDirection = value
	TotemTimers_GUIFrame:Hide()
	TotemTimers_GUIFrame:Show()
	TotemTimers_ReorderElements()
	TotemTimers_UpdateMacro()
end

function TotemTimers_GUI_DropdownBarDirection_OnShow()
	UIDropDownMenu_Initialize(this, TotemTimers_GUI_DropdownBarDirection_OnLoad)
	UIDropDownMenu_SetText(TotemTimers_GUI_BarDirections[TotemTimers_Settings.BarDirection], this)
end


local TotemTimers_GUI_WeaponBuffs = {TT_ROCKBITER_WEAPON, TT_WINDFURY_WEAPON, TT_FLAMETONGUE_WEAPON, TT_FROSTBRAND_WEAPON}

function TotemTimers_GUI_DropdownWeaponBuffLeftClick_OnLoad()
	local info = {}
	info.notCheckable = 1
	info.func = TotemTimers_GUI_DropdownWeaponBuffLeftClick_OnClick
	for _,buff in pairs(TotemTimers_GUI_WeaponBuffs) do
		if spellIDs[buff]>0 then
			info.text = buff
			info.arg1 = buff
			UIDropDownMenu_AddButton(info)
		end
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
		if spellIDs[buff]>0 then
			info.text = buff
			info.arg1 = buff
			UIDropDownMenu_AddButton(info)
		end
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
		if spellIDs[buff]>0 then
			info.text = buff
			info.arg1 = buff
			UIDropDownMenu_AddButton(info)
		end
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
		if spellIDs[buff]>0 then
			info.text = buff
			info.arg1 = buff
			UIDropDownMenu_AddButton(info)
		end
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



local TotemTimers_GUI_TrackerArrangeOptions = {
	["horizontal"] = TT_GUI_HORIZONTAL,
	["vertical"] = TT_GUI_VERTICAL,
	["free"] = TT_GUI_FREE,
}

function TotemTimers_GUI_DropdownTrackerArrange_OnLoad()
	local info = {}
	info.notCheckable = 1
	info.func = TotemTimers_GUI_DropdownTrackerArrange_OnClick
	for option, text in pairs(TotemTimers_GUI_TrackerArrangeOptions) do
		info.text = text
		info.arg1 = option
		UIDropDownMenu_AddButton(info)
	end
end

function TotemTimers_GUI_DropdownTrackerArrange_OnClick(value)
	TotemTimers_Settings.TrackerArrange = value
	TotemTimers_GUIFrame:Hide()
	TotemTimers_GUIFrame:Show()
	TotemTimers_OrderTrackers()
end

function TotemTimers_GUI_DropdownTrackerArrange_OnShow()
	UIDropDownMenu_SetText(TotemTimers_GUI_TrackerArrangeOptions[TotemTimers_Settings.TrackerArrange], this)	
end
