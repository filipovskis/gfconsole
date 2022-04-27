--[[

Author: tochonement
Email: tochonement@gmail.com

12.03.2021

--]]

local function scale(int)
    return math.ceil(int / 900 * ScrH())
end

surface.CreateFont("gfconsole.Title", {
    font = "Roboto Medium",
    size = scale(18),
    extended = true
})

surface.CreateFont("gfconsole.Button", {
    font = "Roboto",
    size = scale(16),
    extended = true
})

surface.CreateFont("gfconsole.Text", {
    font = "Roboto",
    shadow = true,
    size = scale(16),
    extended = true
})

surface.CreateFont("gfconsole.Text.underline", {
    font = "Roboto",
    size = scale(16),
    shadow = true,
    extended = true,
    italic = true
})