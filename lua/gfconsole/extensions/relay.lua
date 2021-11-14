--[[

Author: tochonement
Email: tochonement@gmail.com

22.07.2021

--]]

local GLOBAL = _G
local send = gfconsole.send
local color = Color(214, 70, 142)

local color_client = Color(255, 221, 102)
local color_server = Color(156, 221, 255, 255)

OldPrint = OldPrint or GLOBAL.print
OldMsg = OldMsg or GLOBAL.Msg
OldMsgC = OldMsgC or GLOBAL.MsgC
OldPrintTable = OldPrintTable or GLOBAL.PrintTable

if CLIENT then
    gfconsole.filter.add("print")
    gfconsole.filter.add("msg")
end

local function send_with_space(filter, ...)
    send(filter, ...)
    send(filter, "\n")
end

-- ANCHOR Utility

local translate do
    local translators = {
        ["Vector"] = function(object)
            return string.format("Vector(%i, %i, %i)", object.x, object.y, object.z)
        end,
        ["Color"] = function(object)
            return string.format("Color(%i, %i, %i, %i)", object.r, object.g, object.b, object.a)
        end,
        ["Angle"] = function(object)
            return string.format("Angle(%i, %i, %i)", object.p, object.y, object.r)
        end
    }

    local function is_color(tbl)
        local found = 0

        for _, key in ipairs({"r", "g", "b", "a"}) do
            if tbl[key] then
                found = found + 1
            end
        end

        return (found == 4)
    end

    function translate(any)
        local type = type(any)
        local translator = translators[type]

        if translator then
            return translator(any)
        else
            if type == "table" and is_color(any) then
                return translators["Color"](any)
            else
                return tostring(any)
            end
        end
    end
end

local function parse_args(separator, ...)
    local translated = {}
    local count = select("#", ...)

    for i = 1, count do
        local value = select(i, ...)

        if value == nil then
            table.insert(translated, "nil")
        else
            table.insert(translated, translate(value))
        end

        if separator and i < count then
            table.insert(translated, separator)
        end
    end

    return unpack(translated)
end

-- ANCHOR Override

local function new_print(...)
    OldPrint(...)

    local info = debug.getinfo(2)

    if not info then
        send_with_space("print", color_white, parse_args("  ", ...))
        return
    end

    local prefix = ""
    local src = info.short_src
    local exploded = string.Explode("/", src)

    prefix = exploded[#exploded]
    prefix = prefix .. ":"  .. info.linedefined

    send_with_space("print", (SERVER and color_server or color_client), prefix , color_white, " -- ", parse_args("  ", ...))
end

local function new_msg(...)
    OldMsg(...)
    send("msg", color_white, ...)
end

local function new_msgc(...)
    OldMsgC(...)
    send("msg", ...)
end

local new_print_table do
    local function msg(...)
        OldMsg(...)
        OldMsg("\n")

        send_with_space("print", ...)
    end

    local function parse_key(key)
        if isnumber(key) then
            return "[" .. key .. "]"
        else
            return tostring(key)
        end
    end

    local function print_table(tbl, indent, key)
        indent = indent or 0

        local space = string.rep("\t", indent)
        local iterator = table.IsSequential(tbl) and ipairs or pairs

        if key then
            msg(space, parse_key(key), " = {")
        else
            msg(space, "{")
        end

        for k, v in iterator(tbl) do
            if istable(v) then
                print_table(v, indent + 1, k)
            else
                msg(space .. "\t", parse_key(k), " = ", translate(v))
            end
        end

        msg(space, "}")
    end

    function new_print_table(tbl)
        print_table(tbl)
    end
end

hook.Add("PostGamemodeLoaded", "gfconsole.Relay", function()
    print = new_print
    Msg = new_msg
    MsgC = new_msgc
    PrintTable = new_print_table
end)
print = new_print
Msg = new_msg
MsgC = new_msgc
PrintTable = new_print_table