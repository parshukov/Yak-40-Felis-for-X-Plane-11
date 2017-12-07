size = {245, 110}

-- define property table
defineProperty("frequency", globalPropertyf("sim/cockpit2/radios/actuators/com1_frequency_hz"))  -- set the frequency

defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("AZS_COM_sw", globalPropertyi("sim/custom/xap/azs/AZS_COM_1_sw")) -- AZS switcher
defineProperty("inv_PO1500_radio", globalPropertyi("sim/custom/xap/power/inv_PO1500_radio")) -- inverter for 115v bus
defineProperty("com_cc", globalPropertyf("sim/custom/xap/gauges/com1_cc")) -- cc

-- images table
defineProperty("glass_cap", loadImage("gmk_panel.png", 0, 480, 68, 32)) 
--defineProperty("digitsImage", loadImage("white_digit_strip.png", 3, 0, 10, 196)) 
defineProperty("digitsImage", loadImage("red_digit_strip.png", 6, 0, 20, 392))
local rotary_sound = loadSample('Custom Sounds/rot_click.wav')

-- variables for separate manipulations
local freq_100 = 0  -- digits before period
local freq_10 = 0  -- digits after period

local freq_10_show = 0
local power = false

function update()
   local freq = get(frequency)
	power = get(DC_27_volt) > 21 and get(AZS_COM_sw) == 1 --and get(AC_115_volt) > 110 and get(inv_PO1500_radio) == 1
   -- calculate separate digits
   freq_100 = math.floor(freq / 100)  -- cut off last two digits
   freq_10 = freq - freq_100 * 100  -- cut off first digits 
   
   local freq_last = freq_10 - math.floor(freq_10 / 10) * 10 

   if freq_last == 2 or freq_last == 7 
      then freq_last = 5
      else freq_last = 0
   end

   freq_10_show = freq_10 * 10 + freq_last

   if power then set(com_cc, 1) else set(com_cc, 0) end

end


-- device consist of several components

components = {

    
    -----------------
    -- images --
    -----------------

    -- hundreds digits
    digitstapeLit {
        position = { 85, 70, 40, 25},
        image = digitsImage,
        digits = 3,
        showLeadingZeros = false,
        value = function()
           return freq_100 
        end,
		visible = function()
			return power
		end
    }; 
   
    -- decimals digits
    digitstapeLit {
        position = { 140, 70, 40, 25},
        image = digitsImage,
        digits = 3,
        showLeadingZeros = true,
        value = function()
           return freq_10_show 
        end,
		visible = function()
			return power
		end
    }; 
 --[[  
   -- glass cap image
    texture { 
        position = { 59, 63, 142, 36 },
        image = get(glass_cap)
    },
--]]
--[[
    -- left knob
    needle {
        position = { 17, 49, 43, 43 },
        image = get(small_knob),    
        angle = function()
           return (freq_100 - 118) * 40
        end,
    
    },
 
    -- right knob
    needle {
        position = { 139, 49, 43, 43 },
        image = get(small_knob),    
        angle = function()
           return freq_10 * 36 / 5
        end,
    
    },

--]]
    ---------------------
    -- click zones --
    ---------------------
    
    -- click zones for left knob
    clickable {
       position = {  3, 0, 30, 45 },
        
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
            if freq_100 < 118 then freq_100 = 136 end
            
            local fr = freq_100 * 100 + freq_10
            set(frequency, fr)
            
            return true
        end
    },
    
    clickable {
       position = {  33, 0, 30, 45 },
        
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
            if freq_100 > 136 then freq_100 = 118 end
            
            local fr = freq_100 * 100 + freq_10
            set(frequency, fr)
            
            return true
        end
    },    

    
    -- click zones for right knob
    clickable {
       position = {  178, 0, 30, 45 },
        
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
            freq_10 = math.floor((freq_10_show - 25) / 10)
            
            if freq_10 < 0 then freq_10 = 97 end
            
            local fr = freq_100 * 100 + freq_10
            set(frequency, fr)
            
            return true
        end
    },
    
    clickable {
       position = { 208, 0, 30, 45 },
        
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
            freq_10 = math.floor((freq_10_show + 25) / 10)

            if freq_10 > 97 then freq_10 = 0 end
            
            local fr = freq_100 * 100 + freq_10
            set(frequency, fr)
            
            return true
        end
    },  
	
--[[	
	rectangle {
		position = {0, 0, size[1], size[2]},
		color = {1,0,0,1},
	
	},  --]]

}

