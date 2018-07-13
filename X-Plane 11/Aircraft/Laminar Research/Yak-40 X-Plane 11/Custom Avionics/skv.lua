-- this is air conditioning system
size = {2048, 2048}


defineProperty("thermo", globalPropertyf("sim/cockpit2/temperature/outside_air_temp_degc")) -- outside temperature
-- power
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("inv_PO1500_steklo", globalPropertyi("sim/custom/xap/power/inv_PO1500_steklo")) -- inverter for 115v bus
defineProperty("skv_cc", globalPropertyf("sim/custom/xap/skv/skv_cc")) -- cc

-- switcher
defineProperty("bleed_ON", globalPropertyi("sim/custom/xap/srd/bleed_ON")) -- wirtual switcher of air bleed
defineProperty("salon_temp_sw", globalPropertyi("sim/custom/xap/skv/salon_temp_sw")) -- salon temperature switcher
defineProperty("system_temp_sw", globalPropertyi("sim/custom/xap/skv/system_temp_sw")) -- thu temperature switcher
--defineProperty("air_bleed_sw", globalPropertyi("sim/custom/xap/skv/air_bleed_sw")) -- air push switcher
defineProperty("skv_mode_sw", globalPropertyi("sim/custom/xap/skv/skv_mode_sw")) -- skv mode switcher
defineProperty("cabin_air_sw", globalPropertyi("sim/custom/xap/skv/cabin_air_sw")) -- cabin more/less switcher
defineProperty("dubler_sw", globalPropertyi("sim/custom/xap/srd/dubler_sw")) 
defineProperty("salon_temp_rot", globalPropertyf("sim/custom/xap/skv/salon_temp_rot")) -- rotary for set salon temperature
defineProperty("thu_temp_rot", globalPropertyf("sim/custom/xap/skv/thu_temp_rot")) -- rotary for set cooler temperature

defineProperty("AZS_skv_cool_sw", globalPropertyi("sim/custom/xap/azs/AZS_skv_cool_sw")) -- AZS cooling air
defineProperty("AZS_skv_heat_sw", globalPropertyi("sim/custom/xap/azs/AZS_skv_heat_sw")) -- AZS heating air
defineProperty("AZS_skv_THU_sw", globalPropertyi("sim/custom/xap/azs/AZS_skv_THU_sw")) -- AZS turbo cooling air

-- result
defineProperty("salon_temperature", globalPropertyf("sim/custom/xap/skv/salon_temp")) -- result temperature in salon

defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames
defineProperty("but_test_lamp", globalPropertyi("sim/custom/xap/buttons/but_test_lamp")) -- test lamps button

defineProperty("needleImage", loadImage("needles.png", 86, 73, 18, 173))

defineProperty("yellow_led", loadImage("leds.png", 60, 0, 20, 20)) 
defineProperty("green_led", loadImage("leds.png", 20, 0, 20, 20)) 
defineProperty("red_led", loadImage("leds.png", 40, 0, 20, 20)) 
defineProperty("black_cap", loadImage("covers.png", 0, 56, 52, 52))
defineProperty("black_cap2", loadImage("covers.png", 418, 68, 78, 52))

local switch_sound = loadSample('Custom Sounds/metal_switch.wav')
local rotary_sound = loadSample('Custom Sounds/rot_click.wav')

local salon_temp = 15
local thu_temp = 15
local thu_lamp = false
local mode = 1

local cabin_temp_angle = 0
local pipe_temp_angle = -62
local pipe_temp_last = -62 

local air_angle = 0
local air_angle_last = 0

