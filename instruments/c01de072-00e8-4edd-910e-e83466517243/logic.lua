-- General vars --
oatv_state = 0
time_state = 0

-- Button functions --
function new_oatv()
	
	oatv_state = oatv_state + 1
	
	if (oatv_state > 1) then
	oatv_state = 0
	end
	
end

function new_time()
	
	time_state = time_state + 1
	
	if (time_state > 3) then
	time_state = 0
	end
	
end

function new_control()
    xpl_command("sim/instruments/timer_start_stop")
end

-- Load images in Z-order --
txt_load_font("digital-7-mono.ttf")
img_add_fullscreen("AMtronoff.png")
img_on = img_add_fullscreen("AMtronon.png")
img_light = img_add_fullscreen("AMtrononlight.png")
img_UT = img_add("arrowup.png",57,213,34,6)
img_FT = img_add("arrowdown.png",57,222,34,6)
img_LT = img_add("arrowup.png",105,213,34,6)
img_ET = img_add("arrowdown.png",105,222,34,6)

-- Load text in Z-order --
txt_time = txt_add(" ", "-fx-font-size:80px; -fx-font-family:\"Digital-7 Mono\"; -fx-fill: black; -fx-font-weight:bold; -fx-text-alignment: RIGHT;", 135, 200, 200, 100)
txt_tempvolt = txt_add(" ", "-fx-font-size:80px; -fx-font-family:\"Digital-7 Mono\"; -fx-fill: black; -fx-font-weight:bold; -fx-text-alignment: CENTER;", 45, 103, 300, 250)

-- Set default visibility --
visible(img_on, false)
visible(img_light, false)
visible(img_UT, false)
visible(img_FT, false)
visible(img_LT, false)
visible(img_ET, false)
visible(txt_time, false)

-- Functions --
function new_timeoat(time_zulu, time_local, time_flight, time_elapsed, temperature, avionics, light, voltage)

	visible(img_on, avionics == 1)
	visible(img_light, light >= 1 and avionics == 1)
	
	if time_state == 0 then
		vis_time = string.format("%02d:%02d",(time_zulu / 3600), ( (time_zulu / 60) % 60) )
	elseif time_state == 1 then
		vis_time = string.format("%02d:%02d",(time_local / 3600), ( (time_local / 60) % 60) )
	elseif time_state == 2 then
		vis_time = string.format("%02d:%02d",(time_flight / 3600), ( (time_flight / 60) % 60) )
	elseif time_state == 3 then
		vis_time = string.format("%02d:%02d",(time_elapsed / 60), ( time_elapsed % 60) )
	end
	
	visible(img_UT, time_state == 0 and avionics == 1)
	visible(img_FT, time_state == 2 and avionics == 1)
	visible(img_LT, time_state == 1 and avionics == 1)
	visible(img_ET, time_state == 3 and avionics == 1)
	
	if oatv_state == 0 and avionics == 1 then
		txt_set(txt_tempvolt, string.format("T " .. "%01d" .. "\°C", temperature ) )
	elseif oatv_state == 1 and avionics == 1 then
		txt_set(txt_tempvolt, string.format("%02d" .. "E", voltage[1] ) )
	else
		txt_set(txt_tempvolt, " ")
	end
	
	visible(txt_time, avionics == 1)
	txt_set(txt_time, vis_time)
	
end

function new_timeoat_fsx(time_zulu, time_local, time_elapsed, temperature, avionics, light, voltage)

	avionics = fif(avionics, 1, 0)
	light = fif(light, 1, 0)

-- There is no flight time and timer elapsed time in FSX
	new_timeoat(time_zulu, time_local, 0, 0, temperature, avionics, light, {voltage})

end

-- Switches, buttons and dials --
button_oatv    = button_add("buttonred.png","buttonredpr.png",184,28,32,32, new_oatv)
button_time    = button_add("buttonblue.png", "buttonbluepr.png", 104, 324, 32, 32, new_time)
button_control = button_add("buttonblue.png", "buttonbluepr.png", 267, 324, 32, 32, new_control)

-- subscribe functions on the AirBus
xpl_dataref_subscribe("sim/time/zulu_time_sec", "FLOAT",
					  "sim/time/local_time_sec", "FLOAT",
					  "sim/time/total_flight_time_sec", "FLOAT",
					  "sim/time/timer_elapsed_time_sec", "FLOAT",
					  "sim/weather/temperature_ambient_c", "FLOAT",
					  "sim/cockpit/electrical/avionics_on", "INT",
					  "sim/cockpit/electrical/cockpit_lights_on", "INT", 
					  "sim/cockpit2/electrical/battery_voltage_indicated_volts", "FLOAT[8]", new_timeoat)
fsx_variable_subscribe("ZULU TIME", "Seconds",
					   "LOCAL TIME", "Seconds",
					   "GENERAL ENG ELAPSED TIME:1", "Seconds",
					   "AMBIENT TEMPERATURE", "Celsius", 
					   "ELECTRICAL MASTER BATTERY", "Bool", 
					   "LIGHT PANEL ON", "Bool", 
					   "ELECTRICAL BATTERY VOLTAGE", "Volts", new_timeoat_fsx)