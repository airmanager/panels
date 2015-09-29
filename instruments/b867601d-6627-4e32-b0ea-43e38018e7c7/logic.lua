-- Load and display text and images
img_add_fullscreen("background.png")
img_background_compass = img_add_fullscreen("background_compass.png")
img_plane              = img_add_fullscreen("plane.png")
img_add_fullscreen("backgroundblack.png")

-- Callback functions (handles data received from X-plane)

function new_rotation(rotation)
  img_rotate(img_background_compass, rotation *-1)
end

-- subscribe functions on the AirBus
xpl_dataref_subscribe("sim/cockpit2/gauges/indicators/compass_heading_deg_mag", "FLOAT", new_rotation)
fsx_variable_subscribe("PLANE HEADING DEGREES MAGNETIC", "degrees", new_rotation)
