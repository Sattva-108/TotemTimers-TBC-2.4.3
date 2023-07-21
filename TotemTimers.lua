-- Copyright (c) 2007 Xianghar
-- This code is not to be reproduced or modified without permission from author


--[[StaticPopupDialogs["TOTEMTIMERS_MOUSEOVER"] = {
  text = ""
  button1 = TEXT(OKAY),
  sound = "levelup2",
  whileDead = 1,
  hideOnEscape = 1,
  timeout = 0,
};]]

TotemTimers_NeedsUpdate = {}
local SCT = SCT
local MikSBT = MikSBT
local settings = {}
local TotemData = TotemData
local TimerButtons = TotemTimers_Buttons
local ActiveTotems = {}
local FormatTime = TotemTimers_FormatTime
local Parrot = Parrot

local GetSpellTexture = GetSpellTexture
local function TotemTimers_SpellTexture(totem)
	if totem == TT_ANCIENT_MANA_SPRING then
		return "Interface\\Icons\\INV_Wand_01"
	else
		return GetSpellTexture(totem)
	end
end

local warnings = {
	["ExpirationWarning"] = {
		["color"] = {r=1.0, g=0.5, b=0.0},
		["defColor"] = {r=1.0, g=1.0, b=0.0},
		["text"] = TT_WARNING,
	},
	["ExpirationNotification"] = {
		["color"] = {r=1.0, g=0.0, b=0.0},
		["defColor"] = {r=0.0, g=1.0, b=0.0},
		["text"] = TT_EXPIRED,
	},
	["DestroyedNotification"] = {
		["color"] = {r=1.0, g=0.0, b=0.0},
		["defColor"] = {r=0.0, g=1.0, b=0.0},
		["text"] = TT_DESTROYED,
	},
	["ShieldNotification"] = {
		["color"] = {r=1.0, g=0.0, b=0.0},
		["defColor"] = {r=0.0, g=1.0, b=0.0},
		["text"] = TT_SHIELDINACTIVE,
	},
	["EarthShieldNotification"] = {
		["color"] = {r=1.0, g=0.0, b=0.0},
		["defColor"] = {r=0.0, g=1.0, b=0.0},
		["text"] = TT_SHIELDINACTIVE,
	},
	["WeaponNotification"] = {
		["color"] = {r=1.0, g=0.0, b=0.0},
		["defColor"] = {r=0.0, g=1.0, b=0.0},
		["text"] = TT_EXPIRED,
		},
}

local timerBarBackdrop = {
	bgFile="Interface/Tooltips/UI-Tooltip-Background",
	edgeFile="Interface/Tooltips/UI-Tooltip-Border",
	tile="true",
	tileSize=16,
	edgeSize=1,
}

local msgfunc = nil
local defmsgfunc = function(warning, type, spell)
	UIErrorsFrame:AddMessage(warning,warnings[type].defColor.r, warnings[type].defColor.g,
			warnings[type].defColor.b, 1.0, UIERRORS_HOLD_TIME);
end

local TotemData = TotemData

