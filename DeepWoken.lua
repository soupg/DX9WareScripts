--// Loading my epic libraries
local Lib = loadstring(dx9.Get("https://raw.githubusercontent.com/soupg/DXLibUI/main/main.lua"))()


--// Making UI
Lib:SetWatermark("DeepWoken ESP | Made by supg")

local Window = Lib:CreateWindow("DeepWoken ESP")

--// ESP Tab
local Tab1 = Window:AddTab("ESP")

local Groupbox1 = Tab1:AddLeftGroupbox("Player ESP") 
local Groupbox2 = Tab1:AddRightGroupbox("Other ESP") 

--// Player ESP
Groupbox1:AddToggle("player_esp", {Default = false, Text = "Enabled"})
Groupbox1:AddColorPicker("player_esp_color", {Default = {255, 255, 255}, Text = "Color"})
Groupbox1:AddToggle("player_esp_nametag", {Default = false, Text = "Show Nametag"})
Groupbox1:AddToggle("player_esp_healthbar", {Default = false, Text = "Show Healthbar"})
Groupbox1:AddToggle("player_esp_distance", {Default = false, Text = "Show Distance"})
Groupbox1:AddToggle("player_esp_tracers", {Default = false, Text = "Enable Tracers"})

Groupbox1:AddSlider("player_esp_tracers_type", {Default = 1, Text = "Tracers Type", Min = 1, Max = 4, Rounding = 0})
Groupbox1:AddSlider("player_esp_type", {Default = 1, Text = "Box Type", Min = 1, Max = 3, Rounding = 0})

--// Other ESP
Groupbox2:AddTitle("Chest ESP")
Groupbox2:AddToggle("chest_esp", {Default = false, Text = " Enabled"})
Groupbox2:AddColorPicker("chest_esp_color", {Default = {100, 255, 100}, Text = " Color"})

Groupbox2:AddTitle("Bag ESP")
Groupbox2:AddToggle("bag_esp", {Default = false, Text = " Enabled"})
Groupbox2:AddColorPicker("bag_esp_color", {Default = {255, 255, 100}, Text = " Color"})

Groupbox2:AddTitle("Ship ESP")
Groupbox2:AddToggle("ship_esp", {Default = false, Text = " Enabled"})
Groupbox2:AddColorPicker("ship_esp_color", {Default = {100, 255, 255}, Text = " Color"})

Groupbox2:AddBlank(10)
Groupbox2:AddSlider("esp_distance_limit", {Default = 5000, Text = "ESP Distance Limit", Min = 0, Max = 5000, Rounding = 0})


--// Mob ESP
local Groupbox5 = Tab1:AddRightGroupbox("Mob ESP")

Groupbox5:AddToggle("mob_esp", {Default = false, Text = "Mob ESP"})
Groupbox5:AddToggle("mob_info", {Default = false, Text = "Mob Info"})
Groupbox5:AddToggle("mob_healthbar", {Default = false, Text = "Mob Healthbar"})

Groupbox5:AddColorPicker("mob_esp_color", {Default = {255, 100, 100}, Text = "Mob ESP Color"})

--// GUI Tab
local Tab2 = Window:AddTab("UI Elements")

local Groupbox3 = Tab2:AddLeftGroupbox("Hide Sections") 

Groupbox3:AddToggle("hide_info", {Default = false, Text = "Hide Info"})
Groupbox3:AddToggle("hide_players", {Default = false, Text = "Hide Players"})


local Groupbox4 = Tab2:AddRightGroupbox("UI Settings") 

local WatermarkToggle = Groupbox4:AddToggle("show_watermark", {Default = true, Text = "Show Watermark"})
local RGBToggle = Groupbox4:AddToggle("toggle_rgb", {Default = true, Text = "RGB UI"})

Window:SetRGB(RGBToggle.Value) 
Lib:SetWatermarkVisibility(WatermarkToggle.Value) 





--// Presets
local game = dx9.GetDatamodel();
local Workspace = dx9.FindFirstChild(game,"Workspace");
local Mouse = dx9.GetMouse();
local LocalPlayer = dx9.get_localplayer();
local Players = dx9.get_players();

