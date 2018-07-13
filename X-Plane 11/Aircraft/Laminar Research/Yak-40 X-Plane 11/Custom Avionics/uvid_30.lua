size = { 200, 200 }

-- initialize component property table
--defineProperty("altitude", globalPropertyf("sim/cockpit2/gauges/indicators/altitude_ft_copilot"))
-- pressure value
defineProperty("pressure", globalPropertyf("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot"))
-- barometric altitude
defineProperty("msl_alt", globalPropertyf("sim/flightmodel/position/elevation"))  -- barometric alt. maybe in feet, maybe in meters.
defineProperty("baro_press", globalPropertyf("sim/weather/barometer_sealevel_inhg"))  -- pressire at sea level in.Hg


-- meters needle image
defineProperty("longNeedleImage", loadImage("needles.png", 105, 74, 16, 171))

defineProperty("black_img", loadImage("needles.png", 280, 40, 10, 10))
defineProperty("white_img", loadImage("needles.png", 210, 43, 10, 5))

-- electric
defineProperty("uvid_30_cc", globalPropertyf("sim/custom/xap/gauges/uvid_30_cc")) -- gauge current consumption
defineProperty("uvid_30_sw", globalPropertyf("sim/custom/xap/gauges/uvid_30_sw")) -- gauge switcher ON/OF
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("inv_PO1500_radio", globalPropertyi("sim/custom/xap/power/inv_PO1500_radio")) -- inverter for 115v bus

-- failures
defineProperty("failure", globalPropertyi("sim/operation/failures/rel_ss_alt"))
defineProperty("static_fail", globalPropertyi("sim/operation/failures/rel_static"))  -- static fail

-- digits images
defineProperty("digitsImage", loadImage("white_digit_strip.png", 0, 0, 16, 196))
defineProperty("digitsImageZeros", loadImage("white_digit_zeros_strip.png", 0, 0, 16, 196))
-- red led image
defineProperty("red_led", loadImage("leds.png", 110, 0, 10, 10)) 


defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames

local time_counter = 0
local not_loaded = true




-- post frame caclulations
local alt = get(msl_alt) * 0.3048
local meters_angle = alt * 0.001 * 360.0

local red_led_vis = false
local pressure_num = get(pressure) * 25.3970886

local angle_actual = meters_angle
local last_angle = meters_angle
local msl = get(msl_alt) * 3.28083

function update()

	local power_27 = 0
	local power_115 = 0
	local switcher = get(uvid_30_sw)
	local fail = get(failure)
	local block = get(static_fail)
	local passed = get(frame_time)
	-- power logic
	if get(DC_27_volt) > 21 then power_27 = 1 else power_27 = 0 end
	if get(AC_115_volt) > 110 and get(inv_PO1500_radio) == 1 then power_115 = 1 else power_115 = 0 end
	-- gauge logic
	-- calculate barometric altitude in feet. use real and setted pressure

	if block < 6 then msl = get(msl_alt) * 3.28083
	else msl = msl + (get(msl_alt) * 3.28083 - msl) * passed * 0.001 end
	
	local real_alt = msl + (get(pressure) - get(baro_press)) * 1000  -- calculate barometric altitude in feet
	
	if power_27 * power_115 * switcher > 0 and fail < 6 then  -- altitude in meters. works only when power exist
		alt = real_alt * 0.3048 
		set(uvid_30_cc, 1)
	else 
		set(uvid_30_cc, 0)
	end 
	-- limit altitude
	if alt > 30000 then alt = 30000 end
	
	-- calculate angle for needle
	meters_angle = alt * 0.001 * 360.0

	angle_actual = last_angle + (meters_angle - last_angle) * passed * 4

	last_angle = angle_actual
	
	-- led logic
	if power_27 == 1 then
		if switcher == 1 and (power_115 == 0 or fail == 6) then
		red_led_vis = true
		else red_led_vis = false end
	else red_led_vis = false end
	
	pressure_num = get(pressure) * 25.3970886
	
end


-- altimeter consists of several components
components = {
	-- positioning gauge
	--[[rectangle {
	position = {99, 99, 2, 2},
		color = {1, 0, 0, 1},
	},	--]]

	-- pressure in millimeters of mercury
	digitstape {
        position = { 70, 30, 60, 22};
        image = digitsImage;
        digits = 3;
        
        value = function() 
            return pressure_num; 
        end;
    }; 

	-- altitude in digits in tens of meters
	digitstape {
        position = { 44, 110, 115, 24};
        image = digitsImage;
        digits = 4;
		allowNonRound = false;
		showLeadingZeros = true;
		showSign = false;
        value = function() 
            return alt / 10
        end;
    }; 
	
	digitstape {
        position = { 130, 110, 28, 24};
        image = digitsImageZeros;
        digits = 1;
		allowNonRound = false;
		showLeadingZeros = true;
		showSign = false;
        value = function() 
            return alt / 10
        end;
    }; 
	
	-- first zero not shows
	texture {
		position = {47, 110, 23, 24},
		image = get(black_img),
		visible = function()
			return alt < 10000
		end,
	},
	
	-- sign below zero 
	texture {
		position = {52, 119, 12, 5},
		image = get(white_img),
		visible = function()
			return alt < 0
		end,
	},
	
    -- hundreds meters needle
   needle {
        position = { 10, 10, 180, 180 },
        image = get(longNeedleImage),
        angle = function() 
			return angle_actual
        end,
    },
	
    -- pressure rotary
    rotary {
        -- image = rotaryImage;
        value = pressure;
        step = 1 / 25.3970886;
        position = { 173, 0, 28, 30 };

        -- round inches hg to millimeters hg
        adjuster = function(v)
            local a = math.floor((v * 25.3970886) + 0.5) / 25.3970886
			if a < 20.4747 then a = 20.4747
			elseif a > 31.7359 then a = 31.7359 end
			return a
        end;
    };
--[[	
	-- red fail led
	textureLit{
		position = {166, 2, 32, 32},
		image = get(red_led),
		visible = function()
			return red_led_vis
		end
	
	},
--]]	   
}

