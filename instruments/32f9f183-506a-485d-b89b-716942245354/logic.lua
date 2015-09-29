img_add_fullscreen("TachNumbersBacking.png")


function value_callback(item_nr)
  return item_nr
  --return "" .. item_nr
end
 
-- This will generate 7 text_objects vertically. Text objects are 200x100.

tach0_id = running_txt_add_ver(240,144,10,80,36,value_callback,"-fx-font-family:Arial; -fx-font-size:28pt; -fx-fill: black; -fx-text-alignment: right;")
running_txt_viewport_rect(tach0_id,300,324,80,36)
tach1_id = running_txt_add_ver(238,144,10,50,36,value_callback,"-fx-font-family:Arial; -fx-font-size:28pt; -fx-fill: white; -fx-text-alignment: right;")
running_txt_viewport_rect(tach1_id,260,324,80,36)
tach2_id = running_txt_add_ver(205,144,10,50,36,value_callback,"-fx-font-family:Arial; -fx-font-size:28pt; -fx-fill: white; -fx-text-alignment: right;")
running_txt_viewport_rect(tach2_id,227,324,80,36)
tach3_id = running_txt_add_ver(172,144,10,50,36,value_callback,"-fx-font-family:Arial; -fx-font-size:28pt; -fx-fill: white; -fx-text-alignment: right;")
running_txt_viewport_rect(tach3_id,194,324,80,36)
tach4_id = running_txt_add_ver(140,144,10,50,36,value_callback,"-fx-font-family:Arial; -fx-font-size:28pt; -fx-fill: white; -fx-text-alignment: right;")
running_txt_viewport_rect(tach4_id,162,324,80,36)

img_ticker = img_add("Tachticker.png", 330, 321, 17, 67)

img_add_fullscreen("TachFace.png")
img_needle = img_add_fullscreen ("engine_needle.png")



img_rotate(img_needle, 135)



function PT_rpm(rpm)
	img_rotate(img_needle, rpm[1] * (250/3490) - 125)
end

function rpm_fsx(rpm)
	img_rotate(img_needle, rpm * (250/3490) - 125)
end

function flight_time_fsx(hours)
	seconds = hours * 60 * 60
	flight_time(seconds)
end

function flight_time(time_sec)
	
    -- minutes
    minutes = time_sec / 60
    --img_rotate(img_minutes, 360 - ( (minutes/10) * 360 ) )
    
    -- hours
    hours = minutes / 60
	
	--running_txt_move_carot(tach0_id, (hours))
	--running_txt_move_carot(tach1_id, (hours/10))
	--running_txt_move_carot(tach2_id, (hours/100))


	digit0 = math.floor(hours * 10) % 10 
	
	--digit0 =  ((math.floor(hours * 100) % 10) *10) + (math.floor(hours * 10) % 10 ) 
	digit1 = math.floor(hours) % 10
	
	--digit1 = math.floor(hours)
	--print(digit1)
	digit2 = math.floor(hours/10) % 10	
	digit3 = math.floor(hours/100) % 10
	digit4 = math.floor(hours/1000) % 10
	
	whole = digit1 + (digit2*10) + (digit3*100) + (digit4*1000)
	digit0 = (hours - whole) * 10
	
	--print(digit0)
	if (digit0 > 9.0) then
		part = digit0 - math.floor(digit0)
		--print("sho" .. part)
		digit1 = digit1 + part
	end
	
	if (digit1 > 9.0 and digit0 > 9.0) then
		digit2 = digit2 + part
	end
	
	if (digit2 > 9.0 and digit0 > 9.0) then
		digit3 = digit3 + part
	end
	
	if (digit3 > 9.0 and digit0 > 9.0) then
		digit4 = digit4 + part
	end
	
	--print(digit0)
	--print(hours)
	tick = (((hours-whole)*10000)%10)
	--print(tick)
	--print (hours .. "=" .. whole .. "; " .. digit0 .. ", " .. digit1 ..", " .. digit2 .. ", " .. digit3 .. ", " .. digit4)
	
	running_txt_move_carot(tach0_id, digit0)
	running_txt_move_carot(tach1_id, digit1)
	running_txt_move_carot(tach2_id, digit2)
	running_txt_move_carot(tach3_id, digit3)
	running_txt_move_carot(tach4_id, digit4)

	
	move(img_ticker, 330, 321-(tick*2.4), 17, 67)
	
	--print("hours=" .. hours .. " minutes=" .. minutes)
	
    --rotate_cylinder(img_hours,     (hours)     , 0.9835,    6   )
    --rotate_cylinder(img_tens,      (hours/10)  , 0.99835,   60  )
    --rotate_cylinder(img_hundreds,  (hours/100) , 0.999835,  600 )
    --rotate_cylinder(img_thousands, (hours/1000), 0.9999835, 6000)
end





xpl_dataref_subscribe("sim/cockpit2/engine/indicators/prop_speed_rpm", "FLOAT[8]", PT_rpm)
xpl_dataref_subscribe("sim/time/hobbs_time", "FLOAT", flight_time)
fsx_variable_subscribe("GENERAL ENG RPM:1", "rpm", rpm_fsx)
fsx_variable_subscribe("GENERAL ENG ELAPSED TIME:1", "hours", flight_time_fsx)
