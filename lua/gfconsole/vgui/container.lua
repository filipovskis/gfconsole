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
        panel:SetUnderlineFont("gfconsole.Text.underline")
    end
    self.richtext.ActionSignal = function(panel, name, value)
        if name == "TextClicked" then
            local for_copy = string.match(value, "%b@@")
            if for_copy then
                for_copy = for_copy:Replace("@", "")

                SetClipboardText(for_copy)

                notification.AddLegacy("Copied to clipboard!", 0, 2)
            end
        end
    end

    self.control:AddPanel(self.selector)

    self:AddButton("Clear", function()
        self.richtext:SetText("")
    end)

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
            if object:match("Vector") then
                self.richtext:InsertClickableTextStart("@" .. object.. "@")
                    self.richtext:AppendText(object)
                self.richtext:InsertClickableTextEnd()
            elseif object:match("Angle") then
                self.richtext:InsertClickableTextStart("@" .. object.. "@")
                    self.richtext:AppendText(object)
                self.richtext:InsertClickableTextEnd()
            else
                self.richtext:AppendText(object)
            end
        else
            self.richtext:InsertColorChange(object.r, object.g, object.b, object.a)
        end
    end
end

function PANEL:AddButton(name, func)
    local button = vgui.Create("gfconsole.Button")
    button:SetText(name)
    button:SizeToContentsX(10)
    button.DoClick = function()
        func()
    end

    self.control:AddPanel(button)
end

function PANEL:LoadButtons()
    for _, data in pairs(gfconsole.buttons.get()) do
        self:AddButton(data.name, data.func)
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