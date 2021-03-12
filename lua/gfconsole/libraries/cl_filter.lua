--[[

Author: tochonement
Email: tochonement@gmail.com

12.03.2021

--]]

gfconsole.filter = {}

local name = "gfconsole_filter_%s"
local filter = gfconsole.filter
local storage = {}

local function get(id)
    return GetConVar(name:format(id))
end

function filter.add(id)
    id = string.lower(id)

    CreateClientConVar(name:format(id), "1", true, false)

    table.insert(storage, id)
end

function filter.toggle(id)
    id = string.lower(id)

    local current = filter.check(id)
    
    filter.enable(id, not current)
end

function filter.enable(id, bool)
    id = string.lower(id)

    get(id):SetBool(bool)
end

function filter.get()
    return storage
end

function filter.exist(id)
    for _, id2 in ipairs(storage) do
        if id == id2 then
            return true
        end
    end

    return false
end

function filter.check(id)
    id = string.lower(id)

    if filter.exist(id) then
        return get(id):GetBool()
    end
end

hook.Add("gfconsole.CanPass", "gfconsole.Filters", function(id)
    if id then
        if filter.check(id) == true then
            return false
        end
    end
end)