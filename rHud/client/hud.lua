ESX = nil
local hunger, thirst = 0, 0

CreateThread(function()
    while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

CreateThread(function()
    while rHud.hideHudComponent do
        Wait(0)
        HideHudComponentThisFrame(1) -- Wanted Stars
        HideHudComponentThisFrame(2) -- Weapon Icon
        HideHudComponentThisFrame(3) -- Cash
        HideHudComponentThisFrame(4) -- MP Cash
        HideHudComponentThisFrame(6) -- Vehicle Name
        HideHudComponentThisFrame(7) -- Area Name
        HideHudComponentThisFrame(8) -- Vehicle Class
        HideHudComponentThisFrame(9) -- Street Name
        HideHudComponentThisFrame(13) -- Cash Change
        HideHudComponentThisFrame(17) -- Save Game
        HideHudComponentThisFrame(20) -- Weapon Stats
    end
end)

CreateThread(function()
    while true do
        TriggerEvent('esx_status:getStatus', 'hunger', function(status)
            hunger = status.getPercent()
        end)
        TriggerEvent('esx_status:getStatus', 'thirst', function(status)
            thirst = status.getPercent()
        end)
        Wait(10000)
    end
end)

CreateThread(function()
    local sleep = 1500
    local enabledSpeedo = false
    local IsPaused = false
    TriggerServerEvent("rHud:getInfo")
    while true do
        local ped = PlayerPedId()
        local getVeh = GetVehiclePedIsIn(ped, false)
        local isInVehicle = IsPedInAnyVehicle(ped, false)
        local health = GetEntityHealth(ped)/2
        local shield = GetPedArmour(ped)
        local classe = GetVehicleClass((getVeh)) 
        SendNUIMessage({actionhud = "setValue", key = "health", value = health})
        SendNUIMessage({actionhud = "setValue", key = "shield", value = shield})
        SendNUIMessage({actionhud = "setValue", key = "eat", value = hunger})
        SendNUIMessage({actionhud = "setValue", key = "drink", value = thirst})
        if IsPauseMenuActive() and not IsPaused then
			IsPaused = true
			SendNUIMessage({actionhud = "showhud", showhud = false})
            if isInVehicle and rHud.activateSpeedo and not (classe == 13)  then 
                SendNUIMessage({
                    actionspeedo = "showspeedo",
                    showspeedo = false
                })
            end
		elseif not IsPauseMenuActive() and IsPaused then
			IsPaused = false
			SendNUIMessage({actionhud = "showhud", showhud = true})
            if isInVehicle and rHud.activateSpeedo and not (classe == 13)  then 
                SendNUIMessage({
                    actionspeedo = "showspeedo",
                    showspeedo = true
                })
            end
		end
        if isInVehicle and rHud.activateSpeedo and not (classe == 13) then
            if not enabledSpeedo then
                if not (classe == 13) then 
                    SendNUIMessage({
                        actionspeedo = "showspeedo",
                        showspeedo = true
                    })
                    enabledSpeedo = true
                    sleep = 0
                end
            end
            local vehicle = GetVehiclePedIsIn(ped, false)
            local fuel = GetVehicleFuelLevel(vehicle)
            local gear = GetVehicleCurrentGear(vehicle)
            local speed = math.ceil(GetEntitySpeed(vehicle) * 3.6)
            SendNUIMessage({actionspeedo = "setValue", key = "speed", value = speed})
            SendNUIMessage({actionspeedo = "setValue", key = "fuel", value = fuel})
            if not (classe == 8) then 
                SendNUIMessage({actionspeedo = "setValue", key = "gear", value = gear, vitesse = speed})
            else
                SendNUIMessage({actionspeedo = "setValue", key = "gear2", value = gear, vitesse = speed})
            end
        else
            SendNUIMessage({
                actionspeedo = "showspeedo",
                showspeedo = false
            })
            enabledSpeedo = false
            sleep = 1000
        end
        Wait(sleep)
    end
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer) 
	local data = xPlayer
	local accounts = data.accounts
	for _,v in pairs(accounts) do
		local account = v
		if account.name == "money" then
			local moneymoney = ESX.Math.GroupDigits(account.money)
			SendNUIMessage({actionhud = "setValue", key = "money", value = moneymoney.." $"})
		end
        if account.name == "black_money" then
			local moneymoney = ESX.Math.GroupDigits(account.money)
			SendNUIMessage({actionhud = "setValue", key = "sale", value = moneymoney.." $"})
		end
	end
	local job = data.job
	SendNUIMessage({actionhud = "setValue", key = "job", value = job.label})
end)

RegisterNetEvent('esx:setAccountMoney', function(account)
	if account.name == "money" then
		local moneymoney = ESX.Math.GroupDigits(account.money)
		SendNUIMessage({actionhud = "setValue", key = "money", value = moneymoney.." $"})
	end
    if account.name == "black_money" then
        local moneymoney = ESX.Math.GroupDigits(account.money)
        SendNUIMessage({actionhud = "setValue", key = "sale", value = moneymoney.." $"})
    end
end)

RegisterNetEvent('esx:setJob', function(job)
  SendNUIMessage({actionhud = "setValue", key = "job", value = job.label})
end)

RegisterNetEvent("rHud:toggle", function(show) 
	SendNUIMessage({actionhud = "showhud", showhud = show}) 
end)

RegisterNetEvent("rHud:setInfo", function(cash, dirty, job) 
    SendNUIMessage({actionhud = "setValue", key = "money", value = cash.." $"})
    SendNUIMessage({actionhud = "setValue", key = "sale", value = dirty.." $"})
    SendNUIMessage({actionhud = "setValue", key = "job", value = job})
end)