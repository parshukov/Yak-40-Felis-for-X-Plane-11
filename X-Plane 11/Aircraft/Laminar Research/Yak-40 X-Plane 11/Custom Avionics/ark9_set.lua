-- define component property table. 
-- source
defineProperty("left_freq", globalPropertyf("sim/cockpit2/radios/actuators/adf1_frequency_hz"))  -- left frequency
defineProperty("right_freq", globalPropertyf("sim/cockpit2/radios/actuators/adf1_standby_frequency_hz"))  -- right frequency
defineProperty("active", globalPropertyf("sim/cockpit2/radios/actuators/adf1_right_is_selected"))  -- selector of active disk. 0 - left, 1 - right 
defineProperty("fail", globalPropertyf("sim/operation/failures/rel_adf1"))
defineProperty("adf", globalPropertyf("sim/cockpit2/radios/indicators/adf1_relative_bearing_deg"))
defineProperty("audio_selection", globalPropertyi("sim/cockpit2/radios/actuators/audio_selection_adf1"))

-- switchers on panel
defineProperty("ark_mode", globalPropertyi("sim/custom/xap/ark/ark_1_mode"))
defineProperty("ant_sw", globalPropertyi("sim/custom/xap/ark/ark_1_ant_sw"))
defineProperty("left_1", globalPropertyf("sim/custom/xap/ark/ark_1_left_1"))  -- left disk for set 0-9 kHz
defineProperty("left_10", globalPropertyf("sim/custom/xap/ark/ark_1_left_10"))  -- left disk for set 00-90 kHz
defineProperty("left_100", globalPropertyf("sim/custom/xap/ark/ark_1_left_100"))  -- left disk for set 100-1200 kHz
defineProperty("right_1", globalPropertyf("sim/custom/xap/ark/ark_1_right_1"))  -- right disk for set 0-9 kHz
defineProperty("right_10", globalPropertyf("sim/custom/xap/ark/ark_1_right_10"))  -- right disk for set 00-90 kHz
defineProperty("right_100", globalPropertyf("sim/custom/xap/ark/ark_1_right_100"))  -- right disk for set 100-1200 kHz

-- power
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("ark_cc", globalPropertyf("sim/custom/xap/ark/ark_1_cc")) -- cc


defineProperty("AZS", globalPropertyi("sim/custom/xap/azs/AZS_ARK_1_sw")) -- AZS switcher
defineProperty("inverter", globalPropertyi("sim/custom/xap/power/inv_PO1500_radio")) -- inverter for 115v bus

-- result
defineProperty("res_angle", globalPropertyf("sim/custom/xap/ark/ark_1_angle"))
defineProperty("res_signal", globalPropertyf("sim/custom/xap/ark/ark_1_signal"))
defineProperty("backlit", globalPropertyi("sim/custom/xap/ark/ark_1_backlit"))

defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames

