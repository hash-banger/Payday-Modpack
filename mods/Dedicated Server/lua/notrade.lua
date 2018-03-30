_G.DedicatedServer = _G.DedicatedServer or {}

local _DedicatedServer_TradeManager_on_player_criminal_death = TradeManager.on_player_criminal_death

function TradeManager:on_player_criminal_death(criminal_name, ...)
	if Utils:IsInHeist() and DedicatedServer:Is_On() and DedicatedServer.Settings and DedicatedServer.Settings.Game_HostBOT_Donnot_Release then
		local _peer_id = managers.criminals:character_peer_id_by_name(criminal_name)
		if _peer_id == 1 then
			return
		end
	end
	_DedicatedServer_TradeManager_on_player_criminal_death(self, criminal_name, ...)
end

local _DedicatedServer_TradeManager_is_peer_in_custody = TradeManager.is_peer_in_custody

function TradeManager:is_peer_in_custody(peer_id, ...)
	if peer_id == 1 and DedicatedServer:Is_On() then
		return true
	end
	return _DedicatedServer_TradeManager_is_peer_in_custody(self, peer_id, ...)
end
