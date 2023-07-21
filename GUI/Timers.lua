local spellIDs = TotemTimers_SpellIDs

-- order dropdown menu
local TotemTimers_GUI_OrderOptions = {
	[EARTH_TOTEM_SLOT] = TT_EARTH,
	[FIRE_TOTEM_SLOT] = TT_FIRE,
	[WATER_TOTEM_SLOT] = TT_WATER,
	[AIR_TOTEM_SLOT] = TT_AIR,
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
	TotemTimers_GUI_Timers:Hide()
	TotemTimers_GUI_Timers:Show()
	TotemTimers_ReorderElements()
	TotemTimers_UpdateMacro()
end

function TotemTimers_GUI_DropdownOrder_OnShow()
	local nr = string.gsub(this:GetName(), "TotemTimers_GUI_DropdownOrder", "")
	UIDropDownMenu_SetText(TotemTimers_GUI_OrderOptions[TotemTimers_Settings.Order[tonumber(nr)]], this)	
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
	TotemTimers_ReorderElements()
	--for element=1,4 do
	--	TotemTimers_Buttons[element]:Show()
	--end
	--TotemTimers_UpdateAllButtons()
	TotemTimers_GUI_Timers:Hide()
	TotemTimers_GUI_Timers:Show()
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
	UIDropDownMenu_SetText(TotemTimers_GUI_TimeOptions[value], TotemTimers_GUI_DropdownTime)
end

function TotemTimers_GUI_DropdownTime_OnShow()
	UIDropDownMenu_SetText(TotemTimers_GUI_TimeOptions[TotemTimers_Settings.Time], TotemTimers_GUI_DropdownTime)	
end

-- time position dropdown menu
local TotemTimers_GUI_TimePosOptions = {
	["left"] = TT_GUI_LEFT,
	["right"] = TT_GUI_RIGHT,
	["top"] = TT_GUI_TOP,
	["bottom"] = TT_GUI_BOTTOM,
}

function TotemTimers_GUI_DropdownTimePos_OnLoad()
	local info = {}
	info.notCheckable = 1
	info.func = TotemTimers_GUI_DropdownTimePos_OnClick
	for option, text in pairs(TotemTimers_GUI_TimePosOptions) do
		info.text = text
		info.arg1 = option
		UIDropDownMenu_AddButton(info)
	end
end

function TotemTimers_GUI_DropdownTimePos_OnClick(value)
	TotemTimers_Settings.TimePos = value
	UIDropDownMenu_SetText(TotemTimers_GUI_TimePosOptions[value], TotemTimers_GUI_DropdownTimePos)
	TotemTimers_ReorderElements()
end

function TotemTimers_GUI_DropdownTimePos_OnShow()
	UIDropDownMenu_SetText(TotemTimers_GUI_TimePosOptions[TotemTimers_Settings.TimePos], TotemTimers_GUI_DropdownTimePos)	
end
