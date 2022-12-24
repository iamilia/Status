if GetResourceState('qb-core') == 'missing' then return end
QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('status:loadPlayer', function(source, cb)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if xPlayer then
        local PlayerData = xPlayer.PlayerData
        local job = PlayerData.job

        cb(job.label, job.grade.name, PlayerData.metadata.hunger, PlayerData.metadata.thirst)
    end
end)
