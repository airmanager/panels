-- Add images in Z-order --
img_add_fullscreen("casing.png")
rose = img_add_fullscreen("dial.png")
adf_needle = img_add_fullscreen("needle.png")
img_add_fullscreen("ring.png")
img_add_fullscreen("glass.png")
img_add("hdg.png", 10, 390, 121, 121)

-- Functions --
function PT_adf(heading, adfgreen)
	
	img_rotate(rose, heading* -1)
	
	if adfgreen > 89.5 and adfgreen < 90.5 then
		img_rotate(adf_needle, 90)
	else
		img_rotate(adf_needle, adfgreen)
	end	
	
end

-- Bus subscribe --
xpl_dataref_subscribe("sim/cockpit/radios/adf1_cardinal_dir", "FLOAT",
					  "sim/cockpit2/radios/indicators/adf1_relative_bearing_deg", "FLOAT", PT_adf)
fsx_variable_subscribe("ADF CARD", "Degrees",
					   "ADF RADIAL:1", "Degrees",
					   "ADF RADIAL:2", "Degrees", PT_adf)