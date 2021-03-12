--[[

Author: tochonement
Email: tochonement@gmail.com

12.03.2021

--]]

gfconsole.buttons = {}

local buttons = gfconsole.buttons
local storage = {}

function gfconsole.buttons.add(name, func)
    storage[name] = func
end

function gfconsole.buttons.get()
    return storage
end