function TotemTimers_ProcessSetting(setting)
	if setting == "Recast" then
		if TotemTimers_Settings.Recast and TotemTimers_Settings.Style ~= "buff" then
			TotemTimers_ReactivateButtons()
		else
			TotemTimers_DeactivateButtons()
			--TotemTimers_Settings.Recast = false
		end
		--TotemTimers_UpdateAllButtons()
		TotemTimers_SetupElementCooldowns()
	elseif setting == "Show" then
		if TotemTimers_Settings.Show then
			--TotemTimersFrame:Show()
			TotemTimers_Enable()
		else
			TotemTimers_Disable()
			--TotemTimersFrame:Hide()
		end
	elseif setting == "MiniIcons" then
		if TotemTimers_Settings.MiniIcons and TotemTimers_Settings.Recast 
		  and TotemTimers_Settings.Style~="buff" and TotemTimers_Settings.Style~="fixed" then
			for element = 1,4 do
				TotemTimers_Buttons[element].spellIcon:Show()
			end
		else
			for element = 1,4 do
				TotemTimers_Buttons[element].spellIcon:Hide()
			end
		end
	elseif setting == "Reincarnation" or setting == "ShieldTracker" 
	or setting == "EarthShieldTracker" or setting == "MainEnchant" then
		TotemTimers_OrderTrackers()
	elseif string.sub(setting,1,7) == "Visible" then
		TotemTimers_ReorderElements()
		TotemTimers_UpdateMacro()
	elseif setting == "MouseOver" then
		for element = 1,4 do
			TotemTimers_SetMouseOver(element)
		end
		TotemTimers_InitializeBindings()
	elseif setting == "Style" then
		for e = 1,4 do TotemTimers_Buttons[e].element = e end
		if TotemTimers_Settings.Style == "sticky" or TotemTimers_Settings.Style == "element" then
			for element = 1,4 do
				--TotemTimers_Buttons[element].element = element
				TotemTimers_Buttons[element]:SetHighlightTexture("Interface\Buttons\ButtonHilight-Square")
				TotemTimers_Buttons[element].icon:Show()
				TotemTimers_ProcessSetting("MouseOver")
				TotemTimers_ProcessSetting("MiniIcons")
			end	
		else
			if TotemTimers_Settings.Recast then
				--DEFAULT_CHAT_FRAME:AddMessage("TotemTimers: Recasting cannot be enabled with buff or fixed style.")
				--TotemTimers_Settings.Recast = false
				TotemTimers_ProcessSetting("Recast")
			end
			for element = 1,4 do
				TotemTimers_Buttons[element]:SetHighlightTexture(nil)
			end	
		end
		TotemTimers_UpdateAllButtons()
		TotemTimers_SetupElementCooldowns()
		TotemTimers_UpdatePartyIcons()
		TotemTimers_UpdatePlayerIcon()
	elseif setting == "ShowBar" then
		TotemTimers_UpdateAllButtons()
		TotemTimers_SetTrackerBars(TotemTimers_Settings.ShowBar)
	elseif setting == "ShowPartyBuffs" then
		if not TotemTimers_Settings.ShowPartyBuffs then
			for e=1,4 do for j=1,4 do TotemTimers_Buttons[e].party[j]:Hide() end end
		else
			TotemTimers_UpdatePartyIcons()
		end
		TotemTimers_ReorderElements()
	elseif setting == "ShowPlayerBuffDot" then
		if not TotemTimers_Settings.ShowPlayerBuffDot then
			for e=1,4 do TotemTimers_Buttons[e].player:Hide() end
		else
			TotemTimers_UpdatePlayerIcon()
		end
	elseif setting == "ShowFireElementalButton" or setting == "ShowManaTideButton" or setting == "ShowEarthElementalButton" and TotemTimers_IsSetUp then
		TotemTimers_ReorderElements()
	elseif setting == "Msg" then
		if TotemTimers_Settings.Msg == "tt" then msgfunc = defmsgfunc
		elseif TotemTimers_Settings.Msg == "sct" then
			msgfunc =
				function(warning, type, spell)
					if not SCT then defmsgfunc(warning, type, spell) else
						SCT:DisplayText(warning, warnings[type].color, nil, nil, SCT.FRAME1, nil, nil, TotemTimers_SpellTexture(spell))
					end
				end
		elseif TotemTimers_Settings.Msg == "sct2" then
			msgfunc = 
				function(warning, type, spell)
					if not SCT then defmsgfunc(warning, type, spell) else
						SCT:DisplayText(warning, warnings[type].color, true, nil, SCT.FRAME1, nil,nil, TotemTimers_SpellTexture(spell))
					end
				end
		--[[elseif TotemTimers_Settings.Msg == "sctmsg" then
			msgfunc = 
				function(warning, type, spell)
					if not SCT then defmsgfunc(warning, type, spell) else
						SCT:DisplayText(warning, warnings[type].color, nil, nil, SCT.MSG, nil,nil, TotemTimers_SpellTexture(spell))
					end
				end]]
		elseif TotemTimers_Settings.Msg == "msbt" then
			msgfunc = 
				function(warning, type, spell)
					if not MikSBT then defmsgfunc(warning, type, spell) else
						MikSBT.DisplayMessage(warning, nil, nil, warnings[type].color.r*255,warnings[type].color.g*255,warnings[type].color.b*255)
					end
				end
		elseif TotemTimers_Settings.Msg == "parrot" then
			msgfunc = 
				function(warning, type, spell)
					if not Parrot then defmsgfunc(warning, type, spell) else
						Parrot:ShowMessage(warning, "Notification", false, warnings[type].color.r,
							warnings[type].color.g, warnings[type].color.b)
					end
				end
		elseif TotemTimers_Settings.Msg == "chat" then
			msgfunc =
				function(warning, type, spell)
					DEFAULT_CHAT_FRAME:AddMessage(warning, warnings[type].defColor.r, warnings[type].defColor.g, warnings[type].defColor.b)
				end
		end
	elseif setting == "SwitchAgiWf" then
		local element = AIR_TOTEM_SLOT
		local agi, wf = 0,0
		local numTotems = #TotemTimers_ActiveOrder[AIR_TOTEM_SLOT]
		for i=1,#TotemTimers_ActiveOrder[element] do
			if TotemTimers_ActiveOrder[element][i] == TT_GRACE_OF_AIR then agi = i
			elseif TotemTimers_ActiveOrder[element][i] == TT_WINDFURY then wf = i
			end
		end
		if TotemTimers_Settings.SwitchAgiWf then
			TotemTimers_Buttons[element]:SetAttribute("newstate-S"..agi, wf)
			TotemTimers_Buttons[element]:SetAttribute("newstate-S"..wf, agi)
			TotemTimers_Buttons[element]:SetAttribute("newstate-S"..(agi+numTotems), (wf+numTotems))
			TotemTimers_Buttons[element]:SetAttribute("newstate-S"..(wf+numTotems), (agi+numTotems))
		else
			TotemTimers_Buttons[element]:SetAttribute("newstate-S"..agi, nil)
			TotemTimers_Buttons[element]:SetAttribute("newstate-S"..wf, nil)
			TotemTimers_Buttons[element]:SetAttribute("newstate-S"..(agi+numTotems), nil)
			TotemTimers_Buttons[element]:SetAttribute("newstate-S"..(wf+numTotems), nil)
		end
	elseif setting == "DisableMenuDelay" then
		local seconds = "0.5"
		if TotemTimers_Settings.DisableMenuDelay then seconds = "0.05" end
		for e = 1,4 do
			local tcount = #TotemTimers_ActiveOrder[e]
			TotemTimers_Buttons[e].header:SetAttribute("delaytimemap-anchor-leave",  (tcount+1).."-"..(tcount*2)..":"..seconds)
		end
	elseif setting == "ShieldLeftButton" then
		TotemTimers_Shield:SetAttribute("*spell1",TotemTimers_Settings.ShieldLeftButton)
	elseif setting == "ShieldRightButton" then
		TotemTimers_Shield:SetAttribute("*spell2", TotemTimers_Settings.ShieldRightButton)
	elseif setting == "ShieldMiddleButton" then
		TotemTimers_Shield:SetAttribute("*spell3", TotemTimers_Settings.ShieldMiddleButton)
	elseif setting == "EarthShieldLeftButton" then
		TotemTimers_EarthShield:SetAttribute("*unit1", TotemTimers_Settings.EarthShieldLeftButton)
	elseif setting == "EarthShieldRightButton" then
		TotemTimers_EarthShield:SetAttribute("*unit2", TotemTimers_Settings.EarthShieldRightButton)
	elseif setting == "EarthShieldMiddleButton" then
		TotemTimers_EarthShield:SetAttribute("*unit3", TotemTimers_Settings.EarthShieldMiddleButton)
	elseif setting == "EarthShieldButton4" then
		TotemTimers_EarthShield:SetAttribute("*unit4", TotemTimers_Settings.EarthShieldButton4)
	elseif setting == "TimeFont" then
		TotemTimers_SetTimeFont(TotemTimers_Settings.TimeFont)
	elseif setting == "ColorTimerBars" then
		if TotemTimers_Settings.ColorTimerBars then
			TotemTimers_Buttons[AIR_TOTEM_SLOT].timerBar:SetStatusBarColor(0.6,0.6,1.0,1.0)
			TotemTimers_Buttons[WATER_TOTEM_SLOT].timerBar:SetStatusBarColor(0.2,0.2,1.0,0.7)
			TotemTimers_Buttons[EARTH_TOTEM_SLOT].timerBar:SetStatusBarColor(0.5,0.3,0.1,1.0)
			TotemTimers_Buttons[FIRE_TOTEM_SLOT].timerBar:SetStatusBarColor(1.0,0.1,0.1,0.9)
		else
			for i=1,4 do
				TotemTimers_Buttons[i].timerBar:SetStatusBarColor(0.2,0.2,1.0,0.7)
			end
		end
	elseif setting == "TimerBarTexture" then
		for i=1,4 do
			TotemTimers_Buttons[i].timerBar:SetStatusBarTexture(TotemTimers_Settings.TimerBarTexture)
		end
		TotemTimers_AnkhTimerBar:SetStatusBarTexture(TotemTimers_Settings.TimerBarTexture)
		TotemTimers_ShieldTimerBar:SetStatusBarTexture(TotemTimers_Settings.TimerBarTexture)
		TotemTimers_EarthShieldTimerBar:SetStatusBarTexture(TotemTimers_Settings.TimerBarTexture)
		TotemTimers_MainHandTimerBar:SetStatusBarTexture(TotemTimers_Settings.TimerBarTexture)
		TotemTimers_MainHandTimerBar2:SetStatusBarTexture(TotemTimers_Settings.TimerBarTexture)
	elseif setting == "HideBlizzTimers" then
		if TotemTimers_Settings.HideBlizzTimers then
			TotemFrame:UnregisterEvent("PLAYER_TOTEM_UPDATE");
			TotemFrame:UnregisterEvent("PLAYER_ENTERING_WORLD");
			TotemFrame:Hide()
		else
			TotemFrame:RegisterEvent("PLAYER_TOTEM_UPDATE");
			TotemFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
			TotemFrame:Show()
		end
	end
