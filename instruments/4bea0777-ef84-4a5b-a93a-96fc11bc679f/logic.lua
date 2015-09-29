-------------------------------------
--     Load and display images     --
-------------------------------------
img_add_fullscreen("EGTFace.png")
img_egt = img_add("needle3.png", -150, 0, 512, 512)
img_ff = img_add("needle3.png", 150, 0, 512, 512)
img_ref = img_add("egtref.png", -150, 0, 512, 512)
img_add_fullscreen("EGTCover.png")



persist_id = persist_add("egtref", "INT", 70)




-----------------------------------------
-- Set default visibility and rotation --
-----------------------------------------

-- get value
refdegree = persist_get(persist_id)
img_rotate(img_ref, 145-refdegree)

function new_egtref(value)
	refdegree = refdegree - value
	if (refdegree < -15) then
		refdegree = -15
	end
	
	if (refdegree > 120) then
		refdegree = 120
	end
	img_rotate(img_ref, 145-refdegree)
	persist_put(persist_id, refdegree)
end


function new_values(batt, temp, flow)

	if batt[1] == 1 then
	
		far = ((temp[1] * 9.0) / 5.0) + 32
		
		-- pounds per hour
		lbh = flow[1] * 7936.64144
		
		-- gallons per hours
		gph = lbh / 6.01
		gph = var_cap(gph, 0, 19)
	
	else
		far = 25
		gph = 0
	end
	
	img_rotate(img_egt , 145 - ( far / 25.0 ))
	if (gph <= 5) then
		img_rotate(img_ff , 212 + (gph * 1.6))
	else
		img_rotate(img_ff , 220 + ((gph-5) * 7.7))
	end
	
end


function new_values_fsx(batt, temp, pounds)

	if batt == true then
	
		-- temp in FSX is given in rankine.  To convert, F = R - 459.67
		temp = temp - 459.67
		far = ((temp * 9.0) / 5.0) + 32
		
		-- pounds per hour
		lbh = pounds * 7936.64144

		-- gallons per hours
		gph = pounds / 6.01
	else
		far = 25
		gph = 0
	end
	
	img_rotate(img_egt , 145 - ( far / 25.0 ))
	
	if (gph <= 5) then
		img_rotate(img_ff , 212 + (gph * 1.6))
	else
		img_rotate(img_ff , 220 + ((gph-5) * 7.7))
	end	

end

-- DIALS ADD --
dial_knob = dial_add("egtrefknob.png", 71, 231, 50, 50, new_egtref)
dial_click_rotate(dial_knob,4)

					  
xpl_dataref_subscribe(	"sim/cockpit/electrical/battery_array_on", "INT[8]",
						"sim/cockpit2/engine/indicators/EGT_deg_C","FLOAT[8]", 
						"sim/flightmodel/engine/ENGN_FF_","FLOAT[8]", 			new_values)

fsx_variable_subscribe(	"ELECTRICAL MASTER BATTERY:1", "bool",
						"GENERAL ENG EXHAUST GAS TEMPERATURE:1", "Rankine", 
						"RECIP ENG FUEL FLOW:1", "pounds per hour", 			new_values_fsx)