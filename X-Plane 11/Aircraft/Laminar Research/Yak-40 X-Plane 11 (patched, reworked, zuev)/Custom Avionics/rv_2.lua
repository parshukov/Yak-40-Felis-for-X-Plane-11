-- UV-3M radio altimeter

size = { 200, 200 }

-- radio altitude
defineProperty("altitude", globalPropertyf("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot"))  -- altitude, measured by gauge
defineProperty("dh_set", globalPropertyf("sim/cockpit2/gauges/actuators/radio_altimeter_bug_ft_pilot"))  -- decision height, set by pilot
defineProperty("roll", globalPropertyf("sim/flightmodel/position/phi"))  -- position of acf

-- needle image
defineProperty("needleImage", loadImage("needles.png", 86, 72, 18, 173))
defineProperty("yellow_needleImage", loadImage("needles.png", 122, 63, 23, 193))

defineProperty("yellow_led", loadImage("leds.png", 100, 0, 10, 10)) -- red led image
defineProperty("black_cap", loadImage("covers.png", 0, 55, 56, 56)) -- black cap image
defineProperty("black_cap2", loadImage("covers.png", 354, 58, 54, 50)) -- black cap image
defineProperty("red_flag", loadImage("needles.png", 499, 0, 12, 8))

-- electrical
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("rv_sw", globalPropertyi("sim/custom/xap/gauges/rv_2_sw")) 
defineProperty("rv2_cc", globalPropertyf("sim/custom/xap/gauges/rv_2_cc"))  -- rv work
defineProperty("inv_PO1500_radio", globalPropertyi("sim/custom/xap/power/inv_PO1500_radio")) -- inverter for 115v bus

-- time
defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames
defineProperty("flight_time", globalPropertyf("sim/time/total_running_time_sec")) -- sim time

-- result
defineProperty("radioalt", globalPropertyf("sim/custom/xap/gauges/radioalt"))



-- post frame calculations

local alt_angle = 0
local dh_angle = 0
local red_led_vis = true  -- red flag that indicates that gauge is fail or OFF
local dh_led_vis = false
local switch_last = get(rv_sw)
local timer_started = false
local start_time = get(flight_time)
local passed = 0
local dh_counter = 0
local test = false

local angle = 0
local last_angle = 0

function update()
	passed = get(frame_time)
if  passed > 0 then

	-- power logic
	local power_27 = 0
	local power_115 = 0
	if get(DC_27_volt) > 21 then power_27 = 1 else power_27 = 0 end
	if get(AC_115_volt) > 110 and get(inv_PO1500_radio) == 1 then power_115 = 1 else power_115 = 0 end

	-- dh setting bug angle
	local dh = get(dh_set) * 0.3048  -- get altitude in meters
	if 0 > dh then dh_angle = 0  -- altimeter has different ranges on nonlinear scale
	elseif 20 > dh then dh_angle = dh / 20 * 30
	elseif 100 > dh then dh_angle = (dh - 20) / 80 * 130 + 30
	elseif 800 > dh then dh_angle = (dh - 100) / 700 * 180 + 160
	else dh_angle = 340
	end
	
	
	-- logic of moving needle
	if power_27 * power_115 * get(rv_sw) > 0 then
		set(rv2_cc, 1)
		
		local a = get(altitude) * 0.3048  -- get altitude in meters
		if math.abs(get(roll)) > 60 then a = 1000 end -- limit working roll range
		if not timer_started then 
			timer_started = true
			start_time = get(flight_time)
		end
		
		if get(flight_time) - start_time < 5 and dh_angle - angle > 2 then a = get(dh_set) * 0.3048 
		else start_time = start_time - 10
		end
		
		if test then a = 13 end
		
		if 0 > a then alt_angle = 0  -- altimeter has different ranges on nonlinear scale
		elseif 20 > a then alt_angle = a / 20 * 30
		elseif 100 > a then alt_angle = (a - 20) / 80 * 130 + 30
		elseif 800 > a then alt_angle = (a - 100) / 700 * 180 + 160
		else alt_angle = 340
		end
		
		-- needle smooth move
		angle = last_angle + (alt_angle - last_angle) * passed * 3
		
		-- DH light
		if angle < dh_angle then dh_counter = dh_counter + passed 
		else dh_counter = -0.1 end
		dh_led_vis = dh_counter > 0 and dh_counter < 5
		--dh_led_vis = true else dh_led_vis = false end
		-- red flag visibility
		red_led_vis = false
		-- set radioalt for SSOS
		set(radioalt, a)
		
	else
		dh_counter = -0.1
		red_led_vis = true
		dh_led_vis = false
		timer_started = false
		set(radioalt, 0)
		set(rv2_cc, 0)
	end
	
end
	-- last variables

	last_angle = angle
	
end


components = {
	-- red flag
	texture {
		position = {85, 140, 30, 15},
		image = get(red_flag),
		visible = function()
			return red_led_vis
		end,	
		},

    -- meters needle
    needle {
        position = { 10, 10, 180, 180 },
        image = needleImage,
        angle = function() 
			return angle
        end
    },
	
    -- DH needle
    needle {
        position = { 3, 3, 194, 194 },
        image = yellow_needleImage,
        angle = function() 
			return dh_angle
        end
    },
	
	-- black cap
	texture{
	    position = { 74, 72, 56, 56 },
        image = get(black_cap),
	},
	
	-- black cap2
	texture{
	    position = { 30, 153, 75, 56 },
        image = get(black_cap2),
	},

	-- yellow led
	textureLit{
		position = {171, 8, 25, 25},
		image = get(yellow_led),
		visible = function()
			return dh_led_vis
		end
	},
	
    -- dh rotary
    rotary {
        -- image = rotaryImage;
        value = dh_set;
        step = 10 * 3.2808399; -- 10 meters in feet
        position = { 2, 2, 34, 32 };

        -- round inches hg to millimeters hg
        adjuster = function(v)
            v = math.floor((v * 10 * 3.2808399) + 0.5) / (10 * 3.2808399)
			if v > 700 * 3.2808399 then v = 700 * 3.2808399 end
			if v < 0 then v = 0 end
			return v
        end;
    };
	
	-- test button
    clickable {
        position = {50, 10, 30, 30},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			test = true
			return true
		end,
		onMouseUp  = function() 
			test = false
			return true
		end,
    },
	
}

