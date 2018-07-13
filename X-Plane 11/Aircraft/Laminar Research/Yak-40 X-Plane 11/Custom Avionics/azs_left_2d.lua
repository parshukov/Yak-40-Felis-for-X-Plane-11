size = {423, 512}

-- define switchers
defineProperty("AZS_36v_emerg_sw", globalPropertyi("sim/custom/xap/azs/AZS_36v_emerg_sw")) -- AZS for emergency connect inv for 36v bus
defineProperty("AZS_115v_emerg_sw", globalPropertyi("sim/custom/xap/azs/AZS_115v_emerg_sw")) -- AZS for emergency connect inv-s for 115v bus
defineProperty("AZS_POsteklo_sw", globalPropertyi("sim/custom/xap/azs/AZS_POsteklo_sw")) -- AZS for inverter for 115v bus
defineProperty("AZS_POradio_sw", globalPropertyi("sim/custom/xap/azs/AZS_POradio_sw")) -- AZS for inverter for 115v bus
defineProperty("test_lamps_sw", globalPropertyi("sim/custom/xap/azs/test_lamps_sw")) -- AZS test lamps button
defineProperty("AZS_da30_sw", globalPropertyi("sim/custom/xap/azs/AZS_da30_sw")) -- AZS for inverter for 115v bus
defineProperty("AZS_agd_1_sw", globalPropertyi("sim/custom/xap/azs/AZS_agd_1_sw")) -- AZS for inverter for 115v bus
defineProperty("AZS_agd_2_sw", globalPropertyi("sim/custom/xap/azs/AZS_agd_2_sw")) -- AZS for inverter for 115v bus
defineProperty("AZS_eng_gau_1_sw", globalPropertyi("sim/custom/xap/azs/AZS_eng_gau_1_sw")) -- AZS for engine gauges
defineProperty("AZS_eng_gau_2_sw", globalPropertyi("sim/custom/xap/azs/AZS_eng_gau_2_sw")) -- AZS for engine gauges
defineProperty("AZS_eng_gau_3_sw", globalPropertyi("sim/custom/xap/azs/AZS_eng_gau_3_sw")) -- AZS for engine gauges
defineProperty("AZS_fuel_meter_sw", globalPropertyi("sim/custom/xap/azs/AZS_fuel_meter_sw")) -- AZS for fuel meter
defineProperty("AZS_fire_valve1_sw", globalPropertyi("sim/custom/xap/azs/AZS_fire_valve1_sw")) -- fire valve switcher on AZS
defineProperty("AZS_fire_valve2_sw", globalPropertyi("sim/custom/xap/azs/AZS_fire_valve2_sw")) -- fire valve switcher on AZS
defineProperty("AZS_fire_valve3_sw", globalPropertyi("sim/custom/xap/azs/AZS_fire_valve3_sw")) -- fire valve switcher on AZS
defineProperty("AZS_join_valve_sw", globalPropertyi("sim/custom/xap/azs/AZS_join_valve_sw")) -- fire valve switcher on AZS
defineProperty("AZS_circle_valve_sw", globalPropertyi("sim/custom/xap/azs/AZS_circle_valve_sw")) -- fire valve switcher on AZS
defineProperty("AZS_start_apu_sw", globalPropertyi("sim/custom/xap/azs/AZS_start_apu_sw")) -- AZS for start APU
defineProperty("AZS_ignition1_sw", globalPropertyf("sim/custom/xap/azs/AZS_ignition1_sw"))
defineProperty("AZS_ignition2_sw", globalPropertyf("sim/custom/xap/azs/AZS_ignition2_sw"))
defineProperty("AZS_ignition3_sw", globalPropertyf("sim/custom/xap/azs/AZS_ignition3_sw"))
defineProperty("AZS_ark_1_sw", globalPropertyi("sim/custom/xap/azs/AZS_ARK_1_sw")) -- AZS switcher
defineProperty("AZS_COM_1_sw", globalPropertyi("sim/custom/xap/azs/AZS_COM_1_sw")) -- AZS switcher
defineProperty("AZS_transp_sw", globalPropertyi("sim/custom/xap/azs/AZS_transp_sw"))

defineProperty("AZS_fire_signal1_sw", globalPropertyi("sim/custom/xap/azs/AZS_fire_signal1_sw"))  -- AZS for fire signal in engine
defineProperty("AZS_fire_signal2_sw", globalPropertyi("sim/custom/xap/azs/AZS_fire_signal2_sw"))  -- AZS for fire signal in engine
defineProperty("AZS_fire_signal3_sw", globalPropertyi("sim/custom/xap/azs/AZS_fire_signal3_sw"))  -- AZS for fire signal in engine

