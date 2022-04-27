--[[

Author: tochnonement
Email: tochnonement@gmail.com

27/04/2022

--]]

gfconsole.filter = {}
gfconsole.filter.bits = 0

local storage, count = {}, 0

local function count_bits(int)
    return math.floor(math.log(int, 2)) + 1
end

function gfconsole.filter.create(identifier)
    count = count + 1
    local index = count
    local cvName = "cl_gfconsole_show_" .. identifier

    storage[index] = SERVER and identifier or {
        index = index,
        id = identifier,
        cv = CreateClientConVar(cvName, "1", true, false)
    }
    gfconsole.filter.bits = count_bits(count)

    if CLIENT then
        cvars.AddChangeCallback(cvName, function(convar_name, value_old, value_new)
            local frame = gfconsole.frame
            if IsValid(frame) then
                for _, panel in ipairs(frame.panel.control.Panels) do
                    if panel.ClassName == "GFConsole.Checkbox" and panel.cv:GetName() == convar_name then
                        panel:SetValue(tobool(value_new))
                        break
                    end
                end
            end
        end)
    end

    return index
end
gfconsole.filter.add = gfconsole.filter.create

function gfconsole.filter.get(index)
    return storage[index]
end

function gfconsole.filter.get_all()
    return storage
end

function gfconsole.filter.find(identifier)
    for i = 1, count do
        local data = storage[i]
        if SERVER and data == identifier or data.id == identifier then
            return data, i
        end
    end
end

if CLIENT then
    function gfconsole.filter.is_enabled(index)
        return storage[index].cv:GetBool()
    end

    function gfconsole.filter.enable(identifier, bool)
        local filter = gfconsole.filter.find(identifier)
        if filter then
            filter.cv:SetBool(bool)
        end
    end

    function gfconsole.filter.toggle(identifier)
        local filter = gfconsole.filter.find(identifier)
        if filter then
            filter.cv:SetBool(not filter.cv:GetBool())
        end
    end

    hook.Add("gfconsole.CanPass", "gfconsole.Filters", function(index)
        if index then
            return gfconsole.filter.is_enabled(index)
        end
    end)
end