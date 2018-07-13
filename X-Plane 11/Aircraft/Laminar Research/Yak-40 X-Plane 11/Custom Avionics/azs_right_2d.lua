size = {423, 512}

-- define switchers
defineProperty("AZS_hydrosys_sw", globalPropertyi("sim/custom/xap/azs/AZS_hydrosys_sw")) -- AZS for hydraulic system
defineProperty("AZS_brakes_sw", globalPropertyi("sim/custom/xap/azs/AZS_brakes_sw")) -- AZS for hydraulic system
defineProperty("AZS_flaps_main_sw", globalPropertyi("sim/custom/xap/azs/AZS_flaps_main_sw")) -- AZS main flaps system
defineProperty("AZS_flaps_emerg_sw", globalPropertyi("sim/custom/xap/azs/AZS_flaps_emerg_sw")) -- AZS emerg flaps system
defineProperty("AZS_gears_main_sw", globalPropertyi("sim/custom/xap/azs/AZS_gears_main_sw")) -- AZS main gear system
defineProperty("AZS_gears_emerg_sw", globalPropertyi("sim/custom/xap/azs/AZS_gears_emerg_sw")) -- AZS emerg gear system
defineProperty("AZS_stab_main_sw", globalPropertyi("sim/custom/xap/azs/AZS_stab_main_sw")) -- AZS main stab system
defineProperty("AZS_stab_emerg_sw", globalPropertyi("sim/custom/xap/azs/AZS_stab_emerg_sw")) -- AZS main stab system
defineProperty("AZS_aileron_trim_sw", globalPropertyi("sim/custom/xap/azs/AZS_aileron_trim_sw")) -- AZS stab gear system
defineProperty("AZS_rudder_trim_sw", globalPropertyi("sim/custom/xap/azs/AZS_rudder_trim_sw")) -- AZS stab gear system
defineProperty("AZS_agd_3_sw", globalPropertyi("sim/custom/xap/azs/AZS_agd_3_sw")) -- AGD 3 switch
defineProperty("AZS_bspk_sw", globalPropertyi("sim/custom/xap/azs/AZS_bspk_sw")) -- BSPK system
defineProperty("AZS_ark_2_sw", globalPropertyi("sim/custom/xap/azs/AZS_ARK_2_sw")) -- AZS switcher
defineProperty("AZS_GMK_sw", globalPropertyi("sim/custom/xap/azs/AZS_GMK_sw")) -- AZS switcher
defineProperty("AZS_COM_2_sw", globalPropertyi("sim/custom/xap/azs/AZS_COM_2_sw")) -- AZS switcher
defineProperty("AZS_ADP_sw", globalPropertyi("sim/custom/xap/azs/AZS_ADP_sw")) --  AZS for G-forse meter
defineProperty("AZS_KursMP_sw", globalPropertyi("sim/custom/xap/azs/AZS_KursMP_sw")) --  AZS for nav system
defineProperty("AZS_ladder_sw", globalPropertyi("sim/custom/xap/azs/AZS_ladder_sw")) --  AZS for ladder control
defineProperty("AZS_nosewheel_sw", globalPropertyi("sim/custom/xap/azs/AZS_nosewheel_sw")) -- AZS for hydraulic system
defineProperty("AZS_skv_cool_sw", globalPropertyi("sim/custom/xap/azs/AZS_skv_cool_sw")) -- AZS cooling air
defineProperty("AZS_skv_heat_sw", globalPropertyi("sim/custom/xap/azs/AZS_skv_heat_sw")) -- AZS heating air
defineProperty("AZS_skv_THU_sw", globalPropertyi("sim/custom/xap/azs/AZS_skv_THU_sw")) -- AZS turbo cooling air

