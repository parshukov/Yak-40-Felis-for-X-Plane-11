size = { 120, 120 }

-- initialize component property table
defineProperty("gforce", globalPropertyf("sim/flightmodel2/misc/gforce_normal"))
defineProperty("frame_time", globalPropertyf("sim/custom/xap/time/frame_time")) -- time for frames

-- needle image
defineProperty("NeedleImage", loadImage("needles.png", 68, 74, 14, 168))
defineProperty("RedNeedleImage", loadImage("needles2.png", 46, 3, 14, 168))

defineProperty("AZS_ADP_sw", globalPropertyi("sim/custom/xap/azs/AZS_ADP_sw")) --  AZS for G-forse meter

defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("AC_36_volt", globalPropertyf("sim/custom/xap/power/AC_36_volt")) -- 36 volt
defineProperty("AC_115_volt", globalPropertyf("sim/custom/xap/power/AC_115_volt")) -- 115 volt
defineProperty("inv_PO1500_radio", globalPropertyi("sim/custom/xap/power/inv_PO1500_radio")) -- inverter for 115v bus
defineProperty("Gmeter_cc", globalPropertyf("sim/custom/xap/gauges/Gmeter_cc")) -- cc
local btn_click = loadSample('Custom Sounds/plastic_btn.wav')
-- define minimum and maximum of G
local min_angle = 1
local max_angle = 1
local button_pressed = false
local v = 0 --get(gforce)

function update()

	local passed = get(frame_time)
	
	local power = get(DC_27_volt) > 21 and get(AZS_ADP_sw) > 0 and get(AC_115_volt) > 110 and get(inv_PO1500_radio) == 1
	
	-- move red needles to actual G 
	local G = get(gforce)
	if power then 
		v = G
		set(Gmeter_cc, 1)
	else 
		v = 1 
		set(Gmeter_cc, 0)
	end
	
	if button_pressed then
		if min_angle < v then min_angle = min_angle + passed * 2 end
		if max_angle > v then max_angle = max_angle - passed * 2 end
	end

	-- limit G needle
	if v < -2 then v = -2
	elseif v > 4 then v = 4 end
	
	-- calculate the mininmum
	if v < min_angle then
		min_angle = v
	end
	-- calculate the maximum
	if v > max_angle then
		max_angle = v
	end
	

			
end



-- g-meter consists of several components
components = {

	rectangle {
		position = { 59, 59, 2, 2 },
	},

    -- red needle of minimum
    needle {
        position = { 5, 5, 110, 110 },
        image = get(RedNeedleImage),
        angle = function() 
            return min_angle * 50
        end
    }, 

 
      -- red needle of maximum
    needle {
        position = {  5, 5, 110, 110 },
        image = get(RedNeedleImage),
         angle = function() 
             return max_angle * 50
          end
    },
    
    
    -- white needle
        needle {
        position = {  5, 5, 110, 110 },
        image = get(NeedleImage),
        angle = function()
             --local v = get(gforce)
             if v < -2 then
                return -100 
             elseif v > 4 then
                return 200
             else  return v * 50  
             end
        end
    },    

  

    clickable {
        position = { 100, 0, 20, 20 },
        
       cursor = { 
            x = 0, 
            y = 0, 
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       onMouseClick = function(x, y, button) 
            if not button_pressed then playSample(btn_click, 0) end
			button_pressed = true
			return true
        end,
		onMouseUp = function()
			playSample(btn_click, 0)
			button_pressed = false
			return true
		end,
    },   

--]]
}

