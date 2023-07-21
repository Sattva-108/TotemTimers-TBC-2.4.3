local addonName = "TotemTimers"
if cyCircled then
cyCircled_TotemTimers = cyCircled:NewModule(addonName)

function cyCircled_TotemTimers:AddonLoaded()
	self.db = cyCircled:AcquireDBNamespace(addonName)
	cyCircled:RegisterDefaults(addonName, "profile", {
		["Timers"] = true,
		["Trackers"] = true,
	})
	self:SetupElements()
	--self:OnEnable()
end

function cyCircled_TotemTimers:GetElements()
	return {
		["Timers"] = true,
		["Trackers"] = true,
	}
end

function cyCircled_TotemTimers:SetupElements()
	self.elements = {
		["Timers"] = { 
			args = {
				hotkey = true,
				ct = false,
			},
			elements = {"TotemTimers1", "TotemTimers2", "TotemTimers3", "TotemTimers4"}, 
		},
		["Trackers"] = {
			args = {
				hotkey = true,
				ct = false,
			},
			elements = {"TotemTimers_Ankh", "TotemTimers_Shield", "TotemTimers_EarthShield", "TotemTimers_MainHand"}, 
		},
	}
end

end