defineProperty("AZS_POS_sw", globalPropertyi("sim/custom/xap/azs/AZS_POS_sw"))   -- AZS
defineProperty("AZS_eng1_heat_sw", globalPropertyi("sim/custom/xap/azs/AZS_eng1_heat_sw"))   -- AZS
defineProperty("AZS_eng2_heat_sw", globalPropertyi("sim/custom/xap/azs/AZS_eng2_heat_sw"))   -- AZS
defineProperty("AZS_eng3_heat_sw", globalPropertyi("sim/custom/xap/azs/AZS_eng3_heat_sw"))   -- AZS

defineProperty("lan_light1", globalPropertyi("sim/custom/xap/azs/AZS_lan1_sw")) -- AZS
defineProperty("lan_light2", globalPropertyi("sim/custom/xap/azs/AZS_lan2_sw")) -- AZS
defineProperty("taxi_light1", globalPropertyi("sim/custom/xap/azs/AZS_taxi1_sw")) -- AZS
defineProperty("taxi_light2", globalPropertyi("sim/custom/xap/azs/AZS_taxi2_sw")) -- AZS

defineProperty("AZS_AP_sw", globalPropertyi("sim/custom/xap/azs/AZS_AP_sw")) --AZS for AutoPilot
defineProperty("AZS_sign_gear2_sw", globalPropertyi("sim/custom/xap/azs/AZS_sign_gear2_sw")) -- AZS for gears signal
defineProperty("AZS_rockets_sw", globalPropertyi("sim/custom/xap/azs/AZS_rockets_sw")) -- AZS for rockets
defineProperty("AZS_radio2_sw", globalPropertyi("sim/custom/xap/azs/AZS_radio2_sw")) -- AZS for PO Radio manual
defineProperty("AZS_join_sw", globalPropertyi("sim/custom/xap/azs/AZS_join_sw")) -- AZS for join


defineProperty("azs_right", globalPropertyi("sim/custom/xap/panels/azs_right")) -- right azs panel

-- define images
defineProperty("tmb_up", loadImage("tumbler_up.png"))
defineProperty("tmb_dn", loadImage("tumbler_down.png"))

defineProperty("background", loadImage("azs_2d.png", 450, 0, 423, 512))

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
			set(azs_right, 0)
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
				set(AZS_COM_2_sw, 1)
				set(AZS_ADP_sw, 1)
				set(AZS_agd_3_sw, 1)
				set(AZS_GMK_sw, 1)
				set(AZS_hydrosys_sw, 1)
				set(AZS_AP_sw, 1)
				set(AZS_sign_gear2_sw, 1)
				set(AZS_rockets_sw, 1)
				set(AZS_KursMP_sw, 1)
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
				set(AZS_ark_2_sw, 1)
				set(AZS_radio2_sw, 1)
				set(AZS_stab_emerg_sw, 1)
				set(AZS_flaps_emerg_sw, 1)
				set(AZS_gears_emerg_sw, 1)
				set(AZS_POS_sw, 1)
				set(AZS_bspk_sw, 1)
				set(AZS_skv_cool_sw, 1)
				set(AZS_ladder_sw, 1)
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
				set(AZS_skv_THU_sw, 1)
				set(AZS_nosewheel_sw, 1)
				set(AZS_join_sw, 1)
				set(AZS_eng1_heat_sw, 1)
				set(AZS_eng2_heat_sw, 1)
				set(AZS_eng3_heat_sw, 1)
				set(AZS_brakes_sw, 1)
				set(AZS_skv_heat_sw, 1)
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
				set(lan_light1, 1)
				set(lan_light2, 1)
				set(taxi_light1, 1)
				set(taxi_light2, 1)
				set(AZS_aileron_trim_sw, 1)
				set(AZS_rudder_trim_sw, 1)
				set(AZS_stab_main_sw, 1)
				set(AZS_flaps_main_sw, 1)
				set(AZS_gears_main_sw, 1)
				switcher_pushed = true
			end
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			return true		
		end
    },

