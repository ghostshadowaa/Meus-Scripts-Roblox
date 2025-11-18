-- LocalScript dentro de um ScreenGui
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Criar a GUI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FloatingHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Botão Flutuante
local FloatingButton = Instance.new("ImageButton")
FloatingButton.Name = "FloatingButton"
FloatingButton.Size = UDim2.new(0, 60, 0, 60)
FloatingButton.Position = UDim2.new(0, 50, 0.5, -30)
FloatingButton.AnchorPoint = Vector2.new(0, 0.5)
FloatingButton.Image = "rbxassetid://7072717366" -- Ícone personalizado
FloatingButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
FloatingButton.BackgroundTransparency = 0.2
FloatingButton.BorderSizePixel = 0
FloatingButton.ZIndex = 10

-- Efeito de brilho
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = FloatingButton

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 255)
UIStroke.Thickness = 2
UIStroke.Parent = FloatingButton

FloatingButton.Parent = ScreenGui

-- Hub Principal (inicialmente invisível)
local HubFrame = Instance.new("Frame")
HubFrame.Name = "HubFrame"
HubFrame.Size = UDim2.new(0, 350, 0, 400)
HubFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
HubFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
HubFrame.BackgroundTransparency = 0.1
HubFrame.Visible = false
HubFrame.ZIndex = 5

local HubCorner = Instance.new("UICorner")
HubCorner.CornerRadius = UDim.new(0, 12)
HubCorner.Parent = HubFrame

local HubStroke = Instance.new("UIStroke")
HubStroke.Color = Color3.fromRGB(0, 200, 255)
HubStroke.Thickness = 2
HubStroke.Parent = HubFrame

-- Título do Hub
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
TitleLabel.BackgroundTransparency = 0
TitleLabel.Text = "🧠 STEAL A BRAINROT - ADMIN"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.ZIndex = 6

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleLabel

TitleLabel.Parent = HubFrame

-- Botão de Fechar
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true
CloseButton.ZIndex = 7

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

CloseButton.Parent = TitleLabel

-- Área de Conteúdo
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ContentScroll"
ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ZIndex = 6

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ScrollFrame

ScrollFrame.Parent = HubFrame

HubFrame.Parent = ScreenGui

-- Variáveis para arrastar
local isDragging = false
local dragStartPosition
local buttonStartPosition

-- Função para criar botões no hub
local function createHubButton(text, callback)
    local button = Instance.new("TextButton")
    button.Name = text .. "Button"
    button.Size = UDim2.new(1, 0, 0, 50)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.Gotham
    button.ZIndex = 7
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(100, 100, 150)
    buttonStroke.Thickness = 1
    buttonStroke.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    button.Parent = ScrollFrame
    
    return button
end

-- Sistema de Arrastar para o botão flutuante
FloatingButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStartPosition = Vector2.new(input.Position.X, input.Position.Y)
        buttonStartPosition = FloatingButton.Position
        
        -- Efeito visual ao segurar
        local tween = TweenService:Create(
            FloatingButton,
            TweenInfo.new(0.1),
            {Size = UDim2.new(0, 55, 0, 55), BackgroundTransparency = 0.3}
        )
        tween:Play()
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = Vector2.new(
            input.Position.X - dragStartPosition.X,
            input.Position.Y - dragStartPosition.Y
        )
        
        FloatingButton.Position = UDim2.new(
            buttonStartPosition.X.Scale,
            buttonStartPosition.X.Offset + delta.X,
            buttonStartPosition.Y.Scale,
            buttonStartPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and isDragging then
        isDragging = false
        
        -- Efeito visual ao soltar
        local tween = TweenService:Create(
            FloatingButton,
            TweenInfo.new(0.1),
            {Size = UDim2.new(0, 60, 0, 60), BackgroundTransparency = 0.2}
        )
        tween:Play()
    end
end)

-- Alternar visibilidade do Hub
FloatingButton.MouseButton1Click:Connect(function()
    if not isDragging then
        HubFrame.Visible = not HubFrame.Visible
        
        -- Efeito de animação
        if HubFrame.Visible then
            HubFrame.Size = UDim2.new(0, 0, 0, 0)
            HubFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            
            local tween = TweenService:Create(
                HubFrame,
                TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                {Size = UDim2.new(0, 350, 0, 400), Position = UDim2.new(0.5, -175, 0.5, -200)}
            )
            tween:Play()
        end
    end
end)

-- Fechar Hub
CloseButton.MouseButton1Click:Connect(function()
    HubFrame.Visible = false
end)

-- Criar botões do hub
createHubButton("🐝 Dar Equipamento Bee Gun", function()
    game.ReplicatedStorage:WaitForChild("AdminEvents"):WaitForChild("GiveBeeGun"):FireServer()
end)

