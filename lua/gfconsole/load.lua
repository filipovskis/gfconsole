--[[

Author: tochonement
Email: tochonement@gmail.com

11.03.2021

--]]

local load = {}

local function include_cl(path)
    if SERVER then
        AddCSLuaFile(path)
    else
        return include(path)
    end
end

local function include_sv(path)
    if SERVER then
        return include(path)
    end
end

local function include_sh(path)
    if SERVER then
        AddCSLuaFile(path)
        return include(path)
    else
        return include(path)
    end
end

local function include_tbl(tbl)
    for _, f in ipairs(tbl.shared) do
        include_sh(f .. ".lua")
    end

    for _, f in ipairs(tbl.server) do
        include_sv(f .. ".lua")
    end

    for _, f in ipairs(tbl.client) do
        include_cl(f .. ".lua")
    end
end

return {
    client = include_cl,
    server = include_sv,
    shared = include_sh,
    table = include_tbl
}