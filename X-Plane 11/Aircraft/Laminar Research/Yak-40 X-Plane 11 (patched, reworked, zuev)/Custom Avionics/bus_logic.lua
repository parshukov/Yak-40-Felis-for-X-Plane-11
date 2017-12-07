-- this is a main power logic, connecting all generator, batteries and panels and calculating power load on busses

-- define property table
-- connect sources to bus

defineProperty("bat_volt_bus1", globalPropertyf("sim/custom/xap/power/bat_volt1")) -- battery voltage, initial 24V - full charge.
defineProperty("bat_volt_bus2", globalPropertyf("sim/custom/xap/power/bat_volt2")) -- battery voltage, initial 24V - full charge.
defineProperty("bat_amp_bus1", globalPropertyf("sim/custom/xap/power/bat_amp_bus1"))  -- battery current, initial 0A. positive - battery load, negative - battery recharge.
defineProperty("bat_amp_bus2", globalPropertyf("sim/custom/xap/power/bat_amp_bus2"))  -- battery current, initial 0A. positive - battery load, negative - battery recharge.
defineProperty("bat_on_bus", globalPropertyi("sim/custom/xap/power/bat_on_bus"))  -- internal battery connector to bus. 0 = OFF, 1 = ON
defineProperty("bat_amp_cc1", globalPropertyf("sim/custom/xap/power/bat_amp_cc1"))  -- if batteries are charging, they take current instead of give it. = 0 when bat is source
defineProperty("bat_amp_cc2", globalPropertyf("sim/custom/xap/power/bat_amp_cc2"))  -- if batteries are charging, they take current instead of give it. = 0 when bat is source
defineProperty("bat_conn1", globalPropertyi("sim/custom/xap/power/bat1_on"))  -- battery switch. 0 = OFF, 1 = ON
defineProperty("bat_conn2", globalPropertyi("sim/custom/xap/power/bat2_on"))  -- battery switch. 0 = OFF, 1 = ON

defineProperty("gen1_volt_bus", globalPropertyf("sim/custom/xap/power/gen1_volt_bus"))  -- generator voltage, initial 28.5v
defineProperty("gen2_volt_bus", globalPropertyf("sim/custom/xap/power/gen2_volt_bus"))
defineProperty("gen3_volt_bus", globalPropertyf("sim/custom/xap/power/gen3_volt_bus"))

defineProperty("gen1_amp_bus", globalPropertyf("sim/custom/xap/power/gen1_amp_bus")) -- generator current load from bus, initial 0A
defineProperty("gen2_amp_bus", globalPropertyf("sim/custom/xap/power/gen2_amp_bus")) 
defineProperty("gen3_amp_bus", globalPropertyf("sim/custom/xap/power/gen3_amp_bus"))

defineProperty("gen1_on_bus", globalPropertyi("sim/custom/xap/power/gen1_on_bus"))  -- generator connected if 1 and dissconnected if 0
defineProperty("gen2_on_bus", globalPropertyi("sim/custom/xap/power/gen2_on_bus"))
defineProperty("gen3_on_bus", globalPropertyi("sim/custom/xap/power/gen3_on_bus"))

-- switchers and logic
defineProperty("ground_available", globalPropertyi("sim/custom/xap/power/ground_available")) -- if there is ground power, this var = 1
defineProperty("power_mode", globalPropertyi("sim/custom/xap/power/power_mode"))  -- power mode: 0 = Ground, 1 = off, 2 = airplane

defineProperty("inv_PT1000", globalPropertyi("sim/custom/xap/power/inv_PT1000"))  -- inverter for 36v bus
defineProperty("inv_PT500", globalPropertyi("sim/custom/xap/power/inv_PT500")) -- inverter for 36v bus
defineProperty("inv_PT1000_emerg", globalPropertyi("sim/custom/xap/power/inv_PT1000_emerg")) -- emergency connect one inv to working. 0 = auto, 1 = manual

