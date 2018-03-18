Hooks:PostHook(CharacterTweakData, "init", "init_funspecials", function(self, ...)
	log("Configuring Special Guards :D")
	--SNIPER
		self.heavy_swat_sniper.detection = self.presets.detection.normal
		self.heavy_swat_sniper.has_alarm_pager = false
		self.heavy_swat_sniper.calls_in = true
		self.heavy_swat_sniper.suspicious = true
		self.heavy_swat_sniper.silent_priority_shout = "f42"
		self.heavy_swat_sniper.no_retreat = true
		self.heavy_swat_sniper.no_arrest = true
		self.heavy_swat_sniper.no_move_and_shoot = false
		self.heavy_swat_sniper.shooting_death = true
	--GENSEC
		self.gensec.has_alarm_pager = false
	--CLOACKER
		self.spooc.has_alarm_pager = true
		self.spooc.calls_in = true
		self.spooc.suspicious = true
		self.spooc.silent_priority_shout = "f42"
	--TANK
		self.tank_mini.HEALTH_INIT = 500 --Add HP
		self.tank_mini.ignore_medic_revive_animation = true
		self.tank_mini.damage.shield_knocked = false
		self.tank.ignore_medic_revive_animation = true
		self.tank.damage.shield_knocked = false
		self.tank_hw.ignore_medic_revive_animation = true
		self.tank_hw.damage.shield_knocked = false
		self.tank_hw.HEALTH_INIT = 500 --Add HP
		self.tank_medic.HEALTH_INIT = 1000 --Boss HP
		self.tank_mini.allowed_stances = nil --Disabling that stupid ! in stealth...
		self.tank_mini.silent_priority_shout = "f42" --It's just a voice line for marking this guy in stealth
		self.tank_mini.has_alarm_pager = true --Add pager
		self.tank_mini.calls_in = true --Ability to call police
		self.tank_mini.suspicious = true --Ability to detect Cameras and stuff like that
		self.tank_mini.weapon.mini.FALLOFF = { -- Disabling that stupic ! in stealth... (by removing autofire_rounds)
			{
				r = 100,
				acc = {0.1, 0.15},
				dmg_mul = 5,
				recoil = {2, 2},
				mode = {
					0,
					0,
					0,
					1
				},
			},
			{
				r = 500,
				acc = {0.05, 0.1},
				dmg_mul = 4,
				recoil = {1.5, 1.75},
				mode = {
					0,
					0,
					0,
					1
				},
			},
			{
				r = 1000,
				acc = {0.04, 0.075},
				dmg_mul = 3.5,
				recoil = {1.2, 1.5},
				mode = {
					0,
					0,
					0,
					1
				},
			},
			{
				r = 2000,
				acc = {0.025, 0.05},
				dmg_mul = 3,
				recoil = {0.7, 1},
				mode = {
					0,
					0,
					0,
					1
				},
			},
			{
				r = 3000,
				acc = {0.01, 0.025},
				dmg_mul = 3,
				recoil = {0.5, 0.7},
				mode = {
					0,
					0,
					0,
					1
				}
			}
		}
		self.city_swat.has_alarm_pager = false
		self.bolivian_indoors.has_alarm_pager = false
		self.tank_medic.allowed_stances = nil
		self.tank_medic.silent_priority_shout = "f42"
		self.tank_hw.allowed_stances = nil
		self.tank_hw.silent_priority_shout = "f42"
		self.tank_hw.calls_in = true
		self.tank_hw.suspicious = true
		self.tank_hw.move_speed = self.presets.move_speed.normal
		self.tank_medic.calls_in = true
		self.tank_medic.suspicious = true
	--TASER
		self.taser.has_alarm_pager = true
		self.taser.weapon.is_rifle = {
			aim_delay = {0.1, 0.1},
			focus_delay = 4,
			focus_dis = 200,
			spread = 20,
			miss_dis = 40,
			RELOAD_SPEED = 0.66,
			melee_speed = 0.5,
			melee_dmg = 10,
			melee_retry_delay = {1, 2},
			tase_distance = 1500,
			tase_sphere_cast_radius = 30,
			aim_delay_tase = {0, 0},
			range = {
				close = 1000,
				optimal = 2000,
				far = 5000
			},
			FALLOFF = {
				{
					r = 100,
					acc = {0.6, 0.9},
					dmg_mul = 3,
					recoil = {0.4, 0.7},
					mode = {
						0,
						3,
						3,
						1
					}
				},
				{
					r = 500,
					acc = {0.75, 0.95},
					dmg_mul = 2.5,
					recoil = {0.35, 0.7},
					mode = {
						0,
						3,
						3,
						1
					}
				},
				{
					r = 1000,
					acc = {0.65, 0.95},
					dmg_mul = 2,
					recoil = {0.35, 0.75},
					mode = {
						1,
						2,
						2,
						0
					}
				},
				{
					r = 2000,
					acc = {0.65, 0.8},
					dmg_mul = 1.25,
					recoil = {0.4, 1.2},
					mode = {
						3,
						2,
						2,
						0
					}
				},
				{
					r = 3000,
					acc = {0.45, 0.6},
					dmg_mul = 1,
					recoil = {1.5, 3},
					mode = {
						3,
						1,
						1,
						0
					}
				}
			}
		}
		self.taser.silent_priority_shout = "f42"
		self.taser.calls_in = true
		self.taser.suspicious = true
	--MEDIC
		self.medic.has_alarm_pager = true
		self.medic.silent_priority_shout = "f42"
		self.medic.calls_in = true
		self.medic.suspicious = true
	--SHIELDS
		self.shield.move_speed = self.presets.move_speed.normal
		self.shield.silent_priority_shout = "f42"
		self.shield.calls_in = true
		self.shield.suspicious = true
		self.shield.allowed_stances = nil
		self.shield.no_equip_anim = false
	--MURKY WATER
		self.security.has_alarm_pager = false
end)