local TotemTimers_OldGetPlayerBuffTimeLeft, TotemTimers_OldGetPlayerBuff, TotemTimers_OldGetPlayerBuffTexture
local TotemTimers_OldGetPlayerBuffName, TotemTimers_OldGetPlayerBuffApplications
local maxbuffs = 0
local maxbuffsanddebuffs = 0
local ActiveTotems
local TotemData = TotemData
local TotemDataEffects = TotemDataEffects

local function GetTotem(id)
	id = id+1-maxbuffsanddebuffs
	if id<1 then return nil end
	for i = 1,4 do
		local element = TotemTimers_Settings.Order[i]
		if ActiveTotems[element].totem and not TotemData[ActiveTotems[element].totem].effect
			and ActiveTotems[element].active
			then
				id = id - 1
		end
		if id == 0 then return element end
	end
	return nil
end

function TotemTimers_InitBuffs()
	if not TotemTimers_Settings.ShowTotemsAsBuffs then return end
	TotemTimers_OldGetPlayerBuffTimeLeft = GetPlayerBuffTimeLeft
	GetPlayerBuffTimeLeft = TotemTimers_GetPlayerBuffTimeLeft
	TotemTimers_OldGetPlayerBuff = GetPlayerBuff
	GetPlayerBuff = TotemTimers_GetPlayerBuff
	TotemTimers_OldGetPlayerBuffTexture = GetPlayerBuffTexture
	GetPlayerBuffTexture = TotemTimers_GetPlayerBuffTexture
	TotemTimers_OldGetPlayerBuffName = GetPlayerBuffName
	GetPlayerBuffName = TotemTimers_GetPlayerBuffName
	TotemTimers_OldGetPlayerBuffApplications = GetPlayerBuffApplications
	GetPlayerBuffApplications = TotemTimers_GetPlayerBuffApplications
	ActiveTotems = TTActiveTotems
	hooksecurefunc("CancelPlayerBuff", function(arg1)
		if type(arg1) ~= "number" then return end
		if arg1 >= maxbuffs then
			local totem = GetTotem(arg1) 
			if totem then DestroyTotem(totem) end
		else
			local name = TotemTimers_OldGetPlayerBuffName(arg1)
			if TotemDataEffects[name] and ActiveTotems[TotemDataEffects[name]].active then
				DestroyTotem(ActiveTotems[TotemDataEffects[name]].element)
			end
		end
	end)
end

function TotemTimers_ThrowAuraEvent()
	local frames = {GetFramesRegisteredForEvent("PLAYER_AURAS_CHANGED")}
	--local event = _G["event"];
	--_G["event"] = "PLAYER_AURAS_CHANGED"
	for _,frame in pairs(frames) do
		if frame:GetName() then
			local name = string.sub(frame:GetName(),1,7)
			if name ~= "Possess" and name ~= "Shapesh" then
				if frame.EventDispatcher then
					frame.EventDispatcher:DispatchEvent("PLAYER_AURAS_CHANGED")
				else
					local eventfunc = frame:GetScript("OnEvent")
					if eventfunc then eventfunc(frame, "PLAYER_AURAS_CHANGED") end
				end
			end
		end
	end
	--_G["event"] = event;
end
	
function TotemTimers_GetMaxBuffs()
	maxbuffs = 0
	for i=1,40 do
		if TotemTimers_OldGetPlayerBuff(i, "HELPFUL") == 0 and maxbuffs == 0 then
			maxbuffs = i;
		end
	end
	maxbuffsanddebuffs = 0
	for i=1,40 do
		if TotemTimers_OldGetPlayerBuff(i, "HARMFUL") == 0 and maxbuffsanddebuffs == 0 then
			maxbuffsanddebuffs = maxbuffs+i-1
		end
	end
end
	
function TotemTimers_GetPlayerBuffTimeLeft(id)
	--TotemTimers_GetMaxBuffs()
	local element = GetTotem(id)
	if element then return ActiveTotems[element].duration
	else
		local name = TotemTimers_OldGetPlayerBuffName(id)
		if TotemDataEffects[name] and ActiveTotems[TotemDataEffects[name]].active then
			return ActiveTotems[TotemDataEffects[name]].duration
		else
			return TotemTimers_OldGetPlayerBuffTimeLeft(id)
		end
	end
end

function TotemTimers_GetPlayerBuff(buffID, buffFilter)
	TotemTimers_GetMaxBuffs()
	if not string.find(buffFilter, "HELPFUL") then return TotemTimers_OldGetPlayerBuff(buffID, buffFilter) end
	if buffID < maxbuffs then
		local name = TotemTimers_OldGetPlayerBuffName(buffID)
		if TotemDataEffects[name] and ActiveTotems[TotemDataEffects[name]].active then
			return buffID, 0
		end
		return TotemTimers_OldGetPlayerBuff(buffID, buffFilter)
	end
	if buffID < maxbuffs+4 then
		local buff = buffID - maxbuffs
		if (GetTotem(maxbuffsanddebuffs+buff)) then 
			return (maxbuffsanddebuffs+buff), 0
		end
	end
	return 0,0
end

function TotemTimers_GetPlayerBuffTexture(id)
	local element = GetTotem(id)
	if element then return GetSpellTexture(ActiveTotems[element].totem)
	else return TotemTimers_OldGetPlayerBuffTexture(id)
	end
end

function TotemTimers_GetPlayerBuffName(id)
	if type(id) == "string" then return TotemTimers_OldGetPlayerBuffName(id) end
	local element = GetTotem(id)
	if element then return ActiveTotems[element].totem
	else return TotemTimers_OldGetPlayerBuffName(id)
	end
end

function TotemTimers_GetPlayerBuffApplications(id)
	local element = GetTotem(id)
	if element then return 0
	else return TotemTimers_OldGetPlayerBuffApplications(id)
	end
end




