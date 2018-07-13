size = {300, 135}

-- define property table
defineProperty("frequency", globalPropertyf("sim/cockpit2/radios/actuators/nav1_frequency_hz"))  -- set the frequency

defineProperty("v_plank", globalPropertyf("sim/cockpit2/radios/indicators/nav1_hdef_dots_pilot")) -- horizontal deflection on course
defineProperty("h_plank", globalPropertyf("sim/cockpit2/radios/indicators/nav1_vdef_dots_pilot")) -- vertical deflection on glideslope
defineProperty("cr_flag", globalPropertyf("sim/cockpit2/radios/indicators/nav1_flag_from_to_pilot")) -- Nav-To-From indication, nav1, pilot, 0 is flag, 1 is to, 2 is from.
defineProperty("gs_flag", globalPropertyf("sim/cockpit/radios/nav1_CDI"))  -- glideslope flag. 0 - flag is shown
defineProperty("nav_deg", globalPropertyf("sim/cockpit2/radios/indicators/nav1_relative_bearing_deg")) -- nav1 bearing
defineProperty("fail", globalPropertyf("sim/operation/failures/rel_nav1"))

defineProperty("kp_route", globalPropertyi("sim/custom/xap/gauges/kp_route")) -- switcher route-landing. 0 = landing, 1 = route
defineProperty("kp_mode", globalPropertyi("sim/custom/xap/gauges/kp_mode")) -- ILS or SP-50 mode. 0 = ILS, 1 = SP-50

defineProperty("nav_tofrom", globalPropertyi("sim/custom/xap/gauges/nav1_tofrom")) -- to-from lamps. 0 = none, 1 = to, 2 = from
defineProperty("real_nav", globalPropertyi("sim/custom/xap/set/real_nav")) -- for real NAV system with route and landing modes


-- result
defineProperty("k_flag", globalPropertyi("sim/custom/xap/gauges/k1_flag")) -- flag for course on left kppm
defineProperty("g_flag", globalPropertyi("sim/custom/xap/gauges/g1_flag")) -- flag for glide on left kppm
defineProperty("curs", globalPropertyf("sim/custom/xap/gauges/curs_1")) -- KursMP course for left kppm
defineProperty("glide", globalPropertyf("sim/custom/xap/gauges/glide_1")) -- KursMP glide for left kppm
defineProperty("vor", globalPropertyf("sim/custom/xap/gauges/vor_1")) -- KursMP course for left kppm

-- power
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("inv_PO1500_radio", globalPropertyi("sim/custom/xap/power/inv_PO1500_radio")) -- inverter for 115v bus

defineProperty("nav_cc", globalPropertyf("sim/custom/xap/gauges/nav1_cc")) -- cc

defineProperty("AZS_KursMP_sw", globalPropertyi("sim/custom/xap/azs/AZS_KursMP_sw")) -- power switch on AZS panel

defineProperty("power_sw", globalPropertyi("sim/custom/xap/gauges/nav1_power")) -- power switch
defineProperty("nav_button", globalPropertyi("sim/custom/xap/gauges/nav1_button")) -- test buttons


defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames

-- images table
defineProperty("digitsImage", loadImage("white_digit_strip.png", 3, 0, 10, 196)) 
defineProperty("glass_img", loadImage("gmk_panel.png", 0, 480, 68, 32)) 

