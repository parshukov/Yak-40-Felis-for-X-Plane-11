-- this is overall GMK panel
size = {458, 271}

defineProperty("gyro_mode", globalPropertyi("sim/custom/xap/gauges/gyro_mode")) -- 0 = MK, 1 = GPK, 2 = AK
defineProperty("GMK_curse1", globalPropertyf("sim/custom/xap/gauges/GMK_curse1")) -- calculated course
defineProperty("GMK_curse2", globalPropertyf("sim/custom/xap/gauges/GMK_curse2")) -- calculated course
defineProperty("GMK_curse", globalPropertyf("sim/custom/xap/gauges/GMK_curse")) -- result calculated course
defineProperty("GMK_north", globalPropertyf("sim/custom/xap/gauges/GMK_north")) -- switcher North/South
defineProperty("GMK_lat", globalPropertyf("sim/custom/xap/gauges/GMK_lat")) -- rotary for set latitude
defineProperty("GMK_lat_rot", globalPropertyf("sim/custom/xap/gauges/GMK_lat_rot")) -- animation rotary for set latitude
defineProperty("device_num", 0) -- number of device
defineProperty("GMK_select", globalPropertyf("sim/custom/xap/gauges/GMK_select")) -- switcher to select working devide
defineProperty("man_corr", globalPropertyi("sim/custom/xap/gauges/GMK_man_corr")) -- manual corrector switch
defineProperty("GMK_check", globalPropertyi("sim/custom/xap/gauges/GMK_check")) -- check GMK 0 - 300
defineProperty("gyro_correct", globalPropertyf("sim/custom/xap/gauges/gyro_correct"))

defineProperty("fail1", globalPropertyf("sim/operation/failures/rel_ss_dgy"))
defineProperty("fail2", globalPropertyf("sim/operation/failures/rel_cop_dgy"))

-- power
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("AZS", globalPropertyi("sim/custom/xap/azs/AZS_GMK_sw")) -- AZS switcher

-- result
defineProperty("GMK_curse", globalPropertyf("sim/custom/xap/gauges/GMK_curse")) -- calculated course
defineProperty("GMK_curse_ap", globalPropertyf("sim/custom/xap/gauges/GMK_curse_ap")) -- calculated course for AP

defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames
defineProperty("flight_time", globalPropertyf("sim/time/total_running_time_sec")) -- sim time

-- define images
defineProperty("back_img", loadImage("gmk_panel.png", 0, 0, 458, 271))
defineProperty("scale_img", loadImage("gmk_panel.png", 9, 278, 157, 157))
defineProperty("lamp_img", loadImage("gmk_panel.png", 189, 283, 37, 37))
-- digits images
defineProperty("digitsImage", loadImage("white_digit_strip.png", 1, 0, 14, 196))

local switch_sound = loadSample('Custom Sounds/plastic_switch.wav')

local switcher_pushed = false
local scale_angle = -get(GMK_lat_rot)
local lat = get(GMK_lat)

local show_counter = 5

local main_fail_lit = false
local zap_fail_lit = false

function update()
	local passed = get(frame_time)
	-- show digits on panel
	show_counter = show_counter + passed
	-- calculate latitde scale
	lat = get(GMK_lat)
	scale_angle = -get(GMK_lat_rot)
	
	-- calculate result course
	local dev_sel = get(GMK_select)
	local course = 0
	if dev_sel == 0 then course = get(GMK_curse1) else course = get(GMK_curse2) end

	set(GMK_curse_ap, course)
	
	local correct = get(gyro_correct)	
	local check = get(GMK_check)
	if check == -1 then course = 0 + correct
	elseif check == 1 then course = -60 + correct end
	
	set(GMK_curse, course)
	
	-- lamp logic
	local power = get(DC_27_volt) > 21 and get(AZS) == 1
	local pow_36 = get(AC_36_volt) > 31
	if power then
		main_fail_lit = not pow_36 or get(fail1) == 6 or (check ~= 0 and dev_sel == 0)
		zap_fail_lit = not pow_36 or get(fail2) == 6 or (check ~= 0 and dev_sel == 1)
	else
		main_fail_lit = false
		zap_fail_lit = false
	end
	
	
end

