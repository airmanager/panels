-------------------
--- CESSNA 172R/S VOR ---
-------------------

-- BUTTON, SWITCH AND DIAL FUNCTIONS --
function new_obs(obs)

	if obs == -1 then
		xpl_command("sim/radios/obs1_down")
		fsx_event("VOR1_OBI_DEC")
	elseif obs == 1 then
		xpl_command("sim/radios/obs1_up")
		fsx_event("VOR1_OBI_INC")
	end

end

-- ADD IMAGES --
img_to = img_add_fullscreen("OBSnavto.png")
img_fr = img_add_fullscreen("OBSnavfr.png")
img_navflag = img_add_fullscreen("OBSnavflag.png")
img_gs = img_add_fullscreen("OBSgsflagoff.png")
img_gsflag = img_add_fullscreen("OBSgsflag.png")

img_add_fullscreen("OBSface.png")
img_horbar = img_add("OBSneedle.png",0,-160,512,512)
img_verbar = img_add("OBSneedle.png",-150,0,512,512)


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

function new_info(nav2sig, tofromnav, glideslopeflag)
	
	visible(img_navflag, nav2sig == 0)
	visible(img_to, tofromnav == 1)
	visible(img_fr, tofromnav == 2)
	visible(img_navflag, tofromnav == 0)
	visible(img_gsflag, glideslopeflag == 0)
	
end

function new_info_fsx(nav2sig, tofromnav, glideslopeflag)

	glideslopeflag = fif(glideslopeflag, 1, 0)

	new_info(nav2sig, tofromnav, glideslopeflag)
	
end

function new_dots(horizontal, vertical)

	-- Localizer
	horizontal = var_cap(horizontal, -5, 5)
	img_rotate(img_horbar, horizontal * -12)

	-- Glidescope
	vertical = var_cap(vertical, -4, 4)	
	img_rotate(img_verbar, -90 + (vertical * 12))

end

function new_dots_fsx(vertical, horizontal)

	-- Localizer
	horizontal = 4 / 127 * horizontal
	horizontal = var_cap(horizontal, -4, 4)
	img_rotate(img_horbar, horizontal * -8)
	
	vertical = 4 / 119 * vertical
	
	-- Glidescope
	vertical = var_cap(vertical, -4, 4)	
	img_rotate(img_verbar, -90 + (vertical * 5.4))
	
end

-- DIALS ADD --
dial_obs = dial_add("obsknob.png", 31, 395, 85, 85, new_obs)
dial_click_rotate(dial_obs,6)

-- DATABUS SUBSCRIBE --
fsx_variable_subscribe("NAV OBS:1", "Degrees", new_obsheading)
fsx_variable_subscribe("NAV HAS NAV:1", "Bool",
					   "NAV TOFROM:1", "Enum",
					   "NAV GS FLAG:1", "Bool", new_info_fsx)
					   
fsx_variable_subscribe("NAV GSI:1", "Number",
					   "NAV CDI:1", "Number", new_dots_fsx)
					   
xpl_dataref_subscribe("sim/cockpit/radios/nav1_obs_degm", "FLOAT", new_obsheading)
xpl_dataref_subscribe("sim/cockpit2/radios/indicators/nav1_display_horizontal", "INT",
					  "sim/cockpit2/radios/indicators/nav1_flag_from_to_pilot", "INT", 
					  "sim/cockpit2/radios/indicators/nav1_display_vertical", "INT", new_info)
xpl_dataref_subscribe("sim/cockpit/radios/nav1_hdef_dot", "FLOAT",
					  "sim/cockpit/radios/nav1_vdef_dot", "FLOAT", new_dots)				  