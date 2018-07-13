-- this is simple logic of batteries. calculations for each bat are here.

-- initialize component property table
defineProperty("bat_volt_bus", globalPropertyf("sim/custom/xap/power/bat_volt1")) -- battery voltage, initial 24V - full charge.
defineProperty("bat_amp_bus", globalPropertyf("sim/custom/xap/power/bat_amp_bus1"))  -- battery current, initial 0A. positive - battery load, negative - battery recharge.
defineProperty("bat_on_bus", globalPropertyi("sim/custom/xap/power/bat_on_bus"))  -- battery switch. 0 = OFF, 1 = ON
defineProperty("bat_conn", globalPropertyi("sim/custom/xap/power/bat1_on"))  -- battery switch. 0 = OFF, 1 = ON

defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("DC_27_source", globalPropertyi("sim/custom/xap/power/DC_27_source"))
defineProperty("ground_available", globalPropertyi("sim/custom/xap/power/ground_available")) -- if there is ground power, this var = 1

defineProperty("fail", globalPropertyi("sim/operation/failures/rel_g_bat1"))

-- logic
defineProperty("bat_amp_cc", globalPropertyf("sim/custom/xap/power/bat_amp_cc1"))  -- if batteries are charging, they take current instead of give it. = 0 when bat is source
defineProperty("power_mode", globalPropertyi("sim/custom/xap/power/power_mode"))  -- power mode: 0 = Ground, 1 = off, 2 = airplane
defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames

-- define local variables
local bat_capacity = 25 -- A*H. initial capacity. will use for volt calculations
local BAT_CURRENT_COEF = 2 -- current, that batteries take, when they charge per 1 A*h

local MAX_BAT_CAPACITY = 25

function update()  -- every frame calculations

	-- get some variables

local passed = get(frame_time)
local bat_on = get(bat_on_bus) * get(bat_conn)
	
if passed > 0 then

	if bat_on == 1 then   -- all of calculations can be skipped if batteries are off

		-- calculate if batteries are source. depending if generators work and connected to bus, or ground power is connected or not.
		local bat_source = false
		-- define ground power
		--local ground_power = 0
		--if get(ground_available) == 1 and get(power_mode) == 0 then ground_power = 1 end
		-- define source
		--if get(gen1_on_bus) * get(gen1_volt_bus) == 0 and get(gen2_on_bus) * get(gen2_volt_bus) == 0 and get(gen3_on_bus) * get(gen3_volt_bus) == 0 and ground_power == 0 then 
		if get(DC_27_source) == 2 then
			set(bat_amp_cc, 0)	
			bat_source = true
		elseif get(DC_27_volt) > 21 then
			set(bat_amp_cc, (MAX_BAT_CAPACITY + 5 - bat_capacity) * BAT_CURRENT_COEF)   -- bat current depends on their charge
			bat_source = false
		end

		-- calculate bat current as a substraction of given and charge cirrent
		local bat_amp = get(bat_amp_bus)

		-- calculate curent bat capacity
		bat_capacity = bat_capacity - bat_amp * passed / 3600
		if bat_capacity < 0 then
			bat_capacity = 0 
			--bat_amp = 0
		end
		if bat_capacity > MAX_BAT_CAPACITY + 5 then 
			bat_capacity = MAX_BAT_CAPACITY + 5
			--bat_amp = 0
		end


		-- calculate bat voltage
		local bat_volt = 19 + math.min(bat_capacity, MAX_BAT_CAPACITY) / 5 - bat_amp / 100  -- bat volt depends on current capacity and load or charge

		-- increase capacity fall, when batteries are almost empty. fixes blink issue
		if bat_volt < 21 and bat_source or get(fail) == 6 then bat_capacity = bat_capacity / 2 end
		
		-- set results
		-- set current for ampermeters	
		set(bat_amp_bus, bat_amp) 

		-- set volts
		set(bat_volt_bus, bat_volt)

  	else 
 		-- set current
		set(bat_amp_bus, 0) 
		set(bat_amp_cc, 0)	
		-- set volts
		set(bat_volt_bus, 0)
  	end
end

end
