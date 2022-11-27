ESX                                                                                 = nil
ESX = exports["es_extended"]:getSharedObject()
local PlayerData                                                                    = {}
local onBike, timerMinutesEnabled, timerMinutes, timerSeconds, counter, timer       = false, false, 0, 0, false, 0

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)
	
Citizen.CreateThread(function()
	for k,v in pairs(Config.PuntosAlquiler) do
		for i = 1, #v.Alquiler, 1 do
            blip = AddBlipForCoord(v.Alquiler[i].x, v.Alquiler[i].y, v.Alquiler[i].z)
            SetBlipSprite(blip, Config.BlipYPunto.IdBlip)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, Config.BlipYPunto.tamanoBlip)
            SetBlipColour(blip, Config.BlipYPunto.colorBlip)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(Config.BlipYPunto.nombreBlip)
            EndTextCommandSetBlipName(blip)
        end
	end
end)

Citizen.CreateThread(function()
    while true do
        if onBike == false then
            for k,v in pairs(Config.PuntosAlquiler) do
                for i = 1, #v.Alquiler, 1 do
                    local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                    local distance = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.Alquiler[i].x, v.Alquiler[i].y, v.Alquiler[i].z)

                    if distance < Config.BlipYPunto.distanciaPunto then
                        DrawMarker(Config.BlipYPunto.tipoPunto, v.Alquiler[i].x, v.Alquiler[i].y, v.Alquiler[i].z, 0, 0, 0, 0, 0, 0, Config.BlipYPunto.tamanoPunto.x, Config.BlipYPunto.tamanoPunto.y, Config.BlipYPunto.tamanoPunto.z, Config.BlipYPunto.colorPunto.r, Config.BlipYPunto.colorPunto.g, Config.BlipYPunto.colorPunto.b, Config.BlipYPunto.colorPunto.a, Config.BlipYPunto.puntoSaltando, Config.BlipYPunto.puntoMirandoPlayer, 0, Config.BlipYPunto.puntoRotando)
                    end
                    if distance <= 0.5 then
                        hintToDisplay('Pulsa ~INPUT_CONTEXT~ para ~b~alquilar~s~ una bicicleta')
                        
                        if IsControlJustPressed(0, 38) then
                            OpenBikeMenu()
                        end			
                    end
                end
            end
        end
        Wait(0)
    end
end)

