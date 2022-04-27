--[[

Author: tochnonement
Email: tochnonement@gmail.com

27/04/2022

--]]

local add_message do
    local Run = hook.Run
    local GetConVar = GetConVar
    local color_gray = Color(200, 200, 200)

    function add_message(from_server, filter, ...)
        local frame = gfconsole.frame

        if not IsValid(frame) then return end

        local container = frame.panel
        local should_receive = Run("gfconsole.CanPass", filter)
        local realm = GetConVar("gfconsole_realm"):GetString()

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

        if GetConVar("gfconsole_timestamps"):GetBool() then
            if select(1, ...) ~= "\n" then
                container:AddRecord(color_gray, os.date("[%H:%M:%S] "), ...)
            else
                container:AddRecord(...)
            end
        else
            container:AddRecord(...)
        end
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