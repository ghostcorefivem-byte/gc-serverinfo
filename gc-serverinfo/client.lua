local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local isLoggedIn = false
local uiShown = false

------------------------------------------------------------
-- 🔥 CRITICAL: Prevent black NUI background
------------------------------------------------------------
CreateThread(function()
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    
    while true do
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
        Wait(10000)
    end
end)

-- Hide UI on initial load
CreateThread(function()
    SendNUIMessage({ action = "show", display = false })
end)

------------------------------------------------------------
-- 📍 Show UI Function
------------------------------------------------------------
local function ShowUI()
    if not uiShown then
        uiShown = true
        print("^2[GC-ServerInfo]^7 Showing UI")
        SendNUIMessage({ action = "show", display = true })
        TriggerEvent('gc-serverinfo:client:UpdateDisplay')
        GetPlayerCount()
    end
end

local function HideUI()
    if uiShown then
        uiShown = false
        print("^1[GC-ServerInfo]^7 Hiding UI")
        SendNUIMessage({ action = "show", display = false })
    end
end

------------------------------------------------------------
-- 🎯 Multiple Spawn Detection Methods
------------------------------------------------------------

-- Method 1: QBCore Player Loaded (most reliable)
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    print("^3[GC-ServerInfo]^7 Player loaded event fired")
    PlayerData = QBCore.Functions.GetPlayerData()
    isLoggedIn = true
    
    -- Wait a bit for everything to load, then show
    Wait(3000)
    ShowUI()
end)

-- Method 2: Detect when player spawns
AddEventHandler('QBCore:Client:OnPlayerSpawn', function()
    print("^3[GC-ServerInfo]^7 Player spawn event fired")
    if isLoggedIn then
        Wait(2000)
        ShowUI()
    end
end)

-- Method 3: qb-spawn detection
RegisterNetEvent('qb-spawn:client:setupSpawns', function()
    print("^3[GC-ServerInfo]^7 QB-Spawn setup event fired")
    if isLoggedIn then
        Wait(2000)
        ShowUI()
    end
end)

-- Method 4: Check if player is already spawned (for resource restarts)
CreateThread(function()
    Wait(5000) -- Wait for QBCore to initialize
    
    PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData and next(PlayerData) then
        print("^3[GC-ServerInfo]^7 Player already logged in, showing UI")
        isLoggedIn = true
        ShowUI()
    end
end)

-- Method 5: Manual check every few seconds (safety net)
CreateThread(function()
    while true do
        Wait(10000)
        
        if not uiShown and not isLoggedIn then
            PlayerData = QBCore.Functions.GetPlayerData()
            if PlayerData and next(PlayerData) then
                print("^3[GC-ServerInfo]^7 Player detected via safety check")
                isLoggedIn = true
                ShowUI()
            end
        end
    end
end)

-- Player unload
RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    print("^1[GC-ServerInfo]^7 Player unloaded")
    PlayerData = {}
    isLoggedIn = false
    HideUI()
end)

-- When ps-hud restarts
AddEventHandler('onResourceStart', function(res)
    if res == 'ps-hud' and uiShown then
        Wait(1500)
        SendNUIMessage({ action = "show", display = true })
    end
end)

-- Player data updates
RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val
    if isLoggedIn and uiShown then
        TriggerEvent('gc-serverinfo:client:UpdateDisplay')
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
    if isLoggedIn and uiShown then
        TriggerEvent('gc-serverinfo:client:UpdateDisplay')
    end
end)

------------------------------------------------------------
-- 💰 Data updates
------------------------------------------------------------
local function FormatMoney(amount)
    local formatted = tostring(amount)
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return "$" .. formatted
end

function GetPlayerCount()
    if not isLoggedIn or not uiShown then return end
    
    QBCore.Functions.TriggerCallback('gc-serverinfo:server:GetPlayerCount', function(currentPlayers, maxPlayers)
        SendNUIMessage({
            action = "updatePlayerCount",
            current = currentPlayers,
            max = maxPlayers
        })
    end)
end

RegisterNetEvent('gc-serverinfo:client:UpdateDisplay', function()
    if not isLoggedIn or not uiShown then return end
    
    local playerId = GetPlayerServerId(PlayerId())
    local jobLabel = "Unemployed"
    local cash, bank = 0, 0

    if PlayerData.job and PlayerData.job.label then
        jobLabel = PlayerData.job.label
    end

    if PlayerData.money then
        cash = PlayerData.money['cash'] or 0
        bank = PlayerData.money['bank'] or 0
    end

    SendNUIMessage({
        action = "updateInfo",
        playerId = playerId,
        job = jobLabel,
        cash = FormatMoney(cash),
        bank = FormatMoney(bank)
    })
end)

------------------------------------------------------------
-- ⏱️ Update threads
------------------------------------------------------------
CreateThread(function()
    while true do
        if isLoggedIn and uiShown then 
            GetPlayerCount() 
        end
        Wait(30000) -- Every 30 seconds
    end
end)

CreateThread(function()
    while true do
        if isLoggedIn and uiShown then 
            TriggerEvent('gc-serverinfo:client:UpdateDisplay') 
        end
        Wait(5000) -- Every 5 seconds
    end
end)

------------------------------------------------------------
-- 🛠️ Debug command (optional - remove if not needed)
------------------------------------------------------------
RegisterCommand('serverinfo', function(source, args)
    if args[1] == 'show' then
        ShowUI()
        print("^2[GC-ServerInfo]^7 Manually showing UI")
    elseif args[1] == 'hide' then
        HideUI()
        print("^1[GC-ServerInfo]^7 Manually hiding UI")
    elseif args[1] == 'toggle' then
        if uiShown then
            HideUI()
        else
            ShowUI()
        end
    elseif args[1] == 'status' then
        print("^3[GC-ServerInfo] Status:^7")
        print("  UI Shown: " .. tostring(uiShown))
        print("  Logged In: " .. tostring(isLoggedIn))
        print("  Has PlayerData: " .. tostring(PlayerData and next(PlayerData) ~= nil))
    else
        print("^3[GC-ServerInfo] Commands:^7")
        print("  /serverinfo show - Force show UI")
        print("  /serverinfo hide - Force hide UI")
        print("  /serverinfo toggle - Toggle UI")
        print("  /serverinfo status - Show status")
    end
end)
