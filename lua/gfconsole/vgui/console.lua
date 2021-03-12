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

function PANEL:Think()
    self:ResizeController()
end

-- Custom methods

function PANEL:ResizeController()
    local x, y = self:GetRelativeToCursor()
    local w, h = self:GetSize()

    if x > (w - 8) and y > (h - 8) then
        self.resizable = input.IsMouseDown(MOUSE_LEFT)
        self:SetCursor("sizenwse")
    else
        self:SetCursor("cursor")
    end

    if self.resizable then
        self:SetSize(x, y)
    end
end

function PANEL:GetRelativeToCursor()
    local x, y = self:LocalToScreen(0, 0)
    local x2, y2 = input.GetCursorPos()

    return (x2 - x), (y2 - y)
end

vgui.Register("GFConsole", PANEL, "EditablePanel")