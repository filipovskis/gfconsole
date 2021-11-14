--[[

Author: tochnonement
Email: tochnonement@gmail.com

14/11/2021

--]]

hook.Add("InitPostEntity", "gfconsole.AutoSubscribe", function()
    if GetConVar("gfconsole_autocreate"):GetBool() then
        gfconsole.show()
    end

    if GetConVar("gfconsole_autosubcribe"):GetBool() then
        net.Start("gfconsole:Subscribe")
            net.WriteBool(true)
        net.SendToServer()
    end
end)