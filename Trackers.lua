local SpellIDs = TotemTimers_SpellIDs
local FormatTime = TotemTimers_FormatTime
local shieldName = ""
local shieldIndex = 0
local shieldActive = false
local earthShieldActive = false
local weaponLActive = false
local weaponRActive = false
local earthShieldName = nil
local earthShieldCount = 0
local earthShieldTime = -1
local playerName = UnitName("player")
local Ankh = TotemTimers_Ankh
local AnkhTimerBar = TotemTimers_AnkhTimerBar
local AnkhTime = TotemTimers_AnkhTimerBarTime
local AnkhCooldown = TotemTimers_AnkhCooldown
local Shield = TotemTimers_Shield
local ShieldTimerBar = TotemTimers_ShieldTimerBar
local ShieldTime = TotemTimers_ShieldTimerBarTime
local ShieldCooldown = TotemTimers_ShieldCooldown
local ShieldIcon = TotemTimers_ShieldIcon
local ShieldCount = TotemTimers_ShieldCount
local ShieldFlash = TotemTimers_ShieldFlash
local EarthShield = TotemTimers_EarthShield
local EarthShieldTimerBar = TotemTimers_EarthShieldTimerBar
local EarthShieldTime = TotemTimers_EarthShieldTimerBarTime
local EarthShieldCooldown = TotemTimers_EarthShieldCooldown
local EarthShieldCount = TotemTimers_EarthShieldCount
local EarthShieldIcon = TotemTimers_EarthShieldIcon
local EarthShieldFlash = TotemTimers_EarthShieldFlash
local MainHand = TotemTimers_MainHand
local MainHandTimerBar = TotemTimers_MainHandTimerBar
local MainHandTimerBar2 = TotemTimers_MainHandTimerBar2
local MainHandTime = TotemTimers_MainHandTimerBarTime
local MainHandTime2 = TotemTimers_MainHandTimerBar2Time
local MainHandCooldown = TotemTimers_MainHandCooldown
local MainHandIcon = TotemTimers_MainHandIcon
local MainHandIcon2 = TotemTimers_MainHandIcon2
local MainHandFlash = TotemTimers_MainHandFlash



local timerBarBackdrop = {
	bgFile="Interface/Tooltips/UI-Tooltip-Background",
	edgeFile="Interface/Tooltips/UI-Tooltip-Border",
	tile="true",
	tileSize=16,
	edgeSize=1,
}

local function HideTimerBar(frame)
	frame:SetValue(0)
	frame:SetBackdrop({})
end

local function ShowTimerBar(frame)
	frame:SetBackdrop(timerBarBackdrop)
end

local function TotemTimers_TrackerFlash(flash, time)
	if flash.flashDuration and flash.flashDuration > 0 then
		flash.flashDuration = flash.flashDuration - time
		flash:Show()
		flash:SetAlpha(BuffFrame.BuffAlphaValue)
		if flash.flashDuration < 0 then
			flash:Hide()
		end
	end
end

local ankhDuration = 0
 
local function Ankh_OnUpdate(time) 
	local start, duration, enable = GetSpellCooldown(TT_REINCARNATION)
	if duration ~= 0 then
		ankhDuration = start+duration-floor(GetTime())
		TotemTimers_FormatTime(AnkhTime,ankhDuration, true)
		if TotemTimers_Settings.ShowBar then
			AnkhTimerBar:SetValue(ankhDuration)
		end
	elseif ankhDuration>0 then
		AnkhTime:SetText("")
		HideTimerBar(AnkhTimerBar)
		ankhDuration = 0
	end
	if AnkhCooldown.textFrame then
		AnkhCooldown.textFrame:Hide()
	end
end

function TotemTimers_Ankh_OnEvent(frame, event)
	if event=="BAG_UPDATE" then
		local ankhs = GetItemCount(17030)
		TotemTimers_AnkhCount:SetText(ankhs)
		if ankhs == 0 then
			TotemTimers_AnkhIcon:SetVertexColor(0.5,0.5,1.0)
		else
			TotemTimers_AnkhIcon:SetVertexColor(1.0,1.0,1.0)
		end
	else
		local start, duration, enable = GetSpellCooldown(TT_REINCARNATION)
		CooldownFrame_SetTimer(TotemTimers_AnkhCooldown, start, duration, enable)
		if duration == 0 then
			TotemTimers_AnkhTimerBarTime:SetText("")
			HideTimerBar(AnkhTimerBar)
		else
			TotemTimers_FormatTime(TotemTimers_AnkhTimerBarTime,start+duration-floor(GetTime()), true)
			if TotemTimers_Settings.ShowBar then
				ShowTimerBar(AnkhTimerBar)
			end
		end
	end
