--search and include KLN 90, if it exist in Custom Avionics

createGlobalPropertyi("sim/custom/kln_is_present", 0) -- поворот передней стойки шасси -70 влево, +70 вправо

defineProperty("kln_is_present", globalPropertyf("sim/custom/kln_is_present"))


createProp("sim/custom/kln_power", "int", 1);
defineProperty("kln_power", globalPropertyi("sim/custom/kln_power"));
defineProperty("bus_DC_27_volt", globalPropertyf("sim/custom/xap/An24_power/bus_DC_27_volt")) 


local coded = componentFileName == "KLN90_enabler.sec"

-- check if KLN main file is present and enable it if so.
if (isFileExists(panelDir.."/Custom Avionics/KLN90.lua") and not coded) or (isFileExists(panelDir.."/Custom Avionics/KLN90.sec") and coded) then 
	print("found KLN90, trying to open it")
	set(kln_is_present, 1)
	
	-- include("KLN90.lua") 
	-- decided to exclude the 2D panel and use only 3D one.
end

function update()
	-- KLN power calculation
	if get(bus_DC_27_volt) > 19 then set(kln_power, 1) else set(kln_power, 1) end

end