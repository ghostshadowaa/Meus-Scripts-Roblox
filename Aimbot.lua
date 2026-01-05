-- Carregando a biblioteca Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [[ CONFIGURAÇÃO E VARIÁVEIS ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    Aimbot = false,
    ESP = false,
    FOV = 150,
    CircleVisible = false
}

-- [[ CÍRCULO DE FOV ]]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Transparency = 0.5
FOVCircle.Filled = false
FOVCircle.Visible = false

-- [[ JANELA PRINCIPAL RAYFIELD ]]
local Window = Rayfield:CreateWindow({
   Name = "KA Hub | Premium Edition",
   LoadingTitle = "Carregando Interface...",
   LoadingSubtitle = "by Sirius",
   ConfigurationSaving = { Enabled = true, FolderName = "KA_Hub_Config", FileName = "Config" },
   KeySystem = true, 
   KeySettings = {
      Title = "Sistema de Chave",
      Subtitle = "Acesse o Hub",
      Note = "A chave é: hub",
      Key = {"hub"} 
   }
})
-- AUTO CLICKER v8.0 - MAX SPEED MODE (500+ CPS ATTEMPT!)
-- Uses RunService.Heartbeat for MAXIMUM possible speed (bypasses task.wait limits)
-- Can reach 300-500+ CPS depending on your device/FPS (Roblox engine limit ~1000)
-- Added: REAL-TIME CPS counter (accurate!)
-- Cursor locks on START
-- Warning: VERY HIGH SPEED - may cause lag, heat, or detection/ban in games!

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoClickerPro"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main Frame (taller)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 260)
MainFrame.Position = UDim2.new(0, 15, 0, 15)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 16)
Corner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(100, 200, 255)
Stroke.Thickness = 3
Stroke.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 160, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "AUTO CLICKER"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Buttons
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 38, 0, 38)
MinimizeBtn.Position = UDim2.new(1, -82, 0, 8)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
MinimizeBtn.Text = "âˆ’"
MinimizeBtn.TextColor3 = Color3.new(0,0,0)
MinimizeBtn.TextScaled = true
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = MainFrame
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 12)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 38, 0, 38)
CloseBtn.Position = UDim2.new(1, -42, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.Text = "Ã—"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 12)

-- Toggle
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 45)
ToggleBtn.Position = UDim2.new(0.05, 0, 0, 50)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
ToggleBtn.Text = "START"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.TextScaled = true
ToggleBtn.Parent = MainFrame
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 12)

-- Delay (now just info - speed is MAX)
local DelayLabel = Instance.new("TextLabel")
DelayLabel.Size = UDim2.new(0.9, 0, 0, 35)
DelayLabel.Position = UDim2.new(0.05, 0, 0, 105)
DelayLabel.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
DelayLabel.Text = "Speed: MAX (500+ CPS possible)"
DelayLabel.TextColor3 = Color3.new(1,1,1)
DelayLabel.TextScaled = true
DelayLabel.Parent = MainFrame
Instance.new("UICorner", DelayLabel).CornerRadius = UDim.new(0, 10)

-- Warning
local WarningLabel = Instance.new("TextLabel")
WarningLabel.Size = UDim2.new(0.9, 0, 0, 25)
WarningLabel.Position = UDim2.new(0.05, 0, 0, 140)
WarningLabel.BackgroundTransparency = 1
WarningLabel.Text = "âš ï¸ EXTREME SPEED!"
WarningLabel.TextColor3 = Color3.fromRGB(255, 100, 0)
WarningLabel.TextScaled = true
WarningLabel.Font = Enum.Font.GothamBold
WarningLabel.Parent = MainFrame

-- CPS & Counter
local CPSLabel = Instance.new("TextLabel")
CPSLabel.Size = UDim2.new(0.9, 0, 0, 35)
CPSLabel.Position = UDim2.new(0.05, 0, 0, 165)
CPSLabel.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
CPSLabel.Text = "CPS: 0"
CPSLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
CPSLabel.TextScaled = true
CPSLabel.Font = Enum.Font.GothamBold
CPSLabel.Parent = MainFrame
Instance.new("UICorner", CPSLabel).CornerRadius = UDim.new(0, 10)

