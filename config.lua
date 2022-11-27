Config = {}
Config.PuntosAlquiler = {
    Lugares = {
        Alquiler = { -- Lugares de alquiler
            {x = 221.25 , y = -857.07 , z = 30.20}, -- Garaje Central
            {x = -359.71 , y = -127.8 , z = 37.7}, -- Mecánico
            {x = 275.66 , y = -599.16 , z = 42.15}, -- Hospital
            {x = 1854.07 , y = 3752.85 , z = 33.12}, -- Sandy Shores
            {x = -93.23 , y = 6325.83 , z = 31.49}, -- Paleto Bay
            {x = -1209.77 , y = -1553.22 , z = 4.35} -- Gimnasio
        }
    },
}

Config.Precios = { -- Precio de las bicis por minuto
    cruiser     = 3,
    bmx         = 5,
    fixter      = 5,
    scorcher    = 6,
    tribike     = 7,
    tribike2    = 10,
    tribike3    = 10
}

Config.Moneda = '€'

Config.NombresBicis = { -- Nombres de las bicis     - /!\ NO PUEDES METER "VEHICULOS"
    cruiser     = 'Bicicleta Común',
    bmx         = 'BMX',
    fixter      = 'Bicicleta de Ciudad',
    scorcher    = 'Bicicleta Off-Road',
    tribike     = 'Bicicleta Deportiva (Amarilla)',
    tribike2    = 'Bicicleta Deportiva (Roja)',
    tribike3    = 'Bicicleta Deportiva (Azul)'
}

Config.AjustesNotificaciones = {
    titulo       = 'Alquiler Canarios',  -- Titulo
    subtitulo     = 'Alquiler de bicicletas Canarias',  -- Subtitulo
    mensaje     = 'Se ta acabaoh el tiempo!', -- Mensaje Principal
    icono        = 'CHAR_BIKESITE', -- Icono del mensaje.    Puedes buscar otros: https://wiki.gtanet.work/index.php?title=Notification_Pictures
    indexIcono   = 1  -- Icono junto al título.             Puedes buscar otros: https://docs.esx-framework.org/legacy/Client/functions/showadvancednotification/
}

Config.BlipYPunto = {

    --  Blip 
    nombreBlip    = 'Alquiler de Bicicletas',
    colorBlip  = 66,  -- Color del Blip. - Puedes buscar otros: https://docs.fivem.net/docs/game-references/blips/#blip-colors
    IdBlip      = 226,  -- Icono del blip. - Puedes buscar otros: https://docs.fivem.net/docs/game-references/blips/
    tamanoBlip    = 1.0,  -- Tamaño del blip.

    -- Punto
    distanciaPunto  = 20, -- Distancia desde la que los jugadores pueden ver el punto (en metros)
    tipoPunto      = 21, -- Tipo de punto. - Puedes buscar otros: https://docs.fivem.net/docs/game-references/markers/
    tamanoPunto      = { x = 0.4, y = 0.4, z = 0.4}, -- Tamaño del punto
    colorPunto    = { r = 240, g = 203, b = 87, a = 150}, -- Color del punto
    puntoSaltando   = false, -- El punto "salta"
    puntoRotando    = true, -- El punto rota 360°
    puntoMirandoPlayer    = false, -- El Punto siempre te mira (Solo funciona si puntoRotando esta en false)
}

Config.comprobarUpdates  = true -- Revisar actualizaciones? - Recomendables
Config.Version          = '1.4' -- No editar
