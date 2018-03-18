Hooks:PreHook(CopInventory, "_chk_spawn_shield", "_give_dozer_shield", function(self, weapon_unit)
local shield_units = {
	"tank",
	"tank_hw",
	"tank_mini",
	"shield"
}
	if self._unit and self._unit:base() and self._unit:base()._tweak_table and table.contains(shield_units, self._unit:base()._tweak_table) then
		self._shield_unit_name = "units/payday2/characters/ene_acc_shield_lights/ene_acc_shield_lights"
	end
end)