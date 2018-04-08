KeybindModule = KeybindModule or class(ModuleBase)

KeybindModule.type_name = "Keybind"

function KeybindModule:init(core_mod, config)
    if not KeybindModule.super.init(self, core_mod, config) then
        return false
    end

    self:Load()

    return true
end

function KeybindModule:Load()
	if not self._config.keybind_id and not self._config.id then 
		self:log("[ERROR] Keybind does not contain a definition for keybind_id!")
		return
	end

	local config = table.merge({run_in_menu = true, run_in_game = true}, self._config)
	
	if BLT and BLT.Keybinds then
		BLT.Keybinds:register_keybind_json(self._mod, config)
	else
		LuaModManager:AddJsonKeybinding(config, self._mod.ModPath .. "/")		
	end
end

BeardLib:RegisterModule(KeybindModule.type_name, KeybindModule)