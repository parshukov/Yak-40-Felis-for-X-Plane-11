
defineProperty("cam_in_cockpit", globalPropertyi("sim/graphics/view/view_is_external"))

defineProperty("hole1", globalPropertyf("sim/flightmodel2/misc/custom_slider_ratio[1]"))  
defineProperty("hole2", globalPropertyf("sim/flightmodel2/misc/custom_slider_ratio[2]")) 
defineProperty("ias", globalPropertyf("sim/flightmodel/position/indicated_airspeed"))
defineProperty("apu_N1", globalPropertyf("sim/cockpit/engine/APU_N1")) -- APU N1
defineProperty("starter_work_lit", globalPropertyi("sim/custom/xap/start/starter_work_lit")) -- starter lamp
defineProperty("stop_but", globalPropertyi("sim/custom/xap/start/stop_but")) -- stop button
defineProperty("N1", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[1]"))   
defineProperty("N2", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[0]"))
defineProperty("N3", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[2]"))
defineProperty("flap_deg1", globalPropertyf("sim/flightmodel2/wing/flap1_deg[0]"))  -- left flap deg
defineProperty("flap_deg2", globalPropertyf("sim/flightmodel2/wing/flap1_deg[1]"))  -- right flap deg

defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- frame time

local wind_sound = loadSample('Custom Sounds/window_wind.wav')
local tik_tak = loadSample('Custom Sounds/acs_tik_tik.wav')

local ai9_stop_inn = loadSample('Custom Sounds/AI9_stop_inn.wav')
local ai9_stop_out = loadSample('Custom Sounds/AI9_stop_out.wav')

local starter_out = loadSample('Custom Sounds/starter_out.wav')
local starter_inn = loadSample('Custom Sounds/starter_inn.wav')

local engine_1 = loadSample('Custom Sounds/engine_out.wav')
local engine_2 = loadSample('Custom Sounds/engine_out.wav')
local engine_3 = loadSample('Custom Sounds/engine_out.wav')

local flaps = loadSample('Custom Sounds/flap.wav')


--WORK--------------------------------------------------------------------------------------------------------------------------------------
playSample(wind_sound, 1) -- wind in windows
setSampleGain(wind_sound, 0)

playSample(tik_tak, 1)  -- clock now ticks :)
setSampleGain(tik_tak, 0)

playSample(engine_1, 1) -- engine sound through windows
setSampleGain(engine_1, 0)
setSamplePitch(engine_1, 1000)

playSample(engine_2, 1) -- engine sound through windows
setSampleGain(engine_2, 0)
setSamplePitch(engine_2, 1000)

playSample(engine_2, 1) -- engine sound through windows
setSampleGain(engine_2, 0)
setSamplePitch(engine_2, 1000)

local apu_n1_last = get(apu_N1)
local apu_counter = 0
local flaps_last = math.max(get(flap_deg1), get(flap_deg2))
function update() --------------------------------------------------------------------------------------------------------------------------
	local passed = get(frame_time)
	
	local inside = get(cam_in_cockpit) == 0
	
	-- noise when open windows in flight
	local window_open = math.max(get(hole1), get(hole2))
	local spd = get(ias) * 0.5
	local wind_gain = math.min(1000, window_open * spd * 10)
	if not inside then wind_gain = 0 end
	setSampleGain(wind_sound, wind_gain)
	
	-- clock gain
	if inside then setSampleGain(tik_tak, 150) else setSampleGain(tik_tak, 0) end
	
	-- AI9 engine stop sound
	apu_counter = apu_counter + passed
	if get(apu_N1) < apu_n1_last and apu_n1_last > 80 and apu_n1_last < 95 and apu_counter > 20 then
		if not isSamplePlaying(ai9_stop_inn) then playSample(ai9_stop_inn, 0) end
		if not isSamplePlaying(ai9_stop_out) then playSample(ai9_stop_out, 0) end
	end
	apu_n1_last = get(apu_N1)
	
	if inside then
		setSampleGain(ai9_stop_inn, 1000)
		setSampleGain(ai9_stop_out, 0)
	else
		setSampleGain(ai9_stop_inn, 0)
		setSampleGain(ai9_stop_out, 1000)
	end
	
	-- starter sound
	local starter = get(starter_work_lit) == 1
	if starter then 
		if not isSamplePlaying(starter_out) then playSample(starter_out, 0) end
		if not isSamplePlaying(starter_inn) then playSample(starter_inn, 0) end
	else
		stopSample(starter_out)
		stopSample(starter_inn)		
	end
	if get(stop_but) == 1 then
		stopSample(starter_out)
		stopSample(starter_inn)
	end
	
	if inside then
		setSampleGain(starter_inn, 700)
		setSampleGain(starter_out, window_open * 500)
	else
		setSampleGain(starter_inn, 0)
		setSampleGain(starter_out, 1000)
	end 
	
	-- engine sound
	local n1 = get(N1)
	local n2 = get(N2)
	local n3 = get(N3)
	setSamplePitch(engine_1, math.max(100, n1 * 10))
	setSamplePitch(engine_2, math.max(100, n2 * 10))
	setSamplePitch(engine_3, math.max(100, n3 * 10))
	
	if inside then
		setSampleGain(engine_1, n1 * window_open * 5)
		setSampleGain(engine_2, n2 * window_open * 5)
		setSampleGain(engine_3, n3 * window_open * 5)
	else
		setSampleGain(engine_1, 0)
		setSampleGain(engine_2, 0)
		setSampleGain(engine_3, 0)
	end

	-- flaps sound
	local flaps_now = math.max(get(flap_deg1), get(flap_deg2))
	if passed > 0 then
		-- play flaps sound when they moves
		if math.abs(flaps_now - flaps_last)/passed > 0.0000001 then
			if not isSamplePlaying(flaps) then playSample(flaps, 1) end
		else stopSample(flaps) end
		-- set flaps sound pitch and loudness depending on theyr speed
		local flap_coef = 1
		if inside then flap_coef = 0.4 end
		setSampleGain(flaps, math.max(math.min(1000, math.abs(flaps_now - flaps_last)/passed) * 200 * flap_coef, 300))
		setSamplePitch(flaps, math.max(math.min(1000, math.abs(flaps_now - flaps_last)/passed * 400), 500))
		
	
	end
	
	
	flaps_last = math.max(get(flap_deg1), get(flap_deg2))
	
	-- stop all sounds when sim on pause
	if passed == 0 then
		setSampleGain(wind_sound, 0)
		setSampleGain(tik_tak, 0)
		setSampleGain(engine_1, 0)
		setSampleGain(engine_2, 0)
		setSampleGain(engine_2, 0)
		setSampleGain(starter_inn, 0)
		setSampleGain(starter_out, 0)
		setSampleGain(ai9_stop_out, 0)
		setSampleGain(ai9_stop_inn, 0)
		setSampleGain(flaps, 0)
	end

	
--------------------------------------------------------------------------------------------------------------------------------------------
end  ---------------------------------------------------------------------------------------------------------------------------------------


