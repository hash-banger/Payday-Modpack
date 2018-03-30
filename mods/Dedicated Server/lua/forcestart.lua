_G.DedicatedServer = _G.DedicatedServer or {}
local _MissionBriefingGui_update_announce = {}
local DedicatedServer_MissionBriefingGui_update = MissionBriefingGui.update
function MissionBriefingGui:update(t, dt)
	DedicatedServer_MissionBriefingGui_update(self, t, dt)
	if not DedicatedServer:Is_On() then
		return
	end
	local Game_Cancel_Hesit_Casue_Wait_Too_Long = DedicatedServer and DedicatedServer.Settings and DedicatedServer.Settings.Game_Cancel_Hesit_Casue_Wait_Too_Long or 60
	local Game_Kick_Who_Not_Ready_Yet = DedicatedServer and DedicatedServer.Settings and DedicatedServer.Settings.Game_Kick_Who_Not_Ready_Yet or 40
	local _Msg = DedicatedServer and DedicatedServer.Settings and DedicatedServer.Settings.Game_Announce_When_Ready_To_Start or {}
	local tickkk = math.round(t) - 1
	local _Msg_Amount = _Msg and #_Msg or 0
	if _Msg_Amount > 0 and  tickkk >= 1 and tickkk <= _Msg_Amount and not _MissionBriefingGui_update_announce[tickkk] and _Msg[tickkk] then
		_MissionBriefingGui_update_announce[tickkk] = true
		if managers.chat then
			managers.chat:send_message(ChatManager.GAME, "[Auto-Looby]", _Msg[tickkk])
		end
	end
	if t > 7+_Msg_Amount and not self._ready then
		self:on_ready_pressed()
	end
	if Game_Kick_Who_Not_Ready_Yet >= 0 and t > Game_Kick_Who_Not_Ready_Yet and t > 7+_Msg_Amount then
		--Copy from @FishTaco
		for k, _peer in pairs(managers.network:session():peers() or {}) do
			if _peer:id() ~= 1 and _peer:waiting_for_player_ready() == false then
				managers.network:session():on_peer_kicked(_peer, _peer:id(), 0)
				managers.network:session():send_to_peers("kick_peer", _peer:id(), 2)
			end
		end
	end
	if not Utils:IsInHeist() then
		if Game_Cancel_Hesit_Casue_Wait_Too_Long >= 0 and t > Game_Cancel_Hesit_Casue_Wait_Too_Long and game_state_machine:current_state_name() ~= "disconnected" then
			MenuCallbackHandler:load_start_menu_lobby()
		end
	end
end