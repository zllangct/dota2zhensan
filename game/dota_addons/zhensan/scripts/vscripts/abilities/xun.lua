require("utils/utils_print")
function xun_jingzhixianjin_01( keys)    --寻，静止陷阱
	-- body
    local caster=EntIndexToHScript(keys.caster_entindex)
    local target = keys.target
    local invisibility =false
    local _ability=keys.ability
    local k=keys.ability:GetLevel()
	local spell = target:FindAbilityByName("xun_jingzhixianjin_invisible")
    if spell then  
        spell:SetLevel(k)
    end 
    target:CastAbilityImmediately(spell, target:GetPlayerOwnerID())               
end
function xun_jingzhixianjin_02( keys)
    -- body
    local caster=EntIndexToHScript(keys.caster_entindex)
    local target = keys.target_entities
    local spell = caster:FindAbilityByName("xun_jingzhixianjin_stun")
    local k=keys.ability:GetLevel()
    local delay=keys.ability:GetLevelSpecialValueFor("blast_daley",k-1)
        if spell then  
            spell:SetLevel(1)
        end
    if target[1] then
        if caster:HasModifier("modifier_persistent_invisibility")  then 
            caster:RemoveModifierByName("modifier_persistent_invisibility")
        end 
        caster:CastAbilityImmediately(spell, caster:GetPlayerOwnerID())
        GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("xun_think"),
        function()
            -- body
           caster:ForceKill(true)
           return nil
       end,1)    --爆炸延迟    
    end   
end
function xun_zhimingjiejie_01(keys)
    -- body
    local caster=EntIndexToHScript(keys.caster_entindex)
    local target = keys.target
    local invisibility =false
    local _ability=keys.ability
    local k=keys.ability:GetLevel()
    local unit_health=keys.ability:GetLevelSpecialValueFor("unit_health",k-1)
    local spell = target:FindAbilityByName("xun_zhimingjiejie_buff")
      target:SetMaxHealth(unit_health)
      target:SetHealth(unit_health)
    if spell then  
        spell:SetLevel(k)
        target:CastAbilityImmediately(spell, target:GetPlayerOwnerID())
    end
    
end