size = { 200, 200 }

defineProperty("sim_version", globalPropertyi("sim/custom/xap/sim_version"))  -- saved sim version

-- initialize component property table
defineProperty("N2", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[0]"))
defineProperty("N1", globalPropertyf("sim/flightmodel/engine/ENGN_N1_[0]"))
defineProperty("AZS", 1)

defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames
defineProperty("flight_time", globalPropertyf("sim/time/total_running_time_sec")) -- sim time

defineProperty("msl_alt", globalPropertyf("sim/flightmodel/position/elevation"))  -- barometric alt. maybe in feet, maybe in meters.
defineProperty("baro_press", globalPropertyf("sim/weather/barometer_sealevel_inhg"))  -- pressire at sea level in.Hg

-- background image
-- defineProperty("background", loadImage("ite2.png", 0, 0, 155, 155))

-- needle image
defineProperty("needle_N1", loadImage("needles.png", 145, 78, 19, 163))
defineProperty("needle_N2", loadImage("needles.png", 168, 78, 19, 163))


-- local variables
local left_angle = 50
local right_angle = 50
local left_angle_last = 50
local right_angle_last = 50
local left_angle_actual = 50
local right_angle_actual = 50


-- table of throttles
local n1_table_10 = {{ -100, 0 },    -- bugs workaround
                  {  0, 0 },	--stop
				  {  39.81, 30 },	--IDLE
				  {  65.8, 54.8},	--0.4
				  {  75.58, 65.5},	--0.6
				  {  79.75, 69.8},	--0.7
				  {  85.28, 75.5 },	-- 0.85
                  {  90.36, 80.7},	-- nom
           	      {  100.3, 90.7 },    -- TO
          	      {  10000, 110 }}    -- bugs workaround

local n2_table_10 = {{ -100, 0 },    -- bugs workaround
                  {  0, 0 },		-- stop
				  {  73.56, 53 },		-- IDLE
				  {  86.98, 78.8},		-- 0.4 nominal
				  {  91.09, 85.9},		-- 0.6 nominal
				  {  92.73, 88.5},		-- 0.7 nominal
				  {  94.83, 91.9 },		-- 0.85 nominal
                  {  96.67, 95 },  	-- nominal
           	      {  100, 101 },    -- takeoff
          	      {  10000, 110 }}    -- bugs workaround
				  
local n1_table_11 = {{ -100, 0 },    -- bugs workaround
                  {  0, 0 },	--stop
				  {  22.48, 30 },	--IDLE
				  {  46.59, 54.8},	--0.4
				  {  61.36, 65.5},	--0.6
				  {  66.42, 69.8},	--0.7
				  {  75.67, 75.5 },	-- 0.85
                  {  83.26, 80.7},	-- nom
           	      {  100.3, 90.7 },    -- TO
          	      {  10000, 110 }}    -- bugs workaround

local n2_table_11 = {{ -100, 0 },    -- bugs workaround
                  {  0, 0 },		-- stop
				  {  63.50, 53 },		-- IDLE
				  {  77.52, 78.8},		-- 0.4 nominal
				  {  84.95, 85.9},		-- 0.6 nominal
				  {  87.25, 88.5},		-- 0.7 nominal
				  {  91.12, 91.9 },		-- 0.85 nominal
                  {  94.08, 95 },  	-- nominal
           	      {  100, 101 },    -- takeoff
          	      {  10000, 110 }}    -- bugs workaround


local alt_table2 = {{ -50000, 1},    -- bugs workaround
				  { 0.00, 1 },    -- on standard pressure zero level
				  {  30000, 0.976585365853659},
          		  {  100000, 1 }}
          		  
local alt_table1 = {{ -50000, 1},    -- bugs workaround
				  { 0.00, 1 },    -- on standard pressure zero level
				  {  30000, 0.9322191272052},
          		  {  100000, 1 }}

-- 100.1, 100.4
-- 102.5, 107.7 

-- interpolate values using table as reference
local function interpolate(tbl, value)
    local lastActual = 0
    local lastReference = 0
    for _k, v in pairs(tbl) do
        if value == v[1] then
            return v[2]
        end
        if value < v[1] then
            local a = value - lastActual
            local m = v[2] - lastReference
            return lastReference + a / (v[1] - lastActual) * m
        end
        lastActual = v[1]
        lastReference = v[2]
    end
    return value - lastActual + lastReference
end

local passed = 0
local message_printed = false

-- post frame calculations
function update()
	local XP11 = get(sim_version) == 10
	if XP11 and not message_printed then 
		print("ITE2 tuned to XP11") 
		message_printed = true
	end
	
	
	local azs = get(AZS)
	local alt = get(msl_alt) * 3.28083 -- MSL alt in feet
	local alt_baro = (29.92 - get(baro_press)) * 1000
	local alt_coef1 = interpolate(alt_table1, alt + alt_baro)  -- altitude coeficient for limit power under crit alt
	local alt_coef2 = interpolate(alt_table2, alt + alt_baro)  -- altitude coeficient for limit power under crit alt
	
	if XP11 then
		left_angle = interpolate(n1_table_11, get(N1) * alt_coef1) * azs * 3.07 + 50
		right_angle = interpolate(n2_table_11, get(N2) * alt_coef2) * azs * 3.07 + 50	
	else
		left_angle = interpolate(n1_table_10, get(N1) * alt_coef1) * azs * 3.07 + 50
		right_angle = interpolate(n2_table_10, get(N2) * alt_coef2) * azs * 3.07 + 50
	end
	
	--left_angle = get(N1) * azs * 3.07 + 50
	--right_angle = get(N2) * azs * 3.07 + 50

	passed = get(frame_time)
if  passed > 0 then
	-- set smooth move
	left_angle_actual = left_angle_last + (left_angle - left_angle_last) * passed * 4
	right_angle_actual = right_angle_last + (right_angle - right_angle_last) * passed * 4
end
	-- last variables

	left_angle_last = left_angle_actual
	right_angle_last = right_angle_actual

end


components = {

	-- right needle
    needle {
        position = { 10, 10, 180, 180 },
        image = get(needle_N1),
        angle = function()
            return right_angle_actual
        end
    },

    -- left needle
    needle {
        position = { 10, 10, 180, 180 },
        image = get(needle_N2),
        angle = function()
            return left_angle_actual
        end
    },


   -- positioning gauge
--[[	rectangle {
   		position = {99, 99, 2, 2},
   		color = {1,0,0,1},
   }, --]]

}

