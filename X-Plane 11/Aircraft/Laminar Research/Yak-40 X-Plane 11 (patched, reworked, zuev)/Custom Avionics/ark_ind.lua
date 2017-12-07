size = {250, 200}

-- define property table
-- source
defineProperty("gyro_curse", globalPropertyf("sim/custom/xap/gauges/GMK_curse"))  -- gyro curse from GIK
defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames
defineProperty("flight_time", globalPropertyf("sim/time/total_running_time_sec")) -- sim time

defineProperty("adf1", globalPropertyf("sim/custom/xap/ark/ark_1_angle")) -- bearing to NDB
defineProperty("adf2", globalPropertyf("sim/custom/xap/ark/ark_2_angle"))

defineProperty("vor1", globalPropertyf("sim/custom/xap/gauges/vor_1")) -- bearing to VOR
defineProperty("vor2", globalPropertyf("sim/custom/xap/gauges/vor_2")) -- bearing to VOR

-- power
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt

defineProperty("ark_knob1", globalPropertyi("sim/custom/xap/gauges/ark_ind1_knob1")) -- knobs on ark/vor indicator
defineProperty("ark_knob2", globalPropertyi("sim/custom/xap/gauges/ark_ind1_knob2")) -- knobs on ark/vor indicator

-- signals to autopilot
--defineProperty("ap_curse") -- curse for autopilot

-- images
defineProperty("scale", loadImage("gmk_panel.png", 250, 273.5, 170, 170))
defineProperty("needle1", loadImage("needles2.png", 71, 0, 22, 174))
defineProperty("needle2", loadImage("needles2.png", 100, 0, 22, 174))

defineProperty("sign_ark1", loadImage("gmk_panel.png", 478, 12, 19, 59))
defineProperty("sign_ark2", loadImage("gmk_panel.png", 478, 73, 19, 59))
defineProperty("sign_vor1", loadImage("gmk_panel.png", 478, 132, 19, 59))
defineProperty("sign_vor2", loadImage("gmk_panel.png", 478, 193, 19, 59))

defineProperty("glass_img", loadImage("gmk_panel.png", 75, 444, 32, 68)) 
defineProperty("black_cap", loadImage("covers.png", 0, 56, 52, 52))

-- sounds
local switch_sound = loadSample('Custom Sounds/plastic_switch.wav')

-- local variables
local curse_angle = 0

local flag1 = get(sign_ark1)
local flag2 = get(sign_ark1)

local angle1 = 0
local angle2 = 0
local last_angle1 = 0
local last_angle2 = 0

local switch1 = get(ark_knob1)
local switch2 = get(ark_knob2)

local switch_pushed = false

-- postframe calculaions
function update()
	-- time calculations
	local passed = get(frame_time)
-- time bug workaround
if passed > 0 then
	
	local power = get(DC_27_volt) > 21
	switch1 = get(ark_knob1)
	switch2 = get(ark_knob2)

	-- set flags
	if switch1 == 0 then flag1 = get(sign_ark1)
	elseif switch1 == 1 then flag1 = get(sign_ark2)
	elseif switch1 == 2 then flag1 = get(sign_vor1)
	else flag1 = get(sign_vor2) end
	
	if switch2 == 0 then flag2 = get(sign_ark1)
	elseif switch2 == 1 then flag2 = get(sign_ark2)
	elseif switch2 == 2 then flag2 = get(sign_vor1)
	else flag2 = get(sign_vor2) end	
	
	if power then
		-- set gyro scale
		local v = -get(gyro_curse) 
		local curse_delta = v - curse_angle
		if curse_delta > 180 then curse_delta = curse_delta - 360
		elseif curse_delta < -180 then curse_delta = curse_delta + 360 end
		if curse_delta > 20 then curse_delta = 20
		elseif curse_delta < -20 then curse_delta = -20 end
		curse_angle = curse_angle + 4 * curse_delta * passed
		if curse_angle > 180 then curse_angle = curse_angle - 360
		elseif curse_angle < -180 then curse_angle = curse_angle + 360 end

		
		-- needle 1 smooth
		local v1 = 0
		if switch1 == 0 then v1 = get(adf1) 
		elseif switch1 == 1 then v1 = get(adf2) 
		elseif switch1 == 2 then v1 = get(vor1) 
		else v1 = get(vor2)		
		end
	
		local delta1 = v1 - last_angle1
		if delta1 > 180 then delta1 = delta1 - 360
		elseif delta1 < -180 then delta1 = delta1 + 360 end
		if delta1 > 5 then delta1 = 5
		elseif delta1 < -5 then delta1 = -5 end
		angle1 = angle1 + 5 * delta1 * passed
		if angle1 > 180 then angle1 = angle1 - 360
		elseif angle1 < -180 then angle1 = angle1 + 360 end
		
		-- needle 2 smooth
		local v2 = 0
		if switch2 == 0 then v2 = get(adf1) 
		elseif switch2 == 1 then v2 = get(adf2) 
		elseif switch2 == 2 then v2 = get(vor1) 
		else v2 = get(vor2)		
		end
		
		local delta2 = v2 - last_angle2
		if delta2 > 180 then delta2 = delta2 - 360
		elseif delta2 < -180 then delta2 = delta2 + 360 end
		if delta2 > 5 then delta2 = 5
		elseif delta2 < -5 then delta2 = -5 end
		angle2 = angle2 + 5 * delta2 * passed
		if angle2 > 180 then angle2 = angle2 - 360
		elseif angle2 < -180 then angle2 = angle2 + 360 end	
	end
	
	
	last_angle1 = angle1
	last_angle2 = angle2	


end

end


components = {

	-- flag1 
	texture {
		position = {220, 22, 19, 59},
		image = function()
			return flag1
		end
	},

	-- flag1 
	texture {
		position = {220, 118, 19, 59},
		image = function()
			return flag2
		end
	},

	-- glass
	texture {
		position = {212, 8, 34, 188},
		image = get(glass_img)
	},	
	-- scale
	needle {
		position = {15, 15, 170, 170},
		image = get(scale),
		angle = function()
			return curse_angle -90
		end 
	},

	-- needle 2
	needle {
		position = {5, 5, 190, 190},
		image = get(needle2),
		angle = function()
			return angle2 -90
		end
	},
	
	-- needle 1
	needle {
		position = {5, 5, 190, 190},
		image = get(needle1),
		angle = function()
			return angle1 -90
		end
	},

	-- cover
	texture {
		position = { 75, 75, 50, 50 },
		image = get(black_cap),
	},	
	
	-- left knob
	clickable {
        position = {0, 0, 250, 40},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if not switch_pushed then
				playSample(switch_sound, 0)
				local a = get(ark_knob1) + 1
				if a > 3 then a = 0 end
				set(ark_knob1, a)
				switch_pushed = true
			end
			return true
		end,
		onMouseUp = function()
			switch_pushed = false
			return true		
		end
		
    },	

	-- right knob
	clickable {
        position = {0, 160, 250, 40},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if not switch_pushed then
				playSample(switch_sound, 0)
				local a = get(ark_knob2) + 1
				if a > 3 then a = 0 end
				set(ark_knob2, a)
				switch_pushed = true
			end
			return true
		end,
		onMouseUp = function()
			switch_pushed = false
			return true		
		end
		
    },	
	

--[[
	-- position gauge
	rectangle {
		position = {99, 99, 2, 2},
		color = {1, 0, 0, 1},
	}, 
--]]

}