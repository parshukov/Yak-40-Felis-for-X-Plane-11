-- make table

local test = {}
local table_size = 500000

-- fill table
for i = 1, table_size, 1 do
	table.insert(test, {["lat"] =  (math.random()-0.5) * 180 , ["lon"] =  (math.random()-0.5) * 360})
end

--[[
-- make new table for selecting results
local sel_table = {}

-- fill table with selected elemets, that matches given criteria
for i, k in pairs(test) do
	if k["lat"] > 40 then table.insert(sel_table, {["lat"] = k["lat"], ["lon"] = k["lon"]}) end
end

-- print whole and selected tables
print("test")
for i, k in pairs(test) do
	print("lat", k["lat"], "\t lon", k["lon"])
end

print("sel_table")
for i, k in pairs(sel_table) do
	print("lat", k["lat"], "\t lon", k["lon"])
end

-- sort selected table by "lat" and print it. smaller - first
table.sort(sel_table, function(a,b) return a["lat"] < b["lat"] end)

print("sorted sel_table")
for i, k in pairs(sel_table) do
	print("lat", k["lat"], "\t lon", k["lon"])
end
--]]
-- try to create separate tables for indexes by 10 deg
local sorted_nav = {}
-- fill tables
for i = 1, 19, 1 do
	for k = 1, 37, 1 do
		sorted_nav[i*100+k] = {}
	end
end

-- write test table into indexed sorted_nav table
for i, k in pairs(test) do
	local num = (math.floor(k["lat"]/10)+10) * 100 + (math.floor(k["lon"]/10)+19)
	table.insert(sorted_nav[num], {["lat"] = k["lat"], ["lon"] = k["lon"]})
end
--[[

print("mega test")
for i, k in pairs(sorted_nav) do
	if k[i] then print("index", i) end
	for j, v in pairs(k) do
		if v["lat"] ~= nil and v["lon"] ~= nil then print("\t", i, v["lat"], v["lon"]) end
	end
end
--]]
print("select table")

-- let's search some point
local need_lat = 45.333
local need_long = 50.234
local range = 300 -- n-miles
local num_table = {}

-- search for corners of square over given range
--[[
-- corners of search rectangle
local max_lat = need_lat + range / 60
local min_lat = need_lat - range / 60
local high_max_lon = need_lon + range / 60 /math.cos(math.rad(max_lat))
local high_min_lon = need_lon - range / 60 /math.cos(math.rad(max_lat))
local low_max_lon = need_lon + range / 60 /math.cos(math.rad(min_lat))
local low_min_lon = need_lon - range / 60 /math.cos(math.rad(min_lat))
--]]

-- start point for search. moving right and down
local x = need_lat + range / 60
local y = need_lon - range / (60 * math.cos(math.rad(x)))
-- fill table with indexes
while true do
	-- check coordinates
	local a = x
	local b = y
	if a > 90 then 
		a = 180 - a
		b = b + 180
	elseif a < -90 then
		a = -180 - a
		b = b + 180	
	end
	if b > 180 then b = b - 360
	elseif b < -180 then b = b + 360 end
	
	-- insert number of index in table of indexes
	table.insert(num_table, (math.floor(a/10)+10) * 100 + (math.floor(b/10)+19))
	
	-- move search point to the right
	y = y + 10 
	-- if new coordinates are out of search area - move down or end circle
	if y > need_lon + range / (60 * math.cos(math.rad(x))) then 
		x = x - 10
		y = need_lon - range / (60 * math.cos(math.rad(x)))	
	end
	if x < need_lat - range / 60 then break end
end

-- make selection of coordinates
for t, j in pairs(num_table) do
	for i, k in pairs(sorted_nav[j]) do
		if k["lat"] ~= nil then print(k["lat"], k["lon"]) end
	end
end

--[[
-- select square near that coordinates within given range
local num = (math.floor(need_lat/10)+10) * 100 + (math.floor(need_long/10)+19)
for i, k in pairs(sorted_nav[num]) do
	print(i)
	if k["lat"] ~= nil then print(k["lat"], k["lon"]) end
end
--]]

