createHubButton("🧠 Spawnar Todos Brainrots", function()
    game.ReplicatedStorage:WaitForChild("AdminEvents"):WaitForChild("SpawnAllBrainrots"):FireServer()
end)

createHubButton("🗑️ Limpar Brainrots", function()
    game.ReplicatedStorage:WaitForChild("AdminEvents"):WaitForChild("ClearBrainrots"):FireServer()
end)

createHubButton("🎯 Travar Jogador Mais Próximo", function()
    game.ReplicatedStorage:WaitForChild("AdminEvents"):WaitForChild("FreezeNearestPlayer"):FireServer()
end)

createHubButton("🔓 Destravar Todos Jogadores", function()
    game.ReplicatedStorage:WaitForChild("AdminEvents"):WaitForChild("UnfreezeAllPlayers"):FireServer()
end)

createHubButton("⚡ Efeito Bee em Área", function()
    game.ReplicatedStorage:WaitForChild("AdminEvents"):WaitForChild("AreaBeeEffect"):FireServer()
end)

print("🎮 Hub Flutuante carregado! Use o botão para abrir o menu admin.")



-- LocalScript dentro da Tool "BeeGun"
local Tool = script.Parent
local Handle = Tool:WaitForChild("Handle")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local RemoteEvent = game.ReplicatedStorage:WaitForChild("BeeGunEvents")

-- Variáveis
local Equipped = false
local RaycastParams = RaycastParams.new()
RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
RaycastParams.FilterDescendantsInstances = {Player.Character}

-- Função quando equipado
Tool.Equipped:Connect(function()
    Equipped = true
    Mouse.Icon = "rbxassetid://7072716646" -- Ícone de mira
    
    -- Atualizar filtro do raycast
    if Player.Character then
        RaycastParams.FilterDescendantsInstances = {Player.Character}
    end
end)

-- Função quando desequipado
Tool.Unequipped:Connect(function()
    Equipped = false
    Mouse.Icon = ""
end)

-- Função de atirar
Tool.Activated:Connect(function()
    if not Equipped then return end
    
    -- Efeito visual e sonoro
    if Handle:FindFirstChild("ShootSound") then
        Handle.ShootSound:Play()
    end
    
    -- Raycast para detectar alvo
    local rayOrigin = Player.Character.Head.Position
    local rayDirection = Mouse.Hit.LookVector * 100
    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, RaycastParams)
    
    if raycastResult then
        local hit = raycastResult.Instance
        local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
        local playerHit = Players:GetPlayerFromCharacter(hit.Parent)
        
        if humanoid and playerHit then
            -- Enviar evento para o servidor aplicar efeito bee
            RemoteEvent:FireServer(playerHit)
            
            -- Efeito visual de acerto
            local hitPart = Instance.new("Part")
            hitPart.Size = Vector3.new(0.5, 0.5, 0.5)
            hitPart.Position = raycastResult.Position
            hitPart.BrickColor = BrickColor.new("Bright yellow")
            hitPart.Material = Enum.Material.Neon
            hitPart.Anchored = true
            hitPart.CanCollide = false
            hitPart.Parent = workspace
            
            -- Tween para efeito de expansão
            local tween = game:GetService("TweenService"):Create(
                hitPart,
                TweenInfo.new(0.5),
                {Size = Vector3.new(3, 3, 3), Transparency = 1}
            )
            tween:Play()
            
            game.Debris:AddItem(hitPart, 0.5)
        end
    end
end)



-- ServerScript em ServerScriptService
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Criar eventos
local AdminEvents = Instance.new("Folder")
AdminEvents.Name = "AdminEvents"
AdminEvents.Parent = ReplicatedStorage

local BeeGunEvents = Instance.new("RemoteEvent")
BeeGunEvents.Name = "BeeGunEvents"
BeeGunEvents.Parent = ReplicatedStorage

local GiveBeeGunEvent = Instance.new("RemoteEvent")
GiveBeeGunEvent.Name = "GiveBeeGun"
GiveBeeGunEvent.Parent = AdminEvents

local SpawnBrainrotsEvent = Instance.new("RemoteEvent")
SpawnBrainrotsEvent.Name = "SpawnAllBrainrots"
SpawnBrainrotsEvent.Parent = AdminEvents

local ClearBrainrotsEvent = Instance.new("RemoteEvent")
ClearBrainrotsEvent.Name = "ClearBrainrots"
ClearBrainrotsEvent.Parent = AdminEvents

local FreezePlayerEvent = Instance.new("RemoteEvent")
FreezePlayerEvent.Name = "FreezeNearestPlayer"
FreezePlayerEvent.Parent = AdminEvents

