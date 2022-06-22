include("sh_round.lua")

function DS.ROUND:RoundSwitch( r )
	local old = ROUND_CURRENT
	local new = r

	if (not ROUND_TABLE[new]) then return end
	
	if (ROUND_TABLE[old]) then
		ROUND_TABLE[old].OnFinish()
	end
	ROUND_TABLE[new].OnStart()

	ROUND_CURRENT = new

	net.Start("DS:RoundState")
		net.WriteInt( new, 16 )
	net.Broadcast()
end

hook.Add("PlayerInitialSpawn", "RoundSyncCurrent", function(ply)
	net.Start("DS:RoundState")
		net.WriteInt( DS.ROUND:GetCurrent(), 16 )
	net.Send( ply )
end)

hook.Add( "PlayerDeath", "DSDeathCheck", function( victim, inflictor, attacker )
	if DS.ROUND:GetCurrent() == ROUND_ACTIVE then
		victim:force_spectate_make() 
	end
end)

hook.Add("PlayerDeathThink", "DSDeathThink", function(ply)
	if DS.ROUND:GetCurrent() == ROUND_ACTIVE and !ply:Alive() or ply:GetObserverMode() == OBS_MODE_ROAMING then 
		return false
	end
end)