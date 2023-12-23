Main = {}
local inside = false

CreateThread(function()
    Main:Int()
end)

function Main:Int()
    exports['qb-target']:AddTargetModel(Config.TrashCans.Model, {
        options = {
            {
                event = 'bbv:hideintrash:enter',
                type = 'client',
                icon = "fa-solid fa-trash-can",
                label = Lang.Hide,
            },
            {
                event = 'bbv:hideintrash:exit',
                type = 'client',
                icon = "fa-solid fa-trash-can",
                label = Lang.Exit,
            },
        },
        distance = Config.TrashCans.Distance,
    })
end

RegisterNetEvent('bbv:hideintrash:enter',function()
    Main:Enter()
end)

RegisterNetEvent('bbv:hideintrash:exit',function()
    Main:Exit()
end)

function Main:Enter()
    if inside then return end
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(PlayerPedId())
    for k,v in pairs(Config.TrashCans.Model) do
        local objectId = GetClosestObjectOfType(pedCoords, 1.0, Config.TrashCans.Model[k], false)
        if DoesEntityExist(objectId) then
            inside = true
            local objectcoords = GetEntityCoords(objectId)
            oldcoords = GetEntityCoords(ped)
            SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z, 0.0, 0.0, 0.0)
            FreezeEntityPosition(ped, true)
            SetEntityVisible(ped, false)
            return
        end
    end
end

function Main:Exit()
    local ped = PlayerPedId()
    if not inside then 
        self:Notify(Lang.NotInside)
        return
    end
    inside = false
    SetEntityCoords(ped,oldcoords.x,oldcoords.y,oldcoords.z - 1)
    FreezeEntityPosition(ped, false)
    SetEntityVisible(ped, true)
end


function Main:Notify(msg)
    local message = msg
    if message == nil then 
        return 
    end

    local Notif = {
        text = message,
        color = color or 130,
        flash = flash or false,
        save = saveToBrief or true 
    }

    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(Notif.text)
    ThefeedSetNextPostBackgroundColor(Notif.color)
    EndTextCommandThefeedPostTicker(Notif.flash, Notif.save)
end
