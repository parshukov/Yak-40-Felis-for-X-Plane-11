-- this is AP logic with calculations

defineProperty("res_roll_1", globalPropertyf("sim/custom/xap/gauges/roll_1")) -- current roll
defineProperty("res_pitch_1", globalPropertyf("sim/custom/xap/gauges/pitch_1")) -- current pitch
defineProperty("res_roll_2", globalPropertyf("sim/custom/xap/gauges/roll_3")) -- current roll
defineProperty("res_pitch_2", globalPropertyf("sim/custom/xap/gauges/pitch_3")) -- current pitch
defineProperty("GMK_curse_ap", globalPropertyf("sim/custom/xap/gauges/GMK_curse_ap")) -- calculated course for AP

defineProperty("power_sw", globalPropertyi("sim/custom/xap/AP/power_sw")) -- power switcher
defineProperty("pitch_sw", globalPropertyi("sim/custom/xap/AP/pitch_sw")) -- pitch switcher
defineProperty("pitch_comm", globalPropertyi("sim/custom/xap/AP/pitch_comm")) -- pitch command handle
defineProperty("roll_comm", globalPropertyi("sim/custom/xap/AP/roll_comm")) -- roll command handle
defineProperty("ap_on_but", globalPropertyi("sim/custom/xap/AP/ap_on_but")) -- turn ON button
defineProperty("ap_alt_but", globalPropertyi("sim/custom/xap/AP/ap_alt_but")) -- hold alt button

defineProperty("vvi", globalPropertyf("sim/flightmodel/position/vh_ind_fpm"))
defineProperty("slip", globalPropertyf("sim/cockpit2/gauges/indicators/slip_deg"))

defineProperty("msl_alt", globalPropertyf("sim/flightmodel/position/elevation"))  -- barometric alt. maybe in feet, maybe in meters.
defineProperty("baro_press", globalPropertyf("sim/weather/barometer_sealevel_inhg"))  -- pressire at sea level in.Hg

defineProperty("AZS_agd_1_sw", globalPropertyi("sim/custom/xap/azs/AZS_agd_1_sw")) -- AGD 1 switch
defineProperty("AZS_agd_3_sw", globalPropertyi("sim/custom/xap/azs/AZS_agd_3_sw")) -- AGD 3 switch
defineProperty("AZS_GMK_sw", globalPropertyi("sim/custom/xap/azs/AZS_GMK_sw")) -- AZS switcher
defineProperty("AZS_hydrosys_sw", globalPropertyi("sim/custom/xap/azs/AZS_hydrosys_sw")) -- AZS for hydraulic system
defineProperty("AZS_AP_sw", globalPropertyi("sim/custom/xap/azs/AZS_AP_sw")) --AZS for AutoPilot
defineProperty("AZS_bspk_sw", globalPropertyi("sim/custom/xap/azs/AZS_bspk_sw")) -- BSPK system
defineProperty("AZS_stab_main_sw", globalPropertyi("sim/custom/xap/azs/AZS_stab_main_sw")) -- AZS main stab system

defineProperty("inv_PT1000", globalPropertyi("sim/custom/xap/power/inv_PT1000"))  -- inverter for 36v bus
defineProperty("inv_PT500", globalPropertyi("sim/custom/xap/power/inv_PT500")) -- inverter for 36v bus
defineProperty("bspk_err", globalPropertyi("sim/custom/xap/gauges/bspk_err")) -- bspk error

defineProperty("sim_ap_mode", globalPropertyf("sim/cockpit/autopilot/autopilot_mode"))

-- results
defineProperty("ap_need_pitch", globalPropertyf("sim/custom/xap/AP/ap_need_pitch")) -- needed pitch
defineProperty("ap_need_roll", globalPropertyf("sim/custom/xap/AP/ap_need_roll")) -- needed roll
defineProperty("ap_hdg_diff", globalPropertyf("sim/custom/xap/AP/ap_hdg_diff")) -- heading diff to correct
defineProperty("yaw_spd", globalPropertyf("sim/custom/xap/AP/ap_yaw_spd")) -- current yaw speed deg/sec

