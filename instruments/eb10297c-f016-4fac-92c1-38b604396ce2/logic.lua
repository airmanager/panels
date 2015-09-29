-- General vars --
gps_zoom = 12

-- Button functions --
function new_zoomplus()
	
	gps_zoom = gps_zoom + 1
	
	
	if (gps_zoom > 14) then
		gps_zoom = 14
	end
	
	map_zoom(navmap, gps_zoom)

end

function new_zoommin()
	
	gps_zoom = gps_zoom - 1
		
	if (gps_zoom < 7) then
		gps_zoom = 7
	end
	
	map_zoom(navmap, gps_zoom)

end

function new_home()

	gps_zoom = 12
	map_zoom(navmap, gps_zoom)
	
end

-------------------------------------
-- Load and display map and images --
-------------------------------------
img_add_fullscreen("GPSback.png")
img_add("zoomgps.png",531,302,32,78)
----------------------------------------------** MAP OPTIONS START **----------------------------------------------
-- Change zoom level '...OSM_MAPQUEST",zoom level)' to set your preferred zoom level, lower is out, higher is in --
-- Change map type '...,"map type",12)' to set your preferred map type. See the wiki for the options.            --
-- http://airrietveld.nl/wiki/                                                                                   --
-------------------------------------------------------------------------------------------------------------------

navmap = map_add(80,122,415,351,"OSM_MAPQUEST",12)

---------------------------------------------**** MAP OPTIONS END ****---------------------------------------------
-------------------------------------------------------------------------------------------------------------------

map_add_nav_img_layer(navmap, "AIRP", "airport.png", -13, -13, 26, 26)
map_add_nav_txt_layer(navmap, "AIRP", "NAME", "-fx-font-size:13px; -fx-fill: white; -fx-font-family:\"Arial Black\"; -fx-font-weight: bold;  -fx-text-alignment:center; -fx-stroke: black; -fx-stroke-width: 1;", -40, -30, 80, 40)
img_add("northarrow.png", 90, 130, 25, 25)
airplane_icon = img_add("airplane.png", 275, 285, 25, 25)

---------------------------
-- Load and display text --
---------------------------
txt_add("N","-fx-font-size:12px; -fx-fill: black; -fx-font-family:\"Arial Black\"; -fx-font-weight: bold;", 98,134,20,20)
txt_add("DG","-fx-font-size:18px; -fx-fill: white; -fx-font-family:\"Arial Black\"; -fx-font-weight: bold;  -fx-text-alignment:center; -fx-stroke: black; -fx-stroke-width: 1;", 394,130,100,50)
txt_heading = txt_add(" ","-fx-font-size:22px; -fx-fill: white; -fx-font-family:\"Arial Black\"; -fx-font-weight: bold;  -fx-text-alignment:center; -fx-stroke: black; -fx-stroke-width: 1;", 394,145,100,50)
txt_add("GS","-fx-font-size:18px; -fx-fill: white; -fx-font-family:\"Arial Black\"; -fx-font-weight: bold;  -fx-text-alignment:center; -fx-stroke: black; -fx-stroke-width: 1;", 90,420,100,50)
txt_ground_speed = txt_add(" ","-fx-font-size:22px; -fx-fill: white; -fx-font-family:\"Arial Black\"; -fx-font-weight: bold;  -fx-text-alignment:center; -fx-stroke: black; -fx-stroke-width: 1;", 90,435,100,50)
txt_TFT = txt_add("TFT","-fx-font-size:18px; -fx-fill: white; -fx-font-family:\"Arial Black\"; -fx-font-weight: bold;  -fx-text-alignment:center; -fx-stroke: black; -fx-stroke-width: 1;", 391,410,100,50)
txt_totfltm = txt_add("00:00","-fx-font-size:22px; -fx-fill: white; -fx-font-family:\"Arial Black\"; -fx-font-weight: bold;  -fx-text-alignment:center; -fx-stroke: black; -fx-stroke-width: 1;", 340,425,200,50)
txt_mode = txt_add(" ","-fx-font-size:22px; -fx-fill: #b6cfe5; -fx-font-family: Arial; -fx-font-weight: bold;  -fx-text-alignment:center;", 305,88,200,50)
txt_radioalt = txt_add(" ","-fx-font-size:22px; -fx-fill: #00ff00; -fx-font-family: Arial; -fx-font-weight: bold;  -fx-text-alignment:center;", 305,50,200,50)
txt_nav1 = txt_add(" ","-fx-font-size:22px; -fx-fill: #00ff00; -fx-font-family: Arial; -fx-font-weight: bold;  -fx-text-alignment:center;", 170,50,200,50)
txt_nav1stby =  txt_add(" ","-fx-font-size:22px; -fx-fill: #b6cfe5; -fx-font-family: Arial; -fx-font-weight: bold;  -fx-text-alignment:center;", 170,88,200,50)
txt_com1 = txt_add(" ","-fx-font-size:22px; -fx-fill: #00ff00; -fx-font-family: Arial; -fx-font-weight: bold;  -fx-text-alignment:center;", 79,50,200,50)
txt_com1stby =  txt_add(" ","-fx-font-size:22px; -fx-fill: #b6cfe5; -fx-font-family: Arial; -fx-font-weight: bold;  -fx-text-alignment:center;", 79,88,200,50)
txt_hpa = txt_add(" ","-fx-font-size:22px; -fx-fill: #b6cfe5; -fx-font-family: Arial; -fx-font-weight: bold;  -fx-text-alignment:center;", 346,490,200,50)
txt_OAT = txt_add(" ","-fx-font-size:22px; -fx-fill: #b6cfe5; -fx-font-family: Arial; -fx-font-weight: bold;  -fx-text-alignment:center;", 27,490,200,50)

