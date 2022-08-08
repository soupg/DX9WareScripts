--// supg's universal cursor offset //--

--// Vars
local Lib = loadstring(dx9.Get("https://raw.githubusercontent.com/soupg/DXLibUI/main/main.lua"))()

local debug = false

local Mouse = dx9.GetMouse()
local gui_path = dx9.FindFirstChildOfClass(dx9.FindFirstChild(dx9.FindFirstChildOfClass(dx9.GetDatamodel(), "Players"), dx9.get_localplayer().Info.Name), "PlayerGui")

--// Release Recalibrate / Blacklist
if Lib.Key == "[F5]" and _G.supg ~= nil then
    Lib:Notify("Recalibrating...", 2, {255,255,100})

    if _G.supg.Offset ~= nil and not debug then _G.offset_blacklist[_G.supg.Offset] = true end

    _G.supg = nil
end

--// Debug Blacklist
if Lib.Key == "[F6]" and _G.supg ~= nil and debug then
    if _G.supg.Offset ~= nil then 
        _G.offset_blacklist[_G.supg.Offset] = true 
        Lib:Notify("Blacklisted Offset: "..dx9.GetName(_G.supg.Offset).." | ".._G.supg.Offset, 5, {255,100,100})
        _G.supg = nil
    else
        Lib:Notify("Nothing to blacklist!", 2, {255,0,0})
    end
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

        if FovCheck(child) and not _G.offset_blacklist[child] then table.insert(children, child) end

        if #dx9.GetChildren(child) > 0 then
            for i,v in pairs(GetDescendants(child)) do
                if FovCheck(v) and not _G.offset_blacklist[v] then table.insert(children, v) end
            end
        end
    end

    --// Returns descendants
    return children
end

--// Creating Globals
if _G.supg == nil then
    _G.supg = {
        Offset = nil,
        OldMouse = nil,
        OldPos = {},
    }
end

if _G.offset_blacklist == nil then
    _G.offset_blacklist = {}
end

local Offset = _G.supg.Offset
local OldMouse = _G.supg.OldMouse
local OldPos = _G.supg.OldPos

local desc = GetDescendants(gui_path)

if Offset == nil and OldMouse ~= nil then
    dx9.SetAimbotValue("x", 0)
    dx9.SetAimbotValue("y", 0)

    for i,v in next, OldPos do
        if (dx9.GetImageLabelPosition(i).x ~= v.x or dx9.GetImageLabelPosition(i).y ~= v.y) and (OldMouse.x - Mouse.x == v.x - dx9.GetImageLabelPosition(i).x) and (OldMouse.y - Mouse.y == v.y - dx9.GetImageLabelPosition(i).y) then
            if debug then Lib:Notify("Crosshair: "..dx9.GetName(i).." | Pos: "..v.x..", "..v.y, 5, {100,255,100}) else Lib:Notify("Crosshair Found: "..dx9.GetName(i).." | Press [F5] to blacklist offset and recalibrate", 5, {100,255,100}) end
            Offset = i 
            break
        end
    end
elseif Offset ~= nil then
    
    --// Adjusting Aim if cursor detected
    local pos = dx9.GetImageLabelPosition(Offset)

    dx9.SetAimbotValue("x", pos.x - Mouse.x)
    dx9.SetAimbotValue("y", pos.y - Mouse.y)
else
    dx9.SetAimbotValue("x", 0)
    dx9.SetAimbotValue("y", 0)
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

--// Debug
if debug then
    Log("DEBUG ENABLED")
    Log("")
    Log("Blacklisted Offsets:")
    for i,v in pairs(_G.offset_blacklist) do
        Log(dx9.GetName(i))
    end
    Log("---")
end
