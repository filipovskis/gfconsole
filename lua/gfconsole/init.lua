--[[

Author: tochonement
Email: tochonement@gmail.com

11.03.2021

--]]

local extensions_path = "gfconsole/extensions/"
local load = include("load.lua")

gfconsole.load = load
gfconsole.net = load.shared("libraries/thirdparty/sh_vnet.lua")
gfconsole.extensions = {}

load.table({
    shared = {
        "libraries/thirdparty/sh_panel_search",
        "libraries/sh_message",
        "config"
    },
    server = {
        "libraries/sv_subscriptions",
        "sv_safe"
    },
    client = {
        "libraries/cl_buttons",
        "libraries/cl_filter",
        "cl_convars",
        "cl_fonts",
        "cl_menu",
        "vgui/button",
        "vgui/checkbox",
        "vgui/selector",
        "vgui/header",
        "vgui/container",
        "vgui/console"
    }
})

-- Do not forget to enable extension in config.lua

for _, extension in ipairs(file.Find(extensions_path .. "*", "LUA")) do
    local name = string.Explode(".", extension)[1]

    if gfconsole.config.enabled[name] then
        load.shared(extensions_path .. extension)

        gfconsole.extensions[name] = true
    end
end