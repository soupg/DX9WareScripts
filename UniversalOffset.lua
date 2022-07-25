--// supg's universal cursor offset //--

--// Vars
local Lib = loadstring(dx9.Get("https://raw.githubusercontent.com/soupg/DXLibUI/main/main.lua"))()

local Mouse = dx9.GetMouse();
local gui_path = dx9.FindFirstChildOfClass(dx9.FindFirstChild(dx9.FindFirstChildOfClass(dx9.GetDatamodel(), "Players"), dx9.get_localplayer().Info.Name), "PlayerGui")

if Lib.Key == "[F5]" and _G.supg ~= nil then
    Lib:Notify("Recalibrating...", 2)
    _G.supg = nil;
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


if _G.supg == nil then
    _G.supg = {
        Offset = nil;
        OldMouse = nil;
        OldPos = {};
    }
end

local Offset = _G.supg.Offset
local OldMouse = _G.supg.OldMouse
local OldPos = _G.supg.OldPos

local desc = GetDescendants(gui_path)

if Offset == nil and OldMouse ~= nil then
    dx9.SetAimbotValue("x", 0);
    dx9.SetAimbotValue("y", 0);

    for i,v in next, OldPos do
        --if ((dx9.GetImageLabelPosition(i).x < v.x and Mouse.x < OldMouse.x) or (dx9.GetImageLabelPosition(i).x > v.x and Mouse.x > OldMouse.x)) and ((dx9.GetImageLabelPosition(i).y < v.y and Mouse.y < OldMouse.y) or (dx9.GetImageLabelPosition(i).y > v.y and Mouse.y > OldMouse.y)) then 
        if (dx9.GetImageLabelPosition(i).x ~= v.x or dx9.GetImageLabelPosition(i).y ~= v.y) and (OldMouse.x - Mouse.x == v.x - dx9.GetImageLabelPosition(i).x) and (OldMouse.y - Mouse.y == v.y - dx9.GetImageLabelPosition(i).y) then
            Lib:Notify("Crosshair Found! | Press [F5] to recalibrate", 3)
            Offset = i 
            break
        end
    end
elseif Offset ~= nil then
    
    --// Adjusting Aim if cursor detected
    local pos = dx9.GetImageLabelPosition(Offset)

    dx9.SetAimbotValue("x", pos.x - Mouse.x);
    dx9.SetAimbotValue("y", pos.y - Mouse.y);
else
    dx9.SetAimbotValue("x", 0);
    dx9.SetAimbotValue("y", 0);
end

--// Storing Values
OldMouse = Mouse

local reset = true
for _,v in pairs(desc) do
    if Offset ~= nil and v == Offset then reset = false end

    OldPos[v] = dx9.GetImageLabelPosition(v)
end

if reset then Offset = nil end

_G.supg.Offset = Offset
_G.supg.OldMouse = OldMouse
_G.supg.OldPos = OldPos
