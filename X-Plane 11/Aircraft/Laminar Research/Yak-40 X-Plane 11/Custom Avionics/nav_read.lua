
local ndb_by_code = {}
local vor_by_code = {}
local fix_by_code = {}

local ndb_by_index = {}
local vor_by_index = {}
local fix_by_index = {}

local indecies_for_show = {}

local near_ndb = {}
local near_vor = {}
local near_fix = {}

local test = {}


function read_fix_dat()
	local file = io.open("Resources/default data/earth_fix.dat", "r")
	if file then
		fix_by_code = {}
		fix_by_index = {}
		while true do
			local line = file:read("*line")
			if line == nil then break end
			local a = 2
			local b = string.find(line, " ", a) -- find spacebar after selected point
			if b ~= nil and b > 9 then
				local latitude = tonumber(string.sub(line, a, b))
				a = b
				b = string.find(line, " ", a+4)
				local longtitude = tonumber(string.sub(line, a, b))
				local code = string.sub(line, b + 1)
				-----------
				-- fill table by code
				if fix_by_code[code] == nil then fix_by_code[code] = {} end
				table.insert(fix_by_code[code], {["lat"] = latitude, ["lon"] = longtitude})
				----------	
				-- fill table by index
				local num = 0 
				if longtitude < -81 then num = "S"
				elseif longtitude > 81 then num = "N"
				else num = math.floor((longtitude + 183) / 3) * 100 + math.floor((latitude + 93) / 3) end
				if fix_by_index[num] == nil then fix_by_index[num] = {} end
				table.insert(fix_by_index[num], {["lat"] = latitude, ["lon"] = longtitude, ["icao"] = code})
			end
		
		
		end	
		print("fix.dat read")
	else print("can't read fix.dat")
	end
	file:close()

	
end


function read_nav_dat()
	local file = io.open("Resources/default data/earth_nav.dat", "r")
	local counter = 0
	if file then
		ndb_by_code = {}
		vor_by_code = {}
		ndb_by_index = {}
		vor_by_index = {}
		
		-- fill tables with indecies and empty them
		--[[ndb_by_index["N"] = {}
		ndb_by_index["S"] = {}
		vor_by_index["N"] = {}
		vor_by_index["S"] = {}

		for i = 1, 121, 1 do
			for j = 1, 31, 1 do
				ndb_by_index[i * 100 + j] = {}
				vor_by_index[i * 100 + j] = {}
			end
		end--]]
		
		while true do
			local line = file:read("*line")
			if line == nil then break end
			local a = 1
			local b = string.find(line, " ", a) -- find spacebar
			
			if b ~= nil then
				local nav_type = tonumber(string.sub(line, a, b))
				a = b
				b = string.find(line, " ", b+3)
				
				local latitude = tonumber(string.sub(line, a, b))
				a = b
				b = string.find(line, " ", b+3)
				
				local longtitude = tonumber(string.sub(line, a, b))
				a = string.find(line, "%d", b)  -- find first digit
				b = string.find(line, " ", a)
				
				local elevation = tonumber(string.sub(line, a, b))
				a = string.find(line, "%d", b)
				b = string.find(line, " ", a)
				
				local freq = tonumber(string.sub(line, a, b))
				a = string.find(line, "%d", b)
				b = string.find(line, " ", a)
				
				local range = tonumber(string.sub(line, a, b))
				a = string.find(line, "%d", b)
				b = string.find(line, " ", a)
				
				local course = tonumber(string.sub(line, a, b))
				a = b+1
				b = string.find(line, " ", a)
				
				local code = string.sub(line, a, b-1)
				a = string.find(line, "%a", a) -- find any character after last position
				
				local full_name = string.sub(line, a)
				-- cut types from full name string
				full_name = string.gsub(full_name, " NDB", "")
				full_name = string.gsub(full_name, " VORTAC", "")
				full_name = string.gsub(full_name, "-DME", "")
				full_name = string.gsub(full_name, " VOR", "")
				
				if nav_type == 2 then -- read NDB's
					
					-- fill table with NDBs by its ICAO code
					if ndb_by_code[code] == nil then 
						ndb_by_code[code] = {}
					end
					table.insert(ndb_by_code[code], {["lat"] = latitude, ["lon"] = longtitude, ["freq"] = freq, ["fullname"] = full_name})
					
					-- fill table with NDBs by its coordinate index
					local num = 0
					if longtitude < -81 then num = "S"
					elseif longtitude > 81 then num = "N"
					else num = math.floor((longtitude + 183) / 3) * 100 + math.floor((latitude + 93) / 3) end
					if ndb_by_index[num] == nil then ndb_by_index[num] = {} end
					table.insert(ndb_by_index[num], {["lat"] = latitude, ["lon"] = longtitude, ["freq"] = freq, ["fullname"] = full_name, ["icao"] = code})
				
				elseif nav_type == 3 then -- read VOR's
					
					-- fill table with VORs by its ICAO code
					if vor_by_code[code] == nil then 
						vor_by_code[code] = {}
					end
					table.insert(vor_by_code[code], {["lat"] = latitude, ["lon"] = longtitude, ["freq"] = freq * 0.01, ["fullname"] = full_name})
					
					-- fill table with VORs by its coordinate index
					local num = 0 
					if longtitude < -81 then num = "S"
					elseif longtitude > 81 then num = "N"
					else num = math.floor((longtitude + 183) / 3) * 100 + math.floor((latitude + 93) / 3) end
					if vor_by_index[num] == nil then vor_by_index[num] = {} end
					table.insert(vor_by_index[num], {["lat"] = latitude, ["lon"] = longtitude, ["freq"] = freq * 0.01, ["fullname"] = full_name, ["icao"] = code})										
					
				end
			end
			
		end	
		print("nav.dat read")
	else print("can't read nav.dat")
	end
	file:close()
	
