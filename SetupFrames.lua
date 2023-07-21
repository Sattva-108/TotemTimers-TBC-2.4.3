-- Copyright (c) 2006-2008 Xianghar
-- This code is not to be reproduced or modified without permission from author

TotemTimers_SpellIDs = {}
local SpellIDs = TotemTimers_SpellIDs
TotemTimers_Buttons = {}
for i=1,4 do TotemTimers_Buttons[i] = {} end

TotemTimers_ActiveOrder = {}
	
function TotemTimers_GetAvailableTotems() 

	TotemTimersTotems = {}
	for i=1,4 do TotemTimersTotems[i] = {} end

	local TotemTimers_SpellIDs = TotemTimers_SpellIDs
	for k,v in pairs(SpellIDs) do
		SpellIDs[k] = 0
	end
	SpellIDs[TT_REINCARNATION] = 0
	SpellIDs[TT_LIGHTNING_SHIELD] = 0
	TotemTimers_SpellIDs[TT_EARTH_SHIELD] = 0
	TotemTimers_SpellIDs[TT_ROCKBITER_WEAPON] = 0
	TotemTimers_SpellIDs[TT_WINDFURY_WEAPON] = 0
	TotemTimers_SpellIDs[TT_FLAMETONGUE_WEAPON] = 0
	TotemTimers_SpellIDs[TT_FROSTBRAND_WEAPON] = 0
	--TotemTimers_Debug:AddMessage("Found Totems:")
	TotemTimers_NumSpells = 0
	for i = 1, GetNumSpellTabs() do
		--TotemTimers_Debug:AddMessage("Getting Tab "..i)
		local name, _, offset, numSpells = GetSpellTabInfo(i);
		TotemTimers_NumSpells = TotemTimers_NumSpells + numSpells
		--if name then TotemTimers_Debug:AddMessage("Searching Tab "..i..": "..name) end
		for s = offset + 1, offset + numSpells do
			local spell = GetSpellName(s, BOOKTYPE_SPELL)
			if spell == TT_REINCARNATION or spell == TT_LIGHTNING_SHIELD or spell == TT_EARTH_SHIELD 
				or spell == TT_WINDFURY_WEAPON or spell == TT_ROCKBITER_WEAPON
				or spell == TT_FLAMETONGUE_WEAPON or spell == TT_FROSTBRAND_WEAPON
			then
				TotemTimers_SpellIDs[spell] = s
			else 
				for k,v in pairs(TotemData) do
					if spell == k then
						TotemTimers_SpellIDs[spell] = s
						if v.element then 
							--if not TotemTimersTotems[v.element][spell] then TotemTimers_Debug:AddMessage(spell) end
							TotemTimersTotems[v.element][spell] = true
						end
					end
				end
			end
		end
	end
	TotemTimers_CalcActiveOrder()
end

function TotemTimers_CalcActiveOrder()
	TotemTimers_ActiveOrder = {}
	for element = 1,4 do
		TotemTimers_ActiveOrder[element] = {}
		for _,spell in ipairs(TotemTimers_Order[element]) do
			if TotemTimersTotems[element][spell] and not TotemTimers_Settings["Hide"..spell] then
				table.insert(TotemTimers_ActiveOrder[element], spell)
			end
		end
		--TotemTimers_Debug:AddMessage("Active "..element.." totem order:")
		--for k,v in ipairs(TotemTimers_ActiveOrder[element]) do
			--TotemTimers_Debug:AddMessage(k.." "..v)
		--end
	end
end

