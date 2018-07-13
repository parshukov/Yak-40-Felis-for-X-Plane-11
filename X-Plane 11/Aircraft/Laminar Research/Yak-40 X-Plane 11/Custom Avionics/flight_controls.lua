-- this is the flight controls logic

-- sources
defineProperty("joy_pitch", globalPropertyf("sim/cockpit2/controls/yoke_pitch_ratio")) -- pitch position of joytick
defineProperty("joy_roll", globalPropertyf("sim/cockpit2/controls/yoke_roll_ratio")) -- roll position of joystick
defineProperty("joy_yaw", globalPropertyf("sim/cockpit2/controls/yoke_heading_ratio")) -- yaw position of joystick

defineProperty("pitch_trim", globalPropertyf("sim/custom/xap/control/pitch_trim")) -- virtual pitch trimmer. in Yak40 have range from -3 to +6 in degrees of stab.
defineProperty("roll_trim", globalPropertyf("sim/custom/xap/control/roll_trim")) -- virtual roll trimmer
defineProperty("yaw_trim", globalPropertyf("sim/custom/xap/control/yaw_trim")) -- virtual yaw trimmer

defineProperty("control_fix", globalPropertyi("sim/custom/xap/control/control_fix")) -- fix controls, so they cannot move. 1 = fix, 0 = released

defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time of frame

defineProperty("roll_sw", globalPropertyi("sim/custom/xap/control/roll_sw")) -- roll switcher position
defineProperty("yaw_sw", globalPropertyi("sim/custom/xap/control/yaw_sw")) -- roll switcher position
defineProperty("pitch_sw", globalPropertyi("sim/custom/xap/control/pitch_sw")) -- roll switcher position

-- power
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("control_cc", globalPropertyf("sim/custom/xap/control/control_cc")) -- cc

defineProperty("AZS_stab_main_sw", globalPropertyi("sim/custom/xap/azs/AZS_stab_main_sw")) -- AZS main stab system
defineProperty("AZS_stab_emerg_sw", globalPropertyi("sim/custom/xap/azs/AZS_stab_emerg_sw")) -- AZS main stab system
defineProperty("AZS_aileron_trim_sw", globalPropertyi("sim/custom/xap/azs/AZS_aileron_trim_sw")) -- AZS stab gear system
defineProperty("AZS_rudder_trim_sw", globalPropertyi("sim/custom/xap/azs/AZS_rudder_trim_sw")) -- AZS stab gear system

defineProperty("hydro_press", globalPropertyf("sim/custom/xap/hydro/main_press")) -- pressure in main system. initial 120 kg per square sm. maximum 160.
defineProperty("emerg_press", globalPropertyf("sim/custom/xap/hydro/emerg_press")) -- pressure in emergency system. initial 120 kg per square sm. maximum 160.

-- from AP
defineProperty("ap_roll_pos", globalPropertyf("sim/custom/xap/AP/ap_roll_pos")) -- position of roll axis from AP
defineProperty("ap_hdg_pos", globalPropertyf("sim/custom/xap/AP/ap_hdg_pos")) -- position of hdg axis from AP
defineProperty("ap_pitch_pos", globalPropertyf("sim/custom/xap/AP/ap_pitch_pos")) -- position of pitch axis from AP

-- results
defineProperty("elevator_trim", globalPropertyf("sim/cockpit2/controls/elevator_trim")) -- sim pitch trimmer
defineProperty("aileron_trim", globalPropertyf("sim/cockpit2/controls/aileron_trim")) -- sim roll trimmer
defineProperty("rudder_trim", globalPropertyf("sim/cockpit2/controls/rudder_trim")) -- sim yaw trimmer

defineProperty("pitch_anim", globalPropertyf("sim/custom/xap/control/pitch_anim")) -- animation of elevator

local PITCH_COEF = 0.2 -- set add of horisontal stab to elevator, add number per one degree
local PITCH_SPD = 5 -- speed of elevator
local ROLL_SPD = 7 -- speed of aileron
local YAW_SPD = 5 -- speed of rudder

local passed = get(frame_time) -- time variable

local last_pitch = 0 -- save last position
local last_roll = 0
local last_yaw = 0

