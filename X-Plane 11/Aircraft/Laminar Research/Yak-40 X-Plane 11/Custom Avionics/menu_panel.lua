size = {32, 260}

-- define panels datarefs
defineProperty("main_menu_subpanel", globalPropertyi("sim/custom/xap/panels/main_menu_subpanel"))
defineProperty("azs_left", globalPropertyi("sim/custom/xap/panels/azs_left"))
defineProperty("azs_right", globalPropertyi("sim/custom/xap/panels/azs_right"))
defineProperty("ground_service", globalPropertyi("sim/custom/xap/panels/ground_service"))
defineProperty("camera_subpanel", globalPropertyi("sim/custom/xap/panels/camera"))
defineProperty("payload", globalPropertyi("sim/custom/xap/panels/payload"))
defineProperty("options_subpanel", globalPropertyi("sim/custom/xap/panels/options_subpanel"))
defineProperty("nl10", globalPropertyi("sim/custom/xap/panels/nl10"))
defineProperty("info_panel", globalPropertyi("sim/custom/xap/panels/info_subpanel"))
defineProperty("ap_subpanel", globalPropertyi("sim/custom/xap/panels/ap_subpanel"))
defineProperty("stab_check", globalPropertyi("sim/custom/xap/panels/stab_check"))

-- images
defineProperty("background", loadImage("menu_panel.png"))

-- get panels for manipulate them
defineProperty("panel_1") 
defineProperty("panel_2")
defineProperty("panel_3")  
defineProperty("panel_4") 
defineProperty("panel_5")   
defineProperty("panel_6")
defineProperty("panel_7")
defineProperty("panel_8")   
defineProperty("panel_9")  
defineProperty("panel_10") 
defineProperty("panel_11") 
defineProperty("panel_12") 
defineProperty("panel_13") 
defineProperty("panel_14") 
defineProperty("panel_15") 
defineProperty("panel_16")
defineProperty("panel_17")
defineProperty("panel_18")
defineProperty("panel_19")
defineProperty("panel_20")

--[[
	panel_1 = left AZS (circuit breakers)
	panel_2 = right AZS
	panel_3 = ground service
	panel_4 = camera
	panel_5 = payload panel
	panel_6 = options
	panel_7 = NL-10m
	panel_8 = info_panel
	panel_9 = AP
	panel_10 = 
	panel_11 = 
	panel_12 = 
	panel_13 = 
	panel_14 = 
	panel_15 = 
	panel_16 = 
--]]

    local p1 = get(panel_1)
    local p2 = get(panel_2)
    local p3 = get(panel_3)
    local p4 = get(panel_4)
    local p5 = get(panel_5) 
    local p6 = get(panel_6)
    local p7 = get(panel_7)
    local p8 = get(panel_8)
    local p9 = get(panel_9)
    local p10 = get(panel_10)
	local p11 = get(panel_11)
	local p12 = get(panel_12)
	local p13 = get(panel_13)
	local p14 = get(panel_14)
	local p15 = get(panel_15)
	local p16 = get(panel_16)
	local p17 = get(panel_17)
	local p18 = get(panel_18)
	local p19 = get(panel_19)
	local p20 = get(panel_20)

components = {
	-- background
	--[[rectangle {
		position = {0, 0, size[1], size[2]},
		color = {0,0,0,0.5},
	},--]]
	textureLit {
		position = {0, 0, size[1], size[2]},
		image = get(background),
	},
	
	-- panel's switchers
	-- AP
    switch {
        position = { 0, 236, 32, 24},
        state = function()
            return get(ap_subpanel) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if get(ap_subpanel) ~= 0 then
                set(ap_subpanel, 0)
            else
                set(ap_subpanel, 1)
				movePanelToTop(p9)
            end 
            return true;
        end 
    }, 


	-- azs_left
    switch {
        position = { 0, 210, 32, 24},
        state = function()
            return get(azs_left) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if get(azs_left) ~= 0 then
                set(azs_left, 0)
            else
                set(azs_left, 1)
				movePanelToTop(p1)
            end 
            return true;
        end 
    }, 	
	-- azs_right
    switch {
        position = { 0, 186, 32, 24},
        state = function()
            return get(azs_right) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if get(azs_right) ~= 0 then
                set(azs_right, 0)
            else
                set(azs_right, 1)
				movePanelToTop(p2)
            end 
            return true;
        end 
    },
	-- ground_service
    switch {
        position = { 0, 162, 32, 24},
        state = function()
            return get(ground_service) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if get(ground_service) ~= 0 then
                set(ground_service, 0)
            else
                set(ground_service, 1)
				movePanelToTop(p3)
            end 
            return true;
        end 
    },
	-- camera_subpanel
    switch {
        position = { 0, 136, 32, 24},
        state = function()
            return get(camera_subpanel) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if get(camera_subpanel) ~= 0 then
                set(camera_subpanel, 0)
            else
                set(camera_subpanel, 1)
				movePanelToTop(p4)
            end 
            return true;
        end 
    },
	-- payload
    switch {
        position = { 0, 112, 32, 24},
        state = function()
            return get(payload) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if get(payload) ~= 0 then
                set(payload, 0)
            else
                set(payload, 1)
				movePanelToTop(p5)
            end 
            return true;
        end 
    },
	-- info_panel
    switch {
        position = { 0, 88, 32, 24},
        state = function()
            return get(info_panel) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if get(info_panel) ~= 0 then
                set(info_panel, 0)
            else
                set(info_panel, 1)
				movePanelToTop(p8)
            end 
            return true;
        end 
    },
	-- nl10
    switch {
        position = { 0, 62, 32, 24},
        state = function()
            return get(nl10) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if get(nl10) ~= 0 then
                set(nl10, 0)
            else
                set(nl10, 1)
				movePanelToTop(p7)
            end 
            return true;
        end 
    },
	-- options_subpanel
    switch {
        position = { 0, 37, 32, 24},
        state = function()
            return get(options_subpanel) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if get(options_subpanel) ~= 0 then
                set(options_subpanel, 0)
            else
                set(options_subpanel, 1)
				movePanelToTop(p5)
            end 
            return true;
        end 
    },

	-- stab_check
    switch {
        position = { 0, 11, 32, 24},
        state = function()
            return get(stab_check) ~= 0
        end,
        --btnOn = get(tmb_up),
        --btnOff = get(tmb_dn),
        onMouseClick = function()
            if get(stab_check) ~= 0 then
                set(stab_check, 0)
            else
                set(stab_check, 1)
				movePanelToTop(p5)
            end 
            return true;
        end 
    },

}

