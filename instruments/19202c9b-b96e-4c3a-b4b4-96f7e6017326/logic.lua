img_add_fullscreen("oat_backdrop.png")
img_ice = img_add("oat_ice_warn.png",105,26,50,50)
img_visible(img_ice, false)

mytext1 = txt_add("---", "-fx-font-family:\"Digital-7 Mono\"; -fx-font-size:56px; -fx-fill: grey; -fx-font-weight:bold; -fx-text-alignment: CENTER;", 70, 96, 120, 60)
mytext2 = txt_add("---", "-fx-font-family:\"Digital-7 Mono\"; -fx-font-size:56px; -fx-fill: black; -fx-font-weight:bold; -fx-text-alignment: CENTER;", 66, 92, 120, 60)

function PT_oat(temp)
		
	t = var_round(temp,0)
	txt_set(mytext1,  string.format("%02d",t) )  
	txt_set(mytext2,  string.format("%02d",t) )  
	
	if t > 0 then
    	img_visible(img_ice, true)
    else
    	img_visible(img_ice, false)
    end
end

xpl_dataref_subscribe("sim/weather/temperature_ambient_c", "FLOAT", PT_oat)
fsx_variable_subscribe("AMBIENT TEMPERATURE", "Celsius", PT_oat)