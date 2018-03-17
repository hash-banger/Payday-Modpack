_G.Official_ModShop = _G.Official_ModShop or {}
Official_ModShop.CostRegular = 6
Official_ModShop.MaskPricing = {
	["default"] = Official_ModShop.CostRegular+1,
	["dlc"] = Official_ModShop.CostRegular+1,
	["normal"] = Official_ModShop.CostRegular+1,
	["pd2_clan"] = Official_ModShop.CostRegular+2,
	["halloween"] = Official_ModShop.CostRegular+3,
	["infamous"] = Official_ModShop.CostRegular+14,
	["infamy"] = Official_ModShop.CostRegular+14
}

Hooks:Add("LocalizationManagerPostInit", "Coin4Buy_loc", function(loc)
	LocalizationManager:add_localized_strings({
		["official_gms_purchase"] = "Buy with Coins",
		["official_gms_title"] = "Official Gage Shop"
	})
end)

function BlackMarketGui:_buy_mask_coins_callback(data)
	self._item_bought = true
	data.money = data.money or Official_ModShop.CostRegular
	managers.custom_safehouse:deduct_coins(data.money)
	managers.menu_component:post_event("item_buy")
	managers.blackmarket:on_buy_mask_to_inventory(data.name, data.global_value, data.slot, nil)
	managers.menu:back(true, math.max(data.num_backs - 1, 0))
end

function BlackMarketGui:_buy_mask_part_coins_callback(data)
	self._item_bought = true
	data.money = data.money or Official_ModShop.CostRegular
	managers.custom_safehouse:deduct_coins(data.money)
	managers.menu_component:post_event("item_buy")
	local converted_category = data.category == "color" and "colors" or data.category == "material" and "materials" or data.category == "pattern" and "textures" or data.category
	managers.blackmarket:add_to_inventory(data.global_value, converted_category, data.name, true)
	self:reload()
	QuickMenu:new(managers.localization:text("official_gms_title"), "You successfully buy '".. data.name_localized .."', please reenter here to see your stuff.", {}):Show()
end

Hooks:PostHook(BlackMarketGui, "_setup", "BlackMarketGUIPostSetup_Coin4Buy", function(gui, ...)
	gui.official_modshop_purchase_weaponmod_callback = function(self, data)
		log("official_modshop_purchase_weaponmod_callback")
	end
	gui.official_modshop_purchase_mask_callback = function(self, data)
		local params = {}
		local cost = Official_ModShop.MaskPricing[data.global_value] or Official_ModShop.CostRegular
		if cost > managers.custom_safehouse:coins() then
			QuickMenu:new(managers.localization:text("official_gms_title"), "You don't have enough coins. (Require: ".. cost .. ")", {}):Show()
			return
		end
		params.name = data.name_localized or data.name
		params.money = cost
		data.money = cost
		params.category = data.category
		params.slot = data.slot
		params.weapon = data.name
		params.yes_func = callback(self, self, "_dialog_yes", callback(self, self, "_buy_mask_coins_callback", data))
		params.no_func = callback(self, self, "_dialog_no")
		managers.menu:show_confirm_blackmarket_weapon_mod_purchase(params)
	end
	gui.official_modshop_purchase_mask_part_callback = function(self, data)
		local params = {}
		local cost = Official_ModShop.MaskPricing[data.global_value] or Official_ModShop.CostRegular
		if cost > managers.custom_safehouse:coins() then
			QuickMenu:new(managers.localization:text("official_gms_title"), "You don't have enough coins. (Require: ".. cost .. ")", {}):Show()
			return
		end
		params.name = data.name_localized or data.name
		params.money = cost
		data.money = cost
		params.category = data.category
		params.slot = data.slot
		params.weapon = data.name
		params.yes_func = callback(self, self, "_dialog_yes", callback(self, self, "_buy_mask_part_coins_callback", data))
		params.no_func = callback(self, self, "_dialog_no")
		managers.menu:show_confirm_blackmarket_weapon_mod_purchase(params)
	end
	local wm_modshop = {
		prio = 1,
		btn = "BTN_A",
		pc_btn = nil,
		name = "official_gms_purchase",
		callback = callback(gui, gui, "official_modshop_purchase_weaponmod_callback")
	}
	local bm_modshop = {
		prio = 1,
		btn = "BTN_A",
		pc_btn = nil,
		name = "official_gms_purchase",
		callback = callback(gui, gui, "official_modshop_purchase_mask_callback")
	}
	local mp_modshop = {
		prio = 1,
		btn = "BTN_A",
		pc_btn = nil,
		name = "official_gms_purchase",
		callback = callback(gui, gui, "official_modshop_purchase_mask_part_callback")
	}
	local btn_x = 10
	gui._btns["wm_modshop"] = BlackMarketGuiButtonItem:new(gui._buttons, wm_modshop, btn_x)
	gui._btns["bm_modshop"] = BlackMarketGuiButtonItem:new(gui._buttons, bm_modshop, btn_x)
	gui._btns["mp_modshop"] = BlackMarketGuiButtonItem:new(gui._buttons, mp_modshop, btn_x)
end)

