-- this is simple logic of pressurisation equipment
size = {2048, 2048}

-- sim DataRefs
defineProperty("msl_alt", globalPropertyf("sim/flightmodel/position/elevation"))  -- barometric alt. maybe in feet, maybe in meters.
defineProperty("baro_press", globalPropertyf("sim/weather/barometer_sealevel_inhg"))  -- pressure at sea level in.Hg

defineProperty("eng_rpm1", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[1]"))   
defineProperty("eng_rpm2", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[0]"))
defineProperty("eng_rpm3", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[2]"))

defineProperty("mode", globalPropertyi("sim/cockpit2/pressurization/actuators/bleed_air_mode")) 
defineProperty("dump", globalPropertyi("sim/cockpit2/pressurization/actuators/dump_all_on")) 

defineProperty("sim_cab_alt", globalPropertyf("sim/cockpit2/pressurization/actuators/cabin_altitude_ft"))   
defineProperty("sim_cab_vvi", globalPropertyf("sim/cockpit2/pressurization/actuators/cabin_vvi_fpm"))

defineProperty("actual_cabin_alt", globalPropertyf("sim/cockpit2/pressurization/indicators/cabin_altitude_ft"))
defineProperty("cabin_press_diff", globalPropertyf("sim/cockpit2/pressurization/indicators/pressure_diffential_psi"))
defineProperty("real_vvi", globalPropertyf("sim/flightmodel/position/vh_ind_fpm2")) --feet per sec
defineProperty("apu_can_start", globalPropertyi("sim/custom/xap/apu/apu_can_start")) -- APU can start other engines

defineProperty("acf_has_press_contr", globalPropertyf("sim/aircraft/view/acf_has_press_controls")) 

-- custom
defineProperty("bleed_sw", globalPropertyi("sim/custom/xap/srd/bleed_sw")) -- switcher on panel for emerg ON
defineProperty("bleed_cap", globalPropertyi("sim/custom/xap/srd/bleed_cap")) -- switcher cap on panel
defineProperty("bleed_ON", globalPropertyi("sim/custom/xap/srd/bleed_ON")) -- wirtual switcher of air bleed
defineProperty("system_sw", globalPropertyi("sim/custom/xap/srd/system_sw")) -- switcher on panel for normal ON
defineProperty("dubler_sw", globalPropertyi("sim/custom/xap/srd/dubler_sw")) 
defineProperty("dubler_cap", globalPropertyi("sim/custom/xap/srd/dubler_cap")) 
defineProperty("dump_cap", globalPropertyi("sim/custom/xap/srd/dump_cap")) 
defineProperty("dump_sw", globalPropertyi("sim/custom/xap/srd/dump_sw")) 
defineProperty("left_door", globalPropertyi("sim/cockpit2/switches/custom_slider_on[4]"))-- left soor. 0 = close, 1 = open

defineProperty("srd_siren", globalPropertyi("sim/custom/xap/gauges/srd_siren")) -- SRD signal
defineProperty("srd_siren_sw", globalPropertyi("sim/custom/xap/gauges/srd_siren_sw")) -- SRD signal switch
defineProperty("starter_work_lit", globalPropertyi("sim/custom/xap/start/starter_work_lit")) -- starter lamp

-- settings on SRD panel
defineProperty("press_diff_set", globalPropertyf("sim/custom/xap/srd/press_diff_set")) 
defineProperty("start_compress_set", globalPropertyf("sim/custom/xap/srd/start_compress_set")) 
defineProperty("compress_spd_set", globalPropertyf("sim/custom/xap/srd/compress_spd_set")) 

defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames
defineProperty("but_test_lamp", globalPropertyi("sim/custom/xap/buttons/but_test_lamp")) -- test lamps button
-- power
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt

-- failures
defineProperty("rapid_depress", globalPropertyi("sim/operation/failures/rel_depres_fast")) 


-- images
defineProperty("needles_5", loadImage("needles.png", 16, 111, 16, 98))
defineProperty("rot_scale", loadImage("srd.png", 211, 0, 200, 200))
defineProperty("scale", loadImage("srd.png", 0, 0, 200, 200))

defineProperty("yellow_led", loadImage("leds.png", 60, 0, 20, 20)) 
defineProperty("green_led", loadImage("leds.png", 20, 0, 20, 20)) 
defineProperty("red_led", loadImage("leds.png", 40, 0, 20, 20)) 

defineProperty("overpress_led", loadImage("lamps.png", 0, 100, 60, 25)) 
defineProperty("opendoor_led", loadImage("lamps.png", 60, 150, 60, 25)) 
defineProperty("depress_led", loadImage("lamps.png", 0, 225, 60, 25)) 

defineProperty("needleImage", loadImage("needles.png", 312, 74, 16, 170))


-- doors and windows may depressurise the plane
defineProperty("hole1", globalPropertyf("sim/flightmodel2/misc/custom_slider_ratio[1]"))  
defineProperty("hole2", globalPropertyf("sim/flightmodel2/misc/custom_slider_ratio[2]"))  
defineProperty("hole3", globalPropertyf("sim/flightmodel2/misc/custom_slider_ratio[3]"))
defineProperty("hole4", globalPropertyf("sim/flightmodel2/misc/custom_slider_ratio[4]")) 

defineProperty("slider1", globalPropertyi("sim/cockpit2/switches/custom_slider_on[1]")) -- window 1
defineProperty("slider2", globalPropertyi("sim/cockpit2/switches/custom_slider_on[2]")) -- window 2


local switch_sound = loadSample('Custom Sounds/metal_switch.wav')
local rotary_sound = loadSample('Custom Sounds/rot_click.wav')
local cap_sound = loadSample('Custom Sounds/cap.wav')

local start_press_table = 
				  {{ 0, 50000},    -- bugs workaround
				  {  433, 4500 },    -- maximum alt
				  {  760, 0 },    -- standard pressure
  				  {  806, -560 },    -- minimum alt
          		  {  1000, -1000 }}   --  bugs workaround

--[[

local start_press_table = 
				  {{ 0, 50000},    -- bugs workaround
				  {  440, 4500 },    -- minimum pressure
  				  {  806, -500 },    -- minimum pressure
          		  {  1000, -1000 }}   --  bugs workaround


--]]

-- interpolate values using table as reference
local function interpolate(tbl, value)
    local lastActual = 0
    local lastReference = 0
    for _k, v in pairs(tbl) do
        if value == v[1] then
            return v[2]
        end
        if value < v[1] then
            local a = value - lastActual
            local m = v[2] - lastReference
            return lastReference + a / (v[1] - lastActual) * m
        end
        lastActual = v[1]
        lastReference = v[2]
    end
    return value - lastActual + lastReference
end

set(mode, 0)
set(acf_has_press_contr, 1)
local switcher_pushed = false
local need_cabin_alt = get(actual_cabin_alt) * 0.3048
local angle1 = 0
local counter = 0

local left_urvk_counter = 0

local spd_angle = 0
local start_press_angle = 0
local press_diff_angle = 0

local act_cab_alt_angle = 0
local act_press_angle = 0

local bleed_counter = 3

local air_dump_lit = false
local dubler_lit = false
local system_lit = false
local overpress_lit = false
local depress_lit = false
local doors_lit = false

local start_counter = 0
local notLoaded = true

local door_last = get(left_door)
local window_last1 = get(slider1)
local window_last2 = get(slider2)

function update()
	local passed = get(frame_time)

	start_counter = start_counter + passed	
	if start_counter > 0.3 and start_counter < 0.5 and notLoaded and get(eng_rpm1) < 10 and get(eng_rpm2) < 10 and get(eng_rpm3) < 10 then
		bleed_counter = 0
		set(srd_siren_sw, 0)
		notLoaded = false
	end	
	
	-- start data
	-- translate start of pressurisation from mmHg to minimum altitude
	local min_cabin_alt = interpolate(start_press_table, get(start_compress_set))

	-- translate setted pressurisation speed to m/s
	local press_spd = get(compress_spd_set) * 10
	
	-- calculate real airplane altitude above standard pressure isoline, m
	local real_alt = get(msl_alt) + (29.92 - get(baro_press)) * 304.800919279572547
	
	-- calculate pressure diff
	local real_press_diff = get(cabin_press_diff) * 0.07030696  -- pressure in kg/cm2
	
	-- calculate setted pressure diff, kg/cm2
	local press_diff = get(press_diff_set) -- maximum pressure diff in kg/cm2
	
	-- actual cabin alt, meter
	local act_cab_alt = get(actual_cabin_alt) * 0.3048
	
	-- calculatuins
	local dubler = get(dubler_sw)
	local vvi = math.abs(real_press_diff - press_diff) * 100
	
	-- power
	local power = 0 
	if get(DC_27_volt) > 1 then power = 1 end
	
	-- engines work
	local engines = 0
	if get(eng_rpm1) + get(eng_rpm2) + get(eng_rpm2) > 140 then engines = 1 end
	
	-- calculate system air bleed
	local switcher = get(bleed_sw) + get(system_sw)
	bleed_counter = bleed_counter + switcher * passed * power
	if bleed_counter > 3 then bleed_counter = 3
	elseif bleed_counter < 0 then bleed_counter = 0 end
	
	if bleed_counter > 2.5 then
		set(mode, 2)
		set(bleed_ON, engines)
	elseif bleed_counter < 0.5 then
		set(mode, 0)
		set(bleed_ON, 0)	
	end
	
	-- start issue
	if get(apu_can_start) == 1 then set(mode, 4) 
	elseif get(starter_work_lit) == 1 then set(mode, 2)
	end
	
	-- calculate cabin alt to hold it by system	
	if get(bleed_ON) > 0 then
		if dubler == 1 then min_cabin_alt = 0 end
		-- calculate new cabin altitude
		if real_alt <= min_cabin_alt then
			need_cabin_alt = min_cabin_alt
		elseif real_alt > min_cabin_alt and real_press_diff <= press_diff then
			if need_cabin_alt > min_cabin_alt then need_cabin_alt = need_cabin_alt - 20 * passed
			else need_cabin_alt = need_cabin_alt + 20 * passed
			end
		else
			need_cabin_alt = need_cabin_alt + 200 * passed
		end
		
		-- calculate vvi
		if vvi > press_spd then vvi = press_spd end
		vvi = vvi + 4 * dubler
		--if vvi > 4 then vvi = 4 end
	else
		need_cabin_alt = real_alt
		vvi = 2
	end
	
	local actual_alt = get(actual_cabin_alt) * 0.3048
	if math.abs(real_press_diff - press_diff) < 0.01 then need_cabin_alt = actual_alt end


	-- automatic dump pressure
	if real_press_diff > 0.44 then 
		need_cabin_alt = need_cabin_alt + 200 * passed
		vvi = 8
	end 

	-- manual pressure dump
	if get(dump_sw) == 1 and power == 1 then
		need_cabin_alt = real_alt
		vvi = 30
		set(dump, 1)
	else
		set(dump, 0)
	end
	
	-- some door is open
	local opendoor = get(hole1) > 0.05 or get(hole2) > 0.05 or get(hole3) > 0.05 or get(hole4) > 0.05
	if opendoor then 
		need_cabin_alt = real_alt
		vvi = 1000
		set(dump, 1)
		set(rapid_depress, 6)
	else
		set(dump, 0)
		set(rapid_depress, 0)	
	end
	
	-- calculate angles for gauges
	spd_angle = (press_spd / 10 - 0.15) * 360 / 0.16
	start_press_angle = (get(start_compress_set) - 450) * 200 / 350 - 100
	press_diff_angle = press_diff * 240 / 0.6 - 120
	act_cab_alt_angle = act_cab_alt * 300 / 5000 - 150
	act_press_angle = -(real_press_diff + 0.1) * 313 / 0.9 - 17

	-- lamps
	local test_lamp = get(but_test_lamp) == 1
	if power == 1 then
		air_dump_lit = get(dump_sw) == 1 or test_lamp
		dubler_lit = dubler == 1 or test_lamp
		system_lit = get(bleed_ON) == 0 or test_lamp
		overpress_lit = real_press_diff > 0.46 or test_lamp
		depress_lit = act_cab_alt > 3500 or test_lamp
		doors_lit = opendoor or test_lamp
	else
		air_dump_lit = false
		dubler_lit = false
		system_lit = false
		overpress_lit = false
		doors_lit = false
		depress_lit = false
	end
	
	-- set results
	--if vvi ~= 0 then set(mode, 2) else set(mode, 0) end
	
	set(sim_cab_alt, need_cabin_alt * 3.28)
	set(sim_cab_vvi, vvi * 196.8)
	
	-- set sirene signal
	if (overpress_lit or depress_lit) and not test_lamp and get(srd_siren_sw) == 1 then set(srd_siren, 1) else set(srd_siren, 0) end
	
	-- do not let the door open, when cabin under pressure
	local door = get(left_door)
	if door ~= door_last and door == 1 and real_press_diff > 0.1 then set(left_door, 0) end
	door_last = door
	
	-- do not lef windows open, when cabin is under pressure
	local window1 = get(slider1)
	if window1 ~= window_last1 and window1 == 1 and real_press_diff > 0.1 then set(slider1, 0) end
	window_last1 = window1
	
	local window2 = get(slider2)
	if window2 ~= window_last2 and window2 == 1 and real_press_diff > 0.1 then set(slider2, 0) end
	window_last2 = window2
	


	
	
end

components = {
	
	-- dump lamp
	textureLit {
		position = {1123, 791, 24, 24},
		image = get(red_led),
		visible = function()
			return air_dump_lit
		end
	},
	
	-- dubler lamp
	textureLit {
		position = {1153, 791, 24, 24},
		image = get(yellow_led),
		visible = function()
			return dubler_lit
		end
	},	

	-- system lamp
	textureLit {
		position = {1183, 791, 24, 24},
		image = get(red_led),
		visible = function()
			return system_lit
		end
	},

	-- overpress lamp
	textureLit {
		position = {1599, 880, 60, 26},
		image = get(overpress_led),
		visible = function()
			return overpress_lit
		end
	},
	
	-- depress lamp
	textureLit {
		position = {1921, 880, 60, 26},
		image = get(depress_led),
		visible = function()
			return depress_lit
		end
	},
	
	-- opendoor lamp
	textureLit {
		position = {1959, 837, 60, 26},
		image = get(opendoor_led),
		visible = function()
			return doors_lit
		end
	},	
	-- scale for pressure speed set
	needle {
		position = {1599, 1448, 200, 200},
		image = get(rot_scale),
		angle = function()
			return spd_angle
		end
	},
	
	-- start of pressurisation scale set
	texture {
		position = {1601, 1449, 200, 200},
		image = get(scale),
	},
	
	-- start of pressurisation set
	needle {
		position = {1615, 1463, 170, 170},
		image = get(needleImage),
		angle = function()
			return start_press_angle
		end
	},

	-- pressure diff set
	needle {
		position = {1415, 1462, 170, 170},
		image = get(needleImage),
		angle = function()
			return press_diff_angle
		end
	},

	-- actual cabin press diff
	needle {
		position = {235, 1482, 130, 130},
		image = get(needles_5),
		angle = function()
			return act_press_angle
		end
	},
	
	-- actual cabin alt
	needle {
		position = {215, 1462, 170, 170},
		image = get(needleImage),
		angle = function()
			return act_cab_alt_angle
		end
	},

    -- srd_siren_sw
    switch {
        position = {862, 709, 18, 18 },
        state = function()
            return get(srd_siren_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(srd_siren_sw) ~= 0 then
					set(srd_siren_sw, 0)
				else
					set(srd_siren_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

    -- emerg system switcher cap
    switch {
        position = {1680, 540, 40, 100   },
        state = function()
            return get(bleed_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(bleed_cap) ~= 0 then
					set(bleed_cap, 0)
					set(bleed_sw, 0)
				else
					set(bleed_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },
	
	-- emerg system switch down
    clickable {
        position = {842, 709, 18, 9 },  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if get(bleed_cap) > 0 then
				if not switcher_pushed then playSample(switch_sound, 0) end
				switcher_pushed = true
				set(bleed_sw, -1)
			end
			return true
		end,
		onMouseUp = function()
			playSample(switch_sound, 0)
			switcher_pushed = false
			set(bleed_sw, 0)
			return true		
		end
    },
	-- emerg system switch up
    clickable {
        position = {842, 719, 18, 9 },  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if get(bleed_cap) > 0 then
				if not switcher_pushed then playSample(switch_sound, 0) end
				switcher_pushed = true
				set(bleed_sw, 1)
			end
			return true
		end,
		onMouseUp = function()
			playSample(switch_sound, 0)
			switcher_pushed = false
			set(bleed_sw, 0)
			return true		
		end
    },
	
    -- pressure dump switcher cap
    switch {
        position = {1640, 646, 40, 100  },
        state = function()
            return get(dump_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(dump_cap) ~= 0 then
					set(dump_cap, 0)
					if get(dump_sw) == 1 then playSample(switch_sound, 0) end
					set(dump_sw, 0)
				else
					set(dump_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
    -- pressure dump switcher
    switch {
        position = {802, 709, 18, 18  },
        state = function()
            return get(dump_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and get(dump_cap) == 1 then
				playSample(switch_sound, 0)
				if get(dump_sw) ~= 0 then
					set(dump_sw, 0)
				else
					set(dump_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },		

    -- dubler switcher cap
    switch {
        position = {1680, 646, 40, 100  },
        state = function()
            return get(dubler_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(dubler_cap) ~= 0 then
					set(dubler_cap, 0)
					if get(dubler_sw) == 1 then playSample(switch_sound, 0) end
					set(dubler_sw, 0)
				else
					set(dubler_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

    -- dubler switcher
    switch {
        position = {822, 709, 18, 18  },
        state = function()
            return get(dubler_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and get(dubler_cap) == 1 then
				playSample(switch_sound, 0)
				if get(dubler_sw) ~= 0 then
					set(dubler_sw, 0)
				else
					set(dubler_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- pressure diff set
    rotary {
        -- image = rotaryImage;
        value = press_diff_set;
        step = 0.01;
        position = { 1222, 689, 18, 18 };

        -- set limits
        adjuster = function(a)
			if a >= 0 and a <= 0.6 then playSample(rotary_sound, 0) end
			if a < 0 then a = 0
			elseif a > 0.6 then a = 0.6 end
		return a
        end;
    };

	-- start press set
    rotary {
        -- image = rotaryImage;
        value = start_compress_set;
        step = 5;
        position = { 1241, 689, 18, 18 };

        -- set limits
        adjuster = function(a)
			if a >= 430 and a <= 806 then playSample(rotary_sound, 0) end
			if a < 430 then a = 430
			elseif a > 806 then a = 806 end
		return a
        end;
    };

	-- press speed set
    rotary {
        -- image = rotaryImage;
        value = compress_spd_set;
        step = 0.005;
        position = { 1262, 689, 18, 18 };

        -- set limits
        adjuster = function(a)
			if a >= 0.15 and a <= 0.3 then playSample(rotary_sound, 0) end
			if a < 0.15 then a = 0.15
			elseif a > 0.3 then a = 0.3 end
		return a
        end;
    };	
	
	-- system switch down
    clickable {
        position = {882, 709, 18, 9 },  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed then playSample(switch_sound, 0) end
			switcher_pushed = true
			set(system_sw, -1)
			return true
		end,
		onMouseUp = function()
			playSample(switch_sound, 0)
			switcher_pushed = false
			set(system_sw, 0)
			return true		
		end
    },	
	-- system switch up
    clickable {
        position = {882, 719, 18, 9 },  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed then playSample(switch_sound, 0) end
			switcher_pushed = true
			set(system_sw, 1)
			return true
		end,
		onMouseUp = function()
			playSample(switch_sound, 0)
			switcher_pushed = false
			set(system_sw, 0)
			return true		
		end
    },
	
}


