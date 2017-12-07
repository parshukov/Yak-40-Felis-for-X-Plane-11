-- this is the APU logic and its start panel
size = {2048, 2048}

-- define property table
-- sim variables
defineProperty("gen_on", globalPropertyi("sim/cockpit/electrical/generator_apu_on")) -- APU gen
defineProperty("apu_switch", globalPropertyi("sim/cockpit/engine/APU_switch")) -- APU starter switch 0 = off, 1 = on, 2 = start
defineProperty("has_apu", globalPropertyi("sim/aircraft/overflow/acf_has_APU_switch")) -- Aircraft has APU
defineProperty("apu_N1", globalPropertyf("sim/cockpit/engine/APU_N1")) -- APU N1
defineProperty("thermo", globalPropertyf("sim/cockpit2/temperature/outside_air_temp_degc")) -- outside temperature
defineProperty("ias", globalPropertyf("sim/flightmodel/position/indicated_airspeed")) -- SPEED
defineProperty("msl_alt", globalPropertyf("sim/flightmodel/position/elevation"))  -- barometric alt. maybe in feet, maybe in meters.
defineProperty("APU_press", globalPropertyi("sim/operation/failures/rel_APU_press")) -- APU press fail


-- custom switchers for APU
defineProperty("starter_sw", globalPropertyi("sim/custom/xap/apu/starter_sw")) -- starter switch
defineProperty("starter_mode", globalPropertyi("sim/custom/xap/apu/starter_mode")) -- starter mode. start, cold rotate, stopping
defineProperty("start_button", globalPropertyi("sim/custom/xap/apu/start_button")) -- start button pressed
defineProperty("stop_button", globalPropertyi("sim/custom/xap/apu/stop_button")) -- stop button pressed
defineProperty("apu_fire_ext", globalPropertyi("sim/custom/xap/apu/apu_fire_ext")) -- fire extinguisher for APU

-- power
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("AZS_start_apu_sw", globalPropertyi("sim/custom/xap/azs/AZS_start_apu_sw")) -- AZS for start APU
defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time of frame

-- custom parameters
defineProperty("apu_fuel_access", globalPropertyi("sim/custom/xap/fuel/apu_fuel_access")) -- APU can use fuel
defineProperty("apu_egt", globalPropertyf("sim/custom/xap/apu/apu_egt")) -- EGT for APU
defineProperty("apu_cc", globalPropertyf("sim/custom/xap/apu/apu_cc")) -- current consumption of APU's starter
defineProperty("apu_can_start", globalPropertyi("sim/custom/xap/apu/apu_can_start")) -- APU can start other engines
defineProperty("apu_on_fire", globalPropertyi("sim/custom/xap/apu/apu_on_fire")) -- APU is on fire

defineProperty("but_test_lamp", globalPropertyi("sim/custom/xap/buttons/but_test_lamp")) -- test lamps button

-- define images
defineProperty("needles_1", loadImage("needles.png", 0, 0, 16, 88)) 
defineProperty("start_led", loadImage("lamps.png", 180, 175, 60, 25))
defineProperty("norm_n1_led", loadImage("lamps.png", 60, 200, 60, 25))
defineProperty("norm_oil_led", loadImage("lamps.png", 0, 200, 60, 25))
defineProperty("fire_led", loadImage("lamps.png", 60, 50, 60, 25))
defineProperty("high_rpm_led", loadImage("lamps.png", 120, 50, 60, 25))
defineProperty("needles_5", loadImage("needles.png", 16, 111, 16, 98))
defineProperty("black_cap", loadImage("covers.png", 0, 56, 52, 52))

-- sounds
local switch_sound = loadSample('Custom Sounds/metal_switch.wav')
local button_sound = loadSample('Custom Sounds/plastic_btn.wav')


-- set variables
set(has_apu, 1) -- we use default APU only for start engines
set(gen_on, 0) -- AI9 don't have generator
set(apu_switch, 0) -- by default APU if OFF

local start_lit = false
local normal_n1_lit = false
local normal_oil_lit = false
local high_n1_lit = false
local fire_lit = false

local term_last = 0
local term = 0

local counter = 50
local apu_starting = false
local apu_burn_fuel = 0 -- 1 - if does
	
local termo_angle = -120	

local work_counter = 0
local was_fire_ext = false
local fire_counter = 20
local button_pressed = false

