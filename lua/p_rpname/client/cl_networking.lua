net.Receive("Prisel::RPName::Main", function()

    local action = net.ReadUInt(3)

    if action == 1 then
        local isFirst = net.ReadBool()
        Prisel.RPName:FrameChangeName(isFirst)
    end

    if action == 2 then
        notification.AddLegacy("Ressayez un autre nom.", NOTIFY_ERROR, 5)
    end

    if action == 3 then
        Prisel.RPName:CloseFrame()
    end

    if action == 4 then
        notification.AddLegacy("Vous n'avez pas assez d'argent pour changer de nom.", NOTIFY_ERROR, 5)
    end
    
end)