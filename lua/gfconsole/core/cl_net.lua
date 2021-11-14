--[[

Author: tochnonement
Email: tochnonement@gmail.com

14/11/2021

--]]

local success = pcall(require, "win_toast")

net.Receive("gfconsole:SendWinNotify", function()
    local text = net.ReadString()

    if success then
        WinToast.Show("GFConsole", text)
    end
end)