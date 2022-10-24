local cooldowns = {}
local cooldown = 60 -- the cooldown in seconds
local max = 10 -- you can set here the maximum amount of peds you want to allow people on your server to spawn

RegisterCommand('aggressive', function(source, args)
    if (source > 0) then
        -- If no arguments are given or the first argument is not a number, then don't spawn any peds and notify the player
        local amount = args[1]
        if not tonumber(amount) or amount == '' then
            TriggerClientEvent('chat:addMessage', source,{
                color = { 255, 0, 0},
                multiline = true,
                args = {"Aggressive-Ped", "^7Usage: ^1/aggressive [number]"}
              })
            return
        elseif tonumber(amount) > max then
            TriggerClientEvent('chat:addMessage', source,{
                color = { 255, 0, 0},
                multiline = true,
                args = {"Aggressive-Ped", "^7You can only spawn up to ^1" .. max .. " ^7peds."}
              })
            return
        elseif cooldowns[source] then -- if the player is on cooldown, notify him
            TriggerClientEvent('chat:addMessage', source, {
                color = { 255, 0, 0},
                multiline = true,
                args = {"Aggressive-Ped", "^7You can only use this command once every "..cooldown.." seconds. ("..cooldowns[source].." seconds left)"}
              })
        else -- if all the checks are passed, execute the command
            TriggerClientEvent('aggressiveCommand', source, amount)
            cooldowns[source] = tonumber(cooldown) -- set the cooldown
        end
    else -- If the source is not a player, then notify the server console
        print("Failed to spawn peds (not a player).")
    end
end)

-- each seconds, the cooldowns are reduced by 1 second
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for k, v in pairs(cooldowns) do
            if v > 0 then
                cooldowns[k] = v - 1
            else --remove the player from table if the cooldown is over
                cooldowns[k] = nil
            end
        end
    end
end)