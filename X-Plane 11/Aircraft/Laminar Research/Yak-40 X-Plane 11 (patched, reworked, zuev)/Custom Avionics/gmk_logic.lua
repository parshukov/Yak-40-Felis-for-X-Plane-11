-- this is the simple logic of gyro-inductive compas


-- define property table
-- power
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("AZS", globalPropertyi("sim/custom/xap/azs/AZS_GMK_sw")) -- AZS switcher
defineProperty("GMK_cc", globalPropertyf("sim/custom/xap/gauges/GMK_cc")) -- cc


-- control
defineProperty("gyro_mode", globalPropertyi("sim/custom/xap/gauges/gyro_mode")) -- 0 = MK, 1 = GPK, 2 = AK
defineProperty("GMK_curse", globalPropertyf("sim/custom/xap/gauges/GMK_curse1")) -- calculated course
defineProperty("GMK_north", globalPropertyf("sim/custom/xap/gauges/GMK_north")) -- switcher North/South
defineProperty("GMK_lat", globalPropertyf("sim/custom/xap/gauges/GMK_lat")) -- rotary for set latitude
defineProperty("device_num", 0) -- number of device
defineProperty("GMK_select", globalPropertyf("sim/custom/xap/gauges/GMK_select")) -- switcher to select working devide
defineProperty("man_corr", globalPropertyi("sim/custom/xap/gauges/GMK_man_corr")) -- manual corrector switch

-- sources
defineProperty("gyro", globalPropertyf("sim/custom/xap/gauges/gyro_curse"))
defineProperty("gyro_correct", globalPropertyf("sim/custom/xap/gauges/gyro_correct"))
defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames
defineProperty("flight_time", globalPropertyf("sim/time/total_running_time_sec")) -- sim time
defineProperty("real_mag_curse", globalPropertyf("sim/flightmodel/position/magpsi"))

--[[
-- GIK button
button_command = findCommand("sim/autopilot/heading")
function button_handler(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if 1 == phase then
		if get(gyro_mode) ~= 0 then set(gyro_mode, 0) else set(gyro_mode, 1) end
    end
return 0
end
registerCommandHandler(button_command, 0, button_handler)
--]]

local time_counter = 0
local not_loaded = true



-- local variables
local gyro_angle = 0 -- angle taken from gyro
local angle_correct = 0 -- correction for angle to make it closer to real mag curse
local angle = 0 -- result angle
local earth_rot = 0 -- correction of Earth rotation
local manual = 0
-- post-frame calculations

function update()
	local passed = get(frame_time)
-- time bug workaround
if passed > 0 then
	

	-- check power
	local power = get(DC_27_volt) > 21 and get(AC_36_volt) > 30 and get(AZS) > 0
	
	-- calculate gyro correction, using latitude settings
	if power then earth_rot = (2 * get(GMK_north) - 1) * 360 * math.sin(math.rad(get(GMK_lat))) * passed / 86164 end-- one astronomic day eq 86164 seconds
	if earth_rot > 180 then earth_rot = earth_rot - 360
	elseif earth_rot < -180 then earth_rot = earth_rot + 360 end
	
	-- sync compas
	local mag_curse = get(real_mag_curse) + get(gyro_correct)
	if mag_curse > 360 then mag_curse = mag_curse - 540
	elseif mag_curse > 180 then mag_curse = mag_curse - 360 
	elseif mag_curse < -360 then mag_curse = mag_curse + 540
	elseif mag_curse < -180 then mag_curse = mag_curse + 360 end
	
	if power and math.abs(angle - mag_curse) > 1 and get(gyro_mode) ~= 1 then
		if mag_curse - angle > 180 then
			angle_correct = angle_correct - 3 * passed
		elseif mag_curse - angle > 0 then
			angle_correct = angle_correct + 3 * passed
		elseif mag_curse - angle < -180 then
			angle_correct = angle_correct + 3 * passed
		else
			angle_correct = angle_correct - 3 * passed
		end
		
		if angle_correct > 180 then angle_correct = angle_correct - 360
		elseif angle_correct < -180 then angle_correct = angle_correct + 360 end
	end
	
	-- set manual corrector
	if get(GMK_select) == get(device_num) and power then
		manual = manual + get(man_corr) * passed * 10
		if manual > 180 then manual = manual - 360
		elseif manual < -180 then manual = manual + 360 end
	end
	
	-- set new gyro angle
	if power then angle = get(gyro) + earth_rot + angle_correct + manual end	
	if angle > 360 then angle = angle - 540 end
	if angle > 180 then angle = angle - 360 end
	if angle < -360 then angle = angle + 540 end
	if angle < -180 then angle = angle + 360 end
	
	-- set result
	set(GMK_curse, angle)
	if power then set(GMK_cc, 4) else set(GMK_cc, 0) end


end	


end

