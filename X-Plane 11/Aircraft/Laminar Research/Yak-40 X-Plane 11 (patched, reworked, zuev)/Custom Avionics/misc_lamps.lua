-- this is lamps logic for engine indication and some other
size = {2048, 2048}


-- power
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("but_test_lamp", globalPropertyi("sim/custom/xap/buttons/but_test_lamp")) -- test lamps button

-- sources
defineProperty("oil_quan1", globalPropertyf("sim/cockpit2/engine/indicators/oil_quantity_ratio[1]")) -- oil quantity
defineProperty("oil_quan2", globalPropertyf("sim/cockpit2/engine/indicators/oil_quantity_ratio[0]")) -- oil quantity
defineProperty("oil_quan3", globalPropertyf("sim/cockpit2/engine/indicators/oil_quantity_ratio[2]")) -- oil quantity
defineProperty("chip1", globalPropertyf("sim/cockpit/warnings/annunciators/chip_detected[1]")) -- chip detected
defineProperty("chip2", globalPropertyf("sim/cockpit/warnings/annunciators/chip_detected[0]")) -- chip detected
defineProperty("chip3", globalPropertyf("sim/cockpit/warnings/annunciators/chip_detected[2]")) -- chip detected
defineProperty("cr_flag1", globalPropertyf("sim/custom/xap/gauges/nav1_tofrom")) -- Nav-To-From indication, nav1, pilot, 0 is flag, 1 is to, 2 is from.
defineProperty("cr_flag2", globalPropertyf("sim/custom/xap/gauges/nav2_tofrom")) -- Nav-To-From indication, nav1, copilot, 0 is flag, 1 is to, 2 is from.

defineProperty("oil_p1", globalPropertyf("sim/cockpit2/engine/indicators/oil_pressure_psi[1]"))
defineProperty("oil_p2", globalPropertyf("sim/cockpit2/engine/indicators/oil_pressure_psi[0]"))
defineProperty("oil_p3", globalPropertyf("sim/cockpit2/engine/indicators/oil_pressure_psi[2]"))

defineProperty("flaps_lamp_lit", globalPropertyi("sim/custom/xap/gauges/flaps_lamp_lit")) -- flaps signal
defineProperty("gear_lamp_lit", globalPropertyi("sim/custom/xap/gauges/gear_lamp_lit")) -- gear signal

defineProperty("AZS_da30_sw", globalPropertyi("sim/custom/xap/azs/AZS_da30_sw")) -- gauge switcher
defineProperty("reverser", globalPropertyf("sim/flightmodel2/engines/thrust_reverser_deploy_ratio[0]")) -- reverse ON
defineProperty("rev_switch", globalPropertyf("sim/custom/xap/misc/rev_switch")) -- reverse switch on central panel

defineProperty("vvi", globalPropertyf("sim/flightmodel/position/vh_ind"))
defineProperty("altitude", globalPropertyf("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot"))  -- altitude, measured by gauge

-- define images
defineProperty("high_vibro1_led", loadImage("lamps.png", 120, 100, 60, 25))
defineProperty("high_vibro2_led", loadImage("lamps.png", 180, 100, 60, 25))
defineProperty("high_vibro3_led", loadImage("lamps.png", 0, 125, 60, 25))
defineProperty("low_oil1_led", loadImage("lamps2.png", 120, 0, 60, 25))
defineProperty("low_oil2_led", loadImage("lamps2.png", 180, 0, 60, 25))
defineProperty("low_oil3_led", loadImage("lamps2.png", 0, 25, 60, 25))
defineProperty("chip1_led", loadImage("lamps2.png", 60, 25, 60, 25))
defineProperty("chip2_led", loadImage("lamps2.png", 120, 25, 60, 25))
defineProperty("chip3_led", loadImage("lamps2.png", 180, 25, 60, 25))
defineProperty("da30_fail_led", loadImage("lamps2.png", 0, 0, 60, 25))
defineProperty("to_VOR_led", loadImage("lamps.png", 120, 150, 60, 25))
defineProperty("from_VOR_led", loadImage("lamps.png", 180, 150, 60, 25))
defineProperty("min_oilP_led", loadImage("lamps.png", 60, 100, 60, 25))
defineProperty("gear_led", loadImage("lamps.png", 120, 225, 60, 25))
defineProperty("flap_led", loadImage("lamps.png", 180, 225, 60, 25))
defineProperty("rev_led", loadImage("lamps2.png", 180, 50, 60, 25))
defineProperty("ass_led", loadImage("lamps2.png", 120, 50, 60, 25))

defineProperty("yellow_led", loadImage("leds.png", 60, 0, 20, 20)) 
defineProperty("green_led", loadImage("leds.png", 20, 0, 20, 20)) 
defineProperty("red_led", loadImage("leds.png", 40, 0, 20, 20)) 
defineProperty("red_small_led", loadImage("leds.png", 110, 0, 10, 10)) 
defineProperty("yellow_small_led", loadImage("leds.png", 100, 0, 10, 10)) 

local low_oil_quan1 = false
local low_oil_quan2 = false
local low_oil_quan3 = false

local chip_det1 = false
local chip_det2 = false
local chip_det3 = false

local da30_fail = false

local to_VOR1 = false
local from_VOR1 = false
local to_VOR2 = false
local from_VOR2 = false
local fake_lit = false
local min_oilP = false

local gear_lamp = false
local flap_lamp = false

