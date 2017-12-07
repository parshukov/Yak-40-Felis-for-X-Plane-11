-- this is the start panel
size = {2048, 2048}

defineProperty("emerg_stop1", globalPropertyi("sim/custom/xap/start/emerg_stop1")) -- stop button
defineProperty("emerg_stop2", globalPropertyi("sim/custom/xap/start/emerg_stop2")) -- stop button
defineProperty("emerg_stop3", globalPropertyi("sim/custom/xap/start/emerg_stop3")) -- stop button

defineProperty("emerg_stop1_cap", globalPropertyi("sim/custom/xap/start/emerg_stop1_cap")) -- stop button
defineProperty("emerg_stop2_cap", globalPropertyi("sim/custom/xap/start/emerg_stop2_cap")) -- stop button
defineProperty("emerg_stop3_cap", globalPropertyi("sim/custom/xap/start/emerg_stop3_cap")) -- stop button

defineProperty("air_start1", globalPropertyi("sim/custom/xap/start/air_start1")) -- air start button
defineProperty("air_start2", globalPropertyi("sim/custom/xap/start/air_start2")) -- air start button
defineProperty("air_start3", globalPropertyi("sim/custom/xap/start/air_start3")) -- air start button

defineProperty("air_start1_cap", globalPropertyi("sim/custom/xap/start/air_start1_cap")) -- air start button
defineProperty("air_start2_cap", globalPropertyi("sim/custom/xap/start/air_start2_cap")) -- air start button
defineProperty("air_start3_cap", globalPropertyi("sim/custom/xap/start/air_start3_cap")) -- air start button

defineProperty("start_sw", globalPropertyi("sim/custom/xap/start/start_sw")) -- starter switcher
defineProperty("start_mode_sw", globalPropertyi("sim/custom/xap/start/start_mode_sw")) -- start mode switcher
defineProperty("eng_select_sw", globalPropertyi("sim/custom/xap/start/eng_select_sw")) -- engine selector switcher
defineProperty("start_but", globalPropertyi("sim/custom/xap/start/start_but")) -- start button
defineProperty("stop_but", globalPropertyi("sim/custom/xap/start/stop_but")) -- stop button

defineProperty("starter_press", globalPropertyf("sim/custom/xap/start/starter_press")) -- pressure in start system
defineProperty("starter_work_lit", globalPropertyi("sim/custom/xap/start/starter_work_lit")) -- starter lamp

defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("but_test_lamp", globalPropertyi("sim/custom/xap/buttons/but_test_lamp")) -- test lamps button
defineProperty("AZS_sign_start_sw", globalPropertyi("sim/custom/xap/azs/AZS_sign_start_sw"))  -- AZS for start signal

defineProperty("cap_switch", globalPropertyi("sim/cockpit2/switches/custom_slider_on[11]")) -- start panel cap

defineProperty("needles_5", loadImage("needles.png", 16, 111, 16, 98))
defineProperty("start_led", loadImage("lamps.png", 180, 200, 60, 25))
defineProperty("cover", loadImage("covers.png", 265, 68, 75, 52))

local switch_sound = loadSample('Custom Sounds/metal_switch.wav')
local btn_click = loadSample('Custom Sounds/plastic_btn.wav')
local cap_sound = loadSample('Custom Sounds/cap.wav')

local switcher_pushed = false

local starter_lit = false
local start_angle = -60
function update()
	start_angle = get(starter_press) * 120 / 8 - 60
	local power = get(DC_27_volt) > 21
	local test_lamp = get(but_test_lamp) == 1
	
	if power then
		starter_lit = get(starter_work_lit) == 1 and get(AZS_sign_start_sw) == 1 or test_lamp
	else
		starter_lit = false
	end
	
	
end




