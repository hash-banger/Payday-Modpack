--local DownCounter = DownCounter or _G.DownCounterStandalone
--can't shortcut DownCounter = _G.DownCounterStandalone, I guess playermanager loads before menumanager or something

--on self enter custody
Hooks:PostHook(PlayerManager,"on_enter_custody","dcs_playermanager_onentercustody",function(self, ...)
	if _G.DownCounterStandalone:AnnounceCustodies() and (_G.DownCounterStandalone:IsAlertModeSelf() or _G.DownCounterStandalone:IsAlertModeAll()) then
		local message = (managers.network and managers.network.account and managers.network.account:username()) or "ChadHeister McSexHaver"
		local downs = _G.DownCounterStandalone.counter[LuaNetworking:LocalPeerID()]
		local rollem = math.random(100)
		if rollem > 99 then 
			message = (message .. " is in a pickle! (Downed " .. tostring(downs) .. " times.)")
		elseif rollem <= 99 then
			message = (message .. " has gone into custody. (Downed " .. tostring(downs) .. " times.)")
		end
		_G.DownCounterStandalone:Announce(message)
	end
	_G.DownCounterStandalone.counter[LuaNetworking:LocalPeerID()] = 0
end)

