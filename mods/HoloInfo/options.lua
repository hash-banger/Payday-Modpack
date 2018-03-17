_G.HoloInfo = _G.HoloInfo or {}
HoloInfo.mod_path = ModPath
HoloInfo._data_path = SavePath .. "HoloInfo_savefile.txt"
HoloInfo.options = {} 
HoloInfo.options_menu = "HoloInfoOptions"

function HoloInfo:Save()
	local file = io.open( self._data_path, "w+" )
	if file then
		file:write( json.encode( self.options ) )
		file:close()
	end
end
function HoloInfo:Load()
	local file = io.open( self._data_path, "r" )
	if file then
		self.options = json.decode( file:read("*all") )
		file:close()
	end
end
function HoloInfo:clone( class )
    class.old = clone(class)
end
function HoloInfo:update()
    HoloInfoAlpha = HoloInfo.options.MainAlpha 
    Infotimer_enable = HoloInfo.options.Infotimer_enable
    enemies_enable = HoloInfo.options.enemies_enable --
    hostages_enable = HoloInfo.options.hostages_enable 
    civis_enable = HoloInfo.options.civis_enable --
	bodybags_enable = HoloInfo.options.bodybags_enable
	jokers_enable = HoloInfo.options.jokers_enable
	dominated_enable = HoloInfo.options.dominated_enable
    InfoTimers_max = HoloInfo.options.Infotimer_max 
    InfoTimers_size = HoloInfo.options.Infotimer_size
    InfoTimers_bg_color = HoloInfo.colors[HoloInfo.options.Infotimer_color].color
    InfoTimers_bg_jammed_color = HoloInfo.colors[HoloInfo.options.Infojammed_color].color
    InfoTimers_text_color = HoloInfo.textcolors[HoloInfo.options.Infotimer_text_color] 
    Infobox_text_color = HoloInfo.textcolors[HoloInfo.options.Infobox_text_color] 
    civis_bg_color = HoloInfo.colors[HoloInfo.options.civis_bg_color].color 
    enemies_bg_color = HoloInfo.colors[HoloInfo.options.enemies_bg_color].color 
    pagers_bg_color = HoloInfo.colors[HoloInfo.options.pagers_bg_color].color 
    Hostage_color = HoloInfo.colors[HoloInfo.options.hostagebox_color].color
	--bodybags_bg_color = HoloInfo.colors[HoloInfo.options.bodybags_bg_color].color
	if HoloInfo._hudinfo then
		HoloInfo._hudinfo:update_infos()
	end
end
HoloInfoTextColors = {
    "HoloInfocolorWhite", 
    "HoloInfocolorBlack",  
}

