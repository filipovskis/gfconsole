--[[

Author: tochonement
Email: tochonement@gmail.com

11.03.2021

--]]

PANEL = {}

function PANEL:Init()
    self.header = self:Add("GFConsole.Header")

    self.panel = self:Add("GFConsole.Container")
end

function PANEL:PerformLayout(w, h)
    self:DockPadding(5, 5, 5, 5)

    self.header:Dock(TOP)
    self.header:SetTall(30)

    self.panel:DockMargin(0, 5, 0, 0)
    self.panel:Dock(FILL)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(0, 0, w, h)
end

vgui.Register("GFConsole", PANEL, "EditablePanel")