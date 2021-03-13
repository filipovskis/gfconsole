--[[

Author: tochonement
Email: tochonement@gmail.com

13.03.2021

--]]

if not gfconsole.extensions["subscriptions"] then
    local can_subscribe = gfconsole.config.can_subscribe

    hook.Add("gfconsole.CanReceiveMessage", "gfconsole.Default", function(ply)
        if not can_subscribe(ply) then
            return false
        end
    end)
end