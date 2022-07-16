--// BlackHawk ESP UI | Made by supg //--


--// Library
local Lib = loadstring(dx9.Get("https://raw.githubusercontent.com/soupg/DXLibUI/main/main.lua"))()


--// Making UI
local Window = Lib:CreateWindow({Title = "Blackhawk UI | Made by supg", Size = {0,0}, Resizable = false, ToggleKey = "[F5]", FooterMouseCoords = false })

local Tab1 = Window:AddTab("Main")

local Groupbox1 = Tab1:AddMiddleGroupbox("NPC ESP") 

local aimbotEnabled = Groupbox1:AddToggle({Default = true, Text = "Enemy Aimbot"}):OnChanged(function(value)
    if value then Lib:Notify("Aimbot Enabled", 1) else Lib:Notify("Aimbot Disabled", 1) end
end)

Groupbox1:AddTitle("Enemy ESP")
local espEnabled = Groupbox1:AddToggle({Index = "1", Default = true, Text = " Enabled"}):OnChanged(function(value)
    if value then Lib:Notify("Enemy ESP Enabled", 1) else Lib:Notify("Enemy ESP Disabled", 1) end
end)

local tracerEnabled = Groupbox1:AddToggle({Index = "1t", Default = true, Text = " Tracers Enabled"}):OnChanged(function(value)
    if value then Lib:Notify("Tracers Enabled", 1) else Lib:Notify("Tracers Disabled", 1) end
end)
local espColor = Groupbox1:AddColorPicker({Index = "2", Default = {255, 100, 100}, Text = " Color"}).Value

Groupbox1:AddTitle("Hostage ESP")
local espEnabled2 = Groupbox1:AddToggle({Index = "3", Default = true, Text = " Enabled"}):OnChanged(function(value)
    if value then Lib:Notify("Hostage ESP Enabled", 1) else Lib:Notify("Hostage ESP Disabled", 1) end
end)

local espColor2 = Groupbox1:AddColorPicker({Index = "4", Default = {100, 255, 100}, Text = " Color"}).Value

local distLimit = Groupbox1:AddSlider({Default = 5000, Text = "ESP & Aimbot Distance Limit", Min = 0, Max = 5000, Rounding = 0}).Value


--// Main Code
local NPC_folder = dx9.FindFirstChild(dx9.FindFirstChild(dx9.GetDatamodel(), "Workspace"), "Bots")
local Mouse = dx9.GetMouse()

--// Funcs
function GetDistanceFromPlayer(v)
    local v1 = dx9.get_localplayer().Position;
    local v2 = v

    local a = (v1.x - v2.x) * (v1.x - v2.x);
    local b = (v1.y - v2.y) * (v1.y - v2.y);
    local c = (v1.z - v2.z) * (v1.z - v2.z);
    return math.floor(math.sqrt(a + b + c) + 0.5);
end

--// Box ESP
function BoxESP(params)
    local target = params.Target or nil
    local box_color = espColor or {255,255,255}
    local healthbar = true
    local distance = true
    local tracer = tracerEnabled.Value
    local tracertype = 2 --// 1 = near-bottom, 2 = bottom, 3 = top, 4 = Mouse

    --// Error Handling
    assert(type(target) == "number" and dx9.GetChildren(target) ~= nil, "[Error] BoxESP: Target Argument needs to be a number (pointer) to character!")

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
        dx9.DrawLine({Top.x + width + 2, Top.y}, {Top.x + (width/2) + 2, Top.y}, box_color) -- TopLeft 1
        dx9.DrawLine({Top.x + width + 2, Top.y}, {Top.x + width + 2, Top.y - (height/4)}, box_color) -- TopLeft 2

        dx9.DrawLine({Bottom.x - width, Top.y}, {Bottom.x - (width/2), Top.y}, box_color) -- TopRight 1
        dx9.DrawLine({Bottom.x - width, Top.y}, {Bottom.x - width, Top.y - (height/4)}, box_color) -- TopRight 2

        dx9.DrawLine({Top.x + width + 2, Bottom.y}, {Top.x + (width/2) + 2, Bottom.y}, box_color) -- BottomLeft 1
        dx9.DrawLine({Top.x + width + 2, Bottom.y}, {Top.x + width + 2, Bottom.y + (height/4)}, box_color) -- BottomLeft 2

        dx9.DrawLine({Bottom.x - width, Bottom.y}, {Bottom.x - (width/2), Bottom.y}, box_color) -- BottomRight 1
        dx9.DrawLine({Bottom.x - width, Bottom.y}, {Bottom.x - width, Bottom.y + (height/4)}, box_color) -- BottomRight 2


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

        local name = "Enemy"
        dx9.DrawString({Top.x - (dx9.CalcTextWidth(name) / 2), Top.y - 20}, box_color, name)

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

            if (Top.x + width + (((Bottom.x - width) - (Top.x + width)) / 2)) + (Bottom.y) ~= 0 then
                dx9.DrawLine(loc, {Top.x + width + (((Bottom.x - width) - (Top.x + width)) / 2), Bottom.y}, box_color)
            end
        end
    else
        error("[Error] BoxESP: Passed in target has no HumanoidRootPart!")
    end
end

--// ESP (Hostage and Enemy)
for i,v in pairs(dx9.GetChildren(NPC_folder)) do
    if #dx9.GetChildren(dx9.FindFirstChild(dx9.FindFirstChild(v, "HumanoidRootPart"), "RootRigAttachment")) == 0 then
        
        --// Enemy ESP
        if espEnabled.Value then
            BoxESP({Target = v})
        end
    else

        --// Hostage ESP
        if espEnabled2.Value then
            local pos = dx9.GetPosition(dx9.FindFirstChild(v, "HumanoidRootPart"))
            local wts = dx9.WorldToScreen({pos.x,pos.y+2,pos.z})

            local hp = dx9.GetHealth(dx9.FindFirstChild(v,"Humanoid"));
            local maxhp = dx9.GetMaxHealth(dx9.FindFirstChild(v,"Humanoid"));


            if wts.x > 0 and wts.y > 0 and distLimit > GetDistanceFromPlayer(pos) then
                dx9.DrawCircle({wts.x,wts.y}, {0,0,0}, 3);
                dx9.DrawCircle({wts.x,wts.y}, espColor2, 1);

                dx9.DrawString({wts.x+5, wts.y-15}, espColor2, "Hostage ["..GetDistanceFromPlayer(pos).."]");
            end
        end
    end
end


--// Aimbot
local closestEnemy = {position = {0,0}, distance = 696969}
for i,v in pairs(dx9.GetChildren(NPC_folder)) do
    if #dx9.GetChildren(dx9.FindFirstChild(dx9.FindFirstChild(v, "HumanoidRootPart"), "RootRigAttachment")) == 0 then
        local apos = dx9.GetPosition(dx9.FindFirstChild(v, "HumanoidRootPart"))
        local awts = dx9.WorldToScreen({apos.x,apos.y,apos.z})

        local x = (Mouse.x - awts.x) * (Mouse.x - awts.x)
        local y = (Mouse.y - awts.y) * (Mouse.y - awts.y)
        local diff = math.floor(math.sqrt(x + y))

        if aimbotEnabled.Value and diff <= dx9.GetAimbotValue("fov") and (diff < closestEnemy.distance) and (distLimit > GetDistanceFromPlayer(apos)) then
            closestEnemy = {position = {awts.x,awts.y}, distance = diff}
        end
    end
end

dx9.FirstPersonAim(closestEnemy.position, dx9.GetAimbotValue("smoothness"), dx9.GetAimbotValue("sensitivity"))
