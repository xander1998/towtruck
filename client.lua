local towtruck = nil
local attachedVehicle = nil
local createdBlips = {}

---------------------------------------------------------------------------
-- Starter Blips
---------------------------------------------------------------------------
Citizen.CreateThread(function()
    for a = 1, #XTowConfig.TruckDepos do
        local blip = AddBlipForCoord(XTowConfig.TruckDepos[a].x, XTowConfig.TruckDepos[a].y, XTowConfig.TruckDepos[a].z)
        SetBlipSprite(blip, 50)
        SetBlipColour(blip, 71)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 1.0)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Towtruck Depot")
        EndTextCommandSetBlipName(blip)
    end
end)

---------------------------------------------------------------------------
-- TRUCK DEPOS
---------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        for a = 1, #XTowConfig.TruckDepos do
            local ped = GetPlayerPed(PlayerId())
            local pedPos = GetEntityCoords(ped, false)
            local distance = Vdist(pedPos.x, pedPos.y, pedPos.z, XTowConfig.TruckDepos[a].x, XTowConfig.TruckDepos[a].y, XTowConfig.TruckDepos[a].z)
            if distance <= 15.0 then
                DrawMarker(1, XTowConfig.TruckDepos[a].x, XTowConfig.TruckDepos[a].y, XTowConfig.TruckDepos[a].z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 150, 61, 61, 1.0, 0, 0, 0, 0, 0, 0, 0)
                if distance <= 1.2 then
                    if towtruck == nil then
                        Draw3DText(XTowConfig.TruckDepos[a].x, XTowConfig.TruckDepos[a].y, XTowConfig.TruckDepos[a].z, tostring("~o~[E]~w~ Acquire a towtruck"))
                    else
                        Draw3DText(XTowConfig.TruckDepos[a].x, XTowConfig.TruckDepos[a].y, XTowConfig.TruckDepos[a].z, tostring("~o~[E]~w~ Return your towtruck"))
                    end
                    if IsControlJustPressed(1, 38) and attachedVehicle == nil then
                        if towtruck == nil then
                            AcquireTowtruck(XTowConfig.TruckDepos[a].spawn)
                        else
                            ReturnTowtruck()
                        end
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

---------------------------------------------------------------------------
-- IMPOUNDS
---------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        if towtruck ~= nil then
            for a = 1, #XTowConfig.Impounds do
                local vehPos = GetEntityCoords(towtruck, false)
                local distance = Vdist(vehPos.x, vehPos.y, vehPos.z, XTowConfig.Impounds[a].x, XTowConfig.Impounds[a].y, XTowConfig.Impounds[a].z)
                if distance <= 15.0 then
                    DrawMarker(1, XTowConfig.Impounds[a].x, XTowConfig.Impounds[a].y, XTowConfig.Impounds[a].z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 8.0, 8.0, 1.0, 150, 61, 61, 1.0, 0, 0, 0, 0, 0, 0, 0)
                    if distance <= 5.0 then
                        if attachedVehicle ~= nil then
                            Draw3DText(XTowConfig.Impounds[a].x, XTowConfig.Impounds[a].y, XTowConfig.Impounds[a].z, tostring("~o~[E]~w~ Impound Vehicle"))
                        else
                            Draw3DText(XTowConfig.Impounds[a].x, XTowConfig.Impounds[a].y, XTowConfig.Impounds[a].z, tostring("~r~You have no vehicle to impound"))
                        end
                        if IsControlJustPressed(1, 38) and attachedVehicle ~= nil then
                            ImpoundVehicle()
                        end
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

---------------------------------------------------------------------------
-- VEHICLE FLIPPED LOGIC
---------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        if towtruck ~= nil then
            if attachedVehicle ~= nil then
                if IsEntityUpsidedown(towtruck) then
                    DetachEntity(attachedVehicle, false, false)
                    attachedVehicle = nil
                end
            end
        end
        Citizen.Wait(0)
    end
