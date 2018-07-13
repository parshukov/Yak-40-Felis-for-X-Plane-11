-- this is simple engine logic
size = {2048, 2048}
-- define property table
-- source

defineProperty("sim_version", globalPropertyi("sim/custom/xap/sim_version"))  -- saved sim version

defineProperty("tro_comm_1", globalPropertyf("sim/flightmodel/engine/ENGN_thro[0]"))
defineProperty("tro_comm_2", globalPropertyf("sim/flightmodel/engine/ENGN_thro[1]"))
defineProperty("tro_comm_3", globalPropertyf("sim/flightmodel/engine/ENGN_thro[2]"))

defineProperty("msl_alt", globalPropertyf("sim/flightmodel/position/elevation"))  -- barometric alt. maybe in feet, maybe in meters.
defineProperty("baro_press", globalPropertyf("sim/weather/barometer_sealevel_inhg"))  -- pressire at sea level in.Hg

defineProperty("air_engine", globalPropertyf("sim/custom/xap/antiice/air_engine"))

-- controls
defineProperty("tro_need_1", globalPropertyf("sim/flightmodel/engine/ENGN_thro_use[1]"))
defineProperty("tro_need_2", globalPropertyf("sim/flightmodel/engine/ENGN_thro_use[0]"))
defineProperty("tro_need_3", globalPropertyf("sim/flightmodel/engine/ENGN_thro_use[2]"))

defineProperty("virt_rud1", globalPropertyf("sim/custom/xap/eng/virt_rud1"))
defineProperty("virt_rud2", globalPropertyf("sim/custom/xap/eng/virt_rud2"))
defineProperty("virt_rud3", globalPropertyf("sim/custom/xap/eng/virt_rud3"))

defineProperty("rud_close", globalPropertyi("sim/custom/xap/eng/rud_close"))
defineProperty("red_rud_close", globalPropertyi("sim/custom/xap/eng/red_rud_close"))
defineProperty("red_rud_button", globalPropertyi("sim/cockpit2/switches/custom_slider_on[13]"))

defineProperty("stopor", globalPropertyf("sim/flightmodel2/misc/custom_slider_ratio[12]"))

defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames
defineProperty("flight_time", globalPropertyf("sim/time/total_running_time_sec")) -- sim time

defineProperty("sim_T", globalPropertyf("sim/weather/temperature_ambient_c")) -- temperature on sea level
defineProperty("switch_rud", globalPropertyi("sim/custom/xap/set/switch_rud")) -- switch or hold rud stopors
defineProperty("three_ruds", globalPropertyi("sim/custom/xap/set/three_ruds")) -- user have 3 RUDs
defineProperty("reverse", globalPropertyf("sim/flightmodel2/engines/thrust_reverser_deploy_ratio[0]")) -- reverse on middle engine
defineProperty("rev_fail1", globalPropertyi("sim/operation/failures/rel_revloc1")) -- reverse fail for logic
defineProperty("rev_fail3", globalPropertyi("sim/operation/failures/rel_revloc2")) -- reverse fail for logic
defineProperty("rev_fail2", globalPropertyi("sim/operation/failures/rel_revloc0")) -- reverse fail for logic

defineProperty("acf_tmax", globalPropertyf("sim/aircraft/engine/acf_tmax")) -- engines power

defineProperty("override", globalPropertyi("sim/operation/override/override_throttles"))
set(override, 1) -- use it for take control via plugin
set(tro_need_1, 0.1)
set(tro_need_2, 0.1)
set(tro_need_3, 0.1)


function onAvionicsDone()
	set(override, 0) -- release engine control via plugin to let other models fly :)
	print("throtles released")
end


-- UP and DOWN little levers on RUDs to let them pass IDLE position.
rud_stop = findCommand("sim/flight_controls/tailhook_up")
function rud_stop_handler(phase)
	if get(switch_rud) == 1 then
		if 0 == phase then
			set(rud_close, math.abs(1 - get(rud_close)))
		end
	else
		if 1 == phase then
			set(rud_close, 1)
		else
			set(rud_close, 0)
		end
	end