local power_stab = 1
local power_ail = 1
local power_rudd = 1

local last_pitch_trimm = 0 -- save last position
local last_roll_trimm = 0
local last_yaw_trimm = 0

function update() -- every frame calculations
	local fixed = get(control_fix) == 1
	passed = get(frame_time)

	-- calculate power for stab
	if ((get(hydro_press) > 20 and get(AZS_stab_main_sw) == 1) or (get(emerg_press) > 20 and get(AZS_stab_emerg_sw) == 1)) and get(DC_27_volt) > 21 then
		power_stab = 1
	else power_stab = 0 end

	-- calculate power for ail trimm
	if get(DC_27_volt) > 21 and get(AZS_aileron_trim_sw) == 1 then power_ail = 1
	else power_ail = 0 end

	-- calculate power for rudder trimm
	if get(DC_27_volt) > 21 and get(AZS_rudder_trim_sw) == 1 then power_rudd = 1
	else power_rudd = 0 end

	-- pitch moves
	-- get sources
	local actual_pitch = last_pitch --get(elevator_trim)
	local need_pitch = get(joy_pitch)-- + get(ap_pitch_pos)
	if fixed then need_pitch = 0 end
	-- make moves
	actual_pitch = actual_pitch + (need_pitch - last_pitch) * PITCH_SPD * passed
	last_pitch = actual_pitch
	-- limit results
	local pitch_send = actual_pitch + get(ap_pitch_pos)
	if pitch_send > 1 then pitch_send = 1
	elseif pitch_send < -1 then pitch_send = -1 end
	-- save results
	set(elevator_trim, pitch_send + get(pitch_trim) * PITCH_COEF)
	set(pitch_anim, pitch_send)
	



	-- roll moves
	-- get sources
	local actual_roll = last_roll
	local need_roll = get(joy_roll)-- + get(ap_roll_pos)
	if fixed then need_roll = 0 end
	-- make moves
	actual_roll = actual_roll + (need_roll - last_roll) * ROLL_SPD * passed
	last_roll = actual_roll
	-- limit results
	if actual_roll > 1 then actual_roll = 1
	elseif actual_roll < -1 then actual_roll = -1 end
	
	-- apply and limit with trimmer
	local roll_result = actual_roll + get(roll_trim) * 0.2 + get(ap_roll_pos)
	
	if roll_result > 1 then roll_result = 1
	elseif roll_result < -1 then roll_result = -1 end
	-- save results
	set(aileron_trim, roll_result)
	




	-- yaw moves
	-- get sources
	local actual_yaw = last_yaw
	local need_yaw = get(joy_yaw)-- + get(ap_hdg_pos)
	if fixed then need_yaw = 0 end
	-- make moves
	actual_yaw = actual_yaw + (need_yaw - last_yaw) * YAW_SPD * passed
	last_yaw = actual_yaw
	-- limit results
	if actual_yaw > 1 then actual_yaw = 1
	elseif actual_yaw < -1 then actual_yaw = -1 end
	-- apply and limit with trimmer
	local yaw_result = actual_yaw + get(yaw_trim) * 0.2 + get(ap_hdg_pos)
	if yaw_result > 1 then yaw_result = 1
	elseif yaw_result < -1 then yaw_result = -1 end
	
	-- save results
	set(rudder_trim, yaw_result)
	

	-- power calc
	local CC = 0
	if last_pitch_trimm ~= get(pitch_trim) then CC = 2 end
	if last_roll_trimm ~= get(roll_trim) then CC = CC + 2 end
	if last_yaw_trimm ~= get(yaw_trim) then CC = CC + 2 end

	last_pitch_trimm = get(pitch_trim)
	last_roll_trimm = get(roll_trim)
	last_yaw_trimm = get(yaw_trim)

	set(control_cc, CC)

end

-- virtual trimm commands

