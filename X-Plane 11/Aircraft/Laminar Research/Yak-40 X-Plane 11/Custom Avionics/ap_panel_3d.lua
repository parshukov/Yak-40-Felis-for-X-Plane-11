-- this is AP panel
size = {2048, 2048}

defineProperty("power_sw", globalPropertyi("sim/custom/xap/AP/power_sw")) -- power switcher
defineProperty("pitch_sw", globalPropertyi("sim/custom/xap/AP/pitch_sw")) -- pitch switcher
defineProperty("pitch_comm", globalPropertyi("sim/custom/xap/AP/pitch_comm")) -- pitch command handle
defineProperty("roll_comm", globalPropertyi("sim/custom/xap/AP/roll_comm")) -- roll command handle
defineProperty("ap_on_but", globalPropertyi("sim/custom/xap/AP/ap_on_but")) -- turn ON button
defineProperty("ap_alt_but", globalPropertyi("sim/custom/xap/AP/ap_alt_but")) -- hold alt button

defineProperty("ap_roll_pos", globalPropertyf("sim/custom/xap/AP/ap_roll_pos")) -- position of roll axis from AP
defineProperty("ap_hdg_pos", globalPropertyf("sim/custom/xap/AP/ap_hdg_pos")) -- position of hdg axis from AP
defineProperty("ap_pitch_pos", globalPropertyf("sim/custom/xap/AP/ap_pitch_pos")) -- position of pitch axis from AP

defineProperty("ap_works_roll", globalPropertyi("sim/custom/xap/AP/ap_works_roll")) -- autopilot has control over roll and hdg
defineProperty("ap_works_pitch", globalPropertyi("sim/custom/xap/AP/ap_works_pitch")) -- autopilot has control over pitch and stab

-- lamps
defineProperty("ap_ready_lit", globalPropertyi("sim/custom/xap/AP/ap_ready_lit")) -- autopilot is ready to work
defineProperty("ap_on_lit", globalPropertyi("sim/custom/xap/AP/ap_on_lit")) -- autopilot is working
defineProperty("ap_alt_lit", globalPropertyi("sim/custom/xap/AP/ap_alt_lit")) -- autopilot is working and holding altitude

defineProperty("ap_force_fail", globalPropertyi("sim/custom/xap/AP/ap_force_fail")) -- autopilot is sencing forse
defineProperty("ap_fail_roll", globalPropertyi("sim/custom/xap/AP/ap_fail_roll")) -- autopilot AP is OFF on roll channel due to failure or overforce by pilot
defineProperty("ap_fail_pitch", globalPropertyi("sim/custom/xap/AP/ap_fail_pitch")) -- autopilot AP is OFF on pitch channel due to failure or overforce by pilot

defineProperty("but_test_lamp", globalPropertyi("sim/custom/xap/buttons/but_test_lamp")) -- test lamps button

-- images
defineProperty("yellow_led", loadImage("leds.png", 60, 0, 20, 20)) 
defineProperty("green_led", loadImage("leds.png", 20, 0, 20, 20)) 
defineProperty("red_led", loadImage("leds.png", 40, 0, 20, 20)) 
defineProperty("white_led", loadImage("leds.png", 0, 0, 20, 20)) 
defineProperty("ap_force_fail_led", loadImage("lamps.png", 0, 0, 60, 25))
defineProperty("ap_fail_roll_led", loadImage("lamps.png", 60, 0, 60, 25))
defineProperty("ap_fail_pitch_led", loadImage("lamps.png", 120, 0, 60, 25))

local switcher_pushed = false
local switch_sound = loadSample('Custom Sounds/metal_switch.wav')
local btn_click = loadSample('Custom Sounds/plastic_btn.wav')


local ap_ready = false
local ap_on = false
local ap_alt = false
local ap_force = false
local ap_fail_roll_lit = false
local ap_fail_pitch_lit = false

function update()
	local test_lamp = get(but_test_lamp) == 1
	ap_ready = get(ap_ready_lit) == 1 or test_lamp
	ap_on = get(ap_on_lit) == 1 or test_lamp
	ap_alt = get(ap_alt_lit) == 1 or test_lamp
	ap_force = get(ap_force_fail) == 1 or test_lamp
	ap_fail_roll_lit = get(ap_fail_roll) == 1 or test_lamp
	ap_fail_pitch_lit = get(ap_fail_pitch) == 1 or test_lamp
	

