if Network:is_client() then
	return
end

_G.DedicatedServer = _G.DedicatedServer or {}

if not DedicatedServer then
	return
end

local _t_delay = 0

local _send_bot_tojail = false

local _do_cancel_the_heist = false

local _all_dead_do_restart = false

Hooks:Add("GameSetupUpdate", "DedicatedServerGameSetupUpdate", function(t, dt)
	if Utils:IsInHeist() and DedicatedServer:Is_On() then
		if t > _t_delay and t > 15 and DedicatedServer and DedicatedServer.Settings then
			_t_delay = math.round(t) + 1
			local alv = DedicatedServer:GetPeersAmount() or 0
			local _Lobby_Min_Amount_To_Start = tonumber(tostring(DedicatedServer.Settings.Lobby_Min_Amount_To_Start)) or 0
			if not _do_cancel_the_heist and alv < _Lobby_Min_Amount_To_Start and game_state_machine:current_state_name() ~= "disconnected" then
				_do_cancel_the_heist = true
				MenuCallbackHandler:load_start_menu_lobby()
				return
			end
			if not _send_bot_tojail and not _do_cancel_the_heist and DedicatedServer.Settings.Game_Send_HostBOT_To_Jail then
				_send_bot_tojail = true
				local player = managers.player:local_player()
				managers.player:force_drop_carry()
				managers.statistics:downed({ death = true })
				IngameFatalState.on_local_player_dead()
				game_state_machine:change_state_by_name("ingame_waiting_for_respawn")
				player:character_damage():set_invulnerable(true)
				player:character_damage():set_health(0)
				player:base():_unregister()
				player:base():set_slot(player, 0)
				return
			end
			if DedicatedServer.Settings.All_Dead_Auto_Restart and not _all_dead_do_restart then
				local r_unit_count = 0
				for p_id, peer in pairs(managers.network:session():peers() or {}) do
					if managers.trade:is_peer_in_custody(p_id) then
						r_unit_count = r_unit_count + 1
					end
				end
				if r_unit_count >= alv then
					_all_dead_do_restart = true
					managers.vote:restart()
					return
				end
			end
		end
	end
end)