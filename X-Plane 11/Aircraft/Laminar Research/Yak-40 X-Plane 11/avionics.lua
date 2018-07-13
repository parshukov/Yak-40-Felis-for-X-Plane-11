print("it's Yak-40 by Felis modified by 1941, P.Pranov, R.Guseynov, O.Tronov, N.Parshukov, M.Zuev version 2.5")
size = { 2048, 2048 }

-- 3D panel issue workaround
fixedPanelWidth = 2048
fixedPanelHeight = 2048
function Cdref(drefNameI, drefLocalI)
    defineProperty(drefNameI, createGlobalPropertyf(drefLocalI))
end
Cdref("klnangle",		"KLN90B/custom/angle")
Cdref("navoption",		"PNV/navoption")
Cdref("navoptionchange",		"PNV/navoptionchange")
Cdref("gns430start",		"PNV/GNS430/gns430start")
Cdref("g430finetune",		"PNV/GNS430/finetune")
Cdref("g430coarseupdown",		"PNV/GNS430/coarseupdown")
Cdref("g430pageupdown",		"PNV/GNS430/pageupdown")
Cdref("g430chapterupdown",		"PNV/GNS430/chapterupdown")
Cdref("g430range",		"PNV/GNS430/range")
Cdref("g430onoff",		"PNV/GNS430/onoff")
Cdref("g430ackow",		"PNV/GNS430/g430ackow")
createProp("PNV/GNS430/startlogic", "float", 0)
createProp("PNV/GNS430/darkness", "float", 0)
createProp("sim/custom/kln_power", "int", 0)

set(g430ackow, 0)
set(navoption, 0)
set(navoptionchange, 0)
set(gns430start, 0)
set(g430finetune, 0)
set(g430coarseupdown, 0)
set(g430pageupdown, 0)
set(g430chapterupdown, 0)
set(g430range, 0)
set(g430onoff, 0)

createProp("sim/custom/xap/sim_version", "int", 9); -- sim version

-- create custom data-refs
-- all initial values are for running engines load

-- time --
createProp("sim/custom/xap/time/frame_time", "float", 0.01); -- time between frames


-- test lamps
createProp("sim/custom/xap/buttons/but_test_lamp", "int", 0); -- test lamps buttom. 0 = released, 1 = pressed

-- controls --
createProp("sim/custom/xap/control/light_tride", "int", 0); --
createProp("sim/custom/xap/control/pitch_trim", "float", -2); -- virtual pitch trimmer. in Yak40 have range from -3 to +6 in degrees of stab.
createProp("sim/custom/xap/control/roll_trim", "float", 0); -- virtual roll trimmer
createProp("sim/custom/xap/control/yaw_trim", "float", 0); -- virtual yaw trimmer
createProp("sim/custom/xap/control/control_fix", "int", 0); -- fix controls, so they cannot move. 1 = fixed, 0 = released
createProp("sim/custom/xap/control/pitch_anim", "float", 0);  -- animation of elevator
createProp("sim/custom/xap/control/roll_sw", "int", 0);  -- roll switcher position
createProp("sim/custom/xap/control/yaw_sw", "int", 0);  -- yaw switcher position
createProp("sim/custom/xap/control/pitch_sw", "int", 0);  -- pitch switcher position
createProp("sim/custom/xap/control/control_fix_sw", "int", 0);
createProp("sim/custom/xap/control/control_fix_pow", "int", 0);
createProp("sim/custom/xap/control/control_cc", "float", 0);
-- engines --
createProp("sim/custom/xap/eng/virt_rud1", "float", 0); -- virtual RUD1
createProp("sim/custom/xap/eng/virt_rud2", "float", 0); -- virtual RUD2
createProp("sim/custom/xap/eng/virt_rud3", "float", 0); -- virtual RUD3
createProp("sim/custom/xap/eng/rud_close", "int", 0); -- rud latch. 0 = down and stop active, 1 = up and levers are free to move to STOP position
createProp("sim/custom/xap/eng/red_rud_close", "int", 1); -- red plank. 0 = down and stop active, 1 = up and levers are free to move to STOP position

-- settings --
createProp("sim/custom/xap/set/switch_rud", "int", 0); -- switch or hold rud stopors. 1 = switch, 0 = hold.
createProp("sim/custom/xap/set/three_ruds", "int", 0); -- user have 3 RUDs
createProp("sim/custom/xap/set/nosewheel_command", "int", 0); -- if 1, then user must push button to turn nosewheel
createProp("sim/custom/xap/set/real_ahz", "int", 1);  -- real ahz has errors and needs to be corrected
createProp("sim/custom/xap/set/real_gears", "int", 1);  -- gears can fail to retract or even brake
createProp("sim/custom/xap/set/real_generators", "int", 1);  -- generators can fail if overload
createProp("sim/custom/xap/set/real_startup", "int", 1);  -- when start the engines a lot of thing must to be done
createProp("sim/custom/xap/set/real_nav", "int", 0);  -- for real NAV system with route and landing modes
createProp("sim/custom/xap/set/real_pedals", "int", 0);  -- if you don't have pedals, you use emerg brake as main

-- electrical system --
createProp("sim/custom/xap/power/bat_volt1", "float", 24); -- battery voltage, initial 24V - full charge.
createProp("sim/custom/xap/power/bat_volt2", "float", 24); -- battery voltage, initial 24V - full charge.
createProp("sim/custom/xap/power/bat_amp_bus1", "float", 0); -- battery current, initial 0A. positive - battery load, negative - battery recharge.
createProp("sim/custom/xap/power/bat_amp_bus2", "float", 0); -- battery current, initial 0A. positive - battery load, negative - battery recharge.
createProp("sim/custom/xap/power/bat_on_bus", "int", 1); -- internal battery connector to bus. 0 = OFF, 1 = ON
createProp("sim/custom/xap/power/bat_amp_cc1", "float", 10); -- battery current consumption
createProp("sim/custom/xap/power/bat_amp_cc2", "float", 10); -- battery current consumption
createProp("sim/custom/xap/power/bat1_on", "int", 1); -- internal battery connector to bus. 0 = OFF, 1 = ON
createProp("sim/custom/xap/power/bat2_on", "int", 1); -- internal battery connector to bus. 0 = OFF, 1 = ON

createProp("sim/custom/xap/power/gen1_volt_bus", "float", 28.5); -- generator voltage, initial 28.5v
createProp("sim/custom/xap/power/gen2_volt_bus", "float", 28.5); -- generator voltage, initial 28.5v
createProp("sim/custom/xap/power/gen3_volt_bus", "float", 28.5); -- generator voltage, initial 28.5v

createProp("sim/custom/xap/power/gen1_amp_bus", "float", 0); -- generator current load from bus, initial 0A
createProp("sim/custom/xap/power/gen2_amp_bus", "float", 0); -- generator current load from bus, initial 0A
createProp("sim/custom/xap/power/gen3_amp_bus", "float", 0); -- generator current load from bus, initial 0A

createProp("sim/custom/xap/power/gen1_on_bus", "int", 1); -- generator current load from bus, initial 0A
createProp("sim/custom/xap/power/gen2_on_bus", "int", 1); -- generator current load from bus, initial 0A
createProp("sim/custom/xap/power/gen3_on_bus", "int", 1); -- generator current load from bus, initial 0A

createProp("sim/custom/xap/power/inv_PT1000", "int", 1); -- inverter for 36v bus
createProp("sim/custom/xap/power/inv_PT500", "int", 1); -- inverter for 36v bus
createProp("sim/custom/xap/power/inv_PT1000_emerg", "int", 0); -- emergency connect one inv to working. 0 = auto, 1 = manual

createProp("sim/custom/xap/power/inv_PO1500_radio", "int", 1); -- inverter for 115v bus
createProp("sim/custom/xap/power/inv_PO1500_steklo", "int", 1); -- inverter for 115v bus
createProp("sim/custom/xap/power/inv_PO1500_emerg", "int", 0); -- emergency connect one inv to working. 0 = auto, 1 = manual
createProp("sim/custom/xap/power/inv_PO1500_emerg2", "int", 0); -- emergency connect one inv to working. 0 = auto, 1 = manual

createProp("sim/custom/xap/power/gen1_amp_bus", "float", 0); -- generator current load from bus, initial 0A
createProp("sim/custom/xap/power/gen2_amp_bus", "float", 0); -- generator current load from bus, initial 0A
createProp("sim/custom/xap/power/gen3_amp_bus", "float", 0); -- generator current load from bus, initial 0A

createProp("sim/custom/xap/power/ground_available", "int", 0); -- if there is ground power, this var = 1
createProp("sim/custom/xap/power/power_mode", "int", 2); -- power mode: 0 = Ground, 1 = off, 2 = airplane

createProp("sim/custom/xap/power/DC_27_volt", "float", 27); -- voltage on bus 27v
createProp("sim/custom/xap/power/DC_27_amp", "float", 0); -- current on bus 27v
createProp("sim/custom/xap/power/DC_27_source", "int", 3); -- source for bus 27v

createProp("sim/custom/xap/power/AC_36_volt", "float", 36); -- voltage on bus 36v
createProp("sim/custom/xap/power/AC_36_amp", "float", 0); -- current on bus 36v
createProp("sim/custom/xap/power/AC_36_source", "int", 3); -- source for bus 36v

createProp("sim/custom/xap/power/AC_115_volt", "float", 115); -- voltage on bus 115v
createProp("sim/custom/xap/power/AC_115_amp", "float", 0); -- current on bus 115v
createProp("sim/custom/xap/power/AC_115_source", "int", 3); -- source for bus 115v

createProp("sim/custom/xap/power/POsteklo_sw", "int", 1); -- inverter for 115v bus
createProp("sim/custom/xap/power/POradio_sw", "int", 1); -- inverter for 115v bus
createProp("sim/custom/xap/power/POsteklo_emerg_sw", "int", 0); -- emergency connect inv for 115v bus
createProp("sim/custom/xap/power/POradio_emerg_sw", "int", 0); -- emergency connect inv for 115v bus

createProp("sim/custom/xap/power/PT1000_sw", "int", 1); -- inverter for 36v bus
createProp("sim/custom/xap/power/PT500_sw", "int", 1); -- inverter for 36v bus
createProp("sim/custom/xap/power/PT_emerg_sw", "int", 0); -- emergency connect inv for 36v bus

createProp("sim/custom/xap/power/PT_emerg_sw_cap", "int", 0); -- emergency connect inv for 36v bus cap
createProp("sim/custom/xap/power/POsteklo_emerg_sw_cap", "int", 0); -- emergency connect inv for 115v bus cap
createProp("sim/custom/xap/power/POradio_emerg_sw_cap", "int", 0); -- emergency connect inv for 115v bus cap