------------------------------------------------
------------------------------------------------

	-- switch OFF 1 row
	clickable {
        position = {390, 365, 25, 90},  -- search and set right
        
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
				set(AZS_COM_2_sw, 0)
				set(AZS_ADP_sw, 0)
				set(AZS_agd_3_sw, 0)
				set(AZS_GMK_sw, 0)
				set(AZS_hydrosys_sw, 0)
				set(AZS_AP_sw, 0)
				set(AZS_sign_gear2_sw, 0)
				set(AZS_rockets_sw, 0)
				set(AZS_KursMP_sw, 0)
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
        position = {390, 245, 25, 90},  -- search and set right
        
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
				set(AZS_ark_2_sw, 0)
				set(AZS_radio2_sw, 0)
				set(AZS_stab_emerg_sw, 0)
				set(AZS_flaps_emerg_sw, 0)
				set(AZS_gears_emerg_sw, 0)
				set(AZS_POS_sw, 0)
				set(AZS_bspk_sw, 0)
				set(AZS_skv_cool_sw, 0)
				set(AZS_ladder_sw, 0)
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
        position = {390, 123, 25, 90},  -- search and set right
        
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
				set(AZS_skv_THU_sw, 0)
				set(AZS_nosewheel_sw, 0)
				set(AZS_join_sw, 0)
				set(AZS_eng1_heat_sw, 0)
				set(AZS_eng2_heat_sw, 0)
				set(AZS_eng3_heat_sw, 0)
				set(AZS_brakes_sw, 0)
				set(AZS_skv_heat_sw, 0)
				switcher_pushed = true
			end
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			return true		
		end
    },	
	
	-- switch OFF 4 row
	clickable {
        position = {390, 0, 25, 90},  -- search and set right
        
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
				set(lan_light1, 0)
				set(lan_light2, 0)
				set(taxi_light1, 0)
				set(taxi_light2, 0)
				set(AZS_aileron_trim_sw, 0)
				set(AZS_rudder_trim_sw, 0)
				set(AZS_stab_main_sw, 0)
				set(AZS_flaps_main_sw, 0)
				set(AZS_gears_main_sw, 0)
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

	-- AZS_hydrosys_sw switcher
    switch {
        position = {201, 365, 25, 90},
        state = function()
            return get(AZS_hydrosys_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_hydrosys_sw) ~= 0 then
					set(AZS_hydrosys_sw, 0)
				else
					set(AZS_hydrosys_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

	-- AZS_brakes_sw switcher
    switch {
        position = {279, 123, 25, 90},
        state = function()
            return get(AZS_brakes_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_brakes_sw) ~= 0 then
					set(AZS_brakes_sw, 0)
				else
					set(AZS_brakes_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- AZS_flaps_main_sw switcher
    switch {
        position = {317, 0, 25, 90},
        state = function()
            return get(AZS_flaps_main_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_flaps_main_sw) ~= 0 then
					set(AZS_flaps_main_sw, 0)
				else
					set(AZS_flaps_main_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

	-- AZS_flaps_emerg_sw switcher
    switch {
        position = {163, 245, 25, 90},
        state = function()
            return get(AZS_flaps_emerg_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_flaps_emerg_sw) ~= 0 then
					set(AZS_flaps_emerg_sw, 0)
				else
					set(AZS_flaps_emerg_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- AZS_gears_main_sw switcher
    switch {
        position = {353, 0, 25, 90},
        state = function()
            return get(AZS_gears_main_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_gears_main_sw) ~= 0 then
					set(AZS_gears_main_sw, 0)
				else
					set(AZS_gears_main_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- AZS_gears_emerg_sw switcher
    switch {
        position = {201, 245, 25, 90},
        state = function()
            return get(AZS_gears_emerg_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_gears_emerg_sw) ~= 0 then
					set(AZS_gears_emerg_sw, 0)
				else
					set(AZS_gears_emerg_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- AZS_stab_emerg_sw switcher
    switch {
        position = {125, 245, 25, 90},
        state = function()
            return get(AZS_stab_emerg_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_stab_emerg_sw) ~= 0 then
					set(AZS_stab_emerg_sw, 0)
				else
					set(AZS_stab_emerg_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- AZS_stab_main_sw switcher
    switch {
        position = {279, 0, 25, 90},
        state = function()
            return get(AZS_stab_main_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_stab_main_sw) ~= 0 then
					set(AZS_stab_main_sw, 0)
				else
					set(AZS_stab_main_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- AZS_rudder_trim_sw switcher
    switch {
        position = {240, 0, 25, 90},
        state = function()
            return get(AZS_rudder_trim_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_rudder_trim_sw) ~= 0 then
					set(AZS_rudder_trim_sw, 0)
				else
					set(AZS_rudder_trim_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- AZS_aileron_trim_sw switcher
    switch {
        position = {201, 0, 25, 90},
        state = function()
            return get(AZS_aileron_trim_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_aileron_trim_sw) ~= 0 then
					set(AZS_aileron_trim_sw, 0)
				else
					set(AZS_aileron_trim_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- AZS_agd_3_sw switcher
    switch {
        position = {125, 365, 25, 90},
        state = function()
            return get(AZS_agd_3_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_agd_3_sw) ~= 0 then
					set(AZS_agd_3_sw, 0)
				else
					set(AZS_agd_3_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },		

	-- AZS_bspk_sw switcher
    switch {
        position = {279, 245, 25, 90},
        state = function()
            return get(AZS_bspk_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_bspk_sw) ~= 0 then
					set(AZS_bspk_sw, 0)
				else
					set(AZS_bspk_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- AZS_GMK_sw switcher
    switch {
        position = {163, 365, 25, 90},
        state = function()
            return get(AZS_GMK_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_GMK_sw) ~= 0 then
					set(AZS_GMK_sw, 0)
				else
					set(AZS_GMK_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- AZS_ark_2_sw switcher
    switch {
        position = {48, 245, 25, 90},
        state = function()
            return get(AZS_ark_2_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_ark_2_sw) ~= 0 then
					set(AZS_ark_2_sw, 0)
				else
					set(AZS_ark_2_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- AZS_COM_2_sw switcher
    switch {
        position = {48, 365, 25, 90},
        state = function()
            return get(AZS_COM_2_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_COM_2_sw) ~= 0 then
					set(AZS_COM_2_sw, 0)
				else
					set(AZS_COM_2_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
  },

	-- AZS_ADP_sw switcher
    switch {
        position = {87, 365, 25, 90},
        state = function()
            return get(AZS_ADP_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_ADP_sw) ~= 0 then
					set(AZS_ADP_sw, 0)
				else
					set(AZS_ADP_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- AZS_KursMP_sw switcher
    switch {
        position = {353, 365, 25, 90},
        state = function()
            return get(AZS_KursMP_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_KursMP_sw) ~= 0 then
					set(AZS_KursMP_sw, 0)
				else
					set(AZS_KursMP_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- AZS_ladder_sw switcher
    switch {
        position = {353, 245, 25, 90},
        state = function()
            return get(AZS_ladder_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_ladder_sw) ~= 0 then
					set(AZS_ladder_sw, 0)
				else
					set(AZS_ladder_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

 	-- AZS_nosewheel_sw switcher
    switch {
        position = {87, 123, 25, 90},
        state = function()
            return get(AZS_nosewheel_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_nosewheel_sw) ~= 0 then
					set(AZS_nosewheel_sw, 0)
				else
					set(AZS_nosewheel_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

 	-- AZS_skv_cool_sw switcher
    switch {
        position = {317, 245, 25, 90},
        state = function()
            return get(AZS_skv_cool_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_skv_cool_sw) ~= 0 then
					set(AZS_skv_cool_sw, 0)
				else
					set(AZS_skv_cool_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
  	-- AZS_skv_heat_sw switcher
    switch {
        position = {317, 123, 25, 90},
        state = function()
            return get(AZS_skv_heat_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_skv_heat_sw) ~= 0 then
					set(AZS_skv_heat_sw, 0)
				else
					set(AZS_skv_heat_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

  	-- AZS_skv_heat_sw switcher
    switch {
        position = {353, 123, 25, 90},
        state = function()
            return get(AZS_skv_heat_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_skv_heat_sw) ~= 0 then
					set(AZS_skv_heat_sw, 0)
				else
					set(AZS_skv_heat_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

  	-- AZS_skv_THU_sw switcher
    switch {
        position = {48, 123, 25, 90},
        state = function()
            return get(AZS_skv_THU_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_skv_THU_sw) ~= 0 then
					set(AZS_skv_THU_sw, 0)
				else
					set(AZS_skv_THU_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

 	-- AZS_POS_sw switcher
    switch {
        position = {240, 245, 25, 90},
        state = function()
            return get(AZS_POS_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_POS_sw) ~= 0 then
					set(AZS_POS_sw, 0)
				else
					set(AZS_POS_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

  	-- AZS_eng3_heat_sw switcher
    switch {
        position = {240, 123, 25, 90},
        state = function()
            return get(AZS_eng3_heat_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_eng3_heat_sw) ~= 0 then
					set(AZS_eng3_heat_sw, 0)
				else
					set(AZS_eng3_heat_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

   	-- AZS_eng2_heat_sw switcher
    switch {
        position = {201, 123, 25, 90},
        state = function()
            return get(AZS_eng2_heat_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_eng2_heat_sw) ~= 0 then
					set(AZS_eng2_heat_sw, 0)
				else
					set(AZS_eng2_heat_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },
 
    -- AZS_eng1_heat_sw switcher
    switch {
        position = {163, 123, 25, 90},
        state = function()
            return get(AZS_eng1_heat_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_eng1_heat_sw) ~= 0 then
					set(AZS_eng1_heat_sw, 0)
				else
					set(AZS_eng1_heat_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

   	-- taxi_light1 switcher
    switch {
        position = {48, 0, 25, 90},
        state = function()
            return get(taxi_light1) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(taxi_light1) ~= 0 then
					set(taxi_light1, 0)
				else
					set(taxi_light1, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

    -- lan_light1 switcher
    switch {
        position = {87, 0, 25, 90},
        state = function()
            return get(lan_light1) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(lan_light1) ~= 0 then
					set(lan_light1, 0)
				else
					set(lan_light1, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

     -- taxi_light2 switcher
    switch {
        position = {125, 0, 25, 90},
        state = function()
            return get(taxi_light2) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(taxi_light2) ~= 0 then
					set(taxi_light2, 0)
				else
					set(taxi_light2, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

      -- lan_light2 switcher
    switch {
        position = {163, 0, 25, 90},
        state = function()
            return get(lan_light2) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(lan_light2) ~= 0 then
					set(lan_light2, 0)
				else
					set(lan_light2, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

 	-- AZS_AP_sw switcher
    switch {
        position = {240, 365, 25, 90},
        state = function()
            return get(AZS_AP_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_AP_sw) ~= 0 then
					set(AZS_AP_sw, 0)
				else
					set(AZS_AP_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

  	-- AZS_sign_gear2_sw switcher
    switch {
        position = {279, 365, 25, 90},
        state = function()
            return get(AZS_sign_gear2_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_sign_gear2_sw) ~= 0 then
					set(AZS_sign_gear2_sw, 0)
				else
					set(AZS_sign_gear2_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
  	-- AZS_rockets_sw switcher
    switch {
        position = {317, 365, 25, 90},
        state = function()
            return get(AZS_rockets_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_rockets_sw) ~= 0 then
					set(AZS_rockets_sw, 0)
				else
					set(AZS_rockets_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
 	-- AZS_radio2_sw switcher
    switch {
        position = {87, 245, 25, 90},
        state = function()
            return get(AZS_radio2_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_radio2_sw) ~= 0 then
					set(AZS_radio2_sw, 0)
				else
					set(AZS_radio2_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

  	-- AZS_join_sw switcher
    switch {
        position = {125, 123, 25, 90},
        state = function()
            return get(AZS_join_sw) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(AZS_join_sw) ~= 0 then
					set(AZS_join_sw, 0)
				else
					set(AZS_join_sw, 1)
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