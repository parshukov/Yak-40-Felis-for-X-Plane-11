-- this is the simple logic of relative gyroscope, used for compases

-- define property table
-- source
defineProperty("turn", globalPropertyf("sim/flightmodel/misc/turnrate_roll")) -- turn rate deg/sec. must be used with some coef.
defineProperty("lat", globalPropertyf("sim/flightmodel/position/latitude")) -- real latitude position
defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames
defineProperty("flight_time", globalPropertyf("sim/time/total_running_time_sec")) -- sim time

-- power
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("AZS", globalPropertyi("sim/custom/xap/azs/AZS_GMK_sw")) -- AZS switcher
defineProperty("gyro_cc", globalPropertyf("sim/custom/xap/gauges/GMK_cc"))  -- current consumtion

-- fail
defineProperty("fail", globalPropertyf("sim/operation/failures/rel_ss_dgy"))

-- result
defineProperty("gyro_curse", globalPropertyf("sim/custom/xap/gauges/gyro_curse"))


-- local variables
local curse = 0  -- start value of curse

local passed = 0


-- postframe calculations
function update()
	-- time calculations
	passed = get(frame_time)
-- pre bug check
if passed > 0 then
	-- calculate power
	if get(DC_27_volt) > 21 and get(AC_36_volt) > 30 and get(AZS) > 0 and get(fail) < 6 then
	
		-- calculate relative rotation
		local rotation = (get(turn) + 0) * 3.005 / 20 * passed  --get(turn) * 3 / 20 * passed
		-- earth rotation
		local earth_rot = 360 * math.sin(math.rad(get(lat))) * passed / 86164 -- one astronomic day eq 86164 seconds
		-- calculate new curse
		curse = curse + rotation - earth_rot
		-- limit curse
		if curse > 180 then curse = curse - 360
		elseif curse < -180 then curse = curse + 360 end
	

		-- set result
		set(gyro_curse, curse)
		--set(gyro_cc, 2)
	else
		--set(gyro_cc, 0)
	end
	


end

end