end

function TotemTimers(msg)
	command = string.lower(msg);

	local i = 1;
	arg = {};
	local tmparg = nil;
	for tmparg in string.gmatch(command, "%w+") do
		arg[i] = tmparg;
		i = i + 1;
	end

	if arg[1] == TT_DEBUG then
		if TotemTimers_DebugScrollFrame:IsVisible() then
			TotemTimers_DebugScrollFrame:Hide()
		else
			TotemTimers_DebugScrollFrame:Show()
		end
	elseif( arg[1] == "reset" ) then
		DEFAULT_CHAT_FRAME:AddMessage(TT_RESET);
		TotemTimers_Order = nil
		TotemTimers_Settings = nil
		TotemTimers_SetupVariables()
		TotemTimersFrame:ClearAllPoints();
		TotemTimersFrame:SetPoint("CENTER", "UIParent", "CENTER");
		TotemTimers_Ankh:ClearAllPoints();
		TotemTimers_Ankh:SetPoint("CENTER", "UIParent", "CENTER");
		TotemTimers_TrackerFrame:ClearAllPoints();
		TotemTimers_TrackerFrame:SetPoint("CENTER", "UIParent", "CENTER");
		TotemTimers_Shield:ClearAllPoints();
		TotemTimers_Shield:SetPoint("CENTER", "UIParent", "CENTER");
		TotemTimers_EarthShield:ClearAllPoints();
		TotemTimers_EarthShield:SetPoint("CENTER", "UIParent", "CENTER");
		TotemTimers_UpdateAllButtons()
		TotemTimers_ReorderElements()
		for k,_ in pairs(TotemTimers_Settings) do
			if k ~= "Totems" then
				TotemTimers_ProcessSetting(k)
			end
		end
	else
		if InCombatLockdown() then
			DEFAULT_CHAT_FRAME:AddMessage("Can't open TT options in combat.")
			return
		end
		ShowUIPanel(InterfaceOptionsFrame)
		InterfaceOptionsFrame.lastFrame = GameMenuFrame
		TotemTimers_OpenGUI = true
		InterfaceOptionsFrameTab2:GetScript("OnClick")()
		local buttons = InterfaceOptionsFrameAddOns.buttons
		InterfaceOptionsFrameAddOnsList.offset = 0
		InterfaceAddOnsList_Update()
		local ttname = "TotemTimers "..tostring(GetAddOnMetadata("TotemTimers", "Version"))
		local tt = 0
		local tend = false
		repeat
			for i,v in pairs(buttons) do
				if v.element and v.element.name and v.element.name == ttname then
					tt = i
				else
					tend = true
				end
			end
			if tt == 0 then
				InterfaceOptionsFrameAddOnsList.offset = InterfaceOptionsFrameAddOnsList + 10
				InterfaceAddOnsList_Update()
			end
		until tt > 0 or tend
		if tt > 0 then
			if buttons[tt].element.collapsed then
				InterfaceOptionsListButton_OnClick("RightButton", buttons[tt])
			end
			if InterfaceOptionsFrameAddOns.scrollBar:IsVisible() then
				InterfaceOptionsFrameAddOnsList.offset = InterfaceOptionsFrameAddOnsList.offset+tt-1
				InterfaceAddOnsList_Update()
			end
			for i,v in pairs(buttons) do
				if v.element and v.element == TotemTimers_LastGUIPane then
					InterfaceOptionsListButton_OnClick("LeftButton", v)
				end
			end
		end
	end
