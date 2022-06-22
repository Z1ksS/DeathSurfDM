function OnSpawnMenuSend(ply)
    net.Start("DS:OpenMenuTeamOnSpawn")
        net.WriteBool(false)
    net.Send(ply)
end 

hook.Add("PlayerInitialSpawn", "OpenPlayerMenuTeam", OnSpawnMenuSend)

local mdls = {
	[TEAM_BLUE] = {
		"models/player/gasmask.mdl",
		"models/player/riot.mdl",
		"models/player/urban.mdl",
		"models//player/swat.mdl"
	},
	[TEAM_RED] = {
		"models/player/guerilla.mdl",
		"models/player/leet.mdl",
		"models/player/phoenix.mdl",
		"models/player/arctic.mdl"
	}
}

net.Receive("DS:TeamSelected", function(len, ply)
    if !IsValid(ply) then return end 

    local tId = net.ReadInt(3)

    net.Start("DS:TeamAnswer")
        net.WriteBool(true)
    net.Send(ply) 

    if DS.ROUND:GetCurrent() == ROUND_WAIT or DS.ROUND:GetCurrent() == ROUND_PREP or DS.ROUND:GetCurrent() == ROUND_ACTIVE then 
        ply:force_spectate_make()
    end 

    ply:SetTeam(tId)
    ply:SetModel(mdls[tId][math.random(1,#mdls[tId])])

    ply.Opened = false
end )