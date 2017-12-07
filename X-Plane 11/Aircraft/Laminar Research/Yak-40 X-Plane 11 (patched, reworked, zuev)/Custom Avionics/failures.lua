-- this is simple failures logic

--[[
sim/operation/failures/rel_conlock	int	y	failure_enum	Controls locked
sim/operation/failures/rel_door_open	int	y	failure_enum	Door Open
sim/operation/failures/rel_ex_power_on	int	y	failure_enum	External power is on
sim/operation/failures/rel_fuelcap	int	y	failure_enum	Fuel Cap left off
sim/operation/failures/rel_throt_lo	int	y	failure_enum	Throttle inop giving min thrust
sim/operation/failures/rel_throt_hi	int	y	failure_enum	Throttle inop giving max thrust
sim/operation/failures/rel_comsta0	int	y	failure_enum	Engine Compressor Stall - engine 1
sim/operation/failures/rel_comsta1	int	y	failure_enum	Engine Compressor Stall - engine 2
sim/operation/failures/rel_comsta2	int	y	failure_enum	Engine Compressor Stall - engine 3
--]]
-- sim fails
defineProperty("rel_conlock", globalPropertyi("sim/operation/failures/rel_conlock"))
defineProperty("rel_door_open", globalPropertyi("sim/operation/failures/rel_door_open"))
defineProperty("rel_ex_power_on", globalPropertyi("sim/operation/failures/rel_ex_power_on"))
defineProperty("rel_fuelcap", globalPropertyi("sim/operation/failures/rel_fuelcap"))
defineProperty("rel_throt_lo", globalPropertyi("sim/operation/failures/rel_throt_lo"))
defineProperty("rel_throt_hi", globalPropertyi("sim/operation/failures/rel_throt_hi"))
defineProperty("rel_comsta0", globalPropertyi("sim/operation/failures/rel_comsta0"))
defineProperty("rel_comsta1", globalPropertyi("sim/operation/failures/rel_comsta1"))
defineProperty("rel_comsta2", globalPropertyi("sim/operation/failures/rel_comsta2"))

-- sources
defineProperty("control_fix", globalPropertyi("sim/custom/xap/control/control_fix")) -- fix controls, so they cannot move. 1 = fix, 0 = released
defineProperty("door", globalPropertyf("sim/flightmodel2/misc/custom_slider_ratio[4]")) 
defineProperty("ground_available", globalPropertyi("sim/custom/xap/power/ground_available"))-- ground power. 0 = off, 1 = on
defineProperty("ias", globalPropertyf("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")) -- ias variable
defineProperty("alpha", globalPropertyf("sim/flightmodel2/misc/AoA_angle_degrees"))  -- angle of attack

local was_aoa1 = false
local was_aoa2 = false
local was_aoa3 = false



function update()
	if get(control_fix) == 1 then set(rel_conlock, 6) else set(rel_conlock, 0) end
	if get(door) > 0.1 then set(rel_door_open, 6) else set(rel_door_open, 0) end
	if get(ground_available) == 1 then set(rel_ex_power_on, 6) else set(rel_ex_power_on, 0) end
	set(rel_fuelcap, 0)
	set(rel_throt_lo, 0)
	set(rel_throt_hi, 0)
	local IAS = get(ias)
	local AOA = get(alpha)
	
	if IAS > 20 then
		-- engine 1
		if AOA > 25 then 
			if get(rel_comsta0) < 6 then was_aoa1 = true end
			set(rel_comsta0, 6)
		elseif was_aoa1 and get(rel_comsta0) == 6 then 
			set(rel_comsta0, 0)
			was_aoa1 = false
		end
		-- engine 2
		if AOA > 20 then 
			if get(rel_comsta1) < 6 then was_aoa2 = true end
			set(rel_comsta1, 6)
		elseif was_aoa2 and get(rel_comsta1) == 6 then 
			set(rel_comsta1, 0)
			was_aoa2 = false
		end	
		-- engine 3
		if AOA > 25 then 
			if get(rel_comsta2) < 6 then was_aoa3 = true end
			set(rel_comsta2, 6)
		elseif was_aoa3 and get(rel_comsta2) == 6 then 
			set(rel_comsta2, 0)
			was_aoa3 = false
		end			
		
	else
		if was_aoa1 then set(rel_comsta0, 0) end
		if was_aoa2 then set(rel_comsta1, 0) end
		if was_aoa3 then set(rel_comsta2, 0) end
		was_aoa1 = false
		was_aoa2 = false
		was_aoa3 = false
	end
	
	


end