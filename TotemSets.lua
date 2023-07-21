-- Copyright (c) 2006-2008 Xianghar
-- This code is not to be reproduced or modified without permission from author

local buttonlocations = {
	{"BOTTOM", "TOP"},
	{"BOTTOMLEFT", "TOPRIGHT"},
	{"LEFT", "RIGHT"},
	{"TOPLEFT", "BOTTOMRIGHT"},
	{"TOP", "BOTTOM"},
	{"TOPRIGHT", "BOTTOMLEFT"},
	{"RIGHT", "LEFT"},
	{"BOTTOMRIGHT", "TOPLEFT"},
}

function TotemTimers_ProgramSetButtons()
	if not TotemTimers_AnkhHeader then 
		TotemTimers_Ankh.header = CreateFrame("Frame", "TotemTimers_AnkhHeader", UIParent, "SecureStateHeaderTemplate")
		TotemTimers_AnkhHeader:SetAttribute("state", "1")
		TotemTimers_AnkhHeader:SetAttribute("addchild", TotemTimers_Ankh)
		for i=1,4 do
			TotemTimers_AnkhHeader:SetAttribute("addchild", TotemTimers_Buttons[i].header)
		end

		TotemTimers_Ankh:SetAttribute("newstate1", "1,3-10:2;2:1")
		TotemTimers_Ankh:SetAttribute("newstate2", "1")
		TotemTimers_Ankh:RegisterForClicks("LeftButtonUp", "RightButtonUp")		
		
		TotemTimers_Ankh:SetAttribute("anchorchild", TotemTimers_AnkhHeader)
		TotemTimers_Ankh:SetAttribute("*childstate-OnLeave", "leave")
		TotemTimers_Ankh:SetAttribute("*childstate-OnEnter", "enter")
		TotemTimers_AnkhHeader:SetAttribute("statemap-anchor-leave", ";")
		TotemTimers_AnkhHeader:SetAttribute("statemap-anchor-enter", ";")

		TotemTimers_AnkhHeader:SetAttribute("delaystatemap-anchor-leave", "2:1")
		TotemTimers_AnkhHeader:SetAttribute("delaytimemap-anchor-leave",  "2:0.05")
		TotemTimers_AnkhHeader:SetAttribute("delayhovermap-anchor-leave", "2:true")
	end	
	
	if not TotemTimers_TotemSets then TotemTimers_TotemSets = {} end
	
	for i=1,8 do
		local b = getglobal("TotemTimers_SetButton"..i)
		if b then
			b:SetAttribute("showstates", ";")
		end
		for j=1,4 do
			TotemTimers_Buttons[j].header:SetAttribute("statemap-parent-"..(i+2), ";")
		end
	end
	local nr = 0
	for i,set in pairs(TotemTimers_TotemSets) do
		nr = nr + 1
		if nr < 9 then
			local b = getglobal("TotemTimers_SetButton"..i)
			if not b then
				b = CreateFrame("Button", "TotemTimers_SetButton"..i, TotemTimers_AnkhHeader, "TotemTimers_SetButtonTemplate")
				TotemTimers_AnkhHeader:SetAttribute("addchild", b)
				b:SetScale((TotemTimers_Settings.TrackerSize-2)/28)
			end
			b.nr = i
			for j=1,4 do
				getglobal("TotemTimers_SetButton"..i.."Icon"..j):SetTexture(GetSpellTexture(set[j]))
			end
			b:SetAttribute("showstates", "2")
			b:SetAttribute("newstate1", i+2)
			b:SetAttribute("newstate2", i+2)
			b:SetPoint(buttonlocations[nr][1], TotemTimers_Ankh, buttonlocations[nr][2])
			b:RegisterForClicks("LeftButtonDown", "RightButtonDown")
			for j=1,4 do
				for k = 1,#TotemTimers_ActiveOrder[j] do
					if TotemTimers_ActiveOrder[j][k] == set[j] then
						TotemTimers_Buttons[j].header:SetAttribute("statemap-parent-"..(i+2), k)
					end
				end				
			end
		end
	end

end

function TotemTimers_Ankh_OnClick(button)
	if button == "RightButton" then
		if InCombatLockdown() or #TotemTimers_TotemSets >= 8 then return end
		for i=1,4 do
			if not TotemTimers_ActiveOrder[i] or #TotemTimers_ActiveOrder[i]<1 then
				return
			end
		end
		if not TotemTimers_TotemSets then
			TotemTimers_TotemSets = {}
		end
		local nr = #TotemTimers_TotemSets+1
		TotemTimers_TotemSets[nr] = {}
		for i=1,4 do
			TotemTimers_TotemSets[nr][i] = TotemTimers_Buttons[i].spell
		end
		TotemTimers_ProgramSetButtons()
	end
end

function TotemTimers_SetButton_OnClick(frame, button)
	if button == "RightButton" then
		local popup = StaticPopup_Show("TOTEMTIMERS_DELETESET", frame.nr)
		popup.data = frame.nr
	end
end

local function TotemTimers_DeleteSet(nr)
	if not InCombatLockdown() then
		table.remove(TotemTimers_TotemSets,nr)
		TotemTimers_ProgramSetButtons()
	end
end

StaticPopupDialogs["TOTEMTIMERS_DELETESET"] = {
  text = TT_DELETE_TOTEM_SET,
  button1 = TEXT(OKAY),
  button2 = TEXT(CANCEL),
  whileDead = 1,
  hideOnEscape = 1,
  timeout = 0,
  OnAccept = TotemTimers_DeleteSet,
}