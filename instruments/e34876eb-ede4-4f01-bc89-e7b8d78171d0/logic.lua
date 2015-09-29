-- Load and display text and images

img_background       = img_add_fullscreen("casing.png")
img_ball             = img_add("ball.png", 220,320,75,87)
img_plane            = img_add_fullscreen("plane.png")
img_add_fullscreen("scratches.png")

-- Callback functions (handles data received from X-plane)

function new_ball_deflection(slip)
	slip = var_cap(slip, -7.1, 7.1)
	slip_rad = math.rad(slip * 2.6)
	
	x = (0 * math.cos(slip_rad)) - (292 * math.sin(slip_rad))
	y = (0 * math.sin(slip_rad)) + (292 * math.cos(slip_rad))
	
    img_move(img_ball, x + 220,y + 28,nil,nil)
end

function new_turnrate(roll)

	roll = var_cap(roll, -45, 45)
	img_rotate(img_plane, roll)
end

function new_ball_deflection_FSX(slip)
	
	slip = slip * -1
	
	new_ball_deflection(slip)
	
end

function new_turnrate_FSX(roll)

	new_turnrate(roll * 6)

end

-- subscribe functions on the AirBus
xpl_dataref_subscribe("sim/cockpit2/gauges/indicators/slip_deg", "FLOAT", new_ball_deflection)
xpl_dataref_subscribe("sim/flightmodel/misc/turnrate_roll", "FLOAT", new_turnrate)
fsx_variable_subscribe("INCIDENCE BETA", "Degrees", new_ball_deflection_FSX)
fsx_variable_subscribe("TURN INDICATOR RATE", "Degrees", new_turnrate_FSX)