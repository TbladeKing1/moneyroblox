-- Universal Money Manipulation Script for Roblox

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Obfuscation utility to reverse strings
local function obfuscateString(input)
    return string.reverse(input)
end

-- Keywords to identify potential remotes or stats related to money or currency
local currencyKeywords = {
    "money", "currency", "cash", "coins", "points", "gems", "bucks", "gold", "credits"
}

-- Function to check if a string contains any currency-related keyword
local function isCurrencyRelated(name)
    local lowerName = name:lower()
    for _, keyword in ipairs(currencyKeywords) do
        if string.match(lowerName, obfuscateString(keyword)) then
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

-- Function to find player stats related to currency (leaderstats or other stats objects)
local function findCurrencyStats()
    local stats = {}

    -- Check the player's leaderstats or any other stats folder in their character
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

-- Function to try modifying the money through detected remotes or stats
local function modifyCurrency(remoteOrStat, amount)
    pcall(function()
        -- If it's a RemoteEvent or RemoteFunction, interact with the server
        if remoteOrStat:IsA("RemoteEvent") then
            remoteOrStat:FireServer(amount)
        elseif remoteOrStat:IsA("RemoteFunction") then
            remoteOrStat:InvokeServer(amount)
        -- If it's a stat (leaderstats), modify the value directly
        elseif remoteOrStat:IsA("IntValue") or remoteOrStat:IsA("NumberValue") then
            remoteOrStat.Value = remoteOrStat.Value + amount
            print("Updated stat: " .. remoteOrStat.Name .. " to " .. remoteOrStat.Value)
        end
    end)
end

-- Function to continuously monitor and modify money/currency
local function monitorAndChangeCurrency()
    local currencyRemotes = findCurrencyRemotes()  -- Find remotes
    local currencyStats = findCurrencyStats()      -- Find player stats

    -- Loop to continuously attempt to modify remotes or stats
    while true do
        -- Modify via remotes
        for _, remote in ipairs(currencyRemotes) do
            modifyCurrency(remote, 1000000)  -- Attempt to give 1 million currency
            wait(1)  -- Avoid spamming the server too quickly
        end
        
        -- Modify via player stats directly
        for _, stat in ipairs(currencyStats) do
            modifyCurrency(stat, 1000000)  -- Add 1 million to the stat
        end

        wait(5)  -- General wait to avoid detection and overloading
    end
end

-- Start the money/currency manipulation process
monitorAndChangeCurrency()
