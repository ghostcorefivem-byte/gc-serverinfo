local QBCore = exports['qb-core']:GetCoreObject()

-- Callback to get current player count
QBCore.Functions.CreateCallback('gc-serverinfo:server:GetPlayerCount', function(source, cb)
    local currentPlayers = #GetPlayers()
    local maxPlayers = GetConvarInt('sv_maxclients', 48) -- Default to 48 if not set
    
    cb(currentPlayers, maxPlayers)
end)