end

function TotemTimers_Disable() 
	TotemTimers_IsEnabled = false
	TotemTimersFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
	TotemTimersFrame:UnregisterEvent("PLAYER_TOTEM_UPDATE")
	TotemTimersFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
	TotemTimersFrame:UnregisterEvent("SPELLS_CHANGED")
	TotemTimersFrame:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	TotemTimersFrame:UnregisterEvent("UNIT_AURA")
	TotemTimersFrame:UnregisterEvent("PARTY_MEMBERS_CHANGED")
	TotemTimersFrame:UnregisterEvent("PLAYER_AURAS_CHANGED")
	TotemTimersFrame:Hide()
	if TotemTimers_IsSetUp then TotemTimers_OrderTrackers() end
end

function TotemTimers_Enable() 
	TotemTimers_IsEnabled = true
	TotemTimersFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	TotemTimersFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	TotemTimersFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
	TotemTimersFrame:RegisterEvent("UNIT_AURA")
	TotemTimersFrame:RegisterEvent("PLAYER_TOTEM_UPDATE")
	TotemTimersFrame:RegisterEvent("PARTY_MEMBERS_CHANGED")
	TotemTimersFrame:RegisterEvent("PLAYER_AURAS_CHANGED")
	if TotemTimers_IsSetUp then 
		TotemTimersFrame:RegisterEvent("SPELLS_CHANGED")
		TotemTimersFrame:Show()
		TotemTimers_ReorderElements()
		TotemTimers_OrderTrackers()
	end
