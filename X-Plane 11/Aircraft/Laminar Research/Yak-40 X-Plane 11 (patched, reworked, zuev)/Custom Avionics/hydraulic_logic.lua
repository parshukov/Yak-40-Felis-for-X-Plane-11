-- this is simple logic for calculations of hydraulic system

-- define properties
defineProperty("main_press", globalPropertyf("sim/custom/xap/hydro/main_press")) -- pressure in main system. initial 120 kg per square sm. maximum 160.
defineProperty("emerg_press", globalPropertyf("sim/custom/xap/hydro/emerg_press")) -- pressure in emergency system. initial 120 kg per square sm. maximum 160.
defineProperty("hydro_quantity", globalPropertyf("sim/custom/xap/hydro/hydro_quantity")) -- quantity of hydraulic liquid. initially 28 liters. in work downs to 21 liters. also can flow out in come case of failure.
defineProperty("emerg_pump_sw", globalPropertyi("sim/custom/xap/hydro/emerg_pump_sw"))  -- emergency hydro pump switcher. if its ON and power exist - emergency bus will gain pressure

-- AZS
defineProperty("AZS_hydrosys_sw", globalPropertyi("sim/custom/xap/azs/AZS_hydrosys_sw")) -- AZS for hydraulic system
defineProperty("AZS_join_sw", globalPropertyi("sim/custom/xap/azs/AZS_join_sw")) -- AZS for join

-- engines work
defineProperty("eng1_N1", globalPropertyf("sim/flightmodel/engine/ENGN_N1_[1]")) -- engine 1 rpm
defineProperty("eng2_N1", globalPropertyf("sim/flightmodel/engine/ENGN_N1_[0]")) -- engine 2 rpm

defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- frame time
defineProperty("flight_time", globalPropertyf("sim/time/total_running_time_sec")) -- sim time


-- gears
defineProperty("gear1", globalPropertyf("sim/flightmodel2/gear/deploy_ratio[0]")) -- gear deploy ratio. 0 = up, 1 = down
defineProperty("gear2", globalPropertyf("sim/flightmodel2/gear/deploy_ratio[1]")) -- gear deploy ratio. 0 = up, 1 = down
defineProperty("gear3", globalPropertyf("sim/flightmodel2/gear/deploy_ratio[2]")) -- gear deploy ratio. 0 = up, 1 = down
defineProperty("emerg_brake", globalPropertyf("sim/custom/xap/hydro/emerg_brake"))  -- pressure in braking system
defineProperty("brake_press", globalPropertyf("sim/custom/xap/hydro/brake_press"))  -- pressure in braking system
defineProperty("steer", globalPropertyf("sim/flightmodel2/gear/tire_steer_actual_deg[0]")) -- front gear steer deg
defineProperty("frontgear_use_hydro", globalPropertyi("sim/custom/xap/hydro/frontgear_use_hydro")) -- front gear steering manipulates by hydraulic system
defineProperty("gear_valve", globalPropertyi("sim/custom/xap/hydro/gear_valve")) -- position of gear valve for gydraulic calculations and animations maximum 160.
defineProperty("gear_valve_emerg", globalPropertyi("sim/custom/xap/hydro/gear_valve_emerg")) -- position of gear valve for gydraulic calculations and animations maximum 160.
defineProperty("gear_valve_emerg_cap", globalPropertyi("sim/custom/xap/hydro/gear_valve_emerg_cap")) -- position of gear valve cap for gydraulic calculations and animations maximum 160.
defineProperty("real_pedals", globalPropertyi("sim/custom/xap/set/real_pedals")) -- if you don't have pedals, you use emerg brake as main

-- wipers
defineProperty("wiper1", globalPropertyf("sim/flightmodel2/misc/wiper_angle_deg[0]")) -- wiper position in degrees
defineProperty("wiper2", globalPropertyf("sim/flightmodel2/misc/wiper_angle_deg[1]")) -- wiper position in degrees
defineProperty("wiper_sw", globalPropertyi("sim/cockpit2/switches/wiper_speed")) 

