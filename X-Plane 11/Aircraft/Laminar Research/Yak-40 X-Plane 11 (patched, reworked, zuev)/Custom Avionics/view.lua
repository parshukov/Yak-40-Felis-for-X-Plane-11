
defineProperty("sy", globalPropertyf("sim/aircraft/view/acf_peY"))
defineProperty("sz", globalPropertyf("sim/aircraft/view/acf_peZ"))
defineProperty("alpha", globalPropertyf("sim/flightmodel2/misc/AoA_angle_degrees"))
defineProperty("swview", globalPropertyi("sim/custom/xap/misc/view_point"))
defineProperty("swvib", globalPropertyi("sim/custom/xap/An24_view/switch_vib"))
defineProperty("py", globalPropertyf("sim/graphics/view/pilots_head_y"))
defineProperty("px", globalPropertyf("sim/graphics/view/pilots_head_x"))
defineProperty("pz", globalPropertyf("sim/graphics/view/pilots_head_z"))
defineProperty("az", globalPropertyf("sim/graphics/view/pilots_head_the"))
defineProperty("ax", globalPropertyf("sim/graphics/view/pilots_head_psi"))
defineProperty("ay", globalPropertyf("sim/graphics/view/cockpit_heading"))
defineProperty("speed", globalPropertyf("sim/flightmodel/position/groundspeed"))
defineProperty("airspeed", globalPropertyf("sim/flightmodel/position/indicated_airspeed"))
defineProperty("gforce", globalPropertyf("sim/flightmodel2/misc/gforce_normal")) -- G overload

defineProperty("timef", globalPropertyf("sim/time/total_flight_time_sec"))
defineProperty("gear_force1", globalPropertyf("sim/flightmodel2/gear/tire_vertical_deflection_mtr[0]"))
defineProperty("gear_force2", globalPropertyf("sim/flightmodel2/gear/tire_vertical_deflection_mtr[1]"))
defineProperty("gear_force3", globalPropertyf("sim/flightmodel2/gear/tire_vertical_deflection_mtr[2]"))
defineProperty("fl", globalPropertyf("sim/cockpit2/controls/parking_brake_ratio"))

--defineProperty("set_active_camera", globalPropertyi("sim/custom/xap/set/active_camera")) -- use of moveing camera

a_last = 0
spdlast = get(speed)
koefspd = 0.1
koefairspd = 0.0001
deltalast = 0
amplitude = 0
amplitude2 = 0
koefalpha = 0.03
per = 1
koefgrnd = 0.00001
timelast = 0
deltaairspd = 0
fld=0
function update()



-- points of view: 0-none 1-capt 2-copilot 3-overhead 4-ctr1 5-ctr2, 6-left side, 7-right side, 8-11 - pax1-4	local a = get(swview)
	local a = get(swview)
	if a ~= a_last then
		if a == 1 then set(px, -0.487680) set(py, 0.542344) set(pz, -7.680973) set(az, 0) set(ax, 0) set(swview, 0) --
		elseif a == 2 then set(px, 0.487680) set(py, 0.542344) set(pz, -7.680973) set(az, 0) set(ax, 0) set(swview, 0) --
		elseif a == 3 then set(px, 0) set(py, 0.542344) set(pz, -7.680973) set(az, 40) set(ax, 0) set(swview, 0) --
		elseif a == 4 then set(px, 0) set(py, 0.686954) set(pz, -8.11) set(az, -74) set(ax, 0) set(swview, 0) --
		elseif a == 5 then set(px, 0) set(py, 0.262303) set(pz, -7.66) set(az, -37) set(ax, 0) set(swview, 0) --
		elseif a == 6 then set(px, -0.542970) set(py, 0.60357) set(pz, -7.95) set(az, -54) set(ax, 270) set(swview, 0) --
		elseif a == 7 then set(px, 0.418629) set(py, 0.570525) set(pz, -7.93) set(az, -42) set(ax, 90) set(swview, 0) --
		elseif a == 8 then set(px, -0.800254) set(py, 0.380357) set(pz, -2.01) set(az, -8) set(ax, 288) set(swview, 0) --
		elseif a == 9 then set(px, 0.800254) set(py, 0.380357) set(pz, -2.01) set(az, -8) set(ax, 72) set(swview, 0) --
		elseif a == 10 then set(px, -0.373274) set(py, 0.303714) set(pz, 0.38) set(az, 0) set(ax, 0) set(swview, 0) --
		elseif a == 11 then set(px, -0.563417) set(py, 0.308214) set(pz, -6.69) set(az, 0) set(ax, 170) set(swview, 0)
		end
	end
	a_last = 0
--[[
	-- active camera
	local camera_work = false --get(set_active_camera) == 1
	if camera_work then


		timenow = get(timef)
		swvib = get(swvib)
		deltatime = timenow - timelast
		if deltatime ~= 0 and swvib == 1 then

			--angle of attack
			angle = get(alpha)
			dalphatmp = math.abs(17 - angle)
			if dalphatmp < 2 then dalphatmp = 2 end
			dalpha = 1 / (dalphatmp * dalphatmp)
			tst = 0
			if angle < 90 and angle > 9.5 and (get(speed) > 50 or get(airspeed) > 30)then tst = 1 else tst = 0 end
			amplitude = tst * dalpha * koefalpha

			--airspeed
			if get(airspeed) > 270 then
			deltaairspd = get(airspeed) - 270
			if deltaairspd > 70 then deltaairspd = 70 end
			end
			amplitude3 = deltaairspd * koefairspd

			--ground
			spdnow = get(speed)
			g1 = get(gear_force1)
			g2 = get(gear_force2)
			g3 = get(gear_force3)
			gf = get(gforce)
			if (g1 + g2 + g3) > 0 then amptmp = 1 else amptmp = 0 end
			ampres = (g1 + g2 + g3) * spdnow
			amplitude2 = amptmp * ampres * spdnow * koefgrnd

		else amplitude = 0 amplitude2 = 0 amplitude3 = 0
		end
		timelast = timenow

		--vibration module
		per = per * -1
		drrr = per * amplitude
		drrr2 = per * amplitude2
		drrr3 = per * amplitude3
		resdrrr = get(sy) + drrr + drrr2 + drrr3
		set(sy , resdrrr)
	end --]]
end
