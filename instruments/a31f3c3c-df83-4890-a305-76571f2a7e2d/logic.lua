--  CESSNA 172 FULL PANEL
--  Most functions accurate to aircraft.  The following are not operational:
--  Garmin GPS
--  Autopilot
--  Clock
--  Hour Meter on Tach
--  These items work slightly differntly than the airplane:
--  Fuel tank selector click the tank you want to select. To reset
--  Fuel shotoff select a tank position
--  the Annuncuiator testmust be clicked to test and clicked again to stop unlike the
--  hold to test in airplane
--  Flaps... click once at top or bottom of control to move one notch in that diraction
--  Throttle, Carb heat, mixture, and trim can be operated by hovering the mouse
--  over the control and then using the scroll wheel in an intutive manner
--  this was my first large project with Air Manager so don't take the code too seriously
--  it can be done much better...but it all works and delivers a fun and good
--  flying simualtion 


-- COMPASS
img_comp_drum = img_add("compass_drum.png", -516, 40, 712, 96)

function new_compass(hdg)
if hdg == 360 then
hdg=0
end
 move(img_comp_drum,( -516 + hdg * 501/360),nil ,nil,nil)
end

xpl_dataref_subscribe("sim/cockpit2/gauges/indicators/compass_heading_deg_mag", "FLOAT", new_compass)-- end COMPASS

--END COMPASS



--ATTITUDE INDICATOR  ( instrument all behind panel  mask)

-- Add images in Z-order --
img_backplate = img_add("1.png", 557, 86, 230, 230)
img_hcore = img_add("adi_core.png", 557, 86, 230, 230)
img_ring = img_add("3.png", 557, 86, 230, 230)
img_pointer = img_add("4.png", 557, 86, 230, 230)



-- Attitude Functions --
function PT_attitude(roll, pitch)    
-- roll outer ring
    img_rotate(img_ring, roll *-1)
        
-- roll horizon
    img_rotate(img_hcore , roll * -1)
	
-- roll backplate
	img_rotate(img_backplate , roll * -1)
    
-- move horizon pitch
    pitch = var_cap(pitch,-30,30)
    radial = math.rad(roll * -1)
    x = -(math.sin(radial) * pitch * 3)
    y = (math.cos(radial) * pitch * 3)
    img_move(img_hcore, x/2 + 557, y/2 + 86, nil, nil)
end

-- Attitude Bus subscribe -- 
xpl_dataref_subscribe("sim/flightmodel/position/phi", "FLOAT",
					  "sim/flightmodel/position/theta", "FLOAT", PT_attitude)
					  
-- end ATTITUDE INDICATOR

--BARO DISK (behind main mask)
baro_img_id = img_add("alt_baro_disk.png", 815, 105, 188, 188)
--end bBARO DISK

--CDI 1 (with GLIDESLOPE)
gs_flag_id = img_add("gs_flag.png", 1053, 90, 219, 219)
nav_flag_id = img_add("nav_flag.png", 1053, 90, 219, 219)
cdi_center_id = img_add("cdi_center.png", 1053, 90, 219, 219)
gs_needle_id = img_add("gs_needle.png", 884, 90, 388, 219)
nav_needle_id = img_add("nav_needle.png", 1053, -79, 219, 388)
obs_rose_id = img_add("obs_rose.png", 1053, 90, 219, 219)

obs1_pos= 0
img_rotate (obs_rose_id, 0 )

function set_obs_vor1(dir)
if dir == 1 then
obs1_pos= obs1_pos + 1
elseif dir == -1 then
obs1_pos= obs1_pos - 1
end
xpl_dataref_write("sim/cockpit/radios/nav1_obs_degm", "FLOAT",obs1_pos )
end

function new_vor1_obs(obs_mag)
obs1_pos= obs_mag
img_rotate (obs_rose_id, -1*obs_mag )
end

 function new_vor1_dev(hdots, vdots)
 
 img_rotate (nav_needle_id, hdots * -9)
 img_rotate (gs_needle_id, vdots * 9)
 
 end

function new_gs_off (is_vis)
if is_vis == 0 then
move(gs_flag_id ,1079,nil,nil,nil)
elseif  is_vis == 1 then
move(gs_flag_id ,1053,nil ,nil,nil)
end
end

function new_to_from(posit)
if posit == 0 then
move(nav_flag_id ,1053,nil,nil,nil)
elseif  posit == 1 then
move(nav_flag_id ,1027,nil ,nil,nil)
elseif  posit == 2 then
move(nav_flag_id ,1079,nil ,nil,nil)
end
end


xpl_dataref_subscribe("sim/cockpit/radios/nav1_obs_degm", "FLOAT", new_vor1_obs)
xpl_dataref_subscribe("sim/cockpit/radios/nav1_hdef_dot", "FLOAT","sim/cockpit/radios/nav1_vdef_dot", "FLOAT", new_vor1_dev)
xpl_dataref_subscribe("sim/cockpit2/radios/indicators/nav1_flag_glideslope", "INT", new_gs_off)
xpl_dataref_subscribe("sim/cockpit2/radios/indicators/nav1_flag_from_to_pilot", "INT", new_to_from)


--end CDI 1

--CDI 2 (VOR only)

nav_flag_id_2 = img_add("nav_flag.png", 1052, 324, 219, 219)
cdi_center_id_2 = img_add("cdi_center_2.png", 1052, 324, 219, 219)
nav_needle_id_2 = img_add("nav_needle.png", 1052, 155, 219, 388)
obs_rose_id_2 = img_add("obs_rose.png", 1052, 324, 219, 219)

obs2_pos= 0
img_rotate (obs_rose_id_2, 0 )

function set_obs_vor2(dir)
if dir == 1 then
obs2_pos= obs2_pos + 1
elseif dir == -1 then
obs2_pos= obs2_pos - 1
end
xpl_dataref_write("sim/cockpit/radios/nav2_obs_degm", "FLOAT",obs2_pos )
end


function new_vor2_obs(obs_mag)
obs2_pos= obs_mag
img_rotate (obs_rose_id_2, -1*obs_mag )
end

 function new_vor2_hdev(dots)
 
 img_rotate (nav_needle_id_2, dots * -9)
 
 end


xpl_dataref_subscribe("sim/cockpit/radios/nav2_obs_degm", "FLOAT", new_vor2_obs)
xpl_dataref_subscribe("sim/cockpit/radios/nav2_hdef_dot", "FLOAT", new_vor2_hdev)

function new_to_from_2(posit)
if posit == 0 then
move(nav_flag_id_2 ,1052,nil,nil,nil)
elseif  posit == 1 then
move(nav_flag_id_2 ,1026,nil ,nil,nil)
elseif  posit == 2 then
move(nav_flag_id_2 ,1078,nil ,nil,nil)
end
end

xpl_dataref_subscribe("sim/cockpit2/radios/indicators/nav2_flag_from_to_pilot", "INT", new_to_from_2)

--end CDI 2

--ADF

adf_bac_idk = img_add("adf_back.png", 1052, 573, 219, 219)
adf_needle_id = img_add("adf_needle.png", 1052, 573, 219, 219)
adf_top_id = img_add("adf_top.png", 1052, 573, 219, 219)
adf_rose_id = img_add("adf_rose.png", 1052, 573, 219, 219)

adf_card_pos=0
img_rotate (adf_rose_id, 0 )

function set_adf_card(dir)
 if dir == 1 then
  adf_card_pos = adf_card_pos + 1
 elseif dir == -1 then
  adf_card_pos = adf_card_pos - 1
 end
 xpl_dataref_write("sim/cockpit2/radios/actuators/adf1_card_heading_deg_mag_pilot","FLOAT",adf_card_pos)		
end

function new_adf_bearing(rel_brg)
img_rotate (adf_needle_id, rel_brg )
end


xpl_dataref_subscribe("sim/cockpit/radios/adf1_dir_degt", "FLOAT", new_adf_bearing)

function new_adf_card(card_deg)
adf_card_pos= card_deg
img_rotate (adf_rose_id, -1* card_deg )
end



xpl_dataref_subscribe("sim/cockpit2/radios/actuators/adf1_card_heading_deg_mag_pilot", "FLOAT", new_adf_card)

--end ADF




--MAIN PANEL MASK
panel_mask_id = img_add_fullscreen("cessna172_bkgnd.png")

--end MAIN PANEL MASK

-- VOR/ADF KNOBS (must be in front of  the Panel Mask)
obs_vor1_knob = dial_add("blank_space.png", 1057, 225, 50, 54, set_obs_vor1)
obs_vor2_knob = dial_add("blank_space.png", 1057, 491, 50, 54, set_obs_vor2)
adf_card_knob = dial_add("blank_space.png", 1056, 745, 52, 45, set_adf_card)