defineProperty("inv_PO1500_radio", globalPropertyi("sim/custom/xap/power/inv_PO1500_radio")) -- inverter for 115v bus
defineProperty("inv_PO1500_steklo", globalPropertyi("sim/custom/xap/power/inv_PO1500_steklo")) -- inverter for 115v bus
defineProperty("inv_PO1500_emerg", globalPropertyi("sim/custom/xap/power/inv_PO1500_emerg")) -- STEKLO. emergency connect one inv to working. 0 = off, 1 = auto, 2 = manual
defineProperty("inv_PO1500_emerg2", globalPropertyi("sim/custom/xap/power/inv_PO1500_emerg2")) -- RADIO. emergency connect one inv to working. 0 = off, 1 = auto, 2 = manual

defineProperty("POsteklo_sw", globalPropertyi("sim/custom/xap/power/POsteklo_sw")) -- inverter for 115v bus
defineProperty("POradio_sw", globalPropertyi("sim/custom/xap/power/POradio_sw")) -- inverter for 115v bus
defineProperty("POsteklo_emerg_sw", globalPropertyi("sim/custom/xap/power/POsteklo_emerg_sw")) -- emergency connect inv for 115v bus
defineProperty("POradio_emerg_sw", globalPropertyi("sim/custom/xap/power/POradio_emerg_sw")) -- emergency connect inv for 115v bus

defineProperty("PT1000_sw", globalPropertyi("sim/custom/xap/power/PT1000_sw")) -- inverter for 36v bus
defineProperty("PT500_sw", globalPropertyi("sim/custom/xap/power/PT500_sw")) -- inverter for 36v bus
defineProperty("PT_emerg_sw", globalPropertyi("sim/custom/xap/power/PT_emerg_sw")) -- emergency connect inv for 36v bus

defineProperty("AZS_36v_emerg_sw", globalPropertyi("sim/custom/xap/azs/AZS_36v_emerg_sw")) -- AZS for emergency connect inv for 36v bus
defineProperty("AZS_115v_emerg_sw", globalPropertyi("sim/custom/xap/azs/AZS_115v_emerg_sw")) -- AZS for emergency connect inv-s for 115v bus
defineProperty("AZS_POsteklo_sw", globalPropertyi("sim/custom/xap/azs/AZS_POsteklo_sw")) -- AZS for inverter for 115v bus
defineProperty("AZS_POradio_sw", globalPropertyi("sim/custom/xap/azs/AZS_POradio_sw")) -- AZS for inverter for 115v bus
defineProperty("AZS_radio2_sw", globalPropertyi("sim/custom/xap/azs/AZS_radio2_sw")) -- AZS for PO Radio manual

-- volts and currents on buses. logic
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("DC_27_amp", globalPropertyf("sim/custom/xap/power/DC_27_amp"))
defineProperty("DC_27_source", globalPropertyi("sim/custom/xap/power/DC_27_source"))

defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_36_amp", globalPropertyf("sim/custom/xap/power/AC_36_amp"))
defineProperty("AC_36_source", globalPropertyi("sim/custom/xap/power/AC_36_source"))

defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("AC_115_amp", globalPropertyf("sim/custom/xap/power/AC_115_amp"))
defineProperty("AC_115_source", globalPropertyi("sim/custom/xap/power/AC_115_source"))

defineProperty("gen1_fail_lit", globalPropertyi("sim/custom/xap/power/gen1_fail_lit")) -- lamp for gen 1 fail
defineProperty("gen2_fail_lit", globalPropertyi("sim/custom/xap/power/gen2_fail_lit")) -- lamp for gen 2 fail
defineProperty("gen3_fail_lit", globalPropertyi("sim/custom/xap/power/gen3_fail_lit")) -- lamp for gen 3 fail

defineProperty("PT500_fail_lit", globalPropertyi("sim/custom/xap/power/PT500_fail_lit")) -- lamp for PT500 fail
defineProperty("PO_fail_lit", globalPropertyi("sim/custom/xap/power/PO_fail_lit")) -- lamp for PO fail

