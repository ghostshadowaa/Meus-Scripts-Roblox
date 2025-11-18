-- Miranda Hub - Steal a Brainrot
-- Script Único (Coloque como LocalScript em StarterPlayerScripts)

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Criar RemoteEvents se não existirem
local function createRemoteEvents()
    local events = {
        "MirandaGiveBeeGun",
        "MirandaSpawnBrainrots", 
        "MirandaClearBrainrots",
        "MirandaFreezePlayer",
        "MirandaUnfreezeAll",
        "MirandaAreaEffect",
        "MirandaBeeGunFire"
    }
    
    for _, eventName in pairs(events) do
        if not ReplicatedStorage:FindFirstChild(eventName) then
            local remoteEvent = Instance.new("RemoteEvent")
            remoteEvent.Name = eventName
            remoteEvent.Parent = ReplicatedStorage
        end
    end
end

createRemoteEvents()

-- Configurações do Hub
local MIRANDA_CONFIG = {
    MAIN_COLOR = Color3.fromRGB(28, 28, 28),
    ACCENT_COLOR = Color3.fromRGB(0, 170, 255),
    TEXT_COLOR = Color3.fromRGB(255, 255, 255),
    BUTTON_COLOR = Color3.fromRGB(45, 45, 45),
    
    HUB_SIZE = UDim2.new(0, 350, 0, 450),
    BUTTON_SIZE = UDim2.new(0.9, 0, 0, 50),
    
    MOBILE_MODE = UserInputService.TouchEnabled
}

-- Sistema de Interface Miranda
local MirandaHub = {}

function MirandaHub:CreateScreenGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MirandaHub"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = PlayerGui
    
    return screenGui
end

function MirandaHub:CreateFloatingButton()
    local button = Instance.new("ImageButton")
    button.Name = "MirandaFloatingButton"
    button.Size = MIRANDA_CONFIG.MOBILE_MODE and UDim2.new(0, 70, 0, 70) or UDim2.new(0, 60, 0, 60)
    button.Position = UDim2.new(0, 20, 0.5, -35)
    button.AnchorPoint = Vector2.new(0, 0.5)
    button.BackgroundColor3 = MIRANDA_CONFIG.MAIN_COLOR
    button.BackgroundTransparency = 0.15
    button.Image = "rbxassetid://7072717366" -- Ícone padrão
    button.ScaleType = Enum.ScaleType.Fit
    
    -- Efeitos visuais
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = MIRANDA_CONFIG.ACCENT_COLOR
    stroke.Thickness = 2.5
    stroke.Parent = button
    
    local glow = Instance.new("UIStroke")
    glow.Color = MIRANDA_CONFIG.ACCENT_COLOR
    glow.Thickness = 1
    glow.Transparency = 0.7
    glow.Parent = button
    
    -- Animação de pulso
    coroutine.wrap(function()
        while button and button.Parent do
            local tween = TweenService:Create(glow, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Thickness = 4})
            tween:Play()
            wait(1)
            local tween2 = TweenService:Create(glow, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Thickness = 1})
            tween2:Play()
            wait(1)
        end
    end)()
    
    return button
end

function MirandaHub:CreateMainFrame()
    local frame = Instance.new("Frame")
    frame.Name = "MirandaMainFrame"
    frame.Size = MIRANDA_CONFIG.HUB_SIZE
    frame.Position = UDim2.new(0.5, -175, 0.5, -225)
    frame.BackgroundColor3 = MIRANDA_CONFIG.MAIN_COLOR
    frame.BackgroundTransparency = 0.1
    frame.Visible = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = MIRANDA_CONFIG.ACCENT_COLOR
    stroke.Thickness = 2
    stroke.Parent = frame
    
    -- Sombra
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://8577639283"
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = 0
    shadow.Parent = frame
    
    return frame
end

