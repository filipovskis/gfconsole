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