local rev_lamp = false
local rev_green_lamp = false
local rev_off_lamp = false

local ass_lamp = false

function update()

	local power = get(DC_27_volt) > 20
	local but_test = get(but_test_lamp) == 1
	
	if power then
		low_oil_quan1 = get(oil_quan1) < 0.3 or but_test
		low_oil_quan2 = get(oil_quan2) < 0.3 or but_test
		low_oil_quan3 = get(oil_quan3) < 0.3 or but_test
		chip_det1 = get(chip1) == 1 or but_test
		chip_det2 = get(chip2) == 1 or but_test
		chip_det3 = get(chip3) == 1 or but_test
		da30_fail = get(AZS_da30_sw) == 0 or but_test
		to_VOR1 = get(cr_flag1) == 1 or but_test
		from_VOR1 = get(cr_flag1) == 2 or but_test
		to_VOR2 = get(cr_flag2) == 1 or but_test
		from_VOR2 = get(cr_flag2) == 2 or but_test
		fake_lit = but_test
		min_oilP = (get(oil_p1) + get(oil_p2) + get(oil_p3)) * 0.07031 < 5 or but_test
		gear_lamp = get(gear_lamp_lit) == 1 or but_test
		flap_lamp = get(flaps_lamp_lit) == 1 or but_test
		rev_lamp = get(reverser) > 0.9 or but_test
		rev_off_lamp = get(reverser) < 0.1 and get(rev_switch) == 0 or but_test
		rev_green_lamp = get(reverser) > 0.9 and get(rev_switch) == 1 or but_test
	else
		low_oil_quan1 = false
		low_oil_quan2 = false
		low_oil_quan3 = false	
		chip_det1 = false
		chip_det2 = false
		chip_det3 = false
		da30_fail = false
		to_VOR1 = false
		from_VOR1 = false
		to_VOR2 = false
		from_VOR2 = false	
		fake_lit = false
		min_oilP = false
		gear_lamp = false
		flap_lamp = false
		rev_lamp = false
		rev_off_lamp = false
		rev_green_lamp = false
	end

	ass_lamp = get(vvi) < -15 and get(altitude) > 10 and get(altitude) < 50

end


components = {

	-- reverse led
	textureLit {
		position = {1666, 973, 60, 26},
		image = get(rev_led),
		visible = function()
			return rev_lamp
		end
	},

	-- reverse led
	textureLit {
		position = {973, 881, 24, 24},
		image = get(yellow_led),
		visible = function()
			return rev_green_lamp
		end
	},
	-- reverse led
	textureLit {
		position = {973, 851, 24, 24},
		image = get(green_led),
		visible = function()
			return rev_off_lamp
		end
	},
	
	-- gears led
	textureLit {
		position = {1972, 973, 60, 26},
		image = get(gear_led),
		visible = function()
			return gear_lamp
		end
	},

	-- flaps led
	textureLit {
		position = {1972, 927, 60, 26},
		image = get(flap_led),
		visible = function()
			return flap_lamp
		end
	},	

	-- mininmum oil P
	textureLit {
		position = { 1309, 837, 60, 26},
		image = get(min_oilP_led),
		visible = function()
			return min_oilP
		end
	},

	-- filter block
	textureLit {
		position = { 825, 883, 22, 22},
		image = get(yellow_small_led),
		visible = function()
			return fake_lit
		end
	},

	-- to_VOR1
	textureLit {
		position = { 1376, 933, 60, 26},
		image = get(to_VOR_led),
		visible = function()
			return to_VOR1
		end
	},

	-- from_VOR1
	textureLit {
		position = { 1448, 933, 60, 26},
		image = get(from_VOR_led),
		visible = function()
			return from_VOR1
		end
	},

	-- to_VOR2
	textureLit {
		position = { 1671, 879, 60, 26},
		image = get(to_VOR_led),
		visible = function()
			return to_VOR2
		end
	},

	-- from_VOR2
	textureLit {
		position = {  1743, 879, 60, 26},
		image = get(from_VOR_led),
		visible = function()
			return from_VOR2
		end
	},
	
	-- da30_fail
	textureLit {
		position = { 1737, 1019, 60, 25},
		image = get(da30_fail_led),
		visible = function()
			return da30_fail
		end
	},

	-- low_oil_quan1
	textureLit {
		position = { 1737, 973, 60, 25},
		image = get(low_oil1_led),
		visible = function()
			return low_oil_quan1
		end
	},	

	-- low_oil_quan2
	textureLit {
		position = { 1810, 973, 60, 25},
		image = get(low_oil2_led),
		visible = function()
			return low_oil_quan2
		end
	},	

	-- low_oil_quan3
	textureLit {
		position = { 1881, 973, 60, 25},
		image = get(low_oil3_led),
		visible = function()
			return low_oil_quan3
		end
	},	

	-- chip_det1
	textureLit {
		position = { 1737, 928, 60, 25},
		image = get(chip1_led),
		visible = function()
			return chip_det1
		end
	},	

	-- chip_det2
	textureLit {
		position = { 1810, 928, 60, 25},
		image = get(chip2_led),
		visible = function()
			return chip_det2
		end
	},	

	-- chip_det3
	textureLit {
		position = { 1881, 928, 60, 25},
		image = get(chip3_led),
		visible = function()
			return chip_det3
		end
	},	


	-- ass led
	textureLit {
		position = {1303, 1019, 60, 26},
		image = get(ass_led),
		visible = function()
			return ass_lamp
		end
	},




}


