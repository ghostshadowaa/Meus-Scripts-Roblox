--// Dark Hub - Tema Azul
local guiParent = game.CoreGui

-- Criar GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DarkHub"
ScreenGui.Parent = guiParent

-- Criar Frame principal
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 260, 0, 160)
Frame.Position = UDim2.new(0.5, -130, 0.35, 0)
Frame.BackgroundColor3 = Color3.fromRGB(15, 20, 40) -- azul bem escuro
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Borda azul brilhante
local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 10)

local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Color = Color3.fromRGB(0, 120, 255)
UIStroke.Thickness = 2

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 35)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "Dark Hub"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.Parent = Frame

-- Botão de fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
CloseBtn.TextScaled = true
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Frame

local UIC2 = Instance.new("UICorner", CloseBtn)
UIC2.CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- BOTÃO DE TELEPORTE
local TeleportBtn = Instance.new("TextButton")
TeleportBtn.Size = UDim2.new(1, -20, 0, 55)
TeleportBtn.Position = UDim2.new(0, 10, 0, 55)
TeleportBtn.Text = "Teleportar"
TeleportBtn.BackgroundColor3 = Color3.fromRGB(0, 60, 120)
TeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportBtn.TextScaled = true
TeleportBtn.Font = Enum.Font.GothamBold
TeleportBtn.Parent = Frame

local UIBtnCorner = Instance.new("UICorner", TeleportBtn)
UIBtnCorner.CornerRadius = UDim.new(0, 8)

local player = game.Players.LocalPlayer

-- Função do Teleporte
TeleportBtn.MouseButton1Click:Connect(function()

    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    -- Prevenir bug de física
    root.Velocity = Vector3.new(0,0,0)
    root.RotVelocity = Vector3.new(0,0,0)

    -- Aplicar teleporte
    root.CFrame = CFrame.new(
        -345.083679, 0.0248937607, 113.94593,
        0, 0, -1,
        0, 1, 0,
        1, 0, 0
    )
end)