---------------
-- Functions --
---------------

function new_position(latitude, longitude, heading, groundspeed, timer)

-- Set position on world map --
map_goto(navmap, longitude, latitude)

-- Rotate airplane icon to current heading --
img_rotate(airplane_icon, heading)

-- Set heading text --
txt_set(txt_heading, string.format("%01d" .. "\194\176", heading) )

-- Set groundspeed text --
txt_set(txt_ground_speed, string.format("%01d" .. " KT", groundspeed) )

-- Set flight time text HH:MM --
if timer == 0 then
txt_set(txt_TFT, " ")
txt_set(txt_totfltm, " ")
else
txt_set(txt_TFT, "TFT")
txt_set(txt_totfltm, string.format("%02d:%02d",(timer / 3600), ( (timer / 60) % 60) ) )
end

end

function new_navcomm(mode, radioalt, nav1, nav1stby, com1, com1stby, outsideAT, baro)

-- Transponder mode --
	if mode == 0 then
		txt_set(txt_mode, "OFF")
	elseif mode == 1 then
		txt_set(txt_mode, "STBY")
	elseif mode == 2 then
		txt_set(txt_mode, "ON")
	elseif mode == 3 then
		txt_set(txt_mode, "ALT")
	elseif mode == 4 then
		txt_set(txt_mode, "TST")
	end

-- Radio altimeter --
	if radioalt < 2500 then
		txt_set(txt_radioalt, string.format("%01d", radioalt) )
	else
		txt_set(txt_radioalt, "2500+" )
	end

-- Frequency text set ---
txt_set(txt_nav1,  string.format("%d.%.02d",nav1/100, nav1%100) )
txt_set(txt_nav1stby,  string.format("%d.%.02d",nav1stby/100, nav1stby%100) )	

txt_set(txt_com1,  string.format("%d.%.02d",com1/100, com1%100) )
txt_set(txt_com1stby,  string.format("%d.%.02d",com1stby/100, com1stby%100) )

-- OAT and barometic setting --
txt_set(txt_OAT,  string.format("%01d" .. "\° C", outsideAT) )
txt_set(txt_hpa, string.format("%02d", baro * 33.8639) )

end

function new_navcomm_FSX(squawk, radioalt, nav1, nav1stby, com1, com1stby, outsideAT, baro)

	nav1 = nav1 / 10
	nav1stby = nav1stby / 10
	com1 = com1 / 10
	com1stby = com1stby / 10

	if squawk >0 then
	mode = 2
	else
	mode = 0
	end
	
	new_navcomm(mode, radioalt, nav1, nav1stby, com1, com1stby, outsideAT, baro)
	
end

-- Switches, buttons and dials --
button_zoomplus = button_add("zoomplus.png","zoompluspr.png",533,304,28,28, new_zoomplus)
button_zoommin = button_add("zoommin.png","zoomminpres.png",533,350,28,28, new_zoommin)
button_home = button_add("homebutton.png","homebuttonpr.png",527,391,40,35, new_home)

-------------------
-- Bus subscribe --
-------------------
xpl_dataref_subscribe("sim/flightmodel/position/latitude", "DOUBLE",
			  "sim/flightmodel/position/longitude", "DOUBLE", 
			  "sim/flightmodel/position/mag_psi", "FLOAT",
			  "sim/flightmodel/position/groundspeed", "FLOAT", 
			  "sim/time/total_flight_time_sec", "FLOAT", new_position)
xpl_dataref_subscribe("sim/cockpit/radios/transponder_mode", "INT", 
			  "sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot", "FLOAT", 
			  "sim/cockpit/radios/nav1_freq_hz", "INT", 
			  "sim/cockpit/radios/nav1_stdby_freq_hz", "INT", 
			  "sim/cockpit/radios/com1_freq_hz", "INT", 
			  "sim/cockpit/radios/com1_stdby_freq_hz", "INT", 
			  "sim/cockpit2/temperature/outside_air_temp_degc", "FLOAT", 
			  "sim/cockpit/misc/barometer_setting", "FLOAT", new_navcomm)
fsx_variable_subscribe("GPS POSITION LAT", "Degrees",
					   "GPS POSITION LON", "Degrees",
					   "PLANE HEADING DEGREES MAGNETIC", "Degrees",
					   "GPS GROUND SPEED", "Knots", new_position)
fsx_variable_subscribe("TRANSPONDER CODE:1", "Number",
					   "GPS POSITION ALT", "Feet",
					   "NAV ACTIVE FREQUENCY:1", "KHz",
					   "NAV STANDBY FREQUENCY:1", "KHz",
					   "COM ACTIVE FREQUENCY:1", "KHz",
					   "COM STANDBY FREQUENCY:1", "KHz",
					   "AMBIENT TEMPERATURE", "Celsius",
					   "KOHLSMAN SETTING HG", "inHg", new_navcomm_FSX)