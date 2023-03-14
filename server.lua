print("[Creative Solutions] DESYNC FIXER LOADED")
local START_TIME = os.time()

RegisterServerEvent("DesyncPot:TrackPing")
AddEventHandler("DesyncPot:TrackPing", function()
    local src = source
    TriggerClientEvent("DesyncPot:UpdatePing", src, GetPlayerPing(src))
end)

RegisterServerEvent("DesyncPot:DropPlayer")
AddEventHandler("DesyncPot:DropPlayer", function()
    local src = source
    DropPlayer(src,
        "You were dropped due to high ping. Check your internet and try again. [CREATIVE SOLUTIONS] - Desync/Ping issue.")
end)

RegisterServerEvent("DesyncPot:CheckSession")
AddEventHandler("DesyncPot:CheckSession", function(clientCount)
    local src = source
    if os.time() - START_TIME < 300 then
        -- Server/script recently started, don't process yet
        return
    end

    local serverCount = #GetPlayers()
    if serverCount - clientCount > 2 and clientCount < math.floor(serverCount / 2.0) then
        print(src .. " (probably) got sessioned. They need to relog. Server: " .. serverCount .. "   Client " ..
                  clientCount .. "    Host " .. tostring(NetworkIsHost()))
        TriggerClientEvent("DesyncPot:Sessioned", src, serverCount)
    end
end)