function MirandaHub:CreateTitleBar()
    local titleFrame = Instance.new("Frame")
    titleFrame.Name = "TitleBar"
    titleFrame.Size = UDim2.new(1, 0, 0, 45)
    titleFrame.Position = UDim2.new(0, 0, 0, 0)
    titleFrame.BackgroundColor3 = MIRANDA_CONFIG.MAIN_COLOR
    titleFrame.BackgroundTransparency = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = titleFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🐝 MIRANDA HUB 🧠"
    titleLabel.TextColor3 = MIRANDA_CONFIG.TEXT_COLOR
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleFrame
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0.5, -15)
    closeButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 20
    closeButton.Font = Enum.Font.GothamBold
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton
    closeButton.Parent = titleFrame
    
    return titleFrame, closeButton
end

function MirandaHub:CreateButton(text, icon)
    local button = Instance.new("TextButton")
    button.Name = text .. "Button"
    button.Size = MIRANDA_CONFIG.BUTTON_SIZE
    button.Position = UDim2.new(0.5, 0, 0, 0)
    button.AnchorPoint = Vector2.new(0.5, 0)
    button.BackgroundColor3 = MIRANDA_CONFIG.BUTTON_COLOR
    button.Text = "   " .. (icon or "") .. " " .. text
    button.TextColor3 = MIRANDA_CONFIG.TEXT_COLOR
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.TextXAlignment = Enum.TextXAlignment.Left
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(80, 80, 80)
    stroke.Thickness = 1
    stroke.Parent = button
    
    -- Ícone
    if icon then
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(0, 25, 0, 25)
        iconLabel.Position = UDim2.new(1, -30, 0.5, -12.5)
        iconLabel.AnchorPoint = Vector2.new(1, 0.5)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon
        iconLabel.TextColor3 = MIRANDA_CONFIG.ACCENT_COLOR
        iconLabel.TextSize = 16
        iconLabel.Font = Enum.Font.GothamBold
        iconLabel.Parent = button
    end
    
    -- Efeito hover
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = MIRANDA_CONFIG.BUTTON_COLOR)}:Play()
    end)
    
    return button
end

function MirandaHub:CreateScrollFrame()
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ContentScroll"
    scrollFrame.Size = UDim2.new(1, -20, 1, -65)
    scrollFrame.Position = UDim2.new(0, 10, 0, 55)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = MIRANDA_CONFIG.ACCENT_COLOR
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 10)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = scrollFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingBottom = UDim.new(0, 5)
    padding.Parent = scrollFrame
    
    -- Ajustar tamanho automático
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    end)
    
    return scrollFrame
end

-- Sistema de Arrastar para Mobile
local dragController = {
    isDragging = false,
    dragStart = nil,
    buttonStartPos = nil
}

