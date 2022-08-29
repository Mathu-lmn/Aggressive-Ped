TriggerEvent( "chat:addSuggestion", "/aggressive", "Usage : /aggressive [number] Spawns aggressive ped(s) in the area" )

AddRelationshipGroup( "AGGRESSIVE")
local ped = 0
-- List of ped models that will randomly spawn when executing the command (you can add more)
local models = {
0xDB729238,
0x278C8CB7,
0x3273A285,
0x03B8C510,
0x905CE0CA,
0xD7606C30,
0x60F4A717
}
-- List of random weapons to give to the peds when they spawn (you can add more)
local weapons = {
    "WEAPON_PISTOL",
    "WEAPON_COMBATPISTOL",
    "WEAPON_PISTOL50",
    "WEAPON_SNSPISTOL",
    "WEAPON_HEAVYPISTOL",
    "WEAPON_VINTAGEPISTOL",
    "WEAPON_PISTOL_MK2",
    "WEAPON_SNSPISTOL_MK2"
}

for i in pairs(models) do
    RequestModel(models[i])
    -- Citizen.Trace("Requested model " .. models[i] .. "\n")
end

RegisterNetEvent('aggressiveCommand')
AddEventHandler('aggressiveCommand', function(amount)
    local player = PlayerPedId()
    local playerCoords = GetEntityCoords(player)
    
    -- Spawn the amount of peds specified in the command
    for i = 1, amount, 1 do
        -- get a random model
        local model = models[math.random(#models)]
        -- randomize the position of the ped in the area around the player
        local x_ped = playerCoords.x + math.random(-25, 25)
        local y_ped = playerCoords.y + math.random(-25, 25)
        -- set the z position of the ped to spawn just above the ground
        local z_ped = -200.0
        ped = CreatePed(4, model, x_ped, y_ped, z_ped, 0.0, true, false)
        SetPedCombatAttributes(ped, 46, 1) -- Set ped to always fight
        SetPedFleeAttributes(ped, 0, 0) -- Set ped to not flee
        SetPedCombatRange(ped,2) -- Set ped range to "far"
        -- Set ped to aggressive with the player but not with other peds spawned by the command
        SetPedRelationshipGroupHash(ped, GetHashKey("AGGRESSIVE"))
        SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("AGGRESSIVE"))
        SetRelationshipBetweenGroups(5, GetHashKey("AGGRESSIVE"), GetHashKey("PLAYER"))
        -- Force the ped to attack the player
        TaskCombatPed(ped, player, 0, 16)
        SetPedKeepTask(ped, true)
        -- Add blip to peds so they can be tracked
        SetPedHasAiBlip(ped, true)
        SetPedAiBlipHasCone(ped, false)
        -- Give the ped a random weapon and 999 ammos
        GiveWeaponToPed(ped, GetHashKey(weapons[math.random(#weapons)]), 999, false, true)
        -- Citizen.Trace("Spawned ped " .. model .. " at " .. x_ped .. " " .. y_ped .. " " .. z_ped .. "\n")
    end
    -- Print a message to the player
    TriggerEvent('chatMessage', 'Aggressive-Ped', {255, 0, 0}, "Aggressive ped(s) spawned.")
end)  