if Network:is_client() then
	return
end

_G.ChatCommand = _G.ChatCommand or {}
ChatCommand.now_version = "[2017.11.30]"
ChatCommand.CMD_ACCESS = {
	restart = {true, false},
	ends = {true, false},
	add = {true, false},
	nuke = {true, false},
	free = {true, false},
	--
	vipmenu = {true, false},
	loud = {true, false},
	spawn = {true, true},
	hydra = {true, true},
	bomb = {true, true},
	--
	donate = {false, false},
	jail = {false, false},
	version = {false, false},
	rtd = {false, false},
	vip = {false, false},
	help = {false, false},
	saveme = {false, false}
}
ChatCommand.rtd_time = {0, 0, 0, 0}
ChatCommand.rtd_delay = 60
ChatCommand.VIP_LIST = ChatCommand.VIP_LIST or {}
ChatCommand.VIP_LIST_IDX = ChatCommand.VIP_LIST_IDX or {}
ChatCommand.time2loopcheck = false
ChatCommand.rtd_Hydra_bool = false
ChatCommand.rtd_Hydra_wait4do = {}
ChatCommand.rtd_Hydra_listdone = false
ChatCommand.rtd_Hydra_Split = 2
ChatCommand.rtd_Hydra_CMD = {}
ChatCommand.rtd_roll_rate = {
	20, --Doctor Bag
	20, --Ammo Bag
	35, --Grenade Crate
	35, --First Aid Kit
	10, --Cloaker
	10, --Grenade Out
	10, --Bomb this Area
	10, --Smoke\Flash\Tearing this Area
	10, --Hydra
	5, --Release Teammate
	40 --NONE
}
ChatCommand.Nuke_CMD = false
ChatCommand.SaveMeMax = 6
ChatCommand.SaveMe = {}