local switcher_pushed = false
components = {

	-- engine starting
	textureLit {
		position = { 1955, 1018, 60, 25},
		image = get(start_led),
		visible = function()
			return starter_lit
		end
	},

	-- white needle
    needle {
        position = { 888, 1829, 110, 110 },
        image = get(needles_5),
        angle = function()
			return start_angle
        end
    },
	
	-- cover
	texture {
		position = {900, 1850, 85, 60},
		image = get(cover),
	},

	-------------------------
	-- switchers and buttons
	-------------------------

    -- open start panel cap
    switch {
        position = {688, 442, 90,  37},
        state = function()
            return get(cap_switch) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				if get(cap_switch) ~= 0 then
					set(cap_switch, 0)
				else
					set(cap_switch, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },
	
	
    -- air start 1 switcher cap
    switch {
        position = {840, 468, 60,  118},
        state = function()
            return get(air_start1_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(air_start1_cap) ~= 0 then
					set(air_start1_cap, 0)
				else
					set(air_start1_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },
	
    -- air start 2 switcher cap
    switch {
        position = {900, 468, 60,  118},
        state = function()
            return get(air_start2_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(air_start2_cap) ~= 0 then
					set(air_start2_cap, 0)
				else
					set(air_start2_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
    -- air start 3 switcher cap
    switch {
        position = {961, 468, 60,  118},
        state = function()
            return get(air_start3_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(air_start3_cap) ~= 0 then
					set(air_start3_cap, 0)
				else
					set(air_start3_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },		
	

	-- air start button
    clickable {
        position = {1143, 629, 18, 18},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if get(air_start1_cap) == 1 then 
				set(air_start1, 1) 
				if not switcher_pushed then playSample(btn_click, 0) switcher_pushed = true end
			end
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			if get(air_start1_cap) == 1 then playSample(btn_click, 0) end
			set(air_start1, 0)
			return true		
		end
    },

	-- air start button
    clickable {
        position = {1163, 629, 18, 18},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if get(air_start2_cap) == 1 then 
				if not switcher_pushed then playSample(btn_click, 0) switcher_pushed = true end
				set(air_start2, 1) end
			return true
		end,
		onMouseUp = function()
			if get(air_start2_cap) == 1 then playSample(btn_click, 0) end
			set(air_start2, 0)
			return true		
		end
    },	
	
	-- air start button
    clickable {
        position = {1183, 629, 18, 18},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if get(air_start3_cap) == 1 then 
				set(air_start3, 1) 
				if not switcher_pushed then playSample(btn_click, 0) switcher_pushed = true end
			end
			return true
		end,
		onMouseUp = function()
			if get(air_start3_cap) == 1 then playSample(btn_click, 0) end
			set(air_start3, 0)
			return true		
		end
    },	
	
	
	
	
	

	-- starter switcher
    switch {
        position = {702, 688, 19, 19},
        state = function()
            return get(start_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(start_sw) ~= 0 then
					set(start_sw, 0)
				else
					set(start_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- start mode switcher
    -- 1
    clickable {
        position = {754, 698, 7, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if get(start_mode_sw) ~= 1 then playSample(switch_sound, 0) end
			set(start_mode_sw, 1)
			return true
		end,
    },	

    -- 2
    clickable {
        position = {754, 688, 7, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if get(start_mode_sw) ~= 2 then playSample(switch_sound, 0) end
			set(start_mode_sw, 2)
			return true
		end,
    },	

    -- 3
    clickable {
        position = {741, 693, 7, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if get(start_mode_sw) ~= 3 then playSample(switch_sound, 0) end
			set(start_mode_sw, 3)
			return true
		end,
    },

    -- 0
    clickable {
        position = {749, 693, 4, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if get(start_mode_sw) ~= 0 then playSample(switch_sound, 0) end
			set(start_mode_sw, 0)
			return true
		end,
    },

	-- engine selector 
    -- 1
    clickable {
        position = {762, 698, 7, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if get(eng_select_sw) ~= 1 then playSample(switch_sound, 0) end
			set(eng_select_sw, 1)
			return true
		end,
    },	

    -- 2
    clickable {
        position = {774, 693, 7, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if get(eng_select_sw) ~= 2 then playSample(switch_sound, 0) end
			set(eng_select_sw, 2)
			return true
		end,
    },	

    -- 3
    clickable {
        position = {762, 688, 7, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if get(eng_select_sw) ~= 3 then playSample(switch_sound, 0) end
			set(eng_select_sw, 3)
			return true
		end,
    },

    -- 0
    clickable {
        position = {769, 693, 4, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if get(eng_select_sw) ~= 0 then playSample(switch_sound, 0) end
			set(eng_select_sw, 0)
			return true
		end,
    },

	-- start button
    clickable {
        position = {1002, 649, 18, 18},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed then playSample(btn_click, 0) end
			switcher_pushed = true
			set(start_but, 1)
			return true
		end,
		onMouseUp = function()
			playSample(btn_click, 0)
			switcher_pushed = false
			set(start_but, 0)
			return true		
		end
    },	

	-- stop button
    clickable {
        position = {982, 649, 18, 18},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed then playSample(btn_click, 0) end
			switcher_pushed = true
			set(stop_but, 1)
			return true
		end,
		onMouseUp = function()
			playSample(btn_click, 0)
			switcher_pushed = false
			set(stop_but, 0)
			return true		
		end
    },
	
	
    -- emerg_stop1_cap switcher
    switch {
        position = {1821, 554, 45, 95},
        state = function()
            return get(emerg_stop1_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(emerg_stop1_cap) ~= 0 then
					set(emerg_stop1_cap, 0)
				else
					set(emerg_stop1_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

    -- emerg_stop2_cap switcher
    switch {
        position = {1866, 554, 45, 95},
        state = function()
            return get(emerg_stop2_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(emerg_stop2_cap) ~= 0 then
					set(emerg_stop2_cap, 0)
				else
					set(emerg_stop2_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

    -- emerg_stop3_cap switcher
    switch {
        position = {1916, 554, 45, 95},
        state = function()
            return get(emerg_stop3_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(emerg_stop3_cap) ~= 0 then
					set(emerg_stop3_cap, 0)
				else
					set(emerg_stop3_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- emerg stop button
    clickable {
        position = {882, 609, 18, 18},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if get(emerg_stop1_cap) == 1 then 
				if not switcher_pushed then playSample(btn_click, 0) end
				switcher_pushed = true
				set(emerg_stop1, 1) 
			end
			return true
		end,
		onMouseUp = function()
			if get(emerg_stop1_cap) == 1 then playSample(btn_click, 0) end
			switcher_pushed = false
			set(emerg_stop1, 0)
			return true		
		end
    },

	-- emerg stop button
    clickable {
        position = {902, 609, 18, 18},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if get(emerg_stop2_cap) == 1 then 
				if not switcher_pushed then playSample(btn_click, 0) end
				switcher_pushed = true
				set(emerg_stop2, 1) 
			end
			return true
		end,
		onMouseUp = function()
			if get(emerg_stop2_cap) == 1 then playSample(btn_click, 0) end
			switcher_pushed = false
			set(emerg_stop2, 0)
			return true		
		end
    },

	-- emerg stop button
    clickable {
        position = {922, 609, 18, 18},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if get(emerg_stop3_cap) == 1 then 
				if not switcher_pushed then playSample(btn_click, 0) end
				switcher_pushed = true
				set(emerg_stop3, 1) 
			end
			return true
		end,
		onMouseUp = function()
			if get(emerg_stop3_cap) == 1 then playSample(btn_click, 0) end
			switcher_pushed = false
			set(emerg_stop3, 0)
			return true		
		end
    },








	

}

















