--[[

Author: tochnonement
Email: tochnonement@gmail.com

27/04/2022

--]]

local add_message do
    local Run = hook.Run
    local Trim = string.Trim
    local GetConVar = GetConVar
    local select = select
    local isstring = isstring
    local SysTime = SysTime

    local color_gray = Color(200, 200, 200)
    local last_ts_print = 0

    function add_message(from_server, filter, ...)
        local frame = gfconsole.frame

        if not IsValid(frame) then return end

        local container = frame.panel
        local should_receive = Run("gfconsole.CanPass", filter)
        local realm = GetConVar("cl_gfconsole_realm"):GetString()

        if should_receive == false then
            return
        end

        if from_server then
            if realm == "client" then
                return
            end
        else
            if realm == "server" then
                return
            end
        end

        if last_ts_print ~= SysTime() then
            local first = select(1, ...)
            local second = select(2, ...)
            local is_ts_allowed = GetConVar("cl_gfconsole_timestamps"):GetBool()

            if isstring(first) and Trim(first) == "" then
                is_ts_allowed = false
            elseif isstring(second) and Trim(second) == "" then
                is_ts_allowed = false
            end

            if is_ts_allowed then
                container:AddRecord(color_gray, os.date("[%H:%M:%S] "))
            end

            last_ts_print = SysTime()
        end

        container:AddRecord(...)
    end
end

function gfconsole.send(filter, ...)
    add_message(false, filter, ...)
end

do
    local net_ReadUInt = net.ReadUInt
    local net_ReadData = net.ReadData
    local pon_decode = pon.decode
    local unpack = unpack

    net.Receive("gfconsole:Send", function()
        local filter = net_ReadUInt(gfconsole.filter.bits)
        local length = net_ReadUInt(16)
        local data = net_ReadData(length)
        local decoded = pon_decode(data)

        add_message(true, filter, unpack(decoded))
    end)
end