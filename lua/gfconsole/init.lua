--[[

Author: tochonement
Email: tochonement@gmail.com

11.03.2021

--]]

local extensions_path = "gfconsole/extensions/"

gfconsole.extensions = {}

gfconsole.load.Shared("config.lua")
gfconsole.load.Folder("gfconsole/libraries/thirdparty")
gfconsole.load.Folder("gfconsole/libraries")
gfconsole.load.Folder("gfconsole/core/derma")
gfconsole.load.Folder("gfconsole/core")

-- Do not forget to enable extension in config.lua

for _, extension in ipairs(file.Find(extensions_path .. "*", "LUA")) do
    local name = string.Explode(".", extension)[1]

    if gfconsole.config.enabled[name] then
        gfconsole.load.Shared(extensions_path .. extension)

        gfconsole.extensions[name] = true
    end
end