end)

---------------------------------------------------------------------------
-- TOWTRUCK LOGIC
--------------------------------------------------------------------------- TOWTRUCK HEIGHT - 1.0866451263428
RegisterCommand("tow", function()
    if towtruck ~= nil then
        if attachedVehicle == nil then
            local frontVehicle = GetVehicleInFront()
            if frontVehicle ~= towtruck then
                if CheckBlacklist(frontVehicle) == false then
                    AttachVehicle(frontVehicle)
                else
                    TriggerEvent("chatMessage", "^1That is a blacklisted vehicle. You can't attach that...")
                end
            end
        else
            DetachVehicle()
        end
    end
end, false)

---------------------------------------------------------------------------
-- FUNCTIONS
---------------------------------------------------------------------------
function AcquireTowtruck(spawn)
    local model = GetHashKey(XTowConfig.TruckModel)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
    local spawned = CreateVehicle(model, spawn.x, spawn.y, spawn.z, spawn.h, 1, 1)
    PlaceObjectOnGroundProperly(spawned)
    SetEntityAsMissionEntity(spawned, 1, 1)
    SetEntityAsNoLongerNeeded(spawned)
    towtruck = spawned

    -- Create Blips
    for a = 1, #XTowConfig.Impounds do
        local blip = AddBlipForCoord(XTowConfig.Impounds[a].x, XTowConfig.Impounds[a].y, XTowConfig.Impounds[a].z)
        SetBlipSprite(blip, 398)
        SetBlipColour(blip, 71)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 1.0)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Towtruck Impound")
        EndTextCommandSetBlipName(blip)
        table.insert(createdBlips, blip)
    end
end

function ReturnTowtruck()
    DeleteEntity(towtruck)
    if not DoesEntityExist(towtruck) then
        towtruck = nil
    end

    for a = 1, #createdBlips do
        RemoveBlip(createdBlips[a])
    end
    createdBlips = {}
end

function AttachVehicle(vehicle)
    local towOffset = GetOffsetFromEntityInWorldCoords(towtruck, 0.0, -2.2, 0.4)
    local towRot = GetEntityRotation(towtruck, 1)
    local vehicleHeightMin, vehicleHeightMax = GetModelDimensions(GetEntityModel(vehicle))
    print(vehicleHeightMin, vehicleHeightMax)

    AttachEntityToEntity(vehicle, towtruck, GetEntityBoneIndexByName(towtruck, "bodyshell"), 0, -2.2, 0.4 - vehicleHeightMin.z, 0, 0, 0, 1, 1, 0, 1, 0, 1)
    attachedVehicle = vehicle
end

function DetachVehicle()
    local towOffset = GetOffsetFromEntityInWorldCoords(towtruck, 0.0, -10.0, 0.0)
    DetachEntity(attachedVehicle, false, false)
    SetEntityCoords(attachedVehicle, towOffset.x, towOffset.y, towOffset.z, 1, 0, 0, 1)
    PlaceObjectOnGroundProperly(attachedVehicle)
    attachedVehicle = nil
end

function ImpoundVehicle()
    DeleteEntity(attachedVehicle)
    if not DoesEntityExist(attachedVehicle) then
        attachedVehicle = nil
    end
end

function CheckBlacklist(vehicle)
    for a = 1, #XTowConfig.BlacklistedVehicles do
        if GetHashKey(XTowConfig.BlacklistedVehicles[a]) == GetEntityModel(vehicle) then
            return true
        end
    end
    return false
end

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function GetVehicleInFront()
    local plyCoords = GetEntityCoords(GetPlayerPed(PlayerId()), false)
    local plyOffset = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 5.0, 0.0)
    local rayHandle = StartShapeTestCapsule(plyCoords.x, plyCoords.y, plyCoords.z, plyOffset.x, plyOffset.y, plyOffset.z, 1.0, 10, GetPlayerPed(PlayerId()), 7)
    local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)
    return vehicle
end