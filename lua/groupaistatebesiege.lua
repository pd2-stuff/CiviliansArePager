local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local kic_original_groupaistatebesiege_checkspawnphalanx = GroupAIStateBesiege._check_spawn_phalanx
function GroupAIStateBesiege:_check_spawn_phalanx()
	kic_original_groupaistatebesiege_checkspawnphalanx(self)
end

local kic_original_groupaistatebesiege_phalanxdamagereductiondisable = GroupAIStateBesiege.phalanx_damage_reduction_disable
function GroupAIStateBesiege:phalanx_damage_reduction_disable()
	kic_original_groupaistatebesiege_phalanxdamagereductiondisable(self)
end

local kic_original_groupaistatebesiege_spawnphalanx = GroupAIStateBesiege._spawn_phalanx
function GroupAIStateBesiege:_spawn_phalanx()
	kic_original_groupaistatebesiege_spawnphalanx(self)

	if self._phalanx_spawn_group then
		if table.size(CiviliansArePager.civilians_killed_by_player) > 0 then
			self:phalanx_damage_reduction_enable()
		end
	end
end
