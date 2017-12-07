size = {512, 516}

-- define sources
defineProperty("gear_blocks", globalPropertyi("sim/custom/xap/covers/gear_blocks"))-- gear blocks. 0 = off, 1 = on
defineProperty("pitot1_cap", globalPropertyi("sim/custom/xap/covers/pitot1_cap"))-- pitot cap. 0 = off, 1 = on
defineProperty("pitot2_cap", globalPropertyi("sim/custom/xap/covers/pitot2_cap"))-- pitot cap. 0 = off, 1 = on
defineProperty("rio_cap", globalPropertyi("sim/custom/xap/covers/rio_cap"))-- RIO3 cap. 0 = off, 1 = on
defineProperty("static1_cap", globalPropertyi("sim/custom/xap/covers/static1_cap"))-- static cap. 0 = off, 1 = on
defineProperty("static2_cap", globalPropertyi("sim/custom/xap/covers/static2_cap"))-- static cap. 0 = off, 1 = on
defineProperty("engine1_front_cap", globalPropertyi("sim/custom/xap/covers/engine1_front_cap"))-- engine cap. 0 = off, 1 = on
defineProperty("engine1_back_cap", globalPropertyi("sim/custom/xap/covers/engine1_back_cap"))-- engine cap. 0 = off, 1 = on
defineProperty("engine2_front_cap", globalPropertyi("sim/custom/xap/covers/engine2_front_cap"))-- engine cap. 0 = off, 1 = on
defineProperty("engine2_back_cap", globalPropertyi("sim/custom/xap/covers/engine2_back_cap"))-- engine cap. 0 = off, 1 = on
defineProperty("engine3_front_cap", globalPropertyi("sim/custom/xap/covers/engine3_front_cap"))-- engine cap. 0 = off, 1 = on
defineProperty("engine3_back_cap", globalPropertyi("sim/custom/xap/covers/engine3_back_cap"))-- engine cap. 0 = off, 1 = on
defineProperty("ground_available", globalPropertyi("sim/custom/xap/power/ground_available"))-- ground power. 0 = off, 1 = on
defineProperty("door", globalPropertyi("sim/cockpit2/switches/custom_slider_on[4]"))-- left soor. 0 = close, 1 = open
defineProperty("hole4", globalPropertyf("sim/flightmodel2/misc/custom_slider_ratio[4]")) 

defineProperty("ground_service", globalPropertyi("sim/custom/xap/panels/ground_service"))-- ground service panel

