_G.DedicatedServer = _G.DedicatedServer or {}

if NetworkAccountSTEAM then
	local DedicatedServer_NetworkAccountSTEAM_username_id = NetworkAccountSTEAM.username_id
	function NetworkAccountSTEAM:username_id(...)
		local _ans = DedicatedServer_NetworkAccountSTEAM_username_id(self, ...)
		if DedicatedServer and DedicatedServer:Is_On() and DedicatedServer.Settings and type(DedicatedServer.Settings.Lobby_Name) == "string" then
			_ans = DedicatedServer.Settings.Lobby_Name
		end
		return _ans
	end
end