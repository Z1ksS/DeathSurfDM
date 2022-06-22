local mFrame

function OnSpawnMenu(bool)
    if IsValid(mFrame) then mFrame:Remove() end 

    mFrame = vgui.Create("DFrame")
    mFrame:SetSize(ScrW(), ScrH())
    mFrame:SetTitle("")
	mFrame:Center()
	mFrame:MakePopup()
	mFrame:SetDraggable(false)
	mFrame:Center()
	mFrame:ShowCloseButton(false)
    mFrame.Paint = function(self, w, h)	
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    local TeamSelectButton = {}
    for k, v in pairs(DS.TeamConfig) do
        TeamSelectButton[k] = mFrame:Add("DButton")
        TeamSelectButton[k]:SetText( "" )					
        TeamSelectButton[k]:SetPos( mFrame:GetWide() * 0.3 + (k - 1) * ScaleW(500), mFrame:GetTall() * 0.35 )				
        TeamSelectButton[k]:SetSize( ScaleW(250), ScaleH(250) )		
        TeamSelectButton[k].Paint = function(self, w, h)				

            if self:IsHovered() then 
                draw.SimpleLinearGradient(self:GetX(), self:GetY(), w, h, Color(v.team_color.r, v.team_color.g, v.team_color.b, 255), Color(0, 0, 0, 5))
            else 
                draw.SimpleLinearGradient(self:GetX(), self:GetY(), w, h, Color(v.team_color.r, v.team_color.g, v.team_color.b, 200), Color(0, 0, 0, 5))
            end
            
            draw.SimpleText(v.team_name, "Trebuchet24", w * 0.2 + (k - 1) * 40, h * 0.3, Color(255, 255, 255, 255))
            
            local teamCount = #team.GetPlayers(k)
            draw.SimpleText(teamCount .. " PLAYERS", "Trebuchet18", w * 0.4 + (k - 1) * 5, h * 0.4, Color(255, 255, 255, 255))
        end
        TeamSelectButton[k].DoClick = function()
            if LocalPlayer():Team() == k then 
                LocalPlayer():ChatPrint("You are now playing in this team!")

                return 
            end 

            if team.NumPlayers(k) > team.NumPlayers(k == 1 and 2 or 1) or team.NumPlayers(k) == team.NumPlayers(k == 1 and 2 or 1) and (team.NumPlayers(k) != 0 or team.NumPlayers(k == 1 and 2 or 1) != 0)  then 

                LocalPlayer():ChatPrint("There are too many players in this team!")

                return 
            end 

            net.Start("DS:TeamSelected")
                net.WriteInt(k, 3)
            net.SendToServer(LocalPlayer())

            mFrame:Remove()

        end 
    end 
    
    if bool then 
        local buttonCancel = mFrame:Add("DButton")
        buttonCancel:SetText( "" )	
        buttonCancel:SetPos( mFrame:GetWide() * 0.4, mFrame:GetTall() - 100 )	
        buttonCancel:SetSize(300, 300)

        buttonCancel.Paint = function(self, w, h)	
            draw.SimpleText("CANCEL", "Trebuchet24", w * 0.5, 0, Color(255, 255, 255, 255))
        end

        buttonCancel.DoClick = function()
            mFrame:Remove()
        end 
    end
end 

net.Receive("DS:OpenMenuTeamOnSpawn", function()
    OnSpawnMenu(net.ReadBool())
end )