--[[

Author: tochonement
Email: tochonement@gmail.com

12.03.2021

--]]

gfconsole.subscriptions = {}

local subscriptions = gfconsole.subscriptions
local members = {}

function subscriptions.add(ply)
    if subscriptions.check(ply) then
        return
    end

    table.insert(members, ply)

    hook.Run("gfconsole.SubscriberAdded", ply)
end

function subscriptions.check(ply)
    for index, ply2 in ipairs(members) do
        if ply == ply2 then
            return true, index
        end
    end

    return false
end

function subscriptions.remove(ply)
    local bool, index = subscriptions.check(ply)
    if bool then
        table.remove(members, index)

        hook.Run("gfconsole.SubscriberRemoved", ply)
    end
end

function subscriptions.get()
    return members
end