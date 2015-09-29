-- Add images in Z-order --
img_backplate = img_add_fullscreen("1.png")
img_horizon = img_add_fullscreen("2.png")
img_ring = img_add_fullscreen("3.png")
img_pointer = img_add_fullscreen("4.png")
img_add_fullscreen("5.png")

-- Functions --
function PT_atitude(roll, pitch)    
-- roll outer ring
    img_rotate(img_ring, roll *-1)
        
-- roll horizon
    img_rotate(img_horizon  , roll * -1)
	
-- roll backplate
	img_rotate(img_backplate , roll * -1)
    
-- move horizon pitch
    pitch = var_cap(pitch,-30,30)
    radial = math.rad(roll * -1)
    x = -(math.sin(radial) * pitch * 3)
    y = (math.cos(radial) * pitch * 3)
    img_move(img_horizon, x, y, nil, nil)
 
end

function new_attitude_fsx(roll, pitch, slip)
	
	PT_atitude(roll *-1, pitch * -1)

end

-- Bus subscribe -- 
xpl_dataref_subscribe("sim/cockpit/gyros/phi_vac_ind_deg", "FLOAT",
					  "sim/cockpit/gyros/the_vac_ind_deg", "FLOAT", PT_atitude)
fsx_variable_subscribe("ATTITUDE INDICATOR BANK DEGREES", "Degrees",
					   "ATTITUDE INDICATOR PITCH DEGREES", "Degrees", new_attitude_fsx)