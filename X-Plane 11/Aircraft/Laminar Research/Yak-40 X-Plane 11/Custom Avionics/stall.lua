size = {2048, 2048}

-- define property table
defineProperty("ias", globalPropertyf("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")) -- ias variable
defineProperty("tas", globalPropertyf("sim/flightmodel/position/true_airspeed")) -- tas variable meters per second
defineProperty("alpha", globalPropertyf("sim/flightmodel2/misc/AoA_angle_degrees"))  -- angle of attack
defineProperty("alpha_fail", globalPropertyi("sim/operation/failures/rel_AOA"))  -- angle of attack fail
defineProperty("aoa_sensor_angle", globalPropertyf("sim/custom/xap/misc/aoa_sensor_angle"))  -- angle of AOA sensor

defineProperty("msl_alt", globalPropertyf("sim/flightmodel/position/elevation"))  -- barometric alt. maybe in feet, maybe in meters.
defineProperty("baro_press", globalPropertyf("sim/weather/barometer_sealevel_inhg"))  -- pressire at sea level in.Hg

defineProperty("flap1", globalPropertyf("sim/flightmodel2/wing/flap1_deg[0]")) -- flap deg
defineProperty("flap2", globalPropertyf("sim/flightmodel2/wing/flap1_deg[1]")) -- flap deg

defineProperty("gear1_deploy", globalPropertyf("sim/aircraft/parts/acf_gear_deploy[0]"))  -- deploy of front gear
defineProperty("gear2_deploy", globalPropertyf("sim/aircraft/parts/acf_gear_deploy[1]"))  -- deploy of right gear
defineProperty("gear3_deploy", globalPropertyf("sim/aircraft/parts/acf_gear_deploy[2]"))  -- deploy of left gear


-- power
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt 
defineProperty("but_test_lamp", globalPropertyi("sim/custom/xap/buttons/but_test_lamp")) -- test lamps button
defineProperty("AZS_sign_stall_sw", globalPropertyi("sim/custom/xap/azs/AZS_sign_stall_sw"))  -- AZS for stall signal
defineProperty("stall_siren", globalPropertyi("sim/custom/xap/gauges/stall_siren")) -- stall signal
defineProperty("stall_cc", globalPropertyf("sim/custom/xap/gauges/stall_cc")) -- stall cc

-- enviroment
defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames
defineProperty("flight_time", globalPropertyf("sim/time/total_running_time_sec"))  -- local time since aircraft was loaded 

-- failures
defineProperty("stall_warn_fail", globalPropertyi("sim/operation/failures/rel_stall_warn")) -- failure of stall worning

-- images
defineProperty("stall_led", loadImage("lamps2.png", 0, 50, 50, 50))
defineProperty("speed_led", loadImage("lamps.png", 0, 75, 60, 25))

-- local variables
local a_angle = 0
local last_lamp_change = get(flight_time)
local actual_a = 0
local warn = false
local spd_warn = false
set(aoa_sensor_angle, 0)

function update()
	-- calculate power
	local power = get(DC_27_volt) > 21 and get(AC_36_volt) > 30
	
local passed = get(frame_time)

if passed > 0 then
	local test_lamp = get(but_test_lamp) == 1
	if power then
		
		
		-- calculate alpha
		if get(ias) > 50 and get(alpha_fail) < 6 then
			local a = get(alpha) + 3
			a_angle = a
			set(aoa_sensor_angle, a)
		else 
			a_angle = 0
		end
		-- set warning
		if (actual_a > 13 and get(stall_warn_fail) < 6) or test_lamp then
			--if get(flight_time) - last_lamp_change > 0.16 then
				warn = true --not warn
				last_lamp_change = get(flight_time)
			--end
		else
			warn = false			
		end
	
		-- calculate maximum speed
		local speed = get(ias) * 1.852 -- speed in km/h
		local speed_tas = get(tas) * 3.6 -- speed in km/h
		local real_alt = get(msl_alt) + (29.92 - get(baro_press)) * 304.800919  -- calculate barometric altitude in meters
		local flaps = (get(flap1) + get(flap2)) * 0.5 -- flaps pos in deg
		local gears = (get(gear1_deploy) + get(gear2_deploy) + get(gear3_deploy)) / 3 -- gear deploy
		
		-- lamp logic
		--spd_warn = speed > 455 and real_alt < 6000 or speed > 405 and real_alt > 6000 or speed > 305 and flaps > 20
		--		or speed > 255 and flaps > 34 or speed > 325 and gears > 0.3 or test_lamp
		spd_warn = speed > 455 and real_alt < 6000 or speed_tas > 605 and real_alt > 6000 or speed > 305 and flaps > 20
				or speed > 255 and flaps > 34 or speed > 325 and gears > 0.3 or test_lamp
		
		
		set(stall_cc, 1)
	else
		a_angle = 0
		spd_warn = false
		warn = false	
		set(stall_cc, 0)
	end
	local azs = get(AZS_sign_stall_sw) == 1
	warn = warn and azs or test_lamp
	spd_warn = spd_warn and azs or test_lamp
	
	
	-- smooth move of needles
	actual_a = actual_a + (a_angle - actual_a) * passed * 5
	
	-- siren logic
	if (warn or spd_warn) and not test_lamp then set(stall_siren, 1) else set(stall_siren, 0) end
	
	
end


	
end






components = {

	-- stall image
	textureLit {
		position = {1140, 980, 65, 65},
		image = get(stall_led),
		visible = function()
			return warn
		end
	
	},	

	-- speed image
	textureLit {
		position = {1303, 973, 60, 26},
		image = get(speed_led),
		visible = function()
			return spd_warn
		end
	
	},	

	
	-- position gauge
--[[	rectangle {
		position = {99, 99, 2, 2},
		color = {1, 0, 0, 1},
	}, --]]

}
