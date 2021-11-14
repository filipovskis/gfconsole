--[[

Author: tochonement
Email: tochonement@gmail.com

13.03.2021

--]]

function gfconsole.SendWinNotify(receivers, text)
    net.Start("gfconsole:SendWinNotify")
        net.WriteString(text)
    net.Send(receivers)
end

hook.Add("gfconsole.CanReceiveMessage", "gfconsole.Default", function(ply)
    if not gfconsole.extension:is_enabled("subscriptions") then
        if not gfconsole.config.can_subscribe(ply) then
            return false
        end
    end
end)