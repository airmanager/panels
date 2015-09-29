function new_mode(position, direction)
    
	desired_mode = position + direction
	
	if desired_mode == 0 then
		xpl_dataref_write("sim/cockpit2/radios/actuators/adf1_power", "INT", 0)
	elseif desired_mode == 1 then
		xpl_dataref_write("sim/cockpit2/radios/actuators/adf1_power", "INT", 1)
	elseif desired_mode == 2 then
		xpl_dataref_write("sim/cockpit2/radios/actuators/adf1_power", "INT", 2)
	elseif desired_mode == 3 then
		xpl_dataref_write("sim/cockpit2/radios/actuators/adf1_power", "INT", 3)
	elseif desired_mode == 4 then
		xpl_dataref_write("sim/cockpit2/radios/actuators/adf1_power", "INT", 4)
	end

end

function new_ADF100(ADF100)

	if ADF100 == 1 then
		xpl_command("sim/radios/actv_adf1_hundreds_up")
		fsx_event("ADF_100_INC")
	elseif ADF100 == -1 then
		xpl_command("sim/radios/actv_adf1_hundreds_down")
		fsx_event("ADF_100_DEC")
	end

end

function new_ADF10(ADF10)

	if ADF10 == 1 then
		xpl_command("sim/radios/actv_adf1_tens_up")
		fsx_event("ADF_10_INC")
	elseif ADF10 == -1 then
		xpl_command("sim/radios/actv_adf1_tens_down")
		fsx_event("ADF_10_DEC")
	end

end

function new_ADF1(ADF1)

	if ADF1 == 1 then
		xpl_command("sim/radios/actv_adf1_ones_up")
		fsx_event("ADF_1_INC")
	elseif ADF1 == -1 then
		xpl_command("sim/radios/actv_adf1_ones_down")
		fsx_event("ADF_1_DEC")
	end

end

-- Add images in Z-order --
img_add_fullscreen("ADF650ATS0.png")

-- Set default visibility --
img_visible(img_ident, false)

-- Add text in Z-order --
txt_code_1000 = txt_add(" ", " -fx-font-family: Arial; -fx-font-size:30px; -fx-fill: white; -fx-font-weight:bold; -fx-text-alignment: CENTER;", 188, 32, 200, 200)
txt_code_100 = txt_add("0", " -fx-font-family: Arial; -fx-font-size:30px; -fx-fill: white; -fx-font-weight:bold; -fx-text-alignment: CENTER;", 298, 32, 200, 200)
txt_code_10 = txt_add("0", " -fx-font-family: Arial; -fx-font-size:30px; -fx-fill: white; -fx-font-weight:bold; -fx-text-alignment: CENTER;", 411, 32, 200, 200)
txt_code_1 = txt_add("0", " -fx-font-family: Arial; -fx-font-size:30px; -fx-fill: white; -fx-font-weight:bold; -fx-text-alignment: CENTER;", 523, 32, 200, 200)

function new_ADF(frequency, mode)
	
	-- ADF frequency
	txt_set(txt_code_1, frequency % 10)
	txt_set(txt_code_10, math.floor(frequency / 10 % 10) )
	txt_set(txt_code_100, math.floor(frequency / 100 % 10) )
	
	if frequency > 999 then
		txt_set(txt_code_1000, math.floor(frequency / 1000 % 10) )
	else
		txt_set(txt_code_1000, " ")
	end
	
	-- Set switch state
	switch_set_state(switch_mode, mode)

end

function new_ADF_FSX(frequency)
	
	new_ADF(frequency, 2)

end

-- Switches, buttons and dials --
switch_mode = switch_add("BKKT76Amode1.png","BKKT76Amode2.png","BKKT76Amode3.png","BKKT76Amode4.png","BKKT76Amode5.png",56,62,50,50, new_mode)

dial_ADF100 = dial_add("BKKT76Asetbutsmall.png", 374, 65, 50, 50, new_ADF100)
dial_ADF10 = dial_add("BKKT76Asetbutsmall.png", 486, 65, 50, 50, new_ADF10)
dial_ADF1 = dial_add("BKKT76Asetbutsmall.png", 598, 65, 50, 50, new_ADF1)

-- Bus subscribe --
xpl_dataref_subscribe("sim/cockpit2/radios/actuators/adf1_frequency_hz", "INT",
					  "sim/cockpit2/radios/actuators/adf1_power", "INT", new_ADF)
fsx_variable_subscribe("ADF ACTIVE FREQUENCY:1", "kHz", new_ADF_FSX)