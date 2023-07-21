-- Copyright (c) 2007 Xianghar
-- This code is not to be reproduced or modified without permission from author

local SpellIDs = TotemTimers_SpellIDs
local TotemData = TotemData
local TimerButtons = TotemTimers_Buttons
local dragElement = nil
local dragButton = nil
local dropButton = nil

function TotemTimers_FormatTime(frame, sec, blizz)
	local seconds = floor(sec)
	local text;

 	if( TotemTimers_Settings.Time == "blizz" or blizz) then
		frame:SetFormattedText(SecondsToTimeAbbrev(sec))
	else
		if(seconds <= 0) then
			frame:SetText("")
		elseif seconds < 600 then
			local d, h, m, s = ChatFrame_TimeBreakDown(seconds);
			frame:SetFormattedText("%01d:%02d", m, s)
		elseif(seconds < 3600) then
			local d, h, m, s = ChatFrame_TimeBreakDown(seconds);
			frame:SetFormattedText("%02d:%02d", m, s)
		else
			frame:SetText("1 hr+")
		end
	end

  return text;
end

local FormatTime = TotemTimers_FormatTime

local function UpdateCooldown(frame, spell, option)
	if SpellIDs[spell] and SpellIDs[spell]>0 and option then
		local start, duration, enable = GetSpellCooldown(spell)
		local cooldown = start+duration-GetTime()
		if cooldown > 2 or (cooldown > 0 and frame.cooldowntime and frame.cooldowntime > 0) then
			frame:Show()
			FormatTime(frame, start+duration-GetTime(), true)
			frame.cooldowntime = cooldown
		else
			frame:Hide()
			frame.cooldowntime = 0
		end
	end
end

function TotemTimers_UpdateTimers(arg1)
	for element = 1,4 do
		TotemTimerElement_OnUpdate(TimerButtons[element], arg1)
	end
	UpdateCooldown(TotemTimers_EarthElementalTime, TT_EARTH_ELEMENTAL, TotemTimers_Settings.ShowEarthElementalButton)
	UpdateCooldown(TotemTimers_FireElementalTime, TT_FIRE_ELEMENTAL, TotemTimers_Settings.ShowFireElementalButton)
	UpdateCooldown(TotemTimers_ManaTideTime, TT_MANA_TIDE, TotemTimers_Settings.ShowManaTideButton)
end

function TotemTimerElement_OnUpdate(self, arg1)
	self.flash:Hide()
	if self.element then
		if self.spell then 
			local _,nomana = IsUsableSpell(self.spell)
			if nomana then
				self.spellIcon:SetVertexColor(0.5,0.5,1.0)
			else
				self.spellIcon:SetVertexColor(1.0,1.0,1.0)
			end
		end
		self.icon:SetVertexColor(1.0,1.0,1.0)
		local data = TTActiveTotems[self.element];
		if data and data.active then
			data.duration = data.duration - arg1
			FormatTime(self.time, data.duration)
			if data.warningTime  then
				if data.duration <= data.warningTime and data.duration>0 then
					data.warningTime = nil;
					TotemTimers_Warning("ExpirationWarning", data.totem);
				end
			end
			if data.duration <= 60 then
				self.time:SetTextColor(1.0,1.0,1.0)
			else
				self.time:SetTextColor(1.0,.8,0)
			end
			if TotemTimers_Settings.ProcFlash and TotemData[data.totem].flashInterval and data.duration then
				local delay = TotemData[data.totem].flashDelay or 0
				self.statusBar:SetValue(mod(data.maxduration-data.duration+delay+1,TotemData[data.totem].flashInterval))
			end
			if self.element == AIR_TOTEM_SLOT and TotemTimers_Settings.TotemTwisting and data.twisting and data.twisting >= 0 then
				data.twisting = data.twisting - arg1
				if data.totem == TT_WINDFURY then
					if data.twisting <= 4 then data.twisting = 5 + data.twisting end
				end
				self.statusBar:SetMinMaxValues(0,9)
				self.statusBar:SetValue(9-data.twisting, 9)
				self.statusBar:Show()
				if data.twisting <= 0 then self.statusBar:Hide() end
			end
			if TotemTimers_Settings.ShowBar then self.timerBar:SetValue(data.duration) end
			if data.duration <= TotemTimers_Settings.Flash then
				if TotemTimers_Settings.FlashRed then
					self.flash:Show()
					self.flash:SetAlpha(BuffFrame.BuffAlphaValue)
				else
					self.icon:SetAlpha(BuffFrame.BuffAlphaValue)
				end
			end
		end
	end
end

-- Copyright (c) 2007 Xianghar
-- The following code is not to be reproduced or modified without permission from author

function TotemTimers_UpdateSingleSpellIcon(frame, state)
	local s = tonumber(state)
	local element = frame.element
	if s and not TotemTimers_ActiveOrder[element][s] then
		s = s - #TotemTimers_ActiveOrder[element]
	end	
	if TotemTimers_ActiveOrder[element][s] then
		TimerButtons[element].spellIcon:SetTexture(GetSpellTexture(TotemTimers_ActiveOrder[element][s]))
		TimerButtons[element].spell = TotemTimers_ActiveOrder[element][s]
		if TimerButtons[element].spell then
			local start, duration, enable = GetSpellCooldown(TotemTimers_Buttons[element].spell)
			CooldownFrame_SetTimer(TimerButtons[element].cooldown, start, duration, enable)
		end
		TTActiveTotems[element].spell = TotemTimers_ActiveOrder[element][s]
	end
	TotemTimers_UpdateMacro()
