--[[

Author: tochonement
Email: tochonement@gmail.com

12.03.2021

--]]

if SERVER then
    util.AddNetworkString("gfconsole:Send")

    local RECOVERY_TIME = 1
    local MAXIMUM_MESSAGES = 1024
    local MESSAGES_PER_TICK = 3
    local queue = {}

    local function get_recipients()
        local all = player.GetHumans()
        local recipients = {}

        for _, ply in ipairs(all) do
            local can = hook.Run("gfconsole.CanReceiveMessage", ply)
            if can ~= false then
                table.insert(recipients, ply)
            end
        end

        return recipients
    end

    local function process_queue()
        local recipients = get_recipients()

        if table.IsEmpty(recipients) then
            queue = {}
            return
        end

        for i = 1, MESSAGES_PER_TICK do
            local message = queue[1]
            if message then
                local filter = message.filter
                local data = message.data

                net.Start("gfconsole:Send")
                    net.WriteString(filter)
                    gfconsole.util.write_pon(data)
                net.Send(recipients)

                table.remove(queue, 1)
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

            table.insert(queue, {
                filter = filter,
                data = {...}
            })

            check_queue_overload()
        end
    end

    start_process()
end

if CLIENT then
    local function add(from_server, filter, ...)
        local should_receive = hook.Run("gfconsole.CanPass", filter)
        local realm = GetConVar("gfconsole_realm"):GetString()
        local arguments = {...}

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

        gfconsole.search_panel("GFConsole.Container", function(panel)
            panel:AddRecord(unpack(arguments))
        end)
    end

    function gfconsole.send(filter, ...)
        add(false, filter, ...)
    end

    net.Receive("gfconsole:Send", function()
        local filter = net.ReadString()
        local arguments = gfconsole.util.read_pon()

        add(true, filter, unpack(arguments))
    end)
end