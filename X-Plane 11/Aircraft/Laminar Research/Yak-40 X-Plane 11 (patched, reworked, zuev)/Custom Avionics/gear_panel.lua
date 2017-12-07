-- this is panel gor gear indication
size = {240, 120}

-- define property table
-- source
defineProperty("gear1_deploy", globalPropertyf("sim/aircraft/parts/acf_gear_deploy[0]"))  --deploy of front gear
defineProperty("gear2_deploy", globalPropertyf("sim/aircraft/parts/acf_gear_deploy[1]"))  -- deploy of right gear
defineProperty("gear3_deploy", globalPropertyf("sim/aircraft/parts/acf_gear_deploy[2]"))  -- deploy of left gear


defineProperty("gear_force", globalPropertyf("sim/flightmodel2/gear/tire_vertical_deflection_mtr[1]"))

defineProperty("flap_deg1", globalPropertyf("sim/flightmodel2/wing/flap1_deg[0]"))  -- left flap deg
defineProperty("flap_deg2", globalPropertyf("sim/flightmodel2/wing/flap1_deg[1]"))  -- right flap deg

defineProperty("flap_siren", globalPropertyf("sim/custom/xap/gauges/flaps_siren"))
defineProperty("gear_siren", globalPropertyf("sim/custom/xap/gauges/gear_siren"))

defineProperty("virt_rud1", globalPropertyf("sim/custom/xap/eng/virt_rud1"))
defineProperty("virt_rud2", globalPropertyf("sim/custom/xap/eng/virt_rud2"))
defineProperty("virt_rud3", globalPropertyf("sim/custom/xap/eng/virt_rud3"))

-- power
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AZS_sign_gear_sw", globalPropertyi("sim/custom/xap/azs/AZS_sign_gear_sw"))  -- AZS for gears signal
defineProperty("AZS_sign_gear2_sw", globalPropertyi("sim/custom/xap/azs/AZS_sign_gear2_sw")) -- AZS for gears signal

defineProperty("gear_siren_sw", globalPropertyi("sim/custom/xap/gauges/gear_siren_sw")) -- gear signal switcher
defineProperty("gear_siren_cap", globalPropertyi("sim/custom/xap/gauges/gear_siren_cap")) -- gear signal switcher

defineProperty("flaps_lamp_lit", globalPropertyi("sim/custom/xap/gauges/flaps_lamp_lit")) -- flaps signal
defineProperty("gear_lamp_lit", globalPropertyi("sim/custom/xap/gauges/gear_lamp_lit")) -- gear signal


-- images
defineProperty("green_led", loadImage("gear_lamps.png", 0, 13, 10, 19))
defineProperty("red_vert_led", loadImage("gear_lamps.png", 22, 0, 10, 19))
defineProperty("red_hor_led", loadImage("gear_lamps.png", 0, 0, 19, 10))


local front_green_vis = false
local left_green_vis = false
local right_green_vis = false

local front_red_vis = false
local left_red_vis = false
local right_red_vis = false

local test_button = false
local btn_click = loadSample('Custom Sounds/plastic_btn.wav')

function update()
	
	local azs = get(AZS_sign_gear2_sw) == 1
	local power = get(DC_27_volt) > 21
	-- power calc
	if power then
		-- front gear
		local front_gear = get(gear1_deploy)
		front_green_vis = front_gear > 0.99 and azs or test_button
		front_red_vis = front_gear < 0.01 and azs or test_button

		-- left gear
		local left_gear = get(gear2_deploy)
		left_green_vis = left_gear > 0.99 and azs or test_button
		left_red_vis = left_gear < 0.01 and azs or test_button

		-- right gear
		local right_gear = get(gear3_deploy)
		right_green_vis = right_gear > 0.99 and azs or test_button
		right_red_vis = right_gear < 0.01 and azs or test_button

	else
		front_green_vis = false
		left_green_vis = false
		right_green_vis = false

		front_red_vis = false
		left_red_vis = false
		right_red_vis = false
	end
	
	-- sirene logic
	if front_red_vis and not test_button and (get(flap_deg1) + get(flap_deg2)) > 50 and get(AZS_sign_gear_sw) == 1 and power then 
		set(gear_siren, get(gear_siren_sw)) 
		set(gear_lamp_lit, 1)
	else 
		set(gear_siren, 0) 
		set(gear_lamp_lit, 0)
	end
	
	if (get(virt_rud1) + get(virt_rud3)) > 1.4 and get(gear_force) > 0.01 and (get(flap_deg1) + get(flap_deg2)) < 35 and power then 
		set(flap_siren, 1) 
		set(flaps_lamp_lit, 1)
	else 
		set(flap_siren, 0) 
		set(flaps_lamp_lit, 0)
	end

end

components = { 

	-- front gear leds
	textureLit {
		position = {91, 39, 10, 19},
		image = get(green_led),
		visible = function()
			return front_green_vis
		end
	},

	textureLit {
		position = {91, 76, 10, 19},
		image = get(red_vert_led),
		visible = function()
			return front_red_vis
		end
	},

	-- left gear leds
	textureLit {
		position = {53, 25, 10, 19},
		image = get(green_led),
		visible = function()
			return left_green_vis
		end
	},

	textureLit {
		position = {50, 64, 19, 10},
		image = get(red_hor_led),
		visible = function()
			return left_red_vis
		end
	},

	-- right gear leds
	textureLit {
		position = {127, 25, 10, 19},
		image = get(green_led),
		visible = function()
			return right_green_vis
		end
	},

	textureLit {
		position = {122, 64, 19, 10},
		image = get(red_hor_led),
		visible = function()
			return right_red_vis
		end
	},

	-- test button
    clickable {
        position = {165, 30, 60, 60},  -- search and set right

       cursor = {
            x = 16,
            y = 32,
            width = 16,
            height = 16,
            shape = loadImage("clickable.png")
        },

       	onMouseClick = function()
			if not test_button then playSample(btn_click, 0) end
			test_button = true
			return true
		end,
		onMouseUp = function()
			playSample(btn_click, 0)
			test_button = false
			return true
		end,
    },



}

