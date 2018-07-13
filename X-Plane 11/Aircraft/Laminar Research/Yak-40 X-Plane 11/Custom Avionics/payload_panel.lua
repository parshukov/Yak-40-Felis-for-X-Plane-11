size = {710, 990}

defineProperty("payload_subpanel", globalPropertyi("sim/custom/xap/panels/payload"))

-- sim load
defineProperty("payload", globalPropertyf("sim/flightmodel/weight/m_fixed"))  -- payload weight, kg
defineProperty("CG_load", globalPropertyf("sim/flightmodel/misc/cgz_ref_to_default")) -- Center of Gravity reference to default, m
defineProperty("fuel_q_1", globalPropertyf("sim/flightmodel/weight/m_fuel[0]")) -- fuel quantity for tank 1
defineProperty("fuel_q_2", globalPropertyf("sim/flightmodel/weight/m_fuel[1]")) -- fuel quantity for tank 2


-- images
defineProperty("background", loadImage("payload_panel.png", 5, 3, size[1], size[2]))
defineProperty("vert_plank", loadImage("payload_panel.png", 719, 5, 2, 100))
defineProperty("vert_plank2", loadImage("payload_panel.png", 723, 5, 2, 100))
defineProperty("hor_plank_green", loadImage("payload_panel.png", 730, 2, 100, 2))
defineProperty("hor_plank_orange", loadImage("payload_panel.png", 730, 8, 100, 2))
defineProperty("red_flag", loadImage("payload_panel.png", 734, 22, 70, 25))

-- digits images
defineProperty("digitsImage", loadImage("black_digit_strip.png", 1, 0, 14, 196))


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

-- interpolate distance to fuel quantity
local distance_tbl = {{ 0.00, 0 },
                  {  2500, 4000 },  
                  {  5000, 8000 }}    

				  

-- define variables
--local empty_plane_weight = 10120 -- kg
local empty_plane_weight = 9212 -- kg
local prepared_plane_weight = empty_plane_weight + 185
--local empty_CG = 22 -- %MAC
local max_plane_weight = 17200 -- kg

local flight_distance = 900 -- km
local reserv_distance = 200 -- km
local fuel_stock = 600 -- kg
local fuel_nonused = 64 -- kg

local crew_weight = 240 -- kg
local stuard_weight = 75 -- kg
local used_fuel = interpolate(distance_tbl, flight_distance) 
local fuel_weight = fuel_stock + used_fuel + fuel_nonused + interpolate(distance_tbl, reserv_distance) -- kg
local loaded_plane_weight = prepared_plane_weight + crew_weight + stuard_weight + fuel_weight 
local max_payload = max_plane_weight - loaded_plane_weight

local row_1_mass = 0
local row_2_mass = 150
local row_3_mass = 300
local row_4_mass = 300
local row_5_mass = 300
local row_6_mass = 300
local row_7_mass = 300
local row_8_mass = 600

local all_pax_mass = row_1_mass + row_2_mass + row_3_mass + row_4_mass + row_5_mass + row_6_mass + row_7_mass + row_8_mass

local cargo_1 = 600
local cargo_2 = 0

local airplane_weight = loaded_plane_weight + all_pax_mass + cargo_1 + cargo_2
local comercial_payload = all_pax_mass + cargo_1
local landing_weight = airplane_weight - used_fuel

local pos1 = 326  -- initial position in pixels
local pos2 = pos1
local pos3 = pos2
local pos4 = pos3
local pos5 = pos4
local pos6 = pos5
local pos7 = pos6
local pos8 = pos7
local pos9 = pos8
local pos10 = pos9
local pos11 = pos10
local empty_fuel_pos = pos10
local empty_fuel_cargo2 = pos11

local show_all_pax = false
local fuel_show_row = 1

local pos10_show = pos10
local pos11_show = pos11


local takeoff_weight_plank = 245
local landing_weight_plank = 245





local to_weight_flag = false
local fuel_flag = false
local to_cg_flag = false
local lan_cg_flag = false
local empty_cg_flag = false
local to_CG = 15
local lan_CG = 15
local empty_fuel_CG = 15


