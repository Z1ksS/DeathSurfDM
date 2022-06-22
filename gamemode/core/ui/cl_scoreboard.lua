local sbFrame 

function OpenScoreboardMenu()
    local rounds = GetRoundAmount() or 0

    sbFrame = vgui.Create("DFrame")
    sbFrame:SetSize(ScrW(), ScrH())
    sbFrame:Center()
	sbFrame:SetTitle("")
	sbFrame:MakePopup()
	sbFrame:SetDraggable(false)
	sbFrame:Center()
	sbFrame:ShowCloseButton(false)
    sbFrame.Paint = function(self, w, h)	
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))

		draw.SimpleText("ROUNDS " .. rounds .. "/5", "Trebuchet24", w * 0.47, h * 0.16, Color(255, 255, 255, 255))
    end

    local TeamsPanels = {}
    for k, v in pairs(DS.TeamConfig) do 
        TeamsPanels[k] = sbFrame:Add("DScrollPanel")
        TeamsPanels[k]:SetSize(ScaleW(550), ScaleH(600))
        TeamsPanels[k]:SetPos(ScrW() * 0.2 + (k - 1) * ScaleW(600), ScrH() * 0.2)
        TeamsPanels[k].Paint = function(self, w, h)	
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))

            draw.RoundedBox(0, 0, 0, w, 35, Color(v.team_color.r, v.team_color.g, v.team_color.b, 255))

            draw.SimpleText(v.team_name .. "(" .. #team.GetPlayers(k) .. ")", "Trebuchet24", 10, 5, Color(255, 255, 255, 255))
            draw.SimpleText("K", "Trebuchet24", w - 90, 5, Color(255, 255, 255, 255))
            draw.SimpleText("D", "Trebuchet24", w - 60, 5, Color(255, 255, 255, 255))
            draw.SimpleText("P", "Trebuchet24", w - 30, 5, Color(255, 255, 255, 255))
        end

        TeamsPanels[k].topPanel = TeamsPanels[k]:Add("DPanel")
        TeamsPanels[k].topPanel:SetSize(TeamsPanels[k]:GetWide(), 35)
        TeamsPanels[k].topPanel:SetPos(0, 0)
        TeamsPanels[k].topPanel.Paint = function(self, w, h)	
            draw.RoundedBox(0, 0, 0, w, h, Color(v.team_color.r, v.team_color.g, v.team_color.b, 255))

            draw.SimpleText(v.team_name .. "(" .. #team.GetPlayers(k) .. ")", "Trebuchet24", 10, 5, Color(255, 255, 255, 255))
            draw.SimpleText("K", "Trebuchet24", w - 90, 5, Color(255, 255, 255, 255))
            draw.SimpleText("D", "Trebuchet24", w - 60, 5, Color(255, 255, 255, 255))
            draw.SimpleText("P", "Trebuchet24", w - 30, 5, Color(255, 255, 255, 255))
        end
    end 

    local team_players = {}

    for _, ply in pairs (player.GetAll()) do
        local t = ply:Team()

		team_players[t] = team_players[t] or { players = {} }

		table.insert(team_players[t].players, ply)
    end 

    for k, teams in pairs(team_players) do 
        for i, ply in ipairs(teams.players) do
			if ply and IsValid(ply) then
                if !IsValid(TeamsPanels[k]) then return end 
                
                local plyPanel = vgui.Create("DPanel")
		        plyPanel:SetSize(TeamsPanels[k]:GetWide(),32)
                plyPanel:SetPos(0, 35 + (i - 1) * 35)
		        plyPanel.Paint = function(self,w,h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))

			        draw.SimpleText(!ply:Alive() and ply:Name() .. " *D*" or ply:Name(), "Trebuchet18", 36, 6, color_white, TEXT_ALIGN_LEFT)
			        draw.SimpleText(ply:Frags(), "Trebuchet18", w - 85, 6, color_white, TEXT_ALIGN_CENTER)
			        draw.SimpleText(ply:Deaths(), "Trebuchet18", w - 55, 6, color_white, TEXT_ALIGN_CENTER)
			        draw.SimpleText(ply:Ping(), "Trebuchet18", w - 25, 6, color_white, TEXT_ALIGN_CENTER)
		        end
		
		        local avatar = vgui.Create("AvatarImage", plyPanel)
		        avatar:SetSize(32,32)
		        avatar:SetPlayer(ply,32)
		
		        local avabut = vgui.Create("DButton", plyPanel)
		        avabut:SetSize(32,32)
		        avabut:SetText("")
		        avabut.Paint = function(self,w,h)
			        draw.RoundedBox(0, 0, 0, w, h, Color (210, 210, 210, 0))
		        end
		        avabut.DoClick = function()
			        ply:ShowProfile()
		        end
		
		        TeamsPanels[k]:AddItem(plyPanel)
             end 
        end 
    end
end 

hook.Add("ScoreboardShow", "ScoreBoardOpen", function()
	gui.EnableScreenClicker( true )
	OpenScoreboardMenu()
end)

hook.Add("ScoreboardHide", "ScoreBoardHid", function()
	if sbFrame and IsValid(sbFrame) then
		gui.EnableScreenClicker( false )

		sbFrame:AlphaTo( 0, .1, 0, function()
			sbFrame:Remove()
		end )
	end
end)

function GM:ScoreboardShow() end 