--// Paths
local LivePath = dx9.GetChildren(dx9.FindFirstChild(Workspace,"Live"));
local ThrownPath = dx9.GetChildren(dx9.FindFirstChild(Workspace,"Thrown"));
local ShipPath = dx9.GetChildren(dx9.FindFirstChild(Workspace,"Ships"));

--// Distance Function
function DistFromPlr(v)
    local v1 = LocalPlayer.Position;
    local v2 = dx9.GetPosition(v);
    local a = (v1.x-v2.x)*(v1.x-v2.x);
    local b = (v1.y-v2.y)*(v1.y-v2.y);
    local c = (v1.z-v2.z)*(v1.z-v2.z);
    return math.floor(math.sqrt(a+b+c)+0.5);
end


--// Healthbar Function
function health_bar(x, y, hp, maxhp) -- Location need to be screen coords! 
    local size_x = 120
    local size_y = 5

    --// A lot of math stuff, dont mess with it unless u know what ur doing
    local temp = ((size_x - 2) / ( maxhp/math.max(0, math.min(maxhp, hp))));
    dx9.DrawFilledBox({x - (size_x/2), y}, {x + (size_x/2), y - size_y}, {0,0,0});
    dx9.DrawFilledBox({x - ((size_x/2) - 1), y - 1}, {x - ((size_x/2) - 1) + temp, y - (size_y - 1)}, {255 - 255 / (maxhp / hp), 255 / (maxhp / hp), 0});
end

--// Hide Info Function
function hide_info()
    if Window.Tools.hide_info.Value then
        dx9.DrawFilledBox({325, 3}, {490, 35}, Lib.BackgroundColor); -- Hides name and id / lvl
        dx9.DrawFilledBox({326, 4}, {489, 34}, Lib.CurrentRainbowColor); 
        dx9.DrawFilledBox({327, 5}, {488, 33}, Lib.MainColor);

        dx9.DrawFilledBox({625, 20}, {740, 35}, Lib.BackgroundColor); -- Hides server location
        dx9.DrawFilledBox({626, 21}, {739, 34}, Lib.CurrentRainbowColor); 
        dx9.DrawFilledBox({627, 22}, {738, 33}, Lib.MainColor);

        dx9.DrawFilledBox({985, 20}, {1065, 35}, Lib.BackgroundColor); -- Hides server age
        dx9.DrawFilledBox({986, 21}, {1064, 34}, Lib.CurrentRainbowColor); 
        dx9.DrawFilledBox({987, 22}, {1063, 33}, Lib.MainColor);
    end
    if Window.Tools.hide_players.Value then
        dx9.DrawFilledBox({1750, 15}, {1900, 400}, Lib.BackgroundColor); -- Hides member list
        dx9.DrawFilledBox({1751, 16}, {1899, 399}, Lib.CurrentRainbowColor); 
        dx9.DrawFilledBox({1752, 17}, {1898, 398}, Lib.MainColor);
    end
end
hide_info()

--// Chest ESP
if not Window.Tools.chest_esp.Value then
else
    for i,v in pairs(ThrownPath) do
        if dx9.GetName(v) == "Model" and dx9.FindFirstChild(v,"Lid") then
            local root = dx9.FindFirstChild(v,"Lid");
            local pos = dx9.GetPosition(root);
            local wts = dx9.WorldToScreen({pos.x,pos.y,pos.z});

            if wts.x > 0 and wts.y > 0 and Window.Tools.esp_distance_limit.Value > DistFromPlr(root) then
                dx9.DrawCircle({wts.x, wts.y}, {0,0,0}, 3);
                dx9.DrawCircle({wts.x, wts.y}, Window.Tools.chest_esp_color.Value, 1);
                dx9.DrawString({wts.x+5, wts.y-13}, Window.Tools.chest_esp_color.Value, "Chest ["..DistFromPlr(root).."]");
            end
        end
    end
end

