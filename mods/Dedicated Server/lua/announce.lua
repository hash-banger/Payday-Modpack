_G.DedicatedServer = _G.DedicatedServer or {}

Hooks:Add("NetworkManagerOnPeerAdded", "WelcomeMessage_Announce", function(peer, peer_id)
    if DedicatedServer and DedicatedServer:Is_On() and DedicatedServer.Settings and type(DedicatedServer.Settings.Lobby_Announce_When_Someone_Join) == "table" then
        local peer2 = managers.network:session() and managers.network:session():peer(peer_id)
        if peer2 then
			for k, message in pairs(DedicatedServer.Settings.Lobby_Announce_When_Someone_Join or {}) do
				peer2:send("send_chat_message", ChatManager.GAME, message)
			end
        end
    end
end)