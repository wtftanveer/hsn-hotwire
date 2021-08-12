ESX = nil

Keys = {}
PlayerData = {}
SearchedVeh = {}
local disableF = false

Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports['es_extended']:getSharedObject()
        Citizen.Wait(1)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('hsn-hotwire:client:addKeys')
AddEventHandler('hsn-hotwire:client:addKeys', function(data)
    Keys[data] = true
end)

RegisterNetEvent('hsn-hotwire:client:removeKeys')
AddEventHandler('hsn-hotwire:client:removeKeys',function(plate)
    Keys[plate] = nil
end)

Citizen.CreateThread(function()
    while true do
        local wait = 1000
        if IsPedInAnyVehicle(PlayerPedId(),false)  then
            local vehicle = GetVehiclePedIsIn(PlayerPedId())
            local Plate = GetVehicleNumberPlateText(vehicle)
            local vehicleCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 1.25, 0.35)
            if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() then
                if Keys[Plate] ~= true then
                    wait = 2
                    if SearchedVeh[Plate] ~= true then
			TriggerEvent(Config.TextUI..':ShowUI', '<h4>[H] Hotwire | [Z] Search</h4>', 'rgb(45, 52, 54)')
			--TriggerEvent(Config.TextUI..':ShowUI', 'show', '[H] Hotwire | [Z] Search')
                    else
			TriggerEvent(Config.TextUI..':ShowUI', '<h4>[H] Hotwire</h4>', 'rgb(45, 52, 54)')
			--TriggerEvent(Config.TextUI..':ShowUI', 'show', '[H] Hotwire')
                    end
                    if IsControlJustPressed(1, 74) then--H
                        ESX.TriggerServerCallback('hsn-hotwire:lockpick', function(data)
                        TriggerServerEvent('hsn-hotwire:lockpick')
						exports.rprogress:MiniGame({
							Async = true,
							Difficulty = "Easy",
							Easing = "easeLinear",
							Color = "rgba(255, 255, 255, 1.0)",
							BGColor = "rgba(0, 0, 0, 0.4)",
							Animation = {
								animationDictionary = "mini@repair",
								animationName = "fixing_a_player",
								flag = 49, 
							},
							DisableControls = {
								Mouse = false,
								Player = true,
								Vehicle = true,
							}, 
							onComplete = function(success)
								if success then
									TriggerServerEvent('hsn-hotwire:addKeys',Plate)
									SetVehicleEngineOn(vehicle,true)
									exports['mythic_notify']:SendAlert('inform', 'You have successfully started the vehicle!')
								else
									exports['mythic_notify']:SendAlert('inform', 'You failed to hotwire!')
								end    
							end
						})
                        end, "lockpick")
                    end
                    if IsControlJustPressed(1, 20) then --Z
                        if SearchedVeh[Plate] ~= true then
                            SearchVehicle(Plate)
                        end
                    end
                end
            end
        end
        Citizen.Wait(wait)  
    end
end)

Citizen.CreateThread(function()
    while true do
        local wait = 1000
        if IsPedInAnyVehicle(PlayerPedId(),false)  then
            local vehicle = GetVehiclePedIsIn(PlayerPedId())
            local Plate = GetVehicleNumberPlateText(vehicle)
            if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() then
                if Keys[Plate] == true then
                    wait = 2
                        if SetVehicleEngineOn(vehicle, true) then
			    TriggerEvent(Config.TextUI..':HideUI')
                        end
                end
            end
        end
        Citizen.Wait(wait)  
    end
end)

RegisterCommand('givekeys', function()
    local vehicle = ESX.Game.GetVehicleInDirection()
    local Plate = GetVehicleNumberPlateText(vehicle)
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if vehicle ~= nil then
        if Keys[Plate] == true then
            if closestPlayer ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('hsn-hotwire:server:giveKeys',GetPlayerServerId(closestPlayer), Plate)
            else
                exports['mythic_notify']:SendAlert('inform', 'There is no one nearby!')
            end
        else
            exports['mythic_notify']:SendAlert('inform', 'You do not have the keys to this vehicle!')
        end
    else
        exports['mythic_notify']:SendAlert('inform', 'You have to look towards the vehicle!')
    end
end)

