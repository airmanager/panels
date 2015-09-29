-- Button functions --
function new_flapsset(flapsset)
	
	if flapsset == 1 then
		xpl_command("sim/flight_controls/flaps_down")
		fsx_event("FLAPS_INCR")
	elseif flapsset == -1 then
		xpl_command("sim/flight_controls/flaps_up")
		fsx_event("FLAPS_DECR")
	end

end

-- Add images in Z-order --
img_fond_flaps = img_add("fond_flaps.png", 0, 0, 200, 330)
img_button = img_add("button.png", 0, 0, 80, 35)

-- Functions --
function new_flaps(flapsdeployment)
	
	X_pos = 81	
	
	if flapsdeployment < 0.25 then 
		X_pos = X_pos
	elseif flapsdeployment >= 0.25 and flapsdeployment < 0.5 then
		X_pos = X_pos + 6
	elseif flapsdeployment >= 0.5 then
		X_pos = X_pos + 12
	end
	
	Y_pos= flapsdeployment * 220 + 53
	
	img_move(img_button, X_pos, Y_pos, nil, nil)
	
end

function new_flaps_FSX(flaps)

	new_flaps(flaps / 100)
	
end

-- Switches, buttons and dials --
but_flaps = dial_add("but_transp.png", 72, 40, 70, 264, new_flapsset)

-- Bus subscribe --
xpl_dataref_subscribe("sim/flightmodel2/controls/flap1_deploy_ratio", "FLOAT", new_flaps)
fsx_variable_subscribe("FLAPS HANDLE PERCENT", "Percent", new_flaps_FSX)