local function fuel_diff(weight, load)
	local move = 0
	local row = 1
	if load then 
		if weight <= 2100 then 
			move = 0.0168 * weight
			row = 1
		else 
			move = 0.0104 * weight
			row = 3
		end
	else
		if weight <= 500 then
			move = 0.0086 * weight
			row = 2		
		else
			move = 0.0168 * weight
			row = 1		
		end	
	end
	return move, row
end

local function calc_CG(acf_weight, plank_pos) -- try to unify calculations of CG by diagramm
	
	local MID_CG = 36 -- %MAC, centerline of diagramm
	local MID_CG_POS = 400 -- position of middle in pixels CG on diagramm
	local MIN_WEIGHT = 9000 -- mininmum weight on diagramm, kg
	local MAX_WEIGHT = 17000 -- maximum weight on diagramm, kg
	local MAX_WEIGHT_POS = 192 -- position of max weight in pixels on diagramm
	local MIN_CG = 13 -- minimum CG on diagramm
	local LOW_CG_SCALE = 218 -- low scale lenght in pixels of diagramm
	local HIGH_CG_SCALE = 409 -- high scale lenght in pixels of diagramm
	
	-- calculate pixel position of weight on diagramm
	local z = (acf_weight - MIN_WEIGHT) * MAX_WEIGHT_POS / (MAX_WEIGHT - MIN_WEIGHT)  
	
	-- calculate CG in pixels from middle line
	local b = ((MID_CG_POS - plank_pos) * LOW_CG_SCALE * MAX_WEIGHT_POS) / (z * HIGH_CG_SCALE - z * LOW_CG_SCALE + LOW_CG_SCALE * MAX_WEIGHT_POS)
	
	-- calculate CG in % of MAC
	local result_CG = MID_CG - b * (MID_CG - MIN_CG) / LOW_CG_SCALE
--[[	
	local A = HIGH_CG_SCALE
	local B = LOW_CG_SCALE
	local x = MID_CG_POS - plank_pos
	local C = MAX_WEIGHT_POS
	local z = (acf_weight - MIN_WEIGHT) * MAX_WEIGHT_POS / (MAX_WEIGHT - MIN_WEIGHT)
	
	-- calculate CG in pixels from middle line
	local b = (x * B * C) / (z * A - z * B + B * C)
--]]	
	
	return result_CG

end


local function recalc()
	-- recalculate masses
	prepared_plane_weight = empty_plane_weight + 185
	used_fuel = interpolate(distance_tbl, flight_distance) 
	fuel_weight = fuel_stock + used_fuel + fuel_nonused + interpolate(distance_tbl, reserv_distance) -- kg
	if fuel_weight > 4400 then 
		fuel_weight = 4400
		fuel_flag = true
	else
		fuel_flag = false
	end
	loaded_plane_weight = prepared_plane_weight + crew_weight + stuard_weight + fuel_weight 
	max_payload = max_plane_weight - loaded_plane_weight

	
	all_pax_mass = row_1_mass + row_2_mass + row_3_mass + row_4_mass + row_5_mass + row_6_mass + row_7_mass + row_8_mass
	airplane_weight = loaded_plane_weight + all_pax_mass + cargo_1 + cargo_2
	comercial_payload = all_pax_mass + cargo_1
	landing_weight = airplane_weight - used_fuel
	
	-- calculate CG position
	pos1 = 390 - crew_weight * 0.275
	pos2 = pos1 - row_1_mass * 0.2146667
	pos3 = pos2 - row_2_mass * 0.1866667
	pos4 = pos3 - row_3_mass * 0.1573333
	pos5 = pos4 - row_4_mass * 0.1293333
	pos6 = pos5 - row_5_mass * 0.1
	pos7 = pos6 - row_6_mass * 0.072
	pos8 = pos7 - row_7_mass * 0.0433333
	pos9 = pos8 + cargo_1 * 0.0355
	local fuel_load_pos = 0 -- calculate fuel plank moving and row, where we'll show digits
	fuel_load_pos, fuel_show_row = fuel_diff(fuel_weight, true)
	pos10 = pos9 - fuel_load_pos
	pos11 = pos10 - cargo_2 * 0.202
	
	local eat_fuel, foo = fuel_diff(used_fuel, false)
	empty_fuel_pos = pos10 + eat_fuel
	empty_fuel_cargo2 = empty_fuel_pos - cargo_2 * 0.202
	
	-- limit some planks
	if pos10 > 0 then pos10_show = pos10 else pos10_show = 0 end
	if pos11 > 0 then pos11_show = pos11 else pos11_show = 0 end
	if empty_fuel_pos < 0 then empty_fuel_pos = 0
	elseif empty_fuel_pos > pos9 then empty_fuel_pos = pos9 end
	if empty_fuel_cargo2 < 0 then empty_fuel_cargo2 = 0
	elseif empty_fuel_cargo2 > empty_fuel_pos then empty_fuel_cargo2 = empty_fuel_pos end
	
	-- calculate horisontal planks
	takeoff_weight_plank = 284 + (airplane_weight - 9000) * 0.024
	if takeoff_weight_plank > 476 then takeoff_weight_plank = 476 end
	
	landing_weight_plank = 284 + (landing_weight - 9000) * 0.024
	if landing_weight_plank > 476 then landing_weight_plank = 476 end
	
	-- calculate CG
	to_CG = calc_CG(airplane_weight, pos11)
	lan_CG = calc_CG(landing_weight, empty_fuel_cargo2)
	empty_fuel_CG = calc_CG(airplane_weight - fuel_weight, pos11 + fuel_diff(fuel_weight, true))
	
	-- red falgs logic
	to_weight_flag = airplane_weight > max_plane_weight
	to_cg_flag = to_CG < 13 or to_CG > 32
	lan_cg_flag = lan_CG < 13 or lan_CG > 32
	empty_cg_flag = empty_fuel_CG < 13 or empty_fuel_CG > 32

	
