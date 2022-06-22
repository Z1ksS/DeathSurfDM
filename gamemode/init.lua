AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "sh_load.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function SetRound(value)
	SetGlobalInt("RoundGlobal", value)
end 

function SetRoundsValue(t, value)
	SetGlobalInt(t, value)
end 

function GM:Initialize()

	self.BaseClass.Initialize( self )
	
	SetRoundsValue("Red", 0)
	SetRoundsValue("Blue", 0)
	SetRound(0)

	DS.ROUND:RoundSwitch( ROUND_WAIT )
	--WaitForPlayers()
end


function GM:Move( ply, data )
	if not IsValid( ply ) then return end
	if lp and ply != lp() then return end
	if ply:IsOnGround() or not ply:Alive() then return end
	
	local aim = data:GetMoveAngles()
	local forward, right = aim:Forward(), aim:Right()
	local fmove = data:GetForwardSpeed()
	local smove = data:GetSideSpeed()
	
	forward.z, right.z = 0,0
	forward:Normalize()
	right:Normalize()

	local wishvel = forward * fmove + right * smove
	wishvel.z = 0

	local wishspeed = wishvel:Length()
	if wishspeed > data:GetMaxSpeed() then
		wishvel = wishvel * (data:GetMaxSpeed() / wishspeed)
		wishspeed = data:GetMaxSpeed()
	end

	local wishspd = wishspeed
	wishspd = math.Clamp( wishspd, 0, 32.8 )

	local wishdir = wishvel:GetNormal()
	local current = data:GetVelocity():Dot( wishdir )

	local addspeed = wishspd - current
	if addspeed <= 0 then return end
	
	local accelspeed = 120 * FrameTime() * wishspeed
	if accelspeed > addspeed then
		accelspeed = addspeed
	end
	
	local vel = data:GetVelocity()
	vel = vel + (wishdir * accelspeed)
	
	data:SetVelocity( vel )
	return false
end

local function AutoHop( ply, data )
	if lp and ply != lp() then return end
	
	local ButtonData = data:GetButtons()
	if bit.band( ButtonData, IN_JUMP ) > 0 then
		if ply:WaterLevel() < 2 and not ply:IsOnGround() then
			data:SetButtons( bit.band( ButtonData, bit.bnot( IN_JUMP ) ) )
		end
	end
end
hook.Add( "SetupMove", "AutoHop", AutoHop )

local function StripMovements( ply, data )
	if lp and ply != lp() then return end
	
	local st = ply.Style
	if st and st > 1 and st < 4 and ply:GetMoveType() != MOVETYPE_NOCLIP then
		if ply:OnGround() then return end
		
		if st == 2 then
			data:SetSideSpeed( 0 )
		elseif st == 3 and (data:GetForwardSpeed() == 0 or data:GetSideSpeed() == 0) then
			data:SetForwardSpeed( 0 )
			data:SetSideSpeed( 0 )
		end
	end
end
hook.Add( "SetupMove", "StripIllegal", StripMovements )

local mdls = {
	[TEAM_BLUE] = {
		"models/player/ct_gign.mdl",
		"models/player/ct_sas.mdl",
		"models/player/ct_urban.mdl",
		"models//player/ct_gsg9.mdl"
	},
	[TEAM_RED] = {
		"models/player/t_guerilla.mdl",
		"models/player/t_leet.mdl",
		"models/player/t_phoenix.mdl",
		"models/player/t_arctic.mdl"
	}
}

function GM:PlayerSpawn(ply)
	if DS.ROUND:GetCurrent() == ROUND_WAIT and GetRoundAmount() < 1 then 
		ply:force_spectate_make()
	end

	ply:StripWeapons()
end 

function GM:PlayerSetHandsModel( ply, ent )
   local simplemodel = player_manager.TranslateToPlayerModelName(ply:GetModel())
   local info = player_manager.TranslatePlayerHands(simplemodel)
   if info then
      ent:SetModel(info.model)
      ent:SetSkin(info.skin)
      ent:SetBodyGroups(info.body)
   end
end