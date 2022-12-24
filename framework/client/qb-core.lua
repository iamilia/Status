if GetResourceState('qb-core') == 'missing' then return end
local QBCore = exports['qb-core']:GetCoreObject()

local success, result = pcall(function()
    return QBCore.Functions.GetPlayerData()
end)

local playerData = success and result or {}

health, armor, id, hunger, thirst = 0, 0, 0, 0, 0
isMinimize, showHud = false, true

--[[ Function ]]
local SendNuiMessage = SendNuiMessage
ToggelHud = function()
    if isMinimize then
        QBCore.Functions.TriggerCallback('status:loadPlayer', function(label, grade, food, thirst)
            local datas = {
                id = GetPlayerServerId(PlayerId()),
                name = GetPlayerName(PlayerId()),
                water = thirst,
                food = food,
                heal = tonumber(health),
                armor = tonumber(armor),
                cash = tonumber(comma_value(cashAmount)),
                job = {
                    name = label,
                    rank = grade
                }
            }
            SendNUIMessage({
                type = "all",
                size = "full",
                data = datas
            })
        end)
        isMinimize = false
    else
        QBCore.Functions.TriggerCallback('status:loadPlayer', function(label, grade, food, thirst)
            local datas = {
                id = GetPlayerServerId(PlayerId()),
                name = GetPlayerName(PlayerId()),
                water = thirst,
                food = food,
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

function comma_value(amount)
    local formatted = amount

    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')

        if k == 0 then
            break
        end
    end

    return formatted
end



--[[ Thread ]]

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1500)
        local sPly = PlayerId()
        QBCore.Functions.TriggerCallback('status:loadPlayer', function(label, grade, food, thirst)
            SendNuiMessage(json.encode(
                {
                    type = "set",
                    data = {
                        id = GetPlayerServerId(sPly),
                        name = GetPlayerName(sPly),
                        water = thirst,
                        food = food,
                        job = {
                            name = label,
                            rank = grade
                        }
                    }
                }
            ))
        end)
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


RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    if source == '' then return end
    playerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    if source == '' then return end
    playerData = val
end)

RegisterNetEvent('hud:client:OnMoneyChange', function(type, amount, isMinus)
    if source == '' then return end
    cashAmount = playerData.money['cash']
    SendNuiMessage(json.encode(
        {
            type = "set",
            data = {
                cash = tonumber(comma_value(cashAmount))
            }
        }
    ))
end)