Hooks:PostHook(ChatManager, "init", "ChatCommand_Init", function(cmm, ...)
	local function BombthisArea (pos)
		local nowtime = math.floor(TimerManager:game():time())
		local projectile_index = "frag"
		local _start_pos = pos + Vector3(-2000, -2000, 0)
		local _d = tweak_data.blackmarket.projectiles.frag.time_cheat or 0.15
		ChatCommand.time2loopcheck = true
		ChatCommand.throw_projectile = {}
		for i = 1, 10 do
			for j = 1, 10 do
				local _table_size = table.size(ChatCommand.throw_projectile) + 1
				table.insert(ChatCommand.throw_projectile, {enable = true, projectile_index = projectile_index, pos = _start_pos + Vector3(i*400, j*400, 50), time_do = nowtime + 3 + _d*_table_size})
			end
		end
	end
	cmm:AddCommand({"jail", "kill"}, ChatCommand.CMD_ACCESS["jail"][1], ChatCommand.CMD_ACCESS["jail"][2], function(peer)
		if not managers.trade:is_peer_in_custody(peer:id()) then
			if peer:id() == 1 then
				--Copy from Cheat
				local player = managers.player:local_player()
				managers.player:force_drop_carry()
				managers.statistics:downed( { death = true } )
				IngameFatalState.on_local_player_dead()
				game_state_machine:change_state_by_name( "ingame_waiting_for_respawn" )
				player:character_damage():set_invulnerable( true )
				player:character_damage():set_health( 0 )
				player:base():_unregister()
				player:base():set_slot( player, 0 )
			else
				--Copy from Cheat
				local _unit = peer:unit()
				_unit:network():send("sync_player_movement_state", "incapacitated", 0, _unit:id() )
				_unit:network():send_to_unit( { "spawn_dropin_penalty", true, nil, 0, nil, nil } )
				managers.groupai:state():on_player_criminal_death( _unit:network():peer():id() )
			end
		end
	end)
	cmm:AddCommand("add", ChatCommand.CMD_ACCESS["add"][1], ChatCommand.CMD_ACCESS["add"][2], function(peer, type1, type2, type3)
		if not managers.network then
			_send_msg("Error: !add")
		else
			local now_peer = { managers.network:session():peer(1) or nil,
				managers.network:session():peer(2) or nil,
				managers.network:session():peer(3) or nil,
				managers.network:session():peer(4) or nil }
			if (type2 ~= "1" and type2 ~= "2" and type2 ~= "3" and type2 ~= "4") or type3 ~= "ok" then
				cmm:say("You need to use [!add <id 1-4> ok] for adding new VIP.")
				if now_peer[1] then
					cmm:say("1: " .. now_peer[1]:name())
				end
				if now_peer[2] then
					cmm:say("2: " .. now_peer[2]:name())
				end
				if now_peer[3] then
					cmm:say("3: " .. now_peer[3]:name())
				end
				if now_peer[4] then
					cmm:say("4: " .. now_peer[4]:name())
				end
			else
				local file, err = io.open("mods/Dedicated Server/Addons/ChatCommand/vip_list.txt", "a")
				if file then
					local idx = tonumber(type2)
					if now_peer[idx] then
						file:write("" .. now_peer[idx]:user_id(), "\n")
						cmm:say("Host change [" .. now_peer[idx]:name() .."] to VIP")
					end
					file:close()
					ChatCommand:Read_VIP_List()
				else
					cmm:say("Try again")
				end
			end
		end
	end)
	cmm:AddCommand({"donate", "d"}, ChatCommand.CMD_ACCESS["donate"][1], ChatCommand.CMD_ACCESS["donate"][2], function()
		local file, err = io.open("mods/Dedicated Server/Addons/ChatCommand/donate_msg.txt", "r")
		if file then
			local line = file:read()
			while line do
				cmm:say(tostring(line))
				line = file:read()
			end
		end
		file:close()
	end)
	cmm:AddCommand("loud", ChatCommand.CMD_ACCESS["loud"][1], ChatCommand.CMD_ACCESS["loud"][2], function()
		if managers.groupai and managers.groupai:state() and managers.groupai:state():whisper_mode() then
			managers.groupai:state():on_police_called("alarm_pager_hang_up")
			managers.hud:show_hint( { text = "LOUD!" } )
		end	
	end)
	cmm:AddCommand({"dozer", "taser", "tas" ,"cloaker", "clo", "sniper", "shield", "medic"}, ChatCommand.CMD_ACCESS["spawn"][1], ChatCommand.CMD_ACCESS["spawn"][2], function(peer, type1, type2, type3)
		if peer and peer:unit() then
			local unit = peer:unit()
			local unit_name = Idstring( "units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1" )
			local count = 1
			if type1 == "!taser" or type1 == "!tas" or type1 == "/taser" or type1 == "/tas" then
				unit_name = Idstring( "units/payday2/characters/ene_tazer_1/ene_tazer_1" )
			end
			if type1 == "!cloaker" or type1 == "!clo" or type1 == "/cloaker" or type1 == "/clo" then
				unit_name = Idstring( "units/payday2/characters/ene_spook_1/ene_spook_1" )
			end
			if type3 and (type1 == "!dozer" or type1 == "/dozer") then
				local bulldozer_list = {
					"units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1",
					"units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2",
					"units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3",
					"units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic",
					"units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun"
				}
				if bulldozer_list[tonumber(type3)] then
					unit_name = Idstring(bulldozer_list[tonumber(type3)])
				else
					cmm:say("Error: Wrong Type of Bulldozer")
					return
				end
			end
			if type1 == "!sniper" or type1 == "/sniper" then
				if tonumber(type3) == 1 or tonumber(type3) == 2 then
					unit_name = Idstring( "units/payday2/characters/ene_sniper_" .. type3 .. "/ene_sniper_" .. type3 )
				else
					unit_name = Idstring( "units/payday2/characters/ene_sniper_2/ene_sniper_2" )
				end
			end
			if type1 == "!shield" or type1 == "/shield" then
				if tonumber(type3) == 1 or tonumber(type3) == 2 then
					unit_name = Idstring( "units/payday2/characters/ene_shield_" .. type3 .. "/ene_shield_" .. type3 )
				else
					unit_name = Idstring( "units/payday2/characters/ene_shield_2/ene_shield_2" )
				end
			end
			if type1 == "!medic" or type1 == "/medic" then
				if tonumber(type3) == 2 then
					unit_name = Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4")
				else
					unit_name = Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870")
				end
			end
			if type2 then
				count = tonumber(type2)
			end
			for i = 1, count do
				ChatCommand:spawn_enemy(unit_name, unit:position(), unit:rotation())
			end
		end
	end)
	cmm:AddCommand({"restart", "res"}, ChatCommand.CMD_ACCESS["restart"][1], ChatCommand.CMD_ACCESS["restart"][2], function()
		if managers.crime_spree:is_active() then
			return
		end
		--Copy from Quick/Instant restart 1.0 by: FishTaco
		local all_synced = true
		for k,v in pairs(managers.network:session():peers()) do
			if not v:synched() then
				all_synced = false
			end
		end
		if all_synced then
			managers.game_play_central:restart_the_game()
		end
	end)
	cmm:AddCommand({"vipmenu"}, ChatCommand.CMD_ACCESS["vipmenu"][1], ChatCommand.CMD_ACCESS["vipmenu"][2], function()
		ChatCommand:Menu_VIPMENU()
	end)
	cmm:AddCommand({"version", "ver"}, ChatCommand.CMD_ACCESS["version"][1], ChatCommand.CMD_ACCESS["version"][2], function()
		cmm:say("Current version is " .. ChatCommand.now_version)
		cmm:say("More Info: http://t.im/chatcommand")
		cmm:say("Donate Me: http://t.im/tf2baidonation")
	end)	
	cmm:AddCommand("end", ChatCommand.CMD_ACCESS["ends"][1], ChatCommand.CMD_ACCESS["ends"][2], function()
		if game_state_machine:current_state_name() ~= "disconnected" then
			MenuCallbackHandler:load_start_menu_lobby()
		end	
	end)
	cmm:AddCommand("vip", ChatCommand.CMD_ACCESS["vip"][1], ChatCommand.CMD_ACCESS["vip"][2], function(peer)
		if ChatCommand:is_VIP(peer) then
			cmm:say("[".. peer:name() .."] is VIP")
		elseif peer:id() == 1 then
			cmm:say("[".. peer:name() .."] is Host")
		else
			cmm:say("[".. peer:name() .."] is Normal player")
		end
	end)
	cmm:AddCommand("rtd", ChatCommand.CMD_ACCESS["rtd"][1], ChatCommand.CMD_ACCESS["rtd"][2], function(peer)
		if not peer or not peer:unit() then
			peer = managers.network:session():local_peer()
		end
		if peer and peer:unit() then
			local unit = peer:unit()
			local nowtime = math.floor(TimerManager:game():time())
			local pid = peer:id()
			local pname = peer:name()
			local pos = unit:position()
			local rot = unit:rotation()
			if ChatCommand.rtd_time[pid] < nowtime then
				ChatCommand.rtd_time[pid] = nowtime + ChatCommand.rtd_delay
				local _roll_rate = ChatCommand.rtd_roll_rate
				local _roll_rate_toal = 0
				for _, v in pairs(_roll_rate) do
					_roll_rate_toal = _roll_rate_toal + v
				end
				local _roll_get = math.random(1, _roll_rate_toal)
				_roll_rate_toal = 0
				local _roll_ans = 0
				for _, v in pairs(_roll_rate) do
					_roll_ans = _roll_ans + 1
					if _roll_get >= _roll_rate_toal and _roll_get < _roll_rate_toal + v then
						break
					end
					_roll_rate_toal = _roll_rate_toal + v
				end
				if _roll_ans == 1 then
					cmm:say("[".. pname .."] roll for Doctor Bag!!")
					DoctorBagBase.spawn( pos, rot, 0 )
				elseif _roll_ans == 2 then
					cmm:say("[".. pname .."] roll for Ammo Bag!!")
					AmmoBagBase.spawn( pos, rot, 0 )
				elseif _roll_ans == 3 then
					cmm:say("[".. pname .."] roll for Grenade Crate!!")
					GrenadeCrateBase.spawn( pos, rot, 0 )
				elseif _roll_ans == 4 then
					cmm:say("[".. pname .."] roll for First Aid Kit!!")
					FirstAidKitBase.spawn( pos, rot, 0 , 0 )
				elseif _roll_ans == 5 then
					cmm:say("[".. pname .."] roll for Cloaker!!")
					local unit_name = Idstring( "units/payday2/characters/ene_spook_1/ene_spook_1" )
					local _xy_fixed = {
						Vector3(100, 100, 0),
						Vector3(-100, -100, 0),
						Vector3(100, -100, 0),
						Vector3(-100, 100, 0),
						Vector3(0, 100, 0),
						Vector3(0, -100, 0),
						Vector3(100, 0, 0),
						Vector3(-100, 0, 0),
						Vector3(0, 0, 100),
					}
					for i = 1, 9 do
						ChatCommand:spawn_enemy(unit_name, pos + _xy_fixed[i], rot)
					end
				elseif _roll_ans == 6 then
					cmm:say("[".. pname .."] roll for Grenade Out!!")
					local projectile_index = "frag"
					local _xy_fixed = {-10, 10, -100, 100, -200, 200, -500, 500}
					for i = 1, 10 do
						ProjectileBase.throw_projectile(projectile_index, pos + Vector3(_xy_fixed[math.random(8)], _xy_fixed[math.random(8)], 50), Vector3(0, 0, -1), 1)
					end
				elseif _roll_ans == 7 then
					cmm:say("[".. pname .."] roll for Bomb this Area!!")
					BombthisArea(pos)
				elseif _roll_ans == 8 then
					local _flash_bool = 0
					local _r_type = math.random()
					if 0 <= _r_type and _r_type <= 0.3 then
						cmm:say("[".. pname .."] roll for Smoke this Area!!")
						_flash_bool = 0
					elseif 0.3 < _r_type and _r_type <= 0.6 then
						cmm:say("[".. pname .."] roll for Tearing this Area!!")
						_flash_bool = 1
					else
						cmm:say("[".. pname .."] roll for Flash this Area!!")
						_flash_bool = 2
					end
					local _start_pos = pos + Vector3(-2000, -2000, 0)
					local _d = tweak_data.blackmarket.projectiles.frag.time_cheat or 0.15
					ChatCommand.time2loopcheck = true
					ChatCommand.throw_flash = {}
					for i = 1, 10 do
						for j = 1, 10 do
							local _table_size = table.size(ChatCommand.throw_flash) + 1
							table.insert(ChatCommand.throw_flash, {enable = true, is_smoke = _flash_bool, pos = _start_pos + Vector3(i*400, j*400, 50), time_do = nowtime + 3 + _d*_table_size})
						end
					end
				elseif _roll_ans == 9 then
					cmm:say("[".. pname .."] roll for Hydra!!")
					ChatCommand.rtd_Hydra_bool = true
					ChatCommand.rtd_Hydra_listdone = false
					ChatCommand.rtd_Hydra_wait4do = {}
				elseif _roll_ans == 10 then
					cmm:say("[".. pname .."] roll for Release Teammate!!")
					for k, v in pairs( managers.network:session():peers() ) do
						if managers.trade and managers.trade.is_peer_in_custody and managers.trade:is_peer_in_custody(v:id()) then
							IngameWaitingForRespawnState.request_player_spawn(v:id())
						end
					end
				else
					cmm:say("[".. pname .."] roll for nothing!!")
				end
			else
				cmm:say("[".. pname .."] you still need to wait [".. (ChatCommand.rtd_time[pid] - nowtime) .."]s for next roll.")				
			end
			math.randomseed(tostring(os.time()):reverse():sub(1, 6))
		end
	end)
	cmm:AddCommand("hydra", ChatCommand.CMD_ACCESS["hydra"][1], ChatCommand.CMD_ACCESS["hydra"][2], function(_, _, type2, _)
		ChatCommand.rtd_Hydra_bool = true
		ChatCommand.rtd_Hydra_listdone = false
		ChatCommand.rtd_Hydra_wait4do = {}
		type2 = tonumber(tostring(type2)) or 0
		if type2 <= 0 then
			type2 = 1
		end
		ChatCommand.rtd_Hydra_CMD = {
			Split = type2
		}
		cmm:say("[!! Hydra !!]")
	end)
	cmm:AddCommand("nuke", ChatCommand.CMD_ACCESS["nuke"][1], ChatCommand.CMD_ACCESS["nuke"][2], function()
		ChatCommand.Nuke_CMD = true
		cmm:say("[!! Kill all enemy !!]")
	end)
	cmm:AddCommand("free", ChatCommand.CMD_ACCESS["free"][1], ChatCommand.CMD_ACCESS["free"][2], function()
		for k, v in pairs( managers.network:session():peers() ) do
			if managers.trade and managers.trade.is_peer_in_custody and managers.trade:is_peer_in_custody(v:id()) then
				IngameWaitingForRespawnState.request_player_spawn(v:id())
			end
		end
		cmm:say("[!! Free my teammate !!]")
	end)
	cmm:AddCommand("bomb", ChatCommand.CMD_ACCESS["bomb"][1], ChatCommand.CMD_ACCESS["bomb"][2], function(peer)
		if peer and peer.unit and peer:unit().position then
			local pos = peer:unit():position()
			BombthisArea(pos)
			cmm:say("[!! Bomb this area !!]")
		end
	end)
	cmm:AddCommand("help", ChatCommand.CMD_ACCESS["help"][1], ChatCommand.CMD_ACCESS["help"][2], function(peer)
		cmm:say("[!rtd: Roll something special]")
		cmm:say("[!jail: Send yourself to jail]")
		cmm:say("[!saveme: Save yourself]")
		if peer and peer.id and peer:id() > 0 then
			if ChatCommand:is_VIP(peer) and not peer:id() == 1 then
				cmm:say("VIP: [hydra, bomb, dozer, clo, tas, sniper, shield, medic]")
			end
			if peer:id() == 1 then
				cmm:say("HOST: [free, nuke, loud, res, end, add, vipmenu, hydra, bomb, dozer, clo, tas, sniper, shield, medic]")
			end
		end
	end)
	cmm:AddCommand("saveme", ChatCommand.CMD_ACCESS["saveme"][1], ChatCommand.CMD_ACCESS["saveme"][2], function(peer)
		if peer and peer.id and peer:id() then
			local pid = peer:id()
			local puserid = peer:user_id()
			local pname = peer:name()
			ChatCommand.SaveMe[pid] = ChatCommand.SaveMe[pid] or {}
			if not ChatCommand.SaveMe[pid] or not ChatCommand.SaveMe[pid].Times or not ChatCommand.SaveMe[pid].user_id or ChatCommand.SaveMe[pid].user_id ~= puserid then
				ChatCommand.SaveMe[pid] = {
					Times = 0,
					user_id = puserid
				}
			end
			if ChatCommand.SaveMe[pid].Times >= ChatCommand.SaveMeMax then
				cmm:say("["..pname.."] no more SaveMe, sorry.")
			else
				ChatCommand.SaveMe[pid].Times = ChatCommand.SaveMe[pid].Times or 0
				ChatCommand.SaveMe[pid].Times = ChatCommand.SaveMe[pid].Times + 1
				cmm:say("["..pname.."] use SaveMe. ["..ChatCommand.SaveMe[pid].Times.."//"..ChatCommand.SaveMeMax.."]")
				if managers.trade and managers.trade.is_peer_in_custody and managers.trade:is_peer_in_custody(pid) then
					IngameWaitingForRespawnState.request_player_spawn(pid)
				end
				local r_unit = peer:unit()
				if r_unit then
					if r_unit:interaction() then
						if r_unit:interaction():active() then
							r_unit:interaction():interact(r_unit)
						end
					elseif r_unit:character_damage() and (r_unit:character_damage():need_revive() or r_unit:character_damage():arrested()) then
						r_unit:character_damage():revive(r_unit)
					end
				end
			end
		end
	end)
end)

