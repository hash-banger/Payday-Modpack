_G.DedicatedServer = _G.DedicatedServer or {}

DedicatedServer.ModPath = ModPath
DedicatedServer.options_menu = "DedicatedServer_menu"
DedicatedServer.Settings = {}
DedicatedServer.Last_Data = {}

if ModCore then
	ModCore:new(DedicatedServer.ModPath .. "Config.xml", false, true):init_modules()
end

DedicatedServer.Default_Settings = {
	["Lobby_Name"] = "Auto-Lobby by Dr_Newbie",
	["Lobby_Announce_When_Someone_Join"] = {
		"Welcome to this lobby, this lobby host by BOT",
		"This bot will auto open lobby and start the game",
		"If bot stuck, it means someone isn't ready or loaded"
	},
	["Lobby_Always_Create_New_Lobby"] = false,
	["Lobby_Min_Amount_To_Start"] = 1,
	["Lobby_Time_To_Start_Game"] = 36,
	["Lobby_Time_To_Forced_Start_Game"] = 72,
	["Lobby_Do_Countdown_Before_Start_Game"] = 4,
	["Lobby_Default_Setting"] = {
		["job"] = "rat",
		["difficulty"] = "easy_wish",
		["permission"] = "public",
		["min_rep"] = 0,
		["drop_in"] = true,
		["kicking_allowed"] = true,
		["team_ai"] = true,
		["auto_kick"] = true
	},
	["Lobby_Hesitcycle"] = {
		{ ["difficulty"] = "easy_wish", ["job"] = "mia" },
		{ ["difficulty"] = "easy_wish", ["job"] = "hox" },
		{ ["difficulty"] = "easy_wish", ["job"] = "branchbank_cash" },
		{ ["difficulty"] = "easy_wish", ["job"] = "run" },
		{ ["difficulty"] = "easy_wish", ["job"] = "hvh" },
		{ ["difficulty"] = "easy_wish", ["job"] = "hox_3" },
		{ ["difficulty"] = "easy_wish", ["job"] = "wwh" },
		{ ["difficulty"] = "easy_wish", ["job"] = "glace" },
		{ ["difficulty"] = "easy_wish", ["job"] = "jewelry_store" },
		{ ["difficulty"] = "easy_wish", ["job"] = "mallcrasher" },
		{ ["difficulty"] = "easy_wish", ["job"] = "red2" },
		{ ["difficulty"] = "easy_wish", ["job"] = "haunted" },
		{ ["difficulty"] = "easy_wish", ["job"] = "dah" },
		{ ["difficulty"] = "easy_wish", ["job"] = "dinner" },
		{ ["difficulty"] = "easy_wish", ["job"] = "four_stores" },
		{ ["difficulty"] = "easy_wish", ["job"] = "pal" },
		{ ["difficulty"] = "easy_wish", ["job"] = "man" },
		{ ["difficulty"] = "easy_wish", ["job"] = "watchdogs" },
		{ ["difficulty"] = "easy_wish", ["job"] = "flat" }
	},
	["Game_Send_HostBOT_To_Jail"] = true,
	["Game_HostBOT_Donnot_Release"] = true,
	["Game_Cancel_Hesit_Casue_Wait_Too_Long"] = 180,
	["Game_Kick_Who_Not_Ready_Yet"] = 170,
	["Game_Announce_When_Ready_To_Start"] = {
		"!! Auto-Lobby !!",
		"欢迎来到自动房",
		"本机器人会自动开新房和执行游戏",
		"如果机器人卡住，这代表有人未准备或载入",
		"本房有启用ChatCommand，输入[!help]来解更多",
		"Welcome to Auto-Lobby",
		"This bot will auto open lobby and start the game",
		"If bot stuck, it means someone isn't ready or loaded",
		"Say(Press t) [!help] for more info about this lobby!!"
	},
	["Addons_ChatCommand_Enable"] = true,
	["One_More_Bot"] = false,
	["All_Dead_Auto_Restart"] = true
}

Hooks:Add("LocalizationManagerPostInit", "DedicatedServer_loc", function(loc)
	LocalizationManager:load_localization_file(DedicatedServer.ModPath .. "/loc/en.txt")
end)

Hooks:Add("MenuManagerSetupCustomMenus", "DedicatedServerOptions", function(menu_manager, nodes)
	MenuHelper:NewMenu(DedicatedServer.options_menu)
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "DedicatedServerOptions", function(menu_manager, nodes)
	MenuCallbackHandler.DedicatedServer_menu_Reset_callback = function(self, item)
		DedicatedServer:Reset_Settings()
		DedicatedServer:Reset_Last_Data()
		local _dialog_data = {
			title = "Dedicated Server",
			text = "Reset all to default",
			button_list = {{ text = "[OK]", is_cancel_button = true }},
			id = tostring(math.random(0,0xFFFFFFFF))
		}
		managers.system_menu:show(_dialog_data)
	end
	MenuHelper:AddButton({
		id = "DedicatedServer_menu_Reset_callback",
		title = "DedicatedServer_menu_Reset_title",
		callback = "DedicatedServer_menu_Reset_callback",
		menu_id = DedicatedServer.options_menu,
	})
end)

Hooks:Add("MenuManagerBuildCustomMenus", "DedicatedServerOptions", function(menu_manager, nodes)
	nodes[DedicatedServer.options_menu] = MenuHelper:BuildMenu(DedicatedServer.options_menu)
	MenuHelper:AddMenuItem(MenuHelper.menus.lua_mod_options_menu, DedicatedServer.options_menu, "DedicatedServer_menu_title", "DedicatedServer_menu_desc")
end)

function DedicatedServer:Save_Settings()
	local _file = io.open(self.ModPath .. "/cfg/Settings.txt", "w+")
	if _file then
		_file:write(json.encode(self.Settings))
		io.close(_file)
	end
end

function DedicatedServer:Save_Last_Data()
	local _file = io.open(self.ModPath .. "/tmp/Last_Data.txt", "w+")
	if _file then
		_file:write(json.encode(self.Last_Data))
		io.close(_file)
	end
end

function DedicatedServer:Load_Last_Datat()
	local _file = io.open(self.ModPath .. "/tmp/Last_Data.txt", "r")
	if _file then
		self.Last_Data = json.decode(_file:read("*all"))
		io.close(_file)
	else
		self:Reset_Last_Data()
	end
end

function DedicatedServer:Load_Settings()
	local _file = io.open(self.ModPath .. "/cfg/Settings.txt", "r")
	if _file then
		self.Settings = json.decode(_file:read("*all"))
		io.close(_file)
	else
		self:Reset_Settings()
	end
	for id, value in pairs(self.Default_Settings) do
		if not self.Settings[id] then
			self.Settings[id] = self.Default_Settings[id]
		end
	end
	self:Save_Settings()
end

function DedicatedServer:Reset_Last_Data()
	self.Last_Data = {
		Last_Lobby_Hesitcycle = 1,
		CreateDedicatedServer = false,
	}
	self:Save_Last_Data()
end

function DedicatedServer:Reset_Settings()
	self.Settings = self.Default_Settings
	self:Save_Settings()
end

function DedicatedServer:Is_On()
	return self.Last_Data.CreateDedicatedServer
end

DedicatedServer:Load_Last_Datat()

DedicatedServer:Load_Settings()