defineProperty("N1", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[1]"))   
defineProperty("N2", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[0]"))
defineProperty("N3", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[2]"))

-- define image table
defineProperty("background", loadImage("ark9_set.png", 0, 0, 388, 284))
defineProperty("big_disk", loadImage("ark9_set.png", 406.5, 5, 100, 100))
defineProperty("small_disk", loadImage("ark9_set.png", 428, 112, 56, 56))
defineProperty("ones_disk", loadImage("ark9_set.png", 436, 191, 40, 40))
defineProperty("disk_handle", loadImage("ark9_set.png", 444, 234, 22, 68))
defineProperty("niddle", loadImage("ark9_set.png", 411, 214, 1, 58))
defineProperty("caps", loadImage("ark9_set.png", 0, 297, 296, 88))
defineProperty("mode_selector", loadImage("ark9_set.png", 434, 320, 43, 76))
defineProperty("signal_nd", loadImage("ark9_set.png", 410, 239, 2, 57)) 


defineProperty("tmb_left", loadImage("tumbler_left.png"))
defineProperty("tmb_right", loadImage("tumbler_right.png"))
defineProperty("background_lit", loadImage("ark9_set_lit.png", 0, 0, 388, 284))



-- define initial position for disks
set(active, 1) -- by default active disk is right

defineProperty("active2", globalPropertyf("sim/cockpit2/radios/actuators/adf2_right_is_selected"))  -- selector of active disk. 0 - left, 1 - right 

set(active2, 0)



-- define local variables

local ones_left = 0
local decades_left = 0
local hundreds_left = 0
local ones_right  = 0
local decades_right = 0
local hundreds_right = 0

local ones_left_angle = 0
local decades_left_angle = 0
local hundreds_left_angle = 0
local ones_right_angle = 0
local decades_right_angle = 0
local hundreds_right_angle = 0

local freq_R = 0
local freq_L = 0
local act = 0
local mode_sel = 0
local signal = 0
local power = false

local counter = 5
local random_course = 0

local cr_angle = 0

local start_counter = 0
local notLoaded = true

function update()
	act = get(active)
    power = get(DC_27_volt) > 21 and get(AZS) == 1 and get(AC_115_volt) > 110 and get(inverter) == 1
	local passed = get(frame_time)

    start_counter = start_counter + passed	
    
    -- initial switchers position
    if start_counter > 0.3 and start_counter < 0.5 and notLoaded and get(N1) < 10 and get(N2) < 10 and get(N3) < 10 then
    	set(ark_mode, 0)
    	notLoaded = false
    end
	
    -- set limits for frequency that gauge can set (0100 - 1299)
    local left_fr = get(left_freq)
    local right_fr = get(right_freq)
    if left_fr > 1299 then 
    	set(left_freq, 1299) 
    	left_fr = 1299
    end
    if left_fr < 100 then 
    	set(left_freq, 100) 
    	left_fr = 100
    end
    if right_fr > 1299 then
    	set(right_freq, 1299)
    	right_fr = 1299
    end
    if right_fr < 100 then
    	set(right_freq, 100)
    	right_fr = 100
    end 
 
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
	
	-- calculate animation
	ones_left_angle = ones_left * 30 - 90
	decades_left_angle = decades_left * 360 / 100
	hundreds_left_angle = hundreds_left * 30 / 100 - 30
	ones_right_angle = ones_right * 30 - 90
	decades_right_angle = decades_right * 360 / 100
	hundreds_right_angle = hundreds_right * 30 / 100 - 30
   
   -- set variables for animation in degrees 
   set(left_1, ones_left_angle)
   set(left_10, decades_left_angle)
   set(left_100, hundreds_left_angle)

   set(right_1, ones_right_angle)
   set(right_10, decades_right_angle)
   set(right_100, hundreds_right_angle)  
 
	--------------------------
	-- bearing calculations --
	--------------------------
	
	local source_angle = get(adf)
	local mode = get(ark_mode)
	local signal = 0
	if power and mode > 0 and get(fail) < 6 then
		set(backlit, 1)
		set(ark_cc, 0.3)
		-- calculate random course
		counter = counter + passed
		if counter > 3 then 
			random_course = math.random(0, 360) - 180
			counter = math.random(0, 3)
		end
		-- calculate course for indicator	
		if source_angle ~= 90 then signal = 1 + (math.random() - 0.49999) * 0.2
		else signal = math.random() * 0.2
		end
		if mode == 1 and signal > 0.5 then
			cr_angle = source_angle + (math.random() - 0.49999) * 2		
		elseif mode == 3 then
			cr_angle = cr_angle + get(ant_sw) * passed * 20
			signal = signal * math.abs(math.cos(math.rad(source_angle - cr_angle)))
		elseif mode == 1 then
			cr_angle = random_course --math.random(0, 360) - 180
		end	
	else 
		set(backlit, 0)
		set(ark_cc, 0)
	end
	if cr_angle > 180 then cr_angle = cr_angle - 360
	elseif cr_angle < -180 then cr_angle = cr_angle + 360 end
	
	set(res_signal, signal)
	set(res_angle, cr_angle)

	-- calculate audio
	--if power and mode == 2 then set(audio_selection, 1) else set(audio_selection, 0) end


end  


--[[

components = {

    -- background image
    texture { 
        position = { 0, 0, 388, 284 },
        image = get(background)
    },

    -- background image
    textureLit { 
        position = { 0, 0, 388, 284 },
        image = get(background_lit),
        visible = function()
           if get(mode) > 0 and get(fail) < 6 and power == 1 then return true
           else return false
           end 
           return false        
        end
    }, 

	-- signal needle
    needle {
        position = { 111, 205, 57, 57  },
        image = get(signal_nd),
        angle = function ()
           return signal * 90 - 45
        end
     },    

    
    -- left ones disk
    needle {
        position = { 25, 48, 40, 40 },
        image = get(ones_disk),
        angle = function ()
           return -90 + ones_left * 30
        end
    
    },

    -- right ones disk
    needle {
        position = { 204, 48, 40, 40 },
        image = get(ones_disk),
        angle = function ()
           return -90 + ones_right * 30
        end
    
    },
    
    -- left big disk
    needle {
        position = { 83, 20, 100, 100 },
        image = get(big_disk),
        angle = function ()
           return hundreds_left * 30 / 100 - 30
        end
    
    },

    -- right big disk
    needle {
        position = { 262, 20, 100, 100 },
        image = get(big_disk),
        angle = function ()
           return hundreds_right * 30 / 100 - 30
        end
    
    },        

    -- left small disk
    needle {
        position = { 104, 42, 56, 56 },
        image = get(small_disk),
        angle = function ()
           return decades_left * 36 / 10
        end
    
    },
    
    -- right small disk
    needle {
        position = { 284, 42, 56, 56 },
        image = get(small_disk),
        angle = function ()
           return decades_right * 36 / 10
        end
    
    },
    
    -- caps image
    texture { 
        position = { 74, 23, 296, 88 },
        image = get(caps)
    },   

    -- left handle
    needle {
        position = { 98, 36, 68, 68 },
        image = get(disk_handle),
        angle = function ()
           return decades_left * 36 / 10
        end
    
    },
    
    -- right handle
    needle {
        position = { 278, 36, 68, 68 },
        image = get(disk_handle),
        angle = function ()
           return decades_right * 36 / 10
        end
    
    },

    -- mode handle
    needle {
        position = { 183, 171, 76, 76 },
        image = get(mode_selector),
        angle = function ()
           return mode_sel * 30 - 60
        end
    
    },    

    -- select left/right disk
    switch {
        position = { 242, 230, 64, 18 },
        state = function()
            return get(active) ~= 0
        end,
        btnOn = get(tmb_right),
        btnOff = get(tmb_left),
        onMouseClick = function()
            if get(active) == 1 then
                set(active, 0)
                set(left_freq, freq_L)
                set(right_freq, freq_R)
            else
                set(active, 1)
                set(left_freq, freq_R)
                set(right_freq, freq_L)
            end 
            return true
        end   
    },   

    -- click zones for set left ones
    clickable {
       position = { 14, 50, 25, 40 },
        
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
       position = { 42, 50, 25, 40 },
        
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
       position = { 195, 50, 25, 40 },
        
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
       position = { 225, 50, 25, 40 },
        
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
       position = { 75, 50, 30, 40 },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function(x, y, button) 
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
       position = { 158, 50, 30, 40 },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function(x, y, button) 
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
       position = { 255, 50, 30, 40 },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function(x, y, button) 
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
       position = { 335, 50, 30, 40 },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function(x, y, button) 
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
       position = { 115, 30, 35, 25 },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function(x, y, button) 
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
       position = { 115, 90, 35, 25 },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function(x, y, button) 
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
       position = { 290, 30, 35, 25 },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function(x, y, button) 
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
       position = { 290, 90, 35, 25 },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function(x, y, button) 
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
 
    -- click zones for set left ones
    clickable {
       position = { 183, 175, 30, 60 },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function(x, y, button) 
            local mod
            if mode_sel > 0 then mode_sel = mode_sel - 1 end
            
            if mode_sel == 0 then mod = 0 end
            if mode_sel == 1 then mod = 2 end
            if mode_sel == 2 then mod = 1 end
            if mode_sel == 3 then mod = 3 end
            
            set(mode, mod)
            return true
        end
    },

    clickable {
       position = { 220, 175, 25, 60 },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function(x, y, button) 
            local mod
            if mode_sel < 3 then mode_sel = mode_sel + 1 end
            
            if mode_sel == 0 then mod = 0 end
            if mode_sel == 1 then mod = 2 end
            if mode_sel == 2 then mod = 1 end
            if mode_sel == 3 then mod = 3 end
            
            set(mode, mod)
            return true
        end
    }, 
 

}
--]]