local CounterLabel = Instance.new("TextLabel")
CounterLabel.Size = UDim2.new(0.9, 0, 0, 35)
CounterLabel.Position = UDim2.new(0.05, 0, 0, 205)
CounterLabel.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
CounterLabel.Text = "Clicks: 0"
CounterLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
CounterLabel.TextScaled = true
CounterLabel.Font = Enum.Font.GothamBold
CounterLabel.Parent = MainFrame
Instance.new("UICorner", CounterLabel).CornerRadius = UDim.new(0, 10)

-- Cursor (same)
local CursorHitbox = Instance.new("Frame")
CursorHitbox.Size = UDim2.new(0, 100, 0, 100)
CursorHitbox.Position = UDim2.new(0.5, -50, 0.5, -50)
CursorHitbox.BackgroundTransparency = 1
CursorHitbox.Active = true
CursorHitbox.AnchorPoint = Vector2.new(0.5, 0.5)
CursorHitbox.ZIndex = 999
CursorHitbox.Parent = ScreenGui

local CursorVisual = Instance.new("Frame")
CursorVisual.Size = UDim2.new(0, 50, 0, 50)
CursorVisual.Position = UDim2.new(0.5, -25, 0.5, -25)
CursorVisual.BackgroundTransparency = 1
CursorVisual.Parent = CursorHitbox

local HLine = Instance.new("Frame")
HLine.Size = UDim2.new(1, 0, 0, 4)
HLine.Position = UDim2.new(0, 0, 0.5, -2)
HLine.BackgroundColor3 = Color3.new(1,1,1)
HLine.Parent = CursorVisual

local VLine = Instance.new("Frame")
VLine.Size = UDim2.new(0, 4, 1, 0)
VLine.Position = UDim2.new(0.5, -2, 0, 0)
VLine.BackgroundColor3 = Color3.new(1,1,1)
VLine.Parent = CursorVisual

local CenterDot = Instance.new("Frame")
CenterDot.Size = UDim2.new(0, 14, 0, 14)
CenterDot.Position = UDim2.new(0.5, -7, 0.5, -7)
CenterDot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CenterDot.BorderSizePixel = 0
CenterDot.ZIndex = 10
CenterDot.Parent = CursorVisual
Instance.new("UICorner", CenterDot).CornerRadius = UDim.new(1, 0)

-- Open Button
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 70, 0, 70)
OpenBtn.Position = UDim2.new(0, 20, 0, 20)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
OpenBtn.Text = "Clicker"
OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.TextScaled = true
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

-- Variables
local isOpen = true
local Clicking = false
local ClickCount = 0
local lastClickCount = 0
local lastUpdateTime = tick()
local heartbeatConn

-- Drag
local function toVec2(v) return Vector2.new(v.X, v.Y) end
local dragging = false
local grabOffset = Vector2.new()

