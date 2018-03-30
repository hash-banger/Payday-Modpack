_G.DedicatedServer = _G.DedicatedServer or {}

local _force_close_all = false
local _force_close_all_delay = 0
if RequiredScript == "lib/managers/menu/contractboxgui" then
	local _announce_bool = false
	local _last_peers = {}
	local DedicatedServer_ContractBoxGui_update = ContractBoxGui.update
	function ContractBoxGui:update(t, ...)
		DedicatedServer_ContractBoxGui_update(self, t, ...)
		if not DedicatedServer:Is_On() then
			return
		end
		if Utils:IsInHeist() then
			return
		end
		if not DedicatedServer then
			return
		end
		local _Settings = DedicatedServer.Settings
		if not _Settings then
			return
		end
		if not t or not type(t) == "number" or t < 3 then
			return
		end
		if not managers.job:current_contact_data() then
			DedicatedServer:SetNextHeist()
			_force_close_all_delay = t + 1
			return
		end
		if not _force_close_all and t > _force_close_all_delay then
			_force_close_all = true
			managers.system_menu:force_close_all()
		end
		self._auto_continue_t = self._auto_continue_t or (t + _Settings.Lobby_Time_To_Start_Game)
		local alv = DedicatedServer:GetPeersAmount()
		if t >= self._auto_continue_t then
			if managers.job then
				local contact_data = managers.job:current_contact_data()
				if contact_data and (alv >= _Settings.Lobby_Min_Amount_To_Start or (_Settings.Lobby_Time_To_Forced_Start_Game >= 0 and t >= self._auto_continue_t + _Settings.Lobby_Time_To_Forced_Start_Game)) then
					MenuCallbackHandler:start_the_game()
				end
			end
		else
			if _Settings.Lobby_Do_Countdown_Before_Start_Game > 0 then
				local tickkk = math.round(self._auto_continue_t - t)
				if (tickkk%_Settings.Lobby_Do_Countdown_Before_Start_Game) == 0 and not _announce_bool then
					_announce_bool = true
					managers.chat:send_message(ChatManager.GAME, "[Auto-Looby]",  "Game will start in " .. tostring(tickkk) .. "s")
				end
				if (tickkk%_Settings.Lobby_Do_Countdown_Before_Start_Game) ~= 0 and _announce_bool then
					_announce_bool = false
				end
			end
		end
	end
end