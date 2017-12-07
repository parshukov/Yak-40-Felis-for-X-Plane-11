-- this is the simple logic of flaps movement
size = {2048, 2048}

-- define property table

-- hydraulic system
defineProperty("main_press", globalPropertyf("sim/custom/xap/hydro/main_press")) -- pressure in main system. initial 120 kg per square sm. maximum 160.
defineProperty("flaps_valve", globalPropertyi("sim/custom/xap/hydro/flaps_valve")) -- position of flaps valve for gydraulic calculations and animations.
defineProperty("flaps_valve_cap", globalPropertyi("sim/custom/xap/hydro/flaps_valve_cap")) -- position of flaps valve for gydraulic calculations and animations.
defineProperty("emerg_press", globalPropertyf("sim/custom/xap/hydro/emerg_press")) -- pressure in emergency system. initial 120 kg per square sm. maximum 160.
defineProperty("flaps_valve_emerg", globalPropertyi("sim/custom/xap/hydro/flaps_valve_emerg")) -- position of emergency flaps valve for gydraulic calculations and animations.
defineProperty("flaps_valve_emerg_cap", globalPropertyi("sim/custom/xap/hydro/flaps_valve_emerg_cap")) -- position of emergency flaps valve for gydraulic calculations and animations.


-- flap control
defineProperty("sim_flap", globalPropertyf("sim/cockpit2/controls/flap_ratio")) -- 0 = retracted, 1 = extended
defineProperty("sim_flap_time", globalPropertyf("sim/aircraft/controls/acf_flap_deftime")) -- time to make flaps full cycle
--[[
defineProperty("flap1", globalPropertyf("sim/flightmodel2/wing/flap1_deg[0]")) -- flap deg
defineProperty("flap2", globalPropertyf("sim/flightmodel2/wing/flap1_deg[1]")) -- flap deg
--]]
-- enviroment
defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames
defineProperty("flight_time", globalPropertyf("sim/time/total_running_time_sec")) -- sim time
defineProperty("flap_deg1", globalPropertyf("sim/flightmodel2/wing/flap1_deg[0]"))  -- left flap deg
defineProperty("flap_deg2", globalPropertyf("sim/flightmodel2/wing/flap1_deg[1]"))  -- right flap deg

-- power
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt

defineProperty("flap_cc", globalPropertyf("sim/custom/xap/hydro/flap_cc"))
defineProperty("flap_ind_cc", globalPropertyf("sim/custom/xap/hydro/flap_ind_cc"))
defineProperty("AZS_flaps_main_sw", globalPropertyi("sim/custom/xap/azs/AZS_flaps_main_sw")) -- AZS main flaps system
defineProperty("AZS_flaps_emerg_sw", globalPropertyi("sim/custom/xap/azs/AZS_flaps_emerg_sw")) -- AZS emerg flaps system
defineProperty("manometer_sw", globalPropertyi("sim/custom/xap/misc/manometer_sw"))  -- turn ON all manometers
defineProperty("but_test_lamp", globalPropertyi("sim/custom/xap/buttons/but_test_lamp")) -- test lamps button

-- result
defineProperty("ind_flap_angle", globalPropertyf("sim/custom/xap/hydro/ind_flap_angle")) -- angle for flap indicator

-- define images
defineProperty("needles_1", loadImage("needles.png", 0, 0, 16, 88)) 
defineProperty("needles_2", loadImage("needles.png", 18, 0, 13, 98)) 
defineProperty("needles_3", loadImage("needles.png", 34, 0, 13, 98)) 
defineProperty("needles_4", loadImage("needles.png", 0, 88, 15, 142)) 
defineProperty("needles_5", loadImage("needles.png", 16, 111, 16, 98))

defineProperty("cover", loadImage("covers2.png", 0, 0, 60, 88))

defineProperty("flaps_led", loadImage("lamps.png", 180, 25, 60, 25))

-- comands
flaps_command_up = findCommand("sim/flight_controls/flaps_up")
flaps_command_down = findCommand("sim/flight_controls/flaps_down")

local switch_sound = loadSample('Custom Sounds/metal_switch.wav')
local cap_sound = loadSample('Custom Sounds/cap.wav')

local use_emerg = false

