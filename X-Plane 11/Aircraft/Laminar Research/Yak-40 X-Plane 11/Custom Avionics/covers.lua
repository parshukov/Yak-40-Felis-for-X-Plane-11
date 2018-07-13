-- this is covers logic

-- sources
defineProperty("gear_blocks", globalPropertyi("sim/custom/xap/covers/gear_blocks"))  -- gear blocks. 0 = off, 1 = on

defineProperty("pitot1_cap", globalPropertyi("sim/custom/xap/covers/pitot1_cap"))  -- pitot cap. 0 = off, 1 = on
defineProperty("pitot2_cap", globalPropertyi("sim/custom/xap/covers/pitot2_cap"))  -- pitot cap. 0 = off, 1 = on

defineProperty("rio_cap", globalPropertyi("sim/custom/xap/covers/rio_cap"))  -- RIO3 cap. 0 = off, 1 = on

defineProperty("static1_cap", globalPropertyi("sim/custom/xap/covers/static1_cap"))  -- static cap. 0 = off, 1 = on
defineProperty("static2_cap", globalPropertyi("sim/custom/xap/covers/static2_cap"))  -- static cap. 0 = off, 1 = on

defineProperty("engine1_front_cap", globalPropertyi("sim/custom/xap/covers/engine1_front_cap")) -- engine cap. 0 = off, 1 = on
defineProperty("engine2_front_cap", globalPropertyi("sim/custom/xap/covers/engine2_front_cap")) -- engine cap. 0 = off, 1 = on
defineProperty("engine3_front_cap", globalPropertyi("sim/custom/xap/covers/engine3_front_cap")) -- engine cap. 0 = off, 1 = on

defineProperty("engine1_back_cap", globalPropertyi("sim/custom/xap/covers/engine1_back_cap")) -- engine cap. 0 = off, 1 = on
defineProperty("engine2_back_cap", globalPropertyi("sim/custom/xap/covers/engine2_back_cap")) -- engine cap. 0 = off, 1 = on
defineProperty("engine3_back_cap", globalPropertyi("sim/custom/xap/covers/engine3_back_cap")) -- engine cap. 0 = off, 1 = on


-- sim variables
defineProperty("ground_speed", globalPropertyf("sim/flightmodel/position/groundspeed"))

defineProperty("eng1_work", globalPropertyi("sim/flightmodel2/engines/engine_is_burning_fuel[1]")) 
defineProperty("eng2_work", globalPropertyi("sim/flightmodel2/engines/engine_is_burning_fuel[0]")) 
defineProperty("eng3_work", globalPropertyi("sim/flightmodel2/engines/engine_is_burning_fuel[2]")) 


-- failures
defineProperty("pitot_1_fail", globalPropertyi("sim/operation/failures/rel_pitot"))  -- pitot 1 fail
defineProperty("pitot_2_fail", globalPropertyi("sim/operation/failures/rel_pitot2"))  -- pitot 2 fail
defineProperty("static_1_fail", globalPropertyi("sim/operation/failures/rel_static"))  -- static 1 fail
defineProperty("static_2_fail", globalPropertyi("sim/operation/failures/rel_static2"))  -- static 2 fail
defineProperty("sim_engine_on_fire1", globalPropertyi("sim/operation/failures/rel_engfir1"))  -- left engine on fire
defineProperty("sim_engine_on_fire2", globalPropertyi("sim/operation/failures/rel_engfir0"))  -- mid engine on fire
defineProperty("sim_engine_on_fire3", globalPropertyi("sim/operation/failures/rel_engfir2"))  -- right engine on fire



function update()
	-- set Pitot fail
	if get(pitot1_cap) == 1 then set(pitot_1_fail, 6) else set(pitot_1_fail, 0) end
	if get(pitot2_cap) == 1 then set(pitot_2_fail, 6) else set(pitot_2_fail, 0) end
	
	-- set static fail
	if get(static1_cap) == 1 then set(static_1_fail, 6) else set(static_1_fail, 0) end
	if get(static2_cap) == 1 then set(static_2_fail, 6) else set(static_2_fail, 0) end
	
	-- off gear blocks when moving
	if math.abs(get(ground_speed)) > 1 then set(gear_blocks, 0) end
	
	-- set engines failures when caps are on it
	local eng1 = get(eng1_work) == 1
	local eng2 = get(eng2_work) == 1
	local eng3 = get(eng3_work) == 1
	
	if eng1 and get(engine1_front_cap) == 1 then set(sim_engine_on_fire1, 6) end
	if eng2 and get(engine2_front_cap) == 1 then set(sim_engine_on_fire2, 6) end
	if eng3 and get(engine3_front_cap) == 1 then set(sim_engine_on_fire3, 6) end
	
	if eng1 and get(engine1_back_cap) == 1 then set(engine1_back_cap, 0) end
	if eng2 and get(engine2_back_cap) == 1 then set(engine2_back_cap, 0) end
	if eng3 and get(engine3_back_cap) == 1 then set(engine3_back_cap, 0) end

end
