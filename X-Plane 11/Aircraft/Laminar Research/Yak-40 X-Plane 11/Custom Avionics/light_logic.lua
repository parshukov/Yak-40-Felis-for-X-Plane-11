-- this is light logic
size = {2048, 2048}
-- define property table

defineProperty("nav_light_sw", globalPropertyi("sim/custom/xap/misc/nav_light_sw")) -- nav lights switch
defineProperty("bec_light_sw", globalPropertyi("sim/custom/xap/misc/bec_light_sw")) -- nav beacons switch
defineProperty("lan_light_sw", globalPropertyi("sim/custom/xap/misc/lan_light_sw")) -- landing lights switch
defineProperty("lan_light_sw2", globalPropertyi("sim/custom/xap/misc/lan_light_sw2")) -- landing lights switch
defineProperty("lan_light_open_sw", globalPropertyi("sim/custom/xap/misc/lan_light_open_sw")) -- landing lights switch

defineProperty("hide_left_lamp", globalPropertyi("sim/custom/xap/misc/hide_left_lamp")) -- hide lamp on 3D object
defineProperty("hide_right_lamp", globalPropertyi("sim/custom/xap/misc/hide_right_lamp")) -- hide lamp on 3D object

defineProperty("cockpit_red", globalPropertyf("sim/custom/xap/misc/cockpit_red")) -- red cockpit light rotary
defineProperty("cockpit_spot1", globalPropertyf("sim/custom/xap/misc/cockpit_spot1")) -- cockpit spotlight rotary
defineProperty("cockpit_spot2", globalPropertyf("sim/custom/xap/misc/cockpit_spot2")) -- cockpit spotlight rotary
defineProperty("cockpit_panel", globalPropertyi("sim/custom/xap/misc/cockpit_panel")) -- cockpit spotlight rotary
defineProperty("light_tride", globalPropertyi("sim/custom/xap/control/light_tride")) -- cockpit spotlight rotary

defineProperty("salon_main_sw", globalPropertyi("sim/custom/xap/misc/salon_main_sw")) -- salon lights
defineProperty("salon_emerg_sw", globalPropertyi("sim/custom/xap/misc/salon_emerg_sw")) -- salon lights
defineProperty("emerg_exit_light_sw", globalPropertyi("sim/custom/xap/misc/emerg_exit_light_sw")) -- salon lights

-- AZS
defineProperty("lan_light1", globalPropertyi("sim/custom/xap/azs/AZS_lan1_sw")) -- AZS
defineProperty("lan_light2", globalPropertyi("sim/custom/xap/azs/AZS_lan2_sw")) -- AZS
defineProperty("taxi_light1", globalPropertyi("sim/custom/xap/azs/AZS_taxi1_sw")) -- AZS
defineProperty("taxi_light2", globalPropertyi("sim/custom/xap/azs/AZS_taxi2_sw")) -- AZS

-- sim variables
defineProperty("sim_lan_light_angle", globalPropertyf("sim/aircraft/view/acf_lanlite_the")) -- angle of OpenGL light
defineProperty("sim_taxi_light_sw", globalPropertyf("sim/cockpit/electrical/taxi_light_on")) -- sim landing light switcher
defineProperty("sim_lan_light_sw", globalPropertyf("sim/cockpit/electrical/landing_lights_on")) -- sim landing light switcher
defineProperty("sim_nav_light_sw", globalPropertyf("sim/cockpit/electrical/nav_lights_on")) -- sim nav light switcher
defineProperty("sim_strob_light_sw", globalPropertyf("sim/cockpit/electrical/strobe_lights_on"))
defineProperty("sim_bec_light_sw", globalPropertyf("sim/cockpit/electrical/beacon_lights_on")) -- sim nav light switcher
defineProperty("sim_lan_light_ratio", globalPropertyf("sim/cockpit2/switches/landing_lights_switch[0]")) -- landing lights switch
defineProperty("sim_lan_light_ratio1", globalPropertyf("sim/cockpit2/switches/landing_lights_switch[1]")) -- landing lights switch
defineProperty("sim_lan_light_slider", globalPropertyf("sim/flightmodel2/misc/custom_slider_ratio[5]")) -- landing lights position
defineProperty("sim_lan_light_open", globalPropertyf("sim/cockpit2/switches/custom_slider_on[5]")) -- landing lights open/close

