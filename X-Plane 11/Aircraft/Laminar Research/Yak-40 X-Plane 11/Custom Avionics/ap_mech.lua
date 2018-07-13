-- this is autopilot logic for Yak40 aircraft

defineProperty("power_sw", globalPropertyi("sim/custom/xap/AP/power_sw")) -- power switcher
defineProperty("pitch_sw", globalPropertyi("sim/custom/xap/AP/pitch_sw")) -- pitch switcher
defineProperty("pitch_comm", globalPropertyi("sim/custom/xap/AP/pitch_comm")) -- pitch command handle
defineProperty("roll_comm", globalPropertyi("sim/custom/xap/AP/roll_comm")) -- roll command handle
defineProperty("ap_on_but", globalPropertyi("sim/custom/xap/AP/ap_on_but")) -- turn ON button
defineProperty("ap_alt_but", globalPropertyi("sim/custom/xap/AP/ap_alt_but")) -- hold alt button

defineProperty("ap_roll_pos", globalPropertyf("sim/custom/xap/AP/ap_roll_pos")) -- position of roll axis from AP
defineProperty("ap_hdg_pos", globalPropertyf("sim/custom/xap/AP/ap_hdg_pos")) -- position of hdg axis from AP
defineProperty("ap_pitch_pos", globalPropertyf("sim/custom/xap/AP/ap_pitch_pos")) -- position of pitch axis from AP

defineProperty("ap_need_pitch", globalPropertyf("sim/custom/xap/AP/ap_need_pitch")) -- needed pitch
defineProperty("ap_need_roll", globalPropertyf("sim/custom/xap/AP/ap_need_roll")) -- needed roll
defineProperty("ap_hdg_diff", globalPropertyf("sim/custom/xap/AP/ap_hdg_diff")) -- heading diff to correct

defineProperty("ap_works_roll", globalPropertyi("sim/custom/xap/AP/ap_works_roll")) -- autopilot has control over roll and hdg
defineProperty("ap_works_pitch", globalPropertyi("sim/custom/xap/AP/ap_works_pitch")) -- autopilot has control over pitch and stab
defineProperty("main_press", globalPropertyf("sim/custom/xap/hydro/main_press")) -- pressure in main system. initial 120 kg per square sm. maximum 160.


defineProperty("res_roll_1", globalPropertyf("sim/custom/xap/gauges/roll_1")) -- current roll
defineProperty("res_pitch_1", globalPropertyf("sim/custom/xap/gauges/pitch_1")) -- current pitch
defineProperty("res_roll_2", globalPropertyf("sim/custom/xap/gauges/roll_3")) -- current roll
defineProperty("res_pitch_2", globalPropertyf("sim/custom/xap/gauges/pitch_3")) -- current pitch
defineProperty("GMK_curse_ap", globalPropertyf("sim/custom/xap/gauges/GMK_curse_ap")) -- calculated course for AP

defineProperty("roll_spd", globalPropertyf("sim/flightmodel/position/P")) -- current roll speed deg/sec
defineProperty("pitch_spd", globalPropertyf("sim/flightmodel/position/Q")) -- current pitch speed deg/sec
defineProperty("yaw_spd", globalPropertyf("sim/custom/xap/AP/ap_yaw_spd")) -- current yaw speed deg/sec

defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames


-- current position of planes
defineProperty("elevator_trim", globalPropertyf("sim/cockpit2/controls/elevator_trim")) -- sim pitch trimmer
defineProperty("aileron_trim", globalPropertyf("sim/cockpit2/controls/aileron_trim")) -- sim roll trimmer
defineProperty("rudder_trim", globalPropertyf("sim/cockpit2/controls/rudder_trim")) -- sim yaw trimmer

defineProperty("joy_pitch", globalPropertyf("sim/cockpit2/controls/yoke_pitch_ratio")) -- pitch position of joytick
defineProperty("joy_roll", globalPropertyf("sim/cockpit2/controls/yoke_roll_ratio")) -- roll position of joystick
defineProperty("joy_yaw", globalPropertyf("sim/cockpit2/controls/yoke_heading_ratio")) -- yaw position of joystick

