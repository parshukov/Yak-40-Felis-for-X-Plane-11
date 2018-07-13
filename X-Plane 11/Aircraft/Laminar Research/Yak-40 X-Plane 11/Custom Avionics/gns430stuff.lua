--
size = {520,390}
g430n1_coarse_down=findCommand("sim/GPS/g430n1_coarse_down")
g430n1_coarse_up=findCommand("sim/GPS/g430n1_coarse_up")
g430n1_fine_down=findCommand("sim/GPS/g430n1_fine_down")
g430n1_fine_up=findCommand("sim/GPS/g430n1_fine_up")
g430n1_chapter_up=findCommand("sim/GPS/g430n1_chapter_up")
g430n1_chapter_dn=findCommand("sim/GPS/g430n1_chapter_dn")
g430n1_page_up=findCommand("sim/GPS/g430n1_page_up")
g430n1_page_down=findCommand("sim/GPS/g430n1_page_dn")
defineProperty("bat_on_bus", globalPropertyi("sim/custom/xap/power/bat_on_bus"))
defineProperty("gns430onoff", globalPropertyi("PNV/GNS430/onoff"))
defineProperty("navoptionchange", globalPropertyi("PNV/navoptionchange"))
defineProperty("startlogic", globalPropertyf("PNV/GNS430/startlogic"))
defineProperty("darkness", globalPropertyf("PNV/GNS430/darkness"))
defineProperty("gns430coarseupdown", globalPropertyi("PNV/GNS430/coarseupdown"))
defineProperty("gns430finetune", globalPropertyi("PNV/GNS430/finetune"))
defineProperty("gns430chapterupdown", globalPropertyi("PNV/GNS430/chapterupdown"))
defineProperty("gns430pageupdown", globalPropertyi("PNV/GNS430/pageupdown"))
defineProperty("g430ackow", globalPropertyi("PNV/GNS430/g430ackow"))
defineProperty("sun_pitch_degrees", globalPropertyf("sim/graphics/scenery/sun_pitch_degrees"))
defineProperty("background", loadImage("g430.png"))
defineProperty("backgroundbl", loadImage("g430bl.png"))
defineProperty("glogo", loadImage("glogo.png"))
defineProperty("kln_power", globalPropertyi("sim/custom/kln_power"))
defineProperty("GarminSplashScreen1", loadImage("GarminSplashScreen1.png"))
defineProperty("GarminSplashScreen2", loadImage("GarminSplashScreen2.png"))
defineProperty("GarminSplashScreen3", loadImage("GarminSplashScreen3.png"))
defineProperty("GarminSplashScreen4", loadImage("GarminSplashScreen4.png"))
defineProperty("GarminSplashScreen5", loadImage("GarminSplashScreen5.png"))
defineProperty("GarminSplashScreen6", loadImage("GarminSplashScreen6.png"))
kln90onoff=findCommand("xap/KLN90/Toggle_Power_Switch")
local gns430coarseupdownLOC = 0
local gns430finetuneLOC = 0
local gns430chapterupdownLOC = 0
local gns430pageupdownLOC = 0
local navchange=0
alpha1=1	
alpha2=0
alpha3=0
alpha4=0
alpha5=0
alpha6=0
alpha7=0
alpha81=0
alpha82=0
blinker=0
blinkercoeff=1
langfile_sett = {"","","","","",""}
local font = loadFont('KLN90.fnt')
local font1 = loadFont('ProFontWindows16.fnt')
local font2 = loadFont('ProFontWindows16B.fnt')
local font3 = loadFont('ProFontWindows26.fnt')
local airaccycle1 = "Custom Data/GNS430/navdata/cycle_info.txt"
local file1 = io.open(airaccycle1, "r")
local expyear
local expmonth
local expdate
local currentdate
local nightvar=0
local nightvarh=0
rr, gg, bb =1,1,1
month={"JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"}
if file1 then
		for i=1,3,1 do
		line=file1:read()
		if line == nil then break end
			--print(line)
			langfile_sett[i] = line:gsub("^%s*(.-)%s*$", "%1")
		end
		file1:close()
		expyear=tonumber(string.sub(langfile_sett[3], -4))
		expmonth=string.sub(langfile_sett[3], -8, -6)
		expday=tonumber(string.sub(langfile_sett[3], -11,-10))
		for i=1,12,1 do
			if month[i]==expmonth then
				expmonthint=i
			end
		end
		currentdate=os.time{year=os.date("%Y"), month=os.date("%m"), day=os.date("%d")}
		expdate=os.time{year=expyear, month=expmonthint, day=expday}
		if currentdate>expdate then
			rr, gg, bb =0.95, 0.19, 0.64
			langfile_sett[3] = "Expired!!!"
		else
			langfile_sett[3] = "Exp "..string.sub(langfile_sett[3], -11)
		end
