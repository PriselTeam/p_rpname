local basePath = "p_rpname/"

local function AddCLFile(path)
    if SERVER then
        AddCSLuaFile(basePath .. path)
    end
    include(basePath .. path)
end

local function AddSVFile(path)
    if SERVER then
        include(basePath .. path)
    end
end

local function AddSHFile(path)
    AddCSLuaFile(basePath .. path)
    include(basePath .. path)
end

AddSHFile("config.lua")

AddSVFile("server/sv_utils.lua")
AddSVFile("server/sv_functions.lua")
AddSVFile("server/sv_networking.lua")
AddSVFile("server/sv_hooks.lua")

AddCLFile("client/cl_functions.lua")
AddCLFile("client/cl_networking.lua")

hook.Add("DarkRPFinishedLoading", "prpname_autoloader", function()
    DarkRP.removeChatCommand("rpname")
    DarkRP.removeChatCommand("name")
    DarkRP.removeChatCommand("nick")
end)