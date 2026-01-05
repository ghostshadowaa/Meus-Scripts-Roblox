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
}

-- [[ VARIÁVEIS DE CONTROLE DE TEMPO/CPS ]]
local lastUpdateTime = tick()
local lastClickCount = 0
local heartbeatConn = nil -- Conexão do Auto Clicker
local cpsDisplayConn = nil -- Conexão para atualizar o CPS na UI

-- [[ CÍRCULO DE FOV ]]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Transparency = 0.5
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Radius = Config.FOV -- Inicializa com o valor padrão

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

-- Função central do clique (chamada pelo Heartbeat)
local function doUltraClick()
    local mousePos = UserInputService:GetMouseLocation()
    -- Adiciona uma pequena variação para simular o jitter do mouse
    local x = mousePos.X + math.random(-1, 1)
    local y = mousePos.Y + math.random(-1, 1)

    -- Simula o clique na posição atual do mouse
    VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
    VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
    
    Config.ClickCount = Config.ClickCount + 1
end

-- Função para atualizar o Display de CPS (chamada pelo RenderStepped)
local function updateCPSDisplay(CPSLabel, TotalClicksLabel)
    if tick() - lastUpdateTime >= 1 then
        local cps = Config.ClickCount - lastClickCount
        CPSLabel:Set("CPS Atual: " .. cps)
        -- Não atualiza lastClickCount e lastUpdateTime aqui, pois será feito
        -- no final do bloco do if, garantindo a contagem correta a cada segundo.
        lastClickCount = Config.ClickCount
        lastUpdateTime = tick()
    end
    -- Isso garante que o Total de Cliques seja atualizado constantemente, mesmo sem a contagem de 1 segundo.
    TotalClicksLabel:Set("Total de Cliques: " .. Config.ClickCount)
end

---
--- SEÇÃO: AUTO CLICKER (ULTRA SPEED) - CORRIGIDA
---
local ClickerTab = Window:CreateTab("Auto Clicker", 4483362458)

local CPSLabel = ClickerTab:CreateLabel("CPS Atual: 0")
local TotalClicksLabel = ClickerTab:CreateLabel("Total de Cliques: 0")

ClickerTab:CreateToggle({
   Name = "Ativar Auto Clicker (MAX SPEED)",
   CurrentValue = Config.Clicking,
   Callback = function(Value)
      Config.Clicking = Value
      
      if Value then
          -- CORREÇÃO: Desconecta e zera qualquer conexão antiga para evitar falhas.
          if heartbeatConn then heartbeatConn:Disconnect() end
          if cpsDisplayConn then cpsDisplayConn:Disconnect() end
          
          -- 1. Inicia o clique na velocidade máxima (Heartbeat)
          heartbeatConn = RunService.Heartbeat:Connect(doUltraClick)
          
          -- 2. Inicia a atualização do display de CPS/Contador (RenderStepped)
          cpsDisplayConn = RunService.RenderStepped:Connect(function()
              updateCPSDisplay(CPSLabel, TotalClicksLabel)
          end)
          
      else
          -- Desconecta e zera ambas as conexões ao desativar
          if heartbeatConn then 
              heartbeatConn:Disconnect()
              heartbeatConn = nil -- ESSENCIAL para que o Toggle funcione na próxima vez
          end
          if cpsDisplayConn then 
              cpsDisplayConn:Disconnect()
              cpsDisplayConn = nil -- ESSENCIAL para que o Toggle funcione na próxima vez
          end
          
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

-- Conexão principal para Aimbot, ESP e FOV. O Clicker e CPS agora têm suas próprias conexões.
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
        -- Esta lógica foi movida aqui para garantir que os highlights sejam criados
        -- e persistam enquanto o ESP estiver ativo, sem depender da lógica de desligamento.
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