createProp("sim/custom/xap/power/ind_27v_mode", "int", 5); -- mode for 27v voltmeter
createProp("sim/custom/xap/power/ind_36v_mode", "int", 0); -- mode for 36v voltmeter
createProp("sim/custom/xap/power/ind_115v_mode", "int", 1); -- mode for 115v voltmeter

createProp("sim/custom/xap/power/ind_gen1_amp_angle", "float", 0); -- gen1 angle
createProp("sim/custom/xap/power/ind_gen2_amp_angle", "float", 0); -- gen1 angle
createProp("sim/custom/xap/power/ind_gen3_amp_angle", "float", 0); -- gen1 angle

createProp("sim/custom/xap/power/ind_bus27_volt_angle", "float", 0); -- bus 27 voltmeter angle
createProp("sim/custom/xap/power/ind_bus27_amp_angle", "float", 0); -- bus 27 voltmeter angle
createProp("sim/custom/xap/power/ind_bus36_volt_angle", "float", 0); -- bus 36 voltmeter angle
createProp("sim/custom/xap/power/ind_bus115_volt_angle", "float", 0); -- bus 115 voltmeter angle

createProp("sim/custom/xap/power/gen1_fail_lit", "int", 0); -- lamp
createProp("sim/custom/xap/power/gen2_fail_lit", "int", 0); -- lamp
createProp("sim/custom/xap/power/gen3_fail_lit", "int", 0); -- lamp
createProp("sim/custom/xap/power/PT500_fail_lit", "int", 0); -- lamp
createProp("sim/custom/xap/power/PO_fail_lit", "int", 0); -- lamp


-- hydraulic system
createProp("sim/custom/xap/hydro/main_press", "float", 120); -- pressure in main system. initial 120 kg per square sm. maximum 160.
createProp("sim/custom/xap/hydro/emerg_press", "float", 120); -- pressure in emergency system. initial 120 kg per square sm. maximum 160.
createProp("sim/custom/xap/hydro/hydro_quantity", "float", 1); -- quantity of hydraulic liquid. initially 28 liters. in work downs to 21 liters. also can flow out in come case of failure.
createProp("sim/custom/xap/hydro/emerg_brake", "float", 0); -- pressure in braking system
createProp("sim/custom/xap/hydro/brake_press", "float", 0); -- pressure in braking system

createProp("sim/custom/xap/hydro/emerg_pump_sw", "int", 1); -- emergency hydro pump switcher. if its ON and power exist - emergency bus will gain pressure
createProp("sim/custom/xap/hydro/emerg_pump_sw_cap", "int", 0); -- emergency hydro pump switcher. if its ON and power exist - emergency bus will gain pressure
createProp("sim/custom/xap/hydro/frontgear_use_hydro", "int", 1); -- front gear steering manipulates by hydraulic system
createProp("sim/custom/xap/hydro/gear_valve", "int", 0); -- position of gear valve for gydraulic calculations and animations
createProp("sim/custom/xap/hydro/gear_valve_emerg", "int", 0); -- position of gear valve for gydraulic calculations and animations
createProp("sim/custom/xap/hydro/gear_valve_emerg_cap", "int", 0); -- position of gear valve cap for gydraulic calculations and animations
createProp("sim/custom/xap/hydro/flaps_valve", "int", 0); -- position of flaps valve for gydraulic calculations and animations.
createProp("sim/custom/xap/hydro/flaps_valve_cap", "int", 0); -- position of flaps valve for gydraulic calculations and animations.
createProp("sim/custom/xap/hydro/flaps_valve_emerg", "int", 0); -- position of emergency flaps valve for gydraulic calculations and animations.
createProp("sim/custom/xap/hydro/flaps_valve_emerg_cap", "int", 0); -- position of emergency flaps valve for gydraulic calculations and animations.
createProp("sim/custom/xap/hydro/abs_sw", "int", 1); -- abs switcher

createProp("sim/custom/xap/hydro/pump_cc", "float", 0); -- emergency pump current consumption
createProp("sim/custom/xap/hydro/flap_cc", "float", 0); -- flaps current consumption
createProp("sim/custom/xap/hydro/gear_cc", "float", 0); -- gears current consumption
createProp("sim/custom/xap/hydro/flap_ind_cc", "float", 0); -- flaps current consumption
createProp("sim/custom/xap/hydro/hyd_ind_cc", "float", 0); -- hydro current consumption
createProp("sim/custom/xap/hydro/brk_ind_cc", "float", 0); -- brake current consumption
createProp("sim/custom/xap/hydro/brk_abs_cc", "float", 0); -- brake current consumption
createProp("sim/custom/xap/hydro/ladder_cc", "float", 0); -- ladder current consumption

createProp("sim/custom/xap/hydro/ind_main_press_angle", "float", 0); -- main pressure
createProp("sim/custom/xap/hydro/ind_emerg_press_angle", "float", 0); -- emerg pressure
createProp("sim/custom/xap/hydro/ind_left_brake_angle", "float", 0); -- pressure for left brake
createProp("sim/custom/xap/hydro/ind_right_brake_angle", "float", 0); -- pressure for right brake
createProp("sim/custom/xap/hydro/ind_left_em_brake_angle", "float", 0); -- pressure for left brake
createProp("sim/custom/xap/hydro/ind_right_em_brake_angle", "float", 0); -- pressure for right brake
createProp("sim/custom/xap/hydro/ind_flap_angle", "float", 0); -- angle for flap indicator
createProp("sim/custom/xap/hydro/ind_stab_angle", "float", 0); -- angle for stab indicator

createProp("sim/custom/xap/hydro/qty_low_lit", "int", 0); -- lamp for low quantity
createProp("sim/custom/xap/hydro/qty_norm_lit", "int", 0); -- lamp for normal quantity
createProp("sim/custom/xap/hydro/press_low_lit", "int", 0); -- lamp for low pressure in emerg system
createProp("sim/custom/xap/hydro/left_brake_lit", "int", 0); -- indicator of left ABS
createProp("sim/custom/xap/hydro/right_brake_lit", "int", 0); -- indicator of right ABS

-- AZS --
createProp("sim/custom/xap/azs/AZS_msrp_power", "int", 0); -- AZS for msrp power
createProp("sim/custom/xap/azs/AZS_msrp_on", "int", 0); -- AZS for msrp on
---------------------------------------------------------------------------------------------------------
createProp("sim/custom/xap/azs/AZS_36v_emerg_sw", "int", 1); -- AZS for emergency connect inv for 36v bus
createProp("sim/custom/xap/azs/AZS_115v_emerg_sw", "int", 1); -- AZS for emergency connect inv-s for 115v bus
createProp("sim/custom/xap/azs/AZS_POsteklo_sw", "int", 1); -- AZS for inverter for 115v bus
createProp("sim/custom/xap/azs/AZS_POradio_sw", "int", 1); -- AZS for inverter for 115v bus
createProp("sim/custom/xap/azs/test_lamps_sw", "int", 1); -- AZS for inverter for 115v bus
createProp("sim/custom/xap/azs/AZS_hydrosys_sw", "int", 1); -- AZS for hydraulic system
createProp("sim/custom/xap/azs/AZS_brakes_sw", "int", 1); -- AZS for braking system
createProp("sim/custom/xap/azs/AZS_flaps_main_sw", "int", 1); -- AZS main flaps system
createProp("sim/custom/xap/azs/AZS_flaps_emerg_sw", "int", 1); -- AZS emerg flaps system
createProp("sim/custom/xap/azs/AZS_gears_main_sw", "int", 1); -- AZS main gear system
createProp("sim/custom/xap/azs/AZS_gears_emerg_sw", "int", 1); -- AZS emerg gear system
createProp("sim/custom/xap/azs/AZS_stab_main_sw", "int", 1); -- AZS main stab system
createProp("sim/custom/xap/azs/AZS_stab_emerg_sw", "int", 1); -- AZS stab gear system
createProp("sim/custom/xap/azs/AZS_aileron_trim_sw", "int", 1); -- AZS aileron trimm system
createProp("sim/custom/xap/azs/AZS_rudder_trim_sw", "int", 1); -- AZS rudder trimm system
createProp("sim/custom/xap/azs/AZS_da30_sw", "int", 1); -- AZS for DA30 gauge
createProp("sim/custom/xap/azs/AZS_agd_1_sw", "int", 1); -- AZS for AGD gauge
createProp("sim/custom/xap/azs/AZS_agd_2_sw", "int", 1); -- AZS for AGD gauge
createProp("sim/custom/xap/azs/AZS_agd_3_sw", "int", 1); -- AZS for AGD gauge
createProp("sim/custom/xap/azs/AZS_bspk_sw", "int", 1); -- AZS for BSPK system
createProp("sim/custom/xap/azs/AZS_eng_gau_1_sw", "int", 1); -- AZS for engine gauges
createProp("sim/custom/xap/azs/AZS_eng_gau_2_sw", "int", 1); -- AZS for engine gauges
createProp("sim/custom/xap/azs/AZS_eng_gau_3_sw", "int", 1); -- AZS for engine gauges
createProp("sim/custom/xap/azs/AZS_fire_valve1_sw", "int", 1); -- fire valve switcher on AZS
createProp("sim/custom/xap/azs/AZS_fire_valve2_sw", "int", 1); -- fire valve switcher on AZS
createProp("sim/custom/xap/azs/AZS_fire_valve3_sw", "int", 1); -- fire valve switcher on AZS
createProp("sim/custom/xap/azs/AZS_join_valve_sw", "int", 1); -- join valve switcher on AZS
createProp("sim/custom/xap/azs/AZS_circle_valve_sw", "int", 1); -- circle valve switcher on AZS
createProp("sim/custom/xap/azs/AZS_fuel_meter_sw", "int", 1); -- fuel meter switcher on AZS
createProp("sim/custom/xap/azs/AZS_start_apu_sw", "int", 1); -- AZS for start APU
createProp("sim/custom/xap/azs/AZS_ignition1_sw", "int", 1); -- AZS for engine ignition
createProp("sim/custom/xap/azs/AZS_ignition2_sw", "int", 1); -- AZS for engine ignition
createProp("sim/custom/xap/azs/AZS_ignition3_sw", "int", 1); -- AZS for engine ignition
createProp("sim/custom/xap/azs/AZS_GMK_sw", "int", 1); -- AZS for GMK
createProp("sim/custom/xap/azs/AZS_ARK_1_sw", "int", 1); -- AZS for ARK
createProp("sim/custom/xap/azs/AZS_ARK_2_sw", "int", 1); -- AZS for ARK
createProp("sim/custom/xap/azs/AZS_KursMP_sw", "int", 1); -- AZS nav complex
createProp("sim/custom/xap/azs/AZS_COM_1_sw", "int", 1); -- AZS for COM
createProp("sim/custom/xap/azs/AZS_COM_2_sw", "int", 1); -- AZS for COM
createProp("sim/custom/xap/azs/AZS_transp_sw", "int", 1); -- AZS for transponder
createProp("sim/custom/xap/azs/AZS_DME_sw", "int", 1); -- AZS for DME
createProp("sim/custom/xap/azs/AZS_ADP_sw", "int", 1); -- AZS for G-forse meter
createProp("sim/custom/xap/azs/AZS_ladder_sw", "int", 1); -- AZS for ladder control
createProp("sim/custom/xap/azs/AZS_nosewheel_sw", "int", 1); -- AZS for nosewheel control
createProp("sim/custom/xap/azs/AZS_POS_sw", "int", 1); -- AZS for antiice system
createProp("sim/custom/xap/azs/AZS_eng1_heat_sw", "int", 1); -- AZS for antiice system
createProp("sim/custom/xap/azs/AZS_eng2_heat_sw", "int", 1); -- AZS for antiice system
createProp("sim/custom/xap/azs/AZS_eng3_heat_sw", "int", 1); -- AZS for antiice system
createProp("sim/custom/xap/azs/AZS_fire_signal1_sw", "int", 1); -- AZS for fire signal in engine 1
createProp("sim/custom/xap/azs/AZS_fire_signal2_sw", "int", 1); -- AZS for fire signal in engine 2
createProp("sim/custom/xap/azs/AZS_fire_signal3_sw", "int", 1); -- AZS for fire signal in engine 3
createProp("sim/custom/xap/azs/AZS_fire_ext1_sw", "int", 1); -- AZS for fire extinguisher in engine 1
createProp("sim/custom/xap/azs/AZS_fire_ext2_sw", "int", 1); -- AZS for fire extinguisher in engine 2
createProp("sim/custom/xap/azs/AZS_fire_ext3_sw", "int", 1); -- AZS for fire extinguisher in engine 3
createProp("sim/custom/xap/azs/AZS_fire_ext_valve1_sw", "int", 1); -- AZS for fire extinguisher valve in engine 1
createProp("sim/custom/xap/azs/AZS_fire_ext_valve2_sw", "int", 1); -- AZS for fire extinguisher valve in engine 2
createProp("sim/custom/xap/azs/AZS_fire_ext_valve3_sw", "int", 1); -- AZS for fire extinguisher valve in engine 3
createProp("sim/custom/xap/azs/AZS_skv_cool_sw", "int", 1); -- AZS cooling air
createProp("sim/custom/xap/azs/AZS_skv_heat_sw", "int", 1); -- AZS heating air
createProp("sim/custom/xap/azs/AZS_skv_THU_sw", "int", 1); -- AZS turbo cooler air
createProp("sim/custom/xap/azs/AZS_lan1_sw", "int", 1); -- AZS landing light left
createProp("sim/custom/xap/azs/AZS_lan2_sw", "int", 1); -- AZS landing light right
createProp("sim/custom/xap/azs/AZS_taxi1_sw", "int", 1); -- AZS taxi light left
createProp("sim/custom/xap/azs/AZS_taxi2_sw", "int", 1); -- AZS taxi light right

