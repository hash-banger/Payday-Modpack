PrePlanningTweakData.funbank_init = PrePlanningTweakData.init;
PrePlanningTweakData.funbank_create_locations = PrePlanningTweakData._create_locations;

function PrePlanningTweakData:_create_locations(tweak_data)

	PrePlanningTweakData:funbank_create_locations(tweak_data)

	self.plans = {}
	self.plans.vault_plan = {}
	self.plans.vault_plan.category = "vault_plan"

	self.gui = {}
	self.gui.custom_icons_path = "guis/dlcs/big_bank/textures/pd2/pre_planning/preplan_icon_types"
	self.gui.type_icons_path = "guis/dlcs/big_bank/textures/pd2/pre_planning/preplan_icon_types"
	self.gui.category_icons_path = "guis/dlcs/big_bank/textures/pd2/pre_planning/preplan_icon_frames"
	self.gui.category_icons_bg = 42
	self.gui.MAX_DRAW_POINTS = 1000

	self.categories.vault_plan = {}
	self.categories.vault_plan.name_id = "menu_pp_cat_vault_plan"
	self.categories.vault_plan.desc_id = "menu_pp_cat_vault_plan_desc"
	self.categories.vault_plan.plan = "vault_plan"
	self.categories.vault_plan.icon = 11
	self.categories.vault_plan.prio = 2

	self.types = {}
	self.types.branchbank_lance = {}
	self.types.branchbank_lance.name_id = "menu_pp_branchbank_lance"
	self.types.branchbank_lance.desc_id = "menu_pp_branchbank_lance_desc"
	self.types.branchbank_lance.plan = "vault_plan"
	self.types.branchbank_lance.pos_not_important = false
	self.types.branchbank_lance.category = "vault_plan"
	self.types.branchbank_lance.icon = 12
	self.types.branchbank_lance.total = 1
	self.types.branchbank_lance.cost = 0
	self.types.branchbank_lance.budget_cost = 0
	self.types.branchbank_lance.post_event = "gus_preplan_17"
	self.types.branchbank_lance.prio = 5

end
function PrePlanningTweakData:_create_locations(tweak_data)

	PrePlanningTweakData:funbank_create_locations(tweak_data)

	self.locations.funbank = {
		default_plans = {
			vault_plan = "branchbank_lance"
		},
		total_budget = 8,
		mission_briefing_texture = "guis/textures/pd2/pre_planning/mission_briefing_big",
		start_location = {
			group = "a",
			x = 512,
			y = 512,
			zoom = 1
		},
		{
			name_id = "menu_pp_branchbank_loc_a",
			texture = "guis/textures/pd2/pre_planning/branchbank_1",
			map_x = -0.6,
			map_y = 0,
			map_size = 1,
			x1 = -3500,
			y1 = -300,
			x2 = 500,
			y2 = 3700,
			rotation = 0,
			custom_points = {}
		},
		{
			name_id = "menu_pp_branchbank_loc_b",
			texture = "guis/textures/pd2/pre_planning/branchbank_2",
			map_x = 0.6,
			map_y = 0,
			map_size = 1,
			x1 = -5500,
			y1 = -3200,
			x2 = 2500,
			y2 = 4800,
			rotation = 0,
			custom_points = {}
		}
	}
end