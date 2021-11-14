--[[

Author: tochonement
Email: tochonement@gmail.com

13.05.2021

--]]

local load = {}

function load.Server(path)
    if SERVER then
        return include(path)
    end
end

function load.Client(path)
    if SERVER then
        AddCSLuaFile(path)
    else
        return include(path)
    end
end

function load.Shared(path)
    if SERVER then
        AddCSLuaFile(path)
        return load.Server(path)
    else
        return load.Client(path)
    end
end

function load.Auto(path, ignore)
    local prefix = string.match(path, "/(%l+)_")

    if prefix then
        if prefix == "sv" then
            return load.Server(path)
        elseif prefix == "cl" then
            return load.Client(path)
        elseif prefix == "sh" then
            return load.Shared(path)
        end
    else
        if (not ignore) then
            error("No prefix found")
        end
    end
end

function load.Folder(path, recursive, ignore)
    local parsedPath = path .. "/"
    local files, folders = file.Find(parsedPath .. "*", "LUA")

    for _, f in ipairs(files) do
        if string.Right(f, 4) == ".lua" and f ~= "sh_load.lua" then
            load.Auto(parsedPath .. f, ignore)
        end
    end

    if recursive then
        for _, f in ipairs(folders) do
            load.Folder(path .. "/" .. f, true, ignore)
        end
    end
end

gfconsole.load = load