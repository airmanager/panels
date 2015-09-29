img_add_fullscreen("gauge_face.png")
img_needle = img_add_fullscreen("needle.png")
img_rotate(img_needle, -78)

function PT_airspeed(airspeed)
    -- rotate the needle only if airspeed is above 25kts
	airspeed = var_cap(airspeed, 32, 170)
	
    img_rotate(img_needle, airspeed*320/130 -78)
end

-- Subscribe to bus
xpl_dataref_subscribe("sim/cockpit2/gauges/indicators/airspeed_kts_pilot", "FLOAT", PT_airspeed)
fsx_variable_subscribe("AIRSPEED INDICATED", "knots", PT_airspeed)
-- init the needle

PT_airspeed(0)