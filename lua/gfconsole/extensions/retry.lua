--[[

Author: tochnonement
Email: tochnonement@gmail.com

14/11/2021

--]]

if CLIENT then return end

local success = pcall(require, "luaerror")

if not success then
    return
end

local function retry(ply, file)
    if not ply:GetVar("gfconsole_RetryCalled", false) then
        gfconsole.SendWinNotify(ply, "Trying to load a new file: " .. file)

        ply:ConCommand("retry")
        ply:SetVar("gfconsole_RetryCalled", true)
    end
end

hook.Add("ClientLuaError", "gfconsole.ext.retry", function(ply, fullerror)
    local f = string.match(fullerror, "%b''", 10):gsub("\\", "/")
    local path = string.match(fullerror, "@[%w./%[%]_]+")
    local where = string.match(path, "%w+")
    local fName = string.match(f, "[%w._]+.lua")
    local exists = false

    f = string.gsub(f, "'", "")
    path = string.sub(path, 2)

    if (where == "addons" or where == "gamemodes") then
        -- Check globally
        if file.Exists(f, "LUA") then
            exists = true
            goto process
        end

        -- Check relatively
        local rpath = string.Explode("/", path)
        rpath[#rpath] = f
        rpath = table.concat(rpath, "/")

        if file.Exists(rpath, "LUA") then
            exists = true
        end
    end

    ::process::

    if exists then
        retry(ply, fName)
    end
end)