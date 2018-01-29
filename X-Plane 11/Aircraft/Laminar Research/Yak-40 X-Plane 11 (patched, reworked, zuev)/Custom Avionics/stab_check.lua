-- this is stab_check
size = {700, 509}

defineProperty("stab_check", globalPropertyi("sim/custom/xap/panels/stab_check"))

-- images
defineProperty("background", loadImage("stab.png",  5, 3, size[1], size[2]))

function update()

end

-- components of panel
components = {

	-- background
	texture {
		image = get(background),
		position = {0, 0, size[1], size[2]},

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
        set(stab_check, 0 )
        return true
        end
    },	

}