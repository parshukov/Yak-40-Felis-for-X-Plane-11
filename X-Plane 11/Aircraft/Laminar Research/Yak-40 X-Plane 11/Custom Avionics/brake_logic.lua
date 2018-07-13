-- this is the simple logic of braking system, provide brake limits depending on pressure in system and possibly ABS
size = {2048, 2048}
-- define property table
defineProperty("hydro_main_press", globalPropertyf("sim/custom/xap/hydro/main_press")) -- pressure in main system. initial 120 kg per square sm. maximum 160.
defineProperty("hydro_emerg_press", globalPropertyf("sim/custom/xap/hydro/emerg_press")) -- pressure in emergency system. initial 120 kg per square sm. maximum 160.
defineProperty("brake1", globalPropertyf("sim/flightmodel/controls/l_brake_add")) -- gear brake ratio. 0 = min, 1 = max
defineProperty("brake2", globalPropertyf("sim/flightmodel/controls/r_brake_add")) -- gear brake ratio. 0 = min, 1 = max
defineProperty("block_brake", globalPropertyf("sim/flightmodel/controls/parkbrake"))  -- blocks brakes
defineProperty("gear_blocks", globalPropertyi("sim/custom/xap/covers/gear_blocks"))  -- gear blocks
defineProperty("park_brake_sw", globalPropertyi("sim/custom/xap/misc/park_brake_sw"))  -- gear blocks
defineProperty("real_pedals", globalPropertyi("sim/custom/xap/set/real_pedals")) -- if you don't have pedals, you use emerg brake as main

defineProperty("betterpushback", globalPropertyi("bp/started")) -- 

-- ABS
defineProperty("gear_speed_1", globalPropertyf("sim/flightmodel2/gear/tire_rotation_speed_rad_sec[1]")) -- radians/second	Rotational speed of this tire, radians per second.
defineProperty("gear_speed_2", globalPropertyf("sim/flightmodel2/gear/tire_rotation_speed_rad_sec[2]")) -- radians/second	Rotational speed of this tire, radians per second.
defineProperty("abs_sw", globalPropertyi("sim/custom/xap/hydro/abs_sw"))  -- abs switcher

-- power
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("manometer_sw", globalPropertyi("sim/custom/xap/misc/manometer_sw"))  -- turn ON all manometers
defineProperty("but_test_lamp", globalPropertyi("sim/custom/xap/buttons/but_test_lamp")) -- test lamps button
defineProperty("brk_ind_cc", globalPropertyf("sim/custom/xap/hydro/brk_ind_cc"))
defineProperty("brk_abs_cc", globalPropertyf("sim/custom/xap/hydro/brk_abs_cc"))

-- AZS
defineProperty("AZS_brakes_sw", globalPropertyi("sim/custom/xap/azs/AZS_brakes_sw")) -- AZS for hydraulic system

-- sliders
defineProperty("slider24", globalPropertyi("sim/cockpit2/switches/custom_slider_on[23]")) -- slider for brake animation

-- enviroment
defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- frame time
defineProperty("flight_time", globalPropertyf("sim/time/total_running_time_sec")) -- sim time

-- results, needles angles and lamps
defineProperty("emerg_brake", globalPropertyf("sim/custom/xap/hydro/emerg_brake"))  -- pressure in braking system. result for hydro sys
defineProperty("brake_press", globalPropertyf("sim/custom/xap/hydro/brake_press"))  -- pressure in braking system.  result for hydro sys
defineProperty("ind_left_brake_angle", globalPropertyf("sim/custom/xap/hydro/ind_left_brake_angle")) -- pressure for left brake
defineProperty("ind_right_brake_angle", globalPropertyf("sim/custom/xap/hydro/ind_right_brake_angle")) -- pressure for right brake
defineProperty("ind_left_em_brake_angle", globalPropertyf("sim/custom/xap/hydro/ind_left_em_brake_angle")) -- pressure for left brake
defineProperty("ind_right_em_brake_angle", globalPropertyf("sim/custom/xap/hydro/ind_right_em_brake_angle")) -- pressure for right brake
defineProperty("left_brake_lit", globalPropertyi("sim/custom/xap/hydro/left_brake_lit")) -- indicator of left ABS
defineProperty("right_brake_lit", globalPropertyi("sim/custom/xap/hydro/right_brake_lit")) -- indicator of right ABS

-- define images
defineProperty("needles_1", loadImage("needles.png", 0, 2, 16, 88))

defineProperty("yellow_led", loadImage("leds.png", 60, 0, 20, 20))
defineProperty("green_led", loadImage("leds.png", 20, 0, 20, 20))
defineProperty("red_led", loadImage("leds.png", 40, 0, 20, 20))
defineProperty("black_cap1", loadImage("covers.png", 138, 62, 56, 56))
defineProperty("black_cap2", loadImage("covers.png", 202, 57, 56, 56))
local switch_sound = loadSample('Custom Sounds/metal_switch.wav')

