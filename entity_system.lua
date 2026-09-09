--[[ 
    ADVANCED ENTITY SYSTEM MODULE
    Handles all 12 custom entities with unique abilities
]]--

local EntitySystem = {}
EntitySystem.activeEntities = {}

-- ENTITY ABILITIES
local Abilities = {
    phaseWalk = function(entity, target)
        -- ShadowWraith phases through walls
        for _, part in pairs(entity:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        wait(3)
        for _, part in pairs(entity:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end,
    
    leapAttack = function(entity, target)
        -- CrimsonHunter leaps at player
        local rootPart = entity:FindFirstChild(entity:FindFirstChild("HumanoidRootPart") and "HumanoidRootPart" or "Part")
        if rootPart and target then
            rootPart.Velocity = (target.Position - rootPart.Position).Unit * 100
        end
    end,
    
    teleport = function(entity, target)
        -- VoidGhost teleports around
        local rootPart = entity:FindFirstChild("HumanoidRootPart") or entity:FindFirstChild("Part")
        if rootPart then
            rootPart.CFrame = rootPart.CFrame + Vector3.new(math.random(-50, 50), math.random(-20, 20), math.random(-50, 50))
        end
    end,
    
    freeze = function(entity, target)
        -- IceStalker freezes player
        if target then
            local humanoid = target:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 5
                wait(5)
                humanoid.WalkSpeed = 16
            end
        end
    end,
    
    burnAura = function(entity, target)
        -- InfernoDevil creates burning aura
        local rootPart = entity:FindFirstChild("HumanoidRootPart") or entity:FindFirstChild("Part")
        if rootPart then
            local aura = Instance.new("Part")
            aura.Shape = Enum.PartType.Ball
            aura.Size = Vector3.new(20, 20, 20)
            aura.Color = Color3.fromRGB(255, 100, 0)
            aura.Material = Enum.Material.Neon
            aura.CanCollide = false
            aura.CFrame = rootPart.CFrame
            aura.Parent = workspace
            game:GetService("Debris"):AddItem(aura, 5)
        end
    end,
    
    poisonAura = function(entity, target)
        -- PestilentCreature spreads poison
        local rootPart = entity:FindFirstChild("HumanoidRootPart") or entity:FindFirstChild("Part")
        if rootPart then
            local poison = Instance.new("Part")
            poison.Shape = Enum.PartType.Ball
            poison.Size = Vector3.new(25, 25, 25)
            poison.Color = Color3.fromRGB(100, 150, 50)
            poison.Material = Enum.Material.Neon
            poison.CanCollide = false
            poison.CFrame = rootPart.CFrame
            poison.Parent = workspace
            game:GetService("Debris"):AddItem(poison, 6)
        end
    end,
    
    invisibility = function(entity, target)
        -- SilentReaper becomes invisible
        for _, part in pairs(entity:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
        wait(4)
        for _, part in pairs(entity:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
    end,
    
    electricShock = function(entity, target)
        -- ThunderBeast creates electric shock
        local rootPart = entity:FindFirstChild("HumanoidRootPart") or entity:FindFirstChild("Part")
        if rootPart then
            local shock = Instance.new("Part")
            shock.Shape = Enum.PartType.Ball
            shock.Size = Vector3.new(30, 30, 30)
            shock.Color = Color3.fromRGB(255, 200, 0)
            shock.Material = Enum.Material.Neon
            shock.CanCollide = false
            shock.CFrame = rootPart.CFrame
            shock.Parent = workspace
            game:GetService("Debris"):AddItem(shock, 3)
        end
    end,
    
    rootAttack = function(entity, target)
        -- AbyssalTentacle roots player
        if target then
            local humanoid = target:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 0
                wait(4)
                humanoid.WalkSpeed = 16
            end
        end
    end,
    
    packHunt = function(entity, target)
        -- SpecterWolf hunts in pack
        local rootPart = entity:FindFirstChild("HumanoidRootPart") or entity:FindFirstChild("Part")
        if rootPart and target then
            rootPart.Velocity = (target.Position - rootPart.Position).Unit * 80
        end
    end,
    
    diseaseSpread = function(entity, target)
        -- PlagueLord spreads disease
        local rootPart = entity:FindFirstChild("HumanoidRootPart") or entity:FindFirstChild("Part")
        if rootPart then
            local disease = Instance.new("Part")
            disease.Shape = Enum.PartType.Ball
            disease.Size = Vector3.new(35, 35, 35)
            disease.Color = Color3.fromRGB(90, 200, 100)
            disease.Material = Enum.Material.Neon
            disease.CanCollide = false
            disease.CFrame = rootPart.CFrame
            disease.Parent = workspace
            game:GetService("Debris"):AddItem(disease, 7)
        end
    end,
    
    spaceWarp = function(entity, target)
        -- VortexEntity warps space
        local rootPart = entity:FindFirstChild("HumanoidRootPart") or entity:FindFirstChild("Part")
        if rootPart then
            local warp = Instance.new("Part")
            warp.Shape = Enum.PartType.Ball
            warp.Size = Vector3.new(28, 28, 28)
            warp.Color = Color3.fromRGB(200, 50, 200)
            warp.Material = Enum.Material.Neon
            warp.CanCollide = false
            warp.CFrame = rootPart.CFrame
            warp.Parent = workspace
            game:GetService("Debris"):AddItem(warp, 5)
        end
    end
}

-- Initialize entity with abilities
function EntitySystem:initializeEntity(entity, entityData)
    local humanoid = entity:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.MaxHealth = entityData.health
        humanoid.Health = entityData.health
    end
    
    entity.Tag = entityData.name
    entity.Speed = entityData.speed
    entity.Damage = entityData.damage
    entity.Ability = entityData.ability
    
    table.insert(self.activeEntities, entity)
end

-- Use entity ability
function EntitySystem:useAbility(entity, target)
    if entity.Ability and Abilities[entity.Ability] then
        Abilities[entity.Ability](entity, target)
    end
end

return EntitySystem
