local DownCounter = DownCounter or _G.DownCounterStandalone

Hooks:PostHook(HUDTeammate,"init","dcs_hudteammate_init",function(self,i,teammates_panel,is_player,width)
	local max_downs = Global.game_settings.one_down and 2 or tweak_data.player.damage.LIVES_INIT --4
	max_downs = managers.crime_spree:modify_value("PlayerDamage:GetMaximumLives", max_downs) --non exclusive to difficulty modifiers that force one down, like pre-balance One Down
	DownCounter.global_max_downs = max_downs
end)

function HUDTeammate:_set_downs_amount_string(text,amount) --custom function so that i can set color myself
	if not text then
		return
	end
	local col = (amount and tonumber(amount) > 1 and Color.white:with_alpha(0.6)) or Color.red:with_alpha(0.8)
	amount = (amount and tostring(amount) == "-1" and "DEAD") or amount or ""
	text:set_text(amount)
	
	text:set_range_color(0,string.len(tostring(amount)),col) --I have no idea what I'm doing
end

Hooks:PostHook(HUDTeammate,"set_player_health","dcs_hudteammate_setplayerhealth",function(self,data)
	local radial_health_panel = self._radial_health_panel
	local radial_health = radial_health_panel:child("radial_health")
	local downs_field = radial_health_panel:child("downs")
	self:_set_downs_amount_string(downs_field,data.revives)
end)


Hooks:PostHook(HUDTeammate,"set_health","dcs_hudteammate_sethealth",function(self,data)
	local radial_health_panel = self._radial_health_panel
	local radial_health = radial_health_panel:child("radial_health")
	local downs_field = radial_health_panel:child("downs")		
	
	if self._main_player then
--		local peerid = LuaNetworking:LocalPeerID() or 420	--no longer needed; game already has "revives" stat ready. how convenient 
		data.revives = data.revives or -1
	elseif data.no_hint then
		data.revives = -1 --ded
	else
		local peerid = self:peer_id() or 420
		local revives_left = 0
		local max_downs = DownCounter.global_max_downs or 4
		local downs = DownCounter.counter[peerid]
		if not downs then
			DownCounter.counter[peerid] = 0
			downs = DownCounter.counter[peerid]
		else
			revives_left = (max_downs - downs) or revives_left
		end

		if data then
			data.revives = revives_left or data.revives
		end
	end
	self:_set_downs_amount_string(downs_field,data.revives)
end)


Hooks:PostHook(HUDTeammate,"_create_radial_health","dcs_hudteammate_createradialhealth",function(self,radial_health_panel)

	self._radial_health_panel = self._radial_health_panel or radial_health_panel
	local tabs_texture = "guis/textures/pd2/hud_tabs"
	local bg_color = Color.white/3
	
	local downcounter_panel = self._radial_health_panel:text({ --create a subpanel of health to hold #of downs
		name = "downs", --id for reference
		vertical = "center",
		font_size = 22,
		align = "center",
		text = ";)", --almir wishes you good rng
		font = "fonts/font_medium_mf",
		layer = 1,
		visible = true,
		color = Color.white,
		w = radial_health_panel:w(),
		h = radial_health_panel:h()
	})
end)
