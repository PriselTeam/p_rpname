local playerCaching = {}
local nameCaching = {}

function Prisel.RPName:Initialize()
    if not sql.TableExists("prisel_rpnames") then
        sql.Query("CREATE TABLE prisel_rpnames (steamid TEXT PRIMARY KEY, name TEXT)")
    end

    local query = sql.Query("SELECT name FROM prisel_rpnames")

    if query then
        for k, v in pairs(query) do
            Prisel.RPName:AddNameCaching(v.name)
        end
    end
end

function Prisel.RPName:IsPlayerCached(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    return playerCaching[ply:SteamID()]
end

function Prisel.RPName:AddPlayerCaching(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    playerCaching[ply:SteamID()] = true
end

function Prisel.RPName:IsNameCached(name)
    if not isstring(name) then return end
    return nameCaching[name]
end

function Prisel.RPName:AddNameCaching(name)
    if not isstring(name) then return end
    nameCaching[name] = true
end

local PLAYER = FindMetaTable("Player")

function PLAYER:InitializePRPName()
    if not IsValid(self) or not self:IsPlayer() then return end

    if Prisel.RPName:IsPlayerCached(self) then return end

    local query = sql.Query("SELECT name FROM prisel_rpnames WHERE steamid = '" .. self:SteamID() .. "'")

    if query then

        if self:Name() != query[1].name then
            self:setRPName(query[1].name)
        end

        Prisel.RPName:AddPlayerCaching(self)
    end

end

function PLAYER:SetPRPName(name)
    if not IsValid(self) or not self:IsPlayer() then return end

    if Prisel.RPName:IsNameCached(name) then return false end

    if Prisel.RPName:IsNameCached(self:Name()) then
        nameCaching[self:Name()] = nil
    end

    Prisel.RPName:AddNameCaching(name)
    Prisel.RPName:AddPlayerCaching(self)

    sql.Query("INSERT OR REPLACE INTO prisel_rpnames (steamid, name) VALUES ('" .. self:SteamID() .. "', '" .. name .. "')")

    self:setRPName(name)

    return true 
end

function PLAYER:HasPRPName()
    return Prisel.RPName:IsPlayerCached(self)
end