function dragController:Init(button, frame)
    if not MIRANDA_CONFIG.MOBILE_MODE then return end
    
    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            self.isDragging = true
            self.dragStart = input.Position
            self.buttonStartPos = button.Position
            
            -- Feedback visual
            TweenService:Create(button, TweenInfo.new(0.1), {
                Size = MIRANDA_CONFIG.MOBILE_MODE and UDim2.new(0, 65, 0, 65) or UDim2.new(0, 55, 0, 55),
                BackgroundTransparency = 0.3
            }):Play()
        end
    end
    
    local function onInputChanged(input)
        if self.isDragging and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - self.dragStart
            button.Position = UDim2.new(
                self.buttonStartPos.X.Scale,
                self.buttonStartPos.X.Offset + delta.X,
                self.buttonStartPos.Y.Scale, 
                self.buttonStartPos.Y.Offset + delta.Y
            )
        end
    end
    
    local function onInputEnded(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            self.isDragging = false
            
            TweenService:Create(button, TweenInfo.new(0.1), {
                Size = MIRANDA_CONFIG.MOBILE_MODE and UDim2.new(0, 70, 0, 70) or UDim2.new(0, 60, 0, 60),
                BackgroundTransparency = 0.15
            }):Play()
        end
    end
    
    button.InputBegan:Connect(onInputBegan)
    UserInputService.InputChanged:Connect(onInputChanged)
    UserInputService.InputEnded:Connect(onInputEnded)
end

-- Sistema de Funcionalidades
local MirandaFunctions = {}

function MirandaFunctions:GiveBeeGun()
    ReplicatedStorage:WaitForChild("MirandaGiveBeeGun"):FireServer()
end

function MirandaFunctions:SpawnBrainrots()
    ReplicatedStorage:WaitForChild("MirandaSpawnBrainrots"):FireServer()
end

function MirandaFunctions:ClearBrainrots()
    ReplicatedStorage:WaitForChild("MirandaClearBrainrots"):FireServer()
end

function MirandaFunctions:FreezeNearest()
    ReplicatedStorage:WaitForChild("MirandaFreezePlayer"):FireServer()
end

function MirandaFunctions:UnfreezeAll()
    ReplicatedStorage:WaitForChild("MirandaUnfreezeAll"):FireServer()
end

function MirandaFunctions:AreaBeeEffect()
    ReplicatedStorage:WaitForChild("MirandaAreaEffect"):FireServer()
end

function MirandaFunctions:AntiAFK()
    -- Sistema anti-AFK automático
    local virtualUser = game:GetService("VirtualUser")
    Player.Idled:Connect(function()
        virtualUser:CaptureController()
        virtualUser:ClickButton2(Vector2.new())
    end)
end

-- Inicialização do Miranda Hub
local screenGui = MirandaHub:CreateScreenGui()
local floatingButton = MirandaHub:CreateFloatingButton()
local mainFrame = MirandaHub:CreateMainFrame()
local titleBar, closeButton = MirandaHub:CreateTitleBar()
local scrollFrame = MirandaHub:CreateScrollFrame()

-- Montar a interface
titleBar.Parent = mainFrame
scrollFrame.Parent = mainFrame
mainFrame.Parent = screenGui
floatingButton.Parent = screenGui

-- Configurar arrastar para mobile
dragController:Init(floatingButton, mainFrame)

-- Criar botões das funcionalidades
local function createHubButtons()
    local buttons = {
        {"🐝 Obter Bee Gun", MirandaFunctions.GiveBeeGun},
        {"🧠 Spawnar Brainrots", MirandaFunctions.SpawnBrainrots},
        {"🗑️ Limpar Brainrots", MirandaFunctions.ClearBrainrots},
        {"🎯 Travar Mais Próximo", MirandaFunctions.FreezeNearest},
        {"🔓 Destravar Todos", MirandaFunctions.UnfreezeAll},
        {"⚡ Bee em Área", MirandaFunctions.AreaBeeEffect},
        {"⏰ Anti-AFK", MirandaFunctions.AntiAFK}
    }
    
    for i, buttonData in ipairs(buttons) do
        local button = MirandaHub:CreateButton(buttonData[1])
        button.LayoutOrder = i
        button.Parent = scrollFrame
        
        button.MouseButton1Click:Connect(function()
            buttonData[2]()
            
            -- Feedback de clique
            TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = MIRANDA_CONFIG.ACCENT_COLOR}):Play()
            wait(0.1)
            TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = MIRANDA_CONFIG.BUTTON_COLOR}):Play()
        end)
    end
end

createHubButtons()

-- Controles de Abertura/Fechamento
floatingButton.MouseButton1Click:Connect(function()
    if not dragController.isDragging then
        mainFrame.Visible = not mainFrame.Visible
        
        if mainFrame.Visible then
            -- Animação de entrada
            mainFrame.Size = UDim2.new(0, 0, 0, 0)
            mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            
            local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = MIRANDA_CONFIG.HUB_SIZE,
                Position = UDim2.new(0.5, -175, 0.5, -225)
            })
            tween:Play()
        end
    end