end
	
function TotemTimers_OnLoad()
	TotemTimers_Enable();
	this:RegisterForDrag("LeftButton");
end

function TotemTimers_UpdateTotem(e)
	local haveTotem, totem, startTime, duration, icon

	haveTotem, totem, startTime, duration, icon = GetTotemInfo(e)
	totem = string.gsub(totem, " [VI]+$", "")
	if TT_COMBATLOG_TO_SPELL[totem] then totem = TT_COMBATLOG_TO_SPELL[totem] end
	if not TotemData[totem] then
		totem = ActiveTotems[e].totem
		if duration>0 then TotemTimers_NeedsUpdate[e] = true end
	end
	if duration > 0 then
		if not ActiveTotems[e].active or ActiveTotems[e].totem ~= totem then
			if totem == TT_EARTH_ELEMENTAL then
				if settings.EarthShout then
					if GetNumRaidMembers()>0 then
						SendChatMessage(TotemTimers_Settings.EarthShoutText, "RAID");
					elseif GetNumPartyMembers()>0 then
						SendChatMessage(TotemTimers_Settings.EarthShoutText, "PARTY");
					end			
				end
			elseif totem == TT_FIRE_ELEMENTAL then
				if settings.FireShout then
					if GetNumRaidMembers()>0 then
						SendChatMessage(TotemTimers_Settings.FireShoutText, "RAID");
					elseif GetNumPartyMembers()>0 then
						SendChatMessage(TotemTimers_Settings.FireShoutText, "PARTY");
					end			
				end
			elseif totem == TT_MANA_TIDE then
				if settings.ManaShout and GetNumPartyMembers()>0 then
					SendChatMessage(TotemTimers_Settings.ManaShoutText, "PARTY");
				end
			end
		end
		local activeTotem = ActiveTotems[e]
		activeTotem.element = e
		activeTotem.duration = duration
		activeTotem.maxduration = duration
		activeTotem.totem = totem
		activeTotem.active = true
		activeTotem.warningTime = settings.WarningTime or 10
		TotemTimers_UpdateButton(TimerButtons[e])
		if totem == TT_WINDFURY then
			activeTotem.twisting = 9
		end
	elseif ActiveTotems[e].active then
		local activeTotem = ActiveTotems[e]
		if ActiveTotems[e].duration<1 then
			TotemTimers_Warning("ExpirationNotification", activeTotem.totem)
		else
			TotemTimers_Warning("DestroyedNotification", activeTotem.totem)
		end
		activeTotem.active = false;
		TotemTimers_UpdateButton(TimerButtons[e])
	end 

end

function TotemTimers_OnEvent(event, arg1, arg2, arg3)
	--DEFAULT_CHAT_FRAME:AddMessage("Got Event:"..event);
	if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_DEAD" 
	  or (event == "UNIT_SPELLCAST_SUCCEEDED" and arg1 == "player" and arg2 == TT_TOTEMIC_CALL) then
		TotemTimers_SetupGlobals();
		if TotemTimers_IsEnabled then
			for _, element in pairs(TTActiveTotems) do
				element.active = false;
			end
			TotemTimers_UpdateAllButtons()
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		if TotemTimers_MacroNeedsUpdate then
			TotemTimers_MacroNeedsUpdate = false
			TotemTimers_UpdateMacro()
		end
	elseif event == "SPELLS_CHANGED" then
		if InCombatLockdown() then
			TotemTimers_UpdatedSpells = true
		else
			TotemTimers_SpellsChanged()
		end
	elseif event == "PLAYER_TOTEM_UPDATE" then
		TotemTimers_UpdateTotem(arg1)
	elseif event == "UNIT_AURA" and TotemTimers_Settings.ShowPartyBuffs then
		if strsub(arg1,1,5) == "party" then TotemTimers_UpdatePartyIcons() end
	elseif event == "PARTY_MEMBERS_CHANGED" and TotemTimers_Settings.ShowPartyBuffs then
		TotemTimers_UpdatePartyIcons()
	elseif event == "PLAYER_AURAS_CHANGED" and TotemTimers_Settings.ShowPlayerBuffDot then
		TotemTimers_UpdatePlayerIcon()
	end
