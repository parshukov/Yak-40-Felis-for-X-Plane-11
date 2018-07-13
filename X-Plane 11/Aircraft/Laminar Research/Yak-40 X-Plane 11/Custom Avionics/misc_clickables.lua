-- this is right AZS panel
size = {2048, 2048}

-- define switchers
defineProperty("rv_2_sw", globalPropertyi("sim/custom/xap/gauges/rv_2_sw")) -- RV2 switcher
defineProperty("agd_2_sw", globalPropertyi("sim/custom/xap/gauges/agd_2_sw")) -- AGD 2 switcher
defineProperty("sq_emerg_cap", globalPropertyi("sim/custom/xap/sq/sq_emerg_cap"))

defineProperty("vent_1_sw", globalPropertyi("sim/custom/xap/misc/vent_1_sw")) -- ventilator switcher
defineProperty("vent_2_sw", globalPropertyi("sim/custom/xap/misc/vent_2_sw")) -- ventilator switcher

defineProperty("gear_siren_sw", globalPropertyi("sim/custom/xap/gauges/gear_siren_sw")) -- gear signal switcher
defineProperty("gear_siren_cap", globalPropertyi("sim/custom/xap/gauges/gear_siren_cap")) -- gear signal switcher

defineProperty("siren_button", globalPropertyi("sim/custom/xap/gauges/siren_button")) -- button for temporary OFF sirene

defineProperty("slider15", globalPropertyi("sim/cockpit2/switches/custom_slider_on[15]")) -- cover 1
defineProperty("slider16", globalPropertyi("sim/cockpit2/switches/custom_slider_on[16]")) -- cover 2
defineProperty("slider17", globalPropertyi("sim/cockpit2/switches/custom_slider_on[17]")) -- cover 3
defineProperty("slider18", globalPropertyi("sim/cockpit2/switches/custom_slider_on[18]")) -- cover 4
defineProperty("slider19", globalPropertyi("sim/cockpit2/switches/custom_slider_on[19]")) -- cover 5
defineProperty("slider20", globalPropertyi("sim/cockpit2/switches/custom_slider_on[20]")) -- cover 6
defineProperty("slider21", globalPropertyi("sim/cockpit2/switches/custom_slider_on[21]")) -- cover 7
defineProperty("slider1", globalPropertyi("sim/cockpit2/switches/custom_slider_on[1]")) -- window 1
defineProperty("slider2", globalPropertyi("sim/cockpit2/switches/custom_slider_on[2]")) -- window 2
defineProperty("slider6", globalPropertyi("sim/cockpit2/switches/custom_slider_on[6]")) -- glass 1
defineProperty("slider7", globalPropertyi("sim/cockpit2/switches/custom_slider_on[7]")) -- glass 2

defineProperty("main_menu_subpanel", globalPropertyi("sim/custom/xap/panels/main_menu_subpanel"))
defineProperty("no_smoking", globalPropertyi("sim/cockpit2/switches/no_smoking"))



