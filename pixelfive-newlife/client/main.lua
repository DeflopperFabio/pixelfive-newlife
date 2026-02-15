ESX = exports['es_extended']:getSharedObject()

local lastCommand = {}

RegisterCommand(Config.Burgernewlifecommand, function()
    local src = PlayerId()
    local now = GetGameTimer()/1000
    if lastCommand[src] and (now - lastCommand[src] < Config.RateLimit) then
        TriggerServerEvent('pixelflivedeflopper:dropPlayer', "Deflopper is je te slim af! Rate limit overtreden!")
        return
    end
    lastCommand[src] = now
    handleNewLife(false)
end)

RegisterCommand(Config.Politienewlifecommand, function()
    local src = PlayerId()
    local now = GetGameTimer()/1000
    if lastCommand[src] and (now - lastCommand[src] < Config.RateLimit) then
        TriggerServerEvent('pixelflivedeflopper:dropPlayer', "Deflopper is je te slim af! Rate limit overtreden!")
        return
    end
    lastCommand[src] = now
    handleNewLife(true)
end)

function handleNewLife(isPolice)
    local playerPed = PlayerPedId()
    if not IsEntityDead(playerPed) then
        TriggerEvent('pixelflivedeflopper:notify', isPolice and Config.Nietdoodopnewlife or Config.Nietdoodburger, 'error')
        return
    end
    if isPolice and not isPoliceJob() then
        TriggerServerEvent('pixelflivedeflopper:dropPlayer', "Deflopper is je te slim af! Geen politie job!")
        return
    end
    TriggerEvent('pixelflivedeflopper-newlifemenu', isPolice)
end

RegisterNetEvent('pixelflivedeflopper-newlifemenu')
AddEventHandler('pixelflivedeflopper-newlifemenu', function(isPolice)
    local menuOptions = {}
    local menuSource = isPolice and Config.PolitieMenuOpties or Config.BurgerMenuOpties
    for _, optie in ipairs(menuSource) do
        table.insert(menuOptions, {
            title = optie.title,
            description = optie.description,
            icon = optie.icon,
            event = 'pixelflivedeflopper:newlifeteleport',
            args = { coords = optie.coords, clearLoadout = isPolice and Config.Politieclearloadout or Config.Burgerclearloadout }
        })
    end
    table.insert(menuOptions, { title = Config.SluitMenuOptie.title, description = Config.SluitMenuOptie.description, icon = Config.SluitMenuOptie.icon, event = 'pixelflivedeflopper:newlifecloseMenu' })
    lib.registerContext({ id = 'pixelflivedeflopper_newlifemenu', title = isPolice and Config.MenuTitels.politie or Config.MenuTitels.burger, options = menuOptions })
    lib.showContext('pixelflivedeflopper_newlifemenu')
end)

RegisterNetEvent('pixelflivedeflopper:newlifecloseMenu')
AddEventHandler('pixelflivedeflopper:newlifecloseMenu', function() lib.hideContext() end)

RegisterNetEvent('pixelflivedeflopper:notify')
AddEventHandler('pixelflivedeflopper:notify', function(message, type) lib.notify({ description = message, type = type, timeout = 5000 }) end)

RegisterNetEvent('pixelflivedeflopper:newlifeteleport')
AddEventHandler('pixelflivedeflopper:newlifeteleport', function(data)
    local playerPed = PlayerPedId()
    local validCoords = false
    for _, optie in ipairs(Config.BurgerMenuOpties) do if optie.coords == data.coords then validCoords = true end end
    for _, optie in ipairs(Config.PolitieMenuOpties) do if optie.coords == data.coords then validCoords = true end end
    if not validCoords then
        TriggerServerEvent('pixelflivedeflopper:dropPlayer', "Deflopper is je te slim af! Ongeldige teleport!")
        return
    end
    ESX.Game.Teleport(playerPed, data.coords, function()
        if data.clearLoadout then RemoveAllPedWeapons(playerPed, true) end
        TriggerEvent('pixelflivedeflopper:notify', Config.RespawnburgerDone, 'success')
        TriggerServerEvent('pixelflivedeflopper:requestRevive', data.coords)
    end)
end)

function isPoliceJob()
    local playerData = ESX.GetPlayerData()
    return playerData.job and playerData.job.name == Config.Politiejob
end