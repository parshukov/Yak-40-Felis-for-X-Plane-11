-- this is fuel panel
size = {2048, 2048}

defineProperty("act_sw", globalPropertyi("sim/custom/xap/fuel/act_sw")) -- center fuel automat switcher
defineProperty("act_test_but", globalPropertyi("sim/custom/xap/fuel/act_test_but")) -- center fuel automat switcher
defineProperty("fuel_pump1_sw", globalPropertyi("sim/custom/xap/fuel/fuel_pump1_sw")) -- fuel pump switcher
defineProperty("fuel_pump2_sw", globalPropertyi("sim/custom/xap/fuel/fuel_pump2_sw")) -- fuel pump switcher
defineProperty("fuel_pump2_emerg_sw", globalPropertyi("sim/custom/xap/fuel/fuel_pump2_emerg_sw")) -- fuel pump switcher
defineProperty("fuel_pump2_emerg_sw_cap", globalPropertyi("sim/custom/xap/fuel/fuel_pump2_emerg_sw_cap")) -- fuel pump switcher
defineProperty("fuel_pump_mode_sw", globalPropertyi("sim/custom/xap/fuel/fuel_pump_mode_sw")) -- which pump work softer
defineProperty("join_valve_sw", globalPropertyi("sim/custom/xap/fuel/join_valve_sw")) -- join valve switcher
defineProperty("circle_valve_sw", globalPropertyi("sim/custom/xap/fuel/circle_valve_sw")) -- circle valve switcher
defineProperty("join_valve_sw_cap", globalPropertyi("sim/custom/xap/fuel/join_valve_sw_cap")) -- join valve switcher
defineProperty("circle_valve_sw_cap", globalPropertyi("sim/custom/xap/fuel/circle_valve_sw_cap")) -- circle valve switcher

defineProperty("fire_valve1_sw", globalPropertyi("sim/custom/xap/fuel/fire_valve1_sw")) -- fire valve switcher on overhead
defineProperty("fire_valve2_sw", globalPropertyi("sim/custom/xap/fuel/fire_valve2_sw")) -- fire valve switcher on overhead
defineProperty("fire_valve3_sw", globalPropertyi("sim/custom/xap/fuel/fire_valve3_sw")) -- fire valve switcher on overhead
defineProperty("fire_valve_apu_sw", globalPropertyi("sim/custom/xap/fuel/fire_valve_apu_sw")) -- fire valve switcher for apu

defineProperty("fire_valve1_sw_cap", globalPropertyi("sim/custom/xap/fuel/fire_valve1_sw_cap")) -- fire valve switcher on overhead
defineProperty("fire_valve2_sw_cap", globalPropertyi("sim/custom/xap/fuel/fire_valve2_sw_cap")) -- fire valve switcher on overhead
defineProperty("fire_valve3_sw_cap", globalPropertyi("sim/custom/xap/fuel/fire_valve3_sw_cap")) -- fire valve switcher on overhead

defineProperty("fuel_meter_mode", globalPropertyi("sim/custom/xap/fuel/fuel_meter_mode")) -- fuel_meter mode switcher
defineProperty("fuel_min_but", globalPropertyi("sim/custom/xap/fuel/fuel_min_but")) -- minimum button
defineProperty("fuel_max_but", globalPropertyi("sim/custom/xap/fuel/fuel_max_but")) -- maximum button

defineProperty("fuel_dump1", globalPropertyi("sim/custom/xap/fuel/fuel_dump1")) -- fuel dump
defineProperty("fuel_dump2", globalPropertyi("sim/custom/xap/fuel/fuel_dump2")) -- fuel dump
defineProperty("fuel_dump_cap", globalPropertyi("sim/custom/xap/fuel/fuel_dump_cap")) -- fuel dump cap
defineProperty("fuel_dump1_lit", globalPropertyi("sim/custom/xap/fuel/fuel_dump1_lit")) -- fuel dump
defineProperty("fuel_dump2_lit", globalPropertyi("sim/custom/xap/fuel/fuel_dump2_lit")) -- fuel dump

-- power
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("inv_PO1500_radio", globalPropertyi("sim/custom/xap/power/inv_PO1500_radio")) -- inverter for 115v bus
defineProperty("inv_PO1500_steklo", globalPropertyi("sim/custom/xap/power/inv_PO1500_steklo")) -- inverter for 115v bus

