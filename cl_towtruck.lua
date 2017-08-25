-- Scripted by Xander Tanner-Harrison --
local vehicles = {}
vehicles.Attached = false
vehicles.vTruck = nil
vehicles.cVehicle = nil

RegisterNetEvent("setTruck")
AddEventHandler("setTruck", function()
	if vehicles.vTruck == nil then
		local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 6.5, 0.0)
		local plyHeading = GetEntityHeading(GetPlayerPed(PlayerId()))
		local truck_model = "flatbed"
		RequestModel(GetHashKey(truck_model))
		while not HasModelLoaded(GetHashKey(truck_model)) do
			Citizen.Wait(100)
			RequestModel(GetHashKey(truck_model))
		end
		vehicles.vTruck = CreateVehicle(GetHashKey(truck_model), plyCoords.x, plyCoords.y, plyCoords.z, plyHeading, 1, 1)
		Citizen.Trace("Spawned Vehicles")
	else
		DetachEntity(vehicles.cVehicle, 1, 1)
		DeleteEntity(vehicles.vTruck)
		vehicles.vTruck = nil
		vehicles.cVehicle = nil
		Citizen.Trace("Deleted Vehicles")
	end
end)

RegisterNetEvent("checkList")
AddEventHandler("checkList", function()
local restrictedVehicles = {
	VEHICLE_BUS = {
		name = "Bus",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("bus"))
	},
	VEHICLE_BUZZARD = {
		name = "Buzzard",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("buzzard"))
	},
	VEHICLE_BUZZARD2 = {
		name = "Buzzard2",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("buzzard2"))
	},
	VEHICLE_CARGOBOB = {
		name = "Cargobob",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("cargobob"))
	},
	VEHICLE_CARGOBOB2 = {
		name = "Cargobob2",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("cargobob2"))
	},
	VEHICLE_CARGOBOB3 = {
		name = "Cargobob3",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("cargobob3"))
	},
	VEHICLE_CARGOBOB4 = {
		name = "Cargobob4",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("cargobo4"))
	},
	VEHICLE_CARGOPLANE = {
		name = "Cargo Plane",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("cargoplane"))
	},
	VEHICLE_RHINO = {
		name = "Rhino",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("rhino"))
	},
	VEHICLE_PBUS = {
		name = "Police Bus",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("pbus"))
	},
	VEHICLE_FIRETRUCK = {
		name = "Firetruck",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("firetruk"))
	},
	VEHICLE_NIMBUS = {
		name = "Nimbus",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("nimbus"))
	},
	VEHICLE_RENTALBUS = {
		name = "Rental Bus",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("rentalbus"))
	},
	VEHICLE_TOURBUS = {
		name = "Tour Bus",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("tourbus"))
	},
	VEHICLE_AIRBUS = {
		name = "Air Bus",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("airbus"))
	},
	VEHICLE_BLIMP = {
		name = "Blimp",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("blimp"))
	},
	VEHICLE_BLIMP2 = {
		name = "Blimp2",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("blimp2"))
	},
	VEHICLE_CAMPER = {
		name = "Camper",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("camper"))
	},
	VEHICLE_COACH = {
		name = "Coach",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("coach"))
	},
	VEHICLE_CUTTER = {
		name = "Cutter",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("cutter"))
	},
	VEHICLE_DINGHY = {
		name = "Dinghy",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("dinghy"))
	},
	VEHICLE_DINGHY2 = {
		name = "dinghy2",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("dinghy2"))
	},
	VEHICLE_DINGHY3 = {
		name = "dinghy3",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("dinghy3"))
	},
	VEHICLE_DINGHY4 = {
		name = "dinghy4",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("dinghy4"))
	},
	VEHICLE_DODO = {
		name = "Dodo",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("dodo"))
	},
	VEHICLE_DUSTER = {
		name = "Duster",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("duster"))
	},
	VEHICLE_INSURGENT = {
		name = "Insurgent",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("insurgent"))
	},
	VEHICLE_INSURENT2 = {
		name = "Insurgent2",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("insurgent2"))
	},
	VEHICLE_LAZER = {
		name = "Lazer",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("lazer"))
	},
	VEHICLE_LIMO2 = {
		name = "Limo2",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("limo2"))
	},
	VEHICLE_LUXOR = {
		name = "Luxor",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("luxor"))
	},
	VEHICLE_LUXOR2 = {
		name = "Luxor2",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("luxor2"))
	},
	VEHICLE_MAMMATUS = {
		name = "Mammatus",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("mammatus"))
	},
	VEHICLE_MARQUIS = {
		name = "Marquis",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("marquis"))
	},
	VEHICLE_MARSHALL = {
		name = "Marshall",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("marshall"))
	},
	VEHICLE_MIXER = {
		name = "Mixer",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("mixer"))
	},
	VEHICLE_MIXER2 = {
		name = "Mixer2",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("mixer2"))
	},
	VEHICLE_MONSTER = {
		name = "Monster",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("monster"))
	},
	VEHICLE_MULE = {
		name = "Mule",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("mule"))
	},
	VEHICLE_MULE2 = {
		name = "Mule2",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("mule2"))
	},
	VEHICLE_MULE3 = {
		name = "Mule3",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("mule3"))
	},
	VEHICLE_PACKER = {
		name = "Packer",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("packer"))
	},
	VEHICLE_PHANTOM = {
		name = "Phantom",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("phantom"))
	},
	VEHICLE_POLMAV = {
		name = "Police Maverick",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("polmav"))
	},
	VEHICLE_POUNDER = {
		name = "Pounder",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("pounder"))
	},
	VEHICLE_PREDATOR = {
		name = "Predator",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("predator"))
	},
	VEHICLE_RALLYTRUCK = {
		name = "Rally Truck",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("rallytruck"))
	},
	VEHICLE_RIPLEY = {
		name = "Ripley",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("ripley"))
	},
	VEHICLE_ROMERO = {
		name = "Romero",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("romero"))
	},
	VEHICLE_RUBBLE = {
		name = "Rubble",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("rubble"))
	},
	VEHICLE_SAVAGE = {
		name = "Savage",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("savage"))
	},
	VEHICLE_SHAMAL = {
		name = "Shamal",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("shamal"))
	},
	VEHICLE_SKYLIFT = {
		name = "Skylift",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("skylift"))
	},
	VEHICLE_SPEEDER = {
		name = "Speeder",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("speeder"))
	},
	VEHICLE_SPEEDER2 = {
		name = "Speeder2",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("speeder2"))
	},
	VEHICLE_SQUALO = {
		name = "Squalo",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("squalo"))
	},
	VEHICLE_STOCKADE = {
		name = "Stockade",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("stockade"))
	},
	VEHICLE_STOCKADE3 = {
		name = "Stockade3",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("stockade3"))
	},
	VEHICLE_SUBMERSIBLE = {
		name = "Submarine",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("submersible"))
	},
	VEHICLE_SUBMERSIBLE2 = {
		name = "Submarine2",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("submersible2"))
	},
	VEHICLE_SUNTRAP = {
		name = "Suntrap",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("suntrap"))
	},
	VEHICLE_SUPERVOLITO = {
		name = "Supervolito",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("supervolito"))
	},
	VEHICLE_SUPERVOLITO2 = {
		name = "Supervolito2",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("supervolito2"))
	},
	VEHICLE_SWIFT = {
		name = "Swift",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("swift"))
	},
	VEHICLE_SWIFT2 = {
		name = "Swift2",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("swift2"))
	},
	VEHICLE_TACO = {
		name = "Taco Truck",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("taco"))
	},
	VEHICLE_TECHNICAL = {
		name = "Technical Truck",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("technical"))
	},
	VEHICLE_TIPTRUCK = {
		name = "Tip Truck",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("tiptruck"))
	},
	VEHICLE_TIPTRUCK2 = {
		name = "Tip Truck2",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("tiptruck2"))
	},
	VEHICLE_TITAN = {
		name = "Titan",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("titan"))
	},
	VEHICAL_TORO = {
		name = "Toro",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("toro"))
	},
	VEHICLE_TORO2 = {
		name = "Toro2",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("toro2"))
	},
	VEHICLE_TROPIC = {
		name = "Tropic",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("tropic"))
	},
	VEHICLE_TROPIC2 = {
		name = "Tropic2",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("tropic2"))
	},
	VEHICLE_TUG = {
		name = "Tug Boat",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("tug"))
	},
	VEHICLE_VALKYRIE = {
		name = "Valkyrie",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("valkyrie"))
	},
	VEHICLE_VALKYRIE2 = {
		name = "Valkyrie2",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("valkyrie2"))
	},
	VEHICLE_VELUM = {
		name = "Velum",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("velum"))
	},
	VEHICLE_VELUM2 = {
		name = "Velum2",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("velum2"))
	},
	VEHICLE_VIGERO = {
		name = "Vigero",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("vigero"))
	},
	VEHICLE_VOLATUS = {
		name = "Volatus",
		checkVehicle = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("volatus"))
	},
}

	for k in pairs(restrictedVehicles) do
		if(restrictedVehicles[k].checkVehicle == 1) then
			TriggerEvent("chatMessage", "^1Notice: ^0You can not tow a " .. restrictedVehicles[k].name .. ".")
			Citizen.Trace("Cannot Tow Message")
			return
		end
	end
	TriggerEvent("attachTow")
