--[[

Author: tochnonement
Email: tochnonement@gmail.com

14/11/2021

--]]

gfconsole.extension = {}
gfconsole.extension.list = {}

local base_path = "gfconsole/extensions"

function gfconsole.extension:enable(id)
    local path = base_path .. "/" .. id .. ".lua"
    local success = pcall(gfconsole.load.Shared, path)

    if success then
        table.insert(self.list, id)
    end
end

function gfconsole.extension:is_enabled(id)
    for _, id2 in ipairs(self.list) do
        if id == id2 then
            return true
        end
    end

    return false
end

function gfconsole.extension:find_all()
    local files = file.Find(base_path .. "/*", "LUA")
    local result = {}

    for _, f in ipairs(files) do
        local name = string.Explode(".", f)[1]

        if name then
            table.insert(result, name)
        end
    end

    return result
end

function gfconsole.extension:init()
    local available = self:find_all()

    for _, id in ipairs(available) do
        if gfconsole.config.enabled[id] then
            self:enable(id)
        end
    end
end