-- this is simple logic of start engines
-- define property table
-- default datarefs and commands
defineProperty("sim_igniter1", globalPropertyi("sim/cockpit2/engine/actuators/igniter_on[1]")) -- igniters on/off
defineProperty("sim_igniter2", globalPropertyi("sim/cockpit2/engine/actuators/igniter_on[0]")) -- igniters on/off
defineProperty("sim_igniter3", globalPropertyi("sim/cockpit2/engine/actuators/igniter_on[2]")) -- igniters on/off

defineProperty("sim_ignition1", globalPropertyi("sim/cockpit2/engine/actuators/ignition_on[1]")) -- ignition on/off
defineProperty("sim_ignition2", globalPropertyi("sim/cockpit2/engine/actuators/ignition_on[0]")) -- ignition on/off
defineProperty("sim_ignition3", globalPropertyi("sim/cockpit2/engine/actuators/ignition_on[2]")) -- ignition on/off

defineProperty("sim_starter1", globalPropertyf("sim/cockpit/engine/starter_duration[1]")) -- time of starter work
defineProperty("sim_starter2", globalPropertyf("sim/cockpit/engine/starter_duration[0]")) -- time of starter work
defineProperty("sim_starter3", globalPropertyf("sim/cockpit/engine/starter_duration[2]")) -- time of starter work

starter_1 = findCommand("sim/starters/engage_starter_2")  -- simulator command for starter 1
starter_2 = findCommand("sim/starters/engage_starter_1")  -- simulator command for starter 2
starter_3 = findCommand("sim/starters/engage_starter_3")  -- simulator command for starter 3

-- custom datarefs
defineProperty("fuel_start1", globalPropertyi("sim/custom/xap/start/fuel_start1")) -- fuel valves
defineProperty("fuel_start2", globalPropertyi("sim/custom/xap/start/fuel_start2")) -- fuel valves
defineProperty("fuel_start3", globalPropertyi("sim/custom/xap/start/fuel_start3")) -- fuel valves

defineProperty("air_start1", globalPropertyi("sim/custom/xap/start/air_start1")) -- air start button
defineProperty("air_start2", globalPropertyi("sim/custom/xap/start/air_start2")) -- air start button
defineProperty("air_start3", globalPropertyi("sim/custom/xap/start/air_start3")) -- air start button

defineProperty("start_sw", globalPropertyi("sim/custom/xap/start/start_sw")) -- starter switcher
defineProperty("start_mode_sw", globalPropertyi("sim/custom/xap/start/start_mode_sw")) -- start mode switcher
defineProperty("eng_select_sw", globalPropertyi("sim/custom/xap/start/eng_select_sw")) -- engine selector switcher
defineProperty("start_but", globalPropertyi("sim/custom/xap/start/start_but")) -- start button
defineProperty("stop_but", globalPropertyi("sim/custom/xap/start/stop_but")) -- stop button

defineProperty("starter_work_lit", globalPropertyi("sim/custom/xap/start/starter_work_lit")) -- starter lamp

defineProperty("start_press", globalPropertyf("sim/custom/xap/start/starter_press")) -- pressure in start system

defineProperty("apu_can_start", globalPropertyi("sim/custom/xap/apu/apu_can_start")) -- APU can start other engines

defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt

