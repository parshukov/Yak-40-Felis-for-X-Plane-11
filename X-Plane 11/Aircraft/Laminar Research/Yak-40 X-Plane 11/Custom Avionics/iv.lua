-- this is the simple logic of engine's vibration
size = {2048, 2048}

-- define property table
defineProperty("eng1_fail", globalPropertyf("sim/operation/failures/rel_engfai1")) -- engine fail
defineProperty("eng2_fail", globalPropertyf("sim/operation/failures/rel_engfai0"))
defineProperty("eng3_fail", globalPropertyf("sim/operation/failures/rel_engfai2"))

-- sources
defineProperty("eng1_fire", globalPropertyf("sim/operation/failures/rel_engfir1")) -- engine fire
defineProperty("eng2_fire", globalPropertyf("sim/operation/failures/rel_engfir0"))
defineProperty("eng3_fire", globalPropertyf("sim/operation/failures/rel_engfir2"))

defineProperty("eng1_oil_p", globalPropertyf("sim/flightmodel/engine/ENGN_oil_press_psi[1]"))  -- oil pressure
defineProperty("eng2_oil_p", globalPropertyf("sim/flightmodel/engine/ENGN_oil_press_psi[0]"))
defineProperty("eng3_oil_p", globalPropertyf("sim/flightmodel/engine/ENGN_oil_press_psi[2]"))

defineProperty("chip_detect1", globalPropertyf("sim/cockpit/warnings/annunciators/chip_detected[1]")) -- chip in engine1
defineProperty("chip_detect2", globalPropertyf("sim/cockpit/warnings/annunciators/chip_detected[0]")) -- chip in engine1
defineProperty("chip_detect3", globalPropertyf("sim/cockpit/warnings/annunciators/chip_detected[2]")) -- chip in engine1

defineProperty("eng_rpm1", globalPropertyf("sim/flightmodel/engine/ENGN_N1_[1]")) -- engine rpm in % of N2  
defineProperty("eng_rpm2", globalPropertyf("sim/flightmodel/engine/ENGN_N1_[0]"))
defineProperty("eng_rpm3", globalPropertyf("sim/flightmodel/engine/ENGN_N1_[2]"))

defineProperty("comsta0", globalPropertyi("sim/operation/failures/rel_comsta1"))
defineProperty("comsta1", globalPropertyi("sim/operation/failures/rel_comsta0"))
defineProperty("comsta2", globalPropertyi("sim/operation/failures/rel_comsta2"))

defineProperty("virt_rud1", globalPropertyf("sim/custom/xap/eng/virt_rud1"))
defineProperty("virt_rud2", globalPropertyf("sim/custom/xap/eng/virt_rud2"))
defineProperty("virt_rud3", globalPropertyf("sim/custom/xap/eng/virt_rud3"))

-- power
defineProperty("iv_sw", globalPropertyi("sim/custom/xap/gauges/iv_sw"))
defineProperty("iv_mode", globalPropertyi("sim/custom/xap/gauges/iv_mode"))
defineProperty("iv_test", globalPropertyi("sim/custom/xap/gauges/iv_test"))
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("inv_PO1500_steklo", globalPropertyi("sim/custom/xap/power/inv_PO1500_steklo")) -- inverter for 115v bus
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("iv_cc", globalPropertyf("sim/custom/xap/gauges/iv_cc")) -- cc

defineProperty("but_test_lamp", globalPropertyi("sim/custom/xap/buttons/but_test_lamp")) -- test lamps button

defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames
defineProperty("flight_time", globalPropertyf("sim/time/total_running_time_sec")) -- sim time

-- images
defineProperty("needleImg", loadImage("needles.png", 86, 72, 18, 173))
defineProperty("red_led", loadImage("leds.png", 40, 0, 20, 20)) 
defineProperty("left_led", loadImage("lamps.png", 120, 100, 60, 25)) 
defineProperty("mid_led", loadImage("lamps.png", 180, 100, 60, 25)) 
defineProperty("right_led", loadImage("lamps.png", 0, 125, 60, 25)) 


