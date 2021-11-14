--[[

Author: tochnonement
Email: tochnonement@gmail.com

14/11/2021

--]]

gfconsole.util = {}

function gfconsole.util.write_pon(tbl)
    local data = pon.encode(tbl)

    net.WriteString(data)
end

function gfconsole.util.read_pon()
    local data = net.ReadString()
    local tbl = pon.decode(data)

    return tbl
end