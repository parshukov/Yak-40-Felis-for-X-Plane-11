-- this is BSPK system
size = {2048, 2048} -- cover whole panel

-- power
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("bspk_cc", globalPropertyf("sim/custom/xap/gauges/bspk_cc")) -- cc

defineProperty("AZS_bspk_sw", globalPropertyi("sim/custom/xap/azs/AZS_bspk_sw"))

defineProperty("but_test_lamp", globalPropertyi("sim/custom/xap/buttons/but_test_lamp")) -- test lamps button
defineProperty("bspk_siren", globalPropertyi("sim/custom/xap/gauges/bspk_siren")) -- BSPK signal
defineProperty("bspk_err", globalPropertyi("sim/custom/xap/gauges/bspk_err")) -- bspk error



-- sources
defineProperty("pitch_1", globalPropertyf("sim/custom/xap/gauges/pitch_1"))
defineProperty("roll_1", globalPropertyf("sim/custom/xap/gauges/roll_1"))
defineProperty("pitch_2", globalPropertyf("sim/custom/xap/gauges/pitch_3"))
defineProperty("roll_2", globalPropertyf("sim/custom/xap/gauges/roll_3"))

-- ias variable
defineProperty("ias", globalPropertyf("sim/cockpit2/gauges/indicators/airspeed_kts_pilot"))

-- images
defineProperty("check_ahz_led", loadImage("lamps.png", 180, 50, 60, 25)) 
defineProperty("left_bank_led", loadImage("lamps.png", 60, 25, 60, 25)) 
defineProperty("right_bank_led", loadImage("lamps.png", 120, 25, 60, 25)) 


local left_bank = false
local right_bank = false
local check_ahz = false


function update()
	-- check power
	local power = get(DC_27_volt) > 21
	local power36 = get(AC_36_volt) > 30
	local bspk = get(AZS_bspk_sw) == 1
	local test_lamp = get(but_test_lamp) == 1
	
	local roll1 = get(roll_1)
	local roll2 = get(roll_2)
	
	local pitch1 = get(pitch_1)
	local pitch2 = get(pitch_2)
	
	local spd = get(ias) * 1.852
	
	-- check ahz
	if power then
		check_ahz = bspk and (math.abs(roll1 - roll2) > 7 or math.abs(pitch1 - pitch2) > 7) and power36 or test_lamp
	else check_ahz = false end
	
	-- left bank too large
	if power then
		left_bank = ((roll1 < -32 and spd > 230) or (roll1 < -15 and spd <= 230)) and not check_ahz and bspk and power36 or test_lamp
	else left_bank = false end

	-- right bank too large
	if power then
		right_bank = ((roll1 > 32 and spd > 230) or (roll1 > 15 and spd <= 230)) and not check_ahz and bspk and power36 or test_lamp
	else right_bank = false end

	-- set sirene
	if (left_bank or right_bank) and not test_lamp then set(bspk_siren, 1) else set(bspk_siren, 0) end 
	
	-- set cc
	if power and power36 and bspk then set(bspk_cc, 0.5) else set(bspk_cc, 0) end
	
	-- set bspk error
	if check_ahz and not test_lamp then set(bspk_err, 1) else set(bspk_err, 0) end
	
end


components = {
	-- check ahz
	textureLit {
		position = { 1232, 973, 59, 25},
		image = get(check_ahz_led),
		visible = function()
			return check_ahz
		end
	},	

	-- bank left
	textureLit {
		position = { 1377, 973, 59, 25},
		image = get(left_bank_led),
		visible = function()
			return left_bank
		end
	},	

	-- bank right
	textureLit {
		position = { 1449, 973, 59, 25},
		image = get(right_bank_led),
		visible = function()
			return right_bank
		end
	},	

	
}