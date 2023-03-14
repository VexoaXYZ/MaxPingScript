local MAX_PING = 560
local currentPing = 0
local highPing = false

function TrackPing()
    while true do
        TriggerServerEvent("DesyncPot:TrackPing")
        if not highPing then
            CheckPing()
        end

        Wait(5000)
    end
end

function CheckSession()
    print("Beginning to track session")
    while NetworkIsSessionActive() do
        Wait(60 * 1000)
        print("Sending session check. Host check " .. tostring(NetworkIsHost()))
        TriggerServerEvent("DesyncPot:CheckSession", #GetActivePlayers())
        print("Current Time: " .. tostring(os.time()))
    end
end

function CheckPing()
    if currentPing > MAX_PING then
        highPing = true
        local timeout = 60000
        local startTime = GetGameTimer()

        while math.abs(startTime - GetGameTimer()) < timeout do
            if currentPing < MAX_PING then
                highPing = false
                return
            end

            AddTextEntry("DESYNCFIX", "~r~WARNING:~s~ You will be kicked in ~r~60 seconds~s~ due to your high ping.")
            DisplayHelpTextThisFrame("DESYNCFIX", false)
            Wait(1)
        end

        TriggerServerEvent("DesyncPot:DropPlayer")
        highPing = false
    end
end

RegisterNetEvent("DesyncPot:UpdatePing")
AddEventHandler("DesyncPot:UpdatePing", function(ping)
    currentPing = ping
end)

RegisterNetEvent("DesyncPot:Sessioned")
AddEventHandler("DesyncPot:Sessioned", function(serverCount)
    print("sessioned. need to rejoin " .. #GetActivePlayers() .. " vs " .. serverCount .. " Host " ..
              tostring(NetworkIsHost()))
    TriggerEvent("chat:addMessage", {
        color = {255, 0, 0},
        multiline = true,
        args = {"You have been disconnected and need to rejoin due to a potential issue with the server or desync. Please reconnect to the server. [SESSION WARNING]."}
    })
end)

Citizen.CreateThread(function()
    while not NetworkIsPlayerActive(NetworkGetPlayerIndexFromPed(PlayerPedId())) do
        Wait(500)
    end
    TrackPing()
    CheckSession()
end)

