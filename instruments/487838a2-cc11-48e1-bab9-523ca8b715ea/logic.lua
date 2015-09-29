-- Load and display text and images
img_add_fullscreen("turnback.png")

img_background       = img_add_fullscreen("TurnSlipFace3.png")
img_flag     			= img_add_fullscreen("SlipFlagOn.png")
img_plane            = img_add("TurnPlane.png",0,0,512,512)


img_ball             	= img_add("ball.png", 231,300,53,53)
img_background_bubble   = img_add_fullscreen("TurnSlipBubble.png")

img_background_cover    = img_add_fullscreen("TurnSlipCover.png")

-- Callback functions (handles data received from X-plane)

function new_ball_deflection(slip)
	slip = var_cap(slip, -8.1, 8.1)

	slip_rad = math.rad(slip * 1.6)
	x = (0 * math.cos(slip_rad)) - (482 * math.sin(slip_rad))
	y = (0 * math.sin(slip_rad)) + (482 * math.cos(slip_rad))
	
	img_move(img_ball, x + 225,y - 161,nil,nil)
end

function new_turnrate(roll)
	roll = var_cap(roll, -45, 45)
	img_rotate(img_plane, roll)
end

function new_ball_deflection_fsx(slip)

	--slip = slip * -100
	slip = slip * -9
		print(slip)
	new_ball_deflection(slip)
	
end

function new_battery(battery)
	visible(img_flag, battery[1] == 0)
	
	--print(battery[1])
end

function new_battery_fsx(busvolts)
	--print(busvolts)
	if busvolts < 6 then
		visible(img_flag, true)
	else
		visible(img_flag, false)
	end 
end

function new_turnrate_fsx(roll)
	
	roll = roll * -40
	new_turnrate(roll)
	
end

-- subscribe functions on the AirBus
xpl_dataref_subscribe("sim/cockpit2/gauges/indicators/slip_deg", "FLOAT", new_ball_deflection)
xpl_dataref_subscribe("sim/flightmodel/misc/turnrate_roll", "FLOAT", new_turnrate)
xpl_dataref_subscribe("sim/cockpit/electrical/battery_array_on", "INT[8]", new_battery)
--fsx_variable_subscribe("INCIDENCE BETA", "radians", new_ball_deflection_fsx)
fsx_variable_subscribe("TURN COORDINATOR BALL", "Position", new_ball_deflection_fsx)
fsx_variable_subscribe("PLANE BANK DEGREES", "radians", new_turnrate_fsx)
fsx_variable_subscribe("ELECTRICAL MAIN BUS VOLTAGE", "volts", new_battery_fsx)