defineProperty("but_test_lamp", globalPropertyi("sim/custom/xap/buttons/but_test_lamp")) -- test lamps button

-- default sim variables
defineProperty("sim_bat_on", globalPropertyi("sim/cockpit/electrical/battery_on"))
defineProperty("sim_avionics_on", globalPropertyi("sim/cockpit/electrical/avionics_on"))

defineProperty("sim_inv1_on", globalPropertyi("sim/cockpit2/electrical/inverter_on[0]"))
defineProperty("sim_inv2_on", globalPropertyi("sim/cockpit2/electrical/inverter_on[1]"))



-- calculate buses every frame
function update()
	
	---------------------------------
	-- caclulations for DC 27v bus --
	---------------------------------
	-- initial values
	local DC27_volt = 0
	local DC27_source = get(DC_27_source)  -- 0 = none, 1 = ground, 2 = bats, 3 = gens
	local lamp_test = get(but_test_lamp) == 1
	-- select work source and set voltage for bus
	local bats_on = get(bat_on_bus)
	local ground = get(ground_available)
	local mode = get(power_mode)
	
	-- take voltage from sources
	local gen1 = get(gen1_volt_bus) * get(gen1_on_bus)
	local gen2 = get(gen2_volt_bus) * get(gen2_on_bus)
	local gen3 = get(gen3_volt_bus) * get(gen3_on_bus)
	local bats = math.max(get(bat_volt_bus1), get(bat_volt_bus2))

	-- check if generators work for future calculations
	local gen1_work = 0
	if gen1 > 19 then gen1_work = 1 end
	local gen2_work = 0
	if gen2 > 19 then gen2_work = 1 end
	local gen3_work = 0
	if gen3 > 19 then gen3_work = 1 end

	-- calculate bus
	if mode == 2 then
		-- define source and calculate volts for bus
		if gen1_work + gen2_work + gen3_work > 0 then 
			DC27_volt = (gen1 + gen2 + gen3) / (gen1_work + gen2_work + gen3_work) -- voltage on bus is mean from all working gens
			DC27_source = 3
		elseif bats > 19 then -- of none of gens are not work - power will be taken from batteries
			DC27_volt = bats * bats_on 
			DC27_source = 2
		else 
			DC27_volt = 0
			DC27_source = 0
		end
		-- set sim variables
		set(sim_bat_on, bats_on) 
		set(sim_avionics_on, bats_on)
		set(bat_on_bus, 1)
	elseif mode == 0 then
		DC27_source = 1
		DC27_volt = 27 * ground
		-- set sim variables
		set(sim_bat_on, ground) 
		set(sim_avionics_on, ground)
		set(bat_on_bus, ground)
	else	
		DC27_source = 0
		DC27_volt = 0
		-- set sim variables
		set(sim_bat_on, 0) 
		set(sim_avionics_on, 0)
		set(bat_on_bus, 0)
	end
	-- set results
	set(DC_27_source, DC27_source)  -- set selected source for other logics			
	set(DC_27_volt, DC27_volt) -- set voltage on DC bus 27v
	
	-- set gen fail lamp
	if (gen1_work == 0 or lamp_test) and DC27_volt > 19 then set(gen1_fail_lit, 1) else set(gen1_fail_lit, 0) end
	if (gen2_work == 0 or lamp_test) and DC27_volt > 19 then set(gen2_fail_lit, 1) else set(gen2_fail_lit, 0) end
	if (gen3_work == 0 or lamp_test) and DC27_volt > 19 then set(gen3_fail_lit, 1) else set(gen3_fail_lit, 0) end
	
	
	----------------------------------
	-- calculations for AC 115v bus --
	----------------------------------
	local AC115_volt = 0
	local AC115_source = get(AC_115_source) -- 0 = none, 1 = PO-radio, 2 = PO-steklo, 3 = both, 4 = ground
	local emerg_connect_steklo = (get(POsteklo_emerg_sw) + 1) * get(AZS_115v_emerg_sw) -- 0 = off, 1 = auto, 2 = manual
	local emerg_connect_radio = (get(POradio_emerg_sw) + 1) * get(AZS_115v_emerg_sw) -- 0 = off, 1 = auto, 2 = manual
	local AC115_amp = get(AC_115_amp)
	local inv_radio_work = 0 
	local inv_steklo_work = 0
	if mode == 2 then
		-- check if inverters can work. in every gauge and system i must check which inverter it uses. also i must add here a posibility of auto connection
		if (gen1_work + gen2_work + gen3_work > 0 or (DC27_volt > 20 and emerg_connect_radio == 2 and get(AZS_radio2_sw) == 1)) and get(POradio_sw) == 1 and get(AZS_POradio_sw) == 1 then inv_radio_work = 1 end
		if (gen1_work + gen2_work + gen3_work > 1 or (DC27_volt > 20 and emerg_connect_steklo == 2)) and get(POsteklo_sw) == 1 and get(AZS_POsteklo_sw) == 1 then inv_steklo_work = 1 end
	
		-- calculate bus volts
		if inv_radio_work == 1 and inv_steklo_work == 1 then
			AC115_volt = 115 - AC115_amp / 100
			AC115_source = 3
		elseif inv_radio_work == 1 then
			AC115_volt = 115 - AC115_amp / 50
			AC115_source = 1
		elseif inv_steklo_work == 1 then
			AC115_volt = 115 - AC115_amp / 50
			AC115_source = 2
		else
			AC115_volt = 0
			AC115_source = 0
		end
	elseif mode == 0 then
		AC115_volt = 115 * ground
		AC115_source = 4 * ground
		if get(POradio_sw) == 1 and get(AZS_POradio_sw) == 1 then inv_radio_work = 1 end
		if get(POsteklo_sw) == 1 and get(AZS_POsteklo_sw) == 1 then inv_steklo_work = 1 end
	else
		AC115_volt = 0
		AC115_source = 0
		inv_radio_work = 0
		inv_steklo_work = 0	
	end
	-- set results
	set(AC_115_source, AC115_source)
	set(AC_115_volt, AC115_volt)
	set(inv_PO1500_radio, inv_radio_work)
	set(inv_PO1500_steklo, inv_steklo_work)
	set(inv_PO1500_emerg, emerg_connect_steklo)
	set(inv_PO1500_emerg2, emerg_connect_radio)
	
	-- set lamp for PO fail
	if (inv_radio_work + inv_steklo_work < 2 or lamp_test) and DC27_volt > 19 then set(PO_fail_lit, 1) else set(PO_fail_lit, 0) end
	
	
	---------------------------------
	-- calculations for AC 36v bus --
	---------------------------------
	local AC36_source = get(AC_36_source) -- 0 = none, 1 = PT1000, 2 = PT500, 3 = both
	local AC36_volt = 0
	local inv_1_work = 0
	local inv_2_work = 0
	local emerg_connect_PT1000 = get(AZS_36v_emerg_sw) * (get(PT_emerg_sw) + 1) -- 0 = off, 1 = auto, 2 = manual
	if mode == 2 then -- if power from ground or gens
		-- check if inverters can work
		if get(PT1000_sw) == 1 and DC27_volt > 20 then inv_1_work = 1 end
		if get(PT500_sw) == 1 and gen1_work + gen2_work + gen3_work > 1 then inv_2_work = 1 end
		-- set bus voltage and source
		if inv_1_work == 1 and inv_2_work == 1 then
			AC36_volt = 36 - get(AC_36_amp) / 200
			AC36_source = 3
		elseif inv_1_work == 1 then
			AC36_volt = 36 - get(AC_36_amp) / 100
			AC36_source = 1
		elseif inv_2_work == 1 then
			AC36_volt = 36 - get(AC_36_amp) / 100
			AC36_source = 2
		else
			AC36_volt = 0
			AC36_source = 0
		end		
	elseif mode == 0 then
		-- check if inverters can work
		if get(PT1000_sw) == 1 and DC27_volt > 20 then inv_1_work = 1 end
		if get(PT500_sw) == 1 and DC27_volt > 20 then inv_2_work = 1 end
		-- set bus voltage and source
		if inv_1_work == 1 and inv_2_work == 1 then
			AC36_volt = 36 - get(AC_36_amp) / 200
			AC36_source = 3
		elseif inv_1_work == 1 then
			AC36_volt = 36 - get(AC_36_amp) / 100
			AC36_source = 1
		elseif inv_2_work == 1 then
			AC36_volt = 36 - get(AC_36_amp) / 100
			AC36_source = 2
		else
			AC36_volt = 0
			AC36_source = 0
		end			
	else
		AC36_volt = 0
		AC36_source = 0
	end
	-- set results
	set(AC_36_volt, AC36_volt)
	set(AC_36_source, AC36_source)
	set(inv_PT1000_emerg, emerg_connect_PT1000)
	set(inv_PT1000, inv_1_work)
	set(inv_PT500, inv_2_work)
	
	-- set PT500 fail lamp
	if (inv_2_work == 0 or lamp_test) and DC27_volt > 19 then set(PT500_fail_lit, 1) else set(PT500_fail_lit, 0) end
	

	-- calculate sim inverter status
	if bats_on or gen1_work + gen2_work + gen3_work > 0 or (ground == 1 and mode == 0) then
		set(sim_inv1_on, 1)
		set(sim_inv2_on, 1)
	else
		set(sim_inv1_on, 0)
		set(sim_inv2_on, 0)
	end


	-- try to relocate currents from buses to sources
	-- bus 27v
	if DC27_source == 3 then
		if gen1_work == 1 then set(gen1_amp_bus, get(DC_27_amp) * gen1_work / (gen1_work + gen2_work + gen3_work)) 
		else set(gen1_amp_bus, 0) end
		if gen2_work == 1 then set(gen2_amp_bus, get(DC_27_amp) * gen2_work / (gen1_work + gen2_work + gen3_work)) 
		else set(gen2_amp_bus, 0) end
		if gen3_work == 1 then set(gen3_amp_bus, get(DC_27_amp) * gen3_work / (gen1_work + gen2_work + gen3_work)) 
		else set(gen3_amp_bus, 0) end

		set(bat_amp_bus1, 0 - get(bat_amp_cc1))
		set(bat_amp_bus2, 0 - get(bat_amp_cc2))
	elseif DC27_source == 2 then
		set(gen1_amp_bus, 0)
		set(gen2_amp_bus, 0)
		set(gen3_amp_bus, 0)
		if get(bat_conn1) == 1 then set(bat_amp_bus1, get(DC_27_amp) * get(bat_conn1) / (get(bat_conn1) + get(bat_conn2)))
		else set(bat_amp_bus1, 0) end
		if get(bat_conn2) == 1 then set(bat_amp_bus2, get(DC_27_amp) * get(bat_conn2) / (get(bat_conn1) + get(bat_conn2)))
		else set(bat_amp_bus2, 0) end
	elseif DC27_source == 1 then
		set(gen1_amp_bus, 0)
		set(gen2_amp_bus, 0)
		set(gen3_amp_bus, 0)
		set(bat_amp_bus1, 0 - get(bat_amp_cc1))
		set(bat_amp_bus2, 0 - get(bat_amp_cc2))
	else 
		set(gen1_amp_bus, 0)
		set(gen2_amp_bus, 0)
		set(gen3_amp_bus, 0)
		set(bat_amp_bus1, 0)
		set(bat_amp_bus2, 0)
	end

	--print(get(DC_27_amp), get(bat_amp_bus1), get(bat_amp_bus2), DC27_source)
	
	-- buses 36v and 115v will be calculated and added to 27v in bus counter logic
	
			
end







