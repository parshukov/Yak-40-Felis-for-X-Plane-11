-- this is electric panel logic
size = {2048, 2048} -- panel will contain a several gauges in different plases of panel texture

-- define property table

defineProperty("but_test_lamp", globalPropertyi("sim/custom/xap/buttons/but_test_lamp")) -- test lamps button
defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- frame time

defineProperty("bat_volt_bus1", globalPropertyf("sim/custom/xap/power/bat_volt1")) -- battery voltage, initial 24V - full charge.
defineProperty("bat_volt_bus2", globalPropertyf("sim/custom/xap/power/bat_volt2")) -- battery voltage, initial 24V - full charge.
defineProperty("bat_amp_bus1", globalPropertyf("sim/custom/xap/power/bat_amp_bus1"))  -- battery current, initial 0A. positive - battery load, negative - battery recharge.
defineProperty("bat_amp_bus2", globalPropertyf("sim/custom/xap/power/bat_amp_bus2"))  -- battery current, initial 0A. positive - battery load, negative - battery recharge.
defineProperty("bat_on_bus", globalPropertyi("sim/custom/xap/power/bat_on_bus"))  -- internal battery connector to bus. 0 = OFF, 1 = ON
defineProperty("bat_amp_cc1", globalPropertyf("sim/custom/xap/power/bat_amp_cc1"))  -- if batteries are charging, they take current instead of give it. = 0 when bat is source
defineProperty("bat_amp_cc2", globalPropertyf("sim/custom/xap/power/bat_amp_cc2"))  -- if batteries are charging, they take current instead of give it. = 0 when bat is source
defineProperty("bat_conn1", globalPropertyi("sim/custom/xap/power/bat1_on"))  -- battery switch. 0 = OFF, 1 = ON
defineProperty("bat_conn2", globalPropertyi("sim/custom/xap/power/bat2_on"))  -- battery switch. 0 = OFF, 1 = ON


defineProperty("bat_volt_bus", globalPropertyf("sim/custom/xap/power/bat_volt")) -- battery voltage, initial 24V - full charge.
defineProperty("bat_amp_bus", globalPropertyf("sim/custom/xap/power/bat_amp_bus"))  -- battery current, initial 0A. positive - battery load, negative - battery recharge.
defineProperty("bat_on_bus", globalPropertyi("sim/custom/xap/power/bat_on_bus"))  -- internal battery connector to bus. 0 = OFF, 1 = ON

defineProperty("gen1_volt_bus", globalPropertyf("sim/custom/xap/power/gen1_volt_bus"))  -- generator voltage, initial 28.5v
defineProperty("gen2_volt_bus", globalPropertyf("sim/custom/xap/power/gen2_volt_bus"))
defineProperty("gen3_volt_bus", globalPropertyf("sim/custom/xap/power/gen3_volt_bus"))

defineProperty("gen1_amp_bus", globalPropertyf("sim/custom/xap/power/gen1_amp_bus")) -- generator current load from bus, initial 0A
defineProperty("gen2_amp_bus", globalPropertyf("sim/custom/xap/power/gen2_amp_bus")) 
defineProperty("gen3_amp_bus", globalPropertyf("sim/custom/xap/power/gen3_amp_bus"))

defineProperty("gen1_on_bus", globalPropertyi("sim/custom/xap/power/gen1_on_bus"))  -- generator connected if 1 and dissconnected if 0
defineProperty("gen2_on_bus", globalPropertyi("sim/custom/xap/power/gen2_on_bus"))
defineProperty("gen3_on_bus", globalPropertyi("sim/custom/xap/power/gen3_on_bus"))

defineProperty("ground_available", globalPropertyi("sim/custom/xap/power/ground_available")) -- if there is ground power, this var = 1
defineProperty("power_mode", globalPropertyi("sim/custom/xap/power/power_mode"))  -- power mode: 0 = Ground, 1 = off, 2 = airplane

defineProperty("inv_PT1000", globalPropertyi("sim/custom/xap/power/inv_PT1000"))  -- inverter for 36v bus
defineProperty("inv_PT500", globalPropertyi("sim/custom/xap/power/inv_PT500")) -- inverter for 36v bus
defineProperty("inv_PT1000_emerg", globalPropertyi("sim/custom/xap/power/inv_PT1000_emerg")) -- emergency connect one inv to working. 0 = auto, 1 = manual

