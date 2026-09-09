--[[ 
    STARLIGHT JUG COPY - DOORS ROBLOX LUA SCRIPT
    Replicates the Starlight Jug functionality from DOORS
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- STARLIGHT JUG CONFIG
local STARLIGHT_JUG = {
    isActive = false,
    duration = 60, -- seconds
    radius = 100, -- studs
    brightness = 3,
    range = 100,
    color = Color3.fromRGB(0, 150, 255), -- Cyan/Blue starlight color
    cooldown = 30,
    lastUsed = 0,
    entitySpeedReduction = 0.3, -- Entities move at 30% speed
    playerSpeedBoost = 1.5, -- Player moves 50% faster
    effectParticles = {},
    affectedEntities = {},
}

-- STARLIGHT JUG LIGHT
local jugLight = Instance.new("Part")
jugLight.Name = "StarlightJugLight"
jugLight.Shape = Enum.PartType.Ball
jugLight.Size = Vector3.new(2, 2, 2)
jugLight.Color = STARLIGHT_JUG.color
jugLight.Material = Enum.Material.Neon
jugLight.CanCollide = false
jugLight.CFrame = rootPart.CFrame + rootPart.CFrame.LookVector * 5

-- POINT LIGHT
local pointLight = Instance.new("PointLight")
pointLight.Brightness = 0
pointLight.Range = STARLIGHT_JUG.range
pointLight.Color = STARLIGHT_JUG.color
pointLight.Parent = jugLight

jugLight.Parent = workspace

-- FUNCTION: Activate Starlight Jug
local function activateStarlightJug()
    local currentTime = tick()
    if currentTime - STARLIGHT_JUG.lastUsed < STARLIGHT_JUG.cooldown then
        print("[STARLIGHT JUG] Still on cooldown! Wait " .. math.ceil(STARLIGHT_JUG.cooldown - (currentTime - STARLIGHT_JUG.lastUsed)) .. "s")
        return
    end
    
    STARLIGHT_JUG.isActive = true
    STARLIGHT_JUG.lastUsed = currentTime
    
    print("[STARLIGHT JUG] ACTIVATED!")
    print("[EFFECT] Light radius: " .. STARLIGHT_JUG.radius .. " studs")
    print("[EFFECT] Duration: " .. STARLIGHT_JUG.duration .. " seconds")
    
    -- Smoothly increase brightness
    for i = 0, STARLIGHT_JUG.brightness, 0.1 do
        pointLight.Brightness = i
        wait(0.05)
    end
    
    -- Create starlight aura
    local aura = Instance.new("Part")
    aura.Name = "StarlightAura"
    aura.Shape = Enum.PartType.Ball
    aura.Size = Vector3.new(STARLIGHT_JUG.radius * 2, STARLIGHT_JUG.radius * 2, STARLIGHT_JUG.radius * 2)
    aura.Color = STARLIGHT_JUG.color
    aura.Material = Enum.Material.Neon
    aura.Transparency = 0.7
    aura.CanCollide = false
    aura.CFrame = rootPart.CFrame
    aura.Parent = workspace
    
    -- Entity slowdown effect
    local function slowDownEntities()
        local region = Region3.new(rootPart.Position - Vector3.new(STARLIGHT_JUG.radius, STARLIGHT_JUG.radius, STARLIGHT_JUG.radius), 
                                   rootPart.Position + Vector3.new(STARLIGHT_JUG.radius, STARLIGHT_JUG.radius, STARLIGHT_JUG.radius))
        region = region:ExpandToGrid(4)
        
        for _, part in pairs(workspace:FindPartiesInRegion3(region, nil, 100)) do
            if part.Parent and part.Parent:FindFirstChild("Humanoid") and part.Parent ~= character then
                local entity = part.Parent
                if not table.find(STARLIGHT_JUG.affectedEntities, entity) then
                    table.insert(STARLIGHT_JUG.affectedEntities, entity)
                    
                    local originalSpeed = entity:FindFirstChild("Humanoid").WalkSpeed or 20
                    entity:FindFirstChild("Humanoid").WalkSpeed = originalSpeed * STARLIGHT_JUG.entitySpeedReduction
                    
                    -- Make entity glow red (scared of light)
                    for _, part in pairs(entity:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Color = Color3.fromRGB(255, 0, 0)
                        end
                    end
                end
            end
        end
    end
    
    -- Speed boost for player
    local originalHumanoidSpeed = humanoid.WalkSpeed
    humanoid.WalkSpeed = originalHumanoidSpeed * STARLIGHT_JUG.playerSpeedBoost
    
    -- Main duration loop
    local startTime = tick()
    while tick() - startTime < STARLIGHT_JUG.duration and STARLIGHT_JUG.isActive do
        -- Update aura position
        aura.CFrame = rootPart.CFrame
        jugLight.CFrame = rootPart.CFrame + rootPart.CFrame.LookVector * 5
        
        -- Slow entities
        slowDownEntities()
        
        -- Create particle effects
        local particle = Instance.new("Part")
        particle.Name = "StarlightParticle"
        particle.Shape = Enum.PartType.Ball
        particle.Size = Vector3.new(0.5, 0.5, 0.5)
        particle.Color = STARLIGHT_JUG.color
        particle.Material = Enum.Material.Neon
        particle.CanCollide = false
        particle.CFrame = rootPart.CFrame + Vector3.new(math.random(-30, 30), math.random(-30, 30), math.random(-30, 30))
        particle.Parent = workspace
        game:GetService("Debris"):AddItem(particle, 2)
        
        wait(0.1)
    end
    
    -- Deactivate effect
    STARLIGHT_JUG.isActive = false
    
    -- Restore entity speeds and colors
    for _, entity in ipairs(STARLIGHT_JUG.affectedEntities) do
        if entity and entity.Parent then
            local originalSpeed = entity:FindFirstChild("Humanoid").WalkSpeed or 20
            entity:FindFirstChild("Humanoid").WalkSpeed = originalSpeed / STARLIGHT_JUG.entitySpeedReduction
            
            -- Restore original color
            for _, part in pairs(entity:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Color = Color3.fromRGB(50, 50, 50)
                end
            end
        end
    end
    
    STARLIGHT_JUG.affectedEntities = {}
    
    -- Restore player speed
    humanoid.WalkSpeed = originalHumanoidSpeed
    
    -- Fade out effect
    for i = STARLIGHT_JUG.brightness, 0, -0.1 do
        pointLight.Brightness = i
        wait(0.05)
    end
    
    -- Remove aura
    aura:Destroy()
    
    print("[STARLIGHT JUG] Deactivated! Cooldown: " .. STARLIGHT_JUG.cooldown .. "s")
end

-- FUNCTION: Display Starlight Jug Info
local function displayJugInfo()
    print("\n╔═══════════════════════════════╗")
    print("║    STARLIGHT JUG - INFO       ║")
    print("╚═══════════════════════════════╝")
    print("Status: " .. (STARLIGHT_JUG.isActive and "ACTIVE" or "INACTIVE"))
    print("Radius: " .. STARLIGHT_JUG.radius .. " studs")
    print("Duration: " .. STARLIGHT_JUG.duration .. " seconds")
    print("Brightness: " .. STARLIGHT_JUG.brightness)
    print("Entity Speed Reduction: " .. (STARLIGHT_JUG.entitySpeedReduction * 100) .. "%")
    print("Player Speed Boost: " .. (STARLIGHT_JUG.playerSpeedBoost * 100) .. "%")
    print("Cooldown: " .. STARLIGHT_JUG.cooldown .. " seconds")
    local timeUntilReady = math.max(0, STARLIGHT_JUG.cooldown - (tick() - STARLIGHT_JUG.lastUsed))
    print("Ready in: " .. math.ceil(timeUntilReady) .. "s")
    print("══════════════════════════════\n")
end

-- INPUT BINDINGS
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.J then
        activateStarlightJug()
    elseif input.KeyCode == Enum.KeyCode.U then
        displayJugInfo()
    end
end)

-- UPDATE JUG POSITION
RunService.Heartbeat:Connect(function()
    if jugLight and jugLight.Parent then
        jugLight.CFrame = rootPart.CFrame + rootPart.CFrame.LookVector * 5
    end
end)

-- INITIAL MESSAGE
print("╔════════════════════════════════════╗")
print("║   STARLIGHT JUG - LOADED          ║")
print("║   Press J to activate the jug     ║")
print("║   Press U for jug info            ║")
print("╚════════════════════════════════════╝\n")

displayJugInfo()
