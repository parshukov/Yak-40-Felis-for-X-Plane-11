-- this is logic for fuel system

-- sources
-- buttons and switchers
defineProperty("act_sw", globalPropertyi("sim/custom/xap/fuel/act_sw")) -- center fuel automat switcher
defineProperty("fuel_pump1_sw", globalPropertyi("sim/custom/xap/fuel/fuel_pump1_sw")) -- fuel pump switcher
defineProperty("fuel_pump2_sw", globalPropertyi("sim/custom/xap/fuel/fuel_pump2_sw")) -- fuel pump switcher
defineProperty("fuel_pump2_emerg_sw", globalPropertyi("sim/custom/xap/fuel/fuel_pump2_emerg_sw")) -- fuel pump switcher
defineProperty("fuel_pump_mode_sw", globalPropertyi("sim/custom/xap/fuel/fuel_pump_mode_sw")) -- which pump work softer
defineProperty("join_valve_sw", globalPropertyi("sim/custom/xap/fuel/join_valve_sw")) -- join valve switcher
defineProperty("circle_valve_sw", globalPropertyi("sim/custom/xap/fuel/circle_valve_sw")) -- circle valve switcher
defineProperty("fire_valve1_sw", globalPropertyi("sim/custom/xap/fuel/fire_valve1_sw")) -- fire valve switcher on overhead
defineProperty("fire_valve2_sw", globalPropertyi("sim/custom/xap/fuel/fire_valve2_sw")) -- fire valve switcher on overhead
defineProperty("fire_valve3_sw", globalPropertyi("sim/custom/xap/fuel/fire_valve3_sw")) -- fire valve switcher on overhead
defineProperty("fire_valve_apu_sw", globalPropertyi("sim/custom/xap/fuel/fire_valve_apu_sw")) -- fire valve switcher for apu

defineProperty("fire_valve1_sw_cap", globalPropertyi("sim/custom/xap/fuel/fire_valve1_sw_cap")) -- fire valve switcher on overhead
defineProperty("fire_valve2_sw_cap", globalPropertyi("sim/custom/xap/fuel/fire_valve2_sw_cap")) -- fire valve switcher on overhead
defineProperty("fire_valve3_sw_cap", globalPropertyi("sim/custom/xap/fuel/fire_valve3_sw_cap")) -- fire valve switcher on overhead

-- AZS
defineProperty("AZS_fire_valve1_sw", globalPropertyi("sim/custom/xap/azs/AZS_fire_valve1_sw")) -- fire valve switcher on AZS
defineProperty("AZS_fire_valve2_sw", globalPropertyi("sim/custom/xap/azs/AZS_fire_valve2_sw")) -- fire valve switcher on AZS
defineProperty("AZS_fire_valve3_sw", globalPropertyi("sim/custom/xap/azs/AZS_fire_valve3_sw")) -- fire valve switcher on AZS
defineProperty("AZS_join_valve_sw", globalPropertyi("sim/custom/xap/azs/AZS_join_valve_sw")) -- fire valve switcher on AZS
defineProperty("AZS_circle_valve_sw", globalPropertyi("sim/custom/xap/azs/AZS_circle_valve_sw")) -- fire valve switcher on AZS

-- power
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("inv_PO1500_radio", globalPropertyi("sim/custom/xap/power/inv_PO1500_radio")) -- inverter for 115v bus
defineProperty("inv_PO1500_steklo", globalPropertyi("sim/custom/xap/power/inv_PO1500_steklo")) -- inverter for 115v bus

defineProperty("fuel_pump_cc", globalPropertyf("sim/custom/xap/fuel/fuel_pump_cc")) -- cc
defineProperty("fuel_act_cc", globalPropertyf("sim/custom/xap/fuel/fuel_act_cc")) -- cc


defineProperty("gen1_volt_bus", globalPropertyf("sim/custom/xap/power/gen1_volt_bus"))  -- generator voltage, initial 28.5v
defineProperty("gen2_volt_bus", globalPropertyf("sim/custom/xap/power/gen2_volt_bus"))
defineProperty("gen3_volt_bus", globalPropertyf("sim/custom/xap/power/gen3_volt_bus"))

defineProperty("gen1_on_bus", globalPropertyi("sim/custom/xap/power/gen1_on_bus"))  -- generator connected if 1 and dissconnected if 0
defineProperty("gen2_on_bus", globalPropertyi("sim/custom/xap/power/gen2_on_bus"))
defineProperty("gen3_on_bus", globalPropertyi("sim/custom/xap/power/gen3_on_bus"))

