size = {300, 135}

-- define property table
defineProperty("frequency", globalPropertyf("sim/cockpit2/radios/actuators/dme_frequency_hz"))  -- set the frequency

-- images table
--defineProperty("glass_cap", loadImage("scales_1.png", 142, 418, 78, 32))
defineProperty("digitsImage", loadImage("red_digit_strip.png", 6, 0, 20, 392))

defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("dme_power_sw", globalPropertyf("sim/custom/xap/gauges/dme_power_sw")) -- power switcher for DME
defineProperty("dme_mode_sw", globalPropertyf("sim/custom/xap/gauges/dme_mode_sw")) -- mode switcher for DME, 0 = km, 1 = miles
defineProperty("inv_PO1500_steklo", globalPropertyi("sim/custom/xap/power/inv_PO1500_steklo")) -- inverter for 115v bus
defineProperty("AZS_DME_sw", globalPropertyf("sim/custom/xap/azs/AZS_DME_sw")) -- mode switcher for DME, 0 = km, 1 = miles
defineProperty("fail", globalPropertyi("sim/operation/failures/rel_dme")) -- failure


defineProperty("dme_cc", globalPropertyf("sim/custom/xap/gauges/dme_cc")) --cc

defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames

defineProperty("N1", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[1]"))   
defineProperty("N2", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[0]"))
defineProperty("N3", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[2]"))

local switch_sound = loadSample('Custom Sounds/metal_switch.wav')
local rotary_sound = loadSample('Custom Sounds/rot_click.wav')

-- variables for separate manipulations
local freq_100  = 0
local freq_10 = 0

local power = false
local freq = get(frequency)
 
local start_counter = 0
local notLoaded = true 
 
function update()
	local passed = get(frame_time)

    start_counter = start_counter + passed	
    
    -- initial switchers position
    if start_counter > 0.3 and start_counter < 0.5 and notLoaded and get(N1) < 10 and get(N2) < 10 and get(N3) < 10 then
		set(dme_power_sw, 0)
		notLoaded = false
	end
	
	power = get(DC_27_volt) > 21 and get(dme_power_sw) > 0 and get(AZS_DME_sw) > 0 and get(AC_115_volt) > 110 and get(inv_PO1500_steklo) == 1 and get(fail) < 6
	freq = get(frequency)
  -- calculate separate digits
   freq_100 = math.floor(freq / 100)  -- cut off last two digits
   freq_10 = freq - freq_100 * 100  -- cut off first digits

   if power then set(dme_cc, 1) else set(dme_cc, 0) end

end

local switcher_pushed = false
-- device consist of several components

components = {

    
    -----------------
    -- images --
    -----------------

    -- hundreds digits
    digitstapeLit {
        position = { 90, 85, 100, 30},
        image = digitsImage,
        digits = 6,
        showLeadingZeros = false,
		allowNonRound = false,
		fractional = 2,
        value = function()
           return freq * 0.01
        end,
		visible = function()
			return power
		end,
    }; 
 --[[   
    -- decimals digits
    digitstapeLit {
        position = {160, 85, 40, 30},
        image = digitsImage,
        digits = 2,
        showLeadingZeros = true,
        value = function()
           return freq_10 
        end
    }; --]]
 --[[   
   -- glass cap image
    texture { 
        position = { 0, 43, 80, 36 },
        image = get(glass_cap)
    },
 --]]

    ---------------------
    -- click zones --
    ---------------------
    
    -- click zones for left knob
    clickable {
       position = { 10, 0, 40, 70 },
        
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
       position = { 50, 0, 40, 70 },
        
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
       position = {210, 0, 40, 70 },
        
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
       position = { 250, 0, 40, 70 },
        
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

	-- dme_power_sw switcher
    switch {
        position = {30, 80, 40, 40},
        state = function()
            return get(dme_power_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(dme_power_sw) ~= 0 then
					set(dme_power_sw, 0)
				else
					set(dme_power_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

	-- dme_mode_sw switcher
    switch {
        position = {130, 10, 40, 40},
        state = function()
            return get(dme_mode_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(dme_mode_sw) ~= 0 then
					set(dme_mode_sw, 0)
				else
					set(dme_mode_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
--[[	
	rectangle {
		position = {0, 0, size[1], size[2]},
		color = {1,0,0,1},
	
	}, 
--]]	
}
