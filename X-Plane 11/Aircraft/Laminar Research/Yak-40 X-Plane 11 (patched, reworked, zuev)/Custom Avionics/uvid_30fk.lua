size = { 200, 200 }

-- pressure value
defineProperty("pressure", globalPropertyf("sim/custom/xap/gauges/uvid30fk_press"))
-- barometric altitude
defineProperty("msl_alt", globalPropertyf("sim/flightmodel/position/elevation"))  -- barometric alt. maybe in feet, maybe in meters.
defineProperty("baro_press", globalPropertyf("sim/weather/barometer_sealevel_inhg"))  -- pressire at sea level in.Hg


-- meters needle image
defineProperty("longNeedleImage", loadImage("needles.png", 105, 74, 16, 171))

-- electric
defineProperty("uvid_30fk_cc", globalPropertyf("sim/custom/xap/gauges/uvid_30fk_cc")) -- gauge current consumption
defineProperty("uvid_30fk_sw", globalPropertyf("sim/custom/xap/gauges/uvid_30fk_sw")) -- gauge switcher ON/OF
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("inv_PO1500_radio", globalPropertyi("sim/custom/xap/power/inv_PO1500_radio")) -- inverter for 115v bus

-- failures
defineProperty("failure", globalPropertyi("sim/operation/failures/rel_cop_alt"))
defineProperty("static_fail", globalPropertyi("sim/operation/failures/rel_static2"))  -- static fail


-- digits images
defineProperty("digitsImage", loadImage("white_digit_strip.png", 0, 0, 16, 196))
defineProperty("digitsImageZeros", loadImage("white_digit_zeros_strip.png", 0, 0, 16, 196))
-- red led image
defineProperty("black_img", loadImage("needles.png", 280, 40, 10, 10))
defineProperty("white_img", loadImage("needles.png", 210, 43, 10, 5))

-- initial switchers values
defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames


local time_counter = 0
local not_loaded = true


-- post frame caclulations
local alt = get(msl_alt)
local feet_angle = alt * 0.001 * 360.0
local red_led_vis = true
local pressure_ind = get(pressure) * 33.863726
local angle_actual = feet_angle
local last_angle = feet_angle
local msl = get(msl_alt) * 3.28083

function update()
	
	-- initial switchers values
	local passed = get(frame_time)

	
	local power_27 = 0
	local power_115 = 0
	local switcher = get(uvid_30fk_sw)
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
	
	if power_27 * power_115 * switcher > 0 and fail < 6 then  -- altitude in feet. works only when power exist
		alt = real_alt-- * 0.3048 
		set(uvid_30fk_cc, 1)
	else set(uvid_30fk_cc, 0)	end 
	-- limit altitude
	if alt > 30000 then alt = 30000 end
	
	-- calculate angle for needle
	feet_angle = alt * 0.001 * 360.0
	
	angle_actual = last_angle + (feet_angle - last_angle) * passed * 3
	last_angle = angle_actual
	
	-- led logic
	if power_27 == 0 or switcher == 0 or power_115 == 0 or fail == 6 then
		red_led_vis = false
	else red_led_vis = true end
	
	pressure_ind = get(pressure) * 33.863726
	
end


-- altimeter consists of several components
components = {
	-- positioning gauge
	--[[rectangle {
		position = {99, 99, 2, 2},
		color = {1, 0, 0, 1},
	},--]]
	
	-- red fail led
	texture{
		position = {96, 164, 8, 12},
		image = get(black_img),
		visible = function()
			return red_led_vis
		end
	
	},

	-- pressure in millimeters of mercury
	digitstape {
        position = { 70, 29, 60, 22};
        image = digitsImage;
		showLeadingZeros = true;
        digits = 4;
        value = function() 
            return pressure_ind
        end;
    }; 

	-- altitude in digits in tens of feet
	digitstape {
        position = { 65, 108, 78, 21};
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
        position = { 122, 108, 20, 21};
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
		position = {65, 108, 20, 21},
		image = get(black_img),
		visible = function()
			return alt < 10000
		end,
	},
	
	-- sign below zero 
	texture {
		position = {72, 116, 10, 3},
		image = get(white_img),
		visible = function()
			return alt < 0
		end,
	},
	
    -- hundreds feet needle
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
        step = 1 / 33.863726;
        position = { 175, 0, 26, 32 };

        -- round inches hg to millimeters hg
        adjuster = function(v)
            local a = math.floor((v * 33.863726) + 0.5) / 33.863726
			if a < 20.4747 then a = 20.4747
			elseif a > 31.7359 then a = 31.7359 end
			return a
        end;
    };
	

	   
}

