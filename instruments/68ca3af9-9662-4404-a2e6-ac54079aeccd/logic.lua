-------------------
--- GENERIC VOR ---
-------------------

-- BUTTON, SWITCH AND DIAL FUNCTIONS --
function new_obs(obs)

	if obs == -1 then
		xpl_command("sim/radios/obs2_down")
		fsx_event("VOR2_OBI_DEC")
	elseif obs == 1 then
		xpl_command("sim/radios/obs2_up")
		fsx_event("VOR2_OBI_INC")
	end

end

-- ADD IMAGES --
img_to = img_add_fullscreen("OBS2navto.png")
img_fr = img_add_fullscreen("OBS2navfr.png")
img_navflag = img_add_fullscreen("OBS2navflag.png")
img_add_fullscreen("OBS2face.png")
img_horbar = img_add("OBSneedle.png",0,-140,512,512)

img_compring = img_add_fullscreen("OBScard.png")
img_add_fullscreen("OBScover.png")
img_add("OBSknobshadow.png",31,395,85,85)


-- DEFAULT VISIBILITY --
visible(img_to, false)
visible(img_fr, false)
visible(img_navflag, false)
visible(img_gsflag, false)

-- FUNCTIONS --
function new_obsheading(obs)

	img_rotate(img_compring, obs * -1)
end

function new_info_fsx(nav2sig, tofromnav, glideslopeflag)

	nav2sign = fif(nav2sig, 1, 0)
	glideslopeflag = fif(glideslopeflag, 1, 0)
	
	new_info(nav2sig, tofromnav, glideslopeflag)
	
end

function new_info(nav2sig, tofromnav, glideslopeflag)

	visible(img_navflag, nav2sig == 0)
	
	visible(img_to, tofromnav == 1)
	visible(img_fr, tofromnav == 2)
	visible(img_navflag, tofromnav == 0)

end

function new_dots(horizontal, vertical)

	-- Localizer
	horizontal = var_cap(horizontal, -5, 5)
	img_rotate(img_horbar, horizontal * -12)

end

function new_dots_fsx(horizontal)

	-- Localizer
	horizontal = 4 / 127 * horizontal
	horizontal = var_cap(horizontal, -4, 4)
	img_rotate(img_horbar, horizontal * -6.1)
	
end


-- DIALS ADD --
dial_obs = dial_add("obsknob.png", 31, 395, 85, 85, new_obs)
dial_click_rotate(dial_obs,6)
-- DATABUS SUBSCRIBE --
fsx_variable_subscribe("NAV OBS:2", "Degrees", new_obsheading)
fsx_variable_subscribe("NAV HAS NAV:2", "Bool",
					   "NAV TOFROM:2", "Enum",
					   "NAV GS FLAG:2", "Bool", new_info_fsx)
fsx_variable_subscribe("NAV CDI:2", "Number", new_dots_fsx)
					   
xpl_dataref_subscribe("sim/cockpit/radios/nav2_obs_degm", "FLOAT", new_obsheading)
xpl_dataref_subscribe("sim/cockpit2/radios/indicators/nav2_display_horizontal", "INT",
					  "sim/cockpit2/radios/indicators/nav2_flag_from_to_pilot", "INT", 
					  "sim/cockpit2/radios/indicators/nav2_display_vertical", "INT", new_info)
xpl_dataref_subscribe("sim/cockpit/radios/nav2_hdef_dot", "FLOAT",
					  "sim/cockpit/radios/nav2_vdef_dot", "FLOAT", new_dots)				  