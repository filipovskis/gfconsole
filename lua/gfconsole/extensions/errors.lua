--[[

Author: tochonement
Email: tochonement@gmail.com

12.03.2021

--]]

gfconsole.FILTER_ERRORS = gfconsole.FILTER_ERRORS or gfconsole.filter.create("Errors")

if CLIENT then return end

local sys_arch = string.sub(jit.arch, 2):gsub("86", "32")
local dll_name = "gm" .. (CLIENT and "cl" or "sv") .. "_luaerror_" .. (system.IsWindows() and ("win" .. sys_arch) or system.IsLinux() and ("linux" .. sys_arch) or "osx") .. ".dll"
local dll_exists = file.Exists("lua/bin/" .. dll_name, "MOD")

if not dll_exists then
    ErrorNoHalt("[GFConsole] \"Errors\" extension cannot start, because there's no valid \"luaerror\" module\n")
    return
end

require("luaerror")

local color = Color(230, 25, 25)
local client = Color(215, 241, 165)
local server = Color(97, 214, 214)
local stack_line = "%i. %s - %s:%i"

local function parse_stack(stack)
    local spaces = "\n  "
    local tbl = {}
    local counter = 1
    local parsed = ""

    for _, data in ipairs(stack) do
        local name = data.name
        local empty_name = data.name == ""
        local source = data.source

        source = string.Replace(source, "=", "")
        source = string.Replace(source, "@", "")

        if empty_name and source == "[C]" then
            goto skip
        end

        table.insert(tbl, stack_line:format(counter, (empty_name and "unknown" or name), source, data.lastlinedefined))

        counter = counter + 1

        ::skip::
    end

    for _, str in ipairs(tbl) do
        parsed = parsed .. spaces .. str
        spaces = spaces .. " "
    end

    return parsed
end

luaerror.EnableRuntimeDetour(true)
luaerror.EnableCompiletimeDetour(true)
luaerror.EnableClientDetour(true)

hook.Add("LuaError", "gfconsole.Print", function(isruntime, fullerror, sourcefile, sourceline, errorstr, stack)
    gfconsole.send(gfconsole.FILTER_ERRORS, color, "[ERROR] ", server, fullerror, parse_stack(stack), "\n")
end)

hook.Add("ClientLuaError", "gfconsole.Print", function(ply, fullerror)
    gfconsole.send(gfconsole.FILTER_ERRORS, color, "[ERROR] (", ply:Name(), ") ", client, fullerror, "\n")
end)