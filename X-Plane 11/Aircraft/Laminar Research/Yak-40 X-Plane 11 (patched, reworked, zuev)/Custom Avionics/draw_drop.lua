defineProperty("xx")
defineProperty("yy")
defineProperty("zz")
defineProperty("count", 2)
defineProperty("red", globalPropertyf("sim/graphics/misc/cockpit_light_level_r"))  -- red component of natural light in cockpit
defineProperty("green", globalPropertyf("sim/graphics/misc/cockpit_light_level_g"))  -- green component of natural light in cockpit
defineProperty("blue", globalPropertyf("sim/graphics/misc/cockpit_light_level_b"))  -- blue component of natural light in cockpit
function draw(self)
	local x = get(xx)
	local y = get(yy)
	local z = get(zz)
	local r = get(red)
	local g = get(green)
	local b = get(blue)
	for i = 1, get(count), 1 do
		drawTriangle(x[i]-z[i]/4, y[i], x[i], y[i]+z[i], x[i]+z[i]/4, y[i], r, g, b, 0.7)
		drawTriangle(x[i]+z[i]/4, y[i], x[i], y[i]-z[i], x[i]-z[i]/4, y[i], r*0.7, g*0.7, b*0.7, 0.7)
	end
end