CursorHitbox.InputBegan:Connect(function(input)
    if not Clicking and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        local center = CursorHitbox.AbsolutePosition + CursorHitbox.AbsoluteSize/2
        grabOffset = toVec2(input.Position) - Vector2.new(center.X, center.Y)
        dragging = true
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = toVec2(input.Position)
        local newCenter = mousePos - grabOffset
        CursorHitbox.Position = UDim2.new(0, newCenter.X, 0, newCenter.Y)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ULTRA FAST CLICK (Heartbeat = every frame!)
local function doUltraClick()
    local pos = CursorHitbox.AbsolutePosition + CursorHitbox.AbsoluteSize/2
    local x = pos.X + math.random(-2, 2)
    local y = pos.Y + math.random(-2, 2)

    -- Minimal pulse to reduce lag
    TweenService:Create(CursorVisual, TweenInfo.new(0.03), {Size = UDim2.new(0, 55, 0, 55)}):Play()
    TweenService:Create(CursorVisual, TweenInfo.new(0.05, Enum.EasingStyle.Back), {Size = UDim2.new(0, 50, 0, 50)}):Play()

    VIM:SendMouseButtonEvent(x, y, 0, true, ScreenGui, 0)
    VIM:SendMouseButtonEvent(x, y, 0, false, ScreenGui, 0)  -- Instant release

    ClickCount += 1
    CounterLabel.Text = "Clicks: " .. ClickCount
end

-- Toggle
ToggleBtn.Activated:Connect(function()
    Clicking = not Clicking
    ToggleBtn.Text = Clicking and "STOP" or "START"
    ToggleBtn.BackgroundColor3 = Clicking and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(0, 170, 0)

    CursorHitbox.Active = not Clicking

    if Clicking then
        heartbeatConn = RunService.Heartbeat:Connect(doUltraClick)
    else
        if heartbeatConn then
            heartbeatConn:Disconnect()
        end
    end
end)

-- Real-time CPS
RunService.RenderStepped:Connect(function()
    if Clicking and tick() - lastUpdateTime >= 1 then
        local cps = ClickCount - lastClickCount
        CPSLabel.Text = "CPS: " .. cps
        lastClickCount = ClickCount
        lastUpdateTime = tick()
    end
end)

-- Minimize / Open / Close
MinimizeBtn.Activated:Connect(function()
    isOpen = not isOpen
    MainFrame.Visible = isOpen
    CursorHitbox.Visible = isOpen
    OpenBtn.Visible = not isOpen
end)

OpenBtn.Activated:Connect(function()
    isOpen = true
    MainFrame.Visible = true
    CursorHitbox.Visible = true
    OpenBtn.Visible = false
end)

CloseBtn.Activated:Connect(function()
    if Clicking then Clicking = false end
    if heartbeatConn then heartbeatConn:Disconnect() end
    ScreenGui:Destroy()
end)

-- Intro
MainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Size = UDim2.new(0, 300, 0, 260)}):Play()

print("v8.0 LOADED! MAX SPEED MODE - 300-500+ CPS possible! Use with caution! ðŸ”¥")
local MainTab = Window:CreateTab("Combate", 4483362458) -- Ícone de alvo

-- [[ ELEMENTOS DA INTERFACE ]]

MainTab:CreateToggle({
   Name = "Ativar Aimbot",
   CurrentValue = false,
   Callback = function(Value)
      Config.Aimbot = Value
   end,
})

MainTab:CreateToggle({
   Name = "Mostrar Círculo FOV",
   CurrentValue = false,
   Callback = function(Value)
      Config.CircleVisible = Value
      FOVCircle.Visible = Value
   end,
})

MainTab:CreateSlider({
   Name = "Raio do FOV",
   Range = {50, 800},
   Increment = 10,
   Suffix = "px",
   CurrentValue = 150,
   Callback = function(Value)
      Config.FOV = Value
      FOVCircle.Radius = Value
   end,
})

local VisualTab = Window:CreateTab("Visuais", 4483362458)

VisualTab:CreateToggle({
   Name = "Ativar ESP (Highlights)",
   CurrentValue = false,
   Callback = function(Value)
      Config.ESP = Value
      if not Value then
          -- Limpa o ESP quando desligar
          for _, player in pairs(Players:GetPlayers()) do
              if player.Character and player.Character:FindFirstChild("ESPHighlight") then
                  player.Character.ESPHighlight:Destroy()
              end
          end
      end
   end,
})

-- [[ LÓGICA DO AIMBOT ]]
local function GetClosestPlayer()
    local target = nil
    local shortestDistance = Config.FOV
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            -- Verifica se o jogador está vivo (opcional, dependendo do jogo)
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if distance < shortestDistance then
                    target = player
                    shortestDistance = distance
                end
            end
        end
    end
    return target
end

-- [[ LÓGICA DO ESP ]]
local function UpdateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = player.Character:FindFirstChild("ESPHighlight")
            if Config.ESP then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "ESPHighlight"
                    highlight.Parent = player.Character
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end

-- [[ LOOP PRINCIPAL (RENDERSTEPPED) ]]
RunService.RenderStepped:Connect(function()
    -- Atualiza Círculo
    FOVCircle.Position = UserInputService:GetMouseLocation()
    
    -- Executa Aimbot
    if Config.Aimbot then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            -- Suavização leve pode ser adicionada aqui
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
    
    -- Executa ESP
    UpdateESP()
end)

Rayfield:Notify({
   Title = "Script Ativado",
   Content = "KA Hub carregado com sucesso!",
   Duration = 5,
   Image = 4483362458,
})
