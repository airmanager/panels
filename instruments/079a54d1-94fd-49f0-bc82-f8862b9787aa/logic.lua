-- Load and display text and images
img_add_fullscreen("newheadingbg.png")
img_background_compass = img_add_fullscreen("newheadingcompass.png")
img_bug = img_add_fullscreen("newheadingbug.png")
img_plane = img_add_fullscreen("plane2.png")
img_add("knobshadow.png", 376, 400, 85, 85)
-- Callback functions (handles data received from X-plane or FSX)

function new_rotation(rotation)

	img_rotate(img_background_compass, rotation * -1)

end

function new_headbug(heading, bug)

	img_rotate(img_bug, bug - heading)

end

function new_knob_gyro(value)

	if value == 1 then
		fsx_event("GYRO_DRIFT_INC")
	elseif value == -1 then
		fsx_event("GYRO_DRIFT_DEC")
	end

end

function new_knob_hdg(value)

	if value == 1 then
		fsx_event("HEADING_BUG_INC")
		xpl_command("sim/autopilot/heading_up")
	elseif value == -1 then
		fsx_event("HEADING_BUG_DEC")
		xpl_command("sim/autopilot/heading_down")
	end

end

-- DIALS ADD --
dial_knob = dial_add("gyroknob.png", 31, 395, 85, 85, new_knob_gyro)
dial_click_rotate(dial_knob,6)

dial_knob_hdg = dial_add("hdgknob.png", 376, 395, 85, 85, new_knob_hdg)
dial_click_rotate(dial_knob_hdg,6)

-- Data bus subscribe --
xpl_dataref_subscribe("sim/cockpit/gyros/psi_vac_ind_degm", "FLOAT", new_rotation)
fsx_variable_subscribe("HEADING INDICATOR", "degrees", new_rotation)

xpl_dataref_subscribe("sim/cockpit/gyros/psi_vac_ind_degm", "FLOAT",
					  "sim/cockpit/autopilot/heading_mag", "FLOAT", new_headbug)
fsx_variable_subscribe("HEADING INDICATOR", "degrees",
					   "AUTOPILOT HEADING LOCK DIR", "degrees", new_headbug)