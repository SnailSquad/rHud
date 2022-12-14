-- 'optimized' (Add Wait Lol) Credit : base california Seatbelt system 

local isUiOpen = false
local beltOn = false
local wasInCar = false
local speedBuffer = {}
local velBuffer = {}
local sleep = 1000

local function IsCar(veh)
	local vehClass = GetVehicleClass(veh)
	return (vehClass >= 0 and vehClass <= 7) or (vehClass >= 9 and vehClass <= 12) or (vehClass >= 17 and vehClass <= 20)
end

local function Fwv(entity)
	local hr = GetEntityPhysicsHeading(entity) + 90.0
	if hr < 0.0 then
		hr = 360.0 + hr
	end
	hr = hr * 0.0174533
	return {x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0}
end

CreateThread(function()
	while rHud.activateSpeedo do
		Wait(sleep)
		local plyPed = PlayerPedId()
		local plyVehicle = GetVehiclePedIsIn(plyPed)
		if plyVehicle ~= 0 and (wasInCar or IsCar(plyVehicle)) then
			sleep = 0
			wasInCar = true
			if not beltOn and not isUiOpen and not IsPlayerDead(PlayerId()) and not IsPauseMenuActive() then
				isUiOpen = true
				SendNUIMessage({actionseatbelt = "showseatbelt", showseatbelt = true}) 
			end
			if beltOn then
				DisableControlAction(0, 75)
			end

			speedBuffer[2] = speedBuffer[1]
			speedBuffer[1] = GetEntitySpeed(plyVehicle)
			if speedBuffer[2] ~= nil and not beltOn and GetEntitySpeedVector(plyVehicle, true).y > 1.0 and speedBuffer[1] > 19.25 and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.255) then
				local plyCoords = GetEntityCoords(plyPed, false)
				local fw = Fwv(plyPed)

				SetEntityCoords(plyPed, plyCoords.x + fw.x, plyCoords.y + fw.y, plyCoords.z - 0.47, true, true, true)
				SetEntityVelocity(plyPed, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
				Wait(1)

				SetPedToRagdoll(plyPed, 1000, 1000, 0, 0, 0, 0)
			end
			velBuffer[2] = velBuffer[1]
			velBuffer[1] = GetEntityVelocity(plyVehicle)
			if IsControlJustReleased(0, rHud.seatbeltKey) and GetLastInputMethod(0) then
				beltOn = not beltOn

				if beltOn then
					isUiOpen = true
						SendNUIMessage({actionseatbelt = "showseatbelt", showseatbelt = false}) 
				else
					isUiOpen = true
					SendNUIMessage({actionseatbelt = "showseatbelt", showseatbelt = true}) 
				end
			end
		elseif wasInCar then
			wasInCar = false
			beltOn = false
			speedBuffer[1], speedBuffer[2] = 0.0, 0.0
			if isUiOpen then
				isUiOpen = false
				sleep = 1000
				SendNUIMessage({actionseatbelt = "showseatbelt", showseatbelt = false}) 
			end
		end
	end
end)