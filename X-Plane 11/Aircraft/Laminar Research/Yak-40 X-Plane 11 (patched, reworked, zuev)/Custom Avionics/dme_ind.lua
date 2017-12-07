-- this is DME gauge with simple logic of power
size = {120, 120}

-- define properties
defineProperty("distance", globalPropertyf("sim/cockpit2/radios/indicators/dme_dme_distance_nm"))  -- distance in NM
defineProperty("dme_power_sw", globalPropertyf("sim/custom/xap/gauges/dme_power_sw")) -- power switcher for DME
defineProperty("dme_mode_sw", globalPropertyf("sim/custom/xap/gauges/dme_mode_sw")) -- mode switcher for DME, 0 = km, 1 = miles
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("inv_PO1500_steklo", globalPropertyi("sim/custom/xap/power/inv_PO1500_steklo")) -- inverter for 115v bus
defineProperty("AZS_DME_sw", globalPropertyf("sim/custom/xap/azs/AZS_DME_sw")) -- mode switcher for DME, 0 = km, 1 = miles\

-- images
--defineProperty("digitsImage", loadImage("white_digit_strip.png", 0, 0, 16, 196)) 
defineProperty("digitsImage", loadImage("red_digit_strip.png", 6, 0, 20, 392))

defineProperty("mile_img", loadImage("lamps2.png", 0, 98, 38, 15))
defineProperty("km_img", loadImage("lamps2.png", 0, 113, 38, 15))

-- initial switchers values
defineProperty("N1", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[0]"))   
defineProperty("N2", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[1]"))
defineProperty("frame_time", globalPropertyf("sim/custom/xap/An24_time/frame_time")) -- time for frames

local time_counter = 0
local not_loaded = true


local dist_km = 0
local dist_m = 0
local power = 0
local mode = 0
function update()
	

	power = get(DC_27_volt) > 21 and get(dme_power_sw) > 0 and get(AZS_DME_sw) > 0 and get(AC_115_volt) > 110 and get(inv_PO1500_steklo) == 1
	mode = 1 - get(dme_mode_sw)
	
	local dist = get(distance)
	dist_km = dist * (0.852 * mode + 1)
	if dist_km > 999.9 then dist_km = 999.9 end

	--print(mode, get(dme_mode_sw))
end





components = {

    -- distance digits
    digitstape {
        position = { 15, 60, 90, 25},
        image = digitsImage,
        digits = 4,
        showLeadingZeros = false,
		allowNonRound = true,
		fractional = 1,
		showSign = false,
        value = function()
           return dist_km
        end,
		visible = function()
			return power
		end,		
		
    };
	
	-- mile lamp
	textureLit {
		position = {21, 27, 38, 15},
		image = get(mile_img),
		visible = function()
			return power and mode == 0
		end
	
	},
	
	-- km lamp
	textureLit {
		position = {21, 11, 38, 15},
		image = get(km_img),
		visible = function()
			return power and mode == 1
		end
	
	},
		

	
--[[
	rectangle {
			position = {0,0,120,120},
			color = {1,0,0,1},
	}, 
--]]

}

