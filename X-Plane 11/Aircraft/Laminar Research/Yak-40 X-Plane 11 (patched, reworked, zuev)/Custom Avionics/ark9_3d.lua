size = {500, 364}


-- define component property table. 
defineProperty("left_freq", globalPropertyf("sim/cockpit2/radios/actuators/adf1_frequency_hz"))  -- left frequency
defineProperty("right_freq", globalPropertyf("sim/cockpit2/radios/actuators/adf1_standby_frequency_hz"))  -- right frequency
defineProperty("active", globalPropertyf("sim/cockpit2/radios/actuators/adf1_right_is_selected"))  -- selector of active disk. 0 - left, 1 - right 


-- switchers on panel
defineProperty("ark_mode", globalPropertyi("sim/custom/xap/ark/ark_1_mode"))
defineProperty("ant_sw", globalPropertyi("sim/custom/xap/ark/ark_1_ant_sw"))
defineProperty("left_1", globalPropertyf("sim/custom/xap/ark/ark_1_left_1"))  -- left disk for set 0-9 kHz
defineProperty("left_10", globalPropertyf("sim/custom/xap/ark/ark_1_left_10"))  -- left disk for set 00-90 kHz
defineProperty("left_100", globalPropertyf("sim/custom/xap/ark/ark_1_left_100"))  -- left disk for set 100-1200 kHz
defineProperty("right_1", globalPropertyf("sim/custom/xap/ark/ark_1_right_1"))  -- right disk for set 0-9 kHz
defineProperty("right_10", globalPropertyf("sim/custom/xap/ark/ark_1_right_10"))  -- right disk for set 00-90 kHz
defineProperty("right_100", globalPropertyf("sim/custom/xap/ark/ark_1_right_100"))  -- right disk for set 100-1200 kHz
defineProperty("backlit", globalPropertyi("sim/custom/xap/ark/ark_1_backlit"))

defineProperty("res_signal", globalPropertyf("sim/custom/xap/ark/ark_1_signal"))
defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames



-- define image table
--[[defineProperty("big_disk", loadImage("ark9_set.png", 406.5, 5, 100, 100))
defineProperty("small_disk", loadImage("ark9_set.png", 428, 112, 56, 56))
defineProperty("ones_disk", loadImage("ark9_set.png", 436, 191, 40, 40))
defineProperty("disk_handle", loadImage("ark9_set.png", 444, 234, 22, 68))
defineProperty("niddle", loadImage("ark9_set.png", 411, 214, 1, 58))
defineProperty("caps", loadImage("ark9_set.png", 0, 297, 296, 88))
defineProperty("mode_selector", loadImage("ark9_set.png", 434, 320, 43, 76))--]]
defineProperty("signal_nd", loadImage("ark9_set.png", 410, 239, 2, 57)) 


defineProperty("tmb_left", loadImage("tumbler_left.png"))
defineProperty("tmb_right", loadImage("tumbler_right.png"))
defineProperty("background_lit", loadImage("ark9_set_lit.png", 0, 0, 388, 284))
defineProperty("digitsImage", loadImage("white_digit_strip.png", 1, 0, 14, 196))

local switch_sound = loadSample('Custom Sounds/metal_switch.wav')
local rotary_sound = loadSample('Custom Sounds/rot_click.wav')
local big_rot_sound = loadSample('Custom Sounds/metal_box_switch.wav')
local small_rot_sound = loadSample('Custom Sounds/plastic_switch.wav')

local ones_left = 0
local decades_left = 0
local hundreds_left = 0
local ones_right  = 0
local decades_right = 0
local hundreds_right = 0
local freq_R = 0
local freq_L = 0
local act = 0

local light = false
local signal = 0
local signal_last = 0
local switcher_pushed = false


function update()
	local passed = get(frame_time)
    
    act = get(active)
	local left_fr = get(left_freq)
    local right_fr = get(right_freq)
	
	-- set disks to their freq
    if get(active) == 0 then
       freq_R = right_fr
       freq_L = left_fr
    else
       freq_L = right_fr
       freq_R = left_fr
    end
	
	-- calculate disks position
	ones_left = freq_L - math.floor(freq_L / 10) * 10
	decades_left = freq_L - math.floor(freq_L / 100) * 100 - ones_left
	hundreds_left = math.floor(freq_L / 100) * 100 

	ones_right = freq_R - math.floor(freq_R / 10) * 10
	decades_right = freq_R - math.floor(freq_R / 100) * 100 - ones_right
	hundreds_right = math.floor(freq_R / 100) * 100
	
	light = get(backlit) == 1

	local signal_need = get(res_signal)
	signal = signal + (signal_need - signal_last) * passed * 3
	signal_last = signal
	