defineProperty("N1", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[1]"))   
defineProperty("N2", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[0]"))
defineProperty("N3", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[2]"))
defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time of frame


-- returns true if current beacon is ILS
function isIls(freq)
    --local freq = get(frequency)
    if (10810 > freq) or (11195 < freq) then
        return false
    end
    local v, f = math.modf(freq / 100)
	v = math.floor(f * 10 + 0.001)
    return 1 == (v % 2)
end


local btn_click = loadSample('Custom Sounds/plastic_btn.wav')
local switch_sound = loadSample('Custom Sounds/metal_switch.wav')
local rotary_sound = loadSample('Custom Sounds/rot_click.wav')
local tone1 = loadSample('Custom Sounds/tone_1.wav')
local tone2 = loadSample('Custom Sounds/tone_2.wav')
local tone3 = loadSample('Custom Sounds/tone_3.wav')

local start_counter = 0
local notLoaded = true
local switcher_pushed = false

-- variables for separate manipulations
local freq_100 = 100 
local freq_10 = 0
local freq_num = get(frequency) / 100

local power = false
local counter = 5
local random_course = 0
local cr_angle = 0
local course = 0 --get(v_plank)
local glidesl = 0 --get(h_plank)
	
function update()
	local real = get(real_nav) == 1
	local passed = get(frame_time)
	local freq = get(frequency)
	local ILS = isIls(freq)

	local landing = get(kp_route) == 0
	local right_mode = ILS == landing
	
	start_counter = start_counter + passed	
	if start_counter > 0.3 and start_counter < 0.5 and notLoaded and get(N1) < 10 and get(N2) < 10 and get(N3) < 10 then
		set(power_sw, 0)
		notLoaded = false
	end		
	
	freq_num = freq / 100
   
	-- calculate separate digits
	freq_100 = math.floor(freq / 100)  -- cut off last two digits
	freq_10 = freq - freq_100 * 100  -- cut off first digits
	
	-- planks and vor bearing calculation
	power = get(DC_27_volt) > 21 and get(power_sw) == 1 and get(fail) < 6 and get(AC_115_volt) > 110 and get(AZS_KursMP_sw) == 1 and get(inv_PO1500_radio) == 1 and get(AC_36_volt) > 30
	-- set flags
	local nav_flag = get(cr_flag)
	local glide_flag = get(gs_flag)
	if not landing and real then glide_flag = 0 end
	
	-- set course and glide planks
	if power then 
		course = get(v_plank)
		if get(kp_mode) == 0 and landing or not real then glidesl = get(h_plank) 
		elseif landing then glidesl = -get(h_plank) 
		else glidesl = 0 end
		set(nav_cc, 1)
	else
		set(nav_cc, 0)
	end

	-- check if mode is right
	if not right_mode and real then
		nav_flag = 0
		glide_flag = 0
		course = 0
		glidesl = 0
	end 

	-- add random noise deflection for planks
	if nav_flag == 0 and power and math.random() > 0.996 then 
		course = (math.random() - 0.49999) * 20
		nav_flag = math.random(1, 2)
	end	
	if glide_flag == 0 and power and math.random() > 0.996 and (landing or not real) then 
		glidesl = (math.random() - 0.49999) * 20
		glide_flag = 1
	end		
	-- add test buttons
	local but = get(nav_button)
	if power then
		if but == 1 then
			course = -2.5
			if landing or not real then glidesl = -2.5 end
		elseif but == 2 then
			course = 0
			glidesl = 0	
		elseif but == 3 then
			course = 2.5
			if landing or not real then glidesl = 2.5 end
		end
	end
	-- calculate bearing
	local source_angle = get(nav_deg)
	if landing and real then source_angle = 90 
	else
		if but == 1 or but == 3 then
			source_angle = 180
		elseif but == 2 then
			source_angle = 0
		end	
	end -- bearing will work only in VOR mode (route)
	
	local signal = 0
	if power then
		-- calculate random course
		counter = counter + passed
		if counter > 3 then 
			random_course = math.random(0, 360) - 180
			counter = math.random(0, 3)
		end
		-- calculate course for indicator	
		if source_angle ~= 90 then signal = 1
		else signal = 0
		end
		if signal > 0.5 then
			cr_angle = source_angle + (math.random() - 0.49999) * 2		
		else 
			cr_angle = random_course --math.random(0, 360) - 180
		end
		
	end
	if cr_angle > 180 then cr_angle = cr_angle - 360
	elseif cr_angle < -180 then cr_angle = cr_angle + 360 end
	
	-- set results
	if nav_flag == 0 or not power then set(k_flag, 1) else set(k_flag, 0) end
	if glide_flag == 0 or not power then set(g_flag, 1) else set(g_flag, 0) end
	
	if power and but ~= 0 then 
		set(k_flag, 0) 
		if landing or not real then set(g_flag, 0) end
	end
	
	if not landing or not real and power then 
		if but == 0 then set(nav_tofrom, nav_flag)
		elseif but == 2 then set(nav_tofrom, 1)
		else set(nav_tofrom, 2)
		end
	else
		set(nav_tofrom, 0)
	end
	
	set(curs, course)
	set(glide, glidesl)
	set(vor, cr_angle)
	
	
end


-- device consist of several components

components = {

    
    -----------------
    -- images --
    -----------------
--[[
	-- black hole
	rectangle {
        position = { 103, 76, 47, 18},		
		color = {0,0,0,1},
	},
--]]	
    -- digits
    digitstape {
        position = { 105, 88, 75, 30},
        image = digitsImage,
        digits = 6,
        showLeadingZeros = false,
		fractional = 2,
        value = function()
           return freq_num
        end,
		visible = function()
			return not power
		end,
    }; 
     -- digits
    digitstapeLit {
        position = { 105, 88, 75, 30},
        image = digitsImage,
        digits = 6,
        showLeadingZeros = false,
		fractional = 2,
        value = function()
           return freq_num
        end,
		visible = function()
			return power
		end,
    }; 
	
	-- glass
	texture {
		position = {111, 81, 74, 42},
		image = get(glass_img)
	},
	
    ---------------------
    -- click zones --
    ---------------------
 
 	-- power switch
    switch {
        position = { 230, 75, 50, 50 },
        state = function()
            return get(power_sw) ~= 0
        end,
       -- btnOn = get(tmb_right),
       -- btnOff = get(tmb_left),
        onMouseClick = function()
			if not switcher_pushed then           
				playSample(switch_sound, 0)
				if get(power_sw) ~= 0 then
					set(power_sw, 0)
				else
					set(power_sw, 1)
				end
				switcher_pushed = true
			end
            return true
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,		
    }, 	
	
 
 
    -- click zones for buttons
    clickable {
       position = { 95, 5, 35, 45 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
        onMouseClick = function(x, y, button) 
			if get(nav_button) == 0 then playSample(btn_click, 0) end
			if power and not isSamplePlaying(tone1) then playSample(tone1, 1) end
			set(nav_button, 1)
            return true
        end,
		onMouseUp = function()
			playSample(btn_click, 0)
			stopSample(tone1)
			set(nav_button, 0)
			return true
		end,
    },
    clickable {
       position = { 132, 5, 35, 45 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
        onMouseClick = function(x, y, button) 
			if get(nav_button) == 0 then playSample(btn_click, 0) end
			if power and not isSamplePlaying(tone2) then playSample(tone2, 1) end
			set(nav_button, 2)
            return true
        end,
		onMouseUp = function()
			playSample(btn_click, 0)
			stopSample(tone2)
			set(nav_button, 0)
			return true
		end,
    },
     clickable {
       position = { 169, 5, 35, 45 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
        onMouseClick = function(x, y, button) 
			if get(nav_button) == 0 then playSample(btn_click, 0) end
			if power and not isSamplePlaying(tone3) then playSample(tone3, 1) end
			set(nav_button, 3)
            return true
        end,
		onMouseUp = function()
			playSample(btn_click, 0)
			stopSample(tone3)
			set(nav_button, 0)
			return true
		end,
    },
	
    -- click zones for left knob
    clickable {
       position = { 5, 5, 45, 70 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function(x, y, button) 
            playSample(rotary_sound, 0)
			-- calculate new frequency
            freq_100 = freq_100 - 1
            if freq_100 < 108 then freq_100 = 117 end
            
            local fr = freq_100 * 100 + freq_10
            set(frequency, fr)
            
            return true
        end
    },
    
	clickable {
       position = { 50, 5, 45, 70},
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function(x, y, button) 
            playSample(rotary_sound, 0)
			-- calculate new frequency
            freq_100 = freq_100 + 1
            if freq_100 > 117 then freq_100 = 108 end
            
            local fr = freq_100 * 100 + freq_10
            set(frequency, fr)
            
            return true
        end
    },    

    
    -- click zones for right knob
    clickable {
       position = { 205, 5, 45, 70 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function(x, y, button) 
            playSample(rotary_sound, 0)
			-- calculate new frequency
            freq_10 = freq_10 - 5
            if freq_10 < 0 then freq_10 = 95 end
            
            local a, b = math.modf(freq_10 / 5)
   			if b ~= 0 then freq_10 = a * 5 end
            
            local fr = freq_100 * 100 + freq_10
            set(frequency, fr)
            
            return true
        end
    },
    
    clickable {
       position = {  250, 5, 45, 70 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function(x, y, button) 
            playSample(rotary_sound, 0)
			-- calculate new frequency
            freq_10 = freq_10 + 5
            if freq_10 > 95 then freq_10 = 0 end

            local a, b = math.modf(freq_10 / 5)
   			if b ~= 0 then freq_10 = a * 5 end
            
            local fr = freq_100 * 100 + freq_10
            set(frequency, fr)
            
            return true
        end
    },  

--[[	-- position gauge
	rectangle {
		position = {0, 0, size[1], size[2]},
	}, 
	--]]
}
