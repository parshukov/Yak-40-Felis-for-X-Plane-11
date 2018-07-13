size = {512, 512}

-- define property table
defineProperty("real_ahz", globalPropertyi("sim/custom/xap/set/real_ahz")) -- real ahz has errors and needs to be corrected
defineProperty("three_ruds", globalPropertyi("sim/custom/xap/set/three_ruds")) -- user have 3 RUDs
defineProperty("real_startup", globalPropertyi("sim/custom/xap/set/real_startup")) -- when start the engines a lot of thing must to be done
defineProperty("real_generators", globalPropertyi("sim/custom/xap/set/real_generators")) -- generators can fail if overload
defineProperty("real_gears", globalPropertyi("sim/custom/xap/set/real_gears")) -- gears can fail to retract or even brake
defineProperty("switch_rud", globalPropertyi("sim/custom/xap/set/switch_rud")) -- switch or hold rud stopors. 1 = switch, 0 = hold.
defineProperty("nosewheel_command", globalPropertyi("sim/custom/xap/set/nosewheel_command")) -- if 1, then user must push button to turn nosewheel
defineProperty("real_pedals", globalPropertyi("sim/custom/xap/set/real_pedals")) -- if you don't have pedals, you use emerg brake as main
defineProperty("real_nav", globalPropertyi("sim/custom/xap/set/real_nav")) -- for real NAV system with route and landing modes
defineProperty("navoption", globalPropertyi("PNV/navoption")) -- for real NAV system with route and landing modes
defineProperty("angle", globalPropertyi("KLN90B/custom/angle")) -- for real NAV system with route and landing modes
defineProperty("darkness", globalPropertyf("PNV/GNS430/darkness")) -- for real NAV system with route and landing modes
defineProperty("overrideGPS", globalPropertyi("sim/operation/override/override_gps"))
defineProperty("overrideNAV", globalPropertyi("sim/operation/override/override_nav_heading"))
defineProperty("gns430onoff", globalPropertyi("PNV/GNS430/onoff"))
-----------------------------------------------------------------------------
createProp("sim/custom/xap/black_box", "int", 1); -- black_box on
-------------------------------------------------------------------------
defineProperty("options_subpanel", globalPropertyi("sim/custom/xap/panels/options_subpanel"))

-- images
defineProperty("background", loadImage("settings.png", 0, 0, size[1], size[2]))
defineProperty("tmb_up", loadImage("tumbler_up.png", 0, 20, 32, 88))
defineProperty("tmb_dn", loadImage("tumbler_down.png",  0, 20, 32, 88))
defineProperty("tmb_lf", loadImage("tumbler_left.png",  0, 0, 120, 32))
defineProperty("tmb_rt", loadImage("tumbler_right.png",  0, 0, 120, 32))

-- settings table
local settings_table = {}
	settings_table["ahz"] = get(real_ahz)
	settings_table["RUD"] = get(three_ruds)
	settings_table["start"] = get(real_startup)
	settings_table["gens"] = get(real_generators)
	settings_table["gears"] = get(real_gears)
	settings_table["switchrud"] = get(switch_rud)
	settings_table["nosewheel"] = get(nosewheel_command)
	settings_table["pedals"] = get(real_pedals)
	settings_table["nav"] = get(real_nav)
	settings_table["navoption"] = get(navoption)
	settings_table["angle"] = get(angle)
	settings_table["darkness"] = get(darkness)
	
-- reading file or set properties with default values
function file_read()
	local filename = panelDir .. "/settings.ini"
	local file = io.open(filename, "r")
	-- if file exist - read it and fill the variables with new values
	if file then
		local lines = file:read("*a")
		print("reading settings")
		for k, v in string.gmatch(lines, "(%w+)=([%d%p%-]+)") do
			settings_table[k] = tonumber(v)
			print(k, v)
		end
		file:close()
		-- update values from table
		if settings_table["ahz"] then set(real_ahz, settings_table["ahz"]) end
		if settings_table["RUD"] then set(three_ruds, settings_table["RUD"]) end
		if settings_table["start"] then set(real_startup, settings_table["start"]) end
		if settings_table["gens"] then set(real_generators, settings_table["gens"]) end
		if settings_table["gears"] then set(real_gears, settings_table["gears"]) end
		if settings_table["switchrud"] then set(switch_rud, settings_table["switchrud"]) end
		if settings_table["nosewheel"] then set(nosewheel_command, settings_table["nosewheel"]) end
		if settings_table["pedals"] then set(real_pedals, settings_table["pedals"]) end
		if settings_table["nav"] then set(real_nav, settings_table["nav"]) end
		if settings_table["navoption"] then set(navoption, settings_table["navoption"]) end
		if settings_table["angle"] then set(angle, settings_table["angle"]) end
		if settings_table["darkness"] then set(darkness, settings_table["darkness"]) end
		
		print("settings readed successfully")
	else print ("no .ini file with settings - using default values")
	end
	return true
