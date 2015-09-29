-- Robinson R22 Beta II VSI --
------------------------------
-- Load and display images  --
------------------------------
img_add_fullscreen("VerticalSpeed.png")
img_needle = img_add_fullscreen("vsineedle.png")

---------------
-- Functions --
---------------

function new_vs(fpm)
	
	fpm = var_cap(fpm, -2000, 2000)
	
	if fpm >= 500 then
		img_rotate(img_needle, (138 / 1500 * (fpm - 500)) + 35)
	elseif fpm >= 0 and fpm < 500 then
		img_rotate(img_needle, 35 / 500 * fpm)
	elseif fpm < 0 and fpm > -500 then
		img_rotate(img_needle, 35 / 500 * fpm)
	elseif fpm <= -500 then
		img_rotate(img_needle, (138 / 1500 * (fpm + 500)) - 35)
	end
end

-------------------
-- Bus subscribe --
-------------------
xpl_dataref_subscribe("sim/cockpit2/gauges/indicators/vvi_fpm_pilot", "FLOAT", new_vs)
fsx_variable_subscribe("VERTICAL SPEED", "Feet per minute", new_vs)