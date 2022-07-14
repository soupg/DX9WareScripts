--// RushPoint UI | Made by supg //--

--// Library
local Lib = loadstring(dx9.Get("https://raw.githubusercontent.com/soupg/DXLibUI/main/main.lua"))()
local Window = Lib:CreateWindow({Title = "Rushpoint UI | Made by supg", Size = {500,500}, Resizable = true, ToggleKey = "[F5]" })

--// Tabs
local Tab1 = Window:AddTab("Main")

--// Groupboxes
local Groupbox1 = Tab1:AddGroupbox("Aimbot", "left")
local Groupbox2 = Tab1:AddGroupbox("ESP", "right")



--// AIMBOT SECTION //--
local aimbot = Groupbox1:AddToggle({Text = "Aimbot Enabled"}):OnChanged(function(value)
    if value then Lib:Notify("Aimbot Enabled", 1) else Lib:Notify("Aimbot Disabled", 1) end
end)

--// Aimbot groupbox
local teamcheck = Groupbox1:AddToggle({Text = "TeamCheck Enabled"}):OnChanged(function(value)
    if value then Lib:Notify("TeamCheck Enabled", 1) else Lib:Notify("TeamCheck Disabled", 1) end
end)

--// Smoothness 
local smoothness = Groupbox1:AddSlider({Text = "Aimbot Smoothness", Default = 1, Min = 1, Max = 30})

--// Aimpart 
local aimpart = Groupbox1:AddSlider({Text = "Aimpart", Default = 1, Min = 1, Max = 2}):OnChanged(function(value)
    if value == 1 then Lib:Notify("Aimpart: Head", 1) else Lib:Notify("Aimpart: Torso", 1) end
end)
Groupbox1:AddLabel("1: Head | 2: Torso")


Groupbox1:AddBlank(7)

--// FOV Settings
Groupbox1:AddTitle("FOV Circle")

--// Aimbot groupbox
local fov_circle = Groupbox1:AddToggle({Text = "FOV Circle Enabled"}):OnChanged(function(value)
    if value then Lib:Notify("FOV Circle Enabled", 1) else Lib:Notify("FOV Circle Disabled", 1) end
end)

local fov = Groupbox1:AddSlider({Text = "FOV Size", Default = 100, Min = 10, Max = 300})

local fov_color = Groupbox1:AddColorPicker({Default = {255,255,255}, Text = "FOV Circle Color"})



--// ESP SECTION //--
local esp = Groupbox2:AddToggle({Text = "ESP Enabled"}):OnChanged(function(value)
    if value then Lib:Notify("ESP Enabled", 1) else Lib:Notify("ESP Disabled", 1) end
end)


local nametags = Groupbox2:AddToggle({Text = "Show Nametags"}):OnChanged(function(value)
    if value then Lib:Notify("Nametags Enabled", 1) else Lib:Notify("Nametags Disabled", 1) end
end)

local distance = Groupbox2:AddToggle({Text = "Show Distance"}):OnChanged(function(value)
    if value then Lib:Notify("Distance Enabled", 1) else Lib:Notify("Distance Disabled", 1) end
end)

local healthbar = Groupbox2:AddToggle({Text = "Show Healthbar"}):OnChanged(function(value)
    if value then Lib:Notify("Healthbar Enabled", 1) else Lib:Notify("Healthbar Disabled", 1) end
end)

local box_type = Groupbox2:AddSlider({Text = "Box Type", Default = 1, Min = 1, Max = 3})

local esp_color = Groupbox2:AddColorPicker({Default = {255,255,255}, Text = "ESP Color"})

--// Tracer
Groupbox2:AddTitle("Tracer")

local tracer = Groupbox2:AddToggle({Text = "Tracer Enabled"}):OnChanged(function(value)
    if value then Lib:Notify("Tracer Enabled", 1) else Lib:Notify("Tracer Disabled", 1) end
end)

local tracer_type = Groupbox2:AddSlider({Text = "Tracer Type", Default = 1, Min = 1, Max = 3})


--// My Box ESP Function (from DXLib) //-- 


function GetDistanceFromPlayer(v)
    local v1 = dx9.get_localplayer().Position;
    local v2 = v

    local a = (v1.x - v2.x) * (v1.x - v2.x);
    local b = (v1.y - v2.y) * (v1.y - v2.y);
    local c = (v1.z - v2.z) * (v1.z - v2.z);
    return math.floor(math.sqrt(a + b + c) + 0.5);
end

