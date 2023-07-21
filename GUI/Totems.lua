function TotemTimers_GUI_Totems_OnShow(frame, element)
	last = nil
	local nr = 0
	for _,totem in pairs(TotemTimers_Order[element]) do
		nr = nr + 1
		if TotemData[totem] then
			if not getglobal("TotemTimers_GUI_Text"..totem) then
				local f = frame:CreateFontString("TotemTimers_GUI_Text"..totem, "ARTWORK", "GameFontNormal")
				f:SetText(totem)
				f:SetWidth(150)
				f:SetJustifyH("LEFT")
				local down = CreateFrame("Button", "TotemTimers_GUI_Down"..totem, frame, "TotemTimers_GUI_Down")
				local up = CreateFrame("Button", "TotemTimers_GUI_Up"..totem, frame, "TotemTimers_GUI_Up")
				up.element, down.element = element, element			
				local check = CreateFrame("CheckButton", "TotemTimers_GUI_CheckHide"..totem, frame, "TotemTimers_GUI_CheckHide")
				getglobal("TotemTimers_GUI_CheckHide"..totem.."Text"):SetText(TT_GUI_HIDE)
			end
			local totemText = getglobal("TotemTimers_GUI_Text"..totem)
			local upButton = getglobal("TotemTimers_GUI_Up"..totem)
			local downButton = getglobal("TotemTimers_GUI_Down"..totem)
			if last == nil then
				upButton:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -15)
			else
				upButton:SetPoint("TOPLEFT", last, "TOPLEFT", 0, -40)
			end
			downButton:SetPoint("LEFT", upButton, "RIGHT", 5, 0)
			totemText:SetPoint("LEFT", downButton, "RIGHT", 10, 0)
			getglobal("TotemTimers_GUI_CheckHide"..totem):SetPoint("LEFT", totemText, "RIGHT", 10,0)
			last = upButton
			upButton.nr = nr
			downButton.nr = nr
		end
	end
end

function TotemTimers_GUI_SwitchOrder(element, totem1, totem2)
	if InCombatLockdown() or totem1 < 1 or totem2 < 1 
	  or totem1 > #TotemTimers_Order[element] or totem2 > #TotemTimers_Order[element]
		then
		return
	end
	local oldSwitchAgiWf = TotemTimers_Settings.SwitchAgiWf
	TotemTimers_Settings.SwitchAgiWf = false
	TotemTimers_ProcessSetting("SwitchAgiWf")
	TotemTimers_Order[element][totem1], TotemTimers_Order[element][totem2]
		= TotemTimers_Order[element][totem2], TotemTimers_Order[element][totem1]
	TotemTimers_CalcActiveOrder()
	TotemTimers_ReprogramSlaveButtons()
	TotemTimers_ReorderElements()
	TotemTimers_Settings.SwitchAgiWf = oldSwitchAgiWf
	TotemTimers_ProcessSetting("SwitchAgiWf")
end

function TotemTimers_GUI_Up_OnClick(self)
	TotemTimers_GUI_SwitchOrder(self.element, self.nr-1, self.nr)
	self:GetParent():Hide()
	self:GetParent():Show()
end

function TotemTimers_GUI_Down_OnClick(self)
	TotemTimers_GUI_SwitchOrder(self.element, self.nr+1, self.nr)
	self:GetParent():Hide()
	self:GetParent():Show()
end