adf_card_knob = dial_add("blank_space.png", 1056, 745, 52, 45, set_adf_card)

-- end VOR/ADF KNOBS

--FUEL SELECTOR


fuel_sel_id = img_add("fuel_selector.png",862,876,178,178)
fuel_shut_id =  img_add("fuel_shutoff.png",924,1014,67,67)

function sel_lt_tank(tank)
img_rotate(fuel_sel_id,-45)
move(fuel_shut_id,nil,1014,nil,nil)
 xpl_dataref_write("sim/cockpit/engine/fuel_tank_selector","INT",1)
end

function sel_both_tank(tank)
img_rotate(fuel_sel_id,0)
move(fuel_shut_id,nil,1014,nil,nil)
 xpl_dataref_write("sim/cockpit/engine/fuel_tank_selector","INT",4)
end

function sel_rt_tank(tank)
img_rotate(fuel_sel_id,45)
move(fuel_shut_id,nil,1014,nil,nil)
 xpl_dataref_write("sim/cockpit/engine/fuel_tank_selector","INT",3)
end

function sel_off_tank(tank)
move(fuel_shut_id,nil,1046,nil,nil)
 xpl_dataref_write("sim/cockpit/engine/fuel_tank_selector","INT",0)
end

tank_lt = button_add("blank_space.png","blank_space.png",810,932,96,65,sel_lt_tank)
tank_rt = button_add("blank_space.png","blank_space.png",1004,932,65,114,sel_rt_tank)
tank_both = button_add("blank_space.png","blank_space.png",917,846,96,65,sel_both_tank)
tank_off = button_add("blank_space.png","blank_space.png",911,1002,83,78,sel_off_tank)




function new_tank_pos(position)
if position==1 then
img_rotate(fuel_sel_id,-90)
tank_pos=1
elseif position==3 then
img_rotate(fuel_sel_id,90)
tank_pos=3
elseif position==4 then
img_rotate(fuel_sel_id,0)
tank_pos=4
end
end	

xpl_dataref_subscribe("sim/cockpit/engine/fuel_tank_selector","INT",new_tank_pos)


--end FUEL SELECTOR

--  VERTICAL SPEED INDICATOR

vvi_needle_image = img_add("vvi_needle.png",815,342,170,170)


img_rotate(vvi_needle_image,-0)

function PT_vario(verticalspeed)
	angle = verticalspeed *170/2000

	angle = var_cap(angle, -175, 175)
    img_rotate(vvi_needle_image, angle-0)
end

xpl_dataref_subscribe("sim/cockpit2/gauges/indicators/vvi_fpm_pilot", "FLOAT", PT_vario)

--end VERTICAL SPEED INDICATOR

-- AIRSPEED INDICATOR

as_needle =  img_add("as_needle.png",353,108,170,170)


function new_speed(speed)

speed = var_cap(speed, 0, 220)

if speed >= 133 then
img_rotate(as_needle,66.142857142857181 + (1.2714285714285707 * speed ))

elseif speed >= 98 then
img_rotate(as_needle,-85.874999999999901 + (2.4249999999999989 * speed ))
elseif speed >= 65 then
img_rotate(as_needle,-78.41031774897820 + (2.5558756948685653 * speed ) +(-.0021538980758155392* speed* speed))
	elseif speed >= 40 then
	img_rotate(as_needle,-76.41031774897820 + (2.5558756948685653 * speed ) +(-.0021538980758155392* speed* speed))
	elseif speed >= 20 then
img_rotate(as_needle, (speed*22/40))
else
		img_rotate(as_needle, 0)
end
		
end

xpl_dataref_subscribe("sim/cockpit2/gauges/indicators/airspeed_kts_pilot", "FLOAT", new_speed)

-- end AIRSPEED INDICATOR

--ALTIMETER

function new_baro(baroset)

	if baroset == 1 then
		xpl_command("sim/instruments/barometer_up")
	elseif baroset == -1 then
		xpl_command("sim/instruments/barometer_down")
	end

end


img_small_k_needle = img_add("alt_10k_needle.png", 815, 105, 188, 188)
img_small_needle = img_add("alt_1k_needle.png", 815, 105, 188, 188)
img_big_needle = img_add("alt_100_needle.png", 815, 105, 188, 188)


function PT_altimeter(altitude, pressure)
    k = (altitude/10000)*36
    h = ( (altitude - math.floor(altitude/10000)*10000)/1000 )*36
    t = ( altitude - math.floor(altitude/10000)*10000 )*0.36
    
    img_rotate(img_small_k_needle, k)
    img_rotate(img_small_needle, h)    
    img_rotate(img_big_needle, t) 
    
    kk = k/3.6
    hh = h/36
    tt = t/0.36-hh*1000
    

end

-- Altimeter baro set knob (clear button)
dial_baro = dial_add("barset_dial.png", 810, 258, 50, 58, new_baro)

function baro_callback(pressure)

        -- Only show values between 28.0 and 31.0
	pressure = var_cap(pressure, 28.0, 31.0)
	
	-- Calculate image rotation (degrees) from pressure (hg)

	angle = ( pressure-28.1) * -90 
	
	-- Rotate the image
	img_rotate(baro_img_id, angle)

end

xpl_dataref_subscribe("sim/cockpit/misc/barometer_setting", "FLOAT", baro_callback)
xpl_dataref_subscribe("sim/cockpit2/gauges/indicators/altitude_ft_pilot", "FLOAT",
					  "sim/cockpit/misc/barometer_setting", "FLOAT", PT_altimeter)
					  
--end ALTIMETER



--TACHOMETER

RPM_needle_image = img_add("RPM_needle.png",799,571,226,226)

function RPM_set(rot_spd)
img_rotate(RPM_needle_image , rot_spd[1] * 35/500)
end

--RPM subscribe
					  
xpl_dataref_subscribe( "sim/cockpit2/engine/indicators/prop_speed_rpm","FLOAT[8]", RPM_set)


--end TACHOMETER

--TURN & BANK COORDINATOR


img_ball             = img_add("ball.png", 421,464,33,38)
img_plane            = img_add ("plane.png", 328,323,220,220)


function new_ball_deflection(slip)
	slip = var_cap(slip, -7.1, 7.1)
	slip_rad = math.rad(slip * 2.6)
	
	x = (0 * math.cos(slip_rad)) - (125 * math.sin(slip_rad))
	y = (0 * math.sin(slip_rad)) + (125 * math.cos(slip_rad))
	
    img_move(img_ball, x + 421,y + 339,nil,nil)
end

function new_turnrate(roll)
	roll = var_cap(roll, -45, 45)
	img_rotate(img_plane, roll)
end

xpl_dataref_subscribe("sim/cockpit2/gauges/indicators/slip_deg", "FLOAT", new_ball_deflection)
xpl_dataref_subscribe("sim/flightmodel/misc/turnrate_roll", "FLOAT", new_turnrate)

--end TURN & BANK COORDINATOR

-- DIRECTIONAL GYRO

img_dg_back = img_add("DG_rose.png", 573, 331, 203, 203)
img_dg_bug = img_add("hdg_bug.png",573, 331, 203, 203)
img_dg_ovrly = img_add("DG_overlay.png", 573, 331, 203, 203)

bug_pos= 0

 img_rotate(img_dg_back, 0)

function dial_bug(direction)
--clockwise
  if direction == 1 then
 bug_pos = bug_pos + 1 
   -- xpl_command("sim/autopilot/heading_up")    
    --counter clockwise
  elseif direction == -1 then
  bug_pos = bug_pos - 1
  --  xpl_command("sim/autopilot/heading_down") 
  end
  
  xpl_dataref_write("sim/cockpit2/autopilot/heading_dial_deg_mag_pilot","FLOAT",bug_pos)
 
end

baro_dial = dial_add("bug_knob.png",732,495,51,51,dial_bug)

function new_rotation(rotation, h_bug)
bug_pos = h_bug	
  img_rotate(img_dg_back, rotation *-1)
  img_rotate(img_dg_bug, h_bug - rotation)
end

-- subscribe functions on the AirBus
xpl_dataref_subscribe("sim/cockpit2/gauges/indicators/heading_vacuum_deg_mag_pilot", "FLOAT","sim/cockpit2/autopilot/heading_dial_deg_mag_pilot", "FLOAT",new_rotation)


--end DIRECTIONAL GYRO




--EGT and FF INDICATORS

