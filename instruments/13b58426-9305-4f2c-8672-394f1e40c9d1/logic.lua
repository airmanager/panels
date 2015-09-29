img_ann_back = img_add_fullscreen("AnnunciatorBack.png")
img_ann_fuel = img_add_fullscreen("AnnunciatorLowFuel.png")
img_ann_volts = img_add_fullscreen("AnnunciatorVolts.png")
img_ann_oil = img_add_fullscreen("AnnunciatorOilPress.png")
img_ann_vac = img_add_fullscreen("AnnunciatorVac.png")
img_ann_vacl = img_add_fullscreen("AnnunciatorVacL.png")
img_ann_vacr = img_add_fullscreen("AnnunciatorVacR.png")
img_ann_fuell = img_add_fullscreen("AnnunciatorLowFuelL.png")
img_ann_fuelr = img_add_fullscreen("AnnunciatorLowFuelR.png")
img_ann_bar = img_add_fullscreen("AnnunciatorLine.png")
visible(img_ann_fuell ,false)
visible(img_ann_fuelr ,false)
visible(img_ann_fuel ,false)
visible(img_ann_vac ,false)
visible(img_ann_vacl ,false)
visible(img_ann_vacr ,false)
visible(img_ann_bar ,false)

state_fuell = 0
state_fuelr = 0
state_vac1 = 0
state_vac2 = 0
state_oil = 0
state_volts = 0
state_test = 0
prev_test = 0

battery_on = true

blink_state = false

blink_count = 40


function blink_callback()

	--print("state_vacl=" .. state_vac1)
	
	if state_test == 1 then
		visible(img_ann_fuell,	blink_state)
		visible(img_ann_fuelr,	blink_state)
		visible(img_ann_fuel,	blink_state)
		visible(img_ann_vac,	blink_state)
		visible(img_ann_vacl,	blink_state)
		visible(img_ann_vacr,	blink_state)
		visible(img_ann_oil, 	blink_state)
		visible(img_ann_volts, 	blink_state)
		visible(img_ann_bar,	blink_state)
	else
		visible(img_ann_bar, false)

		-- Low Volts
		------------------------------------------------------
		if state_volts > 0 and state_volts < blink_count then
			visible(img_ann_volts, blink_state)
			state_volts = state_volts + 1
		else
			if state_volts == 0 then
				visible(img_ann_volts, false)
			else
				visible(img_ann_volts, true)	
			end
		end	
		
		-- Low Oil Pressure
		------------------------------------------------------
		if state_oil > 0 and state_oil < blink_count then
			visible(img_ann_oil, blink_state)
			state_oil = state_oil + 1
		else
			if state_oil == 0 then
				visible(img_ann_oil, false)
			else
				visible(img_ann_oil, true)	
			end
		end	
		
		-- Low vacuum
		------------------------------------------------------
		if (state_vac1 > 0 and state_vac1 < blink_count) or (state_vac2 > 0 and state_vac2 < blink_count) then
			visible(img_ann_vac, blink_state)
		else
			if state_vac1 == 0 and state_vac2 == 0 then
				visible(img_ann_vac, false)
			else
				visible(img_ann_vac, true)
			end
		end
		
		if state_vac1 > 0 and state_vac1 < blink_count then
			visible(img_ann_vacl, blink_state)
			state_vac1 = state_vac1 + 1
		else
			if state_vac1 == 0 then
				visible(img_ann_vacl, false)
			else
				visible(img_ann_vacl, true)	
			end
		end	
		
		if state_vac2 > 0 and state_vac2 < blink_count then
			visible(img_ann_vacr, blink_state)
			state_vac2 = state_vac2 + 1
		else
			if state_vac2 == 0 then
				visible(img_ann_vacr, false)
			else
				visible(img_ann_vacr, true)	
			end
		end		
		

		
		-- Fuel
		--------------------------------------------------------
		if state_fuell > 0 and state_fuell < blink_count then
			visible(img_ann_fuell, blink_state)
			state_fuell = state_fuell + 1
		else
			if state_fuell == 0 then
				visible(img_ann_fuell, false)
			else
				visible(img_ann_fuell, true)	
			end
		end
		
		if state_fuelr > 0 and state_fuelr < blink_count then
			visible(img_ann_fuelr, blink_state)
			state_fuelr = state_fuelr + 1
		else
			if state_fuelr == 0 then
				visible(img_ann_fuelr, false)
			else
				visible(img_ann_fuelr, true)	
			end
		end
		
		if (state_fuell > 0 and state_fuell < blink_count) or (state_fuelr > 0 and state_fuelr < blink_count) then
			visible(img_ann_fuel, blink_state)
		else
			if state_fuell == 0 and state_fuelr == 0 then
				visible(img_ann_fuel, false)
			else
				visible(img_ann_fuel, true)
			end
		end
	end
	
	if blink_state == false then
		blink_state = true
	else
		blink_state = false
	end
	

