
-- panel switchers
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




-- get panels for manipulate them
defineProperty("panel_0") 
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


   	local p0 = get(panel_0)
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

-- logic of show/hide menu
function update()
	p0 = get(panel_0)
	p1 = get(panel_1)
    p2 = get(panel_2)
    p3 = get(panel_3)
	p4 = get(panel_4)
	p5 = get(panel_5) 
    p6 = get(panel_6)
    p7 = get(panel_7)
    p8 = get(panel_8)
    p9 = get(panel_9)
    p10 = get(panel_10)
--[[    p10 = get(panel_10)
	p11 = get(panel_11)
	p12 = get(panel_12)
	p13 = get(panel_13)
	p14 = get(panel_14)
	p15 = get(panel_15)
	p16 = get(panel_16)
	p17 = get(panel_17)
	p18 = get(panel_18)
	p19 = get(panel_19)
	p20 = get(panel_20)
--]]

	-- set visible property
	p0.visible = get(main_menu_subpanel) == 1
	p1.visible = get(azs_left) == 1
	p2.visible = get(azs_right) == 1
	p3.visible = get(ground_service) == 1
	p4.visible = get(camera_subpanel) == 1
	p5.visible = get(payload) == 1
	p6.visible = get(options_subpanel) == 1
	p7.visible = get(nl10) == 1
	p8.visible = get(info_panel) == 1
	p9.visible = get(ap_subpanel) == 1
    p10.visible = get(stab_check) == 1
--[[	p10.visible = false --get(service_subpanel) == 1
	p11.visible = false --get(payload_subpanel) == 1
	p12.visible = false --get(nl10m_subpanel) == 1
	p13.visible = false --get(map_subpanel) == 1
	p14.visible = false --get(options_subpanel) == 1
	p15.visible = false --get(info_subpanel) == 1
	p16.visible = false --get(camera_subpanel) == 1
	p17.visible = false --get(rsbn_subpanel) == 1
	p18.visible = false --get(nas1_subpanel) == 1
	p19.visible = false --get(uphone_subpanel) == 1
	p20.visible = false --get(fplan_subpanel) == 1
--]]
	  
end      



-- create commands for panels
local panel_0_command = createCommand("xap/panels/panel_0", "panel 0")
function panel_0_handler(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if 0 == phase then
            if get(main_menu_subpanel) ~= 0 then
                set(main_menu_subpanel, 0)
            else
                set(main_menu_subpanel, 1)
				movePanelToTop(p0)
            end
    end
return 0
end
registerCommandHandler(panel_0_command, 0, panel_0_handler)

local panel_1_command = createCommand("xap/panels/panel_1", "panel 1")
function panel_1_handler(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if 0 == phase then
            if get(azs_left) ~= 0 then
                set(azs_left, 0)
            else
                set(azs_left, 1)
				movePanelToTop(p1)
            end
    end
return 0
end
registerCommandHandler(panel_1_command, 0, panel_1_handler)

local panel_2_command = createCommand("xap/panels/panel_2", "panel 2")
function panel_2_handler(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if 0 == phase then
            if get(azs_right) ~= 0 then
                set(azs_right, 0)
            else
                set(azs_right, 1)
				movePanelToTop(p2)
            end
    end
return 0
end
registerCommandHandler(panel_2_command, 0, panel_2_handler)

local panel_3_command = createCommand("xap/panels/panel_3", "panel 3")
function panel_3_handler(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if 0 == phase then
            if get(ground_service) ~= 0 then
                set(ground_service, 0)
            else
                set(ground_service, 1)
				movePanelToTop(p3)
            end
    end
return 0
end
registerCommandHandler(panel_3_command, 0, panel_3_handler)

local panel_4_command = createCommand("xap/panels/panel_4", "panel 4")
function panel_4_handler(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if 0 == phase then
            if get(camera_subpanel) ~= 0 then
                set(camera_subpanel, 0)
            else
                set(camera_subpanel, 1)
				movePanelToTop(p4)
            end
    end
return 0
end
registerCommandHandler(panel_4_command, 0, panel_4_handler)

local panel_5_command = createCommand("xap/panels/panel_5", "panel 5")
function panel_5_handler(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if 0 == phase then
            if get(payload) ~= 0 then
                set(payload, 0)
            else
                set(payload, 1)
				movePanelToTop(p5)
            end
    end
return 0
end
registerCommandHandler(panel_5_command, 0, panel_5_handler)

local panel_6_command = createCommand("xap/panels/panel_6", "panel 6")
function panel_6_handler(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if 0 == phase then
            if get(options_subpanel) ~= 0 then
                set(options_subpanel, 0)
            else
                set(options_subpanel, 1)
				movePanelToTop(p6)
            end
    end
return 0
end
registerCommandHandler(panel_6_command, 0, panel_6_handler)

local panel_7_command = createCommand("xap/panels/panel_7", "panel 7")
function panel_7_handler(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if 0 == phase then
            if get(nl10) ~= 0 then
                set(nl10, 0)
            else
                set(nl10, 1)
				movePanelToTop(p7)
            end
    end
return 0
end
registerCommandHandler(panel_7_command, 0, panel_7_handler)

local panel_8_command = createCommand("xap/panels/panel_8", "panel 8")
function panel_8_handler(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if 0 == phase then
            if get(info_panel) ~= 0 then
                set(info_panel, 0)
            else
                set(info_panel, 1)
				movePanelToTop(p8)
            end
    end
return 0
end
registerCommandHandler(panel_8_command, 0, panel_8_handler)

local panel_9_command = createCommand("xap/panels/panel_9", "panel 9")
function panel_9_handler(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if 0 == phase then
            if get(ap_subpanel) ~= 0 then
                set(ap_subpanel, 0)
            else
                set(ap_subpanel, 1)
				movePanelToTop(p9)
            end
    end
return 0
end
registerCommandHandler(panel_9_command, 0, panel_9_handler)

local panel_10_command = createCommand("xap/panels/panel_10", "panel 10")
function panel_10_handler(phase)  -- for all commands phase equals: 0 on press; 1 while holding; 2 on release
	if 0 == phase then
            if get(stab_check) ~= 0 then
                set(stab_check, 0)
            else
                set(stab_check, 1)
				movePanelToTop(p9)
            end
    end
return 0
end
registerCommandHandler(panel_10_command, 0, panel_10_handler)