defineProperty("N1", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[1]"))   
defineProperty("N2", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[0]"))
defineProperty("N3", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[2]"))

-- cockpit lights
defineProperty("sim_panel_light", globalPropertyf("sim/cockpit2/switches/panel_brightness_ratio[0]")) -- 2D panel light
defineProperty("sim_cab_light1", globalPropertyf("sim/cockpit2/switches/panel_brightness_ratio[1]")) -- cockpit spotlight
defineProperty("sim_cab_light2", globalPropertyf("sim/cockpit2/switches/panel_brightness_ratio[2]")) -- cockpit flood
defineProperty("sim_cab_light3", globalPropertyf("sim/cockpit2/switches/panel_brightness_ratio[3]")) -- cockpit spotlight

defineProperty("salon_brt", globalPropertyf("sim/custom/xap/misc/salon_brt")) -- salon lights brightness
defineProperty("exit_brt", globalPropertyf("sim/custom/xap/misc/exit_brt")) -- salon exit lights brightness

-- power
defineProperty("nav_light_cc", globalPropertyf("sim/custom/xap/misc/nav_light_cc")) -- light current consumption
defineProperty("bec_light_cc", globalPropertyf("sim/custom/xap/misc/bec_light_cc")) -- light current consumption
defineProperty("lan_light_cc", globalPropertyf("sim/custom/xap/misc/lan_light_cc")) -- light current consumption
defineProperty("cockpit_light_cc", globalPropertyf("sim/custom/xap/misc/cockpit_light_cc")) -- light current consumption

defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt


-- time from simulator start
defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames
defineProperty("sim_time", globalPropertyf("sim/time/total_running_time_sec")) -- sim time


-- initial switchers values
defineProperty("N1", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[1]"))
defineProperty("N2", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[0]"))
defineProperty("N3", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[2]"))


local switch_sound = loadSample('Custom Sounds/metal_switch.wav')
local rotary_sound = loadSample('Custom Sounds/rot_click.wav')

-- commands
-- switch landing light
lan_light_command = findCommand("sim/lights/landing_lights_toggle")
function lan_light_handler(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if 0 == phase then 
		if get(lan_light_sw) == 0 then
			set(lan_light_sw, 1)
			set(lan_light_sw2, 1)
			set(lan_light_open_sw, 1)
		else
			set(lan_light_sw, 0)
			set(lan_light_sw2, 0)
			set(lan_light_open_sw, 0)			
		end
    end
return 0
end
registerCommandHandler(lan_light_command, 0, lan_light_handler)

-- switch taxi light
taxi_light_command = findCommand("sim/lights/taxi_lights_toggle")
function taxi_light_handler(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if 0 == phase then 
		if get(lan_light_sw) == 0 then
			set(lan_light_sw, -1)
			set(lan_light_sw2, -1)
			set(lan_light_open_sw, 1)
		else
			set(lan_light_sw, 0)
			set(lan_light_sw2, 0)
			set(lan_light_open_sw, 0)			
		end
    end
return 0
end
registerCommandHandler(taxi_light_command, 0, taxi_light_handler)



local time_counter = 0
local not_loaded = true


-- local variables
local now = get(sim_time)
local angle = -8

function update()
	-- time variables
	now = get(sim_time)
	local passed = get(frame_time)
if passed > 0 and passed < 0.1 then

	-- initial switchers values
	time_counter = time_counter + passed
	if get(N1) < 40 and get(N2) < 40 and get(N3) < 40 and time_counter > 0.3 and time_counter < 0.4 and not_loaded then
		set(nav_light_sw, 0)
		set(bec_light_sw, 0)
		set(sim_taxi_light_sw, 0)
		set(sim_bec_light_sw, 0)
		set(sim_lan_light_sw, 0)
		set(sim_lan_light_ratio, 0)	
		set(sim_lan_light_ratio1, 0)
		not_loaded = false
	end
	
	-- power calculations
	local power = get(DC_27_volt) 
	

	-- nav light logic
	local ano_switch = get(nav_light_sw)
	
	if power * ano_switch > 21 then 
		set(nav_light_cc, 8)
		set(sim_nav_light_sw, 1)
	else 
		set(nav_light_cc, 0)
		set(sim_nav_light_sw, 0)			
	end
	set(sim_strob_light_sw, 0)
	
	-- beacons logic
	local bec_switch = get(bec_light_sw)
	if power * bec_switch > 21 then 
		set(bec_light_cc, 8)	
		set(sim_bec_light_sw, 1)
	else
		set(bec_light_cc, 0)	
		set(sim_bec_light_sw, 0)
	end 



	
	-- landing light logic
	local lan_sw = get(lan_light_sw)
	local lan_sw2 = get(lan_light_sw2)
	local lan_brt = 0 
	local lan_brt2 = 0


	
	-- left lamp
	if power > 21 and lan_sw == 1 and get(lan_light1) == 1 then
		lan_brt = 1
	elseif power > 21 and lan_sw == -1 and get(taxi_light1) == 1 then 
		lan_brt = 0.4
	else 
		lan_brt = 0
	end

	-- right lamp
	if power > 21 and lan_sw2 == 1 and get(lan_light2) == 1 then
		lan_brt2 = 1
	elseif power > 21 and lan_sw2 == -1 and get(taxi_light2) == 1 then 
		lan_brt2 = 0.4
	else 
		lan_brt2 = 0
	end

	-- open landing light
	if power > 21 then set(sim_lan_light_open, get(lan_light_open_sw)) end	

	-- set angle for light
	angle = -7 - 90 * (-get(sim_lan_light_slider) + 1) + (lan_sw + lan_sw2) * 1.5 * 0.5
	if angle < -30 then 
		lan_brt = 0
		lan_brt2 = 0
	end
	
	if lan_brt + lan_brt2 > 0 then 
		set(sim_lan_light_sw, 1) 
	else 
		set(sim_lan_light_sw, 0) 
	end
	set(sim_taxi_light_sw, 0)

	-- set results
	set(sim_lan_light_angle, angle)
	set(sim_lan_light_ratio, lan_brt )	
	set(sim_lan_light_ratio1, lan_brt2)
	set(lan_light_cc, 22 * (lan_brt + lan_brt2))

	-- hide lamps
	if lan_sw == 1 and get(lan_light1) == 0 or lan_sw == -1 and get(taxi_light1) == 0 then 
		set(hide_left_lamp, 1)
	else set(hide_left_lamp, 0) end

	if lan_sw == 1 and get(lan_light2) == 0 or lan_sw == -1 and get(taxi_light2) == 0 then 
		set(hide_right_lamp, 1)
	else set(hide_right_lamp, 0) end


-----------------------------	
	-- cockpit light
	local panel_ratio = get(cockpit_panel)
	if panel_ratio == 1 then panel_ratio = 1.1
	elseif panel_ratio == -1 then panel_ratio = 1
	else panel_ratio = 0 end
	
	local cockpit_ratio = get(cockpit_red)
	local spot1 = get(cockpit_spot1)
	local spot2 = get(cockpit_spot2)
	
	local salon_ratio = 0
	local exit_ratio = 0
	-- check engines work
	local eng1_work = 0
	local eng2_work = 0
	local eng3_work = 0
	if get(N1) > 40 then eng1_work = 1 end
	if get(N2) > 40 then eng2_work = 1 end
	if get(N3) > 40 then eng3_work = 1 end
	
	if power > 21 then
		set(sim_panel_light, math.max(panel_ratio, (cockpit_ratio * 1.5 + spot1 + spot2) * 0.7))
		set(sim_cab_light1, spot1 * 1.5)
		set(sim_cab_light2, cockpit_ratio * 1.5)
		set(sim_cab_light3, spot2 * 1.5)
		if eng1_work + eng2_work + eng3_work >= 2 and get(salon_main_sw) == 1 then salon_ratio = 1
		elseif get(salon_emerg_sw) == 1 then salon_ratio = 1 end
		set(salon_brt, salon_ratio)
		if get(emerg_exit_light_sw) == 1 then exit_ratio = 1
		else exit_ratio = salon_ratio end
		set(cockpit_light_cc, panel_ratio * 4 + cockpit_ratio * 15 + spot1 * 4 + spot2 * 4 + salon_ratio * 50)
		set(exit_brt, exit_ratio)
		set(light_tride,get(cockpit_panel))
	else 	
		set(light_tride,0)
		set(sim_panel_light, 0)
		set(sim_cab_light1, 0)
		set(sim_cab_light2, 0)
		set(sim_cab_light3, 0)
		set(cockpit_light_cc, 0)
		set(salon_brt, 0)
		set(exit_brt, 0)
	end
	
end

end

local switcher_pushed = false
components = {

	-- landing light
	-- switch down
    clickable {
        position = {962, 689, 19, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			local a = get(lan_light_sw)
			if a < 1 then playSample(switch_sound, 0) end
			a = a + 1
			if a > 1 then a = 1 end
			set(lan_light_sw, a)
		end
    },

	-- switch up
    clickable {
        position = {962, 699, 19, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			local a = get(lan_light_sw)
			if a > -1 then playSample(switch_sound, 0) end
			a = a - 1
			if a < -1 then a = -1 end
			set(lan_light_sw, a)
		end
    },

	-- switch down
    clickable {
        position = {982, 689, 19, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			local a = get(lan_light_sw2)
			if a < 1 then playSample(switch_sound, 0) end
			a = a + 1
			if a > 1 then a = 1 end
			set(lan_light_sw2, a)
		end
    },

	-- switch up
    clickable {
        position = {982, 699, 19, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			local a = get(lan_light_sw2)
			if a > -1 then playSample(switch_sound, 0) end
			a = a - 1
			if a < -1 then a = -1 end
			set(lan_light_sw2, a)
		end
    },



	
	-- lan_light_open_sw
    switch {
        position = {1002, 689, 19, 19  },
        state = function()
            return get(lan_light_open_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(lan_light_open_sw) ~= 0 then
					set(lan_light_open_sw, 0)
				else
					set(lan_light_open_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- nav_light_sw
    switch {
        position = {1022, 689, 19, 19  },
        state = function()
            return get(nav_light_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(nav_light_sw) ~= 0 then
					set(nav_light_sw, 0)
				else
					set(nav_light_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- bec_light_sw
    switch {
        position = {1042, 689, 19, 19  },
        state = function()
            return get(bec_light_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(bec_light_sw) ~= 0 then
					set(bec_light_sw, 0)
				else
					set(bec_light_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- cockpit_panel
    switch {
        position = {761, 648, 39, 19 },
        state = function()
            return get(cockpit_panel) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(cockpit_panel) ~= 0 then
					set(cockpit_panel, 0)
				else
					set(cockpit_panel, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },
	
	-- salon_main_sw
    switch {
        position = {662, 649, 39, 19  },
        state = function()
            return get(salon_main_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(salon_main_sw) ~= 0 then
					set(salon_main_sw, 0)
				else
					set(salon_main_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

	-- salon_emerg_sw
    switch {
        position = {702, 649, 19, 19  },
        state = function()
            return get(salon_emerg_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(salon_emerg_sw) ~= 0 then
					set(salon_emerg_sw, 0)
				else
					set(salon_emerg_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },
	
	-- emerg_exit_light_sw
    switch {
        position = {741, 649, 19, 19  },
        state = function()
            return get(emerg_exit_light_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(emerg_exit_light_sw) ~= 0 then
					set(emerg_exit_light_sw, 0)
				else
					set(emerg_exit_light_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

    rotary {
        -- image = rotaryImage;
        value = cockpit_red;
        step = 0.1;
        position = { 1221, 748, 19, 19 };

        adjuster = function(a)
				if a >= 0 and a <= 1 then playSample(rotary_sound, 0) end
				if a < 0 then a = 0
				elseif a > 1 then a = 1 end
			return a
        end;
    };	
	
    rotary {
        -- image = rotaryImage;
        value = cockpit_spot1;
        step = 0.1;
        position = { 1202, 748, 19, 19 };

        adjuster = function(a)
				if a >= 0 and a <= 1 then playSample(rotary_sound, 0) end
				if a < 0 then a = 0
				elseif a > 1 then a = 1 end
			return a
        end;
    };
	
    rotary {
        -- image = rotaryImage;
        value = cockpit_spot2;
        step = 0.1;
        position = { 1242, 748, 19, 19 };

        adjuster = function(a)
				if a >= 0 and a <= 1 then playSample(rotary_sound, 0) end
				if a < 0 then a = 0
				elseif a > 1 then a = 1 end
			return a
        end;
    };
	
}