end


function TotemTimers_UpdateButton(button)
	if TotemTimers_Settings.ShowTotemsAsBuffs then TotemTimers_ThrowAuraEvent() end
	if settings.Style == "buff" then
		return TotemTimers_UpdateAllButtons()
	end
	local element = button.element
	if ActiveTotems[element] then
		local data = ActiveTotems[element]
		if data.totem then
			button.icon:SetTexture(TotemTimers_SpellTexture(data.totem))
		end
		if data.active and data.totem then
			button.icon:SetAlpha(1.0);
			if BuffFrame.BuffFrameUpdateTime <= 0 then
				FormatTime(button.time, data.duration)
			end
			local button = TimerButtons[element]
			if settings.ShowBar then
				button.timerBar:SetBackdrop(timerBarBackdrop)
				button.timerBar:SetMinMaxValues(0,data.maxduration)
				button.timerBar:SetValue(data.duration)
			else
				button.timerBar:SetBackdrop({})
				button.timerBar:SetValue(0)
			end
			if settings.ProcFlash and TotemData[data.totem].flashInterval then
				button.statusBar:Show()
				local delay = TotemData[data.totem].flashDelay or 0
				button.statusBar:SetMinMaxValues(0,TotemData[data.totem].flashInterval)
				button.statusBar:SetValue(0)
			else
				button.statusBar:Hide()
			end
		else
			button.timerBar:SetBackdrop({})
			button.timerBar:SetValue(0)
			button.statusBar:SetValue(0)
			button.time:SetText("")
			if settings.Style == "sticky" and data.totem then
				button.icon:SetTexture(TotemTimers_SpellTexture(data.totem));
				button.icon:SetAlpha(0.4);
			elseif settings.Style == "element" and data.totem then
				button.icon:SetTexture("Interface\\Icons\\"..TT_EMPTY_ICON);
				button.icon:SetAlpha(1.0)
			--elseif settings.Style == "fixed" and data.totem then
			--	button.icon:Hide()
			else
				button.icon:SetTexture(nil)
			end
		end
	else
		if settings.Style == "element" then
			TimerButtons[element].icon:SetTexture("Interface\\Icons\\"..TT_EMPTY_ICON);
			TimerButtons[element].time:SetText(element);
			TimerButtons[element].icon:SetAlpha(1.0);
			TimerButtons[element].time:SetTextColor(1.0,.8,0);
			--TimerButtons[element]:Show()
		else
		end
	end
end

function TotemTimers_UpdateAllButtons()
	if settings.Style ~= "buff" then
		for element = 1,4 do
			TotemTimers_UpdateButton(TimerButtons[element])
		end
	else
		if TotemTimers_Settings.ShowTotemsAsBuffs then TotemTimers_ThrowAuraEvent() end
		for element = 1,4 do
			local button = TimerButtons[element]
			button.icon:SetAlpha(1.0);
			button.icon:SetTexture("");
			--button.icon:Hide()
			button.time:SetText("");
			button.statusBar:Hide()
			--button.timerBar:Hide()
			if not InCombatLockdown() and settings.Show then button:Show() end
			--get order nr
			local pos = 0
			for i=1,4 do
				if settings.Order[i] == element then pos = i end
			end
			local count = 0
			local totem = 0
			for i=1,4 do
				if ActiveTotems[settings.Order[i]].active then
					count = count + 1
					if count == pos then totem = i end
				end
			end
			if totem > 0 then
				TimerButtons[element].element = settings.Order[totem]
				local data = ActiveTotems[settings.Order[totem]]
				if data and data.totem then
					button.icon:SetTexture(TotemTimers_SpellTexture(data.totem));
					FormatTime(button.time, data.duration)
					--button.icon:Show()
					if settings.ShowBar then
						button.timerBar:SetBackdrop(timerBarBackdrop)
						button.timerBar:SetMinMaxValues(0,data.maxduration)
						button.timerBar:SetValue(data.duration)
					else
						button.timerBar:SetBackdrop({})
						button.timerBar:SetValue(0)
					end
					if settings.ProcFlash and TotemData[data.totem].flashInterval then
						button.statusBar:Show()
						local delay = TotemData[data.totem].flashDelay or 0
						button.statusBar:SetMinMaxValues(0,TotemData[data.totem].flashInterval)
						button.statusBar:SetValue(0)
					else
						button.statusBar:Hide()
					end
				end
			else
				button.timerBar:SetBackdrop({})
				button.timerBar:SetValue(0)
				TimerButtons[element].element = nil
			end
		end
	end
