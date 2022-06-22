function RewardPlayer( ply, amt, reason )
	amt = amt or 0

	ply:PS2_AddStandardPoints( amt, "You were given " .. tostring( amt ) .. " points for ".. reason .. "!", true)
end

hook.Add("PlayerDeath", "PointshopRewards", function( ply, inflictor, attacker )
	if attacker:IsPlayer() then
		if ply:Team() ~= attacker:Team() then
			RewardPlayer( attacker, DS.PointShopKillReward, "killing " .. ply:Nick())
		end
	end
end)