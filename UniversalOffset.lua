--// supg's universal cursor offset //--

--// Vars
local Lib = loadstring(dx9.Get("https://raw.githubusercontent.com/soupg/DXLibUI/main/main.lua"))()

local Mouse = dx9.GetMouse();
local gui_path = dx9.FindFirstChildOfClass(dx9.FindFirstChild(dx9.FindFirstChildOfClass(dx9.GetDatamodel(), "Players"), dx9.get_localplayer().Info.Name), "PlayerGui")

if Lib.Key == "[F5]" and _G.Offset ~= nil then
    _G.Offset = nil;
end

--// Get Descendants (which are image lables)
function GetDescendants(instance)
    local children = {}

    --// Checks if v is imagelabel and is near mouse
    function FovCheck(v)
        if dx9.GetImageLabelPosition(v) then
            local v = dx9.GetImageLabelPosition(v)
            local x = (Mouse.x - v.x) * (Mouse.x - v.x)
            local y = (Mouse.y - v.y) * (Mouse.y - v.y)

            if math.floor(math.sqrt(x + y)) < 500 then
                return true
            end
        end
        return false
    end

    --// Loops through descendants
    for _, child in ipairs(dx9.GetChildren(instance)) do

        if FovCheck(child) then table.insert(children, child) end

        if #dx9.GetChildren(child) > 0 then
            for i,v in pairs(GetDescendants(child)) do
                if FovCheck(v) then table.insert(children, v) end
            end
        end
    end

    --// Returns descendants
    return children
end

--// Initiates Variables
if _G.Offset == nil then
    Lib:Notify("Calibrating offset, please move your mouse around", 3)
    
    _G.Offset = {
        Descendants = GetDescendants(gui_path);
        NewMouse = nil;
        OldPositions = {};
        Notified = false;
    }

    for i,v in pairs(_G.Offset.Descendants) do
        _G.Offset.OldPositions[v] = dx9.GetImageLabelPosition(v).x
    end
end

--// Determines which ImageLabel moves with mouse
if #_G.Offset.Descendants > 0 then
    if _G.Offset.NewMouse == nil then 

        function FovCheck(v)
            local v = dx9.GetImageLabelPosition(v)
            local x = (Mouse.x - v.x) * (Mouse.x - v.x)
            local y = (Mouse.y - v.y) * (Mouse.y - v.y)
    
            return math.floor(math.sqrt(x + y))
        end

        for i,v in pairs(_G.Offset.OldPositions) do
            if dx9.GetImageLabelPosition(i).x ~= v and FovCheck(i) < 500 then 
                _G.Offset.NewMouse = i 
            end
        end

        dx9.SetAimbotValue("x", 0);
        dx9.SetAimbotValue("y", 0);
    else
        --// Notify That Calibrated
        if not _G.Offset.Notified then
            Lib:Notify("Calibration Complete!", 3)
            Lib:Notify("Press [F5] to Re-Calibrate", 3)
            _G.Offset.Notified = true
        end

        --// Adjusting Aim if cursor detected
        local pos = dx9.GetImageLabelPosition(_G.Offset.NewMouse)

        dx9.SetAimbotValue("x", pos.x - Mouse.x);
        dx9.SetAimbotValue("y", pos.y - Mouse.y);
    end
else
    dx9.SetAimbotValue("x", 0);
    dx9.SetAimbotValue("y", 0);

    dx9.DrawString({Mouse.x + 3, Mouse.y - 15}, {255,255,255}, "No UI Elements Found, Calibration Failed!");
end
