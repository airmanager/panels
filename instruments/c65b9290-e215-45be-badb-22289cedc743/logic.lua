-------------------------------------
--     Load and display images     --
-------------------------------------
img_add_fullscreen("VacAmpFace.png")
img_vac = img_add("needle3.png", -160, 0, 512, 512)
img_amp = img_add("needle3.png", 150, 0, 512, 512)
img_add_fullscreen("VacAmpCover.png")


-----------------------------------------
-- Set default visibility and rotation --
-----------------------------------------

function new_vac(suct)
	suct = var_cap(suct, 2.9, 7.1)
	--img_rotate( img_vac , -56.5 + 29 *(7- suct) )
	img_rotate( img_vac, 215.0 - (suct * 25.0) )


end


function new_amps(amps)
	img_rotate(img_amp , 270 + (amps[1]))
end

function new_amps_fsx(amps)
	--print(amps)
	img_rotate(img_amp , 270 + (amps))
end

					  
xpl_dataref_subscribe( "sim/cockpit2/gauges/indicators/suction_1_ratio","FLOAT", new_vac)
xpl_dataref_subscribe( "sim/cockpit2/electrical/battery_amps","FLOAT[8]", new_amps)

fsx_variable_subscribe("SUCTION PRESSURE", "Inches of Mercury", new_vac)
fsx_variable_subscribe("ELECTRICAL BATTERY BUS AMPS", "Amperes", new_amps_fsx)