function update()

	
	local power = get(DC_27_volt) > 21 and get(AC_115_volt) > 110 and get(inv_PO1500_steklo) == 1
	local passed = get(frame_time)
	local test_lamp = get(but_test_lamp) == 1
	local inn_temp = get(salon_temperature)
	local out_temp = get(thermo)
	
	-- calculate salon and THU temperatures
	local salon_sw = get(salon_temp_sw) -- 0 = off, 1 = auto, 2 = less, 3 = more
	local thu_sw = get(system_temp_sw) -- 0 = off, 1 = auto, 2 = less, 3 = more
	
	if salon_sw == 1 then
		salon_temp = get(salon_temp_rot)
	elseif salon_sw == 2 and salon_temp > 0 then
		salon_temp = salon_temp - passed
	elseif salon_sw == 3 and salon_temp < 30 then
		salon_temp = salon_temp + passed
	end
	
	if thu_sw == 1 then
		thu_temp = get(thu_temp_rot)
	elseif thu_sw == 2 and thu_temp > 0 then
		thu_temp = thu_temp - passed
	elseif thu_sw == 3 and thu_temp < 30 then
		thu_temp = thu_temp + passed
	end
	
	if thu_temp >= inn_temp - 2 then 
		thu_temp = inn_temp 
		thu_lamp = test_lamp and power
	else
		thu_lamp = power and get(AZS_skv_cool_sw) == 1
	end	
	
	-- check if cooling and/or heating air are working
	
	if get(AZS_skv_THU_sw) == 0 and thu_temp < inn_temp then thu_temp = inn_temp end
	if get(AZS_skv_cool_sw) == 0 then
		if salon_temp < inn_temp then salon_temp = inn_temp end
	end
	if get(AZS_skv_heat_sw) == 0 then
		if thu_temp > inn_temp then thu_temp = inn_temp end
		if salon_temp > inn_temp then salon_temp = inn_temp end
	end
	
	
	if not power then
		thu_temp = inn_temp
		salon_temp = inn_temp
	end
	
	if power then mode = get(skv_mode_sw) + 1 end
	
	if get(dubler_sw) == 1 then mode = mode + 0.3 end
	
	-- temperature in salon will slowly change to outer
	local inn_out_diff = out_temp - inn_temp
	inn_temp = inn_temp + inn_out_diff * passed * 0.002
	
	-- temperature will slowly change to temp in system
	local sys_diff = 0
	if power then sys_diff = (salon_temp + thu_temp) * 0.5 - inn_temp end
	inn_temp = inn_temp + sys_diff * passed * 0.01 * mode * get(bleed_ON)
	
	
	-- set results
	set(salon_temperature, inn_temp)
	
	if power then cabin_temp_angle = inn_temp * 50/30
	else cabin_temp_angle = -110 end
	
	local pipe_temp_need = 0
	if power then pipe_temp_need = (salon_temp + thu_temp) * 0.5 * 30 / 50 - 30
	else pipe_temp_need = -63 end

	pipe_temp_angle = pipe_temp_angle + (pipe_temp_need - pipe_temp_last) * passed * 0.5
	pipe_temp_last = pipe_temp_angle
	
	local air_need = mode * get(bleed_ON) * 3.5 * 320 / 10 - 10
	air_angle = air_angle + (air_need - air_angle_last) * passed * 0.5
	air_angle_last = air_angle
	if air_angle < 0 then air_angle = 0 end
	
	-- calc power
	local CC = 0
	if power then CC = get(bleed_ON) * get(AZS_skv_cool_sw) end
	if thu_lamp and not test_lamp then CC = CC + 2 end
	
	set(skv_cc, CC)
	
	
end

local switcher_pushed = false