defineProperty("but_test_lamp", globalPropertyi("sim/custom/xap/buttons/but_test_lamp")) -- test lamps button
defineProperty("AZS_fuel_meter_sw", globalPropertyi("sim/custom/xap/azs/AZS_fuel_meter_sw")) -- AZS_fuel_meter_sw

-- results
defineProperty("fire_valve1", globalPropertyf("sim/custom/xap/fuel/fire_valve1")) -- fire valve position
defineProperty("fire_valve2", globalPropertyf("sim/custom/xap/fuel/fire_valve2")) -- fire valve position
defineProperty("fire_valve3", globalPropertyf("sim/custom/xap/fuel/fire_valve3")) -- fire valve position
defineProperty("fire_valve_apu", globalPropertyf("sim/custom/xap/fuel/fire_valve_apu")) -- fire valve position
defineProperty("fuel_pump1_work", globalPropertyi("sim/custom/xap/fuel/fuel_pump1_work")) -- fuel pump working
defineProperty("fuel_pump2_work", globalPropertyi("sim/custom/xap/fuel/fuel_pump2_work")) -- fuel pump working
defineProperty("circle_fuel_access", globalPropertyi("sim/custom/xap/fuel/circle_fuel_access")) -- circle valve is open
defineProperty("join_fuel_access", globalPropertyi("sim/custom/xap/fuel/join_fuel_access")) -- join valve is open

defineProperty("sim_fuel_pump1", globalPropertyi("sim/cockpit2/fuel/fuel_tank_pump_on[0]")) -- sim fuel pump
defineProperty("sim_fuel_pump2", globalPropertyi("sim/cockpit2/fuel/fuel_tank_pump_on[1]")) -- sim fuel pump

defineProperty("fuel_q_1", globalPropertyf("sim/flightmodel/weight/m_fuel[0]")) -- fuel quantity for tank 1
defineProperty("fuel_q_2", globalPropertyf("sim/flightmodel/weight/m_fuel[1]")) -- fuel quantity for tank 2
defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time of frame

-- images
defineProperty("apu_pk_led", loadImage("lamps.png", 120, 200, 60, 25))
defineProperty("low_fuel_left_led", loadImage("lamps.png", 60, 75, 60, 25))
defineProperty("low_fuel_right_led", loadImage("lamps.png", 120, 75, 60, 25))

defineProperty("yellow_led", loadImage("leds.png", 60, 0, 20, 20)) 
defineProperty("green_led", loadImage("leds.png", 20, 0, 20, 20)) 
defineProperty("red_led", loadImage("leds.png", 40, 0, 20, 20)) 

defineProperty("needle_img", loadImage("needles.png", 68, 75, 14, 168))
defineProperty("yellow_cap", loadImage("covers.png", 204, 0, 54, 54))

local switch_sound = loadSample('Custom Sounds/metal_switch.wav')
local btn_click = loadSample('Custom Sounds/plastic_btn.wav')
local cap_sound = loadSample('Custom Sounds/cap.wav')

local switcher_pushed = false
local apu_pk_open_lit = false
local low_fuel_left_lit = false
local low_fuel_right_lit = false
local left_pump_lit = false
local right_pump_lit = false
local join_lit = false
local circle_lit = false
local act_lit = false
local act_fail_lit = false

local valve1_lit = false
local valve2_lit = false
local valve3_lit = false

local fuel_angle = -150
local fuel_angle_last = -150
local dump1_lit = false
local dump2_lit = false

