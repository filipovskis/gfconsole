--[[

Author: tochonement
Email: tochonement@gmail.com

12.03.2021

--]]

function gfconsole.show()
    if IsValid(gfconsole.frame) then
        return
    end

    gfconsole.frame = vgui.Create("GFConsole")
end

function gfconsole.close()
    local frame = gfconsole.frame

    if IsValid(frame) then
        frame:Remove()
    end
end
concommand.Add("gfconsole_close", gfconsole.close)

function gfconsole.reload_frame()
    local frame = gfconsole.frame

    if IsValid(frame) then
        frame:Remove()
    end

    gfconsole.show()
end
concommand.Add("gfconsole_reload", gfconsole.reload_frame)

local function toggle(_, cmd)
    local enable = (cmd == "+gfconsole")

    gfconsole.holding = enable

    if enable then
        gfconsole.show()
    end

    gui.EnableScreenClicker(enable)
end
concommand.Add("+gfconsole", toggle)
concommand.Add("-gfconsole", toggle)

do
    local function title(list, text)
        local label = list:Add('DLabel')
        label:SetText(text:upper())
        label:SetFont('gfconsole.Title')
        label:SetTextColor(color_white)
        label:SetExpensiveShadow(2, color_black)
        label:SetContentAlignment(5)
        label:Dock(TOP)
        label:DockMargin(0, 0, 0, ScreenScale(2))

        return label
    end

    local function checkbox(list, text, cvar)
        local label = list:Add('DCheckBoxLabel')
        label:SetText(text)
        label:SetFont('gfconsole.Title')
        label:Dock(TOP)
        label:DockMargin(0, 0, 0, ScreenScale(2))
        label:SetConVar(cvar:GetName())

        return label
    end

    local function button(list, text, fn)
        local btn = list:Add('DButton')
        btn:SetText(text)
        btn:Dock(TOP)
        btn:DockMargin(0, 0, 0, ScreenScale(2))
        btn.DoClick = function()
            fn()
        end

        return btn
    end

    function gfconsole.show_settings()
        local frame = vgui.Create('DFrame')
        frame:SetTitle('GFConsole Settings')
        frame:SetSize(ScrW() * .25, ScrH() * .5)
        frame:SetIcon('icon16/cog.png')
        frame:Center()
        frame:MakePopup()

        local plist = frame:Add('DScrollPanel')
        plist:Dock(FILL)

        title(plist, 'Filters')

        for _, filter in ipairs(gfconsole.filter.get_all()) do
            checkbox(plist, 'Show: ' .. filter.id, filter.cv)
        end

        title(plist, 'Frame')
        checkbox(plist, 'Automatically create console on join', GetConVar('gfconsole_autocreate'))
        checkbox(plist, 'Automatically subscribe on join', GetConVar('gfconsole_autosubcribe'))

        title(plist, 'Font')
        do
            local cv = GetConVar('gfconsole_font_family')
            local found = false

            local combo = plist:Add('DComboBox')
            combo:Dock(TOP)
            combo:DockMargin(0, 0, 0, ScreenScale(2))

            for _, family in ipairs(gfconsole.config.fonts) do
                local index = combo:AddChoice(family)
                if cv:GetString() == family then
                    combo:ChooseOptionID(index)
                    found = true
                end
            end

            combo.OnSelect = function(p, index, value)
                cv:SetString(value)
            end

            if not found then
                combo:SetText(cv:GetString())
            end

            local slider = plist:Add('DNumSlider')
            slider:SetText('Size')
            slider:SetDecimals(0)
            slider:SetMin(14)
            slider:SetMax(64)
            slider:SetConVar('gfconsole_font_size')
            slider:Dock(TOP)
            slider:DockMargin(0, 0, 0, ScreenScale(2))

            checkbox(plist, 'Shadow', GetConVar('gfconsole_font_shadow'))
        end

        title(plist, 'Actions')
        button(plist, 'Reload Console', function()
            gfconsole.reload_frame()
        end)
        button(plist, 'Close Console', function()
            gfconsole.close()
        end)

        return frame
    end
    concommand.Add('gfconsole_settings', gfconsole.show_settings)
end