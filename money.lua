-- Advanced Persistent Currency Manipulation Script for Roblox

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Keywords related to in-game currency
local currencyKeywords = {
    "money", "currency", "cash", "coins", "points", "gems", "bucks", "gold", "credits", "funds"
}

-- Utility to check if a string is related to currency
local function isCurrencyRelated(name)
    local lowerName = name:lower()
    for _, keyword in ipairs(currencyKeywords) do
        if string.match(lowerName, keyword) then
            return true
        end
    end
    return false
end

-- Find RemoteEvents/RemoteFunctions related to currency
local function findCurrencyRemotes()
    local remotes = {}
    
    -- Iterate over ReplicatedStorage descendants
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            -- Log remotes for debugging purposes
            print("Found remote: " .. obj.Name)
            if isCurrencyRelated(obj.Name) then
                table.insert(remotes, obj)
                print("Potential currency-related remote: " .. obj.Name)
            end
        end
    end
    return remotes
end

-- Look for player stats related to currency
local function findCurrencyStats()
    local stats = {}
    -- Check for leaderstats in player object
    if LocalPlayer:FindFirstChild("leaderstats") then
        for _, stat in pairs(LocalPlayer.leaderstats:GetChildren()) do
            if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                if isCurrencyRelated(stat.Name) then
                    table.insert(stats, stat)
                    print("Found potential currency stat: " .. stat.Name)
                end
            end
        end
    end
    return stats
end

-- Interact with detected remotes or stats to manipulate currency
local function manipulateCurrency(remoteOrStat, amount)
    pcall(function()
        -- If it's a RemoteEvent or RemoteFunction, send data to the server
        if remoteOrStat:IsA("RemoteEvent") then
            -- Break the amount into smaller chunks to avoid detection
            for i = 1, amount / 100000 do
                remoteOrStat:FireServer(100000)  -- Send small amounts in chunks
                wait(math.random(0.2, 0.5))  -- Randomized delay to mimic legitimate activity
            end
        elseif remoteOrStat:IsA("RemoteFunction") then
            -- Send data through InvokeServer in smaller amounts
            for i = 1, amount / 100000 do
                remoteOrStat:InvokeServer(100000)
                wait(math.random(0.2, 0.5))  -- Mimic realistic usage patterns
            end
        elseif remoteOrStat:IsA("IntValue") or remoteOrStat:IsA("NumberValue") then
            -- Directly manipulate the currency value
            remoteOrStat.Value = remoteOrStat.Value + amount
            print("Updated stat: " .. remoteOrStat.Name .. " to " .. remoteOrStat.Value)
        end
    end)
end

-- Function to find purchase-related remote events
local function findPurchaseRemotes()
    local purchaseRemotes = {}
    -- Look for remotes related to purchases or transactions
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            if string.match(obj.Name:lower(), "purchase") or string.match(obj.Name:lower(), "buy") then
                table.insert(purchaseRemotes, obj)
                print("Found purchase-related remote: " .. obj.Name)
            end
        end
    end
    return purchaseRemotes
end

-- Function to monitor and persistently try to add money
local function monitorAndPersistCurrency(amount)
    local currencyRemotes = findCurrencyRemotes()  -- Find currency-related remotes
    local currencyStats = findCurrencyStats()      -- Find player stats (leaderstats)
    local purchaseRemotes = findPurchaseRemotes()  -- Find remotes related to purchases

    -- Loop to continuously manipulate remotes and stats
    while true do
        -- Interact with currency remotes and stats
        for _, remote in ipairs(currencyRemotes) do
            manipulateCurrency(remote, amount)  -- Attempt to give specified amount in smaller chunks
        end
        
        for _, stat in ipairs(currencyStats) do
            manipulateCurrency(stat, amount)  -- Modify player stats directly
        end

        -- Hook into purchase-related remotes (try to mimic legitimate purchases)
        for _, purchaseRemote in ipairs(purchaseRemotes) do
            manipulateCurrency(purchaseRemote, amount)  -- Attempt to mimic legitimate transactions
        end

        -- If the server resets the currency, retry the operation after a random delay
        wait(math.random(10, 20))  -- Random wait time to avoid detection and prevent throttling
    end
end

-- Start the advanced money manipulation process
monitorAndPersistCurrency(1000000)  -- Manipulate currency by adding 1 million each loop
