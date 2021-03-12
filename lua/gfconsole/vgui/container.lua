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
    self.selector:AddConvar("gfconsole_realm", {
        {"client", "Client"},
        {"server", "Server"},
        {"both", "Both"}
    })

    self.richtext = self:Add("RichText")
    self.richtext.PerformLayout = function(panel)
        panel:SetFontInternal("gfconsole.Text")
    end

    self.control:AddPanel(self.selector)

    self:LoadButtons()
    self:LoadFilters()
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

function PANEL:AddCheckbox(text, bool, func)
    local checkbox = vgui.Create("GFConsole.Checkbox")
    checkbox:SetText(text)
    checkbox:SetValue(bool)
    checkbox.OnChange = function(panel, bool)
        func(bool)
    end
    
    self.control:AddPanel(checkbox)
end

function PANEL:AddRecord(...)
    for _, object in ipairs({...}) do
        if isstring(object) then
            self.richtext:AppendText(object)
        else
            self.richtext:InsertColorChange(object.r, object.g, object.b, object.a)
        end
    end
end

function PANEL:LoadButtons()
    for _, data in pairs(gfconsole.buttons.get()) do
        local button = vgui.Create("gfconsole.Button")
        button:SetText(data.name)
        button:SizeToContentsX(10)
        button.DoClick = function()
            data.func()
        end

        self.control:AddPanel(button)
    end
end

function PANEL:LoadFilters()
    for _, id in ipairs(gfconsole.filter.get()) do
        self:AddCheckbox(id, not gfconsole.filter.check(id), function()
            gfconsole.filter.toggle(id)
        end)
    end 
end

vgui.Register("GFConsole.Container", PANEL)