
-- AIRSPEED INDICATOR
as_card = img_add_fullscreen("aircard.png")
img_add_fullscreen("airspeed.png")
as_needle =  img_add("needle.png",0,0,512,512)
img_add("airknobshadow.png",31,400,85,85)

card = 0

function new_speed(speed)

	speed = var_cap(speed, 0, 220)

	if speed >= 160 then
		img_rotate(as_needle,266 + ((speed-160)*1.3))
	--img_rotate(as_needle,266 + (1.2714285714285707 * speed ))

	elseif speed >= 120 then
		img_rotate(as_needle,205 + ((speed-120)*1.525))

	elseif speed >= 100 then
		img_rotate(as_needle,162 + ((speed-100)*2.15))

	elseif speed >= 70 then
		img_rotate(as_needle,92 + ((speed-70)*2.29))

	elseif speed >= 40 then

		img_rotate(as_needle,31 + ((speed-40)*2.033))
	else
		img_rotate(as_needle, (speed*0.775))
	end
		
end

-- This function isn't setup yet.  FSX doesn't appear
-- to expose this value.  X-Plane might expose it as 
-- sim/aircraft/view/acf_asi_kts	int	y	enum	air speed indicator knots calibration
-- but I have not tested it.  For now, we just allow manual manipulation on the screen by 
-- clicking on the knob.
function new_cali(degrees)
	img_rotate(as_card, degrees)
end

function new_knob(value)
	card = card + value
	if card > 48 then
		card = 49
	end
	if card < -135 then
		card = -135
	end
	img_rotate(as_card, card)
end

-- DIALS ADD --
dial_knob = dial_add("airknob.png", 31, 395, 85, 85, new_knob)
dial_click_rotate(dial_knob,6)


xpl_dataref_subscribe("sim/cockpit2/gauges/indicators/airspeed_kts_pilot", "FLOAT", new_speed)
fsx_variable_subscribe("AIRSPEED INDICATED", "knots", new_speed)
--fsx_variable_subscribe("AIRSPEED TRUE CALIBRATE", "Degrees", new_cali)

-- end AIRSPEED INDICATOR

