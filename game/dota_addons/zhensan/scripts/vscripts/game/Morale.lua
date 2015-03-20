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

local MORALE_BUFF = {
    attackTimeBuff = {
        [0] = 0,
        [1] = 0.05,
        [2] = 0.10,
        [3] = 0.15
    },
    moveSpeedBuff = {
        [0] = 0,
        [1] = 0.05,
        [2] = 0.10,
        [3] = 0.15
    }
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
    self.__moraleLevel = {}
    self.__moraleLevel[DOTA_TEAM_GOODGUYS] = 0
    self.__moraleLevel[DOTA_TEAM_BADGUYS] = 0


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

            if entityKilled:GetUnitName() == MORALE_BUILDING_GOLD then -- 当谷仓被击杀的时候的效果，停止发工资
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
    
    -- 更新士气显示
    UpdateMoraleData(self.__morale[DOTA_TEAM_GOODGUYS], self.__morale[DOTA_TEAM_BADGUYS])

    -- 处理小兵的士气等级技能
    -- 可能存在的BUG，npc_creeps不能设置技能和技能等级？
    -- self:DealWithCreepsMorale(false)


    -- 士气系统的具体表现
    -- ？ 建议
    -- 优势一方增加 乘胜追击BUFF，劣势一方增加 背水一战BUFF
    -- 乘胜追击1级：提升移动速度？
    -- 背水一战1级：在生命值低于50%的时候，提升一定程度的普攻暴击。

    -- 还有 2,3 级别的效果。
end


































-- 将新刷新的小兵注册进所有小兵的列表
-- 如果这个队伍的士气等级>0
-- 那么设置他的士气BUFF
function MSys:DealWithCreep(creep)
    table.insert(self.__allCreeps, creep)
    self:SetCreepMorale(creep)
end

-- 当队伍的士气发生变更的时候
-- 处理所有小兵的士气等级
function MSys:DealWithCreepsMorale()
    -- 获取士气较高的队伍的士气，和队伍名称
    local largerMorale = self.__morale[DOTA_TEAM_GOODGUYS]
    local largerMoraleTeam = DOTA_TEAM_GOODGUYS
    if self.__morale[DOTA_TEAM_GOODGUYS] < self.__morale[DOTA_TEAM_BADGUYS] then
        largerMorale = self.__morale[DOTA_TEAM_BADGUYS]
        largerMoraleTeam = DOTA_TEAM_BADGUYS
    end
    local moraleLevel = math.floor((largerMorale - 10) / 3)
    print("DEALING WITH MORALE. TEAM IN ADVANTAGE", largerMoraleTeam, "MORALE", largerMorale, "MORALE LEVEL", moraleLevel)

    -- 如果士气较高的那个队伍的士气等级不等于上次的士气等级，那么才需要刷新小兵的士气BUFF
    local creepsUpdateRequired = moraleLevel ~= self.__moraleLevel[largerMoraleTeam]

    -- 将他们的士气数值存入表
    self.__moraleLevel[largerMoraleTeam] = moraleLevel
    self.__moraleLevel[self:__GetEnemyTeam(largerMoraleTeam)] = 0

    -- 设置场上所有小兵的士气表
    if creepsUpdateRequired then
        for _, creep in pairs(self.__allCreeps) do
            self:SetCreepMorale(creep)
        end
    end
end

function MSys:SetCreepMorale(creep)

    local team = creep:GetTeam()
    local moraleLevel = self.__moraleLevel[team]

    local attackTimeBuff = MORALE_BUFF.attackTimeBuff[moraleLevel]
    local moveSpeedBuff = MORALE_BUFF.moveSpeedBuff[moraleLevel]
    local baseAttackTime = 1 -- creep:GetBaseAttackTime() -- TODO, 这个数值还需要再确认是否正确
    local baseMoveSpeed = 300 -- creep:GetBaseMoveSpeed()

    local attackTimeFixed = baseAttackTime / ( 1 + attackTimeBuff)
    local moveSpeedFixed = math.floor(baseMoveSpeed / ( 1 + moveSpeedBuff))

    creep:SetBaseAttackTime(attackTimeFixed)
    creep:SetBaseMoveSpeed(moveSpeedFixed)    -- 返回类型: void
        -- 参数说明: int a:基础跑速
        -- 描述: 设置基础跑速。

    if not self.__moraleMessagePrinted then
        print("==============================================================================")
        print("     DEAL WITH MORALE     ")
        print("==============================================================================")
        print("ATTACK TIME BUFF", attackTimeBuff, "BASE ATTACK TIME", baseAttackTime, "FIXED ATTACKTIME", attackTimeFixed)
        print("ATTACK TIME BUFF", moveSpeedBuff, "BASE ATTACK TIME", baseMoveSpeed, "FIXED ATTACKTIME", moveSpeedFixed)
        print("==============================================================================")
        self.__moraleMessagePrinted = true
    end

end

function MSys:__GetEnemyTeam(team)
    if team == DOTA_TEAM_GOODGUYS then return DOTA_TEAM_BADGUYS end
    if team == DOTA_TEAM_BADGUYS then return DOTA_TEAM_GOODGUYS end
end