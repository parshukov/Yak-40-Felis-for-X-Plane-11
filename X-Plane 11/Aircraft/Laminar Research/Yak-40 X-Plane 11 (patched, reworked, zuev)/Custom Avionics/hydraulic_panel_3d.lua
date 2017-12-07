-- this is indication of hydraulic system 

size = {2048, 2048} -- panel will contain a several gauges in different plases of panel texture

-- define properties
defineProperty("main_press", globalPropertyf("sim/custom/xap/hydro/main_press")) -- pressure in main system. initial 120 kg per square sm. maximum 160.
defineProperty("emerg_press", globalPropertyf("sim/custom/xap/hydro/emerg_press")) -- pressure in emergency system. initial 120 kg per square sm. maximum 160.
defineProperty("hydro_quantity", globalPropertyf("sim/custom/xap/hydro/hydro_quantity")) -- quantity of hydraulic liquid. initially 28 liters. in work downs to 21 liters. also can flow out in come case of failure.
defineProperty("emerg_pump_sw", globalPropertyi("sim/custom/xap/hydro/emerg_pump_sw"))  -- emergency hydro pump switcher. if its ON and power exist - emergency bus will gain pressure
defineProperty("emerg_pump_sw_cap", globalPropertyi("sim/custom/xap/hydro/emerg_pump_sw_cap"))  -- emergency hydro pump switcher. if its ON and power exist - emergency bus will gain pressure
defineProperty("manometer_sw", globalPropertyi("sim/custom/xap/misc/manometer_sw"))  -- turn ON all manometers
defineProperty("wiper_sw", globalPropertyi("sim/cockpit2/switches/wiper_speed")) 

-- power
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("hyd_ind_cc", globalPropertyf("sim/custom/xap/hydro/hyd_ind_cc"))
-- needles and lamps
defineProperty("ind_main_press_angle", globalPropertyf("sim/custom/xap/hydro/ind_main_press_angle"))
defineProperty("ind_emerg_press_angle", globalPropertyf("sim/custom/xap/hydro/ind_emerg_press_angle"))
defineProperty("qty_low_lit", globalPropertyi("sim/custom/xap/hydro/qty_low_lit"))
defineProperty("qty_norm_lit", globalPropertyi("sim/custom/xap/hydro/qty_norm_lit"))
defineProperty("press_low_lit", globalPropertyi("sim/custom/xap/hydro/press_low_lit"))

defineProperty("but_test_lamp", globalPropertyi("sim/custom/xap/buttons/but_test_lamp")) -- test lamps button
defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- frame time

-- define images
defineProperty("needles_1", loadImage("needles.png", 0, 2, 16, 88)) 
defineProperty("needles_2", loadImage("needles.png", 86, 73, 18, 173))

defineProperty("yellow_led", loadImage("leds.png", 60, 0, 20, 20)) 
defineProperty("green_led", loadImage("leds.png", 20, 0, 20, 20)) 
defineProperty("red_led", loadImage("leds.png", 40, 0, 20, 20)) 
defineProperty("low_qty_led", loadImage("lamps2.png", 60, 0, 60, 25)) 
defineProperty("left_fail_led", loadImage("lamps.png", 180, 0, 60, 25))
defineProperty("mid_fail_led", loadImage("lamps.png", 0, 25, 60, 25))

-- engines work
defineProperty("N1", globalPropertyf("sim/flightmodel/engine/ENGN_N1_[1]"))   
defineProperty("N2", globalPropertyf("sim/flightmodel/engine/ENGN_N1_[0]"))
defineProperty("N3", globalPropertyf("sim/flightmodel/engine/ENGN_N1_[2]"))

local switch_sound = loadSample('Custom Sounds/metal_switch.wav')
local cap_sound = loadSample('Custom Sounds/cap.wav')

local time_counter = 0
local not_loaded = true
local time_coef = 10
local switcher_pushed = false


local emerg_press_angle = -60
local main_press_angle = 195

local emerg_press_angle_last = -60
local main_press_angle_last = 195
local side_press_angle = -120

local lamp_qty_norm = false
local lamp_qty_low = false
local lamp_low_press = false

local lamp_left_fail = false
local lamp_mid_fail = false

local power27 = 0
local power36 = 0