Citizen.CreateThread(function()
    while true do
        local wait = 750
        local veh = GetVehiclePedIsIn(PlayerPedId() , false)
        local Plate = GetVehicleNumberPlateText(veh)
        if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() and Keys[Plate] ~= true then
            wait = 6
            SetVehicleEngineOn(veh, false)
        end
        Citizen.Wait(wait)
    end
end)

SearchVehicle = function(plate)
    SearchedVeh[plate] = true
	exports.rprogress:Custom({
		Async = true,
		Duration = 12500,
		Easing = "easeLinear",
		Label = "Searching Vehicle...",
	    	Animation = {
			animationDictionary = "mini@repair",
			animationName = "fixing_a_player",
			flag = 49, 
		},
		DisableControls = {
			Mouse = false,
			Player = true,
			Vehicle = true,
		},     
    onComplete = function()
        TriggerServerEvent('hsn-hotwire:server:SearchVeh', plate)
    end
})
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        if IsControlJustPressed(1,182) then
            local coords = GetEntityCoords(PlayerPedId())
            vehicle = ESX.Game.GetClosestVehicle()
            local Plate = GetVehicleNumberPlateText(vehicle)
            if Keys[Plate] == true then
                local lock = GetVehicleDoorLockStatus(vehicle)
                if lock == 1 or lock == 0 then
                    TaskPlayAnim(PlayerPedId(), "anim@mp_player_intmenu@key_fob@", "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
                    SetVehicleDoorShut(vehicle, 0, false)
                    SetVehicleDoorShut(vehicle, 1, false)
                    SetVehicleDoorShut(vehicle, 2, false)
                    SetVehicleDoorShut(vehicle, 3, false)
                    SetVehicleDoorsLocked(vehicle, 2)
                    PlayVehicleDoorCloseSound(vehicle, 1)
                    SetVehicleLights(vehicle, 2)
                    SetVehicleLights(vehicle, 0)
                    SetVehicleLights(vehicle, 2)
                    SetVehicleLights(vehicle, 0)
                    exports['mythic_notify']:SendAlert('inform', 'The vehicle is locked.')
                elseif lock == 2 then
                    TaskPlayAnim(PlayerPedId(), "anim@mp_player_intmenu@key_fob@", "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
                    SetVehicleDoorsLocked(vehicle, 1)
					PlayVehicleDoorOpenSound(vehicle, 0)
					SetVehicleLights(vehicle, 2)
					SetVehicleLights(vehicle, 0)
					SetVehicleLights(vehicle, 2)
                    SetVehicleLights(vehicle, 0)
                    exports['mythic_notify']:SendAlert('inform', 'The vehicle is unlocked.')
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local wait = 1250
        if GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= 0 then 
            local curveh = GetVehiclePedIsTryingToEnter(PlayerPedId())
            local pedDriver = GetPedInVehicleSeat(curveh, -1)
            local plate = GetVehicleNumberPlateText(curveh)
            if Keys[plate] ~= PlayerData.identifier and DoesEntityExist(pedDriver) and IsEntityDead(pedDriver) and not IsPedAPlayer(pedDriver)  then
                wait = 1
				exports.rprogress:Custom({
					Async = true,
					Duration = 2000,
					Easing = "easeLinear",
					Label = "Getting Key...",
					DisableControls = {
						Mouse = false,
						Player = true,
						Vehicle = true,
					},    
				onComplete = function()
					TriggerServerEvent('hsn-hotwire:addKeys',plate)
					exports['mythic_notify']:SendAlert('inform', 'You got the car keys!')
				end
				})
            end
        end
        Citizen.Wait(wait)
    end
end)

AddKeys = function(plate)
    if plate ~= nil then
        TriggerServerEvent('hsn-hotwire:addKeys',plate)
    end
end