function update()


	local power = get(DC_27_volt) > 21
	local spd = get(ias)
	local passed = get(frame_time)
	local ai9n1 = get(apu_N1)
	-- calculate start of APU
	local start_sw = get(starter_sw)
	local start_mode = get(starter_mode)
	local start_bt = get(start_button) == 1
	local stop_bt = get(stop_button) == 1
	local apu_fuel = get(apu_fuel_access)
	local AZS = get(AZS_start_apu_sw)
	local ext = get(apu_fire_ext) == 1
	
	counter = counter + passed
	if power and start_sw == 1 and start_mode > 0 and start_bt and AZS == 1 and not apu_starting and ai9n1 < 10 then
		if start_mode == 1 and apu_fuel == 1 and not ext then -- normal starting mode
			counter = 0
			apu_starting = true
			apu_burn_fuel = 1
		else	-- cold rotate and conserve mode
			counter = 0
			apu_starting = true
			apu_burn_fuel = 0
		end
	end

	-- starting logic
	if apu_starting then
		if counter > 3 and counter < 6 then
			set(apu_switch, 2)
			set(apu_cc, 20)
		elseif counter > 6 and counter < 20 then
			set(apu_switch, 1)
		elseif counter > 20 and start_mode == 1 then
			set(apu_switch, 1)
			apu_starting = false
			set(apu_cc, 0)
		elseif counter > 20 then -- stop APU, if it in cold rotate mode
			set(apu_switch, 0)
			apu_starting = false
			set(apu_cc, 0)			
		end
	else
		set(apu_cc, 0)
	end

	--if counter > 18 and ai9n1 > 50 then set(apu_cc, 30) end -- starter will work for cold rotate too
	
	-- stoping logic
	if stop_bt or start_mode == 0 or start_sw == 0 or apu_fuel == 0 or ext then
		apu_starting = false
		counter = counter + 50
		apu_burn_fuel = 0
		set(apu_switch, 0)
	end

	-- calculte temperature of APU
	local N1 = ai9n1 * apu_burn_fuel * (1 + spd * 0.00035 + get(msl_alt) * 0.00001)
	local term_need = N1 * 6.5 * (1 + get(msl_alt) * 0.00002) + get(thermo) + work_counter * 0.15
	term = term + (term_need - term_last) * passed * 0.5
	term_last = term
	set(apu_egt, term)
	termo_angle = term * 250 / 900 - 120
	-- set limits
	if termo_angle < -120 then termo_angle = -120
	elseif termo_angle > 120 then termo_angle = 120 end
	
	local ai9_fire = term > 800 and not ext
	fire_counter = fire_counter + passed
	if ai9_fire then fire_counter = 0 end
	
	if ai9_fire then set(apu_on_fire, 1) else set(apu_on_fire, 0) end
	
	-- calculate starter ability
	if N1 > 97 and apu_burn_fuel == 1 then 
		if get(APU_press) < 6 then set(apu_can_start, 1) 
		else set(apu_can_start, 0) end
		work_counter = work_counter + passed
	else 
		set(apu_can_start, 0) 
		work_counter = work_counter - passed * 3
	end

	if work_counter > 5000 then work_counter = 1000
	elseif work_counter < 0 then work_counter = 0 end
	
	-- set lamps
	local test_lamp = get(but_test_lamp) == 1
	if power then
		normal_n1_lit = N1 > 90 and N1 < 110 or test_lamp
		normal_oil_lit = N1 > 95 or test_lamp
		high_n1_lit = N1 >= 110 or test_lamp
		fire_lit = fire_counter < 15 or test_lamp
		start_lit = apu_starting or test_lamp
	else
		start_lit = false
		normal_n1_lit = false
		normal_oil_lit = false
		high_n1_lit = false
		fire_lit = false	
	end
	

end

local switcher_pushed = false
components = {
	
	-- white needle
       needle {
        position = { 806, 1932, 110, 110 },
        image = get(needles_5),
        angle = function()
			return termo_angle
        end
    },
	
	-- cover
	texture {
		position = { 837, 1962, 50, 50 },
		image = get(black_cap),
	},
	
	-----------
	-- lamps --
	-----------
	-- APU starting
	textureLit {
		position = { 1233, 797, 60, 25},
		image = get(start_led),
		visible = function()
			return start_lit
		end
	},
	
	-- normal rpm
	textureLit {
		position = { 1378, 759, 60, 25},
		image = get(norm_n1_led),
		visible = function()
			return normal_n1_lit
		end
	},	
	
	-- normal oil pressure
	textureLit {
		position = { 1450, 798, 60, 25},
		image = get(norm_oil_led),
		visible = function()
			return normal_oil_lit
		end
	},		
	
	-- fire on AI9
	textureLit {
		position = { 1378, 798, 60, 25},
		image = get(fire_led),
		visible = function()
			return fire_lit
		end
	},	
	
	-- high rpm
	textureLit {
		position = { 1306, 759, 60, 25},
		image = get(high_rpm_led),
		visible = function()
			return high_n1_lit
		end
	},		
	
	-------------------------
	-- switchers and buttons
	-------------------------
	-- starter switcher
    switch {
        position = {721, 688, 19, 19},
        state = function()
            return get(starter_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(starter_sw) ~= 0 then
					set(starter_sw, 0)
				else
					set(starter_sw, 1)
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
        position = {794, 698, 7, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if get(starter_mode) ~= 1 then playSample(switch_sound, 0) end
			set(starter_mode, 1)
			return true
		end,
    },	

    -- 2
    clickable {
        position = {794, 688, 7, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if get(starter_mode) ~= 2 then playSample(switch_sound, 0) end
			set(starter_mode, 2)
			return true
		end,
    },	

    -- 3
    clickable {
        position = {781, 693, 7, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if get(starter_mode) ~= 3 then playSample(switch_sound, 0) end
			set(starter_mode, 3)
			return true
		end,
    },

    -- 0
    clickable {
        position = {789, 693, 4, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if get(starter_mode) ~= 0 then playSample(switch_sound, 0) end
			set(starter_mode, 0)
			return true
		end,
    },

	-- start button
    clickable {
        position = {1042, 649, 18, 18},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if not button_pressed then playSample(button_sound, 0) end
			button_pressed = true
			set(start_button, 1)
			return true
		end,
		onMouseUp = function()
			playSample(button_sound, 0)
			button_pressed = false
			set(start_button, 0)
			return true		
		end
    },	

	-- stop button
    clickable {
        position = {1022, 649, 18, 18},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if not button_pressed then playSample(button_sound, 0) end
			button_pressed = true
			set(stop_button, 1)
			return true
		end,
		onMouseUp = function()
			playSample(button_sound, 0)
			button_pressed = false
			set(stop_button, 0)
			return true		
		end
    },
	
}

