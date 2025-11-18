-- Fly Script Mobile - GitHub Version
-- Por: SeuNome
-- Data: 2024

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Configurações
local Flying = false
local FlySpeed = 50

-- Interface Simples
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 150, 0, 60)
flyButton.Position = UDim2.new(0, 20, 0, 20)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
flyButton.Text = "✈️ ATIVAR VOO"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextScaled = true
flyButton.Font = Enum.Font.GothamBold
flyButton.Parent = screenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = flyButton

-- Variáveis do Fly
local BodyVelocity
local BodyGyro

-- Função de Notificação
function notify(msg)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Fly GitHub",
        Text = msg,
        Duration = 3
    })
end

-- Função Principal
flyButton.MouseButton1Click:Connect(function()
    if Flying then
        -- Desativar Fly
        Flying = false
        if BodyVelocity then BodyVelocity:Destroy() end
        if BodyGyro then BodyGyro:Destroy() end
        flyButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        flyButton.Text = "✈️ ATIVAR VOO"
        notify("Voo desativado!")
    else
        -- Ativar Fly
        local character = LocalPlayer.Character
        if not character then
            notify("Erro: Character não encontrado")
            return
        end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            notify("Erro: HumanoidRootPart não encontrado")
            return
        end
        
        -- Criar componentes de física
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
        BodyVelocity.Parent = humanoidRootPart
        
        BodyGyro = Instance.new("BodyGyro")
        BodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
        BodyGyro.P = 1000
        BodyGyro.Parent = humanoidRootPart
        
        Flying = true
        flyButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        flyButton.Text = "🛑 DESATIVAR VOO"
        notify("Voo ativado! Use WASD + Space/Shift")
        
        -- Loop de movimento
        game:GetService("RunService").Heartbeat:Connect(function()
            if not Flying or not character or not humanoidRootPart then
                return
            end
            
            BodyGyro.CFrame = workspace.CurrentCamera.CFrame
            
            local velocity = Vector3.new(0, 0, 0)
            local camera = workspace.CurrentCamera
            
            -- Controles
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                velocity = velocity + (camera.CFrame.LookVector * FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                velocity = velocity + (camera.CFrame.LookVector * -FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                velocity = velocity + (camera.CFrame.RightVector * -FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                velocity = velocity + (camera.CFrame.RightVector * FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity = velocity + Vector3.new(0, FlySpeed, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                velocity = velocity + Vector3.new(0, -FlySpeed, 0)
            end
            
            BodyVelocity.Velocity = velocity
        end)
    end
end)

notify("Script do GitHub carregado!")
print("✅ Fly Script - GitHub Version carregado!")
