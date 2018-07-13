size = {2048, 2048}

-- define property table
-- datarefs
defineProperty("outer_marker", globalPropertyi("sim/cockpit/misc/outer_marker_lit"))   -- runway markers
defineProperty("middle_marker", globalPropertyi("sim/cockpit/misc/middle_marker_lit"))
defineProperty("inner_marker", globalPropertyi("sim/cockpit/misc/inner_marker_lit"))

defineProperty("alt", globalPropertyf("sim/flightmodel/position/y_agl"))
--defineProperty("marker_audio", globalPropertyi("sim/cockpit/radios/gear_audio_working"))

-- power
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("mrp_cc", globalPropertyf("sim/custom/xap/gauges/mrp_cc"))
defineProperty("but_test_lamp", globalPropertyi("sim/custom/xap/buttons/but_test_lamp")) -- test lamps button
-- fail
defineProperty("fail", globalPropertyi("sim/operation/failures/rel_marker"))

-- from left CourseMP panel
defineProperty("power_sw", globalPropertyi("sim/custom/xap/gauges/nav1_power")) -- power switch
defineProperty("kp_fail", globalPropertyf("sim/operation/failures/rel_nav1"))
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("inv_PO1500_radio", globalPropertyi("sim/custom/xap/power/inv_PO1500_radio")) -- inverter for 115v bus
defineProperty("nav_button", globalPropertyi("sim/custom/xap/gauges/nav1_button")) -- test buttons
defineProperty("AZS_KursMP_sw", globalPropertyi("sim/custom/xap/azs/AZS_KursMP_sw")) -- power switch on AZS panel

-- images
defineProperty("outer_led", loadImage("lamps.png", 0, 175, 60, 25))
defineProperty("middle_led", loadImage("lamps.png", 60, 175, 60, 25))
defineProperty("inner_led", loadImage("lamps.png", 120, 175, 60, 25))

local tone1 = loadSample('Custom Sounds/tone_1.wav')
local tone2 = loadSample('Custom Sounds/tone_2.wav')
local tone3 = loadSample('Custom Sounds/tone_3.wav')

local out_lit = false
local mid_lit = false
local in_lit = false

function update()

	local kp_power = get(DC_27_volt) > 21 and get(power_sw) == 1 and get(kp_fail) < 6 and get(AC_115_volt) > 110 and get(AZS_KursMP_sw) == 1 and get(inv_PO1500_radio) == 1 and get(AC_36_volt) > 30
	local but = get(nav_button)
	local test_lamp = get(but_test_lamp) == 1
	--print(mode)
	if get(DC_27_volt) > 21 and get(alt) < 5000 then
		set(mrp_cc, 2)
		set(fail, 0)
		out_lit = get(outer_marker) > 0 or test_lamp or kp_power and but == 1
		mid_lit = get(middle_marker) > 0 or test_lamp or kp_power and but == 2
		in_lit = get(inner_marker) > 0 or test_lamp or kp_power and but == 3
		
		if out_lit and not isSamplePlaying(tone3) and not test_lamp then playSample(tone3, 1) end
		if not out_lit then stopSample(tone3) end
		
		if mid_lit and not isSamplePlaying(tone2) and not test_lamp then playSample(tone2, 1) end
		if not mid_lit then stopSample(tone2) end

		if in_lit and not isSamplePlaying(tone1) and not test_lamp then playSample(tone1, 1) end
		if not in_lit then stopSample(tone1) end		

	else
		set(mrp_cc, 0)
		set(fail, 6)
		out_lit = false
		mid_lit = false
		in_lit = false
	end

end


components = {

	-- outer marker light
	textureLit {
		image = get(outer_led),
		position = {1233, 930, 60, 25},
		visible = function()
			return out_lit
		end,
	},

	-- middle marker light
	textureLit {
		image = get(middle_led),
		position = {1233, 883, 60, 25},
		visible = function()
			return mid_lit
		end,
	},

	-- inner marker light
	textureLit {
		image = get(inner_led),
		position = {1233, 838, 60, 25},
		visible = function()
			return in_lit
		end,
	},



}