function TotemTimers_ReprogramSlaveButtons()
	for element = 1,4 do
		local tcount = #TotemTimers_ActiveOrder[element]
		for i=1,#TotemTimers_ActiveOrder[element] do
			local btn = getglobal(element.."SlaveButton"..i)
			if btn == nil then
				btn = TotemTimers_CreateSlaveButton(i, tcount, element)
				TotemTimers_SetupElementStates(tcount, element)
			end
			btn:SetAttribute("spell1", TotemTimers_ActiveOrder[element][i])
			btn:SetAttribute("spell3", TotemTimers_ActiveOrder[element][i])
			btn.icon:SetTexture(GetSpellTexture(TotemTimers_ActiveOrder[element][i]))
			btn:SetAttribute("*newstate2", "*:"..i);
			btn:SetAttribute("*newstate3", "*:"..i);
			btn:SetAttribute("hidestates", "1-"..tcount)
			btn:SetAttribute("showstates", (tcount+1).."-"..(tcount*2));
			TotemTimers_Buttons[element]:SetAttribute("*spell-S"..i, TotemTimers_ActiveOrder[element][i])
			TotemTimers_Buttons[element]:SetAttribute("*spell-S"..(i+tcount), TotemTimers_ActiveOrder[element][i])
			TotemTimers_SetupElementStates(#TotemTimers_ActiveOrder[element], element)
		end
	end
	TotemTimers_UpdateSpellIcons()
end

function TotemTimers_DeactivateButtons()
	for element = 1,4 do
		TotemTimers_Buttons[element]:SetAttribute("*childstate-OnEnter", nil)
		TotemTimers_Buttons[element].spellIcon:Hide()
		getglobal(TotemTimers_Buttons[element]:GetName().."HotKey"):Hide()
	end	
end

function TotemTimers_ReactivateButtons() 
	for element=1,4 do
		if TotemTimers_Settings.MouseOver then TotemTimers_Buttons[element]:SetAttribute("*childstate-OnEnter", "enter") 
		end
		if TotemTimers_Settings.MiniIcons then TotemTimers_Buttons[element].spellIcon:Show() end
		getglobal(TotemTimers_Buttons[element]:GetName().."HotKey"):Show()
	end	
end

local PartyBuffRelatives = {["top"] = {"BOTTOMLEFT", "TOPLEFT", "LEFT", "RIGHT",2,0}, ["left"] = {"TOPRIGHT", "TOPLEFT", "TOP", "BOTTOM",0,-2},
                            ["bottom"] = {"TOPLEFT", "BOTTOMLEFT", "LEFT", "RIGHT",2,0}, ["right"] = {"TOPLEFT", "TOPRIGHT", "TOP", "BOTTOM",0,-2}}

local ButtonPositions = {
	["box"] = {{"CENTER",0,"CENTER"},{"LEFT",1,"RIGHT"},{"TOP",1,"BOTTOM"},{"LEFT",3,"RIGHT"}},
	["horizontal"] = {{"CENTER",0,"CENTER"},{"LEFT",1,"RIGHT"},{"LEFT",2,"RIGHT"},{"LEFT",3,"RIGHT"}},
	["vertical"] = {{"CENTER",0,"CENTER"},{"TOP",1,"BOTTOM"},{"TOP",2,"BOTTOM"},{"TOP",3,"BOTTOM"}}	
}

local SlaveButtonPositions = {
	["box"] = {
		{["left"] = {"RIGHT", "LEFT", "RIGHT", "LEFT"},["right"] = {"BOTTOM", "TOP", "LEFT", "RIGHT"}},
		{["left"] = {"BOTTOM", "TOP", "RIGHT", "LEFT"},["right"] = {"LEFT", "RIGHT", "LEFT", "RIGHT"}},
		{["left"] = {"RIGHT", "LEFT", "RIGHT", "LEFT"},["right"] = {"TOP", "BOTTOM", "LEFT", "RIGHT"}},
		{["left"] = {"TOP", "BOTTOM", "RIGHT", "LEFT"},["right"] = {"LEFT", "RIGHT", "LEFT", "RIGHT"}}
	},
	["horizontal"] = {
		{["up"] = {"BOTTOM", "TOP", "BOTTOM", "TOP"},["down"]={"TOP", "BOTTOM", "TOP", "BOTTOM"}},
		{["up"] = {"BOTTOM", "TOP", "BOTTOM", "TOP"},["down"]={"TOP", "BOTTOM", "TOP", "BOTTOM"}},
		{["up"] = {"BOTTOM", "TOP", "BOTTOM", "TOP"},["down"]={"TOP", "BOTTOM", "TOP", "BOTTOM"}},
		{["up"] = {"BOTTOM", "TOP", "BOTTOM", "TOP"},["down"]={"TOP", "BOTTOM", "TOP", "BOTTOM"}},
	},
	["vertical"] = {
		{["left"] = {"RIGHT", "LEFT", "RIGHT", "LEFT"},["right"]={"LEFT", "RIGHT", "LEFT", "RIGHT"}},
		{["left"] = {"RIGHT", "LEFT", "RIGHT", "LEFT"},["right"]={"LEFT", "RIGHT", "LEFT", "RIGHT"}},
		{["left"] = {"RIGHT", "LEFT", "RIGHT", "LEFT"},["right"]={"LEFT", "RIGHT", "LEFT", "RIGHT"}},
		{["left"] = {"RIGHT", "LEFT", "RIGHT", "LEFT"},["right"]={"LEFT", "RIGHT", "LEFT", "RIGHT"}},
	}
}

local timepositions = {
	["top"]    = {"BOTTOM", "TOP", 0, 1},
	["right"]  = {"LEFT", "RIGHT", 1, 0},
	["bottom"] = {"TOP", "BOTTOM", 0, -1},
	["left"]   = {"RIGHT", "LEFT", -1, 0},
}

local function ShowAddButton(button, spell, option)
	if option and SpellIDs[spell] and SpellIDs[spell]>0
	  and TotemTimers_Settings.Style~="buff" and TotemTimers_Settings.Style~="fixed" then 
		button:Show()
	else
		button:Hide()
	end
end

function TotemTimers_SetTimeFont(font)
	for i=1,4 do
		TotemTimers_Buttons[i].time:SetFont(font, TotemTimers_Settings.TimeHeight)
	end
	TotemTimers_AnkhTimerBarTime:SetFont(font, TotemTimers_Settings.TrackerTimeHeight)
	TotemTimers_ShieldTimerBarTime:SetFont(font, TotemTimers_Settings.TrackerTimeHeight)
	TotemTimers_EarthShieldTimerBarTime:SetFont(font, TotemTimers_Settings.TrackerTimeHeight)
	TotemTimers_MainHandTimerBarTime:SetFont(font, TotemTimers_Settings.TrackerTimeHeight)
	TotemTimers_MainHandTimerBar2Time:SetFont(font, TotemTimers_Settings.TrackerTimeHeight)
	TotemTimers_EarthElementalTime:SetFont(font, TotemTimers_Settings.TimeHeight-1)
	TotemTimers_FireElementalTime:SetFont(font, TotemTimers_Settings.TimeHeight-1)
	TotemTimers_ManaTideTime:SetFont(font, TotemTimers_Settings.TimeHeight-1)
end

function TotemTimers_ReorderElements()
	if not TotemTimers_Buttons or not TotemTimers_Settings.Show then return end
	local TotemTimers_Buttons = TotemTimers_Buttons
	if InCombatLockdown() then
		return
	end
	local lastbutton;
	TotemTimers_EarthElemental:SetScale(TotemTimers_Settings.TimerSize/32)
	TotemTimers_FireElemental:SetScale(TotemTimers_Settings.TimerSize/32)
	TotemTimers_ManaTide:SetScale(TotemTimers_Settings.TimerSize/32)
	TotemTimers_EarthElemental:ClearAllPoints()
	TotemTimers_FireElemental:ClearAllPoints()
	TotemTimers_ManaTide:ClearAllPoints()
	ShowAddButton(TotemTimers_EarthElemental, TT_EARTH_ELEMENTAL, TotemTimers_Settings.ShowEarthElementalButton)
	ShowAddButton(TotemTimers_FireElemental, TT_FIRE_ELEMENTAL, TotemTimers_Settings.ShowFireElementalButton)
	ShowAddButton(TotemTimers_ManaTide, TT_MANA_TIDE, TotemTimers_Settings.ShowManaTideButton)
	local font = TotemTimers_Settings.TimeFont
	TotemTimers_EarthElementalTime:SetFont(font, TotemTimers_Settings.TimeHeight-1, flags)
	TotemTimers_FireElementalTime:SetFont(font, TotemTimers_Settings.TimeHeight-1, flags)
	TotemTimers_ManaTideTime:SetFont(font, TotemTimers_Settings.TimeHeight-1, flags)
	TotemTimers_EarthElementalTime:SetHeight(TotemTimers_Settings.TimeHeight-1)
	TotemTimers_FireElementalTime:SetHeight(TotemTimers_Settings.TimeHeight-1)
	TotemTimers_ManaTideTime:SetHeight(TotemTimers_Settings.TimeHeight-1)
	for element=1,4 do
		TotemTimers_Buttons[element].header:ClearAllPoints()
		TotemTimers_Buttons[element].header:Hide()
		TotemTimers_Buttons[element]:SetScale(TotemTimers_Settings.TimerSize/32)
		TotemTimers_Buttons[element].header:SetScale(TotemTimers_Settings.TimerSize/32)
		TotemTimers_Buttons[element].timerBar:SetHeight(TotemTimers_Settings.TimeHeight)
		local font, height, flags = TotemTimers_Buttons[element].time:GetFont()
		TotemTimers_Buttons[element].time:SetFont(font,TotemTimers_Settings.TimeHeight,flags)
		TotemTimers_Buttons[element].time:SetHeight(TotemTimers_Settings.TimeHeight)
		for i = 1, #TotemTimers_ActiveOrder[element] do
			getglobal(element.."SlaveButton"..i):SetScale(TotemTimers_Settings.TimerSize/32)
		end
		for i=1,4 do
			TotemTimers_Buttons[element].party[i]:ClearAllPoints()
			if i == 1 then
				TotemTimers_Buttons[element].party[i]:SetPoint(PartyBuffRelatives[TotemTimers_Settings.PartyBuffSide][1],
				                                                          TotemTimers_Buttons[element],
				                                                          PartyBuffRelatives[TotemTimers_Settings.PartyBuffSide][2],
																		  PartyBuffRelatives[TotemTimers_Settings.PartyBuffSide][5],
																		  PartyBuffRelatives[TotemTimers_Settings.PartyBuffSide][6])
			else
				TotemTimers_Buttons[element].party[i]:SetPoint(PartyBuffRelatives[TotemTimers_Settings.PartyBuffSide][3],
				                                                          TotemTimers_Buttons[element].party[i-1],
				                                                          PartyBuffRelatives[TotemTimers_Settings.PartyBuffSide][4])
			end
		end		
	end
	local count = 1
	local timeheight = TotemTimers_Buttons[1]:GetEffectiveScale()*(TotemTimers_Settings.TimeHeight+2)+TotemTimers_Settings.TimeSpacing
	local timewidth = TotemTimers_Buttons[1]:GetEffectiveScale()*(TotemTimers_Buttons[1].timerBar:GetWidth()+2)+TotemTimers_Settings.TimeSpacing
	local dotheight = TotemTimers_Buttons[1]:GetEffectiveScale()*7
	local buttons = {}
	for i=1,4 do
		if #TotemTimers_ActiveOrder[TotemTimers_Settings.Order[i]]>0 
		 and TotemTimers_Settings["Visible"..i] then
			buttons[count]  = TotemTimers_Settings.Order[i]
			count = count + 1
		end
		TotemTimers_Buttons[i].timerBar:ClearAllPoints()
		TotemTimers_Buttons[i].timerBar:SetPoint(timepositions[TotemTimers_Settings.TimePos][1], TotemTimers_Buttons[i],
		                                         timepositions[TotemTimers_Settings.TimePos][2],
												 timepositions[TotemTimers_Settings.TimePos][3]*TotemTimers_Settings.TimeSpacing,
												 timepositions[TotemTimers_Settings.TimePos][4]*TotemTimers_Settings.TimeSpacing)
	end
	TotemTimers_EarthElementalTime:ClearAllPoints()
	TotemTimers_EarthElementalTime:SetPoint(timepositions[TotemTimers_Settings.TimePos][1], TotemTimers_EarthElemental,
											 timepositions[TotemTimers_Settings.TimePos][2],
											 timepositions[TotemTimers_Settings.TimePos][3]*TotemTimers_Settings.TimeSpacing,
											 timepositions[TotemTimers_Settings.TimePos][4]*TotemTimers_Settings.TimeSpacing)
	TotemTimers_FireElementalTime:ClearAllPoints()
	TotemTimers_FireElementalTime:SetPoint(timepositions[TotemTimers_Settings.TimePos][1], TotemTimers_FireElemental,
											 timepositions[TotemTimers_Settings.TimePos][2],
											 timepositions[TotemTimers_Settings.TimePos][3]*TotemTimers_Settings.TimeSpacing,
											 timepositions[TotemTimers_Settings.TimePos][4]*TotemTimers_Settings.TimeSpacing)
	TotemTimers_ManaTideTime:ClearAllPoints()
	TotemTimers_ManaTideTime:SetPoint(timepositions[TotemTimers_Settings.TimePos][1], TotemTimers_ManaTide,
											 timepositions[TotemTimers_Settings.TimePos][2],
											 timepositions[TotemTimers_Settings.TimePos][3]*TotemTimers_Settings.TimeSpacing,
											 timepositions[TotemTimers_Settings.TimePos][4]*TotemTimers_Settings.TimeSpacing)
	 count = 1
	local spacing = TotemTimers_Settings.Spacing
	local arr = TotemTimers_Settings.Arrange
	for e,v in pairs(buttons) do
		local x,y = 0,0
		if ButtonPositions[arr][count][1] == "TOP" then
			if TotemTimers_Settings.ShowPartyBuffs
			  and TotemTimers_Settings.PartyBuffSide == "top" or TotemTimers_Settings.PartyBuffSide == "bottom" then
				y = y-dotheight
			end
			y = y - spacing
			if TotemTimers_Settings.TimePos == "top" or TotemTimers_Settings.TimePos == "bottom" then
				y = y - timeheight 
			end
		end
		if ButtonPositions[arr][count][1] == "LEFT" then
			x = x+3*TotemTimers_Buttons[1]:GetEffectiveScale()
			if TotemTimers_Settings.ShowPartyBuffs
			  and TotemTimers_Settings.PartyBuffSide == "left" or TotemTimers_Settings.PartyBuffSide == "right" then
				x = x-dotheight
			end
			x = x + spacing
			if TotemTimers_Settings.TimePos == "left" or TotemTimers_Settings.TimePos == "right" then
				x = x + timewidth
			end
		end
		TotemTimers_Buttons[v].header:Show()
		if count == 1 then
			TotemTimers_Buttons[v].header:SetPoint(ButtonPositions[arr][count][1], TotemTimersFrame, ButtonPositions[arr][count][3])
		else
			TotemTimers_Buttons[v].header:SetPoint(ButtonPositions[arr][count][1], TotemTimers_Buttons[buttons[ButtonPositions[arr][count][2]]].header, ButtonPositions[arr][count][3],x,y)
		end
		local dir = TotemTimers_Settings.BarDirection
		if dir == "auto" then
			if TotemTimers_Settings.Arrange == "horizontal" then
				dir = "down"
				local bottom = TotemTimersFrame:GetBottom()
				if bottom and bottom<UIParent:GetHeight()/2 then dir = "up" end
			else
				dir = "left"
				local left = TotemTimersFrame:GetLeft()
				if left and left<UIParent:GetWidth()/2 then dir = "right" end
			end
		end
		for i = 1,#TotemTimers_ActiveOrder[v] do
			getglobal(v.."SlaveButton"..i):ClearAllPoints()
			if i==1 then
				local point = SlaveButtonPositions[arr][count][dir][1]
				getglobal(v.."SlaveButton"..i):SetPoint(SlaveButtonPositions[arr][count][dir][1], TotemTimers_Buttons[v], SlaveButtonPositions[arr][count][dir][2])
				local sx, sy = 0, 0
				if point == "LEFT" and TotemTimers_Settings.PartyBuffSide == "right" then
					sx = dotheight
				elseif point == "RIGHT" and TotemTimers_Settings.PartyBuffSide == "left" then
					sx = -dotheight
				elseif point == "TOP" and TotemTimers_Settings.PartyBuffSide == "bottom" then
					sy = -dotheight
				elseif point == "BOTTOM" and TotemTimers_Settings.PartyBuffSide == "top" then
					sy = dotheight
				end
				local stimewidth = TotemTimers_EarthElemental:GetWidth()*TotemTimers_EarthElemental:GetEffectiveScale()
				local stimeheight = TotemTimers_EarthElementalTime:GetHeight()*TotemTimers_EarthElemental:GetEffectiveScale()
				if point == "RIGHT" and TotemTimers_Settings.TimePos == "right" then sx = sx - stimewidth end
				if point == "LEFT" and TotemTimers_Settings.TimePos == "left" then sx = sx + stimewidth end
				if point == "TOP" and TotemTimers_Settings.TimePos == "top" then sy = sy - stimeheight end
				if point == "BOTTOM" and TotemTimers_Settings.TimePos == "bottom" then sy = sy + stimeheight end
				if point == "RIGHT" and TotemTimers_Settings.TimePos == "left" then sx = sx - timewidth end
				if point == "LEFT" and TotemTimers_Settings.TimePos == "right" then sx = sx + timewidth end
				if point == "TOP" and TotemTimers_Settings.TimePos == "bottom" then sy = sy - timeheight end
				if point == "BOTTOM" and TotemTimers_Settings.TimePos == "top" then sy = sy + timeheight end
				if v == EARTH_TOTEM_SLOT then
					TotemTimers_EarthElemental:SetPoint(SlaveButtonPositions[arr][count][dir][1], TotemTimers_Buttons[v], SlaveButtonPositions[arr][count][dir][2], sx, sy)
				elseif v == FIRE_TOTEM_SLOT then
					TotemTimers_FireElemental:SetPoint(SlaveButtonPositions[arr][count][dir][1], TotemTimers_Buttons[v], SlaveButtonPositions[arr][count][dir][2], sx, sy)
				elseif v == WATER_TOTEM_SLOT then
					TotemTimers_ManaTide:SetPoint(SlaveButtonPositions[arr][count][dir][1], TotemTimers_Buttons[v], SlaveButtonPositions[arr][count][dir][2], sx, sy)
				end
			else
				getglobal(v.."SlaveButton"..i):SetPoint(SlaveButtonPositions[arr][count][dir][3], getglobal(v.."SlaveButton"..(i-1)), SlaveButtonPositions[arr][count][dir][4])
			end
		end
		count = count + 1
	end
end

function TotemTimers_SetupElementCooldowns()
	for e=1,4 do
		if not TotemTimers_Settings.Recast or TotemTimers_Settings.Style == "fixed" or TotemTimers_Settings.Style == "buff" then
			TotemTimers_Buttons[e].cooldown:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
		else
			TotemTimers_Buttons[e].cooldown:RegisterEvent("SPELL_UPDATE_COOLDOWN")
		end
	end
end

function TotemTimers_ButtonSetup()
	TotemTimers_GetAvailableTotems()
	
	--TotemTimers_Buttons = {}
	local TotemTimers_Buttons = TotemTimers_Buttons

	for element = 1,4 do
		TotemTimers_Buttons[element] =  getglobal("TotemTimers"..element)
		TotemTimers_Buttons[element].icon = getglobal("TotemTimers"..element.."Icon")
		TotemTimers_Buttons[element].spellIcon = getglobal("TotemTimers"..element.."SpellIcon")
		TotemTimers_Buttons[element].time = getglobal("TotemTimers"..element.."TimerBarTime")

		TotemTimers_Buttons[element].party = {}
		for j = 1,4 do
			TotemTimers_Buttons[element].party[j] = getglobal(TotemTimers_Buttons[element]:GetName().."Party"..j)
			TotemTimers_Buttons[element].party[j]:Hide()
		end
		TotemTimers_Buttons[element].player = getglobal(TotemTimers_Buttons[element]:GetName().."PlayerBuff")
		TotemTimers_Buttons[element].player:SetVertexColor(1,0,0)
	
		TotemTimers_Buttons[element].header = CreateFrame("Frame", element.."StateHeader", UIParent, "SecureStateHeaderTemplate")
		TotemTimers_Buttons[element].header:SetAttribute("state", "1")
		TotemTimers_Buttons[element].header.StateChanged = function(self, s) TotemTimers_UpdateSingleSpellIcon(self, s) end
		TotemTimers_Buttons[element].header.element = element
		TotemTimers_Buttons[element].element = element
		TotemTimers_Buttons[element].header:SetWidth(32)
		TotemTimers_Buttons[element].header:SetHeight(32)
		TotemTimers_Buttons[element]:RegisterForDrag("LeftButton")
		TotemTimers_Buttons[element]:RegisterForClicks("LeftButtonDown" ,"RightButtonDown", "MiddleButtonDown")
		TotemTimers_Buttons[element].range = getglobal(TotemTimers_Buttons[element]:GetName().."Count")
		TotemTimers_Buttons[element].flash = getglobal(TotemTimers_Buttons[element]:GetName().."Flash")
		--TotemTimers_Buttons[element].procFlash = getglobal(TotemTimers_Buttons[element]:GetName().."ProcFlash")
		TotemTimers_Buttons[element].cooldown = getglobal(TotemTimers_Buttons[element]:GetName().."Cooldown")
		TotemTimers_Buttons[element].cooldown:RegisterEvent("SPELL_UPDATE_COOLDOWN")
		TotemTimers_Buttons[element].cooldown:SetScript("OnEvent", TotemTimers_ElementCooldown)
		TotemTimers_Buttons[element].hotkey = getglobal(TotemTimers_Buttons[element]:GetName().."HotKey")
		TotemTimers_Buttons[element].statusBar = getglobal(TotemTimers_Buttons[element]:GetName().."Bar")
		TotemTimers_Buttons[element].timerBar = getglobal(TotemTimers_Buttons[element]:GetName().."TimerBar")
		
		if not TTActiveTotems[element].spell then 
			TTActiveTotems[element].spell = TotemTimers_ActiveOrder[element][1]
			--DEFAULT_CHAT_FRAME:AddMessage("not")
		end
		
		hooksecurefunc(getmetatable(TotemTimers_Buttons[element]).__index, "SetAttribute", TotemTimers_ShowElementToolTip)


		TotemTimers_Buttons[element].spell = TotemTimersTotems[element][1]
		
		TotemTimers_Buttons[element]:SetPoint("CENTER", TotemTimers_Buttons[element].header, "CENTER")

		local states = ""
		local tcount = #TotemTimers_ActiveOrder[element]

		TotemTimers_SetupElementStates(#TotemTimers_ActiveOrder[element], element)

		--TotemTimers_Buttons[element].header:SetAttribute("state", "1")
		TotemTimers_Buttons[element].header:SetAttribute("addchild", TotemTimers_Buttons[element])

		TotemTimers_Buttons[element].icon:SetTexture(TotemTimersTotems[element][1])
		for i = 1, tcount do
			TotemTimers_CreateSlaveButton(i, tcount, element)
		end
	end
end


function TotemTimers_SetupElementStates(tcount, element)
	local states = ""
	for i = 1, tcount do
		states = states..i..","..(i+tcount)..":S"..i
		if i < tcount then states = states..";" end
	end
	TotemTimers_Buttons[element]:SetAttribute("statebutton1",states)
	TotemTimers_Buttons[element]:SetAttribute("*type*", "spell")
	for i=1,#TotemTimers_ActiveOrder[element] do
		if TotemTimers_Settings.FocusElementals 
			and (TotemTimers_ActiveOrder[element][i] == TT_FIRE_ELEMENTAL or TotemTimers_ActiveOrder[element][i] == TT_EARTH_ELEMENTAL) then
			TotemTimers_Buttons[element]:SetAttribute("*type-S"..i, "macro")
			if TotemTimers_ActiveOrder[element][i] == TT_FIRE_ELEMENTAL then
				TotemTimers_Buttons[element]:SetAttribute("*macrotext-S"..i, "/cast "..TotemTimers_ActiveOrder[element][i].."\n/target "..TT_FIRE_ELE.."\n/focus target\n/targetlasttarget")
				TotemTimers_FireElemental:SetAttribute("*type1", "macro")
				TotemTimers_FireElemental:SetAttribute("*macrotext1", "/cast "..TotemTimers_ActiveOrder[element][i].."\n/target "..TT_FIRE_ELE.."\n/focus target\n/targetlasttarget")
			else
				TotemTimers_Buttons[element]:SetAttribute("*macrotext-S"..i, "/cast "..TotemTimers_ActiveOrder[element][i].."\n/target "..TT_EARTH_ELE.."\n/focus target\n/targetlasttarget")
				TotemTimers_EarthElemental:SetAttribute("*type1", "macro")
				TotemTimers_EarthElemental:SetAttribute("*macrotext1", "/cast "..TotemTimers_ActiveOrder[element][i].."\n/target "..TT_EARTH_ELE.."\n/focus target\n/targetlasttarget")
			end
		else
			TotemTimers_Buttons[element]:SetAttribute("*spell-S"..i, TotemTimers_ActiveOrder[element][i])
			TotemTimers_Buttons[element]:SetAttribute("*spell-S"..(i+tcount), TotemTimers_ActiveOrder[element][i])
		end
	end

	--TotemTimers_Buttons[element]:SetAttribute("state", "1")
	TotemTimers_SetMouseOver(element)

	
	TotemTimers_Buttons[element]:SetAttribute("*childraise-OnEnter", true)
	--TotemTimers_Buttons[element]:SetAttribute("*childstate-OnEnter", "enter");
	TotemTimers_Buttons[element]:SetAttribute("*childstate-OnLeave", "leave")
	local enterstates = "";
	for i = 1, tcount do
		enterstates = enterstates..i..":"..(i+tcount)
		if i < tcount then enterstates = enterstates..";" end
	end
	TotemTimers_Buttons[element].header:SetAttribute("statemap-anchor-enter", enterstates)
	TotemTimers_Buttons[element].header:SetAttribute("statemap-anchor-leave", ";")
	local leavestates = ""
	for i = 1, tcount do
		leavestates = leavestates..(i+tcount)..":"..i
		if i < tcount then leavestates = leavestates..";" end
	end
	TotemTimers_Buttons[element].header:SetAttribute("delaystatemap-anchor-leave", leavestates)
	TotemTimers_Buttons[element].header:SetAttribute("delaytimemap-anchor-leave",  (tcount+1).."-"..(tcount*2)..":0.5")
	TotemTimers_Buttons[element].header:SetAttribute("delayhovermap-anchor-leave", (tcount+1).."-"..(tcount*2)..":true")
	TotemTimers_Buttons[element]:SetAttribute("anchorchild", TotemTimers_Buttons[element].header)
	
	TotemTimers_Buttons[element].header:SetAttribute("statebindings",(tcount+1).."-"..(tcount+tcount)..":vis;1-"..tcount..":novis");
end

function TotemTimers_SetMouseOver(element)
	local states = ""
	local tcount = #TotemTimers_ActiveOrder[element]
	for i = 1, tcount do
		states = states..i..":"..(i+tcount)..";"..(i+tcount)..":"..i
		if i < tcount then states = states..";" end
	end
	TotemTimers_States = states
	if not TotemTimers_Settings.MouseOver or TotemTimers_Settings.Style=="buff" or TotemTimers_Settings.Style=="fixed" then
		TotemTimers_Buttons[element]:SetAttribute("*newstate2", states)
		TotemTimers_Buttons[element]:SetAttribute("*spell2", ATTRIBUTE_NOOP)
		TotemTimers_Buttons[element]:SetAttribute("*type3", "macro")
		TotemTimers_Buttons[element]:SetAttribute("*macrotext3", "/script DestroyTotem("..element..")")		
		TotemTimers_Buttons[element]:SetAttribute("*newstate3", ";")
		TotemTimers_Buttons[element]:SetAttribute("*childstate-OnEnter", nil)
	else
		TotemTimers_Buttons[element]:SetAttribute("*type2", "macro")
		TotemTimers_Buttons[element]:SetAttribute("*macrotext2", "/script DestroyTotem("..element..")")
		TotemTimers_Buttons[element]:SetAttribute("*newstate2", ";")
		TotemTimers_Buttons[element]:SetAttribute("*newstate3", states)
		TotemTimers_Buttons[element]:SetAttribute("*spell3", ATTRIBUTE_NOOP)
		TotemTimers_Buttons[element]:SetAttribute("*childstate-OnEnter", "enter")
	end
end

function TotemTimers_CreateSlaveButton(i, tcount, element)
	local btn = CreateFrame("Button", element.."SlaveButton"..i, TotemTimers_Buttons[element].header, "TotemTimersTotemTemplate")
		
	if i == 1 then btn:SetPoint("LEFT", TotemTimers_Buttons[element], "RIGHT", 5, 0)
	else btn:SetPoint("LEFT", element.."SlaveButton"..(i-1), "RIGHT", 5, 0)
	end			

	btn:SetAttribute("*type1", "spell")
	btn:SetAttribute("spell1", TotemTimers_ActiveOrder[element][i])
	btn:SetAttribute("*type3", "spell")
	btn:SetAttribute("spell3", TotemTimers_ActiveOrder[element][i])
	btn.spell = TotemTimers_ActiveOrder[element][i]
	if btn.spell == TTActiveTotems[element].spell then
		TotemTimers_Buttons[element].header:SetAttribute("state", i)
	end
	btn:SetAttribute("*type2", "spell");
	btn:SetAttribute("*spell2", ATTRIBUTE_NOOP);
	btn:SetAttribute("*newstate2", "*:"..i);
	btn:SetAttribute("*newstate3", "*:"..i);
	local leftClickStates = ""
	for j = 1, tcount do
		leftClickStates = leftClickStates..(j+tcount)..":"..j;
		if j < tcount then leftClickStates = leftClickStates..";" end
	end
	btn:SetAttribute("*newstate1", leftClickStates);
	btn:SetAttribute("showstates", (tcount+1).."-"..(tcount*2));
	--btn:SetAttribute("state", 0);
	if TotemTimers_Settings.BarBindings then 
		if TotemTimers_Settings.ReverseBarBindings then
			btn:SetAttribute("bindings-vis",tostring(10-i))
			getglobal(btn:GetName().."HotKey"):SetText(tostring(10-i))
		else
			btn:SetAttribute("bindings-vis",tostring(i))
			getglobal(btn:GetName().."HotKey"):SetText(tostring(i))
		end
	end
	TotemTimers_Buttons[element].header:SetAttribute("addchild", btn)
	--btn.cooldown = getglobal(element.."SlaveButton"..i.."Cooldown")
	btn.icon = getglobal(element.."SlaveButton"..i.."Icon")
	btn.icon:SetTexture(GetSpellTexture(TotemTimers_ActiveOrder[element][i]))
	btn:RegisterForClicks("LeftButtonUp" ,"RightButtonUp", "MiddleButtonUp" );
	--btn:SetScript("PostClick", TotemTimers_UpdateSpellIcons)
	btn.cooldown = CreateFrame("Cooldown", btn:GetName().."Cooldown", btn, "CooldownFrameTemplate")
	btn.cooldown:SetAllPoints(btn)
	btn.cooldown:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	btn.cooldown:SetScript("OnEvent", TotemTimers_TotemCooldown)
	--btn:RegisterForDrag("LeftButton")
	btn:SetFrameStrata("HIGH")
	btn.element = element
	return btn
end

function TotemTimers_SetupTrackers()
	TotemTimers_ShieldIcon:SetAlpha(0.4)
	if SpellIDs[TT_LIGHTNING_SHIELD]>0 then TotemTimers_ShieldIcon:SetTexture(GetSpellTexture(TT_LIGHTNING_SHIELD)) end
	TotemTimers_EarthShieldIcon:SetAlpha(0.4)
	if SpellIDs[TT_EARTH_SHIELD]>0 then	TotemTimers_EarthShieldIcon:SetTexture(GetSpellTexture(TT_EARTH_SHIELD)) end
	
	TotemTimers_TrackerFrame:RegisterForDrag("LeftButton")
	TotemTimers_Shield:SetAttribute("*type*", "spell")
	--TotemTimers_Shield:SetAttribute("spell1", TT_LIGHTNING_SHIELD)
	--TotemTimers_Shield:SetAttribute("*type2", "spell")
	--TotemTimers_Shield:SetAttribute("spell2", TT_WATER_SHIELD)
	TotemTimers_Shield:RegisterForDrag("LeftButton")
	TotemTimers_Shield:RegisterForClicks("LeftButtonUp" ,"RightButtonUp", "MiddleButtonUp")
	TotemTimers_Shield:SetAttribute("*unit*", "player")
	TotemTimers_EarthShield:RegisterForDrag("LeftButton")
	TotemTimers_EarthShield:RegisterForClicks("LeftButtonUp","RightButtonUp", "MiddleButtonUp", "Button4Up")
	TotemTimers_EarthShield:SetAttribute("*type*", "spell")
	TotemTimers_EarthShield:SetAttribute("spell*", TT_EARTH_SHIELD)
	--TotemTimers_EarthShield:SetAttribute("*unit1", "focus")
	--TotemTimers_EarthShield:SetAttribute("*unit2", "target")
	--TotemTimers_EarthShield:SetAttribute("*unit3", "targettarget")
	--TotemTimers_EarthShield:SetAttribute("*unit4", "player")
	TotemTimers_MainHand:RegisterForClicks("LeftButtonUp" ,"RightButtonUp")
	TotemTimers_MainHand:RegisterForDrag("LeftButton")
	TotemTimers_MainHand:SetAttribute("*type*", "spell")
	TotemTimers_SetWeaponEnchants()
end

function TotemTimers_SetPointTracker(frame, relativeTo, distance)
	if TotemTimers_Settings.TrackerArrange == "free" then return end
	if relativeTo == TotemTimers_TrackerFrame then
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", relativeTo, "CENTER")
	else
		if TotemTimers_Settings.TrackerArrange == "horizontal" then
			local timewidth = 0
			if TotemTimers_Settings.TrackerTimePos == "left" or TotemTimers_Settings.TrackerTimePos == "right" then timewidth = TotemTimers_AnkhTimerBar:GetWidth()+TotemTimers_Settings.TrackerTimeSpacing end
			frame:ClearAllPoints()
			frame:SetPoint("LEFT", relativeTo, "RIGHT",
				(timewidth+TotemTimers_Settings.TrackerSpacing)*TotemTimers_Ankh:GetEffectiveScale(), 0)
		elseif TotemTimers_Settings.TrackerArrange == "vertical" then
			local timeheight = 0
			if TotemTimers_Settings.TrackerTimePos == "top" or TotemTimers_Settings.TrackerTimePos == "bottom" then
				timeheight = TotemTimers_Settings.TrackerTimeHeight+TotemTimers_Settings.TrackerTimeSpacing
				if frame:GetName() == "TotemTimers_MainHand" and select(4,GetTalentInfo(2,18))>0 then
					timeheight = timeheight + TotemTimers_Settings.TrackerTimeHeight
				end
			end
			frame:ClearAllPoints()
			frame:SetPoint("TOP", relativeTo, "BOTTOM", 0,
				-(timeheight+TotemTimers_Settings.TrackerSpacing)*TotemTimers_Ankh:GetEffectiveScale())
		end
	end
end

function TotemTimers_OrderTrackers()
	if not TotemTimers_IsSetUp then
		if not TotemTimers_OrderedTrackers then 
			TotemTimers_OrderedTrackers = true
		else
			return
		end
	end
	TotemTimers_Ankh:SetScale(TotemTimers_Settings.TrackerSize/30)
	for i=1,8 do
		local b = getglobal("TotemTimers_SetButton"..i)
		if b then b:SetScale((TotemTimers_Settings.TrackerSize-2)/28) end
	end
	local font, height, flags = TotemTimers_AnkhTimerBarTime:GetFont()
	TotemTimers_AnkhTimerBarTime:SetFont(font,TotemTimers_Settings.TrackerTimeHeight,flags)
	TotemTimers_AnkhTimerBarTime:SetHeight(TotemTimers_Settings.TrackerTimeHeight)
	TotemTimers_AnkhTimerBar:SetHeight(TotemTimers_Settings.TrackerTimeHeight)
	TotemTimers_AnkhTimerBar:ClearAllPoints()
	TotemTimers_AnkhTimerBar:SetPoint(timepositions[TotemTimers_Settings.TrackerTimePos][1], TotemTimers_Ankh,
											 timepositions[TotemTimers_Settings.TrackerTimePos][2],
											 timepositions[TotemTimers_Settings.TrackerTimePos][3]*TotemTimers_Settings.TrackerTimeSpacing,
											 timepositions[TotemTimers_Settings.TrackerTimePos][4]*TotemTimers_Settings.TrackerTimeSpacing)
											 
	TotemTimers_Shield:SetScale(TotemTimers_Settings.TrackerSize/30)
	TotemTimers_ShieldTimerBarTime:SetFont(font,TotemTimers_Settings.TrackerTimeHeight,flags)
	TotemTimers_ShieldTimerBarTime:SetHeight(TotemTimers_Settings.TrackerTimeHeight)
	TotemTimers_ShieldTimerBar:ClearAllPoints()
	TotemTimers_ShieldTimerBar:SetPoint(timepositions[TotemTimers_Settings.TrackerTimePos][1], TotemTimers_Shield,
											 timepositions[TotemTimers_Settings.TrackerTimePos][2],
											 timepositions[TotemTimers_Settings.TrackerTimePos][3]*TotemTimers_Settings.TrackerTimeSpacing,
											 timepositions[TotemTimers_Settings.TrackerTimePos][4]*TotemTimers_Settings.TrackerTimeSpacing)

	TotemTimers_EarthShield:SetScale(TotemTimers_Settings.TrackerSize/30)
	TotemTimers_EarthShieldTimerBarTime:SetFont(font,TotemTimers_Settings.TrackerTimeHeight,flags)
	TotemTimers_EarthShieldTimerBarTime:SetHeight(TotemTimers_Settings.TrackerTimeHeight)
	TotemTimers_EarthShieldTimerBar:ClearAllPoints()
	TotemTimers_EarthShieldTimerBar:SetPoint(timepositions[TotemTimers_Settings.TrackerTimePos][1], TotemTimers_EarthShield,
											 timepositions[TotemTimers_Settings.TrackerTimePos][2],
											 timepositions[TotemTimers_Settings.TrackerTimePos][3]*TotemTimers_Settings.TrackerTimeSpacing,
											 timepositions[TotemTimers_Settings.TrackerTimePos][4]*TotemTimers_Settings.TrackerTimeSpacing)

	TotemTimers_MainHand:SetScale(TotemTimers_Settings.TrackerSize/30)
	TotemTimers_MainHandTimerBarTime:SetFont(font,TotemTimers_Settings.TrackerTimeHeight,flags)
	TotemTimers_MainHandTimerBarTime:SetHeight(TotemTimers_Settings.TrackerTimeHeight)
	TotemTimers_MainHandTimerBar2Time:SetFont(font,TotemTimers_Settings.TrackerTimeHeight,flags)
	TotemTimers_MainHandTimerBar2Time:SetHeight(TotemTimers_Settings.TrackerTimeHeight)
	TotemTimers_MainHandTimerBar:ClearAllPoints()
	TotemTimers_MainHandTimerBar2:ClearAllPoints()
	local sy = 0
	if TotemTimers_Settings.TrackerTimePos == "left" or TotemTimers_Settings.TrackerTimePos == "right" and select(4,GetTalentInfo(2,18))>0 then sy = TotemTimers_Settings.TrackerTimeHeight/2 end
	TotemTimers_MainHandTimerBar:SetPoint(timepositions[TotemTimers_Settings.TrackerTimePos][1], TotemTimers_MainHand,
											 timepositions[TotemTimers_Settings.TrackerTimePos][2],
											 timepositions[TotemTimers_Settings.TrackerTimePos][3]*TotemTimers_Settings.TrackerTimeSpacing,
											 timepositions[TotemTimers_Settings.TrackerTimePos][4]*TotemTimers_Settings.TrackerTimeSpacing+sy)
	if TotemTimers_Settings.TrackerTimePos == "top" then
		TotemTimers_MainHandTimerBar2:SetPoint("BOTTOM", TotemTimers_MainHandTimerBar, "TOP")
	else
		TotemTimers_MainHandTimerBar2:SetPoint("TOP", TotemTimers_MainHandTimerBar, "BOTTOM")
	end
	
	TotemTimers_TrackerFrame:Show()
 	
	local relativeTo = TotemTimers_TrackerFrame
	local dist = 0
	if TotemTimers_Settings.Reincarnation and TotemTimers_Settings.Show and SpellIDs[TT_REINCARNATION]>0 then 
		TotemTimers_Ankh:Show()
		TotemTimers_SetPointTracker(TotemTimers_Ankh, relativeTo)
		relativeTo = TotemTimers_Ankh
		--[[if TotemTimers_Settings.TrackerArrange == "vertical" then
			dist = -TotemTimers_Settings.TrackerTimeHeight-5*TotemTimers_Settings.TrackerSize/30
		end]]
	else
		TotemTimers_Ankh:Hide()
	end
	if TotemTimers_Settings.ShieldTracker and TotemTimers_Settings.Show and SpellIDs[TT_LIGHTNING_SHIELD]>0 then
		if not TotemTimers_Shield:IsVisible() then TotemTimers_Shield:Show() end
		TotemTimers_SetPointTracker(TotemTimers_Shield, relativeTo)
		relativeTo = TotemTimers_Shield
		--[[if TotemTimers_Settings.TrackerArrange == "vertical" then
			dist = -TotemTimers_Settings.TrackerTimeHeight-5*TotemTimers_Settings.TrackerSize/30
		end]]
	else
		TotemTimers_Shield:Hide()
	end
	if TotemTimers_Settings.EarthShieldTracker and TotemTimers_Settings.Show and SpellIDs[TT_EARTH_SHIELD]>0 then
		if not TotemTimers_EarthShield:IsVisible() then TotemTimers_EarthShield:Show() end
		TotemTimers_SetPointTracker(TotemTimers_EarthShield, relativeTo)
		relativeTo = TotemTimers_EarthShield
		--dist = -5
	else
		TotemTimers_EarthShield:Hide()
	end
	if TotemTimers_Settings.MainEnchant and TotemTimers_Settings.Show and SpellIDs[TT_ROCKBITER_WEAPON]>0 then
		if not TotemTimers_MainHand:IsVisible() then TotemTimers_MainHand:Show() end
		TotemTimers_SetPointTracker(TotemTimers_MainHand, relativeTo)
	else
		TotemTimers_MainHand:Hide()
	end
	local name,_,_,_,rank = GetTalentInfo(2,18)
	if name == nil then TotemTimers_ReorderTrackers = true end
	if rank and rank > 0 then
		TotemTimers_MainHandIcon:SetTexCoordModifiesRect(1)
		TotemTimers_MainHandIcon:SetTexCoord(0,0.5,0,1)
		TotemTimers_MainHandIcon2:SetTexCoord(0.5,1,0,1)
		TotemTimers_MainHandIcon2Frame:Show()
	else
		TotemTimers_MainHandIcon:SetTexCoordModifiesRect(1)
		TotemTimers_MainHandIcon:SetTexCoord(0,1,0,1)
		TotemTimers_MainHandIcon2Frame:Hide()
	end
	if relativeTo == TotemTimers_TrackerFrame then
		TotemTimers_TrackerFrame:Hide()
	end	
end

function TotemTimers_SetWeaponEnchants()
	TotemTimers_MainHand:SetAttribute("*spell1", TotemTimers_Settings.MainEnchant1)
	TotemTimers_MainHand:SetAttribute("*spell2", TotemTimers_Settings.MainEnchant2)
	TotemTimers_MainHand:SetAttribute(TotemTimers_Settings.WeaponBuffModifier.."-spell1", TotemTimers_Settings.ShiftMainEnchant1)
	TotemTimers_MainHand:SetAttribute(TotemTimers_Settings.WeaponBuffModifier.."-spell2", TotemTimers_Settings.ShiftMainEnchant2)
end
