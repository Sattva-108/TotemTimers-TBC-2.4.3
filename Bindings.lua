local _G = getfenv()
local bindingNames = {
	["BINDING_NAME_TT_STRENGTH_OF_EARTH"] = "TT_STRENGTH_OF_EARTH",
	["BINDING_NAME_TT_STONESKIN"] = "TT_STONESKIN",
	["BINDING_NAME_TT_EARTHBIND"] = "TT_EARTHBIND",
	["BINDING_NAME_TT_TREMOR"] = "TT_TREMOR",
	["BINDING_NAME_TT_STONECLAW"] = "TT_STONECLAW",
	["BINDING_NAME_TT_EARTH_ELEMENTAL"] = "TT_EARTH_ELEMENTAL",

	["BINDING_NAME_TT_SEARING"] = "TT_SEARING",
	["BINDING_NAME_TT_MAGMA"] = "TT_MAGMA",
	["BINDING_NAME_TT_FIRE_NOVA"] = "TT_FIRE_NOVA",
	["BINDING_NAME_TT_WRATH"] = "TT_WRATH",
	["BINDING_NAME_TT_FIRE_ELEMENTAL"] = "TT_FIRE_ELEMENTAL",
	["BINDING_NAME_TT_FROST_RESISTANCE"] = "TT_FROST_RESISTANCE",
	["BINDING_NAME_TT_FLAMETONGUE"] = "TT_FLAMETONGUE",

	["BINDING_NAME_TT_MANA_SPRING"] = "TT_MANA_SPRING",
	["BINDING_NAME_TT_HEALING_STREAM"] = "TT_HEALING_STREAM",
	["BINDING_NAME_TT_MANA_TIDE"] = "TT_MANA_TIDE",
	["BINDING_NAME_TT_POISON_CLEANSING"] = "TT_POISON_CLEANSING",
	["BINDING_NAME_TT_DISEASE_CLEANSING"] = "TT_DISEASE_CLEANSING",
	["BINDING_NAME_TT_FIRE_RESISTANCE"] = "TT_FIRE_RESISTANCE",

	["BINDING_NAME_TT_GRACE_OF_AIR"] = "TT_GRACE_OF_AIR",
	["BINDING_NAME_TT_GROUNDING"] = "TT_GROUNDING",
	["BINDING_NAME_TT_NATURE_RESISTANCE"] = "TT_NATURE_RESISTANCE",
	["BINDING_NAME_TT_SENTRY"] = "TT_SENTRY",
	["BINDING_NAME_TT_TRANQUIL_AIR"] = "TT_TRANQUIL_AIR",
	["BINDING_NAME_TT_WINDFURY"] = "TT_WINDFURY",
	["BINDING_NAME_TT_WINDWALL"] = "TT_WINDWALL",
	["BINDING_NAME_TT_WRATH_AIR"] = "TT_WRATH_AIR",
	
	["BINDING_NAME_TT_WINDFURY_WEAPON"] = "TT_WINDFURY_WEAPON",
	["BINDING_NAME_TT_ROCKBITER_WEAPON"] = "TT_ROCKBITER_WEAPON",
	["BINDING_NAME_TT_FLAMETONGUE_WEAPON"] = "TT_FLAMETONGUE_WEAPON",
	["BINDING_NAME_TT_FROSTBRAND_WEAPON"] = "TT_FROSTBRAND_WEAPON",
}
_G["BINDING_NAME_TOTEMTIMERSCALL"] = _G["TT_TOTEMIC_CALL"]
_G["BINDING_NAME_TOTEMTIMERSLIGHTNINGSHIELD"] = _G["TT_LIGHTNING_SHIELD"]
_G["BINDING_NAME_TOTEMTIMERSWATERSHIELD"] = _G["TT_WATER_SHIELD"]

for k,v in pairs(bindingNames) do
	_G[k] = _G[v]
end

local menubutton = "RightButton"
	
