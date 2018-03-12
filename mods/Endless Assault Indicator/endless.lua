EAI = {}
EAI.modpath = ModPath
EAI.locfile_english = ModPath .. "/en.txt"
Hooks:Add("LocalizationManagerPostInit", "EAI_Localization", function(loc)
	loc:load_localization_file( EAI.locfile_english )
end)

color = nil
hostages_hidden = false
host_has_it = false
multiplayer_game = false
endless_client = false

local old_init = HUDAssaultCorner.init
function HUDAssaultCorner:init(...)
	old_init(self, ...)
	self._assault_endless_color = Color(1, 1, 0, 0)
	if managers.mutators:are_mutators_active() then
		self._assault_endless_color = Color(255, 106, 67, 255) / 255
	end
end

function HUDAssaultCorner:show_point_of_no_return_timer()
	local delay_time = self._assault and 1.2 or 0
	self:_close_assault_box()
	local point_of_no_return_panel = self._hud_panel:child("point_of_no_return_panel")
	self:_hide_hostages()
	point_of_no_return_panel:stop()
	point_of_no_return_panel:animate(callback(self, self, "_animate_show_noreturn"), delay_time)
	self:_set_feedback_color(self._noreturn_color)
	self._point_of_no_return = true
end

local old_sync_set_assault_mode = HUDAssaultCorner.sync_set_assault_mode
function HUDAssaultCorner:sync_set_assault_mode(mode)
	old_sync_set_assault_mode(self, mode)
	if mode == "phalanx" then
		if not hostages_hidden then
			hostages_hidden = true
			self:_hide_hostages()
		end
	end
end

function HUDAssaultCorner:_get_assault_endless_strings()
	if managers.job:current_difficulty_stars() > 0 then
		local ids_risk = Idstring("risk")
		return {
			"hud_assault_endless",
			"hud_assault_end_line",
			ids_risk,
			"hud_assault_end_line",
			"hud_assault_endless",
			"hud_assault_end_line",
			ids_risk,
			"hud_assault_end_line"
		}
	else
		return {
			"hud_assault_endless",
			"hud_assault_end_line",
			"hud_assault_endless",
			"hud_assault_end_line",
			"hud_assault_endless",
			"hud_assault_end_line"
		}
	end
end

function HUDAssaultCorner:_start_assault(text_list)
	local image
	if self:GetEndlessAssault() then -- Set Assault Banner Color to Red and get strings with text "ENDLESS POLICE ASSAULT IN PROGRESS" if Endless Assault was triggered by the game
		image = "guis/textures/pd2/hud_icon_padlockbox" -- Changes Assault Box Icon to padlock (same texture when Capitan Winters arrives)
		color = self._assault_endless_color
		self:_set_text_list(self:_get_assault_endless_strings())
	else
		image = "guis/textures/pd2/hud_icon_assaultbox" -- Defaults to default icon for Assault Box
		color = self._assault_color
		self:_set_text_list(self:_get_assault_strings())
	end
	local assault_panel = self._hud_panel:child("assault_panel")
	local text_panel = assault_panel:child("text_panel")
	self._assault = true
	if self._bg_box:child("text_panel") then
		self._bg_box:child("text_panel"):stop()
		self._bg_box:child("text_panel"):clear()
	else
		self._bg_box:panel({name = "text_panel"})
	end
	self._bg_box:child("bg"):stop()
	assault_panel:set_visible(true)
	local icon_assaultbox = assault_panel:child("icon_assaultbox")
	icon_assaultbox:set_image(image)
	icon_assaultbox:stop()
	icon_assaultbox:animate(callback(self, self, "_show_icon_assaultbox"))
	local config = {
		attention_color = color,
		attention_forever = true,
		attention_color_function = callback(self, self, "assault_attention_color_function")
	}
	self._bg_box:stop()
	self._bg_box:animate(callback(nil, _G, "HUDBGBox_animate_open_left"), 0.75, 242, function()
	end, config)
	local box_text_panel = self._bg_box:child("text_panel")
	box_text_panel:stop()
	box_text_panel:animate(callback(self, self, "_animate_text"), nil, nil, callback(self, self, "assault_attention_color_function"))
	self:_set_feedback_color(color)
	self:_update_assault_hud_color(color)
	if alive(self._wave_bg_box) then
		self._wave_bg_box:stop()
		self._wave_bg_box:animate(callback(self, self, "_animate_wave_started"), self)
	end
	if endless_client then
 		endless_client = false
 	end
end

