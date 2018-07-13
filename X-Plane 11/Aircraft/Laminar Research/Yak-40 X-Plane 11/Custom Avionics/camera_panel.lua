size = {256, 256}

-- define property table
defineProperty("camera_subpanel", globalPropertyi("sim/custom/xap/panels/camera"))
-- points of view: 0-none 1-capt 2-copilot 3-overhead 4-ctr1 5-ctr2, 6-left side, 7-right side, 8-11 - pax1-4

defineProperty("swview", globalPropertyi("sim/custom/xap/misc/view_point"))

-- images
defineProperty("background", loadImage("camera.png", 0, 0, size[1], size[2]))


components = {

	-- background
	textureLit {
		image = get(background),
		position = {0, 0, size[1], size[2]},

	},	

	----------------
	-- clickables --
	----------------
	-- Captain view
	clickable {
        position = {20, 155, 100, 50},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(swview, 1)
			return true
		end,
    },

	-- Copilot view
	clickable {
        position = {135, 155, 100, 50},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(swview, 2)
			return true
		end,
    },

	-- Overhead view
	clickable {
        position = {78, 210, 100, 40},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(swview, 3)
			return true
		end,
    },

	-- Center 1 view
	clickable {
        position = {90, 115, 76, 40},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(swview, 4)
			return true
		end,
    },

	-- Center 2 view
	clickable {
        position = {90, 65, 76, 50},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(swview, 5)
			return true
		end,
    },

	-- left side view
	clickable {
        position = {10, 65, 50, 90},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(swview, 6)
			return true
		end,
    },

	-- right side view
	clickable {
        position = {196, 65, 50, 90},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(swview, 7)
			return true
		end,
    },

	-- pax 1 view
	clickable {
        position = {12, 5, 55, 55},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(swview, 8)
			return true
		end,
    },

	-- pax 2 view
	clickable {
        position = {72, 5, 55, 55},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(swview, 9)
			return true
		end,
    },	
	
	-- pax 3 view
	clickable {
        position = {130, 5, 55, 55},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(swview, 10)
			return true
		end,
    },	
	
	-- pax 4 view
	clickable {
        position = {190, 5, 55, 55},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			set(swview, 11)
			return true
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
        set(camera_subpanel, 0 )
		return true
        end
    },
}

