-- this is gyro correction gauge for GMK1
size = {200, 200}

defineProperty("gyro_correct", globalPropertyf("sim/custom/xap/gauges/gyro_correct"))
defineProperty("real_mag_curse", globalPropertyf("sim/flightmodel/position/magpsi"))


defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt

defineProperty("needle1", loadImage("needles2.png", 129, 0, 22, 174))
defineProperty("needle2", loadImage("needles2.png", 152, 0, 22, 174))



local mag_angle = 0 --get(real_mag_curse)
local corr_angle = get(gyro_correct)
function update()
	local power = get(DC_27_volt) > 21
	
	if power then mag_angle = get(real_mag_curse) end
	corr_angle = -get(gyro_correct)
end


components = {

	
	-- needle 2
	needle {
		position = {10, 10, 180, 180},
		image = get(needle2),
		angle = function()
			return corr_angle
		end
	},

	-- needle 1
	needle {
		position = {10, 10, 180, 180},
		image = get(needle1),
		angle = function()
			return mag_angle
		end
	},

    -- correction
    rotary {
        -- image = rotaryImage;
        value = gyro_correct;
        step = 1 ;
        position = { 168, 5, 30, 30 };

        adjuster = function(a)
			if a > 180 then a = a - 360
			elseif a < -180 then a = a + 360 end
			return a
        end;
    };

}