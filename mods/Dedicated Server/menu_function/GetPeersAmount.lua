_G.DedicatedServer = _G.DedicatedServer or {}

function DedicatedServer:GetPeersAmount()
	local alv = 0
	if managers.network then
		if managers.network:session() then
			if managers.network:session():peers() then
				for k, v in pairs(managers.network:session():peers() or {}) do
					local levellevel = v:level() or -1
					if levellevel >= 0 then
						alv = alv + 1
					end
				end
			end
		end
	end
	alv = tonumber(tostring(alv)) or 0
	return alv
end