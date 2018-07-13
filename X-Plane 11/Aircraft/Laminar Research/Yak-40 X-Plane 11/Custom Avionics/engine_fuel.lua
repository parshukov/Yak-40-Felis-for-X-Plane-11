size = {2048, 2048}


-- sources
defineProperty("fuel_start1", globalPropertyi("sim/custom/xap/start/fuel_start1")) -- fuel valves
defineProperty("fuel_start2", globalPropertyi("sim/custom/xap/start/fuel_start2")) -- fuel valves
defineProperty("fuel_start3", globalPropertyi("sim/custom/xap/start/fuel_start3")) -- fuel valves


defineProperty("eng1_fuel_access", globalPropertyi("sim/custom/xap/fuel/eng1_fuel_access")) -- engine 1 can use fuel
defineProperty("eng2_fuel_access", globalPropertyi("sim/custom/xap/fuel/eng2_fuel_access")) -- engine 2 can use fuel
defineProperty("eng3_fuel_access", globalPropertyi("sim/custom/xap/fuel/eng3_fuel_access")) -- engine 3 can use fuel


defineProperty("engine1_front_cap", globalPropertyi("sim/custom/xap/covers/engine1_front_cap")) -- engine cap. 0 = off, 1 = on
defineProperty("engine2_front_cap", globalPropertyi("sim/custom/xap/covers/engine2_front_cap")) -- engine cap. 0 = off, 1 = on
defineProperty("engine3_front_cap", globalPropertyi("sim/custom/xap/covers/engine3_front_cap")) -- engine cap. 0 = off, 1 = on

defineProperty("engine1_back_cap", globalPropertyi("sim/custom/xap/covers/engine1_back_cap")) -- engine cap. 0 = off, 1 = on
defineProperty("engine2_back_cap", globalPropertyi("sim/custom/xap/covers/engine2_back_cap")) -- engine cap. 0 = off, 1 = on
defineProperty("engine3_back_cap", globalPropertyi("sim/custom/xap/covers/engine3_back_cap")) -- engine cap. 0 = off, 1 = on

-- result
defineProperty("mixt_valve1", globalPropertyf("sim/flightmodel/engine/ENGN_mixt[1]")) -- Mixture Control (per engine), 0 = cutoff, 1 = full rich
defineProperty("mixt_valve2", globalPropertyf("sim/flightmodel/engine/ENGN_mixt[0]")) -- Mixture Control (per engine), 0 = cutoff, 1 = full rich
defineProperty("mixt_valve3", globalPropertyf("sim/flightmodel/engine/ENGN_mixt[2]")) -- Mixture Control (per engine), 0 = cutoff, 1 = full rich


function update()

	set(mixt_valve1, get(fuel_start1) * get(eng1_fuel_access)) --* (1 - get(engine1_front_cap)) * (1 - get(engine1_back_cap)))

	set(mixt_valve2, get(fuel_start2) * get(eng2_fuel_access)) --* (1 - get(engine2_front_cap)) * (1 - get(engine2_back_cap)))
	
	set(mixt_valve3, get(fuel_start3) * get(eng3_fuel_access)) --* (1 - get(engine3_front_cap)) * (1 - get(engine3_back_cap)))
	
end

