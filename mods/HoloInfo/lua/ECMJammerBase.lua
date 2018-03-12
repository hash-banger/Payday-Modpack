if HoloInfo.options.ECMtimer_enable then
HoloInfo:clone(ECMJammerBase)
function ECMJammerBase:set_active(active, ...)
	self.old.set_active(self,active ,...)
	if HoloInfo._hudinfo then
		if active == true then
		    HoloInfo._hudinfo:create_timer(self._unit:id())
	    end
	end
end

function ECMJammerBase:update(...)
	self.old.update(self, ...)
	if HoloInfo._hudinfo then
		if self._jammer_active == true then
			HoloInfo._hudinfo:set_timer(self._unit:id(), self._chk_feedback_retrigger_t or self._battery_life, "ECM")
	    end
	end
end
function ECMJammerBase:set_battery_empty(...)
	self.old.set_battery_empty(self, ...)
	if HoloInfo._hudinfo then
		if managers.hud then
			HoloInfo._hudinfo:remove_timer(self._unit:id())
		end
	end
end
function ECMJammerBase:destroy(...)
	self.old.destroy(self, ...)
	if HoloInfo._hudinfo then
		if managers.hud then
			HoloInfo._hudinfo:remove_timer(self._unit:id())
		end
	end
end
end