img_egt = img_add("EGT_needle.png", 143, 366, 88, 88)
img_ff = img_add("FF_needle.png", 241, 366, 88, 88)
viewport_rect(img_egt,197,333,79,325)
viewport_rect(img_ff,197,333,79,325)
function new_heat(tem)

img_rotate(img_egt , (tem[1]-810)*-60/700 )
end

function new_ff(flo)

flo[1] = var_cap(flo[1], .00285, 0.015)

img_rotate(img_ff , -166.790 + flo[1] * 45096.61 - 2899846.314 * flo[1] * flo[1] )
end

					  
xpl_dataref_subscribe( "sim/cockpit2/engine/indicators/EGT_deg_C","FLOAT[8]", new_heat)
xpl_dataref_subscribe( "sim/flightmodel/engine/ENGN_FF_","FLOAT[8]", new_ff)


 --end EGT and FF INDICATORS
 
 
 --OIL PRESS & TEMP INDICATORS

 img_oilt = img_add("OILT_needle.png", -14, 548, 88, 88)
img_oilp = img_add("OILP_needle.png", 81, 549, 88, 88)
viewport_rect(img_oilt,38,333,78,325)
viewport_rect(img_oilp,38,333,78,325)

function new_oil(opress, otemp )
opress[1] = var_cap(opress[1], 0, 115)
otemp[1] = var_cap(otemp[1], -10, 250 )

img_rotate( img_oilt , 58.4877331 - 0.4574889444 * otemp[1] )
img_rotate(img_oilp ,  opress[1]*120/115 - 60 )
end
 				  
xpl_dataref_subscribe( "sim/cockpit2/engine/indicators/oil_pressure_psi","FLOAT[8]","sim/cockpit2/engine/indicators/oil_temperature_deg_C","FLOAT[8]", new_oil)

 --end OIL PRESS & TEMP INDICATORS
 
-- VACUUM  & AMMETER GAUGES
 img_vac = img_add("VAC_needle.png", 147, 550, 88, 88)
img_amp = img_add("AMP_needle.png", 245, 551, 88, 88)
viewport_rect(img_vac,197,333,79,325)
viewport_rect(img_amp,197,333,79,325)

a = 1.5001050052502620E+02
b = -2.1001050052502629E+02

function new_vac(suct)
suct = var_cap(suct, 2.9, 7.1)
img_rotate( img_vac , -56.5 + 29 *(7- suct) )
end


function new_amps(draw)
img_rotate(img_amp , draw[1]* 1.05 )
end

					  
xpl_dataref_subscribe( "sim/cockpit2/gauges/indicators/suction_1_ratio","FLOAT", new_vac)
xpl_dataref_subscribe( "sim/cockpit2/electrical/battery_amps","FLOAT[8]", new_amps)

--end VACUUM  & AMMETER GAUGES

--BEACON SWITCH
function beacon_click_callback(position)
if position == 0 then
switch_set_state(beacon_switch_id,1)
xpl_dataref_write("sim/cockpit/electrical/beacon_lights_on","INT",1)
elseif position == 1 then
xpl_dataref_write("sim/cockpit/electrical/beacon_lights_on","INT",0)
switch_set_state(beacon_switch_id,0)
end

end

beacon_switch_id = switch_add("sw_off.png", "sw_on.png", 340,991,49,49,beacon_click_callback)

function new_beacon_switch_pos(sw_on)
if sw_on == 0 then
switch_set_state(beacon_switch_id,0)
elseif  sw_on == 1 then
switch_set_state(beacon_switch_id,1)
end
end	


xpl_dataref_subscribe("sim/cockpit/electrical/beacon_lights_on","INT",new_beacon_switch_pos)

--end BEACON SWITCH

--LANDING LIGHT SWITCH
function landing_click_callback(position)
if position == 0 then
switch_set_state(landing_switch_id,1)
xpl_dataref_write("sim/cockpit/electrical/landing_lights_on","INT",1)
elseif position == 1 then
xpl_dataref_write("sim/cockpit/electrical/landing_lights_on","INT",0)
switch_set_state(landing_switch_id,0)
end

end

landing_switch_id = switch_add("sw_off.png", "sw_on.png", 401,991,49,49,landing_click_callback)

function new_landing_switch_pos(sw_on)
if sw_on == 0 then
switch_set_state(landing_switch_id,0)
elseif  sw_on == 1 then
switch_set_state(landing_switch_id,1)
end
end	


xpl_dataref_subscribe("sim/cockpit/electrical/landing_lights_on","INT",new_landing_switch_pos)
--end LANDING LIGHT SWITCH

--TAXI LIGHT SWITCH
function taxi_click_callback(position)
if position == 0 then
switch_set_state(taxi_switch_id,1)
xpl_dataref_write("sim/cockpit/electrical/taxi_light_on","INT",1)
elseif position == 1 then
xpl_dataref_write("sim/cockpit/electrical/taxi_light_on","INT",0)
switch_set_state(taxi_switch_id,0)
end

end

taxi_switch_id = switch_add("sw_off.png", "sw_on.png", 462,991,49,49,taxi_click_callback)

function new_taxi_switch_pos(sw_on)
if sw_on == 0 then
switch_set_state(taxi_switch_id,0)
elseif  sw_on == 1 then
switch_set_state(taxi_switch_id,1)
end
end	


xpl_dataref_subscribe("sim/cockpit/electrical/taxi_light_on","INT",new_taxi_switch_pos)

--end TAXI LIGHT SWITCH

--NAV LIGHTS SWITCH
function nav_click_callback(position)
if position == 0 then
switch_set_state(nav_switch_id,1)
xpl_dataref_write("sim/cockpit/electrical/nav_lights_on","INT",1)
elseif position == 1 then
xpl_dataref_write("sim/cockpit/electrical/nav_lights_on","INT",0)
switch_set_state(nav_switch_id,0)
end

end

nav_switch_id = switch_add("sw_off.png", "sw_on.png", 523,991,49,49,nav_click_callback)

function new_nav_switch_pos(sw_on)
if sw_on == 0 then
switch_set_state(nav_switch_id,0)
elseif  sw_on == 1 then
switch_set_state(nav_switch_id,1)
end
end	


xpl_dataref_subscribe("sim/cockpit/electrical/nav_lights_on","INT",new_nav_switch_pos)

--end NAV LIGHTS SWITCH

--STROBE SWITCH

function strobe_click_callback(position)
if position == 0 then
switch_set_state(strobe_switch_id,1)
xpl_dataref_write("sim/cockpit/electrical/strobe_lights_on","INT",1)
elseif position == 1 then
xpl_dataref_write("sim/cockpit/electrical/strobe_lights_on","INT",0)
switch_set_state(strobe_switch_id,0)
end

end

strobe_switch_id = switch_add("sw_off.png", "sw_on.png", 584,991,49,49,strobe_click_callback)

function new_strobe_switch_pos(sw_on)
if sw_on == 0 then
switch_set_state(strobe_switch_id,0)
elseif  sw_on == 1 then
switch_set_state(strobe_switch_id,1)
end
end	


xpl_dataref_subscribe("sim/cockpit/electrical/strobe_lights_on","INT",new_strobe_switch_pos)
-- end STROBE SWITCH

--PITOT HEAT SWITCH
function pitot_click_callback(position)
if position == 0 then
switch_set_state(pitot_switch_id,1)
xpl_dataref_write("sim/cockpit/switches/pitot_heat_on","INT",1)
elseif position == 1 then
xpl_dataref_write("sim/cockpit/switches/pitot_heat_on","INT",0)
switch_set_state(pitot_switch_id,0)
end

end

pitot_switch_id = switch_add("sw_off.png", "sw_on.png", 645,991,49,49,pitot_click_callback)

function new_pitot_switch_pos(sw_on)
if sw_on == 0 then
switch_set_state(pitot_switch_id,0)
elseif  sw_on == 1 then
switch_set_state(pitot_switch_id,1)
end
end	


xpl_dataref_subscribe("sim/cockpit2/switches/pitot_heat_on","INT",new_pitot_switch_pos)

--end PITOT HEAT SWITCH

-- ALTERNATOR SWITCH


function alt_click_callback(position)
if position == 0 then
xpl_dataref_write("sim/cockpit2/electrical/generator_on", "INT[8]", {1}, 0)
--switch_set_state(alt_switch_id,1)
elseif position == 1 then
xpl_dataref_write("sim/cockpit2/electrical/generator_on","INT[8]", {0}, 0)
--switch_set_state(alt_switch_id,0)
end

end

alt_switch_id = switch_add("alt_off.png", "alt_on.png",200,920, 36,108,alt_click_callback)