end)

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Fechar hub ao clicar fora (apenas mobile)
if MIRANDA_CONFIG.MOBILE_MODE then
    local backgroundCover = Instance.new("TextButton")
    backgroundCover.Size = UDim2.new(1, 0, 1, 0)
    backgroundCover.BackgroundTransparency = 1
    backgroundCover.Text = ""
    backgroundCover.ZIndex = 4
    backgroundCover.Visible = false
    backgroundCover.Parent = mainFrame
    
    mainFrame:GetPropertyChangedSignal("Visible"):Connect(function()
        backgroundCover.Visible = mainFrame.Visible
    end)
    
    backgroundCover.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
    end)
end

-- Sistema de Bee Gun (Local)
local BeeGunSystem = {}

function BeeGunSystem:EquipTool()
    local tool = Instance.new("Tool")
    tool.Name = "MirandaBeeGun"
    tool.ToolTip = "Miranda Hub - Bee Gun"
    tool.CanBeDropped = false
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 1, 3)
    handle.BrickColor = BrickColor.new("Bright yellow")
    handle.Material = Enum.Material.Neon
    handle.Parent = tool
    
    -- Configurar a ferramenta
    tool.Equipped:Connect(function()
        BeeGunSystem:OnEquipped()
    end)
    
    tool.Unequipped:Connect(function()
        BeeGunSystem:OnUnequipped()
    end)
    
    tool.Activated:Connect(function()
        BeeGunSystem:OnActivated()
    end)
    
    return tool
end

function BeeGunSystem:OnEquipped()
    -- Mudar cursor
    if not MIRANDA_CONFIG.MOBILE_MODE then
        local mouse = Player:GetMouse()
        mouse.Icon = "rbxassetid://7072716646"
    end
end

function BeeGunSystem:OnUnequipped()
    -- Restaurar cursor
    if not MIRANDA_CONFIG.MOBILE_MODE then
        local mouse = Player:GetMouse()
        mouse.Icon = ""
    end
end

function BeeGunSystem:OnActivated()
    -- Efeito de disparo
    local character = Player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- Raycast para acertar jogadores
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {character}
    
    local startPos = character.Head.Position
    local endPos = startPos + (character.Head.CFrame.LookVector * 100)
    
    local result = workspace:Raycast(startPos, endPos - startPos, params)
    
    if result then
        local hit = result.Instance
        local hitPlayer = Players:GetPlayerFromCharacter(hit.Parent)
        
        if hitPlayer then
            ReplicatedStorage:WaitForChild("MirandaBeeGunFire"):FireServer(hitPlayer)
            
            -- Efeito visual de acerto
            local hitEffect = Instance.new("Part")
            hitEffect.Size = Vector3.new(2, 2, 2)
            hitEffect.Position = result.Position
            hitEffect.BrickColor = BrickColor.new("Bright yellow")
            hitEffect.Material = Enum.Material.Neon
            hitEffect.Anchored = true
            hitEffect.CanCollide = false
            hitEffect.Parent = workspace
            
            TweenService:Create(hitEffect, TweenInfo.new(0.5), {
                Size = Vector3.new(4, 4, 4),
                Transparency = 1
            }):Play()
            
            game.Debris:AddItem(hitEffect, 0.5)
        end
    end
end

-- Receber Bee Gun do servidor
ReplicatedStorage:WaitForChild("MirandaGiveBeeGun").OnClientEvent:Connect(function()
    local backpack = Player:FindFirstChild("Backpack")
    if backpack then
        local beeGun = BeeGunSystem:EquipTool()
        beeGun.Parent = backpack
        
        -- Notificação
        game.StarterGui:SetCore("SendNotification", {
            Title = "Miranda Hub",
            Text = "Bee Gun adicionada ao seu inventário!",
            Duration = 3,
            Icon = "rbxassetid://7072717366"
        })
    end
end)

-- Notificação de inicialização
wait(2)
game.StarterGui:SetCore("SendNotification", {
    Title = "Miranda Hub",
    Text = "Hub carregado com sucesso! Use o botão flutuante.",
    Duration = 5,
    Icon = "rbxassetid://7072717366"
})

print("🎮 Miranda Hub - Steal a Brainrot carregado!")
print("📱 Modo Mobile: " .. tostring(MIRANDA_CONFIG.MOBILE_MODE))