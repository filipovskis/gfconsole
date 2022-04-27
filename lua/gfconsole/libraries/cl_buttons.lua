--[[

Author: tochonement
Email: tochonement@gmail.com

12.03.2021

--]]

gfconsole.buttons = {}

local buttons = gfconsole.buttons
local storage = {}

function buttons.add(name, func)
    for _, data in ipairs(storage) do
        if data.name == name then
            data.func = func
            return
        end
    end

    table.insert(storage, {
        name = name,
        func = func
    })
end

function buttons.exist(name)
    for _, data in ipairs(storage) do
        if data.name == name then
            return true
        end
    end

    return false
end

function buttons.get()
    return storage
end