createProp("sim/custom/xap/azs/AZS_sign_stall_sw", "int", 1); -- AZS for stall signal
createProp("sim/custom/xap/azs/AZS_sign_start_sw", "int", 1); -- AZS for start signal
createProp("sim/custom/xap/azs/AZS_sign_gear_sw", "int", 1); -- AZS for gears signal
createProp("sim/custom/xap/azs/AZS_AP_sw", "int", 1); -- AZS for AutoPilot
createProp("sim/custom/xap/azs/AZS_sign_gear2_sw", "int", 1); -- AZS for gears signal
createProp("sim/custom/xap/azs/AZS_rockets_sw", "int", 1); -- AZS for rockets
createProp("sim/custom/xap/azs/AZS_radio2_sw", "int", 1); -- AZS for PO Radio manual
createProp("sim/custom/xap/azs/AZS_join_sw", "int", 1); -- AZS for join

-- gauges
createProp("sim/custom/xap/gauges/da30_cc", "float", 0); -- turn indicator current consumption
createProp("sim/custom/xap/gauges/da30_2_cc", "float", 0); -- turn indicator current consumption
createProp("sim/custom/xap/gauges/rv_2_sw", "int", 1); -- radio altimeter switcher
createProp("sim/custom/xap/gauges/rv_2_cc", "float", 0); -- radio alt cc
createProp("sim/custom/xap/gauges/uvid_30_sw", "int", 1); -- altimeter switcher
createProp("sim/custom/xap/gauges/uvid_30_cc", "float", 0); -- altimeter cc
createProp("sim/custom/xap/gauges/vd10ft_press", "float", 29.92); -- altimeter pressure
createProp("sim/custom/xap/gauges/uvid30fk_press", "float", 29.92); -- altimeter pressure
createProp("sim/custom/xap/gauges/uvid_30fk_sw", "int", 1); -- altimeter switcher
createProp("sim/custom/xap/gauges/uvid_30fk_cc", "float", 0); -- altimeter cc

createProp("sim/custom/xap/gauges/agd_1_sw", "int", 1); -- agd switcher
createProp("sim/custom/xap/gauges/agd_1_cc", "float", 0); -- agd cc
createProp("sim/custom/xap/gauges/roll_1", "float", 0); -- agd roll
createProp("sim/custom/xap/gauges/pitch_1", "float", 0); -- agd roll
createProp("sim/custom/xap/gauges/agd_2_sw", "int", 1); -- agd switcher
createProp("sim/custom/xap/gauges/agd_2_cc", "float", 0); -- agd cc
createProp("sim/custom/xap/gauges/roll_2", "float", 0); -- agd roll
createProp("sim/custom/xap/gauges/pitch_2", "float", 0); -- agd roll
createProp("sim/custom/xap/gauges/agd_3_sw", "int", 1); -- agd switcher
createProp("sim/custom/xap/gauges/agd_3_cc", "float", 0); -- agd cc
createProp("sim/custom/xap/gauges/roll_3", "float", 0); -- agd roll
createProp("sim/custom/xap/gauges/pitch_3", "float", 0); -- agd roll

createProp("sim/custom/xap/gauges/gyro_curse1", "float", 0); -- course of gyroscope
createProp("sim/custom/xap/gauges/gyro_curse2", "float", 0); -- course of gyroscope

createProp("sim/custom/xap/gauges/gyro_mode", "int", 0); -- 0 = MK, 1 = GPK, 2 = AK
createProp("sim/custom/xap/gauges/gyro_correct", "float", 0); -- correction of magnetic course
createProp("sim/custom/xap/gauges/GMK_curse1", "float", 0); -- course of GMK
createProp("sim/custom/xap/gauges/GMK_curse2", "float", 0); -- course of GMK
createProp("sim/custom/xap/gauges/GMK_curse", "float", 0); -- result course of GMK
createProp("sim/custom/xap/gauges/GMK_north", "int", 1); -- switcher North/South
createProp("sim/custom/xap/gauges/GMK_lat", "float", 40); -- rotary for set latitude
createProp("sim/custom/xap/gauges/GMK_lat_rot", "float", 186.41); -- rotary for animation, deg
createProp("sim/custom/xap/gauges/GMK_select", "int", 0); -- switcher to select working devide
createProp("sim/custom/xap/gauges/GMK_man_corr", "int", 0); -- manual corrector switch
createProp("sim/custom/xap/gauges/GMK_check", "int", 0); -- check GMK 0 - 300
createProp("sim/custom/xap/gauges/GMK_cc", "float", 0); -- cc
createProp("sim/custom/xap/gauges/GMK_curse_ap", "float", 0); -- calculated course for AP

createProp("sim/custom/xap/gauges/curs_1", "float", 0); -- course plank
createProp("sim/custom/xap/gauges/glide_1", "float", 0); -- glide plank
createProp("sim/custom/xap/gauges/k1_flag", "int", 1); -- course flag
createProp("sim/custom/xap/gauges/g1_flag", "int", 1); -- glide plank
createProp("sim/custom/xap/gauges/vor_1", "float", 1); -- vor bearing
createProp("sim/custom/xap/gauges/nav1_power", "int", 1); -- power switch
createProp("sim/custom/xap/gauges/nav1_button", "int", 0); -- test buttons. 0 = none
createProp("sim/custom/xap/gauges/nav1_tofrom", "int", 0); -- to-from lamps. 0 = none, 1 = to, 2 = from


createProp("sim/custom/xap/gauges/curs_2", "float", 0); -- course plank
createProp("sim/custom/xap/gauges/glide_2", "float", 0); -- glide plank
createProp("sim/custom/xap/gauges/k2_flag", "int", 1); -- course flag
createProp("sim/custom/xap/gauges/g2_flag", "int", 1); -- glide plank
createProp("sim/custom/xap/gauges/vor_2", "float", 1); -- vor bearing
createProp("sim/custom/xap/gauges/nav2_power", "int", 1); -- power switch
createProp("sim/custom/xap/gauges/nav2_button", "int", 0); -- test buttons. 0 = none
createProp("sim/custom/xap/gauges/nav2_tofrom", "int", 0); -- to-from lamps. 0 = none, 1 = to, 2 = from

createProp("sim/custom/xap/gauges/kp_route", "int", 0); -- switcher route-landing. 0 = landing, 1 = route
createProp("sim/custom/xap/gauges/kp_mode", "int", 0); -- ILS or SP-50 mode. 0 = ILS, 1 = SP-50

createProp("sim/custom/xap/gauges/ark_ind1_knob1", "int", 0); -- knobs on ark/vor indicator
createProp("sim/custom/xap/gauges/ark_ind1_knob2", "int", 1); -- knobs on ark/vor indicator
createProp("sim/custom/xap/gauges/ark_ind2_knob1", "int", 0); -- knobs on ark/vor indicator
createProp("sim/custom/xap/gauges/ark_ind2_knob2", "int", 1); -- knobs on ark/vor indicator

createProp("sim/custom/xap/gauges/dme_power_sw", "int", 1); -- power switcher for DME
createProp("sim/custom/xap/gauges/dme_mode_sw", "int", 1); -- mode switcher for DME, 0 = km, 1 = miles
createProp("sim/custom/xap/gauges/spu_mode", "int", 0); -- SPU mode switcher
createProp("sim/custom/xap/gauges/iv_sw", "int", 1); -- IV power switcher
createProp("sim/custom/xap/gauges/iv_test", "int", 0); -- IV test button
createProp("sim/custom/xap/gauges/iv_mode", "int", 0); -- IV mode switcher
createProp("sim/custom/xap/gauges/kontur_power", "int", 1); -- kontur power
createProp("sim/custom/xap/gauges/kontur_brt", "float", 1); -- kontur brightness
createProp("sim/custom/xap/gauges/radioalt", "float", 1); -- altitude from RV

