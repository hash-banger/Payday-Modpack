_G.DedicatedServer = _G.DedicatedServer or {}

Hooks:Add("MenuManagerBuildCustomMenus", "CreateDedicatedServerLobbyMenu", function(menu_manager, nodes)
	local mainmenu = nodes.main
	if mainmenu == nil then
		return
	end
	if mainmenu._items == nil then
		log("[CreateEmptyLobby] Fatal Error: Main menu node is empty, aborting")
		return
	end
	local data = {
		type = "CoreMenuItem.Item",
	}
	local params = {
		name = "createautolobby_btn",
		text_id = "DedicatedServer_menu_createautolobby_title",
		help_id = "DedicatedServer_menu_createautolobby_desc",
		callback = "createautolobby_callback"
	}
	local new_item = mainmenu:create_item(data, params)
	new_item.dirty_callback = callback(mainmenu, mainmenu, "item_dirty")
	if mainmenu.callback_handler then
		new_item:set_callback_handler(mainmenu.callback_handler)
	end

	local position = 2
	for index, item in pairs(mainmenu._items) do
		if item:name() == "crimenet_offline" then
			position = index
			break
		end
	end
	table.insert(mainmenu._items, position, new_item)
end)

function MenuCallbackHandler:createautolobby_callback()
	Global.game_settings.permission = "public"
	managers.job:deactivate_current_job()
	managers.gage_assignment:deactivate_assignments()
	Global.load_level = false
	Global.level_data.level = nil
	Global.level_data.mission = nil
	Global.level_data.world_setting = nil
	Global.level_data.level_class_name = nil
	Global.level_data.level_id = nil
	self:create_lobby()
	DedicatedServer.Last_Data = DedicatedServer.Last_Data or {}
	DedicatedServer.Last_Data.CreateDedicatedServer = true
	DedicatedServer:Save_Last_Data()
end