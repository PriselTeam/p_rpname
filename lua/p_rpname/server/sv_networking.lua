util.AddNetworkString("Prisel::RPName::Main")
util.AddNetworkString("Prisel::RPName::MainSV")


net.Receive("Prisel::RPName::MainSV", function(_, ply)
    local action = net.ReadUInt(3)

    if action == 1 then
        local name = net.ReadString()
        local isFirstTime = false

        if not ply:HasPRPName() then
            isFirstTime = true
        end

        if not isFirstTime and ply:GetNWBool("Prisel::RPName::ForceName") then
            ply:SetNWBool("Prisel::RPName::ForceName", false)
            isFirstTime = true
        end

        if string.match(name, "^[a-zA-Z]+%s[a-zA-Z%s]+$") and string.len(name) >= 3 and string.len(name) <= 32 then
            if not isFirstTime then
                if ply:canAfford(Prisel.RPName.Configuration.NamePrice) then
                    ply:addMoney(-Prisel.RPName.Configuration.NamePrice)
                else
                    net.Start("Prisel::RPName::Main")
                        net.WriteUInt(4, 3)
                    net.Send(ply)
                    return
                end
            end

            local success = ply:SetPRPName(name)

            if success then
                net.Start("Prisel::RPName::Main")
                    net.WriteUInt(3, 3)
                net.Send(ply)
            else
                net.Start("Prisel::RPName::Main")
                    net.WriteUInt(2, 3)
                net.Send(ply)
            end
        end
    end

    if action == 3 then
        if Prisel.RPName.Configuration.Staffs[ply:GetUserGroup()] then
            local target = net.ReadEntity()
            local name = net.ReadString()

            if not IsValid(target) or not target:IsPlayer() then return end

            if string.match(name, "^[a-zA-Z]+%s[a-zA-Z%s]+$") and string.len(name) >= 3 and string.len(name) <= 32 then
                local success = target:SetPRPName(name)

                if success then
                    net.Start("Prisel::RPName::Main")
                        net.WriteUInt(3, 3)
                    net.Send(ply)
                else
                    net.Start("Prisel::RPName::Main")
                        net.WriteUInt(2, 3)
                    net.Send(ply)
                end

                return
            end

            net.Start("Prisel::RPName::Main")
                net.WriteUInt(3, 3)
            net.Send(ply)

        end
    end

    if action == 2 then
        -- if Prisel.RPName.Configuration.Staffs[ply:GetUserGroup()] then
        --     local target = net.ReadEntity()

        --     if not IsValid(target) or not target:IsPlayer() then return end

        --     net.Start("Prisel::RPName::Main")
        --         net.WriteUInt(1, 3)
        --         net.WriteBool(true)
        --     net.Send(ply)

        --     ply:SetNWBool("Prisel::RPName::ForceName", true)
        -- end
    end
    
end)