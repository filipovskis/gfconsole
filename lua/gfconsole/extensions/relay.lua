--[[

Author: tochonement
Email: tochonement@gmail.com

22.07.2021

--]]

local send = gfconsole.send

local color_client = Color(255, 221, 102)
local color_server = Color(156, 221, 255, 255)

gfconsole.FILTER_PRINT = gfconsole.FILTER_PRINT or gfconsole.filter.create("Print")
gfconsole.FILTER_MSG = gfconsole.FILTER_MSG or gfconsole.filter.create("Etc")

do
    local _G = _G
    OldPrint = OldPrint or _G.print
    OldMsg = OldMsg or _G.Msg
    OldMsgC = OldMsgC or _G.MsgC
    OldPrintTable = OldPrintTable or _G.PrintTable
    OldMsgN = OldMsgN or _G.MsgN
end

local function send_with_space(filter, ...)
    send(filter, ...)
    send(filter, "\n")
end

-- ANCHOR Utility

local translate do
    local format = string.format
    local tostring = tostring
    local type = type
    local istable = istable
    local TypeID = TypeID

    local translators = {
        ["Vector"] = function(object)
            return format("Vector(%i, %i, %i)", object.x, object.y, object.z)
        end,
        ["Color"] = function(object)
            return format("Color(%i, %i, %i, %i)", object.r, object.g, object.b, object.a)
        end,
        ["Angle"] = function(object)
            return format("Angle(%i, %i, %i)", object.p, object.y, object.r)
        end
    }

    local function is_color(tbl)
        return istable(tbl) and TypeID(tbl) == TYPE_COLOR
    end

    function translate(any)
        local sType = type(any)
        local translator = translators[sType]

        if sType == "string" then
            return any
        elseif translator then
            return translator(any)
        else
            if is_color(any) then
                return translators["Color"](any)
            else
                return tostring(any)
            end
        end
    end
end

local parse_args do
    local select = select
    local unpack = unpack
    local nilStr = "nil"

    function parse_args(separator, ...)
        local result, count = {}, 0
        local arg_amount = select("#", ...)

        for i = 1, arg_amount do
            local value = select(i, ...)

            count = count + 1

            if value == nil then
                result[count] = nilStr
            else
                result[count] = translate(value)
            end

            if separator and i < count then
                result[count] = result[count] .. separator
            end
        end

        return unpack(result)
    end
end

-- ANCHOR Override

local new_print do
    local getinfo = debug.getinfo
    local explode = string.Explode

    function new_print(...)
        OldPrint(...)

        local info = getinfo(2)

        if not info then
            send_with_space(gfconsole.FILTER_PRINT, color_white, parse_args("  ", ...))
            return
        end

        local src = info.short_src
        local exploded = explode("/", src)
        local prefix = exploded[#exploded] .. ":" .. info.linedefined

        send_with_space(gfconsole.FILTER_PRINT, SERVER and color_server or color_client, prefix , color_white, " -- ", parse_args("  ", ...))
    end
end

local function new_msg(...)
    OldMsg(...)
    send(gfconsole.FILTER_MSG, color_white, ...)
end

local function new_msgn(...)
    OldMsgN(...)
    send_with_space(gfconsole.FILTER_MSG, color_white, ...)
end

local function new_msgc(...)
    OldMsgC(...)
    send(gfconsole.FILTER_MSG, ...)
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

local function override()
    print = new_print
    Msg = new_msg
    MsgN = new_msgn
    MsgC = new_msgc
    PrintTable = new_print_table
end

override()
hook.Add("PostGamemodeLoaded", "gfconsole.Relay", override)