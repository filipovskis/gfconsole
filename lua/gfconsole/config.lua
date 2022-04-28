--[[

Author: tochonement
Email: tochonement@gmail.com

13.03.2021

--]]

gfconsole.config = {}

local config = gfconsole.config

-- The list of extensions, which will be enabled on start
config.enabled = {
    ["errors"]          = true,
    ["execute"]         = true,
    ["relay"]           = true,
    ["subscriptions"]   = true,
    ["utility"]         = true,
    ["bot"]             = true,
    ["retry"]           = false
}

-- The list of colors
config.colors = {
    green = Color(39, 174, 96),
    blue = Color(52, 152, 219),
    watermelon = Color(255, 107, 129),
    coral = Color(255, 127, 80),
    sky = Color(83, 82, 237),
    amethyst = Color(155, 89, 182),
    turqoise = Color(26, 188, 156)
}

-- The list of available fonts
config.fonts = {
    "Roboto",
    "Roboto Condensed",
    "Arial",
    "Tahoma",
    "Courier New"
}

-- The accent color
config.color = Color(39, 174, 96)

-- (DANGEROUS) The customcheck function for access to execute commands
config.can_execute = function(ply)
    return ply:IsSuperAdmin()
end

-- The customcheck function for access to be a subscriber
-- If "subscriptions" extension is disabled it will determine whether player can receive messages or not
config.can_subscribe = function(ply)
    return ply:IsSuperAdmin()
end