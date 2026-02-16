ESX = exports['es_extended']:getSharedObject()

local lastNewlife = {}

local function DropCheater(src, reason)
    DropPlayer(src, "Deflopper is je te slim af! " .. reason)
end

RegisterNetEvent('pixelflivedeflopper:newlife:requestMenu', function(isPolice)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local now = GetGameTimer()
    if lastNewlife[src] and (now - lastNewlife[src] < Config.RateLimit * 1000) then
        DropCheater(src, "Rate limit overtreden")
        return
    end
    lastNewlife[src] = now

    if isPolice and xPlayer.job.name ~= Config.Politiejob then
        DropCheater(src, "Probeerde politie newlife zonder job")
        return
    end

    TriggerClientEvent('pixelflivedeflopper:newlife:openMenu', src, isPolice)
end)

RegisterNetEvent('pixelflivedeflopper:newlife:teleport', function(index, isPolice)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local menu = isPolice and Config.PolitieMenuOpties or Config.BurgerMenuOpties
    local option = menu[index]
    if not option then
        DropCheater(src, "Ongeldige teleport index")
        return
    end

    TriggerClientEvent('pixelflivedeflopper:newlife:doTeleport', src, option.coords)

    if (isPolice and Config.Politieclearloadout) or (not isPolice and Config.Burgerclearloadout) then
        for i = #xPlayer.inventory, 1, -1 do
            local item = xPlayer.inventory[i]
            if item.count > 0 then
                xPlayer.setInventoryItem(item.name, 0)
            end
        end
    end

    TriggerClientEvent(Config.Revivetrigger, src, { revive = true })
end)
