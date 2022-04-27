--[[

Author: tochonement
Email: tochonement@gmail.com

12.03.2021

--]]

PANEL = {}

AccessorFunc(PANEL, "value", "Value")

function PANEL:Init()
    self:SetFont("gfconsole.Button")
    self:SetTextColor(color_white)
    self:SetValue(false)
    self:SetExpensiveShadow(1, color_black)
end

function PANEL:Paint(w, h)
    if self:IsHovered() then
        surface.SetDrawColor(114, 123, 139)
    else
        surface.SetDrawColor(78, 84, 96)
    end

    surface.DrawRect(0, 0, w, h)

    if self.value then
        surface.SetDrawColor(gfconsole.config.color)
        surface.DrawRect(0, h - 2, w, 2)
    end

    surface.SetDrawColor(0, 0, 0, 230)
    surface.DrawOutlinedRect(0, 0, w, h, 1)
end

function PANEL:DoClick()
    self:Toggle()
end

function PANEL:Toggle()
    local new = not self.value

    self.value = new

    if (self.OnChange) then
        self:OnChange(new)
    end
end

vgui.Register("GFConsole.Checkbox", PANEL, "DButton")