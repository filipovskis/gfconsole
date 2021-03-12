--[[

Author: tochonement
Email: tochonement@gmail.com

12.03.2021

--]]

if SERVER then
    util.AddNetworkString("gfconsole:Send")

    local function get_recipients()
        local all = player.GetAll()
        local recipients = {}

        for _, ply in ipairs(all) do
            local can = hook.Run("gfconsole.CanReceiveMessage", ply)
            if can ~= false then
                table.insert(recipients, ply)
            end
        end

        return recipients
    end
    
    function gfconsole.send(filter, ...)
        local recipients = get_recipients()

        if table.IsEmpty(recipients) then
            return
        end

        local packet = gfconsole.net.CreatePacket("gfconsole:Send")
            packet:String(filter or "")
            packet:Table({...})
            packet:AddTargets(recipients)
        packet:Send()
    end

    gfconsole.send(nil, Color(155, 255, 255), "Hello 2")
else
    local function add(from_server, filter, ...)
        local should_receive = hook.Run("gfconsole.CanPass", filter)
        local arguments = {...}

        if should_receive == false then
            return
        end

        gfconsole.search_panel("GFConsole.Container", function(panel)
            panel:AddRecord(unpack(arguments))
        end)
    end

    function gfconsole.send(filter, ...)
        add(false, filter, ...)
    end

    gfconsole.net.Watch("gfconsole:Send", function(packet)
        local filter = packet:String()
        local arguments = packet:Table()

        add(true, filter, unpack(arguments))
    end, gfconsole.net.OPTION_WATCH_OVERRIDE)
end