function update()
	local power = get(DC_27_volt) > 21
	local test_lamp = get(but_test_lamp) == 1
	apu_pk_open_lit = power and get(fire_valve_apu) > 0.5 or test_lamp
	local q1 = get(fuel_q_1)
	local q2 = get(fuel_q_2)	
	local fuel_meter = get(AZS_fuel_meter_sw) == 1
	low_fuel_left_lit = power and fuel_meter and q1 < 200 or test_lamp
	low_fuel_right_lit = power and fuel_meter and q2 < 200 or test_lamp
	left_pump_lit = power and get(fuel_pump1_work) == 1 or test_lamp
	right_pump_lit = power and get(fuel_pump2_work) == 1 or test_lamp
	join_lit = power and get(join_fuel_access) == 1 or test_lamp
	circle_lit = power and get(circle_fuel_access) == 1 or test_lamp
	act_lit = power and (left_pump_lit and right_pump_lit and get(act_sw) == 1 and get(inv_PO1500_radio) == 1 and q1 > 200 and q2 > 200 or get(act_test_but) == 1) or test_lamp
	act_fail_lit = power and get(act_sw) == 1 and not act_lit or test_lamp
	valve1_lit = power and get(fire_valve1) > 0.5 or test_lamp
	valve2_lit = power and get(fire_valve2) > 0.5 or test_lamp
	valve3_lit = power and get(fire_valve3) > 0.5 or test_lamp
	dump1_lit = power and get(fuel_dump1_lit) == 1 or test_lamp
	dump2_lit = power and get(fuel_dump2_lit) == 1 or test_lamp
	
	-- fuel indicator
	local fuel_ind = 0
	local fuel_mode = get(fuel_meter_mode)
	
	if fuel_mode == 0 then fuel_ind = (q1 + q2) * 0.5
	elseif fuel_mode == -1 then fuel_ind = q1
	else fuel_ind = q2 end
	
	if get(fuel_min_but) == 1 then fuel_ind = 0
	elseif get(fuel_max_but) == 1 then fuel_ind = 2200 end
	local passed = get(frame_time)
	
	if fuel_meter and power then
		local ind_angle = fuel_ind * 300 / 2200 - 150
		--if fuel_angle < ind_angle - 1 then fuel_angle = fuel_angle + passed * 40
		--elseif fuel_angle > ind_angle + 1 then fuel_angle = fuel_angle - passed * 40 end
		fuel_angle = fuel_angle + (ind_angle - fuel_angle_last) * passed * 2
		fuel_angle_last = fuel_angle
		if fuel_angle > 150 then fuel_angle = 150 end
	end
	
end