function ChatManager:say(_msg)
	if _msg then
		managers.chat:send_message(ChatManager.GAME, "", tostring(_msg))
	end
end

_G.DedicatedServer = _G.DedicatedServer or {}

Hooks:PostHook(ChatManager, "receive_message_by_peer", "ChatCommand_Active", function(cmm, channel_id, peer, message)
	if not DedicatedServer or not DedicatedServer:Is_On() or not DedicatedServer.Settings or not DedicatedServer.Settings["Addons_ChatCommand_Enable"] then
		return
	end
	local is_run_by_Host = function ()
		if not Network then
			return false
		end
		return not Network:is_client()
	end
	local commad = string.lower(tostring(message))
	local _is_Host = peer:id() == 1 --HOST
	local _is_VIP = ChatCommand:is_VIP(peer) --VIP
	local _is_rHost = is_run_by_Host() --Is this only run by Host
	local type1, type2, type3 = unpack(commad:split(" "))
	if _is_rHost then
		type1 = string.lower(type1)
		if Utils:IsInHeist() then
			if type1 and (type1:sub(1,1) == "!" or type1:sub(1,1) == "/") and cmm._commands and cmm._commands[type1] then
				if (cmm._commands[type1].ishost and _is_Host) or (cmm._commands[type1].isvip and _is_VIP) or (not cmm._commands[type1].ishost and not cmm._commands[type1].isvip) then
					if managers.trade and managers.trade.is_peer_in_custody and managers.trade:is_peer_in_custody(peer:id()) then
						cmm:say("Sorry, [".. tostring(peer:name()) .."] you're in custody")
					else
						cmm._commands[type1].func(peer, type1, type2, type3)					
					end
				else
					cmm:say("You don't have premission to use this command")
				end
			elseif type1 and (type1:sub(1,1) == "!" or type1:sub(1,1) == "/") then
				cmm:say("The command: " .. type1 .. " doesn't exist")
			end
		elseif Utils:IsInGameState() and not _is_Host and type1 and cmm._commands[type1] then
			cmm:say("Current is not in game, please try it later")
		end
	end
end)