local UnfreezeAllEvent = Instance.new("RemoteEvent")
UnfreezeAllEvent.Name = "UnfreezeAllPlayers"
UnfreezeAllEvent.Parent = AdminEvents

local AreaBeeEvent = Instance.new("RemoteEvent")
AreaBeeEvent.Name = "AreaBeeEffect"
AreaBeeEvent.Parent = AdminEvents

-- Sistema de Bee Effect
local BeeEffectService = {
    AffectedPlayers = {},
    BeeGunTool = nil
}

-- Configurar Bee Gun Tool
function BeeEffectService.setupBeeGun()
    local toolTemplate = ServerStorage:FindFirstChild("BeeGun")
    if not toolTemplate then
        -- Criar tool padrão se não existir
        toolTemplate = Instance.new("Tool")
        toolTemplate.Name = "BeeGun"
        toolTemplate.ToolTip = "Bee Gun - Efeito Permanente"
        toolTemplate.CanBeDropped = false
        
        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(1, 1, 3)
        handle.BrickColor = BrickColor.new("Bright yellow")
        handle.Material = Enum.Material.Neon
        handle.Parent = toolTemplate
        
        local sound = Instance.new("Sound")
        sound.Name = "ShootSound"
        sound.SoundId = "rbxassetid://9117165902" -- Som de abelha
        sound.Volume = 0.5
        sound.Parent = handle
        
        toolTemplate.Parent = ServerStorage
    end
    
    BeeEffectService.BeeGunTool = toolTemplate
end

-- Aplicar efeito de abelha permanente
function BeeEffectService.applyBeeEffect(player)
    if BeeEffectService.AffectedPlayers[player] then
        return -- Já está afetado
    end
    
    local character = player.Character
    if not character then return end
    
    print("🐝 Aplicando efeito bee em: " .. player.Name)
    
    -- Marcar como afetado
    BeeEffectService.AffectedPlayers[player] = true
    
    -- Efeitos visuais
    local beeFolder = Instance.new("Folder")
    beeFolder.Name = "BeeEffect"
    beeFolder.Parent = character
    
    -- Partículas de abelha
    local beeParticles = Instance.new("ParticleEmitter")
    beeParticles.Name = "BeeParticles"
    beeParticles.Texture = "rbxassetid://243664672" -- Textura de abelha
    beeParticles.Lifetime = NumberRange.new(1, 3)
    beeParticles.Rate = 30
    beeParticles.SpreadAngle = Vector2.new(45, 45)
    beeParticles.Speed = NumberRange.new(5, 10)
    beeParticles.Parent = character:FindFirstChild("Head") or character:WaitForChild("HumanoidRootPart")
    
    -- Som de zumbido constante
    local buzzSound = Instance.new("Sound")
    buzzSound.Name = "BeeBuzz"
    buzzSound.SoundId = "rbxassetid://9117165902"
    buzzSound.Looped = true
    buzzSound.Volume = 0.3
    buzzSound.Parent = character:FindFirstChild("Head") or character:WaitForChild("HumanoidRootPart")
    buzzSound:Play()
    
    -- Efeito de movimento irregular
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local originalWalkSpeed = humanoid.WalkSpeed
        humanoid.WalkSpeed = 0 -- Travar movimento
        
        -- Coroutine para movimento de abelha
        coroutine.wrap(function()
            while BeeEffectService.AffectedPlayers[player] and character and character.Parent do
                if humanoid.Health > 0 then
                    -- Movimento aleatório
                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        local randomDirection = Vector3.new(
                            math.random(-10, 10),
                            math.random(5, 15),
                            math.random(-10, 10)
                        )
                        
                        -- Aplicar impulso
                        local bodyVelocity = Instance.new("BodyVelocity")
                        bodyVelocity.Velocity = randomDirection
                        bodyVelocity.MaxForce = Vector3.new(2000, 2000, 2000)
                        bodyVelocity.Parent = rootPart
                        
                        game.Debris:AddItem(bodyVelocity, 0.3)
                    end
                end
                wait(1)
            end
        end)()
        
        -- Restaurar quando efeito for removido
        player.CharacterAdded:Connect(function(newChar)
            if not BeeEffectService.AffectedPlayers[player] then
                wait(1) -- Esperar character carregar
                local newHumanoid = newChar:FindFirstChildOfClass("Humanoid")
                if newHumanoid then
                    newHumanoid.WalkSpeed = originalWalkSpeed
                end
            end
        end)
    end
    
    -- Conectar para remover efeito se player sair
    player.AncestryChanged:Connect(function()
        if not player:IsDescendantOf(Players) then
            BeeEffectService.removeBeeEffect(player)
        end
    end)
