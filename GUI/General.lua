local spellIDs = TotemTimers_SpellIDs
local sharedmedia = false
if LibStub then
	sharedmedia = LibStub:GetLibrary("LibSharedMedia-3.0", true)
end

function TotemTimers_GUI_ShowTooltip(textvar, istext)
	local text = textvar
	if not istext then text = getglobal(textvar) end
	if text then
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
		GameTooltip:SetText(text, 1,1,1,1,1)
	end
end


function TotemTimers_GUI_TimeFont_OnLoad()
	if sharedmedia then
		local fonts = sharedmedia:List("font")
		local info = {}
		info.notCheckable = 1
		info.func = TotemTimers_GUI_TimeFont_OnClick
		for k,v in pairs(fonts) do
			local f = sharedmedia:Fetch("font", v)
			info.text = v
			info.arg1 = f
			UIDropDownMenu_AddButton(info)
			getglobal("DropDownList1Button"..k):SetFont(f, UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT)
		end
	end
end

function TotemTimers_GUI_TimeFont_OnClick(newFont)
	TotemTimers_Settings.TimeFont = newFont
	TotemTimers_SetTimeFont(newFont)
	TotemTimers_GUI_General:Hide()
	TotemTimers_GUI_General:Show()
end

function TotemTimers_GUI_TimeFont_OnShow()
	if sharedmedia then
		UIDropDownMenu_SetText(TotemTimers_Settings.TimeFont, TotemTimers_GUI_TimeFont)
	end
end


function TotemTimers_GUI_TimerBarTexture_OnLoad()
	if sharedmedia then
		local fonts = sharedmedia:List("statusbar")
		local info = {}
		info.notCheckable = 1
		info.func = TotemTimers_GUI_TimerBarTexture_OnClick
		for k,v in pairs(fonts) do
			local f = sharedmedia:Fetch("statusbar", v)
			info.text = v
			info.arg1 = f
			UIDropDownMenu_AddButton(info)
		end
	end
end

function TotemTimers_GUI_TimerBarTexture_OnClick(texture)
	TotemTimers_Settings.TimerBarTexture = texture
	TotemTimers_ProcessSetting("TimerBarTexture")
	TotemTimers_GUI_General:Hide()
	TotemTimers_GUI_General:Show()
end

function TotemTimers_GUI_TimerBarTexture_OnShow()
	if sharedmedia then
		UIDropDownMenu_SetText(select(3,string.find(TotemTimers_Settings.TimerBarTexture, "(%a+)$")), TotemTimers_GUI_TimerBarTexture)
	end
end

