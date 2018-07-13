-- this is the logic for manipulate gears movements and its failures
size = {2048, 2048}

-- define property table
-- landing gears
defineProperty("gear1_deflect", globalPropertyf("sim/flightmodel2/gear/tire_vertical_deflection_mtr[0]"))  -- vertical deflection of front gear
defineProperty("gear2_deflect", globalPropertyf("sim/flightmodel2/gear/tire_vertical_deflection_mtr[1]"))  -- vertical deflection of left gear
defineProperty("gear3_deflect", globalPropertyf("sim/flightmodel2/gear/tire_vertical_deflection_mtr[2]"))  -- vertical deflection of right gear

defineProperty("gear1_deploy", globalPropertyf("sim/aircraft/parts/acf_gear_deploy[0]"))  -- deploy of front gear
defineProperty("gear2_deploy", globalPropertyf("sim/aircraft/parts/acf_gear_deploy[1]"))  -- deploy of right gear
defineProperty("gear3_deploy", globalPropertyf("sim/aircraft/parts/acf_gear_deploy[2]"))  -- deploy of left gear

-- hydraulic system
defineProperty("hydro_press", globalPropertyf("sim/custom/xap/hydro/main_press")) -- pressure in main system. initial 120 kg per square sm. maximum 160.
defineProperty("emerg_press", globalPropertyf("sim/custom/xap/hydro/emerg_press")) -- pressure in emergency system. initial 120 kg per square sm. maximum 160.
defineProperty("gear_valve", globalPropertyi("sim/custom/xap/hydro/gear_valve")) -- position of gear valve for gydraulic calculations and animations.
defineProperty("gear_valve_emerg", globalPropertyi("sim/custom/xap/hydro/gear_valve_emerg")) -- position of gear valve for gydraulic calculations and animations maximum 160.
defineProperty("gear_valve_emerg_cap", globalPropertyi("sim/custom/xap/hydro/gear_valve_emerg_cap")) -- position of gear valve cap for gydraulic calculations and animations maximum 160.

-- enviroment
defineProperty("airspeed", globalPropertyf("sim/flightmodel/position/indicated_airspeed"))  -- knots indicated air speed
defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames
defineProperty("flight_time", globalPropertyf("sim/time/total_running_time_sec")) -- sim time
defineProperty("G", globalPropertyf("sim/flightmodel2/misc/gforce_normal")) -- G overload
defineProperty("sim_slip", globalPropertyf("sim/flightmodel/misc/slip"))  -- slip

-- failures
defineProperty("retract1_fail", globalPropertyi("sim/operation/failures/rel_lagear1")) -- fail of retract gear
defineProperty("retract2_fail", globalPropertyi("sim/operation/failures/rel_lagear2")) -- fail of retract gear
defineProperty("retract3_fail", globalPropertyi("sim/operation/failures/rel_lagear3")) -- fail of retract gear
defineProperty("actuator_fail", globalPropertyi("sim/operation/failures/rel_gear_act")) -- actuator fail. bugs workaround


defineProperty("set_real_gears", globalPropertyi("sim/custom/xap/set/real_gears")) --  gears can fail in overspeed

-- power
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("gear_cc", globalPropertyf("sim/custom/xap/hydro/gear_cc"))
defineProperty("AZS_gears_main_sw", globalPropertyi("sim/custom/xap/azs/AZS_gears_main_sw")) -- AZS main gear system
defineProperty("AZS_gears_emerg_sw", globalPropertyi("sim/custom/xap/azs/AZS_gears_emerg_sw")) -- AZS emerg gear system

-- commands
gear_command_up = findCommand("sim/flight_controls/landing_gear_up")
gear_command_down = findCommand("sim/flight_controls/landing_gear_down")
gear_toggle = findCommand("sim/flight_controls/landing_gear_toggle")


local switch_sound = loadSample('Custom Sounds/metal_switch.wav')
local cap_sound = loadSample('Custom Sounds/cap.wav')
local gear_move1 = loadSample('Custom Sounds/gear_move.wav')
local gear_move2 = loadSample('Custom Sounds/gear_move.wav')
local gear_move3 = loadSample('Custom Sounds/gear_move.wav')
local gear_close1 = loadSample('Custom Sounds/gear_close.wav')
local gear_close2 = loadSample('Custom Sounds/gear_close.wav')
local gear_close3 = loadSample('Custom Sounds/gear_close.wav')

local direction = 0
local power = 1
local power_emerg = 1
local use_emerg = false


