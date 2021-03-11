--[[

Author: tochonement
Email: tochonement@gmail.com

11.03.2021

--]]

PANEL = {}

function PANEL:Init()
    self.control = self:Add("DHorizontalScroller")
    self.control:SetTall(30)
    self.control:SetOverlap(-5)

    self.selector = self:Add("GFConsole.Selector")
    self.selector:SetWide(200)

    self.richtext = self:Add("RichText")

    self.control:AddPanel(self.selector)

    self:AddCheckbox("Print")
    self:AddCheckbox("Msg")
    self:AddCheckbox("Errors")
end

function PANEL:PerformLayout(w, h)
    self.control:Dock(TOP)
    self.control:SetTall(25)

    self.richtext:Dock(FILL)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 100)
    surface.DrawRect(0, 0, w, h)
end

function PANEL:AddCheckbox(text)
    local checkbox = self:Add("GFConsole.Checkbox")
    checkbox:SetText(text)
    
    self.control:AddPanel(checkbox)
end

vgui.Register("GFConsole.Container", PANEL)