size = {170, 70}

-- define property table
defineProperty("obs", globalPropertyf("sim/cockpit2/radios/actuators/nav1_obs_deg_mag_pilot"))  -- set the course
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("inv_PO1500_radio", globalPropertyi("sim/custom/xap/power/inv_PO1500_radio")) -- inverter for 115v bus

defineProperty("power_sw", globalPropertyi("sim/custom/xap/gauges/nav1_power")) -- power switch
defineProperty("fail", globalPropertyf("sim/operation/failures/rel_nav1"))
defineProperty("AZS_KursMP_sw", globalPropertyi("sim/custom/xap/azs/AZS_KursMP_sw")) -- power switch on AZS panel

-- images table
defineProperty("digitsImage", loadImage("white_digit_strip.png", 3, 0, 10, 196)) 
defineProperty("glass_img", loadImage("gmk_panel.png", 0, 480, 68, 32)) 
local rotary_sound = loadSample('Custom Sounds/rot_click.wav')

local obs_num = get(obs)


local power = false
function update()
	obs_num = get(obs)
	power = get(DC_27_volt) > 21 and get(power_sw) == 1 and get(fail) < 6 and get(AC_115_volt) > 110 and get(AZS_KursMP_sw) == 1 and get(inv_PO1500_radio) == 1 and get(AC_36_volt) > 30
end


components = {

    
    -----------------
    -- images --
    -----------------

    -- digits
    digitstapeLit {
        position = { 15, 20, 60, 40},
        image = digitsImage,
        digits = 3,
        showLeadingZeros = true,
		allowNonRound = true,
		--fractional = 2,
        value = function()
           return obs_num
        end,
		visible = function()
			return power
		end
    }; 

    digitstape {
        position = { 15, 20, 60, 40},
        image = digitsImage,
        digits = 3,
        showLeadingZeros = true,
		allowNonRound = true,
		--fractional = 2,
        value = function()
           return obs_num
        end,
		visible = function()
			return not power
		end
    }; 

	-- glass
	texture {
		position = {-1, 10, 97, 70},
		image = get(glass_img)
	},
	
    ---------------------
    -- click zones --
    ---------------------
    
    -- rotary for curse set
    rotary {
        -- image = rotaryImage;
        value = obs;
        step = 1;
        position = { 110, 0, 55, 70 };
        adjuster = function(v)
            playSample(rotary_sound, 0)
			v = math.floor(v + 0.5)
			if v > 359 then v = v - 360
			elseif v < 0 then v = v + 360 end
			return v
        end;
    };
	
--[[
	-- position gauge
	rectangle {
		position = {0, 0, size[1], size[2]},
	}, 
--]]
	
}
