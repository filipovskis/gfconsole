--[[

Author: tochonement
Email: tochonement@gmail.com

11.03.2021

--]]

PANEL = {}

function PANEL:Init()
    self.header = self:Add("GFConsole.Header")

    self.panel = self:Add("GFConsole.Container")

    self:SetCookieName("gfconsole")
end

function PANEL:PerformLayout(w, h)
    self:DockPadding(5, 5, 5, 5)

    self.header:Dock(TOP)
    self.header:SetTall(30)

    self.panel:DockMargin(0, 5, 0, 0)
    self.panel:Dock(FILL)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(0, 0, w, h)
end

function PANEL:Think()
    if gfconsole.holding then
        self:ResizeController()
    end

    local hide = hook.Call("HUDShouldDraw", GAMEMODE, "gfconsole.Hide")
    if hide == false then
        self:SetAlpha(0)
    else
        if self:GetAlpha() ~= 255 then
            self:SetAlpha(255)
        end
    end
end

function PANEL:LoadCookies()
    local pos = self:GetCookie("position")
    local size = self:GetCookie("size")
    local scrw, scrh = ScrW(), ScrH()

    if pos then
        pos = util.JSONToTable(pos)

        self:SetPos(pos.x * scrw, pos.y * scrh)
    end
    
    if size then
        size = util.JSONToTable(size)

        self:SetSize(size.w * scrw, size.h * scrh)
    else
        self:SetSize(ScrW(), ScrH() * .25)
    end
end

-- Custom methods

function PANEL:SaveSize(w, h)
    self:SetCookie("size", util.TableToJSON({
        w = (w / ScrW()),
        h = (h / ScrH())
    }))
end

function PANEL:SavePosition(x, y)
    self:SetCookie("position", util.TableToJSON({
        x = (x / ScrW()),
        y = (y / ScrH())
    }))
end

function PANEL:Move(x, y)
    self:SetPos(x, y)
    self:SavePosition(x, y)
end

function PANEL:ResizeController()
    local x, y = self:GetRelativeToCursor()
    local w, h = self:GetSize()

    if x > (w - 8) and y > (h - 8) then
        self.resizable = input.IsMouseDown(MOUSE_LEFT)
        self:SetCursor("sizenwse")
    else
        self:SetCursor("cursor")
    end

    if self.resizable then
        self:SetSize(x, y)
        self:SaveSize(x, y)
    end
end

function PANEL:GetRelativeToCursor()
    local x, y = self:LocalToScreen(0, 0)
    local x2, y2 = input.GetCursorPos()

    return (x2 - x), (y2 - y)
end

vgui.Register("GFConsole", PANEL, "EditablePanel")