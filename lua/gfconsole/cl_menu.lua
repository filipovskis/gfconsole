--[[

Author: tochonement
Email: tochonement@gmail.com

12.03.2021

--]]

local function show()
    if IsValid(gfconsole.frame) then
        return 
    end

    gfconsole.frame = vgui.Create("GFConsole")
end

function gfconsole.reload_frame()
    local frame = gfconsole.frame

    if IsValid(frame) then
        frame:Remove()
    end

    show()
end

hook.Add("InitPostEntity", "gfconsole.AutoSubscribe", function()
    if GetConVar("gfconsole_auto_create") then
        show()
    end

    if GetConVar("gfconsole_auto_subcribe"):GetBool() then
        net.Start("gfconsole:Subscribe")
            net.WriteBool(true)
        net.SendToServer()
    end
end)

local function toggle(_, cmd)
    if cmd == "+gfconsole" then
        show()
        gui.EnableScreenClicker(true)
    else
        gui.EnableScreenClicker(false)
    end
end
concommand.Add("+gfconsole", toggle)
concommand.Add("-gfconsole", toggle)