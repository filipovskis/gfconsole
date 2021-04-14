--[[

Author: tochonement
Email: tochonement@gmail.com

27.03.2021

--]]

if CLIENT then
    gfconsole.buttons.add("Get position", function()
        local pos = LocalPlayer():GetPos()
        local ang = LocalPlayer():GetAngles()
        local output
    
        local str_pos = "Vector(%i, %i, %i)"
        local str_ang = "Angle(%i, %i, %i)"
    
        for _, key in ipairs({"x", "y", "z"}) do
            pos[key] = math.Round(pos[key])
        end
    
        for _, key in ipairs({"p", "y", "r"}) do
            ang[key] = math.Round(ang[key])
        end
    
        output = str_pos:format(pos.x, pos.y, pos.z) .. ", " .. str_ang:format(ang.p, ang.y, ang.r)

        gfconsole.send(nil, color_white, output .. "\n")
    end)
end