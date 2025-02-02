lib.callback.register('fuel:checkMoney', function(source, cost)
    local hasEnough = exports.ox_inventory:GetItem(source, 'money', nil, true) >= cost
    
    if not hasEnough then
        lib.notify(source, {
            title = 'Fuel Station',
            description = 'Not enough money',
            type = 'error'
        })
    end
    
    return hasEnough
end)

lib.callback.register('fuel:pay', function(source, cost)
    local success = exports.ox_inventory:RemoveItem(source, 'money', cost)
    
    if success then
        lib.notify(source, {
            title = 'Fuel Station',
            description = 'Vehicle refueled successfully',
            type = 'success'
        })
        return true
    end
    
    lib.notify(source, {
        title = 'Fuel Station',
        description = 'Not enough money',
        type = 'error'
    })
    return false
end)