createProp("sim/custom/xap/gauges/siren_button", "int", 0); -- button for temporary OFF sirene
createProp("sim/custom/xap/gauges/bspk_siren", "int", 0); -- BSPK signal
createProp("sim/custom/xap/gauges/srd_siren", "int", 0); -- SRD signal
createProp("sim/custom/xap/gauges/srd_siren_sw", "int", 1); -- SRD signal switch
createProp("sim/custom/xap/gauges/stall_siren", "int", 0); -- stall signal
createProp("sim/custom/xap/gauges/fire_siren", "int", 0); -- fire signal
createProp("sim/custom/xap/gauges/fire_siren_sw", "int", 1); -- fire signal switch
createProp("sim/custom/xap/gauges/flaps_siren", "int", 0); -- flaps signal
createProp("sim/custom/xap/gauges/gear_siren", "int", 0); -- gear signal
createProp("sim/custom/xap/gauges/gear_siren_sw", "int", 1); -- gear signal switcher
createProp("sim/custom/xap/gauges/gear_siren_cap", "int", 0); -- gear signal switcher

createProp("sim/custom/xap/gauges/flaps_lamp_lit", "int", 0); -- flaps signal
createProp("sim/custom/xap/gauges/gear_lamp_lit", "int", 0); -- gear signal

createProp("sim/custom/xap/gauges/bspk_cc", "float", 0); -- bspk cc
createProp("sim/custom/xap/gauges/bspk_err", "int", 0); -- bspk error
createProp("sim/custom/xap/gauges/com1_cc", "float", 0); -- com cc
createProp("sim/custom/xap/gauges/com2_cc", "float", 0); -- com cc
createProp("sim/custom/xap/gauges/dme_cc", "float", 0); -- dme cc
createProp("sim/custom/xap/gauges/efis_cc", "float", 0); -- efis cc
createProp("sim/custom/xap/gauges/emi1_cc", "float", 0); -- emi cc
createProp("sim/custom/xap/gauges/emi2_cc", "float", 0); -- emi cc
createProp("sim/custom/xap/gauges/emi3_cc", "float", 0); -- emi cc
createProp("sim/custom/xap/gauges/iv_cc", "float", 0); -- iv cc
createProp("sim/custom/xap/gauges/kppm1_cc", "float", 0); -- kppm cc
createProp("sim/custom/xap/gauges/kppm1_cc", "float", 0); -- kppm cc
createProp("sim/custom/xap/gauges/nav1_cc", "float", 0); -- nav set cc
createProp("sim/custom/xap/gauges/nav2_cc", "float", 0); -- nav set cc
createProp("sim/custom/xap/gauges/stab_ind_cc", "float", 0); -- stab ind cc
createProp("sim/custom/xap/gauges/stall_cc", "float", 0); -- stall cc
createProp("sim/custom/xap/gauges/Gmeter_cc", "float", 0); -- G-meter cc
createProp("sim/custom/xap/gauges/rv_2_cc", "float", 0); --rv work



-- fuel
createProp("sim/custom/xap/fuel/act_sw", "int", 1); -- center fuel automat switcher
createProp("sim/custom/xap/fuel/act_test_lamp", "int", 1);-- center fuel automat control lamp-------------pilot40
createProp("sim/custom/xap/fuel/fuel_pump1_sw", "int", 1); -- fuel pump switcher
createProp("sim/custom/xap/fuel/fuel_pump2_sw", "int", 1); -- fuel pump switcher
createProp("sim/custom/xap/fuel/fuel_pump2_emerg_sw", "int", 0); -- fuel pump switcher
createProp("sim/custom/xap/fuel/fuel_pump2_emerg_sw_cap", "int", 0); -- fuel pump switcher cap
createProp("sim/custom/xap/fuel/fuel_pump_mode_sw", "int", 0); -- which pump work softer
createProp("sim/custom/xap/fuel/join_valve_sw", "int", 0); -- join valve switcher
createProp("sim/custom/xap/fuel/join_valve_sw_cap", "int", 0); -- join valve switcher cap
createProp("sim/custom/xap/fuel/circle_valve_sw", "int", 0); -- circle valve switcher
createProp("sim/custom/xap/fuel/circle_valve_sw_cap", "int", 0); -- circle valve switcher cap
createProp("sim/custom/xap/fuel/fire_valve1_sw", "int", 1); -- fire valve switcher on overhead
createProp("sim/custom/xap/fuel/fire_valve2_sw", "int", 1); -- fire valve switcher on overhead
createProp("sim/custom/xap/fuel/fire_valve3_sw", "int", 1); -- fire valve switcher on overhead
createProp("sim/custom/xap/fuel/fire_valve1_sw_cap", "int", 0); -- fire valve switcher on overhead cap
createProp("sim/custom/xap/fuel/fire_valve2_sw_cap", "int", 0); -- fire valve switcher on overhead cap
createProp("sim/custom/xap/fuel/fire_valve3_sw_cap", "int", 0); -- fire valve switcher on overhead cap
createProp("sim/custom/xap/fuel/fire_valve_apu_sw", "int", 0); -- fire valve switcher for apu
createProp("sim/custom/xap/fuel/fire_valve1", "float", 1); -- fire valve position
createProp("sim/custom/xap/fuel/fire_valve2", "float", 1); -- fire valve position
createProp("sim/custom/xap/fuel/fire_valve3", "float", 1); -- fire valve position
createProp("sim/custom/xap/fuel/fire_valve_apu", "float", 0); -- fire valve position
createProp("sim/custom/xap/fuel/fuel_pump1_work", "int", 1); -- fuel pump working
createProp("sim/custom/xap/fuel/fuel_pump2_work", "int", 1); -- fuel pump working
createProp("sim/custom/xap/fuel/eng1_fuel_access", "int", 1); -- engine 1 can use fuel
createProp("sim/custom/xap/fuel/eng2_fuel_access", "int", 1); -- engine 2 can use fuel
createProp("sim/custom/xap/fuel/eng3_fuel_access", "int", 1); -- engine 3 can use fuel
createProp("sim/custom/xap/fuel/apu_fuel_access", "int", 0); -- APU can use fuel
createProp("sim/custom/xap/fuel/circle_fuel_access", "int", 0); -- circle valve is open
createProp("sim/custom/xap/fuel/join_fuel_access", "int", 0);-- join valve is open
createProp("sim/custom/xap/fuel/act_test_but", "int", 0);-- test of ACT
createProp("sim/custom/xap/fuel/fuel_meter_mode", "int", 0);-- fuel_meter mode switcher
createProp("sim/custom/xap/fuel/fuel_min_but", "int", 0);--  minimum button
createProp("sim/custom/xap/fuel/fuel_max_but", "int", 0);-- maximum button
createProp("sim/custom/xap/fuel/fuel_dump1", "int", 0);-- fuel dump left
createProp("sim/custom/xap/fuel/fuel_dump2", "int", 0);-- fuel dump right
createProp("sim/custom/xap/fuel/fuel_dump_cap", "int", 0);-- fuel dump right
createProp("sim/custom/xap/fuel/fuel_dump1_lit", "int", 0);-- fuel dump left
createProp("sim/custom/xap/fuel/fuel_dump2_lit", "int", 0);-- fuel dump right
createProp("sim/custom/xap/fuel/fuel_pump_cc", "float", 0);-- fuel pump CC
createProp("sim/custom/xap/fuel/fuel_act_cc", "float", 0);-- fuel pump CC

-- APU
createProp("sim/custom/xap/apu/starter_sw", "int", 0);-- starter switch
createProp("sim/custom/xap/apu/starter_mode", "int", 0);-- starter mode. start, cold rotate, stopping
createProp("sim/custom/xap/apu/start_button", "int", 0);-- start button pressed
createProp("sim/custom/xap/apu/stop_button", "int", 0);-- stop button pressed
createProp("sim/custom/xap/apu/apu_egt", "float", 0);-- EGT for APU
createProp("sim/custom/xap/apu/apu_cc", "float", 0);-- current consumption of APU's starter
createProp("sim/custom/xap/apu/apu_can_start", "int", 0);-- APU can start other engines
createProp("sim/custom/xap/apu/apu_fire_ext", "int", 0);-- fire extinguisher for APU
createProp("sim/custom/xap/apu/apu_on_fire", "int", 0);-- APU is on fire

-- start
createProp("sim/custom/xap/start/fuel_start1", "int", 1);-- fuel valves
createProp("sim/custom/xap/start/fuel_start2", "int", 1);-- fuel valves
createProp("sim/custom/xap/start/fuel_start3", "int", 1);-- fuel valves

createProp("sim/custom/xap/start/air_start1", "int", 0);-- air start button
createProp("sim/custom/xap/start/air_start2", "int", 0);-- air start button
createProp("sim/custom/xap/start/air_start3", "int", 0);-- air start button

createProp("sim/custom/xap/start/air_start1_cap", "int", 0);-- air start button
createProp("sim/custom/xap/start/air_start2_cap", "int", 0);-- air start button
createProp("sim/custom/xap/start/air_start3_cap", "int", 0);-- air start button

createProp("sim/custom/xap/start/start_sw", "int", 0);-- starter switcher
createProp("sim/custom/xap/start/start_mode_sw", "int", 0);-- start mode switcher
createProp("sim/custom/xap/start/eng_select_sw", "int", 0);-- engine selector switcher
createProp("sim/custom/xap/start/start_but", "int", 0);-- start button
createProp("sim/custom/xap/start/stop_but", "int", 0);-- stop button
createProp("sim/custom/xap/start/starter_work_lit", "int", 0);-- starter lamp
createProp("sim/custom/xap/start/starter_press", "float", 0);-- pressure in start system

createProp("sim/custom/xap/start/emerg_stop1", "int", 0);-- stop button
createProp("sim/custom/xap/start/emerg_stop2", "int", 0);-- stop button
createProp("sim/custom/xap/start/emerg_stop3", "int", 0);-- stop button

createProp("sim/custom/xap/start/emerg_stop1_cap", "int", 0);-- stop button cap
createProp("sim/custom/xap/start/emerg_stop2_cap", "int", 0);-- stop button cap
createProp("sim/custom/xap/start/emerg_stop3_cap", "int", 0);-- stop button cap