defineProperty("AZS_fire_ext1_sw", globalPropertyi("sim/custom/xap/azs/AZS_fire_ext1_sw"))  -- AZS for fire extinguisher in engine
defineProperty("AZS_fire_ext2_sw", globalPropertyi("sim/custom/xap/azs/AZS_fire_ext2_sw"))  -- AZS for fire extinguisher in engine
defineProperty("AZS_fire_ext3_sw", globalPropertyi("sim/custom/xap/azs/AZS_fire_ext3_sw"))  -- AZS for fire extinguisher in engine

defineProperty("AZS_fire_ext_valve1_sw", globalPropertyi("sim/custom/xap/azs/AZS_fire_ext_valve1_sw"))  -- AZS for fire extinguisher in engine
defineProperty("AZS_fire_ext_valve2_sw", globalPropertyi("sim/custom/xap/azs/AZS_fire_ext_valve2_sw"))  -- AZS for fire extinguisher in engine
defineProperty("AZS_fire_ext_valve3_sw", globalPropertyi("sim/custom/xap/azs/AZS_fire_ext_valve3_sw"))  -- AZS for fire extinguisher in engine

defineProperty("AZS_sign_stall_sw", globalPropertyi("sim/custom/xap/azs/AZS_sign_stall_sw"))  -- AZS for stall signal
defineProperty("AZS_sign_start_sw", globalPropertyi("sim/custom/xap/azs/AZS_sign_start_sw"))  -- AZS for start signal
defineProperty("AZS_sign_gear_sw", globalPropertyi("sim/custom/xap/azs/AZS_sign_gear_sw"))  -- AZS for gears signal


defineProperty("azs_left", globalPropertyi("sim/custom/xap/panels/azs_left"))  -- AZS for gears signal

-- define images
defineProperty("tmb_up", loadImage("tumbler_up.png"))
defineProperty("tmb_dn", loadImage("tumbler_down.png"))

defineProperty("background", loadImage("azs_2d.png", 0, 0, 423, 512))

local switch_sound = loadSample('Custom Sounds/metal_switch.wav')

local switcher_pushed = false

components = {

	rectangle {
		position = {0, 0, 423, 512},
		color = {0, 0, 0, 0.5},
	},
	
	texture {
		position = {0, 0, 423, 512},
		image = get(background),
	},

	-- close panel
	clickable {
		position = {size[1]-20, size[2]-20, 20, 20},  -- search and set right
        
		cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
		},  
        
       	onMouseClick = function() 
			set(azs_left, 0)
			return true
		end,
    },
	
	--------------------
	-- row clickables --
	--------------------
	
	-- switch ON 1 row
	clickable {
        position = {10, 365, 25, 90},  -- search and set right
        
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
				set(AZS_COM_1_sw, 1)
				set(AZS_da30_sw, 1)
				set(AZS_agd_1_sw, 1)
				set(AZS_fuel_meter_sw, 1)
				set(test_lamps_sw, 1)
				set(AZS_eng_gau_1_sw, 1)
				set(AZS_eng_gau_2_sw, 1)
				set(AZS_eng_gau_3_sw, 1)
				set(AZS_agd_2_sw, 1)
				switcher_pushed = true
			end
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			return true		
		end
    },	
	
	-- switch ON 2 row
	clickable {
        position = {10, 245, 25, 90},  -- search and set right
        
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
				set(AZS_ark_1_sw, 1)
				set(AZS_transp_sw, 1)
				set(AZS_36v_emerg_sw, 1)
				set(AZS_POradio_sw, 1)
				set(AZS_POsteklo_sw, 1)
				set(AZS_115v_emerg_sw, 1)
				set(AZS_fire_signal1_sw, 1)
				set(AZS_fire_signal2_sw, 1)
				set(AZS_fire_signal3_sw, 1)
				switcher_pushed = true
			end
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			return true		
		end
    },		
	
	-- switch ON 3 row
	clickable {
        position = {10, 123, 25, 90},  -- search and set right
        
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
				set(AZS_sign_stall_sw, 1)
				set(AZS_circle_valve_sw, 1)
				set(AZS_join_valve_sw, 1)
				set(AZS_fire_valve1_sw, 1)
				set(AZS_fire_valve2_sw, 1)
				set(AZS_fire_valve3_sw, 1)
				set(AZS_fire_ext1_sw, 1)
				set(AZS_fire_ext2_sw, 1)
				set(AZS_fire_ext3_sw, 1)
				switcher_pushed = true
			end
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			return true		
		end
    },	

	-- switch ON 4 row
	clickable {
        position = {10, 0, 25, 90},  -- search and set right
        
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
				set(AZS_sign_start_sw, 1)
				set(AZS_sign_gear_sw, 1)
				set(AZS_start_apu_sw, 1)
				set(AZS_ignition1_sw, 1)
				set(AZS_ignition2_sw, 1)
				set(AZS_ignition3_sw, 1)
				set(AZS_fire_ext_valve1_sw, 1)
				set(AZS_fire_ext_valve2_sw, 1)
				set(AZS_fire_ext_valve3_sw, 1)
				switcher_pushed = true
			end
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			return true		
		end
    },
