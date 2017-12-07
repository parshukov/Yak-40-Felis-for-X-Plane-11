-- this is test lamps button logic
size = {20, 20}

-- sources
defineProperty("test_lamps_sw", globalPropertyi("sim/custom/xap/azs/test_lamps_sw")) -- AZS test lamps button
defineProperty("DC_27_volt", globalPropertyf("sim/custom/xap/power/DC_27_volt")) -- 27 volt
defineProperty("test_lamp_btn", globalPropertyi("sim/custom/xap/misc/test_lamp_btn")) -- test lamps button pressed

-- result
defineProperty("but_test_lamp", globalPropertyi("sim/custom/xap/buttons/but_test_lamp")) -- test lamps button
local btn_click = loadSample('Custom Sounds/plastic_btn.wav')
local button_clicked = false

function update()
	local power = 0
	if get(DC_27_volt) > 21 then power = 1 end
	
	set(but_test_lamp, power * get(test_lamps_sw) * get(test_lamp_btn))
end


components = {
 
	-- test button
    clickable {
        position = {0, 0, 20, 20},  -- search and set right
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
       	onMouseClick = function() 
			if not button_clicked then playSample(btn_click, 0) end
			button_clicked = true
			set(test_lamp_btn, 1)
			return true
		end,
		onMouseUp  = function() 
			playSample(btn_click, 0)
			button_clicked = false
			set(test_lamp_btn, 0)
			return true
		end,
    },

}
