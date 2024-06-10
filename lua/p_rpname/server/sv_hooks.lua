hook.Add("Initialize", "Prisel::RPName::Init", function()
    Prisel.RPName:Initialize()
end)

hook.Add("PlayerInitialSpawn", "Prisel::RPName::PIS", function(ply)
    timer.Simple(1, function()
        ply:InitializePRPName()

        if not ply:HasPRPName() then
            timer.Simple(1, function()
                net.Start("Prisel::RPName::Main")
                    net.WriteUInt(1, 3)
                    net.WriteBool(true)
                net.Send(ply)
            end)
        end
    end)

end)