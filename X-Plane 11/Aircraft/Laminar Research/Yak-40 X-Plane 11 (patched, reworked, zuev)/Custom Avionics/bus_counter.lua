-- this is script for count currents on buses

-- property table
-- sources
defineProperty("DC_27_amp", globalPropertyf("sim/custom/xap/power/DC_27_amp"))
defineProperty("DC_27_source", globalPropertyi("sim/custom/xap/power/DC_27_source"))

defineProperty("AC_36_amp", globalPropertyf("sim/custom/xap/power/AC_36_amp"))
defineProperty("AC_36_source", globalPropertyi("sim/custom/xap/power/AC_36_source"))

defineProperty("AC_115_amp", globalPropertyf("sim/custom/xap/power/AC_115_amp"))
defineProperty("AC_115_source", globalPropertyi("sim/custom/xap/power/AC_115_source"))

-- current consumption from systems and gauges
defineProperty("bat_amp_cc1", globalPropertyf("sim/custom/xap/power/bat_amp_cc1"))  -- if batteries are charging, they take current instead of give it. = 0 when bat is source
defineProperty("bat_amp_cc2", globalPropertyf("sim/custom/xap/power/bat_amp_cc2"))  -- if batteries are charging, they take current instead of give it. = 0 when bat is source
defineProperty("hydr_pump_cc", globalPropertyf("sim/custom/xap/hydro/pump_cc"))  -- if batteries are charging, they take current instead of give it. = 0 when bat is source
defineProperty("flap_cc", globalPropertyf("sim/custom/xap/hydro/flap_cc"))
defineProperty("flap_ind_cc", globalPropertyf("sim/custom/xap/hydro/flap_ind_cc"))
defineProperty("gear_cc", globalPropertyf("sim/custom/xap/hydro/gear_cc"))
defineProperty("agd1_cc", globalPropertyf("sim/custom/xap/gauges/agd_1_cc"))
defineProperty("agd2_cc", globalPropertyf("sim/custom/xap/gauges/agd_2_cc"))
defineProperty("agd3_cc", globalPropertyf("sim/custom/xap/gauges/agd_3_cc"))
defineProperty("rio3_cc", globalPropertyf("sim/custom/xap/antiice/rio3_cc")) -- 
defineProperty("aoa_cc", globalPropertyf("sim/custom/xap/antiice/aoa_cc")) -- 
defineProperty("apu_cc", globalPropertyf("sim/custom/xap/apu/apu_cc")) -- current consumption of APU's starter
defineProperty("ark1_cc", globalPropertyf("sim/custom/xap/ark/ark_1_cc")) -- cc
defineProperty("ark2_cc", globalPropertyf("sim/custom/xap/ark/ark_2_cc")) -- cc
defineProperty("bspk_cc", globalPropertyf("sim/custom/xap/gauges/bspk_cc")) -- cc
defineProperty("com1_cc", globalPropertyf("sim/custom/xap/gauges/com1_cc")) -- cc
defineProperty("com2_cc", globalPropertyf("sim/custom/xap/gauges/com2_cc")) -- cc
defineProperty("da30_1_cc", globalPropertyf("sim/custom/xap/gauges/da30_cc")) -- current consumption
defineProperty("da30_2_cc", globalPropertyf("sim/custom/xap/gauges/da30_2_cc")) -- current consumption
defineProperty("dme_cc", globalPropertyf("sim/custom/xap/gauges/dme_cc")) --cc
defineProperty("efis_cc", globalPropertyf("sim/custom/xap/gauges/efis_cc")) -- cc
defineProperty("emi1_cc", globalPropertyf("sim/custom/xap/gauges/emi1_cc")) -- cc
defineProperty("emi2_cc", globalPropertyf("sim/custom/xap/gauges/emi2_cc")) -- cc
defineProperty("emi3_cc", globalPropertyf("sim/custom/xap/gauges/emi3_cc")) -- cc
defineProperty("fire_cc", globalPropertyf("sim/custom/xap/fire/fire_cc")) -- cc
defineProperty("control_cc", globalPropertyf("sim/custom/xap/control/control_cc")) -- cc
defineProperty("fuel_pump_cc", globalPropertyf("sim/custom/xap/fuel/fuel_pump_cc")) -- cc
defineProperty("fuel_act_cc", globalPropertyf("sim/custom/xap/fuel/fuel_act_cc")) -- cc
defineProperty("GMK_cc", globalPropertyf("sim/custom/xap/gauges/GMK_cc")) -- ÒÒ
defineProperty("iv_cc", globalPropertyf("sim/custom/xap/gauges/iv_cc")) -- cc
defineProperty("kppm1_cc", globalPropertyf("sim/custom/xap/gauges/kppm1_cc")) -- cc
defineProperty("kppm2_cc", globalPropertyf("sim/custom/xap/gauges/kppm2_cc")) -- cc
defineProperty("nav1_cc", globalPropertyf("sim/custom/xap/gauges/nav1_cc")) -- cc
defineProperty("nav2_cc", globalPropertyf("sim/custom/xap/gauges/nav2_cc")) -- cc
defineProperty("rv2_cc", globalPropertyf("sim/custom/xap/gauges/rv_2_cc"))  -- rv work
defineProperty("skv_cc", globalPropertyf("sim/custom/xap/skv/skv_cc")) -- cc
defineProperty("stab_ind_cc", globalPropertyf("sim/custom/xap/gauges/stab_ind_cc")) -- cc
defineProperty("stall_cc", globalPropertyf("sim/custom/xap/gauges/stall_cc")) -- stall cc
defineProperty("sq_cc", globalPropertyf("sim/custom/xap/sq/sq_cc"))
defineProperty("Gmeter_cc", globalPropertyf("sim/custom/xap/gauges/Gmeter_cc")) -- cc
defineProperty("uvid_30_cc", globalPropertyf("sim/custom/xap/gauges/uvid_30_cc")) -- gauge current consumption
defineProperty("uvid_30fk_cc", globalPropertyf("sim/custom/xap/gauges/uvid_30fk_cc")) -- gauge current consumption
defineProperty("hyd_ind_cc", globalPropertyf("sim/custom/xap/hydro/hyd_ind_cc"))
defineProperty("brk_ind_cc", globalPropertyf("sim/custom/xap/hydro/brk_ind_cc"))
defineProperty("brk_abs_cc", globalPropertyf("sim/custom/xap/hydro/brk_abs_cc"))
defineProperty("antiice_cc", globalPropertyf("sim/custom/xap/antiice/antiice_cc")) -- 
defineProperty("nosewheel_cc", globalPropertyf("sim/custom/xap/misc/nosewheel_cc")) -- cc
defineProperty("ladder_cc", globalPropertyf("sim/custom/xap/hydro/ladder_cc")) -- ladder consumption
defineProperty("ap_cc", globalPropertyf("sim/custom/xap/AP/ap_cc")) -- AP current consumption
defineProperty("cockpit_light_cc", globalPropertyf("sim/custom/xap/misc/cockpit_light_cc")) -- light current consumption
defineProperty("nav_light_cc", globalPropertyf("sim/custom/xap/misc/nav_light_cc")) -- light current consumption
defineProperty("bec_light_cc", globalPropertyf("sim/custom/xap/misc/bec_light_cc")) -- light current consumption
defineProperty("lan_light_cc", globalPropertyf("sim/custom/xap/misc/lan_light_cc")) -- light current consumption


