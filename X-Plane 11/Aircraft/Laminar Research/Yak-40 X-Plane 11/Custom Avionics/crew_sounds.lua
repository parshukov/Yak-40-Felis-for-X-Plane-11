-- this is the first crew sounds for Yak40

defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames

defineProperty("ias", globalPropertyf("sim/cockpit2/gauges/indicators/airspeed_kts_pilot"))
defineProperty("radioalt", globalPropertyf("sim/custom/xap/gauges/radioalt"))
defineProperty("vvi", globalPropertyf("sim/cockpit2/gauges/indicators/vvi_fpm_pilot"))

defineProperty("virt_rud1", globalPropertyf("sim/custom/xap/eng/virt_rud1"))
defineProperty("virt_rud2", globalPropertyf("sim/custom/xap/eng/virt_rud2"))
defineProperty("virt_rud3", globalPropertyf("sim/custom/xap/eng/virt_rud3"))

defineProperty("flap1", globalPropertyf("sim/flightmodel2/wing/flap1_deg[0]")) -- flap deg
defineProperty("flap2", globalPropertyf("sim/flightmodel2/wing/flap1_deg[1]")) -- flap deg

defineProperty("gear1_deflect", globalPropertyf("sim/flightmodel2/gear/tire_vertical_deflection_mtr[0]"))  -- vertical deflection of front gear
defineProperty("gear2_deflect", globalPropertyf("sim/flightmodel2/gear/tire_vertical_deflection_mtr[1]"))  -- vertical deflection of left gear
defineProperty("gear3_deflect", globalPropertyf("sim/flightmodel2/gear/tire_vertical_deflection_mtr[2]"))  -- vertical deflection of right gear

defineProperty("gear1_deploy", globalPropertyf("sim/aircraft/parts/acf_gear_deploy[0]"))  -- deploy of front gear
defineProperty("gear2_deploy", globalPropertyf("sim/aircraft/parts/acf_gear_deploy[1]"))  -- deploy of right gear
defineProperty("gear3_deploy", globalPropertyf("sim/aircraft/parts/acf_gear_deploy[2]"))  -- deploy of left gear

-- sounds
local crew_spd_up = loadSample('Custom Sounds/crew_spd_up.wav')
local crew_spd_100 = loadSample('Custom Sounds/crew_spd_100.wav')
local crew_spd_150 = loadSample('Custom Sounds/crew_spd_150.wav')
local crew_spd_170 = loadSample('Custom Sounds/crew_spd_170.wav')
local crew_spd_180 = loadSample('Custom Sounds/crew_spd_180.wav')
local crew_spd_200 = loadSample('Custom Sounds/crew_spd_200.wav')
local crew_spd_save = loadSample('Custom Sounds/crew_spd_save.wav')

local crew_500m = loadSample('Custom Sounds/crew_500m.wav')
local crew_400m = loadSample('Custom Sounds/crew_400m.wav')
local crew_200m = loadSample('Custom Sounds/crew_200m.wav')
local crew_100m = loadSample('Custom Sounds/crew_100m.wav')
local crew_50m = loadSample('Custom Sounds/crew_50m.wav')
local crew_30m = loadSample('Custom Sounds/crew_30m.wav')
local crew_20m = loadSample('Custom Sounds/crew_20m.wav')
local crew_10m = loadSample('Custom Sounds/crew_10m.wav')
local crew_5m = loadSample('Custom Sounds/crew_5m.wav')
local crew_4m = loadSample('Custom Sounds/crew_4m.wav')
local crew_3m = loadSample('Custom Sounds/crew_3m.wav')
local crew_2m = loadSample('Custom Sounds/crew_2m.wav')
local crew_1m = loadSample('Custom Sounds/crew_1m.wav')


local was_500 = false
local was_400 = false
local was_200 = false
local was_100 = false
local was_50 = false
local was_30 = false
local was_20 = false
local was_10 = false
local was_5 = false
local was_4 = false
local was_3 = false
local was_2 = false
local was_1 = false


local speak_counter = -10
local phrase_time = 0

local v_ias_last = 0