end

function TotemTimers_UpdateSpellIcons()
	for element = 1,4 do
		if TimerButtons[element]:IsVisible() then
			local state = TimerButtons[element].header:GetAttribute("state")
			state = tonumber(state)
			if state and not TotemTimers_ActiveOrder[element][tonumber(state)] then
				state = state - #TotemTimers_ActiveOrder[element]
			end
			if TotemTimers_ActiveOrder[element][tonumber(state)] then
				TimerButtons[element].spellIcon:SetTexture(GetSpellTexture(TotemTimers_ActiveOrder[element][tonumber(state)]))
				TimerButtons[element].spell = TotemTimers_ActiveOrder[element][tonumber(state)]
				if TimerButtons[element].spell then
					local start, duration, enable = GetSpellCooldown(TotemTimers_Buttons[element].spell)
					CooldownFrame_SetTimer(TimerButtons[element].cooldown, start, duration, enable)
				end
				TTActiveTotems[element].spell = TotemTimers_ActiveOrder[element][tonumber(state)]
			end
		end
	end
	TotemTimers_UpdateMacro()
end


function TotemTimers_TotemCooldown()
	local spell = this:GetParent():GetAttribute("spell1")
	if spell and TotemTimers_SpellIDs[spell] and TotemTimers_SpellIDs[spell]>0 then
		local start, duration, enable = GetSpellCooldown(this:GetParent():GetAttribute("spell1"))
		CooldownFrame_SetTimer(this, start, duration, enable)
	end
end

function TotemTimers_ElementCooldown()
	--if not TotemTimers_Settings.Recast then return end
	local spell = this:GetParent().spell
	if spell then
		local start, duration, enable = GetSpellCooldown(spell)
		CooldownFrame_SetTimer(this, start, duration, enable)
	end
end

function TotemTimers_ShowElementToolTip(self, attribute, value)
	if attribute ~= "_entered" then return end
	if not value then
		GameTooltip:Hide()
		return
	end
	if TotemTimers_Settings.Tooltips and TotemTimers_Settings.Recast and self.spell then
		local spellId = SpellIDs[self.spell]
		if not spellId then
			--TotemTimers_Debug:AddMessage("ShowElementToolTip: No SpellID")
			return
		end
		if GetSpellName(spellId, BOOKTYPE_SPELL) == self.spell then
			local left = self:GetLeft()
			if left<UIParent:GetWidth()/2 then
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			else			
				GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			end
			GameTooltip:SetSpell(spellId, BOOKTYPE_SPELL)
		end
	end
end

function TotemTimers_ShowTotemToolTip(show)
	if not show then
		GameTooltip:Hide()
		return
	end
	if TotemTimers_Settings.Tooltips and TotemTimers_Settings.Recast then
		local spell = this:GetAttribute("spell1")
		if spell then
			local spellId = SpellIDs[this:GetAttribute("spell1")]
			if not spellId then
				--TotemTimers_Debug:AddMessage("ShowTotemToolTip: No Spell")
				return
			end
			if GetSpellName(spellId, BOOKTYPE_SPELL) == this:GetAttribute("spell1") then
				local left = this:GetLeft()
				if left<UIParent:GetWidth()/2 then
					GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
				else			
					GameTooltip:SetOwner(this, "ANCHOR_LEFT")
				end
				GameTooltip:SetSpell(spellId, BOOKTYPE_SPELL)
			end
		end
	end
end


function TotemTimerElement_OnDragStart()
	if not TotemTimers_Settings.Lock and not InCombatLockdown() then
		TotemTimersFrame:StartMoving()
	end
end

function TotemTimerElement_OnDragStop()
	TotemTimersFrame:StopMovingOrSizing()
	TotemTimers_ReorderElements()
end


function TotemTimers_UpdatePartyIcons()
	for i=1,4 do
		for e =1,4 do
			TimerButtons[e].party[i]:Hide()
			if UnitExists("party"..i) then
				local _,class = UnitClass("party"..i)
				if class then TimerButtons[e].party[i]:SetVertexColor(RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b) end
			end
		end
		local finished = false
		local count = 0
		while not finished do
			count = count +1
			name = UnitBuff("party"..i,count)
			if name then
				local element = TotemDataEffects[name]
				if element and TTActiveTotems[element].active then
					if TotemTimers_Settings.Style == "buff" then
						for e = 1,4 do
							if TimerButtons[e].element == element then
								TimerButtons[e].party[i]:Show()
							end
						end
					else
						TimerButtons[element].party[i]:Show()
					end
				end
			else
				finished = true
			end
		end
	end
end

function TotemTimers_UpdatePlayerIcon()
	local finished = false
	local count = 0
	for e =1,4 do
		TimerButtons[e].player:Hide()
	end
	while not finished do
		count = count +1
		name = UnitBuff("player",count)
		if name then
			local element = TotemDataEffects[name]
			if element and TTActiveTotems[element].active then
				if TotemTimers_Settings.Style == "buff" then
					for e=1,4 do
						if TimerButtons[e].element == element then
							TimerButtons[e].player:Show()
						end
					end
				else
					TimerButtons[element].player:Show()
				end
			end
		else
			finished = true
		end
	end
end