function flaps_up_handler(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if 1 == phase then
		if not use_emerg then 
			set(flaps_valve, -1)
			set(flaps_valve_emerg, 0)
			--set(flaps_valve_emerg_cap, 0)
		else 
			set(flaps_valve, 0)
			set(flaps_valve_emerg, 0)
			--set(flaps_valve_emerg_cap, 0)
		end			
	else
		set(flaps_valve, 0)
		set(flaps_valve_emerg, 0)
		--set(flaps_valve_emerg_cap, 0)
    end
return 0
end

function flaps_down_handler(phase)
	if 1 == phase then
		if not use_emerg then 
			set(flaps_valve, 1)
			set(flaps_valve_emerg, 0)
			--set(flaps_valve_emerg_cap, 0)
		else
			set(flaps_valve, 0)
			set(flaps_valve_emerg, 1)
			set(flaps_valve_emerg_cap, 1)
		end
			
	else
		set(flaps_valve, 0)
		set(flaps_valve_emerg, 0)
		--set(flaps_valve_emerg_cap, 0)
    end
return 0
end

registerCommandHandler(flaps_command_up, 0, flaps_up_handler)
registerCommandHandler(flaps_command_down, 0, flaps_down_handler)

-- local variables
local passed = 0

local flap_pos = get(sim_flap) -- calculated position of virtual flap lever to manipulate flaps
local switcher_pushed = false
local flap_ind_angle = 45
local counter = 0
local flap_fail_lamp = false

-- post frame calculations
function update()
	passed = get(frame_time)
	local power27 = 0
	if get(DC_27_volt) > 21 then power27 = 1 end
	
	-- sync flaps position after load aircraft

	
-- all calculations produced only during sim work
if passed > 0 then
	local flap_speed = 0.00000001 -- by default flaps must not move. THIS MUST NOT BE = 0!!!
	local norm_valve = get(flaps_valve)
	local emerg_valve = get(flaps_valve_emerg)
	
	-- calculate new speed
	if norm_valve ~= 0 and power27 == 1 and get(AZS_flaps_main_sw) == 1 and not use_emerg then
		flap_speed = 0.1 * get(main_press) / 140 -- range per second
		set(flap_cc, 5)
	else
		set(flap_cc, 0)
	end
	
	if emerg_valve ~= 0 and power27 == 1 and get(AZS_flaps_emerg_sw) == 1 and use_emerg then
		flap_speed = 0.03 * get(emerg_press) / 140 -- range per second
	end

	-- check for zero
	if flap_speed < 0.00000001 then flap_speed = 0.00000001 end


	-- save new position of virtual flap handler
	if norm_valve ~= 0 or emerg_valve ~= 0 then -- if we use normal control, then plugin must not conflict with sim
		flap_pos = get(sim_flap)
	else
		set(sim_flap, flap_pos)		-- if we use some axis, plugin will get lever back to its last saved position
	end

	-- save results
	if counter > 1 then set(sim_flap_time, 1/flap_speed) 
	else set(sim_flap_time, 1) end
	counter = counter + passed
	
	-- calculate flap indicator and lamp
	if power27 > 0 and get(manometer_sw) == 1 and get(AC_36_volt) > 30 then
		flap_ind_angle = math.max(get(flap_deg1), get(flap_deg2)) * 90 / 60 + 45
		flap_fail_lamp = math.abs((get(flap_deg1) + get(flap_deg2)) - get(sim_flap) * 35 * 2) > 8 
		set(flap_ind_cc, 2)
	else
		flap_ind_angle = 45
		flap_fail_lamp = false
		set(flap_ind_cc, 0)
	end	
	
	flap_fail_lamp = flap_fail_lamp or get(but_test_lamp) == 1
	
	set(ind_flap_angle, flap_ind_angle)
end

end

components = {

	-- flaps image
	textureLit {
		position = {1522, 973, 60, 26},
		image = get(flaps_led),
		visible = function()
			return flap_fail_lamp
		end
	
	},	
	
	-----------------------
	-- needle indicators --
	-----------------------

	-- flap position indicator
	needle { 
		image = get(needles_5),
		position = {1680, 1321, 135, 135},
		angle = function()
		return flap_ind_angle
		end,	
	},

	-- cover
	texture {
		position = {1719, 1329, 70, 117},
		image = get(cover),
	},
	---------------
	-- switchers --
	---------------
	
    -- flap valve cap
    switch {
        position = {1141, 468, 60, 120 },
        state = function()
            return get(flaps_valve_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(flaps_valve_cap) ~= 0 then
					set(flaps_valve_cap, 0)
				else
					set(flaps_valve_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- flaps switch up
    clickable {
        position = {1042, 718, 19, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed then playSample(switch_sound, 0) switcher_pushed = true end
			use_emerg = false
			commandBegin(flaps_command_up)
			return true
		end, 
		onMouseUp = function()
			use_emerg = false
			playSample(switch_sound, 0)
			switcher_pushed = false
			commandEnd(flaps_command_up)
		end,		
    },
	
	-- flaps switch down
    clickable {
        position = {1042, 708, 19, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed then playSample(switch_sound, 0) switcher_pushed = true end
			use_emerg = false
			commandBegin(flaps_command_down)
			return true
		end, 
		onMouseUp = function()
			use_emerg = false
			playSample(switch_sound, 0)
			switcher_pushed = false
			commandEnd(flaps_command_down)
		end,		
    },	
	
	
	
    -- flap emerg valve cap
    switch {
        position = {1201, 468, 60, 120 },
        state = function()
            return get(flaps_valve_emerg_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(flaps_valve_emerg_cap) ~= 0 then
					set(flaps_valve_emerg_cap, 0)
				else
					set(flaps_valve_emerg_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- flaps emerg switch down
    clickable {
        position = {1082, 708, 19, 19},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed then playSample(switch_sound, 0) switcher_pushed = true end
			use_emerg = true
			commandBegin(flaps_command_down)
			return true
		end, 
		onMouseUp = function()
			use_emerg = false
			playSample(switch_sound, 0)
			switcher_pushed = false
			commandEnd(flaps_command_down)
		end,		
    },	






















}
