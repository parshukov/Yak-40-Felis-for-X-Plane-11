
-- no image
defineProperty("image")

-- default value
defineProperty("value", 0)

-- default step
defineProperty("step", 1)

-- function for adjusting value to near suitable
--defineProperty("adjuster")

--adjuster = function (v) return v ; end

function updateValue(newValue)
    local a = rawget(_C, 'adjuster')
    if a then
        newValue = a(newValue)
    end
    set(value, newValue)
end


-- rotary consists of texture and two clickable areas
components = {
    
    -- background image
    texture { image = image },

    clickable {
        position = { 0, 0, 100, 50 },
        
        cursor = { 
            x = 10, 
            y = 28, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateleft.png")
        },

        onMouseClick = function(x, y, button)
            updateValue(get(value) - get(step))
            return true
        end,
    },
    
    clickable {
        position = { 0, 50, 100, 50 },
        
        cursor = { 
            x = 10, 
            y = 28, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateright.png")
        },
        
        onMouseClick = function(x, y, button) 
            updateValue(get(value) + get(step))
            return true
        end,
    },
    
}

