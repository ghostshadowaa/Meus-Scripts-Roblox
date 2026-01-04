-- Cria a GUI
local player = game.Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "TeleportGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Botão
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0.5, -25)
button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "TELEPORTAR"
button.TextScaled = true
button.Parent = gui

-- CFrame de destino
local destino = CFrame.new(
    556.714355, 69.1929932, 3.99294281,
    0, 0, -1,
    0, 1, 0,
    1, 0, 0
)

-- Função de teleporte
button.MouseButton1Click:Connect(function()
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    hrp.CFrame = destino
end)