function update()
	-- calculate enviroment values
	local passed = get(frame_time)
	local v_ias = get(ias) * 1.852 -- km/h
	local r_alt = get(radioalt) -- m
	local v_spd = get(vvi) * 0.00508 -- m/s

	local gear_defl = get(gear1_deflect) + get(gear2_deflect) + get(gear3_deflect)
	local gear_dep = get(gear1_deploy) + get(gear2_deploy) + get(gear3_deploy)
	local flaps = get(flap1)
	local ruds = get(virt_rud1) + get(virt_rud2) + get(virt_rud3)
	
	speak_counter = speak_counter + passed
	
	if speak_counter > phrase_time then -- every phrase needs some time to speak. when speaking one, other must wait
	
		-- determine if we are taking off
		if gear_defl > 0.1 and ruds > 1.8 and gear_dep > 2.9 then
			if v_ias > v_ias_last and v_ias > 50 and v_ias < 55 then -- speeding up
				playSample(crew_spd_up, 0)
				phrase_time = 2 -- set time for phrase
				speak_counter = 0 -- reset counter
			elseif v_ias > v_ias_last and v_ias > 95 and v_ias < 105 then -- speed 100
				playSample(crew_spd_100, 0)
				phrase_time = 2 -- set time for phrase
				speak_counter = 0 -- reset counter
			elseif v_ias > v_ias_last and v_ias > 147 and v_ias < 153 then -- speed 150
				playSample(crew_spd_150, 0)
				phrase_time = 2 -- set time for phrase
				speak_counter = 0 -- reset counter
			elseif v_ias > v_ias_last and v_ias > 157 and v_ias < 163 then -- speed 170
				playSample(crew_spd_170, 0)
				phrase_time = 1 -- set time for phrase
				speak_counter = 0 -- reset counter
			elseif v_ias > v_ias_last and v_ias > 177 and v_ias < 183 then -- speed 180
				playSample(crew_spd_180, 0)
				phrase_time = 1 -- set time for phrase
				speak_counter = 0 -- reset counter
			elseif v_ias > v_ias_last and v_ias > 197 and v_ias < 203 then -- speed 200
				playSample(crew_spd_200, 0)
				phrase_time = 1 -- set time for phrase
				speak_counter = 0 -- reset counter			
			end
				 was_500 = false
				 was_400 = false
				 was_200 = false
				 was_100 = false
				 was_50 = false
				 was_30 = false
				 was_20 = false
				 was_10 = false
				 was_5 = false
				 was_4 = false
				 was_3 = false
				 was_2 = false
				 was_1 = false	
		-- determine if we are just taked off and ready to retract L.G.
		elseif v_spd > 1 and r_alt > 10 and r_alt < 15 and gear_dep > 2.9 and ruds > 2.4 then
			playSample(crew_spd_save, 0)
			phrase_time = 5 -- set time for phrase
			speak_counter = 0 -- reset counter
				 was_500 = false
				 was_400 = false
				 was_200 = false
				 was_100 = false
				 was_50 = false
				 was_30 = false
				 was_20 = false
				 was_10 = false
				 was_5 = false
				 was_4 = false
				 was_3 = false
				 was_2 = false
				 was_1 = false				
		-- determine if we are descending for landing
		elseif v_spd < 0 and ruds < 2 then
			if r_alt > 498 and r_alt < 502 and not was_500 then -- alt 500
				playSample(crew_500m, 0)
				phrase_time = 3 -- set time for phrase
				speak_counter = 0 -- reset counter
				was_500 = true
				 was_400 = false
				 was_200 = false
				 was_100 = false
				 was_50 = false
				 was_30 = false
				 was_20 = false
				 was_10 = false
				 was_5 = false
				 was_4 = false
				 was_3 = false
				 was_2 = false
				 was_1 = false
			elseif r_alt > 398 and r_alt < 402 and not was_400 then -- alt 400
				playSample(crew_400m, 0)
				phrase_time = 3 -- set time for phrase
				speak_counter = 0 -- reset counter	
				was_500 = false
				was_400 = true
				 was_200 = false
				 was_100 = false
				 was_50 = false
				 was_30 = false
				 was_20 = false
				 was_10 = false
				 was_5 = false
				 was_4 = false
				 was_3 = false
				 was_2 = false
				 was_1 = false
			elseif r_alt > 198 and r_alt < 202 and not was_200 then -- alt 200
				playSample(crew_200m, 0)
				phrase_time = 3 -- set time for phrase
				speak_counter = 0 -- reset counter	
				was_400 = false
				was_200 = true
				 was_100 = false
				 was_50 = false
				 was_30 = false
				 was_20 = false
				 was_10 = false
				 was_5 = false
				 was_4 = false
				 was_3 = false
				 was_2 = false
				 was_1 = false
			elseif r_alt > 98 and r_alt < 102 and not was_100 then -- alt 100
				playSample(crew_100m, 0)
				phrase_time = 3 -- set time for phrase
				speak_counter = 0 -- reset counter
				was_200 = false
				was_100 = true
				 was_400 = false
				 was_50 = false
				 was_30 = false
				 was_20 = false
				 was_10 = false
				 was_5 = false
				 was_4 = false
				 was_3 = false
				 was_2 = false
				 was_1 = false
			elseif r_alt > 49 and r_alt < 51 and not was_50 then -- alt 50
				playSample(crew_50m, 0)
				phrase_time = 1.5 -- set time for phrase
				speak_counter = 0 -- reset counter
				was_100 = false
				was_50 = true
				 was_400 = false
				 was_200 = false
				 was_30 = false
				 was_20 = false
				 was_10 = false
				 was_5 = false
				 was_4 = false
				 was_3 = false
				 was_2 = false
				 was_1 = false
			elseif r_alt > 29 and r_alt < 31 and not was_30 then -- alt 30
				playSample(crew_30m, 0)
				phrase_time = 1.5 -- set time for phrase
				speak_counter = 0 -- reset counter
				was_50 = false
				was_30 = true
				 was_400 = false
				 was_200 = false
				 was_100 = false
				 was_20 = false
				 was_10 = false
				 was_5 = false
				 was_4 = false
				 was_3 = false
				 was_2 = false
				 was_1 = false
			elseif r_alt > 19 and r_alt < 21 and not was_20 then -- alt 20
				playSample(crew_20m, 0)
				phrase_time = 1 -- set time for phrase
				speak_counter = 0 -- reset counter
				was_30 = false
				was_20 = true
				 was_400 = false
				 was_200 = false
				 was_100 = false
				 was_50 = false
				 was_10 = false
				 was_5 = false
				 was_4 = false
				 was_3 = false
				 was_2 = false
				 was_1 = false
			elseif r_alt > 9 and r_alt < 11 and not was_10 then -- alt 10
				playSample(crew_10m, 0)
				phrase_time = 1 -- set time for phrase
				speak_counter = 0 -- reset counter
				was_20 = false
				was_10 = true
				 was_400 = false
				 was_200 = false
				 was_100 = false
				 was_50 = false
				 was_30 = false
				 was_5 = false
				 was_4 = false
				 was_3 = false
				 was_2 = false
				 was_1 = false
			elseif r_alt > 4.5 and r_alt < 5.5 and not was_5 then -- alt 5
				playSample(crew_5m, 0)
				phrase_time = 0.5 -- set time for phrase
				speak_counter = 0 -- reset counter
				was_10 = false
				was_5 = true
				 was_400 = false
				 was_200 = false
				 was_100 = false
				 was_50 = false
				 was_30 = false
				 was_20 = false
				 was_4 = false
				 was_3 = false
				 was_2 = false
				 was_1 = false
			elseif r_alt > 3.5 and r_alt < 4.5 and not was_4 then -- alt 4
				playSample(crew_4m, 0)
				phrase_time = 0.5 -- set time for phrase
				speak_counter = 0 -- reset counter	
				was_5 = false
				was_4 = true
				 was_400 = false
				 was_200 = false
				 was_100 = false
				 was_50 = false
				 was_30 = false
				 was_20 = false
				 was_10 = false
				 was_3 = false
				 was_2 = false
				 was_1 = false
			elseif r_alt > 2.5 and r_alt < 3.5 and not was_3 then -- alt 3
				playSample(crew_3m, 0)
				phrase_time = 0.5 -- set time for phrase
				speak_counter = 0 -- reset counter
				was_4 = false
				was_3 = true
				 was_400 = false
				 was_200 = false
				 was_100 = false
				 was_50 = false
				 was_30 = false
				 was_20 = false
				 was_10 = false
				 was_5 = false
				 was_2 = false
				 was_1 = false
			elseif r_alt > 1.5 and r_alt < 2.5 and not was_2 then -- alt 2
				playSample(crew_2m, 0)
				phrase_time = 0.5 -- set time for phrase
				speak_counter = 0 -- reset counter
				was_3 = false
				was_2 = true
				 was_400 = false
				 was_200 = false
				 was_100 = false
				 was_50 = false
				 was_30 = false
				 was_20 = false
				 was_10 = false
				 was_5 = false
				 was_4 = false
				 was_1 = false
			elseif r_alt > 0.5 and r_alt < 1.5 and not was_1 then -- alt 1
				playSample(crew_1m, 0)
				phrase_time = 0.4 -- set time for phrase
				speak_counter = 0 -- reset counter
				was_2 = false
				was_1 = true
				 was_400 = false
				 was_200 = false
				 was_100 = false
				 was_50 = false
				 was_30 = false
				 was_20 = false
				 was_10 = false
				 was_5 = false
				 was_4 = false
				 was_3 = false
			else
			--[[	 was_500 = false
				 was_400 = false
				 was_200 = false
				 was_100 = false
				 was_50 = false
				 was_30 = false
				 was_20 = false
				 was_10 = false
				 was_5 = false
				 was_4 = false
				 was_3 = false
				 was_2 = false
				 was_1 = false
			--]]
			end
				
		end
	
	
	
	
	
	
	
	
	end

	-- last variables
	v_ias_last = v_ias


end