end


function calc_indecies(latitude, longtitude, range) -- function for fill index table for showing 'em
	indecies_for_show = {}  -- flush table
	
	local x = latitude + range / 60 -- start point for search, lat in degrees
	-- move latitude away from poles
	while x > 84 do
		x = x - 3
	end	
	if x < -81 then x = -82 end
	
	local y = longtitude - range / (60 * math.cos(math.rad(x))) -- start point for search, lon in degrees
	
	local last_num = 0 -- variable for check same index
	
	-- fill table with indexes
	while true do
		
		-- check coordinates
		local a = math.floor(x/3)*3
		local b = math.floor(y/3)*3
		if b > 180 then b = b - 360
		elseif b < -180 then b = b + 360 end
		
		-- insert number of index in table of indexes
		local num = 0		
		if a < -81 then num = "S"
		elseif a > 81 then num = "N"
		else num = math.floor((b + 183) / 3) * 100 + math.floor((a + 93) / 3) end

		if num ~= last_num then table.insert(indecies_for_show, num) end
		last_num = num
		
	
		-- move search point to the right
		y = y + 3
		-- if new coordinates are out of search area - move down or end circle
		if y > math.ceil((longtitude + range / (60 * math.cos(math.rad(x))))/3)*3 then 
			x = x - 3
			y = longtitude - range / (60 * math.cos(math.rad(x)))	
		end
		if x < math.floor((latitude - range / 60)/3)*3 or x < -84 then break end
	end

	return true
	
end

-------------------------
function select_navaids(latitude, longtitude, range, ndb, vor, fix, apt)
	
	-- flush tables
	if ndb then near_ndb = {} end
	if vor then near_vor = {} end
	if fix then near_fix = {} end
	
	
	for k, i in pairs(indecies_for_show) do

		-- search and save near NDBs
		if ndb and ndb_by_index[i] ~= nil then 
			for n, m in pairs(ndb_by_index[i]) do
				if m["icao"] ~= nil then 
					local d, foo = calc_range(latitude, longtitude, m["lat"], m["lon"])
					--print(m["icao"], d)
					if d <= range then
						--print("NDB", m["icao"], m["lat"], m["lon"], m["freq"], m["fullname"], d, calc_true_course(latitude, longtitude, m["lat"], m["lon"], d))
						table.insert(near_ndb, {["icao"] = m["icao"], ["lat"] = m["lat"], ["lon"] = m["lon"], ["freq"] = m["freq"], ["fullname"] = m["fullname"], ["dist"] = d, ["tc"] = calc_true_course(latitude, longtitude, m["lat"], m["lon"], d)})
					end
				end
			end
		end
		-- search and save near VORs
		if vor and vor_by_index[i] ~= nil then 
			for n, m in pairs(vor_by_index[i]) do
				if m["icao"] ~= nil then 
					local d, foo = calc_range(latitude, longtitude, m["lat"], m["lon"])
					--print(m["icao"], d)
					if d <= range then
						--print("VOR", m["icao"], m["lat"], m["lon"], m["freq"], m["fullname"], d, calc_true_course(latitude, longtitude, m["lat"], m["lon"], d))
						table.insert(near_vor, {["icao"] = m["icao"], ["lat"] = m["lat"], ["lon"] = m["lon"], ["freq"] = m["freq"], ["fullname"] = m["fullname"], ["dist"] = d, ["tc"] = calc_true_course(latitude, longtitude, m["lat"], m["lon"], d)})
					end
				end
			end
		end
		-- search and save near FIXes
		if fix and fix_by_index[i] ~= nil then 
			for n, m in pairs(fix_by_index[i]) do
				if m["icao"] ~= nil then 
					local d, foo = calc_range(latitude, longtitude, m["lat"], m["lon"])
					if d <= range then
						--print(m["icao"], m["lat"], m["lon"], d, calc_true_course(latitude, longtitude, m["lat"], m["lon"], d))
						table.insert(near_fix, {["icao"] = m["icao"], ["lat"] = m["lat"], ["lon"] = m["lon"], ["dist"] = d, ["tc"] = calc_true_course(latitude, longtitude, m["lat"], m["lon"], d)})
					end
				end
			end
		end	
			
	end
	return true