end


components = {
--[[
	rectangle {
		position = {0,0,size[1], size[2]}
	},

--]]

	-- background image
    textureLit { 
        position = { -3, -4, size[1]+3, size[2]+5 },
        image = get(background_lit),
        visible = function()
			return light
        end
    }, 


	-- show freq left
   digitstapeLit {
        position = { 100, 75, 52, 27},
        image = digitsImage,
        digits = 4,
		showLeadingZeros = true,
        value = function() 
            return hundreds_left + decades_left
        end,
		visible = function()
			return light
		end,
    };

	-- show freq left
   digitstapeLit {
        position = { 332, 75, 52, 27},
        image = digitsImage,
        digits = 4,
		showLeadingZeros = true,
        value = function() 
            return hundreds_right + decades_right
        end,
		visible = function()
			return light
		end,
    };

	-- show freq left
   digitstape {
        position = { 100, 75, 52, 27},
        image = digitsImage,
        digits = 4,
		showLeadingZeros = true,
        value = function() 
            return hundreds_left + decades_left
        end,
		visible = function()
			return not light
		end,
    };

	-- show freq left
   digitstape {
        position = { 332, 75, 52, 27},
        image = digitsImage,
        digits = 4,
		showLeadingZeros = true,
        value = function() 
            return hundreds_right + decades_right
        end,
		visible = function()
			return not light
		end,
    };

	-- signal needle
    needle {
        position = { 149, 273, 57, 57  },
        image = get(signal_nd),
        angle = function ()
           return signal * 120 - 60
        end
     },   



    -- click zones for set left ones
    clickable {
       position = { 15, 40, 40, 90 },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function(x, y, button) 
            
			local freq
            if ones_left > 0 then
               playSample(rotary_sound, 0)
			   ones_left = ones_left - 1
               freq = hundreds_left + decades_left + ones_left
               if act == 0 then
                  set(left_freq, freq)
               else set(right_freq, freq)
               end
            end
            return true
        end
    },

    clickable {
       position = { 55, 40, 40, 90 },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function(x, y, button) 
			local freq
            if ones_left < 9 then
               playSample(rotary_sound, 0)
			   ones_left = ones_left + 1
               freq = hundreds_left + decades_left + ones_left
               if act == 0 then
                  set(left_freq, freq)
               else set(right_freq, freq)
               end
            end
            return true
        end
    },  

    -- click zones for set right ones
    clickable {
       position = {  248, 40, 40, 90 },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function(x, y, button) 
            local freq
            if ones_right > 0 then
               playSample(rotary_sound, 0)
			   ones_right = ones_right - 1
               freq = hundreds_right + decades_right + ones_right
               if act == 0 then
                  set(right_freq, freq)
               else set(left_freq, freq)
               end
            end
            return true
        end
    },

    clickable {
       position = { 288, 40, 40, 90 },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function(x, y, button) 
            local freq
            if ones_right < 9 then
               playSample(rotary_sound, 0)
			   ones_right = ones_right + 1
               freq = hundreds_right + decades_right + ones_right
               if act == 0 then
                  set(right_freq, freq)
               else set(left_freq, freq)
               end
            end
            return true
        end
    },

    -- click zones for set left decades
    clickable {
       position = { 145, 45, 50, 40 },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function(x, y, button) 
            playSample(big_rot_sound, 0)
			local freq
            decades_left = decades_left - 10
            if decades_left == -10 then decades_left = 90 end
            freq = hundreds_left + decades_left + ones_left
               if act == 0 then
                  set(left_freq, freq)
               else set(right_freq, freq)
               end
            return true
        end
    },

    clickable {
       position = { 145, 90, 50, 40 },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function(x, y, button) 
            playSample(big_rot_sound, 0)
			local freq
            decades_left = decades_left + 10
            if decades_left == 100 then decades_left = 0 end
            freq = hundreds_left + decades_left + ones_left
               if act == 0 then
                  set(left_freq, freq)
               else set(right_freq, freq)
               end
            return true
        end
    },

    -- click zones for set right decades
    clickable {
       position = { 378, 45, 50, 40 },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function(x, y, button) 
            playSample(big_rot_sound, 0)
			local freq
            decades_right = decades_right - 10
            if decades_right == -10 then decades_right = 90 end
            freq = hundreds_right + decades_right + ones_right
               if act == 0 then
                  set(right_freq, freq)
               else set(left_freq, freq)
               end
            
            return true
        end
    },

    clickable {
       position = { 378, 90, 50, 40 },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function(x, y, button) 
            playSample(big_rot_sound, 0)
			local freq
            decades_right = decades_right + 10
            if decades_right == 100 then decades_right = 0 end
            freq = hundreds_right + decades_right + ones_right
               if act == 0 then
                  set(right_freq, freq)
               else set(left_freq, freq)
               end
            return true
        end
    },

    -- click zones for set left hundreds
    clickable {
       position = { 100, 70, 40, 40 },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function(x, y, button) 
            playSample(big_rot_sound, 0)
			local freq
            hundreds_left = hundreds_left - 100
            if hundreds_left == 0 then hundreds_left = 1200 end
            freq = hundreds_left + decades_left + ones_left
               if act == 0 then
                  set(left_freq, freq)
               else set(right_freq, freq)
               end
            return true
        end
    },

    clickable {
       position = {  200, 70, 40, 40},
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function(x, y, button) 
            playSample(big_rot_sound, 0)
			local freq
            hundreds_left = hundreds_left + 100
            if hundreds_left == 1300 then hundreds_left = 100 end
            freq = hundreds_left + decades_left + ones_left
               if act == 0 then
                  set(left_freq, freq)
               else set(right_freq, freq)
               end
            return true
        end
    },	
	
    -- click zones for set right hundreds
    clickable {
       position = { 335, 70, 40, 40 },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function(x, y, button) 
            playSample(big_rot_sound, 0)
			local freq
            hundreds_right = hundreds_right - 100
            if hundreds_right == 0 then hundreds_right = 1200 end
            freq = hundreds_right + decades_right + ones_right
               if act == 0 then
                  set(right_freq, freq)
               else set(left_freq, freq)
               end
            return true
        end
    },

    clickable {
       position = { 430, 70, 40, 40 },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function(x, y, button) 
            playSample(big_rot_sound, 0)
			local freq
            hundreds_right = hundreds_right + 100
            if hundreds_right == 1300 then hundreds_right = 100 end
            freq = hundreds_right + decades_right + ones_right
               if act == 0 then
                  set(right_freq, freq)
               else set(left_freq, freq)
               end
            return true
        end
    },	
	
    -- click zones for set ark mode
    clickable {
       position = { 240, 240, 40, 60 },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function(x, y, button) 
			local a = get(ark_mode) - 1
			if a >= 0 then playSample(small_rot_sound, 0) end
			if a < 0 then a = 0 end
            set(ark_mode, a)
            return true
        end
    },

    clickable {
       position = { 285, 240, 40, 60 },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function(x, y, button) 
			local a = get(ark_mode) + 1
			if a <=3 then playSample(small_rot_sound, 0) end
			if a > 3 then a = 3 end
            set(ark_mode, a)
            return true
        end
    }, 	
	
	
    -- click zones for rotate antenna
    clickable {
       position = { 310, 290, 40, 60 },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function(x, y, button) 
            if not switcher_pushed then playSample(switch_sound, 0) end
			switcher_pushed = true
			set(ant_sw, -1)
			return true
        end,
		onMouseUp = function()
            switcher_pushed = false
			playSample(switch_sound, 0)
			set(ant_sw, 0)
			return true		
		end
    },

    clickable {
       position = { 360, 290, 40, 60  },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function(x, y, button) 
            if not switcher_pushed then playSample(switch_sound, 0) end
			switcher_pushed = true
			set(ant_sw, 1)
			return true
        end,
		onMouseUp = function()
            switcher_pushed = false
			playSample(switch_sound, 0)
			set(ant_sw, 0)
			return true		
		end
    }, 		
	
	
    -- select left/right disk
    switch {
        position = { 1, 344, 18, 18 },
        state = function()
            return get(active) ~= 0
        end,
       -- btnOn = get(tmb_right),
       -- btnOff = get(tmb_left),
        onMouseClick = function()
			if not switcher_pushed then           
				playSample(switch_sound, 0)
				if get(active) == 1 then
					set(active, 0)
					set(left_freq, freq_L)
					set(right_freq, freq_R)
				else
					set(active, 1)
					set(left_freq, freq_R)
					set(right_freq, freq_L)
				end
				switcher_pushed = true
			end
            return true
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,		
    }, 	
	

	
}

