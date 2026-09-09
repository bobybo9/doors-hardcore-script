--[[ 
    CUSTOM ROOMS SYSTEM MODULE
    Handles all 6 custom rooms with hazards and rewards
]]--

local RoomSystem = {}
RoomSystem.activeRooms = {}

-- ROOM DEFINITIONS
RoomSystem.rooms = {
    {
        name = "ShadowVault",
        theme = "Dark underground chamber",
        hazards = {"Shadow pools", "Phantom guardians"},
        rewards = {"VoidShard", "ShadowCloak"},
        difficulty = "Hard",
        size = Vector3.new(100, 50, 100),
        color = Color3.fromRGB(20, 20, 40)
    },
    {
        name = "InfernoLair",
        theme = "Fiery cavern with lava",
        hazards = {"Lava floors", "Fire geysers"},
        rewards = {"InfernoCrystal", "ThunderCore"},
        difficulty = "Extreme",
        size = Vector3.new(120, 60, 120),
        color = Color3.fromRGB(255, 100, 0)
    },
    {
        name = "FrozenTombs",
        theme = "Ancient ice-covered tombs",
        hazards = {"Ice floors", "Frozen spikes"},
        rewards = {"FrostGem", "HealingVial"},
        difficulty = "Hard",
        size = Vector3.new(110, 55, 110),
        color = Color3.fromRGB(0, 180, 255)
    },
    {
        name = "ThunderSpire",
        theme = "Electric tower of power",
        hazards = {"Lightning strikes", "Electric floors"},
        rewards = {"ThunderCore", "SpecterOrb"},
        difficulty = "Hard",
        size = Vector3.new(80, 120, 80),
        color = Color3.fromRGB(255, 200, 0)
    },
    {
        name = "AbyssDepths",
        theme = "Cosmic void chamber",
        hazards = {"Void rifts", "Reality tears"},
        rewards = {"SoulEssence", "VoidShard"},
        difficulty = "Nightmare",
        size = Vector3.new(150, 80, 150),
        color = Color3.fromRGB(100, 0, 200)
    },
    {
        name = "PoisonGarden",
        theme = "Toxic vegetation maze",
        hazards = {"Poison gas", "Carnivorous plants"},
        rewards = {"HealingVial", "PureLight"},
        difficulty = "Medium",
        size = Vector3.new(130, 40, 130),
        color = Color3.fromRGB(100, 150, 50)
    }
}

-- Create room in workspace
function RoomSystem:createRoom(roomData, position)
    local room = Instance.new("Model")
    room.Name = roomData.name
    
    -- Main floor
    local floor = Instance.new("Part")
    floor.Name = "Floor"
    floor.Shape = Enum.PartType.Block
    floor.Size = roomData.size
    floor.Color = roomData.color
    floor.Material = Enum.Material.Concrete
    floor.CanCollide = true
    floor.CFrame = position
    floor.Parent = room
    
    -- Walls
    local wallThickness = 5
    local wallHeight = roomData.size.Y
    
    -- North wall
    local northWall = Instance.new("Part")
    northWall.Name = "NorthWall"
    northWall.Size = Vector3.new(roomData.size.X, wallHeight, wallThickness)
    northWall.Color = roomData.color
    northWall.Material = Enum.Material.Concrete
    northWall.CFrame = position + Vector3.new(0, wallHeight/2, -roomData.size.Z/2)
    northWall.Parent = room
    
    -- South wall
    local southWall = Instance.new("Part")
    southWall.Name = "SouthWall"
    southWall.Size = Vector3.new(roomData.size.X, wallHeight, wallThickness)
    southWall.Color = roomData.color
    southWall.Material = Enum.Material.Concrete
    southWall.CFrame = position + Vector3.new(0, wallHeight/2, roomData.size.Z/2)
    southWall.Parent = room
    
    -- East wall
    local eastWall = Instance.new("Part")
    eastWall.Name = "EastWall"
    eastWall.Size = Vector3.new(wallThickness, wallHeight, roomData.size.Z)
    eastWall.Color = roomData.color
    eastWall.Material = Enum.Material.Concrete
    eastWall.CFrame = position + Vector3.new(roomData.size.X/2, wallHeight/2, 0)
    eastWall.Parent = room
    
    -- West wall
    local westWall = Instance.new("Part")
    westWall.Name = "WestWall"
    westWall.Size = Vector3.new(wallThickness, wallHeight, roomData.size.Z)
    westWall.Color = roomData.color
    westWall.Material = Enum.Material.Concrete
    westWall.CFrame = position + Vector3.new(-roomData.size.X/2, wallHeight/2, 0)
    westWall.Parent = room
    
    -- Ceiling
    local ceiling = Instance.new("Part")
    ceiling.Name = "Ceiling"
    ceiling.Size = roomData.size
    ceiling.Color = roomData.color
    ceiling.Material = Enum.Material.Concrete
    ceiling.CFrame = position + Vector3.new(0, wallHeight, 0)
    ceiling.Parent = room
    
    room.Parent = workspace
    table.insert(self.activeRooms, room)
    
    return room
