-- 🏠 TELEPORTE PARA BASE - Steal a Brainrot
-- Coloque como LocalScript em StarterPlayerScripts

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Configuração das bases disponíveis
local BASE_LOCATIONS = {
    ["Base Principal"] = Vector3.new(100, 50, 0),
    ["Base Secreta"] = Vector3.new(-200, 25, 150),
    ["Base no Topo"] = Vector3.new(0, 100, -100),
    ["Base na Caverna"] = Vector3.new(150, 10, 200),
    ["Base do Lago"] = Vector3.new(-100, 20, -150),
    ["Base do Pico"] = Vector3.new(0, 150, 0)
}

-- Sistema de Teleporte
local TeleportSystem = {
    CurrentBase = "Base Principal",
    IsTeleporting = false,
    LastTeleport = 0,
    Cooldown = 10 -- segundos
}

-- Criar a interface do botão de teleporte
function TeleportSystem:CreateTeleportButton()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TeleportHub"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = PlayerGui

    -- Botão Principal Flutuante
    local mainButton = Instance.new("ImageButton")
    mainButton.Name = "TeleportMainButton"
    mainButton.Size = UDim2.new(0, 65, 0, 65)
    mainButton.Position = UDim2.new(1, -80, 0.5, -32.5)
    mainButton.AnchorPoint = Vector2.new(1, 0.5)
    mainButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainButton.BackgroundTransparency = 0.15
    mainButton.Image = "rbxassetid://7072716646" -- Ícone de teleporte
    mainButton.ScaleType = Enum.ScaleType.Fit
    
    -- Efeitos visuais do botão
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = mainButton
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 170, 255)
    stroke.Thickness = 2.5
    stroke.Parent = mainButton
    
    -- Efeito de brilho pulsante
    local glow = Instance.new("UIStroke")
    glow.Color = Color3.fromRGB(0, 255, 255)
    glow.Thickness = 1
    glow.Transparency = 0.7
    glow.Parent = mainButton
    
    -- Animação de pulso contínuo
    coroutine.wrap(function()
        while mainButton and mainButton.Parent do
            local tweenIn = TweenService:Create(glow, TweenInfo.new(1, Enum.EasingStyle.Sine), {Thickness = 4})
            local tweenOut = TweenService:Create(glow, TweenInfo.new(1, Enum.EasingStyle.Sine), {Thickness = 1})
            
            tweenIn:Play()
            wait(1)
            tweenOut:Play()
            wait(1)
        end
    end)()

    -- Menu de Bases (inicialmente invisível)
    local baseMenu = Instance.new("Frame")
    baseMenu.Name = "BaseMenu"
    baseMenu.Size = UDim2.new(0, 250, 0, 300)
    baseMenu.Position = UDim2.new(1, -260, 0.5, -150)
    baseMenu.AnchorPoint = Vector2.new(1, 0.5)
    baseMenu.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    baseMenu.BackgroundTransparency = 0.1
    baseMenu.Visible = false
    
    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 12)
    menuCorner.Parent = baseMenu
    
    local menuStroke = Instance.new("UIStroke")
    menuStroke.Color = Color3.fromRGB(0, 170, 255)
    menuStroke.Thickness = 2
    menuStroke.Parent = baseMenu

    -- Título do Menu
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    title.BackgroundTransparency = 0
    title.Text = "🏠 TELEPORTE PARA BASE"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = title
    title.Parent = baseMenu

    -- Botão de Fechar
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 18
    closeButton.Font = Enum.Font.GothamBold
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton
    closeButton.Parent = title

    -- Lista de Bases
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "BaseList"
    scrollFrame.Size = UDim2.new(1, -10, 1, -50)
    scrollFrame.Position = UDim2.new(0, 5, 0, 45)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 8)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = scrollFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingBottom = UDim.new(0, 5)
    padding.Parent = scrollFrame

    -- Ajustar tamanho automático da lista
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    end)

    -- Criar botões para cada base
    for baseName, basePosition in pairs(BASE_LOCATIONS) do
        local baseButton = Instance.new("TextButton")
        baseButton.Name = baseName .. "Button"
        baseButton.Size = UDim2.new(1, 0, 0, 45)
        baseButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        baseButton.Text = "   🏠 " .. baseName
        baseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        baseButton.TextSize = 14
        baseButton.Font = Enum.Font.Gotham
        baseButton.TextXAlignment = Enum.TextXAlignment.Left
        baseButton.LayoutOrder = #scrollFrame:GetChildren()
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 8)
        buttonCorner.Parent = baseButton
        
        local buttonStroke = Instance.new("UIStroke")
        buttonStroke.Color = Color3.fromRGB(80, 80, 100)
        buttonStroke.Thickness = 1
        buttonStroke.Parent = baseButton

        -- Destaque para base atual
        if baseName == self.CurrentBase then
            baseButton.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
            baseButton.Text = "   🏠 " .. baseName .. " ✓"
        end

        -- Efeitos de hover
        baseButton.MouseEnter:Connect(function()
            if baseName ~= self.CurrentBase then
                TweenService:Create(baseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(65, 65, 85)}):Play()
            end
        end)

        baseButton.MouseLeave:Connect(function()
            if baseName ~= self.CurrentBase then
                TweenService:Create(baseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 65)}):Play()
            end
        end)

        -- Evento de clique
        baseButton.MouseButton1Click:Connect(function()
            self:TeleportToBase(baseName, basePosition)
        end)

        baseButton.Parent = scrollFrame
    end

    scrollFrame.Parent = baseMenu
    baseMenu.Parent = screenGui
    mainButton.Parent = screenGui

    return {
        ScreenGui = screenGui,
        MainButton = mainButton,
        BaseMenu = baseMenu,
        CloseButton = closeButton
    }
