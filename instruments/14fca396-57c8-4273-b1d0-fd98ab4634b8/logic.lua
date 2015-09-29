-- Add images in Z-order --
img_add_fullscreen("GermonGTX723.png", 0, 0, 700, 180)
img_lit = img_add_fullscreen("GermonGTX723lit.png", 0, 0, 700, 180)
img_light = img_add_fullscreen("GermonGTX723light.png", 0, 0, 700, 180)
img_reply = img_add_fullscreen("reply.png", 0, 0, 700, 180)

-- Add text --
txt_load_font("volter.ttf")
txt_ident = txt_add(" ", "-fx-font-family:\"Volter (Goldfish)\"; -fx-font-size:12px; -fx-fill: #e8e65f; -fx-font-weight:bold;", 190, 25, 200, 200)
txt_squawk = txt_add(" ", "-fx-font-family:\"Volter (Goldfish)\"; -fx-font-size:50px; -fx-fill: #e8e65f; -fx-font-weight:bold; -fx-text-alignment: CENTER;", 240, 46, 200, 200)
txt_mode = txt_add(" ", "-fx-font-family:\"Volter (Goldfish)\"; -fx-font-size:20px; -fx-fill: #e8e65f; -fx-font-weight:bold; -fx-text-alignment: LEFT;", 190, 56, 200, 200)
txt_pralt = txt_add(" ", "-fx-font-family:\"Volter (Goldfish)\"; -fx-font-size:13px; -fx-fill: #e8e65f; -fx-font-weight:bold; -fx-text-alignment: LEFT;", 450, 80, 200, 200)
txt_fl = txt_add(" ", "-fx-font-family:\"Volter (Goldfish)\"; -fx-font-size:13px; -fx-fill: #e8e65f; -fx-font-weight:bold; -fx-text-alignment: LEFT;", 475, 95, 200, 200)
txt_flft = txt_add(" ", "-fx-font-family:\"Volter (Goldfish)\"; -fx-font-size:13px; -fx-fill: #e8e65f; -fx-font-weight:bold; -fx-text-alignment: LEFT;", 495, 95, 200, 200)
txt_fltm = txt_add(" ", "-fx-font-family:\"Volter (Goldfish)\"; -fx-font-size:13px; -fx-fill: #e8e65f; -fx-font-weight:bold; -fx-text-alignment: LEFT;", 455, 30, 200, 200)
txt_totfltm = txt_add(" ", "-fx-font-family:\"Volter (Goldfish)\"; -fx-font-size:13px; -fx-fill: #e8e65f; -fx-font-weight:bold; -fx-text-alignment: LEFT;", 470, 45, 200, 200)

-- Set default visibility --
img_visible(img_light, false)
img_visible(img_reply, false)
img_visible(img_lit, false)

-- Boolean indicating if the blinking light should be activated
img_light_active = false

-- Functions --
function new_transponder(ident, squawk, mode, alt, timer, lit)

	if ident == 1 and mode >= 2 then
		txt_set(txt_ident, "IDENT")
	else
		txt_set(txt_ident, " ")
	end

	if mode >= 1 then
		txt_set(txt_squawk, squawk)
	else
		txt_set(txt_squawk, " ")
	end
	
	img_light_active = (mode == 2) or (mode == 3)
	
	if mode == 0 then
		txt_set(txt_mode, " ")
	elseif mode == 1 then
		txt_set(txt_mode, "STBY")
	elseif mode == 2 then
		txt_set(txt_mode, "ON")
	elseif mode == 3 then
		txt_set(txt_mode, "ALT")
	elseif mode == 4 then
		txt_set(txt_mode, "TST")
	end
	
	img_visible(img_reply, mode == 2 or mode == 3)
	
	if mode >= 1 then
		txt_set(txt_pralt, "PRESSURE ALT")
	else
		txt_set(txt_pralt, " ")
	end
	
	if mode >= 1 then
		txt_set(txt_fl, "FL")
	else
		txt_set(txt_fl, " ")
	end
	
	altft = alt / 100
	altft = var_round(altft, 0)
	var_cap(altft, 0, 999)
	
	if mode >= 1 and altft < 10 then
		txt_set(txt_flft, string.format("00" .. "%d", altft ) )
	elseif mode >= 1 and altft >= 10 and altft <= 99 then
		txt_set(txt_flft, string.format("0" .. "%d", altft ) )
	elseif mode >= 1 and altft >= 100 then
		txt_set(txt_flft, altft )
	elseif mode == 0 then
		txt_set(txt_flft, " ")
	end
	
	if mode >= 1 then
		txt_set(txt_fltm, "FLIGHT TIME")
	else
		txt_set(txt_fltm, " ")
	end
	
	if mode >= 1 then
		txt_set(txt_totfltm, string.format("%02d:%02d:%02d",(timer / 3600), ( (timer / 60) % 60),(timer % 60) ) )
	else
		txt_set(txt_totfltm, " ")
	end
	
	img_visible(img_lit, lit == 1 and mode >= 1)
	
end


blink_val = false


-- This value is called every x milliseconds to let the light blink
function blink_timer_callback()
  blink_val = not blink_val
  img_visible(img_light, blink_val and img_light_active)
end

-- Bus subscribe --
xpl_dataref_subscribe("sim/cockpit/radios/transponder_id", "INT",
					  "sim/cockpit/radios/transponder_code", "INT",
					  "sim/cockpit/radios/transponder_mode", "INT",
					  "sim/flightmodel/misc/h_ind", "FLOAT", 
					  "sim/time/total_flight_time_sec", "FLOAT", 
					  "sim/cockpit/electrical/cockpit_lights_on", "INT", new_transponder)

timer_start(0, 2000, blink_timer_callback)