end


-- components of panel
components = {

	-- ap_ready led
	textureLit {
		position = {854, 821, 24, 24},
		image = get(green_led),
		visible = function()
			return ap_ready
		end
	},	
	
	-- ap_on led
	textureLit {
		position = {883, 821, 24, 24},
		image = get(white_led),
		visible = function()
			return ap_on
		end
	},
	
	-- ap_alt led
	textureLit {
		position = {913, 821, 24, 24},
		image = get(white_led),
		visible = function()
			return ap_alt
		end
	},	
	
	-- ap_force led
	textureLit {
		position = { 1376, 1019, 60, 26},
		image = get(ap_force_fail_led),
		visible = function()
			return ap_force
		end
	},	
	
	-- ap_fail_roll_lit led
	textureLit {
		position = { 1448, 1019, 60, 26},
		image = get(ap_fail_roll_led),
		visible = function()
			return ap_fail_roll_lit
		end
	},	
	
	-- ap_fail_roll_lit led
	textureLit {
		position = { 1522, 1019, 60, 26},
		image = get(ap_fail_pitch_led),
		visible = function()
			return ap_fail_pitch_lit
		end
	},
	
	-- power_sw switcher
    switch {
        position = {1222, 709, 19, 19},
        state = function()
            return get(power_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(power_sw) ~= 0 then
					set(power_sw, 0)
				else
					set(power_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- pitch_sw switcher
    switch {
        position = {1241, 709, 19, 19},
        state = function()
            return get(pitch_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(pitch_sw) ~= 0 then
					set(pitch_sw, 0)
				else
					set(pitch_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- pitch down 
    clickable {
       position = { 1266, 718, 8, 10 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateup.png")
        },  
        
        onMouseClick = function(x, y, button) 
			if not switcher_pushed then playSample(switch_sound, 0) switcher_pushed = true end
			set(pitch_comm, -1)
            return true
        end,
		onMouseUp = function()
			playSample(switch_sound, 0)
			switcher_pushed = false
			set(pitch_comm, 0)
			return true
		end,
    },

	-- pitch up 
    clickable {
       position = { 1266, 708, 8, 10 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotatedown.png")
        },  
        
        onMouseClick = function(x, y, button) 
			if not switcher_pushed then playSample(switch_sound, 0) switcher_pushed = true end
			set(pitch_comm, 1)
            return true
        end,
		onMouseUp = function()
			playSample(switch_sound, 0)
			switcher_pushed = false
			set(pitch_comm, 0)
			return true
		end,
    },

	-- roll left
    clickable {
       position = { 1261, 708, 5, 19 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function(x, y, button) 
			local a = get(roll_comm)
			if not switcher_pushed and a > -30 then 
				playSample(switch_sound, 0) 
				switcher_pushed = true
				a = a - 5
				set(roll_comm, a)
			end
            return true
        end,
		onMouseUp = function()
			switcher_pushed = false
			return true
		end,
    },

	-- roll right
    clickable {
       position = { 1274, 708, 5, 19 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function(x, y, button) 
			local a = get(roll_comm)
			if not switcher_pushed and a < 30 then 
				playSample(switch_sound, 0) 
				switcher_pushed = true
				a = a + 5
				set(roll_comm, a)
			end
            return true
        end,
		onMouseUp = function()
			switcher_pushed = false
			return true
		end,
    },

	-- click sirene button
    clickable {
       position = { 885, 821, 22, 22 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
        onMouseClick = function(x, y, button) 
			if not switcher_pushed then playSample(btn_click, 0) switcher_pushed = true end
			set(ap_on_but, 1)
            return true
        end,
		onMouseUp = function()
			playSample(btn_click, 0)
			switcher_pushed = false
			set(ap_on_but, 0)
			return true
		end,
    },

	-- click sirene button
    clickable {
       position = { 915, 821, 22, 22 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
        onMouseClick = function(x, y, button) 
			if not switcher_pushed then playSample(btn_click, 0) switcher_pushed = true end
			set(ap_alt_but, 1)
            return true
        end,
		onMouseUp = function()
			playSample(btn_click, 0)
			switcher_pushed = false
			set(ap_alt_but, 0)
			return true
		end,
    },




}