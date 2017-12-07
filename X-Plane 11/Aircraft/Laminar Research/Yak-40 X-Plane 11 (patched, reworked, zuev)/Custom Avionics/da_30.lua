size = { 200, 200 }

-- initialize component property table
defineProperty("vvi", globalPropertyf("sim/cockpit2/gauges/indicators/vvi_fpm_pilot"))
defineProperty("turn", globalPropertyf("sim/cockpit2/gauges/indicators/turn_rate_heading_deg_pilot"))

-- power
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("AZS_da30_sw", globalPropertyi("sim/custom/xap/azs/AZS_da30_sw")) -- gauge switcher
defineProperty("da30_cc", globalPropertyf("sim/custom/xap/gauges/da30_cc")) -- current consumption



-- needle image
defineProperty("vvi_needle", loadImage("needles.png", 86, 73, 18, 173))
defineProperty("turn_needle", loadImage("needles.png", 203, 9, 162, 14))

local variometer_table = { 
{  -10000000, -180 },
{  -30, -180 },
{  -20, -140 }, 
{  -10, -80 },
{  10, 80 },
{  20, 140 },
{  30, 180 },
{ 10000000, 180 }} 

local function interpolate(tbl, value) -- interpolate values using tables
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

-- post frame calculations
local turn_ind_angle = 0
local vvi_angle = -90

function update()
	-- check power and current
	local power = 0
	if get(DC_27_volt) > 21 and get(AZS_da30_sw) > 0 and get(AC_36_volt) > 30 then
		power = 1
		set(da30_cc, 2)
	else
		power = 0
		set(da30_cc, 0)
	end

	-- calculate turn needle position
	if power > 0 then
		turn_ind_angle = get(turn) * 0.6
	else turn_ind_angle = 0 end

	-- set limits
	if turn_ind_angle > 35 then turn_ind_angle = 35
	elseif turn_ind_angle < -35 then turn_ind_angle = -35 end
	
	-- calculate vvi needle position
    vvi_angle = interpolate(variometer_table, get(vvi) * 0.00508) -90
end


components = {
	-- positioning gauge
	rectangle {
		position = {99, 99, 2, 2},
		color = {1, 0, 0, 1},
	},

	-- turn needle
	needle {
		position = {-20, -88, 240, 240},
		image = get(turn_needle),
		angle = function()
			return turn_ind_angle + 90
		end,
	},
	
    -- vvi needle
	needle {
        position = { 10, 10, 180, 180 },
        image = get(vvi_needle),
        angle = function() 
			return vvi_angle
        end
    }, 
	
	
}

