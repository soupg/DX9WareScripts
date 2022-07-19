local key = dx9.GetKey()

--dx9.ShowConsole(true)


if _G.g == nil then
    _G.g = {
        height = dx9.size().height/2;
        cooldown = 0;
        tube_spawn = 0;
        tubes = {};
        score = 0;
    }
end
local size = {dx9.size().width, dx9.size().height}
local g = _G.g


--// Death
if g.height < 0 then 
    g.height = size[2]/2
end

--// Gravity
if key == "[SPACE]" then
    g.height = g.height + 69
    g.cooldown = 7
elseif g.cooldown == 0 then
    g.height = g.height - 5
else
    g.cooldown = g.cooldown - 1
end

--// Tube Mechanics
g.tube_spawn = g.tube_spawn + 1

if g.tube_spawn > 150 then
    local tube = {
        y = math.random(300, size[2] - 300);
        x = size[1];
    }
    table.insert(g.tubes, tube)

    g.tube_spawn = 0
end

--// Drawing Game
dx9.DrawFilledBox({0, 0}, size, {50, 150, 200})

dx9.DrawFilledBox({148, size[2] - g.height + 2}, {202, size[2] - g.height - 52}, {0, 0, 0})
dx9.DrawFilledBox({150, size[2] - g.height}, {200, size[2] - g.height - 50}, {200, 200, 100})
dx9.DrawString({160, size[2] - g.height - 40}, {255,255,255}, "BIRD")

--// Drawing Tubes
for i,v in pairs(g.tubes) do
    v.x = v.x - 10
    if v.x + 150 < 0 then 
        g.tubes[i] = nil
        g.score = g.score + 1
    elseif v.x < 200 and (size[2] - g.height - 50 < v.y - 100 or size[2] - g.height > v.y + 100) then
        _G.g = nil
        g = nil
    end

    dx9.DrawFilledBox({v.x - 3, 0}, {v.x + 153, v.y - 98}, {0, 0, 0})
    dx9.DrawFilledBox({v.x, 0}, {v.x + 150, v.y - 100}, {100, 255, 100})

    dx9.DrawFilledBox({v.x - 3, v.y + 98}, {v.x + 153, size[2]}, {0, 0, 0})
    dx9.DrawFilledBox({v.x, v.y + 100}, {v.x + 150, size[2]}, {100, 255, 100})
end

--// Drawing score
dx9.DrawString({size[1]/2, 7}, {255,255,255}, "SCORE: "..g.score)

--// Closing Statement
_G.g = g
