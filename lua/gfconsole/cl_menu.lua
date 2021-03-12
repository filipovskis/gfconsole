--[[

Author: tochonement
Email: tochonement@gmail.com

12.03.2021

--]]

local function show()
    if gfconsole.frame then
        return
    end

    local frame = vgui.Create("GFConsole")
    frame:SetSize(ScrW(), ScrH() * .25)
    frame.y = 100
    
    gfconsole.frame = frame
end

local function toggle(_, cmd)
    if cmd == "+gfconsole" then
        gui.EnableScreenClicker(true)
        show()
    else
        gui.EnableScreenClicker(false)
    end
end
concommand.Add("+gfconsole", toggle)
concommand.Add("-gfconsole", toggle)