end

function TotemTimers_Warning(type, spell)
	if UnitIsDead("player") or not settings[type] then return end
	local warning = format(warnings[type].text, spell)
	msgfunc(warning, type, spell)
	--[[if settings.Msg == "tt" then
		UIErrorsFrame:AddMessage(warning,warnings[type].defColor.r, warnings[type].defColor.g,
			warnings[type].defColor.b, 1.0, UIERRORS_HOLD_TIME);	
	elseif settings.Msg == "sct" and SCT and SCT.DisplayText then
		SCT:DisplayText(warning, warnings[type].color, nil, nil, 1, nil, nil, TotemTimers_SpellTexture(spell))
	elseif settings.Msg == "msbt" and MikSBT and MikSBT.DisplayMessage then
		MikSBT.DisplayMessage(warning, nil, nil,
			warnings[type].color.r*255, warnings[type].color.g*255, warnings[type].color.b*255)
	elseif settings.Msg == "parrot" and Parrot then
		Parrot:ShowMessage(warning, "Notification", false, warnings[type].color.r,
					warnings[type].color.g, warnings[type].color.b);
	elseif settings.Msg == "chat" then
		DEFAULT_CHAT_FRAME:AddMessage(warning, warnings[type].defColor.r, warnings[type].defColor.g, warnings[type].defColor.b)
	end]]
end


