local selected_original = BaseInteractionExt.selected

function BaseInteractionExt:selected(...)
	selected_original(self, ...)

	local _text_id = self._tweak_data.text_id or alive(self._unit) and self._unit:base().interaction_text_id and self._unit:base():interaction_text_id()
	local _string_macros = {}

	self:_add_string_macros(_string_macros)

	if self._tweak_data.special_equipment and not managers.player:has_special_equipment(self._tweak_data.special_equipment) then
		return true
	end

	if _text_id then
		local basic_text = managers.localization:text(_text_id, _string_macros)
		managers.hud:show_interact({
			text = basic_text .. " (" .. self:check_interact_time() .. " s)",
			icon = self._tweak_data.icon
		})
	end
	
	return true
end

function BaseInteractionExt:check_interact_time()
	local interact_timer = 0
	if self:_timer_value() then
		interact_timer = self:_get_timer()
	end
	if interact_timer < 10 then
		if string.len(interact_timer) > 3 then
			interact_timer = string.sub(math.round(interact_timer * 10) / 10, 1, 3)
		elseif string.len(interact_timer) == 1 then
			interact_timer = interact_timer .. ".0"
		end
	else
		if string.len(interact_timer) > 4 then
			interact_timer = string.sub(math.round(interact_timer * 10) / 10, 1, 4)
		elseif string.len(interact_timer) == 2 then
			interact_timer = interact_timer .. ".0"
		end
	end
	return interact_timer
end