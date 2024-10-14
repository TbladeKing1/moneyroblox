-- Advanced Universal Money Manipulation Script for Roblox

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Currency-related keywords to detect remotes or stats
local currencyKeywords = {
    "money", "currency", "cash", "coins", "points", "gems", "bucks", "gold", "credits", "funds"
}

-- Function to check if a string is related to currency
local function isCurrencyRelated(name)
    local lowerName = name:lower()
    for _, keyword in ipairs(currencyKeywords) do
        if string.match(lowerName, keyword) then
            return true
        end
    end
    return false
end

-- Function to find RemoteEvents/RemoteFunctions related to currency
local function findCurrencyRemotes()
    local remotes = {}
    
    -- Iterate over all descendants of ReplicatedStorage
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            print("Found remote: " .. obj.Name)  -- Log all remotes for debugging
            -- If the remote has a currency-related keyword, add it to the remotes list
            if isCurrencyRelated(obj.Name) then
                table.insert(remotes, obj)
                print("Potential currency-related remote: " .. obj.Name)
            end
        end
    end
    return remotes
end

-- Function to find player stats related to currency (leaderstats or other stats)
local function findCurrencyStats()
    local stats = {}

    -- Check the player's leaderstats or any other stats folder
    if LocalPlayer:FindFirstChild("leaderstats") then
        for _, stat in pairs(LocalPlayer.leaderstats:GetChildren()) do
            if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                if isCurrencyRelated(stat.Name) then
                    table.insert(stats, stat)
                    print("Potential currency stat found: " .. stat.Name)
                end
            end
        end
    end
    return stats
end

-- Function to interact with detected remotes (sending smaller chunks to avoid detection)
local function manipulateCurrency(remoteOrStat, amount)
    pcall(function()
        -- If it's a RemoteEvent or RemoteFunction, interact with the server
        if remoteOrStat:IsA("RemoteEvent") then
            for i = 1, amount / 100000 do
                remoteOrStat:FireServer(100000)  -- Fire small amounts in chunks of 100,000
                wait(math.random(0.2, 0.5))  -- Randomized wait time to avoid detection
            end
        elseif remoteOrStat:IsA("RemoteFunction") then
            for i = 1, amount / 100000 do
                remoteOrStat:InvokeServer(100000)  -- Invoke small amounts in chunks of 100,000
                wait(math.random(0.2, 0.5))  -- Randomized wait time to avoid detection
            end
        -- If it's a stat (leaderstats), modify the value directly
        elseif remoteOrStat:IsA("IntValue") or remoteOrStat:IsA("NumberValue") then
            remoteOrStat.Value = remoteOrStat.Value + amount
            print("Updated stat: " .. remoteOrStat.Name .. " to " .. remoteOrStat.Value)
        end
    end)
end

-- Function to continuously monitor and manipulate currency
local function monitorAndChangeCurrency()
    local currencyRemotes = findCurrencyRemotes()  -- Find remotes
    local currencyStats = findCurrencyStats()      -- Find player stats

    -- Loop to continuously attempt to modify remotes or stats
    while true do
        -- Modify currency via remotes
        for _, remote in ipairs(currencyRemotes) do
            manipulateCurrency(remote, 1000000)  -- Attempt to give 1 million currency in smaller chunks
        end
        
        -- Modify currency via player stats directly
        for _, stat in ipairs(currencyStats) do
            manipulateCurrency(stat, 1000000)  -- Add 1 million to the stat
        end

        wait(math.random(3, 7))  -- Random wait time between loops to avoid detection
    end
end

-- Start the advanced money manipulation process
monitorAndChangeCurrency()
