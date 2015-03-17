
zhangfei={}
zhangfei.isbig = false
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
function zhangfei_wanfumodi_01(keys)
    -- body
    local caster=EntIndexToHScript(keys.caster_entindex)
    local k=keys.ability:GetLevel()
    local maxhealth_bonus=keys.ability:GetLevelSpecialValueFor("maxhealth_bonus",k-1)
    local _duration=keys.ability:GetLevelSpecialValueFor("duration",k-1)
    caster:AddNewModifier(caster, keys.ability, "modifier_brewmaster_earth_spell_immunity", {duration=_duration})
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("zhangfei_think"),
        function (  )
            -- body
            if caster:HasModifier("modifier_brewmaster_earth_spell_immunity") and zhangfei.isbig == false then             
                wanfumodi_big(keys)

              --  caster:SetMaxHealth(caster:GetMaxHealth()+maxhealth_bonus)
              --  caster:SetHealth(caster:GetHealth()+maxhealth_bonus)
                zhangfei.isbig=true
                return 0.01
            elseif not caster:HasModifier("modifier_brewmaster_earth_spell_immunity") and zhangfei.isbig == true then 
                wanfumodi_small(keys)                
               -- caster:SetMaxHealth(caster:GetMaxHealth()-maxhealth_bonus)
                zhangfei.isbig = false
                return nil 
            else  
                return 0.01
            end 

        end,0)
end
function zhangfei_yinghan_01(keys)
    -- body
    local caster=EntIndexToHScript(keys.caster_entindex)
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("bonus_armor_zhangfei"),
        function (  )
            -- body
            local nowhealth=caster:GetHealth()
          if nowhealth < caster:GetMaxHealth()/2 then 
             keys.ability:ApplyDataDrivenModifier(caster, caster, "zhangfei_yinghan_buff", nil)
             return 0.3
          else
               if caster:HasModifier("zhangfei_yinghan_buff") then
                  caster:RemoveModifierByName("zhangfei_yinghan_buff")
               end 
               return 0.3
           end          
        end,0)
end
function zhangfei_shenji_01(keys)
	-- body   
    local caster=EntIndexToHScript(keys.caster_entindex)
    local i=keys.ability:GetLevel()
    local currenthealth = caster:GetHealth()
    local durationtime=keys.ability:GetLevelSpecialValueFor("ability_duration",i-1)
    local amplify_damage=keys.ability:GetLevelSpecialValueFor("amplify_damage",i-1)
    local leap_speedbonus_as_one=keys.ability:GetLevelSpecialValueFor("leap_speedbonus_as_one",i-1)
    local overtime = Time()+durationtime
    local speed=caster:GetAttackSpeed()
    local speed1=caster:GetAttacksPerSecond()
    local str= leap_speedbonus_as_one*speed
    if str>=100 then 
        local x1=math.floor(str/100)*100
        keys.ability:ApplyDataDrivenModifier(caster, caster, "attackspeed_"..tostring(x1), {duration=durationtime})
        local x2=math.floor((str-x1)/10)*10 
        keys.ability:ApplyDataDrivenModifier(caster, caster, "attackspeed_"..tostring(x2), {duration=durationtime})       
        local x3=math.floor(str-x1-x2)
        keys.ability:ApplyDataDrivenModifier(caster, caster, "attackspeed_"..tostring(x3), {duration=durationtime})
    else 
        if str>=10 then 
           local x2=math.floor(str/10)*10 
           keys.ability:ApplyDataDrivenModifier(caster, caster, "attackspeed_"..tostring(x2), {duration=durationtime})
         -- keys.ability:ApplyDataDrivenModifier(caster, caster, "attackspeed_100", {duration=durationtime}) 
           local x3=math.floor(str-x2)
           keys.ability:ApplyDataDrivenModifier(caster, caster, "attackspeed"..tostring(x3), {duration=durationtime})
        else 
           local x3=math.floor(str)
           keys.ability:ApplyDataDrivenModifier(caster, caster, "attackspeed_"..tostring(x3), {duration=durationtime}) 
        end
    end 
    local speed1=caster:GetAttacksPerSecond()
    speed=caster:GetAttackSpeed()
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("bonus_damage_zhangfei"), 
		   function( )
			if caster:IsAlive() and Time() < overtime then
				local nowhealth=caster:GetHealth()
				if caster:IsAlive() and nowhealth<currenthealth then 
					if nowhealth >0 then
						if nowhealth >= (amplify_damage*(currenthealth-nowhealth))/100 then
					       caster:SetHealth(nowhealth-(amplify_damage*(currenthealth-nowhealth))/100)
					       currenthealth=nowhealth-(currenthealth-nowhealth)
					       nowhealth=caster:GetHealth()	
					    else 					       
					       return nil
					    end
					end		
				end				
                return 0.01
            else 
            	return nil 
			end	

		end,0)
end