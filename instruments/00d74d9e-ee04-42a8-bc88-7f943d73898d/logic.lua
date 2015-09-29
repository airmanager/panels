img_add_fullscreen("fuel_flow_backdrop.png")
img_neddle = img_add("engine_neddle.png",98,0,60,256)

img_add("engine_center.png",98,98,60,60)
img_rotate(img_neddle,0)

function PT_fuel_flow(fuelflow)
    k = 1315
	angle = var_cap(k*fuelflow[1]*266/30-26, 0, 240)
    img_rotate(img_neddle, angle)
end

function PT_fuel_flow_FSX(fuelflow)
	
	fuelflow = (fuelflow / 3600) * 0.45359237
	PT_fuel_flow( {fuelflow} )

end

xpl_dataref_subscribe("sim/cockpit2/engine/indicators/fuel_flow_kg_sec", "FLOAT[8]", PT_fuel_flow)
fsx_variable_subscribe("RECIP ENG FUEL FLOW:1", "Pounds per hour", PT_fuel_flow_FSX)