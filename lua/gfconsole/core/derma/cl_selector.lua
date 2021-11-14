--[[

Author: tochonement
Email: tochonement@gmail.com

12.03.2021

--]]

PANEL = {}

function PANEL:PerformLayout(w, h)
    local children = self:GetChildren()
    local wide = w / #children

    for _, panel in ipairs(children) do
        panel:SetWide(wide)
    end
end

function PANEL:PaintOver(w, h)
    surface.SetDrawColor(0, 0, 0, 230)
    surface.DrawOutlinedRect(0, 0, w-1, h, 1)
end

-- Custom methods

function PANEL:AddConvar(name, options)
    local convar = GetConVar(name)
    local current = convar:GetString()

    for _, data in ipairs(options) do
        local id = data[1]
        local name = data[2]

        local option = self:AddOption(name, function()
            convar:SetString(id)
        end)

        if id == current then
            self:SelectOption(option)
        end
    end
end

function PANEL:AddOption(text, func)
    local button = self:Add("DButton")
    button:SetText(text)
    button:SetTextColor(color_white)
    button:SetFont("gfconsole.Button")
    button:Dock(LEFT)
    button.Paint = function(panel, w, h)
        if panel.Active then
            surface.SetDrawColor(49, 181, 255)
        else
            surface.SetDrawColor(0, 0, 0, 200)
        end
        surface.DrawRect(0, 0, w, h)
    end
    button.DoClick = function(panel)
        self:SelectOption(panel)
        func()
    end

    return button
end

function PANEL:SelectOption(panel)
    for _, child in ipairs(self:GetChildren()) do
        child:SetTextColor(color_white)
        child.Active = false
    end

    panel:SetTextColor(color_black)
    panel.Active = true
end

vgui.Register("GFConsole.Selector", PANEL)