function ChatManager:AddCommand(cmd, ishost, isvip, func)
	if not self._commands then
		self._commands = {}
	end
	if type(cmd) == "string" then
		cmd = string.lower(cmd)
		self._commands["!"..cmd] = {}
		self._commands["/"..cmd] = {}

		self._commands["!"..cmd].func = func
		self._commands["/"..cmd].func = func
		self._commands["!"..cmd].ishost = ishost
		self._commands["/"..cmd].ishost = ishost
		self._commands["!"..cmd].isvip = isvip
		self._commands["/"..cmd].isvip = isvip
	else
		for _, _cmd in pairs(cmd) do --Add multiple commands from table
			_cmd = string.lower(_cmd)
			self._commands["!".._cmd] = {}
			self._commands["/".._cmd] = {}
			
			self._commands["!".._cmd].func = func
			self._commands["/".._cmd].func = func
			self._commands["!".._cmd].ishost = ishost
			self._commands["/".._cmd].ishost = ishost
			self._commands["!".._cmd].isvip = isvip
			self._commands["/".._cmd].isvip = isvip
		end
	end
end

function ChatCommand:is_VIP(peer)
	if not peer or not peer.user_id then
		return false
	end
	local line = tostring(peer:user_id())
	if self.VIP_LIST[line] then
		return true
	else
		return false
	end
