-------------------------------------
--     Load and display images     --
-------------------------------------
img_add_fullscreen("FuelFace.png")
img_lt_fuel = img_add("needle3.png", -142, 0, 512, 512)
img_rt_fuel = img_add("needle3.png", 142, 0, 512, 512)
img_add_fullscreen("FuelCover.png")


-----------------------------------------
-- Set default visibility and rotation --
-----------------------------------------
left = 0
right = 0
cur_left = 0
cur_right = 0
speedl = 0.5
speedr = 0.5
factor = 0.20



function new_fuel(quan, batt)

-- X-plane gives fuel in weight (pounds), so we have to divide by 6 lbs per gallon)
	if (batt[1] == 1) then
		left = ((quan[1]* 2.20462) / 6.0)
		right = ((quan[2]* 2.20462) / 6.0) 
	else
		left = 0
		right = 0
	end

end

function timer_callback()	
	img_rotate(img_lt_fuel , 145 - (cur_left	* 4.23))
	img_rotate(img_rt_fuel , 215 + (cur_right	* 4.23))
	
	
	if (cur_left < left) then
		diff = left - cur_left
		if (diff < 0.001) then
			speedl = 0
			cur_left = left
		else
			speedl = diff * factor
		end
		cur_left = cur_left + speedl
	elseif (cur_left > left) then
		diff = cur_left - left
		if (diff < 0.001) then
			speedl = 0
			cur_left = left
		else
			speedl = diff * factor
		end
		cur_left = cur_left - speedl
	else
	
	end
	
	if (cur_right < right) then
		diff = right - cur_right
		if (diff < 0.001) then
			speedr = 0
			cur_right = right
		else
			speedr = diff * factor
		end
		cur_right = cur_right + speedr
	elseif (cur_right > right) then
		diff = cur_right - right
		if (diff < 0.001) then
			speedr = 0
			cur_right = right
		else
			speedr = diff * factor
		end
		cur_right = cur_right - speedr
	else
		
	end
	

	
end
tmr_blink = timer_start(0, 50, timer_callback)


function new_fuel_fsx(batt, lefttank, righttank)

	if (batt == true) then
		left = lefttank
		right = righttank
	else
		left = 0
		right = 0
	end

end


					  
xpl_dataref_subscribe( "sim/cockpit2/fuel/fuel_quantity","FLOAT[9]",
					   "sim/cockpit/electrical/battery_array_on", "INT[8]", new_fuel)
fsx_variable_subscribe("ELECTRICAL MASTER BATTERY:1", "bool",
					   "FUEL TANK LEFT MAIN QUANTITY", "gallons",
					   "FUEL TANK RIGHT MAIN QUANTITY", "gallons", new_fuel_fsx)


					  