defineProperty("ap_works_roll", globalPropertyi("sim/custom/xap/AP/ap_works_roll")) -- autopilot has control over roll and hdg
defineProperty("ap_works_pitch", globalPropertyi("sim/custom/xap/AP/ap_works_pitch")) -- autopilot has control over pitch and stab

defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames

defineProperty("ap_cc", globalPropertyf("sim/custom/xap/AP/ap_cc")) -- AP current consumption


-- engines work
defineProperty("N1", globalPropertyf("sim/flightmodel/engine/ENGN_N1_[1]"))   
defineProperty("N2", globalPropertyf("sim/flightmodel/engine/ENGN_N1_[0]"))
defineProperty("N3", globalPropertyf("sim/flightmodel/engine/ENGN_N1_[2]"))

-- fail sources
defineProperty("joy_pitch", globalPropertyf("sim/cockpit2/controls/yoke_pitch_ratio")) -- pitch position of joytick
defineProperty("joy_roll", globalPropertyf("sim/cockpit2/controls/yoke_roll_ratio")) -- roll position of joystick
defineProperty("joy_yaw", globalPropertyf("sim/cockpit2/controls/yoke_heading_ratio")) -- yaw position of joystick

defineProperty("ail_servo", globalPropertyi("sim/operation/failures/rel_servo_ailn"))  -- aileron trim fail
defineProperty("elev_servo", globalPropertyi("sim/operation/failures/rel_servo_elev"))  -- elevator trim fail
defineProperty("rudd_serv", globalPropertyi("sim/operation/failures/rel_servo_rudd"))  -- rudder trim fail

-- lamps
defineProperty("ap_ready_lit", globalPropertyi("sim/custom/xap/AP/ap_ready_lit")) -- autopilot is ready to work
defineProperty("ap_on_lit", globalPropertyi("sim/custom/xap/AP/ap_on_lit")) -- autopilot is working
defineProperty("ap_alt_lit", globalPropertyi("sim/custom/xap/AP/ap_alt_lit")) -- autopilot is working and holding altitude

defineProperty("ap_force_fail", globalPropertyi("sim/custom/xap/AP/ap_force_fail")) -- autopilot is sencing forse
defineProperty("ap_fail_roll", globalPropertyi("sim/custom/xap/AP/ap_fail_roll")) -- autopilot AP is OFF on roll channel due to failure or overforce by pilot
defineProperty("ap_fail_pitch", globalPropertyi("sim/custom/xap/AP/ap_fail_pitch")) -- autopilot AP is OFF on pitch channel due to failure or overforce by pilot
defineProperty("ap_fail", globalPropertyi("sim/custom/xap/AP/ap_fail")) -- autopilot is off by fail

--------------------------
local apoff_sound = loadSample('Custom Sounds/bell.wav')-- autopilot off sound
------------------------------------------------------
local saved_heading = get(GMK_curse_ap) -- this heading AP will hold
local heading_last = get(GMK_curse_ap)

local pitch_mode = 0 -- 0 = off, 1 = pitch, 2 = alt
local comm_pitch = (get(res_pitch_1) + get(res_pitch_2)) * 0.5
local alt_to_hold = 500 -- saved altitude for AP tp hold it
local alt_diff_last = 0
local pitch_step = 0.17
local pitch_need = 0

local power_mode = 0 -- 0 = off, 1 = standby, 2 = work
local power_counter = 0

local roll_force_counter = 0
local pitch_force_counter = 0
local roll_fail = false
local pitch_fail = false
local not_loaded = true
local time_counter = 0

-- function for calculating roll, depending on curse difference between needed and actual curse
function calc_roll(curse_delta, norm_delta, max_roll)
	-- normalise delta. on delta bigger then norm_delta - bank will be maximal = max_roll
	local delta = curse_delta / norm_delta
	if delta > 1 then delta = 1
	elseif delta < -1 then delta = -1 end

	-- return result
	return max_roll * delta
