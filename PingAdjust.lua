-- // DaHood Ping To Prediciton Thing - supg#2289 //--

-- // This table can be expanded / lowered / replaced.
local sets = {
  [40] = 7.62,
  [50] = 7.46,
  [60] = 7.22,
  [70] = 7.02,
  [80] = 6.82,
  [90] = 6.612,
  [100] = 6.41,
  [110] = 6.18
}

-- // Actual Script //--
local ping = dx9.GetPing()
loadstring(dx9.Get("https://raw.githubusercontent.com/soupg/DXLibUI/main/main.lua"))() --// To make loadstrings work

local smallestSoFar, prediction
for i, y in pairs(sets) do
  if not smallestSoFar or (math.abs(ping - i) < smallestSoFar) then
    smallestSoFar = math.abs(ping - i)
    prediction = sets[i]
  end
end

dx9.SetAimbotValue("prediction", prediction)

-- // Drawing Debug Text
dx9.DrawString({ 180, 0 }, {255, 255, 255}, "PRED: " .. prediction .. "   |   PING: " .. ping)
