-- Configurações Iniciais
-- O seu link original continua sendo carregado aqui
loadstring(game:HttpGet("https://raw.githubusercontent.com/kaynan9000/Script/refs/heads/main/Teste.lua"))()

local Library = {Toggle = false} -- Controle do menu
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ESPBtn = Instance.new("TextButton")
local AimbotBtn = Instance.new("TextButton")

-- Propriedades da UI (Simples e funcional)
ScreenGui.Parent = game.CoreGui
MainFrame.Name = "PainelMelhorado"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true -- Permite arrastar o painel

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Menu de Auxílio"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

-- Botão ESP
ESPBtn.Parent = MainFrame
ESPBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
ESPBtn.Size = UDim2.new(0.8, 0, 0, 30)
ESPBtn.Text = "Ativar ESP"
ESPBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

-- Botão Aimbot
AimbotBtn.Parent = MainFrame
AimbotBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
AimbotBtn.Size = UDim2.new(0.8, 0, 0, 30)
AimbotBtn.Text = "Ativar Aimbot"
AimbotBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

--- FUNÇÕES ---

-- Função Abrir/Fechar (Tecla Insert)
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Lógica Simples de ESP (Cria caixas nos jogadores)
ESPBtn.MouseButton1Click:Connect(function()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            local highlight = Instance.new("Highlight")
            highlight.Parent = player.Character
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
        end
    end
    print("ESP Ativado!")
end)

-- Lógica Simples de Aimbot (Foca na cabeça mais próxima)
AimbotBtn.MouseButton1Click:Connect(function()
    local Camera = workspace.CurrentCamera
    local LocalPlayer = game.Players.LocalPlayer
    
    game:GetService("RunService").RenderStepped:Connect(function()
        local closestPlayer = nil
        local shortestDistance = math.huge
        
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local pos = Camera:WorldToViewportPoint(player.Character.PrimaryPart.Position)
                local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).magnitude
                
                if magnitude < shortestDistance then
                    closestPlayer = player
                    shortestDistance = magnitude
                end
            end
        end
        
        if closestPlayer and closestPlayer.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestPlayer.Character.Head.Position)
        end
    end)
    print("Aimbot Ativado!")
end)
-
