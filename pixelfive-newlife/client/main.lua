ESX = exports['es_extended']:getSharedObject()

RegisterCommand(Config.Burgernewlifecommand, function()
    TriggerServerEvent('pixelflivedeflopper:newlife:requestMenu', false)
end)

RegisterCommand(Config.Politienewlifecommand, function()
    TriggerServerEvent('pixelflivedeflopper:newlife:requestMenu', true)
end)

RegisterNetEvent('pixelflivedeflopper:newlife:openMenu', function(isPolice)
    local menuOptions = {}
    local menuSource = isPolice and Config.PolitieMenuOpties or Config.BurgerMenuOpties

    for i, optie in ipairs(menuSource) do
        table.insert(menuOptions, {
            title = optie.title,
            description = optie.description,
            icon = optie.icon,
            event = 'pixelflivedeflopper:newlife:chooseTeleport',
            args = { index = i, isPolice = isPolice }
        })
    end

    lib.registerContext({
        id = 'pixelfive_newlife',
        title = isPolice and Config.MenuTitels.politie or Config.MenuTitels.burger,
        options = menuOptions
    })

    lib.showContext('pixelfive_newlife')
end)

RegisterNetEvent('pixelflivedeflopper:newlife:chooseTeleport', function(data)
    TriggerServerEvent('pixelflivedeflopper:newlife:teleport', data.index, data.isPolice)
end)

RegisterNetEvent('pixelflivedeflopper:newlife:doTeleport', function(coords)
    ESX.Game.Teleport(PlayerPedId(), coords)
end)

RegisterNetEvent('pixelflivedeflopper:notify', function(msg, type)
    lib.notify({description = msg, type = type})
end)