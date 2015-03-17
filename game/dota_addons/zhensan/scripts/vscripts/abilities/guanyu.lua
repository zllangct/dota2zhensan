require("utils/utils_print")
function guanyu_liuyuefeizhan_01( keys)
	local caster=EntIndexToHScript(keys.caster_entindex)
	local ability=keys.ability
	local caster_ori = caster:GetAbsOrigin()
    local point =keys.target_points[1]
    local distance = (caster_ori-point):Length()
    local movement = distance/1
    local dir=(caster_ori-point):Normalized()
    local k=keys.ability:GetLevel()
    local damage=keys.ability:GetLevelSpecialValueFor("damage",k-1)
    guanyu_liuyuefeizhan_move(caster,point,movement,distance,dir,damage,ability)
end 
function guanyu_liuyuefeizhan_move(caster,point,movement,distance,dir,damage,ability)  --耗时0.5秒
	-- body
	  local caster_ori = caster:GetAbsOrigin()
	  local perdistance_h = distance / 40
	  local cont = 0
      local perdistance_v  = 10
      GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("fengbaozhizhang_02"),function()  	 
	    local caster_ori = caster:GetAbsOrigin()
	    caster:SetAbsOrigin(caster_ori-dir*perdistance_h)
	    caster_ori = caster:GetAbsOrigin() 
        if cont < 20 then 
        	caster:SetAbsOrigin(caster_ori+Vector(0,0,perdistance_v))
        else 
        	caster:SetAbsOrigin(caster_ori-Vector(0,0,2*perdistance_v))
        end
        if cont == 29 then 
            caster:SetAbsOrigin(GetGroundPosition(caster_ori-Vector(0,0,perdistance_v),caster))
        end   
	    cont=cont+1
	    if cont == 30 then 
	    	local p_end = 'particles/econ/items/brewmaster/brewmaster_offhand_elixir/brewmaster_thunder_clap_elixir.vpcf'
            local p_index = ParticleManager:CreateParticle(p_end, PATTACH_CUSTOMORIGIN, caster)
            ParticleManager:SetParticleControl(p_index, 0, caster:GetOrigin())
            
         guanyu_liuyuefeizhan_damage(caster,damage,point,ability)
         FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
         ParticleManager:ReleaseParticleIndex(p_index)
         return nil
	    end 
	    return 0.02
    end,0)
end
function guanyu_liuyuefeizhan_damage(caster,damage,point,ability)
	-- body
	print("enter damage")
	local target=FindUnitsInRadius(caster:GetTeam(), point, nil, 300, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
	PrintTable(target)
	local caster_now=caster:GetAbsOrigin() 
	print("castar_now:"..tostring(castar_now))   
	if target[1] then 
	  for _,_target in pairs(target) do
		local target_now =_target:GetAbsOrigin()
		print("_target_now:"..tostring(_target_now))
		local _distance = (caster_now-target_now):Length() 
		local _damage = (damage-100)*(_distance/300)+100   
		    ApplyDamage(
                                { victim = _target, 
                                  attacker = caster, 
                                  damage = _damage,	
                                  damage_type = DAMAGE_TYPE_PHYSICAL 
                                }
			            )

		    
	  end
   end
    if caster:HasModifier("guanyu_liuyuefeizhan_wudi")  then 
    	caster:RemoveModifierByName("guanyu_liuyuefeizhan_wudi") 
    end
end