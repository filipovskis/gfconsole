--[[

Author: tochonement
Email: tochonement@gmail.com

12.03.2021

--]]

if CLIENT then
    gfconsole.filter.add("error")
end

if SERVER then
    require("luaerror")

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

    if luaerror then
        local color = Color(230, 25, 25)
        local client = Color(215, 241, 165)
        local server = Color(97, 214, 214)

        luaerror.EnableRuntimeDetour(true)

        luaerror.EnableCompiletimeDetour(true)

        luaerror.EnableClientDetour(true)

        hook.Add("LuaError", "gfconsole.Print", function(isruntime, fullerror, sourcefile, sourceline, errorstr, stack)
            gfconsole.send("error", color, "[ERROR] ", server, errorstr, parse_stack(stack), "\n")
        end)

        hook.Add("ClientLuaError", "gfconsole.Print", function(ply, fullerror)
            gfconsole.send("error", color, "[ERROR] (", ply:Name(), ") ", client, fullerror, "\n")
        end)
    end
end