end

-- Função de teleporte
function TeleportSystem:TeleportToBase(baseName, position)
    if self.IsTeleporting then
        self:ShowNotification("⏳ Teleporte em andamento...", Color3.fromRGB(255, 255, 0))
        return
    end

    local currentTime = tick()
    if currentTime - self.LastTeleport < self.Cooldown then
        local remaining = math.ceil(self.Cooldown - (currentTime - self.LastTeleport))
        self:ShowNotification("⏰ Cooldown: " .. remaining .. "s", Color3.fromRGB(255, 100, 100))
        return
    end

    local character = Player.Character
    if not character then
        self:ShowNotification("❌ Personagem não encontrado", Color3.fromRGB(255, 0, 0))
        return
    end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        self:ShowNotification("❌ Não é possível teleportar", Color3.fromRGB(255, 0, 0))
        return
    end

    self.IsTeleporting = true
    self.CurrentBase = baseName
    self.LastTeleport = currentTime

    -- Efeito visual antes do teleporte
    self:ShowNotification("🚀 Teleportando para " .. baseName .. "...", Color3.fromRGB(0, 255, 255))

    -- Efeito de partículas no personagem
    self:CreateTeleportEffects(humanoidRootPart.Position)

    -- Pequeno delay para os efeitos
    wait(0.5)

    -- Executar o teleporte
    local success = pcall(function()
        -- Verificar se a posição é segura (não dentro de paredes, etc.)
        local safePosition = self:FindSafePosition(position)
        
        -- Teleportar o personagem
        humanoidRootPart.CFrame = CFrame.new(safePosition) + Vector3.new(0, 3, 0)
    end)

    if success then
        self:ShowNotification("✅ Chegou na " .. baseName, Color3.fromRGB(0, 255, 0))
        
        -- Efeito visual após o teleporte
        self:CreateTeleportEffects(humanoidRootPart.Position)
        
        -- Atualizar interface
        self:UpdateBaseSelection(baseName)
    else
        self:ShowNotification("❌ Falha no teleporte", Color3.fromRGB(255, 0, 0))
    end

    self.IsTeleporting = false
end

-- Encontrar posição segura para teleporte
function TeleportSystem:FindSafePosition(targetPosition)
    -- Verificar se a posição está livre
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {Player.Character}
    
    -- Testar diferentes alturas
    for i = 1, 10 do
        local testPosition = targetPosition + Vector3.new(0, i * 3, 0)
        local ray = workspace:Raycast(testPosition, Vector3.new(0, -10, 0), params)
        
        if ray then
            return ray.Position + Vector3.new(0, 3, 0) -- Acima do chão
        end
    end
    
    return targetPosition + Vector3.new(0, 10, 0) -- Fallback
end

-- Criar efeitos visuais de teleporte
function TeleportSystem:CreateTeleportEffects(position)
    -- Luz no local do teleporte
    local light = Instance.new("PointLight")
    light.Brightness = 5
    light.Range = 15
    light.Color = Color3.fromRGB(0, 200, 255)
    light.Parent = workspace
    
    local attachment = Instance.new("Attachment")
    attachment.Position = position
    attachment.Parent = workspace
    
    light.Attachment = attachment

    -- Partículas de teleporte
    local particles = Instance.new("ParticleEmitter")
    particles.Texture = "rbxassetid://243664672"
    particles.Lifetime = NumberRange.new(0.5, 1.5)
    particles.Rate = 50
    particles.SpreadAngle = Vector2.new(45, 45)
    particles.Speed = NumberRange.new(5, 10)
    particles.Color = ColorSequence.new(Color3.fromRGB(0, 150, 255))
    particles.Parent = attachment

    -- Remover efeitos após alguns segundos
    game.Debris:AddItem(attachment, 3)
    game.Debris:AddItem(light, 3)