end

function TotemTimers_ShieldOnEvent(frame, event, arg1, arg2)
	if event=="UNIT_SPELLCAST_SUCCEEDED" then
		local start, duration, enable = GetSpellCooldown(TT_LIGHTNING_SHIELD)
		CooldownFrame_SetTimer(ShieldCooldown, start, duration, enable)
	else
		shieldIndex = 0
		ShieldCount:SetText("")
		ShieldTime:SetText("")
		HideTimerBar(ShieldTimerBar)
		ShieldIcon:SetAlpha(0.4)
		for i=0,31 do
			local n = GetPlayerBuffName(i)
			if n == TT_LIGHTNING_SHIELD or n == TT_WATER_SHIELD or n == TT_EARTH_SHIELD then
				shieldIndex = GetPlayerBuff(i,"HELPFUL|HARMFUL|PASSIVE")
				shieldName = n
				ShieldIcon:SetTexture(GetPlayerBuffTexture(i))
				ShieldIcon:SetAlpha(1)
				if GetPlayerBuffTimeLeft(shieldIndex)>0 then
					FormatTime(ShieldTime, GetPlayerBuffTimeLeft(shieldIndex), true)
					if TotemTimers_Settings.ShowBar then ShowTimerBar(ShieldTimerBar) end
				end
				ShieldCount:SetText(GetPlayerBuffApplications(shieldIndex))
				shieldActive = true
			end
		end
		if shieldIndex == 0 and shieldActive then
			ShieldFlash.flashDuration = 5
			TotemTimers_Warning("ShieldNotification", shieldName)
			shieldActive = false
		end
	end        
end

local function Shield_OnUpdate(time)
	if shieldIndex > 0 then
		if GetPlayerBuffTimeLeft(shieldIndex) > 0 then
			local timeleft = GetPlayerBuffTimeLeft(shieldIndex)
			FormatTime(ShieldTime,timeleft, true)
			if TotemTimers_Settings.ShowBar then
				ShieldTimerBar:SetValue(timeleft)
			end
		end
	end
	TotemTimers_TrackerFlash(ShieldFlash, arg1)
end

function TotemTimers_GetEarthShieldCount(unit)
	local finished = false
	local count = 0
	while not finished do
		count = count+1
		local bn,_,_,ba = UnitBuff(unit, count, 1)
		if not bn then finished = true
		else
			if bn == TT_EARTH_SHIELD then return ba end
		end		
	end
	return 0
end

