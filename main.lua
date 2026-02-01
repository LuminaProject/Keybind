local function RemoveFromTable(tbl, item)
    for i = #tbl, 1, -1 do
        if tbl[i] == item then
            table.remove(tbl, i)
            break
        end
    end
end

local Events = {}
local GetPlayers = {}
local GetCritters = {}
local GetResources = {}

local Players = game:GetService("Players")
local Critters = workspace.Critters

for _, v in ipairs(Players:GetPlayers()) do
    table.insert(GetPlayers, v)
end

Events.PlayerAdded = Players.PlayerAdded:Connect(function(Player)
    table.insert(GetPlayers, Player)
end)

Events.PlayerRemoving = Players.PlayerRemoving:Connect(function(Player)
    RemoveFromTable(GetPlayers, Player)
end)

for _, c in ipairs(Critters:GetChildren()) do
    if c:IsA("Model") then
        table.insert(GetCritters, c)
    end
end

Events.CritterAdded = Critters.ChildAdded:Connect(function(c)
    if c:IsA("Model") then
        table.insert(GetCritters, c)
    end
end)

Events.CritterRemoved = Critters.ChildRemoved:Connect(function(c)
    RemoveFromTable(GetCritters, c)
end)

local ResourceFolders = {"Resources", "Totems", "ScavengerMounds", "Mounds", "Deployables"}
for _, folderName in ipairs(ResourceFolders) do
    local folder = workspace:FindFirstChild(folderName)
    if folder then
        for _, resource in ipairs(folder:GetChildren()) do
            if resource:IsA("Model") then
                table.insert(GetResources, resource)
            end
        end

        Events["ResourceAdded_" .. folderName] = folder.ChildAdded:Connect(function(child)
            if child:IsA("Model") then
                table.insert(GetResources, child)
            end
        end)

        Events["ResourceRemoved_" .. folderName] = folder.ChildRemoved:Connect(function(child)
            RemoveFromTable(GetResources, child)
        end)
    end
end

return { Events = Events, GetPlayers = GetPlayers, GetCritters = GetCritters, GetResources = GetResources }
