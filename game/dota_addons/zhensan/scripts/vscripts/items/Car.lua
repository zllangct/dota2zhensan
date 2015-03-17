require("utils/utils_print")
--初始化车子系统
if Car == nil then Car = class({}) end

function Car:Init()
	--ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(Car, "OnCarBuy"), self)
end
function Car:OnCarBuy(keys)
   	-- body
   	local plyID = keys.PlayerID
    if not plyID then return end
    -- The name of the item purchased
    local itemName = keys.itemname 
     -- The cost of the item purchased
    local itemcost = keys.itemcost
    local player = PlayerResource:GetPlayer(plyID)
    if not player then return end
    local hero = player:GetAssignedHero()
    if itemName == "item_toushiche" then 
       local item =ItemCore:FindItem(hero, itemName)         	                 
    end 
end   
function che_point(keys)
    -- body
    local caster=EntIndexToHScript(keys.caster_entindex)
    local caster_fv = caster:GetForwardVector()
    local caster_origin = caster:GetOrigin()
    local plyID=caster:GetPlayerID()
    point=GetGroundPosition(caster_origin,caster)
    local result = { }
       if caster.__lumber_data ~=nil and caster.__lumber_data >= 12 then 
         caster.__lumber_data = caster.__lumber_data-12
           Lumber:UpdateLumberToHUD(plyID, caster.__lumber_data) 
            table.insert(result, point)      
        else 
            FireGameEvent( 'custom_error_show', { player_ID = caster:GetPlayerID(), _error = "木材不足！！！" } )
           caster:ModifyGold(220,false,0)   
        end   
    
    return result
end
function test_001(keys)
    -- body
    print("#########shifang chenggong!!!")
end
function on_dummy_spawn(keys)
    -- body
    local caster =keys.caster
	local point = keys.target:GetAbsOrigin()
    local team = keys.caster:GetTeam()
    local result = { }
    local unit_name = "npc_dummy_1"
    local creep = CreateUnitByName(unit_name,point, false,caster:GetOwner(),caster:GetOwner(), team)
    creep:SetOwner(caster:GetOwner())
    local distance = (keys.caster:GetAbsOrigin()-creep:GetAbsOrigin()):Length()
    local _time=distance/800
    local spell = creep:FindAbilityByName("toushiche_dummy_01")
            if spell then  
                spell:SetLevel(1)
            end
    local _target = creep
    local ability=keys.caster:FindAbilityByName("toushiche_toushi_1")
    local info = {
                Target = _target,
                Source = keys.caster,
                Ability =ability,
                EffectName = "particles/base_attacks/ranged_siege_good.vpcf",
                bDodgeable = true,
                bProvidesVision = true,
                iMoveSpeed = 800,
                iVisionRadius = 1,
                iVisionTeamNumber = keys.caster:GetTeamNumber(), -- Vision still belongs to the one that casted the ability
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
        }
    ProjectileManager:CreateTrackingProjectile( info )
    
    creep:SetContextThink(DoUniqueString("chezi_01"),
        function()
          creep:CastAbilityImmediately(spell, creep:GetOwner():GetPlayerOwnerID())
        end,_time)
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("chezi_01"),
        function()
            -- body
            creep:RemoveSelf()
        end,3)
end
function on_chezi_spwan(keys)
local target=keys.target
local caster = keys.caster
local spell = target:FindAbilityByName("toushiche_toushi_1")
           if spell then  
                spell:SetLevel(1)
           end 
local spell2 = target:FindAbilityByName("toushiche_toushi_2")
if spell2 then  
             spell2:SetLevel(1)
 end
end
function on_dummy_spawn_2(keys)
    -- body  
    local caster =keys.caster
    local point = keys.target_points[1]
    local team = keys.caster:GetTeam()
    local result = { }
    local unit_name = "npc_dummy_2"
    local creep = CreateUnitByName(unit_name,point, false, caster:GetOwner(), caster:GetOwner(), team)
          creep:SetOwner(caster:GetOwner())    
    local distance = (keys.caster:GetAbsOrigin()-creep:GetAbsOrigin()):Length()
   --[[ if distance > 1200 then 
        keys.caster:FindAbilityByName("toushiche_toushi_2"):EndCooldown()
        local order={   UnitIndex=creep:entindex() ,
                        TargetIndex=caster:entindex() ,
                        OrderType=DOTA_UNIT_ORDER_ATTACK_TARGET,
                    }
        ExecuteOrderFromTable(order)
        return 
    end]]
    local _time=distance/800
    local spell = creep:FindAbilityByName("toushiche_dummy_02")
            if spell then  
                spell:SetLevel(1)
            end
    local _target = creep
    local ability=keys.caster:FindAbilityByName("toushiche_toushi_2")
    local info = {
                Target = _target,
                Source = keys.caster,
                Ability =ability,
                EffectName = "particles/base_attacks/ranged_siege_good.vpcf",
                bDodgeable = true,
                bProvidesVision = true,
                iMoveSpeed = 800,
                iVisionRadius = 1,
                iVisionTeamNumber = keys.caster:GetTeamNumber(), -- Vision still belongs to the one that casted the ability
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
        }
    ProjectileManager:CreateTrackingProjectile( info )
    
    creep:SetContextThink(DoUniqueString("chezi_01"),
        function()
            -- body 释放技能
             
            creep:CastAbilityImmediately(spell, creep:GetPlayerOwnerID())
        end,_time)
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("chezi_01"),
        function()
            -- body
            creep:RemoveSelf()
        end,3)
end