-- this is EFIS map controls
size = {2048, 2048}

-- sim variables
defineProperty("map_mode", globalPropertyi("sim/cockpit2/EFIS/map_mode"))
defineProperty("map_mode_is_HSI", globalPropertyi("sim/cockpit2/EFIS/map_mode_is_HSI"))
defineProperty("map_range", globalPropertyi("sim/cockpit/switches/EFIS_map_range_selector"))

defineProperty("EFIS_weather_on", globalPropertyi("sim/cockpit2/EFIS/EFIS_weather_on"))
defineProperty("EFIS_tcas_on", globalPropertyi("sim/cockpit2/EFIS/EFIS_tcas_on"))
defineProperty("EFIS_airport_on", globalPropertyi("sim/cockpit2/EFIS/EFIS_airport_on"))
defineProperty("EFIS_vor_on", globalPropertyi("sim/cockpit2/EFIS/EFIS_vor_on"))
defineProperty("EFIS_ndb_on", globalPropertyi("sim/cockpit2/EFIS/EFIS_ndb_on"))

defineProperty("EFIS_fix_on", globalPropertyi("sim/cockpit2/EFIS/EFIS_fix_on"))
defineProperty("EFIS_page", globalPropertyi("sim/cockpit2/EFIS/EFIS_page"))
defineProperty("EFIS_fail", globalPropertyi("sim/operation/failures/rel_efis_2"))

defineProperty("kontur_power", globalPropertyi("sim/custom/xap/gauges/kontur_power"))
defineProperty("kontur_brt", globalPropertyf("sim/custom/xap/gauges/kontur_brt"))

defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("inv_PO1500_steklo", globalPropertyi("sim/custom/xap/power/inv_PO1500_steklo")) -- inverter for 115v bus

defineProperty("efis_cc", globalPropertyf("sim/custom/xap/gauges/efis_cc")) -- cc



defineProperty("fail", loadImage("lamps2.png", 52, 84, 36, 14))

defineProperty("wxr", loadImage("lamps2.png", 52, 100, 32, 12))
defineProperty("nav", loadImage("lamps2.png", 52, 115, 32, 12))
defineProperty("tcas", loadImage("lamps2.png", 86, 100, 32, 12))
defineProperty("rng", loadImage("lamps2.png", 86, 115, 32, 12))

defineProperty("nm5", loadImage("lamps2.png", 129, 100, 32, 12))
defineProperty("nm10", loadImage("lamps2.png", 127, 115, 37, 12))
defineProperty("nm20", loadImage("lamps2.png", 169, 100, 38, 12))
defineProperty("nm40", loadImage("lamps2.png", 169, 115, 38, 12))
defineProperty("nm80", loadImage("lamps2.png", 212, 100, 38, 12))
defineProperty("nm160", loadImage("lamps2.png", 209, 115, 44, 12))
defineProperty("nm320", loadImage("lamps2.png", 209, 85, 44, 12))

defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames

