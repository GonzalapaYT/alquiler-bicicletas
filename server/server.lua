ESX 					= nil
ESX = exports["es_extended"]:getSharedObject()
local precioAlquiler, nombreBici 		= nil, nil
local resourceVersion			= Config.Version


RegisterServerEvent('gonzalapa-alquilerbicis:dineroMano')
AddEventHandler('gonzalapa-alquilerbicis:dineroMano', function(tipoBici, tiempoAlquiler)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local playerMoney = xPlayer.getMoney()
	local paid = false

	if tipoBici == 'cruiser' then
		precioAlquiler = Config.Precios.cruiser
		nombreBici = Config.NombresBicis.cruiser
	elseif tipoBici == 'bmx' then
		precioAlquiler = Config.Precios.bmx
		nombreBici = Config.NombresBicis.bmx
	elseif tipoBici == 'fixter' then
		precioAlquiler = Config.Precios.fixter
		nombreBici = Config.NombresBicis.fixter
	elseif tipoBici == 'scorcher' then
		precioAlquiler = Config.Precios.scorcher
		nombreBici = Config.NombresBicis.scorcher
	elseif tipoBici == 'tribike' then
		precioAlquiler = Config.Precios.tribike
		nombreBici = Config.NombresBicis.tribike
	elseif tipoBici == 'tribike2' then
		precioAlquiler = Config.Precios.tribike2
		nombreBici = Config.NombresBicis.tribike2
	elseif tipoBici == 'tribike3' then
		precioAlquiler = Config.Precios.tribike3
		nombreBici = Config.NombresBicis.tribike3
	end

	if playerMoney >= precioAlquiler * tiempoAlquiler then
		xPlayer.removeMoney(precioAlquiler * tiempoAlquiler)
		paid = true
		notification('Has ~g~alquilado~s~ una ~b~' .. nombreBici .. ' durante~y~ '..tiempoAlquiler..' minuto(s) ~s~por: ~g~' .. Config.Moneda .. ' ' .. precioAlquiler * tiempoAlquiler) 
	else
		notification('Que haces ~r~no~s~ tienes suficiente dinero ~g~' .. Config.Moneda .. ' ~y~' .. precioAlquiler * tiempoAlquiler - playerMoney .. '~s~ ~r~faltan!~s~')
	end

	if paid then
		TriggerClientEvent('gonzalapa-alquilerbicis:sacarBici', source, tipoBici, tiempoAlquiler)
	end
end)

function notification(text)
	TriggerClientEvent('esx:showNotification', source, text)
end

if Config.comprobarUpdates then
	local version = resourceVersion
	local resourceName = GetCurrentResourceName()
	
	Citizen.CreateThread(function()
		function checkVersion(err, response, headers)
			if err == 200 then
				local data = json.decode(response)
				if version ~= data.bikeRentalVersion and tonumber(version) < tonumber(data.bikeRentalVersion) then
					print("El [^2"..resourceName.."^7] resource esta ^1desactualizado^7.\nUltima versión: ^2"..data.bikeRentalVersion.."\n^7Versión instalada: ^1"..version.."\n^7Descarga aquí la ultima versión: https://github.com/GonzalapaYT/alquiler-bicicletas")
				elseif tonumber(version) > tonumber(data.bikeRentalVersion) then
					print("El [^2"..resourceName.."^7] resource parece ser ^1mayor^7 que la última versión. Revisa eso en: https://github.com/GonzalapaYT/alquiler-bicicletas")
				else
					print("El [^2"..resourceName.."^7] resource esta ^2en la ultima versión: ^7! (^2v" .. version .."^7)")
				end
			else
				print("^1Comprobación de version fallida!^7 HTTP Codigo de error: "..err)
			end
			
			SetTimeout(3600000, checkVersionHTTPRequest)
		end
		function checkVersionHTTPRequest()
			PerformHttpRequest("https://raw.githubusercontent.com/hoaaiww/version/main/versions.json", checkVersion, "GET")
		end
		checkVersionHTTPRequest()
	end)
end