-- ARK
createProp("sim/custom/xap/ark/ark_1_mode", "int", 1);-- ARK mode
createProp("sim/custom/xap/ark/ark_1_ant_sw", "int", 0);-- antenna switch to rotate ram
createProp("sim/custom/xap/ark/ark_1_left_1", "float", 0);-- left disk for set 0-9 kHz
createProp("sim/custom/xap/ark/ark_1_left_10", "float", 0);-- left disk for set 00-90 kHz
createProp("sim/custom/xap/ark/ark_1_left_100", "float", 0);-- left disk for set 100-1200 kHz
createProp("sim/custom/xap/ark/ark_1_right_1", "float", 0);-- right disk for set 0-9 kHz
createProp("sim/custom/xap/ark/ark_1_right_10", "float", 0);-- right disk for set 00-90 kHz
createProp("sim/custom/xap/ark/ark_1_right_100", "float", 0);-- right disk for set 100-1200 kHz
createProp("sim/custom/xap/ark/ark_1_backlit", "int", 1);-- ARK back lit

createProp("sim/custom/xap/ark/ark_2_mode", "int", 1);-- ARK mode
createProp("sim/custom/xap/ark/ark_2_ant_sw", "int", 0);-- antenna switch to rotate ram
createProp("sim/custom/xap/ark/ark_2_left_1", "float", 0);-- left disk for set 0-9 kHz
createProp("sim/custom/xap/ark/ark_2_left_10", "float", 0);-- left disk for set 00-90 kHz
createProp("sim/custom/xap/ark/ark_2_left_100", "float", 0);-- left disk for set 100-1200 kHz
createProp("sim/custom/xap/ark/ark_2_right_1", "float", 0);-- right disk for set 0-9 kHz
createProp("sim/custom/xap/ark/ark_2_right_10", "float", 0);-- right disk for set 00-90 kHz
createProp("sim/custom/xap/ark/ark_2_right_100", "float", 0);-- right disk for set 100-1200 kHz
createProp("sim/custom/xap/ark/ark_2_backlit", "int", 1);-- ARK back lit

createProp("sim/custom/xap/ark/ark_1_angle", "float", 0);--
createProp("sim/custom/xap/ark/ark_1_signal", "float", 0);--
createProp("sim/custom/xap/ark/ark_2_angle", "float", 0);--
createProp("sim/custom/xap/ark/ark_2_signal", "float", 0);--

createProp("sim/custom/xap/ark/ark_1_cc", "float", 0);--
createProp("sim/custom/xap/ark/ark_2_cc", "float", 0);--

-- transponder
createProp("sim/custom/xap/sq/digit_1", "int", 0);-- digit 1
createProp("sim/custom/xap/sq/digit_2", "int", 0);-- digit 2
createProp("sim/custom/xap/sq/digit_3", "int", 0);-- digit 3
createProp("sim/custom/xap/sq/digit_4", "int", 0);-- digit 4

createProp("sim/custom/xap/sq/emerg", "int", 0);-- emergency button
createProp("sim/custom/xap/sq/sq_emerg_cap", "int", 0);-- emergency button cap
createProp("sim/custom/xap/sq/sq_mode", "int", 1);-- mode switcher

createProp("sim/custom/xap/sq/sq_sw", "int", 1);-- power switcher
createProp("sim/custom/xap/sq/sq_cc", "float", 0);-- current consumption


-- covers
createProp("sim/custom/xap/covers/gear_blocks", "int", 0); -- gear blocks. 0 = off, 1 = on
createProp("sim/custom/xap/covers/pitot1_cap", "int", 0); -- pitot cap. 0 = off, 1 = on
createProp("sim/custom/xap/covers/pitot2_cap", "int", 0); -- pitot cap. 0 = off, 1 = on
createProp("sim/custom/xap/covers/rio_cap", "int", 0); -- RIO3 cap. 0 = off, 1 = on
createProp("sim/custom/xap/covers/static1_cap", "int", 0); -- static cap. 0 = off, 1 = on
createProp("sim/custom/xap/covers/static2_cap", "int", 0); -- static cap. 0 = off, 1 = on
createProp("sim/custom/xap/covers/engine1_front_cap", "int", 0); -- engine cap. 0 = off, 1 = on
createProp("sim/custom/xap/covers/engine1_back_cap", "int", 0); -- engine cap. 0 = off, 1 = on
createProp("sim/custom/xap/covers/engine2_front_cap", "int", 0); -- engine cap. 0 = off, 1 = on
createProp("sim/custom/xap/covers/engine2_back_cap", "int", 0); -- engine cap. 0 = off, 1 = on
createProp("sim/custom/xap/covers/engine3_front_cap", "int", 0); -- engine cap. 0 = off, 1 = on
createProp("sim/custom/xap/covers/engine3_back_cap", "int", 0); -- engine cap. 0 = off, 1 = on

-- SRD
createProp("sim/custom/xap/srd/bleed_sw", "int", 0); --
createProp("sim/custom/xap/srd/bleed_cap", "int", 0); --
createProp("sim/custom/xap/srd/bleed_ON", "int", 1); --
createProp("sim/custom/xap/srd/system_sw", "int", 0); --
createProp("sim/custom/xap/srd/dubler_sw", "int", 0); --
createProp("sim/custom/xap/srd/dubler_cap", "int", 0); --
createProp("sim/custom/xap/srd/dump_cap", "int", 0); --
createProp("sim/custom/xap/srd/dump_sw", "int", 0); --

createProp("sim/custom/xap/srd/press_diff_set", "float", 0.4); --
createProp("sim/custom/xap/srd/start_compress_set", "float", 650); --
createProp("sim/custom/xap/srd/compress_spd_set", "float", 0.25); --

-- SKV
createProp("sim/custom/xap/skv/salon_temp_sw", "int", 0); -- salon temperature switcher
createProp("sim/custom/xap/skv/system_temp_sw", "int", 0); -- thu temperature switcher
createProp("sim/custom/xap/skv/skv_mode_sw", "int", 0); -- skv mode switcher
createProp("sim/custom/xap/skv/cabin_air_sw", "int", 0); -- cabin more/less switcher
createProp("sim/custom/xap/skv/salon_temp_rot", "float", 15); -- cabin more/less switcher
createProp("sim/custom/xap/skv/thu_temp_rot", "float", 15); -- cabin more/less switcher
createProp("sim/custom/xap/skv/salon_temp", "float", 15); -- result temperature in salon
createProp("sim/custom/xap/skv/skv_cc", "float", 0); -- result temperature in salon

-- anti-ice
createProp("sim/custom/xap/antiice/pitot1", "int", 0); --
createProp("sim/custom/xap/antiice/pitot2", "int", 0); --
createProp("sim/custom/xap/antiice/eng1", "int", 0); --
createProp("sim/custom/xap/antiice/eng2", "int", 0); --
createProp("sim/custom/xap/antiice/eng3", "int", 0); --
createProp("sim/custom/xap/antiice/system_sw", "int", 1); --
createProp("sim/custom/xap/antiice/system_cap", "int", 0); --
createProp("sim/custom/xap/antiice/system_mode1", "int", 0); --
createProp("sim/custom/xap/antiice/system_mode2", "float", 0.5); --
createProp("sim/custom/xap/antiice/window", "int", 1); --
createProp("sim/custom/xap/antiice/rio3", "int", 1); --
createProp("sim/custom/xap/antiice/aoa", "int", 0); --
createProp("sim/custom/xap/antiice/rio3_cc", "float", 1)--
createProp("sim/custom/xap/antiice/aoa_cc", "float", 1)--
createProp("sim/custom/xap/antiice/antiice_cc", "float", 1)--
createProp("sim/custom/xap/antiice/air_engine", "float", 0)-- air took from engines for de-ice system
createProp("sim/custom/xap/antiice/check_btn", "int", 0)-- check button

-- fire
createProp("sim/custom/xap/fire/reset_button", "int", 0); -- reset fire system status
createProp("sim/custom/xap/fire/nacelle_sel_button", "int", 0); -- select nacelle to extinguish. 0 = none, 1 2 3 - engines, 4 = APU
createProp("sim/custom/xap/fire/engine_sel_button", "int", 0); -- select engine to extinguish. 0 = none, 1 2 3 - engines
createProp("sim/custom/xap/fire/engine_ext_button", "int", 0); -- select turn to extinguish engine.
createProp("sim/custom/xap/fire/nacelle_ext_button", "int", 0); -- select turn to extinguish nacelle.
createProp("sim/custom/xap/fire/apu_ext_cap", "int", 0); -- select turn to extinguish nacelle.
createProp("sim/custom/xap/fire/fire_cc", "float", 0); -- cc

-- misc
createProp("sim/custom/xap/misc/manometer_sw", "int", 1); -- turn ON all manometers
createProp("sim/custom/xap/misc/test_lamp_btn", "int", 0); -- test lamps button pressed
createProp("sim/custom/xap/misc/park_brake_sw", "int", 0); -- parking brake set
createProp("sim/custom/xap/misc/ladder_power_sw", "int", 0); -- ladder power switch
createProp("sim/custom/xap/misc/ladder_sw", "int", 0); -- ladder switch
createProp("sim/custom/xap/misc/ladder_sw_cap", "int", 0); -- ladder switch
createProp("sim/custom/xap/misc/noseweel", "int", 0); -- switch off nosewheel control. 1 = OFF
createProp("sim/custom/xap/misc/noseweel_cap", "int", 0); -- switch off nosewheel control cap
createProp("sim/custom/xap/misc/weel_taxi", "int", 0); -- when this var = 1, nosewheel can turn > 10 deg
createProp("sim/custom/xap/misc/vent_1_sw", "int", 0); -- ventilator switcher
createProp("sim/custom/xap/misc/vent_2_sw", "int", 0); -- ventilator switcher
createProp("sim/custom/xap/misc/vent_3_sw", "int", 0); -- ventilator switcher
createProp("sim/custom/xap/misc/vent_4_sw", "int", 0); -- ventilator switcher
createProp("sim/custom/xap/misc/vent_1", "float", 0); -- ventilator angle
createProp("sim/custom/xap/misc/vent_2", "float", 0); -- ventilator angle
createProp("sim/custom/xap/misc/vent_3", "float", 0); -- ventilator angle
createProp("sim/custom/xap/misc/vent_4", "float", 0); -- ventilator angle

createProp("sim/custom/xap/misc/nav_light_sw", "int", 1); -- nav lights switch
createProp("sim/custom/xap/misc/bec_light_sw", "int", 1); -- nav beacons switch
createProp("sim/custom/xap/misc/lan_light_sw", "int", 0); -- landing lights switch
createProp("sim/custom/xap/misc/lan_light_sw2", "int", 0); -- landing lights switch
createProp("sim/custom/xap/misc/lan_light_open_sw", "int", 0); -- landing lights open switch

