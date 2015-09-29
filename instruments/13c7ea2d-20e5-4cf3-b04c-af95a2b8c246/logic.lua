-- Button functions --
function new_onoff(state, direction)
	
	xpl_dataref_write("sim/cockpit2/radios/actuators/com2_power", "INT", state + direction)
	fsx_event("TOGGLE_AVIONICS_MASTER", state + direction)
	
end

function new_comtransfer()

	xpl_command("sim/radios/com2_standy_flip")
	fsx_event("COM2_STBY_RADIO_SWAP")
	
end

function new_navtransfer()

	xpl_command("sim/radios/nav2_standy_flip")
	fsx_event("NAV2_RADIO_SWAP")
	
end

function new_combig(combigvar)
	
	if combigvar == 1 then
		xpl_command("sim/radios/stby_com2_coarse_up")
		fsx_event("COM2_RADIO_WHOLE_INC")
	elseif combigvar == -1 then
		xpl_command("sim/radios/stby_com2_coarse_down")
		fsx_event("COM2_RADIO_WHOLE_DEC")
	end

end

function new_comsmall(comsmallvar)

	if comsmallvar == 1 then
		xpl_command("sim/radios/stby_com2_fine_up")
		fsx_event("COM2_RADIO_FRACT_INC")
	elseif comsmallvar == -1 then
		xpl_command("sim/radios/stby_com2_fine_down")
		fsx_event("COM2_RADIO_FRACT_DEC")
	end

end

function new_navbig(navbigvar)
	
	if navbigvar == 1 then
		xpl_command("sim/radios/stby_nav2_coarse_up")
		fsx_event("NAV2_RADIO_WHOLE_INC")
	elseif navbigvar == -1 then
		xpl_command("sim/radios/stby_nav2_coarse_down")
		fsx_event("NAV2_RADIO_WHOLE_DEC")
	end

end

function new_navsmall(navsmallvar)

	if navsmallvar == 1 then
		xpl_command("sim/radios/stby_nav2_fine_up")
		fsx_event("NAV2_RADIO_FRACT_INC")
	elseif navsmallvar == -1 then
		xpl_command("sim/radios/stby_nav2_fine_down")
		fsx_event("NAV2_RADIO_FRACT_DEC")
	end

end

-- Add images in Z-order --
img_add_fullscreen("KX165A.png")
redline = img_add("redline.png", 349, 34, 2, 60)

-- Add text --
txt_com2 = txt_add(" ", "-fx-font-size:40px; -fx-fill: #fb2c00; -fx-text-alignment: LEFT;", 25, 35, 200, 200)
txt_com2stby = txt_add(" ", "-fx-font-size:40px; -fx-fill: #fb2c00; -fx-text-alignment: LEFT;", 200, 35, 200, 200)

txt_nav2 = txt_add(" ", "-fx-font-size:40px; -fx-fill: #fb2c00; -fx-text-alignment: LEFT;", 365, 35, 200, 200)
txt_nav2stby = txt_add(" ", "-fx-font-size:40px; -fx-fill: #fb2c00; -fx-text-alignment: LEFT;", 520, 35, 200, 200)

-- Set default visibility --
img_visible(redline, false)

-- Functions --
function new_navcomm(avionics, nav2, nav2stby, com2, com2stby, battery, generator)
	
	img_visible(redline, avionics >= 1 and (battery >= 1 or generator[1] >= 1))
	print(battery)
	if avionics >= 1 and (battery >= 1 or generator[1] >= 1) then
	  txt_set(txt_com2, string.format("%d.%.02d",com2/100, com2%100) )
	  txt_set(txt_com2stby, string.format("%d.%.02d",com2stby/100, com2stby%100))
	  txt_set(txt_nav2, string.format("%d.%.02d",nav2/100, nav2%100))
	  txt_set(txt_nav2stby, string.format("%d.%.02d",nav2stby/100, nav2stby%100) )
	else
	  txt_set(txt_com2, " ")
	  txt_set(txt_com2stby, " ")
	  txt_set(txt_nav2, " ")
	  txt_set(txt_nav2stby, " ")
	end
	
	switch_set_state(switch_onoff, avionics > 0)
	
end

function new_navcomm_FSX(avionics, nav2, nav2stby, com2, com2stby, battery, generator)

	if generator == true then
		generator = 1
	else
		generator = 0
	end
	
    new_navcomm(avionics, nav2*100+0.01, nav2stby*100+0.01, com2*100+0.01, com2stby*100+0.01, battery, {generator})
	
end

-- Switches, buttons and dials --
switch_onoff = switch_add("offswitch.png","onswitch.png",61,154,47,47, new_onoff)
comtransfer = button_add("switchfreq.png", "switchfreqpressed.png", 130, 135, 60, 38, new_comtransfer)
navtransfer = button_add("switchfreq.png", "switchfreqpressed.png", 487, 135, 60, 38, new_navtransfer)
combig = dial_add("dialbig.png", 229, 113, 85, 85, new_combig)
comsmall = dial_add("dialsmall.png", 239, 123, 60, 60, new_comsmall)
navbig = dial_add("dialbig.png", 594, 113, 85, 85, new_navbig)
navsmall = dial_add("dialsmall.png", 604, 123, 60, 60, new_navsmall)

-- Bus subscribe --
xpl_dataref_subscribe("sim/cockpit2/radios/actuators/com2_power", "INT",
					  "sim/cockpit/radios/nav2_freq_hz", "INT", 
					  "sim/cockpit/radios/nav2_stdby_freq_hz", "INT",
					  "sim/cockpit2/radios/actuators/com2_frequency_hz", "INT",
					  "sim/cockpit2/radios/actuators/com2_standby_frequency_hz", "INT", 
					  "sim/cockpit/electrical/battery_on", "INT", 
					  "sim/cockpit2/electrical/generator_on", "INT[8]", new_navcomm)
fsx_variable_subscribe("ELECTRICAL AVIONICS BUS VOLTAGE", "Volts",
					   "NAV ACTIVE FREQUENCY:2", "Mhz",
					   "NAV STANDBY FREQUENCY:2", "Mhz",
					   "COM ACTIVE FREQUENCY:2", "Mhz",
					   "COM STANDBY FREQUENCY:2", "Mhz",
					   "ELECTRICAL BATTERY BUS VOLTAGE", "Volts",
					   "GENERAL ENG GENERATOR SWITCH:1", "BOOL", new_navcomm_FSX)