function gear_up_handler(phase)
	if 0 == phase then
		if not use_emerg then
			if get(gear_valve) ~= -1 then
				set(gear_valve, -1)
				direction = -power
			else
				set(gear_valve, 0)
				direction = 0
			end
		else
			set(gear_valve, 0)
			direction = 0
		end
	end
return 0
end

function gear_down_handler(phase)
	if 0 == phase then
		if not use_emerg then
			if get(gear_valve) ~= 1 then
				set(gear_valve, 1)
				direction = power
			else
				set(gear_valve, 0)
				direction = 0
			end
		else
			set(gear_valve, 0)
			direction = power_emerg
		end
	end
return 0
end

function gear_toggle_handler(phase)
	if 0 == phase then
		local a = get(gear_valve)
		if a == 0 then
			if get(gear1_deploy) > 0.5 then a = -1
			elseif get(gear1_deploy) <= 0.5 then a = 1 end
		elseif a == 1 then a = -1
		else a = 1
		end
		set(gear_valve, a)
		direction = a * power
	end
return 0
end

registerCommandHandler(gear_command_up, 0, gear_up_handler)
registerCommandHandler(gear_command_down, 0, gear_down_handler)
registerCommandHandler(gear_toggle, 0, gear_toggle_handler)



-- local variables
local passed = 0
local lock1 = true  -- locks for gears
local lock2 = true
local lock3 = true
local lock1_last = lock1
local lock2_last = lock2
local lock3_last = lock3

local pos1_last = get(gear1_deploy)
local pos2_last = get(gear2_deploy)
local pos3_last = get(gear3_deploy)

local last_gear_deploy1 = get(gear1_deploy)
local last_gear_deploy2 = get(gear2_deploy)
local last_gear_deploy3 = get(gear3_deploy)

local gear1_crash = false   -- variables for gear crash calculations
local gear2_crash = false
local gear3_crash = false

-- constants
local GEAR_SPEED = 1 / 4 -- per second
local HYDRO = 0.006
local switcher_pushed = false

-- every frame calculations
function update()

	local pos1 = get(gear1_deploy)  -- positions of gears
	local pos2 = get(gear2_deploy)
	local pos3 = get(gear3_deploy)

	passed = get(frame_time)

	-- calculate power
	if get(DC_27_volt) > 21 and get(AZS_gears_main_sw) == 1 then power = 1 else power = 0 end
	if get(DC_27_volt) > 21 and get(AZS_gears_emerg_sw) == 1 then power_emerg = 1 else power_emerg = 0 end

	local real = get(set_real_gears) == 1