function new_alt_switch_pos(alt_on)
if alt_on[1] == 0 then
switch_set_state(alt_switch_id,0)
elseif  alt_on[1] == 1 then
switch_set_state(alt_switch_id,1)
end
end	


xpl_dataref_subscribe("sim/cockpit/electrical/generator_on","INT[8]",new_alt_switch_pos)

-- end ALTERNATOR SWITCH


--BATTERY SWITCH
function bat_click_callback(position)
if position == 0 then
xpl_dataref_write("sim/cockpit/electrical/battery_on","INT",1)
---switch_set_state(bat_switch_id,1)
elseif position == 1 then
xpl_dataref_write("sim/cockpit/electrical/battery_on","INT",0)
--switch_set_state(bat_switch_id,0)
end

end

bat_switch_id = switch_add("bat_off.png", "bat_on.png",237,920, 35,108,bat_click_callback)

function new_bat_switch_pos(sw_on)
if sw_on == 0 then
switch_set_state(bat_switch_id,0)
elseif  sw_on == 1 then
switch_set_state(bat_switch_id,1)
end
end	


xpl_dataref_subscribe("sim/cockpit/electrical/battery_on","INT",new_bat_switch_pos)

--end BATTERY SWITCH

--AVIONICS MASTER SWITCH
function avion_click_callback(position)
if position == 0 then
switch_set_state(avion_switch_id,1)
xpl_dataref_write("sim/cockpit/electrical/avionics_on","INT",1)
elseif position == 1 then
xpl_dataref_write("sim/cockpit/electrical/avionics_on","INT",0)
switch_set_state(avion_switch_id,0)
end

end

avion_switch_id = switch_add("avion_off.png", "avion_on.png",725,923, 69,97,avion_click_callback)

function new_avion_switch_pos(sw_on)
if sw_on == 0 then
switch_set_state(avion_switch_id,0)
elseif  sw_on == 1 then
switch_set_state(avion_switch_id,1)
end
end	


xpl_dataref_subscribe("sim/cockpit/electrical/avionics_on","INT",new_avion_switch_pos)

-- end AVIONICS MASTER SWITCH


--IGNITION KEY

ign_off = img_add("key_off.png",31,938,125,125)
ign_left = img_add("key_left.png",31,938,125,125)
ign_right = img_add("key_right.png",31,938,125,125)
ign_both = img_add("key_both.png",31,938,125,125)
ign_start = img_add("key_start.png",31,938,125,125)
visible(ign_off,true)
visible(ign_left,false)
visible(ign_right,false)
visible(ign_both,false)
visible(ign_start,false)


ign_state = 0


function ignition_callback(ig_dir)

if ig_dir == 1 then
ign_state = ign_state + 1
if ign_state == 5 then
ign_state = 4
end
elseif ig_dir == -1 then
ign_state = ign_state - 1
if ign_state == -1 then
ign_state= 0
end
end
if ign_state == 0 then
	xpl_dataref_write("sim/cockpit2/engine/actuators/ignition_key", "INT[8]", {0}, 0)
elseif ign_state == 1 then 
	xpl_dataref_write("sim/cockpit2/engine/actuators/ignition_key", "INT[8]", {2}, 0)
elseif ign_state == 2 then 
	xpl_dataref_write("sim/cockpit2/engine/actuators/ignition_key", "INT[8]", {1}, 0)
elseif ign_state == 3 then 
	xpl_dataref_write("sim/cockpit2/engine/actuators/ignition_key", "INT[8]", {3}, 0)
elseif ign_state == 4 then 
	xpl_dataref_write("sim/cockpit2/engine/actuators/ignition_key", "INT[8]", {4}, 0)
end
end

ignition_sw = dial_add("blank_space",31,938,125,125,ignition_callback)



function new_ignition (ign_pos)
visible(ign_off,false)
visible(ign_left,false)
visible(ign_right,false)
visible(ign_both,false)
visible(ign_start,false)
if ign_pos[1] == 0 then
visible(ign_off,true)
ign_state= 0
elseif ign_pos[1] == 2 then
visible(ign_right,true)
ign_state= 1
elseif ign_pos[1] == 1 then
visible(ign_left,true)
ign_state= 2
elseif ign_pos[1] == 3 then
visible(ign_both,true)
ign_state= 3
elseif ign_pos[1] == 4 then
visible(ign_start,true)
ign_state= 4
end

end

xpl_dataref_subscribe("sim/cockpit2/engine/actuators/ignition_key", "INT[8]", new_ignition)

--end IGNITION KEY


-- THROTTLE

img_throttle = img_add("throttle_knob.png", 1284, 1026, 90, 90)

throttle_pos= 0

function move_throttle(direction)
throttle_pos = var_cap(throttle_pos,0,1)
--clockwise (add power)
  if direction == 1 then
   throttle_pos = throttle_pos + .1   
    --counter clockwise (pull power)
  elseif direction == -1 then
   throttle_pos = throttle_pos - .1
  end
  xpl_dataref_write("sim/cockpit2/engine/actuators/throttle_ratio_all","FLOAT",throttle_pos)
end

throttle_dial = dial_add("blank_space.png",1268,917,122,163,move_throttle)

function new_throttle(throttle_ratio)
throttle_pos = throttle_ratio
move(img_throttle,nil,1025 - throttle_pos * 75 ,nil,nil)
end

xpl_dataref_subscribe("sim/cockpit2/engine/actuators/throttle_ratio_all","FLOAT",new_throttle)

--end THROTTLE


--MIXTURE

img_mixture = img_add("mixture_knob.png", 1433, 997, 148, 148)

mix_pos= 0
function move_mix(direction)
mix_pos = var_cap(mix_pos,0,1)
--clockwise (add mix)
  if direction == 1 then
   mix_pos = mix_pos + .34
    
    --counter clockwise (pull mix)
  elseif direction == -1 then
   mix_pos = mix_pos - .34
  end
  xpl_dataref_write("sim/cockpit2/engine/actuators/mixture_ratio_all","FLOAT",mix_pos)
end

mixture_dial = dial_add("blank_space.png",1441,910,123,170,move_mix)

function new_mixture(mix_ratio)
mix_pos = mix_ratio
  move(img_mixture,nil,977 - mix_pos * 55 ,nil,nil)
end

xpl_dataref_subscribe("sim/cockpit2/engine/actuators/mixture_ratio_all","FLOAT",new_mixture)

--end MIXTURE

--CARB HEAT

img_carb_heat = img_add("carb_heat_knob.png", 1124, 935, 102, 102)

carb_ht_pos= 1

function move_carb_ht(direction)
carb_ht_pos = var_cap(carb_ht_pos,0,1)
--clockwise (remove heat)
  if direction == 1 then
   carb_ht_pos = carb_ht_pos + .2
   xpl_command("sim/engines/carb_heat_off")  
    --counter clockwise (add heat)
  elseif direction == -1 then
   carb_ht_pos = carb_ht_pos - .2
   xpl_command("sim/engines/carb_heat_on")          
  end
  move(img_carb_heat,nil,995 - carb_ht_pos * 50 ,nil,nil)
  -- xpl_dataref_write("sim/cockpit2/engine/actuators/carb_heat_ratio","FLOAT[8]",carb_ht_pos, 1 )
 
end

carb_ht_dial = dial_add("blank_space.png",1123,916,100,164,move_carb_ht)

-- end CARB HEAT

--PITCH TRIM

img_trim_ind = img_add("trim_ind.png", 1695, 781, 42, 400)
img_trim1 = img_add("trim11.png", 1568, 874, 201, 209)
img_trim2 = img_add("trim12.png", 1568, 874, 201, 209)


visible(img_trim2 ,false)

sim_it= 0
trim=0

function move_trim(up_dn)   
trim = var_cap(trim,-1,1)
  if sim_it == 0 then
 visible(img_trim2 ,true)
 sim_it= 1
   elseif sim_it == 1 then
    visible(img_trim2 ,false)
 sim_it= 0
end
  if up_dn == 1 then
  trim = trim - .01
  elseif up_dn == -1 then
  trim = trim + .01
  end
xpl_dataref_write("sim/flightmodel/controls/elv_trim","FLOAT",trim)
end

trim_dial = dial_add("blank_space.png",1568, 874, 201, 209, move_trim )

function new_trim(trim_val)
trim= trim_val
move(img_trim_ind,nil,781 + trim_val * 82 ,nil,nil)
end	

  

xpl_dataref_subscribe("sim/flightmodel/controls/elv_trim","FLOAT",new_trim)

--end PITCH TRIM


--FLAPS

img_flap_hand = img_add("flap_knob.png", 1825, 864, 95, 62)

