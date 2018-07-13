-- this is antiice system
size = {2048, 2048}

-- switcher
defineProperty("pitot1", globalPropertyi("sim/custom/xap/antiice/pitot1"))   -- pitot heat 1
defineProperty("pitot2", globalPropertyi("sim/custom/xap/antiice/pitot2"))   -- pitot heat 2
defineProperty("eng1", globalPropertyi("sim/custom/xap/antiice/eng1"))   -- eng heat 1
defineProperty("eng2", globalPropertyi("sim/custom/xap/antiice/eng2"))   -- eng heat 2
defineProperty("eng3", globalPropertyi("sim/custom/xap/antiice/eng3"))   -- eng heat 3
defineProperty("system_sw", globalPropertyi("sim/custom/xap/antiice/system_sw"))   -- system switch. 1 = ON, 0 = OFF, -1 = test
defineProperty("system_cap", globalPropertyi("sim/custom/xap/antiice/system_cap"))   -- system switch cap
defineProperty("system_mode1", globalPropertyi("sim/custom/xap/antiice/system_mode1"))   -- system mode. 1 = auto, 0 = hard
defineProperty("system_mode2", globalPropertyf("sim/custom/xap/antiice/system_mode2"))   -- system mode. 0 = pre, 1 = full
defineProperty("window", globalPropertyi("sim/custom/xap/antiice/window"))   -- window heat
defineProperty("rio3", globalPropertyi("sim/custom/xap/antiice/rio3"))   -- ice sensor
defineProperty("aoa", globalPropertyi("sim/custom/xap/antiice/aoa"))   -- aoa sensor

defineProperty("virt_rud2", globalPropertyf("sim/custom/xap/eng/virt_rud2"))
defineProperty("virt_rud3", globalPropertyf("sim/custom/xap/eng/virt_rud3"))

defineProperty("air_engine", globalPropertyf("sim/custom/xap/antiice/air_engine"))

defineProperty("check_btn", globalPropertyf("sim/custom/xap/antiice/check_btn")) -- check button



-- sim datarefs
defineProperty("pitot_1", globalPropertyi("sim/cockpit/switches/pitot_heat_on"))   -- pitot heat 1
defineProperty("pitot_2", globalPropertyi("sim/cockpit/switches/pitot_heat_on2"))   -- pitot heat 2
defineProperty("wind_ht", globalPropertyi("sim/cockpit/switches/anti_ice_window_heat"))   -- window heat
defineProperty("wing_ht", globalPropertyi("sim/cockpit/switches/anti_ice_surf_heat"))  -- on/off wing heat
defineProperty("engine_ht", globalPropertyi("sim/cockpit2/ice/ice_inlet_heat_on"))  -- on/off engine heat
defineProperty("ice_detect", globalPropertyi("sim/cockpit2/ice/ice_detect_on"))  -- on/off ice detection
defineProperty("aoa_ht", globalPropertyi("sim/cockpit2/ice/ice_AOA_heat_on"))  -- on/off AOA heat

defineProperty("ice_on_plane", globalPropertyi("sim/cockpit2/annunciators/ice"))  -- ice detected

