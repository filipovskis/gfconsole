--[[

Author: tochonement
Email: tochonement@gmail.com

12.03.2021

--]]

local function scale(int)
    return math.ceil(int / 900 * ScrH())
end

local function initFonts()
    surface.CreateFont("gfconsole.Title", {
        font = "Roboto Bold",
        size = scale(18),
        extended = true
    })

    surface.CreateFont("gfconsole.Button", {
        font = "Roboto",
        size = scale(16),
        extended = true
    })

    surface.CreateFont("gfconsole.Tiny", {
        font = "Roboto",
        size = scale(14),
        extended = true
    })
end
initFonts()

local buildFont do
    local cvFontFamily = CreateClientConVar("cl_gfconsole_font_family", "Roboto")
    local cvFontSize = CreateClientConVar("cl_gfconsole_font_size", "16")
    local cvFontShadow = CreateClientConVar("cl_gfconsole_font_shadow", "1")

    function buildFont()
        local family = cvFontFamily:GetString()
        local size = scale(cvFontSize:GetInt())
        local shadow = cvFontShadow:GetBool()

        surface.CreateFont("gfconsole.Text", {
            font = family,
            size = size,
            shadow = shadow,
            extended = true
        })

        surface.CreateFont("gfconsole.Text.underline", {
            font = family,
            size = size,
            shadow = shadow,
            extended = true,
            italic = true
        })
    end

    buildFont()
    cvars.AddChangeCallback("cl_gfconsole_font_family", buildFont)
    cvars.AddChangeCallback("cl_gfconsole_font_size", buildFont)
    cvars.AddChangeCallback("cl_gfconsole_font_shadow", buildFont)
end

hook.Add("OnScreenSizeChanged", "gfconsole.UpdateFonts", function()
    initFonts()
    buildFont()
end)