end

-- Add hazards to room
function RoomSystem:addHazards(room, hazards)
    for i, hazardName in ipairs(hazards) do
        if hazardName == "Lava floors" then
            local lava = Instance.new("Part")
            lava.Name = "Lava"
            lava.Shape = Enum.PartType.Block
            lava.Size = Vector3.new(30, 2, 30)
            lava.Color = Color3.fromRGB(255, 100, 0)
            lava.Material = Enum.Material.Neon
            lava.CanCollide = true
            lava.CFrame = room:FindFirstChild("Floor").CFrame + Vector3.new(20 * i, 1, 20 * i)
            lava.Touched:Connect(function(hit)
                if hit.Parent:FindFirstChild("Humanoid") then
                    hit.Parent:FindFirstChild("Humanoid"):TakeDamage(10)
                end
            end)
            lava.Parent = room
            
        elseif hazardName == "Fire geysers" then
            local geyser = Instance.new("Part")
            geyser.Name = "FireGeyser"
            geyser.Shape = Enum.PartType.Cylinder
            geyser.Size = Vector3.new(10, 40, 10)
            geyser.Color = Color3.fromRGB(255, 100, 0)
            geyser.Material = Enum.Material.Neon
            geyser.CanCollide = false
            geyser.CFrame = room:FindFirstChild("Floor").CFrame + Vector3.new(30 * i, 20, -30 * i)
            geyser.Parent = room
            
        elseif hazardName == "Ice floors" then
            local ice = Instance.new("Part")
            ice.Name = "IceFloor"
            ice.Shape = Enum.PartType.Block
            ice.Size = Vector3.new(30, 1, 30)
            ice.Color = Color3.fromRGB(0, 180, 255)
            ice.Material = Enum.Material.Ice
            ice.CanCollide = true
            ice.CFrame = room:FindFirstChild("Floor").CFrame + Vector3.new(20 * i, 0.5, -20 * i)
            ice.Parent = room
            
        elseif hazardName == "Lightning strikes" then
            local lightning = Instance.new("Part")
            lightning.Name = "Lightning"
            lightning.Shape = Enum.PartType.Block
            lightning.Size = Vector3.new(20, 100, 20)
            lightning.Color = Color3.fromRGB(255, 200, 0)
            lightning.Material = Enum.Material.Neon
            lightning.CanCollide = false
            lightning.CFrame = room:FindFirstChild("Floor").CFrame + Vector3.new(40 * i, 50, 0)
            lightning.Parent = room
            
        elseif hazardName == "Poison gas" then
            local poison = Instance.new("Part")
            poison.Name = "PoisonGas"
            poison.Shape = Enum.PartType.Ball
            poison.Size = Vector3.new(50, 50, 50)
            poison.Color = Color3.fromRGB(100, 150, 50)
            poison.Material = Enum.Material.Neon
            poison.CanCollide = false
            poison.CFrame = room:FindFirstChild("Floor").CFrame + Vector3.new(0, 25, 0)
            poison.Touched:Connect(function(hit)
                if hit.Parent:FindFirstChild("Humanoid") then
                    hit.Parent:FindFirstChild("Humanoid"):TakeDamage(5)
                end
            end)
            poison.Parent = room
        end
    end
end

-- Add reward items to room
function RoomSystem:addRewards(room, rewards)
    for i, rewardName in ipairs(rewards) do
        local reward = Instance.new("Part")
        reward.Name = rewardName
        reward.Shape = Enum.PartType.Ball
        reward.Size = Vector3.new(3, 3, 3)
        reward.Color = Color3.fromRGB(255, 215, 0)
        reward.Material = Enum.Material.Neon
        reward.CanCollide = true
        reward.CFrame = room:FindFirstChild("Floor").CFrame + Vector3.new(40 * i, 5, -40 * i)
        reward.Parent = room
    end
end

-- Get room info
function RoomSystem:getRoomInfo(roomName)
    for _, room in ipairs(self.rooms) do
        if room.name == roomName then
            return room
        end
    end
    return nil
end

-- Display all rooms
function RoomSystem:displayAllRooms()
    print("\n╔════════════════════════════════╗")
    print("║      CUSTOM ROOMS (6 TOTAL)     ║")
    print("╚════════════════════════════════╝")
    for i, room in ipairs(self.rooms) do
        print(string.format("%d. %-20s [%s]", i, room.name, room.difficulty))
        print("   Theme: " .. room.theme)
        print("   Hazards: " .. table.concat(room.hazards, ", "))
        print("   Rewards: " .. table.concat(room.rewards, ", "))
        print()
    end
end

return RoomSystem