function TotemTimers_EarthShield_OnEvent(frame, event, arg1, arg2, arg3, arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" and arg2=="SPELL_CAST_SUCCESS" and arg10 == TT_EARTH_SHIELD then
		if arg4==playerName then
			local cd = getglobal("TotemTimers_EarthShieldCooldown")
			if cd then
				local start, duration, enable = GetSpellCooldown(TT_EARTH_SHIELD)
				if start and duration and enable then
					CooldownFrame_SetTimer(cd, start, duration, enable)
				end
			end
			earthShieldName = arg7
		end
		if arg7 == earthShieldName then
			earthShieldActive = true
			earthShieldTime = 600
		end
	elseif event == "UNIT_AURA" then
		if earthShieldName and UnitName(arg1) == earthShieldName then
			local c = TotemTimers_GetEarthShieldCount(arg1)
			if c == 0 then
				TotemTimers_EarthShieldIcon:SetAlpha(0.4)
				earthShieldTime = 0
			else
				if TotemTimers_Settings.ShowBar then ShowTimerBar(EarthShieldTimerBar) end
				TotemTimers_EarthShieldIcon:SetAlpha(1)
				if c == 6 and earthShieldCount<6 then
					earthShieldActive = true
					earthShieldTime = 600
				end
			end
			earthShieldCount = c
			EarthShieldCount:SetText(c)
		end
	end
end

function TotemTimers_EarthShield_OnUpdate(self, time)
	if earthShieldActive then
		FormatTime(EarthShieldTime,earthShieldTime, true)
		if TotemTimers_Settings.ShowBar then
			EarthShieldTimerBar:SetValue(earthShieldTime)
		end
		earthShieldTime = earthShieldTime - time
		if earthShieldTime <=5 then 
			EarthShieldFlash.flashDuration = 5
		end
		if earthShieldTime <= 0 then
			earthShieldActive = false
			TotemTimers_Warning("EarthShieldNotification", TT_EARTH_SHIELD)
			EarthShieldTime:SetText("")
			HideTimerBar(EarthShieldTimerBar)
		end
	end	
	TotemTimers_TrackerFlash(EarthShieldFlash, time)
end

local mainHandWeapon = 0
local lastMhWeapon = 0
local mainEnchant = {}
local offHandWeapon = 0
local lastOhWeapon = 0
local offEnchant = {}

local function getWeapons()
	mainHandWeapon = GetInventoryItemLink("player", 16)
	offHandWeapon = GetInventoryItemLink("player", 17)
	if mainHandWeapon then  mainHandWeapon = tonumber(select(3,string.find(mainHandWeapon, "item:(%d+):"))) end
	if offHandWeapon then offHandWeapon = tonumber(select(3,string.find(offHandWeapon, "item:(%d+):"))) end
	if TotemTimers_Settings.LastMainEnchants[mainHandWeapon] then
		mainEnchant = TotemTimers_Settings.LastMainEnchants[mainHandWeapon]
		MainHandIcon:SetTexture(mainEnchant[2])
	end
	MainHandIcon:SetAlpha(0.4)
	if TotemTimers_Settings.LastOffEnchants[offHandWeapon] then
		offEnchant = TotemTimers_Settings.LastOffEnchants[offHandWeapon]
		MainHandIcon2:SetTexture(offEnchant[2])
	end
	MainHandIcon2:SetAlpha(0.4)
end

local wait = 0

local function MainHand_OnUpdate(arg1)
	local enchant, expiration,_,oenchant, oexpiration = GetWeaponEnchantInfo()
	if enchant then
		if mainEnchant[3] == 0 then
			--the new weapon enchantment is active in getweaponenchantinfo about a half second after the event so we wait a second to determine the maximum duration
			wait = wait + arg1
			if wait >= 1 then
				mainEnchant[3] = expiration/1000
				wait = 0
			end
		end
		FormatTime(MainHandTime, expiration/1000,true)
		if TotemTimers_Settings.ShowBar and mainEnchant[3] then
			ShowTimerBar(MainHandTimerBar)
			MainHandTimerBar:SetMinMaxValues(0, mainEnchant[3])
			MainHandTimerBar:SetValue(expiration/1000)
			--DEFAULT_CHAT_FRAME:AddMessage((expiration/1000).."   "..mainEnchant[3])
		end
		if (expiration/1000 < BUFF_WARNING_TIME) then
			MainHandIcon:SetAlpha(BuffFrame.BuffAlphaValue)
		else
			MainHandIcon:SetAlpha(1.0);
		end
	elseif weaponLActive then
		MainHandTime:SetText("")
		HideTimerBar(MainHandTimerBar)
		TotemTimers_MainHandIcon:SetAlpha(0.4)
		if mainHandWeapon == lastMhWeapon then
			MainHandFlash.flashDuration = 5
			TotemTimers_Warning("WeaponNotification", "MH: "..tostring(mainEnchant[1]))
		end
	end
	weaponLActive = enchant
	if oenchant then
		if offEnchant[3] == 0 then
			wait = wait + arg1
			if wait >= 1 then
				offEnchant[3] = oexpiration/1000
				wait = 0
			end		
		end
		FormatTime(MainHandTime2, oexpiration/1000,true)
		if TotemTimers_Settings.ShowBar and offEnchant[3] then
			ShowTimerBar(MainHandTimerBar2)
			MainHandTimerBar2:SetMinMaxValues(0, offEnchant[3])
			MainHandTimerBar2:SetValue(oexpiration/1000)
		end
		if (mainHandExpiration and mainHandExpiration < BUFF_WARNING_TIME) then
			MainHandIcon2:SetAlpha(BuffFrame.BuffAlphaValue)
		else
			MainHandIcon2:SetAlpha(1.0);
		end
		weaponRActive = true
	elseif weaponRActive then
		MainHandTime2:SetText("")
		HideTimerBar(MainHandTimerBar2)
		MainHandIcon2:SetAlpha(0.4)
		if offHandWeapon == lastOhWeapon then
			MainHandFlash.flashDuration = 5
			TotemTimers_Warning("WeaponNotification", "OH: "..tostring(offEnchant[1]))
		end
	end
	weaponRActive = oenchant
	local start, duration, enable = GetSpellCooldown(TT_ROCKBITER_WEAPON)
    CooldownFrame_SetTimer(TotemTimers_MainHandCooldown, start, duration, enable)
    TotemTimers_TrackerFlash(MainHandFlash, arg1)
	lastOhWeapon = offHandWeapon
	lastMhWeapon = mainHandWeapon
end


function TotemTimers_MainHandOnEvent(event, arg1, arg2, a3, a4, a5, a6, a7, a8, a9, a10, a11)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" and arg2 == "ENCHANT_APPLIED" and a7==playerName and a9 then
		local enchant = string.gsub(a9, " %d+$", "")
		local texture = nil
		if TT_COMBATLOG_TO_SPELL[enchant] then
			texture = GetSpellTexture(TT_COMBATLOG_TO_SPELL[enchant])
		else
			texture = select(10,GetItemInfo(a9))
			if not texture then texture = select(10,GetItemInfo(a10)) end
		end
		local weapon = nil
		if a10 and a10 == mainHandWeapon then
			TotemTimers_Settings.LastMainEnchants[mainHandWeapon] = {enchant, texture, 0}
			mainEnchant = TotemTimers_Settings.LastMainEnchants[mainHandWeapon]
			MainHandIcon:SetTexture(texture)
			if not texture then
				MainHandIcon:SetTexture(GetSpellTexture(TT_ROCKBITER_WEAPON))
			end
		elseif a10 and a10 == offHandWeapon then
			TotemTimers_Settings.LastOffEnchants[offHandWeapon] = {enchant, texture, 0}
			offEnchant = TotemTimers_Settings.LastOffEnchants[offHandWeapon]
			MainHandIcon2:SetTexture(texture)
			if not texture then
				MainHandIcon2:SetTexture(GetSpellTexture(TT_ROCKBITER_WEAPON))
			end
		else
			return
		end
	elseif event == "UNIT_INVENTORY_CHANGED" and arg1 == "player" then
		getWeapons()
		if mainHandWeapon then
			local weaponenchant = TotemTimers_Settings.LastMainEnchants[mainHandWeapon]
		end
		switchedWeapons = true
	end
end

function TotemTimers_MainHandOnShow(self)
	if SpellIDs[TT_ROCKBITER_WEAPON] <= 0 then
		MainHand:Hide()
	end
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED")
	getWeapons()
	if not TotemTimers_Settings.LastMainEnchants[mainHandWeapon] then
		MainHandIcon:SetTexture(GetSpellTexture(TT_ROCKBITER_WEAPON))
	end
	if not TotemTimers_Settings.LastOffEnchants[offHandWeapon] then
		MainHandIcon2:SetTexture(GetSpellTexture(TT_ROCKBITER_WEAPON))
	end
end

function TotemTimers_SetTrackerBars(enabled)
	if enabled then
		if ankhDuration > 0 then ShowTimerBar(AnkhTimerBar) end
		if shieldActive then ShowTimerBar(ShieldTimerBar) end
		if earthShieldTime>0 then ShowTimerBar(EarthShieldTimerBar) end
		if weaponRActive then ShowTimerBar(MainHandTimerBar) end
		if weaponLActive then ShowTimerBar(MainHandTimerBar2) end
	else
		HideTimerBar(AnkhTimerBar)
		HideTimerBar(ShieldTimerBar)
		HideTimerBar(EarthShieldTimerBar)
		HideTimerBar(MainHandTimerBar)
		HideTimerBar(MainHandTimerBar2)
	end
end


function TotemTimers_UpdateTrackers(time)
	local settings = TotemTimers_Settings
	if settings.Reincarnation and SpellIDs[TT_REINCARNATION]>0 then Ankh_OnUpdate(time) end
	if settings.ShieldTracker and SpellIDs[TT_LIGHTNING_SHIELD]>0 then Shield_OnUpdate(time) end
	if settings.MainEnchant and SpellIDs[TT_ROCKBITER_WEAPON]>0 then MainHand_OnUpdate(time) end
	if settings.EarthShieldTracker and SpellIDs[TT_EARTH_SHIELD]>0 then TotemTimers_EarthShield_OnUpdate(TotemTimers_EarthShield, time)end	
end