-- [[ KA HUB | PREMIUM EDITION - UNIFIED VERSION ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [[ SERVIÇOS ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ CONFIGURAÇÕES ]]
local Config = {
    -- Combate/Aimbot
    Aimbot = false,
    FOV = 150,
    CircleVisible = false,
    -- Visuais
    ESP = false,
    -- Auto Clicker
    Clicking = false,
    ClickCount = 0,
    ClickDelay = 0.01 -- NOVO: Delay inicial (0.01s = 100 CPS teórico)
}

-- [[ VARIÁVEIS DE CONTROLE DE TEMPO/CPS ]]
local lastUpdateTime = tick()
local lastClickCount = 0
local clickerThread = nil -- NOVO: Variável para a thread do loop do Clicker
local cpsDisplayConn = nil -- Conexão para atualizar o CPS na UI

-- [[ CÍRCULO DE FOV ]]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Transparency = 0.5
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Radius = Config.FOV

---
--- LÓGICA DE SUPORTE (FUNÇÕES)
---

local function GetClosestPlayer()
    local target = nil
    local shortestDistance = Config.FOV
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
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

-- Função central do clique (agora usando task.wait)
local function doClickLoop()
    while Config.Clicking do
        local mousePos = UserInputService:GetMouseLocation()
        local x = mousePos.X + math.random(-1, 1)
        local y = mousePos.Y + math.random(-1, 1)

        VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
        VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
        
        Config.ClickCount = Config.ClickCount + 1
        
        -- Espera baseada no delay manual configurado
        task.wait(Config.ClickDelay)
    end
end

-- Função para atualizar o Display de CPS (chamada pelo RenderStepped)
local function updateCPSDisplay(CPSLabel, TotalClicksLabel)
    if tick() - lastUpdateTime >= 1 then
        local cps = Config.ClickCount - lastClickCount
        CPSLabel:Set("CPS Atual: " .. cps)
        lastClickCount = Config.ClickCount
        lastUpdateTime = tick()
    end
    TotalClicksLabel:Set("Total de Cliques: " .. Config.ClickCount)
end

-- [[ JANELA PRINCIPAL RAYFIELD ]]
local Window = Rayfield:CreateWindow({
   Name = "KA Hub | Premium Edition",
   LoadingTitle = "Carregando Multi-Ferramentas...",
   LoadingSubtitle = "by Sirius & KA",
   ConfigurationSaving = { Enabled = true, FolderName = "KA_Hub_Config", FileName = "Config" },
   KeySystem = true, 
   KeySettings = {
      Title = "Sistema de Chave",
      Subtitle = "Acesse o Hub",
      Note = "A chave é: hub",
      Key = {"hub"} 
   }
})
-- [[ CONFIGURAÇÃO DO FLY SCRIPT ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ VARIÁVEIS DE CONTROLE ]]
local Config = {
    FlySpeed = 5, -- Velocidade de voo em studs/frame (ajuste conforme necessário)
    Flying = false
}

-- [[ FUNÇÃO DE VOAR ]]
local function HandleFly(dt)
    -- O 'dt' (delta time) garante que o movimento seja suave e independente do FPS.
    
    if not Config.Flying then
        return
    end

    local FlyVector = Vector3.new(0, 0, 0)
    local Speed = Config.FlySpeed * dt * 60 -- Multiplica por 60 para normalizar pela taxa de quadros (idealmente 60 FPS)

    -- Detecta entradas do usuário:
    
    -- Frente (W) e Trás (S)
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        FlyVector = FlyVector + Camera.CFrame.lookVector
    elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then
        FlyVector = FlyVector - Camera.CFrame.lookVector
    end

    -- Direita (D) e Esquerda (A)
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        FlyVector = FlyVector + Camera.CFrame.rightVector
    elseif UserInputService:IsKeyDown(Enum.KeyCode.A) then
        FlyVector = FlyVector - Camera.CFrame.rightVector
    end

    -- Cima (Space/Espaço) e Baixo (Shift Esquerdo)
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        FlyVector = FlyVector + Vector3.new(0, 1, 0)
    elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        FlyVector = FlyVector - Vector3.new(0, 1, 0)
    end

    -- Se houver movimento, aplica a CFrame à câmera
    if FlyVector.Magnitude > 0 then
        -- Normaliza para que o movimento diagonal não seja mais rápido
        FlyVector = FlyVector.Unit * Speed
        
        Camera.CFrame = Camera.CFrame + FlyVector
    end
end

-- [[ LÓGICA DE ATIVAÇÃO/DESATIVAÇÃO ]]
local function ToggleFly()
    Config.Flying = not Config.Flying
    
    if Config.Flying then
        print("Fly Ativado! Use W/A/S/D para mover, Espaço/Shift para subir/descer.")
        
        -- Desativa o Character e a Gravity para evitar interferência
        if LocalPlayer.Character then
            LocalPlayer.Character.Archivable = false
            LocalPlayer.Character:Destroy()
        end
        Camera.CameraType = Enum.CameraType.Scriptable
        
        -- Conecta o loop de voo ao RenderStepped (para movimento suave)
        RunService:BindToRenderStep("FlyMovement", Enum.RenderPriority.Camera.Value, HandleFly)
        
    else
        print("Fly Desativado. Carregando personagem.")
        
        -- Reconecta o loop de voo
        RunService:UnbindFromRenderStep("FlyMovement")
        
        -- Restaura o Character e a Camera
        Camera.CameraType = Enum.CameraType.Custom
        LocalPlayer:LoadCharacter()
    end
end

-- [[ INTERFACE SIMPLES DE ATIVAÇÃO (Tecla E) ]]
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    -- Ativa/Desativa ao pressionar a tecla 'E'
    if input.KeyCode == Enum.KeyCode.E and not gameProcessed then
        ToggleFly()
    end
end)

print("Fly Script Carregado. Pressione E para Ativar/Desativar.")

---
--- SEÇÃO: AUTO CLICKER (COM CONTROLE MANUAL)
---
local ClickerTab = Window:CreateTab("Auto Clicker", 4483362458)

local CPSLabel = ClickerTab:CreateLabel("CPS Atual: 0")
local TotalClicksLabel = ClickerTab:CreateLabel("Total de Cliques: 0")

-- NOVO SLIDER DE VELOCIDADE
ClickerTab:CreateSlider({
   Name = "Delay (0.01s = 100 CPS)",
   Range = {0.005, 0.5}, -- 0.005s (200 CPS) a 0.5s (2 CPS)
   Increment = 0.005,
   Suffix = "s",
   CurrentValue = Config.ClickDelay,
   Callback = function(Value)
      Config.ClickDelay = Value
   end,
})

ClickerTab:CreateToggle({
   Name = "Ativar Auto Clicker",
   CurrentValue = Config.Clicking,
   Callback = function(Value)
      Config.Clicking = Value
      
      if Value then
          -- Inicia a thread do loop de clique
          clickerThread = coroutine.wrap(doClickLoop)()
          
          -- Inicia a atualização do display de CPS/Contador
          cpsDisplayConn = RunService.RenderStepped:Connect(function()
              updateCPSDisplay(CPSLabel, TotalClicksLabel)
          end)
          
      else
          -- Desconecta o display de CPS
          if cpsDisplayConn then 
              cpsDisplayConn:Disconnect()
              cpsDisplayConn = nil
          end
          
          -- A thread de clique para automaticamente quando Config.Clicking = false
          
          -- Garante que o display seja atualizado pela última vez ao parar
          updateCPSDisplay(CPSLabel, TotalClicksLabel)
      end
   end,
})

ClickerTab:CreateButton({
   Name = "Resetar Contador",
   Callback = function()
       Config.ClickCount = 0
       lastClickCount = 0
       TotalClicksLabel:Set("Total de Cliques: 0")
       CPSLabel:Set("CPS Atual: 0")
   end,
})

---
--- SEÇÃO: COMBATE (AIMBOT)
---
local CombatTab = Window:CreateTab("Combate", 4483362458)

CombatTab:CreateToggle({
   Name = "Ativar Aimbot",
   CurrentValue = Config.Aimbot,
   Callback = function(Value) Config.Aimbot = Value end,
})

CombatTab:CreateToggle({
   Name = "Mostrar Círculo FOV",
   CurrentValue = Config.CircleVisible,
   Callback = function(Value)
      Config.CircleVisible = Value
      FOVCircle.Visible = Value
   end,
})

CombatTab:CreateSlider({
   Name = "Raio do FOV",
   Range = {50, 800},
   Increment = 10,
   Suffix = "px",
   CurrentValue = Config.FOV,
   Callback = function(Value)
      Config.FOV = Value
      FOVCircle.Radius = Value
   end,
})

---
--- SEÇÃO: VISUAIS (ESP)
---
local VisualTab = Window:CreateTab("Visuais", 4483362458)

VisualTab:CreateToggle({
   Name = "Ativar ESP (Highlights)",
   CurrentValue = Config.ESP,
   Callback = function(Value)
      Config.ESP = Value
      if not Value then
          for _, player in pairs(Players:GetPlayers()) do
              if player.Character and player.Character:FindFirstChild("ESPHighlight") then
                  player.Character.ESPHighlight:Destroy()
              end
          end
      end
   end,
})

---
--- LOOP PRINCIPAL (RENDERSTEPPED - LÓGICA)
---

-- Conexão principal para Aimbot, ESP e FOV.
RunService.RenderStepped:Connect(function()
    -- Update FOV Circle
    FOVCircle.Position = UserInputService:GetMouseLocation()
    
    -- Aimbot Logic
    if Config.Aimbot then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
    
    -- ESP Logic
    if Config.ESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = player.Character:FindFirstChild("ESPHighlight")
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "ESPHighlight"
                    highlight.Parent = player.Character
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end
end)

Rayfield:Notify({
   Title = "KA Hub Unificado",
   Content = "Auto Clicker e Aimbot carregados!",
   Duration = 5,
   Image = 4483362458,
})
