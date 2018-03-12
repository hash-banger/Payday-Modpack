function HUDBGBox_create( panel, params, config )
	local box_panel = panel:panel( params )
	local color = config and config.color
	local alpha = config and config.alpha 
	local Frame_style = HoloInfo.options.Frame_style
	local blend_mode = config and config.blend_mode

    local bg = box_panel:rect({
		name = "bg",
		halign = "grow",
		valign = "grow",
		blend_mode = "normal",
		alpha = alpha or 0.25,
		color = color or Color(1, 0, 0, 0),
		layer = -1
	})
 
	local left_top = box_panel:bitmap({
		name = "left_top",
		halign = "left",
		valign = "top",
		color = Color.white,
		blend_mode = "normal",
		layer = 10,
		x = 0,
		y = 0
	})
	local left_bottom = box_panel:bitmap({
		name = "left_bottom",
		halign = "left",
		valign = "bottom",
		color = Color.white,
		rotation = -90,
		blend_mode = "normal",
		layer = 10,
		x = 0,
		y = 0
	})
	local right_top = box_panel:bitmap({
		name = "right_top",
		halign = "right",
		valign = "top",
		color = Color.white,
		rotation = 90,
		blend_mode = "normal",
		layer = 10,
		x = 0,
		y = 0
	})
	local right_bottom = box_panel:bitmap({
		name = "right_bottom",
		halign = "right",
		valign = "bottom",
		color = Color.white,
		rotation = 180,
		blend_mode = "normal",
		layer = 10,
		x = 0,
		y = 0
	})
	if Frame_style == 1 then
	    right_bottom:set_image("guis/textures/pd2/hud_corner")
	    left_bottom:set_image("guis/textures/pd2/hud_corner")
	    left_top:set_image("guis/textures/pd2/hud_corner")
	    right_top:set_image("guis/textures/pd2/hud_corner") 
	    right_bottom:set_size(8,8)
	    left_bottom:set_size(8,8)
	    left_top:set_size(8,8)
	    right_top:set_size(8,8)
    elseif Frame_style == 2 then
	    left_bottom:set_size(box_panel:w() , 2)
	    left_bottom:set_halign("grow")
	    right_bottom:set_alpha(0)
	    left_bottom:set_rotation(0)
	    right_top:set_alpha(0)
	    left_top:set_alpha(0)
    elseif Frame_style == 3 then
 	    left_bottom:set_size(2 , box_panel:h())
	    right_bottom:set_alpha(0)
	    left_bottom:set_rotation(0)
	    right_top:set_alpha(0)
	    left_top:set_alpha(0)   
	elseif Frame_style == 4 then
	   	left_top:set_size(box_panel:w() , 2)
	    left_top:set_halign("grow")
	    right_bottom:set_alpha(0)
	    left_top:set_rotation(0)
	    right_top:set_alpha(0)
	    left_bottom:set_alpha(0) 	
    else
	    left_bottom:set_size(box_panel:w() , 2)
	    right_bottom:set_size(2, box_panel:h()) 
	    right_top:set_size(box_panel:w(), 2)
	    left_top:set_size(2, box_panel:h())
	    left_bottom:set_halign("grow")
	    right_top:set_halign("grow")
	    right_bottom:set_rotation(0)
	    left_bottom:set_rotation(0)
	    right_top:set_rotation(0)
	    left_top:set_rotation(0)
	end	
	right_bottom:set_right( box_panel:w())
	right_bottom:set_bottom( box_panel:h())
	right_top:set_right(box_panel:w())
	left_bottom:set_bottom(box_panel:h())
	return box_panel
end
  