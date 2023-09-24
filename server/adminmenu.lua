local function isAdmin(playerId)
    local admin = IsPlayerAceAllowed(playerId, 'wxAC.bypass')
    if admin == 1 or admin then return true end
    return false
end

lib.callback.register('wx_anticheat:isAdmin', function(source)
    if isAdmin(source) then return true else return false end
end)