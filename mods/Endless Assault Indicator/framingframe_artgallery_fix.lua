local old_init = HUDAssaultCorner.init
function HUDAssaultCorner:init(...)
	old_init(self, ...)
	if Global.game_settings.level_id == "gallery" or Global.game_settings.level_id == "framing_frame_1" then --Fixed endless assault on Framing Frame Day 1/Art Gallery when it's not
		self._no_endless_assault_override = true
	end
end