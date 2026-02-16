ESX = exports['es_extended']:getSharedObject()

RegisterCommand(Config.Burgernewlifecommand, function()
    local ped = PlayerPedId()
    if not IsEntityDead(ped) then
        TriggerEvent('pixelflivedeflopper:notify', Config.Nietdoodburger, 'error')
        return
    end
    TriggerServerEvent('pixelflivedeflopper:newlife:requestMenu', false)
end)

RegisterCommand(Config.Politienewlifecommand, function()
    local ped = PlayerPedId()
    if not IsEntityDead(ped) then
        TriggerEvent('pixelflivedeflopper:notify', Config.Nietdoodopnewlife, 'error')
        return
    end
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
            args = {
                index = i,
                isPolice = isPolice
            }
        })
    end

    table.insert(menuOptions, {
        title = Config.SluitMenuOptie.title,
        description = Config.SluitMenuOptie.description,
        icon = Config.SluitMenuOptie.icon,
        event = 'pixelflivedeflopper:newlife:closeMenu'
    })

    lib.registerContext({
        id = 'pixelfive_newlife_menu',
        title = isPolice and Config.MenuTitels.politie or Config.MenuTitels.burger,
        options = menuOptions
    })

    lib.showContext('pixelfive_newlife_menu')
end)

RegisterNetEvent('pixelflivedeflopper:newlife:chooseTeleport', function(data)
    lib.hideContext()
    TriggerServerEvent('pixelflivedeflopper:newlife:teleport', data.index, data.isPolice)
end)

RegisterNetEvent('pixelflivedeflopper:newlife:closeMenu', function()
    lib.hideContext()
end)

RegisterNetEvent('pixelflivedeflopper:newlife:doTeleport', function(coords)
    ESX.Game.Teleport(PlayerPedId(), coords)
    TriggerEvent('pixelflivedeflopper:notify', Config.RespawnburgerDone, 'success')
end)

RegisterNetEvent('pixelflivedeflopper:notify', function(message, type)
    lib.notify({
        description = message,
        type = type,
        timeout = 5000
    })
end)