end


function update()
	
	if get(sim_ap_mode) > 1 then set(sim_ap_mode, 1) end -- limit sim autopilot mode to flight dirctor. we don't use a default autopilot.
	
	local passed = get(frame_time)
	-- initial switchers values
	time_counter = time_counter + passed
	if get(N1) < 10 and get(N2) < 10 and get(N3) < 10 and time_counter > 0.3 and time_counter < 0.4 and not_loaded then
		set(power_sw, 0)
		set(pitch_sw, 0)
		not_loaded = false
	end	
	------------------
	-- power logic
	
	-- AP will work if several systems are works too
	local power = get(AZS_agd_1_sw) == 1 and get(AZS_agd_3_sw) == 1 and get(AZS_GMK_sw) == 1 and get(AZS_hydrosys_sw) == 1 and get(AZS_AP_sw) == 1
	power = power and get(AZS_bspk_sw) == 1 and get(AZS_stab_main_sw) == 1 and get(inv_PT1000) == 1 and get(inv_PT500) == 1 and get(bspk_err) == 0
	power = power and get(power_sw) == 1
	
	-- AP will be ready after some time
	if not power then
		power_mode = 0
		power_counter = 0
	else
		if get(ail_servo) < 6 and get(rudd_serv) < 6 and get(elev_servo) < 6 then
			power_counter = power_counter + passed
		elseif power_counter > 0 then power_counter = power_counter - passed end
		if power_counter > 10 and power_mode == 0 then power_mode = 1
		elseif power_counter > 10 and power_mode == 1 and get(ap_on_but) == 1 then power_mode = 2 end
	end
	
	-- set AP modes
	if power_mode == 2 then
		set(ap_cc, 20)
		-- check roll work
		if get(ail_servo) < 6 and get(rudd_serv) < 6 and not roll_fail then
			set(ap_works_roll, 1)
		else
			set(ap_works_roll, 0)
		end
		 -- check pitch work
		if get(pitch_sw) == 1 and get(elev_servo) < 6 and not pitch_fail then
			set(ap_works_pitch, 1)
			if get(ap_alt_but) == 1 then pitch_mode = 2 end
			if get(pitch_comm) ~= 0 or pitch_mode == 0 then pitch_mode = 1 end
		else
			pitch_mode = 0
			set(ap_works_pitch, 0)
		end
		
	else
		if power_mode == 1 then set(ap_cc, 5) else set(ap_cc, 0) end
		pitch_mode = 0
		set(ap_works_roll, 0)
		set(ap_works_pitch, 0)
		roll_fail = false
		pitch_fail = false
	end
	
	-- check forces
	if (math.abs(get(joy_roll)) > 0.3 or get(ail_servo) == 6 or get(rudd_serv) == 6) and roll_force_counter < 2.5 and power_mode > 0 then roll_force_counter = roll_force_counter + passed
	elseif roll_force_counter > 0 then roll_force_counter = roll_force_counter - passed end
	
	if (math.abs(get(joy_pitch)) > 0.3 or get(elev_servo) == 6) and pitch_force_counter < 2.5 and get(pitch_sw) == 1 and power_mode > 0 then pitch_force_counter = pitch_force_counter + passed
	elseif pitch_force_counter > 0 then pitch_force_counter = pitch_force_counter - passed end
	
	if power_mode == 2 and roll_force_counter > 2 then roll_fail = true end
	if power_mode == 2 and pitch_force_counter > 2 then pitch_fail = true end
	
	
	if roll_fail or pitch_fail then set(ap_fail, 1) else set(ap_fail, 0) end
	
	-- AP lamps
	if power then
		if power_mode == 1 then
			set(ap_ready_lit, 1)
			set(ap_on_lit, 0)
			set(ap_alt_lit, 0)
			set(ap_force_fail, 0)
			set(ap_fail_roll, 0)
			set(ap_fail_pitch, 0)
		elseif power_mode == 2 then
			set(ap_ready_lit, 0)
			set(ap_on_lit, 1)
			if pitch_mode == 2 then set(ap_alt_lit, 1) else set(ap_alt_lit, 0) end
			if math.abs(get(joy_roll)) > 0.1 or (math.abs(get(joy_pitch)) > 0.1 and get(pitch_sw) == 1) or roll_fail or pitch_fail then
				set(ap_force_fail, 1)
			else set(ap_force_fail, 0) end
			if roll_fail then set(ap_fail_roll, 1) end
			if pitch_fail then set(ap_fail_pitch, 1) end
		else
			set(ap_ready_lit, 0)
			set(ap_on_lit, 0)
			set(ap_alt_lit, 0)
			set(ap_force_fail, 0)
			set(ap_fail_roll, 0)
			set(ap_fail_pitch, 0)		
		end
		
		
	else
		set(ap_ready_lit, 0)
		set(ap_on_lit, 0)
		set(ap_alt_lit, 0)
		set(ap_force_fail, 0)
		set(ap_fail_roll, 0)
		set(ap_fail_pitch, 0)		
	end
	
	
	
	
	-------------
	-- pitch logic

	-- calculate current barometric altitude in meters
	local msl = get(msl_alt) * 3.28083 -- in feet
	local real_alt = (msl + (29.92 - get(baro_press)) * 1000) * 0.3048 -- in meters
	
	-- calculate pitch
	if pitch_mode == 1 then	-- direct command mode. pitch controlled by knob
		comm_pitch = comm_pitch + get(pitch_comm) * passed * 0.9
		if comm_pitch > 15 then comm_pitch = 15
		elseif comm_pitch < -15 then comm_pitch = -15 end
		
		pitch_need = comm_pitch 
		alt_to_hold = real_alt
	elseif pitch_mode == 2 then -- altitude hold mode. AP remebmer pitch also
		comm_pitch = (get(res_pitch_1) + get(res_pitch_2)) * 0.5
		
		-- calculate difference
		local alt_diff = real_alt - alt_to_hold
		local spd_coef = math.min(1, math.abs(alt_diff / 100)) * 5	
		-- calculate approach movement to given track
		if math.abs(alt_diff) - math.abs(alt_diff_last) > 0 and alt_diff > 25 then -- climbing from hold_alt. above
			pitch_need = pitch_need - pitch_step * 2 * passed
		elseif math.abs(alt_diff) - math.abs(alt_diff_last) < 0 and alt_diff > 25 then -- descending to hold_alt. above
			if passed > 0 then 
				if (alt_diff - alt_diff_last) / passed > -spd_coef then 
					pitch_need = pitch_need - pitch_step * 1 * passed
				elseif (alt_diff - alt_diff_last) / passed < -spd_coef then
					pitch_need = pitch_need + pitch_step * 1 * passed
				end
			end
		elseif math.abs(alt_diff) - math.abs(alt_diff_last) > 0 and alt_diff < -25 then -- descending from hold_alt. below
			pitch_need = pitch_need + pitch_step * 2 * passed
		elseif math.abs(alt_diff) - math.abs(alt_diff_last) < 0 and alt_diff < -25 then -- climbing to hold_alt. below
			if passed > 0 then 
				if (alt_diff - alt_diff_last) / passed < spd_coef then 
					pitch_need = pitch_need + pitch_step * 1 * passed
				elseif (alt_diff - alt_diff_last) / passed > spd_coef then
					pitch_need = pitch_need - pitch_step * 1 * passed
				end
			end	
		elseif math.abs(alt_diff) - math.abs(alt_diff_last) > 0 and alt_diff > 10 then -- climbing from hold_alt. above
			pitch_need = pitch_need - pitch_step * 1 * passed
		elseif math.abs(alt_diff) - math.abs(alt_diff_last) < 0 and alt_diff > 10 then -- descending to hold_alt. above
			if passed > 0 then 
				if (alt_diff - alt_diff_last) / passed > -spd_coef then 
					pitch_need = pitch_need - pitch_step * 0.5 * passed
				elseif (alt_diff - alt_diff_last) / passed < -spd_coef then
					pitch_need = pitch_need + pitch_step * 0.5 * passed
				end
			end
		elseif math.abs(alt_diff) - math.abs(alt_diff_last) > 0 and alt_diff < -10 then -- descending from hold_alt. below
			pitch_need = pitch_need + pitch_step * 1 * passed
		elseif math.abs(alt_diff) - math.abs(alt_diff_last) < 0 and alt_diff < -10 then -- climbing to hold_alt. below
			if passed > 0 then 
				if (alt_diff - alt_diff_last) / passed < spd_coef then 
					pitch_need = pitch_need + pitch_step * 0.5 * passed
				elseif (alt_diff - alt_diff_last) / passed > spd_coef then
					pitch_need = pitch_need - pitch_step * 0.5 * passed
				end
			end	
		elseif math.abs(alt_diff) - math.abs(alt_diff_last) > 0 and alt_diff > 0 then -- climbing from hold_alt. above
			pitch_need = pitch_need - pitch_step * 0.2 * passed
		elseif math.abs(alt_diff) - math.abs(alt_diff_last) < 0 and alt_diff > 0 then -- descending to hold_alt. above
			if passed > 0 then 
				if (alt_diff - alt_diff_last) / passed > -spd_coef then 
					pitch_need = pitch_need - pitch_step * 0.1 * passed
				elseif (alt_diff - alt_diff_last) / passed < -spd_coef then
					pitch_need = pitch_need + pitch_step * 0.1 * passed
				end
			end
		elseif math.abs(alt_diff) - math.abs(alt_diff_last) > 0 and alt_diff < 0 then -- descending from hold_alt. below
			pitch_need = pitch_need + pitch_step * 0.2 * passed
		elseif math.abs(alt_diff) - math.abs(alt_diff_last) < 0 and alt_diff < 0 then -- climbing to hold_alt. below
			if passed > 0 then 
				if (alt_diff - alt_diff_last) / passed < spd_coef then 
					pitch_need = pitch_need + pitch_step * 0.1 * passed
				elseif (alt_diff - alt_diff_last) / passed > spd_coef then
					pitch_need = pitch_need - pitch_step * 0.1 * passed
				end
			end				
		else
			--pitch_need = (get(res_pitch_1) + get(res_pitch_2)) * 0.5 -- think about some fix for stable pitch
		end
		
		alt_diff_last = alt_diff
		
	else -- AP is off, but remember current position
		comm_pitch = (get(res_pitch_1) + get(res_pitch_2)) * 0.5
		pitch_need = comm_pitch
		alt_to_hold = real_alt
	end
		
	if pitch_need > 15 then pitch_need = 15
	elseif pitch_need < -15 then pitch_need = -15 end
	
	set(ap_need_pitch, pitch_need)
	
	-------------
	-- roll logic
	local comm_roll = get(roll_comm)
	local hdg = get(GMK_curse_ap)
	if power_mode ~= 2 or comm_roll ~= 0 then 
		saved_heading = hdg -- save new heading for hold it in future
		set(ap_need_roll, comm_roll)
	else
		set(ap_need_roll, calc_roll(-hdg + saved_heading, 15, 10)) -- make AP to hold course by GMK
	end
	
	
	
	
	-----------------
	-- heading logic
	--[[
	local hdg_diff = 0	
	local hdg_spd = 0
	local hdg = get(GMK_curse_ap)
	if power_mode ~= 2 then saved_heading = hdg end -- save new heading for hold it in future
	if comm_roll ~= 0 then 
		hdg_diff = 0 -- diff = side slip
		saved_heading = hdg -- save new heading for hold it in future
		hdg_spd = -get(slip)
	else 
		hdg_diff = hdg - saved_heading
		if passed > 0 then hdg_spd = (hdg - heading_last) / passed
		else hdg_spd = 0 end
	end
	
	heading_last = hdg
	
	
	-- limit hdg diff
	if hdg_diff > 180 then hdg_diff = hdg_diff - 360
	elseif hdg_diff < -180 then hdg_diff = hdg_diff + 360 end
	
	if hdg_diff > 10 then hdg_diff = 10
	elseif hdg_diff < -10 then hdg_diff = -10 end
	
	set(ap_hdg_diff, hdg_diff)
	set(yaw_spd, hdg_spd)
	--]]
	set(ap_hdg_diff, 0)
	set(yaw_spd, -get(slip))