function flaps_up_one(position)
xpl_command("sim/flight_controls/flaps_up")
end
function flaps_dn_one(position)
xpl_command("sim/flight_controls/flaps_down")
end

flaps_up_sw = switch_add("blank_space.png", "blank_space.png", 1757,860,160,100,flaps_up_one)
flaps_dn_sw = switch_add("blank_space.png", "blank_space.png", 1757,980,160,100,flaps_dn_one)

function new_flap(flap_val)
trim= trim_val
move(img_flap_hand,nil,864 + flap_val * 120 ,nil,nil)
end	


xpl_dataref_subscribe("sim/flightmodel2/controls/flap_handle_deploy_ratio","FLOAT",new_flap)

--end FLAPS

-- ANNUNCIATOR PANEL

img_ann_all = img_add("annun_all.png", 715, 19, 225, 65)
img_ann_brakes = img_add("annun_brakes.png", 715, 19, 225, 65)
img_ann_volts = img_add("annun_volts.png", 715, 19, 225, 65)
img_ann_oil = img_add("annun_oil.png", 715, 19, 225, 65)
img_ann_vac = img_add("annun_vac.png", 715, 19, 225, 65)
img_ann_vacl = img_add("annun_vac_l.png", 715, 19, 225, 65)
img_ann_vacr = img_add("annun_vac_r.png", 715, 19, 225, 65)
img_ann_fuell = img_add("annun_fuel_l.png", 715, 19, 225, 65)
img_ann_fuelr = img_add("annun_fuel_r.png", 715, 19, 225, 65)
visible(img_ann_all ,false)
visible(img_ann_brakes ,false)
visible(img_ann_oil ,false)
visible(img_ann_volts ,false)
visible(img_ann_vac ,false)
visible(img_ann_vacl ,false)
visible(img_ann_vacr ,false)
visible(img_ann_fuell ,false)
visible(img_ann_fuelr ,false)
warn_bell = sound_add("fire_bell.wav")

function ann_test_callback(position)
if position == 0 then
switch_set_state(ann_switch_id,1)
visible(img_ann_all ,true)
sound_loop(warn_bell)
--xpl_command("sim/annunciator/test_all_annunciators")  
elseif position == 1 then
switch_set_state(ann_switch_id,0)
sound_stop(warn_bell)
visible(img_ann_all ,false)
end

end

ann_switch_id = switch_add("blank_space.png", "annun_test_sw.png",954,35, 28,30,ann_test_callback)


function new_ann_test(test_on)

if test_on == 1 then
visible(img_ann_all ,true)
elseif  test_on == 0 then
visible(img_ann_all ,false)
end
end

xpl_dataref_subscribe("sim/cockpit/warnings/annunciator_test_pressed","INT",new_ann_test)

function new_oil_warn(lt_on)

if lt_on == 1 then
visible(img_ann_oil ,true)
elseif  lt_on == 0 then
visible(img_ann_oil ,false)
end
end

xpl_dataref_subscribe("sim/cockpit/warnings/annunciators/oil_pressure","INT",new_oil_warn)

function new_alt_warn(lt_on)

if lt_on == 1 then
visible(img_ann_volts ,true)
elseif  lt_on == 0 then
visible(img_ann_volts ,false)
end
end

xpl_dataref_subscribe("sim/cockpit/warnings/annunciators/low_voltage","INT",new_alt_warn)

function new_park_brk(bk_on)

if bk_on > 0.5 then
visible(img_ann_brakes ,true)
elseif  bk_on <= .5 then
visible(img_ann_brakes ,false)
end
end

xpl_dataref_subscribe("sim/cockpit2/controls/parking_brake_ratio","FLOAT",new_park_brk)

function new_vac_warn(lt_on)

if lt_on == 1 then
visible(img_ann_vac ,true)
visible(img_ann_vacl ,true)
elseif  lt_on == 0 then
visible(img_ann_vac ,false)
visible(img_ann_vacl ,false)
end
end

xpl_dataref_subscribe("sim/cockpit/warnings/annunciators/low_vacuum","INT",new_vac_warn)

-- end ANNUNCIATOR PANEL

--FUEL QUANTITY INDICATORS
img_lt_fuel = img_add("LT_fuel_needle.png", -18, 365, 88, 88)
img_rt_fuel = img_add("RT_fuel_needle.png", 84, 364, 88, 88)
viewport_rect(img_lt_fuel,38,333,78,325)
viewport_rect(img_rt_fuel,38,333,78,325)



function new_fuel(quan)

img_rotate(img_lt_fuel , quan[1] * -1.6718 + 59 )
img_rotate(img_rt_fuel , quan[2] * 1.57800 - 56 )

-- turn on annunciator for low quan if necessary


if quan[1] < 15 then
visible(img_ann_fuell ,true)
else 
visible(img_ann_fuell ,false)
end 


if quan[2] < 14 then
visible(img_ann_fuelr ,true)
else
visible(img_ann_fuelr ,false)
end

end

					  
xpl_dataref_subscribe( "sim/cockpit2/fuel/fuel_quantity","FLOAT[9]", new_fuel)

--end FUEL QUANTITY INDICATORS


--NAV COM 1


-- Button functions --
function new_onoff1(onoffstate)
	print("switch position has been changed to position " .. onoffstate)
	xpl_dataref_write("sim/cockpit2/radios/actuators/com1_power", "INT", onoffstate)
	
end

function new_onoff1(position)
if position == 0 then
xpl_dataref_write("sim/cockpit2/radios/actuators/com1_power", "INT",1)
switch_set_state(switch_onoff1,1)
elseif position == 1 then
xpl_dataref_write("sim/cockpit2/radios/actuators/com1_power", "INT",0)
switch_set_state(switch_onoff1,0)
end

end

function new_comtransfer1()

	xpl_command("sim/radios/com1_standy_flip")

end

function new_navtransfer1()

	xpl_command("sim/radios/nav1_standy_flip")

end

function new_combig1(combigvar)
	
	if combigvar == 1 then
		xpl_command("sim/radios/stby_com1_coarse_up")
	elseif combigvar == -1 then
		xpl_command("sim/radios/stby_com1_coarse_down")
	end

end

function new_comsmall1(comsmallvar)

	if comsmallvar == 1 then
		xpl_command("sim/radios/stby_com1_fine_up")
	elseif comsmallvar == -1 then
		xpl_command("sim/radios/stby_com1_fine_down")
	end

end

function new_navbig1(navbigvar)
	
	if navbigvar == 1 then
		xpl_command("sim/radios/stby_nav1_coarse_up")
	elseif navbigvar == -1 then
		xpl_command("sim/radios/stby_nav1_coarse_down")
	end

end

function new_navsmall1(navsmallvar)

	if navsmallvar == 1 then
		xpl_command("sim/radios/stby_nav1_fine_up")
	elseif navsmallvar == -1 then
		xpl_command("sim/radios/stby_nav1_fine_down")
	end

end

-- Add images in Z-order --

redline1 = img_add("redline.png", 1527, 312, 2, 41)

-- Add text --
txt_com1 = txt_add(" ", "-fx-font-size:30px; -fx-fill: #fb2c00; -fx-text-alignment: LEFT;", 1325, 310, 82, 44)
txt_com1stby = txt_add(" ", "-fx-font-size:30px; -fx-fill: #fb2c00; -fx-text-alignment: LEFT;", 1432,  310, 82, 44)

txt_nav1 = txt_add(" ", "-fx-font-size:30px; -fx-fill: #fb2c00; -fx-text-alignment: LEFT;", 1537, 310, 82, 44)
txt_nav1stby = txt_add(" ", "-fx-font-size:30px; -fx-fill: #fb2c00; -fx-text-alignment: LEFT;", 1636, 310, 82, 44)
-- Set default visibility --
img_visible(redline1, false)

-- Functions --
function new_navcomm(avionics, radio_pwr, nav1, nav1stby, com1, com1stby, battery, generator)
	
	if avionics >= 1  and radio_pwr >=1 and (battery >= 1 or generator[1] >= 1) then
	  txt_set(txt_com1, string.format("%d.%.02d",com1/100, com1%100) )
	  txt_set(txt_com1stby, string.format("%d.%.02d",com1stby/100, com1stby%100))
	  txt_set(txt_nav1, string.format("%d.%.02d",nav1/100, nav1%100))
	  txt_set(txt_nav1stby, string.format("%d.%.02d",nav1stby/100, nav1stby%100) )
	  img_visible(redline1, true)
	else
	  txt_set(txt_com1, " ")
	  txt_set(txt_com1stby, " ")
	  txt_set(txt_nav1, " ")
	  txt_set(txt_nav1stby, " ")
	  img_visible(redline1, false)
	end
	
	switch_set_state(switch_onoff1, radio_pwr)
	
