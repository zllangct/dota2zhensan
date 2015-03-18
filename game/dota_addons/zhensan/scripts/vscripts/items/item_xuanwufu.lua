
-- 将英雄的单位变大
function wanfumodi_big(keys)
    local caster=EntIndexToHScript(keys.caster_entindex)
    local i = 1
    caster.__isBig = true
    Timers:CreateTimer(function()
        if i <= 25 then
            caster:SetModelScale(1 + i / 50)
            i = i + 1
            return 0.01
        else
            return nil
        end
    end)
end

-- 将英雄的单位变小
function wanfumodi_small(keys)
    local caster=EntIndexToHScript(keys.caster_entindex)
    local i = 1
    Timers:CreateTimer(function()
        if i <= 25 then
            caster:SetModelScale( 1 + (25 - i) / 50 )
            i = i + 1
            return 0.01
        else
            return nil
        end
    end)
    caster.__isBig = false
end

-- 当玩家使用玄武斧
function OnPlayerUseXuanwufu(keys)
    local caster = keys.caster
    if not caster.__isBig then -- 如果玩家不在变大的状态，那么变大
        print("CASTER IS NOT BIG, MAKE IT BIGGER")
        caster.__isBig = true
        local i = 0
        Timers:CreateTimer(function()
            if i <= 25 then
                caster:SetModelScale(1 + i / 50)
                i = i + 1
                return 0.01
            else
                return nil
            end
        end)
    end
end
-- 当玄武斧的状态小时
function OnPlayerXuanwufuDisactivated(keys)
    local caster = keys.caster
    if caster.__isBig then -- 如果玩家正在变大的状态，那么变小
        local i = 0
        Timers:CreateTimer(function()
            if i <= 25 then
                caster:SetModelScale( 1 + (25 - i) / 50 )
                i = i + 1
                return 0.01
            else
                return nil
            end
        end)
        caster.__isBig = false
    end
end