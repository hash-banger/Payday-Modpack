
	_G.AdvAssault = _G.AdvAssault or {}
	AdvAssault._path = ModPath

	Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_AdvAssault", function( loc )
	local loc_path = AdvAssault._path .. "loc/"
		for _, filename in pairs(file.GetFiles(loc_path)) do
			local str = filename:match('^(.*).json$')
			if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
				loc:load_localization_file(loc_path .. filename)
				break
			end
		end
		loc:load_localization_file(loc_path .. "english.json", false)
	end)
	
	local advanced_assault = true -- true / false
	if not advanced_assault then return end

if string.lower(RequiredScript) == "lib/managers/hud/hudassaultcorner" then
	
	local _start_assault_original = HUDAssaultCorner._start_assault
	local sync_set_assault_mode_original = HUDAssaultCorner.sync_set_assault_mode
	
	function HUDAssaultCorner:_start_assault(text_list, ...)
		if Network:is_server() then
			for i, string_id in ipairs(text_list) do
				if string_id == "hud_assault_assault" then
					text_list[i] = "hud_adv_assault"
				end
			end
		end
		return _start_assault_original(self, text_list, ...)
	end
	
	function HUDAssaultCorner:locked_assault(status)
		if self._assault_locked == status then return end
		local assault_panel = self._hud_panel:child("assault_panel")
		local icon_assaultbox = assault_panel and assault_panel:child("icon_assaultbox")
		local image
		self._assault_locked = status
		if status then
			image = "guis/textures/pd2/hud_icon_padlockbox"
		else
			image = "guis/textures/pd2/hud_icon_assaultbox"
		end
		if icon_assaultbox and image then
			icon_assaultbox:set_image(image)
		end
	end
elseif string.lower(RequiredScript) == "lib/managers/hudmanagerpd2" then
	function HUDManager:_locked_assault(status)
		status = Network:is_server() and (managers.groupai:state():get_hunt_mode() or false) or status
		self._assault_locked = self._assault_locked or false
		if self._assault_locked ~= status then
			if self._hud_assault_corner then
				self._hud_assault_corner:locked_assault(status)
			end
			self._assault_locked = status
		end
		return self._assault_locked
	end
elseif string.lower(RequiredScript) == "lib/managers/localizationmanager" then
	local text_original = LocalizationManager.text

	function LocalizationManager:text(string_id, ...)
		if string_id == "hud_adv_assault" then
			return self:hud_adv_assault()
		end
		return text_original(self, string_id, ...)
	end

	function LocalizationManager:hud_adv_assault()
		if advanced_assault then
			if managers.hud and managers.hud:_locked_assault() then
				return self:text("wolfhud_locked_assault")
			else
				local tweak = tweak_data.group_ai.besiege.assault
				local gai_state = managers.groupai:state()
				local assault_data = Network:is_server() and gai_state and gai_state._task_data.assault
				if tweak and gai_state and assault_data and assault_data.active then
					local get_value = gai_state._get_difficulty_dependent_value or function() return 0 end
					local get_mult = gai_state._get_balancing_multiplier or function() return 0 end
					local phase = self:text("wolfhud_advassault_phase_title") .. "  " .. self:text("wolfhud_advassault_phase_" .. assault_data.phase)

					local spawns = get_value(gai_state, tweak.force_pool) * get_mult(gai_state, tweak.force_pool_balance_mul)
					local spawns_left = self:text("wolfhud_advassault_spawns_title") .. "  " .. math.round(math.max(spawns - assault_data.force_spawned, 0))

					local time_left = assault_data.phase_end_t - gai_state._t + 350
					if assault_data.phase == "build" then
						local sustain_duration = math.lerp(get_value(gai_state, tweak.sustain_duration_min), get_value(gai_state, tweak.sustain_duration_max), 0.5) * get_mult(gai_state, tweak.sustain_duration_balance_mul)
						time_left = time_left + sustain_duration + tweak.fade_duration
					elseif assault_data.phase == "sustain" then
						time_left = time_left + tweak.fade_duration
					end
					--if gai_state:_count_police_force("assault") > 7 then -- 350 = additional duration, if more than 7 assault groups are active (hardcoded values in gai_state).
					--	time_left = time_left + 350
					--end
					if time_left < 0 then
						time_left = self:text("wolfhud_advassault_time_overdue")
					else
						time_left = self:text("wolfhud_advassault_time_title") .. "  " .. string.format("%.2f", time_left)
					end

					local spacer = string.rep(" ", 10)
					local sep = string.format("%s%s%s", spacer, self:text("hud_assault_end_line"), spacer)
					return string.format("%s%s%s%s%s", phase, sep, spawns_left, sep, time_left)
				end
			end
		end
		return self:text("hud_assault_assault")
	end
end