local TotemTimers_Bindings = {
	["TOTEMTIMERSAIR"] = function(key) 
		SetOverrideBindingClick(TotemTimers_Buttons[AIR_TOTEM_SLOT], false, key, TotemTimers_Buttons[AIR_TOTEM_SLOT]:GetName())
		TotemTimers_Buttons[AIR_TOTEM_SLOT].hotkey:SetText(GetBindingText(key, "KEY_", 1))
	end,
	["TOTEMTIMERSEARTH"] = function(key, keytext)
		SetOverrideBindingClick(TotemTimers_Buttons[EARTH_TOTEM_SLOT], false, key, TotemTimers_Buttons[EARTH_TOTEM_SLOT]:GetName())
		TotemTimers_Buttons[EARTH_TOTEM_SLOT].hotkey:SetText(GetBindingText(key, "KEY_", 1))
	end,
	["TOTEMTIMERSFIRE"] = function(key, keytext)
		SetOverrideBindingClick(TotemTimers_Buttons[FIRE_TOTEM_SLOT], false, key, TotemTimers_Buttons[FIRE_TOTEM_SLOT]:GetName())
		TotemTimers_Buttons[FIRE_TOTEM_SLOT].hotkey:SetText(GetBindingText(key, "KEY_", 1))
	end,
	["TOTEMTIMERSWATER"] = function(key, keytext)	
		SetOverrideBindingClick(TotemTimers_Buttons[WATER_TOTEM_SLOT], false, key, TotemTimers_Buttons[WATER_TOTEM_SLOT]:GetName())
		TotemTimers_Buttons[WATER_TOTEM_SLOT].hotkey:SetText(GetBindingText(key, "KEY_", 1))
	end,
	["TOTEMTIMERSAIRMENU"] = function(key)
		SetOverrideBindingClick(TotemTimers_Buttons[AIR_TOTEM_SLOT], false, key, TotemTimers_Buttons[AIR_TOTEM_SLOT]:GetName(), menubutton)
	end,
	["TOTEMTIMERSEARTHMENU"] = function(key)
		SetOverrideBindingClick(TotemTimers_Buttons[EARTH_TOTEM_SLOT], false, key, TotemTimers_Buttons[EARTH_TOTEM_SLOT]:GetName(), menubutton)
	end,
	["TOTEMTIMERSFIREMENU"] = function(key)
		SetOverrideBindingClick(TotemTimers_Buttons[FIRE_TOTEM_SLOT], false, key, TotemTimers_Buttons[FIRE_TOTEM_SLOT]:GetName(), menubutton)
	end,
	["TOTEMTIMERSWATERMENU"] = function(key)
		SetOverrideBindingClick(TotemTimers_Buttons[WATER_TOTEM_SLOT], false, key, TotemTimers_Buttons[WATER_TOTEM_SLOT]:GetName(), menubutton)
	end,
	["TOTEMTIMERSCALL"] = function(key)
		SetOverrideBindingSpell(TotemTimersFrame, false, key, TT_TOTEMIC_CALL)
	end,
	["TOTEMTIMERSLIGHTNINGSHIELD"] = function(key)
		SetOverrideBindingSpell(TotemTimersFrame, false, key, TT_LIGHTNING_SHIELD)
	end,
	["TOTEMTIMERSWATERSHIELD"] = function(key)
		SetOverrideBindingSpell(TotemTimersFrame, false, key, TT_WATER_SHIELD)
	end,
	["TOTEMTIMERSEARTHSHIELDFOCUS"] = function(key)
		SetOverrideBindingClick(TotemTimers_EarthShield, false, key, "TotemTimers_EarthShield")
	end,
	["TOTEMTIMERSEARTHSHIELDTARGET"] = function(key)
		SetOverrideBindingClick(TotemTimers_EarthShield, false, key, "TotemTimers_EarthShield", "RightButton")
	end,
	["TOTEMTIMERSEARTHSHIELDSELF"] = function(key)
		SetOverrideBindingClick(TotemTimers_EarthShield, false, key, "TotemTimers_EarthShield", "Button4")
	end,
	["TOTEMTIMERSWEAPONBUFF1"] = function(key)
		SetOverrideBindingClick(TotemTimers_MainHand, false, key, "TotemTimers_MainHand")
	end,
	["TOTEMTIMERSWEAPONBUFF2"] = function(key)
		SetOverrideBindingClick(TotemTimers_MainHand, false, key, "TotemTimers_MainHand", "RightButton")
	end,
	["TT_WINDFURY_WEAPON"] = function(key)
		SetOverrideBindingSpell(TotemTimersFrame, false, key, TT_WINDFURY_WEAPON)
	end,
	["TT_ROCKBITER_WEAPON"] = function(key)
		SetOverrideBindingSpell(TotemTimersFrame, false, key, TT_ROCKBITER_WEAPON)
	end,
	["TT_FLAMETONGUE_WEAPON"] = function(key)
		SetOverrideBindingSpell(TotemTimersFrame, false, key, TT_FLAMETONGUE_WEAPON)
	end,
	["TT_FROSTBRAND_WEAPON"] = function(key)
		SetOverrideBindingSpell(TotemTimersFrame, false, key, TT_FROSTBRAND_WEAPON)
	end,
}

function TotemTimers_SetBinding(key, binding)
	if not TotemTimers_IsSetUp then return end
	if binding == nil then
		for i=1,4 do
			if TotemTimers_Buttons[i].hotkey:GetText() == key then
				TotemTimers_Buttons[i].hotkey:SetText("")
			end
		end
	elseif TotemTimers_Bindings[binding] then
		TotemTimers_Bindings[binding](key)
	elseif TotemData[_G[binding]] then
		SetOverrideBindingSpell(TotemTimersFrame, false, key, _G[binding])
	end
end

function TotemTimers_InitializeBindings()
	if TotemTimers_Settings.MouseOver then
		menubutton = "MiddleButton"
	else
		menubutton = "RightButton"
	end
	local key1, key2
	for binding,_ in pairs(TotemTimers_Bindings) do
		key1, key2 = GetBindingKey(binding)
		if key2 then TotemTimers_Bindings[binding](key2) end
		if key1 then TotemTimers_Bindings[binding](key1) end
	end
	for _,v in pairs(bindingNames) do
		key1, key2 = GetBindingKey(v)
		if key1 then
			SetOverrideBindingSpell(TotemTimersFrame, false, key1, _G[v])
		end
		if key2 then
			SetOverrideBindingSpell(TotemTimersFrame, false, key2, _G[v])
		end
	end
end

