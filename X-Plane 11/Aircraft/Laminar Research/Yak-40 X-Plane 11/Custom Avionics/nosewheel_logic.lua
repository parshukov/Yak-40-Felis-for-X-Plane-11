-- this is nose wheel logic to make its limits
size = {2048, 2048}
-- sources
defineProperty("weel_switch", globalPropertyi("sim/custom/xap/misc/noseweel"))
defineProperty("noseweel_cap", globalPropertyi("sim/custom/xap/misc/noseweel_cap"))
defineProperty("weel_taxi", globalPropertyi("sim/custom/xap/misc/weel_taxi"))
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AZS_nosewheel_sw", globalPropertyi("sim/custom/xap/azs/AZS_nosewheel_sw")) -- AZS for hydraulic system
defineProperty("nosewheel_command", globalPropertyi("sim/custom/xap/set/nosewheel_command")) -- if 1, then user must push button to turn nosewheel
defineProperty("groundspeed", globalPropertyf("sim/flightmodel/position/groundspeed")) -- ground speed, m/s
defineProperty("nosewheel_cc", globalPropertyf("sim/custom/xap/misc/nosewheel_cc")) -- cc

defineProperty("main_press", globalPropertyf("sim/custom/xap/hydro/main_press")) -- pressure in main system. initial 120 kg per square sm. maximum 160.
defineProperty("emerg_press", globalPropertyf("sim/custom/xap/hydro/emerg_press")) -- pressure in emergency system. initial 120 kg per square sm. maximum 160.

defineProperty("lock", globalPropertyi("sim/cockpit2/controls/nosewheel_steer_on"))



-- result
defineProperty("weel_angle1", globalPropertyf("sim/aircraft/gear/acf_nw_steerdeg1"))
defineProperty("weel_angle2", globalPropertyf("sim/aircraft/gear/acf_nw_steerdeg2"))

local switch_sound = loadSample('Custom Sounds/metal_switch.wav')
local cap_sound = loadSample('Custom Sounds/cap.wav')

function update()

	set(lock, 1) -- do not let nosewheel become free castor
--[[	
	-- test
	set(lock, 0)
	set(weel_angle1, 0) 
	set(weel_angle2, 0)
--]]	
	local power = get(DC_27_volt) > 21 and get(AZS_nosewheel_sw) == 1 and get(weel_switch) == 0
	local press = math.max(get(main_press), get(emerg_press)) / 120
	if press > 1 then press = 1 end
	if press < 0.09 then press = 0.09 end
	
	if (get(weel_taxi) == 1 or (get(nosewheel_command) == 0 and math.abs(get(groundspeed)) < 10)) and power and press > 0.185 then
		set(nosewheel_cc, 3)
		set(weel_angle1, 55 * press) 
		set(weel_angle2, 55 * press)
	else 
		set(nosewheel_cc, 0)
		set(weel_angle1, 5) 
		set(weel_angle2, 5) 
	end


end

--gear_togle_command = findCommand("sim/flight_controls/gyro_rotor_trim_up")

gear_togle_command = findCommand("sim/flight_controls/nwheel_steer_toggle")
function gear_toggle_handler(phase)
	if 1 == phase then
		set(weel_taxi, 1)
	else
		set(weel_taxi, 0)
	end
return 0
end

registerCommandHandler(gear_togle_command, 0, gear_toggle_handler)


local switcher_pushed = false
components = {

	-- weel_switch
    switch {
        position = {1062, 709, 18, 18},
        state = function()
            return get(weel_switch) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and get(noseweel_cap) == 1 then
				playSample(switch_sound, 0)
				if get(weel_switch) ~= 0 then
					set(weel_switch, 0)
				else
					set(weel_switch, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },
	
    -- noseweel_cap
    switch {
        position = {1962, 557, 45,  90},
        state = function()
            return get(noseweel_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(noseweel_cap) ~= 0 then
					set(noseweel_cap, 0)
					if get(weel_switch) == 1 then playSample(switch_sound, 0) end
					set(weel_switch, 0)
				else
					set(noseweel_cap, 1)
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