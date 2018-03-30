if RequiredScript == "lib/managers/menu/stageendscreengui" then
	function StageEndScreenGui:show()
		self._enabled = true
		self._panel:set_alpha(1)
		self._fullscreen_panel:set_alpha(1)
		DelayedCalls:Add('DelayedMod_Idle4Card_set_speed_up', 1, function()
			managers.hud:set_speed_up_endscreen_hud(5)
		end)
	end
end

if RequiredScript == "lib/managers/hud/hudlootscreen" then
	Hooks:PostHook(HUDLootScreen, "begin_choose_card", "HUDLootScreen_begin_choose_card_speedup", function(hudd, peer_id, ...)
		if hudd._peer_data and hudd._peer_data[peer_id] then
			hudd._peer_data[peer_id].wait_t = 0
		end
	end )
end