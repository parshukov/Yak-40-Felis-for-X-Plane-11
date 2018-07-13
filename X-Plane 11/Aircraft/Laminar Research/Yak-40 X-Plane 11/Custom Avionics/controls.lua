-- this is controls panel
size = {2048, 2048}

defineProperty("control_fix", globalPropertyi("sim/custom/xap/control/control_fix")) -- fix controls, so they cannot move. 1 = fix, 0 = released
defineProperty("control_fix_sw", globalPropertyi("sim/custom/xap/control/control_fix_sw")) -- fix controls switcher
defineProperty("control_fix_pow", globalPropertyi("sim/custom/xap/control/control_fix_pow")) -- fix controls power

defineProperty("pitch_trim", globalPropertyf("sim/custom/xap/control/pitch_trim")) -- virtual pitch trimmer. in Yak40 have range from -3 to +6 in degrees of stab.
defineProperty("roll_trim", globalPropertyf("sim/custom/xap/control/roll_trim")) -- virtual roll trimmer
defineProperty("yaw_trim", globalPropertyf("sim/custom/xap/control/yaw_trim")) -- virtual yaw trimmer

defineProperty("roll_sw", globalPropertyi("sim/custom/xap/control/roll_sw")) -- roll switcher position
defineProperty("yaw_sw", globalPropertyi("sim/custom/xap/control/yaw_sw")) -- roll switcher position
defineProperty("pitch_sw", globalPropertyi("sim/custom/xap/control/pitch_sw")) -- roll switcher position

defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("but_test_lamp", globalPropertyi("sim/custom/xap/buttons/but_test_lamp")) -- test lamps button

-- engines work
defineProperty("N1", globalPropertyf("sim/flightmodel/engine/ENGN_N1_[1]"))   
defineProperty("N2", globalPropertyf("sim/flightmodel/engine/ENGN_N1_[0]"))
defineProperty("N3", globalPropertyf("sim/flightmodel/engine/ENGN_N1_[2]"))
defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- frame time

defineProperty("yellow_led", loadImage("leds.png", 60, 0, 20, 20)) 
defineProperty("green_led", loadImage("leds.png", 20, 0, 20, 20)) 
defineProperty("red_led", loadImage("leds.png", 40, 0, 20, 20)) 

defineProperty("fix_led", loadImage("lamps.png", 0, 50, 60, 25)) 

pitch_UP_comm = findCommand("sim/flight_controls/pitch_trim_up")
pitch_DOWN_comm = findCommand("sim/flight_controls/pitch_trim_down")
pitch_TO_comm = findCommand("sim/flight_controls/pitch_trim_takeoff")

roll_LEFT_comm = findCommand("sim/flight_controls/aileron_trim_left")
roll_RIGHT_comm = findCommand("sim/flight_controls/aileron_trim_right")
roll_CTR_comm = findCommand("sim/flight_controls/aileron_trim_center")

yaw_LEFT_comm = findCommand("sim/flight_controls/rudder_trim_left")
yaw_RIGHT_comm = findCommand("sim/flight_controls/rudder_trim_right")
yaw_CTR_comm = findCommand("sim/flight_controls/rudder_trim_center")

local switch_sound = loadSample('Custom Sounds/metal_switch.wav')

local fix_power_lit = false
local fix_ON_lit = false
local fix_OFF_lit = false
local roll_center_lit = false
local yaw_center_lit = false
local switcher_pushed = false

local not_loaded = true
local time_counter = 0

