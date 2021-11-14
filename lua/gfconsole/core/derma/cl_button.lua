--[[

Author: tochonement
Email: tochonement@gmail.com

12.03.2021

--]]

PANEL = {}

function PANEL:Init()
    self:SetTextColor(color_white)
    self:SetFont("gfconsole.Button")
end

function PANEL:Paint(w, h)
    if self:IsHovered() then
        surface.SetDrawColor(114, 123, 139)
    else
        surface.SetDrawColor(78, 84, 96)
    end
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(0, 0, 0, 230)
    surface.DrawOutlinedRect(0, 0, w, h, 1)
end

vgui.Register("gfconsole.Button", PANEL, "DButton")