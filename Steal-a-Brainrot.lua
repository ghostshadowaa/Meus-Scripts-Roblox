--// Criar GUI no CoreGui (Executor) ou StarterGui (Studio)
local guiParent = game.CoreGui

--// Criar ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotHub"
ScreenGui.Parent = guiParent

--// Criar Frame (Hub Principal)
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 150)
Frame.Position = UDim2.new(0.5, -125, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

--// Título do Hub
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "Brainrot Hub"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Parent = Frame

--// Botão FECHAR
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
CloseBtn.TextScaled = true
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Parent = Frame

--// Efeito do botão fechar
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

--// Botão de Teleporte
local TeleportBtn = Instance.new("TextButton")
TeleportBtn.Size = UDim2.new(1, -20, 0, 50)
TeleportBtn.Position = UDim2.new(0, 10, 0, 60)
TeleportBtn.Text = "Teleportar"
TeleportBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportBtn.TextScaled = true
TeleportBtn.Parent = Frame

--// Script de teleporte
local player = game.Players.LocalPlayer

TeleportBtn.MouseButton1Click:Connect(function()
    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart")

    root.CFrame = CFrame.new(
        -345.083679, 0.0248937607, 113.94593,
        0, 0, -1,
        0, 1, 0,
        1, 0, 0
    )
end)
