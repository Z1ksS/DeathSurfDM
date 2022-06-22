ROUND_CURRENT = -1

ROUND_TABLE = {}

function DS.ROUND:AddState( r, fOnStart, fOnThink, fOnFinish )
	ROUND_TABLE[r] = {
		OnStart = fOnStart,
		OnThink = fOnThink,
		OnFinish = fOnFinish
	}
	print("ADD" .. r)
end

function DS.ROUND:RoundThinkFunc( r )
	if not ROUND_TABLE[r] then return end

	ROUND_TABLE[r].OnThink()
end

function DS.ROUND:GetCurrent()
	return ROUND_CURRENT
end

hook.Add("Think", "ROUND_THINK", function()
	DS.ROUND:RoundThinkFunc( DS.ROUND:GetCurrent() )
end)

ROUND_WAIT = 1
ROUND_PREP = 2
ROUND_ACTIVE = 3
ROUND_OVER = 4

ROUND_TIMER = ROUND_TIMER or 0

function DS.ROUND:GetTimer() 
	return ROUND_TIMER or 0
end

timer.Create("DeathrunRoundTimerCalculate", 0.2, 0, function()
	ROUND_TIMER = ROUND_TIMER - 0.2
	if ROUND_TIMER < 0 then ROUND_TIMER = 0 end
end)

if SERVER then
	util.AddNetworkString("DeathrunSyncRoundTimer")
	util.AddNetworkString("DeathrunSendMVPs")
	function DS.ROUND:SyncTimer()
		net.Start("DeathrunSyncRoundTimer")
		net.WriteInt( DS.ROUND:GetTimer(), 16 )
		net.Broadcast()
	end
	function DS.ROUND:SyncTimerPlayer( ply )
		net.Start("DeathrunSyncRoundTimer")
		net.WriteInt( DS.ROUND:GetTimer(), 16 )
		net.Send( ply )
	end
	function DS.ROUND:SetTimer( s )
		ROUND_TIMER = s
		DS.ROUND:SyncTimer()
	end
else
	net.Receive("DeathrunSyncRoundTimer", function( len, ply )
		ROUND_TIMER = net.ReadInt( 16 )
	end)
end

local function EnoughPlayers()
    local canRun = false 

	for _, ply in pairs(player.GetAll()) do
		if IsValid(ply) and team.NumPlayers(1) >= 1 and team.NumPlayers(2) >= 1 then
			canRun = true 
		end
	end
	
    return canRun
end

DS.ROUND:AddState( ROUND_WAIT,
	function()
		print("Round State: WAITING")	
	end,
	function()
		if SERVER then
			local launched = false 

			if EnoughPlayers() and !launched then
				DS.ROUND:RoundSwitch( ROUND_PREP )

				launched = true
			end
		end
	end,
	function()
		print("Exiting: WAITING")
	end
)

DS.ROUND:AddState( ROUND_PREP,
	function()
		print("Round State: PREP")

		if SERVER then

			game.CleanUpMap()

			timer.Simple( 5, function()
				DS.ROUND:RoundSwitch( ROUND_ACTIVE )
			end)

			DS.ROUND:SetTimer( 5 )
		end 
	end,
	function()
	end,
	function()
		print("Exiting: PREP")
	end
)

DS.ROUND:AddState( ROUND_ACTIVE,
	function()
		print("Round State: ACTIVE")

		if SERVER then
			SetRound(GetRoundAmount() + 1)
			
			for _, ply in pairs(player.GetAll()) do
				if IsValid(ply) then 

					if ply:GetObserverMode() == OBS_MODE_ROAMING then 
						ply:Spectate(OBS_MODE_NONE)
					end 

					ply:Spawn()

					for i = 1, #DS.TeamConfig[ply:Team()].weaponsOnSpawn do 
						ply:Give(DS.TeamConfig[ply:Team()].weaponsOnSpawn[i])
					end 
				end
			end 

			DS.ROUND:SetTimer( 60*5 )
		end 

	end,
	function()
		if SERVER then 
			local players = player.GetAll()

			if !EnoughPlayers() then 
				for _, ply in pairs(players) do
					ply:force_spectate_make()
					--DS.ROUND:RoundSwitch( ROUND_WAIT )
				end 
			end 

			local rTeamAlive = 0
			local bTeamAlive = 0

			for k, ply in pairs( team.GetPlayers(1) ) do
				if ( ply:Alive() ) then 
					bTeamAlive = bTeamAlive + 1
				end 
			end 

			for k, ply in pairs( team.GetPlayers(2) ) do
				if ( ply:Alive() ) then 
					rTeamAlive = rTeamAlive + 1
				end 
			end

			if GetRoundAmount() < 5 and rTeamAlive == 0 or bTeamAlive == 0 then

				game.CleanUpMap(false)

				if rTeamAlive == 0 then 
					SetRoundsValue("Blue", GetRoundAmountTeam("Blue") + 1)	

					for k, v in pairs(players) do 
						if v:Team() == TEAM_BLUE then 
							RewardPlayer(v, DS.PointShopWinReward, "winning the round")
						end 

						if ( v:Alive() ) then 
							v:StripWeapons()
						end
					end 

					DS.ROUND:RoundSwitch( ROUND_WAIT )
				elseif bTeamAlive == 0 then 
					SetRoundsValue("Red", GetRoundAmountTeam("Red") + 1)

					for k, v in pairs(players) do 
						if v:Team() == TEAM_RED then 
							RewardPlayer(v, DS.PointShopWinReward, "winning the round")
						end 

						if ( v:Alive() ) then 
							v:StripWeapons()
						end 
					end 

					DS.ROUND:RoundSwitch( ROUND_WAIT )
				end
			
			end 

			--draw
			if rTeamAlive > 0 and bTeamAlive > 0 then 
				if DS.ROUND:GetTimer() <= 0 then 
				
					for _, ply in pairs(players) do
						ply:force_spectate_make()
					end 


					DS.ROUND:RoundSwitch( ROUND_WAIT )
				end 
			end 

			if GetRoundAmount() >= 5 then 
				for _, ply in pairs(players) do
					ply:Freeze(true)

					DS.ROUND:RoundSwitch( ROUND_OVER )
				end 
			end 
		end 
	end,
	function()
		print("Exiting: ACTIVE")
	end
)

DS.ROUND:AddState( ROUND_OVER,
	function()
		print("Round State: OVER")

		if SERVER then 
			timer.Simple(15, function()
				for _, ply in pairs(player.GetAll()) do
					if ( ply:Alive() ) then 
						ply:KillSilent()

						ply:force_spectate_make()
					end 
				end 

				MapVote.Start()
			end) 

			DS.ROUND:SetTimer(15)
		end
	end,
	function()
	end,
	function()
		print("Exiting round: OVER")
	end
)