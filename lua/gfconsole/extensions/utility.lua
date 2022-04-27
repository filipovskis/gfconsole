--[[

Author: tochonement
Email: tochonement@gmail.com

27.03.2021

--]]

if SERVER then return end

local color1 = Color(52, 152, 219)
local color2 = Color(142, 68, 173)

gfconsole.buttons.add("Get Pos/Ang", function()
    local pos = LocalPlayer():GetPos()
    local ang = LocalPlayer():GetAngles()

    for _, key in ipairs({"p", "y", "r"}) do
        ang[key] = math.Round(ang[key])
    end

    for _, key in ipairs({"x", "y", "z"}) do
        pos[key] = math.Round(pos[key])
    end

    local vecStr = ("Vector(%i, %i, %i)"):format(pos.x, pos.y, pos.z)
    local angStr = ("Angle(%i, %i, %i)"):format(ang.p, ang.y, ang.r)

    gfconsole.send(nil, color_white, color1, vecStr, ' ', color2, angStr, "\n")
end)