end

-- Switches, buttons and dials --
switch_onoff1 = switch_add("offswitch.png","onswitch.png",1333,376,43,43, new_onoff1)
comtransfer1 = button_add("switchfreq.png", "switchfreqpressed.png", 1386, 371, 37, 23, new_comtransfer1)
navtransfer1 = button_add("switchfreq.png", "switchfreqpressed.png", 1609, 371, 37, 23, new_navtransfer1)
combig1 = dial_add("blank_space.png", 1435, 357, 80, 70, new_combig1)
comsmall1 = dial_add("blank_space.png", 1461, 376, 30, 48, new_comsmall1)
navbig1 = dial_add("blank_space.png", 1657, 357, 80, 70, new_navbig1)
navsmall1 = dial_add("blank_space.png",  1685, 376, 30, 48, new_navsmall1)

-- Bus subscribe --
xpl_dataref_subscribe("sim/cockpit2/switches/avionics_power_on", "INT",
					   "sim/cockpit2/radios/actuators/com1_power", "INT",
					  "sim/cockpit/radios/nav1_freq_hz", "INT", 
					  "sim/cockpit/radios/nav1_stdby_freq_hz", "INT",
					  "sim/cockpit2/radios/actuators/com1_frequency_hz", "INT",
					  "sim/cockpit2/radios/actuators/com1_standby_frequency_hz", "INT", 
					  "sim/cockpit/electrical/battery_on", "INT", 
					  "sim/cockpit2/electrical/generator_on", "INT[8]", new_navcomm)
					  
--end NAV COM 1

--NAV COM 2

-- Button functions --
function new_onoff2(position)
if position == 0 then
xpl_dataref_write("sim/cockpit2/radios/actuators/com2_power", "INT",1)
switch_set_state(switch_onoff2,1)
elseif position == 1 then
xpl_dataref_write("sim/cockpit2/radios/actuators/com2_power", "INT",0)
switch_set_state(switch_onoff2,0)
end

end

function new_comtransfer2()

	xpl_command("sim/radios/com2_standy_flip")

end

function new_navtransfer2()

	xpl_command("sim/radios/nav2_standy_flip")

end

function new_combig2(combigvar)
	
	if combigvar == 1 then
		xpl_command("sim/radios/stby_com2_coarse_up")
	elseif combigvar == -1 then
		xpl_command("sim/radios/stby_com2_coarse_down")
	end

end

function new_comsmall2(comsmallvar)

	if comsmallvar == 1 then
		xpl_command("sim/radios/stby_com2_fine_up")
	elseif comsmallvar == -1 then
		xpl_command("sim/radios/stby_com2_fine_down")
	end

end

function new_navbig2(navbigvar)
	
	if navbigvar == 1 then
		xpl_command("sim/radios/stby_nav2_coarse_up")
	elseif navbigvar == -1 then
		xpl_command("sim/radios/stby_nav2_coarse_down")
	end

end

function new_navsmall2(navsmallvar)

	if navsmallvar == 1 then
		xpl_command("sim/radios/stby_nav2_fine_up")
	elseif navsmallvar == -1 then
		xpl_command("sim/radios/stby_nav2_fine_down")
	end

end

-- Add images in Z-order --

redline2 = img_add("redline.png", 1527, 449, 2, 41)

-- Add text --
txt_com2 = txt_add(" ", "-fx-font-size:30px; -fx-fill: #fb2c00; -fx-text-alignment: LEFT;", 1325, 445, 82, 44)
txt_com2stby = txt_add(" ", "-fx-font-size:30px; -fx-fill: #fb2c00; -fx-text-alignment: LEFT;", 1432,  445, 82, 44)

txt_nav2 = txt_add(" ", "-fx-font-size:30px; -fx-fill: #fb2c00; -fx-text-alignment: LEFT;", 1537, 445, 82, 44)
txt_nav2stby = txt_add(" ", "-fx-font-size:30px; -fx-fill: #fb2c00; -fx-text-alignment: LEFT;", 1636, 445, 82, 44)
-- Set default visibility --
img_visible(redline2, false)

-- Functions --
function new_navcomm2(avionics,radio_pwr, nav2, nav2stby, com2, com2stby, battery, generator)
	
--	img_visible(redline2, avionics >= 1 and (battery >= 1 or generator[1] >= 1))
	
	if avionics >= 1 and radio_pwr>= 1 and (battery >= 1 or generator[1] >= 1) then
	  txt_set(txt_com2, string.format("%d.%.02d",com2/100, com2%100) )
	  txt_set(txt_com2stby, string.format("%d.%.02d",com2stby/100, com2stby%100))
	  txt_set(txt_nav2, string.format("%d.%.02d",nav2/100, nav2%100))
	  txt_set(txt_nav2stby, string.format("%d.%.02d",nav2stby/100, nav2stby%100) )
	  	img_visible(redline2, true)
	else
	  txt_set(txt_com2, " ")
	  txt_set(txt_com2stby, " ")
	  txt_set(txt_nav2, " ")
	  txt_set(txt_nav2stby, " ")
	  img_visible(redline2, false )
	end
	
	switch_set_state(switch_onoff2, radio_pwr)
	
end

-- Switches, buttons and dials --
switch_onoff2 = switch_add("offswitch.png","onswitch.png",1333,512,43,43, new_onoff2)
comtransfer2 = button_add("switchfreq.png", "switchfreqpressed.png", 1386, 506, 37, 23, new_comtransfer2)
navtransfer2 = button_add("switchfreq.png", "switchfreqpressed.png", 1609, 506, 37, 23, new_navtransfer2)
combig2 = dial_add("blank_space.png", 1435, 492, 80, 70, new_combig2)
comsmall2 = dial_add("blank_space.png", 1461, 511, 30, 48, new_comsmall2)
navbig2 = dial_add("blank_space.png", 1657, 492, 80, 70, new_navbig2)
navsmall2 = dial_add("blank_space.png",  1685, 511, 30, 48, new_navsmall2)

-- Bus subscribe --
xpl_dataref_subscribe("sim/cockpit2/switches/avionics_power_on", "INT",
                      "sim/cockpit2/radios/actuators/com2_power", "INT",
					  "sim/cockpit/radios/nav2_freq_hz", "INT", 
					  "sim/cockpit/radios/nav2_stdby_freq_hz", "INT",
					  "sim/cockpit2/radios/actuators/com2_frequency_hz", "INT",
					  "sim/cockpit2/radios/actuators/com2_standby_frequency_hz", "INT", 
					  "sim/cockpit/electrical/battery_on", "INT", 
					  "sim/cockpit2/electrical/generator_on", "INT[8]", new_navcomm2)
					  
--end NAV COM 2


--ADF

txt_adf_freq = txt_add(" ", "-fx-font-size:30px; -fx-fill: #fb2c00; -fx-text-alignment: RIGHT;", 1500, 580, 67, 38)
txt_adf_on = txt_add("ADF", "-fx-font-size:18px; -fx-fill: #fb2c00; -fx-text-alignment: LEFT;", 1458, 584, 27, 16)
visible(txt_adf_on,false)

function new_onoff_adf (position)
 if position == 0 then
  xpl_dataref_write("sim/cockpit2/radios/actuators/adf1_power", "INT",1)
  switch_set_state(switch_onoff_adf,1)
 elseif position == 1 then
  xpl_dataref_write("sim/cockpit2/radios/actuators/adf1_power", "INT",0)
  switch_set_state(switch_onoff_adf,0)
 end
end


function new_adf_hundreds(hund_val)
	
	if hund_val == 1 then
		xpl_command("sim/radios/actv_adf1_hundreds_up")
	elseif hund_val == -1 then
		xpl_command("sim/radios/actv_adf1_hundreds_down")
	end

end


function new_adf_tens(tens_val)
	
	if tens_val == 1 then
		xpl_command("sim/radios/actv_adf1_tens_up")
	elseif tens_val == -1 then
		xpl_command("sim/radios/actv_adf1_tens_down")
	end

end

function new_adf_ones(ones_val)

	if ones_val == 1 then
		xpl_command("sim/radios/actv_adf1_ones_up")
	elseif ones_val == -1 then
		xpl_command("sim/radios/actv_adf1_ones_down")
	end

end