-------------------------------------------
-------------------------------------------
	
	-- switch OFF 1 row
	clickable {
        position = {385, 365, 25, 90},  -- search and set right
        
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
				set(AZS_COM_1_sw, 0)
				set(AZS_da30_sw, 0)
				set(AZS_agd_1_sw, 0)
				set(AZS_fuel_meter_sw, 0)
				set(test_lamps_sw, 0)
				set(AZS_eng_gau_1_sw, 0)
				set(AZS_eng_gau_2_sw, 0)
				set(AZS_eng_gau_3_sw, 0)
				set(AZS_agd_2_sw, 0)
				switcher_pushed = true
			end
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			return true		
		end
    },

	-- switch OFF 2 row
	clickable {
        position = {385, 245, 25, 90},  -- search and set right
        
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
				set(AZS_ark_1_sw, 0)
				set(AZS_transp_sw, 0)
				set(AZS_36v_emerg_sw, 0)
				set(AZS_POradio_sw, 0)
				set(AZS_POsteklo_sw, 0)
				set(AZS_115v_emerg_sw, 0)
				set(AZS_fire_signal1_sw, 0)
				set(AZS_fire_signal2_sw, 0)
				set(AZS_fire_signal3_sw, 0)
				switcher_pushed = true
			end
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			return true		
		end
    },	

	-- switch OFF 3 row
	clickable {
        position = {385, 123, 25, 90},  -- search and set right
        
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
				set(AZS_sign_stall_sw, 0)
				set(AZS_circle_valve_sw, 0)
				set(AZS_join_valve_sw, 0)
				set(AZS_fire_valve1_sw, 0)
				set(AZS_fire_valve2_sw, 0)
				set(AZS_fire_valve3_sw, 0)
				set(AZS_fire_ext1_sw, 0)
				set(AZS_fire_ext2_sw, 0)
				set(AZS_fire_ext3_sw, 0)
				switcher_pushed = true
			end
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			return true		
		end
    },

	-- switch ON 4 row
	clickable {
        position = {385, 0, 25, 90},  -- search and set right
        
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
				set(AZS_sign_start_sw, 0)
				set(AZS_sign_gear_sw, 0)
				set(AZS_start_apu_sw, 0)
				set(AZS_ignition1_sw, 0)
				set(AZS_ignition2_sw, 0)
				set(AZS_ignition3_sw, 0)
				set(AZS_fire_ext_valve1_sw, 0)
				set(AZS_fire_ext_valve2_sw, 0)
				set(AZS_fire_ext_valve3_sw, 0)
				switcher_pushed = true
			end
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			return true		
		end
    },	
	
	---------------------
	-- switchers --
	---------------------

	-- AZS_36v_emerg_sw switcher
    switch {
        position = {117, 245, 25, 90},
        state = function()
            return get(AZS_36v_emerg_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_36v_emerg_sw) ~= 0 then
					set(AZS_36v_emerg_sw, 0)
				else
					set(AZS_36v_emerg_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },
	
	-- AZS_115v_emerg_sw switcher
    switch {
        position = {232, 245, 25, 90},
        state = function()
            return get(AZS_115v_emerg_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_115v_emerg_sw) ~= 0 then
					set(AZS_115v_emerg_sw, 0)
				else
					set(AZS_115v_emerg_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- AZS_POsteklo_sw switcher
    switch {
        position = {194, 245, 25, 90},
        state = function()
            return get(AZS_POsteklo_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_POsteklo_sw) ~= 0 then
					set(AZS_POsteklo_sw, 0)
				else
					set(AZS_POsteklo_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- AZS_POradio_sw switcher
    switch {
        position = {155, 245, 25, 90},
        state = function()
            return get(AZS_POradio_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_POradio_sw) ~= 0 then
					set(AZS_POradio_sw, 0)
				else
					set(AZS_POradio_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- test_lamps_sw switcher
    switch {
        position = {194, 365, 25, 90},
        state = function()
            return get(test_lamps_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(test_lamps_sw) ~= 0 then
					set(test_lamps_sw, 0)
				else
					set(test_lamps_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- AZS_da30_sw switcher
    switch {
        position = {80, 365, 25, 90},
        state = function()
            return get(AZS_da30_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_da30_sw) ~= 0 then
					set(AZS_da30_sw, 0)
				else
					set(AZS_da30_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- AZS_agd_1_sw switcher
    switch {
        position = {118, 365, 25, 90},
        state = function()
            return get(AZS_agd_1_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_agd_1_sw) ~= 0 then
					set(AZS_agd_1_sw, 0)
				else
					set(AZS_agd_1_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- AZS_agd_2_sw switcher
    switch {
        position = {345, 365, 25, 90},
        state = function()
            return get(AZS_agd_2_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_agd_2_sw) ~= 0 then
					set(AZS_agd_2_sw, 0)
				else
					set(AZS_agd_2_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

	-- AZS_eng_gau_1_sw switcher
    switch {
        position = {232, 365, 25, 90},
        state = function()
            return get(AZS_eng_gau_1_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_eng_gau_1_sw) ~= 0 then
					set(AZS_eng_gau_1_sw, 0)
				else
					set(AZS_eng_gau_1_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- AZS_eng_gau_2_sw switcher
    switch {
        position = {270, 365, 25, 90},
        state = function()
            return get(AZS_eng_gau_2_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_eng_gau_2_sw) ~= 0 then
					set(AZS_eng_gau_2_sw, 0)
				else
					set(AZS_eng_gau_2_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },
	
	-- AZS_eng_gau_3_sw switcher
    switch {
        position = {307, 365, 25, 90},
        state = function()
            return get(AZS_eng_gau_3_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_eng_gau_3_sw) ~= 0 then
					set(AZS_eng_gau_3_sw, 0)
				else
					set(AZS_eng_gau_3_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- AZS_fuel_meter_sw switcher
    switch {
        position = {155, 365, 25, 90},
        state = function()
            return get(AZS_fuel_meter_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_fuel_meter_sw) ~= 0 then
					set(AZS_fuel_meter_sw, 0)
				else
					set(AZS_fuel_meter_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

	-- AZS_circle_valve_sw switcher
    switch {
        position = {80, 123, 25, 90},
        state = function()
            return get(AZS_circle_valve_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_circle_valve_sw) ~= 0 then
					set(AZS_circle_valve_sw, 0)
				else
					set(AZS_circle_valve_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- AZS_join_valve_sw switcher
    switch {
        position = {118, 123, 25, 90},
        state = function()
            return get(AZS_join_valve_sw) ~= 0
        end,
		btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_join_valve_sw) ~= 0 then
					set(AZS_join_valve_sw, 0)
				else
					set(AZS_join_valve_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- AZS_fire_valve1_sw switcher
    switch {
        position = {155, 123, 25, 90},
        state = function()
            return get(AZS_fire_valve1_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_fire_valve1_sw) ~= 0 then
					set(AZS_fire_valve1_sw, 0)
				else
					set(AZS_fire_valve1_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },
	
	-- AZS_fire_valve2_sw switcher
    switch {
        position = {194, 123, 25, 90},
        state = function()
            return get(AZS_fire_valve2_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_fire_valve2_sw) ~= 0 then
					set(AZS_fire_valve2_sw, 0)
				else
					set(AZS_fire_valve2_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- AZS_fire_valve3_sw switcher
    switch {
        position = {232, 123, 25, 90},
        state = function()
            return get(AZS_fire_valve3_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_fire_valve3_sw) ~= 0 then
					set(AZS_fire_valve3_sw, 0)
				else
					set(AZS_fire_valve3_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- AZS_start_apu_sw switcher
    switch {
        position = {118, 0, 25, 90},
        state = function()
            return get(AZS_start_apu_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_start_apu_sw) ~= 0 then
					set(AZS_start_apu_sw, 0)
				else
					set(AZS_start_apu_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- AZS_ignition1_sw switcher
    switch {
        position = {155, 0, 25, 90},
        state = function()
            return get(AZS_ignition1_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_ignition1_sw) ~= 0 then
					set(AZS_ignition1_sw, 0)
				else
					set(AZS_ignition1_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- AZS_ignition2_sw switcher
    switch {
        position = {194, 0, 25, 90},
        state = function()
            return get(AZS_ignition2_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_ignition2_sw) ~= 0 then
					set(AZS_ignition2_sw, 0)
				else
					set(AZS_ignition2_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },
		
	-- AZS_ignition3_sw switcher
    switch {
        position = {232, 0, 25, 90},
        state = function()
            return get(AZS_ignition3_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_ignition3_sw) ~= 0 then
					set(AZS_ignition3_sw, 0)
				else
					set(AZS_ignition3_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- AZS_ark_1_sw switcher
    switch {
        position = {43, 245, 25, 90},
        state = function()
            return get(AZS_ark_1_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_ark_1_sw) ~= 0 then
					set(AZS_ark_1_sw, 0)
				else
					set(AZS_ark_1_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- AZS_COM_1_sw switcher
    switch {
        position = {43, 365, 25, 90},
        state = function()
            return get(AZS_COM_1_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_COM_1_sw) ~= 0 then
					set(AZS_COM_1_sw, 0)
				else
					set(AZS_COM_1_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

	-- AZS_transp_sw switcher
    switch {
        position = {80, 245, 25, 90},
        state = function()
            return get(AZS_transp_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_transp_sw) ~= 0 then
					set(AZS_transp_sw, 0)
				else
					set(AZS_transp_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- AZS_fire_signal1_sw switcher
    switch {
        position = {270, 245, 25, 90},
        state = function()
            return get(AZS_fire_signal1_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_fire_signal1_sw) ~= 0 then
					set(AZS_fire_signal1_sw, 0)
				else
					set(AZS_fire_signal1_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- AZS_fire_signal2_sw switcher
    switch {
        position = {307, 245, 25, 90},
        state = function()
            return get(AZS_fire_signal2_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_fire_signal2_sw) ~= 0 then
					set(AZS_fire_signal2_sw, 0)
				else
					set(AZS_fire_signal2_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },
	
	-- AZS_fire_signal3_sw switcher
    switch {
        position = {345, 245, 25, 90},
        state = function()
            return get(AZS_fire_signal3_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_fire_signal3_sw) ~= 0 then
					set(AZS_fire_signal3_sw, 0)
				else
					set(AZS_fire_signal3_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },		
	
	-- AZS_fire_ext1_sw switcher
    switch {
        position = {270, 123, 25, 90},
        state = function()
            return get(AZS_fire_ext1_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_fire_ext1_sw) ~= 0 then
					set(AZS_fire_ext1_sw, 0)
				else
					set(AZS_fire_ext1_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- AZS_fire_ext2_sw switcher
    switch {
        position = {307, 123, 25, 90},
        state = function()
            return get(AZS_fire_ext2_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_fire_ext2_sw) ~= 0 then
					set(AZS_fire_ext2_sw, 0)
				else
					set(AZS_fire_ext2_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- AZS_fire_ext3_sw switcher
    switch {
        position = {345, 123, 25, 90},
        state = function()
            return get(AZS_fire_ext3_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_fire_ext3_sw) ~= 0 then
					set(AZS_fire_ext3_sw, 0)
				else
					set(AZS_fire_ext3_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- AZS_fire_ext_valve1_sw switcher
    switch {
        position = {270, 0, 25, 90},
        state = function()
            return get(AZS_fire_ext_valve1_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_fire_ext_valve1_sw) ~= 0 then
					set(AZS_fire_ext_valve1_sw, 0)
				else
					set(AZS_fire_ext_valve1_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- AZS_fire_ext_valve2_sw switcher
    switch {
        position = {307, 0, 25, 90},
        state = function()
            return get(AZS_fire_ext_valve2_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_fire_ext_valve2_sw) ~= 0 then
					set(AZS_fire_ext_valve2_sw, 0)
				else
					set(AZS_fire_ext_valve2_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- AZS_fire_ext_valve3_sw switcher
    switch {
        position = {345, 0, 25, 90},
        state = function()
            return get(AZS_fire_ext_valve3_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_fire_ext_valve3_sw) ~= 0 then
					set(AZS_fire_ext_valve3_sw, 0)
				else
					set(AZS_fire_ext_valve3_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- AZS_sign_stall_sw switcher
    switch {
        position = {43, 123, 25, 90},
        state = function()
            return get(AZS_sign_stall_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_sign_stall_sw) ~= 0 then
					set(AZS_sign_stall_sw, 0)
				else
					set(AZS_sign_stall_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- AZS_sign_start_sw switcher
    switch {
        position = {43, 0, 25, 90},
        state = function()
            return get(AZS_sign_start_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_sign_start_sw) ~= 0 then
					set(AZS_sign_start_sw, 0)
				else
					set(AZS_sign_start_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- AZS_sign_gear_sw switcher
    switch {
        position = {80, 0, 25, 90},
        state = function()
            return get(AZS_sign_gear_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_sign_gear_sw) ~= 0 then
					set(AZS_sign_gear_sw, 0)
				else
					set(AZS_sign_gear_sw, 1)
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