function Is_This_Unlock(data)
	if not data then
		return false
	end
	if data["lock_texture"] then
		local _ss = tostring(data["lock_texture"])
		if _ss:find("lock_skill") or _ss:find("lock_dlc") or _ss:find("lock_level") or _ss:find("lock_community") or _ss:find("money_lock") or _ss:find("lock_infamy") then
			return false
		end
	end
	for k, v in pairs( tweak_data.dlc ) do
		if v.achievement_id ~= nil and v.content ~= nil and v.content.loot_drops ~= nil then
			for i, loot in pairs( v.content.loot_drops ) do
				if loot.item_entry ~= nil and loot.item_entry == data.name and loot.type_items == data.category then
					if not managers.achievment.handler:has_achievement(v.achievement_id) then
						local achievement_tracker = tweak_data.achievement[ data.weapon_part and "weapon_part_tracker" or "mask_tracker" ]
						local achievement_progress = achievement_tracker[data.name]
						if achievement_progress then
							return false
						end
						if not data.weapon_part then
							return false
						end
					end
				end
			end
		end
	end
	if data["global_value"] and tweak_data.dlc[data["global_value"]] and not managers.dlc:is_dlc_unlocked(data["global_value"]) then
		return false
	end
	return true
end

Hooks:PostHook(BlackMarketGui, "populate_mods", "OfficialGageShop_BlackMarketGui_populate_mods", function(gui, data)
	for k, v in pairs(data) do
		if data[k] and type(v) == "table" and v["unlocked"] then
			local _vv = tostring(json.encode({v = v}))
			local _weapon_mod_tweak = tweak_data.weapon.factory.parts[v.name]
			if _weapon_mod_tweak and _weapon_mod_tweak.type == "bonus" and 
				_vv:find("wm_preview") and not _vv:find("wm_buy_mod") and 
				Is_This_Unlock(v) then
				table.insert(data[k], "wm_buy_mod")
			end
		end
	end
end)

Hooks:PostHook(BlackMarketGui, "populate_buy_mask", "OfficialGageShop_BlackMarketGui_populate_buy_mask", function(gui, data)
	for k, v in pairs(data) do
		if data[k] and type(v) == "table" and v["unlocked"] then
			if tostring(json.encode({v = v})):find("bm_preview") and Is_This_Unlock(v) then
				table.insert(data[k], "bm_modshop")
				data[k].mid_text = nil
				data[k].lock_texture = nil
			end
		end
	end
end)

Hooks:PostHook(BlackMarketGui, "populate_choose_mask_mod", "OfficialGageShop_BlackMarketGui_populate_choose_mask_mod", function(gui, data)
	for k, v in pairs(data) do
		if data[k] and type(v) == "table" and v["unlocked"] then
			if tostring(json.encode({v = v})):find("mp_preview") and Is_This_Unlock(v) then
				table.insert(data[k], "mp_modshop")
			end
		end
	end
end)