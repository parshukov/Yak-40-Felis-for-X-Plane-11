size = {328, 257}


-- define peoperty table
defineProperty("xpdr_code", globalPropertyf("sim/cockpit/radios/transponder_code"))
defineProperty("xpdr_mode", globalPropertyf("sim/cockpit/radios/transponder_mode")) 
defineProperty("xpdr_led", globalPropertyf("sim/cockpit/radios/transponder_light"))
ident = findCommand("sim/transponder/transponder_ident")  -- comand of transponder ident
defineProperty("xpdr_fail", globalPropertyi("sim/operation/failures/rel_g_xpndr"))


-- digits
defineProperty("digit_1", globalPropertyi("sim/custom/xap/sq/digit_1"))
defineProperty("digit_2", globalPropertyi("sim/custom/xap/sq/digit_2"))
defineProperty("digit_3", globalPropertyi("sim/custom/xap/sq/digit_3"))
defineProperty("digit_4", globalPropertyi("sim/custom/xap/sq/digit_4"))

-- switchers
defineProperty("emerg", globalPropertyi("sim/custom/xap/sq/emerg"))
defineProperty("sq_emerg_cap", globalPropertyi("sim/custom/xap/sq/sq_emerg_cap"))
defineProperty("sq_mode", globalPropertyi("sim/custom/xap/sq/sq_mode"))

-- power
defineProperty("sq_sw", globalPropertyi("sim/custom/xap/sq/sq_sw"))
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("sq_cc", globalPropertyf("sim/custom/xap/sq/sq_cc"))
defineProperty("AZS_transp_sw", globalPropertyi("sim/custom/xap/azs/AZS_transp_sw"))
defineProperty("inv_PO1500_radio", globalPropertyi("sim/custom/xap/power/inv_PO1500_radio")) -- inverter for 115v bus

-- images
defineProperty("green_led", loadImage("leds.png", 105, 23, 6, 9)) 
defineProperty("red_led", loadImage("leds.png", 112, 23, 6, 9)) 
defineProperty("white_led", loadImage("leds.png", 125, 23, 6, 9)) 
defineProperty("digitsImage", loadImage("white_digit_strip.png", 3, 0, 10, 196)) 
--defineProperty("digitsImage", loadImage("red_digit_strip.png", 6, 0, 20, 392)) 
defineProperty("glass_img", loadImage("gmk_panel.png", 0, 480, 68, 32)) 

