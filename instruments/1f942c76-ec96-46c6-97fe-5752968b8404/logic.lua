img_add_fullscreen("casing.png")
img_needle = img_add_fullscreen("needle.png")
img_add_fullscreen("glass.png")
img_rotate(img_needle,-0)

function PT_vario(verticalspeed)
	angle = verticalspeed *175/2000

	angle = var_cap(angle, -175, 175)
    img_rotate(img_needle, angle-0)
end

xpl_dataref_subscribe("sim/cockpit2/gauges/indicators/vvi_fpm_pilot", "FLOAT", PT_vario)
fsx_variable_subscribe("VERTICAL SPEED", "Feet per minute", PT_vario)