Hooks:PostHook(HostNetworkSession, 'on_peer_sync_complete' , 'dcs_hostoptin' , function(self, peer, peer_id)
	LuaNetworking:SendToPeer(peer_id,_G.DownCounterStandalone.ModID, "Ah ah ah! The Count is here to count your downs... you can count on it! Down Counter Standalone mod active.")
end)
