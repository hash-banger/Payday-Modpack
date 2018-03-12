LevelModule = LevelModule or class(ItemModuleBase)

LevelModule.type_name = "level"
LevelModule.levels_folder = "levels/mods/"
function LevelModule:init(core_mod, config, load)
    if not LevelModule.super.init(self, core_mod, config) then
        return false
    end

    self._config.id = tostring(self._config.id)
    if Global.level_data and Global.level_data.level_id == self._config.id then
        BeardLib.current_level = self
        self:Load()
    end
    return true
end

function LevelModule:Load()
    if self._config.include then
        for i, include_data in ipairs(self._config.include) do
            if include_data.file then
                local file_split = string.split(include_data.file, "[.]")
                local complete_path = BeardLib.Utils.Path:Combine(self._mod.ModPath, self._config.include.directory, include_data.file)
                local new_path = BeardLib.Utils.Path:Combine(self.levels_folder, self._config.id, file_split[1])
                if FileIO:Exists(complete_path) then
                    if include_data.type then
                        BeardLib:ReplaceScriptData(complete_path, include_data.type, new_path, file_split[2], {add = true})
                    else
                        FileManager:AddFile(file_split[2]:id(), new_path:id(), complete_path)
                    end
                else
                    self:log("[ERROR] Included file '%s' is not readable by the lua state!", complete_path)
                end
            end
        end
    end

    if self._config.add then
        self._loaded_addfiles = AddFilesModule:new(self._mod, self._config.add)
        Global.level_data._add = Global.level_data._add or self._loaded_addfiles
    end

    if self._config.script_data_mods then
        local script_mods = ScriptReplacementsModule:new(self._mod, self._config.script_data_mods)
        script_mods:post_init()
    end

    if self._config.hooks then
        HooksModule:new(self._mod, self._config.hooks)
    end
end

function LevelModule:AddLevelDataToTweak(l_self)
    l_self[self._config.id] = table.merge(clone(self._config), {
        name_id = self._config.name_id or "heist_" .. self._config.id .. "_name",
        briefing_id = self._config.brief_id or "heist_" .. self._config.id .. "_brief",
        world_name = "mods/" .. self._config.id,
        ai_group_type = l_self.ai_groups[self._config.ai_group_type] or l_self.ai_groups.default,
        intro_event = self._config.intro_event or "nothing",
        outro_event = self._config.outro_event or "nothing",
        music = self._config.music or "heist",
        custom_packages = self._config.packages or self._config.custom_packages,
        custom = true
    })
    if self._config.merge_data then
        table.merge(l_self[self._config.id], BeardLib.Utils:RemoveMetas(self._config.merge_data, true))
    end
    table.insert(l_self._level_index, self._config.id)
end

function LevelModule:AddAssetsDataToTweak(a_self)
    for _, value in ipairs(self._config.assets) do
        if value._meta == "asset" then
            if a_self[value.name] ~= nil then
                table.insert(value.exclude and a_self[value.name].exclude_stages or a_self[value.name].stages, self._config.id)
            else
                self:log("[ERROR] Asset %s does not exist! (Map: %s)", value.name, name)
            end
        else
            if not a_self[value._meta] then
                a_self[value._meta] = value
            else
                self:log("[ERROR] Asset with name: %s already exists! (Map: %s)", value._meta, name)
            end
        end
    end
end

function LevelModule:RegisterHook()
    if tweak_data and tweak_data.levels then    
        self:AddLevelDataToTweak(tweak_data.levels)
    else
        Hooks:PostHook(LevelsTweakData, "init", self._config.id .. "AddLevelData", callback(self, self, "AddLevelDataToTweak"))
    end

    if self._config.assets then
        if tweak_data and tweak_data.assets then
            self:AddAssetsDataToTweak(tweak_data.assets)
        else
            Hooks:PostHook(AssetsTweakData, "init", self._config.id .. "AddAssetsData", callback(self, self, "AddAssetsDataToTweak"))
        end
    end
end

BeardLib:RegisterModule(LevelModule.type_name, LevelModule)

InstanceModule = InstanceModule or class(LevelModule)
InstanceModule.type_name = "instance"
InstanceModule.levels_folder = "levels/instances/mods/"
InstanceModule._loaded_packages = {}

function InstanceModule:init(core_mod, config)
    if not LevelModule.super.init(self, core_mod, config) then
        return false
    end
    self._world_path = Path:Combine(self.levels_folder, self._config.id, "world")
    BeardLib.managers.MapFramework._loaded_instances[self._world_path] = self --long ass line
    return true
end

function InstanceModule:LoadPackage(package)
    if PackageManager:package_exists(package) and not PackageManager:loaded(package) then
        PackageManager:load(package)
        table.insert(self._loaded_packages, package)
    end
end

function InstanceModule:Load()
    for _, package in pairs(self._config.packages or self._config.custom_packages) do
        self:LoadPackage(package)
    end
    InstanceModule.super.Load(self)
end

function InstanceModule:Unload()
    for _, package in pairs(self._loaded_packages) do
        if PackageManager:loaded(package) then
            PackageManager:unload(package)
        end
    end
    self._loaded_packages = nil
    if self._loaded_addfiles then
        self._loaded_addfiles:Unload()
        self._loaded_addfiles = nil
    end
    InstanceModule.super.Load(self)
end

BeardLib:RegisterModule(InstanceModule.type_name, InstanceModule)