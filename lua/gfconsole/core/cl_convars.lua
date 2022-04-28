--[[

Author: tochonement
Email: tochonement@gmail.com

12.03.2021

--]]

CreateClientConVar("cl_gfconsole_realm", "both", true, false)
CreateClientConVar("cl_gfconsole_auto_subscribe", "0", true, false)
CreateClientConVar("cl_gfconsole_auto_open", "0", true, false)
CreateClientConVar("cl_gfconsole_timestamps", "0", true, false)
local cvColor = CreateClientConVar("cl_gfconsole_color", "green", true, false)

do
    local function updateColor()
        local color = gfconsole.config.colors[cvColor:GetString()]
        if color then
            gfconsole.config.color = color

            local frame = gfconsole.frame
            if IsValid(frame) then
                frame.header.lblVersion:SetTextColor(color)
                frame.header.lblFps:SetTextColor(color)
                frame.header.lblPing:SetTextColor(color)
            end
        end
    end

    cvars.AddChangeCallback("cl_gfconsole_color", updateColor)
    updateColor()
end