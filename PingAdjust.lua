--// DaHood Ping To Prediciton Increment Thing - supg //--

--[[

info:

If you average over 110 ping, just use the 110 setting as its the highest you can go while still being accurate.
Example: If you have 69 ping, set your ping target to 60 as you ALWAYS round

Feel free to import your own sets as well as up / down increment keys.
This script WILL WORK FOR ANY GAME, although I HIGHLY suggest changing the sets if you're going to be using the script for other games.
Script WILL adjust to different table sizes and values automatically (as long as there is 1 or more values in table)

script made by supg B) 

]]

--// Change this stuff if you need to
local down_key = '[F]'
local up_key = '[G]'
local info_location = {169, 7} -- X, Y Location of where the info box showing ping and sense is located

--// This table can be expanded / lowered / replaced. The scripts adjusts to any valid set.
local sets = {
    [40] = 7.62,
    [50] = 7.46,
    [60] = 7.22,
    [70] = 7.02,
    [80] = 6.82,
    [90] = 6.612,
    [100] = 6.41,
    [110] = 6.18,
}


--// Actual Script //--
local key = dx9.GetKey()
local Lib = loadstring(dx9.Get("https://raw.githubusercontent.com/soupg/DXLibUI/main/main.lua"))()

info_location[2] = info_location[2] - 19 -- Adjusting Offset

--// Init
if Lib.FirstRun then
    for i,v in pairs(sets) do
        _G.Lib.Increment = i -- Sets initial ping as last value from table
    end
    
    dx9.SetAimbotValue("prediction", sets[_G.Lib.Increment])
end

if key == up_key then
    local root = 6969696969

    for i,v in pairs(sets) do 
        if i > _G.Lib.Increment and i < root then
            root = i
        end
    end

    if root ~= 6969696969 then
        _G.Lib.Increment = root
        dx9.SetAimbotValue("prediction", sets[root])
        Lib:Notify("[+] "..root)
    end
elseif key == down_key then
    local root = -6969696969

    for i,v in pairs(sets) do 
        if i < _G.Lib.Increment and i > root then
            root = i
        end
    end
    
    if root ~= -6969696969 then
        _G.Lib.Increment = root
        dx9.SetAimbotValue("prediction", sets[_G.Lib.Increment])
        Lib:Notify("[-] "..root)
    end
end

--// Drawing Box
local text = "PRED: "..sets[_G.Lib.Increment].."   |   PING: "..down_key.." - ".._G.Lib.Increment.." + "..up_key
local length = dx9.CalcTextWidth(text)

dx9.DrawFilledBox( { info_location[1] + 4 , info_location[2] + 19 } , { info_location[1] + 4 + length + 12, info_location[2] + 22 + (18) } , Lib.CurrentRainbowColor )
dx9.DrawFilledBox( { info_location[1] + 5 , info_location[2] + 20 } , { info_location[1] + 3 + length + 12, info_location[2] + 21 + (18) } , Lib.OutlineColor )
dx9.DrawFilledBox( { info_location[1] + 6 , info_location[2] + 21 } , { info_location[1] + 2 + length + 12, info_location[2] + 20 + (18) } , Lib.MainColor )

dx9.DrawString( { info_location[1] + 11 , info_location[2] + 20 } , Lib.FontColor , text )
