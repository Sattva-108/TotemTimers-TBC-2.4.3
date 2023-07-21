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
	TotemTimers_GUI_Trackers:Hide()
	TotemTimers_GUI_Trackers:Show()
	TotemTimers_OrderTrackers()
end

function TotemTimers_GUI_DropdownTrackerArrange_OnShow()
	UIDropDownMenu_SetText(TotemTimers_GUI_TrackerArrangeOptions[TotemTimers_Settings.TrackerArrange], this)	
end

-- tracker time position dropdown menu
local TotemTimers_GUI_TimePosOptions = {
	["left"] = TT_GUI_LEFT,
	["right"] = TT_GUI_RIGHT,
	["top"] = TT_GUI_TOP,
	["bottom"] = TT_GUI_BOTTOM,
}

function TotemTimers_GUI_DropdownTrackerTimePos_OnLoad()
	local info = {}
	info.notCheckable = 1
	info.func = TotemTimers_GUI_DropdownTrackerTimePos_OnClick
	for option, text in pairs(TotemTimers_GUI_TimePosOptions) do
		info.text = text
		info.arg1 = option
		UIDropDownMenu_AddButton(info)
	end
end

function TotemTimers_GUI_DropdownTrackerTimePos_OnClick(value)
	TotemTimers_Settings.TrackerTimePos = value
	UIDropDownMenu_SetText(TotemTimers_GUI_TimePosOptions[value], TotemTimers_GUI_DropdownTrackerTimePos)
	TotemTimers_OrderTrackers()
end

function TotemTimers_GUI_DropdownTrackerTimePos_OnShow()
	UIDropDownMenu_SetText(TotemTimers_GUI_TimePosOptions[TotemTimers_Settings.TrackerTimePos], TotemTimers_GUI_DropdownTrackerTimePos)	
end