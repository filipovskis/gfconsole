--[[

Author: tochonement
Email: tochonement@gmail.com

13.03.2021

--]]

if CLIENT then
    gfconsole.buttons.add("Input", function()
        Derma_StringRequest("Send command to a server", "Input a command", "", function(text)
            net.Start("gfconsole.execute:Send")
                net.WriteString(text)
            net.SendToServer()
        end)
    end)
end

if SERVER then
    util.AddNetworkString("gfconsole.execute:Send")

    local can_access = gfconsole.config.can_execute

    net.Receive("gfconsole.execute:Send", function(len, ply)
        if can_access(ply) then
            local text = net.ReadString()
            local arguments = string.Explode(" ", text)
            local cmd = arguments[1]

            table.remove(arguments, 1)

            if cmd == "echo" then
                Msg(unpack(arguments))
                Msg("\n")
            else
                RunConsoleCommand(cmd, unpack(arguments))
            end
        end
    end)
end