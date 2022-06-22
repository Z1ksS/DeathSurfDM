local msgs = {}

msgs = {
	"Press F1 to open select team menu.",
    "To open pointshop menu, press F3 button.",
    "You can customize your character with poinshop system! Press F3 to open menu.",
}

local idx = 1

local function DoAnnouncements()
	chat.AddText(Color(255, 255, 255, 255), "[", Color(255, 255, 255, 255), "DS", Color(255, 255, 255, 255), "] "..(msgs[idx]))
	idx = idx + 1
	if idx > #msgs then idx = 1 end
end

hook.Add("Initialize", "DSThinkAnnounce", function()
	timer.Destroy("DeathrunAnnouncementTimer")
	timer.Create("DeathrunAnnouncementTimer", 40, 0, function()
		DoAnnouncements()
	end)
end)

timer.Create("DeathrunAnnouncementTimer", 40, 0, function()
	DoAnnouncements()
end)