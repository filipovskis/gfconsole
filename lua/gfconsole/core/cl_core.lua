--[[

Author: tochonement
Email: tochonement@gmail.com

12.03.2021

--]]

function gfconsole.show()
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

    gfconsole.show()
end
concommand.Add("gfconsole_reload_frame", gfconsole.reload_frame)

local function toggle(_, cmd)
    local enable = (cmd == "+gfconsole")

    gfconsole.holding = enable

    if enable then
        gfconsole.show()
    end

    gui.EnableScreenClicker(enable)
end
concommand.Add("+gfconsole", toggle)
concommand.Add("-gfconsole", toggle)