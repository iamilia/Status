if GetResourceState('extendedmode') == 'missing' then return end
--[[ Var ]]
ESX = nil
health, armor, id, hunger, thirst = 0, 0, 0, 0, 0
isMinimize, showHud = false, true

--[[ Function ]]
local SendNuiMessage = SendNuiMessage
ToggelHud = function()
    if isMinimize then
        ESX.TriggerServerCallback("status:loadPlayer", function(player)
            id = player.source
            local datas = {
                id = player.source,
                name = player.name,
                heal = health,
                armor = armor,
                water = thirst,
                food = hunger,
                cash = ESX.GetPlayerData().accounts[3].money
            }
            if player.job.name ~= status.unemployedjobname then
                datas.job = {
                    name = player.job.name,
                    rank = player.job.grade
                }
            end
            SendNUIMessage({
                type = "all",
                size = "full",
                data = datas
            })
        end)
        isMinimize = false
    else
        ESX.TriggerServerCallback("status:loadPlayer", function(player)
            id = player.source
            local datas = {
                id = player.source,
                heal = health,
                armor = armor,
                water = thirst,
                food = hunger,
            }
            SendNUIMessage({
                type = "all",
                size = "short",
                data = datas
            })
        end)
        isMinimize = true
    end
end



updateht = function(hunger, thirs)
    SendNuiMessage(json.encode({
        type = "set",
        data = {
            food = tonumber(hunger),
            water = tonumber(thirs),
        }
    }))
end


--[[ Thread ]]
CreateThread(function()
    while ESX == nil do
        TriggerEvent(status.getsharedobj, function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while not ESX.PlayerLoaded do
        Wait(500)
    end
    while hunger == 0 and thirst == 0 and health == 0 do
        Wait(500)
    end
    Wait(5000)
    ESX.TriggerServerCallback("status:loadPlayer", function(player)
        id = player.source
        local datas = {
            id = player.source,
            name = player.name,
            heal = health,
            armor = armor,
            water = thirst,
            food = hunger,
            cash = ESX.GetPlayerData().accounts[3].money
        }
        if player.job.name ~= status.unemployedjobname then
            datas.job = {
                name = player.job.name,
                rank = player.job.grade
            }
        end
        SendNUIMessage({
            type = "all",
            size = "full",
            data = datas
        })
    end)
end)

CreateThread(function()
    while true do
        TriggerEvent(status.triggeresxstatusget, 'hunger', function(lav)
            TriggerEvent(status.triggeresxstatusget, 'thirst', function(ref)
                hunger = lav.val / 10000
                thirst = ref.val / 10000
            end)
        end)
        SendNuiMessage(json.encode({
            type = "set",
            data = {
                water = thirst,
                food = hunger,
            }
        }))
        Wait(10000)
    end
end)


CreateThread(function()
    local showed = false
    while true do
        if showed ~= showHud and not IsPauseMenuActive() then
            SendNuiMessage(json.encode({
                type = "display",
                state = true
            }))
            showed = showHud
        end
        if IsPauseMenuActive() and showed then
            SendNuiMessage(json.encode({
                type = "display",
                state = false
            }))
            showed = false
        end
        if showHud then
            local ped = PlayerPedId()
            local pedhealth = GetEntityHealth(ped)
            if pedhealth < 100 then
                health = 0
            else
                pedhealth = pedhealth - 100
                health    = pedhealth
            end
            armor = GetPedArmour(ped)
            if armor < 101 then
                armor = 100
            end
            SendNuiMessage(json.encode(
                {
                    type = "set",
                    data = {
                        heal = tonumber(health),
                        armor = tonumber(armor),
                    }
                }
            ))
        end
        Wait(1000)
    end
end)


CreateThread(function()
    if status.UseKeyManager then
        AddEventHandler("onKeyDown", function(key)
            if (key):lower() == (status.Keytoshowandhide):lower() then
                ToggelHud()
                exports.pNotify:SendNotification(
                    {

                        text = '<strong class="whit-text">تغییر وضعیت انجام شد</strong>',

                        type = "success",

                        timeout = 1000,

                        layout = "centerRight",

                        queue = "TogglerHud"

                    }
                )
            end
        end)
    else
        RegisterCommand('+toggelhud', function()
            exports.pNotify:SendNotification({
                text = '<strong class="whit-text">تغییر وضعیت انجام شد</strong>',
                type = "success",
                timeout = 1000,
                layout = "centerRight",
                queue = "TogglerHud"
            })
            ToggelHud()
        end, false)
        RegisterKeyMapping('+toggelhud', 'donnot edit', 'keyboard', status.Keytoshowandhide)
    end
end)


--[[ Def EventHandlers ]]

RegisterNetEvent('esx:setJob', function(job)
    if source == '' then return end
    if not isMinimize then
        ESX.TriggerServerCallback("status:loadPlayer", function(player)
            id = player.source
            local datas = {
                id = player.source,
                name = player.name,
                heal = health,
                armor = armor,
                water = thirst,
                food = hunger,
                cash = ESX.GetPlayerData().accounts[3].money
            }
            if job.name ~= status.unemployedjobname then
                datas.job = {
                    name = job.name,
                    rank = job.grade
                }
            end
            SendNuiMessage(json.encode({
                type = "all",
                size = "full",
                data = datas
            }))
        end)
    end
    if job.name ~= status.unemployedjobname then
        SendNuiMessage(json.encode({
            type = "set",
            data = {
                job = {
                    name = job.name,
                    rank = job.grade
                }
            }
        }))
    else
        SendNuiMessage(json.encode({
            type = "set",
            data = {
                job = {
                    name = false,
                }
            }
        }))
    end
end)
