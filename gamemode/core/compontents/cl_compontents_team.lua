local PANEL = {}

function PANEL:Init()

	self:SetTitle("")
	self:SetSize(350, 350)
	self:MakePopup()
	self:SetDraggable(false)
	self:Center()
	self:ShowCloseButton(false)

	self:SetCursor("hand")

	self.TeamID = ""
end

function PANEL:SetTeam(team_id)
	self.TeamID = team_id
end 

function PANEL:Paint(w, h)
	--draw.SimpleLinearGradient(0, 0, w, h, sColor, eColor, horizontal)
end