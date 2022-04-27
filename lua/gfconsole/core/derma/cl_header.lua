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

    self.lblVersion = self:Add("DLabel")
    self.lblVersion:SetText(gfconsole.__VERSION)
    self.lblVersion:SetFont("gfconsole.Tiny")
    self.lblVersion:SetTextColor(gfconsole.config.color)
    self.lblVersion:SizeToContents()
    self.lblVersion:SetContentAlignment(7)

    self.fps = self:Add("DLabel")
    self.fps:SetFont("gfconsole.Tiny")

    self.lblFps = self:Add("DLabel")
    self.lblFps:SetFont("gfconsole.Tiny")
    self.lblFps:SetText("AVG Framerate: ")
    self.lblFps:SetTextColor(gfconsole.config.color)
    self.lblFps:SizeToContents()

    self.ping = self:Add("DLabel")
    self.ping:SetFont("gfconsole.Tiny")

    self.lblPing = self:Add("DLabel")
    self.lblPing:SetFont("gfconsole.Tiny")
    self.lblPing:SetText("AVG Ping: ")
    self.lblPing:SetTextColor(gfconsole.config.color)
    self.lblPing:SizeToContents()

    self:SetCursor("sizeall")

    self:ResetCollected()
end

function PANEL:PerformLayout(w, h)
    self.label:Dock(LEFT)
    self.label:DockMargin(5, 0, 0, 0)

    self.lblVersion:Dock(LEFT)
    self.lblVersion:DockMargin(5, 5, 0, 0)

    self.lblFps:Dock(RIGHT)
    self.fps:Dock(RIGHT)
    self.fps:DockMargin(0, 0, 5, 0)

    self.lblPing:Dock(RIGHT)
    self.ping:Dock(RIGHT)
    self.ping:DockMargin(0, 0, 5, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(0, 0, w, h)
end

function PANEL:OnMousePressed(code)
    if code == MOUSE_LEFT then
        self:OnClick()
    end
end

function PANEL:OnMouseReleased(code)
    if code == MOUSE_LEFT then
        self:OnRelease()
    end
end

function PANEL:Think()
    local curtime = CurTime()

    self:UpdateCollected()

    if (self.next_update or 0) <= curtime then
        self.fps:SetText(math.Round(get_average(self.collected.fps)))
        self.fps:SizeToContentsX()

        self.ping:SetText(math.Round(get_average(self.collected.ping)) .. "ms")
        self.ping:SizeToContentsX()

        self:ResetCollected()

        self.next_update = curtime + .8
    end

    if gfconsole.holding then
        self:MoveController()
    end
end

-- Custom methods

function PANEL:OnClick()
    self:CatchOffset()
    self:MouseCapture(true)
    self.moving = true
end

function PANEL:OnRelease()
    self:MouseCapture(false)
    self.moving = false
end

function PANEL:MoveController()
    if self.moving then
        local x, y = input.GetCursorPos()
        local cx, cy = self:GetOffset()

        self:GetParent():Move(x - cx, y - cy)
    end
end

function PANEL:CatchOffset()
    local x, y = self:GetRelativeToCursor()

    self.offset = {
        x = x,
        y = y
    }
end

function PANEL:GetOffset()
    local offset = self.offset

    if offset then
        return offset.x, offset.y
    else
        return 0, 0
    end
end

function PANEL:GetRelativeToCursor()
    local x, y = self:LocalToScreen(0, 0)
    local x2, y2 = input.GetCursorPos()

    return (x2 - x), (y2 - y)
end

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