-- this is simple SPU logic
size = {100, 100}

-- define property table
defineProperty("audio_selection_com1", globalPropertyi("sim/cockpit2/radios/actuators/audio_selection_com1"))
defineProperty("audio_selection_com2", globalPropertyi("sim/cockpit2/radios/actuators/audio_selection_com2"))
defineProperty("audio_selection_nav1", globalPropertyi("sim/cockpit2/radios/actuators/audio_selection_nav1"))
defineProperty("audio_selection_nav2", globalPropertyi("sim/cockpit2/radios/actuators/audio_selection_nav2"))
defineProperty("audio_selection_adf1", globalPropertyi("sim/cockpit2/radios/actuators/audio_selection_adf1"))
defineProperty("audio_selection_adf2", globalPropertyi("sim/cockpit2/radios/actuators/audio_selection_adf2"))
defineProperty("audio_dme_enabled", globalPropertyi("sim/cockpit2/radios/actuators/audio_dme_enabled"))

defineProperty("ark1_mode", globalPropertyi("sim/custom/xap/ark/ark_1_mode"))
defineProperty("ark2_mode", globalPropertyi("sim/custom/xap/ark/ark_2_mode"))

--defineProperty("spu_power_sw", globalPropertyi("sim/custom/xap/gauges/spu_power_sw"))
defineProperty("spu_mode", globalPropertyi("sim/custom/xap/gauges/spu_mode"))
-- 0 = VHF1
-- 1 = VHF2
-- 2 -
-- 3 = ADF1
-- 4 = ADF2
-- 5 = NAV1
-- 6 = NAV2
-- 7 = DME
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt

local galet_sound = loadSample('Custom Sounds/metal_box_switch.wav')

function update()
	local mode = get(spu_mode)
	local power = get(DC_27_volt) > 21

	if power then
		if mode == 0 then
			set(audio_selection_com1, 1)
			set(audio_selection_com2, 0)
			set(audio_selection_nav1, 0)
			set(audio_selection_nav2, 0)
			set(audio_selection_adf1, 0)
			set(audio_selection_adf2, 0)
			set(audio_dme_enabled, 0)
		elseif mode == 1 then
			set(audio_selection_com1, 0)
			set(audio_selection_com2, 1)
			set(audio_selection_nav1, 0)
			set(audio_selection_nav2, 0)
			set(audio_selection_adf1, 0)
			set(audio_selection_adf2, 0)
			set(audio_dme_enabled, 0)
		elseif mode == 3 and get(ark1_mode) == 2 then
			set(audio_selection_com1, 0)
			set(audio_selection_com2, 0)
			set(audio_selection_nav1, 0)
			set(audio_selection_nav2, 0)
			set(audio_selection_adf1, 1)
			set(audio_selection_adf2, 0)
		elseif mode == 4 and get(ark2_mode) == 2 then
			set(audio_selection_com1, 0)
			set(audio_selection_com2, 0)
			set(audio_selection_nav1, 0)
			set(audio_selection_nav2, 0)
			set(audio_selection_adf1, 0)
			set(audio_selection_adf2, 1)
			set(audio_dme_enabled, 0)
		elseif mode == 5 then
			set(audio_selection_com1, 0)
			set(audio_selection_com2, 0)
			set(audio_selection_nav1, 1)
			set(audio_selection_nav2, 0)
			set(audio_selection_adf1, 0)
			set(audio_selection_adf2, 0)
			set(audio_dme_enabled, 0)			
		elseif mode == 6 then
			set(audio_selection_com1, 0)
			set(audio_selection_com2, 0)
			set(audio_selection_nav1, 0)
			set(audio_selection_nav2, 1)
			set(audio_selection_adf1, 0)
			set(audio_selection_adf2, 0)
			set(audio_dme_enabled, 0)
		elseif mode == 7 then
			set(audio_selection_com1, 0)
			set(audio_selection_com2, 0)
			set(audio_selection_nav1, 0)
			set(audio_selection_nav2, 0)
			set(audio_selection_adf1, 0)
			set(audio_selection_adf2, 0)
			set(audio_dme_enabled, 1)
		else
			set(audio_selection_com1, 0)
			set(audio_selection_com2, 0)
			set(audio_selection_nav1, 0)
			set(audio_selection_nav2, 0)
			set(audio_selection_adf1, 0)
			set(audio_selection_adf2, 0)
			set(audio_dme_enabled, 0)
		end
	else
		set(audio_selection_com1, 0)
		set(audio_selection_com2, 0)
		set(audio_selection_nav1, 0)
		set(audio_selection_nav2, 0)
		set(audio_selection_adf1, 0)
		set(audio_selection_adf2, 0)
		set(audio_dme_enabled, 0)
	end
	


end



components = {
	
	-- mode rotay
	rotary {
        position = { 0, 0, 100, 100},
        value = spu_mode;
        adjuster = function(v)
            if v >= 0 and v <= 7 then playSample(galet_sound, 0) end
			if 0 > v then
                v = 0;
            elseif 7 < v then
                v = 7
            end
			return v
        end;
    },

}