components = {
	-- fuel indicator
	-- white needle
    needle {
        position = { 218, 1663, 166, 166 },
        image = get(needle_img),
        angle = function()
			return fuel_angle
        end
    },
	
	-- cover
	texture {
		position = { 275, 1722, 50, 50 },
		image = get(yellow_cap),
	},
	-- min button
    clickable {
        position = {202, 1650, 30, 30},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed then playSample(btn_click, 0) switcher_pushed = true end
			set(fuel_min_but, 1)
			return true
		end,
		onMouseUp = function()
			playSample(btn_click, 0)
			switcher_pushed = false
			set(fuel_min_but, 0)
			return true		
		end
    },	
	-- max button
    clickable {
        position = {370, 1650, 30, 30},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed then playSample(btn_click, 0) switcher_pushed = true end
			set(fuel_max_but, 1)
			return true
		end,
		onMouseUp = function()
			playSample(btn_click, 0)
			switcher_pushed = false
			set(fuel_max_but, 0)
			return true		
		end
    },

	-- left tank switch
    clickable {
        position = {642, 609, 9, 19},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed then playSample(switch_sound, 0) switcher_pushed = true end
			set(fuel_meter_mode, -1)
			return true
		end,
		onMouseUp = function()
			playSample(switch_sound, 0)
			switcher_pushed = false
			set(fuel_meter_mode, 0)
			return true		
		end
    },

	-- right tank switch
    clickable {
        position = {652, 609, 9, 19},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed then playSample(switch_sound, 0) switcher_pushed = true end
			set(fuel_meter_mode, 1)
			return true
		end,
		onMouseUp = function()
			set(fuel_meter_mode, 0)
			playSample(switch_sound, 0)
			switcher_pushed = false
			return true		
		end
    },
	
	--------------------
	-- lamps and leds --
	--------------------
	-- APU PK
	textureLit {
		position = {1450, 759, 60, 25},
		image = get(apu_pk_led),
		visible = function()
			return apu_pk_open_lit
		end
	},
	
	-- low_fuel_left_lit
	textureLit {
		position = {1381, 880, 60, 25},
		image = get(low_fuel_left_led),
		visible = function()
			return low_fuel_left_lit
		end
	},	
	
	-- low_fuel_right_lit
	textureLit {
		position = {1454, 880, 60, 25},
		image = get(low_fuel_right_led),
		visible = function()
			return low_fuel_right_lit
		end
	},	
	
	-- left_pump_lit
	textureLit {
		position = {1004, 882, 22, 22},
		image = get(green_led),
		visible = function()
			return left_pump_lit
		end
	},	
	
	-- right_pump_lit
	textureLit {
		position = {1034, 882, 22, 22},
		image = get(green_led),
		visible = function()
			return right_pump_lit
		end
	},	
	
	-- join_lit
	textureLit {
		position = {1065, 852, 22, 22},
		image = get(green_led),
		visible = function()
			return join_lit
		end
	},	

	-- circle_lit
	textureLit {
		position = {1095, 852, 22, 22},
		image = get(green_led),
		visible = function()
			return circle_lit
		end
	},	
	
	-- act_lit
	textureLit {
		position = {1005, 852, 22, 22},
		image = get(green_led),
		visible = function()
			return act_lit
		end
	},

	-- act_fail_lit
	textureLit {
		position = {1034, 852, 22, 22},
		image = get(red_led),
		visible = function()
			return act_fail_lit
		end
	},	
	
	-- valve1_lit
	textureLit {
		position = {944, 762, 22, 22},
		image = get(green_led),
		visible = function()
			return valve1_lit
		end
	},
	
	-- valve2_lit
	textureLit {
		position = {974, 762, 22, 22},
		image = get(green_led),
		visible = function()
			return valve2_lit
		end
	},	

	-- valve3_lit
	textureLit {
		position = {1005, 762, 22, 22},
		image = get(green_led),
		visible = function()
			return valve3_lit
		end
	},	
	
	-- dump1_lit
	textureLit {
		position = {974, 822, 22, 22},
		image = get(red_led),
		visible = function()
			return dump1_lit
		end
	},	
	
	-- dump2_lit
	textureLit {
		position = {1004, 822, 22, 22},
		image = get(red_led),
		visible = function()
			return dump2_lit
		end
	},	
	
	
	---------------------
	-- switchers --
	---------------------
	-- ACT test
    clickable {
        position = {1121, 629, 19, 19},
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       onMouseClick = function() 
			set(act_test_but, 1)
			if not switcher_pushed then playSample(btn_click, 0) switcher_pushed = true end
          return true
       end,
       onMouseUp = function() 
			set(act_test_but, 0)
			playSample(btn_click, 0)
			switcher_pushed = false
          return true
       end,
    }, 

	-- act_sw switcher
    switch {
        position = {781, 589, 19, 19},
        state = function()
            return get(act_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(act_sw) ~= 0 then
					set(act_sw, 0)
				else
					set(act_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- fuel_pump1_sw switcher
    switch {
        position = {802, 589, 19, 19},
        state = function()
            return get(fuel_pump1_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(fuel_pump1_sw) ~= 0 then
					set(fuel_pump1_sw, 0)
				else
					set(fuel_pump1_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- fuel_pump2_sw switcher
    switch {
        position = {822, 589, 19, 19},
        state = function()
            return get(fuel_pump2_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(fuel_pump2_sw) ~= 0 then
					set(fuel_pump2_sw, 0)
				else
					set(fuel_pump2_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },
	
	-- mode up
    clickable {
        position = {842, 599, 19, 9},
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       onMouseClick = function() 
			local a = get(fuel_pump_mode_sw)
			if a < 1 then playSample(switch_sound, 0) end
			a = a + 1
			if a > 1 then a = 1 end
			set(fuel_pump_mode_sw, a)
          return true
       end,
    }, 

	-- mode down
    clickable {
        position = {842, 589, 19, 9},
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       onMouseClick = function() 
			local a = get(fuel_pump_mode_sw)
			if a > -1 then playSample(switch_sound, 0) end
			a = a - 1
			if a < -1 then a = -1 end
			set(fuel_pump_mode_sw, a)
          return true
       end,
    }, 
	
	-- fuel_pump2_emerg_sw_cap switcher
    switch {
        position = {1502, 538, 60, 110},
        state = function()
            return get(fuel_pump2_emerg_sw_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(fuel_pump2_emerg_sw_cap) ~= 0 then
					set(fuel_pump2_emerg_sw_cap, 0)
				else
					set(fuel_pump2_emerg_sw_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },
	
	-- fuel_pump2_emerg_sw switcher
    switch {
        position = {862, 589, 19, 19},
        state = function()
            return get(fuel_pump2_emerg_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and get(fuel_pump2_emerg_sw_cap) ~= 0 then
				playSample(switch_sound, 0)
				if get(fuel_pump2_emerg_sw) ~= 0 then
					set(fuel_pump2_emerg_sw, 0)
				else
					set(fuel_pump2_emerg_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- join_valve_sw_cap switcher
    switch {
        position = {1562, 538, 60, 110},
        state = function()
            return get(join_valve_sw_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(join_valve_sw_cap) ~= 0 then
					set(join_valve_sw_cap, 0)
				else
					set(join_valve_sw_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },
	
	-- join_valve_sw switcher
    switch {
        position = {882, 589, 19, 19},
        state = function()
            return get(join_valve_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and get(join_valve_sw_cap) ~= 0 then
				playSample(switch_sound, 0)
				if get(join_valve_sw) ~= 0 then
					set(join_valve_sw, 0)
				else
					set(join_valve_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- circle_valve_sw_cap switcher
    switch {
        position = {1622, 538, 60, 110},
        state = function()
            return get(circle_valve_sw_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(circle_valve_sw_cap) ~= 0 then
					set(circle_valve_sw_cap, 0)
				else
					set(circle_valve_sw_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },
	
	-- circle_valve_sw switcher
    switch {
        position = {902, 589, 19, 19},
        state = function()
            return get(circle_valve_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and get(circle_valve_sw_cap) ~= 0 then
				playSample(switch_sound, 0)
				if get(circle_valve_sw) ~= 0 then
					set(circle_valve_sw, 0)
				else
					set(circle_valve_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- fire_valve1_sw switcher
    switch {
        position = {1062, 689, 19, 19},
        state = function()
            return get(fire_valve1_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and get(fire_valve1_sw_cap) ~= 0 then
				playSample(switch_sound, 0)
				if get(fire_valve1_sw) ~= 0 then
					set(fire_valve1_sw, 0)
				else
					set(fire_valve1_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },
	-- fire_valve2_sw switcher
    switch {
        position = {1082, 689, 19, 19},
        state = function()
            return get(fire_valve2_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and get(fire_valve2_sw_cap) ~= 0 then
				playSample(switch_sound, 0)
				if get(fire_valve2_sw) ~= 0 then
					set(fire_valve2_sw, 0)
				else
					set(fire_valve2_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	-- fire_valve3_sw switcher
    switch {
        position = {1102, 689, 19, 19},
        state = function()
            return get(fire_valve3_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and get(fire_valve3_sw_cap) ~= 0 then
				playSample(switch_sound, 0)
				if get(fire_valve3_sw) ~= 0 then
					set(fire_valve3_sw, 0)
				else
					set(fire_valve3_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },		
	
	-- fire_valve1_sw_cap switcher
    switch {
        position = {1322, 538, 60, 110},
        state = function()
            return get(fire_valve1_sw_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(fire_valve1_sw_cap) ~= 0 then
					set(fire_valve1_sw_cap, 0)
					if get(fire_valve1_sw) == 0 then playSample(switch_sound, 0) end
					set(fire_valve1_sw, 1)
				else
					set(fire_valve1_sw_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- fire_valve2_sw_cap switcher
    switch {
        position = {1382, 538, 60, 110},
        state = function()
            return get(fire_valve2_sw_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(fire_valve2_sw_cap) ~= 0 then
					set(fire_valve2_sw_cap, 0)
					if get(fire_valve2_sw) == 0 then playSample(switch_sound, 0) end
					set(fire_valve2_sw, 1)
				else
					set(fire_valve2_sw_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- fire_valve3_sw_cap switcher
    switch {
        position = {1442, 538, 60, 110},
        state = function()
            return get(fire_valve3_sw_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(fire_valve3_sw_cap) ~= 0 then
					set(fire_valve3_sw_cap, 0)
					if get(fire_valve3_sw) == 0 then playSample(switch_sound, 0) end
					set(fire_valve3_sw, 1)
				else
					set(fire_valve3_sw_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- fire_valve_apu_sw switcher
    switch {
        position = {742, 629, 19, 19},
        state = function()
            return get(fire_valve_apu_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(fire_valve_apu_sw) ~= 0 then
					set(fire_valve_apu_sw, 0)
				else
					set(fire_valve_apu_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- fuel_dump_cap switcher
    switch {
        position = {1723, 549, 99, 99},
        state = function()
            return get(fuel_dump_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(fuel_dump_cap) ~= 0 then
					set(fuel_dump_cap, 0)
				else
					set(fuel_dump_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },
	
	-- fuel_dump1 switcher
    switch {
        position = {862, 669, 19, 19},
        state = function()
            return get(fuel_dump1) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and get(fuel_dump_cap) ~= 0 then
				playSample(switch_sound, 0)
				if get(fuel_dump1) ~= 0 then
					set(fuel_dump1, 0)
				else
					set(fuel_dump1, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- fuel_dump2 switcher
    switch {
        position = {882, 669, 19, 19},
        state = function()
            return get(fuel_dump2) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and get(fuel_dump_cap) ~= 0 then
				playSample(switch_sound, 0)
				if get(fuel_dump2) ~= 0 then
					set(fuel_dump2, 0)
				else
					set(fuel_dump2, 1)
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