components = {
	
	-- gauges
	
	-- cabin temp
	needle {
        position = { 1607, 1214, 105, 105 },
        image = get(needleImage),
        angle = function() 
			return cabin_temp_angle
        end
    }, 
	
	-- pipe temp
	needle {
        position = { 1482, 1196, 115, 115 },
        image = get(needleImage),
        angle = function() 
			return pipe_temp_angle
        end
    }, 
	
	-- cover
	texture {
		position = { 1637, 1240, 50, 50 },
		image = get(black_cap),
	},
	-- cover
	texture {
		position = { 1490, 1200, 100, 70 },
		image = get(black_cap2),
	},
	
	-- air consumption 
	needle {
        position = { 410, 1457, 180, 180 },
        image = get(needleImage),
        angle = function() 
			return air_angle
        end
    },	
	
	
	
	-- THU lamp
	textureLit {
		position = {823, 761, 24, 24},
		image = get(green_led),
		visible = function()
			return thu_lamp
		end
	},	
	
	
	
	
	
	
	-- salon temp swticher
	-- switch up
    clickable {
        position = {902, 722, 18, 6 },  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed and get(salon_temp_sw) ~= 1 then playSample(switch_sound, 0) end
			switcher_pushed = true
			set(salon_temp_sw, 1)
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			--set(salon_temp_sw, 0)
			return true		
		end
    },	
	-- switch center
    clickable {
        position = {902, 716, 18, 6 },  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed and get(salon_temp_sw) ~= 0 then playSample(switch_sound, 0) end
			switcher_pushed = true
			set(salon_temp_sw, 0)
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			--set(salon_temp_sw, 0)
			return true		
		end
    },
	-- switch right
    clickable {
        position = {912, 709, 8, 6 },  -- search and set right
        
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
			set(salon_temp_sw, 2)
			return true
		end,
		onMouseUp = function()
			playSample(switch_sound, 0)
			switcher_pushed = false
			set(salon_temp_sw, 0)
			return true		
		end
    },
	-- switch left
    clickable {
        position = {902, 709, 8, 6 },  -- search and set right
        
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
			set(salon_temp_sw, 3)
			return true
		end,
		onMouseUp = function()
			playSample(switch_sound, 0)
			switcher_pushed = false
			set(salon_temp_sw, 0)
			return true		
		end
    },

	-- system temp swticher
	-- switch up
    clickable {
        position = {922, 722, 18, 6 },  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed and get(system_temp_sw) ~= 1 then playSample(switch_sound, 0) end
			switcher_pushed = true
			set(system_temp_sw, 1)
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			--set(system_temp_sw, 0)
			return true		
		end
    },	
	-- switch center
    clickable {
        position = {922, 716, 18, 6 },  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed and get(system_temp_sw) ~= 0 then playSample(switch_sound, 0) end
			switcher_pushed = true
			set(system_temp_sw, 0)
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			--set(system_temp_sw, 0)
			return true		
		end
    },
	-- switch right
    clickable {
        position = {932, 709, 8, 6 },  -- search and set right
        
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
			set(system_temp_sw, 2)
			return true
		end,
		onMouseUp = function()
			playSample(switch_sound, 0)
			switcher_pushed = false
			set(system_temp_sw, 0)
			return true		
		end
    },
	-- switch left
    clickable {
        position = {922, 709, 8, 6 },  -- search and set right
        
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
			set(system_temp_sw, 3)
			return true
		end,
		onMouseUp = function()
			playSample(switch_sound, 0)
			switcher_pushed = false
			set(system_temp_sw, 0)
			return true		
		end
    },

    -- mode switcher
    switch {
        position = {822, 689, 18, 18},
        state = function()
            return get(skv_mode_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(skv_mode_sw) ~= 0 then
					set(skv_mode_sw, 0)
				else
					set(skv_mode_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- salon temp rotary
    rotary {
        -- image = rotaryImage;
        value = salon_temp_rot;
        step = 1;
        position = { 1961, 1342, 87, 87 };

        -- set limits
        adjuster = function(a)
			if a >= 0 and a <= 30 then playSample(rotary_sound, 0) end
			if a < 0 then a = 0
			elseif a > 30 then a = 30 end
		return a
        end;
    };	
	
	-- salon temp rotary
    rotary {
        -- image = rotaryImage;
        value = thu_temp_rot;
        step = 1;
        position = { 1961, 1248, 87, 87 };

        -- set limits
        adjuster = function(a)
			if a >= 0 and a <= 30 then playSample(rotary_sound, 0) end
			if a < 0 then a = 0
			elseif a > 30 then a = 30 end
		return a
        end;
    };		

	-- cabin air sw
	-- switch up
    clickable {
        position = {842, 698, 18, 9},  -- search and set right
        
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
			set(cabin_air_sw, 1)
			return true
		end,
		onMouseUp = function()
			playSample(switch_sound, 0)
			switcher_pushed = false
			set(cabin_air_sw, 0)
			return true		
		end
    },
	
	-- switch down
    clickable {
        position = {842, 689, 18, 9},  -- search and set right
        
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
			set(cabin_air_sw, -1)
			return true
		end,
		onMouseUp = function()
			playSample(switch_sound, 0)
			switcher_pushed = false
			set(cabin_air_sw, 0)
			return true		
		end
    },	
	
	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}

