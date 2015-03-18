-- 显示自定义错误
function ShowCustomErrorForPlayer(playerid, message)
    FireGameEvent( 'custom_error_show', { player_ID = playerid, _error = message } )
end

-- 更新木材信息
function UpdateLumberDataForPlayer(playerid, val)
    FireGameEvent("lumber_update", {PlayerID = playerid, Lumber = val})
end

-- 更新士气显示
function UpdateMoraleData(moraleTeam1, moraleTeam2)
    FireGameEvent("morale_update",{
        MoraleShu = moraleTeam1,
        MoraleWei = moraleTeam2,
    })
end