-- all calculations produced only during sim work
if passed > 0 then

	local G_coef = 0.3 -- get(hydro_press) * 0.004
	local A_coef = 0.001
	local slip = get(sim_slip)
	local main_hydro = get(hydro_press)
	local emerg_hydro = get(emerg_press)
	local A_spd = get(airspeed)
	local G_force = get(G)
	-- calculate if gears can retract depending on autoblock
	local retract = false
	if get(gear2_deflect) < 0.01 then retract = true else retract = false end

	-- set emerg commands
	if get(gear_valve_emerg) == 1 then
		use_emerg = true
		commandBegin(gear_command_down)
	end

	--gears crash
	if get(gear1_deflect) > 0.60 then gear1_crash = true end
	if get(gear2_deflect) > 0.70 then gear2_crash = true end
	if get(gear3_deflect) > 0.70 then gear3_crash = true end


	-- calculations for gear 1
	if not lock1 and (not gear1_crash or not real) and retract and get(retract1_fail) < 6 then
		-- calculate position
		if not use_emerg then
			pos1 = pos1_last + 1.2 * GEAR_SPEED * (direction * main_hydro * HYDRO + G_force * math.cos(math.pi * pos1_last / 2) * G_coef + A_spd * math.sin(math.pi * pos1_last / 2) * A_coef + math.random() * 0.1) * passed
			if not isSamplePlaying(gear_move1) and pos1 > 0 and pos1 < 1 then playSample(gear_move1, 1) end
			setSampleGain(gear_move1, main_hydro * 8)
			setSamplePitch(gear_move1, power * main_hydro * 10)
		else
			pos1 = pos1_last + 1.2 * GEAR_SPEED * (direction * emerg_hydro * HYDRO * 0.5 + G_force * math.cos(math.pi * pos1_last / 2) * G_coef + A_spd * math.sin(math.pi * pos1_last / 2) * A_coef + math.random() * 0.1) * passed
			if not isSamplePlaying(gear_move1) and pos1 > 0 and pos1 < 1 then playSample(gear_move1, 1) end
			setSampleGain(gear_move1, emerg_hydro * 8)
			setSamplePitch(gear_move1, power * emerg_hydro * 8)
		end
		-- limit positions and close lock when reached
		if pos1 < 0 then
			stopSample(gear_move1)
			pos1 = 0
			lock1 = true
		elseif pos1 > 1 then
			stopSample(gear_move1)
			pos1 = 1
			lock1 = true
		end
	end

	-- calculate crash position
	if gear1_crash and real then
		stopSample(gear_move1)
		if pos1 > 0.2 then pos1 = pos1 - passed / 2 end
		if pos1 < 0.2 then
			pos1 = 0.2
			gear1_crash = false
		end
	end

	-- calculations for gear 2
	if not lock2 and (not gear2_crash or not real) and retract and get(retract2_fail) < 6 then
		-- calculate position
		if not use_emerg then
			pos2 = pos2_last + GEAR_SPEED * (direction * main_hydro * HYDRO + G_force * math.cos(math.pi * pos2_last / 2) * G_coef + A_spd * math.sin(math.pi * pos2_last / 2) * A_coef * (slip * 0.5) + math.random() * 0.1) * passed
			if not isSamplePlaying(gear_move2) and pos2 > 0 and pos2 < 1 then playSample(gear_move2, 1) end
			setSampleGain(gear_move2, main_hydro * 8)
			setSamplePitch(gear_move2, power * main_hydro * 10)
		else
			pos2 = pos2_last + GEAR_SPEED * (direction * emerg_hydro * HYDRO * 0.5 + G_force * math.cos(math.pi * pos2_last / 2) * G_coef + A_spd * math.sin(math.pi * pos2_last / 2) * A_coef * (slip * 0.5) + math.random() * 0.1) * passed
			if not isSamplePlaying(gear_move2) and pos2 > 0 and pos2 < 1 then playSample(gear_move2, 1) end
			setSampleGain(gear_move2, emerg_hydro * 8)
			setSamplePitch(gear_move2, power * emerg_hydro * 10)
		end
		-- limit positions and close lock when reached
		if pos2 < 0 then
			stopSample(gear_move2)
			pos2 = 0
			lock2 = true
		elseif pos2 > 1 then
			stopSample(gear_move2)
			pos2 = 1
			lock2 = true
		end
	end

	-- calculate crash position
	if gear2_crash and real then
		stopSample(gear_move2)
		if pos2 > 0.3 then pos2 = pos2 - passed / 2 end
		if pos1 < 0.3 then
			pos2 = 0.3
			gear2_crash = false
		end
	end

	-- calculations for gear 3
	if not lock3 and (not gear3_crash or not real) and retract and get(retract3_fail) < 6 then
		-- calculate position
		if not use_emerg then
			pos3 = pos3_last + GEAR_SPEED * (direction * main_hydro * HYDRO + G_force * math.cos(math.pi * pos3_last / 2) * G_coef + A_spd * math.sin(math.pi * pos3_last / 2) * A_coef * (-slip * 0.5) + math.random() * 0.1) * passed
			if not isSamplePlaying(gear_move3) and pos3 > 0 and pos3 < 1 then playSample(gear_move3, 1) end
			setSampleGain(gear_move3, main_hydro * 8)
			setSamplePitch(gear_move3, power * main_hydro * 10)
		else
			pos3 = pos3_last + GEAR_SPEED * (direction * emerg_hydro * HYDRO * 0.5 + G_force * math.cos(math.pi * pos3_last / 2) * G_coef + A_spd * math.sin(math.pi * pos3_last / 2) * A_coef * (-slip * 0.5) + math.random() * 0.1) * passed
			if not isSamplePlaying(gear_move3) and pos3 > 0 and pos3 < 1 then playSample(gear_move3, 1) end
			setSampleGain(gear_move3, emerg_hydro * 8)
			setSamplePitch(gear_move3, power * emerg_hydro * 10)
		end
		-- limit positions and close lock when reached
		if pos3 < 0 then
			stopSample(gear_move3)
			pos3 = 0
			lock3 = true
		elseif pos3 > 1 then
			stopSample(gear_move3)
			pos3 = 1
			lock3 = true
		end
	end

	-- calculate crash position
	if gear3_crash and real then
		stopSample(gear_move3)
		if pos3 > 0.3 then pos3 = pos3 - passed / 2 end
		if pos3 < 0.3 then
			pos3 = 0.3
			gear3_crash = false
		end
	end
	-- limit gear positions
	if pos1 > 1 then pos1 = 1 end
	if pos1 < 0 then pos1 = 0 end
	if pos2 > 1 then pos2 = 1 end
	if pos2 < 0 then pos2 = 0 end
	if pos3 > 1 then pos3 = 1 end
	if pos3 < 0 then pos3 = 0 end

	-- calculate locks
	lock1 = direction < 1 and pos1 < 0.03 or direction > -1 and pos1 > 0.97
	lock2 = direction < 1 and pos2 < 0.03 or direction > -1 and pos2 > 0.97
	lock3 = direction < 1 and pos3 < 0.03 or direction > -1 and pos3 > 0.97

	-- play lock sounds
	if lock1_last ~= lock1 then playSample(gear_close1, 0) end
	if lock2_last ~= lock2 then playSample(gear_close2, 0) end
	if lock3_last ~= lock3 then playSample(gear_close3, 0) end

	-- stop playing sounds
	if lock1 or direction == 0 then stopSample(gear_move1) end
	if lock2 or direction == 0 then stopSample(gear_move2) end
	if lock3 or direction == 0 then stopSample(gear_move3) end

	lock1_last = lock1
	lock2_last = lock2
	lock3_last = lock3

	-- bugs workaround
	local sim_pos1 = get(gear1_deploy)
	local sim_pos2 = get(gear2_deploy)
	local sim_pos3 = get(gear3_deploy)
	-- if all gears are in max or min position and direcion lead further - make them stop and set valve to neutral pos
	if sim_pos1 == 0 and sim_pos2 == 0 and sim_pos3 == 0 and direction == -1 or
	   sim_pos1 == 1 and sim_pos2 == 1 and sim_pos3 == 1 and direction == 1 then
		direction = 0
		set(gear_valve, 0)
		--set(gear_valve_emerg, 0)
		--set(gear_valve_emerg_cap, 0)
	end


	-- set results
	if get(retract1_fail) < 6 or (gear1_crash and real) then set(gear1_deploy, pos1) end
	if get(retract2_fail) < 6 or (gear2_crash and real) then set(gear2_deploy, pos2) end
	if get(retract3_fail) < 6 or (gear3_crash and real) then set(gear3_deploy, pos3) end


	-- landing gear deploy failure
	local ias = get(airspeed) * 1.852
	if ias > 450 and real then
		if pos1 > pos1_last and pos1_last > 0.7 then set(retract1_fail, 6) end
		if pos2 > pos2_last and pos2_last > 0.7 then set(retract2_fail, 6) end
		if pos3 > pos3_last and pos3_last > 0.7 then set(retract3_fail, 6) end
	end




	pos1_last = pos1
	pos2_last = pos2
	pos3_last = pos3