-- results
defineProperty("fire_valve1", globalPropertyf("sim/custom/xap/fuel/fire_valve1")) -- fire valve position
defineProperty("fire_valve2", globalPropertyf("sim/custom/xap/fuel/fire_valve2")) -- fire valve position
defineProperty("fire_valve3", globalPropertyf("sim/custom/xap/fuel/fire_valve3")) -- fire valve position
defineProperty("fire_valve_apu", globalPropertyf("sim/custom/xap/fuel/fire_valve_apu")) -- fire valve position

defineProperty("fuel_pump1_work", globalPropertyi("sim/custom/xap/fuel/fuel_pump1_work")) -- fuel pump working
defineProperty("fuel_pump2_work", globalPropertyi("sim/custom/xap/fuel/fuel_pump2_work")) -- fuel pump working

defineProperty("eng1_fuel_access", globalPropertyi("sim/custom/xap/fuel/eng1_fuel_access")) -- engine 1 can use fuel
defineProperty("eng2_fuel_access", globalPropertyi("sim/custom/xap/fuel/eng2_fuel_access")) -- engine 2 can use fuel
defineProperty("eng3_fuel_access", globalPropertyi("sim/custom/xap/fuel/eng3_fuel_access")) -- engine 3 can use fuel
defineProperty("apu_fuel_access", globalPropertyi("sim/custom/xap/fuel/apu_fuel_access")) -- APU can use fuel

defineProperty("circle_fuel_access", globalPropertyi("sim/custom/xap/fuel/circle_fuel_access")) -- circle valve is open
defineProperty("join_fuel_access", globalPropertyi("sim/custom/xap/fuel/join_fuel_access")) -- join valve is open

-- sim variables
defineProperty("sim_fuel_pump1", globalPropertyi("sim/cockpit2/fuel/fuel_tank_pump_on[0]")) -- sim fuel pump
defineProperty("sim_fuel_pump2", globalPropertyi("sim/cockpit2/fuel/fuel_tank_pump_on[1]")) -- sim fuel pump

defineProperty("sim_fuel_tank_selector", globalPropertyi("sim/cockpit2/fuel/fuel_tank_selector")) -- sim fuel tank in use. 0=none,1=left,2=center,3=right,4=all
defineProperty("sim_fuel_tank_transfer_to", globalPropertyi("sim/cockpit2/fuel/fuel_tank_transfer_to")) -- 0=none,1=left,2=center,3=right
defineProperty("sim_fuel_tank_transfer_from", globalPropertyi("sim/cockpit2/fuel/fuel_tank_transfer_from")) -- 0=none,1=left,2=center,3=right
-- never use 2 (center) as fuel source - yak40 don't have it!!!
defineProperty("fuel_q_1", globalPropertyf("sim/flightmodel/weight/m_fuel[0]")) -- fuel quantity for tank 1
defineProperty("fuel_q_2", globalPropertyf("sim/flightmodel/weight/m_fuel[1]")) -- fuel quantity for tank 2

defineProperty("eng1_work", globalPropertyi("sim/flightmodel2/engines/engine_is_burning_fuel[1]")) 
defineProperty("eng2_work", globalPropertyi("sim/flightmodel2/engines/engine_is_burning_fuel[0]")) 
defineProperty("eng3_work", globalPropertyi("sim/flightmodel2/engines/engine_is_burning_fuel[2]")) 

defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time of frame

defineProperty("fuel_dump1", globalPropertyi("sim/custom/xap/fuel/fuel_dump1")) -- fuel dump
defineProperty("fuel_dump2", globalPropertyi("sim/custom/xap/fuel/fuel_dump2")) -- fuel dump
defineProperty("fuel_dump_cap", globalPropertyi("sim/custom/xap/fuel/fuel_dump_cap")) -- fuel dump cap
defineProperty("fuel_dump1_lit", globalPropertyi("sim/custom/xap/fuel/fuel_dump1_lit")) -- fuel dump
defineProperty("fuel_dump2_lit", globalPropertyi("sim/custom/xap/fuel/fuel_dump2_lit")) -- fuel dump

