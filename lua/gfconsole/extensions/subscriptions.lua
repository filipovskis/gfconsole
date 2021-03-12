--[[

Author: tochonement
Email: tochonement@gmail.com

12.03.2021

--]]

if SERVER then
    util.AddNetworkString("gfconsole:Subscribe")

    local function can_subscribe(ply)
        return ply:IsSuperAdmin()
    end

    hook.Add("PlayerDisconnected", "gfconsole.subscriptions.Remove", function(ply)
        gfconsole.subscriptions.remove(ply)
    end)

    hook.Add("gfconsole.CanReceiveMessage", "Subscriptions", function(ply)
        local is_subscriber = gfconsole.subscriptions.check(ply)
        if not is_subscriber then
            return false
        end
    end)

    hook.Add("gfconsole.SubscriberAdded", "Notify", function(ply)
        gfconsole.send("Subscriptions", Color(59, 179, 95), "[Subscriptions] ", color_white, "User added: " .. ply:Name())
    end)

    hook.Add("gfconsole.SubscriberRemoved", "Notify", function(ply)
        gfconsole.send("Subscriptions", Color(59, 179, 95), "[Subscriptions] ", color_white, "User removed: " .. ply:Name())
    end)

    net.Receive("gfconsole:Subscribe", function(len, ply)
        local bool = net.ReadBool()

        if can_subscribe(ply) then
            if bool then
                gfconsole.subscriptions.add(ply)
            else
                gfconsole.subscriptions.remove(ply)
            end
        end
    end)
else
    local function toggle(bool)
        net.Start("gfconsole:Subscribe")
            net.WriteBool(bool)
        net.SendToServer()
    end

    gfconsole.buttons.add("Subscribe", function()
        toggle(true)
    end)
    
    gfconsole.buttons.add("Unsubscribe", function()
        toggle(false)
    end)
end