end

-----------------------
function calc_range(lat1, lon1, lat2, lon2)
	local d = math.acos(math.sin(math.rad(lat1)) * math.sin(math.rad(lat2)) + math.cos(math.rad(lat1)) * math.cos(math.rad(lat2)) * math.cos(math.rad(lon1-lon2)))
	return math.deg(d) * 60, d -- in nm and radians
end
-----------------------
function calc_true_course(lat1, lon1, lat2, lon2, dist)
	-- dist must be in miles
	local tc = 0
	local foo, d = 0, 0
	
	if dist == nil then foo, d = calc_range(lat1, lon1, lat2, lon2) 
	else d = math.rad(dist / 60) end
	if d == 0 then return 0 end
	
	if lat1 > 89.9999 then tc = math.pi
	elseif lat1 < -89.9999 then tc = 0
	--[[elseif lat1 == lat2 then
		if lon1 < lon2 then tc = math.pi * 0.5
		elseif lon1 > lon2 then tc = math.pi * 1.5
		else tc = 0 end
	elseif lon1 == lon2 then
		if lat1 < lat2 then tc = 0
		elseif lat1 > lat2 then tc = math.pi
		else tc = 0 end--]]
	elseif math.sin(math.rad(lon2-lon1)) > 0 then
		tc = math.acos((math.sin(math.rad(lat2)) - math.sin(math.rad(lat1)) * math.cos(d)) / (math.sin(d) * math.cos(math.rad(lat1))))
	else
		tc = 2 * math.pi - math.acos((math.sin(math.rad(lat2)) - math.sin(math.rad(lat1)) * math.cos(d)) / (math.sin(d) * math.cos(math.rad(lat1))))  
	end
	return math.deg(tc) -- return degrees
	-- need to add cases when lat1 and lat2 are at different sides from 180/-180 line
end
-----------------
function flush_table(t)
	for i, n in pairs(t) do
		t[i] = nil
	end
	return true
end


-----------------
local CODE = ""

local notLoaded = false

function update()
	
	if not notLoaded then
		notLoaded = true
		read_nav_dat()
		read_fix_dat()
		
		-- example seasrch of NDBs by code
		--print("NDB")
		if ndb_by_code[CODE] ~= nil then
			for k, i in pairs(ndb_by_code[CODE]) do
				print("   ", i["fullname"], i["freq"], i["lat"], i["lon"])
			end
		end
		-- example search of VORs by code
		--print("VOR")
		if vor_by_code[CODE] ~= nil then
			for k, i in pairs(vor_by_code[CODE]) do
				print("   ", i["fullname"], i["freq"], i["lat"], i["lon"])
			end
		end
		
		
		-- example for select navaids at given point within given range
		calc_indecies(47.215539, 11.027839, 60)		
		select_navaids(47.215539, 11.027839, 60, true, true, true, true)
		
		-- make selection of navaids
		print("near NDB")
		for t, j in pairs(near_ndb) do
			if j["icao"] ~= nil then print("	", j["icao"], j["lat"], j["lon"], j["fullname"], j["dist"], j["tc"]) end
		end
		print("near VOR")
		for f, k in pairs(near_vor) do
			if k["icao"] ~= nil then print("	", k["icao"], k["lat"], k["lon"], k["fullname"], k["dist"], k["tc"]) end
		end
		print("near FIX")
		for l, o in pairs(near_fix) do
			if o["icao"] ~= nil then print("	", o["icao"], o["lat"], o["lon"], o["dist"], o["tc"]) end
		end	
		
		
	end
	
end