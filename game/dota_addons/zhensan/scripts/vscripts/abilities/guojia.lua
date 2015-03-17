require('abilities/ability_generic')
function guojia_binhebaoliepo_01(keys)
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
        --ParticleManager:ReleaseParticleIndex(p_index)
        --ParticleManager:DestroyParticle(p_index,true)
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