end

-- Remover efeito de abelha
function BeeEffectService.removeBeeEffect(player)
    if BeeEffectService.AffectedPlayers[player] then
        BeeEffectService.AffectedPlayers[player] = nil
        
        local character = player.Character
        if character then
            -- Remover efeitos visuais
            local beeFolder = character:FindFirstChild("BeeEffect")
            if beeFolder then
                beeFolder:Destroy()
            end
            
            -- Restaurar movimento
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
    end
end

-- Sistema de Spawn de Brainrots
local BrainrotSpawner = {
    ActiveBrainrots = {},
    SpawnLocations = {
        Vector3.new(0, 5, 0),
        Vector3.new(20, 5, 0),
        Vector3.new(-20, 5, 0),
        Vector3.new(0, 5, 20),
        Vector3.new(0, 5, -20)
    }
}

function BrainrotSpawner.spawnBrainrot(position)
    local brainrot = Instance.new("Part")
    brainrot.Name = "Brainrot"
    brainrot.Size = Vector3.new(4, 4, 4)
    brainrot.Position = position
    brainrot.BrickColor = BrickColor.new("Bright green")
    brainrot.Material = Enum.Material.Neon
    brainrot.Shape = Enum.PartType.Ball
    brainrot.Anchored = false
    brainrot.CanCollide = true
    
    local humanoid = Instance.new("Humanoid")
    humanoid.WalkSpeed = 12
    humanoid.Health = 100
    humanoid.MaxHealth = 100
    humanoid.Parent = brainrot
    
    -- Comportamento de perseguição
    coroutine.wrap(function()
        while brainrot and brainrot.Parent do
            local players = Players:GetPlayers()
            local closestPlayer = nil
            local closestDistance = 50
            
            for _, player in pairs(players) do
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local distance = (character.HumanoidRootPart.Position - brainrot.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = character
                    end
                end
            end
            
            if closestPlayer then
                humanoid:MoveTo(closestPlayer.HumanoidRootPart.Position)
            end
            
            wait(1)
        end
    end)()
    
    brainrot.Parent = workspace
    table.insert(BrainrotSpawner.ActiveBrainrots, brainrot)
    return brainrot
end

function BrainrotSpawner.spawnAllBrainrots()
    BrainrotSpawner.clearBrainrots()
    
    for _, position in pairs(BrainrotSpawner.SpawnLocations) do
        BrainrotSpawner.spawnBrainrot(position)
        wait(0.3)
    end
end

function BrainrotSpawner.clearBrainrots()
    for _, brainrot in pairs(BrainrotSpawner.ActiveBrainrots) do
        if brainrot and brainrot.Parent then
            brainrot:Destroy()
        end
    end
    BrainrotSpawner.ActiveBrainrots = {}
end

-- Event Handlers
GiveBeeGunEvent.OnServerEvent:Connect(function(player)
    if player.Character then
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            local beeGun = BeeEffectService.BeeGunTool:Clone()
            beeGun.Parent = backpack
        end
    end
end)

BeeGunEvents.OnServerEvent:Connect(function(shooter, targetPlayer)
    if shooter and targetPlayer then
        BeeEffectService.applyBeeEffect(targetPlayer)
    end
end)

SpawnBrainrotsEvent.OnServerEvent:Connect(function(player)
    BrainrotSpawner.spawnAllBrainrots()
end)

ClearBrainrotsEvent.OnServerEvent:Connect(function(player)
    BrainrotSpawner.clearBrainrots()
end)

FreezePlayerEvent.OnServerEvent:Connect(function(adminPlayer)
    local closestPlayer = nil
    local closestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= adminPlayer and player.Character then
            local distance = (player.Character.HumanoidRootPart.Position - adminPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = player
            end
        end
    end
    
    if closestPlayer then
        BeeEffectService.applyBeeEffect(closestPlayer)
    end
end)

UnfreezeAllEvent.OnServerEvent:Connect(function(player)
    for affectedPlayer, _ in pairs(BeeEffectService.AffectedPlayers) do
        BeeEffectService.removeBeeEffect(affectedPlayer)
    end
end)

AreaBeeEvent.OnServerEvent:Connect(function(adminPlayer)
    local origin = adminPlayer.Character.HumanoidRootPart.Position
    local radius = 20
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= adminPlayer and player.Character then
            local distance = (player.Character.HumanoidRootPart.Position - origin).Magnitude
            if distance <= radius then
                BeeEffectService.applyBeeEffect(player)
            end
        end
    end
end)

-- Inicializar
BeeEffectService.setupBeeGun()
print("🎮 Sistema Steal a Brainrot carregado!")