-- flaps
defineProperty("flap1", globalPropertyf("sim/flightmodel2/wing/flap1_deg[0]")) -- flap deg
defineProperty("flap2", globalPropertyf("sim/flightmodel2/wing/flap1_deg[1]")) -- flap deg

defineProperty("flaps_valve", globalPropertyi("sim/custom/xap/hydro/flaps_valve")) -- position of flaps valve for gydraulic calculations and animations.
defineProperty("flaps_valve_emerg", globalPropertyi("sim/custom/xap/hydro/flaps_valve_emerg")) -- position of emergency flaps valve for gydraulic calculations and animations.
defineProperty("flaps_valve_emerg_cap", globalPropertyi("sim/custom/xap/hydro/flaps_valve_emerg_cap")) -- position of emergency flaps valve for gydraulic calculations and animations.

-- stabiliser
defineProperty("stab", globalPropertyf("sim/custom/xap/control/pitch_trim")) -- virtual pitch trimmer. in Yak40 have range from -3 to +6 in degrees of stab.

-- reverse
defineProperty("rev_flap", globalPropertyf("sim/flightmodel2/engines/thrust_reverser_deploy_ratio[0]")) -- reverse flap position

-- ladder
defineProperty("trap", globalPropertyf("sim/flightmodel2/misc/custom_slider_ratio[3]")) -- trap position


-- power calculations
defineProperty("pump_cc", globalPropertyf("sim/custom/xap/hydro/pump_cc")) -- emergency pump consumption
defineProperty("ladder_cc", globalPropertyf("sim/custom/xap/hydro/ladder_cc")) -- ladder consumption
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt

-- failures
defineProperty("hydr_leak", globalPropertyi("sim/operation/failures/rel_hydleak")) -- leak in hydraulic

-- feed from pumps depends on total presure
local hydro_feed_main = { 
{  0, 3},    
{  120, 2 },    
{  150, 1 },    
{  165, 0 },
{  200, 0 }}  

local hydro_feed_emerg = { 
{  0, 2 },    
{  120, 1.5 },    
{  150, 1 },    
{  170, 0 },
{  240, 0 }}  

local pump_press_to_cc = { 
{  0, 2 },    
{  120, 2 },    
{  150, 1 },    
{  160, 0 },
{  240, 0 }}  

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

local main_hydro_press = get(main_press)
local emerg_hydro_press = get(emerg_press)
local quantity = 1 


local gear1_last = get(gear1)
local gear2_last = get(gear2)
local gear3_last = get(gear3)
local wiper1_last = get(wiper1)
local wiper2_last = get(wiper2)
local flap1_last = get(flap1)
local flap2_last = get(flap2)
local steer_last = get(steer)
local brake_last = get(brake_press)
local stab_last = get(stab)
local rev_last = get(rev_flap)
local brake_emerg_last = get(emerg_brake)
local trap_last = get(trap)

-- every frame calculations
function update() 
	local passed = get(frame_time)
	local power = 0
	
	-- calculate power
	if get(DC_27_volt) > 21 and get(AZS_hydrosys_sw) == 1 then power = 1
	else power = 0 end

	
