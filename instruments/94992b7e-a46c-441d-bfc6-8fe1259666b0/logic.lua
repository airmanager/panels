---------------------------------------------
--        Load and display images          --
---------------------------------------------
img_bg = img_add_fullscreen("attbg.png")
img_horizon = img_add_fullscreen("attdial.png")
img_bankind = img_add_fullscreen("attroll.png")
img_hoop = img_add_fullscreen("atthoop.png")
img_flag = img_add("GyroFlag.png", -120, -190, 512, 512)
img_add_fullscreen("attface.png")
--img_add("airknobshadow.png",213,400,85,85)

flag_rotation = 0
flag_state = 0

hoop_height = 0

---------------
-- Functions --
---------------

function new_attitude(roll, pitch)

-- Roll outer ring
    roll = var_cap(roll, -60, 60)
	img_rotate(img_bankind, roll *-1)
    img_rotate(img_bg, roll *-1)
-- Roll horizon
    img_rotate(img_horizon  , roll * -1)
    
-- Move horizon pitch
    pitch = var_cap(pitch, -25, 25)
    radial = math.rad(roll * -1)
    x = -(math.sin(radial) * pitch * 3)
    y = (math.cos(radial) * pitch * 3)
    img_move(img_horizon, x, y, nil, nil)
	

	
end


function timer_callback()
	
	if flag_state == 1 then
		-- extend
		flag_rotation = flag_rotation - 0.25
		if flag_rotation <= -30 then
			flag_rotation = -30
			timer_stop(tmr_flag)
		end
	else
		-- retract
		flag_rotation = flag_rotation + 0.25
		if flag_rotation >= 0 then
			flag_rotation = 0
			timer_stop(tmr_flag)
		end
	end

	img_rotate(img_flag, flag_rotation)
end

function new_vacfail(vacfail1, vacfail2, vac1, vac2)
	if (vacfail1 > 0 and vacfail2 > 0) or (vac1 < 1.8 and vac2 < 1.8) then
		flag_state = 1
	else
		flag_state = 0
	end
    timer_stop(tmr_flag)
	tmr_flag = timer_start(0, 250, timer_callback)
end

function new_vacfail_fsx(fail, vac)
	if fail > 0 or vac < 1.8 then
		flag_state = 1
	else
		flag_state = 0
	end
    
    timer_stop(tmr_flag)
	tmr_flag = timer_start(0, 250, timer_callback)
end

function new_attitude_fsx(roll, pitch)
	
	new_attitude(roll * -57, pitch * -37)

end

--This could be converted to a simulator control
--but for now it is manual.
function new_knob(value)
	hoop_height = hoop_height + value
	if hoop_height > 27 then
		hoop_height = 27
	end
	if hoop_height < -35 then
		hoop_height = -35
	end
	move(img_hoop, 0, hoop_height, 512, 512)
	print (hoop_height)
end

-- DIALS ADD --
dial_knob = dial_add("airknob.png", 213, 395, 85, 85, new_knob)
dial_click_rotate(dial_knob,6)

-------------------
-- Bus subscribe --
-------------------
xpl_dataref_subscribe("sim/cockpit/gyros/phi_vac_ind_deg", "FLOAT",
					  "sim/cockpit/gyros/the_vac_ind_deg", "FLOAT",	new_attitude)
					
xpl_dataref_subscribe("sim/operation/failures/rel_vacuum", "INT",
					  "sim/operation/failures/rel_vacuum2", "INT",
					  "sim/cockpit/misc/vacuum", "FLOAT", 
					  "sim/cockpit/misc/vacuum2", "FLOAT", new_vacfail)
					
fsx_variable_subscribe("ATTITUDE INDICATOR BANK DEGREES", "Radians",
					   "ATTITUDE INDICATOR PITCH DEGREES", "Radians", new_attitude_fsx)
					   
fsx_variable_subscribe("PARTIAL PANEL VACUUM", "Enum",
					   "SUCTION PRESSURE", "Inches of Mercury", new_vacfail_fsx)					   