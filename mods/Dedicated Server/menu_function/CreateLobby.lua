_G.DedicatedServer = _G.DedicatedServer or {}

DedicatedServer.Current_Server_Settings = {}

function DedicatedServer:SetNextHeist(data, retry)
	local _Last_Lobby_Hesitcycle = self.Last_Data.Last_Lobby_Hesitcycle or 0
	local _Lobby_Hesitcycle = self.Settings.Lobby_Hesitcycle or {}
	local _Next_Hesit_Ready = {}
	local _Next_Hesit = {}
	retry = retry or 0
	data = data or {}
	
	if retry > table.size(_Lobby_Hesitcycle) + 1 then
		local _dialog_data = {
			title = "Dedicated Server",
			text = "Fail to create the heist\nReason: No required DLC.",
			button_list = {{ text = "[OK]", is_cancel_button = true }},
			id = tostring(math.random(0,0xFFFFFFFF))
		}
		managers.system_menu:show(_dialog_data)
		return
	end
	
	_Last_Lobby_Hesitcycle = _Last_Lobby_Hesitcycle + 1
	if _Last_Lobby_Hesitcycle > #_Lobby_Hesitcycle then
		_Last_Lobby_Hesitcycle = 1
	end
	
	self.Last_Data.Last_Lobby_Hesitcycle = _Last_Lobby_Hesitcycle	
	self:Save_Last_Data()
	
	if #_Lobby_Hesitcycle > 0 then
		_Next_Hesit = _Lobby_Hesitcycle[_Last_Lobby_Hesitcycle]
	end
	
	if #data > 0 then
		_Next_Hesit = data
	end
	
	_Next_Hesit_Ready = self.Settings.Lobby_Default_Setting
	_Next_Hesit_Ready.job = _Next_Hesit.job or _Next_Hesit_Ready.job
	
	local job_tweak_data = tweak_data.narrative.jobs[_Next_Hesit_Ready.job]
	local is_not_dlc_or_got = not job_tweak_data.dlc or managers.dlc:is_dlc_unlocked(job_tweak_data.dlc)
	if not is_not_dlc_or_got then
		retry = retry + 1
		self:SetNextHeist(nil, retry)
		return
	end
	
	_Next_Hesit_Ready.difficulty = _Next_Hesit.difficulty or _Next_Hesit_Ready.difficulty
	_Next_Hesit_Ready.permission = _Next_Hesit.permission or _Next_Hesit_Ready.permission
	_Next_Hesit_Ready.min_rep = _Next_Hesit.min_rep or _Next_Hesit_Ready.min_rep
	_Next_Hesit_Ready.drop_in = _Next_Hesit.drop_in or _Next_Hesit_Ready.drop_in
	_Next_Hesit_Ready.kicking_allowed = _Next_Hesit.kicking_allowed or _Next_Hesit_Ready.kicking_allowed
	_Next_Hesit_Ready.team_ai = _Next_Hesit.team_ai or _Next_Hesit_Ready.team_ai
	_Next_Hesit_Ready.auto_kick = _Next_Hesit.auto_kick or _Next_Hesit_Ready.auto_kick
	self:CreateLobby(_Next_Hesit_Ready)
end

function DedicatedServer:CreateLobby(data)
	self.Current_Server_Settings = data or {}
	if self.Settings.Lobby_Always_Create_New_Lobby then
		managers.menu:on_leave_lobby()
	end
	managers.job:on_buy_job(data.job, data.difficulty)
	Global.game_settings.permission = data.permission ~= nil and data.permission or self.Settings.permission
	Global.game_settings.reputation_permission = type(data.min_rep) == "number" and data.min_rep or self.Settings.min_rep
	Global.game_settings.drop_in_allowed = data.drop_in ~= nil and data.drop_in or self.Settings.drop_in
	Global.game_settings.kicking_allowed = data.kicking_allowed ~= nil and data.kicking_allowed or self.Settings.kicking_allowed
	Global.game_settings.team_ai = data.team_ai ~= nil and data.team_ai or self.Settings.team_ai
	Global.game_settings.auto_kick = data.auto_kick ~= nil and data.auto_kick or self.Settings.auto_kick
	MenuCallbackHandler:start_job({job_id = data.job, difficulty = data.difficulty})
end