defineProperty("inv_PO1500_radio", globalPropertyi("sim/custom/xap/power/inv_PO1500_radio")) -- inverter for 115v bus
defineProperty("inv_PO1500_steklo", globalPropertyi("sim/custom/xap/power/inv_PO1500_steklo")) -- inverter for 115v bus
defineProperty("inv_PO1500_emerg", globalPropertyi("sim/custom/xap/power/inv_PO1500_emerg")) -- emergency connect one inv to working. 0 = auto, 1 = manual
defineProperty("inv_PO1500_emerg2", globalPropertyi("sim/custom/xap/power/inv_PO1500_emerg2")) -- emergency connect one inv to working. 0 = auto, 1 = manual

-- volts and currents on buses. logic
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("DC_27_amp", globalPropertyf("sim/custom/xap/power/DC_27_amp"))
defineProperty("DC_27_source", globalPropertyi("sim/custom/xap/power/DC_27_source"))

defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 36 volt

-- switchers on panels
defineProperty("POsteklo_sw", globalPropertyi("sim/custom/xap/power/POsteklo_sw")) -- inverter for 115v bus
defineProperty("POradio_sw", globalPropertyi("sim/custom/xap/power/POradio_sw")) -- inverter for 115v bus
defineProperty("POsteklo_emerg_sw", globalPropertyi("sim/custom/xap/power/POsteklo_emerg_sw")) -- emergency connect inv for 115v bus
defineProperty("POradio_emerg_sw", globalPropertyi("sim/custom/xap/power/POradio_emerg_sw")) -- emergency connect inv for 115v bus

defineProperty("PT1000_sw", globalPropertyi("sim/custom/xap/power/PT1000_sw")) -- inverter for 36v bus
defineProperty("PT500_sw", globalPropertyi("sim/custom/xap/power/PT500_sw")) -- inverter for 36v bus
defineProperty("PT_emerg_sw", globalPropertyi("sim/custom/xap/power/PT_emerg_sw")) -- emergency connect inv for 36v bus

defineProperty("PT_emerg_sw_cap", globalPropertyi("sim/custom/xap/power/PT_emerg_sw_cap")) -- emergency connect inv for 36v bus cap
defineProperty("POsteklo_emerg_sw_cap", globalPropertyi("sim/custom/xap/power/POsteklo_emerg_sw_cap")) -- emergency connect inv for 115v bus cap
defineProperty("POradio_emerg_sw_cap", globalPropertyi("sim/custom/xap/power/POradio_emerg_sw_cap")) -- emergency connect inv for 115v bus cap

defineProperty("ind_27v_mode", globalPropertyi("sim/custom/xap/power/ind_27v_mode")) -- rotary switcher for 27v voltmeter
	-- 0 = gen left, 1 = gen mid, 2 = gen right, 3 = ground, 4 = bat right, 5 = bus, 6 = bat left
defineProperty("ind_36v_mode", globalPropertyi("sim/custom/xap/power/ind_36v_mode")) -- rotary switcher for 36v voltmeter
	-- 0, 1, 2 = PT1000 power; 3, 4, 5 = PT500 power
defineProperty("ind_115v_mode", globalPropertyi("sim/custom/xap/power/ind_115v_mode")) -- rotary switcher for 115v voltmeter
	-- 0 = PO radio, 1 = PO steklo, 2 = ground

-- engines work
defineProperty("N1", globalPropertyf("sim/flightmodel/engine/ENGN_N1_[1]"))   
defineProperty("N2", globalPropertyf("sim/flightmodel/engine/ENGN_N1_[0]"))
defineProperty("N3", globalPropertyf("sim/flightmodel/engine/ENGN_N1_[2]"))
	
-- gauges angles
defineProperty("ind_gen1_amp_angle", globalPropertyf("sim/custom/xap/power/ind_gen1_amp_angle")) -- gen1 angle
defineProperty("ind_gen2_amp_angle", globalPropertyf("sim/custom/xap/power/ind_gen2_amp_angle")) -- gen2 angle
defineProperty("ind_gen3_amp_angle", globalPropertyf("sim/custom/xap/power/ind_gen3_amp_angle")) -- gen3 angle

