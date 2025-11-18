-- 🛡️ ANTI-HIT & BRAINROT RADAR 🧠
-- Coloque como LocalScript em StarterPlayerScripts

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Configurações
local ANTI_HIT_ENABLED = true
local RADAR_ENABLED = true
local MAX_DISTANCE = 200

-- Sistema Anti-Hit
local AntiHitSystem = {
    Enabled = true,
    OriginalProperties = {},
    Connections = {}
}

-- Sistema de Radar
local RadarSystem = {
    Enabled = true,
    TrackedBrainrots = {},
    GUI = nil
}

-- Função para ativar Anti-Hit 100%
function AntiHitSystem:Enable()
    if not self.Enabled then return end
    
    local character = Player.Character
    if not character then
        Player.CharacterAdded:Wait()
        character = Player.Character
    end
    
    -- Remover colisões de todas as partes
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            self.OriginalProperties[part] = {
                CanCollide = part.CanCollide,
                CanTouch = part.CanTouch
            }
            part.CanCollide = false
            part.CanTouch = false
        end
    end
    
    -- Proteção contra dano
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        -- Conexão para cancelar dano
        self.Connections.healthChange = humanoid.HealthChanged:Connect(function()
            if humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
        
        -- Conexão para quando leva dano
        self.Connections.damage = humanoid.Touched:Connect(function() end)
        
        -- Imunidade a dano
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end
    
    -- Reconectar quando character morrer/respawnar
    self.Connections.characterAdded = Player.CharacterAdded:Connect(function(newChar)
        wait(1) -- Esperar character carregar
        self:Enable()
    end)
    
    -- Loop de proteção contínua
    coroutine.wrap(function()
        while self.Enabled and character and character.Parent do
            -- Manter vida máxima
            if humanoid and humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
            
            -- Manter partes sem colisão
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    part.CanTouch = false
                end
            end
            
            RunService.Heartbeat:Wait()
        end
    end)()
    
    print("🛡️ Anti-Hit ATIVADO - 100% Imune")
end

-- Função para desativar Anti-Hit
function AntiHitSystem:Disable()
    self.Enabled = false
    
    -- Restaurar propriedades originais
    for part, properties in pairs(self.OriginalProperties) do
        if part and part.Parent then
            part.CanCollide = properties.CanCollide
            part.CanTouch = properties.CanTouch
        end
    end
    
    -- Desconectar conexões
    for _, connection in pairs(self.Connections) do
        connection:Disconnect()
    end
    
    self.Connections = {}
    self.OriginalProperties = {}
    
    print("🛡️ Anti-Hit DESATIVADO")
end

-- Sistema de Radar para Brainrots Valorizados
function RadarSystem:CreateGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BrainrotRadar"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = PlayerGui
    
    -- Frame principal do radar
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "RadarFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 200)
    mainFrame.Position = UDim2.new(0, 20, 0, 20)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.Visible = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 255, 0)
    stroke.Thickness = 2
    stroke.Parent = mainFrame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    title.BackgroundTransparency = 0
    title.Text = "🧠 BRAINROT RADAR 🎯"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = title
    title.Parent = mainFrame
    
    -- Lista de brainrots
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "BrainrotList"
    scrollFrame.Size = UDim2.new(1, -10, 1, -40)
    scrollFrame.Position = UDim2.new(0, 5, 0, 35)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 0)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = scrollFrame
    
    scrollFrame.Parent = mainFrame
    mainFrame.Parent = screenGui
    
    self.GUI = screenGui
    return screenGui
end