-- turn pitch trimmer UP
pitch_UP_comm = findCommand("sim/flight_controls/pitch_trim_up")
function pitch_UP_hnd(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if (1 == phase or 0 == phase) then
		local a = get(pitch_trim) + get(frame_time) / 2
		if a > 4 then a = 4 end
		if power_stab == 1 then set(pitch_trim, a) end
		set(pitch_sw, -1)
	else
		set(pitch_sw, 0)
    end
return 0
end
registerCommandHandler(pitch_UP_comm, 0, pitch_UP_hnd)

-- turn pitch trimmer UP
pitch_DOWN_comm = findCommand("sim/flight_controls/pitch_trim_down")
function pitch_DOWN_hnd(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if (1 == phase or 0 == phase) then
		local a = get(pitch_trim) - get(frame_time) / 2
		if a < -5 then a = -5 end
		if power_stab == 1 then set(pitch_trim, a) end
		set(pitch_sw, 1)
	else
		set(pitch_sw, 0)
    end
return 0
end
registerCommandHandler(pitch_DOWN_comm, 0, pitch_DOWN_hnd)

-- turn pitch trimmer UP
pitch_TO_comm = findCommand("sim/flight_controls/pitch_trim_takeoff")
function pitch_TO_hnd(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if (1 == phase or 0 == phase) and power_stab == 1 then
		set(pitch_trim, -2)  --adjust this value to normal flight position
		set(pitch_sw, 0)
    end
return 0
end
registerCommandHandler(pitch_TO_comm, 0, pitch_TO_hnd)




-- turn roll trimmer LEFT
roll_LEFT_comm = findCommand("sim/flight_controls/aileron_trim_left")
function roll_LEFT_hnd(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if (1 == phase or 0 == phase) then
		local a = get(roll_trim) - get(frame_time) / 2
		if a < -1 then a = -1 end
		if power_ail == 1 then set(roll_trim, a) end
		set(roll_sw, -1)
	else
		set(roll_sw, 0)
    end
return 0
end
registerCommandHandler(roll_LEFT_comm, 0, roll_LEFT_hnd)

-- turn roll trimmer RIGHT
roll_RIGHT_comm = findCommand("sim/flight_controls/aileron_trim_right")
function roll_RIGHT_hnd(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if (1 == phase or 0 == phase) then
		local a = get(roll_trim) + get(frame_time) / 2
		if a > 1 then a = 1 end
		if power_ail == 1 then set(roll_trim, a) end
		set(roll_sw, 1)
	else
		set(roll_sw, 0)
    end
return 0
end
registerCommandHandler(roll_RIGHT_comm, 0, roll_RIGHT_hnd)

-- turn roll trimmer CTR
roll_CTR_comm = findCommand("sim/flight_controls/aileron_trim_center")
function roll_CTR_hnd(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if (1 == phase or 0 == phase) then
		if power_ail == 1 then set(roll_trim, 0) end
		set(roll_sw, 0)
    end
return 0
end
registerCommandHandler(roll_CTR_comm, 0, roll_CTR_hnd)




-- turn yaw trimmer LEFT
yaw_LEFT_comm = findCommand("sim/flight_controls/rudder_trim_left")
function yaw_LEFT_hnd(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if (1 == phase or 0 == phase) then
		local a = get(yaw_trim) - get(frame_time) / 2
		if a < -1 then a = -1 end
		if power_rudd == 1 then set(yaw_trim, a) end
		set(yaw_sw, -1)
	else
		set(yaw_sw, 0)
    end
return 0
end
registerCommandHandler(yaw_LEFT_comm, 0, yaw_LEFT_hnd)

-- turn yaw trimmer RIGHT
yaw_RIGHT_comm = findCommand("sim/flight_controls/rudder_trim_right")
function yaw_RIGHT_hnd(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if (1 == phase or 0 == phase) then
		local a = get(yaw_trim) + get(frame_time) / 2
		if a > 1 then a = 1 end
		if power_rudd == 1 then set(yaw_trim, a) end
		set(yaw_sw, 1)
	else
		set(yaw_sw, 0)
    end
return 0
end
registerCommandHandler(yaw_RIGHT_comm, 0, yaw_RIGHT_hnd)

-- turn yaw trimmer CTR
yaw_CTR_comm = findCommand("sim/flight_controls/rudder_trim_center")
function yaw_CTR_hnd(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if (1 == phase or 0 == phase) then
		if power_rudd == 1 then set(yaw_trim, 0) end
		set(yaw_sw, 0)
    end
return 0
end
registerCommandHandler(yaw_CTR_comm, 0, yaw_CTR_hnd)