defineProperty("roll_trim", globalPropertyf("sim/custom/xap/control/roll_trim")) -- virtual roll trimmer
defineProperty("yaw_trim", globalPropertyf("sim/custom/xap/control/yaw_trim")) -- virtual yaw trimmer

local PITCH_COEF = 0.2 -- set add of horisontal stab to elevator, add number per one degree. must sync with flightcontrols
defineProperty("pitch_trim", globalPropertyf("sim/custom/xap/control/pitch_trim")) -- virtual pitch trimmer. in Yak40 have range from -3 to +6 in degrees of stab.

local roll_spd_lim = 5
local pitch_spd_lim = 5
local hdg_spd_lim = 1

local roll_norm_diff = 15
local pitch_norm_diff = 10


	local ail_pos_need = 0 -- nedded aileron position
	local elev_pos_need = 0 -- needed elevator position
	local rudd_pos_need = 0 -- needed rudder position

function update()
	local passed = get(frame_time)
	local press = get(main_press) > 30

	local roll_now = (get(res_roll_1) + get(res_roll_2)) * 0.5 -- current roll
	local roll_need = get(ap_need_roll) -- new roll, will calculate it by logic
	local roll_clar = 0.01 -- clarify the roll change speed

	local hdg_now = get(GMK_curse_ap) -- currend heading
	local hdg_need = 0 -- new heading, will calculte it by logic
	local hdg_clar = 0.1 -- clarify the heading change speed

	local pitch_now = (get(res_pitch_1) + get(res_pitch_2)) * 0.5 -- current pitch
	local pitch_need = get(ap_need_pitch) -- new pitch, will calculate it by logic
	local pitch_clar = 0.01 -- clarity the pitch change speed


	-------------------
	-- roll logic

	local roll_diff = (roll_need - roll_now) / roll_norm_diff -- normalized roll diff
	if roll_diff > 1 then roll_diff = 1
	elseif roll_diff < -1 then roll_diff = -1 end

	local roll_spd_need = roll_diff * roll_spd_lim -- roll speed for reach the needed position
	local roll_spd_now = get(roll_spd) -- current roll speed

	if get(ap_works_roll) == 0 or not press then
		roll_spd_need = 0
		roll_spd_now = 0
	end
	
	
	local ail_pos_now = get(ap_roll_pos) -- current aileron position

	local ail_step = math.min(0.5, math.abs(roll_spd_now - roll_spd_need) * 0.3)
