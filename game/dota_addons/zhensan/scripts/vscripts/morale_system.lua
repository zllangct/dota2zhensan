------------------------------------------------------------------------
--士气系统
------------------------------------------------------------------------
if Morale_System == nil then Morale_System = class( { }) end
Morale_System.Morale_shu = 10
Morale_System.Morale_wei = 10


function Morale_System:init()
	-- 监听单位击杀事件
    ListenToGameEvent("entity_killed", Dynamic_Wrap(Morale_System, "thinker"), self)
    Morale_System.morale_ability_name ="morale_ability"
end
function Morale_System:thinker(keys)
	local entity_killed = EntIndexToHScript(keys.entindex_killed)  --获取死亡者实体
    if not(entity_killed and entity_attacker) then return end   --如果实体不存在，则退出士气系统
    local killed_team = ntity_killed:GetTeam()   --获取死亡者队伍
    local entity_attacker = EntIndexToHScript(keys.entindex_attacker)
    local team_attacker = entity_attacker:GetTeam()
    if entity_killed:IsHero() then 
    	if killed_team == DOTA_TEAM_GOODGUYS then 
            if self.Morale_shu>1 then
    		    self.Morale_shu=self.Morale_shu-1
    		    self.Morale_wei=self.Morale_wei+1
                GameRules:SendCustomMessage("#morale_shu_down", team_attacker, 0)
                GameRules:SendCustomMessage("#morale_shu_down", killed_team, 0)
    		end
    	elseif  killed_team == DOTA_TEAM_BADGUYS then 
    		if Mself.Morale_wei>1 then
    		    self.Morale_shu=self.Morale_shu+1
    		    self.Morale_wei=self.Morale_wei-1
                GameRules:SendCustomMessage("#morale_shu_up", killed_team, 0)
                GameRules:SendCustomMessage("#tmorale_shu_up", team_attacker, 0)               
        	end
    	end 
        UTIL_ResetMessageTextAll()
        UTIL_MessageTextAll("#morale_message", 255, 255, 255, 125, { value1 = self.Morale_shu,value2 = self.Morale_wei })
        
    end
   
end
function Morale_System:syn_ability(caster)  
	-- body   
    --local caster=EntIndexToHScript(keys.caster)
    local lvl = 1
    caster:SetContextThink( "wild_maxaway", function()
    if caster:GetTeam() == DOTA_TEAM_GOODGUYS then 
       if self.Morale_shu > 10 then 
           lvl = math.ceil((self.Morale_shu-10)/3)
       end
    elseif caster:GetTeam()== DOTA_TEAM_BADGUYS then
        if self.Morale_wei > 10 then 
           lvl = math.ceil((self.Morale_shu-10)/3)
        end
    end
    local morale_ability = caster:FindAbilityByName(self.morale_ability_name)
    if not morale_ability then
        caster:AddAbility(self.morale_ability_name)
        morale_ability = caster:FindAbilityByName(self.morale_ability_name)
        morale_ability:SetLevel(lvl)
    end
  end,1)
end