end

-- Atualizar seleção de base na interface
function TeleportSystem:UpdateBaseSelection(selectedBase)
    if not self.GUI then return end
    
    local scrollFrame = self.GUI.BaseMenu:FindFirstChild("BaseList")
    if not scrollFrame then return end
    
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            local baseName = string.gsub(child.Text, "   🏠 ", "")
            baseName = string.gsub(baseName, " ✓", "")
            
            if baseName == selectedBase then
                child.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
                child.Text = "   🏠 " .. baseName .. " ✓"
            else
                child.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
                child.Text = "   🏠 " .. baseName
            end
        end
    end
end

-- Mostrar notificação
function TeleportSystem:ShowNotification(message, color)
    game.StarterGui:SetCore("SendNotification", {
        Title = "🏠 Teleporte",
        Text = message,
        Duration = 3,
        Icon = "rbxassetid://7072716646"
    })
end

-- Sistema de detecção de bases automáticas
function TeleportSystem:ScanForBases()
    -- Procurar por partes nomeadas como "Base" no workspace
    local foundBases = {}
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") and string.find(string.lower(obj.Name), "base") then
            local baseName = "Base " .. obj.Name
            foundBases[baseName] = obj.Position
        end
    end
    
    -- Se encontrou bases automáticas, adicionar às disponíveis
    if next(foundBases) ~= nil then
        for baseName, position in pairs(foundBases) do
            BASE_LOCATIONS[baseName] = position
        end
    end
end

-- Inicialização do sistema
function TeleportSystem:Init()
    -- Procurar bases automáticas
    self:ScanForBases()
    
    -- Criar interface
    self.GUI = self:CreateTeleportButton()
    
    -- Configurar eventos
    self.GUI.MainButton.MouseButton1Click:Connect(function()
        self.GUI.BaseMenu.Visible = not self.GUI.BaseMenu.Visible
        
        if self.GUI.BaseMenu.Visible then
            -- Animação de entrada
            self.GUI.BaseMenu.Size = UDim2.new(0, 0, 0, 0)
            local tween = TweenService:Create(self.GUI.BaseMenu, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                Size = UDim2.new(0, 250, 0, 300)
            })
            tween:Play()
        end
    end)
    
    self.GUI.CloseButton.MouseButton1Click:Connect(function()
        self.GUI.BaseMenu.Visible = false
    end)
    
    -- Fechar menu ao clicar fora (para mobile)
    if UserInputService.TouchEnabled then
        local backgroundCover = Instance.new("TextButton")
        backgroundCover.Size = UDim2.new(1, 0, 1, 0)
        backgroundCover.BackgroundTransparency = 1
        backgroundCover.Text = ""
        backgroundCover.ZIndex = 4
        backgroundCover.Visible = false
        backgroundCover.Parent = self.GUI.BaseMenu
        
        self.GUI.BaseMenu:GetPropertyChangedSignal("Visible"):Connect(function()
            backgroundCover.Visible = self.GUI.BaseMenu.Visible
        end)
        
        backgroundCover.MouseButton1Click:Connect(function()
            self.GUI.BaseMenu.Visible = false
        end)
    end
    
    -- Atalho de tecla (opcional para PC)
    if not UserInputService.TouchEnabled then
        UserInputService.InputBegan:Connect(function(input, processed)
            if not processed and input.KeyCode == Enum.KeyCode.T then
                self.GUI.BaseMenu.Visible = not self.GUI.BaseMenu.Visible
            end
        end)
    end
    
    print("🏠 Sistema de Teleporte carregado!")
    print("📋 Bases disponíveis: " .. tostring(#self:GetBaseList()))
    
    -- Notificação inicial
    wait(2)
    self:ShowNotification("Sistema de teleporte carregado! Use o botão azul.", Color3.fromRGB(0, 170, 255))
end

-- Obter lista de bases
function TeleportSystem:GetBaseList()
    local bases = {}
    for baseName in pairs(BASE_LOCATIONS) do
        table.insert(bases, baseName)
    end
    return bases
end

-- Iniciar o sistema
TeleportSystem:Init()

-- Comando de chat para teleporte rápido (opcional)
Player.Chatted:Connect(function(message)
    local lowerMessage = string.lower(message)
    
    if string.sub(lowerMessage, 1, 5) == "/base" then
        local baseName = string.sub(message, 7)
        
        for availableBase, position in pairs(BASE_LOCATIONS) do
            if string.lower(availableBase) == string.lower(baseName) then
                TeleportSystem:TeleportToBase(availableBase, position)
                return
            end
        end
        
        TeleportSystem:ShowNotification("Base não encontrada: " .. baseName, Color3.fromRGB(255, 100, 100))
    end
end)
