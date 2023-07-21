-- msg dropdown menu
local TotemTimers_GUI_MsgOptions = {
	["tt"] = TT_GUI_TT,
	["sct"] = TT_GUI_SCT,
	["sct2"] = TT_GUI_SCT2,
	--["sctmsg"] = TT_GUI_SCTMSG,
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
	TotemTimers_ProcessSetting("Msg")
end

function TotemTimers_GUI_DropdownMsg_OnShow()
	UIDropDownMenu_SetText(TotemTimers_GUI_MsgOptions[TotemTimers_Settings.Msg], TotemTimers_GUI_DropdownMsg)	
end