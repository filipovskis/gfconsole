--[[

Author: tochnonement
Email: tochnonement@gmail.com

14/11/2021

--]]

-- Windows notifications
do
    local sys_arch = string.sub(jit.arch, 2):gsub("86", "32")
    local dll_name = "gm" .. (CLIENT and "cl" or "sv") .. "_win_toast_" .. (system.IsWindows() and ("win" .. sys_arch) or system.IsLinux() and ("linux" .. sys_arch) or "osx") .. ".dll"
    local dll_exists = file.Exists("lua/bin/" .. dll_name, "MOD")

    if dll_exists then
        require("win_toast")

        net.Receive("gfconsole:SendWinNotify", function()
            WinToast.Show("GFConsole", net.ReadString())
        end)
    else
        net.Receive("gfconsole:SendWinNotify", function() end)
    end
end
