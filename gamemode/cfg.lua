DS.TeamConfig = {
    [TEAM_RED] = {
		team_color = Color(255, 0, 0),
		team_name = "Terrorists",
		weaponsOnSpawn = {
			"weapon_ak47",
			"weapon_glock",
		}
	},
    [TEAM_BLUE] = {
		team_color = Color(0, 0, 255),
		team_name = "Counter Terrorists",
		weaponsOnSpawn = {
			"weapon_m4a1",
			"weapon_usp",
		}
	}
}

DS.PointShopKillReward = 10 --how many points will player receive after he kills somebody
DS.PointShopWinReward = 15 --how many points will player receive after his team wins round