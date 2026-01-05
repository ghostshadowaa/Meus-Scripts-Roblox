-- Carregando a biblioteca Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [[ CONFIGURAÇÃO E VARIÁVEIS GLOBAIS ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager") -- Para o Auto Clicker
local TweenService = game:GetService("TweenService") -- Para o Auto Clicker (se quiser efeitos)

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    Aimbot = false,
    ESP = false,
    AutoClicker = false, -- Nova configuração integrada
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
FOVCircle.Radius = Config.FOV -- Inicializa o raio

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

-- [[ LÓGICA DO AUTO CLICKER (Integrado) ]]
local Clicking = false
local ClickCount = 0
local heartbeatConn = nil
local lastClickCount = 0
local lastUpdateTime = tick()
local ClicksPerSecond = 0
local AimbotTarget = nil -- Para o Clicker usar a posição do alvo se o Aimbot estiver ligado

local function doUltraClick()
    -- Prioriza o alvo do Aimbot se estiver ativo, senão usa a posição do mouse
    local pos = UserInputService:GetMouseLocation()
    
    if Config.Aimbot and AimbotTarget and AimbotTarget.Character and AimbotTarget.Character:FindFirstChild("Head") then
        local viewportPos, onScreen = Camera:WorldToViewportPoint(AimbotTarget.Character.Head.Position)
        if onScreen then
             pos = Vector2.new(viewportPos.X, viewportPos.Y)
        end
    end

    local x = pos.X + math.random(-2, 2)
    local y = pos.Y + math.random(-2, 2)

    -- Simula o clique do mouse no ponto
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, nil, 0)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, nil, 0)

    ClickCount = ClickCount + 1
end

local function toggleAutoClicker(Enabled)
    Clicking = Enabled
    Config.AutoClicker = Enabled
    
    if Enabled then
        heartbeatConn = RunService.Heartbeat:Connect(doUltraClick)
        warn("Auto Clicker ATIVADO! Velocidade máxima.")
    else
        if heartbeatConn then
            heartbeatConn:Disconnect()
            heartbeatConn = nil
        end
        warn("Auto Clicker DESATIVADO.")
    end
end

-- Cálculo de CPS (Opcional, apenas para mostrar no console/notificação)
RunService.RenderStepped:Connect(function()
    if Clicking and tick() - lastUpdateTime >= 1 then
        ClicksPerSecond = ClickCount - lastClickCount
        lastClickCount = ClickCount
        lastUpdateTime = tick()
        -- Se quiser mostrar o CPS em tempo real, use Rayfield:Notify ou print:
        -- print("CPS: " .. ClicksPerSecond .. " | Clicks Totais: " .. ClickCount)
    end
end)

-- [[ LÓGICA DO AIMBOT ]]
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

-- [[ INTERFACE RAYFIELD - ABAS ]]

-- Aba Combate
local MainTab = Window:CreateTab("Combate", 4483362458) -- Ícone de alvo

MainTab:CreateToggle({
   Name = "Ativar Aimbot",
   CurrentValue = Config.Aimbot,
   Callback = function(Value)
      Config.Aimbot = Value
   end,
})

MainTab:CreateToggle({
   Name = "Mostrar Círculo FOV",
   CurrentValue = Config.CircleVisible,
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
   CurrentValue = Config.FOV,
   Callback = function(Value)
      Config.FOV = Value
      FOVCircle.Radius = Value
   end,
})

MainTab:CreateToggle({ -- Novo Toggle para o Auto Clicker
   Name = "Auto Clicker (MAX SPEED)",
   CurrentValue = Config.AutoClicker,
   Callback = function(Value)
      toggleAutoClicker(Value)
   end,
})

-- Aba Visual
local VisualTab = Window:CreateTab("Visuais", 4483362458)

VisualTab:CreateToggle({
   Name = "Ativar ESP (Highlights)",
   CurrentValue = Config.ESP,
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

-- [[ LOOP PRINCIPAL (RENDERSTEPPED) ]]
RunService.RenderStepped:Connect(function()
    -- Atualiza Círculo de FOV
    FOVCircle.Position = UserInputService:GetMouseLocation()
    
    -- Executa Aimbot
    if Config.Aimbot then
        AimbotTarget = GetClosestPlayer()
        if AimbotTarget and AimbotTarget.Character and AimbotTarget.Character:FindFirstChild("Head") then
            -- Aimbot - Mira suave na cabeça do alvo
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, AimbotTarget.Character.Head.Position)
        else
            AimbotTarget = nil -- Limpa o alvo se estiver fora
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