if not HoloInfo.setup then
	HoloInfo.colors = { --You can add new ones 
		{color = Color(0.2, 0.6 ,1 ), menu_name = "Blue"},	  	 
		{color = Color(1,0.6 ,0 ), menu_name = "Orange"},
		{color = Color(0, 1, 0.1), menu_name = "Green"},	
		{color = Color(1, 0.25, 0.7), menu_name = "Pink"},				 
		{color = Color(0, 0, 0), menu_name = "Black"},		 		 
		{color = Color(0.15, 0.15, 0.15), menu_name = "Grey"},
		{color = Color(0.1, 0.1, 0.35), menu_name = "DarkBlue"},	
		{color = Color(1, 0.1, 0), menu_name = "Red"},	
		{color = Color(1, 0.8, 0.2), menu_name = "Yellow"},	
		{color = Color(1, 1, 1), menu_name = "White"},
		{color = Color(0, 1, 0.9), menu_name = "Cyan"},
		{color = Color(0.5, 0, 1), menu_name = "Purple"},
		{color = Color(0, 0.9, 0.5), menu_name = "SpringGreen"},
		{color = Color(0.6,0.8,0.85), menu_name = "Light Blue"},
		{color = Color(1, 0, 0.2), menu_name = "Crimson"},
		{color = Color(0.5,82,45), menu_name = "Brown"},
		{color = Color(0.7, 0.9, 0), menu_name = "Lime"}, 
	}
	HoloInfo.textcolors = {
		Color.white,	
		Color.black,	  	 	  
	} 
    HoloInfo:Load()
    HoloInfo.options.Defaults = {
        Infotimer_enable = true,
        ECMtimer_enable = true,
        Drilltimer_enable = true,
        Digitaltimer_enable = true,
        gagepacks_enable = false,
        Infotimer_color = 1,
        Infojammed_color = 8,
        Infotimer_text_color = 2,
        civis_bg_color = 1,
        hostages_enable = true,
        enemies_bg_color = 9,
        Infobox_text_color = 2,
        Infotimer_size = 48,
        Infotimer_max = 5,
        civis_enable = true,
        pagers_enable = true,
        gagepacks_bg_color = 1,
        pagers_bg_color = 1,
        enemies_enable = true,
        info_ypos = 90,
        info_xpos = 1235,
        Infobox_max = 3,
        hostagebox_color = 1,
        Frame_style = 1,
        MainAlpha = 0.8,
        truetime = false,
		bodybags_enable = true,
		--bodybags_bg_color = 1,
		jokers_enable = true,
		dominated_enable = true,
    }
    for option, value in pairs(HoloInfo.options.Defaults) do
        if HoloInfo.options[option] == nil then
            HoloInfo.options[option] = value
        end
    end
    HoloInfo:Load()
    HoloInfoAlpha = HoloInfo.options.MainAlpha 
    Infotimer_enable = HoloInfo.options.Infotimer_enable
    enemies_enable = HoloInfo.options.enemies_enable --
    hostages_enable = HoloInfo.options.hostages_enable 
    civis_enable = HoloInfo.options.civis_enable --
    InfoTimers_max = HoloInfo.options.Infotimer_max 
    InfoTimers_size = HoloInfo.options.Infotimer_size
    InfoTimers_bg_color = HoloInfo.colors[HoloInfo.options.Infotimer_color].color
    InfoTimers_bg_jammed_color = HoloInfo.colors[HoloInfo.options.Infojammed_color].color
    InfoTimers_text_color = HoloInfo.textcolors[HoloInfo.options.Infotimer_text_color] 
    Infobox_text_color = HoloInfo.textcolors[HoloInfo.options.Infobox_text_color] 
    civis_bg_color = HoloInfo.colors[HoloInfo.options.civis_bg_color].color 
    enemies_bg_color = HoloInfo.colors[HoloInfo.options.enemies_bg_color].color 
	pagers_bg_color = HoloInfo.colors[HoloInfo.options.pagers_bg_color].color 
    Hostage_color = HoloInfo.colors[HoloInfo.options.hostagebox_color].color
    gagepacks_bg_color = HoloInfo.colors[HoloInfo.options.gagepacks_bg_color].color
    bodybags_enable = HoloInfo.options.bodybags_enable
    --bodybags_bg_color = HoloInfo.colors[HoloInfo.options.bodybags_bg_color].color
	jokers_enable = HoloInfo.options.jokers_enable
	dominated_enable = HoloInfo.options.dominated_enable
	HoloInfo.setup = true
end
local HoloInfoColors = {}
Hooks:Add("LocalizationManagerPostInit", "HoloInfo_loc", function(loc)
 	loc:load_localization_file( "mods/HoloInfo/EN.txt")	
	for k, v in pairs(HoloInfo.colors) do
		LocalizationManager:add_localized_strings({
			["HoloInfocolor"..v.menu_name] = v.menu_name,
		})  	  
	  	table.insert(HoloInfoColors, "HoloInfocolor"..v.menu_name)
  	end
end)
 
