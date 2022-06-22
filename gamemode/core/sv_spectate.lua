local ply = FindMetaTable("Player")

function ply:force_spectate_make()
	self:Spectate(OBS_MODE_ROAMING)
end 

function GetAlivePlayers()
   local alive = {}
   for k, p in pairs(player.GetAll()) do
      if IsValid(p) and p:Alive() then
         table.insert(alive, p)
      end
   end

   return alive
end

function GetNextAlivePlayer(ply)
   local alive = GetAlivePlayers()

   if #alive < 1 then return nil end

   local prev = nil
   local choice = nil

   if IsValid(ply) then
      for k,p in pairs(alive) do
         if prev == ply then
            choice = p
         end

         prev = p
      end
   end

   if not IsValid(choice) then
      choice = alive[1]
   end

   return choice
end

hook.Add("KeyPress", "SpectateKeyPress", function(ply, key)
	if not IsValid(ply) then return end

	if ply:GetObserverMode() == OBS_MODE_ROAMING then

      	if key == IN_ATTACK2 then

        	ply:Spectate(OBS_MODE_ROAMING)
        	ply:SetEyeAngles(angle_zero)
       	 	ply:SpectateEntity(nil)

        	local alive = GetAlivePlayers()

        	if #alive < 1 then return end

        	local target = table.Random(alive)

        	if IsValid(target) then
        		ply:SetPos(target:EyePos())
        		ply:SetEyeAngles(target:EyeAngles())
        	end

      	elseif key == IN_RELOAD then
        	local pos = ply:GetPos()
        	local ang = ply:EyeAngles()

        	local target = ply:GetObserverTarget()

        	if IsValid(target) and target:IsPlayer() then
        		pos = target:EyePos()
        		ang = target:EyeAngles()
        	end

       	 	ply:Spectate(OBS_MODE_ROAMING)
        	ply:SpectateEntity(nil)

        	ply:SetPos(pos)
        	ply:SetEyeAngles(ang)
        	return true

      	elseif key == IN_DUCK then

        	if not (ply:GetMoveType() == MOVETYPE_NOCLIP) then
        		ply:SetMoveType(MOVETYPE_NOCLIP)
        	end

    	elseif key == IN_JUMP then
        	local tgt = ply:GetObserverTarget()

        	if not IsValid(tgt) or not tgt:IsPlayer() then return end

        	if not ply.spec_mode or ply.spec_mode == OBS_MODE_CHASE then
        		ply.spec_mode = OBS_MODE_IN_EYE
        	elseif ply.spec_mode == OBS_MODE_IN_EYE then
        		ply.spec_mode = OBS_MODE_CHASE
        	end

        	ply:Spectate(ply.spec_mode)
      	end
   	end
end )