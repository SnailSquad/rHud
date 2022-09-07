ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    print('The resource ^2rHud^0 has been ^4initialized^0 !')
end)

RegisterServerEvent('rHud:getInfo', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xMoney = xPlayer.getAccount('money').money
    local xDirty = xPlayer.getAccount('black_money').money
    local xJob = xPlayer.getJob().label
    TriggerClientEvent("rHud:setInfo", _source, xMoney, xDirty, xJob)
end)