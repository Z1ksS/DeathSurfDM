MapVote.Config = {}

-- Default Config
MapVoteConfigDefault = {
    MapLimit = 24,
    TimeLimit = 28,
    AllowCurrentMap = false,
    EnableCooldown = true,
    MapsBeforeRevote = 3,
    RTVPlayerCount = 3,
    MapPrefixes = {"surf_"},
    AutoGamemode = false
}
-- Default Config

hook.Add("Initialize", "MapVoteConfigSetup", function()
    if not file.Exists("mapvote", "DATA") then file.CreateDir("mapvote") end
    if not file.Exists("mapvote/config.txt", "DATA") then
        file.Write("mapvote/config.txt", util.TableToJSON(MapVoteConfigDefault))
    end
end)

MapVote.CurrentMaps = {}
MapVote.Votes = {}

MapVote.Allow = false

MapVote.UPDATE_VOTE = 1
MapVote.UPDATE_WIN = 3