defineProperty("N1", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[1]"))   
defineProperty("N2", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[0]"))
defineProperty("N3", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[2]"))


-- sounds
local btn_click = loadSample('Custom Sounds/plastic_btn.wav')
local button_clicked = false

local powerClicked = false
local power_timer = 0
local brightness = 1 - get(kontur_brt)

local wxr_lit = false
local nav_lit = false
local tcas_lit = false
local fail_lit = false

local start_counter = 0
local notLoaded = true 

local range = get(map_range)

function update()
	-- lock some variables
	set(map_mode, 1)
	set(map_mode_is_HSI, 0)
	set(EFIS_fix_on, 0)
	set(EFIS_page, 0)

	local passed = get(frame_time)

    start_counter = start_counter + passed	
    
    -- initial switchers position
	if start_counter > 0.3 and start_counter < 0.5 and notLoaded and get(N1) < 10 and get(N2) < 10 and get(N3) < 10 then
		set(kontur_power, 0)
		notLoaded = false
	end
	-- calculate power
	local power = get(kontur_power) == 1 and get(DC_27_volt) > 21 and get(inv_PO1500_steklo) == 1
	
	-- set lamps
	if power then 
		brightness = 1 - get(kontur_brt)
		wxr_lit = get(EFIS_weather_on) == 1
		nav_lit = get(EFIS_airport_on) == 1
		tcas_lit = get(EFIS_tcas_on) == 1
		range = get(map_range) - 2
		fail_lit = get(EFIS_fail) == 6
		set(efis_cc, 1)
	else
		brightness = 1
		wxr_lit = false
		nav_lit = false
		tcas_lit = false
		fail_lit = false
		range = 0
		set(efis_cc, 0)
	end
	
	if fail_lit then brightness = 1 end


	
	-- sync nav show
	if nav_lit then 
		set(EFIS_vor_on, 1)
		set(EFIS_ndb_on, 1)
	else
		set(EFIS_vor_on, 0)
		set(EFIS_ndb_on, 0)
	end
	
end



--[[
--sim/cockpit2/EFIS/map_mode	int	y	enum	Map mode. 0=approach, 1=vor,2=map,3=nav,4=plan
--sim/cockpit2/EFIS/map_mode_is_HSI	int	y	boolean	Map is in HSI mode, 0 or 1.
--sim/cockpit2/EFIS/map_range	int	y	enum	Map range, 1->6, where 6 is the longest range.
sim/cockpit2/EFIS/EFIS_weather_on	int	y	boolean	On the moving map, show the weather or not.
sim/cockpit2/EFIS/EFIS_tcas_on	int	y	boolean	On the moving map, show the TCAS or not.
sim/cockpit2/EFIS/EFIS_airport_on	int	y	boolean	On the moving map, show the airports or not.
sim/cockpit2/EFIS/EFIS_fix_on	int	y	boolean	On the moving map, show the fixes or not.
sim/cockpit2/EFIS/EFIS_vor_on	int	y	boolean	On the moving map, show the VORs or not.
sim/cockpit2/EFIS/EFIS_ndb_on	int	y	boolean	On the moving map, show the NDBs or not.
sim/cockpit2/EFIS/EFIS_page
--]]



components = {


	-- range leds
	
	-- 5 led
	textureLit {
		position = {82, 125, 32, 12},
		image = get(nm5),
		visible = function()
			return range == 0
		end
	},	
	
	-- 10 led
	textureLit {
		position = {82, 125, 32, 12},
		image = get(nm10),
		visible = function()
			return range == 1
		end
	},		
	
	-- 20 led
	textureLit {
		position = {80, 125, 38, 12},
		image = get(nm20),
		visible = function()
			return range == 2
		end
	},	
	
	-- 40 led
	textureLit {
		position = {80, 125, 38, 12},
		image = get(nm40),
		visible = function()
			return range == 3
		end
	},

	-- 80 led
	textureLit {
		position = {80, 125, 38, 12},
		image = get(nm80),
		visible = function()
			return range == 4
		end
	},

	-- 160 led
	textureLit {
		position = {78, 125, 44, 12},
		image = get(nm160),
		visible = function()
			return range == 5
		end
	},

---------------------------

	-- 10 led
	textureLit {
		position = {70, 253, 32, 12},
		image = get(nm10),
		visible = function()
			return range == 0
		end
	},		
	
	-- 20 led
	textureLit {
		position = {68, 253, 38, 12},
		image = get(nm20),
		visible = function()
			return range == 1
		end
	},	
	
	-- 40 led
	textureLit {
		position = {68, 253, 38, 12},
		image = get(nm40),
		visible = function()
			return range == 2
		end
	},

	-- 80 led
	textureLit {
		position = {68, 253, 38, 12},
		image = get(nm80),
		visible = function()
			return range == 3
		end
	},

	-- 160 led
	textureLit {
		position = {64, 253, 44, 12},
		image = get(nm160),
		visible = function()
			return range == 4
		end
	},

	-- 320 led
	textureLit {
		position = {64, 253, 44, 12},
		image = get(nm320),
		visible = function()
			return range == 5
		end
	},









	
	-- WXr led
	textureLit {
		position = {120, 62, 32, 12},
		image = get(wxr),
		visible = function()
			return wxr_lit
		end
	},
	
	-- NAV led
	textureLit {
		position = {185, 62, 32, 12},
		image = get(nav),
		visible = function()
			return nav_lit
		end
	},
	
	-- TCAS led
	textureLit {
		position = {250, 62, 32, 12},
		image = get(tcas),
		visible = function()
			return tcas_lit
		end
	},
   
	-- RNG led
	textureLit {
		position = {70, 265, 32, 12},
		image = get(rng),
	},
   
	-- power button
	clickable {
        position = {1, 328, 40, 40 },
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       onMouseClick = function() 
			if not powerClicked then
				power_timer = 0
				set(kontur_power, 1 - get(kontur_power))
				playSample(btn_click, 0)
			end
			
			powerClicked = true
			return true
       end,
       
       onMouseUp = function()
			powerClicked = false
			return true
       end,

    }, 

	-- weather button
	clickable {
        position = {41, 328, 40, 40 },
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       onMouseClick = function() 
				set(EFIS_weather_on, 1 - get(EFIS_weather_on))
				playSample(btn_click, 0)
			return true
       end,
    }, 
	
	-- NAV button
	clickable {
        position = {81, 328, 40, 40 },
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       onMouseClick = function() 
				local a = 1 - get(EFIS_airport_on)
				set(EFIS_airport_on, a)
				set(EFIS_vor_on, a)
				set(EFIS_ndb_on, a)
				playSample(btn_click, 0)				
			return true
       end,
    }, 

	-- TCAS button
	clickable {
        position = {121, 328, 40, 40 },
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       onMouseClick = function() 
				set(EFIS_tcas_on, 1 - get(EFIS_tcas_on))
				playSample(btn_click, 0)
			return true
       end,
    }, 
	
   -- range rotary
    rotary {
        -- image = rotaryImage;
        value = map_range;
        step = 1;
        position = { 201, 328, 80, 40 };

        -- round inches hg to millimeters hg
        adjuster = function(a)
			if a < 2 then a = 2
			elseif a > 6 then a = 6 end
			playSample(btn_click, 0)
			return a
        end;
    };

	
	-- brightness of monitor
	rectangle_ctr {
		position = {0, 0, 390, 310},
		R = 0,
		G = 0,
		B = 0,
		A = function()
			return brightness
		end
	},
	
		-- fail led
	textureLit {
		position = {165, 190, 72, 28},
		image = get(fail),
		visible = function()
			return fail_lit
		end
	},	

	
}


