--[[

Author: tochonement
Email: tochonement@gmail.com

12.03.2021

--]]

_print = _print or print
_Msg = _Msg or Msg
_MsgC = _MsgC or MsgC

local send = gfconsole.send

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

local function translate(object)
    local type = type(object)
    local translator = translators[type]

    if translator then
        return translator(object)
    else
        if type == "table" and is_color(object) then
            return translators["Color"](object)
        else
            return tostring(object)
        end
    end
end

local function override()
    do
        local color = Color(214, 70, 142)

        local function parse(...)
            if ... == nil then
                return "nil"
            else
                local parsed = {}
                local arguments = {...}
                local count = #arguments
    
                for index, object in ipairs(arguments) do
                    table.insert(parsed, translate(object))

                    if index < count then
                        table.insert(parsed, " ")
                    end
                end

                table.insert(parsed, "\n")
                
                return unpack(parsed)
            end
        end
    
        function print(...)
            _print(...)

            local info = debug.getinfo(2)
    
            if not info then
                send("Print", parse(...))
                return
            end
        
            local prefix = ""
            local src = info.short_src
            local exploded = string.Explode("/", src)
            
            prefix = exploded[#exploded]
            prefix = prefix .. ":"  .. info.linedefined
        
            send("Print", color, prefix , color_white, " -- ", parse(...))
        end
    end

    do
        local function print(...)
            _Msg(...)
            _Msg("\n")
    
            send("Print", ...)
            send("Print", "\n")
        end

        local function output(tbl, indent, key)
            indent = indent or 1

            local iterator = table.IsSequential(tbl) and ipairs or pairs
            local tabs = ""
        
            for i = 1, (indent - 1) do
                tabs = tabs .. "\t"
            end
        
            if key then
                print(tabs, key, " = ", "{")
            else
                print(tabs, "{")
            end
        
            for k, v in iterator(tbl) do
                local type = type(v)
        
                if isnumber(k) then
                    k = "[" .. k .. "]"
                end
        
                if type == "table" then
                    if is_color(v) then
                        print("\t", tabs, k, " = ", translators["Color"](v))
                    else
                        output(v, indent + 1, k)
                    end
                else
                    local value = v
        
                    if type == "string" then
                        value = "\"" .. value .. "\""
                    else
                        value = translate(value)
                    end
        
                    print("\t", tabs, k, " = ", value)
                end
            end
        
            print(tabs, "}")
        end

        function PrintTable(tbl)
            output(tbl)
        end
    end
    
    _G.Msg = function(...)
        _Msg(...)
    
        send("Msg", ...)
    end
    
    _G.MsgC = function(...)
        _MsgC(...)
    
        send("Msg", ...)
    end
end

hook.Add("PostGamemodeLoaded", "gfconsole.Override", override)