RegisterNetEvent('alquiler-bicicletas:sacarBici')
AddEventHandler('alquiler-bicicletas:sacarBici', function(tipoBici, tiempoAlquiler)
    local player = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(player, false)
    local playerHeading = GetEntityHeading(player, false)

    ESX.Game.SpawnVehicle(GetHashKey(tipoBici), playerCoords, playerHeading, function(bike)
        TaskWarpPedIntoVehicle(player, bike, -1)
        if (IsEntityAMissionEntity(bike) == false) then
            SetEntityAsMissionEntity(bike, true, true)
        end
        timerSeconds = 60
        timerMinutes = timer
        timer = timer * 60
        if timer > 60 then
            timerMinutesEnabled = true
        end
        onBike = true

        local renting = timer * 1000
        local waiting = timer / 60 * 1000

        Wait(waiting)
        Wait(renting)

        onBike = false
        if IsPedInVehicle(player, bike, true) then
            FreezeEntityPosition(bike, true)
            notification(Config.AjustesNotificaciones.titulo, Config.AjustesNotificaciones.subtitulo, Config.AjustesNotificaciones.mensaje, Config.AjustesNotificaciones.icono, Config.AjustesNotificaciones.indexIcono)
            TaskLeaveVehicle(player, bike, 1)
            Wait(1000)
            DeleteVehicle(bike)
            counter = false
	    timerMinutesEnabled = false
        else
            notification(Config.AjustesNotificaciones.titulo, Config.AjustesNotificaciones.subtitulo, Config.AjustesNotificaciones.mensaje, Config.AjustesNotificaciones.icono, Config.AjustesNotificaciones.indexIcono)
            DeleteVehicle(bike)
            counter = false
            timerMinutesEnabled = false
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        if onBike then
            counter = true
            if timerSeconds <= 59 then
                timerSeconds = timerSeconds - 1
            elseif timerSeconds == 60 then
                timerSeconds = timerSeconds - 1
                timerMinutes = timerMinutes - 1
            end

            if timerMinutesEnabled and timerSeconds == -1 then
                timerSeconds = 59
                timerMinutes = timerMinutes - 1
            end

            if timerMinutesEnabled and timerMinutes == 0 then
                timerMinutesEnabled = false
                timerSeconds = 59
                timerMinutes = nil
            end

            if timerSeconds == 0 and not timerMinutesEnabled then
                counter = false
                timerSeconds = 0
                timerMinutes = 0
            end

            Citizen.Wait(1000)
        else
            Citizen.Wait(0)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if onBike and counter then
            if timerSeconds == nil then
                Citizen.Wait(100)
            else
                if timerMinutesEnabled then
                    DrawText2D(0.505, 0.95, 1.0,1.0,0.4, "Tiempo de alquiler restante: ~b~" ..timerMinutes.. " minuto(s) " ..timerSeconds.. " segundo(s)", 255, 255, 255, 255)
                else
                    DrawText2D(0.505, 0.95, 1.0,1.0,0.4, "Tiempo restante de alquiler de bicicleta: ~b~" ..timerSeconds.. " segundo(s)", 255, 255, 255, 255)
                end
            end
        end
    end
end)

function OpenBikeMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'bike_menu',
        {
            title    = 'Alquiler Bicicletas',
            align    = 'center',
            elements = {
                {label = Config.NombresBicis.cruiser .. ' (<span style="color:lightgreen;">'   .. Config.Moneda .. ' ' .. Config.Precios.cruiser .. '</span>/<span style="color:lightblue;">Minuto</span>)',      value = 'cruiser'},
		        {label = Config.NombresBicis.bmx .. ' (<span style="color:lightgreen;">'       .. Config.Moneda .. ' ' .. Config.Precios.bmx.. '</span>/<span style="color:lightblue;">Minuto</span>)',          value = 'bmx'},
		        {label = Config.NombresBicis.fixter .. ' (<span style="color:lightgreen;">'    .. Config.Moneda .. ' ' .. Config.Precios.fixter.. '</span>/<span style="color:lightblue;">Minuto</span>)',        value = 'fixter'},
		        {label = Config.NombresBicis.scorcher .. ' (<span style="color:lightgreen;">'  .. Config.Moneda .. ' ' .. Config.Precios.scorcher.. '</span>/<span style="color:lightblue;">Minuto</span>)',      value = 'scorcher'},
                {label = Config.NombresBicis.tribike .. ' (<span style="color:lightgreen;">'   .. Config.Moneda .. ' ' .. Config.Precios.tribike.. '</span>/<span style="color:lightblue;">Minuto</span>)',       value = 'tribike'},
                {label = Config.NombresBicis.tribike2 .. ' (<span style="color:lightgreen;">'  .. Config.Moneda .. ' ' .. Config.Precios.tribike2.. '</span>/<span style="color:lightblue;">Minuto</span>)',      value = 'tribike2'},
                {label = Config.NombresBicis.tribike3 .. ' (<span style="color:lightgreen;">'  .. Config.Moneda .. ' ' .. Config.Precios.tribike3.. '</span>/<span style="color:lightblue;">Minuto</span>)',      value = 'tribike3'},
            }
        },
        function(data, menu)
            if data.current.value == 'cruiser' then
				ESX.UI.Menu.CloseAll()
                rentBike('cruiser')
            elseif data.current.value == 'bmx' then
                ESX.UI.Menu.CloseAll()
                rentBike('bmx')
            elseif data.current.value == 'fixter' then
                ESX.UI.Menu.CloseAll()
                rentBike('fixter')
            elseif data.current.value == 'scorcher' then
                ESX.UI.Menu.CloseAll()
                rentBike('scorcher')
            elseif data.current.value == 'tribike' then
                ESX.UI.Menu.CloseAll()
                rentBike('tribike')
            elseif data.current.value == 'tribike2' then
                ESX.UI.Menu.CloseAll()
                rentBike('tribike2')
            elseif data.current.value == 'tribike3' then
                ESX.UI.Menu.CloseAll()
                rentBike('tribike3')
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function rentBike(bikeType)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menu-alquiler',
        {
        title = ('Cuanto tiempo quieres alquilar la bicicleta? (en minutos)')
        },
        function(data, menu)
            local amount = tonumber(data.value)
            if amount == nil or amount >= 59 then
                ESX.ShowNotification('~r~Error~s~ de cantidad o quieres alquilarla por ~r~mucho tiempo~s~! (min: ~o~1~s~, max: ~g~59~s~)')
            elseif amount == 0 then
                menu.close()
            else
                menu.close()
                timer = amount
                TriggerServerEvent('alquiler-bicicletas:dineroMano', bikeType, amount)
            end
        end,
        function(data, menu)
            menu.close()
    end)
end

function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function DrawText2D(x, y, width, height, scale, text, r, g, b, a, outline)
	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end

function notification(title, subject, msg, icon, iconIndex)
    ESX.ShowAdvancedNotification(title, subject, msg, icon, iconIndex)
end