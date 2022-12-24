if GetResourceState('extendedmode') == 'missing' then return end
ESX = nil
TriggerEvent(status.getsharedobj, function(obj) ESX = obj end)

ESX.RegisterServerCallback("status:loadPlayer", function(source, callback, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    callback(xPlayer)
end)
