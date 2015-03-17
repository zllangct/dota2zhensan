-- 真三·士气系统
-- 每次某一方提升士气，那么降低另一方的士气，双方的士气总额始终为20
-- 1、只要有英雄阵亡该队伍的士气下降，每个队伍的起始值为10，小兵都带有士气buff，
-- 士气在13、16、19时小兵士气buff分别为1、2、3级，（士气buff：加攻速和移动速度）
-- 2、士气buff：移动速度和攻击速度：5% 10% 15%
-- 当某一方的谷仓被击杀
-- 那么降低那一方的士气，同时停发系统工资
-- 兵营，据点，都降士气
-- 谷仓降士气同时停工资

-- Author:XavierCHN @ 2015.3.17

-- 会影响士气的建筑列表
local MORALE_BUILDINGS = {
    "npc_zs_gucang", -- 谷仓
    "npc_zs_bingying", -- 兵营
    "npc_zs_judian", -- 据点
}
-- 会停发工资的建筑
local MORALE_BUILDING_GOLD = "npc_zs_gucang"

-- 初始化
if MSys == nil then MSys = class({}) end

-- 当有英雄被击杀的时候，被击杀英雄方的士气下降

-- 士气系统：初始化
-- 注册事件监听，初始化双方的士气数值
-- 
function MSys:Init()
    -- 注册事件监听
    ListenToGameEvent("dota_player_killed", Dynamic_Wrap(MSys, "OnPlayerKilled"), self)
    ListenToGameEvent("entity_killed", Dynamic_Wrap(MSys, "OnEntityKilled"), self)

    -- 设置双方的初始士气为10
    self.__morale = {}
    self.__morale[DOTA_TEAM_GOODGUYS] = 10
    self.__morale[DOTA_TEAM_BADGUYS] = 10

    -- 设置双方的金钱
    self.__goldTicking = {}
    self.__goldTicking[DOTA_TEAM_BADGUYS] = true
    self.__goldTicking[DOTA_TEAM_GOODGUYS] = true

    self.__goldTickTimerStarted = false

    -- 注册小兵
    self.__allCreeps = {}
end



-- 士气系统：英雄被击杀的响应
-- 当有英雄被击杀的事件响应
-- 
function MSys:OnPlayerKilled(keys)
    local playerId = keys.PlayerID
    local playerKilled = PlayerResource:GetPlayer(playerId)
    if not playerKilled then return end -- 确保成功
    local heroKilled = playerKilled:GetAssignedHero()
    if not heroKilled then return end -- 确保成功

    print("[DOTA2ZS] a hero was killed, deal with morale system")

    local heroKilledTeam = heroKilled:GetTeam()
    print("player from", heroKilledTeam,"was killed")

    -- 提升被击杀队伍的士气，同时提升击杀方士气
    self:MoraleDown(playerKilled, heroKilledTeam)

end

-- 士气系统：单位被击杀的响应
-- 
function MSys:OnEntityKilled(keys)
    local entityKilled = EntIndexToHScript(keys.entindex_killed)
    
    -- 如果有士气建筑被击杀，那么降低被击杀那方的士气
    for _, name in pairs(MORALE_BUILDINGS) do
        if entityKilled:GetUnitName() == name then
            print("a morale building was killed, fixing morale data")
            local team = entityKilled:GetTeam()
            self:MoraleDown(entityKilled, team)

            if entityKilled:GetUnitName() == MORALE_BUILDING_GOLD then
                -- 禁止双方发工资
                GameRules:SetGoldTickTime(0)
                self.__goldTicking[team] = false
                -- 启动一个计时器为另一方发工资
                if not self.__goldTickTimerStarted then
                    self.__goldTickTimerStarted = true
                    local enemyTeam = self:__GetEnemyTeam(team)
                    Timers:CreateTimer(GameRules:GetGoldTickTime(),function()
                        for i = -1,DOTA_MAX_PLAYERS do
                            local palyer = PlayerResource:GetPlayer(i)
                            if player:GetTeam() == enemyTeam() then
                                PlayerResouce:ModifyGold(player:GetPlayerID(), GameRules:GetGoldPerTick(), false, 0)
                                -- 如果双方都不发工资，那么停止计时器
                                if self.__goldTicking[team] == false and self.__goldTicking[self:__GetEnemyTeam(team)] == false then
                                    return nil
                                else
                                    return GameRules:GetGoldTickTime()
                                end
                            end
                        end
                    end)
                end
            end
        end
    end

    -- 处理小兵被击杀的问题
    if string.find(entityKilled:GetUnitName(), "npc_zs_creep_" ) then
        for k,v in pairs(self.__allCreeps) do
            if v == entityKilled then
                self.__allCreeps[k] = nil
            end
        end
    end
end

function MSys:MoraleDown(player, team)
    -- 获取敌方士气
    local enemyTeam = self:__GetEnemyTeam(team)
    local enemyMorale = self.__morale[enemyTeam]

    -- 如果敌方士气达到20，不再增加
    if enemyMorale >= 20 then
        return
    end

    -- 提升该队伍的士气
    self.__morale[team] = self.__morale[team] - 1
    self.__morale[enemyTeam] = self.__morale[enemyTeam] + 1
    
    FireGameEvent("morale_update",{
        MoraleShu = self.__morale[DOTA_TEAM_GOODGUYS],
        MoraleWei = self.__morale[DOTA_TEAM_BADGUYS]
    })

    -- 处理小兵的士气等级技能
    -- 可能存在的BUG，npc_creeps不能设置技能和技能等级？

end

function MSys:DealWithCreep(creep)
    table.insert(self.__allCreeps, creep)
end



function MSys:__GetEnemyTeam(team)
    if team == DOTA_TEAM_GOODGUYS then return DOTA_TEAM_BADGUYS end
    if team == DOTA_TEAM_BADGUYS then return DOTA_TEAM_GOODGUYS end
end


--[[
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
]]