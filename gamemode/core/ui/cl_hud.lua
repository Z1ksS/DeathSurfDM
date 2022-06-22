function ScaleW(sizew)
	return ScrW() * ( sizew / 1920 )
end

function ScaleH(sizeh)
	return ScrH() * (sizeh / 1080) 
end

function HudDraw()
    local rBlue, rRed = GetRoundAmountTeam("Blue"), GetRoundAmountTeam("Red")
    
    local gameState = DS.ROUND:GetCurrent()

    local w, h = ScrW(), ScrH()
    local xOffSet = w * 0.5 - w * 0.1
    local wScale1, wScale2, hScale = ScaleW(65), ScaleW(275), ScaleH(55)
    draw.SimpleLinearGradient(xOffSet, 0, wScale1, hScale, Color(255, 0, 0, 255), Color(0, 0, 0, 75))
    draw.SimpleLinearGradient(xOffSet + wScale1, 0, wScale2, hScale, Color(0, 0, 0, 255), Color(0, 0, 0, 75))
    draw.SimpleLinearGradient(xOffSet + wScale1 + wScale2, 0, wScale1, hScale, Color(21, 24, 213), Color(0, 0, 0, 75))

    draw.SimpleText(rRed, "Trebuchet24",  xOffSet + ( ( (xOffSet + wScale1) - ( xOffSet ) ) * 0.43 ), 15, Color(255, 255, 255, 255))
    draw.SimpleText(rBlue, "Trebuchet24",  (xOffSet + wScale1 + wScale2) + ( ( (xOffSet + wScale1 + wScale2 + wScale1) - ( xOffSet + wScale1 + wScale2 ) ) * 0.43 ), 15, Color(255, 255, 255, 255))

    if gameState == ROUND_WAIT then 
        draw.SimpleText("WAITING FOR PLAYERS", "Trebuchet24",  ( (xOffSet + wScale1 + wScale2) + (xOffSet + wScale1) ) * 0.45, 15, Color(255, 255, 255, 255))
    elseif gameState == ROUND_PREP then 
        draw.SimpleText("ROUND WILL START IN " .. math.Round( math.Clamp( DS.ROUND:GetTimer(), 0, 5 ) ), "Trebuchet24",  ( (xOffSet + wScale1 + wScale2) + (xOffSet + wScale1) ) * 0.45, 15, Color(255, 255, 255, 255))
    elseif gameState == ROUND_ACTIVE then 
        draw.SimpleText("ROUND ENDS IN " .. string.ToMinutesSeconds( math.Clamp( DS.ROUND:GetTimer(), 0, 60*5 ) ), "Trebuchet24",  ( (xOffSet + wScale1 + wScale2) + (xOffSet + wScale1) ) * 0.45, 15, Color(255, 255, 255, 255))
    elseif gameState == ROUND_OVER and GetRoundAmount() >= 5 then 
        draw.SimpleText("Map voting in " .. string.ToMinutesSeconds( math.Clamp( DS.ROUND:GetTimer(), 0, 15 ) ), "Trebuchet24",  ( (xOffSet + wScale1 + wScale2) + (xOffSet + wScale1) ) * 0.45, 15, Color(255, 255, 255, 255))
    end

    if LocalPlayer():GetObserverMode() == OBS_MODE_ROAMING then 
        draw.SimpleText("YOU ARE NOW IN SPECTATOR MODE", "Trebuchet24", w * 0.45, h - 100, Color(255, 255, 255))
    end
end 

hook.Add("HUDPaint", "DrawHUD", HudDraw)