function Box3d(pos1, pos2, box_color) 

    --// Error Handling
    assert(type(pos1) == "table" and #pos1 == 3, "[Error] Box3d: First Argument needs to be a table with 3 position values!")
    assert(type(pos2) == "table" and #pos2 == 3, "[Error] Box3d: Second Argument needs to be a table with 3 position values!")
    assert(type(box_color) == "table" and #box_color == 3, "[Error] Box3d: Third Argument needs to be a table with 3 RGB values!")

    local box_matrix = { 
        1,1,1,-1,1,1,
        -1,1,1,-1,-1,1,
        1,1,1,1,-1,1,
        1,-1,1,-1,-1,1,
        1,1,-1,1,1,1,
        1,-1,-1,1,-1,1,
        1,1,-1,1,-1,-1,
        1,1,-1,-1,1,-1,
        -1,-1,-1,-1,1,-1,
        1,-1,-1,-1,-1,-1,
        -1,-1,-1,-1,-1,1,
        -1,1,-1,-1,1,1,
    }

    local x = pos1[1] - pos2[1]
    local y = pos1[2] - pos2[2]
    local z = pos1[3] - pos2[3]
    
    local size = {x, y, z}
    
    dx9.Box3d(box_matrix, {(pos1[1] + pos2[1]) / 2, (pos1[2] + pos2[2]) / 2, (pos1[3] + pos2[3]) / 2}, {0, 0, 0}, size, box_color)
end

function BoxESP(params) -- params = {*Target = model, Color = {r,g,b}, Healthbar = false, Distance = false, Nametag = false, Tracer = false, TracerType = 1, BoxType = 1} 
    local target = params.Target or nil
    local box_color = params.Color or {255,255,255}
    local healthbar = params.Healthbar or false
    local distance = params.Distance or false
    local nametag = params.Nametag or false
    local tracer = params.Tracer or false
    local tracertype = params.TracerType or 1 --// 1 = near-bottom, 2 = bottom, 3 = top, 4 = Mouse
    local box_type = params.BoxType or 1 --// 1 = corners, 2 = 2d box, 3 = 3d box

    --// Error Handling
    assert(type(tracertype) == "number" and (tracertype == 1 or tracertype == 2 or tracertype == 3 or tracertype == 4), "[Error] BoxESP: TracerType Argument needs to be a number! (1 - 4)")
    assert(type(box_type) == "number" and (box_type == 1 or box_type == 2 or box_type == 3), "[Error] BoxESP: BoxType Argument needs to be a number! (1 - 3)")
    assert(type(target) == "number" and dx9.GetChildren(target) ~= nil, "[Error] BoxESP: Target Argument needs to be a number (pointer) to character!")
    assert(type(box_color) == "table" and #box_color == 3, "[Error] BoxESP: Color Argument needs to be a table with 3 RGB values!")

    if dx9.FindFirstChild(target, "HumanoidRootPart") and dx9.GetPosition(dx9.FindFirstChild(target, "HumanoidRootPart")) then
        local torso = dx9.GetPosition(dx9.FindFirstChild(target, "HumanoidRootPart"))

        local HeadPosY = torso.y + 2.5
        local LegPosY = torso.y - 3.5

        local Top = dx9.WorldToScreen({torso.x , HeadPosY, torso.z})
        local Bottom = dx9.WorldToScreen({torso.x , LegPosY, torso.z})

        local height = Top.y - Bottom.y

        local width = (height / 2) 
        width = width / 1.2

        --// Draw Box
        if box_type == 1 then --// cormers
            dx9.DrawLine({Top.x + width + 2, Top.y}, {Top.x + (width/2) + 2, Top.y}, box_color) -- TopLeft 1
            dx9.DrawLine({Top.x + width + 2, Top.y}, {Top.x + width + 2, Top.y - (height/4)}, box_color) -- TopLeft 2

            dx9.DrawLine({Bottom.x - width, Top.y}, {Bottom.x - (width/2), Top.y}, box_color) -- TopRight 1
            dx9.DrawLine({Bottom.x - width, Top.y}, {Bottom.x - width, Top.y - (height/4)}, box_color) -- TopRight 2

            dx9.DrawLine({Top.x + width + 2, Bottom.y}, {Top.x + (width/2) + 2, Bottom.y}, box_color) -- BottomLeft 1
            dx9.DrawLine({Top.x + width + 2, Bottom.y}, {Top.x + width + 2, Bottom.y + (height/4)}, box_color) -- BottomLeft 2

            dx9.DrawLine({Bottom.x - width, Bottom.y}, {Bottom.x - (width/2), Bottom.y}, box_color) -- BottomRight 1
            dx9.DrawLine({Bottom.x - width, Bottom.y}, {Bottom.x - width, Bottom.y + (height/4)}, box_color) -- BottomRight 2

        elseif box_type == 2 then
            dx9.DrawBox({Bottom.x - width, Top.y}, {Top.x + width, Bottom.y}, box_color)
        else
            Box3d({torso.x - 2, HeadPosY, torso.z - 2}, {torso.x + 2, LegPosY, torso.z + 2}, box_color)
        end

        if healthbar then
            if dx9.FindFirstChild(target, "Humanoid") then
                local tl = {Top.x + width - 5, Top.y + 1}
                local br = {Top.x + width - 1, Bottom.y - 1}

                local humanoid = dx9.FindFirstChild(target, "Humanoid")
                local hp = dx9.GetHealth(humanoid)
                local maxhp = dx9.GetMaxHealth(humanoid)


                --// A lot of math stuff, dont mess with it unless u know what ur doing
                local addon = ( (height + 2) / ( maxhp/math.max(0, math.min(maxhp, hp))) )
                
                dx9.DrawBox({tl[1] - 1, tl[2] - 1}, {br[1] + 1, br[2] + 1}, box_color) -- Outer
                dx9.DrawFilledBox({tl[1], tl[2]}, {br[1], br[2]}, {0,0,0}) -- Inner Black
                dx9.DrawFilledBox({tl[1] + 1, br[2] - 1}, {br[1] - 1,    (br[2] + addon + 1)   }, {255 - 255 / (maxhp / hp), 255 / (maxhp / hp), 0}) -- Inner
            else
                error("[Error] BoxESP: Target has no humanoid, healthbar not added!")
            end
        end

        if distance then
            local dist = ""..GetDistanceFromPlayer(torso)
            dx9.DrawString({Bottom.x - (dx9.CalcTextWidth(dist) / 2), Bottom.y}, box_color, dist)
        end

        if nametag then
            local name = dx9.GetName(target)
            dx9.DrawString({Top.x - (dx9.CalcTextWidth(name) / 2), Top.y - 20}, box_color, name)
        end

        if tracer then
            local loc -- Location of tracer start

            if tracertype == 1 then
                loc = {dx9.size().width / 2, dx9.size().height / 1.1}
            elseif tracertype == 2 then
                loc = {dx9.size().width / 2, dx9.size().height}
            elseif tracertype == 3 then
                loc = {dx9.size().width / 2, 1}
            else
                loc = {dx9.GetMouse().x, dx9.GetMouse().y}
            end

            dx9.DrawLine(loc, {Top.x + width + (((Bottom.x - width) - (Top.x + width)) / 2), Bottom.y}, box_color)
        end
    else
        error("[Error] BoxESP: Passed in target has no HumanoidRootPart!")
    end
end



--// Main Code //--

local Workspace = dx9.FindFirstChild(dx9.GetDatamodel(), "Workspace")
local Players = dx9.FindFirstChild(dx9.FindFirstChild(Workspace, "MapFolder"), "Players")
local LocalPlayer = dx9.get_localplayer()
local Mouse = dx9.GetMouse()

function GetLocalPlayerTeam()
    if not teamcheck.Value then
        return 
    else
        for i,v in pairs(dx9.GetChildren(Players)) do
            if dx9.GetName(v) == LocalPlayer.Info.Name then
                return dx9.GetStringValue(dx9.FindFirstChild(v, "Team"))
            end
        end
    end
end

local Target = {Position = {0,0}, Distance = 696969}

for i,v in pairs(dx9.GetChildren(Players)) do

    --// Player ESP
    if esp.Value and dx9.GetStringValue(dx9.FindFirstChild(v, "Team")) ~= GetLocalPlayerTeam() and dx9.GetName(v) ~= LocalPlayer.Info.Name then
        BoxESP({Target = v, Color = esp_color.Value, Healthbar = healthbar.Value, Distance = distance.Value, Nametag = nametags.Value, Tracer = tracer.Value, TracerType = tracer_type.Value, BoxType = box_type.Value} )
    end

    --// Getting Target
    local root = dx9.FindFirstChild(v, "HumanoidRootPart")

    local TargetPart = "Head"
    if aimpart.Value == 2 then 
        TargetPart = "HumanoidRootPart"
    end

    local AimpartPOS = dx9.GetPosition(dx9.FindFirstChild(v, TargetPart))
    local AimpartWTS = dx9.WorldToScreen({AimpartPOS.x,AimpartPOS.y,AimpartPOS.z})

    function FovCheck()
        local x = (Mouse.x - AimpartWTS.x) * (Mouse.x-  AimpartWTS.x)
        local y = (Mouse.y - AimpartWTS.y) * (Mouse.y - AimpartWTS.y)

        return math.floor(math.sqrt(x + y))
    end

    if dx9.GetStringValue(dx9.FindFirstChild(v, "Team")) ~= GetLocalPlayerTeam() and aimbot.Value and FovCheck() <= fov.Value and FovCheck() < Target.Distance and dx9.GetName(v) ~= LocalPlayer.Info.Name then
        Target = {Position = {AimpartWTS.x, AimpartWTS.y}, Distance = FovCheck()}
    end
end


if fov_circle.Value then
    dx9.DrawCircle({Mouse.x, Mouse.y}, fov_color.Value, fov.Value)
end

dx9.FirstPersonAim(Target.Position, smoothness.Value, 1)


--// Library Loaded
if Lib.FirstRun then Lib:Notify("Script Loaded!", 2) end