defineProperty("N1", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[1]"))   
defineProperty("N2", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[0]"))
defineProperty("N3", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[2]"))
defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time of frame

local btn_click = loadSample('Custom Sounds/plastic_btn.wav')
local switch_sound = loadSample('Custom Sounds/metal_switch.wav')
local cap_sound = loadSample('Custom Sounds/cap.wav')

local start_counter = 0
local notLoaded = true
local switcher_pushed = false

function update()
	local passed = get(frame_time)
	start_counter = start_counter + passed	
	if start_counter > 0.3 and start_counter < 0.5 and notLoaded and get(N1) < 10 and get(N2) < 10 and get(N3) < 10 then
		set(rv_2_sw, 0)
		set(agd_2_sw, 0)
		notLoaded = false
	end
	
end


-- components of panel
components = {
    
	-- click sirene button
    clickable {
       position = { 1161, 646, 38, 20 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
        onMouseClick = function(x, y, button) 
			if not switcher_pushed then playSample(btn_click, 0) switcher_pushed = true end
			set(siren_button, 1)
            return true
        end,
		onMouseUp = function()
			playSample(btn_click, 0)
			switcher_pushed = false
			set(siren_button, 0)
			return true
		end,
    },
	-- gear_siren_cap switcher
    switch {
        position = {1559, 648, 41, 99},
        state = function()
            return get(gear_siren_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(gear_siren_cap) ~= 0 then
					set(gear_siren_cap, 0)
					if get(gear_siren_sw) == 0 then playSample(switch_sound, 0) end
					set(gear_siren_sw, 1)
				else
					set(gear_siren_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- gear_siren_sw switcher
    switch {
        position = {681, 629, 19, 19},
        state = function()
            return get(gear_siren_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and get(gear_siren_cap) == 1 then
				playSample(switch_sound, 0)
				if get(gear_siren_sw) ~= 0 then
					set(gear_siren_sw, 0)
				else
					set(gear_siren_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

	-- rv_2_sw switcher
    switch {
        position = {642, 688, 19, 19},
        state = function()
            return get(rv_2_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(rv_2_sw) ~= 0 then
					set(rv_2_sw, 0)
				else
					set(rv_2_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

	-- agd_2_sw switcher
    switch {
        position = {702, 668, 19, 19},
        state = function()
            return get(agd_2_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(agd_2_sw) ~= 0 then
					set(agd_2_sw, 0)
				else
					set(agd_2_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

	-- sq_emerg_cap switcher
    switch {
        position = {1441, 668, 40, 80},
        state = function()
            return get(sq_emerg_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(sq_emerg_cap) ~= 0 then
					set(sq_emerg_cap, 0)
				else
					set(sq_emerg_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },
	
	-- vent_1_sw switcher
    switch {
        position = {642, 669, 19, 19},
        state = function()
            return get(vent_1_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(vent_1_sw) ~= 0 then
					set(vent_1_sw, 0)
				else
					set(vent_1_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },		
	
	-- vent_2_sw switcher
    switch {
        position = {802, 628, 19, 19},
        state = function()
            return get(vent_2_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(vent_2_sw) ~= 0 then
					set(vent_2_sw, 0)
				else
					set(vent_2_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },		
	
	
	-- slider15 switcher
    switch {
        position = {1443, 500, 30, 30},
        state = function()
            return get(slider15) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(slider15) ~= 0 then
					set(slider15, 0)
				else
					set(slider15, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- slider16 switcher
    switch {
        position = {1474, 500, 30, 30},
        state = function()
            return get(slider16) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(slider16) ~= 0 then
					set(slider16, 0)
				else
					set(slider16, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- slider17 switcher
    switch {
        position = {1570, 500, 30, 30},
        state = function()
            return get(slider17) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(slider17) ~= 0 then
					set(slider17, 0)
				else
					set(slider17, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },		
	
	-- slider18 switcher
    switch {
        position = {1601, 500, 30, 30},
        state = function()
            return get(slider18) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(slider18) ~= 0 then
					set(slider18, 0)
				else
					set(slider18, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- slider19 switcher
    switch {
        position = {1633, 500, 30, 30},
        state = function()
            return get(slider19) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(slider19) ~= 0 then
					set(slider19, 0)
				else
					set(slider19, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- slider20 switcher
    switch {
        position = {1729, 500, 30, 30},
        state = function()
            return get(slider20) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(slider20) ~= 0 then
					set(slider20, 0)
				else
					set(slider20, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

	-- slider21 switcher
    switch {
        position = {1760, 500, 30, 30},
        state = function()
            return get(slider21) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(slider21) ~= 0 then
					set(slider21, 0)
				else
					set(slider21, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

	-- slider1 switcher
    switch {
        position = {1507, 500, 30, 30},
        state = function()
            return get(slider1) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(slider1) ~= 0 then
					set(slider1, 0)
				else
					set(slider1, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- slider2 switcher
    switch {
        position = {1697, 500, 30, 30},
        state = function()
            return get(slider2) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(slider2) ~= 0 then
					set(slider2, 0)
				else
					set(slider2, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

	-- slider6 switcher
    switch {
        position = {1538, 500, 30, 30},
        state = function()
            return get(slider6) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(slider6) ~= 0 then
					set(slider6, 0)
				else
					set(slider6, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

	-- slider7 switcher
    switch {
        position = {1665, 500, 30, 30},
        state = function()
            return get(slider7) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(slider7) ~= 0 then
					set(slider7, 0)
				else
					set(slider7, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

	-- main_menu_subpanel switcher
    switch {
        position = {1133, 400, 40, 40},
        state = function()
            return get(main_menu_subpanel) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(main_menu_subpanel) ~= 0 then
					set(main_menu_subpanel, 0)
				else
					set(main_menu_subpanel, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- no_smoking switcher
    switch {
        position = {902, 688, 19, 19},
        state = function()
            return get(no_smoking) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(no_smoking) ~= 0 then
					set(no_smoking, 0)
				else
					set(no_smoking, 1)
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