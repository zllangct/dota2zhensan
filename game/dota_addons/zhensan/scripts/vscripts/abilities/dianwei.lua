
function dianwei_yexingzhanhun_01(keys)
	-- body
	local caster=EntIndexToHScript(keys.caster_entindex)
    local i=0
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("dianwei"),
    	function ( )
    		-- body
    	
           if i ~= keys.ability:GetLevel() then 
           	   i = keys.ability:GetLevel()
               local health_bonus=keys.ability:GetLevelSpecialValueFor("health_bonus",i-1)
            -- local health_regen=caster:GetHealthRegen()
               local health_regen_base=caster:GetBaseHealthRegen()    
               local base_health_new =health_regen_base + 0.25*(health_bonus/100)
               caster:SetBaseHealthRegen(base_health_new)
            end
           return 1

        end,0)
end
function AmplifyDamageParticle( event )
  local target = event.target
  local location = target:GetAbsOrigin()
  local particleName = "particles/dianweiyaohuo.vpcf"

-- Particle. Need to wait one frame for the older particle to be destroyed
  Timers:CreateTimer(0.01, function() 
    target.AmpDamageParticle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, target)
    ParticleManager:SetParticleControl(target.AmpDamageParticle, 0, target:GetAbsOrigin())
   --ParticleManager:SetParticleControl(target.AmpDamageParticle, 1, target:GetAbsOrigin())
    --ParticleManager:SetParticleControl(target.AmpDamageParticle, 2, target:GetAbsOrigin())

    ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 1, target, PATTACH_OVERHEAD_FOLLOW, "attach_overhead", target:GetAbsOrigin(), true)
   --ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 2, target, PATTACH_OVERHEAD_FOLLOW, "attach_overhead""attach_hitloc", target:GetAbsOrigin(), true)
  end)
end

-- Destroys the particle when the modifier is destroyed
function EndAmplifyDamageParticle( event )
  local target = event.target
  ParticleManager:DestroyParticle(target.AmpDamageParticle,false)
end
