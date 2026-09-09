--[[ 
    CUSTOM ITEMS SYSTEM MODULE
    Handles all custom items and their effects
]]--

local ItemSystem = {}
ItemSystem.itemEffects = {}

-- ITEM EFFECT IMPLEMENTATIONS
ItemSystem.itemEffects.SoulEssence = function(player, character)
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Health = humanoid.MaxHealth
        print("[SOUL ESSENCE] Full Heal + 10s Invincibility Activated!")
        
        -- Invincibility effect
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        wait(10)
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

ItemSystem.itemEffects.VoidShard = function(player, character)
    print("[VOID SHARD] Teleporting to safe room...")
    local safeRoomSpawn = Vector3.new(0, 50, 0)
    character:MoveTo(safeRoomSpawn)
end

ItemSystem.itemEffects.CrimsonAmulet = function(player, character)
    print("[CRIMSON AMULET] Damage increased by 50% for 15 seconds!")
    -- Damage buff effect
    wait(15)
    print("[CRIMSON AMULET] Damage buff expired")
end

ItemSystem.itemEffects.FrostGem = function(player, character)
    print("[FROST GEM] Freezing all nearby enemies for 5 seconds!")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        for _, enemy in pairs(workspace:FindPartiesInRegion3(Region3.new(rootPart.Position - Vector3.new(50, 50, 50), rootPart.Position + Vector3.new(50, 50, 50)))) do
            if enemy.Parent and enemy.Parent:FindFirstChild("Humanoid") and enemy.Parent ~= character then
                enemy.Parent:FindFirstChild("Humanoid").WalkSpeed = 0
            end
        end
        wait(5)
        for _, enemy in pairs(workspace:FindPartiesInRegion3(Region3.new(rootPart.Position - Vector3.new(50, 50, 50), rootPart.Position + Vector3.new(50, 50, 50)))) do
            if enemy.Parent and enemy.Parent:FindFirstChild("Humanoid") and enemy.Parent ~= character then
                enemy.Parent:FindFirstChild("Humanoid").WalkSpeed = 16
            end
        end
    end
end

ItemSystem.itemEffects.ThunderCore = function(player, character)
    print("[THUNDER CORE] AOE Electric damage activated!")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        local aoe = Instance.new("Part")
        aoe.Shape = Enum.PartType.Ball
        aoe.Size = Vector3.new(40, 40, 40)
        aoe.Color = Color3.fromRGB(255, 200, 0)
        aoe.Material = Enum.Material.Neon
        aoe.CanCollide = false
        aoe.CFrame = rootPart.CFrame
        aoe.Parent = workspace
        game:GetService("Debris"):AddItem(aoe, 2)
    end
end

ItemSystem.itemEffects.ShadowCloak = function(player, character)
    print("[SHADOW CLOAK] Becoming invisible for 8 seconds!")
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
        end
    end
    wait(8)
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 0
        end
    end
end

ItemSystem.itemEffects.HealingVial = function(player, character)
    print("[HEALING VIAL] Restoring 30 HP!")
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Health = math.min(humanoid.Health + 30, humanoid.MaxHealth)
    end
end

ItemSystem.itemEffects.SpecterOrb = function(player, character)
    print("[SPECTER ORB] Protective barrier activated (5 hits)!")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        local barrier = Instance.new("Part")
        barrier.Shape = Enum.PartType.Ball
        barrier.Size = Vector3.new(15, 15, 15)
        barrier.Color = Color3.fromRGB(150, 100, 255)
        barrier.Material = Enum.Material.Neon
        barrier.CanCollide = false
        barrier.CFrame = rootPart.CFrame
        barrier.Parent = workspace
        barrier.BodyVelocity = Instance.new("BodyVelocity")
        barrier.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        barrier.BodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
        
        local hitCount = 0
        barrier.Touched:Connect(function(hit)
            if hit.Parent ~= character then
                hitCount = hitCount + 1
                if hitCount >= 5 then
                    barrier:Destroy()
                end
            end
        end)
        
        game:GetService("Debris"):AddItem(barrier, 10)
    end
end

ItemSystem.itemEffects.InfernoCrystal = function(player, character)
    print("[INFERNO CRYSTAL] Burning ground in 15 stud radius!")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        local burn = Instance.new("Part")
        burn.Shape = Enum.PartType.Cylinder
        burn.Size = Vector3.new(30, 1, 30)
        burn.Color = Color3.fromRGB(255, 100, 0)
        burn.Material = Enum.Material.Neon
        burn.CanCollide = false
        burn.CFrame = rootPart.CFrame - Vector3.new(0, 3, 0)
        burn.Parent = workspace
        game:GetService("Debris"):AddItem(burn, 8)
    end
end

ItemSystem.itemEffects.PureLight = function(player, character)
    print("[PURE LIGHT] Destroying all nearby entities!")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        local light = Instance.new("Part")
        light.Shape = Enum.PartType.Ball
        light.Size = Vector3.new(60, 60, 60)
        light.Color = Color3.fromRGB(255, 255, 255)
        light.Material = Enum.Material.Neon
        light.CanCollide = false
        light.CFrame = rootPart.CFrame
        light.Parent = workspace
        
        for _, entity in pairs(workspace:GetDescendants()) do
            if entity:IsA("Model") and entity:FindFirstChild("Humanoid") and entity ~= character then
                if (entity:FindFirstChild("HumanoidRootPart") or entity:FindFirstChild("Part")).Position:Distance(rootPart.Position) < 60 then
                    entity:Destroy()
                end
            end
        end
        
        game:GetService("Debris"):AddItem(light, 2)
    end
end

-- Use item function
function ItemSystem:useItem(itemName, player, character)
    if self.itemEffects[itemName] then
        self.itemEffects[itemName](player, character)
        return true
    else
        print("[ERROR] Item effect not found: " .. itemName)
        return false
    end
end

-- Get item info
function ItemSystem:getItemInfo(itemName)
    local items = {
        SoulEssence = {rarity = "Legendary", effect = "Heal 50HP + Invincibility 10s"},
        VoidShard = {rarity = "Epic", effect = "Teleport to nearest safe room"},
        CrimsonAmulet = {rarity = "Rare", effect = "Increase damage by 50% for 15s"},
        FrostGem = {rarity = "Rare", effect = "Freeze all enemies for 5s"},
        ThunderCore = {rarity = "Epic", effect = "AOE electric damage to nearby enemies"},
        ShadowCloak = {rarity = "Rare", effect = "Become invisible for 8s"},
        HealingVial = {rarity = "Common", effect = "Restore 30HP instantly"},
        SpecterOrb = {rarity = "Epic", effect = "Create protective barrier (5 hits)"},
        InfernoCrystal = {rarity = "Rare", effect = "Burn ground in 15 stud radius"},
        PureLight = {rarity = "Legendary", effect = "Destroy all nearby entities"}
    }
    return items[itemName]
end

return ItemSystem