-- initial switchers values
defineProperty("N1", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[1]"))   
defineProperty("N2", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[0]"))
defineProperty("N3", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[2]"))

local galet_sound = loadSample('Custom Sounds/metal_box_switch.wav')
local btn_click = loadSample('Custom Sounds/plastic_btn.wav')

local time_counter = 0
local not_loaded = true


local fire_counter1 = 0
local fire_counter2 = 0
local fire_counter3 = 0

local chip_counter1 = 0
local chip_counter2 = 0
local chip_counter3 = 0

local oil_counter1 = 0
local oil_counter2 = 0
local oil_counter3 = 0

local stall_counter1 = 0
local stall_counter2 = 0
local stall_counter3 = 0

local vibro_angle1 = -30
local vibro_angle2 = -30
local vibro_angle3 = -30

local vibro_lit1 = false
local vibro_lit2 = false
local vibro_lit3 = false

local last_angle = -30
local actual_angle = -30






function update()
	-- time calculations
	passed = get(frame_time)
-- time bug workaround
if passed > 0 then
	-- initial switchers values
	time_counter = time_counter + passed
	if get(N1) < 40 and get(N2) < 40 and get(N3) < 40 and time_counter > 0.3 and time_counter < 0.4 and not_loaded then
		set(iv_sw, 0)
		not_loaded = false
	end
	
	local vibro1 = 0
	local vibro2 = 0
	local vibro3 = 0
	
	local rud1 = get(virt_rud1)
	local rud2 = get(virt_rud2)
	local rud3 = get(virt_rud3)
	
	local rpm1 = get(eng_rpm1)
	local rpm2 = get(eng_rpm2)
	local rpm3 = get(eng_rpm3)
	
	local fail1 = 0
	local fail2 = 0
	local fail3 = 0
	if get(eng1_fail) == 6 then fail1 = 1 end
	if get(eng2_fail) == 6 then fail2 = 1 end
	if get(eng3_fail) == 6 then fail3 = 1 end
	
	-- vibration sensors work fine when engines RPM are 98 - 101%
	-- when RPM more than 101% - vibration increases
	
	-- left engine
	if rpm1 >= 0 and rpm1 < 20 then vibro1 = rpm1 / 6.66
	elseif rpm1 >= 20 and rpm1 < 98 then vibro1 = 3 - (rpm1 - 20) / 39
	elseif rpm1 >= 98 and rpm1 <= 101 then vibro1 = 1
	else vibro1 = 1 + (rpm1 - 101) / 4 end

	-- center engine
	if rpm2 >= 0 and rpm2 < 20 then vibro2 = rpm2 / 6.66
	elseif rpm2 >= 20 and rpm2 < 98 then vibro2 = 3 - (rpm2 - 20) / 39
	elseif rpm2 >= 98 and rpm2 <= 101 then vibro2 = 1
	else vibro2 = 1 + (rpm2 - 101) / 4 end

	-- right engine
	if rpm3 >= 0 and rpm3 < 20 then vibro3 = rpm3 / 6.66
	elseif rpm3 >= 20 and rpm3 < 98 then vibro3 = 3 - (rpm3 - 20) / 39
	elseif rpm3 >= 98 and rpm3 <= 101 then vibro3 = 1
	else vibro3 = 1 + (rpm3 - 101) / 4 end
	
	-- vibration for failed engines
	vibro1 = vibro1 + fail1 * rpm1 / 30
	vibro2 = vibro2 + fail2 * rpm2 / 30
	vibro3 = vibro3 + fail3 * rpm3 / 30
	
	-- vibration may slowly increase on engine fire
	if get(eng1_fire) == 6 and fire_counter1 <= 7 then fire_counter1 = fire_counter1 + passed * 0.4 * rpm1 * rud1 / 100 
	elseif get(eng1_fire) < 6 and fire_counter1 >= 0 then fire_counter1 = fire_counter1 - passed * 0.4 end
	if get(eng2_fire) == 6 and fire_counter2 <= 7 then fire_counter2 = fire_counter2 + passed * 0.4 * rpm2 * rud2 / 100 
	elseif get(eng2_fire) < 6 and fire_counter2 >= 0 then fire_counter2 = fire_counter2 - passed * 0.4 end
	if get(eng3_fire) == 6 and fire_counter3 <= 7 then fire_counter3 = fire_counter3 + passed * 0.4 * rpm3 * rud3 / 100
	elseif get(eng3_fire) < 6 and fire_counter3 >= 0 then fire_counter3 = fire_counter3 - passed * 0.4 end
	
	-- vibration may increase if engine destroying
	if get(chip_detect1) == 1 and chip_counter1 <= 7 then chip_counter1 = chip_counter1 + chip_counter1 * 0.5 * passed * rpm1 * rud1 / 100 end
	if get(chip_detect2) == 1 and chip_counter2 <= 7 then chip_counter2 = chip_counter2 + chip_counter2 * 0.5 * passed * rpm2 * rud2 / 100 end
	if get(chip_detect3) == 1 and chip_counter3 <= 7 then chip_counter3 = chip_counter3 + chip_counter3 * 0.5 * passed * rpm3 * rud3 / 100 end
	
	-- vibration may increase if oil pressure is low and then engine may heat and destroy
	if get(eng1_oil_p) * 0.07031 < 2 and oil_counter1 <= 7 and rpm1 > 20 then oil_counter1 = oil_counter1 + passed * 0.2 * rpm1 * rud1 / 100
	elseif get(eng1_oil_p) * 0.07031 >= 2 and oil_counter1 >= 0 then oil_counter1 = oil_counter1 - passed * 0.4 end
	if get(eng2_oil_p) * 0.07031 < 2 and oil_counter2 <= 7 and rpm2 > 20 then oil_counter2 = oil_counter2 + passed * 0.2 * rpm2 * rud2 / 100
	elseif get(eng2_oil_p) * 0.07031 >= 2 and oil_counter2 >= 0 then oil_counter2 = oil_counter2 - passed * 0.4 end
	if get(eng3_oil_p) * 0.07031 < 2 and oil_counter3 <= 7 and rpm3 > 20 then oil_counter3 = oil_counter3 + passed * 0.2 * rpm3 * rud3 / 100
	elseif get(eng3_oil_p) * 0.07031 >= 2 and oil_counter3 >= 0 then oil_counter3 = oil_counter3 - passed * 0.4 end
	
	-- vibration may increase if engine stall
	if get(comsta0) == 6 and stall_counter1 <= 7 and rpm1 > 20 then stall_counter1 = stall_counter1 + passed * 0.2 * rpm1 * rud1 / 100
	elseif get(comsta0) < 6 and stall_counter1 >= 0 then stall_counter1 = stall_counter1 - passed * 0.4 end
	if get(comsta1) == 6 and stall_counter2 <= 7 and rpm2 > 20 then stall_counter2 = stall_counter2 + passed * 0.2 * rpm2 * rud2 / 100
	elseif get(comsta1) < 6 and stall_counter2 >= 0 then stall_counter2 = stall_counter2 - passed * 0.4 end
	if get(comsta2) == 6 and stall_counter3 <= 7 and rpm3 > 20 then stall_counter3 = stall_counter3 + passed * 0.2 * rpm3 * rud3 / 100
	elseif get(comsta2) < 6 and stall_counter3 >= 0 then stall_counter3 = stall_counter3 - passed * 0.4 end
	
	-- result vibration and engine faulre
	vibro1 = vibro1 + (fire_counter1 + chip_counter1 + oil_counter1 + stall_counter1) * rpm1 / 100
	if vibro1 > 7 then vibro1 = 7 end
	if vibro1 > 6.5 then set(eng1_fail, 6) end
	
	
	vibro2 = vibro2 + (fire_counter2 + chip_counter2 + oil_counter2 + stall_counter2) * rpm2 / 100
	if vibro2 > 7 then vibro2 = 7 end	
	if vibro2 > 6.5 then set(eng2_fail, 6) end

	vibro3 = vibro3 + (fire_counter3 + chip_counter3 + oil_counter3 + stall_counter3) * rpm3 / 100
	if vibro3 > 7 then vibro3 = 7 end	
	if vibro3 > 6.5 then set(eng3_fail, 6) end
	
	-- calculate angles
	
	local power = get(iv_sw) == 1 and get(DC_27_volt) > 21
	local power115 = get(AC_115_volt) > 110 and get(inv_PO1500_steklo) == 1
	local test_lamp = get(but_test_lamp) == 1
	
	if power then
		if get(iv_test) == 1 and power115 then
			vibro1 = 6
			vibro2 = 6
			vibro3 = 6
		end
		if power115 then 
			vibro_angle1 = vibro1 * 90 / 8 - 45
			vibro_angle2 = vibro2 * 90 / 8 - 45
			vibro_angle3 = vibro3 * 90 / 8 - 45
		else 
			vibro_angle1 = -45
			vibro_angle2 = -45
			vibro_angle3 = -45
		end
		vibro_lit1 = vibro1 > 4
		vibro_lit2 = vibro2 > 4
		vibro_lit3 = vibro3 > 4
		
	else
		vibro_lit1 = false
		vibro_lit2 = false
		vibro_lit3 = false
		vibro_angle1 = -45
		vibro_angle2 = -45
		vibro_angle3 = -45
	end
	
	vibro_lit1 = vibro_lit1 or test_lamp
	vibro_lit2 = vibro_lit2 or test_lamp
	vibro_lit3 = vibro_lit3 or test_lamp
	
	-- set angle of needle for gauge
	local vibro_angle = -45
	local mode = get(iv_mode)
	if mode == 0 then vibro_angle = math.max(vibro_angle1, vibro_angle2, vibro_angle3)
	elseif mode == 1 then vibro_angle = vibro_angle1
	elseif mode == 2 then vibro_angle = vibro_angle2
	else vibro_angle = vibro_angle3 end
	
	actual_angle = last_angle + (vibro_angle - last_angle) * passed * 3
	last_angle = actual_angle
	
	-- set cc
	if power and power115 then set(iv_cc, 1) else set(iv_cc, 0) end
	

end

end


components = {
	
	textureLit {
		position = {1380, 837, 60, 26},
		image = get(left_led),
		visible = function()
			return vibro_lit1
		end
	
	},

	textureLit {
		position = {1453, 837, 60, 26},
		image = get(mid_led),
		visible = function()
			return vibro_lit2
		end
	
	},

	textureLit {
		position = {1525, 837, 60, 26},
		image = get(right_led),
		visible = function()
			return vibro_lit3
		end
	
	},

	needle {
		position = {1263, 304, 190, 190},
		image = get(needleImg),
		angle = function()
			return actual_angle
		end
	},

   -- mode knob rotary
   rotary {
       position = {1202, 669, 18, 18},
       value = iv_mode,
       step = 1,
       adjuster = function(v)
          if v >= 0 and v <= 3 then playSample(galet_sound, 0) end
		  if v > 3 then v = 3 end
          if v < 0 then v = 0 end
          return v
       end,
   },

	-- test button
	clickable {
        position = {962, 668, 18, 18 },
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       onMouseClick = function() 
			if get(iv_test) == 0 then playSample(btn_click, 0) end
			set(iv_test, 1)
			return true
       end,
       
       onMouseUp = function()
			playSample(btn_click, 0)
			set(iv_test, 0)
			return true
       end,

    },
   
	
}

