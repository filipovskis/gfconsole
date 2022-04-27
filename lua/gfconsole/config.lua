--[[

Author: tochonement
Email: tochonement@gmail.com

13.03.2021

--]]

gfconsole.config = {}

local config = gfconsole.config

-- A list of extensions, which will be enabled on start
config.enabled = {
    ["errors"] = true,
    ["execute"] = true,
    ["relay"] = true,
    ["subscriptions"] = true,
    ["utility"] = true,
    ["retry"] = false
}

-- The list of available fonts
config.fonts = {
    "Roboto",
    "Roboto Condensed",
    "Arial",
    "Tahoma",
    "Courier New"
}

-- Accent colors
config.color = Color(39, 174, 96)

-- A customcheck function for access to execute commands
-- Be aware that this is dangerous
config.can_execute = function(ply)
    return ply:IsSuperAdmin()
end

-- A customcheck function for access to be a subscriber
config.can_subscribe = function(ply)
    return ply:IsSuperAdmin()
end