DEFINE_BASECLASS( "player_default" )

local PLAYER = {}

PLAYER.DisplayName			= "SurfDM"
PLAYER.WalkSpeed			= 250
PLAYER.RunSpeed				= 275
PLAYER.MaxHealth			= 300
PLAYER.StartHealth			= 300
PLAYER.DropWeaponOnDie		= true
PLAYER.TeammateNoCollide	= false
PLAYER.UseVMHands			= true

function PLAYER:OnSpawn( ply )
    ply:SetCollisionGroup(COLLISION_GROUP_WEAPON)
end

function PLAYER:GetHandsModel()
	local playermodel = player_manager.TranslateToPlayerModelName( self.Player:GetModel() )
	return player_manager.TranslatePlayerHands( playermodel )
end

player_manager.RegisterClass( "player_surf_dm", PLAYER, "player_default" )