--// Bag ESP
if not Window.Tools.bag_esp.Value then
else
    for i,v in pairs(ThrownPath) do
        if dx9.GetName(v) == "BagDrop" and dx9.FindFirstChild(v,"OriginalOwner") then
            local root = v;
            local pos = dx9.GetPosition(root);
            local wts = dx9.WorldToScreen({pos.x,pos.y,pos.z});
            local owner = dx9.GetStringValue(dx9.FindFirstChild(v,"OriginalOwner"));
            
            if wts.x > 0 and wts.y > 0 and Window.Tools.esp_distance_limit.Value > DistFromPlr(root) then
                dx9.DrawCircle({wts.x,wts.y}, {0,0,0}, 3);
                dx9.DrawCircle({wts.x,wts.y}, Window.Tools.bag_esp_color.Value, 1);
                dx9.DrawString({wts.x+5,wts.y-13}, Window.Tools.bag_esp_color.Value, owner.."'s Bag ["..DistFromPlr(root).."]");
            end
        end
    end
end

--// Ship ESP
if not Window.Tools.ship_esp.Value then
else
    for i,v in pairs(ShipPath) do
        if dx9.GetType(v) == "Model" and dx9.FindFirstChild(v,"Owner") then
            local root = dx9.FindFirstChildOfClass(v,"Part");
            local pos = dx9.GetPosition(root);
            local wts = dx9.WorldToScreen({pos.x,pos.y,pos.z});
            local owner = dx9.GetStringValue(dx9.FindFirstChild(v,"Owner"));
            --local guild = dx9.GetStringValue(dx9.FindFirstChild(v,"Guild"));
            
            if wts.x > 0 and wts.y > 0 and Window.Tools.esp_distance_limit.Value > DistFromPlr(root) then
                dx9.DrawCircle({wts.x,wts.y},{0,0,0},3);
                dx9.DrawCircle({wts.x,wts.y}, Window.Tools.ship_esp_color.Value,1);
                dx9.DrawString({wts.x+5,wts.y-13}, Window.Tools.ship_esp_color.Value, dx9.GetName(v).." ["..DistFromPlr(root).."]\n[Owner: "..owner.."]");
            end
        end
    end
end

--// Mob ESP
if not Window.Tools.mob_esp.Value then
else
    for i,v in pairs(LivePath) do
        if string.sub(dx9.GetName(v), 1, 1) == "." and dx9.FindFirstChild(v,"Humanoid") then
            local root = dx9.FindFirstChild(v,"HumanoidRootPart");
            local pos = dx9.GetPosition(root);
            local wts = dx9.WorldToScreen({pos.x,pos.y+2,pos.z});
            local name = string.sub(dx9.GetName(v), 2);

            local hp = dx9.GetHealth(dx9.FindFirstChild(v,"Humanoid"));
            local maxhp = dx9.GetMaxHealth(dx9.FindFirstChild(v,"Humanoid"));

            if wts.x > 0 and wts.y > 0 and Window.Tools.esp_distance_limit.Value > DistFromPlr(root) then
                dx9.DrawCircle({wts.x,wts.y}, {0,0,0}, 3);
                dx9.DrawCircle({wts.x,wts.y}, Window.Tools.mob_esp_color.Value, 1);

                if Window.Tools.mob_info.Value then
                    dx9.DrawString({wts.x - 60,wts.y - 50}, Window.Tools.mob_esp_color.Value, name.."\n[DIST: "..DistFromPlr(root).."] [HP: "..math.floor(hp + 0.5).."]");
                end
                
                if Window.Tools.mob_healthbar.Value then
                    health_bar(wts.x, wts.y-5, hp, maxhp)
                end
            end
        end
    end
end

--// Player ESP
if not Window.Tools.player_esp.Value then
else
    for i,v in pairs(LivePath) do
        if string.sub(dx9.GetName(v), 1, 1) ~= "." and dx9.FindFirstChild(v,"Humanoid") and dx9.GetName(v) ~= LocalPlayer.Info.Name then
            dxl.BoxESP({Target = v, Color = Window.Tools.player_esp_color.Value, Healthbar = Window.Tools.player_esp_healthbar.Value, Distance = Window.Tools.player_esp_distance.Value, Nametag = Window.Tools.player_esp_nametag.Value, Tracer = Window.Tools.player_esp_tracers.Value, TracerType = Window.Tools.player_esp_tracers_type.Value, BoxType = Window.Tools.player_esp_type.Value})
        end
    end 
end