function TotemTimers_SetupVariables()
	if not TotemTimers_Settings then
		TotemTimers_Settings = {}
	end
	if not TotemTimers_Settings.Version or TotemTimers_Settings.Version ~= 8.001 then
		DEFAULT_CHAT_FRAME:AddMessage("TotemTimers: Pre-8.0 or no saved settings found, loading defaults...")
		TotemTimers_Settings = {}
		TTActiveTotems = {}
		TotemTimers_Order = {}
	end
	TotemTimers_LoadDefaultSettings()
	--DEFAULT_CHAT_FRAME:AddMessage(TT_LOADED..": Variables");
	if not TTActiveTotems then
		TTActiveTotems = {};
	end
	for element = 1,4 do
		if not TTActiveTotems[element] then TTActiveTotems[element] = {} end
		TTActiveTotems[element].active = false;
	end
	TTActiveTotems[AIR_TOTEM_SLOT].twisting = 0
	for element = 1,4 do
		local count = 1
		while (count <= #TotemTimers_Order[element]) do
			local c2 = count+1
			while (c2<= #TotemTimers_Order[element]) do
				if TotemTimers_Order[element][c2] == TotemTimers_Order[element][count] then
					table.remove(TotemTimers_Order[element], c2)
				end
				c2 = c2 + 1
			end
			count = count+1
		end
	end
end


function TotemTimers_SetupGlobals()
	TotemTimersFrame:UnregisterEvent("PLAYER_ALIVE")
	if TotemTimers_IsSetUp then
		return
	end
	local _, class = UnitClass("player")
	if( class == "SHAMAN" ) then
		TotemTimers_SetupVariables()
		settings = TotemTimers_Settings
		ActiveTotems = TTActiveTotems
		-- Register our slash command
		SLASH_TOTEMTIMERS1 = "/totemtimers";
		SLASH_TOTEMTIMERS2 = "/tt";
		SlashCmdList["TOTEMTIMERS"] = function(msg)
			TotemTimers(msg);
		end
		--TotemTimers_Debug:SetFont(TotemTimers_Debug:GetFont(),10)
		--TotemTimers_Debug:SetFading(false)
		TotemTimers_ButtonSetup()
		TimerButtons = TotemTimers_Buttons
		hooksecurefunc("SetBinding", TotemTimers_SetBinding)
		TotemTimers_InitializeBindings()
		if TotemTimersFrame:GetLeft()<0 or TotemTimersFrame:GetBottom()<0
			or TotemTimersFrame:GetRight()>UIParent:GetWidth()
			or TotemTimersFrame:GetTop()>UIParent:GetHeight()
			then
			TotemTimersFrame:SetPoint("CENTER", UIParent, "CENTER")
		end
		TotemTimers_SetupTrackers()
		for element = 1,4 do
			if not TTActiveTotems[element].totem and #TotemTimers_ActiveOrder[element]>0 then
				TTActiveTotems[element].totem = TotemTimers_ActiveOrder[element][1]
			end			
		end
		for k,_ in pairs(TotemTimers_Settings) do
			if k ~= "Totems" then
				TotemTimers_ProcessSetting(k)
			end
		end
		if settings.Show then TotemTimersFrame:Show() end
		if settings.Show then TotemTimersFrame:RegisterEvent("SPELLS_CHANGED") end
		hooksecurefunc("SaveBindings", function() ClearOverrideBindings(TotemTimersFrame) TotemTimers_InitializeBindings() end)
		--[[if not TotemTimers_Settings.MouseOver then
			if not TotemTimers_Settings.ShowMouseOverDialog or TotemTimers_Settings.ShowMouseOverDialog<3 then
				StaticPopup_Show ("TOTEMTIMERS_MOUSEOVER");
				if not TotemTimers_Settings.ShowMouseOverDialog then TotemTimers_Settings.ShowMouseOverDialog = 1
				else TotemTimers_Settings.ShowMouseOverDialog = TotemTimers_Settings.ShowMouseOverDialog +1
				end
			end
		end]]
		TotemTimers_UpdateAllButtons()
		TotemTimers_UpdateSpellIcons()
		TotemTimers_InitBuffs()
		for i=1,4 do TotemTimers_UpdateTotem(i) end
		TotemTimers_LastGUIPane = TotemTimers_GUI_General
		hooksecurefunc("InterfaceOptionsFrame_OnHide", function() if TotemTimers_OpenGUI then
														  TotemTimers_OpenGUI = false
														  HideUIPanel(GameMenuFrame)
														  end
														end)
		TotemTimers_ProgramSetButtons()
	else
		DEFAULT_CHAT_FRAME:AddMessage("TotemTimers not loaded.")
		getglobal("TotemTimersFrame"):Hide();
		TotemTimers_Disable();
	end
	TotemTimers_IsSetUp = true
end

function TotemTimers_UpdateMacro()
	if TotemTimers_Settings.Style == "buff" then return end
	if not InCombatLockdown() then
		local _, free = GetNumMacros()
		local nr = GetMacroIndexByName("TT Cast")
		if free==18 and nr==0 then return end
		local sequence = "/castsequence reset=combat/60  "
		for i=1,4 do
			if TotemTimers_Settings["Visible"..i] then
				if TimerButtons[settings.Order[i]].spell then
					sequence = sequence .. TimerButtons[settings.Order[i]].spell..", "
				end
			end
		end
		sequence = strsub(sequence, 1, strlen(sequence)-2)
		local nr = GetMacroIndexByName("TT Cast")
		if nr == 0 then
			CreateMacro("TT Cast", 1, sequence, 0, 1)
		else
			EditMacro(nr, "TT Cast", 1, sequence, 0, 1)
		end
	else
		TotemTimers_MacroNeedsUpdate = true
	end
end

function TotemTimers_SpellsChanged()
	local newNumSpells = 0
	for i = 1, GetNumSpellTabs() do
		local _, _, _, numSpells = GetSpellTabInfo(i);
		newNumSpells = newNumSpells + numSpells
	end
	if newNumSpells == TotemTimers_NumSpells then return end
	TotemTimers_GetAvailableTotems() 
	for element = 1,4 do
		if not TTActiveTotems[element].totem and #TotemTimers_ActiveOrder[element]>0 then
			TTActiveTotems[element].totem = TotemTimers_ActiveOrder[element][1]
		end
	end
	TotemTimers_ReprogramSlaveButtons()
	TotemTimers_ReorderElements()
	TotemTimers_UpdateAllButtons()
	TotemTimers_OrderTrackers()
end

function TotemTimers_ShowDebug()
	local text = ""
	text = text.."Settings:|n"
	for k,v in pairs(TotemTimers_Settings) do
		text = text..'  ["'..k..'"] = '
		if type(v) == "table" then
			text = text.." {|n"
			for i,j in pairs(v) do
				text = text..'    ["'..i..'"] = '..tostring(j).."|n"
			end
			text = text.."   }|n"
		else
			text = text..tostring(v)..string.char(13)
		end
	end
	text=text.."|n|n"
	
	for i=1,4 do
		text = text.."Button "..i..":|n"
		text = text.."type1: "..tostring(TotemTimers_Buttons[i]:GetAttribute("*type1")).."|n"
		text = text.."type2: "..tostring(TotemTimers_Buttons[i]:GetAttribute("*type2")).."|n"
		text = text.."newstate2: "..tostring(TotemTimers_Buttons[i]:GetAttribute("*newstate2")).."|n"
		text = text.."type3: "..tostring(TotemTimers_Buttons[i]:GetAttribute("*type3")).."|n"
		text = text.."newstate3: "..tostring(TotemTimers_Buttons[i]:GetAttribute("*newstate3")).."|n"
		text = text.."#spells: "..#TotemTimers_ActiveOrder[i].."|n|n"
	end
	TotemTimers_Debug:SetText(text)
	TotemTimers_Debug:HighlightText()
end