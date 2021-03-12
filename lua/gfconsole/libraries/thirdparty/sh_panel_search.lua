-- https://gist.github.com/tochnonement/ee7b3ca1c9882856f15bc88b7c15de2d

do
    local function process(panel, class, callback)
        for _, child in ipairs(panel:GetChildren()) do
            if child.ClassName == class then
                if IsValid(child) then
                    callback(child)
                end
                return
            else
                process(child, class, callback)
            end
        end
    end
    
    function gfconsole.search_panel(class, callback)
        process(vgui.GetWorldPanel(), class, callback)
    end
end