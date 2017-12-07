-- this is small indicator of stab position
size = {120, 120}

-- define property table
defineProperty("pitch_trim", globalPropertyf("sim/custom/xap/control/pitch_trim")) -- virtual pitch trimmer. in Yak40 have range from -3 to +6 in degrees of stab.
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("manometer_sw", globalPropertyi("sim/custom/xap/misc/manometer_sw"))  -- turn ON all manometers
defineProperty("stab_ind_cc", globalPropertyf("sim/custom/xap/gauges/stab_ind_cc")) -- cc

-- result
defineProperty("ind_stab_angle", globalPropertyf("sim/custom/xap/hydro/ind_stab_angle")) -- angle for stab indicator

-- define images
defineProperty("needles_5", loadImage("needles.png", 16, 111, 16, 98))
defineProperty("cover", loadImage("covers2.png", 65, 0, 60, 88))

local stab_ind_angle = 90

function update()
	
	if get(manometer_sw) == 1 and get(DC_27_volt) > 21 and get(AC_36_volt) > 30 then
		stab_ind_angle = -get(pitch_trim) * 45 / 6 + 75
		set(stab_ind_cc, 1)
	else 
		stab_ind_angle = 90
		set(stab_ind_cc, 0)
	end
	set(ind_stab_angle, stab_ind_angle)
	
end


components = {



	-- stab position indicator
	needle { 
		image = get(needles_5),
		position = {-32, -7, 134, 134},
		angle = function()
		return stab_ind_angle
		end,	
	},

	-- cover
	texture {
		position = {0, 1, 70, 118},
		image = get(cover),
	},

}