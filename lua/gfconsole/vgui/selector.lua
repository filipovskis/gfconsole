--[[

Author: tochonement
Email: tochonement@gmail.com

12.03.2021

--]]

PANEL = {}

function PANEL:Init()
    self:AddOption("Client")
    self:AddOption("Server")
    self:AddOption("Both")
end

function PANEL:PerformLayout(w, h)
    local children = self:GetChildren()
    local wide = w / #children

    for _, panel in ipairs(children) do
        panel:SetWide(wide)
    end
end

function PANEL:PaintOver(w, h)
    surface.SetDrawColor(0, 0, 0, 230)
    surface.DrawOutlinedRect(0, 0, w, h, 1)
end

-- Custom methods

function PANEL:AddOption(text)
    local button = self:Add("DButton")
    button:SetText(text)
    button:SetTextColor(color_white)
    button:SetFont("gfconsole.Button")
    button:Dock(LEFT)
    button.Paint = function(panel, w, h)
        if panel.Active then
            surface.SetDrawColor(49, 181, 255)
        else
            surface.SetDrawColor(78, 84, 96)
        end
        surface.DrawRect(0, 0, w, h)
    end
    button.DoClick = function(panel)
        self:SelectOption(panel)
    end
end

function PANEL:SelectOption(panel)
    for _, child in ipairs(self:GetChildren()) do
        child.Active = false 
    end

    panel.Active = true
end

vgui.Register("GFConsole.Selector", PANEL)