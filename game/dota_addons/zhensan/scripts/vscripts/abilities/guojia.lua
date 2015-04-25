require('abilities/ability_generic')
function guojia_binhebaoliepo_01(keys) --国家特效，无其他内容
    local caster = keys.caster
    local point = keys.target_points[1]
    local caster_origin = caster:GetOrigin()
    local direction =(point - caster_origin):Normalized()
    local particle ={}
    local effect_count = 0
    local p_time = 0
    caster:SetContextThink(DoUniqueString("fireeffect"),
    function()
        local p_index = ParticleManager:CreateParticle("particles/heroes/zhuge/jakiro_ice_path_shards.vpcf", PATTACH_CUSTOMORIGIN, caster)
        local vec = caster_origin + direction *(100 + 200 * effect_count)
        ParticleManager:SetParticleControl(p_index, 0, vec)
        particle[effect_count] = p_index
        effect_count = effect_count + 1
        -- 总共创建五个
        if effect_count >= 6 then 
            
            if p_time >= 1.5 then
                for i=0,6 do
                    local k = particle[i]
                    ParticleManager:DestroyParticle(k,true)  
                end
               return nil 
            else 
               
                p_time=p_time+1.5
                return 1.5
            end
        else  
            return 0.05 
        end
    end ,
    0.1)
end
function guojia_binhebaoliepo_02(keys)
    local caster=keys.caster 
    local target=keys.target
    --for k,_target in pairs(target) do
        if target:IsMagicImmune() then 
            keys.ability:ApplyDataDrivenModifier(caster,target, "modifier_jidongningjie_1",nil)
        end
   -- end
end