ESX = exports['es_extended']:getSharedObject()

function dropPlayer(src, reason)
    DropPlayer(src, reason or "Deflopper is je te slim af!")
end

RegisterNetEvent('pixelflivedeflopper:dropPlayer')
AddEventHandler('pixelflivedeflopper:dropPlayer', function(reason)
    local src = source
    dropPlayer(src, reason)
end)

RegisterNetEvent('pixelflivedeflopper:requestRevive', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        DropPlayer(src, "Deflopper is je te slim af!")
        return
    end

    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then
        DropPlayer(src, "Deflopper is je te slim af!")
        return
    end

    TriggerClientEvent(Config.Revivetrigger, src, { revive = true })
end)

RegisterNetEvent('pixelflivedeflopper:clearInventory')
AddEventHandler('pixelflivedeflopper:clearInventory', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then dropPlayer(src, "Deflopper is je te slim af!") return end
    if #xPlayer.inventory > 100 then dropPlayer(src, "Deflopper is je te slim af! Exploit!") return end
    for i = #xPlayer.inventory, 1, -1 do
        local item = xPlayer.inventory[i]
        if item.count > 0 then xPlayer.setInventoryItem(item.name, 0) end
    end
end)