--[[

Author: tochonement
Email: tochonement@gmail.com

13.03.2021

--]]

gfconsole.config = {}

local config = gfconsole.config

-- Enabled extensions
config.enabled = {
    ["errors"] = true,
    ["execute"] = true,
    ["override"] = true,
    ["subscriptions"] = true,
    ["utility"] = true,
}

-- Can execute commands to a server console
config.can_execute = function(ply)
    return ply:IsSuperAdmin()
end

-- Can subscribe to listen server events (print, errors, etc.)
config.can_subscribe = function(ply)
    return ply:IsSuperAdmin()
end