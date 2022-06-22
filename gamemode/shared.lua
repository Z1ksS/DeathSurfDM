DS = DS or {}
DS.ROUND = DS.ROUND or {}

MapVote = {}

GM.Name 	= "DeathSurf"
GM.Author 	= "Z1ks"
GM.Email 	= ""
GM.Website 	= ""

--Teams
TEAM_BLUE = 1
TEAM_RED = 2
TEAM_SPEC = 3

include( "sh_load.lua" )

include("cfg.lua")

AddCSLuaFile("cfg.lua")

Loader.Load( "libraries" )
Loader.Load( "core" )


function GetRoundAmount()
	return GetGlobalInt("RoundGlobal")
end 

function GetRoundAmountTeam(t)
	return GetGlobalInt(t)
end 

function GM:CreateTeams()

	team.SetUp( TEAM_BLUE, DS.TeamConfig[TEAM_BLUE].team_name, DS.TeamConfig[TEAM_BLUE].team_color )
	team.SetSpawnPoint( TEAM_BLUE, "info_player_counterterrorist" )
	team.SetClass( TEAM_Blue, { "player_surf_dm" } )

	team.SetUp( TEAM_RED, DS.TeamConfig[TEAM_RED].team_name, DS.TeamConfig[TEAM_RED].team_color )
	team.SetSpawnPoint( TEAM_RED, "info_player_terrorist" )
	team.SetClass( TEAM_RED, { "player_surf_dm" } )
end 
