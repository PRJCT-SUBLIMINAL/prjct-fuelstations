local function RefuelVehicle(vehicle)
    local currentFuel = exports['LegacyFuel']:GetFuel(vehicle)
    local maxFuel = 100.0
    local fuelToAdd = maxFuel - currentFuel
    local cost = math.ceil(fuelToAdd * Config.FuelCost)
    local refuelTime = math.ceil(fuelToAdd * 300)
    local canPay = lib.callback.await('fuel:checkMoney', false, cost)
    
    if canPay then
        if lib.progressCircle({
            duration = refuelTime,
            label = 'Refueling vehicle...',
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
            },
        }) then
            local success = lib.callback.await('fuel:pay', false, cost)
            if success then
                exports['LegacyFuel']:SetFuel(vehicle, maxFuel)
            end
        end
    end
end

CreateThread(function()
    for _, model in ipairs(Config.PumpModels) do
        exports.ox_target:addModel(model, {
            {
                name = 'refuel_vehicle',
                icon = 'fas fa-gas-pump',
                label = 'Refuel Vehicle',
                canInteract = function(entity, distance, coords, name)
                    local vehicle = GetVehiclePedIsIn(cache.ped, true)
                    return vehicle ~= 0 and #(GetEntityCoords(vehicle) - coords) < 5.0
                end,
                onSelect = function()
                    local vehicle = GetVehiclePedIsIn(cache.ped, true)
                    if vehicle ~= 0 then
                        RefuelVehicle(vehicle)
                    end
                end
            }
        })
    end
end)
