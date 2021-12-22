local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local kic_original_civilianlogicinactive_setinteraction = CivilianLogicInactive._set_interaction
function CivilianLogicInactive._set_interaction(data, my_data)
	if data.unit:character_damage():dead() and managers.groupai:state():whisper_mode() then
		if math.random() < CiviliansArePager.cops_in_disguise_chance[CiviliansArePager.settings.cops_in_disguise] then
			data.unit:unit_data().has_alarm_pager = true
			data.brain:begin_alarm_pager()
			return
		end
	end

	kic_original_civilianlogicinactive_setinteraction(data, my_data)
end

local kic_original_civilianlogicinactive_onenemyweaponshot = CivilianLogicInactive.on_enemy_weapons_hot
function CivilianLogicInactive.on_enemy_weapons_hot(data)
	kic_original_civilianlogicinactive_onenemyweaponshot(data)

	if data.unit:interaction():active() then
		data.unit:interaction():set_active(false, true)
	end
end
