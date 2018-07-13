-- this is reverse switch logic
size = {2048, 2048}
defineProperty("rev_switch", globalPropertyf("sim/custom/xap/misc/rev_switch")) -- reverse switch on central panel
defineProperty("reverse_pos", globalPropertyf("sim/flightmodel2/engines/thrust_reverser_deploy_ratio[0]")) -- reverse on middle engine
defineProperty("rev_switch_cap", globalPropertyf("sim/custom/xap/misc/rev_switch_cap")) -- cap


local switch_sound = loadSample('Custom Sounds/metal_switch.wav')
local was_switcher = false
local switched = false
local rev_command = findCommand("sim/engines/thrust_reverse_toggle")

--[[
function rev_toggle_handler(phase)
	if 0 == phase then
		if not was_switcher then set(rev_switch, 1 - get(rev_switch)) end
		was_switcher = false
	end
return 0
end
registerCommandHandler(rev_command, 0, rev_toggle_handler)
--]]

-- sync initial switch position
--if get(reverse_pos) < 0.5 then set(rev_switch, 0) 
--elseif get(reverse_pos) >= 0.5 then set(rev_switch, 1) end

local switcher_pushed = false
local rev_last = get(reverse_pos)

function update()

	local switch_pos = get(rev_switch)
	local rev = get(reverse_pos)
	
	if switch_pos == 0 and (rev > rev_last or rev >= 0.97) and not switched then
		--was_switcher = true
		switched = true
		commandOnce(rev_command)
	elseif switch_pos == 1 and (rev < rev_last or rev <= 0.03) and not switched then
		--was_switcher = true
		switched = true
		commandOnce(rev_command)
	end

	rev_last = rev
	if rev > 0.97 or rev < 0.03 then switched = false end
	
--[[
	-- sync switch and reverse position
	local switch_pos = get(rev_switch)
	local rev = get(reverse_pos)
	if switch_pos == 0 and (rev > rev_last or rev >= 0.95) and not switched then
		was_switcher = true
		switched = true
		commandOnce(rev_command)
	elseif switch_pos == 1 and (rev < rev_last or rev <= 0.05) and not switched then
		was_switcher = true
		switched = true
		commandOnce(rev_command)
	end
	rev_last = rev
	
	if rev > 0.95 or rev < 0.05 then switched = false end
--]]

end

components = {

    clickable {
       position = { 1202, 617, 19, 9 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotateup.png")
        },  
        
        onMouseClick = function(x, y, button) 
			local a = get(rev_switch)
			if get(rev_switch_cap) == 1 and a < 1 then
				playSample(switch_sound, 0)
				a = a + 0.5
			end
			set(rev_switch, a)
			--[[if not switcher_pushed and get(rev_switch_cap) == 1 then
				playSample(switch_sound, 0)
				set(rev_switch, 1)
				switcher_pushed = true
			end		--]]	
            return true
        end,
		onMouseUp = function()
			--[[if switcher_pushed then playSample(switch_sound, 0) end
			set(rev_switch, 0.5)
			switcher_pushed = false--]]
			return true
		end,
    },

    clickable {
       position = { 1202, 608, 19, 9 },
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("rotatedown.png")
        },  
        
        onMouseClick = function(x, y, button) 
			local a = get(rev_switch)
			if get(rev_switch_cap) == 1 and a > 0 then
				playSample(switch_sound, 0)
				a = a - 0.5
			end
			set(rev_switch, a)
			--[[if not switcher_pushed and get(rev_switch_cap) == 1 then
				playSample(switch_sound, 0)
				set(rev_switch, 1)
				switcher_pushed = true
			end		--]]	
            return true
        end,
		onMouseUp = function()
			--[[if switcher_pushed then playSample(switch_sound, 0) end
			set(rev_switch, 0.5)
			switcher_pushed = false--]]
			return true
		end,
    },

	-- reverse switcher cap
    clickable {
       position = { 1262, 608, 60, 37},
        
       cursor = { 
            x = 16, 
            y = 32, 
            width = 16, 
            height = 16, 
            shape = loadImage("clickable.png")
        },  
        
        onMouseClick = function()
            if not switcher_pushed then
				if get(rev_switch_cap) == 1 and get(rev_switch) == 0.5 then
					set(rev_switch_cap, 0)
					playSample(switch_sound, 0)
				elseif get(rev_switch_cap) == 1 and get(rev_switch) ~= 0.5 then
					set(rev_switch_cap, 0.3)
					playSample(switch_sound, 0)				
				else
					set(rev_switch_cap, 1)
					playSample(switch_sound, 0)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
			return true
		end,
    }, 	
--[[
-- reverse switcher cap
    switch {
        position = {1262, 608, 60, 37 },
        state = function()
            return get(rev_switch_cap) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				if get(rev_switch_cap) ~= 0 then
					set(rev_switch_cap, 0)
					playSample(switch_sound, 0)
				else
					set(rev_switch_cap, 1)
					playSample(switch_sound, 0)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
			return true
		end,
    },
	

    -- reverse switcher
    switch {
        position = {1202, 608, 19, 19 },
        state = function()
            return get(rev_switch) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if not switcher_pushed then
				playSample(switch_sound, 0)
				if get(rev_switch) ~= 0 then
					set(rev_switch, 0)
				else
					set(rev_switch, 1)
				end
				switcher_pushed = true
			end
			return true;
        end,
		onMouseUp = function()
			switcher_pushed = false
			return true
		end,
    },  --]]

}