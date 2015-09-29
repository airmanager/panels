img_thousands = img_add("thousands.png", 142, 278, 145, 145)
img_hundreds = img_add("hundreds.png", 192, 278, 145, 145)
img_tens = img_add("tens.png", 242, 278, 145, 145)
img_hours = img_add("hours.png", 286, 278, 145, 145)
img_minutes = img_add("minutes.png", 328, 278, 145, 145)
img_add_fullscreen("casing.png")
img_needle = img_add_fullscreen ("engine_needle.png")
img_add_fullscreen("glass.png")

img_rotate(img_needle, 135)

function rotate_cylinder(image_id, val, ceil, exp)
  if (val%1) > ceil then
    img_rotate(image_id, 360 - ( ( (val%1)-ceil) * exp * 360) - (math.floor(val) * 36 )  )
  else
    img_rotate(image_id, 360 - (math.floor(val) * 36 ) )
  end
end

function PT_rpm(rpm)
    img_rotate(img_needle, rpm[1] * (270/3490) - 135)
end

function flight_time(time_sec)

    -- minutes
    minutes = time_sec / 60
    img_rotate(img_minutes, 360 - ( (minutes/10) * 360 ) )
    
    -- hours
    hours = minutes / 60
    rotate_cylinder(img_hours,     (hours)     , 0.9835,    6   )
    rotate_cylinder(img_tens,      (hours/10)  , 0.99835,   60  )
    rotate_cylinder(img_hundreds,  (hours/100) , 0.999835,  600 )
    rotate_cylinder(img_thousands, (hours/1000), 0.9999835, 6000)
end

function PT_rpm_FSX(rpm)

	PT_rpm({rpm})
	
end

-- Bus subscribe --
xpl_dataref_subscribe("sim/cockpit2/engine/indicators/prop_speed_rpm", "FLOAT[8]", PT_rpm)
xpl_dataref_subscribe("sim/time/hobbs_time", "FLOAT", flight_time)
fsx_variable_subscribe("PROP RPM:1", "Rpm", PT_rpm_FSX)
fsx_variable_subscribe("GENERAL ENG ELAPSED TIME:1", "Seconds", flight_time)