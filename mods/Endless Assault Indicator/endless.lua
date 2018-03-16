_G.EAI = _G.EAI or {}
EAI.modpath = ModPath
EAI.locfile_english = ModPath .. "/loc/english.txt"
EAI.locfile_thailand = ModPath .. "/loc/thailand.txt"
Hooks:Add("LocalizationManagerPostInit", "EAI_Localization", function(loc)
	if SystemFS:exists(Application:base_path() .. "mods/PD2TH/mod.txt", true) and SystemFS:exists(Application:base_path() .. "PD2TL") and SystemFS:exists(Application:base_path() .. "assets/mod_overrides/ThaiFont") then
		loc:load_localization_file( EAI.locfile_thailand )
	else
		loc:load_localization_file( EAI.locfile_english )
	end
end)

local _f_init = HUDAssaultCorner.init
function HUDAssaultCorner:init(hud, full_hud, tweak_hud)
	_f_init(self, hud, full_hud, tweak_hud)
	self.image = nil
	self.banner_color = nil
	self.multiplayer_game = false
	self.endless_client = false
	self.always_endless_assault = false
	self._assault_endless_color = self._noreturn_color
	self._no_endless_assault_override = false
	if managers.mutators:are_mutators_active() then
		self._assault_endless_color = Color(255, 106, 67, 255) / 255
	end
	if not Network:is_server() then
		self.heists_with_endless_assaults = { "haunted", "chew", "hvh" } -- Safe House Nightmare, The Biker Heist Day 2, Cursed Kill Room
		for k, v in pairs(self.heists_with_endless_assaults) do
			if Global.game_settings.level_id == v then
				self.always_endless_assault = true
				break;
			end
		end
	end
	self:SetNormalAssault()
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
		self.banner_color = self._vip_assault_color
		self:_hide_hostages()
	else
		self.banner_color = self._assault_color
		self:_show_hostages()
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
	if self.banner_color == self._assault_endless_color then
		self:SetNormalAssault()
	end
	if self:GetEndlessAssault() then -- Set Assault Banner Color to Red and get strings with text "ENDLESS POLICE ASSAULT IN PROGRESS" if Endless Assault was triggered by the game
		self.image = "guis/textures/pd2/hud_icon_padlockbox" -- Changes Assault Box Icon to padlock (same texture when Capitan Winters arrives)
		self.banner_color = self._assault_endless_color
		self:_set_text_list(self:_get_assault_endless_strings())
	else
		self:_set_text_list(self:_get_assault_strings())
	end
	self._assault = true
	local assault_panel = self._hud_panel:child("assault_panel")
	local text_panel = assault_panel:child("text_panel")
	if self._bg_box:child("text_panel") then
		self._bg_box:child("text_panel"):stop()
		self._bg_box:child("text_panel"):clear()
	else
		self._bg_box:panel({name = "text_panel"})
	end
	self._bg_box:child("bg"):stop()
	assault_panel:set_visible(true)
	local icon_assaultbox = assault_panel:child("icon_assaultbox")
	icon_assaultbox:set_image(self.image)
	icon_assaultbox:stop()
	icon_assaultbox:animate(callback(self, self, "_show_icon_assaultbox"))
	local config = {
		attention_color = self.banner_color,
		attention_forever = true,
		attention_color_function = callback(self, self, "assault_attention_color_function")
	}
	self._bg_box:stop()
	self._bg_box:animate(callback(nil, _G, "HUDBGBox_animate_open_left"), 0.75, 242, function()
	end, config)
	local box_text_panel = self._bg_box:child("text_panel")
	box_text_panel:stop()
	box_text_panel:animate(callback(self, self, "_animate_text"), nil, nil, callback(self, self, "assault_attention_color_function"))
	self:_set_feedback_color(self.banner_color)
	self:_update_assault_hud_color(self.banner_color)
	if alive(self._wave_bg_box) then
		self._wave_bg_box:stop()
		self._wave_bg_box:animate(callback(self, self, "_animate_wave_started"), self)
	end
	if self.endless_client then
 		self.endless_client = false
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
	if self.endless_client then
		self.endless_client = false
	end
end

function HUDAssaultCorner:SetNormalAssault()
	self.banner_color = self._assault_color
	self.image = "guis/textures/pd2/hud_icon_assaultbox"
end

function HUDAssaultCorner:_animate_normal_wave_completed(panel, assault_hud)
	wait(8.6)
	self:_close_assault_box()
end

local old_show_icon_assaultbox = HUDAssaultCorner._show_icon_assaultbox
function HUDAssaultCorner:_show_icon_assaultbox(...)
	old_show_icon_assaultbox(self, ...)
	if self.banner_color == self._assault_endless_color or self.banner_color == self._vip_assault_color then
		self:_hide_hostages()
	else -- I hate you Watch Dogs Day 2
		if not self._casing then
 			self:_show_hostages()
 		end
	end
end

local old_hide_icon_assaultbox = HUDAssaultCorner._hide_icon_assaultbox
function HUDAssaultCorner:_hide_icon_assaultbox(...)
	old_hide_icon_assaultbox(self, ...)
 	self:_show_hostages()
end

--[[local old_close_assault_box = HUDAssaultCorner._close_assault_box
function HUDAssaultCorner:_close_assault_box()
	if self._assault then
		return
	end
	old_close_assault_box(self)
end]]

function HUDAssaultCorner:GetEndlessAssault()
	if self._no_endless_assault_override then
		return false
	end
	if Network:is_server() then
		if managers.groupai:state():get_hunt_mode() then
			if multiplayer_game then -- Only send when playing Multiplayer and atleast 1 client must have it.
				LuaNetworking:SendToPeers("EAI_Message", "endless_triggered")
			end
			return true
		end
		return false
	else
		if self.always_endless_assault then
			return true
		end
		return self.endless_client
	end
end

Hooks:Add("NetworkReceivedData", "NetworkReceivedData_EAI", function(sender, id, data)
	if id == "EAI_Message" then
		if data == "endless_triggered" then
			self.endless_client = true
		end
		if data == "EAI?" then
			self.multiplayer_game = true
			LuaNetworking:SendToPeer(sender, id, "EAI!")
		end
		if data == "EAI!" then
			LuaNetworking:SendToPeer(1, id, "IsEndlessAssault?")
		end
		if data == "IsEndlessAssault?" then
			if self._assault_mode ~= "phalanx" and managers.groupai:state():get_hunt_mode() then -- Notifies drop-in client about Endless Assault in progress
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