-- try to simulate rain drops on glass
size = {100, 100}

defineProperty("ias", globalPropertyf("sim/flightmodel/position/indicated_airspeed"))
defineProperty("sim_rain", globalPropertyf("sim/weather/rain_percent"))
defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time of frame
defineProperty("drop_img", loadImage("leds.png", 0, 25, 5, 7))

-- define drops properties
local DROP_COUNT = 500 -- maximum amount of drops
local TRESHOLD = 0.001 -- mean drops density
local LIFETIME = 10
local drop_x = {0}
local drop_y = {0}
local drop_size = {0}

local drop_x2 = {0}
local drop_y2 = {0}
local drop_size2 = {0}

local drop_x3 = {0}
local drop_y3 = {0}
local drop_size3 = {0}

local rain = get(sim_rain)

-- fill tables
for j = 1, DROP_COUNT, 1 do
	drop_x[j] = 0
	drop_y[j] = 0
	drop_size[j] = 0
	
	drop_x2[j] = 0
	drop_y2[j] = 0
	drop_size2[j] = 0
	
	drop_x3[j] = 0
	drop_y3[j] = 0
	drop_size3[j] = 0
end

local back_drops = {0}
local back_count = math.floor(size[1]) * 100 + math.floor(size[2])
for u = 1, back_count, 1 do
	back_drops[u] = 0
end


local part = 1
function update()

	-- create drops, make them disapear and move
	local spd = get(ias)
	rain = get(sim_rain)
	local passed = get(frame_time)
	LIFETIME = 10 + rain * 10
	local start_drop = 1
	local end_drop = 34
	if part == 1 then 
		start_drop = 1
		end_drop = math.ceil(DROP_COUNT / 3)
		part = 2
	elseif part == 2 then
		start_drop = end_drop + 1
		end_drop = end_drop + math.ceil(DROP_COUNT / 3)
		part = 3		
	else
		start_drop = end_drop + 1
		end_drop = DROP_COUNT
		part = 1	
	end
	
	for i = start_drop, end_drop, 1 do
		-- if no drop here, place it randomly
		if rain > 0 and drop_size[i] == 0 and math.random() > (1 - TRESHOLD * rain^2 - spd * 0.001 * rain^2) then
			drop_size[i] = math.random(10, 100) * (0.01 + rain^2 * 0.01)
			drop_x[i] = math.random(0, size[1])
			drop_y[i] = math.random(0, size[2])
		end
		if drop_size[i] >= 0.1 then
			-- make drops smaller by time and move them, depending on speed and size
			drop_size[i] = drop_size[i] - passed / LIFETIME
			drop_x[i] = drop_x[i] - passed * spd * math.random() * drop_size[i] * 0.07
			drop_y[i] = drop_y[i] + (spd - 30) * passed * math.random() * drop_size[i] * 0.3

			-- limit drops by window frame and min size
			if drop_x[i] > size[1] or drop_x[i] < 0 or drop_y[i] > size[2] or drop_y[i] < 0 or drop_size[i] < 0.1 then drop_size[i] = 0 end
			-- check intersection with other drops
		
			for k = 1, DROP_COUNT, 1 do
				if drop_size[k] ~= 0 then
					if drop_x[k] - drop_x[i] < (drop_size[i]+drop_size[k])*0.5 and drop_x[k] - drop_x[i] > -(drop_size[i]+drop_size[k])*0.5 and drop_y[k] - drop_y[i] < (drop_size[i]+drop_size[k])*0.5 and drop_y[k] - drop_y[i] > -(drop_size[i]+drop_size[k])*0.5 and i ~= k then
						drop_size[i] = drop_size[i] + drop_size[k] * 0.5
						drop_size[k] = 0
					end
				end
			end
		 
		
			if drop_size[i] > 2 then drop_size[i] = 2 end
		
			drop_x2[i] = (drop_x[i] / size[1])^2 * size[1]
			drop_y2[i] = (drop_y[i] / size[1])^2 * size[2]
			drop_size2[i] = drop_size[i] * 0.8		

			drop_x3[i] = (drop_x2[i] + drop_x[i]) * 0.5
			drop_y3[i] = (drop_y2[i] + drop_y[i]) * 0.5
			drop_size3[i] = (drop_size2[i] + drop_size[i]) * 0.5

			-- save drop in back_drops
			back_drops[math.floor(drop_x[i])*100 + math.floor(drop_y[i])] = math.max(drop_size[i], back_drops[math.floor(drop_x[i])*100 + math.floor(drop_y[i])])
			back_drops[math.floor(drop_x2[i])*100 + math.floor(drop_y2[i])] = math.max(drop_size2[i], back_drops[math.floor(drop_x2[i])*100 + math.floor(drop_y2[i])])
			back_drops[math.floor(drop_x3[i])*100 + math.floor(drop_y3[i])] = math.max(drop_size3[i], back_drops[math.floor(drop_x3[i])*100 + math.floor(drop_y3[i])])
		end
	end
end


components = {

--[[
	draw_drop {
		--position = {0, 0, size[1], size[2]},
		xx = function()
			return drop_x
		end,
		yy = function()
			return drop_y
		end,
		zz = function()
			return drop_size
		end,
		count = DROP_COUNT,
	},

	draw_drop {
		--position = {0, 0, size[1], size[2]},
		xx = function()
			return drop_x2
		end,
		yy = function()
			return drop_y2
		end,
		zz = function()
			return drop_size2
		end,
		count = DROP_COUNT,
	},

	draw_drop {
		--position = {0, 0, size[1], size[2]},
		xx = function()
			return drop_x3
		end,
		yy = function()
			return drop_y3
		end,
		zz = function()
			return drop_size3
		end,
		count = DROP_COUNT,
	},
--]]	
	draw_back_drop {
		position = {0, 0, size[1], size[2]},
		drop_table = function()
			return back_drops
		end,
		count = back_count,	
	},
	
	
}
