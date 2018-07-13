-- this is outer air thermometer
size = {120, 120}

-- define property table
defineProperty("thermo", globalPropertyf("sim/cockpit2/temperature/outside_air_temp_degc")) -- outside temperature

defineProperty("needles_1", loadImage("needles.png", 0, 0, 16, 88)) -- needle image
defineProperty("black_cap", loadImage("covers.png", 0, 56, 52, 52))

-- table for termo gauge
local termo_table = {{ -500, -180},    
				  { -60, -100 },    
            	  {  -50, -90 },    
           		  {  0, -45 },   
          		  {  50, 8 },   
          		  {  100, 55 },
				  {  150, 97 },
				  {  1000, 180 }}  

-- interpolate values using table as reference
local function interpolate(tbl, value)
    local lastActual = 0
    local lastReference = 0
    for _k, v in pairs(tbl) do
        if value == v[1] then
            return v[2]
        end
        if value < v[1] then
            local a = value - lastActual
            local m = v[2] - lastReference
            return lastReference + a / (v[1] - lastActual) * m
        end
        lastActual = v[1]
        lastReference = v[2]
    end
    return value - lastActual + lastReference
end

local termo_angle = 0

function update()

	-- thermometer gauge
	termo_angle = interpolate(termo_table, get(thermo))

end



components = {

	-- thermoneter
	needle { 
		image = get(needles_1),
		position = {0, 0, 120, 120},
		angle = function()
			return termo_angle
		end,
	},

	-- cover
	texture {
		position = { 35, 35, 50, 50 },
		image = get(black_cap),
	},
	
}







