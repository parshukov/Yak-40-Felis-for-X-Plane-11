--search and include KLN 90, if it exist in Custom Avionics

local coded = componentFileName == "KLN90_enabler.sec"

if (isFileExists(panelDir.."/Custom Avionics/KLN90.lua") and not coded) or (isFileExists(panelDir.."/Custom Avionics/KLN90.sec") and coded) then 
	--print("found KLN90, trying to open it")
	include("KLN90.lua") 
end

