--ElementMoveUnit--
--Created by Luffy, modified by Simon W

core:import("CoreMissionScriptElement")
ElementMoveUnit = ElementMoveUnit or class(CoreMissionScriptElement.MissionScriptElement)
function ElementMoveUnit:init(...)
	self._units = {}
	ElementMoveUnit.super.init(self, ...)
end

function ElementMoveUnit:on_script_activated()
	for _, id in pairs(self._values.unit_ids) do
		local unit = managers.worlddefinition:get_unit_on_load(id)
		if unit then
			table.insert(self._units, unit)
		end
	end
	self._has_fetched_units = true
end

function ElementMoveUnit:client_on_executed(...)
	self:on_executed(...)
end

function ElementMoveUnit:on_executed(instigator)
	if not self._values.enabled then
		return
	end
	if not self._values.end_pos and not self._values.displacement then
		BeardLib:log("[ERROR] MoveUnit must either have a displacement or end position defined!")
		return
	end

	if #self._units == 0 and alive(instigator) then
		self:register_move_unit(instigator)
	else
		for _, unit in pairs(self._units) do
			self:register_move_unit(unit)
		end
	end
end

function ElementMoveUnit:register_move_unit(unit)
	if self._values.remember_unit_position then
		unit:unit_data().orig_pos = unit:unit_data().orig_pos or mvector3.copy(unit:position())
	end

	local start_pos = self._values.start_pos or self._values.unit_position_as_start_position and unit:unit_data().orig_pos or unit:position() or self._values.position
	local end_pos = self._values.end_pos
	if not end_pos and self._values.displacement then
		end_pos = mvector3.copy(start_pos)
		mvector3.add(end_pos, self._values.displacement)
	end
	managers.game_play_central:add_move_unit(unit, start_pos, end_pos, self._values.speed, ClassClbk(self, "done_callback", unit))
end

function ElementMoveUnit:done_callback(instigator)
	ElementMoveUnit.super.on_executed(self, instigator)
end

function ElementMoveUnit:save(data)
	data.save_me = true
	data.enabled = self._values.enabled
end

function ElementMoveUnit:load(data)
	if not self._has_fetched_units then
		self:on_script_activated()
	end
	self:set_enabled(data.enabled)
end
