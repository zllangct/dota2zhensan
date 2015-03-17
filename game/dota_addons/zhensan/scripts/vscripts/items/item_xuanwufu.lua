yinxiong={}
yinxiong.isbig = false
function wanfumodi_big(keys)
    -- body
    local caster=EntIndexToHScript(keys.caster_entindex)
    local i = 1
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString(""),
        function( )
            -- body
            if i<= 25 then
               caster:SetModelScale(1+i/50)
               i=i+1
               return 0.01
            else 
               return nil
            end
        end,0)
end
function wanfumodi_small(keys)
    -- body
    local caster=EntIndexToHScript(keys.caster_entindex)
    local i = 1
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString(""),
        function( )
            -- body
            if i<= 25 then
               caster:SetModelScale(1+(25-i)/50)
               i=i+1
               return 0.02
            else 
               return nil
            end
        end,0)
end
function xuanwufu_01(keys)
    -- body
    local caster=EntIndexToHScript(keys.caster_entindex)
    local _duration=17
    caster:AddNewModifier(caster, keys.ability, "modifier_brewmaster_earth_spell_immunity", {duration=_duration})
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("yinxiong_think"),
        function (  )
            -- body
            if caster:HasModifier("modifier_brewmaster_earth_spell_immunity") and yinxiong.isbig == false then             
                wanfumodi_big(keys)
                yinxiong.isbig=true
                return 0.01
            elseif not caster:HasModifier("modifier_brewmaster_earth_spell_immunity") and yinxiong.isbig == true then 
                wanfumodi_small(keys)                
                yinxiong.isbig = false
                return nil 
            else  
                return 0.01
            end 

        end,0)
end