function new_adf(avionics,radio_pwr, adf_value, battery, generator)
	
	
	if avionics >= 1 and radio_pwr>=1 and (battery >= 1 or generator[1] >= 1) then
	  txt_set(txt_adf_freq,  adf_value)
	  visible(txt_adf_on,true)

	else
	  txt_set(txt_adf_freq, " ")
	  visible(txt_adf_on,false)

	end
	  switch_set_state(switch_onoff_adf, radio_pwr)	
end		
	
	



-- Switches, buttons and dials --
switch_onoff_adf = switch_add("offadf.png","onadf.png",1335,612,40,42, new_onoff_adf)
adf_hunds_freq = dial_add("blank_space.png", 1377,575,79,79, new_adf_hundreds)
adf_tens_freq = dial_add("blank_space.png", 1589,575,79,79, new_adf_tens)
adf_ones_freq = dial_add("blank_space.png", 1613, 602, 38, 38, new_adf_ones)



-- Bus subscribe --
xpl_dataref_subscribe("sim/cockpit2/switches/avionics_power_on", "INT",
                      "sim/cockpit2/radios/actuators/adf1_power", "INT",
					  "sim/cockpit2/radios/actuators/adf1_frequency_hz", "INT", 
					  "sim/cockpit/electrical/battery_on", "INT", 
					  "sim/cockpit2/electrical/generator_on", "INT[8]", new_adf)
--end ADF


-- TRANSPONDER

tx_dial_id = img_add("txpdr_dial.png", 1658,680,60,60)

txt_tspdr_swk = txt_add("1200", "-fx-font-size:30px; -fx-fill: #fb2c00; -fx-text-alignment: RIGHT;", 1543, 670, 58, 45)
txt_tspdr_swk8888 = txt_add("8888", "-fx-font-size:30px; -fx-fill: #fb2c00; -fx-text-alignment: RIGHT;", 1543, 670, 58, 45)
txt_txp_on = txt_add("ON", "-fx-font-size:12px; -fx-fill: #fb2c00; -fx-text-alignment: RIGHT;", 1496, 672, 22, 11)
txt_txp_stby = txt_add("STBY", "-fx-font-size:12px; -fx-fill: #fb2c00; -fx-text-alignment: RIGHT;", 1496, 684, 22, 11)
txt_txp_test = txt_add("TEST", "-fx-font-size:12px; -fx-fill: #fb2c00; -fx-text-alignment: RIGHT;", 1470, 672, 22, 11)
txt_swk_id =  txt_add("IDENT", "-fx-font-size:16px; -fx-fill: #fb2c00; -fx-text-alignment: RIGHT;", 1350, 692, 43, 15)
trans_mode_sel = 0

function tspdr_select(directn)

if directn == 1 then
trans_mode_sel= trans_mode_sel + 1
  if trans_mode_sel == 4 then
  trans_mode_sel=3
  end
elseif directn == -1 then
trans_mode_sel= trans_mode_sel - 1
  if trans_mode_sel == -1 then
  trans_mode_sel=0
  end	
end
	if trans_mode_sel == 0 then
   xpl_command("sim/transponder/transponder_off")
   img_rotate(tx_dial_id,0)
	elseif trans_mode_sel == 1 then
	xpl_command("sim/transponder/transponder_standby")
	img_rotate(tx_dial_id,40)
	elseif trans_mode_sel == 2 then
	xpl_command("sim/transponder/transponder_on")
	img_rotate(tx_dial_id,80)
	elseif trans_mode_sel == 3 then
	xpl_command("sim/transponder/transponder_test")
	img_rotate(tx_dial_id,120)
	end
end


tspdr_dial_id = dial_add("blank_space.png", 1661,681,58,58,tspdr_select)


function swk_vfr()

xpl_dataref_write("sim/cockpit2/radios/actuators/transponder_code", "INT","1200")

end

vfr_button = button_add("TXP_VFR.png","TXP_VFR_dep.png",1671,742,37,23,swk_vfr)

function swk_idt()

if trans_mode_sel==2 then
xpl_command("sim/transponder/transponder_ident")
end


end 

idt_button = button_add("TXP_IDT.png","TXP_IDT_dep.png",1320,685,37,23,swk_idt)


function new_transp_ones(ones_val)

	if ones_val == 1 then
		xpl_command("sim/transponder/transponder_ones_up")
	elseif ones_val == -1 then
		xpl_command("sim/transponder/transponder_ones_down")
	end

end
function new_transp_tens(tens_val)

	if tens_val == 1 then
		xpl_command("sim/transponder/transponder_tens_up")
	elseif tens_val == -1 then
		xpl_command("sim/transponder/transponder_tens_down")
	end

end
function new_transp_huns(huns_val)

	if huns_val == 1 then
		xpl_command("sim/transponder/transponder_hundreds_up")
	elseif huns_val == -1 then
		xpl_command("sim/transponder/transponder_hundreds_down")
	end

end
function new_transp_thos(thos_val)

	if thos_val == 1 then
		xpl_command("sim/transponder/transponder_thousands_up")
	elseif thos_val == -1 then
		xpl_command("sim/transponder/transponder_thousands_down")
	end

end

transp_thos_id = dial_add("blank_space.png", 1365,727,34,34, new_transp_thos)
transp_huns_id = dial_add("blank_space.png", 1437,727,34,34, new_transp_huns)
transp_tens_id = dial_add("blank_space.png", 1509,727,34,34, new_transp_tens)
transp_ones_id = dial_add("blank_space.png", 1579,727,34,34, new_transp_ones)



function new_transpdr(code_val, mode_val, avionics, battery, generator)

txt_set(txt_tspdr_swk, code_val)

if mode_val == 0 then
   	 visible ( txt_tspdr_swk, false)
   	 visible ( txt_tspdr_swk8888, false)
	  visible(txt_txp_on,false)
	  visible(txt_txp_stby,false)
	  visible(txt_txp_test,false)
	trans_mode_sel= 0
elseif mode_val == 1 then
	if avionics >= 1  and (battery >= 1 or generator[1] >= 1) then
	  visible ( txt_tspdr_swk, true)
	  visible ( txt_tspdr_swk8888, false)
	   visible(txt_txp_on,false)
	  visible(txt_txp_stby,true)
	  visible(txt_txp_test,false)
img_rotate(tx_dial_id,0)
	else
	  visible ( txt_tspdr_swk, false)
	  visible ( txt_tspdr_swk8888, false)
	  visible(txt_txp_on,false)
	  visible(txt_txp_stby,false)
	  visible(txt_txp_test,false)
	end
trans_mode_sel = 1
img_rotate(tx_dial_id,40)
elseif mode_val == 2 then
	if avionics >= 1  and (battery >= 1 or generator[1] >= 1) then
	  visible ( txt_tspdr_swk, true)
	  visible ( txt_tspdr_swk8888, false)
	   visible(txt_txp_on,true)
	  visible(txt_txp_stby,false)
	  visible(txt_txp_test,false)
	else
	  visible ( txt_tspdr_swk, false)
	  visible ( txt_tspdr_swk8888, false)
	  visible(txt_txp_on,false)
	  visible(txt_txp_stby,false)
	  visible(txt_txp_test,false)
	end
trans_mode_sel= 2
img_rotate(tx_dial_id,80)
elseif mode_val == 3 then
if avionics >= 1  and (battery >= 1 or generator[1] >= 1) then
	  visible ( txt_tspdr_swk, false)
	  visible ( txt_tspdr_swk8888, true)
	   visible(txt_txp_on,true)
	  visible(txt_txp_stby,true)
	  visible(txt_txp_test,true)
	else
	  visible ( txt_tspdr_swk, false)
	  visible ( txt_tspdr_swk8888, false)
	  visible(txt_txp_on,false)
	  visible(txt_txp_stby,false)
	  visible(txt_txp_test,false)
	end
trans_mode_sel= 3
img_rotate(tx_dial_id,120)
end	
end

function swk_idt_chg(ident)
if ident== 1 then
visible(txt_swk_id,true)

else
visible(txt_swk_id,false)
end
end


xpl_dataref_subscribe("sim/cockpit2/radios/indicators/transponder_id",  "INT", swk_idt_chg)

xpl_dataref_subscribe("sim/cockpit2/radios/actuators/transponder_code", "INT",
                      "sim/cockpit2/radios/actuators/transponder_mode", "INT",
                      "sim/cockpit2/switches/avionics_power_on", "INT",
                      "sim/cockpit/electrical/battery_on", "INT", 
					  "sim/cockpit2/electrical/generator_on", "INT[8]",new_transpdr )


-- end TRANSPONDER

-- Audio Panel


om_on = img_add("outer_mkr_on.png", 1320, 24, 18, 18)
mm_on = img_add("middle_mkr_on.png", 1320, 47, 18, 18)
im_on = img_add("inner_mkr_on.png", 1320, 70, 18, 18)

