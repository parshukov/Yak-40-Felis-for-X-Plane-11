defineProperty("bspk_siren", globalPropertyi("sim/custom/xap/gauges/bspk_siren")) -- BSPK signal
defineProperty("srd_siren", globalPropertyi("sim/custom/xap/gauges/srd_siren")) -- SRD signal
defineProperty("fire_siren", globalPropertyi("sim/custom/xap/gauges/fire_siren")) -- fire signal
defineProperty("stall_siren", globalPropertyi("sim/custom/xap/gauges/stall_siren")) -- stall signal
defineProperty("flap_siren", globalPropertyf("sim/custom/xap/gauges/flaps_siren"))
defineProperty("gear_siren", globalPropertyf("sim/custom/xap/gauges/gear_siren"))

defineProperty("ap_fail", globalPropertyi("sim/custom/xap/AP/ap_fail")) -- autopilot is off by fail

defineProperty("guns_armed", globalPropertyf("sim/cockpit/weapons/guns_armed"))
defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time between frames
defineProperty("siren_button", globalPropertyi("sim/custom/xap/gauges/siren_button")) -- button for temporary OFF sirene

defineProperty("cam_in_cockpit", globalPropertyi("sim/graphics/view/view_is_external"))



local siren_sound = loadSample('Custom Sounds/siren.wav')
local bell_sound = loadSample('Custom Sounds/bell.wav')

set(guns_armed, 0)

local system_counter = 0

local bspk_last = 0
local bspk_counter = 10
local srd_last = 0
local srd_sound = false
local srd_counter = 0
local fire_last = 0
local stall_last = 0
local stall_counter = 0
local stall_sound = false
local flaps_last = 0
local gears_last = 0
local autopilot_counter = 10
local autopilot_last = 0

local button_pressed = false

function update()
	
local inside = get(cam_in_cockpit) == 0
	local passed = get(frame_time)
	system_counter = system_counter + passed
	set(guns_armed, 0)
	
	setSampleGain(siren_sound,  500)
	setSampleGain(bell_sound,  600)	
	
	-- sirene sources
	-- BSPK
	bspk_counter = bspk_counter + passed
	local bspk = get(bspk_siren)
	if bspk_last ~= bspk and bspk == 1 then 
		bspk_counter = 0 
		button_pressed = false -- reset virtual button position
	end
	bspk_last = bspk
	
	----------------
	-- SRD
	local srd = get(srd_siren)
	if srd == 1 and srd ~= srd_last then 
		button_pressed = false -- reset virtual button position
	end
	srd_last = srd
	if srd == 1 then 
		srd_counter = srd_counter + passed
		if srd_counter > 0.25 then
			srd_counter = 0
			srd_sound = not srd_sound
		end
	else srd_sound = false
	end
	---------------
	-- fire
	local fire = get(fire_siren)
	if fire ~= fire_last and fire == 1 then
		button_pressed = false -- reset virtual button position
	end
	fire_last = fire
	
	-------------
	-- stall
	local stall = get(stall_siren)
	if stall ~= stall_last and stall == 1 then
		button_pressed = false -- reset virtual button position
	end
	stall_last = stall
	if stall == 1 then 
		stall_counter = stall_counter + passed
		if stall_counter > 0.25 then
			stall_counter = 0
			stall_sound = not stall_sound
		end
	else stall_sound = false
	end
	
	-------------
	-- flaps
	local flaps = get(flap_siren)
	if flaps ~= flaps_last and flaps == 1 then
		button_pressed = false -- reset virtual button position
	end
	flaps_last = flaps
	
	-- gears
	local gears = get(gear_siren)
	if gears ~= gears_last and gears == 1 then
		button_pressed = false -- reset virtual button position
	end
	gears_last = gears

	---------------
	-- autopilot
	autopilot_counter = autopilot_counter + passed
	local autopilot = get(ap_fail)
	if autopilot_last ~= autopilot and autopilot == 1 then 
		autopilot_counter = 0 
		button_pressed = false -- reset virtual button position
	end
	autopilot_last = autopilot
	

	-- start playing main sirene
	if inside and not isSamplePlaying(siren_sound) and system_counter > 5 and not button_pressed and (srd_sound or stall_sound or flaps == 1 or gears == 1) then
		playSample(siren_sound, 1)
	end
	
	-- stop playing main sirene
	if isSamplePlaying(siren_sound) and (button_pressed or (not srd_sound and not stall_sound and flaps == 0 and gears == 0)) or not inside or passed == 0 then
		stopSample(siren_sound)
	end	

	-- start playing bell 
	if inside and not isSamplePlaying(bell_sound) and system_counter > 5 and not button_pressed and ((bspk_counter < 4 and bspk == 1) or fire == 1 or (autopilot_counter < 4 and autopilot == 1)) then
		playSample(bell_sound, 1)
	end
	
	-- stop playing bell
	if isSamplePlaying(bell_sound) and (button_pressed or ((bspk_counter >= 4 or bspk == 0) and fire == 0 and (autopilot_counter >= 4 or autopilot == 0))) or not inside or passed == 0 then
		stopSample(bell_sound)
	end	
	
	
	
	local button = get(siren_button)
	if button == 1 then button_pressed = true end  -- if button pressed - siren will not work further, till new event come
	
	
	
	

end



