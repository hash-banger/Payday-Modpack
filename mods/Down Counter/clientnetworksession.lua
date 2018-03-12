Hooks:PostHook(ClientNetworkSession,"on_peer_synched","dcs_peeroptin",function(self, peer_id, ...)
	LuaNetworking:SendToPeer(peer_id,_G.DownCounterStandalone.ModID, "Ah ah ah! The Count is here to count your downs... you can count on it! Down Counter Standalone mod active.")
	--todo send information if player has nine lives, since individual skill data isn't shared normally
end)