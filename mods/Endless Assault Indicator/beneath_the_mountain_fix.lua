if Global.game_settings.level_id == "pbr" then -- Fix for Beneath the Mountain
	local _f_DialogManager_queue_dialog = DialogManager.queue_dialog
	function DialogManager:queue_dialog(id, ...)
		if id == "Play_loc_jr1_23" then
			managers.hud:SetNormalAssaultOverride()
		end
    	return _f_DialogManager_queue_dialog(self, id, ...)
	end

	function HUDManager:SetNormalAssaultOverride()
		self._hud_assault_corner:SetNormalAssaultOverride()
	end

	function HUDAssaultCorner:SetNormalAssaultOverride()
		self._hud_panel:child("assault_panel"):child("icon_assaultbox"):set_image("guis/textures/pd2/hud_icon_assaultbox")
		self:_update_assault_hud_color(self._assault_color)
		self:_set_text_list(self:_get_assault_strings())
		self:_show_hostages()
	end
end