else
	rr, gg, bb =0.95, 0.19, 0.64
	langfile_sett[3] = "not installed"
	langfile_sett[1] = "1609"
end

function draw() 
    drawTexture(get(backgroundbl), 0, 0, 520,390, 1, 1, 1, alpha1)
    drawRectangle(0, 0, 520,390, 0, 0, 0, nightvar)
    drawTexture(get(GarminSplashScreen1), 0, 0, 520,390, 1, 1, 1, alpha2) 
	drawTexture(get(GarminSplashScreen2), 0, 0, 520,390, 1, 1, 1, alpha3)
	drawText(font1, 265, 91, "1998-"..os.date("%Y"),1, 1, 1, alpha3)
	drawTexture(get(GarminSplashScreen3), 0, 0, 520,390, 1, 1, 1, alpha4)
	drawText(font1, 205, 40, "Cycle "..string.sub(langfile_sett[1], -4),1, 1, 1, alpha4)
	drawTexture(get(GarminSplashScreen4), 0, 0, 520,390, 1, 1, 1, alpha5)
	drawTexture(get(GarminSplashScreen5), 0, 0, 520,390, 1, 1, 1, alpha6)
	drawTexture(get(GarminSplashScreen6), 0, 0, 520,390, 1, 1, 1, alpha7)
	drawText(font2, 294, 179, langfile_sett[3],rr, gg, bb, alpha7)
	drawRectangle(450, 330, 60,50, 1, 1, 1, alpha81)
	drawText(font3, 456, 343, "OK?",0, 0, 0, alpha82)
	--drawText(font2, 294, 179, "Exp 30/JUNE/15",1, 1, 1, 1)
--	drawText(font2, 294, 179, "Exp "..string.sub(langfile_sett[3], -11),1, 1, 1, 1)
	
	
	
	
	--drawTexture(get(glogo), 40, 45, 150, 42, 1, 1, 1, alpha2) 
    --drawTexture(get(background), 0, 0, 230, 122, 1, 1, 1, alpha3)
    drawRectangle(0, 0, 520,390, 0, 0, 0, get(darkness))
	--drawText(font, 40, 45, string.sub(langfile_sett[1], -4),1, 1, 1, 1)
end
function update()
	if get(navoptionchange)==1 then
		if get(kln_power)==1 then
			commandOnce(kln90onoff)
			set(navoptionchange,0)
		else
			set(navoptionchange,0)
		end
	end