function HUDAssaultCorner:_end_assault()
 	if not self._assault then
 		self._start_assault_after_hostage_offset = nil
 		return             
 	end

	self:_set_feedback_color(nil)
	self._assault = false
	local box_text_panel = self._bg_box:child("text_panel")
	box_text_panel:stop()
	box_text_panel:clear()
	self._remove_hostage_offset = true
	self._start_assault_after_hostage_offset = nil
	local icon_assaultbox = self._hud_panel:child("assault_panel"):child("icon_assaultbox")
	icon_assaultbox:stop()

	self:_update_assault_hud_color(self._assault_survived_color)
	self:_set_text_list(self:_get_survived_assault_strings())
	box_text_panel:animate(callback(self, self, "_animate_text"), nil, nil, callback(self, self, "assault_attention_color_function"))

	if self:is_safehouse_raid() then
		self._wave_bg_box:stop()
		self._wave_bg_box:animate(callback(self, self, "_animate_wave_completed"), self)
	else
		box_text_panel:animate(callback(self, self, "_animate_normal_wave_completed"), self)
	end
end

function HUDAssaultCorner:_animate_normal_wave_completed(panel, assault_hud)
	wait(8.6)
	self:_close_assault_box()
end

local old_show_icon_assaultbox = HUDAssaultCorner._show_icon_assaultbox
function HUDAssaultCorner:_show_icon_assaultbox(...)
	old_show_icon_assaultbox(self, ...)
	if color == self._assault_endless_color then
		if not hostages_hidden then
			hostages_hidden = true
			self:_hide_hostages()
		end
	else
		if hostages_hidden then -- I hate you Watch Dogs Day 2
 			hostages_hidden = false
 			self:_show_hostages()
 		end
	end
end

local old_hide_icon_assaultbox = HUDAssaultCorner._hide_icon_assaultbox
function HUDAssaultCorner:_hide_icon_assaultbox(...)
	old_hide_icon_assaultbox(self, ...)
	if hostages_hidden then
 		hostages_hidden = false
 		self:_show_hostages()
 	end
end

--[[local old_close_assault_box = HUDAssaultCorner._close_assault_box
function HUDAssaultCorner:_close_assault_box()
	if self._assault then
		return
	end
	old_close_assault_box(self)
end]]

function HUDAssaultCorner:GetEndlessAssault()
	if Network:is_server() then
		if managers.groupai:state():get_hunt_mode() then
			if multiplayer_game then -- Only send when playing Multiplayer and atleast 1 client must have it.
				LuaNetworking:SendToPeers("EAI_Message", "endless_triggered")
			end
		end
		return managers.groupai:state():get_hunt_mode()
	else
		return endless_client
	end
end

if Global.game_settings.level_id == "pbr" and (Network:is_server() or (not Network:is_server() and host_has_it)) then -- Fix for Beneath the Mountain
	local _f_DialogManager_queue_dialog = DialogManager.queue_dialog
	function DialogManager:queue_dialog(id, ...)
		if id == "Play_loc_jr1_23" then
			log("[EAI]: " .. id)
			managers.hud:SetNormalAssaultOverride()
		end
    	return _f_DialogManager_queue_dialog(self, id, ...)
	end

	function HUDManager:SetNormalAssaultOverride()
		self._hud_assault_corner:SetNormalAssaultOverride()
	end

	function HUDAssaultCorner:SetNormalAssaultOverride()
		self._hud_panel:child("assault_panel"):child("icon_assaultbox"):set_image("guis/textures/pd2/hud_icon_assaultbox")
		self:_update_assault_hud_color(self._assault_color)
		self:_set_text_list(self:_get_assault_strings())
		self.hostages_hidden = false
		self:_show_hostages()
	end
end

Hooks:Add("NetworkReceivedData", "NetworkReceivedData_EAI", function(sender, id, data)
	if id == "EAI_Message" then
		if data == "endless_triggered" then
			endless_client = true
		end
		if data == "EAI?" then
			multiplayer_game = true
			LuaNetworking:SendToPeer(sender, id, "EAI!")
		end
		if data == "EAI!" then
			host_has_it = true
			LuaNetworking:SendToPeer(1, id, "IsEndlessAssault?")
		end
		if data == "IsEndlessAssault?" then
			if managers.groupai:state():get_hunt_mode() then -- Notifies drop-in client about Endless Assault in progress
				LuaNetworking:SendToPeer(sender, id, "endless_triggered")
			end
		end
	end
end)

Hooks:Add("BaseNetworkSessionOnLoadComplete", "BaseNetworkSessionOnLoadComplete_EAI", function(local_peer, id)
	if not Network:is_server() then
		LuaNetworking:SendToPeer(1, "EAI_Message", "EAI?")
	end
end)