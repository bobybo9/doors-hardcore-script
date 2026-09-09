--[[ 
    CRUCIFIX SCRIPT - DOORS ROBLOX LUA
    Repels/Destroys entities like the real DOORS crucifix
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- CRUCIFIX CONFIG
local CRUCIFIX = {
    isActive = false,
    isHeld = false,
    repelRadius = 80, -- studs
    repelForce = 150, -- velocity
    damagePerTick = 5,
    burnDuration = 8, -- seconds
    cooldown = 20,
    lastUsed = 0,
    maxHealth = 100,
    currentHealth = 100,
    durability = 100,
    maxDurability = 100,
    color = Color3.fromRGB(200, 0, 0), -- Red crucifix
    affectedEntities = {},
}

-- CREATE CRUCIFIX MODEL
local crucifix = Instance.new("Model")
crucifix.Name = "Crucifix"

-- Main cross body (vertical)
local verticalPart = Instance.new("Part")
verticalPart.Name = "Vertical"
verticalPart.Shape = Enum.PartType.Block
verticalPart.Size = Vector3.new(1, 8, 0.5)
verticalPart.Color = CRUCIFIX.color
verticalPart.Material = Enum.Material.Wood
verticalPart.CanCollide = false
verticalPart.CFrame = rootPart.CFrame + rootPart.CFrame.LookVector * 5
verticalPart.Parent = crucifix

-- Horizontal cross body
local horizontalPart = Instance.new("Part")
horizontalPart.Name = "Horizontal"
horizontalPart.Shape = Enum.PartType.Block
horizontalPart.Size = Vector3.new(6, 1, 0.5)
horizontalPart.Color = CRUCIFIX.color
horizontalPart.Material = Enum.Material.Wood
horizontalPart.CanCollide = false
horizontalPart.CFrame = rootPart.CFrame + rootPart.CFrame.LookVector * 5 + Vector3.new(0, 1.5, 0)
horizontalPart.Parent = crucifix

-- Weld parts together
local weld = Instance.new("WeldConstraint")
weld.Part0 = verticalPart
weld.Part1 = horizontalPart
weld.Parent = horizontalPart

-- Point light effect (holy glow)
local holyLight = Instance.new("PointLight")
holyLight.Brightness = 0.5
holyLight.Range = 30
holyLight.Color = CRUCIFIX.color
holyLight.Parent = verticalPart

crucifix.Parent = workspace

-- FUNCTION: Activate Crucifix
local function activateCrucifix()
    local currentTime = tick()
    if currentTime - CRUCIFIX.lastUsed < CRUCIFIX.cooldown then
        print("[CRUCIFIX] Still on cooldown! Wait " .. math.ceil(CRUCIFIX.cooldown - (currentTime - CRUCIFIX.lastUsed)) .. "s")
        return
    end
    
    if CRUCIFIX.currentHealth <= 0 then
        print("[CRUCIFIX] Broken! Needs repair!")
        return
    end
    
    CRUCIFIX.isActive = true
    CRUCIFIX.lastUsed = currentTime
    
    print("[CRUCIFIX] ✝ ACTIVATED!")
    print("[EFFECT] Repel radius: " .. CRUCIFIX.repelRadius .. " studs")
    print("[EFFECT] Damage: " .. CRUCIFIX.damagePerTick .. " per tick")
    
    -- Increase brightness
    holyLight.Brightness = 2
    
    -- Create holy explosion effect
    local explosion = Instance.new("Part")
    explosion.Name = "HolyExplosion"
    explosion.Shape = Enum.PartType.Ball
    explosion.Size = Vector3.new(CRUCIFIX.repelRadius * 2, CRUCIFIX.repelRadius * 2, CRUCIFIX.repelRadius * 2)
    explosion.Color = CRUCIFIX.color
    explosion.Material = Enum.Material.Neon
    explosion.Transparency = 0.6
    explosion.CanCollide = false
    explosion.CFrame = rootPart.CFrame
    explosion.Parent = workspace
    Debris:AddItem(explosion, 1)
    
    -- Find and repel entities
    local region = Region3.new(rootPart.Position - Vector3.new(CRUCIFIX.repelRadius, CRUCIFIX.repelRadius, CRUCIFIX.repelRadius), 
                               rootPart.Position + Vector3.new(CRUCIFIX.repelRadius, CRUCIFIX.repelRadius, CRUCIFIX.repelRadius))
    region = region:ExpandToGrid(4)
    
    local hitEntities = {}
    for _, part in pairs(workspace:FindPartiesInRegion3(region, nil, 100)) do
        if part.Parent and part.Parent:FindFirstChild("Humanoid") and part.Parent ~= character then
            local entity = part.Parent
            if not table.find(hitEntities, entity) then
                table.insert(hitEntities, entity)
                
                -- Repel entity
                local repelDirection = (entity:FindFirstChild("HumanoidRootPart") or part).Position - rootPart.Position
                repelDirection = repelDirection.Unit
                (entity:FindFirstChild("HumanoidRootPart") or part).Velocity = repelDirection * CRUCIFIX.repelForce
                
                -- Damage entity
                local entityHumanoid = entity:FindFirstChild("Humanoid")
                if entityHumanoid then
                    entityHumanoid:TakeDamage(CRUCIFIX.damagePerTick * 3)
                    print("[CRUCIFIX] Hit " .. entity.Name .. "! Damage: " .. (CRUCIFIX.damagePerTick * 3))
                end
                
                -- Burn effect
                for _, bodyPart in pairs(entity:GetDescendants()) do
                    if bodyPart:IsA("BasePart") then
                        bodyPart.Color = Color3.fromRGB(255, 50, 0)
                    end
                end
                
                -- Restore color after burn duration
                task.delay(CRUCIFIX.burnDuration, function()
                    for _, bodyPart in pairs(entity:GetDescendants()) do
                        if bodyPart:IsA("BasePart") then
                            bodyPart.Color = Color3.fromRGB(100, 100, 100)
                        end
                    end
                end)
            end
        end
    end
    
    -- Reduce durability
    CRUCIFIX.currentHealth = math.max(0, CRUCIFIX.currentHealth - 15)
    
    -- Dim light after effect
    wait(0.5)
    holyLight.Brightness = 0.5
    CRUCIFIX.isActive = false
    
    if CRUCIFIX.currentHealth <= 0 then
        print("[CRUCIFIX] Durability depleted! Crucifix is now broken.")
    end
end

-- FUNCTION: Hold Crucifix (continuous repel)
local function holdCrucifix()
    if CRUCIFIX.currentHealth <= 0 then
        print("[CRUCIFIX] Broken! Needs repair!")
        return
    end
    
    CRUCIFIX.isHeld = not CRUCIFIX.isHeld
    
    if CRUCIFIX.isHeld then
        print("[CRUCIFIX] Holding crucifix - continuous repel active!")
        holyLight.Brightness = 1.5
        
        while CRUCIFIX.isHeld and CRUCIFIX.currentHealth > 0 do
            local region = Region3.new(rootPart.Position - Vector3.new(CRUCIFIX.repelRadius, CRUCIFIX.repelRadius, CRUCIFIX.repelRadius), 
                                       rootPart.Position + Vector3.new(CRUCIFIX.repelRadius, CRUCIFIX.repelRadius, CRUCIFIX.repelRadius))
            region = region:ExpandToGrid(4)
            
            for _, part in pairs(workspace:FindPartiesInRegion3(region, nil, 100)) do
                if part.Parent and part.Parent:FindFirstChild("Humanoid") and part.Parent ~= character then
                    local entity = part.Parent
                    local repelDirection = ((entity:FindFirstChild("HumanoidRootPart") or part).Position - rootPart.Position).Unit
                    (entity:FindFirstChild("HumanoidRootPart") or part).Velocity = repelDirection * (CRUCIFIX.repelForce * 0.8)
                end
            end
            
            -- Reduce durability while held
            CRUCIFIX.currentHealth = math.max(0, CRUCIFIX.currentHealth - 1)
            wait(0.3)
        end
        
        holyLight.Brightness = 0.5
        print("[CRUCIFIX] Released crucifix - Durability: " .. CRUCIFIX.currentHealth .. "%")
    else
        print("[CRUCIFIX] Released crucifix")
    end
end

-- FUNCTION: Repair Crucifix
local function repairCrucifix()
    CRUCIFIX.currentHealth = CRUCIFIX.maxHealth
    print("[CRUCIFIX] ✝ Repaired! Durability: " .. CRUCIFIX.currentHealth .. "%")
end

-- FUNCTION: Display Crucifix Info
local function displayCrucifixInfo()
    print("\n╔═══════════════════════════════╗")
    print("║    CRUCIFIX - INFO            ║")
    print("╚═══════════════════════════════╝")
    print("Status: " .. (CRUCIFIX.isHeld and "HELD" or (CRUCIFIX.isActive and "ACTIVE" or "READY")))
    print("Durability: " .. CRUCIFIX.currentHealth .. "/" .. CRUCIFIX.maxHealth)
    print("Repel Radius: " .. CRUCIFIX.repelRadius .. " studs")
    print("Repel Force: " .. CRUCIFIX.repelForce)
    print("Damage Per Tick: " .. CRUCIFIX.damagePerTick)
    print("Burn Duration: " .. CRUCIFIX.burnDuration .. " seconds")
    print("Cooldown: " .. CRUCIFIX.cooldown .. " seconds")
    local timeUntilReady = math.max(0, CRUCIFIX.cooldown - (tick() - CRUCIFIX.lastUsed))
    print("Ready in: " .. math.ceil(timeUntilReady) .. "s")
    print("══════════════════════════════\n")
end

-- INPUT BINDINGS
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.C then
        activateCrucifix()
    elseif input.KeyCode == Enum.KeyCode.V then
        holdCrucifix()
    elseif input.KeyCode == Enum.KeyCode.X then
        repairCrucifix()
    elseif input.KeyCode == Enum.KeyCode.Z then
        displayCrucifixInfo()
    end
end)

-- UPDATE CRUCIFIX POSITION
RunService.Heartbeat:Connect(function()
    if crucifix and crucifix.Parent then
        crucifix:MoveTo(rootPart.Position + rootPart.CFrame.LookVector * 5)
        crucifix:SetPrimaryPartCFrame(rootPart.CFrame + rootPart.CFrame.LookVector * 5)
    end
end)

-- INITIAL MESSAGE
print("╔════════════════════════════════════╗")
print("║   CRUCIFIX SCRIPT - LOADED        ║")
print("║   C - Use crucifix (blast)        ║")
print("║   V - Hold crucifix (continuous) ║")
print("║   X - Repair crucifix            ║")
print("║   Z - Show crucifix info         ║")
print("╚════════════════════════════════════╝\n")

displayCrucifixInfo()
