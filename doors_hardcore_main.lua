--[[ 
    DOORS HARDCORE SCRIPT - ROBLOX EXECUTOR
    12 Custom Entities + Custom Items + Custom Rooms
    Designed for DOORS horror game
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- CONFIG
local CONFIG = {
    godMode = true,
    infStamina = true,
    noclip = false,
    speedMultiplier = 1.5,
    jumpPower = 50,
    entitySpawnRate = 0.3,
}

-- CUSTOM ENTITIES TABLE
local CUSTOM_ENTITIES = {
    {
        name = "ShadowWraith",
        health = 100,
        speed = 35,
        damage = 25,
        color = Color3.fromRGB(20, 20, 40),
        size = Vector3.new(2.5, 3.5, 1.2),
        ability = "phaseWalk"
    },
    {
        name = "CrimsonHunter",
        health = 150,
        speed = 40,
        damage = 35,
        color = Color3.fromRGB(200, 0, 0),
        size = Vector3.new(2, 4, 1.5),
        ability = "leapAttack"
    },
    {
        name = "VoidGhost",
        health = 80,
        speed = 45,
        damage = 20,
        color = Color3.fromRGB(75, 0, 130),
        size = Vector3.new(1.8, 3.8, 0.9),
        ability = "teleport"
    },
    {
        name = "IceStalker",
        health = 120,
        speed = 32,
        damage = 28,
        color = Color3.fromRGB(0, 180, 255),
        size = Vector3.new(2.3, 3.6, 1.1),
        ability = "freeze"
    },
    {
        name = "InfernoDevil",
        health = 140,
        speed = 38,
        damage = 40,
        color = Color3.fromRGB(255, 100, 0),
        size = Vector3.new(2.8, 3.9, 1.4),
        ability = "burnAura"
    },
    {
        name = "PestilentCreature",
        health = 110,
        speed = 36,
        damage = 22,
        color = Color3.fromRGB(100, 150, 50),
        size = Vector3.new(2.1, 3.7, 1.3),
        ability = "poisonAura"
    },
    {
        name = "SilentReaper",
        health = 95,
        speed = 42,
        damage = 30,
        color = Color3.fromRGB(50, 50, 50),
        size = Vector3.new(1.9, 4.2, 1),
        ability = "invisibility"
    },
    {
        name = "ThunderBeast",
        health = 130,
        speed = 39,
        damage = 33,
        color = Color3.fromRGB(255, 200, 0),
        size = Vector3.new(2.6, 3.8, 1.2),
        ability = "electricShock"
    },
    {
        name = "AbyssalTentacle",
        health = 125,
        speed = 30,
        damage = 27,
        color = Color3.fromRGB(30, 0, 60),
        size = Vector3.new(2.2, 4.1, 2),
        ability = "rootAttack"
    },
    {
        name = "SpecterWolf",
        health = 105,
        speed = 44,
        damage = 26,
        color = Color3.fromRGB(150, 150, 200),
        size = Vector3.new(1.7, 2.5, 1.8),
        ability = "packHunt"
    },
    {
        name = "PlagueLord",
        health = 160,
        speed = 33,
        damage = 38,
        color = Color3.fromRGB(90, 200, 100),
        size = Vector3.new(2.9, 4.3, 1.6),
        ability = "diseaseSpread"
    },
    {
        name = "VortexEntity",
        health = 115,
        speed = 41,
        damage = 32,
        color = Color3.fromRGB(200, 50, 200),
        size = Vector3.new(2.4, 3.5, 1.1),
        ability = "spaceWarp"
    }
}

-- CUSTOM ITEMS TABLE
local CUSTOM_ITEMS = {
    {
        name = "SoulEssence",
        rarity = "Legendary",
        effect = "Heal 50HP + Invincibility 10s",
        color = Color3.fromRGB(255, 215, 0)
    },
    {
        name = "VoidShard",
        rarity = "Epic",
        effect = "Teleport to nearest safe room",
        color = Color3.fromRGB(100, 0, 200)
    },
    {
        name = "CrimsonAmulet",
        rarity = "Rare",
        effect = "Increase damage by 50% for 15s",
        color = Color3.fromRGB(200, 0, 0)
    },
    {
        name = "FrostGem",
        rarity = "Rare",
        effect = "Freeze all enemies for 5s",
        color = Color3.fromRGB(0, 200, 255)
    },
    {
        name = "ThunderCore",
        rarity = "Epic",
        effect = "AOE electric damage to nearby enemies",
        color = Color3.fromRGB(255, 200, 0)
    },
    {
        name = "ShadowCloak",
        rarity = "Rare",
        effect = "Become invisible for 8s",
        color = Color3.fromRGB(30, 30, 50)
    },
    {
        name = "HealingVial",
        rarity = "Common",
        effect = "Restore 30HP instantly",
        color = Color3.fromRGB(0, 255, 100)
    },
    {
        name = "SpecterOrb",
        rarity = "Epic",
        effect = "Create protective barrier (5 hits)",
        color = Color3.fromRGB(150, 100, 255)
    },
    {
        name = "InfernoCrystal",
        rarity = "Rare",
        effect = "Burn ground in 15 stud radius",
        color = Color3.fromRGB(255, 100, 0)
    },
    {
        name = "PureLight",
        rarity = "Legendary",
        effect = "Destroy all nearby entities",
        color = Color3.fromRGB(255, 255, 255)
    }
}

-- CUSTOM ROOMS TABLE
local CUSTOM_ROOMS = {
    {
        name = "ShadowVault",
        theme = "Dark underground chamber",
        hazards = {"Shadow pools", "Phantom guardians"},
        rewards = {"VoidShard", "ShadowCloak"},
        difficulty = "Hard"
    },
    {
        name = "InfernoLair",
        theme = "Fiery cavern with lava",
        hazards = {"Lava floors", "Fire geysers"},
        rewards = {"InfernoCrystal", "ThunderCore"},
        difficulty = "Extreme"
    },
    {
        name = "FrozenTombs",
        theme = "Ancient ice-covered tombs",
        hazards = {"Ice floors", "Frozen spikes"},
        rewards = {"FrostGem", "HealingVial"},
        difficulty = "Hard"
    },
    {
        name = "ThunderSpire",
        theme = "Electric tower of power",
        hazards = {"Lightning strikes", "Electric floors"},
        rewards = {"ThunderCore", "SpecterOrb"},
        difficulty = "Hard"
    },
    {
        name = "AbyssDepths",
        theme = "Cosmic void chamber",
        hazards = {"Void rifts", "Reality tears"},
        rewards = {"SoulEssence", "VoidShard"},
        difficulty = "Nightmare"
    },
    {
        name = "PoisonGarden",
        theme = "Toxic vegetation maze",
        hazards = {"Poison gas", "Carnivorous plants"},
        rewards = {"HealingVial", "PureLight"},
        difficulty = "Medium"
    }
}

-- PLAYER STATS
local PlayerStats = {
    health = 100,
    maxHealth = 100,
    stamina = 100,
    maxStamina = 100,
    level = 1,
    experience = 0,
    inventory = {},
}

-- FUNCTION: Apply God Mode
local function applyGodMode()
    if CONFIG.godMode then
        humanoid.Health = PlayerStats.maxHealth
        humanoid:FindFirstChild("Died"):Destroy()
    end
end

-- FUNCTION: Apply Infinite Stamina
local function applyInfiniteStamina()
    if CONFIG.infStamina then
        PlayerStats.stamina = PlayerStats.maxStamina
    end
end

-- FUNCTION: Noclip Toggle
local function toggleNoclip()
    CONFIG.noclip = not CONFIG.noclip
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not CONFIG.noclip
        end
    end
end

-- FUNCTION: Increase Speed
local function increaseSpeed()
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        humanoidRootPart.Velocity = humanoidRootPart.Velocity * CONFIG.speedMultiplier
    end
end

-- FUNCTION: Create Custom Entity
local function createCustomEntity(entityData, spawnPosition)
    local entity = Instance.new("Model")
    entity.Name = entityData.name
    
    local body = Instance.new("Part")
    body.Shape = Enum.PartType.Block
    body.Size = entityData.size
    body.Color = entityData.color
    body.Material = Enum.Material.SmoothPlastic
    body.CanCollide = true
    body.CFrame = spawnPosition
    body.Parent = entity
    
    local humanoid = Instance.new("Humanoid")
    humanoid.Parent = entity
    humanoid.MaxHealth = entityData.health
    humanoid.Health = entityData.health
    
    entity.Parent = workspace
    
    return entity
end

-- FUNCTION: Add Item to Inventory
local function addItemToInventory(itemData)
    table.insert(PlayerStats.inventory, itemData)
    print("[ITEM ACQUIRED] " .. itemData.name .. " (" .. itemData.rarity .. ")")
end

-- FUNCTION: Use Item
local function useItem(itemName)
    for i, item in ipairs(PlayerStats.inventory) do
        if item.name == itemName then
            print("[ITEM USED] " .. itemName .. ": " .. item.effect)
            table.remove(PlayerStats.inventory, i)
            
            -- Apply item effects
            if itemName == "SoulEssence" then
                PlayerStats.health = PlayerStats.maxHealth
                print("[EFFECT] Full heal + Invincibility activated!")
            elseif itemName == "HealingVial" then
                PlayerStats.health = math.min(PlayerStats.health + 30, PlayerStats.maxHealth)
            elseif itemName == "FrostGem" then
                print("[EFFECT] All enemies frozen for 5 seconds!")
            end
            break
        end
    end
end

-- FUNCTION: Display Custom Room Info
local function displayRoomInfo(roomData)
    print("\n=== ENTERING CUSTOM ROOM ===")
    print("Room: " .. roomData.name)
    print("Theme: " .. roomData.theme)
    print("Difficulty: " .. roomData.difficulty)
    print("Hazards: " .. table.concat(roomData.hazards, ", "))
    print("Rewards: " .. table.concat(roomData.rewards, ", "))
    print("===========================\n")
end

-- FUNCTION: Spawn Random Entity
local function spawnRandomEntity()
    if math.random() < CONFIG.entitySpawnRate then
        local randomEntity = CUSTOM_ENTITIES[math.random(1, #CUSTOM_ENTITIES)]
        local spawnPos = rootPart.Position + Vector3.new(math.random(-50, 50), 0, math.random(-50, 50))
        createCustomEntity(randomEntity, CFrame.new(spawnPos))
        print("[ENTITY SPAWNED] " .. randomEntity.name)
    end
end

-- FUNCTION: Gain Experience
local function gainExperience(amount)
    PlayerStats.experience = PlayerStats.experience + amount
    local levelUp = math.floor(PlayerStats.experience / 100)
    if levelUp > PlayerStats.level then
        PlayerStats.level = levelUp
        PlayerStats.maxHealth = 100 + (PlayerStats.level * 20)
        print("[LEVEL UP!] Level: " .. PlayerStats.level .. " | Max Health: " .. PlayerStats.maxHealth)
    end
end

-- FUNCTION: Display Player Stats
local function displayStats()
    print("\n=== PLAYER STATS ===")
    print("Health: " .. PlayerStats.health .. "/" .. PlayerStats.maxHealth)
    print("Stamina: " .. PlayerStats.stamina .. "/" .. PlayerStats.maxStamina)
    print("Level: " .. PlayerStats.level)
    print("Experience: " .. PlayerStats.experience)
    print("Inventory: " .. #PlayerStats.inventory .. " items")
    print("====================\n")
end

-- FUNCTION: Display Inventory
local function displayInventory()
    print("\n=== INVENTORY ===")
    if #PlayerStats.inventory == 0 then
        print("Empty!")
    else
        for i, item in ipairs(PlayerStats.inventory) do
            print(i .. ". " .. item.name .. " [" .. item.rarity .. "]")
        end
    end
    print("=================\n")
end

-- FUNCTION: Display All Entities
local function displayCustomEntities()
    print("\n=== CUSTOM ENTITIES (12) ===")
    for i, entity in ipairs(CUSTOM_ENTITIES) do
        print(i .. ". " .. entity.name .. " | HP: " .. entity.health .. " | Speed: " .. entity.speed .. " | Ability: " .. entity.ability)
    end
    print("=============================\n")
end

-- FUNCTION: Display All Custom Items
local function displayCustomItems()
    print("\n=== CUSTOM ITEMS ===")
    for i, item in ipairs(CUSTOM_ITEMS) do
        print(i .. ". " .. item.name .. " [" .. item.rarity .. "] - " .. item.effect)
    end
    print("====================\n")
end

-- FUNCTION: Display All Custom Rooms
local function displayCustomRooms()
    print("\n=== CUSTOM ROOMS ===")
    for i, room in ipairs(CUSTOM_ROOMS) do
        print(i .. ". " .. room.name .. " [" .. room.difficulty .. "]")
    end
    print("====================\n")
end

-- INPUT BINDINGS
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.G then
        toggleNoclip()
        print("[NOCLIP] " .. (CONFIG.noclip and "ENABLED" or "DISABLED"))
    elseif input.KeyCode == Enum.KeyCode.H then
        displayStats()
    elseif input.KeyCode == Enum.KeyCode.I then
        displayInventory()
    elseif input.KeyCode == Enum.KeyCode.E then
        displayCustomEntities()
    elseif input.KeyCode == Enum.KeyCode.O then
        displayCustomItems()
    elseif input.KeyCode == Enum.KeyCode.R then
        displayCustomRooms()
    elseif input.KeyCode == Enum.KeyCode.K then
        gainExperience(50)
    elseif input.KeyCode == Enum.KeyCode.L then
        addItemToInventory(CUSTOM_ITEMS[math.random(1, #CUSTOM_ITEMS)])
    elseif input.KeyCode == Enum.KeyCode.M then
        local randomRoom = CUSTOM_ROOMS[math.random(1, #CUSTOM_ROOMS)]
        displayRoomInfo(randomRoom)
    elseif input.KeyCode == Enum.KeyCode.F then
        spawnRandomEntity()
    end
end)

-- MAIN LOOP
RunService.Heartbeat:Connect(function()
    if CONFIG.godMode then
        applyGodMode()
    end
    
    if CONFIG.infStamina then
        applyInfiniteStamina()
    end
    
    -- Periodic entity spawning
    if math.random() < 0.05 then
        spawnRandomEntity()
    end
end)

-- INITIAL MESSAGE
print("╔════════════════════════════════════════╗")
print("║   DOORS HARDCORE SCRIPT - LOADED   ║")
print("║  12 Custom Entities + Items + Rooms   ║")
print("╚════════════════════════════════════════╝")
print("\nKEYBINDS:")
print("G - Toggle Noclip")
print("H - Show Stats")
print("I - Show Inventory")
print("E - Show All Entities")
print("O - Show All Items")
print("R - Show All Rooms")
print("K - Gain 50 EXP")
print("L - Get Random Item")
print("M - Enter Random Room")
print("F - Spawn Random Entity\n")

displayStats()
