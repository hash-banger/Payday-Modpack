--	skilltreegui notable lines
--		2797 self._spec_placing_points = math.sign(dir)
--		

local make_fine_text = function(text)
	local x, y, w, h = text:text_rect()
	text:set_size(w, h)
	text:set_position(math.round(text:x()), math.round(text:y()))
end

function SkillTreeGui:update(t, dt)
	if not self._enabled then
		return
	end
	if not managers.menu:is_pc_controller() then
		local controller_spec_adding_points, controller_spec_removing_points
		if self._selected_spec_tier == managers.skilltree:get_specialization_value(self._active_spec_tree, "tiers", "current_tier") + 1 then
			controller_spec_adding_points = not self._is_skilltree_page_active and managers.menu_component:get_controller_input_bool("upgrade_alternative1")
			controller_spec_removing_points = not controller_spec_adding_points and not self._is_skilltree_page_active and managers.menu_component:get_controller_input_bool("upgrade_alternative4")
		end
		if self._controller_spec_adding_points ~= controller_spec_adding_points then
			if not controller_spec_adding_points then
				self:stop_spec_place_points()
			elseif self._controller_spec_removing_points then
				self:stop_spec_place_points()
			else
				self:start_spec_place_points(1, self._active_spec_tree)
			end
		elseif self._controller_spec_removing_points ~= controller_spec_removing_points then
			if not controller_spec_removing_points then
				self:stop_spec_place_points()
			else
				self:start_spec_place_points(-1, self._active_spec_tree)
			end
		end
		self._controller_spec_adding_points = controller_spec_adding_points
		self._controller_spec_removing_points = controller_spec_removing_points
	end
	if self._spec_placing_points then
		if self._spec_placing_points == 0 or not self._spec_placing_tree then
			return self:stop_spec_place_points()
		end
		local points_placed = self._spec_placing_points
		local tree = self._spec_placing_tree
		local current_tier = managers.skilltree:get_specialization_value(tree, "tiers", "current_tier")
		local max_tier = managers.skilltree:get_specialization_value(tree, "tiers", "max_tier")
		if current_tier == max_tier then
			return self:stop_spec_place_points()
		end
		local current_points = managers.skilltree:get_specialization_value(tree, "tiers", "next_tier_data", "current_points")
		local points = managers.skilltree:get_specialization_value(tree, "tiers", "next_tier_data", "points")
		local diff = points - current_points
		local points_to_spend = managers.skilltree:get_specialization_value("points")
		local dir = self._spec_placing_points / math.abs(self._spec_placing_points)
		local speed = math.clamp(points / 10, 150, 1000) + math.abs(self._spec_placing_points) * 10
		self._spec_placing_points = self._spec_placing_points + dt * dir * speed
		self._spec_placing_points = math.clamp(self._spec_placing_points, -current_points, math.min(diff, points_to_spend))
		self._spec_tree_items[tree]:update_progress(false, current_points + math.round(self._spec_placing_points), false)
		local progress_string = managers.localization:to_upper_text("menu_st_progress", {
			progress = string.format("%i/%i", current_points + math.round(self._spec_placing_points), points)
		})
		self._spec_description_progress:set_text(progress_string)
		if points_placed == self._spec_placing_points then
			self:stop_spec_place_points()
		else
			local points_text = self._specialization_panel:child("points_text")
			local spec_box_panel = self._specialization_panel:child("spec_box_panel")
			points_text:set_text(managers.localization:to_upper_text("menu_st_available_spec_points", {
				points = managers.money:add_decimal_marks_to_string(tostring(points_to_spend - math.round(self._spec_placing_points)))
			}))
			make_fine_text(points_text)
			points_text:set_right(spec_box_panel:right())
			points_text:set_top(spec_box_panel:bottom() + 20)
			points_text:set_position(math.round(points_text:x()), math.round(points_text:y()))
		end
	end
end