defineProperty("ind_bus27_volt_angle", globalPropertyf("sim/custom/xap/power/ind_bus27_volt_angle")) -- bus 27 voltmeter angle
defineProperty("ind_bus27_amp_angle", globalPropertyf("sim/custom/xap/power/ind_bus27_amp_angle")) -- bus 27 voltmeter angle
defineProperty("ind_bus36_volt_angle", globalPropertyf("sim/custom/xap/power/ind_bus36_volt_angle")) -- bus 36 voltmeter angle
defineProperty("ind_bus115_volt_angle", globalPropertyf("sim/custom/xap/power/ind_bus115_volt_angle")) -- bus 115 voltmeter angle

-- lamps status
defineProperty("gen1_fail_lit", globalPropertyi("sim/custom/xap/power/gen1_fail_lit")) -- lamp for gen 1 fail
defineProperty("gen2_fail_lit", globalPropertyi("sim/custom/xap/power/gen2_fail_lit")) -- lamp for gen 2 fail
defineProperty("gen3_fail_lit", globalPropertyi("sim/custom/xap/power/gen3_fail_lit")) -- lamp for gen 3 fail

defineProperty("PT500_fail_lit", globalPropertyi("sim/custom/xap/power/PT500_fail_lit")) -- lamp for PT500 fail
defineProperty("PO_fail_lit", globalPropertyi("sim/custom/xap/power/PO_fail_lit")) -- lamp for PO fail

defineProperty("but_test_lamp", globalPropertyi("sim/custom/xap/buttons/but_test_lamp")) -- test lamps button

-- define images
defineProperty("needles_1", loadImage("needles.png", 0, 2, 16, 88)) 
defineProperty("needles_2", loadImage("needles.png", 18, 0, 13, 98)) 
defineProperty("needles_3", loadImage("needles.png", 34, 0, 13, 98)) 

defineProperty("yellow_led", loadImage("leds.png", 60, 0, 20, 20)) 
defineProperty("green_led", loadImage("leds.png", 20, 0, 20, 20)) 
defineProperty("red_led", loadImage("leds.png", 40, 0, 20, 20)) 

defineProperty("gen1_fail_img", loadImage("lamps.png", 120, 125, 60, 25))
defineProperty("gen2_fail_img", loadImage("lamps.png", 180, 125, 60, 25))
defineProperty("gen3_fail_img", loadImage("lamps.png", 0, 150, 60, 25))
defineProperty("PT_fail_img", loadImage("lamps.png", 60, 125, 60, 25))

defineProperty("black_cap", loadImage("covers.png", 0, 56, 52, 52))
defineProperty("black_capV", loadImage("covers.png", 339, 0, 54, 54))

local switch_sound = loadSample('Custom Sounds/metal_switch.wav')
local galet_sound = loadSample('Custom Sounds/metal_box_switch.wav')
local cap_sound = loadSample('Custom Sounds/cap.wav')

local AC36_volt_table = { 
{  -100, -120 },    
{  0, -115 },    
{  15, -90 },    
{  30, -30 },
{  35, 20 },
{  45, 120 },
{  100, 120 }} 

local AC115_volt_table = { 
{  -100, -120 },    
{  0, -120 },    
{  30, -95 },    
{  60, -80 },
{  90, -30 },
{  120, 18 },
{  150, 120 },
{  300, 120 },} 

local function interpolate(tbl, value) -- interpolate values using tables
    local lastActual = 0 
    local lastReference = 0 
    for _k, v in pairs(tbl) do
		if value == v[1] then
            return v[2]
        end
        if value < v[1] then
            local a = value - lastActual
            local m = v[2] - lastReference
            return lastReference + a / (v[1] - lastActual) * m
        end
        lastActual = v[1]
        lastReference = v[2]
    end
    return value - lastActual + lastReference
end

local switcher_pushed = false
local time_coef = 10
local not_loaded = true
local time_counter = 0


local gen1_angle = get(ind_gen1_amp_angle)
local gen2_angle = get(ind_gen2_amp_angle)
local gen3_angle = get(ind_gen3_amp_angle)
local all_amp_angle = get(ind_bus27_amp_angle)
local DC27_volt_angle = get(ind_bus27_volt_angle)
local AC36_volt_angle = get(ind_bus36_volt_angle)
local AC115_volt_angle = get(ind_bus115_volt_angle)