end)

RegisterNetEvent("towVehicle")
AddEventHandler("towVehicle", function()
	local flatbedModel = IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetHashKey("flatbed"))

	if (vehicles.vTruck == nil) then
		TriggerEvent("chatMessage", "^1Notice: ^0Please set your towtruck with /truck.")
		return
	elseif flatbedModel then
		TriggerEvent("chatMessage", "^1Notice: ^0You can not tow another flatbed.")
		return
	elseif not flatbedModel then
		TriggerEvent("checkList")
	end
end)

RegisterNetEvent("attachTow")
AddEventHandler("attachTow", function()
	Citizen.Trace("Started Attach")
	local plyCoords = GetEntityCoords(GetPlayerPed(PlayerId()), false)
	local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 5.0, 0.0)
	vehicles.cVehicle = getVehicleInDirection(plyCoords, coordB)

	AttachEntityToEntity(vehicles.cVehicle, vehicles.vTruck, GetEntityBoneIndexByName(vehicles.vTruck, "bodyshell"), 0, -2.0, 1.2, 0, 0, 0, 1, 1, 0, 1, 0, 1)
	TriggerEvent("chatMessage", "^1Notice: ^0You have attached the vehicle.")
	vehicles.Attached = true
	Citizen.Trace("Finished Attaching")
end)

RegisterNetEvent("detachTow")
AddEventHandler("detachTow", function()
	if vehicles.Attached then
		DetachEntity(vehicles.cVehicle, false, false)
		local vehiclesCoords = GetOffsetFromEntityInWorldCoords(vehicles.vTruck, 0.0, -10.0, 0.0)
		SetEntityCoords(vehicles.cVehicle, vehiclesCoords["x"], vehiclesCoords["y"], vehiclesCoords["z"], 1, 0, 0, 1)
		TriggerEvent("chatMessage", "^1Notice: ^0You have detached the vehicle.")
		vehicles.Attached = false
		vehicles.cVehicles = nil
	else
		TriggerEvent("chatMessage", "^1Notice: ^0You do not have a vehicle to detach.")
		return
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if IsEntityUpsidedown(vehicles.vTruck) and vehicles.Attached then
			DetachEntity(vehicles.cVehicle, false, false)
			vehicles.Attached = false
		end
	end
end)

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end