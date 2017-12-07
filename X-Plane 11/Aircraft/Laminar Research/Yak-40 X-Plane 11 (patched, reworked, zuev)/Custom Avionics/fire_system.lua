size = {2048, 2048}

-- AZS
defineProperty("AZS_fire_signal1_sw", globalPropertyi("sim/custom/xap/azs/AZS_fire_signal1_sw"))  -- AZS for fire signal in engine
defineProperty("AZS_fire_signal2_sw", globalPropertyi("sim/custom/xap/azs/AZS_fire_signal2_sw"))  -- AZS for fire signal in engine
defineProperty("AZS_fire_signal3_sw", globalPropertyi("sim/custom/xap/azs/AZS_fire_signal3_sw"))  -- AZS for fire signal in engine

defineProperty("AZS_fire_ext1_sw", globalPropertyi("sim/custom/xap/azs/AZS_fire_ext1_sw"))  -- AZS for fire extinguisher in engine
defineProperty("AZS_fire_ext2_sw", globalPropertyi("sim/custom/xap/azs/AZS_fire_ext2_sw"))  -- AZS for fire extinguisher in engine
defineProperty("AZS_fire_ext3_sw", globalPropertyi("sim/custom/xap/azs/AZS_fire_ext3_sw"))  -- AZS for fire extinguisher in engine

defineProperty("AZS_fire_ext_valve1_sw", globalPropertyi("sim/custom/xap/azs/AZS_fire_ext_valve1_sw"))  -- AZS for fire extinguisher in engine
defineProperty("AZS_fire_ext_valve2_sw", globalPropertyi("sim/custom/xap/azs/AZS_fire_ext_valve2_sw"))  -- AZS for fire extinguisher in engine
defineProperty("AZS_fire_ext_valve3_sw", globalPropertyi("sim/custom/xap/azs/AZS_fire_ext_valve3_sw"))  -- AZS for fire extinguisher in engine

-- buttons on panels
defineProperty("reset_button", globalPropertyi("sim/custom/xap/fire/reset_button"))  -- reset fire system status
defineProperty("nacelle_sel_button", globalPropertyi("sim/custom/xap/fire/nacelle_sel_button"))  -- select nacelle to extinguish. 0 = none, 1 2 3 - engines, 4 = APU
defineProperty("engine_sel_button", globalPropertyi("sim/custom/xap/fire/engine_sel_button"))  -- select engine to extinguish. 0 = none, 1 2 3 - engines
defineProperty("engine_exting_button", globalPropertyi("sim/custom/xap/fire/engine_ext_button"))  -- select turn to extinguish engine.
defineProperty("nacelle_exting_button", globalPropertyi("sim/custom/xap/fire/nacelle_ext_button"))  -- select turn to extinguish engine. 2 3 4
defineProperty("apu_ext_cap", globalPropertyi("sim/custom/xap/fire/apu_ext_cap"))  -- APU valve cap

defineProperty("but_test_lamp", globalPropertyi("sim/custom/xap/buttons/but_test_lamp")) -- test lamps button
defineProperty("apu_fire_ext", globalPropertyi("sim/custom/xap/apu/apu_fire_ext")) -- fire extinguisher for APU
defineProperty("apu_on_fire", globalPropertyi("sim/custom/xap/apu/apu_on_fire")) -- APU is on fire

-- sim variables
defineProperty("sim_engine_on_fire1", globalPropertyi("sim/operation/failures/rel_engfir1"))  -- left engine on fire
defineProperty("sim_engine_on_fire2", globalPropertyi("sim/operation/failures/rel_engfir0"))  -- mid engine on fire
defineProperty("sim_engine_on_fire3", globalPropertyi("sim/operation/failures/rel_engfir2"))  -- right engine on fire


defineProperty("sim_engine_ext1", globalPropertyi("sim/cockpit2/engine/actuators/fire_extinguisher_on[1]"))  -- left engine fire extinguiher
defineProperty("sim_engine_ext2", globalPropertyi("sim/cockpit2/engine/actuators/fire_extinguisher_on[0]"))  -- mid engine fire extinguiher
defineProperty("sim_engine_ext3", globalPropertyi("sim/cockpit2/engine/actuators/fire_extinguisher_on[2]"))  -- right engine fire extinguiher