-- local variables
local passed = 0
local time_coef = 10

local brake1_temp = 0
local brake2_temp = 0
local speed1_last = get(gear_speed_1)
local speed2_last = get(gear_speed_2)
local left_abs = false
local right_abs = false
local power27 = 0
local power36 = 0
local park_brake_last = 0

local left_brake_angle = 195
local right_brake_angle = -60

local left_brake_angle_last = 195
local right_brake_angle_last = -60

local left_em_brake_angle = 195
local right_em_brake_angle = -60

local left_em_brake_angle_last = 195
local right_em_brake_angle_last = -60

local left_abs_lamp = false
local right_abs_lamp = false

local switcher_pushed = false

-- every frame calculations
local maximum = 0
function update()
	passed = get(frame_time)

-- all calculations produced only during sim work
if passed > 0 then

	-- calculate power
	if get(DC_27_volt) > 21 then power27 = 1 else power27 = 0 end
	if get(AC_36_volt) > 30 then power36 = 1 else power36 = 0 end
	local manometers = get(manometer_sw)
	local azs = get(AZS_brakes_sw)

	-- limit brakes depending on brake capacitor pressure
	local brake_1 = get(brake1)
	local brake_2 = get(brake2)
	local main_press = get(hydro_main_press)
	local emerg_press = get(hydro_emerg_press)
	local park_brake = get(block_brake)
	if get(betterpushback)==1 then
		--if get(park_brake_sw) == 1 then park_brake = 1 end -- hold parking brake from release by pedals

		if park_brake > 0.01 then set(slider24, 1) else set(slider24, 0) end -- set lever anim
		if brake_1 > main_press / 120 then brake_1 = main_press / 120 end
		if brake_2 > main_press / 120 then brake_1 = main_press / 120 end
		
		-- park brake logic
	else
		if brake_1 + brake_2 > 0 then park_brake = park_brake_last end
		--if get(park_brake_sw) == 1 then park_brake = 1 end -- hold parking brake from release by pedals

		if park_brake > 0.01 then set(slider24, 1) else set(slider24, 0) end -- set lever anim
		if brake_1 > main_press / 120 then brake_1 = main_press / 120 end
		if brake_2 > main_press / 120 then brake_1 = main_press / 120 end
		
		-- park brake logic
		local pedals = get(real_pedals) == 1
		if pedals then
			if park_brake > emerg_press / 120 then park_brake = emerg_press / 120 end
			if park_brake > 1 then park_brake = 1 end
		else
			if park_brake > main_press / 120 then park_brake = main_press / 120 end
			if park_brake > 1 then park_brake = 1 end		
		end
	end
	-- save results for hydrosystem
	set(brake_press, math.max(brake_1, brake_2) * 120)
	set(emerg_brake, park_brake * 120)

	-- calculate angles for manometers
	-- calculate left pressure indicator
	local left_brake_angle_need = -brake_1 * 120 / 1 + 195
	if power36 == 0 or manometers == 0 then left_brake_angle_need = 200 end
	left_brake_angle = left_brake_angle + (left_brake_angle_need - left_brake_angle_last) * passed * time_coef


	-- calculate right pressure indicator
	local right_brake_angle_need = brake_2 * 120 / 1 - 105
	if power36 == 0 or manometers == 0 then right_brake_angle_need = -110 end
	right_brake_angle = right_brake_angle + (right_brake_angle_need - right_brake_angle_last) * passed * time_coef


	-- calculate left_emerg pressure indicator
	local left_em_brake_angle_need = -park_brake * 120 * 120 / 150 + 195
	if power36 == 0 or manometers == 0 then left_em_brake_angle_need = 200 end
	left_em_brake_angle = left_em_brake_angle + (left_em_brake_angle_need - left_em_brake_angle_last) * passed * time_coef


	-- calculate right pressure indicator
	local right_em_brake_angle_need = park_brake * 120 * 120 / 150 - 105
	if power36 == 0 or manometers == 0 then right_em_brake_angle_need = -110 end
	right_em_brake_angle = right_em_brake_angle + (right_em_brake_angle_need - right_em_brake_angle_last) * passed * time_coef

	-- set needles angles
	set(ind_left_brake_angle, left_brake_angle)
	set(ind_right_brake_angle, right_brake_angle)
	set(ind_left_em_brake_angle, left_em_brake_angle)
	set(ind_right_em_brake_angle, right_em_brake_angle)

	-- power CC
	if power27 == 1 and power36 == 1 and manometers == 1 then set(brk_ind_cc, 4) else set(brk_ind_cc, 0) end

	-- ABS logic
	local abs_switcher = get(abs_sw)
	-- wheel 1
	if brake1_temp == 0 and abs_switcher == 1 and not left_abs and azs == 1 and power27 == 1 then
		if (speed1_last - get(gear_speed_1)) / passed > 30 and get(gear_speed_1) < 0.01 then  -- if wheel stops too rapidly. level must be corrected
			brake1_temp = brake_1  -- save previous brake state
			brake_1 = brake_1 / 3  -- release brakes for one frame
			left_abs = true
		end
	elseif left_abs then
		brake_1 = brake1_temp -- return previous brake state, if ABS used
		brake1_temp = 0
		left_abs = false
	end

	-- wheel 2
	if brake2_temp == 0 and abs_switcher == 1 and not right_abs and azs == 1 and power27 == 1 then
		if (speed2_last - get(gear_speed_2)) / passed > 30 and get(gear_speed_2) < 0.01 then  -- if wheel stops too rapidly
			brake2_temp = brake_2 -- save previous brake state
			brake_2 = brake_2 / 3  -- release brakes for one frame
			right_abs = true
		end
	elseif right_abs then
		brake_2 = brake2_temp -- return previous brake state, if ABS used
		brake2_temp = 0
		right_abs = false
	end
	
	-- power
	if abs_switcher == 1 and azs == 1 and power27 == 1 then set(brk_abs_cc, 5) else set(brk_abs_cc, 0) end

	-- calculate lamps
	local but_test = get(but_test_lamp) == 1
	if power27 == 1 then
		left_abs_lamp = left_abs or but_test
		right_abs_lamp = right_abs or but_test
	else
		left_abs_lamp = false
		right_abs_lamp = false
	end


	-- override park brake for gear blocks
	if get(gear_blocks) == 1 then park_brake = 5 end


	-- set results to sim
	set(brake1, brake_1)
	set(brake2, brake_2)
	set(brake_press, main_press)
	set(block_brake, park_brake)
	park_brake_last = park_brake