createProp("sim/custom/xap/misc/cockpit_red", "float", 0.1); -- red cockpit light rotary
createProp("sim/custom/xap/misc/cockpit_spot1", "float", 0.1); -- cockpit spotlight rotary
createProp("sim/custom/xap/misc/cockpit_spot2", "float", 0.1); -- cockpit spotlight rotary
createProp("sim/custom/xap/misc/cockpit_panel", "int", 0); -- panel switcher

createProp("sim/custom/xap/misc/salon_main_sw", "int", 0); -- salon lights
createProp("sim/custom/xap/misc/salon_emerg_sw", "int", 0); -- salon lights
createProp("sim/custom/xap/misc/emerg_exit_light_sw", "int", 0); -- salon lights

createProp("sim/custom/xap/misc/salon_brt", "float", 0); -- salon lights brightness
createProp("sim/custom/xap/misc/exit_brt", "float", 0); -- salon exit lights brightness

createProp("sim/custom/xap/misc/nav_light_cc", "float", 0); -- light current consumption
createProp("sim/custom/xap/misc/bec_light_cc", "float", 0); -- light current consumption
createProp("sim/custom/xap/misc/lan_light_cc", "float", 0); -- light current consumption
createProp("sim/custom/xap/misc/cockpit_light_cc", "float", 0); -- light current consumption

createProp("sim/custom/xap/misc/hide_left_lamp", "int", 0); -- hide lamp on 3D object
createProp("sim/custom/xap/misc/hide_right_lamp", "int", 0); -- hide lamp on 3D object
createProp("sim/custom/xap/misc/aoa_sensor_angle", "float", 0); -- angle for AOA animation
createProp("sim/custom/xap/misc/view_point", "int", 0); -- point of view

createProp("sim/custom/xap/misc/nosewheel_cc", "float", 1)--
createProp("sim/custom/xap/misc/cam_in_cockpit", "int", 1)--
createProp("sim/custom/xap/misc/rev_switch", "float", 0.5) -- reverse switch on central panel
createProp("sim/custom/xap/misc/rev_switch_cap", "float", 0) -- reverse switch cap on central panel

-- panels
createProp("sim/custom/xap/panels/main_menu_subpanel", "int", 1);  -- main menu panel. 0 = OFF, 1 = ON
createProp("sim/custom/xap/panels/azs_left", "int", 0); -- left azs panel
createProp("sim/custom/xap/panels/azs_right", "int", 0); -- right azs panel
createProp("sim/custom/xap/panels/ground_service", "int", 0); -- ground service panel
createProp("sim/custom/xap/panels/camera", "int", 0); -- camera panel
createProp("sim/custom/xap/panels/payload", "int", 0); -- payload panel
createProp("sim/custom/xap/panels/options_subpanel", "int", 0); -- options panel
createProp("sim/custom/xap/panels/nl10", "int", 0); -- NL-10m panel
createProp("sim/custom/xap/panels/info_subpanel", "int", 0);  -- info panel. 0 = OFF, 1 = ON
createProp("sim/custom/xap/panels/ap_subpanel", "int", 0);  -- autopilot panel. 0 = OFF, 1 = ON
createProp("sim/custom/xap/panels/stab_check", "int", 0);  -- stab_check panel. 0 = OFF, 1 = ON

-- autopilot
createProp("sim/custom/xap/AP/power_sw", "int", 1) -- power switcher
createProp("sim/custom/xap/AP/pitch_sw", "int", 1) -- pitch switcher
createProp("sim/custom/xap/AP/pitch_comm", "int", 0) -- pitch command handle
createProp("sim/custom/xap/AP/roll_comm", "int", 0) -- roll command handle
createProp("sim/custom/xap/AP/ap_on_but", "int", 0) -- turn ON button
createProp("sim/custom/xap/AP/ap_alt_but", "int", 0) -- hold alt button

createProp("sim/custom/xap/AP/ap_roll_pos", "float", 0) -- position of roll axis from AP
createProp("sim/custom/xap/AP/ap_hdg_pos", "float", 0) -- position of hdg axis from AP
createProp("sim/custom/xap/AP/ap_pitch_pos", "float", 0) -- position of pitch axis from AP

createProp("sim/custom/xap/AP/ap_works_roll", "int", 0) -- autopilot has control over roll and hdg
createProp("sim/custom/xap/AP/ap_works_pitch", "int", 0) -- autopilot has control over pitch and stab

createProp("sim/custom/xap/AP/ap_need_pitch", "float", 0) -- needed pitch
createProp("sim/custom/xap/AP/ap_need_roll", "float", 0) -- needed roll 
createProp("sim/custom/xap/AP/ap_hdg_diff", "float", 0) -- heading diff to correct
createProp("sim/custom/xap/AP/ap_yaw_spd", "float", 0) -- currnet yaw speed

createProp("sim/custom/xap/AP/ap_ready_lit", "int", 0) -- autopilot is ready to work
createProp("sim/custom/xap/AP/ap_on_lit", "int", 0) -- autopilot is working
createProp("sim/custom/xap/AP/ap_alt_lit", "int", 0) -- autopilot is working and holding altitude

createProp("sim/custom/xap/AP/ap_force_fail", "int", 0) -- autopilot is sencing forse
createProp("sim/custom/xap/AP/ap_fail_roll", "int", 0) -- autopilot AP is OFF on roll channel due to failure or overforce by pilot
createProp("sim/custom/xap/AP/ap_fail_pitch", "int", 0) -- autopilot AP is OFF on pitch channel due to failure or overforce by pilot
createProp("sim/custom/xap/AP/ap_fail", "int", 0) -- autopilot is off

createProp("sim/custom/xap/AP/ap_cc", "float", 0) -- AP current consumption




----------------------------
-- subpanels --
----------------------------



-- window size issue for panels
defineProperty("window_height",globalPropertyi("sim/graphics/view/window_height"))
defineProperty("window_width",globalPropertyi("sim/graphics/view/window_width"))
local coef = get(window_height) / 1024
if coef > 1 then coef = 1 end  -- set initial coefficient for float panel's size - make 'em smaller, if screen resolution less then 1024 by height.

defineProperty("closeImage", loadImage("close.png"))  -- close cross image



-- add azs left subpanel
azs_left = subpanel {
    position = { 40, get(window_height) - 550, 423, 512 };
    noBackground = true;
    noClose = true;
    components = {
		azs_left_2d {
         position = { 0, 0, 423, 512 },
         };
		 textureLit {
		 position = {(423 - 16), (512 - 16), 16 , 16 },
		 image = get(closeImage),
		 };
	};
}

-- add azs right subpanel
azs_right = subpanel {
    position = { get(window_width) - 450, get(window_height) - 550, 423, 512 };
    noBackground = true;
    noClose = true;
    components = {
		azs_right_2d {
         position = { 0, 0, 423, 512 },
         };
		 textureLit {
		 position = {(423 - 16), (512 - 16), 16 , 16 },
		 image = get(closeImage),
		 };
	};
}

-- add ground service subpanel
ground = subpanel {
    position = { get(window_width) - 530, 40, 512, 516 };
    noBackground = true;
    noClose = true;
    components = {
		ground_panel_2d {
         position = { 0, 0, 512, 516 },
         };
		 textureLit {
		 position = {(512 - 16), (516 - 16), 16 , 16 },
		 image = get(closeImage),
		 };
	};
}

-- add ground service subpanel
cam_panel = subpanel {
    position = { 40, get(window_height) - 320, 256, 256 };
    noBackground = true;
    noClose = true;
    components = {
		camera_panel {
         position = { 0, 0, 256, 256 },
         };
		 textureLit {
		 position = {(256 - 16), (256 - 16), 16 , 16 },
		 image = get(closeImage),
		 };
	};
}

-- add payload subpanel
payload = subpanel {
    position = { 40, 10, 710 * coef, 990 * coef };
    noBackground = false;
    noClose = true;
    components = {
		payload_panel {
         position = { 0, 0, 710 * coef, 990 * coef },
         };
	textureLit {
		 position = {(710 - 16) * coef, (990 - 16) * coef, 16 * coef, 16 * coef},
		 image = get(closeImage),
		 };
	};
}

-- add options subpanel
options = subpanel {
    position = { 40, 20, 512 * coef, 512 * coef };
    noBackground = true;
    noClose = true;
    components = {
		settings {
         position = { 0, 0, 512 * coef, 512 * coef },
         };
		textureLit {
		 position = {(512 - 16) * coef, (512 - 16) * coef, 16 * coef, 16 * coef},
		 image = get(closeImage),
		 };
	};
}

-- add NL-10m subpanel
nl10m_panel = subpanel {
    position = { 40, 0, 1280 * coef, 330 * coef };
    noBackground = true;
    noClose = true;
    components = {
		nl10m {
         position = { 0, 0, 1280 * coef, 330 * coef },
         };
		 textureLit {
		 position = {(1280 - 16) * coef, (330 - 16) * coef, 16 * coef, 16 * coef},
		 image = get(closeImage),
		 };
	};
}

-- add info subpanel
info_panel = subpanel {
    position = { 40, 470, 227, 256  };
    noBackground = false;
    noClose = true;
	noResize = true;
    components = {
		info_panel_2d {
         position = { 0, 0, 227, 256 },
         };
	textureLit {
		 position = {(227 - 16), (256 - 16), 16, 16},
		 image = get(closeImage),
		 };
	};
}

-- add AP subpanel
ap_panel = subpanel {
    position = { 40, 40, 350, 290 };
    noBackground = true;
    noClose = true;
    noResize = true;
	components = {
		ap_panel_2d {
         position = { 0, 0, 350, 290 },
         };
	textureLit {
		 position = {(350 - 16), (290 - 16), 16, 16},
		 image = get(closeImage),
		 };
	};
}

-- add stab_check subpanel
stab_check = subpanel {
    position = { 600, 220, 700, 509 };
    noBackground = true;
    noClose = true;
	components = {
		stab_check {
         position = { 0, 0, 700, 509 },
         };
	textureLit {
		 position = {(700 - 20), (509 - 20), 16, 16},
		 image = get(closeImage),
		 };
	};
}

-- add menu subpanel
main_menu = subpanel {
    position = { 0, 300, 32, 260 };
    noBackground = true;
    noClose = true;
    noResize = true;
    components = {
		menu_panel {
         position = { 0, 0, 32, 260 },
		panel_1 = azs_left,
		panel_2 = azs_right,
		panel_3 = ground,
		panel_4 = cam_panel,
		panel_5 = payload,
		panel_6 = options,
		panel_7 = nl10m_panel,
		panel_8 = info_panel,
		panel_9 = ap_panel,
		panel_10 = stab_check,
         };
	};
}

