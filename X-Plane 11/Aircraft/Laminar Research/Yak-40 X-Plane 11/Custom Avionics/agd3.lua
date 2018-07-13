size = {200, 200}

-- define component property table.
defineProperty("pitch_sim", globalPropertyf("sim/cockpit2/gauges/indicators/pitch_electric_deg_pilot"))
defineProperty("roll_sim", globalPropertyf("sim/cockpit2/gauges/indicators/roll_electric_deg_pilot"))


-- power
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
--defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("AGD_sw", 1)
defineProperty("AZS_agd_sw", 1)
defineProperty("AGD_cc", 0)
defineProperty("res_roll", 0) -- result roll
defineProperty("res_pitch", 0) -- result pitch



-- failures
defineProperty("sim_fail", globalPropertyi("sim/operation/failures/rel_ss_ahz")) -- failure for pilot ahz


-- time from simulator start
defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames
defineProperty("sim_time", globalPropertyf("sim/time/total_running_time_sec")) -- sim time

-- reality
defineProperty("set_real_ahz", globalPropertyi("sim/custom/xap/set/real_ahz")) -- real ahz has errors and needs to be corrected


-- initial switchers values
defineProperty("N1", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[1]"))   
defineProperty("N2", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[0]"))
defineProperty("N3", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[2]"))

-- define images
defineProperty("tapeImage", loadImage("ag_tape.png", 0, 0, 256, 1024))
defineProperty("planeImage", loadImage("needles.png", 73, 1, 121, 27))
defineProperty("flagImage", loadImage("needles.png", 85, 36, 58, 22))
defineProperty("triangle", loadImage("triangle.png", 0, 0, 8, 8))
defineProperty("planka", loadImage("ag_tape.png", 0, 156, 10, 200))
defineProperty("foreground", loadImage("agd_cover.png", 0, 0, 200, 200))
defineProperty("arrest_img", loadImage("agd_cover.png", 212, 4, 36, 36))
defineProperty("pitch_img", loadImage("agd_cover.png", 212, 61, 36, 36))

local btn_click = loadSample('Custom Sounds/plastic_btn.wav')
-- height of visible window area
local winHeight = 130 / 512

-- height of one degrees in texture coord
local pitch_deg = 2.0 / 512

local now = get(sim_time)

local real_num = get(set_real_ahz)
local real = real_num == 1


-- third horizont
local initial_roll_err = 0 --math.random(-20, 20) * real_num -- initial error, ehich will be decreased to 0 after connecting power
local roll_corr = 0  -- correction for errors and arrest
local roll_show = 0  -- result roll
local roll_off = 0 --math.random(-2, 2) * real_num -- determine the direction for AG fall
local initial_pitch_err = 0 --math.random(-30, 30) * real_num -- initial error, ehich will be decreased to 0 after connecting power
local pitch_corr = 0  -- correction for errors and arrest
local pitch_show = 0  -- result roll
local pitch_off = 0 --math.random(-2, 2) * real_num -- determine the direction for AG fall
local arrest = 0  -- variable for arresting process
local arrest_push = false -- validate if arrest button is pushed
local pitch_rot = 0
local ahz_fail = true
local fail = 0
local power_roll = 0 --get(roll_right)
local power_pitch = 0 --get(pitch_right)

local time_counter = 0
local notLoaded = true

local power27 = 0
local power36 = 0

local eng_check = true

function update()
	-- time variables
	local passed = get(frame_time)
	now = get(sim_time)
if passed > 0 then
	real_num = get(set_real_ahz)
	real = real_num == 1
	fail = get(sim_fail)
	
	
	time_counter = time_counter + passed	

	-- set initial AHZ position
	if real and time_counter > 0.3 and time_counter < 0.4 and notLoaded and get(N1) < 10 and get(N2) < 10 and get(N3) < 10 then
		initial_roll_err = math.random(-20, 20)
		roll_off = math.random(-1, 1)
		initial_pitch_err = math.random(-30, 30)
		pitch_off = math.random(-1, 1)
		
		notLoaded = false
	elseif real and time_counter > 0.3 and time_counter < 0.4 and notLoaded then 
		roll_off = math.random(-1, 1)
		pitch_off = math.random(-1, 1)	
	
		notLoaded = false	
	end
	
	local switch = get(AGD_sw) * get(AZS_agd_sw)
	-- calculate power
	if get(DC_27_volt) > 21 then power27 = 1 else power27 = 0 end
	if get(AC_36_volt) > 28 then power36 = 1 else power36 = 0 end



	-- calculate roll and pitch for power off
	if power27 * power36 * switch == 0 or fail == 6 then
		power_roll = get(roll_sim) * real_num
		power_pitch = get(pitch_sim) * real_num
	end -- if no power, then horizon will remain its position


	-- calculate power ON and OFF initial roll and pitch
	if power27 * power36 * switch == 0 or fail == 6 then
		if math.abs(initial_roll_err) < 20 then initial_roll_err = initial_roll_err + passed * roll_off * 0.1 * real_num end
		if math.abs(initial_pitch_err) < 30 then initial_pitch_err = initial_pitch_err + passed * pitch_off * 0.1 * real_num end
	else
		if initial_roll_err > 0.1 then initial_roll_err = initial_roll_err - passed * 0.3
		elseif initial_roll_err < -0.1 then initial_roll_err = initial_roll_err + passed * 0.3
		else initial_roll_err = 0 end
		if initial_pitch_err > 0.1 then initial_pitch_err = initial_pitch_err - passed * 0.3
		elseif initial_pitch_err < -0.1 then initial_pitch_err = initial_pitch_err + passed * 0.3
		else initial_pitch_err = 0 end
		
		-- reset all errors and correction after some time
		if power_roll > 0.1 then power_roll = power_roll - passed * 0.1
		elseif power_roll < -0.1 then power_roll = power_roll + passed * 0.1 
		else power_roll = 0 end
		
		if power_pitch > 0.1 then power_pitch = power_pitch - passed * 0.1
		elseif power_pitch < -0.1 then power_pitch = power_pitch + passed * 0.1 
		else power_pitch = 0 end
		
		if roll_corr > 0.1 then roll_corr = roll_corr - 0.1 * passed
		elseif roll_corr < -0.1 then roll_corr = roll_corr + 0.1 * passed 
		else roll_corr = 0 end
		
		if pitch_corr > 0.1 then pitch_corr = pitch_corr - 0.1 * passed
		elseif pitch_corr < -0.1 then pitch_corr = pitch_corr + 0.1 * passed 
		else pitch_corr = 0 end
		
	end


	-- arresting mechanism
	if arrest > 0 and fail < 6 then
		-- set new correction
		if math.abs(initial_roll_err) < 0.1 then
			if roll_show > 0.1 then roll_corr = roll_corr + 6 * passed
			elseif roll_show < -0.1 then roll_corr = roll_corr - 6 * passed end
		end
		if math.abs(initial_pitch_err) < 0.1 then
			if pitch_show > 0.1 then pitch_corr = pitch_corr + 6 * passed
			elseif pitch_show < -0.1 then pitch_corr = pitch_corr - 6 * passed end
		end
		
		-- reset errors
		if power_roll > 0.1 then power_roll = power_roll - passed
		elseif power_roll < -0.1 then power_roll = power_roll + passed end
		if power_pitch > 0.1 then power_pitch = power_pitch - passed
		elseif power_pitch < -0.1 then power_pitch = power_pitch + passed end

		if initial_roll_err > 0.1 then initial_roll_err = initial_roll_err - passed * 6
		elseif initial_roll_err < -0.1 then initial_roll_err = initial_roll_err + passed * 6 end
		if initial_pitch_err > 0.1 then initial_pitch_err = initial_pitch_err - passed * 6
		elseif initial_pitch_err < -0.1 then initial_pitch_err = initial_pitch_err + passed * 6 end

		--[[
		if roll_err > 0.1 then roll_err = roll_err - passed
		elseif roll_err < -0.1 then roll_err = roll_err + passed end
		if pitch_err > 0.1 then pitch_err = pitch_err - passed
		elseif pitch_err < 0.1 then pitch_err = pitch_err + passed end
		--]]
		
	end

	
	-- main formula for curent position
	roll_show = get(roll_sim) - power_roll + initial_roll_err - roll_corr
	pitch_show = get(pitch_sim) - power_pitch + initial_pitch_err - pitch_corr
		-- final result is a summ of power position, initial error of gauge, collective error of gauge and correction of this error
	-- limit pitch
	if pitch_show > 80 then pitch_show = 80
	elseif pitch_show < -80 then pitch_show = -80 end
	
	-- set results
	set(res_roll, roll_show)
	set(res_pitch, pitch_show)
	
	----------------------------

	-- lamp and flags logic
	if power27 > 0 then
		if power36 == 0 or fail == 6 or switch == 0 or arrest > 0 then ahz_fail = true
		else ahz_fail = false end
	else
		ahz_fail = false
	end

	-- power consumption
	local agd_cc = 0

	if power27 > 0 then
		if not ahz_fail then agd_cc = 2 else agd_cc = 0 end
	end
	set(AGD_cc, agd_cc)


end

end



components = {


    -- attitude tape
    tape {
        position = { 27, 25, 145, 148},
        image = get(tapeImage),
        window = { 1.0, winHeight / 1.3},

        -- calculate pitch level
        scrollY = function()
            return (0.5 - winHeight / 2 / 1.3) - pitch_deg * (pitch_show + pitch_rot);
        end,
    },

	-- planka
	texture {
        position = { 98, 0, 4, 200 },
        image = get(planka),
	},

	-- aircraft image
    needle {
        position = { 20, 20, 160, 160 },
        image = get(planeImage),
        angle = function()
            return roll_show
        end
    },
	
	-- fail indicator
	texture {
		position = {15, 120, 70, 26},
		image = get(flagImage),
		visible = function()
			return ahz_fail or power27 == 0 
		end,
	},
	
	-- foreground
	texture {
		position = {0, 0, 200, 200},
		image = get(foreground),
	
	},
	
	
	
	-- arrest button
	texture {
		position = {168, 0, 33, 33},
		image = get(arrest_img),
	
	},
    clickable {
       position = { 170, 0, 35, 35 },

       cursor = {
            x = 16, 
            y = 32, 
            width = 16,
            height = 16,
            shape = loadImage("clickable.png")
        },

        onMouseClick = function(x, y, button)
			if not arrest_push then
				 playSample(btn_click, 0)
				arrest_push = true
				arrest = 1
			end
            return true
        end,
        onMouseUp = function(x, y, button)
			 playSample(btn_click, 0)
			arrest_push = false
			arrest = 0
            return true
        end,

    },

    -- pitch rotary
    needle {
        position = { 1, 2, 30, 30 },
        image = get(pitch_img),
        angle = function()
            return pitch_rot * 10
        end
    },	
    clickable {
       position = { 1, 2, 15, 30 },

       cursor = {
            x = 16, 
            y = 32, 
            width = 16,
            height = 16,
            shape = loadImage("rotateleft.png")
        },

        onMouseClick = function(x, y, button)
			pitch_rot = pitch_rot - 1
			if pitch_rot < -12 then pitch_rot = -12 end
            return true
        end,
    },
    clickable {
       position = { 16, 2, 15, 30 },

       cursor = {
            x = 16, 
            y = 32, 
            width = 16,
            height = 16,
            shape = loadImage("rotateright.png")
        },

        onMouseClick = function(x, y, button)
			pitch_rot = pitch_rot + 1
			if pitch_rot > 12 then pitch_rot = 12 end
            return true
        end,
    },

	-- rotary indicator
    free_texture {
        image = get(triangle),
        position_x = 23,
        position_y = function()
			return 97 - pitch_rot * 0.7
		end,
        width = 6,
        height = 6,
    },


	
	


}

