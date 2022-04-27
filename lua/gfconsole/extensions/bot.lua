--[[

Author: tochnonement
Email: tochnonement@gmail.com

28/04/2022

--]]

local GetBots = player.GetBots

if CLIENT then
    gfconsole.buttons.add("Bot Management", function()
        local botCount = #GetBots()
        local dmenu = DermaMenu()
            dmenu:AddOption(botCount .. " Bots"):SetIcon("icon16/eye.png")

            local subCreate, optCreate = dmenu:AddSubMenu("Create")
            local subRemove, optRemove = dmenu:AddSubMenu("Remove")

            optCreate:SetIcon("icon16/add.png")
            optRemove:SetIcon("icon16/delete.png")

            for _, count in ipairs({1, 3, 5, 10}) do
                subCreate:AddOption(count, function()
                    net.Start("gfconsole.bot:Create")
                        net.WriteUInt(count, 8)
                    net.SendToServer()
                end)
            end

            for _, count in ipairs({1, 3, 5, 10}) do
                if count < botCount then
                    subRemove:AddOption(count, function()
                        net.Start("gfconsole.bot:Remove")
                            net.WriteUInt(count, 8)
                        net.SendToServer()
                    end)
                end
            end

            if botCount > 0 then
                subRemove:AddOption("Everyone", function()
                    net.Start("gfconsole.bot:Remove")
                        net.WriteUInt(botCount, 8)
                    net.SendToServer()
                end)
            end

            dmenu:AddOption("Toggle Movement", function()
                net.Start("gfconsole.bot:ToggleMovement")
                net.SendToServer()
            end):SetIcon("icon16/controller.png")
        dmenu:Open()
    end)
end

if CLIENT then return end

util.AddNetworkString("gfconsole.bot:Create")
util.AddNetworkString("gfconsole.bot:Remove")
util.AddNetworkString("gfconsole.bot:ToggleMovement")

local required_to_create = 0
local bots_cant_move = false

local function log(ply, text)
    print(ply:Name() .. " (" .. ply:SteamID() .. ") " .. text)
end

net.Receive("gfconsole.bot:Create", function(len, ply)
    if not gfconsole.config.can_execute(ply) then
        return
    end

    local count = net.ReadUInt(8)

    required_to_create = required_to_create + count

    log(ply, "created " .. count .. " bots")
end)

net.Receive("gfconsole.bot:Remove", function(len, ply)
    if not gfconsole.config.can_execute(ply) then
        return
    end

    local count = net.ReadUInt(8)
    local diff = required_to_create - count
    local left = math.abs(diff)

    if diff < 0 then
        local bots = GetBots()
        for i = 1, left do
            if IsValid(bots[i]) then
                bots[i]:Kick("GFConsole")
            end
        end
        required_to_create = 0
    else
        required_to_create = diff
    end

    log(ply, "removed " .. count .. " bots")
end)

net.Receive("gfconsole.bot:ToggleMovement", function(len, ply)
    if not gfconsole.config.can_execute(ply) then
        return
    end

    bots_cant_move = not bots_cant_move

    log(ply, (bots_cant_move and "disabled" or "enabled") .. " movement for bots")
end)

hook.Add("StartCommand", "gfconsole.bot.Controller", function(ply, cmd)
    if ply:IsBot() and bots_cant_move then
        cmd:ClearMovement()
    end
end)

timer.Create("gfconsole.bot.CreationQueue", 1 / 2, 0, function()
    if required_to_create > 0 then
        required_to_create = required_to_create - 1
        RunConsoleCommand("bot")
    end
end)