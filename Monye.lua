-- Money Manipulation Script for Roblox

-- Utility function to obfuscate potential money-related RemoteEvents/Functions
local function obfuscateString(input)
    return string.reverse(input)
end

-- Look for RemoteEvents/RemoteFunctions related to money
local function findMoneyRelatedRemotes()
    local remotes = {}
    for _, obj in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            -- Log all potential remotes
            print("Found remote: " .. obj.Name)
            if string.match(obj.Name:lower(), obfuscateString("money")) or string.match(obj.Name:lower(), obfuscateString("currency")) then
                table.insert(remotes, obj)
                print("Potential money-related remote: " .. obj.Name)
            end
        end
    end
    return remotes
end

-- Function to try manipulating money on the server
local function modifyMoney(remote, amount)
    pcall(function()
        if remote:IsA("RemoteEvent") then
            remote:FireServer(amount)
        elseif remote:IsA("RemoteFunction") then
            remote:InvokeServer(amount)
        end
    end)
end

-- Continuously try to give money by firing or invoking remotes
local function monitorAndChangeMoney()
    local moneyRemotes = findMoneyRelatedRemotes()
    while true do
        for _, remote in ipairs(moneyRemotes) do
            modifyMoney(remote, 999999999)  -- Attempt to give 999 million in-game currency
            wait(0.1)  -- Interval to avoid spamming too quickly
        end
        wait(1)  -- General wait to reduce server load
    end
end

-- Start money manipulation process
monitorAndChangeMoney()