function update()
	local passed = get(frame_time) -- time of frame
	time_counter = time_counter + passed
	if get(N1) < 10 and get(N2) < 10 and get(N3) < 10 and time_counter > 0.3 and time_counter < 0.4 and not_loaded then
		set(control_fix, 1)
		set(control_fix_sw, 1)
		not_loaded = false
	end

	local power = get(DC_27_volt) > 19
	local fix_power = get(control_fix_pow) == 1
	local test_lamp = get(but_test_lamp) == 1
	
	if power then
		if fix_power then set(control_fix, get(control_fix_sw)) end -- set fixator
		fix_ON_lit = get(control_fix) == 1 or test_lamp -- set lamps
		fix_OFF_lit = not fix_ON_lit or test_lamp
		fix_power_lit = fix_power or test_lamp
		roll_center_lit = math.abs(get(roll_trim)) < 0.02 or test_lamp
		yaw_center_lit = math.abs(get(yaw_trim)) < 0.02 or test_lamp
	else
		fix_ON_lit = false
		fix_OFF_lit = false
		fix_power_lit = false
		roll_center_lit = false
		yaw_center_lit = false
	end
	
end

components = {

	-- fix_power_lit
	textureLit {
		position = {884, 791, 24, 24},
		image = get(red_led),
		visible = function()
			return fix_power_lit
		end
	},

	-- fix_OFF_lit
	textureLit {
		position = {854, 791, 24, 24},
		image = get(green_led),
		visible = function()
			return fix_OFF_lit
		end
	},

	-- fix_ON_lit
	textureLit {
		position = {823, 791, 24, 24},
		image = get(red_led),
		visible = function()
			return fix_ON_lit
		end
	},

	-- fix_ON_lit
	textureLit {
		position = {1594, 973, 60, 26},
		image = get(fix_led),
		visible = function()
			return fix_ON_lit
		end
	},
	
	

	-- roll_center_lit
	textureLit {
		position = {1184, 882, 24, 24},
		image = get(green_led),
		visible = function()
			return roll_center_lit
		end
	},
	
	-- yaw_center_lit
	textureLit {
		position = {823, 820, 24, 24},
		image = get(green_led),
		visible = function()
			return yaw_center_lit
		end
	},
	
	-- control_fix_sw switcher
    switch {
        position = {781, 609, 39, 19},
        state = function()
            return get(control_fix_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(control_fix_sw) ~= 0 then
					set(control_fix_sw, 0)
				else
					set(control_fix_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- control_fix_pow switcher
    switch {
        position = {822, 609, 19, 19},
        state = function()
            return get(control_fix_pow) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(control_fix_pow) ~= 0 then
					set(control_fix_pow, 0)
				else
					set(control_fix_pow, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

    -- roll trimm left
    clickable {
        position = {1202, 708, 9, 19},  -- search and set right
        
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
				commandBegin(roll_LEFT_comm)
				set(roll_sw, -1)
				switcher_pushed = true
			end
			return true
		end,
		onMouseUp = function()
			playSample(switch_sound, 0)
			commandEnd(roll_LEFT_comm)
			set(roll_sw, 0)
			switcher_pushed = false
			return true
		end,
    },

    -- roll trimm right
    clickable {
        position = {1211, 708, 9, 19},  -- search and set right
        
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
				commandBegin(roll_RIGHT_comm)
				set(roll_sw, 1)
				switcher_pushed = true
			end
			return true
		end,
		onMouseUp = function()
			playSample(switch_sound, 0)
			commandEnd(roll_RIGHT_comm)
			set(roll_sw, 0)
			switcher_pushed = false
			return true
		end,
    },

    -- yaw trimm left
    clickable {
        position = {1022, 709, 9, 19},  -- search and set right
        
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
				commandBegin(yaw_LEFT_comm)
				set(yaw_sw, -1)
				switcher_pushed = true
			end
			return true
		end,
		onMouseUp = function()
			playSample(switch_sound, 0)
			commandEnd(yaw_LEFT_comm)
			set(yaw_sw, 0)
			switcher_pushed = false
			return true
		end,
    },

    -- yaw trimm right
    clickable {
        position = {1031, 709, 9, 19},  -- search and set right
        
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
				commandBegin(yaw_RIGHT_comm)
				set(yaw_sw, 1)
				switcher_pushed = true
			end
			return true
		end,
		onMouseUp = function()
			playSample(switch_sound, 0)
			commandEnd(yaw_RIGHT_comm)
			set(yaw_sw, 0)
			switcher_pushed = false
			return true
		end,
    },
	
	
}
