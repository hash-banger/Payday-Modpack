if HoloInfo.options.Drilltimer_enable then

HoloInfo:clone(TimerGui)
function TimerGui:init(...)
	self.old.init(self, ...)
	self._unit_names_id = {"", "", "", ""}
	self._unit_names = {
	    drill = "Drill", 
	    lance = "Thermal".."\n".."drill",
	    huge_lance = "The Beast",
	    votingmachine2 = "Hacking", hack_suburbia = "Hacking",hold_hack_comp = "Hacking",
	    hold_download_keys = "Download",
	    hold_analyze_evidence = "analyze",
	    uload_database = "Upload"
	}
end

function TimerGui:_start(...)
	self.old._start(self, ...)
	if not self._created then
	    if self._unit:interaction() then
	    	if self._unit:interaction().tweak_data then
	    		self._name = self._unit_names[self._unit:interaction().tweak_data]
	    	else
	    		self._name = "Timer"
	    	end
	    else
	    	self._name = "Timer"
	    end
	    if HoloInfo._hudinfo then
			HoloInfo._hudinfo:create_timer(self._unit:id())
		end
		self._created = true 
    end
end
function TimerGui:update(...)
	self.old.update(self, ...)
	if HoloInfo._hudinfo then
		if not self._jammed then
			HoloInfo._hudinfo:set_timer(self._unit:id(),self._time_left or self._current_timer or self._current_jam_timer,self._name)
		end

		if not alive(self._new_gui) and not alive(self._ws) then
	       HoloInfo._hudinfo:remove_timer(self._unit:id())
		end
	end
end
function TimerGui:_set_jammed(...)
	self.old._set_jammed(self, ...)	
	if HoloInfo._hudinfo then
      HoloInfo._hudinfo:set_jammed(self._unit:id(), self._time_left or self._current_timer or self._current_jam_timer, self._name)
  	end
end
function TimerGui:done(...)
	self.old.done(self, ...)	
	if HoloInfo._hudinfo then
		HoloInfo._hudinfo:remove_timer(self._unit:id())
		self._created = nil
	end
end
function TimerGui:_set_done(...)
	self.old._set_done(self, ...)	
	if HoloInfo._hudinfo then
		HoloInfo._hudinfo:remove_timer(self._unit:id())
		self._created = nil
	end
end
function TimerGui:destroy(...)
	self.old.destroy(self, ...)	
	if HoloInfo._hudinfo then
		HoloInfo._hudinfo:remove_timer(self._unit:id())
		self._created = nil
	end
end

function TimerGui:_set_powered(...)
	self.old._set_powered(self, ...)	
	if HoloInfo._hudinfo then
		if not self._powered then
			HoloInfo._hudinfo:set_jammed(self._unit:id(), self._time_left or self._current_timer or self._current_jam_timer, self._name)
		end
	end
end

function TimerGui:post_event(...)
	self.old.post_event(self, ...)	
	if HoloInfo._hudinfo then
		if event == self._done_event then
			HoloInfo._hudinfo:remove_timer(self._unit:id())
		    self._created = nil
		end
	end
end
DrillTimerGui = DrillTimerGui or class(TimerGui)
Hooks:PostHook(DrillTimerGui, "post_event", "remove_timer", function(self, event)
	if HoloInfo._hudinfo then
		if event == self._done_event then
			HoloInfo._hudinfo:remove_timer(self._unit:id())
		    self._created = nil
		end
	end
end) 
end