-- calculations every frame
function update()
	-- local counters	
	local DC27_amp = 0
	local AC36_amp = 0
	local AC115_amp = 0
	
	
	-- check ground connection for bus 115v
	local ground_115 = 0
	if get(AC_115_source) == 4 then ground_115 = 1 end
	
	-- check if both inverters work on each bus
	local PO_both = 0
	if get(AC_115_source) == 3 then PO_both = 1 end
	
	local PT_both = 0
	if get(AC_36_source) == 4 then PT_both = 1 end

	-- counters --
	
	-- bus 115v counter
	AC115_amp = get(rio3_cc) + get(aoa_cc) + get(ark1_cc) + get(ark2_cc) + get(com1_cc) + get(com2_cc) + get(dme_cc)
	AC115_amp = AC115_amp + get(efis_cc) + get(fuel_act_cc) + get(iv_cc) + get(kppm1_cc) + get(kppm2_cc)
	AC115_amp = AC115_amp + get(nav1_cc) + get(nav2_cc) + get(rv2_cc) + get(skv_cc) + get(sq_cc) + get(Gmeter_cc)
	AC115_amp = AC115_amp + get(uvid_30_cc) + get(uvid_30fk_cc)
	
	-- bus 36v counter
	AC36_amp = get(agd1_cc) + get(agd3_cc) + get(bspk_cc) + get(da30_1_cc) + get(da30_2_cc) + get(emi1_cc) + get(emi2_cc) + get(emi3_cc)
	AC36_amp = AC36_amp + get(GMK_cc) + get(nav1_cc) * 2 + get(nav2_cc) * 2 + get(stab_ind_cc) + get(stall_cc) + get(flap_ind_cc)
	AC36_amp = AC36_amp + get(hyd_ind_cc) + get(brk_ind_cc) + get(ap_cc)
	
	-- bus 27v counter
	DC27_amp = get(bat_amp_cc1) + get(bat_amp_cc2) + AC115_amp * (1 - ground_115) * (5.5 + 0.5 * PO_both) + AC36_amp * (1.8 + 0.2 * PT_both)
	DC27_amp = DC27_amp + get(hydr_pump_cc) + get(flap_cc) + get(agd1_cc) * 0.5 + get(agd3_cc) * 0.5 + get(agd2_cc) * 2
	DC27_amp = DC27_amp + get(apu_cc) + get(fire_cc) + get(control_cc) + get(gear_cc) + get(fuel_pump_cc) + get(brk_abs_cc)
	DC27_amp = DC27_amp + get(antiice_cc) + get(nosewheel_cc) + get(ladder_cc) + get(cockpit_light_cc) + get(nav_light_cc) + get(bec_light_cc) + get(lan_light_cc)
	
	-- set calculated values
	if get(DC_27_source) ~= 0 then set(DC_27_amp, DC27_amp) else set(DC_27_amp, 0) end
	if get(AC_36_source) ~= 0 then set(AC_36_amp, AC36_amp) else set(AC_36_amp, 0) end
	if get(AC_115_source) ~= 0 then set(AC_115_amp, AC115_amp) else set(AC_115_amp, 0) end
	
end