defineProperty("N1", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[1]"))   
defineProperty("N2", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[0]"))
defineProperty("N3", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[2]"))


set(sim_fuel_pump1, 1)
set(sim_fuel_pump2, 1)
set(sim_fuel_tank_selector, 4)

local circle1 = false
local circle2 = false

local start_counter = 0
local notLoaded = true

local fuel_counter_1 = 40 -- time for enable fuel cross valves, when one of fuel pump fails, sec
local fuel_counter_2 = 40 -- time for enable fuel cross valves, when one of fuel pump fails
local fuel_counter_3 = 40 -- time for enable fuel cross valves, when one of fuel pump fails
local fuel_counter_4 = 40 -- time for enable fuel cross valves, when one of fuel pump fails


function update()

	local power = get(DC_27_volt) > 21
	local passed = get(frame_time)
	local qty_1 = get(fuel_q_1)
	local qty_2 = get(fuel_q_2)	
	local valve_cc = 0
	start_counter = start_counter + passed	
    -- initial switchers position
	if start_counter > 0.3 and start_counter < 0.5 and notLoaded and get(N1) < 10 and get(N2) < 10 and get(N3) < 10 then
		set(act_sw, 0)
		set(fuel_pump1_sw, 0)
		set(fuel_pump2_sw, 0)
		set(fire_valve1_sw, 0)
		set(fire_valve2_sw, 0)
		set(fire_valve3_sw, 0)
		set(fire_valve1_sw_cap, 1)
		set(fire_valve2_sw_cap, 1)
		set(fire_valve3_sw_cap, 1)
		set(fire_valve1, 0)
		set(fire_valve2, 0)
		set(fire_valve3, 0)
		notLoaded = false
	end



	
	-- logic of fuel pumps
	-- left
	local pump1_work = true
	if power then
		local switch = get(fuel_pump1_sw)
		--set(sim_fuel_pump1, switch)
		set(fuel_pump1_work, switch)
		pump1_work = switch == 1
	else
		--set(sim_fuel_pump1, 0)
		set(fuel_pump1_work, 0)
		pump1_work = false
	end

	-- right
	local pump2_work = true
	if power then
		local one_gen_work = get(gen1_volt_bus) * get(gen1_on_bus) > 0 or get(gen2_volt_bus) * get(gen2_on_bus) > 0 or get(gen3_volt_bus) * get(gen3_on_bus) > 0
		if get(fuel_pump2_sw) == 1 and (one_gen_work or get(fuel_pump2_emerg_sw) == 1) then
			--set(sim_fuel_pump2, 1)
			set(fuel_pump2_work, 1)
			pump2_work = true
		else
			--set(sim_fuel_pump2, 0)
			set(fuel_pump2_work, 0)
			pump2_work = false
		end
	else 
		--set(sim_fuel_pump2, 0)
		set(fuel_pump2_work, 0)
		pump2_work = false
	end
--[[	
	-- fuel buffers
	if  not pump1_work and pump_counter_1 > 0 then pump_counter_1 = pump_counter_1 - passed
	else pump_counter_1 = 40 end
	
	if  not pump2_work and pump_counter_2 > 0 then pump_counter_2 = pump_counter_2 - passed
	else pump_counter_2 = 40 end
	
	local fuel_buffer_1 = pump_counter_1 > 0
	local fuel_buffer_2 = pump_counter_2 > 0
--]]	
	-- logic of fire valves
	-- 1
	local fire_valve_1 = get(fire_valve1)
	if power and get(AZS_fire_valve1_sw) == 1 then
		if get(fire_valve1_sw) == 1 and fire_valve_1 < 1 then fire_valve_1 = fire_valve_1 + passed / 4 valve_cc = valve_cc + 5
		elseif get(fire_valve1_sw) == 0 and fire_valve_1 > 0 then fire_valve_1 = fire_valve_1 - passed / 4 valve_cc = valve_cc + 5
		end
		if fire_valve_1 > 1 then fire_valve_1 = 1
		elseif fire_valve_1 < 0 then fire_valve_1 = 0 end
		set(fire_valve1, fire_valve_1)
	end

	-- 2
	local fire_valve_2 = get(fire_valve2)
	if power and get(AZS_fire_valve2_sw) == 1 then
		if get(fire_valve2_sw) == 1 and fire_valve_2 < 1 then fire_valve_2 = fire_valve_2 + passed / 4 valve_cc = valve_cc + 5
		elseif get(fire_valve2_sw) == 0 and fire_valve_2 > 0 then fire_valve_2 = fire_valve_2 - passed / 4 valve_cc = valve_cc + 5
		end
		if fire_valve_2 > 1 then fire_valve_2 = 1
		elseif fire_valve_2 < 0 then fire_valve_2 = 0 end
		set(fire_valve2, fire_valve_2)
	end

	-- 3
	local fire_valve_3 = get(fire_valve3)
	if power and get(AZS_fire_valve3_sw) == 1 then
		if get(fire_valve3_sw) == 1 and fire_valve_3 < 1 then fire_valve_3 = fire_valve_3 + passed / 4 valve_cc = valve_cc + 5
		elseif get(fire_valve3_sw) == 0 and fire_valve_3 > 0 then fire_valve_3 = fire_valve_3 - passed / 4 valve_cc = valve_cc + 5
		end
		if fire_valve_3 > 1 then fire_valve_3 = 1
		elseif fire_valve_3 < 0 then fire_valve_3 = 0 end
		set(fire_valve3, fire_valve_3)
	end
	
	-- APU
	local apu_fire_valve = get(fire_valve_apu)
	if power then
		if get(fire_valve_apu_sw) == 1 and apu_fire_valve < 1 then apu_fire_valve = apu_fire_valve + passed / 4 valve_cc = valve_cc + 5
		elseif get(fire_valve_apu_sw) == 0 and apu_fire_valve > 0 then apu_fire_valve = apu_fire_valve - passed / 4 valve_cc = valve_cc + 5
		end
		if apu_fire_valve > 1 then apu_fire_valve = 1
		elseif apu_fire_valve < 0 then apu_fire_valve = 0 end
		set(fire_valve_apu, apu_fire_valve)
	end
	
	-- logic of circle and join
	if power and get(circle_valve_sw) == 1 and get(AZS_circle_valve_sw) == 1 then
		circle1 = true
		set(circle_fuel_access, 1)
	elseif power and get(circle_valve_sw) == 0 and get(AZS_circle_valve_sw) == 1 then
		circle1 = false
		set(circle_fuel_access, 0)
	end
	if power and get(join_valve_sw) == 1 and get(AZS_join_valve_sw) == 1 then
		circle2 = true
		set(join_fuel_access, 1)
	elseif power and get(join_valve_sw) == 0 and get(AZS_join_valve_sw) == 1 then
		circle2 = false
		set(join_fuel_access, 0)
	end
	
	-- engine feed logic
--[[local eng1_feed = ((pump1_work and (qty_1 > 32 or (qty_2 > 50 and circle2))) or (pump2_work and circle1 and (qty_2 > 32 or (qty_1 > 32 and circle2)))) and fire_valve_1 > 0.5
	local eng2_feed = ((pump1_work and (qty_1 > 32 or (qty_2 > 50 and circle2))) or (pump2_work and (qty_2 > 32 or (qty_1 > 50 and circle2)))) and fire_valve_2 > 0.5
	local eng3_feed = ((pump2_work and (qty_2 > 32 or (qty_1 > 50 and circle2))) or (pump1_work and circle1 and (qty_1 > 32 or (qty_2 > 32 and circle2)))) and fire_valve_3 > 0.5
	local apu_feed = ((pump1_work and (qty_1 > 32 or (qty_2 > 50 and circle2))) or (pump2_work and circle1 and (qty_2 > 32 or (qty_1 > 32 and circle2)))) and apu_fire_valve > 0.5
	--]]
	
	-- set fuel counters
	--1
	if (pump1_work and (qty_1 > 32 or (qty_2 > 50 and circle2))) or (pump2_work and circle1 and (qty_2 > 32 or (qty_1 > 32 and circle2))) then fuel_counter_1 = 40
	elseif fuel_counter_1 > 0 then fuel_counter_1 = fuel_counter_1 - passed end
	
	--2
	if (pump1_work and (qty_1 > 32 or (qty_2 > 50 and circle2))) or (pump2_work and (qty_2 > 32 or (qty_1 > 50 and circle2))) then fuel_counter_2 = 40
	elseif fuel_counter_2 > 0 then fuel_counter_2 = fuel_counter_2 - passed end
	
	--3
	if (pump2_work and (qty_2 > 32 or (qty_1 > 50 and circle2))) or (pump1_work and circle1 and (qty_1 > 32 or (qty_2 > 32 and circle2))) then fuel_counter_3 = 40
	elseif fuel_counter_3 > 0 then fuel_counter_3 = fuel_counter_3 - passed end
	
	-- APU
	if (pump1_work and (qty_1 > 32 or (qty_2 > 50 and circle2))) or (pump2_work and circle1 and (qty_2 > 32 or (qty_1 > 32 and circle2))) then fuel_counter_4 = 40
	elseif fuel_counter_4 > 0 then fuel_counter_4 = fuel_counter_4 - passed end

	-- set fuel feeds
	local eng1_feed = fuel_counter_1 > 0 and fire_valve_1 > 0.5
	local eng2_feed = fuel_counter_2 > 0 and fire_valve_2 > 0.5
	local eng3_feed = fuel_counter_3 > 0 and fire_valve_3 > 0.5
	local apu_feed = fuel_counter_4 > 0 and apu_fire_valve > 0.5
	
	-- set results
	if eng1_feed then set(eng1_fuel_access, 1) else set(eng1_fuel_access, 0) end
	if eng2_feed then set(eng2_fuel_access, 1) else set(eng2_fuel_access, 0) end
	if eng3_feed then set(eng3_fuel_access, 1) else set(eng3_fuel_access, 0) end
	if apu_feed then set(apu_fuel_access, 1) else set(apu_fuel_access, 0) end
	
	-- calculate fuel source
	local eng_working1 = get(eng1_work) == 1
	local eng_working2 = get(eng2_work) == 1
	local eng_working3 = get(eng3_work) == 1
	
	local tank_sel = 4
	if eng_working1 and eng_working3 then -- 1 1 1 or 1 0 1
		if pump1_work and pump2_work then
			tank_sel = 4 --if get(sim_fuel_tank_selector) ~= 1 then tank_sel = 1 else tank_sel = 3 end
		elseif pump1_work then 
			tank_sel = 1
		else tank_sel = 3 end
	elseif eng_working1 and not eng_working3 then -- 1 0 0 or 1 1 0
		tank_sel = 1
	elseif eng_working3 and not eng_working1 then -- 0 0 1 or 0 1 1 
		tank_sel = 3
	elseif eng_working2 and not eng_working1 and not eng_working3 then -- 0 1 0
		--[[if (qty_1 > 32 and (pump1_work or (pump2_work and circle2))) and (qty_2 > 32 and (pump2_work or (pump1_work and circle2))) then
			if get(sim_fuel_tank_selector) ~= 1 then tank_sel = 1 else tank_sel = 3 end
		elseif (qty_1 > 32 and (pump1_work or (pump2_work and circle2))) then
			tank_sel = 1
		else tank_sel = 4 end--]]
		if pump1_work and pump2_work then
			tank_sel = 4 --if get(sim_fuel_tank_selector) ~= 1 then tank_sel = 1 else tank_sel = 3 end
		elseif pump1_work then 
			tank_sel = 1
		else tank_sel = 3 end
	else tank_sel = 4 end -- 0 0 0
	if circle2 or circle1 then tank_sel = 4 end

	-- logic of center fuel unit
	-- ACT will work only if both pumps are ON
	if pump1_work and pump2_work and get(act_sw) == 1 and get(inv_PO1500_radio) == 1 and qty_1 > 200 and qty_2 > 200 then
		if qty_1 - qty_2 > 200 then tank_sel = 1
		elseif qty_2 - qty_1 > 200 then tank_sel = 3
		end
		local mode = get(fuel_pump_mode_sw)
		if mode == 1 then tank_sel = 3
		elseif mode == -1 then tank_sel = 1
		end
		set(fuel_act_cc, 0.5)
	else
		set(fuel_act_cc, 0)
	end

	-- fuel dump logic
	if qty_1 > 200 and get(fuel_dump1) == 1 then
		qty_1 = qty_1 - passed * 5
		set(fuel_q_1, qty_1)
		set(fuel_dump1_lit, 1)
	else
		set(fuel_dump1_lit, 0)
	end
	if qty_2 > 200 and get(fuel_dump2) == 1 then
		qty_2 = qty_2 - passed * 5
		set(fuel_q_2, qty_2)
		set(fuel_dump2_lit, 1)
	else
		set(fuel_dump2_lit, 0)
	end	
	
	-- pump power
	local CC = 0
	if pump1_work then CC = CC + 5 end
	if pump2_work then CC = CC + 5 end
	set(fuel_pump_cc, CC + valve_cc)
	
	-- set result 
	set(sim_fuel_tank_selector, tank_sel)
	set(sim_fuel_tank_transfer_to, 0)
	set(sim_fuel_tank_transfer_from, 0)	
	set(sim_fuel_pump1, 1)
	set(sim_fuel_pump2, 1)	
end