return 0
end
registerCommandHandler(rud_stop, 0, rud_stop_handler)

-- UP and DOWN red plank on RUDs to let them pass IDLE position.
red_rud_stop = findCommand("sim/flight_controls/tailhook_down")
function red_rud_stop_handler(phase)
	if 0 == phase then
		if get(red_rud_close) == 0 and get(virt_rud1) >=0.1 and get(virt_rud2) >=0.1 and get(virt_rud3) >=0.1 then
			set(red_rud_close, 1)
		else set(red_rud_close, 0) end
	end
return 0
end
registerCommandHandler(red_rud_stop, 0, red_rud_stop_handler)


-- table of throttles
local tro_table_10 = {{ 0.00,-1 }, -- STOP
                  {  0.10, 0.267 },	-- IDLE 213 lbs isa
                  {  0.40, 0.5797 }, -- 0.4 nominal 1007 lbs isa
				  {  0.50, 0.7}, -- 0.6 nominal 1510 lbs isa
				  {  0.55, 0.7514 }, -- 0.7 nominal 1763 lbs isa
                  {  0.60, 0.81954}, -- 0.85 nominal 2136 lbs isa
           	      {  0.70, 0.882 }, -- nominal 2517 lbs isa
          	      {  1.00, 1.004 }} -- takeoff 3372 lbs isa
				  
local tro_table_11 = {{ 0.00,-1 }, -- STOP
                  {  0.10, 0.076 },	-- IDLE 213 lbs isa
                  {  0.40, 0.35 }, -- 0.4 nominal 1007 lbs isa
				  {  0.50, 0.53}, -- 0.6 nominal 1510 lbs isa
				  {  0.55, 0.59 }, -- 0.7 nominal 1763 lbs isa
                  {  0.60, 0.713}, -- 0.85 nominal 2136 lbs isa
           	      {  0.70, 0.798 }, -- nominal 2517 lbs isa
          	      {  1.00, 1.000 }} -- takeoff 3372 lbs isa

-- tables for altitude correction
local alt_table = {{ -50000, 1},    -- bugs workaround
				  { 0.00, 1 },    -- on standard pressure zero level
				  {  30000, 1.1},
          		  {  100000, 0.1 }}

local t_table = {{ -1000, 1},    -- bugs workaround
				  { -30, 1 },   -- -30 C
				  { -10, 1 },   -- -10 C
            	  {  0,  1 },   --  0 C
           		  {  15, 1 },    -- standard temperature
          		  {  50, 1 },  --  +50 C
          		  {  1000, 1 }}   -- bugs workaround


-- interpolate values using table as reference
local function interpolate(tbl, value)
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



local rud1_out = true
local rud2_out = true
local rud3_out = true

local rud1_last = 0.1
local rud2_last = 0.1
local rud3_last = 0.1

local rud1_need = 0.1
local rud2_need = 0.1
local rud3_need = 0.1

local timer = 0

local message_printed = false

function update()
	-- time calculations
	local passed = get(frame_time)
	local XP11 = get(sim_version) == 10	
	if XP11 and not message_printed then 
		print("engines tuned to XP11") 
		message_printed = true
	end
	