---GNS430 start logic
	if get(bat_on_bus)==1 then
		if get(gns430onoff)==1 then
			if get(startlogic)<20.2 then
				set(startlogic,get(startlogic)+0.01)
				if get(startlogic)>0.4 and get(startlogic)<3.65 and alpha2<1 then
					alpha2=alpha2+0.01
					--nightvar=nightvar-0.01
				elseif get(startlogic)>3.65 and get(startlogic)<7.2 and alpha3<1 then
					--alpha1=0
					if alpha2>0 then
						alpha2=alpha2-0.1
					else
						alpha2=0
					end	
					if alpha3<1 then
						alpha3=alpha3+0.1
					else
						alpha3=1
					end
				elseif get(startlogic)>7.2 and get(startlogic)<10.6 and alpha4<1 then
					--alpha1=0
					if alpha3>0 then
						alpha3=alpha3-0.1
					else
						alpha3=0
					end	
					if alpha4<1 then
						alpha4=alpha4+0.1
					else
						alpha4=1
					end
				elseif get(startlogic)>10.6 and get(startlogic)<14 and alpha5<1 then
					--alpha1=0
					if alpha4>0 then
						alpha4=alpha4-0.1
					else
						alpha4=0
					end	
					if alpha5<1 then
						alpha5=alpha5+0.1
					else
						alpha5=1
					end
				elseif get(startlogic)>14 and get(startlogic)<17.6 and alpha6<1 then
					--alpha1=0
					if alpha5>0 then
						alpha5=alpha5-0.1
					else
						alpha5=0
					end	
					if alpha6<1 then
						alpha6=alpha6+0.1
					else
						alpha6=1
					end
				elseif get(startlogic)>17.6 and get(startlogic)<20 and alpha7<1 then
					--alpha1=0
					if alpha6>0 then
						alpha6=alpha6-0.1
					else
						alpha6=0
					end	
					if alpha7<1 then
						alpha7=alpha7+0.1
					else
						alpha7=1
					end
					set(g430ackow,2)
				elseif get(startlogic)>20 and get(startlogic)<20.2 and alpha7>0 then
					alpha81=1
					alpha82=1
				end
			else
				alpha1=0
				alpha2=0
				alpha3=0
				alpha4=0
				alpha5=0
				alpha6=0
				print(blinker)
				if get(g430ackow)==2 then
					blinker=blinker+blinkercoeff*0.03
					if blinker>1.4 then
						blinkercoeff=-1
					elseif blinker<0 then
						blinkercoeff=1
					end
					if blinker>0.88 then
						if alpha81<=1 then
							alpha81=alpha81-blinkercoeff*0.2
						elseif alpha81>1 then
							alpha81=1
						elseif alpha81<0 then
							alpha81=0
						end
					end
					if blinker>0.77 then
						if alpha82<=1 then
							alpha82=alpha82-blinkercoeff*0.2
						elseif alpha82>1 then
							alpha82=1
						elseif alpha82<0 then
							alpha82=0
						end
					end
				end
				if get(g430ackow)==1 then
					if alpha7>0 then
						alpha81=0
						alpha82=0
						alpha7=alpha7-0.1
						nightvar=nightvar-0.1
					else
						alpha81=0
						alpha82=0
						alpha7=0
						nightvar=0
					end
				end
			end
		else
			set(startlogic,0)
			if alpha1<1 then
				alpha1=alpha1+0.1
			else
				alpha1=1
			end
			alpha2=0
			alpha3=0
			alpha2=0
			alpha3=0
			alpha4=0
			alpha5=0
			alpha6=0
			alpha7=0
			alpha81=0
			alpha82=0
			nightvarh=get(sun_pitch_degrees)+10
			if nightvarh>5 and nightvarh<15 then
				nightvar=-7/15+7/nightvarh
			elseif nightvarh>15 then
				nightvar=0
			end
			if get(sun_pitch_degrees)<-5 then
				nightvar=1
			end
		end
	else
		set(startlogic,0)
		alpha1=1
		alpha2=0
		alpha3=0
		alpha4=0
		alpha5=0
		alpha6=0
		alpha7=0
		alpha81=0
		alpha82=0
		nightvarh=get(sun_pitch_degrees)+10
		if nightvarh>5 and nightvarh<15 then
			nightvar=-7/15+7/nightvarh
		elseif nightvarh>15 then
			nightvar=0
		end
		if get(sun_pitch_degrees)<-5 then
			nightvar=1
		end
	end
---GNS rotary logic
	if get(gns430coarseupdown)>gns430coarseupdownLOC then
		commandOnce(g430n1_coarse_up)
		gns430coarseupdownLOC=get(gns430coarseupdown)
	end
	if get(gns430coarseupdown)<gns430coarseupdownLOC then
		commandOnce(g430n1_coarse_down)
		gns430coarseupdownLOC=get(gns430coarseupdown)
	end
	if get(gns430finetune)>gns430finetuneLOC then
		commandOnce(g430n1_fine_up)
		gns430finetuneLOC=get(gns430finetune)
	end
	if get(gns430finetune)<gns430finetuneLOC then
		commandOnce(g430n1_fine_down)
		gns430finetuneLOC=get(gns430finetune)
	end
	if get(gns430chapterupdown)>gns430chapterupdownLOC then
		commandOnce(g430n1_chapter_up)
		gns430chapterupdownLOC=get(gns430chapterupdown)
	end
	if get(gns430chapterupdown)<gns430chapterupdownLOC then
		commandOnce(g430n1_chapter_dn)
		gns430chapterupdownLOC=get(gns430chapterupdown)
	end
	if get(gns430pageupdown)>gns430pageupdownLOC then
		commandOnce(g430n1_page_up)
		gns430pageupdownLOC=get(gns430pageupdown)
	end
	if get(gns430pageupdown)<gns430pageupdownLOC then
		commandOnce(g430n1_page_down)
		gns430pageupdownLOC=get(gns430pageupdown)
	end




end