defineProperty("start_cap", globalPropertyf("sim/flightmodel2/misc/custom_slider_ratio[11]")) 

defineProperty("N1", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[1]"))
defineProperty("N2", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[0]"))
defineProperty("N3", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[2]"))

defineProperty("fire_siren", globalPropertyi("sim/custom/xap/gauges/fire_siren")) -- fire signal
defineProperty("fire_siren_sw", globalPropertyi("sim/custom/xap/gauges/fire_siren_sw")) -- fire signal

defineProperty("fire_led", loadImage("lamps.png", 60, 225, 60, 26)) 

defineProperty("yellow_led", loadImage("leds.png", 60, 0, 20, 20)) 
defineProperty("green_led", loadImage("leds.png", 20, 0, 20, 20)) 
defineProperty("red_led", loadImage("leds.png", 40, 0, 20, 20)) 

defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("fire_cc", globalPropertyf("sim/custom/xap/fire/fire_cc")) -- cc

defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames
-- sounds
local btn_click = loadSample('Custom Sounds/plastic_btn.wav')
local switch_sound = loadSample('Custom Sounds/metal_switch.wav')
local cap_sound = loadSample('Custom Sounds/cap.wav')

local button_pressed = false

local nacelle_fire_1 = false
local nacelle_fire_2 = false
local nacelle_fire_3 = false
local apu_fire = false

local ext_1_ready = true
local ext_2_ready = true
local ext_3_ready = true
local ext_4_ready = true

local ext_1_used = false
local ext_2_used = false
local ext_3_used = false
local ext_4_used = false

-- destination to fire extinguish
local nacelle_dest = 0 -- 0 = none, 1 2 3 - engines, 4 = APU
local eng_dest = 0 -- 0 = none, 1 2 3 - engines

local valve1 = 0 -- nacelle 1
local valve2 = 0 -- nacelle 2
local valve3 = 0 -- nacelle 3
local valve7 = 0 -- nacelle APU
local valve4 = 0 -- engine 1
local valve5 = 0 -- engine 2
local valve6 = 0 -- engine 3


local nacelle_button = 0
local engine_button = 0

local nacelle_ext_button = 0 -- 0 = none, 1 2 3 = 2 3 4 fire turns
local engine_ext_button = 0 -- 0 = none, 1 2 3 4 = 1 2 3 4 fire turns

local power = false

local eng1_counter = 0
local eng2_counter = 0
local eng3_counter = 0

local fire_counter = 20
local lamp_counter1 = 20
local lamp_counter2 = 20
local lamp_counter3 = 20
local lamp_counter4 = 20
local lamp_counter5 = 20
local lamp_counter6 = 20

local fire_lamp1 = false
local fire_lamp2 = false
local fire_lamp3 = false
local fire_lamp4 = false
local fire_lamp5 = false
local fire_lamp6 = false
local valve_lamp1 = false
local valve_lamp2 = false
local valve_lamp3 = false
local valve_lamp4 = false
local valve_lamp5 = false
local valve_lamp6 = false
local valve_lamp7 = false

local turn1_lamp = false
local turn2_lamp = false
local turn3_lamp = false
local turn4_lamp = false

local siren_off_lamp = false
local fire_lamp = false

set(sim_engine_ext1, 0)
set(sim_engine_ext2, 0)
set(sim_engine_ext3, 0)

local time_counter = 0
local not_loaded = true

function update()
	
	power = get(DC_27_volt) > 21
	local passed = get(frame_time)

	-- initial switchers values
	time_counter = time_counter + passed
	if get(N1) < 40 and get(N2) < 40 and get(N3) < 40 and time_counter > 0.3 and time_counter < 0.4 and not_loaded then
		set(fire_siren_sw, 0)
		not_loaded = false
	end
	
	-- generate fire in naccels
	if get(sim_engine_on_fire1) == 6 then
		eng1_counter = eng1_counter + passed
		if get(AZS_fire_signal1_sw) == 1 then lamp_counter4 = 0 end
	end
	if get(sim_engine_on_fire2) == 6 then
		eng2_counter = eng2_counter + passed
		if get(AZS_fire_signal2_sw) == 1 then lamp_counter5 = 0 end
	end
	if get(sim_engine_on_fire3) == 6 then
		eng3_counter = eng3_counter + passed
		if get(AZS_fire_signal3_sw) == 1 then lamp_counter6 = 0 end
	end
	
	if eng1_counter > 30 then
		nacelle_fire_1 = true
		lamp_counter1 = 0
	end
	if eng2_counter > 30 then
		nacelle_fire_2 = true
		lamp_counter2 = 0
	end
	if eng3_counter > 30 then
		nacelle_fire_3 = true
		lamp_counter3 = 0
	end
		
	
	-- set destination automatic
	-- react on APU fire
	apu_fire = get(apu_on_fire) == 1
	if apu_fire and valve7 == 0 then
		valve7 = 1 -- set destination
	end

	-- react on nacelle 1 fire
	if nacelle_fire_1 and valve1 == 0 then
		valve1 = 1 -- set destination
	end

	-- react on nacelle 2 fire
	if nacelle_fire_2 and valve2 == 0 then
		valve2 = 1 -- set destination
	end
	
	-- react on nacelle 3 fire
	if nacelle_fire_3 and valve3 == 0 then
		valve3 = 1 -- set destination
	end
	
	
	-- react on engine 1 fire
	if get(sim_engine_on_fire1) == 6 and valve4 == 0 and get(AZS_fire_signal1_sw) == 1 then
		valve4 = get(AZS_fire_ext_valve1_sw) * get(AZS_fire_ext1_sw) -- set destination
	end	
	
	-- react on engine 2 fire
	if get(sim_engine_on_fire2) == 6 and valve5 == 0 and get(AZS_fire_signal2_sw) == 1 then
		valve5 = get(AZS_fire_ext_valve2_sw) * get(AZS_fire_ext2_sw) -- set destination
	end		

	-- react on engine 3 fire
	if get(sim_engine_on_fire3) == 6 and valve6 == 0 and get(AZS_fire_signal3_sw) == 1 then
		valve6 = get(AZS_fire_ext_valve3_sw) * get(AZS_fire_ext3_sw) -- set destination
	end	
	
	-------------
	-- set destination manually
	nacelle_button = get(nacelle_sel_button)
	engine_button = get(engine_sel_button)
		if nacelle_button == 1 then
			valve1 = 1
		elseif nacelle_button == 2 then
			valve2 = 1
		elseif nacelle_button == 3 then
			valve3 = 1
		elseif nacelle_button == 4 then
			valve7 = 1
		elseif engine_button == 1 then
			valve4 = get(AZS_fire_ext_valve1_sw) * get(AZS_fire_ext1_sw)
		elseif engine_button == 2 then
			valve5 = get(AZS_fire_ext_valve2_sw) * get(AZS_fire_ext2_sw)
		elseif engine_button == 3 then
			valve6 = get(AZS_fire_ext_valve3_sw) * get(AZS_fire_ext3_sw)
		end
	
	-- reset destinations
	if valve1 + valve2 + valve3 + valve4 + valve5 + valve6 + valve7 > 0 then 
		fire_counter = fire_counter + passed 
	else 
		fire_counter = 0 
	end
	
	if not power or (get(reset_button) == 1 and fire_counter > 15) then
		valve1 = 0
		valve2 = 0
		valve3 = 0
		valve4 = 0
		valve5 = 0
		valve6 = 0
		valve7 = 0
	end
	
	-- lamps logic
	local test_lamp = get(but_test_lamp) == 1
	local siren_sw = get(fire_siren_sw) == 1
	if power then
		fire_lamp1 = lamp_counter1 < 10 or test_lamp -- fire in nacelle 1
		fire_lamp2 = lamp_counter2 < 10 or test_lamp -- fire in nacelle 2
		fire_lamp3 = lamp_counter3 < 10 or test_lamp -- fire in nacelle 4
		fire_lamp4 = lamp_counter4 < 10 or test_lamp -- fire in engine 1
		fire_lamp5 = lamp_counter5 < 10 or test_lamp -- fire in engine 2
		fire_lamp6 = lamp_counter6 < 10 or test_lamp -- fire in engine 3
		valve_lamp1 = valve1 == 1 or test_lamp -- valve for nacelle 1
		valve_lamp2 = valve2 == 1 or test_lamp -- valve for nacelle 2
		valve_lamp3 = valve3 == 1 or test_lamp -- valve for nacelle 3
		valve_lamp4 = valve4 == 1 or test_lamp -- valve for engine 1
		valve_lamp5 = valve5 == 1 or test_lamp -- valve for engine 2
		valve_lamp6 = valve6 == 1 or test_lamp -- valve for engine 3
		valve_lamp7 = valve7 == 1 or test_lamp -- valve for APU
		
		lamp_counter1 = lamp_counter1 + passed
		lamp_counter2 = lamp_counter2 + passed
		lamp_counter3 = lamp_counter3 + passed
		lamp_counter4 = lamp_counter4 + passed
		lamp_counter5 = lamp_counter5 + passed
		lamp_counter6 = lamp_counter6 + passed
		
		turn1_lamp = ext_1_ready or test_lamp
		turn2_lamp = ext_2_ready or test_lamp
		turn3_lamp = ext_3_ready or test_lamp
		turn4_lamp = ext_4_ready or test_lamp
		siren_off_lamp = not siren_sw or test_lamp
	else
		lamp_counter1 = 20
		lamp_counter2 = 20
		lamp_counter3 = 20
		lamp_counter4 = 20
		lamp_counter5 = 20
		lamp_counter6 = 20	
		fire_lamp1 = false
		fire_lamp2 = false
		fire_lamp3 = false
		fire_lamp4 = false
		fire_lamp5 = false
		fire_lamp6 = false	
		valve_lamp1 = false
		valve_lamp2 = false
		valve_lamp3 = false
		valve_lamp4 = false
		valve_lamp5 = false
		valve_lamp6 = false
		valve_lamp7 = false		
		turn1_lamp = false
		turn2_lamp = false
		turn3_lamp = false
		turn4_lamp = false
		siren_off_lamp = false
	end
	
	-- sirene logic
	local siren = power and (apu_fire or (fire_lamp1 or fire_lamp2 or fire_lamp3 or fire_lamp4 or fire_lamp5 or fire_lamp6) and not test_lamp)
	
	fire_lamp = siren or test_lamp
	
	if siren and siren_sw then set(fire_siren, 1) else set(fire_siren, 0) end
	
	
	valves = (valve1 + valve2 + valve3 + valve4 + valve5 + valve6 + valve7)
	
	-- current
	if power then
		set(fire_cc, 1 + get(AZS_fire_signal1_sw) + get(AZS_fire_signal2_sw) + get(AZS_fire_signal3_sw))
	else set(fire_cc, 0) end

	---------------------
	-- extinguish fire
	engine_ext_button = get(engine_exting_button)
	nacelle_ext_button = get(nacelle_exting_button)
	
	if valve7 == 1 then -- APU
		if ext_1_ready then 
			ext_1_used = true
			if math.random() < 0.95 / valves then 
				apu_fire = false
				set(apu_fire_ext, 1)
			end
		elseif nacelle_ext_button == 2 and ext_2_ready then
			ext_2_used = true
			if math.random() < 0.95 / valves then 
				apu_fire = false
				set(apu_fire_ext, 1)
			end
		elseif nacelle_ext_button == 3 and ext_3_ready then
			ext_3_used = true
			if math.random() < 0.95 / valves then 
				apu_fire = false
				set(apu_fire_ext, 1)
			end
		elseif nacelle_ext_button == 4 and ext_4_ready then
			ext_4_used = true
			if math.random() < 0.95 / valves then 
				apu_fire = false
				set(apu_fire_ext, 1)
			end
		end	
	end
	if valve1 == 1 then -- nacelle 1
		if ext_1_ready then 
			ext_1_used = true
			if math.random() < 0.95 / valves then 
				nacelle_fire_1 = false
				eng1_counter = 0
			end
		elseif nacelle_ext_button == 2 and ext_2_ready then
			ext_2_used = true
			if math.random() < 0.95 / valves then 
				nacelle_fire_1 = false
				eng1_counter = 0
			end
		elseif nacelle_ext_button == 3 and ext_3_ready then
			ext_3_used = true
			nacelle_fire_1 = false
			if math.random() < 0.95 / valves then 
				nacelle_fire_1 = false
				eng1_counter = 0
			end
		elseif nacelle_ext_button == 4 and ext_4_ready then
			ext_4_used = true
			nacelle_fire_1 = false
			if math.random() < 0.95 / valves then 
				nacelle_fire_1 = false
				eng1_counter = 0
			end
		end	
	end
	if valve2 == 1 then -- nacelle 2
		if ext_1_ready then 
			ext_1_used = true
			if math.random() < 0.95 / valves then 
				nacelle_fire_2 = false
				eng2_counter = 0
			end
		elseif nacelle_ext_button == 2 and ext_2_ready then
			ext_2_used = true
			if math.random() < 0.95 / valves then 
				nacelle_fire_2 = false
				eng2_counter = 0
			end
		elseif nacelle_ext_button == 3 and ext_3_ready then
			ext_3_used = true
			if math.random() < 0.95 / valves then 
				nacelle_fire_2 = false
				eng2_counter = 0
			end
		elseif nacelle_ext_button == 4 and ext_4_ready then
			ext_4_used = true
			if math.random() < 0.95 / valves then 
				nacelle_fire_2 = false
				eng2_counter = 0
			end
		end	
	end
	if valve3 == 1 then -- nacelle 3
		if ext_1_ready then 
			ext_1_used = true
			if math.random() < 0.95 / valves then 
				nacelle_fire_3 = false
				eng3_counter = 0
			end
		elseif nacelle_ext_button == 2 and ext_2_ready then
			ext_2_used = true
			if math.random() < 0.95 / valves then 
				nacelle_fire_3 = false
				eng3_counter = 0
			end
		elseif nacelle_ext_button == 3 and ext_3_ready then
			ext_3_used = true
			if math.random() < 0.95 / valves then 
				nacelle_fire_3 = false
				eng3_counter = 0
			end
		elseif nacelle_ext_button == 4 and ext_4_ready then
			ext_4_used = true
			if math.random() < 0.95 / valves then 
				nacelle_fire_3 = false
				eng3_counter = 0
			end
		end
	end
	if valve4 == 1 then -- engine 1
		if engine_ext_button == 1 and ext_1_ready then 
			ext_1_used = true
			set(sim_engine_ext1, 1)
			if  math.random() < 0.95 / valves then 
				set(sim_engine_on_fire1, 0)
				eng1_counter = 0
			end
		elseif engine_ext_button == 2 and ext_2_ready then
			ext_2_used = true
			set(sim_engine_ext1, 1)
			if  math.random() < 0.95 / valves then 
				set(sim_engine_on_fire1, 0)
				eng1_counter = 0
			end
		elseif engine_ext_button == 3 and ext_3_ready then
			ext_3_used = true
			set(sim_engine_ext1, 1)
			if  math.random() < 0.95 / valves then 
				set(sim_engine_on_fire1, 0)
				eng1_counter = 0
			end
		elseif engine_ext_button == 4 and ext_4_ready then
			ext_4_used = true
			set(sim_engine_ext1, 1)
			if  math.random() < 0.95 / valves then 
				set(sim_engine_on_fire1, 0)
				eng1_counter = 0
			end
		end	
	end
	if valve5 == 1 then -- engine 2
		if engine_ext_button == 1 and ext_1_ready then 
			ext_1_used = true
			set(sim_engine_ext2, 1)
			if  math.random() < 0.95 / valves then 
				set(sim_engine_on_fire2, 0)
				eng2_counter = 0
			end
		elseif engine_ext_button == 2 and ext_2_ready then
			ext_2_used = true
			set(sim_engine_ext2, 1)
			if  math.random() < 0.95 / valves then 
				set(sim_engine_on_fire2, 0)
				eng2_counter = 0
			end
		elseif engine_ext_button == 3 and ext_3_ready then
			ext_3_used = true
			set(sim_engine_ext2, 1)
			if  math.random() < 0.95 / valves then 
				set(sim_engine_on_fire2, 0)
				eng2_counter = 0
			end
		elseif engine_ext_button == 4 and ext_4_ready then
			ext_4_used = true
			set(sim_engine_ext2, 2)
			if  math.random() < 0.95 / valves then 
				set(sim_engine_on_fire2, 0)
				eng2_counter = 0
			end
		end	
	end
	if valve6 == 1 then -- engine 3
		if engine_ext_button == 1 and ext_1_ready then 
			ext_1_used = true
			set(sim_engine_ext3, 1)
			if  math.random() < 0.95 / valves then 
				set(sim_engine_on_fire3, 0)
				eng3_counter = 0
			end
		elseif engine_ext_button == 2 and ext_2_ready then
			ext_2_used = true
			set(sim_engine_ext3, 1)
			if  math.random() < 0.95 / valves then 
				set(sim_engine_on_fire3, 0)
				eng3_counter = 0
			end
		elseif engine_ext_button == 3 and ext_3_ready then
			ext_3_used = true
			set(sim_engine_ext3, 1)
			if  math.random() < 0.95 / valves then 
				set(sim_engine_on_fire3, 0)
				eng3_counter = 0
			end
		elseif engine_ext_button == 4 and ext_4_ready then
			ext_4_used = true
			set(sim_engine_ext3, 1)
			if  math.random() < 0.95 / valves then 
				set(sim_engine_on_fire3, 0)
				eng3_counter = 0
			end
		end		
	end
	
	-- set new extinguisher's status
	ext_1_ready = not ext_1_used
	ext_2_ready = not ext_2_used
	ext_3_ready = not ext_3_used
	ext_4_ready = not ext_4_used

	if get(start_cap) < 0.05 then set(apu_ext_cap, 0) end
	
end


local switcher_pushed = false
components = {
	
	--------------
	-- lamps --
	------------
	-- fire lamp
	textureLit {
		position = {1888, 780, 60, 26},
		image = get(fire_led),
		visible = function()
			return fire_lamp
		end,		
	},
	
	-- sirene off lamp
	textureLit {
		position = {853, 761, 24, 24},
		image = get(yellow_led),
		visible = function()
			return  siren_off_lamp
		end,		
	},	


	-- nacelle 1 lamp
	textureLit {
		position = {823, 732, 24, 24},
		image = get(red_led),
		visible = function()
			return fire_lamp1
		end,		
	},
	
	-- nacelle 2 lamp
	textureLit {
		position = {854, 732, 24, 24},
		image = get(red_led),
		visible = function()
			return fire_lamp2
		end,		
	},	
	
	-- nacelle 3 lamp
	textureLit {
		position = {885, 732, 24, 24},
		image = get(red_led),
		visible = function()
			return fire_lamp3
		end,		
	},	

	-- engine 1 lamp
	textureLit {
		position = {916, 732, 24, 24},
		image = get(red_led),
		visible = function()
			return fire_lamp4
		end,		
	},	

	-- engine 2 lamp
	textureLit {
		position = {946, 732, 24, 24},
		image = get(red_led),
		visible = function()
			return fire_lamp5
		end,		
	},	
	
	-- engine 3 lamp
	textureLit {
		position = {978, 732, 24, 24},
		image = get(red_led),
		visible = function()
			return fire_lamp6
		end,		
	},	
	
	-- nacelle 1 valve
	textureLit {
		position = {1009, 732, 24, 24},
		image = get(green_led),
		visible = function()
			return valve_lamp1
		end,		
	},	
	
	-- nacelle 2 valve
	textureLit {
		position = {1040, 732, 24, 24},
		image = get(green_led),
		visible = function()
			return valve_lamp2
		end,		
	},	
	
	-- nacelle 3 valve
	textureLit {
		position = {1071, 732, 24, 24},
		image = get(green_led),
		visible = function()
			return valve_lamp3
		end,		
	},	
	
	-- engine 1 valve
	textureLit {
		position = {1101, 732, 24, 24},
		image = get(green_led),
		visible = function()
			return valve_lamp4
		end,		
	},	

	-- engine 2 valve
	textureLit {
		position = {1132, 732, 24, 24},
		image = get(green_led),
		visible = function()
			return valve_lamp5
		end,		
	},

	-- engine 3 valve
	textureLit {
		position = {1163, 732, 24, 24},
		image = get(green_led),
		visible = function()
			return valve_lamp6
		end,		
	},

	-- APU valve
	textureLit {
		position = {943, 851, 24, 24},
		image = get(green_led),
		visible = function()
			return valve_lamp7
		end,		
	},

	-- turn 2
	textureLit {
		position = {1033, 762, 24, 24},
		image = get(yellow_led),
		visible = function()
			return turn2_lamp
		end,		
	},

	-- turn 3
	textureLit {
		position = {1063, 762, 24, 24},
		image = get(yellow_led),
		visible = function()
			return turn3_lamp
		end,		
	},

	-- turn 4
	textureLit {
		position = {1093, 762, 24, 24},
		image = get(yellow_led),
		visible = function()
			return turn4_lamp
		end,		
	},

	-- turn 1
	textureLit {
		position = {1124, 762, 24, 24},
		image = get(yellow_led),
		visible = function()
			return turn1_lamp
		end,		
	},
	
	--------------
	-- buttons --
	--------------
	-- turn 2 for nacelles
	clickable {
        position = {1002, 609, 18, 18},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(nacelle_exting_button, 2)
			if not button_pressed then playSample(btn_click, 0) end
			button_pressed = true
			return true
		end,
		onMouseUp = function()
			playSample(btn_click, 0)
			button_pressed = false
			set(nacelle_exting_button, 0)
			return true		
		end
    },

	-- turn 3 for nacelles
	clickable {
        position = {1022, 609, 18, 18},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(nacelle_exting_button, 3)
			if not button_pressed then playSample(btn_click, 0) end
			button_pressed = true
			return true
		end,
		onMouseUp = function()
			set(nacelle_exting_button, 0)
			playSample(btn_click, 0)
			button_pressed = false
			return true		
		end
    },

	-- turn 4 for nacelles
	clickable {
        position = {1042, 609, 18, 18},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(nacelle_exting_button, 4)
			if not button_pressed then playSample(btn_click, 0) end
			button_pressed = true
			return true
		end,
		onMouseUp = function()
			set(nacelle_exting_button, 0)
			playSample(btn_click, 0)
			button_pressed = false
			return true		
		end
    },

	-- turn 1 for engines
	clickable {
        position = {1082, 609, 18, 18},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(engine_exting_button, 1)
			if not button_pressed then playSample(btn_click, 0) end
			button_pressed = true
			return true
		end,
		onMouseUp = function()
			set(engine_exting_button, 0)
			playSample(btn_click, 0)
			button_pressed = false
			return true		
		end
    },

	-- turn 2 for engines
	clickable {
        position = {1102, 609, 18, 18},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(engine_exting_button, 2)
			if not button_pressed then playSample(btn_click, 0) end
			button_pressed = true
			return true
		end,
		onMouseUp = function()
			set(engine_exting_button, 0)
			playSample(btn_click, 0)
			button_pressed = false
			return true		
		end
    },

	-- turn 3 for engines
	clickable {
        position = {1122, 609, 18, 18},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(engine_exting_button, 3)
			if not button_pressed then playSample(btn_click, 0) end
			button_pressed = true
			return true
		end,
		onMouseUp = function()
			set(engine_exting_button, 0)
			playSample(btn_click, 0)
			button_pressed = false
			return true		
		end
    },

	-- turn 4 for engines
	clickable {
        position = {1142, 609, 18, 18},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(engine_exting_button, 4)
			if not button_pressed then playSample(btn_click, 0) end
			button_pressed = true
			return true
		end,
		onMouseUp = function()
			set(engine_exting_button, 0)
			playSample(btn_click, 0)
			button_pressed = false
			return true		
		end
    },

	-- select nacelle 1
	clickable {
        position = {1162, 609, 18, 18},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(nacelle_sel_button, 1)
			if not button_pressed then playSample(btn_click, 0) end
			button_pressed = true
			return true
		end,
		onMouseUp = function()
			set(nacelle_sel_button, 0)
			playSample(btn_click, 0)
			button_pressed = false
			return true		
		end
    },
	
	-- select nacelle 2
	clickable {
        position = {1182, 609, 18, 18},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(nacelle_sel_button, 2)
			if not button_pressed then playSample(btn_click, 0) end
			button_pressed = true
			return true
		end,
		onMouseUp = function()
			set(nacelle_sel_button, 0)
			playSample(btn_click, 0)
			button_pressed = false
			return true		
		end
    },	

	-- select nacelle 3
	clickable {
        position = {962, 589, 18, 18},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(nacelle_sel_button, 3)
			if not button_pressed then playSample(btn_click, 0) end
			button_pressed = true
			return true
		end,
		onMouseUp = function()
			set(nacelle_sel_button, 0)
			playSample(btn_click, 0)
			button_pressed = false
			return true		
		end
    },

	-- select nacelle 4
	clickable {
        position = {962, 649, 18, 18},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(nacelle_sel_button, 4)
			if not button_pressed then playSample(btn_click, 0) end
			button_pressed = true
			return true
		end,
		onMouseUp = function()
			set(nacelle_sel_button, 0)
			playSample(btn_click, 0)
			button_pressed = false
			return true		
		end
    },
	
	-- select engine 1
	clickable {
        position = {982, 589, 18, 18},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(engine_sel_button, 1)
			if not button_pressed then playSample(btn_click, 0) end
			button_pressed = true
			return true
		end,
		onMouseUp = function()
			set(engine_sel_button, 0)
			playSample(btn_click, 0)
			button_pressed = false
			return true		
		end
    },

	-- select engine 2
	clickable {
        position = {1002, 589, 18, 18},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(engine_sel_button, 2)
			if not button_pressed then playSample(btn_click, 0) end
			button_pressed = true
			return true
		end,
		onMouseUp = function()
			set(engine_sel_button, 0)
			playSample(btn_click, 0)
			button_pressed = false
			return true		
		end
    },	

	-- select engine 3
	clickable {
        position = {1022, 589, 18, 18},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(engine_sel_button, 3)
			if not button_pressed then playSample(btn_click, 0) end
			button_pressed = true
			return true
		end,
		onMouseUp = function()
			set(engine_sel_button, 0)
			playSample(btn_click, 0)
			button_pressed = false
			return true		
		end
    },	
	
	-- fire_siren_sw switcher
    switch {
        position = {661, 629, 19, 19},
        state = function()
            return get(fire_siren_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(fire_siren_sw) ~= 0 then
					set(fire_siren_sw, 0)
				else
					set(fire_siren_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	
	-- apu_ext_cap switcher
    switch {
        position = {1402, 657, 40, 90},
        state = function()
            return get(apu_ext_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(apu_ext_cap) ~= 0 then
					set(apu_ext_cap, 0)
				else
					set(apu_ext_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- reset button
	clickable {
        position = {962, 629, 18, 18},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(reset_button, 1)
			if not button_pressed then playSample(btn_click, 0) end
			button_pressed = true
			return true
		end,
		onMouseUp = function()
			set(reset_button, 0)
			playSample(btn_click, 0)
			button_pressed = false
			return true		
		end
    },
	
	
}