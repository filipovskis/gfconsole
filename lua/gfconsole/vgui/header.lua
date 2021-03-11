--[[

Author: tochonement
Email: tochonement@gmail.com

11.03.2021

--]]

local function get_average(tbl)
    local count = #tbl
    local sum = 0
    local result

    for _, value in ipairs(tbl) do
        sum = sum + value
    end

    result = sum / count

    return result
end

PANEL = {}

function PANEL:Init()
    self.label = self:Add("DLabel")
    self.label:SetText("Developer Console")
    self.label:SetFont("gfconsole.Title")
    self.label:SetTextColor(color_white)
    self.label:SizeToContents()

    self.fps = self:Add("DLabel")
    self.fps:SetFont("gfconsole.Title")

    self.ping = self:Add("DLabel")
    self.ping:SetFont("gfconsole.Title")

    self:ResetCollected()
end

function PANEL:PerformLayout(w, h)
    self.label:Dock(LEFT)
    self.label:DockMargin(5, 0, 0, 0)

    self.fps:Dock(RIGHT)
    self.fps:DockMargin(0, 0, 5, 0)

    self.ping:Dock(RIGHT)
    self.ping:DockMargin(0, 0, 5, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(0, 0, w, h)
end

function PANEL:Think()
    local curtime = CurTime()

    self:UpdateCollected()

    if (self.next_update or 0) <= curtime then
        self.fps:SetText(string.format("AVG Framerate: %i", get_average(self.collected.fps)))
        self.fps:SizeToContentsX()

        self.ping:SetText(string.format("AVG Ping: %i", get_average(self.collected.ping)))
        self.ping:SizeToContentsX()

        self:ResetCollected()

        self.next_update = curtime + 1
    end
end

-- Custom methods

function PANEL:UpdateCollected()
    table.insert(self.collected.fps, (1 / FrameTime()))
    table.insert(self.collected.ping, LocalPlayer():Ping())
end

function PANEL:ResetCollected()
    self.collected = {
        fps = {},
        ping = {}
    }
end

vgui.Register("GFConsole.Header", PANEL)