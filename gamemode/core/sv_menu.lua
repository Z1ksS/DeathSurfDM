function GM:ShowHelp(ply) 
    net.Start("DS:OpenMenuTeamOnSpawn")
        net.WriteBool(true)
    net.Send(ply)
end 