-- all calculations produced only during sim work
if passed > 0 then	
	
	-- check if engines work	
	local left_eng = 0
	if get(eng1_N1) > 20 then left_eng = 1 else left_eng = 0 end
	local right_eng = 0
	if get(eng2_N1) > 20 then right_eng = 1 else right_eng = 0 end

	-- calculate the sources for main hydrosystem
	main_hydro_press = get(main_press) + (interpolate(hydro_feed_main, main_hydro_press ) * left_eng + interpolate(hydro_feed_main, main_hydro_press) * right_eng) * passed * 3 * quantity


	-- calculate source for emerg system
	local emerg_pump = 0
	local emerg_sw = get(emerg_pump_sw) * get(AZS_join_sw)
	if emerg_sw * power == -1 or (emerg_sw * power == 1 and (get(gear_valve_emerg_cap) == 1 or get(flaps_valve_emerg_cap) == 1 or get(stab) - stab_last ~= 0)) then  -- add here all emerg caps and valves
		emerg_pump = 1	
	else emerg_pump = 0 end

	
	-- calculate emergency feed
	emerg_hydro_press = get(emerg_press) + (interpolate(hydro_feed_emerg, emerg_hydro_press)) * passed * emerg_pump * 3 * quantity
	-- calculate power current consumption
	set(pump_cc, interpolate(pump_press_to_cc, emerg_hydro_press) * power * emerg_pump * 10)

	-- calculate hydro-quantity
	local leak = 0
	if get(hydr_leak) == 6 then leak = (main_hydro_press + emerg_hydro_press) / 480 * 0.005 end -- will lose 0.1 of quantity per second when pressure is max
	quantity = quantity - leak
	if quantity < 0 then quantity = 0 end
	
	-- calculate uses of main bus
	-- landing gear
	local gear_feed = math.abs(get(gear_valve)) * main_hydro_press / 20 -- last number for speed correction
	
	-- gear brakes
	local brake_feed = math.max(0, get(brake_press) - brake_last) * 0.2  -- main braking system feeds from main hydro	
	
	-- wipers
	local wipers_feed = (math.abs(get(wiper1) - wiper1_last) + math.abs(get(wiper2) - wiper2_last)) * 0.02 -- last number for speed correction
	-- off wipers when pressure is low
	if main_hydro_press < 30 then set(wiper_sw, 0) end

	-- front gear steer
	local nosegear_feed =  math.abs(get(steer) - steer_last) * get(frontgear_use_hydro) * 0.5

	-- flaps
	local flaps_feed = (math.abs(get(flap1) - flap1_last) + math.abs(get(flap2) - flap2_last)) * 20 * math.abs(get(flaps_valve))

	-- stabilisator
	local stab_feed = math.abs(get(stab) - stab_last) * 10

	-- reverse flaps
	local rev_feed = math.abs(get(rev_flap) - rev_last) * 20
	
	
	-- calculate uses of emerg bus
	-- gear brakes
	local emerg_brake_feed = math.max(0, get(emerg_brake) - brake_emerg_last) * 5
	
	local pedals = get(real_pedals) == 1
	if not pedals then -- if user don't have pedlas, redirect emergency brake to main system
		brake_feed = brake_feed + emerg_brake_feed
		emerg_brake_feed = 0
	end
	
	
	-- flaps
	local flaps_feed_emerg = (get(flap1) - flap1_last + get(flap2) - flap2_last) * get(flaps_valve_emerg) * 70
	
	-- landing gear
	local gear_feed_emerg = get(gear_valve_emerg) * emerg_hydro_press / 20 -- last number for speed correction
	
	-- ladder
	local trap_feed = math.abs(get(trap) - trap_last) * 30

	

	-- calculate new pressures for buses buses
	main_hydro_press = main_hydro_press - (gear_feed + brake_feed + wipers_feed + nosegear_feed + flaps_feed + stab_feed + rev_feed + leak * 1000) * passed  
	
	emerg_hydro_press = emerg_hydro_press - (emerg_brake_feed + flaps_feed_emerg + stab_feed + gear_feed_emerg + trap_feed + leak * 1000) * passed
	
	-- set minimal limits, maximum are set by interpolate tables; 
	if main_hydro_press < 10 then main_hydro_press = 10 end
	if emerg_hydro_press < 10 then emerg_hydro_press = 10 end

	-- power
	if trap_feed ~= 0 or rev_feed ~= 0 then set(ladder_cc, 5) else set(ladder_cc, 0) end


	-- set results
	set(main_press, main_hydro_press)
	set(emerg_press, emerg_hydro_press)
	set(hydro_quantity, quantity)

end
	-- set last variables
	gear1_last = get(gear1)
	gear2_last = get(gear2)
	gear3_last = get(gear3)
	wiper1_last = get(wiper1)
	wiper2_last = get(wiper2)
	flap1_last = get(flap1)
	flap2_last = get(flap2)
	steer_last = get(steer)
	brake_last = get(brake_press)
	stab_last = get(stab)
	rev_last = get(rev_flap)
	brake_emerg_last = get(emerg_brake)
	trap_last = get(trap)
end

