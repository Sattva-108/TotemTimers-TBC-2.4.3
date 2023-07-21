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
	TotemTimers_GUI_Timers2:Hide()
	TotemTimers_GUI_Timers2:Show()
	TotemTimers_ReorderElements()
	TotemTimers_UpdateMacro()
end

function TotemTimers_GUI_DropdownBarDirection_OnShow()
	UIDropDownMenu_Initialize(this, TotemTimers_GUI_DropdownBarDirection_OnLoad)
	UIDropDownMenu_SetText(TotemTimers_GUI_BarDirections[TotemTimers_Settings.BarDirection], this)
end

-- party buffs location dropdown menu
local TotemTimers_GUI_PartyBuffsOptions = {
	["top"] = TT_GUI_TOP,
	["left"] = TT_GUI_LEFT,
	["right"] = TT_GUI_RIGHT,
	["bottom"] = TT_GUI_BOTTOM,
}

function TotemTimers_GUI_DropdownPartyBuffs_OnLoad()
	local info = {}
	info.notCheckable = 1
	info.func = TotemTimers_GUI_DropdownPartyBuffs_OnClick
	for option, text in pairs(TotemTimers_GUI_PartyBuffsOptions) do
		info.text = text
		info.arg1 = option
		UIDropDownMenu_AddButton(info)
	end
end

function TotemTimers_GUI_DropdownPartyBuffs_OnClick(value)
	TotemTimers_Settings.PartyBuffSide = value
	UIDropDownMenu_SetText(TotemTimers_GUI_PartyBuffsOptions[value], TotemTimers_GUI_DropdownPartyBuffs)
	TotemTimers_ReorderElements()
end

function TotemTimers_GUI_DropdownPartyBuffs_OnShow()
	UIDropDownMenu_SetText(TotemTimers_GUI_PartyBuffsOptions[TotemTimers_Settings.PartyBuffSide], TotemTimers_GUI_DropdownPartyBuffs)
end