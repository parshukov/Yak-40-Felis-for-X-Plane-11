-- this is CourseMP panel
size = {2048, 2048}

defineProperty("kp_route", globalPropertyi("sim/custom/xap/gauges/kp_route")) -- switcher route-landing. 0 = landing, 1 = route
defineProperty("kp_mode", globalPropertyi("sim/custom/xap/gauges/kp_mode")) -- ILS or SP-50 mode. 0 = ILS, 1 = SP-50

defineProperty("k1_flag", globalPropertyi("sim/custom/xap/gauges/k1_flag")) -- flag for course on left kppm
defineProperty("g1_flag", globalPropertyi("sim/custom/xap/gauges/g1_flag")) -- flag for glide on left kppm

defineProperty("k2_flag", globalPropertyi("sim/custom/xap/gauges/k2_flag")) -- flag for course on left kppm
defineProperty("g2_flag", globalPropertyi("sim/custom/xap/gauges/g2_flag")) -- flag for glide on left kppm


-- power
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("inv_PO1500_radio", globalPropertyi("sim/custom/xap/power/inv_PO1500_radio")) -- inverter for 115v bus
defineProperty("AZS_KursMP_sw", globalPropertyi("sim/custom/xap/azs/AZS_KursMP_sw")) -- power switch on AZS panel

defineProperty("power_sw1", globalPropertyi("sim/custom/xap/gauges/nav1_power")) -- power switch
defineProperty("power_sw2", globalPropertyi("sim/custom/xap/gauges/nav2_power")) -- power switch

defineProperty("but_test_lamp", globalPropertyi("sim/custom/xap/buttons/but_test_lamp")) -- test lamps button


defineProperty("green_led", loadImage("leds.png", 100, 10, 10, 10)) 


local switch_sound = loadSample('Custom Sounds/metal_switch.wav')
local switcher_pushed = false
local k1_lamp = false
local g1_lamp = false
local k2_lamp = false
local g2_lamp = false

function update()
	local but_test = get(but_test_lamp) == 1
	local power = get(DC_27_volt) > 21 and get(AC_115_volt) > 110 and get(AZS_KursMP_sw) == 1 and get(inv_PO1500_radio) == 1 and get(AC_36_volt) > 30
	
	local power1 = power and get(power_sw1) == 1
	local power2 = power and get(power_sw2) == 1
	
	if power1 then
		k1_lamp = get(k1_flag) == 0 or but_test
		g1_lamp = get(g1_flag) == 0 or but_test
	else
		k1_lamp = false
		g1_lamp = false
	end
	
	if power2 then
		k2_lamp = get(k2_flag) == 0 or but_test
		g2_lamp = get(g2_flag) == 0 or but_test
	else
		k2_lamp = false
		g2_lamp = false
	end	



end




components = {

	-- K1 lamp
	textureLit {
		position = {1062, 882, 24, 24},
		image = get(green_led),
		visible = function()
			return k1_lamp
		end
	},

	-- G1 lamp
	textureLit {
		position = {1092, 882, 24, 24},
		image = get(green_led),
		visible = function()
			return g1_lamp
		end
	},

	-- K2 lamp
	textureLit {
		position = {1122, 882, 24, 24},
		image = get(green_led),
		visible = function()
			return k2_lamp
		end
	},

	-- G2 lamp
	textureLit {
		position = {1152, 882, 24, 24},
		image = get(green_led),
		visible = function()
			return g2_lamp
		end
	},
	
	
	
 	-- route mode switch
    switch {
        position = { 942, 649, 19, 19 },
        state = function()
            return get(kp_route) ~= 0
        end,
       -- btnOn = get(tmb_right),
       -- btnOff = get(tmb_left),
        onMouseClick = function()
			if not switcher_pushed then           
				playSample(switch_sound, 0)
				if get(kp_route) ~= 0 then
					set(kp_route, 0)
				else
					set(kp_route, 1)
				end
				switcher_pushed = true
			end
            return true
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,		
    }, 

 	-- landing mode switch
    switch {
        position = { 922, 649, 19, 19 },
        state = function()
            return get(kp_mode) ~= 0
        end,
       -- btnOn = get(tmb_right),
       -- btnOff = get(tmb_left),
        onMouseClick = function()
			if not switcher_pushed then           
				playSample(switch_sound, 0)
				if get(kp_mode) ~= 0 then
					set(kp_mode, 0)
				else
					set(kp_mode, 1)
				end
				switcher_pushed = true
			end
            return true
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,		
    }, 






}