visible( om_on, false)
visible( mm_on, false)
visible( im_on, false)


function com1_click_callback(position)
if position == 0 then
switch_set_state(com1_audio_but,1)
xpl_dataref_write("sim/cockpit2/radios/actuators/audio_selection_com1","INT",1)
elseif position == 1 then
xpl_dataref_write("sim/cockpit2/radios/actuators/audio_selection_com1","INT",0)
switch_set_state(com1_audio_but,0)
end

end

com1_audio_but = switch_add("blank_space.png","com1_on.png" , 1454, 14, 33, 31,com1_click_callback)

function new_com1_sel_pos(sw_on)
if sw_on == 0 then
switch_set_state(com1_audio_but,0)
elseif  sw_on == 1 then
switch_set_state(com1_audio_but,1)
end
end	


xpl_dataref_subscribe("sim/cockpit2/radios/actuators/audio_selection_com1","INT",new_com1_sel_pos)
--END COMM 1

--COMM 2

function com2_click_callback(position)
if position == 0 then
switch_set_state(com2_audio_but,1)
xpl_dataref_write("sim/cockpit2/radios/actuators/audio_selection_com2","INT",1)
elseif position == 1 then
xpl_dataref_write("sim/cockpit2/radios/actuators/audio_selection_com2","INT",0)
switch_set_state(com2_audio_but,0)
end

end

com2_audio_but = switch_add("blank_space.png","com2_on.png" , 1491, 14, 33, 31,com2_click_callback)

function new_com2_sel_pos(sw_on)
if sw_on == 0 then
switch_set_state(com2_audio_but,0)
elseif  sw_on == 1 then
switch_set_state(com2_audio_but,1)
end
end	


xpl_dataref_subscribe("sim/cockpit2/radios/actuators/audio_selection_com2","INT",new_com2_sel_pos)

-- END COMM 2

--NAV 1

function nav1_click_callback(position)
if position == 0 then
switch_set_state(nav1_audio_but,1)
xpl_dataref_write("sim/cockpit2/radios/actuators/audio_selection_nav1","INT",1)
elseif position == 1 then
xpl_dataref_write("sim/cockpit2/radios/actuators/audio_selection_nav1","INT",0)
switch_set_state(nav1_audio_but,0)
end

end

nav1_audio_but = switch_add("blank_space.png","nav1_on.png" , 1565, 14, 33, 31,nav1_click_callback)

function new_nav1_sel_pos(sw_on)
if sw_on == 0 then
switch_set_state(nav1_audio_but,0)
elseif  sw_on == 1 then
switch_set_state(nav1_audio_but,1)
end
end	


xpl_dataref_subscribe("sim/cockpit2/radios/actuators/audio_selection_nav1","INT",new_nav1_sel_pos)
--END NAV 1

--NAV 2

function nav2_click_callback(position)
if position == 0 then
switch_set_state(nav2_audio_but,1)
xpl_dataref_write("sim/cockpit2/radios/actuators/audio_selection_nav2","INT",1)
elseif position == 1 then
xpl_dataref_write("sim/cockpit2/radios/actuators/audio_selection_nav2","INT",0)
switch_set_state(nav2_audio_but,0)
end

end

nav2_audio_but = switch_add("blank_space.png","nav2_on.png" ,  1601, 14, 33, 31,nav2_click_callback)

function new_nav2_sel_pos(sw_on)
if sw_on == 0 then
switch_set_state(nav2_audio_but,0)
elseif  sw_on == 1 then
switch_set_state(nav2_audio_but,1)
end
end	


xpl_dataref_subscribe("sim/cockpit2/radios/actuators/audio_selection_nav2","INT",new_nav2_sel_pos)
--END NAV 2

--MKR

function mkr_click_callback(position)
if position == 0 then
switch_set_state(mkr_audio_but,1)
xpl_dataref_write("sim/cockpit2/radios/actuators/audio_marker_enabled","INT",1)
elseif position == 1 then
xpl_dataref_write("sim/cockpit2/radios/actuators/audio_marker_enabled","INT",0)
switch_set_state(mkr_audio_but,0)
end

end

mkr_audio_but = switch_add("blank_space.png","mkr_on.png" , 1454, 58, 33, 31,mkr_click_callback)

function new_mkr_sel_pos(sw_on)
if sw_on == 0 then
switch_set_state(mkr_audio_but,0)
elseif  sw_on == 1 then
switch_set_state(mkr_audio_but,1)
end
end	


xpl_dataref_subscribe("sim/cockpit2/radios/actuators/audio_marker_enabled","INT",new_mkr_sel_pos)
--END MKR

--ADF

function adf_click_callback(position)
if position == 0 then
switch_set_state(adf_audio_but,1)
xpl_dataref_write("sim/cockpit2/radios/actuators/audio_selection_adf1","INT",1)
elseif position == 1 then
xpl_dataref_write("sim/cockpit2/radios/actuators/audio_selection_adf1","INT",0)
switch_set_state(adf_audio_but,0)
end

end

adf_audio_but = switch_add("blank_space.png","adf_on.png" , 1528, 58, 33, 31,adf_click_callback)

function new_adf_sel_pos(sw_on)
if sw_on == 0 then
switch_set_state(adf_audio_but,0)
elseif  sw_on == 1 then
switch_set_state(adf_audio_but,1)
end
end	


xpl_dataref_subscribe("sim/cockpit2/radios/actuators/audio_selection_adf1","INT",new_adf_sel_pos)
--END ADF
--MONI

--function moni_click_callback(position)
--if position == 0 then
--switch_set_state(moni_audio_but,1)
----xpl_dataref_write("sim/cockpit2/radios/actuators/audio_selection_adf1","INT",1)
--elseif position == 1 then
----xpl_dataref_write("sim/cockpit2/radios/actuators/audio_selection_adf1","INT",0)
--switch_set_state(moni_audio_but,0)
--end
--
--end

moni_audio_but = switch_add("blank_space.png","moni_on.png" , 1602, 58, 33, 31,moni_click_callback)

--this is a dummy switch that operates but does nothing


xpl_dataref_subscribe("sim/cockpit2/radios/actuators/audio_selection_adf1","INT",new_adf_sel_pos)
--END MONI

-- mkr beacons

function new_mkr_lit (om_is_on, mm_is_on, im_is_on)
if om_is_on == 1 then
visible( om_on, true)
else
visible( om_on, false)
end
if mm_is_on == 1 then
visible( mm_on, true)
else
visible( mm_on, false)
end
if im_is_on == 1 then
visible( im_on, true)
else
visible( im_on, false)
end

end


xpl_dataref_subscribe("sim/cockpit2/radios/indicators/outer_marker_lit","INT",
"sim/cockpit2/radios/indicators/middle_marker_lit","INT",
"sim/cockpit2/radios/indicators/inner_marker_lit","INT", new_mkr_lit )
--end Mkr beacons

--transmit selector

mic_mode_sel = 0

function mic_select(diren)

if diren == 1 then
mic_mode_sel = mic_mode_sel + 1
  if mic_mode_sel == 5 then
  mic_mode_sel = 4
  end
elseif diren == -1 then
mic_mode_sel = mic_mode_sel - 1
  if mic_mode_sel == -1 then
  mic_mode_sel = 0
  end
 end
  	
	if mic_mode_sel == 0 then
    img_rotate(mic_dial_id,-35)
	elseif mic_mode_sel == 1 then
	xpl_dataref_write("sim/cockpit/switches/audio_panel_out", "INT",6 )
	img_rotate(mic_dial_id,-4)
	elseif mic_mode_sel == 2 then
	xpl_dataref_write("sim/cockpit/switches/audio_panel_out", "INT",7 )
	img_rotate(mic_dial_id,30)
	elseif mic_mode_sel == 3 then
	img_rotate(mic_dial_id,63)
	elseif mic_mode_sel == 4 then
	img_rotate(mic_dial_id,93)
	end
end

mic_dial_id = img_add("mic_dial.png", 1671,33,51,51)
mic_dial_clk = dial_add("blank_space.png", 1671,33,51,51,mic_select)

function new_mic_pos(rad_tx)

if rad_tx == 6 then
img_rotate(mic_dial_id,-4)
mic_mode_sel = 1
elseif  rad_tx == 7  then
img_rotate(mic_dial_id,30)
mic_mode_sel = 2
end

end


xpl_dataref_subscribe("sim/cockpit/switches/audio_panel_out", "INT", new_mic_pos )

--end transmit selector









-- Autopilot

--end Autopilot