defineProperty("N1", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[1]"))   
defineProperty("N2", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[0]"))
defineProperty("N3", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[2]"))
defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time of frame

-- sim variables
defineProperty("ground_speed", globalPropertyf("sim/flightmodel/position/groundspeed"))

defineProperty("background", loadImage("ground_panel.png", 0, 0, 512, 512))
defineProperty("green_dot", loadImage("azs_2d.png", 887, 8, 23, 23))
local start_counter = 0
local notLoaded = true
local switcher_pushed = false
local acf_moving = false

local ground_lit = false
local rio3_lit = false
local pitot1_lit = false
local pitot2_lit = false
local door_lit = false
local stat1_lit = false
local stat2_lit = false
local blocks_lit = false
local eng_front1_lit = false
local eng_front2_lit = false
local eng_front3_lit = false
local eng_back1_lit = false
local eng_back2_lit = false
local eng_back3_lit = false

function update()

	local passed = get(frame_time)
	start_counter = start_counter + passed	
	if start_counter > 0.3 and start_counter < 0.5 and notLoaded and get(N1) < 20 and get(N2) < 20 and get(N3) < 20 then
		set(gear_blocks, 1)
		set(pitot1_cap, 1)
		set(pitot2_cap, 1)
		set(rio_cap, 1)
		set(static1_cap, 1)
		set(static2_cap, 1)
		set(engine1_front_cap, 1)
		set(engine2_front_cap, 1)
		set(engine3_front_cap, 1)
		set(engine1_back_cap, 1)
		set(engine2_back_cap, 1)
		set(engine3_back_cap, 1)
		notLoaded = false
	end

	acf_moving = get(ground_speed) > 1
	
	if acf_moving then set(ground_available, 0) end
	
	ground_lit = get(ground_available) == 0
	rio3_lit = get(rio_cap) == 0
	pitot1_lit = get(pitot1_cap) == 0
	pitot2_lit = get(pitot2_cap) == 0
	door_lit = get(hole4) < 0.05
	stat1_lit = get(static1_cap) == 0
	stat2_lit = get(static2_cap) == 0
	blocks_lit = get(gear_blocks) == 0
	eng_front1_lit = get(engine1_front_cap) == 0
	eng_front2_lit = get(engine2_front_cap) == 0
	eng_front3_lit = get(engine3_front_cap) == 0	
	eng_back1_lit = get(engine1_back_cap) == 0
	eng_back2_lit = get(engine2_back_cap) == 0
	eng_back3_lit = get(engine3_back_cap) == 0
	
end

components = {

	rectangle {
		position = {0, 0, size[1], size[2]},
		color = {0,0,0,0.0},
	},

	textureLit {
		position = {0, 4, 512, 512},
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
			set(ground_service, 0)
			return true
		end,
    },	
	
	--------------------
	-- leds --
	--------------------

	textureLit {
		position = {210, 433, 23, 23},
		image = get(green_dot),
		visible = function()
			return ground_lit
		end
	},	

	textureLit {
		position = {270, 433, 23, 23},
		image = get(green_dot),
		visible = function()
			return rio3_lit
		end
	},	

	textureLit {
		position = {208, 405, 23, 23},
		image = get(green_dot),
		visible = function()
			return pitot1_lit
		end
	},	

	textureLit {
		position = {274, 405, 23, 23},
		image = get(green_dot),
		visible = function()
			return pitot2_lit
		end
	},

	textureLit {
		position = {208, 378, 23, 23},
		image = get(green_dot),
		visible = function()
			return door_lit
		end
	},	
	
	textureLit {
		position = {209, 342, 23, 23},
		image = get(green_dot),
		visible = function()
			return stat1_lit
		end
	},

	textureLit {
		position = {274, 342, 23, 23},
		image = get(green_dot),
		visible = function()
			return stat2_lit
		end
	},

	textureLit {
		position = {297, 271, 23, 23},
		image = get(green_dot),
		visible = function()
			return blocks_lit
		end
	},

	textureLit {
		position = {190, 188, 23, 23},
		image = get(green_dot),
		visible = function()
			return eng_front1_lit
		end
	},

	textureLit {
		position = {241, 193, 23, 23},
		image = get(green_dot),
		visible = function()
			return eng_front2_lit
		end
	},

	textureLit {
		position = {291, 188, 23, 23},
		image = get(green_dot),
		visible = function()
			return eng_front3_lit
		end
	},

	textureLit {
		position = {193, 104, 23, 23},
		image = get(green_dot),
		visible = function()
			return eng_back1_lit
		end
	},

	textureLit {
		position = {240, 38, 23, 23},
		image = get(green_dot),
		visible = function()
			return eng_back2_lit
		end
	},
	
	textureLit {
		position = {287, 104, 23, 23},
		image = get(green_dot),
		visible = function()
			return eng_back3_lit
		end
	},
	
	------------------
	-- switchers --
	------------------
	
	-- gear_blocks switcher
    switch {
        position = {290, 270, 100, 50},
        state = function()
            return get(gear_blocks) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and not acf_moving then
				if get(gear_blocks) ~= 0 then
					set(gear_blocks, 0)
				else
					set(gear_blocks, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

	-- pitot1_cap switcher
    switch {
        position = {140, 403, 100, 27},
        state = function()
            return get(pitot1_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and not acf_moving then
				if get(pitot1_cap) ~= 0 then
					set(pitot1_cap, 0)
				else
					set(pitot1_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },		
	
	-- pitot2_cap switcher
    switch {
        position = {275, 403, 100, 27},
        state = function()
            return get(pitot2_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and not acf_moving then
				if get(pitot2_cap) ~= 0 then
					set(pitot2_cap, 0)
				else
					set(pitot2_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- rio_cap switcher
    switch {
        position = {275, 430, 100, 27},
        state = function()
            return get(rio_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and not acf_moving then
				if get(rio_cap) ~= 0 then
					set(rio_cap, 0)
				else
					set(rio_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- static1_cap switcher
    switch {
        position = {140, 340, 100, 27},
        state = function()
            return get(static1_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and not acf_moving then
				if get(static1_cap) ~= 0 then
					set(static1_cap, 0)
				else
					set(static1_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },		
	
	-- static2_cap switcher
    switch {
        position = {275, 340, 100, 27},
        state = function()
            return get(static2_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and not acf_moving then
				if get(static2_cap) ~= 0 then
					set(static2_cap, 0)
				else
					set(static2_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- engine1_front_cap switcher
    switch {
        position = {150, 180, 70, 40},
        state = function()
            return get(engine1_front_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and not acf_moving then
				if get(engine1_front_cap) ~= 0 then
					set(engine1_front_cap, 0)
				else
					set(engine1_front_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },		
	
	-- engine1_back_cap switcher
    switch {
        position = {150, 90, 70, 40},
        state = function()
            return get(engine1_back_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and not acf_moving then
				if get(engine1_back_cap) ~= 0 then
					set(engine1_back_cap, 0)
				else
					set(engine1_back_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },		
	
	-- engine2_front_cap switcher
    switch {
        position = {220, 190, 70, 40},
        state = function()
            return get(engine2_front_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and not acf_moving then
				if get(engine2_front_cap) ~= 0 then
					set(engine2_front_cap, 0)
				else
					set(engine2_front_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },		
	
	-- engine2_back_cap switcher
    switch {
        position = {220, 30, 70, 40},
        state = function()
            return get(engine2_back_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and not acf_moving then
				if get(engine2_back_cap) ~= 0 then
					set(engine2_back_cap, 0)
				else
					set(engine2_back_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },		
	
	-- engine3_front_cap switcher
    switch {
        position = {290, 180, 70, 40},
        state = function()
            return get(engine3_front_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and not acf_moving then
				if get(engine3_front_cap) ~= 0 then
					set(engine3_front_cap, 0)
				else
					set(engine3_front_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },		
	
	-- engine3_back_cap switcher
    switch {
        position = {290, 90, 70, 40},
        state = function()
            return get(engine3_back_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and not acf_moving then
				if get(engine3_back_cap) ~= 0 then
					set(engine3_back_cap, 0)
				else
					set(engine3_back_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- ground_available switcher
    switch {
        position = {140, 430, 100, 27},
        state = function()
            return get(ground_available) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and not acf_moving then
				if get(ground_available) ~= 0 then
					set(ground_available, 0)
				else
					set(ground_available, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- door switcher
    switch {
        position = {140, 370, 100, 30},
        state = function()
            return get(door) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and not acf_moving then
				if get(door) ~= 0 then
					set(door, 0)
				else
					set(door, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },		
	
	-- quick prepare
	clickable {
		position = {300, 0, 150, 40},  -- search and set right
        
		cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
		},  
        
       	onMouseClick = function() 
			set(gear_blocks, 0)
			set(pitot1_cap, 0)
			set(pitot2_cap, 0)
			set(rio_cap, 0)
			set(static1_cap, 0)
			set(static2_cap, 0)
			set(engine1_front_cap, 0)
			set(engine2_front_cap, 0)
			set(engine3_front_cap, 0)
			set(engine1_back_cap, 0)
			set(engine2_back_cap, 0)
			set(engine3_back_cap, 0)
			set(ground_available, 0)
			set(door, 0)
			return true
		end,
    },	
	
	-- quick park
	clickable {
		position = {50, 0, 150, 40},  -- search and set right
        
		cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
		},  
        
       	onMouseClick = function() 
			set(gear_blocks, 1)
			set(pitot1_cap, 1)
			set(pitot2_cap, 1)
			set(rio_cap, 1)
			set(static1_cap, 1)
			set(static2_cap, 1)
			set(engine1_front_cap, 1)
			set(engine2_front_cap, 1)
			set(engine3_front_cap, 1)
			set(engine1_back_cap, 1)
			set(engine2_back_cap, 1)
			set(engine3_back_cap, 1)
			set(ground_available, 0)
			set(door, 0)
			return true
		end,
    },	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