components = {
	sim_vers{}, -- check sim version
	sound{},
	crew_sounds{},

	-------
	-- logic --
	-------
	time_logic{},
	flap_aero {},
	flight_controls{},
	ground_stuff {},
	KLN90 {},
	KLN90_panel { 
			position = { 269, 555, 588, 188 } 
	},
	gns430stuff {position = { 0, 465, 348, 195 } },
	panel_logic {
		panel_0 = main_menu,
		panel_1 = azs_left,
		panel_2 = azs_right,
		panel_3 = ground,
		panel_4 = cam_panel,
		panel_5 = payload,
		panel_6 = options,
		panel_7 = nl10m_panel,
		panel_8 = info_panel,
		panel_9 = ap_panel,
		panel_10 = stab_check,
	},

	battery_logic{},
	battery_logic{
		bat_volt_bus = globalPropertyf("sim/custom/xap/power/bat_volt2"), -- battery voltage, initial 24V - full charge.
		bat_amp_bus = globalPropertyf("sim/custom/xap/power/bat_amp_bus2"),  -- battery current, initial 0A. positive - battery load, negative - battery recharge.
		bat_conn = globalPropertyi("sim/custom/xap/power/bat2_on"),  -- battery switch. 0 = OFF, 1 = ON
		bat_amp_cc = globalPropertyf("sim/custom/xap/power/bat_amp_cc2"),
		fail = globalPropertyi("sim/operation/failures/rel_g_bat2"),
	},
	generators_logic{},
	bus_logic{},
	bus_counter{},

	hydraulic_logic{},
	fuel_logic {},
	start_logic {},
	engine_fuel{},
	gyro {
		gyro_cc = globalPropertyf("sim/custom/xap/gauges/GMK_cc1"),  -- current consumtion
		gyro_curse = globalPropertyf("sim/custom/xap/gauges/gyro_curse1"),
		fail = globalPropertyf("sim/operation/failures/rel_ss_dgy"),
	},
	gyro {
		gyro_cc = globalPropertyf("sim/custom/xap/gauges/GMK_cc2"),  -- current consumtion
		gyro_curse = globalPropertyf("sim/custom/xap/gauges/gyro_curse2"),
		fail = globalPropertyf("sim/operation/failures/rel_cop_dgy"),
	},
	gmk_logic {
		GMK_curse = globalPropertyf("sim/custom/xap/gauges/GMK_curse1"), -- calculated course
		device_num = 0, -- number of device
		gyro = globalPropertyf("sim/custom/xap/gauges/gyro_curse1"),
	},
	gmk_logic {
		GMK_curse = globalPropertyf("sim/custom/xap/gauges/GMK_curse2"), -- calculated course
		device_num = 1, -- number of device
		gyro = globalPropertyf("sim/custom/xap/gauges/gyro_curse2"),
	},

	ark9_set {},

	ark9_set {
		left_freq = globalPropertyf("sim/cockpit2/radios/actuators/adf2_frequency_hz"),  -- left frequency
		right_freq = globalPropertyf("sim/cockpit2/radios/actuators/adf2_standby_frequency_hz"),  -- right frequency
		active = globalPropertyf("sim/cockpit2/radios/actuators/adf2_right_is_selected"),  -- selector of active disk. 0 - left, 1 - right
		fail = globalPropertyf("sim/operation/failures/rel_adf2"),
		adf = globalPropertyf("sim/cockpit2/radios/indicators/adf2_relative_bearing_deg"),
		audio_selection = globalPropertyi("sim/cockpit2/radios/actuators/audio_selection_adf2"),
		inverter = globalPropertyi("sim/custom/xap/power/inv_PO1500_steklo"), -- inverter for 115v bus
		ark_mode = globalPropertyi("sim/custom/xap/ark/ark_2_mode"),
		ant_sw = globalPropertyi("sim/custom/xap/ark/ark_2_ant_sw"),
		left_1 = globalPropertyf("sim/custom/xap/ark/ark_2_left_1"),  -- left disk for set 0-9 kHz
		left_10 = globalPropertyf("sim/custom/xap/ark/ark_2_left_10"),  -- left disk for set 00-90 kHz
		left_100 = globalPropertyf("sim/custom/xap/ark/ark_2_left_100"),  -- left disk for set 100-1200 kHz
		right_1 = globalPropertyf("sim/custom/xap/ark/ark_2_right_1"),  -- right disk for set 0-9 kHz
		right_10 = globalPropertyf("sim/custom/xap/ark/ark_2_right_10"),  -- right disk for set 00-90 kHz
		right_100 = globalPropertyf("sim/custom/xap/ark/ark_2_right_100"),  -- right disk for set 100-1200 kHz
		backlit = globalPropertyi("sim/custom/xap/ark/ark_2_backlit"),
		AZS = globalPropertyi("sim/custom/xap/azs/AZS_ARK_2_sw"), -- AZS switcher
		ark_cc = globalPropertyf("sim/custom/xap/ark/ark_2_cc"), -- cc

		res_angle = globalPropertyf("sim/custom/xap/ark/ark_2_angle"),
		res_signal = globalPropertyf("sim/custom/xap/ark/ark_2_signal"),
	},

	vent {},
	covers {},
	siren_logic {},
	view {},
	failures {},
	ap_mech {},
	ap_logic {},
	msrp {},
	
	-------------------
	-- overall panels --
	------------------
	engine_logic{
		position = {0, 0, 2048, 2048},
	},

	elecric_panel_3d {
		position = {0, 0, 2048, 2048},
	},
	flaps_logic {
		position = {0, 0, 2048, 2048},
	},

	gear_logic {
		position = {0, 0, 2048, 2048},
	},

	gear_panel {
		position = {640, 1129, 240, 120},
	},

	stab_ind {
		position = {1600, 1328, 120, 120},
	},

	achs1 {
		position = {781, 1246, 200, 200},
	},

	misc_clickables {
		position = {0, 0, 2048, 2048},
	},

	bspk {
		position = {0, 0, 2048, 2048},
	},

	ite2 {
		position = {601, 1646, 200, 200},
		--AZS = globalPropertyi("sim/custom/xap/azs/AZS_eng_gau_1_sw"),
		N2 = globalPropertyf("sim/flightmodel/engine/ENGN_N2_[1]"),
		N1 = globalPropertyf("sim/flightmodel/engine/ENGN_N1_[1]"),
	},

	ite2 {
		position = {801, 1646, 200, 200},
		N2 = globalPropertyf("sim/flightmodel/engine/ENGN_N2_[0]"),
		N1 = globalPropertyf("sim/flightmodel/engine/ENGN_N1_[0]"),
		--AZS = globalPropertyi("sim/custom/xap/azs/AZS_eng_gau_2_sw"),
	},

	ite2 {
		position = {1000, 1646, 200, 200},
		N2 = globalPropertyf("sim/flightmodel/engine/ENGN_N2_[2]"),
		N1 = globalPropertyf("sim/flightmodel/engine/ENGN_N1_[2]"),
		--AZS = globalPropertyi("sim/custom/xap/azs/AZS_eng_gau_3_sw"),
	},

	emi3 {
		position = {1200, 1646, 200, 200},
		fuel_p = globalPropertyf("sim/cockpit2/engine/indicators/fuel_pressure_psi[1]"),
		oil_p = globalPropertyf("sim/cockpit2/engine/indicators/oil_pressure_psi[1]"),
		oil_t = globalPropertyf("sim/cockpit2/engine/indicators/oil_pressure_psi[1]"),
		AZS = globalPropertyi("sim/custom/xap/azs/AZS_eng_gau_1_sw"),
		emi_cc = globalPropertyf("sim/custom/xap/gauges/emi1_cc"), -- cc
	},

	emi3 {
		position = {1400, 1646, 200, 200},
		fuel_p = globalPropertyf("sim/cockpit2/engine/indicators/fuel_pressure_psi[0]"),
		oil_p = globalPropertyf("sim/cockpit2/engine/indicators/oil_pressure_psi[0]"),
		oil_t = globalPropertyf("sim/cockpit2/engine/indicators/oil_pressure_psi[0]"),
		AZS = globalPropertyi("sim/custom/xap/azs/AZS_eng_gau_2_sw"),
		emi_cc = globalPropertyf("sim/custom/xap/gauges/emi2_cc"), -- cc
	},

	emi3 {
		position = {1600, 1646, 200, 200},
		fuel_p = globalPropertyf("sim/cockpit2/engine/indicators/fuel_pressure_psi[2]"),
		oil_p = globalPropertyf("sim/cockpit2/engine/indicators/oil_pressure_psi[2]"),
		oil_t = globalPropertyf("sim/cockpit2/engine/indicators/oil_pressure_psi[2]"),
		AZS = globalPropertyi("sim/custom/xap/azs/AZS_eng_gau_3_sw"),
		emi_cc = globalPropertyf("sim/custom/xap/gauges/emi3_cc"), -- cc
	},

	egt_term {
		position = {1840, 1326, 120, 120},
		--AZS = globalPropertyi("sim/custom/xap/azs/AZS_eng_gau_1_sw"),
		EGT = globalPropertyf("sim/cockpit2/engine/indicators/EGT_deg_C[1]"),
	},

	egt_term {
		position = {1840, 1207, 120, 120},
		EGT = globalPropertyf("sim/cockpit2/engine/indicators/EGT_deg_C[0]"),
		--AZS = globalPropertyi("sim/custom/xap/azs/AZS_eng_gau_2_sw"),
	},

	egt_term {
		position = {1720, 1207, 120, 120},
		EGT = globalPropertyf("sim/cockpit2/engine/indicators/EGT_deg_C[2]"),
		--AZS = globalPropertyi("sim/custom/xap/azs/AZS_eng_gau_3_sw"),
	},

	test_lamps {
		position = {981, 628, 20, 20},
	},

	misc_lamps {
		position = {0, 0, 2048, 2048},
	},

	fuel_panel_3d {
		position = {0, 0, 2048, 2048},
	},

	apu_logic {
		position = {0, 0, 2048, 2048},
	},

	start_panel {
		position = {0, 0, 2048, 2048},
	},

	controls {
		position = {0, 0, 2048, 2048},
	},

	ark9_3d {
		position = {404, 2, 500, 364},
	},

	ark9_3d {
		position = {905, 2, 500, 364},

		left_freq = globalPropertyf("sim/cockpit2/radios/actuators/adf2_frequency_hz"),  -- left frequency
		right_freq = globalPropertyf("sim/cockpit2/radios/actuators/adf2_standby_frequency_hz"),  -- right frequency
		active = globalPropertyf("sim/cockpit2/radios/actuators/adf2_right_is_selected"),  -- selector of active disk. 0 - left, 1 - right
		fail = globalPropertyf("sim/operation/failures/rel_adf2"),
		adf = globalPropertyf("sim/cockpit2/radios/indicators/adf2_relative_bearing_deg"),
		audio_selection = globalPropertyi("sim/cockpit2/radios/actuators/audio_selection_adf2"),

		ark_mode = globalPropertyi("sim/custom/xap/ark/ark_2_mode"),
		ant_sw = globalPropertyi("sim/custom/xap/ark/ark_2_ant_sw"),
		left_1 = globalPropertyf("sim/custom/xap/ark/ark_2_left_1"),  -- left disk for set 0-9 kHz
		left_10 = globalPropertyf("sim/custom/xap/ark/ark_2_left_10"),  -- left disk for set 00-90 kHz
		left_100 = globalPropertyf("sim/custom/xap/ark/ark_2_left_100"),  -- left disk for set 100-1200 kHz
		right_1 = globalPropertyf("sim/custom/xap/ark/ark_2_right_1"),  -- right disk for set 0-9 kHz
		right_10 = globalPropertyf("sim/custom/xap/ark/ark_2_right_10"),  -- right disk for set 00-90 kHz
		right_100 = globalPropertyf("sim/custom/xap/ark/ark_2_right_100"),  -- right disk for set 100-1200 kHz
		backlit = globalPropertyi("sim/custom/xap/ark/ark_2_backlit"),
		AZS = globalPropertyi("sim/custom/xap/azs/AZS_ARK_2_sw"), -- AZS switcher

		res_angle = globalPropertyf("sim/custom/xap/ark/ark_2_angle"),
		res_signal = globalPropertyf("sim/custom/xap/ark/ark_2_signal"),
	},
	mrp {
		position = {0, 0, 2048, 2048},
	},

	com_set{
		position = {1784, 138, 245, 110},
	},
	com_set{
		position = {1784, 9, 245, 110},
		frequency = globalPropertyf("sim/cockpit2/radios/actuators/com2_frequency_hz"),  -- set the frequency
		AZS_COM_sw = globalPropertyi("sim/custom/xap/azs/AZS_COM_2_sw"), -- AZS switcher
		com_cc = globalPropertyf("sim/custom/xap/gauges/com2_cc"), -- cc
	},

	iv {
		position = {0, 0, 2048, 2048},
	},

	doors {
		position = {0, 0, 2048, 2048},
	},

	nosewheel_logic {
		position = {0, 0, 2048, 2048},
	},

	efis {
		position = {0, 0, 2048, 2048},
	},

	srd {
		position = {0, 0, 2048, 2048},
	},

	skv {
		position = {0, 0, 2048, 2048},
	},

	fire_system {
		position = {0, 0, 2048, 2048},
	},
	
	light_logic {
		position = {0, 0, 2048, 2048},
	},

	stall {
		position = {0, 0, 2048, 2048},
	},
	
	reverse {
		position = {0, 0, 2048, 2048},
	}, 
	
	ap_panel_3d {
		position = {0, 0, 2048, 2048},	
	},
	
	course_mp_panel_3d {
		position = {0, 0, 2048, 2048},	
	},
	
	
	-------------------
    -- captain instruments
    -------------------
	azs_left_3d {
		position = {0, 0, 2048, 2048},
	},

	hydraulic_panel_3d {
		position = {0, 0, 2048, 2048},
	},

	brake_logic {
		position = {0, 0, 2048, 2048},
	},
	da_30 {
		position = {1599, 1846, 200, 200},
	},
	kus_730 {
		position = {1000, 1846, 200, 200},
	},

	uvid_30 {
		position = {1200, 1846, 200, 200},
	},

	vd_10ft {
		position = {400, 1646, 200, 200},
	},

	rv_2 {
		position = {0, 1646, 200, 200},
	},

	agd3 {
		position = {0, 1247, 200, 200},
		AGD_sw = globalPropertyi("sim/custom/xap/gauges/agd_1_sw"),
		AZS_agd_sw = globalPropertyi("sim/custom/xap/azs/AZS_agd_1_sw"),
		AGD_cc = globalPropertyf("sim/custom/xap/gauges/agd_1_cc"),
		res_roll = globalPropertyf("sim/custom/xap/gauges/roll_1"),
		res_pitch = globalPropertyf("sim/custom/xap/gauges/pitch_1"),
	},

	agd3 {
		position = {200, 1247, 200, 200},
		AC_36_volt = 36, -- 36 volt
		AGD_sw = globalPropertyi("sim/custom/xap/gauges/agd_2_sw"),
		AZS_agd_sw = globalPropertyi("sim/custom/xap/azs/AZS_agd_2_sw"),
		AGD_cc = globalPropertyf("sim/custom/xap/gauges/agd_2_cc"),
		res_roll = globalPropertyf("sim/custom/xap/gauges/roll_2"),
		res_pitch = globalPropertyf("sim/custom/xap/gauges/pitch_2"),
		sim_fail = 0,
	},

	up4 {
		position = {1001, 1327, 120, 120},
	},

	therm {
		position = {1481, 1327, 120, 120},
	},

	kppm {
		position = {1400, 1847, 200, 200},
	},

	ark_ind {
		position = {1800, 1847, 250, 200},
	},

	nav_os1_set {
		position = {1001, 1050, 300, 135},
	},

	obs_set{
		position = {403, 1050, 170, 70},
	},

	transponder {
		position = {17, 770, 328, 257},
	},

	spu {
		position = {1262, 668, 19, 19},
	},

	km8 {
		position = {200, 1046, 200, 200},
	},
	-------------------
	-- copilot instruments
	-------------------
	azs_right_3d {
		position = {0, 0, 2048, 2048},
	},
	da_30 {
		position = {1200, 1446, 200, 200},
		da30_cc = globalPropertyf("sim/custom/xap/gauges/da30_2_cc"), -- current consumption
		vvi = globalPropertyf("sim/cockpit2/gauges/indicators/vvi_fpm_copilot"),
		turn = globalPropertyf("sim/cockpit2/gauges/indicators/turn_rate_heading_deg_copilot"),
	},

	kus_730 {
		position = {600, 1446, 200, 200},
		ias = globalPropertyf("sim/cockpit2/gauges/indicators/airspeed_kts_copilot"),
	},

	vd_10 {
		position = {800, 1446, 200, 200},
	},

	uvid_30fk {
		position = {0, 1446, 200, 200},
	},

	agd3 {
		position = {400, 1247, 200, 200},
		AGD_sw = globalPropertyi("sim/custom/xap/gauges/agd_3_sw"),
		AZS_agd_sw = globalPropertyi("sim/custom/xap/azs/AZS_agd_3_sw"),
		AGD_cc = globalPropertyf("sim/custom/xap/gauges/agd_3_cc"),
		res_roll = globalPropertyf("sim/custom/xap/gauges/roll_3"),
		res_pitch = globalPropertyf("sim/custom/xap/gauges/pitch_3"),
		sim_fail = globalPropertyi("sim/operation/failures/rel_cop_ahz"), -- failure for copilot ahz
	},

	var_10_cabin {
		position = {1800, 1646, 200, 200},
	},

	gmk_panel_3d {
		position = {363, 772, 457, 271},
	},

	kppm {
		position = {1000, 1447, 200, 200},
		hor_def = globalPropertyf("sim/custom/xap/gauges/curs_2"),
		vert_def = globalPropertyf("sim/custom/xap/gauges/glide_2"),
		curs_flag = globalPropertyf("sim/custom/xap/gauges/k2_flag"),
		glide_flag = globalPropertyf("sim/custom/xap/gauges/g2_flag"),
		inverter = globalPropertyi("sim/custom/xap/power/inv_PO1500_steklo"),
		kppm_cc = globalPropertyf("sim/custom/xap/gauges/kppm2_cc"), -- cc
	},

	ark_ind {
		position = {1800, 1447, 250, 200},
		ark_knob1 = globalPropertyi("sim/custom/xap/gauges/ark_ind2_knob1"),
		ark_knob2 = globalPropertyi("sim/custom/xap/gauges/ark_ind2_knob2"),
	},

	nav_os1_set {
		position = {1300, 1050, 300, 135},
		frequency = globalPropertyf("sim/cockpit2/radios/actuators/nav2_frequency_hz"),  -- set the frequency

		v_plank = globalPropertyf("sim/cockpit2/radios/indicators/nav2_hdef_dots_pilot"), -- horizontal deflection on course
		h_plank = globalPropertyf("sim/cockpit2/radios/indicators/nav2_vdef_dots_pilot"), -- vertical deflection on glideslope
		cr_flag = globalPropertyf("sim/cockpit2/radios/indicators/nav2_flag_from_to_pilot"), -- Nav-To-From indication, nav1, pilot, 0 is flag, 1 is to, 2 is from.
		gs_flag = globalPropertyf("sim/cockpit/radios/nav2_CDI"),  -- glideslope flag. 0 - flag is shown
		nav_deg = globalPropertyf("sim/cockpit2/radios/indicators/nav2_relative_bearing_deg"), -- nav1 bearing
		fail = globalPropertyf("sim/operation/failures/rel_nav2"),

		k_flag = globalPropertyi("sim/custom/xap/gauges/k2_flag"), -- flag for course on left kppm
		g_flag = globalPropertyi("sim/custom/xap/gauges/g2_flag"), -- flag for glide on left kppm
		curs = globalPropertyf("sim/custom/xap/gauges/curs_2"), -- KursMP course for left kppm
		glide = globalPropertyf("sim/custom/xap/gauges/glide_2"), -- KursMP glide for left kppm
		vor = globalPropertyf("sim/custom/xap/gauges/vor_2"), -- KursMP course for left kppm
		nav_tofrom = globalPropertyi("sim/custom/xap/gauges/nav2_tofrom"), -- to-from lamps. 0 = none, 1 = to, 2 = from
		
		power_sw = globalPropertyi("sim/custom/xap/gauges/nav2_power"), -- power switch
		nav_button = globalPropertyi("sim/custom/xap/gauges/nav2_button"), -- power switch
		nav_cc = globalPropertyf("sim/custom/xap/gauges/nav2_cc"), -- cc
	},

	obs_set{
		position = {581, 1050, 170, 70},
		obs = globalPropertyf("sim/cockpit2/radios/actuators/nav2_obs_deg_mag_pilot"),  -- set the course
		power_sw = globalPropertyi("sim/custom/xap/gauges/nav2_power"), -- power switch
		fail = globalPropertyf("sim/operation/failures/rel_nav2"),
	},

	dme_set {
		position = {820, 913, 299, 135},
	},

	dme_ind {
		position = {881, 1128, 120, 120},
	},

	antiice {
		position = {0, 0, 2048, 2048},
	},


	
}

