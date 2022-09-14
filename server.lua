local cooldowns = {}
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
        end

        if not cooldowns[source] or ((os.clock() - cooldowns[source]) > 60) then -- set a cooldown of 60 seconds to prevent spamming
            cooldowns[source] = os.clock()
            TriggerClientEvent('aggressiveCommand', source, amount)
        
        else -- If the player is on cooldown, notify the player
            TriggerClientEvent('chat:addMessage', source, {
                color = { 255, 0, 0},
                multiline = true,
                args = {"Aggressive-Ped", "^7You can only use this command once every minute."}
              })
        end
    else -- If the source is not a player, then notify the server console
        print("Failed to spawn peds (not a player).")
    end
end)