-- initial switchers values
defineProperty("N1", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[1]"))   
defineProperty("N2", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[0]"))
defineProperty("N3", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[2]"))
defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time of frame

local switch_sound = loadSample('Custom Sounds/metal_switch.wav')
local rotary_sound = loadSample('Custom Sounds/rot_click.wav')
local btn_click = loadSample('Custom Sounds/plastic_btn.wav')
local galet_sound = loadSample('Custom Sounds/metal_box_switch.wav')

local start_counter = 0
local notLoaded = true
local switcher_pushed = false

local emergency = false
local power = false       -- transponder's power
local last_code = get(xpdr_code)

function getDigits(squawk)
    local d1 = math.floor(squawk / 1000)
    squawk = squawk - d1 * 1000
    local d2 = math.floor(squawk / 100)
    squawk = squawk - d2 * 100
    local d3 = math.floor(squawk / 10)
    local d4 = squawk - d3 * 10
    return d1, d2, d3, d4
end

-- set transponder code
function setSquawk(d1, d2, d3, d4)
	last_code = d1 * 1000 + d2 * 100 + d3 * 10 + d4
	if not emergency then
		set(xpdr_code, last_code)
	else set(xpdr_code, 7700) end
end

-- first digit of squawk code
defineProperty("code_1", 
        function()
			local d1, d2, d3, d4 = getDigits(last_code)
			return d1
        end)

-- second digit of squawk code
defineProperty("code_2", 
        function(self, value)
			local d1, d2, d3, d4 = getDigits(last_code)
            return d2
        end)

-- third digit of squawk code
defineProperty("code_3", 
        function(self, value)
			local d1, d2, d3, d4 = getDigits(last_code)
            return d3
        end)

-- last digit of squawk code
defineProperty("code_4", 
        function(self, value)
			local d1, d2, d3, d4 = getDigits(last_code)
            return d4
        end)

-- set knobs initial positions
set(digit_1, get(code_1))
set(digit_2, get(code_2))
set(digit_3, get(code_3))
set(digit_4, get(code_4))

local xpdr_light = get(xpdr_led) > 0.5
local xpdr_emerg = false
function update()
	local passed = get(frame_time)
	
	start_counter = start_counter + passed	
	if start_counter > 0.3 and start_counter < 0.5 and notLoaded and get(N1) < 10 and get(N2) < 10 and get(N3) < 10 then
		set(sq_sw, 0)
		set(xpdr_mode, 0)
		notLoaded = false
	end	
	
	
	power = get(sq_sw) > 0 and get(xpdr_fail) < 6 and get(DC_27_volt) > 21 and get(AZS_transp_sw) > 0 and get(AC_115_volt) > 110 and get(inv_PO1500_radio) == 1
	local mode = get(sq_mode)
	if power then 
		set(xpdr_mode, mode) 
		set(sq_cc, 2)
		xpdr_light = get(xpdr_led) > 0.5 and mode > 0
		xpdr_emerg = emergency and mode > 0
	else 
		set(xpdr_mode, 0) 
		set(sq_cc, 0)
		xpdr_light = false
		xpdr_emerg = false
	end
  
end  


-- transponder cosist of several components

components = {
	
	-- transponder light
	textureLit {
		position = {31, 197, 25, 28},
		image = get(green_led),
		visible = function()
			return xpdr_light
		end
	},
	
	-- transponder light
	textureLit {
		position = {31, 197, 25, 28},
		image = get(red_led),
		visible = function()
			return xpdr_emerg
		end
	},

    -- digits
    digitstapeLit {
        position = { 139, 82, 55, 30},
        image = digitsImage,
        digits = 4,
        showLeadingZeros = true,
		allowNonRound = false,
		--fractional = 2,
        value = function()
           return last_code
        end,
		visible = function()
			return power
		end
    }; 	

    -- digits
    digitstape {
        position = { 139, 82, 55, 30},
        image = digitsImage,
        digits = 4,
        showLeadingZeros = true,
		allowNonRound = false,
		--fractional = 2,
        value = function()
           return last_code
        end,
		visible = function()
			return not power
		end
    }; 	


	-- glass
	texture {
		position = {133, 79, 66, 35},
		image = get(glass_img)
	},
	
	
    -- power switch
    switch {
        position = { 278, 140, 40, 60},
        state = function()
            return get(sq_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
		onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(sq_sw) ~= 0 then
					set(sq_sw, 0)
				else
					set(sq_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    }, 

   -- mode knob rotary
   rotary {
       position = {132, 150, 100, 90},
       value = sq_mode,
       step = 1,
       adjuster = function(v)
          if v >= 0 and v <= 3 then playSample(galet_sound, 0) end
		  if v > 3 then v = 3 end
          if v < 0 then v = 0 end
          return v
       end,
   },   

    -- digit rotaries
    -- digit 1
    rotary_vert {
        position = { 89, 0, 25, 100 },
        value = code_1;
        adjuster = function(v)
            playSample(rotary_sound, 0)
			if 0 > v then
                v = 7;
            elseif 7 < v then
                v = 0
            end
            local d1, d2, d3, d4 = getDigits(last_code)
			setSquawk(v, d2, d3, d4)
			set(digit_1, get(code_1))
        end;
    },
    
    -- digit 2
   rotary_vert {
        position = { 114, 0, 25, 100 },
        value = code_2;
        adjuster = function(v)
             playSample(rotary_sound, 0)
			if 0 > v then
                v = 7;
            elseif 7 < v then
                v = 0
            end
            local d1, d2, d3, d4 = getDigits(last_code)
            setSquawk(d1, v, d3, d4)
			set(digit_2, get(code_2))
        end;
    },

    -- digit 3
    rotary_vert {
        position = { 195, 0, 25, 100 },
        value = code_3;
        adjuster = function(v)
             playSample(rotary_sound, 0)
			if 0 > v then
                v = 7;
            elseif 7 < v then
                v = 0
            end
            local d1, d2, d3, d4 = getDigits(last_code)
            setSquawk(d1, d2, v, d4)
			set(digit_3, get(code_3))
        end;
    },

    -- digit 4
    rotary_vert {
        position = {  220, 0, 25, 100},
        value = code_4;
        adjuster = function(v)
             playSample(rotary_sound, 0)
			if 0 > v then
                v = 7;
            elseif 7 < v then
                v = 0
            end
            local d1, d2, d3, d4 = getDigits(last_code)
            setSquawk(d1, d2, d3, v)
			set(digit_4, get(code_4))
        end;
    },


	-- ident button
    clickable {
       position = { 270, 30, 40, 40 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
        onMouseClick = function()
            if not switcher_pushed then playSample(btn_click, 0) end
			switcher_pushed = true
			if power then commandOnce(ident) end
            return true
        end,
		onMouseUp = function()
			switcher_pushed = false
			playSample(btn_click, 0)
			return true
		end,
    },  

	-- emergency button
	clickable {
       position = { 25, 30, 40, 40 },
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
        onMouseClick = function()
            if get(sq_emerg_cap) > 0 then
				if not switcher_pushed then 
					playSample(btn_click, 0) 
					switcher_pushed = true
					emergency = not emergency
					if emergency then set(emerg, 1)
					else set(emerg, 0) end
					local d1, d2, d3, d4 = getDigits(last_code)
					setSquawk(d1, d2, d3, d4)
				end
			end
			return true
        end,
		onMouseUp = function()
			switcher_pushed = false
			if get(sq_emerg_cap) > 0 then playSample(btn_click, 0) end
			return true
		end,		
    }, 
--[[
	rectangle {
		position = {0, 0, size[1], size[2]},
		color = {1,0,0,1},
	},
--]]
}

