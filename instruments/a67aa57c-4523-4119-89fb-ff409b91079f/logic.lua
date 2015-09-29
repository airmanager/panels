--     C402 EGT Gauge    --
-------------------------------------
--     Load and display images     --
-------------------------------------
img_add_fullscreen("OilPressTempFace.png")
img_oilt = img_add("needle3.png", -150, 0, 512, 512)
img_oilp = img_add("needle3.png", 150, 0, 512, 512)
img_add_fullscreen("OilPressTempCover.png")

target_oilt = 75
target_oilp = 0
cur_oilt = 75
cur_oilp = 0
speed_oilt = 5
speed_oilp = 5
factor = 0.2

-----------------------------------------
-- Set default visibility and rotation --
-----------------------------------------

function new_oil(batt, opress, otemp )
	opress[1] = var_cap(opress[1], 0, 115)
	otemp[1] = var_cap(otemp[1], 75, 250 )
	
	if (batt[1] == 1) then
		target_oilt = otemp[1]
		target_oilp = opress[1]
	else
		target_oilt = 75
		target_oilp = 0
	end
end

function new_oil_fsx(batt, press, temp)

	-- temp in FSX is given in rankine.  To convert, F = R - 459.67
	temp = temp - 459.67
	temp = var_cap(temp, 75, 250)
	
	-- oil pressure in FSX is given as PSF (pounds per square foot).  Must convert to inches.
	press = press * 0.0069444444444606
	press = var_cap(press, 0, 115)

	if (batt == true) then
		target_oilt = temp
		target_oilp = press
	else
		target_oilt = 75
		target_oilp = 0
	end

end 	

function timer_callback()	
	
	img_rotate(img_oilt, 180.0 - (cur_oilt * 0.58) )
	img_rotate(img_oilp, 180 + 40 + (cur_oilp * 0.91))

	if (cur_oilt < target_oilt) then
		diff = target_oilt - cur_oilt
		if (diff < 0.001) then
			speed_oilt = 0
			cur_oilt = target_oilt
		else
			speed_oilt = diff * factor
		end
		cur_oilt = cur_oilt + speed_oilt
	elseif (cur_oilt > target_oilt) then
		diff = cur_oilt - target_oilt
		if (diff < 0.001) then
			speed_oilt = 0
			cur_oilt = target_oilt
		else
			speed_oilt = diff * factor
		end
		cur_oilt = cur_oilt - speed_oilt
	else
	
	end
	
	if (cur_oilp < target_oilp) then
		diff = target_oilp - cur_oilp
		if (diff < 0.001) then
			speed_oilp = 0
			cur_oilp = target_oilp
		else
			speed_oilp = diff * factor
		end
		cur_oilp = cur_oilp + speed_oilp
	elseif (cur_oilp > target_oilp) then
		diff = cur_oilp - target_oilp
		if (diff < 0.001) then
			speed_oilp = 0
			cur_oilp = target_oilp
		else
			speed_oilp = diff * factor
		end
		cur_oilp = cur_oilp - speed_oilp
	else
		
	end
	

	
end
tmr_blink = timer_start(0, 50, timer_callback)


-------------------
-- Bus subscribe --
-------------------

xpl_dataref_subscribe(	"sim/cockpit/electrical/battery_array_on", "INT[8]",
						"sim/cockpit2/engine/indicators/oil_pressure_psi","FLOAT[8]",
						"sim/cockpit2/engine/indicators/oil_temperature_deg_C","FLOAT[8]", new_oil)
					   
fsx_variable_subscribe("ELECTRICAL MASTER BATTERY:1", "bool",
					   "ENG OIL PRESSURE:1", "psf",
					   "ENG OIL TEMPERATURE:1", "rankine", new_oil_fsx) 