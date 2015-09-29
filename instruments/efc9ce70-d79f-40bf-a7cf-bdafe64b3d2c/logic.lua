-- Button, switches and dials functions --
function new_baro(baroset)

	if baroset == 1 then
		xpl_command("sim/instruments/barometer_up")
		fsx_event("KOHLSMAN_INC")
	elseif baroset == -1 then
		xpl_command("sim/instruments/barometer_down")
		fsx_event("KOHLSMAN_DEC")
	end

end

-- Add images in Z-order --
baro_img_id = img_add("baro_dial.png", 206, 130, 241, 241)
img_add_fullscreen("altitude_scale.png")
img_small_k_needle = img_add_fullscreen("round_needle.png")
img_small_needle = img_add_fullscreen("small_needle.png")
img_big_needle = img_add_fullscreen("long_needle.png")
img_add_fullscreen("scratches.png")

-- Functions --
function PT_altimeter(altitude, pressure)
    k = (altitude/10000)*36
    h = ( (altitude - math.floor(altitude/10000)*10000)/1000 )*36
    t = ( altitude - math.floor(altitude/10000)*10000 )*0.36
    
    img_rotate(img_small_k_needle, k)
    img_rotate(img_small_needle, h)    
    img_rotate(img_big_needle, t) 
    
    kk = k/3.6
    hh = h/36
    tt = t/0.36-hh*1000
    
    txt_set(txt_altk,  string.format("%02d",var_round(altitude/100,0)*100 ) )
	--txt_set(txt_inhg, string.format("%.02f", pressure) )    
	txt_set(txt_inhg, string.format("%.02d.%.02d", pressure, (pressure*100)%100 ) )    
	txt_set(txt_hpa,  string.format("%02d",pressure * 33.8639) )

end

-- This function will be called when new pressure value is received from X-plane
function baro_callback(pressure)

        -- Only show values between 28.0 and 31.0
	pressure = var_cap(pressure, 28.0, 31.0)
	
	-- Calculate image rotation (degrees) from pressure (hg)
	-- full scale in degrees divided by full scale in hg (360 / 3.0)
        -- Also add 90 degrees since the lowest value (28.0) is on the image top, and we need it on the right
	angle = 92 - ( (pressure-28.0) * (360 / 3.0) )
	
	-- Rotate the image
	img_rotate(baro_img_id, angle)

end

-- Buttons, switches and dials --
dial_baro = dial_add("barset_dial.png", 33, 409, 83, 83, new_baro)

-- Bus subscribe -- 
xpl_dataref_subscribe("sim/cockpit/misc/barometer_setting", "FLOAT", baro_callback)
xpl_dataref_subscribe("sim/cockpit2/gauges/indicators/altitude_ft_pilot", "FLOAT",
					  "sim/cockpit/misc/barometer_setting", "FLOAT", PT_altimeter)
fsx_variable_subscribe("INDICATED ALTITUDE", "Feet",
					   "KOHLSMAN SETTING HG", "inHg", PT_altimeter)
fsx_variable_subscribe("KOHLSMAN SETTING HG", "inHg", baro_callback)