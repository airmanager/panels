-- BUTTON, SWITCH AND DIAL FUNCTIONS --
function new_hdg(hdg)

	if hdg == -1 then
		xpl_command("sim/radios/adf1_down")
		fsx_event("ADF_CARD_DEC")
	elseif hdg == 1 then
		xpl_command("sim/radios/adf1_up")
		fsx_event("ADF_CARD_INC")
	end

end

img_add_fullscreen("ADFback.png")
rose = img_add_fullscreen("OBScard.png")
yellow_needle = img_add_fullscreen("ADFneedle.png")
img_add_fullscreen("ADFcover.png")
img_add("adfknobshadow.png",31,395,85,85)





function new_adf(heading, adfyellow)
	
	img_rotate(rose, heading* -1)
	
	if adfyellow > 89.5 and adfyellow < 90.5 then
		img_rotate(yellow_needle, 90)
	else
		img_rotate(yellow_needle, adfyellow)
	end
	

	
end
-- DIALS ADD --
dial_hdg = dial_add("adfknob.png", 31, 395, 85, 85, new_hdg)
dial_click_rotate(dial_hdg,6)
xpl_dataref_subscribe("sim/cockpit/radios/adf1_cardinal_dir", "FLOAT",
			  "sim/cockpit2/radios/indicators/adf1_relative_bearing_deg", "FLOAT", new_adf)
fsx_variable_subscribe("ADF CARD", "Degrees",
					   "ADF RADIAL:1", "Degrees", new_adf)