-- check for sim version

defineProperty("sim_version", globalPropertyi("sim/custom/xap/sim_version"))  -- saved sim version

defineProperty("sim_v", globalPropertys("sim/version/sim_build_string"))  -- sim version



local notLoaded = true

function update()
	
	if notLoaded then
		local text_version = get(sim_v)

		print("sim build date:", text_version)

		local a = 1
		local b = string.find(text_version, " ", a)
		local vers_month = string.sub(text_version, a, b)
		a = b+2
		b = string.find(text_version, " ", a)
		local vers_date = tonumber(string.sub(text_version, a, b))
		a = b+1
		b = string.find(text_version, " ", a)
		local vers_year = tonumber(string.sub(text_version, a, b))

		print("sim year is", vers_year)
		
		if vers_year >= 2012 then set(sim_version, 10) end
		print("sat sim version is", get(sim_version))
	
		notLoaded = false
	end
	
	
end