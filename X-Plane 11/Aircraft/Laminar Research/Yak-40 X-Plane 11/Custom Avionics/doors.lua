-- this is ladder logic
size = {2048, 2048}
-- sources
defineProperty("ladder_power_sw", globalPropertyf("sim/custom/xap/misc/ladder_power_sw"))
defineProperty("ladder_sw", globalPropertyf("sim/custom/xap/misc/ladder_sw"))
defineProperty("ladder_sw_cap", globalPropertyf("sim/custom/xap/misc/ladder_sw_cap"))
defineProperty("AZS_ladder_sw", globalPropertyf("sim/custom/xap/azs/AZS_ladder_sw"))
defineProperty("but_test_lamp", globalPropertyi("sim/custom/xap/buttons/but_test_lamp")) -- test lamps button

defineProperty("emerg_press", globalPropertyf("sim/custom/xap/hydro/emerg_press")) -- pressure in emergency system. initial 120 kg per square sm. maximum 160.

defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
-- result
defineProperty("sim_ladder", globalPropertyi("sim/cockpit2/switches/custom_slider_on[3]"))
defineProperty("sim_ladder_pos", globalPropertyf("sim/flightmodel2/misc/custom_slider_ratio[3]"))
-- images 
defineProperty("red_led", loadImage("leds.png", 40, 0, 20, 20)) 

local switch_sound = loadSample('Custom Sounds/metal_switch.wav')
local cap_sound = loadSample('Custom Sounds/cap.wav')

local switch_last = 0
local switcher_pushed = false

local ladder_lit = false

function update()

	local power = get(DC_27_volt) > 21 and get(AZS_ladder_sw) == 1 and get(ladder_power_sw) == 1 
		
	if power and get(emerg_press) > 20 then
		if get(ladder_sw) == 1 then 
			set(sim_ladder, 1)
			switch_last = 1
		else 
			set(sim_ladder, 0)
			switch_last = 0
		end
	else
		set(sim_ladder, switch_last)
	end
		
	-- lamps
	
	local test_lamp = get(but_test_lamp) == 1
	ladder_lit = power and get(sim_ladder_pos) > 0.05 or test_lamp
		
		
end


components = {

	-- ladder lamp
	textureLit {
		position = {1004, 792, 24, 24},
		image = get(red_led),
		visible = function()
			return ladder_lit
		end
	},
	
	
	-- ladder_power_sw switcher
    switch {
        position = {862, 689, 19, 19},
        state = function()
            return get(ladder_power_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(ladder_power_sw) ~= 0 then
					set(ladder_power_sw, 0)
				else
					set(ladder_power_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- ladder_sw switcher
    switch {
        position = {882, 689, 19, 19},
        state = function()
            return get(ladder_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and get(ladder_sw_cap) == 1 then
				playSample(switch_sound, 0)
				if get(ladder_sw) ~= 0 then
					set(ladder_sw, 0)
				else
					set(ladder_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- ladder_sw_cap switcher
    switch {
        position = {1800, 647, 43, 100},
        state = function()
            return get(ladder_sw_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(ladder_sw_cap) ~= 0 then
					set(ladder_sw_cap, 0)
					if get(ladder_sw) == 1 then playSample(switch_sound, 0) end
					set(ladder_sw, 0)
				else
					set(ladder_sw_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },



}