end

function ChatCommand:Read_VIP_List()
	local file, err = io.open("mods/Dedicated Server/Addons/ChatCommand/vip_list.txt", "r")
	self.VIP_LIST = {}
	self.VIP_LIST_IDX = {}
	if file then
		local line = file:read()
		local count = 0
		while line do
			line = tostring(line)
			if not self.VIP_LIST[line] then
				count = count + 1
				self.VIP_LIST[line] = count
				table.insert(self.VIP_LIST_IDX, line)
			end
			line = file:read()
		end
		file:close()
	end
end

ChatCommand:Read_VIP_List()

function ChatCommand:spawn_enemy(unit_name, pos, rot)
	local unit_done = safe_spawn_unit(unit_name, pos, rot)
	local team_id = tweak_data.levels:get_default_team_ID(unit_done:base():char_tweak().access == "gangster" and "gangster" or "combatant")
	unit_done:movement():set_team(managers.groupai:state():team_data( team_id ))
	managers.groupai:state():assign_enemy_to_group_ai(unit_done, team_id)
	return unit_done
end

function ChatCommand:Menu_VIPMENU(params)
	local opts = {}
	local start = params and params.start or 0
	start = start >= 0 and start or 0
	for k, v in pairs(self.VIP_LIST_IDX or {}) do
		if k > start then
			opts[#opts+1] = { text = "" .. v .. "", callback_func = callback(self, self, "Menu_VIPMENU_Selected", {id = tostring(v)}) }
		end
		if (#opts) >= 10 then
			start = k
			break
		end	
	end
	opts[#opts+1] = { text = "[Next]--------------", callback_func = callback(self, self, "Menu_VIPMENU", {start = start}) }
	opts[#opts+1] = { text = "[Back to Main]----", callback_func = callback(self, self, "Menu_VIPMENU", {}) }
	opts[#opts+1] = { text = "[Cancel]", is_cancel_button = true }
	local _dialog_data = {
		title = "VIP MENU ",
		text = "",
		button_list = opts,
		id = tostring(math.random(0,0xFFFFFFFF))
	}
	if managers.system_menu then
		managers.system_menu:show(_dialog_data)
	end
end

function ChatCommand:Menu_VIPMENU_Selected(params)
	local opts = {}
	opts[#opts+1] = { text = "View", callback_func = callback(self, self, "Menu_VIPMENU_Selected_View", {id = params.id}) }
	opts[#opts+1] = { text = "Remove", callback_func = callback(self, self, "Menu_VIPMENU_Selected_Remove", {id = params.id}) }
	opts[#opts+1] = { text = "[Cancel]", is_cancel_button = true }
	local _dialog_data = {
		title = "" .. params.id,
		text = "",
		button_list = opts,
		id = tostring(math.random(0,0xFFFFFFFF))
	}
	if managers.system_menu then
		managers.system_menu:show(_dialog_data)
	end
end

function ChatCommand:Menu_VIPMENU_Selected_View(params)
	Steam:overlay_activate("url", "http://steamcommunity.com/profiles/" .. params.id)
	self:Menu_VIPMENU_Selected({id = params.id})
end

function ChatCommand:Menu_VIPMENU_Selected_Remove(params)
	local file, err = io.open("mods/Dedicated Server/Addons/ChatCommand/vip_list.txt", "w")
	if file then
		for k, v in pairs(self.VIP_LIST_IDX or {}) do
			if tostring(v) ~= tostring(params.id) then
				file:write(tostring(v) .. "\n")			
			end
		end
		file:close()
	end
	ChatCommand:Read_VIP_List()
	local _dialog_data = {
		title = "" .. params.id,
		text = "He is removed from VIP list.",
		button_list = {{ text = "OK", is_cancel_button = true }},
		id = tostring(math.random(0,0xFFFFFFFF))
	}
	if managers.system_menu then
		managers.system_menu:show(_dialog_data)
	end
end

Hooks:Add("GameSetupUpdate", "RTDGameSetupUpdate", function(t, dt)
	if not Utils:IsInHeist() then
		return
	end
	local function nukeunit(pawn)
		pawn:character_damage():damage_mission({damage = 9999999, forced = true})
		pawn:set_slot(0)
	end
	local nowtime = TimerManager:game():time()
	if ChatCommand.time2loopcheck then
		ChatCommand.throw_projectile = ChatCommand.throw_projectile or {}
			for id, data in pairs(ChatCommand.throw_projectile) do
				if data.enable and type(data.time_do) == "number" and nowtime > data.time_do then
					ChatCommand.throw_projectile[id].enable = false
					ProjectileBase.throw_projectile(data.projectile_index, data.pos, Vector3(0, 0, -1), 1)
					ChatCommand.throw_projectile[id] = {}
				end
			end
		ChatCommand.throw_flash = ChatCommand.throw_flash or {}
			for id, data in pairs(ChatCommand.throw_flash) do
				if data.enable and type(data.time_do) == "number" and nowtime > data.time_do then
					ChatCommand.throw_flash[id].enable = false
					if data.is_smoke == 0 or data.is_smoke == 2 then
						local _is_smoke = data.is_smoke == 0 and false or true
						managers.network:session():send_to_peers_synched("sync_smoke_grenade", data.pos, data.pos, 6, data.is_smoke)
						managers.groupai:state():sync_smoke_grenade(data.pos, data.pos, 6, data.is_smoke)
					end
					if data.is_smoke == 1 then
						local grenade = World:spawn_unit(Idstring("units/pd2_dlc_drm/weapons/smoke_grenade_tear_gas/smoke_grenade_tear_gas"), data.pos, Rotation())
						grenade:base():set_properties({
							radius = 4 * 0.7 * 100,
							damage = 30 * 0.3,
							duration = 10
						})
						grenade:base():detonate()
					end
					ChatCommand.throw_flash[id] = {}
				end
			end
		if table.size(ChatCommand.throw_flash) <= 0 and table.size(ChatCommand.throw_projectile) <= 0 then
			ChatCommand.time2loopcheck = false
		end
	end
	if ChatCommand.rtd_Hydra_bool then
		if not ChatCommand.rtd_Hydra_listdone then
			ChatCommand.rtd_Hydra_wait4do = {}
			local _all_enemies = managers.enemy:all_enemies() or {}
			local tt = 1
			for _, data in pairs(_all_enemies) do
				local enemyType = tostring(data.unit:base()._tweak_table)
				if ( enemyType == "security" or enemyType == "gensec" or 
					enemyType == "cop" or enemyType == "fbi" or 
					enemyType == "swat" or enemyType == "heavy_swat" or 
					enemyType == "fbi_swat" or enemyType == "fbi_heavy_swat" or 
					enemyType == "city_swat" or enemyType == "sniper" or 
					enemyType == "gangster" or enemyType == "taser" or 
					enemyType == "tank" or enemyType == "spooc" or enemyType == "shield" or 
					enemyType == "medic" ) then
					ChatCommand.rtd_Hydra_wait4do[tt] = {follow_unit = data.unit, unit_name = data.unit:name(), pos = data.unit:position(), t = nowtime + (tt * 0.3)}
					tt = tt + 1
				end
			end
			ChatCommand.rtd_Hydra_listdone = true
		else
			local _Hydra_Run = false
			for id, data in pairs(ChatCommand.rtd_Hydra_wait4do) do
				if data and type(data.t) == "number" and data.t > 0 then
					_Hydra_Run = true
				end
				if _Hydra_Run and data.t < nowtime then
					data.t = 0
					local _Split = 0
					if ChatCommand.rtd_Hydra_CMD and ChatCommand.rtd_Hydra_CMD.Split then
						_Split = ChatCommand.rtd_Hydra_CMD.Split
					else
						_Split = ChatCommand.rtd_Hydra_Split
					end
					for i = 1 , _Split do
						local unit_done = ChatCommand:spawn_enemy(data.unit_name, data.pos + Vector3(math.random(-200, 200), math.random(-200, 200), 0), Rotation())
					end
					ChatCommand.rtd_Hydra_wait4do[id] = nil
				end
			end
			if not _Hydra_Run then
				ChatCommand.rtd_Hydra_bool = false
				ChatCommand.rtd_Hydra_listdone = false
				ChatCommand.rtd_Hydra_wait4do = {}
				ChatCommand.rtd_Hydra_CMD = {}
			end
		end
	end
	if ChatCommand.Nuke_CMD then
		ChatCommand.Nuke_CMD = false
		local _all_enemies = managers.enemy:all_enemies() or {}
		for _, data in pairs(_all_enemies) do
			local enemyType = tostring(data.unit:base()._tweak_table)
			if ( enemyType == "security" or enemyType == "gensec" or 
				enemyType == "cop" or enemyType == "fbi" or 
				enemyType == "swat" or enemyType == "heavy_swat" or 
				enemyType == "fbi_swat" or enemyType == "fbi_heavy_swat" or 
				enemyType == "city_swat" or enemyType == "sniper" or 
				enemyType == "gangster" or enemyType == "taser" or 
				enemyType == "tank" or enemyType == "spooc" or enemyType == "shield" or 
				enemyType == "medic" ) then
				nukeunit(data.unit)
			end
		end
	end
end)