end


tmr_blink = timer_start(0, 250, blink_callback)

function new_warn_fsx(battery, oilpress, volts, vacuum, fuel_l, fuel_r)

	battery_on = battery

	-- convert psf to psi
	oilpress = oilpress * 0.0069444444444606
	-- oil pressure
	if oilpress < 20 and battery_on == true then
		if state_oil == 0 then
			state_oil = 1
		end
	else
		state_oil = 0
	end
	
	if volts < 24.5 and battery_on == true then
		if state_volts == 0 then
			state_volts = 1
		end
	else
		state_volts = 0
	end

	low = 3.0 -- as per spec from actual Cessna 172S Information Manual
	if vacuum < low and battery_on == true then
		if state_vac1 == 0 then
			state_vac1 = 1
			state_vac2 = 1
		end
	else
		state_vac1 = 0
		state_vac2 = 0
	end	
	
	-- Fuel
	if fuel_l < 5 and battery_on == true then
		if state_fuell == 0 then
			state_fuell = 1
		end
	else 
		state_fuell = 0
	end 

	if fuel_r < 5 and battery_on == true then
		if state_fuelr == 0 then
			state_fuelr = 1
		end
	else
		state_fuelr = 0
	end	
	
	-- Test switch being held
	-- There is no FSX simulation variable for a test switch.
	-- You could implement this by utilizing some other switch that
	-- is unused... like maybe the de-ice switch.
	test = 0
	state_test = test
	if test == 1 and prev_test == 0 then
		blink_state = true -- cause to turn on instantly!
	end
	prev_test = state_test
	
end

function new_battery(battery, oilpress, volts, vacuum1, vacuum2, fuel, test)
	
	-- battery on/off
	if battery[1] == 1 then
		battery_on = true
	else
		battery_on = false
	end
	
	-- oil pressure
	if oilpress == 1 and battery_on == true then
		if state_oil == 0 then
			state_oil = 1
		end
	else
		state_oil = 0
	end
	
	if volts == 1 and battery_on == true then
		if state_volts == 0 then
			state_volts = 1
		end
	else
		state_volts = 0
	end

	-- low vacuum
	low = 3.0 -- as per spec from actual Cessna 172S Information Manual
	if vacuum1 < low and battery_on == true then
		if state_vac1 == 0 then
			state_vac1 = 1
		end
	else
		state_vac1 = 0
	end
	if vacuum2 < low and battery_on == true then
		if state_vac2 == 0 then
			state_vac2 = 1
		end
	else
		state_vac2 = 0
	end


	
	-- Fuel
	if fuel[1] < 15 and battery_on == true then
		if state_fuell == 0 then
			state_fuell = 1
		end
	else 
		state_fuell = 0
	end 

	if fuel[2] < 15 and battery_on == true then
		if state_fuelr == 0 then
			state_fuelr = 1
		end
	else
		state_fuelr = 0
	end
	
	-- Test switch being held
	state_test = test
	if test == 1 and prev_test == 0 then
		blink_state = true -- cause to turn on instantly!
	end
	prev_test = state_test
end

xpl_dataref_subscribe("sim/cockpit/electrical/battery_array_on", "INT[8]",
					  "sim/cockpit/warnings/annunciators/oil_pressure","INT",
					  "sim/cockpit/warnings/annunciators/low_voltage","INT",
					  "sim/cockpit/misc/vacuum", "FLOAT",
					  "sim/cockpit/misc/vacuum2", "FLOAT",
					  "sim/cockpit2/fuel/fuel_quantity","FLOAT[9]",
					  "sim/cockpit/warnings/annunciator_test_pressed", "INT",  new_battery)



fsx_variable_subscribe("ELECTRICAL MASTER BATTERY:1", "bool",
					   "GENERAL ENG OIL PRESSURE:1", "Psf",
					   "ELECTRICAL MAIN BUS VOLTAGE", "Volts",
					   "SUCTION PRESSURE", "inHg",
					   "FUEL TANK LEFT MAIN QUANTITY", "gallons",
					   "FUEL TANK RIGHT MAIN QUANTITY", "gallons", new_warn_fsx)




-- end ANNUNCIATOR PANEL