end


-- commands


-- hold AP
ap_hold_command = findCommand("sim/autopilot/servos_on")
local ap_hold = false
function ap_hold_handler(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if 1 == phase and (power_mode == 2 or ap_hold) then
		power_mode = 1
		ap_hold = true
	elseif ap_hold then
		power_mode = 2
		ap_hold = false
    else ap_hold = false
    end
return 0
end
registerCommandHandler(ap_hold_command, 0, ap_hold_handler)



-- turn off AP
ap_off_command = findCommand("sim/autopilot/fdir_servos_down_one")
function ap_off_handler(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if 0 == phase and power_mode == 2 then
		power_mode = 1
		playSample(apoff_sound, 0)
	end
return 0
end
registerCommandHandler(ap_off_command, 0, ap_off_handler)

-- turn ON AP
ap_on_command = findCommand("sim/autopilot/fdir_servos_up_one")
function ap_on_handler(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if 1 == phase then
		set(ap_on_but, 1)
	else
		set(ap_on_but, 0)
	end
return 0
end
registerCommandHandler(ap_on_command, 0, ap_on_handler)

-- left bank
ap_left_command = findCommand("sim/autopilot/override_left")
function ap_left_handler(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if 0 == phase then
		local a = get(roll_comm) - 5
		if a < -30 then a = -30 end
		set(roll_comm, a)
    end
return 0
end
registerCommandHandler(ap_left_command, 0, ap_left_handler)

-- right bank
ap_right_command = findCommand("sim/autopilot/override_right")
function ap_right_handler(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if 0 == phase then
		local a = get(roll_comm) + 5
		if a > 30 then a = 30 end
		set(roll_comm, a)
    end
return 0
end
registerCommandHandler(ap_right_command, 0, ap_right_handler)

-- pitch UP
ap_UP_command = findCommand("sim/autopilot/override_up")
function ap_UP_handler(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if 1 == phase then
		set(pitch_comm, 1)
    else set(pitch_comm, 0)
    end
return 0
end
registerCommandHandler(ap_UP_command, 0, ap_UP_handler)

-- pitch DOWN
ap_DOWN_command = findCommand("sim/autopilot/override_down")
function ap_DOWN_handler(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if 1 == phase then
		set(pitch_comm, -1)
    else set(pitch_comm, 0)
    end
return 0
end
registerCommandHandler(ap_DOWN_command, 0, ap_DOWN_handler)

-- alt hold mode
ap_alt_command = findCommand("sim/autopilot/altitude_hold")
function ap_alt_handler(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if 1 == phase then
		set(ap_alt_but, 1)
  	else set(ap_alt_but, 0)
   	end
return 0
end
registerCommandHandler(ap_alt_command, 0, ap_alt_handler)

-- AP power switcher
ap_power_command = findCommand("sim/autopilot/fdir_on")
function ap_power_handler(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if 0 == phase then
		set(power_sw, 1 - get(power_sw))
	end
return 0
end
registerCommandHandler(ap_power_command, 0, ap_power_handler)

-- AP pitch switcher
ap_pitch_command = findCommand("sim/autopilot/pitch_sync")
function ap_pitch_handler(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if 0 == phase then
		set(pitch_sw, 1 - get(pitch_sw))
	end
return 0
end
registerCommandHandler(ap_pitch_command, 0, ap_pitch_handler)