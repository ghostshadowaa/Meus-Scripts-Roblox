-- [[ CONFIGURAÇÕES E VARIÁVEIS DE CONTROLE ]]
local _g = getgenv and getgenv() or _G
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Prevenção de execução dupla
if _g.ScriptJaCarregado then 
    warn("O script já está em execução!")
    return 
end
_g.ScriptJaCarregado = true

-- Estados das Funções
local Config = {
    ESP = false,
    Aimbot = false,
    MenuVisible = true -- Começa visível para facilitar o uso
}

-- [[ INTERFACE DO USUÁRIO (MOBILE OTIMIZADO) ]] ---

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ESPBtn = Instance.new("TextButton")
local AimbotBtn = Instance.new("TextButton")
local ToggleButton = Instance.new("TextButton") -- Novo botão para abrir/fechar

ScreenGui.Name = "PainelMobile"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Botão Flutuante (Toggle) - Substitui a tecla INSERT
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 70, 0, 70)
ToggleButton.Position = UDim2.new(1, -80, 0, 10) -- Canto superior direito
ToggleButton.Text = "MENU"
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 18
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.CornerRadius = UDim.new(0.5, 0) -- Transforma em círculo

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
-- Posição otimizada para Mobile (superior esquerdo para não cobrir o jogo todo)
MainFrame.Position = UDim2.new(0.02, 0, 0.1, 0) 
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Active = true
MainFrame.Visible = Config.MenuVisible

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Auxílio Mobile"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local function ConfigurarBotao(btn, texto, pos)
    btn.Parent = MainFrame
    btn.Position = pos
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Text = texto
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BorderSizePixel = 0
    btn.AnchorPoint = Vector2.new(0.5, 0) -- Centraliza o botão dentro da MainFrame
end

-- Os botões são configurados no centro da MainFrame
ConfigurarBotao(ESPBtn, "ESP: OFF", UDim2.new(0.5, 0, 0.35, 0))
ConfigurarBotao(AimbotBtn, "Aimbot: OFF", UDim2.new(0.5, 0, 0.65, 0))

-- Lógica para Abertura/Fechamento (Toggle)
ToggleButton.MouseButton1Click:Connect(function()
    Config.MenuVisible = not Config.MenuVisible
    MainFrame.Visible = Config.MenuVisible
    ToggleButton.BackgroundColor3 = Config.MenuVisible and Color3.fromRGB(255, 100, 0) or Color3.fromRGB(0, 150, 255)
end)

-- Lógica do ESP 
ESPBtn.MouseButton1Click:Connect(function()
    Config.ESP = not Config.ESP
    ESPBtn.Text = "ESP: " .. (Config.ESP and "ON" or "OFF")
    ESPBtn.BackgroundColor3 = Config.ESP and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
end)

-- Lógica do Aimbot 
AimbotBtn.MouseButton1Click:Connect(function()
    Config.Aimbot = not Config.Aimbot
    AimbotBtn.Text = "Aimbot: " .. (Config.Aimbot and "ON" or "OFF")
    AimbotBtn.BackgroundColor3 = Config.Aimbot and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
end)

-- [[ LÓGICA DAS FUNCIONALIDADES ]]

local function GetClosestPlayer()
    local closest = nil
    local shortestDistance = math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) 

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                -- Checa se o alvo está visível e a uma distância razoável (por exemplo, 400 pixels do centro)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                    
                    if distance < shortestDistance and distance < 400 then 
                        closest = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    return closest
end

-- LOOP ÚNICO DE RENDERIZAÇÃO 
RunService.RenderStepped:Connect(function()
    
    -- Lógica de Aimbot
    if Config.Aimbot then
        local target = GetClosestPlayer()
        if target and target.Character:FindFirstChild("Head") then
            local targetPos = target.Character.Head.Position
            local lookCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
            
            -- Interpolação suave para um movimento de câmera menos abrupto
            Camera.CFrame = Camera.CFrame:Lerp(lookCFrame, 0.15) -- Aumentei um pouco a velocidade para mobile
        end
    end

    -- Lógica de ESP
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = player.Character:FindFirstChild("ESPHighlight")
            
            if Config.ESP then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "ESPHighlight"
                    highlight.Parent = player.Character
                    highlight.FillColor = Color3.fromRGB(255, 0, 0) 
                    highlight.OutlineColor = Color3.new(1, 1, 1) 
                    highlight.DepthMode = Enum.DepthMode.AlwaysOnTop
                end
            else
                -- Remove o Highlight se o ESP estiver desligado
                if highlight then highlight:Destroy() end
            end
        end
    end
end)

print("Script carregado com sucesso para dispositivos móveis!")
