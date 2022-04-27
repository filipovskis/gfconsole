--[[

Author: tochnonement
Email: tochnonement@gmail.com

27/04/2022

--]]

util.AddNetworkString("gfconsole:Send")

local RECOVERY_TIME = 1
local MAXIMUM_MESSAGES = 1024
local MESSAGES_PER_TICK = 3
local queue, count = {}, 0

local get_recipients do
    local GetHumans = player.GetHumans
    local Run = hook.Run

    function get_recipients()
        local recipient_list = {}
        local recipient_count = 0
        local players = GetHumans()
        local iterations = 0

        while (true) do
            iterations = iterations + 1
            local ply = players[iterations]
            if not ply then
                break
            end

            if Run("gfconsole.CanReceiveMessage", ply) ~= false then
                recipient_count = recipient_count + 1
                recipient_list[recipient_count] = ply
            end
        end

        return recipient_list, recipient_count
    end
end

local process_queue do
    local net_Start = net.Start
    local net_Send = net.Send
    local net_WriteString = net.WriteString
    local net_WriteUInt = net.WriteUInt
    local net_WriteData = net.WriteData
    local table_remove = table.remove
    local pon_encode = pon.encode

    function process_queue()
        local recipients, amount = get_recipients()

        if amount < 1 then
            queue = {}
            return
        end

        for i = 1, MESSAGES_PER_TICK do
            local message = queue[1]
            if message then
                local filter = message.filter
                local data = message.data
                local encoded = pon_encode(data)
                local length = #encoded

                net_Start("gfconsole:Send")
                    net_WriteString(filter)
                    net_WriteUInt(length, 16)
                    net_WriteData(encoded)
                net_Send(recipients)

                table_remove(queue, 1)
                count = count - 1
            end
        end
    end
end

local function start_process()
    gfconsole.process_enabled = true

    hook.Add("Think", "gfconsole.QueueProcess", process_queue)
end

local function stop_process()
    gfconsole.process_enabled = false

    hook.Remove("Think", "gfconsole.QueueProcess")
end

local function is_queue_filled()
    return #queue >= MAXIMUM_MESSAGES
end

local function check_queue_overload()
    if is_queue_filled() then
        stop_process()

        queue = {}

        timer.Simple(RECOVERY_TIME, start_process)
    end
end

function gfconsole.send(filter, ...)
    if gfconsole.process_enabled then
        filter = filter or ""

        count = count + 1
        queue[count] = {
            filter = filter,
            data = {...}
        }

        check_queue_overload()
    end
end

start_process()