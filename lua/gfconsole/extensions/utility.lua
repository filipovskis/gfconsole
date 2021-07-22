--[[

Author: tochonement
Email: tochonement@gmail.com

27.03.2021

--]]

if CLIENT then
    gfconsole.buttons.add("Get position", function()
        local pos = LocalPlayer():GetPos()

        for _, key in ipairs({"x", "y", "z"}) do
            pos[key] = math.Round(pos[key])
        end

        gfconsole.send(nil, color_white, ("Vector(%i, %i, %i)"):format(pos.x, pos.y, pos.z), "\n")
    end)

    gfconsole.buttons.add("Get angle", function()
        local ang = LocalPlayer():GetAngles()

        for _, key in ipairs({"p", "y", "r"}) do
            ang[key] = math.Round(ang[key])
        end

        gfconsole.send(nil, color_white, ("Angle(%i, %i, %i)"):format(ang.p, ang.y, ang.r), "\n")
    end)
end