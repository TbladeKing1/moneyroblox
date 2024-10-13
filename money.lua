-- Enhanced Money Manipulation Script for Roblox

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Utility function to reverse strings (simple obfuscation)
local function obfuscateString(input)
    return string.reverse(input)
end

-- Function to find RemoteEvents/RemoteFunctions related to money or currency
local function findMoneyRelatedRemotes()
    local remotes = {}
    
    -- Iterate over all descendants of ReplicatedStorage to find RemoteEvents/RemoteFunctions
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local lowerName = obj.Name:lower()
            print("Found remote: " .. obj.Name)  -- Log all remotes for debugging

            -- Look for remotes that might be related to money, currency, or purchases
            if string.match(lowerName, obfuscateString("money")) or 
               string.match(lowerName, obfuscateString("currency")) or 
               string.match(lowerName, obfuscateString("buy")) or
               string.match(lowerName, obfuscateString("purchase")) then
                table.insert(remotes, obj)
                print("Potential money-related remote: " .. obj.Name)
            end
        end
    end
    return remotes
end

-- Function to try modifying money through detected remotes
local function modifyMoney(remote, amount)
    pcall(function()
        if remote:IsA("RemoteEvent") then
            -- Fire the remote with money amount (try to simulate legitimate requests)
            remote:FireServer(amount)
        elseif remote:IsA("RemoteFunction") then
            -- Invoke the remote function with money amount
            remote:InvokeServer(amount)
        end
    end)
end

-- Function to continuously monitor and modify money
local function monitorAndChangeMoney()
    local moneyRemotes = findMoneyRelatedRemotes()

    while true do
        for _, remote in ipairs(moneyRemotes) do
            modifyMoney(remote, 1000000)  -- Attempt to give 1 million currency
            wait(1)  -- Adjust the wait time to avoid overloading the server
        end
        wait(5)  -- General wait to avoid detection by anti-cheat mechanisms
    end
end

-- Run the script to monitor and attempt money modification
monitorAndChangeMoney()