local gen1_angle_last = get(ind_gen1_amp_angle)
local gen2_angle_last = get(ind_gen2_amp_angle)
local gen3_angle_last = get(ind_gen3_amp_angle)
local all_amp_angle_last = get(ind_bus27_amp_angle)
local DC27_volt_angle_last = get(ind_bus27_volt_angle)
local AC36_volt_angle_last = get(ind_bus36_volt_angle)
local AC115_volt_angle_last = get(ind_bus115_volt_angle)

local gen1_fail_lamp = false
local gen2_fail_lamp = false
local gen3_fail_lamp = false
local PO_fail_lamp = false
local PT_fail_lamp = false
local ground_lamp = false


function update()
	
	local passed = get(frame_time) -- time of frame
	local ground = get(ground_available)	
	local bus_mode = get(power_mode)
	-- initial switchers values
	time_counter = time_counter + passed
	if get(N1) < 10 and get(N2) < 10 and get(N3) < 10 and time_counter > 0.3 and time_counter < 0.4 and not_loaded then
		set(power_mode, 1)
		set(gen1_on_bus, 0)
		set(gen2_on_bus, 0)
		set(gen3_on_bus, 0)
		set(POsteklo_sw, 0)
		set(POradio_sw, 0)
		set(PT1000_sw, 0)
		set(PT500_sw, 0)		
		not_loaded = false
	end

	-- calculate gen1 amp angle
	local gen1_angle_need = get(gen1_amp_bus) * 225 / 500 - 103
	gen1_angle = gen1_angle + (gen1_angle_need - gen1_angle_last) * passed * time_coef
	set(ind_gen1_amp_angle, gen1_angle)

	-- calculate gen2 amp angle
	local gen2_angle_need = get(gen2_amp_bus) * 225 / 500 - 103
	gen2_angle = gen2_angle + (gen2_angle_need - gen2_angle_last) * passed * time_coef
	set(ind_gen2_amp_angle, gen2_angle)	

	-- calculate gen3 amp angle
	local gen3_angle_need = get(gen3_amp_bus) * 225 / 500 - 103
	gen3_angle = gen3_angle + (gen3_angle_need - gen3_angle_last) * passed * time_coef
	set(ind_gen3_amp_angle, gen3_angle)	
		
	
	-- calculate angle for DC27 voltmeter
	local mode27 = get(ind_27v_mode)
	local volt27 = 0
	local amp27 = 0
	if bus_mode == 2 then
		if mode27 == 0 then volt27 = get(gen1_volt_bus) * get(gen1_on_bus)
			amp27 = get(gen1_amp_bus)
		elseif mode27 == 1 then volt27 = get(gen2_volt_bus) * get(gen2_on_bus)
			amp27 = get(gen2_amp_bus)
		elseif mode27 == 2 then volt27 = get(gen3_volt_bus) * get(gen3_on_bus)
			amp27 = get(gen3_amp_bus)
		elseif mode27 == 3 then volt27 = 27 * ground
			amp27 = get(DC_27_amp) * ground
		elseif mode27 == 4 then volt27 = get(bat_volt_bus2)
			amp27 = get(bat_amp_bus2)
		elseif mode27 == 6 then volt27 = get(bat_volt_bus1)
			amp27 = get(bat_amp_bus1)
		else volt27 = get(DC_27_volt)
			amp27 = get(DC_27_amp) end
	elseif bus_mode == 0 then
		if mode27 == 0 then volt27 = get(gen1_volt_bus) * get(gen1_on_bus)
			amp27 = get(gen1_amp_bus)
		elseif mode27 == 1 then volt27 = get(gen2_volt_bus) * get(gen2_on_bus)
			amp27 = get(gen2_amp_bus)
		elseif mode27 == 2 then volt27 = get(gen3_volt_bus) * get(gen3_on_bus)
			amp27 = get(gen3_amp_bus)
		elseif mode27 == 3 then volt27 = get(DC_27_volt) * ground
			amp27 = get(DC_27_amp) * ground
		elseif mode27 == 4 then volt27 = get(bat_volt_bus2)
			amp27 = get(bat_amp_bus2)
		elseif mode27 == 6 then volt27 = get(bat_volt_bus1)
			amp27 = get(bat_amp_bus1)
		else volt27 = get(DC_27_volt) * ground 
			amp27 = get(DC_27_amp) end
	else volt27 = 0 end
	
	local DC27_volt_angle_need = volt27 * 240 / 30 - 120
	DC27_volt_angle = DC27_volt_angle + (DC27_volt_angle_need - DC27_volt_angle_last) * passed * time_coef
	set(ind_bus27_volt_angle, DC27_volt_angle)

	-- calculate bus amp angle
	local all_amp_angle_need = -103
	all_amp_angle_need = amp27 * 225 / 500 - 103
	all_amp_angle = all_amp_angle + (all_amp_angle_need - all_amp_angle_last) * passed * time_coef
	set(ind_bus27_amp_angle, all_amp_angle)	

	
	-- calculate angle for 36v voltmeter
	local mode36 = get(ind_36v_mode)
	local AC36_volt = 0
	if mode36 < 3 then AC36_volt = get(AC_36_volt) * get(inv_PT1000)
	else AC36_volt = get(AC_36_volt) * get(inv_PT500)
	end
	
	local AC36_volt_angle_need = interpolate(AC36_volt_table, AC36_volt)
	AC36_volt_angle = AC36_volt_angle + (AC36_volt_angle_need - AC36_volt_angle_last) * passed * time_coef
	set(ind_bus36_volt_angle, AC36_volt_angle)
	
	-- calculate angle for 115v voltmeter
	local mode115 = get(ind_115v_mode)
	local AC115_volt = 0
	if mode115 == 0 then AC115_volt = get(AC_115_volt) * get(inv_PO1500_radio)
	elseif mode115 == 1 then AC115_volt = get(AC_115_volt) * get(inv_PO1500_steklo)
	else AC115_volt = 115 * get(ground_available) end
	
	local AC115_volt_angle_need = interpolate(AC115_volt_table, AC115_volt)
	AC115_volt_angle = AC115_volt_angle + (AC115_volt_angle_need - AC115_volt_angle_last) * passed * time_coef
	set(ind_bus115_volt_angle, AC115_volt_angle)
	
	-- set last variables
	gen1_angle_last = gen1_angle
	gen2_angle_last = gen2_angle
	gen3_angle_last = gen3_angle
	all_amp_angle_last = all_amp_angle
	DC27_volt_angle_last = DC27_volt_angle
	AC36_volt_angle_last = AC36_volt_angle
	AC115_volt_angle_last = AC115_volt_angle


	
	-- lamps logic
	gen1_fail_lamp = get(gen1_fail_lit) == 1
	gen2_fail_lamp = get(gen2_fail_lit) == 1
	gen3_fail_lamp = get(gen3_fail_lit) == 1
	PO_fail_lamp = get(PO_fail_lit) == 1
	PT_fail_lamp = get(PT500_fail_lit) == 1
	ground_lamp = ground == 1 or get(but_test_lamp) == 1
	
