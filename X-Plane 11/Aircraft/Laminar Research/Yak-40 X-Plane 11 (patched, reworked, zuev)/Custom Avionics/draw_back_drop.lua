size = {100, 100}
defineProperty("drop_tabe")
defineProperty("count", 2)
defineProperty("red", globalPropertyf("sim/graphics/misc/cockpit_light_level_r"))  -- red component of natural light in cockpit
defineProperty("green", globalPropertyf("sim/graphics/misc/cockpit_light_level_g"))  -- green component of natural light in cockpit
defineProperty("blue", globalPropertyf("sim/graphics/misc/cockpit_light_level_b"))  -- blue component of natural light in cockpit
function draw(self)
	local table = get(drop_table)
	local r = get(red)
	local g = get(green)
	local b = get(blue)
	for i = 1, get(count), 1 do
		local x = math.floor(i / 100)
		local y = i - x * 100
		if y <= 100 and table[i] > 0 then
			local a = table[i] * 0.3
			drawTriangle(x, y, x, y+a*4, x+a*2, y, r, g, b, a)
			drawTriangle(x, y+a*7, x+a*2, y+a*4, x+a*2, y, r, g, b, a)
			table[i] = table[i] - 0.002
			if table[i] < 0 then table[i] = 0 end
		end
	end
end
