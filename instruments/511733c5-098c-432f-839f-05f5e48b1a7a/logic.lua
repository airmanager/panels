img_add_fullscreen("FuelSelectPanel.png")
img_knob = img_add("FuelSelectKnob.png", 0, -25, 512, 512)



function callback_left()
	xpl_dataref_write("sim/cockpit2/fuel/fuel_tank_selector_left", "INT", 1)
	fsx_event("FUEL_SELECTOR_LEFT")
end

function callback_right()
	xpl_dataref_write("sim/cockpit2/fuel/fuel_tank_selector_left", "INT", 3)
	fsx_event("FUEL_SELECTOR_RIGHT")
end

function callback_both()
	xpl_dataref_write("sim/cockpit2/fuel/fuel_tank_selector_left", "INT", 4)
	fsx_event("FUEL_SELECTOR_ALL")
end

function callback_released()
	-- Don't care about the release.
end

button_left = button_add(nil,nil,0,180,150,120,callback_left, callback_released)
button_right = button_add(nil,nil,362,180,150,120,callback_right, callback_released)
button_both = button_add(nil,nil,181,0,150,120,callback_both, callback_released)

function new_select(tank)
	--print(tank)
	
	if (tank == 4) then
		img_rotate(img_knob, 0)
	elseif (tank == 1) then
		img_rotate(img_knob, -90)
	elseif (tank == 3) then
		img_rotate(img_knob, 90)
	elseif (tank == 0) then
		-- this is off position in some Cessnas.
		img_rotate(img_knob, 180)
	else
		img_rotate(img_knob, 180)
	end
end

function new_select_fsx(tank)
	--print(tank)
	
	if (tank == 1) then
		-- both
		img_rotate(img_knob, 0)
	elseif (tank == 2) then
		-- left
		img_rotate(img_knob, -90)
	elseif (tank == 3) then
		-- right
		img_rotate(img_knob, 90)
	elseif (tank == 0) then
		-- this is off position in some Cessnas.
		img_rotate(img_knob, 180)
	else
		img_rotate(img_knob, 180)
	end
end

xpl_dataref_subscribe("sim/cockpit2/fuel/fuel_tank_selector_left", "INT", new_select)
fsx_variable_subscribe("RECIP ENG FUEL TANK SELECTOR:1", "enum", new_select_fsx)
--fsx_variable_subscribe("FUEL TANK SELECTOR:1", "enum", new_select_fsx)