--[[
	if roll_spd_need > roll_spd_now + roll_clar then ail_pos_need = ail_pos_now - get(joy_roll) * 1 - get(roll_trim) * 0.2 + ail_step * passed
	elseif roll_spd_need < roll_spd_now - roll_clar then ail_pos_need = ail_pos_now - get(joy_roll) * 1 - get(roll_trim) * 0.2 - ail_step * passed
	end
--]]
	if roll_spd_need > roll_spd_now + roll_clar then ail_pos_need = ail_pos_now + ail_step * passed
	elseif roll_spd_need < roll_spd_now - roll_clar then ail_pos_need = ail_pos_now - ail_step * passed
	end
	
	if ail_pos_need > 0.7 then ail_pos_need = 0.7
	elseif ail_pos_need < -0.7 then ail_pos_need = -0.7 end

	if get(ap_works_roll) == 1 and press then
		set(ap_roll_pos, ail_pos_need)
	else
		if ail_pos_need > 0 then ail_pos_need = ail_pos_need * 0.9
		elseif ail_pos_need < 0 then ail_pos_need = ail_pos_need * 0.9 end
		set(ap_roll_pos, ail_pos_need)
	end


	---------------------
	-- pitch logic
	local pitch_diff = (pitch_need - pitch_now) / pitch_norm_diff  -- pitch speed for reach the needed position
	if pitch_diff > 1 then pitch_diff = 1
	elseif pitch_diff < -1 then pitch_diff = -1 end


	local pitch_spd_need = pitch_diff * pitch_spd_lim + math.abs(roll_now) * 0.05
	local pitch_spd_now = get(pitch_spd) -- current pitch speed

	if get(ap_works_pitch) == 0 or not press then
		pitch_spd_need = 0
		pitch_spd_now = 0
	end

	
	--local elev_pos_now = get(elevator_trim) - get(pitch_trim) * PITCH_COEF -- current elevator position
	local elev_pos_now = get(ap_pitch_pos) -- current elevator position
	
	
	local elev_step = math.min(0.7, math.abs(pitch_spd_now - pitch_spd_need) * 0.1)

	if pitch_spd_need > pitch_spd_now + pitch_clar then elev_pos_need = elev_pos_now + elev_step * passed
	elseif pitch_spd_need < pitch_spd_now - pitch_clar then elev_pos_need = elev_pos_now - elev_step * passed
	end

	if elev_pos_need > 0.7 then elev_pos_need = 0.7
	elseif elev_pos_need < -0.7 then elev_pos_need = -0.7 end

	if get(ap_works_pitch) == 1 and press then
		-- add here a logic for stab to release the pitch axis
		local stab_pos = get(pitch_trim)
		if elev_pos_need > 0.01 and stab_pos <= 5.9 then
			set(pitch_trim, stab_pos + passed * 0.03)
			--elev_pos_need = elev_pos_need - passed * 0.03 * PITCH_COEF
		elseif elev_pos_need < -0.01 and stab_pos >= -2.9 then
			set(pitch_trim, stab_pos - passed * 0.03)
			--elev_pos_need = elev_pos_need + passed * 0.03 * PITCH_COEF
		end
		set(ap_pitch_pos, elev_pos_need)
	else
		if elev_pos_need > 0 then elev_pos_need = elev_pos_need * 0.9
		elseif elev_pos_need < 0 then elev_pos_need = elev_pos_need * 0.9 end
		set(ap_pitch_pos, elev_pos_need)
	end




	---------------------
	-- heading logic

	local hdg_spd_need = get(ap_hdg_diff) * 2 -- heading speed for reach the needed position
	-- limit direction
	if hdg_spd_need > 180 then hdg_spd_need = hdg_spd_need - 360
	elseif hdg_spd_need < -180 then hdg_spd_need = hdg_spd_need + 360 end

	if hdg_spd_need > hdg_spd_lim then hdg_spd_need = hdg_spd_lim
	elseif hdg_spd_need < -hdg_spd_lim then hdg_spd_need = -hdg_spd_lim end

	local hdg_spd_now = get(yaw_spd) -- current heading speed

	if get(ap_works_roll) == 0 or not press then
		hdg_spd_need = 0
		hdg_spd_now = 0
	end

	local rudd_pos_now = get(ap_hdg_pos) -- current rudder position

	local rudd_step = math.min(0.5, math.abs(hdg_spd_now - hdg_spd_need) * 0.05)

	if hdg_spd_need < hdg_spd_now + hdg_clar then rudd_pos_need = rudd_pos_now + rudd_step * passed
	elseif hdg_spd_need > hdg_spd_now - hdg_clar then rudd_pos_need = rudd_pos_now - rudd_step * passed
	end

	if rudd_pos_need > 0.3 then rudd_pos_need = 0.3
	elseif rudd_pos_need < -0.3 then rudd_pos_need = -0.3 end

	if get(ap_works_roll) == 1 and press then
		set(ap_hdg_pos, rudd_pos_need)
	else
		if rudd_pos_need > 0 then rudd_pos_need = rudd_pos_need * 0.9
		elseif rudd_pos_need < 0 then rudd_pos_need = rudd_pos_need * 0.9 end
		set(ap_hdg_pos, rudd_pos_need)
	end








end