end

end

components = {


	---------------
	-- switchers --
	---------------

	-- gears switch up
    clickable {
        position = {1002, 709, 19, 9},  -- search and set right

       cursor = {
            x = 16,
            y = 32,
            width = 16,
            height = 16,
            shape = loadImage("clickable.png")
        },

       	onMouseClick = function()
			if not switcher_pushed then
				playSample(switch_sound, 0)
				commandBegin(gear_command_up)
				switcher_pushed = true
			end
			use_emerg = false

			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			use_emerg = false
			commandEnd(gear_command_up)
		end,
    },

	-- gears switch down
    clickable {
        position = {1002, 719, 19, 9},  -- search and set right

       cursor = {
            x = 16,
            y = 32,
            width = 16,
            height = 16,
            shape = loadImage("clickable.png")
        },

       	onMouseClick = function()
			if not switcher_pushed then
				playSample(switch_sound, 0)
				commandBegin(gear_command_down)
				switcher_pushed = true
			end
			use_emerg = false

			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			use_emerg = false
			commandEnd(gear_command_down)
		end,
    },

    -- emerg gear valve cap
    switch {
        position = {1081, 468, 60, 120 },
        state = function()
            return get(gear_valve_emerg_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(gear_valve_emerg_cap) ~= 0 then
					set(gear_valve_emerg_cap, 0)
				else
					set(gear_valve_emerg_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- emerg gear switch
    switch {
        position = {982, 710, 19, 19 },
        state = function()
            return get(gear_valve_emerg) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and get(gear_valve_emerg_cap) == 1 then
				playSample(switch_sound, 0)
				if get(gear_valve_emerg) ~= 0 then
					set(gear_valve_emerg, 0)
					use_emerg = false
					commandEnd(gear_command_down)
				else
					set(gear_valve_emerg, 1)
					use_emerg = true
					commandBegin(gear_command_down)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },



}