-- every frame calculations.
function update()
	local passed = get(frame_time) -- time of frame
	
	-- initial switchers values
	time_counter = time_counter + passed
	local eng_n1 = get(N1)
	local eng_n2 = get(N2)
	if eng_n1 < 10 and eng_n2 < 10 and get(N3) < 10 and time_counter > 0.3 and time_counter < 0.4 and not_loaded then
		set(manometer_sw, 0)
		not_loaded = false
	end

	-- calculate power
	if get(DC_27_volt) > 21 then power27 = 1 else power27 = 0 end
	if get(AC_36_volt) > 30 then power36 = 1 else power36 = 0 end
	
	local manometers = get(manometer_sw)
	
	-- calculate main pressure indicator
	local main_press_angle_need = -get(main_press) * 120 / 240 + 195
	if power36 == 0 or manometers == 0 then main_press_angle_need = 200 end
	main_press_angle = main_press_angle + (main_press_angle_need - main_press_angle_last) * passed * time_coef	
	
	-- calculate emergency pressure indicator
	local emerg_press_angle_need = get(emerg_press) * 120 / 240 - 105
	if power36 == 0 or manometers == 0 then emerg_press_angle_need = -110 end
	emerg_press_angle = emerg_press_angle + (emerg_press_angle_need - emerg_press_angle_last) * passed * time_coef
	
	local side_press_need = get(emerg_press) * 240 / 250 - 120
	side_press_angle = side_press_angle + (side_press_need - side_press_angle) * passed * time_coef
	
	-- set last values
	emerg_press_angle_last = emerg_press_angle
	main_press_angle_last = main_press_angle
	
	-- power CC
	if power27 == 1 and power36 == 1 and manometers == 1 then set(hyd_ind_cc, 3) else set(hyd_ind_cc, 0) end
	
	-- calculate lamps
	local lamp_test = get(but_test_lamp) == 1
	if power27 == 1 then
		local qty = get(hydro_quantity)
		lamp_qty_norm = qty >= 0.5 or lamp_test
		lamp_qty_low = qty < 0.5 or lamp_test
		lamp_low_press = get(emerg_press) < 110 or lamp_test
		lamp_left_fail = eng_n1 < 15 or lamp_test
		lamp_mid_fail = eng_n2 < 15 or lamp_test
	else
		lamp_qty_norm = false
		lamp_qty_low = false
		lamp_low_press = false
		lamp_left_fail = false
		lamp_mid_fail = false
	end

	
	-- set vars for panels
	set(ind_main_press_angle, main_press_angle)
	set(ind_emerg_press_angle, emerg_press_angle)

	if lamp_qty_low then set(qty_low_lit, 1) else set(qty_low_lit, 0) end
	if lamp_qty_norm then set(qty_norm_lit, 1) else set(qty_norm_lit, 0) end
	if lamp_low_press then set(press_low_lit, 1) else set(press_low_lit, 0) end
	
	-- set wiper switch to zero if pressure is low
	if get(main_press) < 20 then set(wiper_sw, 0) end
	
end

-- components
components = {
	
	-----------------------
	-- needle indicators --
	-----------------------
	-- emergency pressure indicator
	needle { 
		image = get(needles_1),
		position = {1171, 1306, 88, 88},
		angle = function()
		return emerg_press_angle
		end,	
	},


	-- main pressure indicator
	needle { 
		image = get(needles_1),
		position = {1101, 1381, 88, 88},
		angle = function()
		return main_press_angle
		end,	
	},

	-- emergency pressure indicator
	needle { 
		image = get(needles_2),
		position = {211, 1857, 176, 176},
		angle = function()
		return emerg_press_angle
		end,	
	},	

	--------------------
	-- lamps and leds --
	--------------------
	-- hydro qty normal
	textureLit {
		position = { 884, 762, 22, 22},
		image = get(green_led),
		visible = function()
			return lamp_qty_norm
		end
	},
	
	-- hydro qty low
	textureLit {
		position = { 915, 762, 22, 22},
		image = get(red_led),
		visible = function()
			return lamp_qty_low
		end
	},	
	textureLit {
		position = { 1810, 1019, 59, 25},
		image = get(low_qty_led),
		visible = function()
			return lamp_qty_low
		end
	},	
	
	-- hydro press low
	textureLit {
		position = { 1185, 852, 22, 22},
		image = get(red_led),
		visible = function()
			return lamp_low_press
		end
	},	
	
	-- left fail
	textureLit {
		position = { 1595, 1019, 59, 25},
		image = get(left_fail_led),
		visible = function()
			return lamp_left_fail
		end
	},
	
	-- mid fail
	textureLit {
		position = { 1667, 1019, 59, 25},
		image = get(mid_fail_led),
		visible = function()
			return lamp_mid_fail
		end
	},

	---------------
	-- switchers --
	---------------

--[[	rectangle {
		position = {1962, 649, 40, 100},
	},
--]]
    -- emerg_pump_sw switcher
    clickable {
        position = {922, 588, 19, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			 if not switcher_pushed and get(emerg_pump_sw_cap) == 1 then
				local a = get(emerg_pump_sw)
				if a < 1 then playSample(switch_sound, 0) end
				a = a + 1
				if a > 1 then a = 1 end
				set(emerg_pump_sw, a)
				switcher_pushed = true
			end
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			return true
		end,
		
    },
    clickable {
        position = {922, 598, 19, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			 if not switcher_pushed and get(emerg_pump_sw_cap) == 1 then
				local a = get(emerg_pump_sw)
				if a > -1 then playSample(switch_sound, 0) end
				a = a - 1
				if a < -1 then a = -1 end
				set(emerg_pump_sw, a)
				switcher_pushed = true
			end
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			return true
		end,
		
    },


    -- emerg_pump_sw_cap switcher
    switch {
        position = {1881, 649, 40, 100},
        state = function()
            return get(emerg_pump_sw_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(emerg_pump_sw_cap) ~= 0 then
					set(emerg_pump_sw_cap, 0)
					if get(emerg_pump_sw) ~= 1 then playSample(switch_sound, 0) end
					set(emerg_pump_sw, 1)
				else
					set(emerg_pump_sw_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

    -- manometers switcher
    switch {
        position = {942, 588, 19, 19},
        state = function()
            return get(manometer_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(manometer_sw) ~= 0 then
					set(manometer_sw, 0)
				else
					set(manometer_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

--[[
    -- wiper_sw switcher
    switch {
        position = {687, 370, 80, 70},
        state = function()
            return get(wiper_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				if get(wiper_sw) ~= 0 then
					set(wiper_sw, 0)
				else
					set(wiper_sw, 2)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },
--]]
	
}
