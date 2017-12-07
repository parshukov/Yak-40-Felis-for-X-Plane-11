defineProperty("cl", globalPropertyf("sim/aircraft/controls/acf_flap_cl"))
defineProperty("cd", globalPropertyf("sim/aircraft/controls/acf_flap_cd"))
defineProperty("cm", globalPropertyf("sim/aircraft/controls/acf_flap_cm"))
defineProperty("flap", globalPropertyf("sim/flightmodel/controls/flaprat"))
defineProperty("alt", globalPropertyf("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot"))
defineProperty("yd", globalPropertyf("sim/cockpit2/switches/yaw_damper_on"))
function update()
set(yd,1)
flapratio = get(flap)
ralt = get(alt)
if ralt < 1 then ralt = 1 end

kalt = 1 / ralt


flapcl = 0.2 + (0.8 * flapratio) -- + (kalt * 0.3) * flapratio
flapcd = 0.06 * flapratio
flapcm = -0.1 --+ (kalt * 0.1)
set(cl , flapcl)
set(cd , flapcd)
set(cm , flapcm)
end