defineProperty("N1", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[1]"))   
defineProperty("N2", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[0]"))
defineProperty("N3", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[2]"))

-- filures
defineProperty("engine_ht_fail", globalPropertyi("sim/operation/failures/rel_ice_inlet_heat"))  -- engine heat fail
defineProperty("pitot1_ht_fail", globalPropertyi("sim/operation/failures/rel_ice_pitot_heat1"))  -- pitot 1 heat fail
defineProperty("pitot2_ht_fail", globalPropertyi("sim/operation/failures/rel_ice_pitot_heat2"))  -- pitot 2 heat fail
defineProperty("aoa_ht_fail", globalPropertyi("sim/operation/failures/rel_ice_AOA_heat"))  -- AOA heat fail
defineProperty("wing_ht_fail", globalPropertyi("sim/operation/failures/rel_ice_surf_heat"))  -- AOA heat fail
defineProperty("detector_fail", globalPropertyi("sim/operation/failures/rel_ice_detect"))  -- ice detector fail

defineProperty("rio_cap", globalPropertyi("sim/custom/xap/covers/rio_cap"))  -- RIO3 cap. 0 = off, 1 = on

-- power
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 36 volt

defineProperty("inv_PO1500_radio", globalPropertyi("sim/custom/xap/power/inv_PO1500_radio")) -- inverter for 115v bus
defineProperty("inv_PO1500_steklo", globalPropertyi("sim/custom/xap/power/inv_PO1500_steklo")) -- inverter for 115v bus

defineProperty("rio3_cc", globalPropertyf("sim/custom/xap/antiice/rio3_cc")) -- 
defineProperty("aoa_cc", globalPropertyf("sim/custom/xap/antiice/aoa_cc")) -- 
defineProperty("antiice_cc", globalPropertyf("sim/custom/xap/antiice/antiice_cc")) -- 

defineProperty("AZS_POS_sw", globalPropertyi("sim/custom/xap/azs/AZS_POS_sw"))   -- AZS
defineProperty("AZS_eng1_heat_sw", globalPropertyi("sim/custom/xap/azs/AZS_eng1_heat_sw"))   -- AZS
defineProperty("AZS_eng2_heat_sw", globalPropertyi("sim/custom/xap/azs/AZS_eng2_heat_sw"))   -- AZS
defineProperty("AZS_eng3_heat_sw", globalPropertyi("sim/custom/xap/azs/AZS_eng3_heat_sw"))   -- AZS

defineProperty("but_test_lamp", globalPropertyi("sim/custom/xap/buttons/but_test_lamp")) -- test lamps button

defineProperty("yellow_led", loadImage("leds.png", 60, 0, 20, 20)) 
defineProperty("green_led", loadImage("leds.png", 20, 0, 20, 20)) 
defineProperty("red_led", loadImage("leds.png", 40, 0, 20, 20)) 

defineProperty("ice_led", loadImage("lamps.png", 180, 75, 60, 25)) 

defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames

-- sounds
local switch_sound = loadSample('Custom Sounds/metal_switch.wav')
local cap_sound = loadSample('Custom Sounds/cap.wav')
local btn_click = loadSample('Custom Sounds/plastic_btn.wav')


local eng_heat_lit1 = false
local eng_heat_lit2 = false
local eng_heat_lit3 = false
local ice_detected = false
local system_check_lit = false
local system_mode_high_lit = false
local system_mode_low_lit = false

local start_counter = 0
local notLoaded = true
local ice_counter = 70

set(system_mode2, 0.5)

function update()
	local passed = get(frame_time)
	start_counter = start_counter + passed	
	
	-- initial switchers position
	if start_counter > 0.3 and start_counter < 0.5 and notLoaded and get(N1) < 10 and get(N2) < 10 and get(N3) < 10 then
		set(pitot1, 0)
		set(pitot2, 0)
		set(eng1, 0)
		set(eng2, 0)
		set(eng3, 0)
		set(aoa, 0)
		set(window, 0)
		set(rio3, 0)
		notLoaded = false
	end
	
	-- check power for overall system
	local power = get(AZS_POS_sw) > 0 and get(DC_27_volt) > 21
	local PO_radio = get(inv_PO1500_radio)
	local PO_Steklo = get(inv_PO1500_steklo)
	
	-- check engines work
	local eng1_work = 0
	local eng2_work = 0
	local eng3_work = 0
	if get(N1) > 40 then eng1_work = 1 end
	if get(N2) > 40 then eng2_work = 1 end
	if get(N3) > 40 then eng3_work = 1 end
	local system_cc = 0

	-- some elements can heat from electric
	if power then
		system_cc = 2
		set(pitot_1, get(pitot1))
		set(pitot_2, get(pitot2))
		set(wind_ht, math.abs(get(window)))
		set(aoa_ht, get(aoa) * PO_Steklo)
	else
		system_cc = 0
		set(pitot_1, 0)
		set(pitot_2, 0)
		set(wind_ht, 0)
		set(aoa_ht, 0)	
	end

	-- ice detect logic
	if power and get(system_sw) == 1 and get(rio3) == 1 then
		set(ice_detect, PO_radio)
	else set(ice_detect, 0) end
	
	
	local ice = get(ice_detect) * math.max(get(ice_on_plane), get(rio_cap)) -- ice detected for automatic
	local mode = get(system_mode2)
	local automat = get(system_mode1)

	-- counter for automatic heat
	ice_counter = ice_counter + passed
	if automat == 1 and ice == 1 and ice_counter > 60 and power then
		ice_counter = 0
	end
	if eng1_work + eng2_work + eng3_work < 2 or automat == 0 or not power then ice_counter = 70 end
	

	local engine_air = 0 -- calculate air took from engines
	
	-- engines heat switcher
	local eng_heat1 = get(AZS_eng1_heat_sw) * eng1_work
	local eng_heat2 = get(AZS_eng2_heat_sw) * eng2_work
	local eng_heat3 = get(AZS_eng3_heat_sw) * eng3_work

	local sw1 = get(eng1) * eng_heat1
	local sw2 = get(eng2) * eng_heat2
	local sw3 = get(eng3) * eng_heat3
	

	
	-- current mode of system
	local systemmode = 0
	if power and eng1_work + eng2_work + eng3_work >= 2 and (mode == 1 or ice_counter <= 60 and mode ~= 0) and get(virt_rud2) <= 0.7 and get(virt_rud3) <= 0.7 then -- full mode
		systemmode = 2
	elseif power and eng1_work + eng2_work + eng3_work >= 2 and (mode ~= 0.5 or ice_counter <= 60) then -- soft mode
		systemmode = 1
	end
	
	-- engine heat
	if systemmode == 1 then 
		set(engine_ht, math.abs(get(engine_ht) - 1)) 
		engine_air = engine_air + (eng_heat1 + eng_heat2 + eng_heat3) * 0.0016
	elseif systemmode == 2 then 
		set(engine_ht, 1) 
		engine_air = engine_air + (eng_heat1 + eng_heat2 + eng_heat3) * 0.0066
	elseif power and get(eng1) * get(AZS_eng1_heat_sw) + get(eng2) * get(AZS_eng2_heat_sw) + get(eng3) * get(AZS_eng3_heat_sw) > 0 then
		set(engine_ht, 1)
		engine_air = engine_air + (sw1 + sw2 + sw3) * 0.0016
--[[	elseif ice_counter <= 60 then
		set(engine_ht, 1) 
		engine_air = engine_air + (eng_heat1 + eng_heat2 + eng_heat3) * 0.0016 --]]
	else set(engine_ht, 0) end
	
	-- wing heat
	if systemmode == 1 then 
		set(wing_ht, math.abs(get(wing_ht) - 1)) 
		engine_air = engine_air + 0.005
	elseif systemmode == 2 then
		set(wing_ht, 1) 
		engine_air = engine_air + 0.02
--[[	elseif ice_counter <= 60 then
		set(wing_ht, 1) 
		engine_air = engine_air + 0.02	--]]
	else set(wing_ht, 0) end

	set(air_engine, engine_air * 2)
--	print(engine_air, (eng_heat1 + eng_heat2 + eng_heat3) * 0.0016, (eng_heat1 + eng_heat2 + eng_heat3) * 0.0066)


	-- lamps
	local test_lamp = get(but_test_lamp) == 1
	local button = get(check_btn) == 1

	ice_detected = power and ice == 1 or test_lamp	
	system_check_lit = power and get(system_sw) == -1 and get(detector_fail) < 6 or test_lamp
	eng_heat_lit1 = power and get(engine_ht_fail) < 6 and ( get(eng1) * get(AZS_eng1_heat_sw) == 1 or (systemmode > 0 or ice_counter <= 60 or button and mode ~= 0.5) ) or test_lamp
	eng_heat_lit2 = power and get(engine_ht_fail) < 6 and ( get(eng2) * get(AZS_eng2_heat_sw) == 1 or (systemmode > 0 or ice_counter <= 60 or button and mode ~= 0.5) ) or test_lamp
	eng_heat_lit3 = power and get(engine_ht_fail) < 6 and ( get(eng3) * get(AZS_eng3_heat_sw) == 1 or (systemmode > 0 or ice_counter <= 60 or button and mode ~= 0.5) ) or test_lamp
	system_mode_high_lit = power and (systemmode == 2 or button and mode == 1) or test_lamp
	system_mode_low_lit = power and (systemmode == 1 and not system_mode_high_lit or button and mode == 0) or test_lamp
	

--[[
	if power and eng1_work + eng2_work + eng3_work >= 2 then
		-- set heating
		if get(system_sw) == 1 then
			system_cc = 2
			set(pitot_1, get(pitot1))
			set(pitot_2, get(pitot2))
			set(wind_ht, math.abs(get(window)))
			if get(eng1) * get(AZS_eng1_heat_sw) + get(eng2) * get(AZS_eng2_heat_sw) + get(eng3) * get(AZS_eng3_heat_sw) > 0 then 
				set(engine_ht, 1)
			else
				set(engine_ht, 0)
			end
			set(aoa_ht, get(aoa) * PO_Steklo)
			set(ice_detect, PO_radio)
			set(wing_ht, get(system_mode1))
		else 
			system_cc = 0
			set(pitot_1, 0)
			set(pitot_2, 0)
			set(wind_ht, 0)
			set(engine_ht, 0)
			set(aoa_ht, 0)
			set(ice_detect, 0)
			set(wing_ht, 0)
		end
	else
		system_cc = 0
		set(pitot_1, 0)
		set(pitot_2, 0)
		set(wind_ht, 0)
		set(engine_ht, 0)
		set(aoa_ht, 0)
		set(ice_detect, 0)	
		set(wing_ht, 0)
	end
	
	-- lamps
	local test_lamp = get(but_test_lamp) == 1

	ice_detected = power and (get(ice_on_plane) == 1 or get(rio_cap) == 1) or test_lamp
	system_on_lit = power and eng1_work + eng2_work + eng3_work >= 2 and get(system_sw) ~= 0 or test_lamp
	eng_heat_lit1 = system_on_lit and get(eng1) * get(AZS_eng1_heat_sw) > 0 and get(engine_ht_fail) < 6 and get(system_sw) == 1 or test_lamp
	eng_heat_lit2 = system_on_lit and get(eng2) * get(AZS_eng2_heat_sw) > 0 and get(engine_ht_fail) < 6 and get(system_sw) == 1 or test_lamp
	eng_heat_lit3 = system_on_lit and get(eng3) * get(AZS_eng3_heat_sw) > 0 and get(engine_ht_fail) < 6 and get(system_sw) == 1 or test_lamp
	system_mode_high_lit = system_on_lit and get(system_mode2) == 1 or test_lamp
	system_mode_low_lit = system_on_lit and get(system_mode2) == 0 or test_lamp
	
	--print(power, eng1_work + eng2_work + eng3_work >= 2, get(eng1), get(AZS_eng1_heat_sw), get(engine_ht_fail) < 6, get(system_sw))
--]]	
	-- power cc
	set(rio3_cc, get(ice_detect))
	set(aoa_cc, get(aoa_ht))
	set(antiice_cc, get(pitot_1) + get(pitot_2) + system_cc)

end


local switcher_pushed = false

components = {
	
	-- ice detected lamp
	textureLit {
		position = {1525, 880, 60, 26},
		image = get(ice_led),
		visible = function()
			return ice_detected
		end,		
	},
	
	-- engine heat lamp
	textureLit {
		position = {1123, 821, 23, 23},
		image = get(green_led),
		visible = function()
			return eng_heat_lit1
		end,		
	},	
	
	-- engine heat lamp
	textureLit {
		position = {1153, 821, 23, 23},
		image = get(green_led),
		visible = function()
			return eng_heat_lit2
		end,		
	},
	
	-- engine heat lamp
	textureLit {
		position = {1183, 821, 23, 23},
		image = get(green_led),
		visible = function()
			return eng_heat_lit3
		end,		
	},
	
	-- system check lamp
	textureLit {
		position = {1033, 821, 23, 23},
		image = get(green_led),
		visible = function()
			return system_check_lit
		end,		
	},	

	-- system mode up lamp
	textureLit {
		position = {1062, 821, 23, 23},
		image = get(green_led),
		visible = function()
			return system_mode_high_lit
		end,		
	},	
	
	-- system mode down lamp
	textureLit {
		position = {1093, 821, 23, 23},
		image = get(green_led),
		visible = function()
			return system_mode_low_lit
		end,		
	},	
	
	--------------------
	-- pitot1 switcher
    switch {
        position = {902, 669, 19, 19},
        state = function()
            return get(pitot1) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(pitot1) ~= 0 then
					set(pitot1, 0)
				else
					set(pitot1, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

	-- pitot2 switcher
    switch {
        position = {922, 669, 19, 19},
        state = function()
            return get(pitot2) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(pitot2) ~= 0 then
					set(pitot2, 0)
				else
					set(pitot2, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

	-- rio3 switcher
    switch {
        position = {942, 669, 19, 19},
        state = function()
            return get(rio3) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(rio3) ~= 0 then
					set(rio3, 0)
				else
					set(rio3, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

	-- aoa switcher
    switch {
        position = {762, 709, 19, 19},
        state = function()
            return get(aoa) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(aoa) ~= 0 then
					set(aoa, 0)
				else
					set(aoa, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },
	
	-- system_mode1 switcher
    switch {
        position = {822, 649, 19, 19},
        state = function()
            return get(system_mode1) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(system_mode1) ~= 0 then
					set(system_mode1, 0)
				else
					set(system_mode1, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- system_mode2 switcher
	-- system switch down
    clickable {
        position = {842, 659, 19, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed and get(system_mode2) < 1 then
				playSample(switch_sound, 0)
				switcher_pushed = true
				local a = get(system_mode2) + 0.5
				if a > 1 then a = 1 end
				set(system_mode2, a)
			end
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			return true		
		end
    },

	-- system switch down
    clickable {
        position = {842, 649, 19, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed and get(system_mode2) > 0 then
				playSample(switch_sound, 0)
				switcher_pushed = true
				local a = get(system_mode2) - 0.5
				if a < -1 then a = 11 end
				set(system_mode2, a)
			end
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			return true		
		end
    },	
--[[
    switch {
        position = {842, 649, 19, 19},
        state = function()
            return get(system_mode2) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(system_mode2) ~= 0 then
					set(system_mode2, 0)
				else
					set(system_mode2, 1)
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
	-- eng heat switcher
    switch {
        position = {861, 649, 19, 19},
        state = function()
            return get(eng1) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(eng1) ~= 0 then
					set(eng1, 0)
				else
					set(eng1, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- eng heat switcher
    switch {
        position = {881, 649, 19, 19},
        state = function()
            return get(eng2) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(eng2) ~= 0 then
					set(eng2, 0)
				else
					set(eng2, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- eng heat switcher
    switch {
        position = {901, 649, 19, 19},
        state = function()
            return get(eng3) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(eng3) ~= 0 then
					set(eng3, 0)
				else
					set(eng3, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },
	
	-- system_cap switcher
    switch {
        position = {2001, 648, 40, 100},
        state = function()
            return get(system_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(system_cap) ~= 0 then
					set(system_cap, 0)
					if get(system_sw) ~= 1 then playSample(switch_sound, 0) end
					set(system_sw, 1)
				else
					set(system_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- system switch down
    clickable {
        position = {802, 649, 18, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed and get(system_cap) > 0 and get(system_sw) < 1 then
				playSample(switch_sound, 0)
				switcher_pushed = true
				local a = get(system_sw) + 1
				if a > 1 then a = 1 end
				set(system_sw, a)
			end
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			return true		
		end
    },

	-- system switch down
    clickable {
        position = {802, 659, 18, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed and get(system_cap) > 0 and get(system_sw) > -1 then
				playSample(switch_sound, 0)
				switcher_pushed = true
				local a = get(system_sw) - 1
				if a < -1 then a = 11 end
				set(system_sw, a)
			end
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			return true		
		end
    },	

	-- window switch down
    clickable {
        position = {1142, 689, 38, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed then
				playSample(switch_sound, 0)
				switcher_pushed = true
				local a = get(window) - 1
				if a < -1 then a = -1 end
				set(window, a)
			end
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			return true		
		end
    },	

	-- window switch up
    clickable {
        position = {1142, 699, 38, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed then
				playSample(switch_sound, 0)
				switcher_pushed = true
				local a = get(window) + 1
				if a > 1 then a = 1 end
				set(window, a)
			end
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			return true		
		end
    },	

	-- check button
    clickable {
        position = {1022, 629, 19, 19},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed then
				set(check_btn, 1)
				playSample(btn_click, 0)
				switcher_pushed = true
			end
			return true
		end,
		onMouseUp = function()
			set(check_btn, 0)
			playSample(btn_click, 0)
			switcher_pushed = false
			return true		
		end
    },

	
}