--[[
table for rotary angle
0	0.0
10	50.36
20	99.19
30	145
40	186.41
50	222.15
60	251.15
70	272.51
80	285.59
90	290

angle = math.sin(math.rad(lat))

--]]


components = {
	
	-- scale
	needleLit {
		position = {150, 17, 157, 157},
		image = get(scale_img),
		angle = function()
			return scale_angle
		end,
	},
	
	
	-- background
	texture {
		position = {0, 0, size[1], size[2]},
		image = get(back_img),
	},

	
	-- show latitude
   digitstapeLit {
        position = { 203, 10, 50, 30},
        image = digitsImage,
        digits = 2,
		showLeadingZeros = true,
        value = function() 
            return lat
        end,
		visible = function()
			return show_counter < 3
		end,
    };
	
	-- fail led
	textureLit {
		position = {137, 222, 37, 37},
		image = get(lamp_img),
		visible = function()
			return zap_fail_lit
		end,
	},
	
	-- fail led
	textureLit {
		position = {283, 222, 37, 37},
		image = get(lamp_img),
		visible = function()
			return main_fail_lit
		end,
	},
	
    -- GMK_north switcher
    switch {
        position = {45, 190, 70, 70},
        state = function()
            return get(GMK_north) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(GMK_north) ~= 0 then
					set(GMK_north, 0)
				else
					set(GMK_north, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

    -- GMK_select switcher
    switch {
        position = {190, 190, 70, 70},
        state = function()
            return get(GMK_select) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(GMK_select) ~= 0 then
					set(GMK_select, 0)
				else
					set(GMK_select, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- gyro_mode
    clickable {
        position = {330, 190, 45, 70},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed then
				playSample(switch_sound, 0)
				switcher_pushed = true
				local a = get(gyro_mode) - 1
				if a < 0 then a = 0 end
				set(gyro_mode, a)
			end
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			return true
		end,
		
    },
    clickable {
        position = {375, 190, 45, 70},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed then
				playSample(switch_sound, 0)
				switcher_pushed = true
				local a = get(gyro_mode) + 1
				if a > 2 then a = 2 end
				set(gyro_mode, a)
			end
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			return true
		end,
		
    },


	-- latitude select
    clickable {
        position = {173, 20, 55, 130},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed then
				local a = get(GMK_lat) - 1
				if a > 90 then a = 90 end
				set(GMK_lat, a)
				set(GMK_lat_rot, math.sin(math.rad(a)) * 290)
				show_counter = 0
			end
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			return true
		end,
    },
    clickable {
        position = {228, 20, 55, 130},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed then
				local a = get(GMK_lat) + 1
				if a < 0 then a = 0 end
				set(GMK_lat, a)
				set(GMK_lat_rot, math.sin(math.rad(a)) * 290)
				show_counter = 0
			end
			return true
		end,
		onMouseUp = function()
			switcher_pushed = false
			return true
		end,
    },

	-- GMK_check
    clickable {
        position = {38, 15, 45, 70},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed then	playSample(switch_sound, 0) end
			switcher_pushed = true
			set(GMK_check, -1)
			return true
		end,
		onMouseUp = function()
			playSample(switch_sound, 0)
			switcher_pushed = false
			set(GMK_check, 0)
			return true
		end,
    },
    clickable {
        position = {83, 15, 45, 70},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed then	playSample(switch_sound, 0) end
			switcher_pushed = true
			set(GMK_check, 1)
			return true
		end,
		onMouseUp = function()
			playSample(switch_sound, 0)
			switcher_pushed = false
			set(GMK_check, 0)
			return true
		end,
    },	

	-- man_corr
    clickable {
        position = {330, 15, 45, 70},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed then	playSample(switch_sound, 0) end
			switcher_pushed = true
			set(man_corr, 1)
			return true
		end,
		onMouseUp = function()
			playSample(switch_sound, 0)
			switcher_pushed = false
			set(man_corr, 0)
			return true
		end,
    },
    clickable {
        position = {375, 15, 45, 70},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
       	onMouseClick = function() 
			if not switcher_pushed then	playSample(switch_sound, 0) end
			switcher_pushed = true
			set(man_corr, -1)
			return true
		end,
		onMouseUp = function()
			playSample(switch_sound, 0)
			switcher_pushed = false
			set(man_corr, 0)
			return true
		end,
    },	
	
}