local _o_init = HUDAssaultCorner.init
function HUDAssaultCorner:init(...)
	_o_init(self, ...)
	if HoloInfo.options.hostages_enable and self._hostages_bg_box then 	
		local hostages_icon = self._hud_panel:child("hostages_panel"):child( "hostages_icon" )
		self._hostages_bg_box:hide()
		self._hostages_bg_box:set_alpha(0)		
		hostages_icon:set_visible(false)
		hostages_icon:set_alpha(0)
	end
end
 