end

local notLoaded = true

function update()
	-- initial calculations
	if notLoaded then
		recalc()
		set(fuel_q_1, fuel_weight * 0.5)
		set(fuel_q_2, fuel_weight * 0.5)
		set(payload, comercial_payload + crew_weight + stuard_weight)
		local acf_CG_meters = -(13 - empty_fuel_CG) * 0.0158 -- moving of CG in meters. CG range = 13-32 and lenght - 0.3m 0.3/19 = 0.0158
		set(CG_load, acf_CG_meters)
		notLoaded = false
	end
end

-- components of panel
components = {


	-- background
	texture {
		image = get(background),
		position = {0, 0, size[1], size[2]},

	},


	-----------------
	-- red flags --
	----------------
	-- acf weight flag
	texture {
		image = get(red_flag),
		position = {228, 68, 78, 15},
		visible = function()
			return to_weight_flag
		end
	},

	-- fuel weight flag
	texture {
		image = get(red_flag),
		position = {600, 810, 80, 20},
		visible = function()
			return fuel_flag
		end
	},

	-- TO CG flag
	texture {
		image = get(red_flag),
		position = {585, 63, 65, 24},
		visible = function()
			return to_cg_flag
		end
	},

	-- Lan CG flag
	texture {
		image = get(red_flag),
		position = {585, 38, 65, 23},
		visible = function()
			return lan_cg_flag
		end
	},

	-- Empty fuel CG flag
	texture {
		image = get(red_flag),
		position = {585, 89, 65, 24},
		visible = function()
			return empty_cg_flag
		end
	},

	
	-------------------------
	-- diagramm planks --
	------------------------

    -- crew_weight plank
    free_texture {
        image = get(vert_plank),
        position_x = function() 
             return 180 + pos1
        end,
        position_y = 730,
        width = 3,
        height = 22,		
    },

    -- row_1_mass plank
    free_texture {
        image = get(vert_plank),
        position_x = function() 
             return 180 + pos2
        end,
        position_y = 705,
        width = 3,
        height = 26,
		visible = function()
			return not show_all_pax
		end,
    },

    -- row_2_mass plank
    free_texture {
        image = get(vert_plank),
        position_x = function() 
             return 180 + pos3
        end,
        position_y = 690,
        width = 3,
        height = 16,
		visible = function()
			return not show_all_pax
		end,
    },
	
    -- row_3_mass plank
    free_texture {
        image = get(vert_plank),
        position_x = function() 
             return 180 + pos4
        end,
        position_y = 676,
        width = 3,
        height = 14,
		visible = function()
			return not show_all_pax
		end,
    },	
	
    -- row_4_mass plank
    free_texture {
        image = get(vert_plank),
        position_x = function() 
             return 180 + pos5
        end,
        position_y = 662,
        width = 3,
        height = 14,
		visible = function()
			return not show_all_pax
		end,
    },	
	
    -- row_5_mass plank
    free_texture {
        image = get(vert_plank),
        position_x = function() 
             return 180 + pos6
        end,
        position_y = 648,
        width = 3,
        height = 14,
		visible = function()
			return not show_all_pax
		end,
    },	
	
    -- row_6_mass plank
    free_texture {
        image = get(vert_plank),
        position_x = function() 
             return 180 + pos7
        end,
        position_y = 634,
        width = 3,
        height = 14,
		visible = function()
			return not show_all_pax
		end,
    },	
	
    -- row_7_mass plank
    free_texture {
        image = get(vert_plank),
        position_x = function() 
             return 180 + pos8
        end,
        position_y = 594,
        width = 3,
        height = 40,
		visible = function()
			return not show_all_pax
		end,
    },	
	
	-- rows 8 and 9 don't affect CG move
	
    -- all pax plank
    free_texture {
        image = get(vert_plank),
        position_x = function() 
             return 180 + pos8
        end,
        position_y = 594,
        width = 3,
        height = 137,
		visible = function()
			return show_all_pax
		end
    },	
	
    -- cargo_1 plank
    free_texture {
        image = get(vert_plank),
        position_x = function() 
             return 180 + pos9
        end,
        position_y = 580,
        width = 3,
        height = 14,
    },	

    -- empty_fuel_pos plank
    free_texture {
        image = get(vert_plank2),
        position_x = function() 
             return 180 + empty_fuel_pos
        end,
        position_y = 539,
        width = 3,
        height = 41,
    },
	
    -- empty_fuel_cargo2 plank
    free_texture {
        image = get(vert_plank2),
        position_x = function() 
             return 180 + empty_fuel_cargo2
        end,
        position_y = 283,
        width = 3,
        height = 257,
    },
	
    -- fuel_load_pos plank
    free_texture {
        image = get(vert_plank),
        position_x = function() 
             return 180 + pos10_show -- pos10
        end,
        position_y = 539,
        width = 3,
        height = 41,
    },
	
    -- cargo_2 plank
    free_texture {
        image = get(vert_plank),
        position_x = function() 
             return 180 + pos11_show --pos11
        end,
        position_y = 283,
        width = 3,
        height = 257,
    },
	


	-------------------
	-- weight planks --
	-------------------
    -- aircraft weight at landing
    free_texture {
        image = get(hor_plank_orange),
        position_x = 150, 
        position_y = function()
			return landing_weight_plank
        end,
        width = 470,
        height = 3, 
    },  

 -- aircraft weight
    free_texture {
        image = get(hor_plank_green),
        position_x = 150, 
        position_y = function()
			return takeoff_weight_plank
        end,
        width = 470,
        height = 3, 
    }, 

	
	-------------------------
	-- begining digits --
	-------------------------
	
	-- empty plane weight
   digitstape {
        position = { 340, 904, 72, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return prepared_plane_weight
        end;
    }; 

	-- crew weight
   digitstape {
        position = { 340, 888, 72, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return crew_weight
        end;
    }; 

	-- stuard weight
   digitstape {
        position = { 340, 873, 72, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return stuard_weight
        end;
    }; 

	-- fuel weight
   digitstape {
        position = { 340, 857, 72, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return fuel_weight
        end;
    }; 

	-- maximum TOW
   digitstape {
        position = { 340, 841, 72, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return max_plane_weight
        end;
    }; 

	-- prepared plane weight
   digitstape {
        position = { 340, 826, 72, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return loaded_plane_weight
        end;
    }; 

	-- max payload weight
   digitstape {
        position = { 340, 810, 72, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return max_payload
        end;
    }; 


	--------------------
	-- distance to destination AP
   digitstape {
        position = { 600, 900, 72, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return flight_distance
        end;
    };

	-- distance to reserve AP
   digitstape {
        position = { 600, 878, 72, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return reserv_distance
        end;
    };	
	
	-- fuel stock
   digitstape {
        position = { 600, 857, 72, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return fuel_stock
        end;
    };	

	-- fuel nonused
   digitstape {
        position = { 600, 835, 72, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return fuel_nonused
        end;
    };	

	-- fuel loaded
   digitstape {
        position = { 600, 813, 72, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return fuel_weight
        end;
    };	

	-----------------------
	-- mass digits --
	-----------------------
	
	-- crew weight
   digitstape {
        position = { 620, 737, 60, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return crew_weight
        end;
    }; 	

	-- all pax weight
   digitstape {
        position = { 620, 723, 60, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return all_pax_mass
        end;
		visible = function()
			return show_all_pax
		end
    }; 

	-- row_1_mass weight
   digitstape {
        position = { 620, 709, 60, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return row_1_mass
        end;
		visible = function()
			return not show_all_pax
		end
    }; 

	-- row_2_mass weight
   digitstape {
        position = { 620, 695, 60, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return row_2_mass
        end;
		visible = function()
			return not show_all_pax
		end
    }; 

	-- row_3_mass weight
   digitstape {
        position = { 620, 681, 60, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return row_3_mass
        end;
		visible = function()
			return not show_all_pax
		end
    };

	-- row_4_mass weight
   digitstape {
        position = { 620, 667, 60, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return row_4_mass
        end;
		visible = function()
			return not show_all_pax
		end
    };

	-- row_5_mass weight
   digitstape {
        position = { 620, 653, 60, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return row_5_mass
        end;
		visible = function()
			return not show_all_pax
		end
    };

	-- row_6_mass weight
   digitstape {
        position = { 620, 640, 60, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return row_6_mass
        end;
		visible = function()
			return not show_all_pax
		end
    };

	-- row_7_mass weight
   digitstape {
        position = { 620, 626, 60, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return row_7_mass
        end;
		visible = function()
			return not show_all_pax
		end
    };

	-- row_8_mass weight
   digitstape {
        position = { 620, 612, 60, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return row_8_mass
        end;
		visible = function()
			return not show_all_pax
		end
    };	
	
	-- cargo_1 weight
   digitstape {
        position = { 620, 584, 60, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return cargo_1
        end;
    };	
	
	-- fuel 1 weight
   digitstape {
        position = { 620, 570, 60, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return fuel_weight
        end;
		visible = function()
			return fuel_show_row == 1
		end
    };		
	
	-- fuel 2 weight
   digitstape {
        position = { 620, 543, 60, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return fuel_weight
        end;
		visible = function()
			return fuel_show_row == 3
		end
    };	
	
	-- cargo_2 weight
   digitstape {
        position = { 620, 529, 60, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return cargo_2
        end;
    };	
	
	







	-----------------------
	-- rows digits --
	-----------------------
	
	-- crew weight
   digitstape {
        position = { 107, 737, 15, 15};
        image = digitsImage;
        digits = 1;
        allowNonRound = true;
        value = function() 
            return crew_weight / 80
        end;
    }; 	

	-- all pax weight
   digitstape {
        position = { 103, 723, 27, 15};
        image = digitsImage;
        digits = 2;
        allowNonRound = true;
        value = function() 
            return all_pax_mass / 75
        end;
    }; 

	-- row_1_mass weight
   digitstape {
        position = { 107, 709, 15, 15};
        image = digitsImage;
        digits = 1;
        allowNonRound = true;
        value = function() 
            return row_1_mass / 75
        end;
    }; 

	-- row_2_mass weight
   digitstape {
        position = { 107, 695, 15, 15};
        image = digitsImage;
        digits = 1;
        allowNonRound = true;
        value = function() 
            return row_2_mass / 75
        end;
    }; 

	-- row_3_mass weight
   digitstape {
        position = {107, 681, 15, 15};
        image = digitsImage;
        digits = 1;
        allowNonRound = true;
        value = function() 
            return row_3_mass / 75
        end;
    };

	-- row_4_mass weight
   digitstape {
        position = { 107, 667, 15, 15};
        image = digitsImage;
        digits = 1;
        allowNonRound = true;
        value = function() 
            return row_4_mass / 75
        end;
    };

	-- row_5_mass weight
   digitstape {
        position = { 107, 653, 15, 15};
        image = digitsImage;
        digits = 1;
        allowNonRound = true;
        value = function() 
            return row_5_mass / 75
        end;
    };

	-- row_6_mass weight
   digitstape {
        position = { 107, 640, 15, 15};
        image = digitsImage;
        digits = 1;
        allowNonRound = true;
        value = function() 
            return row_6_mass / 75
        end;
    };

	-- row_7_mass weight
   digitstape {
        position = { 107, 626, 15, 15};
        image = digitsImage;
        digits = 1;
        allowNonRound = true;
        value = function() 
            return row_7_mass / 75
        end;
    };

	-- row_8_mass weight
   digitstape {
        position = { 107, 612, 15, 15};
        image = digitsImage;
        digits = 1;
        allowNonRound = true;
        value = function() 
            return row_8_mass / 75
        end;
    };	
	
	-- cargo_1 weight
   digitstape {
        position = { 100, 584, 35, 15};
        image = digitsImage;
        digits = 3;
        allowNonRound = true;
        value = function() 
            return cargo_1
        end;
    };	
	
	-- cargo_2 weight
   digitstape {
        position = { 100, 529, 35, 15};
        image = digitsImage;
        digits = 3;
        allowNonRound = true;
        value = function() 
            return cargo_2
        end;
    };	

	-------------------------
	-- result digits --
	-------------------------
	
	-- prepared plane weight
   digitstape {
        position = { 228, 99, 78, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return loaded_plane_weight
        end;
    };

	-- payload weight
   digitstape {
        position = { 228, 84, 78, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return comercial_payload
        end;
    };

	-- takeoff weight
   digitstape {
        position = { 228, 68, 78, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return airplane_weight
        end;
    };

	-- fuel weight
   digitstape {
        position = { 228, 53, 78, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return used_fuel
        end;
    };	

	-- landing weight
   digitstape {
        position = { 228, 38, 78, 15};
        image = digitsImage;
        digits = 5;
        allowNonRound = true;
        value = function() 
            return landing_weight
        end;
    };

	----------------------
	-- result CG digits --
	----------------------
	
	-- takeoff CG
   digitstape {
        position = { 590, 63, 55, 25};
        image = digitsImage;
        digits = 3;
		fractional = 1;
        allowNonRound = true;
        value = function() 
            return to_CG
        end;
    };	

	-- landing CG
   digitstape {
        position = { 590, 38, 55, 25};
        image = digitsImage;
        digits = 3;
		fractional = 1;
        allowNonRound = true;
        value = function() 
            return lan_CG
        end;
    };	
	
	-- empty fuel CG
   digitstape {
        position = { 590, 89, 55, 25};
        image = digitsImage;
        digits = 3;
		fractional = 1;
        allowNonRound = true;
        value = function() 
            return empty_fuel_CG
        end;
    };	

	-----------------
	-- clickables --
	-----------------
	
   -- clickable area for decrement crew_weight
    clickable {
       position = { 95, 738, 20, 14 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function()
			crew_weight = crew_weight - 80
			if crew_weight < 80 then crew_weight = 80 end
			recalc()
			return true
        end
    },

   -- clickable area for increment crew_weight
    clickable {
       position = { 117, 738, 20, 14 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function()
			crew_weight = crew_weight + 80
			if crew_weight > 240 then crew_weight = 240 end
			recalc()
			return true
        end
    },
	-------------------------
   -- clickable area for decrement all pax mass
    clickable {
       position = { 95, 723, 20, 14 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function()
			row_1_mass = 0
			row_2_mass = 0
			row_3_mass = 0
			row_4_mass = 0
			row_5_mass = 0
			row_6_mass = 0
			row_7_mass = 0
			row_8_mass = 0
			show_all_pax = false
			recalc()
			return true
        end
    },

   -- clickable area for increment all pax mass
    clickable {
       position = { 117, 723, 20, 14 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function()
			row_1_mass = 300
			row_2_mass = 300
			row_3_mass = 300
			row_4_mass = 300
			row_5_mass = 300
			row_6_mass = 300
			row_7_mass = 300
			row_8_mass = 600
			show_all_pax = true
			recalc()
			return true
        end
    },
	-------------------------
   -- clickable area for decrement row_1_mass
    clickable {
       position = { 95, 709, 20, 14 },
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function()
			row_1_mass = row_1_mass - 75
			if row_1_mass < 0 then row_1_mass = 0 end
			show_all_pax = false
			recalc()
        return true
        end
    },	
	
   -- clickable area for increment row_1_mass
    clickable {
       position = { 117, 709, 20, 14 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function()
			row_1_mass = row_1_mass + 75
			if row_1_mass > 300 then row_1_mass = 300 end
			show_all_pax = false
			recalc()
        return true
        end
    },	
	----------------------
   -- clickable area for decrement row_2_mass
    clickable {
       position = { 95, 695, 20, 14 },
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function()
			row_2_mass = row_2_mass - 75
			if row_2_mass < 0 then row_2_mass = 0 end
			show_all_pax = false
			recalc()
        return true
        end
    },	
	
   -- clickable area for increment row_2_mass
    clickable {
       position = { 117, 695, 20, 14 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function()
			row_2_mass = row_2_mass + 75
			if row_2_mass > 300 then row_2_mass = 300 end
			show_all_pax = false
			recalc()
        return true
        end
    },	
	----------------------
   -- clickable area for decrement row_3_mass
    clickable {
       position = { 95, 681, 20, 14 },
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function()
			row_3_mass = row_3_mass - 75
			if row_3_mass < 0 then row_3_mass = 0 end
			show_all_pax = false
			recalc()
        return true
        end
    },	
	
   -- clickable area for increment row_3_mass
    clickable {
       position = { 117, 681, 20, 14 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function()
			row_3_mass = row_3_mass + 75
			if row_3_mass > 300 then row_3_mass = 300 end
			show_all_pax = false
			recalc()
        return true
        end
    },	
	----------------------
   -- clickable area for decrement row_4_mass
    clickable {
       position = { 95, 667, 20, 14 },
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function()
			row_4_mass = row_4_mass - 75
			if row_4_mass < 0 then row_4_mass = 0 end
			show_all_pax = false
			recalc()
        return true
        end
    },	
	
   -- clickable area for increment row_4_mass
    clickable {
       position = { 117, 667, 20, 14 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function()
			row_4_mass = row_4_mass + 75
			if row_4_mass > 300 then row_4_mass = 300 end
			show_all_pax = false
			recalc()
        return true
        end
    },	
	----------------------
   -- clickable area for decrement row_5_mass
    clickable {
       position = { 95, 653, 20, 14 },
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function()
			row_5_mass = row_5_mass - 75
			if row_5_mass < 0 then row_5_mass = 0 end
			show_all_pax = false
			recalc()
        return true
        end
    },	
	
   -- clickable area for increment row_5_mass
    clickable {
       position = { 117, 653, 20, 14 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function()
			row_5_mass = row_5_mass + 75
			if row_5_mass > 300 then row_5_mass = 300 end
			show_all_pax = false
			recalc()
        return true
        end
    },	
	----------------------
   -- clickable area for decrement row_6_mass
    clickable {
       position = { 95, 640, 20, 14 },
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function()
			row_6_mass = row_6_mass - 75
			if row_6_mass < 0 then row_6_mass = 0 end
			show_all_pax = false
			recalc()
        return true
        end
    },	
	
   -- clickable area for increment row_6_mass
    clickable {
       position = { 117, 640, 20, 14 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function()
			row_6_mass = row_6_mass + 75
			if row_6_mass > 300 then row_6_mass = 300 end
			show_all_pax = false
			recalc()
        return true
        end
    },	
	----------------------
   -- clickable area for decrement row_7_mass
    clickable {
       position = { 95, 626, 20, 14 },
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function()
			row_7_mass = row_7_mass - 75
			if row_7_mass < 0 then row_7_mass = 0 end
			show_all_pax = false
			recalc()
        return true
        end
    },	
	
   -- clickable area for increment row_7_mass
    clickable {
       position = { 117, 626, 20, 14 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function()
			row_7_mass = row_7_mass + 75
			if row_7_mass > 300 then row_7_mass = 300 end
			show_all_pax = false
			recalc()
        return true
        end
    },	
	----------------------
   -- clickable area for decrement row_8_mass
    clickable {
       position = { 95, 612, 20, 14 },
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function()
			row_8_mass = row_8_mass - 75
			if row_8_mass < 0 then row_8_mass = 0 end
			show_all_pax = false
			recalc()
        return true
        end
    },	
	
   -- clickable area for increment row_8_mass
    clickable {
       position = { 117, 612, 20, 14 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function()
			row_8_mass = row_8_mass + 75
			if row_8_mass > 600 then row_8_mass = 600 end
			show_all_pax = false
			recalc()
        return true
        end
    },	
	----------------------
   -- clickable area for decrement cargo_1
    clickable {
       position = { 95, 584, 20, 14 },
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function()
			cargo_1 = cargo_1 - 20
			if cargo_1 < 0 then cargo_1 = 0 end
			recalc()
        return true
        end
    },	
	
   -- clickable area for increment cargo_1
    clickable {
       position = { 117, 584, 20, 14 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function()
			cargo_1 = cargo_1 + 20
			if cargo_1 > 720 then cargo_1 = 720 end
			recalc()
        return true
        end
    },	
	----------------------
   -- clickable area for decrement cargo_2
    clickable {
       position = { 95, 529, 20, 14 },
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function()
			cargo_2 = cargo_2 - 25
			if cargo_2 < 0 then cargo_2 = 0 end
			recalc()
        return true
        end
    },	
	
   -- clickable area for increment cargo_2
    clickable {
       position = { 117, 529, 20, 14 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function()
			if pos11 > 1 then cargo_2 = cargo_2 + 25 end
			if cargo_2 > 900 then cargo_2 = 900 end
			recalc()
        return true
        end
    },	
	----------------------

	--------------------------
	-- fuel calculator --
	--------------------------

	
   -- clickable area for decrement destination distance
    clickable {
       position = { 600, 898, 30, 20},
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function()
			flight_distance = flight_distance - 50
			if flight_distance < 0 then flight_distance = 0 end
			recalc()
        return true
        end
    },	
	
   -- clickable area for increment destination distance
    clickable {
       position = { 650, 898, 30, 20 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function()
			flight_distance = flight_distance + 50
			if flight_distance > 2500 then flight_distance = 2500 end
			recalc()
        return true
        end
    },	
	----------------------	
   -- clickable area for decrement reserve distance
    clickable {
       position = { 600, 877, 30, 20},
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function()
			reserv_distance = reserv_distance - 50
			if reserv_distance < 0 then reserv_distance = 0 end
			recalc()
        return true
        end
    },	
	
   -- clickable area for increment reserve distance
    clickable {
       position = { 650, 877, 30, 20 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function()
			reserv_distance = reserv_distance + 50
			if reserv_distance > 2500 then reserv_distance = 2500 end
			recalc()
        return true
        end
    },	
	----------------------		
   -- clickable area for decrement fuel stock
    clickable {
       position = { 600, 855, 30, 20},
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },  
        
        onMouseClick = function()
			fuel_stock = fuel_stock - 50
			if fuel_stock < 0 then fuel_stock = 0 end
			recalc()
        return true
        end
    },	
	
   -- clickable area for increment fuel stock
    clickable {
       position = { 650, 855, 30, 20 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },  
        
        onMouseClick = function()
			fuel_stock = fuel_stock + 50
			if fuel_stock > 1000 then fuel_stock = 1000 end
			recalc()
        return true
        end
    },	
	----------------------	
	
   -- clickable area for store results into sim
    clickable {
       position = { 460, 125, 200, 50 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
        onMouseClick = function()
			set(fuel_q_1, fuel_weight * 0.5)
			set(fuel_q_2, fuel_weight * 0.5)
			set(payload, comercial_payload + crew_weight + stuard_weight)
			local acf_CG_meters = -(13 - empty_fuel_CG) * 0.0158 -- moving of CG in meters
			set(CG_load, acf_CG_meters)
			set(payload_subpanel, 0 ) -- close panel
        return true
        end
    },	
	
	
	
	
	
	



	
	
   -- clickable area for closing panel
    clickable {
       position = { size[1]-20, size[2]-20, 20, 20 },
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
        onMouseClick = function()
        set(payload_subpanel, 0 )
        return true
        end
    },	

}



