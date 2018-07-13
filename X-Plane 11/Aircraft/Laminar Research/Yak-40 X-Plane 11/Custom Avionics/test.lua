
--sim/flightmodel/controls/mwing01_ail1def
--sim/flightmodel/controls/mwing02_ail1def
--sim/multiplayer/controls/yoke_roll_ratio
--sim/flightmodel/controls/mwing03_elv1def
--sim/aircraft/parts/acf_ail1



defineProperty("ovj", globalPropertyf("sim/operation/override/override_joystick"))
defineProperty("ovs", globalPropertyf("sim/operation/override/override_artstab"))


defineProperty("trimmy", globalPropertyf("sim/cockpit2/controls/rudder_trim"))
defineProperty("trimmr", globalPropertyf("sim/cockpit2/controls/aileron_trim"))
defineProperty("trimmp", globalPropertyf("sim/cockpit2/controls/elevator_trim"))




defineProperty("times", globalPropertyf("sim/time/total_flight_time_sec"))

defineProperty("trimmp", globalPropertyf("sim/cockpit2/controls/elevator_trim")) -- sim pitch trimmer
defineProperty("trimmr", globalPropertyf("sim/cockpit2/controls/aileron_trim")) -- sim roll trimmer
defineProperty("trimmy", globalPropertyf("sim/cockpit2/controls/rudder_trim")) -- sim yaw trimmer





defineProperty("pitchj", globalPropertyf("sim/cockpit2/controls/yoke_pitch_ratio"))
defineProperty("rollj", globalPropertyf("sim/cockpit2/controls/yoke_roll_ratio"))
defineProperty("yawj", globalPropertyf("sim/cockpit2/controls/yoke_heading_ratio"))
defineProperty("al", globalPropertyf("sim/flightmodel/position/phi"))
defineProperty("ty", globalPropertyf("sim/flightmodel/position/Rrad"))
defineProperty("tp", globalPropertyf("sim/flightmodel/position/Qrad"))
defineProperty("tr", globalPropertyf("sim/flightmodel/position/Prad"))
cntp = 0
resp=0
resr=0
resy=0
timl=0
function update()
--[[
tim = get(times)
timd = tim-timl
timl=tim

trmp = get(trimmp)
trmr = get(trimmr)
trmy = get(trimmy)

ap=get(pitchj) * 1
ar=get(rollj) * 1
ay=get(yawj) * 1

cntp = ap - trmp
cntr = ar - trmr
cnty = ay - trmy

resp = resp + (cntp * timd)*1
resr = resr + (cntr * timd)*4
resy = resy + (cnty * timd)*1

set(trimmp, resp)
set(trimmr, resr)
set(trimmy, resy)
--]]

trmp = get(trimmp)*0.5
trmr = get(trimmr)*1
trmy = get(trimmy)*1

--set(tp, trmp)
--set(tr, trmr)
--set(ty, trmy)
end