-- Função para escanear brainrots valorizados
function RadarSystem:ScanBrainrots()
    if not self.Enabled then return end
    
    local brainrots = {}
    
    -- Procurar brainrots no workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and string.find(string.lower(obj.Name), "brainrot") then
            local humanoid = obj:FindFirstChildOfClass("Humanoid")
            local head = obj:FindFirstChild("Head")
            
            if humanoid and head then
                -- Calcular valor baseado em características
                local value = self:CalculateBrainrotValue(obj, humanoid)
                local distance = (head.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                
                if distance <= MAX_DISTANCE then
                    table.insert(brainrots, {
                        Model = obj,
                        Value = value,
                        Distance = distance,
                        Position = head.Position
                    })
                end
            end
        end
    end
    
    -- Ordenar por valor (maior primeiro)
    table.sort(brainrots, function(a, b)
        return a.Value > b.Value
    end)
    
    self.TrackedBrainrots = brainrots
    self:UpdateRadarDisplay()
    
    return brainrots
end

-- Calcular valor do brainrot
function RadarSystem:CalculateBrainrotValue(brainrot, humanoid)
    local value = 0
    
    -- Baseado na vida
    value = value + humanoid.MaxHealth
    
    -- Baseado na velocidade
    value = value + (humanoid.WalkSpeed * 10)
    
    -- Baseado no tamanho
    local head = brainrot:FindFirstChild("Head")
    if head then
        value = value + (head.Size.Magnitude * 50)
    end
    
    -- Bônus por cores especiais
    if head then
        local color = head.BrickColor
        if color == BrickColor.new("Bright red") then
            value = value + 500 -- Brainrot forte
        elseif color == BrickColor.new("Bright yellow") then
            value = value + 300 -- Brainrot rápido
        elseif color == BrickColor.new("Bright green") then
            value = value + 200 -- Brainrot normal
        elseif color == BrickColor.new("Bright blue") then
            value = value + 400 -- Brainrot especial
        end
    end
    
    -- Bônus por materiais especiais
    if head and head.Material == Enum.Material.Neon then
        value = value + 100
    end
    
    return math.floor(value)
end

-- Atualizar display do radar
function RadarSystem:UpdateRadarDisplay()
    if not self.GUI then return end
    
    local scrollFrame = self.GUI:FindFirstChild("RadarFrame"):FindFirstChild("BrainrotList")
    if not scrollFrame then return end
    
    -- Limpar lista anterior
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Adicionar brainrots à lista
    for i, brainrot in pairs(self.TrackedBrainrots) do
        if i <= 8 then -- Limitar a 8 no display
            self:CreateBrainrotEntry(scrollFrame, brainrot, i)
        end
    end
    
    -- Ajustar tamanho do canvas
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, (#self.TrackedBrainrots * 35))
end

-- Criar entrada na lista do radar
function RadarSystem:CreateBrainrotEntry(parent, brainrot, index)
    local entryFrame = Instance.new("Frame")
    entryFrame.Name = "BrainrotEntry"
    entryFrame.Size = UDim2.new(1, 0, 0, 30)
    entryFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    entryFrame.BackgroundTransparency = 0.1
    entryFrame.LayoutOrder = index
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = entryFrame
    
    -- Ícone do brainrot
    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 25, 0, 25)
    icon.Position = UDim2.new(0, 5, 0.5, -12.5)
    icon.BackgroundTransparency = 1
    icon.Text = "🧠"
    icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    icon.TextSize = 14
    icon.Font = Enum.Font.GothamBold
    icon.Parent = entryFrame
    
    -- Valor do brainrot
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Size = UDim2.new(0, 60, 0, 25)
    valueLabel.Position = UDim2.new(0, 35, 0.5, -12.5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = "💎 " .. brainrot.Value
    valueLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    valueLabel.TextSize = 12
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    valueLabel.Parent = entryFrame
    
    -- Distância
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "Distance"
    distanceLabel.Size = UDim2.new(0, 80, 0, 25)
    distanceLabel.Position = UDim2.new(0, 100, 0.5, -12.5)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "📏 " .. math.floor(brainrot.Distance) .. "m"
    distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    distanceLabel.TextSize = 11
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextXAlignment = Enum.TextXAlignment.Left
    distanceLabel.Parent = entryFrame
    
    -- Direção
    local directionLabel = Instance.new("TextLabel")
    directionLabel.Name = "Direction"
    directionLabel.Size = UDim2.new(0, 50, 0, 25)
    directionLabel.Position = UDim2.new(1, -55, 0.5, -12.5)
    directionLabel.BackgroundTransparency = 1
    directionLabel.Text = self:GetDirectionArrow(brainrot.Position)
    directionLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    directionLabel.TextSize = 16
    directionLabel.Font = Enum.Font.GothamBold
    directionLabel.Parent = entryFrame
    
    -- Efeito de destaque para os top 3
    if index <= 3 then
        local highlight = Instance.new("UIStroke")
        highlight.Color = Color3.fromRGB(255, 215, 0) -- Ouro
        highlight.Thickness = 2
        highlight.Parent = entryFrame
        
        if index == 1 then
            valueLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- Ouro para #1
        elseif index == 2 then
            valueLabel.TextColor3 = Color3.fromRGB(192, 192, 192) -- Prata para #2
        elseif index == 3 then
            valueLabel.TextColor3 = Color3.fromRGB(205, 127, 50) -- Bronze para #3
        end
    end
    
    entryFrame.Parent = parent
end

-- Calcular direção (seta)
function RadarSystem:GetDirectionArrow(brainrotPosition)
    if not Player.Character then return "?" end
    
    local charRoot = Player.Character:FindFirstChild("HumanoidRootPart")
    if not charRoot then return "?" end
    
    local charPos = charRoot.Position
    local direction = (brainrotPosition - charPos).Unit
    
    local charForward = charRoot.CFrame.LookVector
    local dotProduct = charForward:Dot(direction)
    
    local right = charRoot.CFrame.RightVector
    local crossProduct = charForward:Cross(direction).Y
    
    if dotProduct > 0.7 then
        return "↑" -- Frente
    elseif dotProduct < -0.7 then
        return "↓" -- Trás
    elseif crossProduct > 0 then
        return "→" -- Direita
    else
        return "←" -- Esquerda
    end
end

-- Iniciar radar
function RadarSystem:Start()
    if not self.Enabled then return end
    
    -- Criar GUI
    self:CreateGUI()
    
    -- Loop de atualização do radar
    coroutine.wrap(function()
        while self.Enabled do
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                self:ScanBrainrots()
            end
            wait(1) -- Atualizar a cada 1 segundo
        end
    end)()
    
    print("🎯 Radar de Brainrots ATIVADO")
end

-- Parar radar
function RadarSystem:Stop()
    self.Enabled = false
    if self.GUI then
        self.GUI:Destroy()
        self.GUI = nil
    end
    self.TrackedBrainrots = {}
    print("🎯 Radar de Brainrots DESATIVADO")
end

-- Interface de controle
local ControlGUI = {}

function ControlGUI:Create()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AntiHitControls"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui
    
    -- Botão flutuante de controle
    local controlButton = Instance.new("TextButton")
    controlButton.Name = "ControlButton"
    controlButton.Size = UDim2.new(0, 50, 0, 50)
    controlButton.Position = UDim2.new(1, -70, 0, 20)
    controlButton.AnchorPoint = Vector2.new(1, 0)
    controlButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    controlButton.Text = "⚡"
    controlButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    controlButton.TextSize = 20
    controlButton.ZIndex = 10
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = controlButton
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 255, 0)
    stroke.Thickness = 2
    stroke.Parent = controlButton
    
    -- Menu de controle
    local menuFrame = Instance.new("Frame")
    menuFrame.Name = "ControlMenu"
    menuFrame.Size = UDim2.new(0, 150, 0, 120)
    menuFrame.Position = UDim2.new(1, -160, 0, 80)
    menuFrame.AnchorPoint = Vector2.new(1, 0)
    menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    menuFrame.BackgroundTransparency = 0.1
    menuFrame.Visible = false
    
    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 8)
    menuCorner.Parent = menuFrame
    
    local menuStroke = Instance.new("UIStroke")
    menuStroke.Color = Color3.fromRGB(0, 255, 0)
    menuStroke.Thickness = 2
    menuStroke.Parent = menuFrame
    
    -- Botões do menu
    local function createMenuButton(text, yPos, callback)
        local button = Instance.new("TextButton")
        button.Name = text .. "Button"
        button.Size = UDim2.new(0.9, 0, 0, 25)
        button.Position = UDim2.new(0.05, 0, 0, yPos)
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 12
        button.Font = Enum.Font.Gotham
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button
        
        button.MouseButton1Click:Connect(callback)
        button.Parent = menuFrame
        
        return button
    end
    
    -- Criar botões do menu
    local antiHitButton = createMenuButton("🛡️ Anti-Hit: ON", 10, function()
        ANTI_HIT_ENABLED = not ANTI_HIT_ENABLED
        if ANTI_HIT_ENABLED then
            AntiHitSystem:Enable()
            antiHitButton.Text = "🛡️ Anti-Hit: ON"
            antiHitButton.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        else
            AntiHitSystem:Disable()
            antiHitButton.Text = "🛡️ Anti-Hit: OFF"
            antiHitButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        end
    end)
    
    local radarButton = createMenuButton("🎯 Radar: ON", 40, function()
        RADAR_ENABLED = not RADAR_ENABLED
        if RADAR_ENABLED then
            RadarSystem:Start()
            radarButton.Text = "🎯 Radar: ON"
            radarButton.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        else
            RadarSystem:Stop()
            radarButton.Text = "🎯 Radar: OFF"
            radarButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        end
    end)
    
    local refreshButton = createMenuButton("🔄 Atualizar", 70, function()
        if RADAR_ENABLED then
            RadarSystem:ScanBrainrots()
        end
    end)
    
    -- Controle de visibilidade do menu
    controlButton.MouseButton1Click:Connect(function()
        menuFrame.Visible = not menuFrame.Visible
    end)
    
    -- Fechar menu ao clicar fora
    local function closeMenu()
        menuFrame.Visible = false
    end
    
    controlButton.Parent = screenGui
    menuFrame.Parent = screenGui
    
    return screenGui
end

-- Inicialização
wait(2) -- Esperar carregamento

-- Criar controles
ControlGUI:Create()

-- Iniciar sistemas
if ANTI_HIT_ENABLED then
    AntiHitSystem:Enable()
end

if RADAR_ENABLED then
    RadarSystem:Start()
end

-- Notificação
game.StarterGui:SetCore("SendNotification", {
    Title = "🛡️ ANTI-HIT & RADAR 🎯",
    Text = "Sistemas ativados com sucesso!",
    Duration = 5,
    Icon = "rbxassetid://7072717366"
})

print("🎮 Sistema Anti-Hit & Radar carregado!")
print("🛡️ Anti-Hit: " .. (ANTI_HIT_ENABLED and "ATIVADO" or "DESATIVADO"))
print("🎯 Radar: " .. (RADAR_ENABLED and "ATIVADO" or "DESATIVADO"))
