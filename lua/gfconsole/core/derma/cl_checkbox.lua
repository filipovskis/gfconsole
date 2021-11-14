--[[

Author: tochonement
Email: tochonement@gmail.com

12.03.2021

--]]

local mat = Material("icon16/tick.png")

-- PANEL = {}

-- function PANEL:Init()
--     self.Label:SetFont("gfconsole.Button")
--     self.Label:SetContentAlignment(4)
--     self.Label:SetTextColor(color_white)
-- end

-- function PANEL:PerformLayout(w, h)
--     self.BaseClass.PerformLayout(self, w, h)

--     self.Label:SetTall(h)
-- end

-- function PANEL:ApplySchemeSettings()
--     self.Button.Paint = function(panel, w, h)
--         surface.SetDrawColor(78, 84, 96)
--         surface.DrawRect(0, 0, w, h)

--         if panel:GetChecked() then
--             surface.SetMaterial(mat)
--             surface.SetDrawColor(255, 255, 255)
--             surface.DrawTexturedRect(0, 0, 16, 16)
--         end

--         surface.SetDrawColor(0, 0, 0, 230)
--         surface.DrawOutlinedRect(0, 0, w, h, 1)
--     end
-- end

-- vgui.Register("GFConsole.Checkbox", PANEL, "DCheckBoxLabel")

PANEL = {}

AccessorFunc(PANEL, "value", "Value")

function PANEL:Init()
    self:SetFont("gfconsole.Button")
    self:SetTextColor(color_white)
    self:SetValue(false)
end

function PANEL:Paint(w, h)
    if self:IsHovered() then
        surface.SetDrawColor(114, 123, 139)
    else
        surface.SetDrawColor(78, 84, 96)
    end

    surface.DrawRect(0, 0, w, h)

    if self.value then
        surface.SetDrawColor(49, 181, 255)
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