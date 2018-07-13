size = { 120, 120 }

-- initialize component property table
defineProperty("EGT", globalPropertyf("sim/cockpit2/engine/indicators/EGT_deg_C[0]"))
defineProperty("AZS", 1)

-- needle image
defineProperty("needles_5", loadImage("needles.png", 16, 111, 16, 98))

defineProperty("black_cap", loadImage("covers.png", 0, 55, 56, 56)) -- black cap image

local angle = 0

function update()
    local v = get(EGT) * get(AZS)
	angle = v * 250 / 900 - 120
	
	-- set limits
	if angle < -120 then angle = -120
	elseif angle > 120 then angle = 120 end
	

end

-- EGT indicator consists of several components
components = {


 
  
    -- white needle
       needle {
        position = { 5, 5, 110, 110 },
        image = get(needles_5),
        angle = function()
			return angle
        end
    },
	
	-- black cap
	texture{
	    position = { 38, 35, 50, 50 },
        image = get(black_cap),
	},


}