-- time bug workaround
if passed > 0 then

	-- altitude calculations
	local alt = get(msl_alt) * 3.28083 -- MSL alt in feet
	local alt_baro = (29.92 - get(baro_press)) * 1000
	local alt_coef = interpolate(alt_table, alt + alt_baro)  -- altitude coeficient for limit power under crit alt
	local t_coef = interpolate(t_table, get(sim_T))

	-- rud calculations
	local rud_minimum = 0.1
	local stop_active = get(rud_close) == 0
	local red_stopor = get(red_rud_close) == 1
	local stopor_active = get(stopor) > 0.5
	local heat = 0 --get(air_engine) -- wing heat takes some power from engines

	local rud1_com = get(tro_comm_1)
	local rud2_com = get(tro_comm_2)
	local rud3_com = get(tro_comm_3)
	
	-- set new engines power with defrost system
	set(acf_tmax, 15000 * (1 - get(air_engine)))

	-- halt side levers for reverse
	if get(reverse) > 0.5 and get(three_ruds) == 0 then
		rud1_com = 0.0
		rud3_com = 0.0
	end
	set(rev_fail1, 6)
	set(rev_fail2, 0)
	set(rev_fail3, 6)

	-- limit rud 1
	if rud1_com < rud_minimum and rud1_out then rud1_com = rud_minimum end

	-- check if rud were out from stop
	if rud1_com >= rud_minimum and (stop_active or red_stopor) then rud1_out = true
	else rud1_out = false end

	-- set result
	if not stopor_active then rud1_last = rud1_com end
	set(virt_rud1, rud1_last)

	-- limit rud2
	if rud2_com < rud_minimum and rud2_out then rud2_com = rud_minimum end

	-- check if rud were out from stop
	if rud2_com >= rud_minimum and (stop_active or red_stopor)  then rud2_out = true
	else rud2_out = false end

	-- set result
	if not stopor_active then rud2_last = rud2_com end
	set(virt_rud2, rud2_last)


	-- limit rud3
	if rud3_com < rud_minimum and rud3_out then rud3_com = rud_minimum end

	-- check if rud were out from stop
	if rud3_com >= rud_minimum and (stop_active or red_stopor)  then rud3_out = true
	else rud3_out = false end

	-- set result
	if not stopor_active then rud3_last = rud3_com end
	set(virt_rud3, rud3_last)




	-- set results for engine throttles
	-- engine 1
	local throttle_1 = 0
	if XP11 then throttle_1 = interpolate(tro_table_11, rud1_last) * alt_coef * t_coef
	else throttle_1 = interpolate(tro_table_10, rud1_last) * alt_coef * t_coef end
	--smooth move
	if throttle_1 > rud1_need then rud1_need = rud1_need + math.min((throttle_1 - rud1_need) * passed * 10, passed * 0.08)
	elseif throttle_1 < rud1_need then rud1_need = rud1_need - math.min((rud1_need - throttle_1) * passed * 7, passed * 0.1) end
	-- set result
	set(tro_need_1, rud1_need)

	-- engine 2
	local throttle_2 = 0
	if XP11 then throttle_2 = interpolate(tro_table_11, rud2_last) * alt_coef * t_coef
	else throttle_2 = interpolate(tro_table_10, rud2_last) * alt_coef * t_coef end
	--smooth move
	if throttle_2 > rud2_need then rud2_need = rud2_need + math.min((throttle_2 - rud2_need) * passed * 10, passed * 0.08)
	elseif throttle_2 < rud2_need then rud2_need = rud2_need - math.min((rud2_need - throttle_2) * passed * 7, passed * 0.1) end
	-- set result
	set(tro_need_2, rud2_need)

	-- engine 3
	local throttle_3 = 0
	if XP11 then throttle_3 = interpolate(tro_table_11, rud3_last) * alt_coef * t_coef
	else throttle_3 = interpolate(tro_table_10, rud3_last) * alt_coef * t_coef end
	--smooth move
	if throttle_3 > rud3_need then rud3_need = rud3_need + math.min((throttle_3 - rud3_need) * passed * 10, passed * 0.08)
	elseif throttle_3 < rud3_need then rud3_need = rud3_need - math.min((rud3_need - throttle_3) * passed * 7, passed * 0.1) end
	-- set result
	set(tro_need_3, rud3_need)

	-- animate red RUD plank
	if red_stopor then set(red_rud_button, 0)
	else set(red_rud_button, 1) end

	-- fix bug with plank and RUD
	if rud1_last < rud_minimum or rud2_last < rud_minimum or rud3_last < rud_minimum then set(red_rud_close, 0) end

end

end

components = {

    -- red plank manipulator
    clickable {
        position = {800, 407, 200, 40},  -- search and set right

       cursor = {
            x = 16,
            y = 32,
            width = 16,
            height = 16,
            shape = loadImage("clickable.png")
        },

       	onMouseClick = function()
			commandOnce(red_rud_stop)
			return true
		end,
    },



}