defineProperty("eng_rpm1", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[1]"))   
defineProperty("eng_rpm2", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[0]"))
defineProperty("eng_rpm3", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[2]"))

defineProperty("eng_work1", globalPropertyf("sim/flightmodel2/engines/engine_is_burning_fuel[1]"))
defineProperty("eng_work2", globalPropertyf("sim/flightmodel2/engines/engine_is_burning_fuel[0]"))
defineProperty("eng_work3", globalPropertyf("sim/flightmodel2/engines/engine_is_burning_fuel[2]"))

defineProperty("virt_rud1", globalPropertyf("sim/custom/xap/eng/virt_rud1"))
defineProperty("virt_rud2", globalPropertyf("sim/custom/xap/eng/virt_rud2"))
defineProperty("virt_rud3", globalPropertyf("sim/custom/xap/eng/virt_rud3"))

defineProperty("AZS_ignition1_sw", globalPropertyf("sim/custom/xap/azs/AZS_ignition1_sw"))
defineProperty("AZS_ignition2_sw", globalPropertyf("sim/custom/xap/azs/AZS_ignition2_sw"))
defineProperty("AZS_ignition3_sw", globalPropertyf("sim/custom/xap/azs/AZS_ignition3_sw"))


defineProperty("emerg_stop1", globalPropertyi("sim/custom/xap/start/emerg_stop1")) -- stop button
defineProperty("emerg_stop2", globalPropertyi("sim/custom/xap/start/emerg_stop2")) -- stop button
defineProperty("emerg_stop3", globalPropertyi("sim/custom/xap/start/emerg_stop3")) -- stop button

defineProperty("emerg_stop1_cap", globalPropertyi("sim/custom/xap/start/emerg_stop1_cap")) -- stop button
defineProperty("emerg_stop2_cap", globalPropertyi("sim/custom/xap/start/emerg_stop2_cap")) -- stop button
defineProperty("emerg_stop3_cap", globalPropertyi("sim/custom/xap/start/emerg_stop3_cap")) -- stop button

defineProperty("real_startup", globalPropertyi("sim/custom/xap/set/real_startup"))-- when start the engines a lot of thing must to be done
defineProperty("control_fix", globalPropertyi("sim/custom/xap/control/control_fix")) -- fix controls, so they cannot move. 1 = fix, 0 = released

defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames
defineProperty("sim_run_time", globalPropertyf("sim/time/total_running_time_sec")) -- sim time

local time_last = get(sim_run_time)  -- time for previous frame

local eng1_start_time = time_last - 100
local eng2_start_time = time_last - 100
local eng3_start_time = time_last - 100

local eng1_starting = false
local eng2_starting = false
local eng3_starting = false

local eng1_starting_air = false
local eng2_starting_air = false
local eng3_starting_air = false

local eng1_rpm_check = false
local eng2_rpm_check = false
local eng3_rpm_check = false

commandEnd(starter_1)
commandEnd(starter_2)
commandEnd(starter_3)

local start_button_pressed = false
local starter_press = 0
local duration_last = get(sim_starter1) + get(sim_starter3) + get(sim_starter3)
-- postframe calculaions
function update()
	-- time calculations
	local time_now = get(sim_run_time)
	local passed = get(frame_time)
	local fix_contr = get(control_fix) == 1
	local real = get(real_startup) == 1
-- time bug workaround
if passed > 0 then
	
	-- power calculations
	local power = get(DC_27_volt) > 19
	
	local rpm1 = get(eng_rpm1)
	local rpm2 = get(eng_rpm2)
	local rpm3 = get(eng_rpm3)

	-- automatic fuel cutoff if engines shuted down
	if time_now - eng1_start_time > 70 and rpm1 < 50 then set(fuel_start1, 0) end
	if time_now - eng2_start_time > 70 and rpm2 < 50 then set(fuel_start2, 0) end
	if time_now - eng3_start_time > 70 and rpm3 < 50 then set(fuel_start3, 0) end
	
	-- emergency fuel cutoff
	if get(emerg_stop1) == 1 then
		eng1_starting = false
		eng1_start_time = eng1_start_time - 70
		set(fuel_start1, 0)
		commandEnd(starter_1)
		set(starter_work_lit, 0)
		eng1_rpm_check = false
	end

	if get(emerg_stop2) == 1 then
		eng2_starting = false
		eng2_start_time = eng2_start_time - 70
		set(fuel_start2, 0)
		commandEnd(starter_2)
		set(starter_work_lit, 0)
		eng2_rpm_check = false
	end
	
	if get(emerg_stop3) == 1 then
		eng3_starting = false
		eng3_start_time = eng3_start_time - 70
		set(fuel_start3, 0)
		commandEnd(starter_3)
		set(starter_work_lit, 0)
		eng3_rpm_check = false
	end

	
	local work1 = get(eng_work1)
	local work2 = get(eng_work2)
	local work3 = get(eng_work3)
	
	-- air start system logic
	starter_press = starter_press + (get(apu_can_start) * 0.2 + (rpm1 * work1 + rpm2 * work2 + rpm3 * work3) * 0.002) * passed
	local duration_now = get(sim_starter1) * (1-work1) + get(sim_starter2) * (1-work2) + get(sim_starter3) * (1-work3)
	local duration_diff = math.max(0, math.min(1, duration_now - duration_last))
	starter_press = starter_press - (duration_diff * 0.1 + 0.045 * passed) * starter_press^2
	duration_last = duration_now
	if starter_press > 4 then starter_press = 4
	elseif starter_press < 0 then starter_press = 0 end
	set(start_press, starter_press)
	
	-- start variables
	local selected_eng = get(eng_select_sw)
	local eng_start = get(start_but) == 1
	local eng_stop = get(stop_but) == 1
	local starter = get(start_sw) == 1
	local starter_mode = get(start_mode_sw)
	
	-- start engines logic
	if power then
		-- engage start process
		if selected_eng == 1 and eng_start and not start_button_pressed and (starter and starter_press > 2 and not fix_contr or not real) then
			eng1_starting = true
			eng2_starting = false
			eng3_starting = false
			eng1_starting_air = false
			eng2_starting_air = false
			eng3_starting_air = false
			eng1_start_time = time_now
			start_button_pressed = true
		elseif selected_eng == 2 and eng_start and not start_button_pressed and (starter and starter_press > 2 and not fix_contr or not real) then
			eng1_starting = false
			eng2_starting = true
			eng3_starting = false
			eng1_starting_air = false
			eng2_starting_air = false
			eng3_starting_air = false
			eng2_start_time = time_now
			start_button_pressed = true
		elseif selected_eng == 3 and eng_start and not start_button_pressed and (starter and starter_press > 2 and not fix_contr or not real) then
			eng1_starting = false
			eng2_starting = false
			eng3_starting = true
			eng1_starting_air = false
			eng2_starting_air = false
			eng3_starting_air = false
			eng3_start_time = time_now
			start_button_pressed = true
		end
		
		-- release start button
		start_button_pressed = eng_start
		
		
		----------------
		-- engine 1 --
		-----------------
		-- start process on ground	
		if eng1_starting and (starter_mode == 1 or not real) and not eng1_starting_air then
			-- rpm check
			if not eng1_rpm_check and rpm1 > 50 then
					eng1_starting = false
					eng1_start_time = eng1_start_time - 70
			else eng1_rpm_check = true
			end
			
			-- turn on the starter
			if time_now - eng1_start_time > 2 and time_now - eng1_start_time < 28 then
				commandBegin(starter_1)
				set(starter_work_lit, 1)
			end
			
			-- turn on the fuel
			if time_now - eng1_start_time > 20 and time_now - eng1_start_time < 28 then
				set(fuel_start1, 1)
			end
			
			-- finish startup process
			if time_now - eng1_start_time > 42 or rpm1 > 60 then 
				eng1_starting = false 
				commandEnd(starter_1)
				set(starter_work_lit, 0)
				eng1_rpm_check = false
			end 
			
			-- emergency stop startup process
			if eng_stop or selected_eng ~= 1 then  
				eng1_starting = false
				eng1_start_time = eng1_start_time - 70
				set(fuel_start1, 0)
				commandEnd(starter_1)
				set(starter_work_lit, 0)
				eng1_rpm_check = false
			end	
		end

		-- start process on air
		local start_on_air1 = get(air_start1) == 1
		if not eng1_starting and start_on_air1 and rpm1 > 8 and not fix_contr then
			eng1_start_time = time_now
			eng1_starting_air = true
		end
		
		if eng1_starting_air then 
			if time_now - eng1_start_time < 5 then
				commandBegin(starter_1)
				set(fuel_start1, 1)
			else
				commandEnd(starter_1)
				eng1_starting_air = false
			end
			
		end
		
		-- cold rotate
		if eng1_starting and starter_mode > 1 then
			-- turn on the starter
			if time_now - eng1_start_time < 20 then
				commandBegin(starter_1)
				set(starter_work_lit, 1)
			else 
				commandEnd(starter_1)
				set(starter_work_lit, 0)
				eng1_starting = false
			end
			
			if eng_stop or selected_eng ~= 1 then  -- emergency stop startup process
				eng1_starting = false
				eng1_start_time = eng1_start_time - 70
				commandEnd(starter_1)
				set(starter_work_lit, 0)
			end
		end

		----------------
		-- engine 2 --
		-----------------
		-- start process on ground	
		if eng2_starting and (starter_mode == 1 or not real) and not eng2_starting_air then
			
			-- rpm check
			if not eng2_rpm_check and rpm2 > 50 then
					eng2_starting = false
					eng2_start_time = eng2_start_time - 70
			else eng2_rpm_check = true
			end
			
			-- turn on the starter
			if time_now - eng2_start_time > 2 and time_now - eng2_start_time < 28 then
				commandBegin(starter_2)
				set(starter_work_lit, 1)
			end
			
			-- turn on the fuel
			if time_now - eng2_start_time > 20 and time_now - eng2_start_time < 28 then
				set(fuel_start2, 1)
			end
			
			-- finish startup process
			if time_now - eng2_start_time > 42 or rpm2 > 60 then 
				eng2_starting = false 
				commandEnd(starter_2)
				set(starter_work_lit, 0)
				eng2_rpm_check = false
			end 
			
			-- emergency stop startup process
			if eng_stop or selected_eng ~= 2 then  
				eng2_starting = false
				eng2_start_time = eng2_start_time - 70
				set(fuel_start2, 0)
				commandEnd(starter_2)
				set(starter_work_lit, 0)
				eng2_rpm_check = false
			end	
			
		end

		-- start process on air
		local start_on_air2 = get(air_start2) == 1
		if not eng2_starting and start_on_air2 and rpm2 > 8 and not fix_contr then
			eng2_start_time = time_now
			eng2_starting_air = true
		end
		
		if eng2_starting_air then 
			if time_now - eng2_start_time < 5 then
				commandBegin(starter_2)
				set(fuel_start2, 1)
			else
				commandEnd(starter_2)
				eng2_starting_air = false
			end
			
		end
		
		-- cold rotate
		if eng2_starting and starter_mode > 1 then
			-- turn on the starter
			if time_now - eng2_start_time < 20 then
				commandBegin(starter_2)
				set(starter_work_lit, 1)
			else 
				commandEnd(starter_2)
				set(starter_work_lit, 0)
				eng2_starting = false
			end
			
			if eng_stop or selected_eng ~= 2 then  -- emergency stop startup process
				eng2_starting = false
				eng2_start_time = eng2_start_time - 70
				commandEnd(starter_2)
				set(starter_work_lit, 0)
			end
		end

		
		----------------
		-- engine 3 --
		-----------------
		-- start process on ground	
		if eng3_starting and (starter_mode == 1 or not real) and not eng3_starting_air then

			-- rpm check
			if not eng3_rpm_check and rpm3 > 50 then
					eng3_starting = false
					eng3_start_time = eng3_start_time - 70
			else eng3_rpm_check = true
			end

			-- turn on the starter
			if time_now - eng3_start_time > 2 and time_now - eng3_start_time < 28 then
				commandBegin(starter_3)
				set(starter_work_lit, 1)
			end

			-- turn on the fuel
			if time_now - eng3_start_time > 20 and time_now - eng3_start_time < 28 then
				set(fuel_start3, 1)
			end
			
			-- finish startup process
			if time_now - eng3_start_time > 42 or rpm3 > 60 then 
				eng3_starting = false 
				commandEnd(starter_3)
				set(starter_work_lit, 0)
				eng3_rpm_check = false
			end 

			-- emergency stop startup process
			if eng_stop or selected_eng ~= 3 then  
				eng3_starting = false
				eng3_start_time = eng3_start_time - 70
				set(fuel_start3, 0)
				commandEnd(starter_3)
				set(starter_work_lit, 0)
				eng3_rpm_check = false
			end	
			
		end

		-- start process on air
		local start_on_air3 = get(air_start3) == 1
		if not eng3_starting and start_on_air3 and rpm3 > 8 and not fix_contr then
			eng3_start_time = time_now
			eng3_starting_air = true
		end
		
		if eng3_starting_air then 
			if time_now - eng3_start_time < 5 then
				commandBegin(starter_3)
				set(fuel_start3, 1)
			else
				commandEnd(starter_3)
				eng3_starting_air = false
			end
			
		end
		
		-- cold rotate
		if eng3_starting and starter_mode > 1 then
			-- turn on the starter
			if time_now - eng3_start_time < 20 then
				commandBegin(starter_3)
				set(starter_work_lit, 1)
			else 
				commandEnd(starter_3)
				set(starter_work_lit, 0)
				eng3_starting = false
			end
			
			if eng_stop or selected_eng ~= 3 then  -- emergency stop startup process
				eng3_starting = false
				eng3_start_time = eng3_start_time - 70
				commandEnd(starter_3)
				set(starter_work_lit, 0)
			end
		end
	
		-- bugs workaround
		if (not starter or starter_mode < 1 or selected_eng == 0) and real then -- stop start process
			eng1_starting = false
			eng1_start_time = eng1_start_time - 70
			commandEnd(starter_1)
			eng1_rpm_check = false
			---
			eng2_starting = false
			eng2_start_time = eng2_start_time - 70
			commandEnd(starter_2)
			eng2_rpm_check = false
			---
			eng3_starting = false
			eng3_start_time = eng3_start_time - 70
			commandEnd(starter_3)
			eng3_rpm_check = false
			---
			start_button_pressed = false
			set(starter_work_lit, 0)	
		end
	
		
	else
		eng1_starting = false
		eng1_starting_air = false
		eng1_start_time = eng1_start_time - 70
		commandEnd(starter_1)
		eng1_rpm_check = false
		---
		eng2_starting = false
		eng2_starting_air = false
		eng2_start_time = eng2_start_time - 70
		commandEnd(starter_2)
		eng2_rpm_check = false
		---
		eng3_starting = false
		eng3_starting_air = false
		eng3_start_time = eng3_start_time - 70
		commandEnd(starter_3)
		eng3_rpm_check = false
		---
		start_button_pressed = false
		set(starter_work_lit, 0)
	end
	
	-- AZS logic
	local AZS1 = get(AZS_ignition1_sw)
	local AZS2 = get(AZS_ignition2_sw)
	local AZS3 = get(AZS_ignition3_sw)
	
	set(sim_igniter1, AZS1)
	set(sim_igniter2, AZS2)
	set(sim_igniter3, AZS3)
	
	set(sim_ignition1, AZS1 * 3)
	set(sim_ignition2, AZS2 * 3)
	set(sim_ignition3, AZS3 * 3)
	
	--if AZS1 == 0 then set(fuel_start1, 0) end
	--if AZS2 == 0 then set(fuel_start2, 0) end
	--if AZS3 == 0 then set(fuel_start3, 0) end
	
	-- stop starter (bugs workariond)
	if not eng1_starting and not eng1_starting_air then 
		commandEnd(starter_1)
		--set(starter_work_lit, 0)
	end
	if not eng2_starting and not eng2_starting_air then 
		commandEnd(starter_2)
		--set(starter_work_lit, 0)
	end
	if not eng3_starting and not eng3_starting_air then 
		commandEnd(starter_3)
		--set(starter_work_lit, 0)
	end
	

	
end


end

