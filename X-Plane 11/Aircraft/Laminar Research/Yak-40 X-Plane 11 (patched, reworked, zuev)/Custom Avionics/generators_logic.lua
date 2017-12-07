-- this is simple logic of generators. calculations for each gen are here.

-- initialize component property table
defineProperty("gen1_volt_bus", globalPropertyf("sim/custom/xap/power/gen1_volt_bus"))  -- generator voltage, initial 28.5v
defineProperty("gen2_volt_bus", globalPropertyf("sim/custom/xap/power/gen2_volt_bus"))
defineProperty("gen3_volt_bus", globalPropertyf("sim/custom/xap/power/gen3_volt_bus"))

defineProperty("gen1_amp_bus", globalPropertyf("sim/custom/xap/power/gen1_amp_bus")) -- generator current load from bus, initial 0A
defineProperty("gen2_amp_bus", globalPropertyf("sim/custom/xap/power/gen2_amp_bus")) 
defineProperty("gen3_amp_bus", globalPropertyf("sim/custom/xap/power/gen3_amp_bus"))

defineProperty("gen1_on_bus", globalPropertyi("sim/custom/xap/power/gen1_on_bus"))  -- generator connected if 1 and dissconnected if 0
defineProperty("gen2_on_bus", globalPropertyi("sim/custom/xap/power/gen2_on_bus"))
defineProperty("gen3_on_bus", globalPropertyi("sim/custom/xap/power/gen3_on_bus"))

defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt

-- all generators work from their engines
defineProperty("eng1_N1", globalPropertyf("sim/flightmodel/engine/ENGN_N1_[1]")) -- engine 1 rpm
defineProperty("eng2_N1", globalPropertyf("sim/flightmodel/engine/ENGN_N1_[0]")) -- engine 2 rpm
defineProperty("eng3_N1", globalPropertyf("sim/flightmodel/engine/ENGN_N1_[2]")) -- engine 3 rpm

-- default sim variables
defineProperty("sim_gen1_on", globalPropertyi("sim/cockpit/electrical/generator_on[1]"))
defineProperty("sim_gen2_on", globalPropertyi("sim/cockpit/electrical/generator_on[0]"))
defineProperty("sim_gen3_on", globalPropertyi("sim/cockpit/electrical/generator_on[2]"))

-- failures
defineProperty("set_real_generators", globalPropertyi("sim/custom/xap/set/real_generators")) -- generators can fail if overload

defineProperty("sim_gen1_fail", globalPropertyi("sim/operation/failures/rel_genera1"))
defineProperty("sim_gen2_fail", globalPropertyi("sim/operation/failures/rel_genera0"))
defineProperty("sim_gen3_fail", globalPropertyi("sim/operation/failures/rel_genera2"))


function update() -- every frame calculations are here
	-- pre calculation defifnitions

	local eng_rpm1 = get(eng1_N1)
	local eng_rpm2 = get(eng2_N1)
	local eng_rpm3 = get(eng3_N1)
	local eng1_work = 0
	local eng2_work = 0
	local eng3_work = 0
	
	local gen1_amp = get(gen1_amp_bus)
	local gen2_amp = get(gen2_amp_bus)
	local gen3_amp = get(gen3_amp_bus)
	local DC = 0-- generator cannot work, if there is no power for start it. once started, gen will produce power for itself
	DC = 1 -- on yak40 generator are self powered
	if get(DC_27_volt) > 18 then DC = 1 end
	-- set overload fails
	if get(set_real_generators) == 1 then
		if gen1_amp > 250 then set(sim_gen1_fail, 6) end
		if gen2_amp > 250 then set(sim_gen2_fail, 6) end
		if gen3_amp > 250 then set(sim_gen3_fail, 6) end
	end
	
	-- check engine work
	if eng_rpm1 > 10 then eng1_work = 1 else eng1_work = 0 end
	if eng_rpm2 > 10 then eng2_work = 1 else eng2_work = 0 end
	if eng_rpm3 > 10 then eng3_work = 1 else eng3_work = 0 end

	-- sim generators failures
	local gen1_fail = get(sim_gen1_fail) == 6
	local gen2_fail = get(sim_gen2_fail) == 6
	local gen3_fail = get(sim_gen3_fail) == 6	
	
	-- calculations for generator 1
	local gen1_volt = (28.5 - gen1_amp / 100) * eng1_work * DC  -- calculate voltage of generator depending on it's load and engine work
	if gen1_fail then gen1_volt = 0 end -- check failure
	set(gen1_volt_bus, gen1_volt) -- set result

	-- calculations for generator 2
	local gen2_volt = (28.5 - gen2_amp / 100) * eng2_work * DC  -- calculate voltage of generator depending on it's load and engine work
	if gen2_fail then gen2_volt = 0 end -- check failure
	set(gen2_volt_bus, gen2_volt) -- set result

	-- calculations for generator 3
	local gen3_volt = (28.5 - gen3_amp / 100) * eng3_work * DC  -- calculate voltage of generator depending on it's load and engine work
	if gen3_fail then gen3_volt = 0 end -- check failure
	set(gen3_volt_bus, gen3_volt) -- set result	

	
	-- set simulator's generators status
	if gen1_volt * get(gen1_on_bus) > 0 then 
		set(sim_gen1_on, 1)
	else 
		set(sim_gen1_on, 0)
	end
	
	if gen2_volt * get(gen2_on_bus) > 0 then 
		set(sim_gen2_on, 1)
	else 
		set(sim_gen2_on, 0)
	end	
	
	if gen3_volt * get(gen3_on_bus) > 0 then 
		set(sim_gen3_on, 1)
	else
		set(sim_gen3_on, 0)
	end

	
end