Hooks:Add("MenuManagerSetupCustomMenus", "HoloInfoOptions", function( menu_manager, nodes )
	MenuHelper:NewMenu( HoloInfo.options_menu )
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "HoloInfoOptions", function( menu_manager, nodes )
	MenuCallbackHandler.HoloInfo_toggle = function(self, item)
		HoloInfo.options[item._parameters.name] = (item:value() == "on" and true or false)
		HoloInfo:Save()
		HoloInfo:update()
    end
    MenuCallbackHandler.HoloInfo_value = function(self, item)
		HoloInfo.options[item._parameters.name] = item:value()
		HoloInfo:Save()			
		HoloInfo:update()
    end    
    MenuCallbackHandler.resetinfo = function(self, item)
        for option, value in pairs(HoloInfo.options.Defaults) do
            MenuHelper:ResetItemsToDefaultValue( item, {[option] = true}, value)
        end		
    end
    MenuHelper:AddToggle({
        id =  "enemies_enable",
        title =  "enemies_enable_title",
        desc = "enemies_enable_desc",
        menu_id = HoloInfo.options_menu,
        value = HoloInfo.options.enemies_enable,
        callback = "HoloInfo_toggle",
        priority = 99,
    })             
    MenuHelper:AddToggle({
        id =  "civis_enable",
        title =  "civis_enable_title",
        desc = "civis_enable_desc",
        menu_id = HoloInfo.options_menu,
        value = HoloInfo.options.civis_enable,
        callback = "HoloInfo_toggle",
        priority = 98,
    })       
    MenuHelper:AddToggle({
        id =  "hostages_enable",
        title =  "hostages_enable_title",
        desc = "hostages_enable_desc",
        menu_id = HoloInfo.options_menu,
        value = HoloInfo.options.hostages_enable,
        callback = "HoloInfo_toggle",
        priority = 97,
    })       
    MenuHelper:AddToggle({
        id =  "Infotimer_enable",
        title =  "Infotimer_enable_title",
        desc = "Infotimer_enable_desc",
        menu_id = HoloInfo.options_menu,
        value = HoloInfo.options.Infotimer_enable,
        callback = "HoloInfo_toggle",
        priority = 96,
    })        
    MenuHelper:AddToggle({
        id =  "Drilltimer_enable",
        title =  "Drilltimer_enable_title",
        desc = "Drilltimer_enable_desc",
        menu_id = HoloInfo.options_menu,
        value = HoloInfo.options.Drilltimer_enable,
        callback = "HoloInfo_toggle",
        localize = true,
        priority = 95,
    })       
    MenuHelper:AddToggle({
        id =  "ECMtimer_enable",
        title =  "ECMtimer_enable_title",
        desc = "ECMtimer_enable_desc",
        menu_id = HoloInfo.options_menu,
        value = HoloInfo.options.ECMtimer_enable,
        callback = "HoloInfo_toggle",
        priority = 94,
    })   
    MenuHelper:AddToggle({
        id =  "Digitaltimer_enable",
        title =  "Digitaltimer_enable_title",
        desc = "Digitaltimer_enable_desc",
        menu_id = HoloInfo.options_menu,
        value = HoloInfo.options.Digitaltimer_enable,
        callback = "HoloInfo_toggle",
        priority = 93,
    })        
    MenuHelper:AddToggle({
        id =  "pagers_enable",
        title =  "pagers_enable_title",
        desc = "pagers_enable_desc",
        menu_id = HoloInfo.options_menu,
        value = HoloInfo.options.pagers_enable,
        callback = "HoloInfo_toggle",
        priority = 92,
    })        
    MenuHelper:AddToggle({
        id =  "gagepacks_enable",
        title =  "gagepacks_enable_title",
        desc = "gagepacks_enable_desc",
        menu_id = HoloInfo.options_menu,
        value = HoloInfo.options.gagepacks_enable,
        callback = "HoloInfo_toggle",
        priority = 92,
    })    
	MenuHelper:AddToggle({
		id =  "bodybags_enable",
		title =  "bodybags_enable_title",
		desc = "bodybags_enable_desc",
		menu_id = HoloInfo.options_menu,
		value = HoloInfo.options.bodybags_enable,
		callback = "HoloInfo_toggle",
		priority = 92,
	})     
	MenuHelper:AddToggle({
		id =  "jokers_enable",
		title =  "jokers_enable_title",
		desc = "jokers_enable_desc",
		menu_id = HoloInfo.options_menu,
		value = HoloInfo.options.jokers_enable,
		callback = "HoloInfo_toggle",
		priority = 92,
	})     
	MenuHelper:AddToggle({
		id =  "dominated_enable",
		title =  "dominated_enable_title",
		desc = "dominated_enable_desc",
		menu_id = HoloInfo.options_menu,
		value = HoloInfo.options.dominated_enable,
		callback = "HoloInfo_toggle",
		priority = 92,
	})     
    MenuHelper:AddToggle({
        id =  "truetime",
        title =  "truetime_title",
        desc = "truetime_desc",
        menu_id = HoloInfo.options_menu,
        value = HoloInfo.options.truetime,
        callback = "HoloInfo_toggle",
        priority = 91,
    })      
    MenuHelper:AddDivider({
        id = "choicetoggle_divider",
        size = 16,
        menu_id = HoloInfo.options_menu,
        priority = 90,
    }) 
   	MenuHelper:AddMultipleChoice({
        id =  "Infotimer_text_color",
        title =  "Infotimer_text_color_title",
        desc = "Infotimer_text_color_desc",
		menu_id = HoloInfo.options_menu,
        value = HoloInfo.options.Infotimer_text_color,
		callback = "HoloInfo_value",
        items = HoloInfoTextColors,
        priority = 89,
    })          
    MenuHelper:AddMultipleChoice({
        id =  "Infobox_text_color",
        title =  "Infobox_text_color_title",
        desc = "Infobox_text_color_desc",
		menu_id = HoloInfo.options_menu,
        value = HoloInfo.options.Infobox_text_color,
		callback = "HoloInfo_value",
        items = HoloInfoTextColors,
        priority = 88,
    })              
    MenuHelper:AddMultipleChoice({
        id =  "Infotimer_color",
		menu_id = HoloInfo.options_menu,
        title =  "Infotimer_color_title",
        desc = "Infotimer_color_desc",
        value = HoloInfo.options.Infotimer_color,
		callback = "HoloInfo_value",
        items = HoloInfoColors,
        priority = 87,
    })       
    MenuHelper:AddMultipleChoice({
        id =  "Infojammed_color",
        title =  "Infojammed_color_title",
        desc = "Infojammed_color_desc",
		menu_id = HoloInfo.options_menu,
        value = HoloInfo.options.Infojammed_color,
		callback = "HoloInfo_value",
        items = HoloInfoColors,
        priority = 86,
    })       
    MenuHelper:AddMultipleChoice({
        id =  "enemies_bg_color",
        title =  "enemies_bg_color_title",
        desc = "enemies_bg_color_desc",
		menu_id = HoloInfo.options_menu,
        value = HoloInfo.options.enemies_bg_color,
		callback = "HoloInfo_value",
        items = HoloInfoColors,
        priority = 85,
    })         
    MenuHelper:AddMultipleChoice({
        id =  "civis_bg_color",
        title =  "civis_bg_color_title",
        desc = "civis_bg_color_desc",
        menu_id = HoloInfo.options_menu,
        value = HoloInfo.options.civis_bg_color,
        callback = "HoloInfo_value",
        items = HoloInfoColors,
        priority = 84,
    })      
    MenuHelper:AddMultipleChoice({
        id =  "hostagebox_color",
        title =  "hostagebox_color_title",
        desc = "hostagebox_color_desc",
		menu_id = HoloInfo.options_menu,
        value = HoloInfo.options.hostagebox_color,
		callback = "HoloInfo_value",
        items = HoloInfoColors,
        priority = 84,
    })           
    MenuHelper:AddMultipleChoice({
        id =  "pagers_bg_color",
        title =  "pagers_bg_color_title",
        desc = "pagers_bg_color_desc",
        menu_id = HoloInfo.options_menu,
        value = HoloInfo.options.pagers_bg_color,
        callback = "HoloInfo_value",
        items = HoloInfoColors,
        priority = 83,
    })             
    MenuHelper:AddMultipleChoice({
        id =  "gagepacks_bg_color",
        title =  "gagepacks_bg_color_title",
        desc = "gagepacks_bg_color_desc",
        menu_id = HoloInfo.options_menu,
        value = HoloInfo.options.gagepacks_bg_color,
        callback = "HoloInfo_value",
        items = HoloInfoColors,
        priority = 82,
    })   
	--[[
	MenuHelper:AddMultipleChoice({
		id =  "bodybags_bg_color",
		title =  "bodybags_bg_color_title",
		desc = "bodybags_bg_color_desc",
		menu_id = HoloInfo.options_menu,
		value = HoloInfo.options.bodybags_bg_color,
		callback = "HoloInfo_value",
		items = HoloInfoColors,
		priority = 82,
	})
]]	
    local data = {type = "MenuItemMultiChoice"} 
    for k, v in ipairs({"Normal", "Underline","Sideline", "Upperline","Fullframe"}) do 
        table.insert( data, { _meta = "option", localize = false ,text_id = v, value = k } ) 
    end
    local params = {
        name = "Frame_style",
        text_id = "Frame_style_title",
        help_id = "Frame_style_desc",
        callback = "HoloInfo_value",
        filter = true,
        localize = true,
    }
    local menu = MenuHelper:GetMenu( HoloInfo.options_menu )
    local item = menu:create_item(data, params)
    item._priority = 82 
    item:set_value( HoloInfo.options.Frame_style or 1 )
    table.insert( menu._items_list, item )

    local data = {type = "MenuItemMultiChoice"} 
    for k, v in ipairs({1,2,3,4,5,6,7,8,9,10}) do 
        table.insert( data, { _meta = "option", localize = false ,text_id = v, value = k } ) 
    end
    local params = {
        name = "Infotimer_max",
        text_id = "Infotimer_max_title",
        help_id = "Infotimer_max_desc",
        callback = "HoloInfo_value",
        filter = true,
        localize = true,
    }
    local menu = MenuHelper:GetMenu( HoloInfo.options_menu )
    local item = menu:create_item(data, params)
    item._priority = 81
    item:set_value( HoloInfo.options.Infotimer_max or 1 )
    table.insert( menu._items_list, item )

    local data = {type = "MenuItemMultiChoice"} 
    for k, v in ipairs({1,2,3,4,5,6,7,8,9,10}) do 
        table.insert( data, { _meta = "option", localize = false ,text_id = v, value = k } ) 
    end
    local params = {
        name = "Infobox_max",
        text_id = "Infobox_max_title",
        help_id = "Infobox_max_desc",
        callback = "HoloInfo_value",
        filter = true,
        localize = true,
    }
    local menu = MenuHelper:GetMenu( HoloInfo.options_menu )
    local item = menu:create_item(data, params)
    item._priority = 80
    item:set_value( HoloInfo.options.Infobox_max or 1 )
    table.insert( menu._items_list, item )
    MenuHelper:AddDivider({
        id = "sliderchoice_divider",
        size = 16,
        menu_id = HoloInfo.options_menu,
        priority = 79,
    })  
    MenuHelper:AddSlider({
        id =  "MainAlpha",
        title =  "HoloInfo_alpha_title",
        desc = "HoloInfo_alpha_desc",
        menu_id = HoloInfo.options_menu,
        show_value = true,
        value = HoloInfo.options.MainAlpha,
        callback = "HoloInfo_value",
        min = 0,
        max = 1,
        priority = 78,
    })      
    MenuHelper:AddSlider({
        id =  "Infotimer_size",
        title =  "Infotimer_size_title",
        desc = "Infotimer_size_desc",
		menu_id = HoloInfo.options_menu,
        value = HoloInfo.options.Infotimer_size,
        show_value = true,        
		callback = "HoloInfo_value",
        min = 24,
        max = 128,
        priority = 77,
    })         
    MenuHelper:AddSlider({
        id =  "info_xpos",
        title =  "info_xpos_title",
        desc = "info_xpos_desc",
		menu_id = HoloInfo.options_menu,
        value = HoloInfo.options.info_xpos,
        show_value = true,
		callback = "HoloInfo_value",
        min = 0,
        max = 1500,
        priority = 76,
    })      
    MenuHelper:AddSlider({
        id =  "info_ypos",
        title =  "info_ypos_title",
        desc = "info_ypos_desc",
		menu_id = HoloInfo.options_menu,
        value = HoloInfo.options.info_ypos,
        show_value = true,
		callback = "HoloInfo_value",
        min = 0,
        max = 1500,
        priority = 75,
    })     
    MenuHelper:AddDivider({
        id = "buttonslider_divider",
        size = 16,
        menu_id = HoloInfo.options_menu,
        priority = 74,
    })   
	MenuHelper:AddButton({
        id =  "resetinfo",
        title =  "resetinfo_title",
        desc = "resetinfo_desc",
		menu_id = HoloInfo.options_menu,
        callback = "resetinfo", 
        priority = 0,
    })   
end)

Hooks:Add("MenuManagerBuildCustomMenus", "HoloInfoOptions", function(menu_manager, nodes)
	nodes[HoloInfo.options_menu] = MenuHelper:BuildMenu( HoloInfo.options_menu)
	MenuHelper:AddMenuItem( nodes["blt_options"], HoloInfo.options_menu, "HoloInfo_options_title", "HoloInfo_options_desc", 1 )
end)