end

-- saving file
function file_save()
	local filename = panelDir .. "/settings.ini"
	local success = false -- check operation
	local savefile = io.open(filename, "w")
	savefile:write("ahz","=",get(real_ahz)," \n")
	savefile:write("RUD","=",get(three_ruds)," \n")
	savefile:write("start","=",get(real_startup)," \n")
	savefile:write("gens","=",get(real_generators)," \n")
	savefile:write("gears","=",get(real_gears)," \n")
	savefile:write("switchrud","=",get(switch_rud)," \n")
	savefile:write("nosewheel","=",get(nosewheel_command)," \n")
	savefile:write("pedals","=",get(real_pedals)," \n")
	savefile:write("nav","=",get(real_nav)," \n")
	savefile:write("navoption","=",get(navoption)," \n")
	savefile:write("angle","=",get(angle)," \n")
	savefile:write("darkness","=",get(darkness)," \n")
	
	if savefile then success = true end
	savefile:close()
	
	return success
end


local notLoaded = true
local switcher_pushed = false

function update()
	if notLoaded then
		file_read()
		notLoaded = false
	end

end

components = {
	-- background
	textureLit {
		image = get(background),
		position = {0, 0, size[1], size[2]},

	},	

	-- save file clickable
	clickable {
       position = {260, 30, 230, 50},
        
       cursor = { 
            x = 16, 
            y = 32,  
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
        onMouseClick = function()
			local file_saved = file_save()
			if file_saved then print("saving file with settings - success") else print("saving file with settings - error") end			
			return true
        end,
    },

	-- RE-READ file clickable
	clickable {
       position = {260, 85, 230, 50},
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
        onMouseClick = function()
			file_read()
			return true
        end,
    },

	-- real_ahz switcher
    switchLit {
        position = {220, 403, 22, 50},
        state = function()
            return get(real_ahz) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				if get(real_ahz) ~= 0 then
					set(real_ahz, 0)
				else
					set(real_ahz, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- three_ruds switcher
    switchLit {
        position = {220, 352, 22, 50},
        state = function()
            return get(three_ruds) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				if get(three_ruds) ~= 0 then
					set(three_ruds, 0)
				else
					set(three_ruds, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- real_startup switcher
    switchLit {
        position = {220, 302, 22, 50},
        state = function()
            return get(real_startup) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				if get(real_startup) ~= 0 then
					set(real_startup, 0)
				else
					set(real_startup, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- real_generators switcher
    switchLit {
        position = {220, 252, 22, 50},
        state = function()
            return get(real_generators) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				if get(real_generators) ~= 0 then
					set(real_generators, 0)
				else
					set(real_generators, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	-- real_gears switcher
    switchLit {
        position = {220, 202, 22, 50},
        state = function()
            return get(real_gears) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				if get(real_gears) ~= 0 then
					set(real_gears, 0)
				else
					set(real_gears, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	


	-- switch_rud switcher
    switchLit {
        position = {460, 403, 22, 50},
        state = function()
            return get(switch_rud) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				if get(switch_rud) ~= 0 then
					set(switch_rud, 0)
				else
					set(switch_rud, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- nosewheel_command switcher
    switchLit {
        position = {460, 352, 22, 50},
        state = function()
            return get(nosewheel_command) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				if get(nosewheel_command) ~= 0 then
					set(nosewheel_command, 0)
				else
					set(nosewheel_command, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },

	-- real_pedals switcher
    switchLit {
        position = {460, 302, 22, 50},
        state = function()
            return get(real_pedals) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				if get(real_pedals) ~= 0 then
					set(real_pedals, 0)
				else
					set(real_pedals, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

	-- real_nav switcher
    switchLit {
        position = {460, 252, 22, 50},
        state = function()
            return get(real_nav) ~= 0
        end,
        btnOn = get(tmb_up),
        btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				if get(real_nav) ~= 0 then
					set(real_nav, 0)
				else
					set(real_nav, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	
	
	switchLit {
        position = {300, 168, 100, 25},
        state = function()
            return get(navoption) ~= 0
        end,
        btnOn = get(tmb_rt),
        btnOff = get(tmb_lf),
        onMouseClick = function()
            if not switcher_pushed then
				if get(navoption) ~= 0 then
					set(navoption, 0)
					set(gns430onoff,0)
				else
					set(navoption, 1)
					--print(get(kln_power))
					set(navoptionchange,1)
					set(overrideGPS,0)
					set(overrideNAV,0)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
		end,
    },	

	
   -- clickable area for closing main menu
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
        set(options_subpanel, 0 )
		return true
        end
    },
}