end



-- components of electric panel
components = {

	--------------------
	-- lamps and leds --
	--------------------
	
	-- gen 1 fail led
	textureLit {
		position = { 1744, 837, 59, 25},
		image = get(gen1_fail_img),
		visible = function()
			return gen1_fail_lamp
		end
	},
	
	-- gen 2 fail led
	textureLit {
		position = { 1814, 837, 59, 25},
		image = get(gen2_fail_img),
		visible = function()
			return gen2_fail_lamp
		end
	},	
	
	-- gen 3 fail led
	textureLit {
		position = { 1887, 837, 59, 25},
		image = get(gen3_fail_img),
		visible = function()
			return gen3_fail_lamp
		end
	},	
	
	-- PT500 fail led
	textureLit {
		position = { 1600, 837, 59, 25},
		image = get(PT_fail_img),
		visible = function()
			return PT_fail_lamp
		end
	},	
	
	-- PO fail led
	textureLit {
		position = { 1034, 793, 22, 22},
		image = get(red_led),
		visible = function()
			return PO_fail_lamp
		end
	},	

	-- Ground power led
	textureLit {
		position = { 1064, 793, 22, 22},
		image = get(red_led),
		visible = function()
			return ground_lamp
		end
	},		
	
	------------
	-- gauges --
	------------

	-- gen 1 ampermeter
	needle { 
		image = get(needles_1),
		position = {1000, 1208, 120, 120},
		angle = function()
			return gen1_angle
		end,	
	},

	-- gen 2 ampermeter
	needle { 
		image = get(needles_1),
		position = {1240, 1208, 120, 120},
		angle = function()
			return gen2_angle
		end,	
	},

	-- gen 3 ampermeter
	needle { 
		image = get(needles_1),
		position = {1600, 1087, 120, 120},
		angle = function()
			return gen3_angle
		end,	
	},
	
	-- DC 27 ampermeter
	needle { 
		image = get(needles_1),
		position = {1360, 1208, 120, 120},
		angle = function()
			return all_amp_angle
		end,	
	},	
	
	-- DC 27 voltmeter
	needle { 
		image = get(needles_1),
		position = {1120, 1208, 120, 120},
		angle = function()
			return DC27_volt_angle
		end,	
	},	

	-- AC 36 voltmeter
	needle { 
		image = get(needles_1),
		position = {1720, 1087, 120, 120},
		angle = function()
			return AC36_volt_angle
		end,	
	},

	-- AC 115 voltmeter
	needle { 
		image = get(needles_1),
		position = {1840, 1087, 120, 120},
		angle = function()
			return AC115_volt_angle
		end,	
	},

	----------------
	-- caps --
	----------------
	-- cover
	texture {
		position = { 1035, 1243, 50, 50 },
		image = get(black_cap),
	},
	-- cover
	texture {
		position = { 1275, 1243, 50, 50 },
		image = get(black_cap),
	},
	-- cover
	texture {
		position = { 1635, 1122, 50, 50 },
		image = get(black_cap),
	},	
	-- cover
	texture {
		position = { 1395, 1243, 50, 50 },
		image = get(black_cap),
	},

	-- cover
	texture {
		position = { 1157, 1243, 50, 50 },
		image = get(black_cap),
	},
	-- cover2
	texture {
		position = { 1755, 1122, 50, 50 },
		image = get(black_capV),
	},	
	-- cover2
	texture {
		position = { 1875, 1122, 50, 50 },
		image = get(black_capV),
	},	
	
	
	---------------
	-- switchers --
	---------------
--[[
	rectangle {
		position = {1962, 649, 40, 100},
	},
--]]
    -- PT1000 emerg switcher
    switch {
        position = {721, 629, 19, 19  },
        state = function()
            return get(PT_emerg_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and get(PT_emerg_sw_cap) == 1 then
				playSample(switch_sound, 0)
				if get(PT_emerg_sw) ~= 0 then
					set(PT_emerg_sw, 0)
				else
					set(PT_emerg_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

    -- PT1000 emerg switcher cap
    switch {
        position = {1601, 649, 40, 100 },
        state = function()
            return get(PT_emerg_sw_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(PT_emerg_sw_cap) ~= 0 then
					set(PT_emerg_sw_cap, 0)
					if get(PT_emerg_sw) == 1 then playSample(switch_sound, 0) end
					set(PT_emerg_sw, 0)
				else
					set(PT_emerg_sw_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- power mode
	-- switch up
    clickable {
        position = {642, 599, 19, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			local a = get(power_mode)
			if a < 2 then playSample(switch_sound, 0) end
			a = a + 1
			if a > 2 then a = 2 end
			set(power_mode, a)
		end
    },
	-- switch down
    clickable {
        position = {642, 588, 19, 9},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			local a = get(power_mode)
			if a > 0 then playSample(switch_sound, 0) end
			a = a - 1
			if a < 0 then a = 0 end
			set(power_mode, a)
		end
    },	
	
    -- PT1000 switcher
    switch {
        position = {662, 588, 19, 19},
        state = function()
            return get(PT1000_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(PT1000_sw) ~= 0 then
					set(PT1000_sw, 0)
				else
					set(PT1000_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	
    -- PT500 switcher
    switch {
        position = {682, 588, 19, 19},
        state = function()
            return get(PT500_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(PT500_sw) ~= 0 then
					set(PT500_sw, 0)
				else
					set(PT500_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
    -- PO radio emerg switcher
    switch {
        position = {702, 588, 19, 19},
        state = function()
            return get(POradio_emerg_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and get(POradio_emerg_sw_cap) == 1 then
				playSample(switch_sound, 0)
				if get(POradio_emerg_sw) ~= 0 then
					set(POradio_emerg_sw, 0)
				else
					set(POradio_emerg_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
    -- PO radio emerg switcher cap
    switch {
        position = {1720, 649, 40, 100},
        state = function()
            return get(POradio_emerg_sw_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(POradio_emerg_sw_cap) ~= 0 then
					set(POradio_emerg_sw_cap, 0)
					if get(POradio_emerg_sw) == 1 then playSample(switch_sound, 0) end
					set(POradio_emerg_sw, 0)
				else
					set(POradio_emerg_sw_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },		
	
    -- PO steklo switcher
    switch {
        position = {721, 588, 19, 19},
        state = function()
            return get(POsteklo_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(POsteklo_sw) ~= 0 then
					set(POsteklo_sw, 0)
				else
					set(POsteklo_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- PO radio switcher
    switch {
        position = {741, 588, 19, 19},
        state = function()
            return get(POradio_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(POradio_sw) ~= 0 then
					set(POradio_sw, 0)
				else
					set(POradio_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	

	-- gen 1 on bus
    switch {
        position = {722, 608, 19, 19},
        state = function()
            return get(gen1_on_bus) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(gen1_on_bus) ~= 0 then
					set(gen1_on_bus, 0)
				else
					set(gen1_on_bus, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- gen 2 on bus
    switch {
        position = {742, 608, 19, 19},
        state = function()
            return get(gen2_on_bus) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(gen2_on_bus) ~= 0 then
					set(gen2_on_bus, 0)
				else
					set(gen2_on_bus, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },
	
	-- gen 3 on bus
    switch {
        position = {761, 608, 19, 19},
        state = function()
            return get(gen3_on_bus) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(gen3_on_bus) ~= 0 then
					set(gen3_on_bus, 0)
				else
					set(gen3_on_bus, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- PO steklo energ switch
    switch {
        position = {802, 669, 19, 19},
        state = function()
            return get(POsteklo_emerg_sw) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed and get(POsteklo_emerg_sw_cap) == 1 then
				playSample(switch_sound, 0)
				if get(POsteklo_emerg_sw) ~= 0 then
					set(POsteklo_emerg_sw, 0)
				else
					set(POsteklo_emerg_sw, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- PO steklo energ switch cap
    switch {
        position = {1962, 649, 40, 100},
        state = function()
            return get(POsteklo_emerg_sw_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(cap_sound, 0)
				if get(POsteklo_emerg_sw_cap) ~= 0 then
					set(POsteklo_emerg_sw_cap, 0)
					if get(POsteklo_emerg_sw) == 1 then playSample(switch_sound, 0) end
					set(POsteklo_emerg_sw, 0)
				else
					set(POsteklo_emerg_sw_cap, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- bat 1 on bus
    switch {
        position = {742, 729, 19, 19},
        state = function()
            return get(bat_conn1) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(bat_conn1) ~= 0 then
					set(bat_conn1, 0)
				else
					set(bat_conn1, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },
	-- bat 2 on bus
    switch {
        position = {762, 729, 19, 19},
        state = function()
            return get(bat_conn2) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(bat_conn2) ~= 0 then
					set(bat_conn2, 0)
				else
					set(bat_conn2, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	
    rotary {
        -- image = rotaryImage;
        value = ind_27v_mode;
        step = 1;
        position = { 1262, 648, 19, 19 };
        adjuster = function(a)
				if a >= 0 and a <= 6 then playSample(galet_sound, 0) end
				if a < 0 then a = 0
				elseif a > 6 then a = 6 end
			return a
        end;
    };		

    rotary {
        -- image = rotaryImage;
        value = ind_36v_mode;
        step = 1;
        position = { 1282, 648, 19, 19 };
        adjuster = function(a)
				if a >= 0 and a <= 5 then playSample(galet_sound, 0) end
				if a < 0 then a = 0
				elseif a > 5 then a = 5 end
			return a
        end;
    };	
	
    rotary {
        -- image = rotaryImage;
        value = ind_115v_mode;
        step = 1;
        position = { 1201, 628, 19, 19 };
        adjuster = function(a)
				if a >= 0 and a <= 2 then playSample(galet_sound, 0) end
				if a < 0 then a = 0
				elseif a > 2 then a = 2 end
			return a
        end;
    };
	
}