end
	-- last variables
	speed1_last = get(gear_speed_1)
	speed2_last = get(gear_speed_2)

	left_brake_angle_last = left_brake_angle
	right_brake_angle_last = right_brake_angle
	left_em_brake_angle_last = left_em_brake_angle
	right_em_brake_angle_last = right_em_brake_angle


end



components = {

	-----------------------
	-- needle indicators --
	-----------------------

	-- left brake indicator
	needle {
		image = get(needles_1),
		position = {1341, 1381, 88, 88},
		angle = function()
		return left_brake_angle
		end,
	},

	-- right brake indicator
	needle {
		image = get(needles_1),
		position = {1411, 1307, 88, 88},
		angle = function()
		return right_brake_angle
		end,
	},

	-- left park brake indicator
	needle {
		image = get(needles_1),
		position = {1221, 1381, 88, 88},
		angle = function()
		return left_em_brake_angle
		end,
	},

	-- right park brake indicator
	needle {
		image = get(needles_1),
		position = {1292, 1307, 88, 88},
		angle = function()
		return right_em_brake_angle
		end,
	},

	-- cover 1
	texture {
		position = { 1360, 1398, 45, 45 },
		image = get(black_cap1),
	},	

	-- cover 1
	texture {
		position = { 1240, 1398, 45, 45 },
		image = get(black_cap1),
	},
	
	-- cover 1
	texture {
		position = { 1120, 1398, 45, 45 },
		image = get(black_cap1),
	},

	-- cover 2. cover for hydrosystem
	texture {
		position = { 1430, 1330, 45, 45 },
		image = get(black_cap2),
	},	
	
	-- cover 2
	texture {
		position = { 1310, 1330, 45, 45 },
		image = get(black_cap2),
	},	
	
	-- cover 2. cover for hydrosystem
	texture {
		position = { 1190, 1330, 45, 45 },
		image = get(black_cap2),
	},
	--------------------
	-- lamps and leds --
	--------------------

	-- left gear led
	textureLit {
		image = get(green_led),
		position = {944, 792, 22, 22},
		visible = function()
			return left_abs_lamp
		end,
	},

	-- right gear led
	textureLit {
		image = get(green_led),
		position = {974, 792, 22, 22},
		visible = function()
			return right_abs_lamp
		end,
	},

	---------------
	-- switchers --
	---------------

    -- ABS switcher
    switch {
        position = {701, 629, 19, 19},
        state = function()
            return get(abs_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(abs_sw) ~= 0 then
					set(abs_sw, 0)
				else
					set(abs_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

    -- park brake switcher
    switch {
        position = {1603, 0, 160, 250},
        state = function()
            return get(block_brake) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),

        onMouseClick = function()
            if not switcher_pushed then
				if get(block_brake) ~= 0 then
					set(block_brake, 0)
				else
					set(block_brake, 1)
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
