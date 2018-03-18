local spot_lines = {
	"f42_any",
	"g10",
	"g15"
}
local nof42 = {
	"bodhi",
	"jimmy",
	"sydney",
	"wild",
	"chico",
	"max",
	"myh",
	"ecp_male",
	"ecp_female"
}

local say_orig = PlayerSound.say
function PlayerSound:say(sound_name, ...)
	if sound_name == "f42_any" then
		local character = managers.criminals:character_name_by_unit(self._unit)
		Application:set_clipboard(tostring(table.contains(nof42, character)))
		sound_name = table.contains(nof42, character) and spot_lines[math.random(2, 3)] or spot_lines[math.random(1, 3)]
	end
	self._last_speech = say_orig(self, sound_name, ...)
	return self._last_speech
end