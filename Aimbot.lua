-- [[ KA HUB | PREMIUM EDITION - UNIFIED VERSION ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [[ SERVIÇOS ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
-- local VIM = game:GetService("VirtualInputManager") -- Removido (Não é necessário para Fly/Aimbot)
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
    -- Fly
    Flying = false, -- Controle de estado do Fly
    FlySpeed = 5   -- Velocidade de voo (studs/frame)
}

-- [[ VARIÁVEIS DE CONTROLE ]]
local FlyBindName = "FlyMovement" -- Nome da Bind para o RenderStep do Fly

-- [[ CÍRCULO DE FOV ]]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Transparency = 0.5
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Radius = Config.FOV

-- [[ JANELA PRINCIPAL RAYFIELD ]]
local Window = Rayfield:CreateWindow({
   Name = "KA Hub | Premium Edition",
   LoadingTitle = "Carregando Ferramentas...",
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

-- [[ FUNÇÃO DE VOAR (Fly Handler) ]]
local function HandleFly(dt)
    if not Config.Flying then
        return
    end

    local FlyVector = Vector3.new(0, 0, 0)
    -- dt * 60 é uma normalização para manter a velocidade constante, independente do FPS.
    local Speed = Config.FlySpeed * dt * 60 

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

    -- Aplica a CFrame à câmera
    if FlyVector.Magnitude > 0 then
        FlyVector = FlyVector.Unit * Speed -- Normaliza e aplica velocidade
        Camera.CFrame = Camera.CFrame + FlyVector
    end
end

-- [[ LÓGICA DE ATIVAÇÃO/DESATIVAÇÃO DO FLY (Integração Rayfield) ]]
local function ToggleFly(Enabled)
    Config.Flying = Enabled
    
    if Enabled then
        print("Fly Ativado!")
        
        -- Desativa o Character (crucial para o Fly)
        if LocalPlayer.Character then
            -- Para evitar bugs com LoadCharacter, tentamos apenas tirar a CFrame
            LocalPlayer.Character.Parent = nil 
        end
        
        Camera.CameraType = Enum.CameraType.Scriptable
        
        -- Conecta o loop de voo ao RenderStepped
        RunService:BindToRenderStep(FlyBindName, Enum.RenderPriority.Camera.Value, HandleFly)
        
    else
        print("Fly Desativado. Carregando personagem.")
        
        -- Desconecta o loop de voo
        RunService:UnbindFromRenderStep(FlyBindName)
        
        -- Restaura o Character e a Camera
        Camera.CameraType = Enum.CameraType.Custom
        -- Recarrega o Character para colocá-lo no lugar onde a câmera estava
        LocalPlayer:LoadCharacter()
    end
end

---
--- SEÇÃO: MOVIMENTO (FLY)
---
local MovementTab = Window:CreateTab("Movimento", 4483362458) -- Ícone de alvo (Pode ser mudado)

MovementTab:CreateToggle({
    Name = "Ativar Fly (W/A/S/D)",
    CurrentValue = Config.Flying,
    Callback = ToggleFly, -- Chama a função de toggle
})

MovementTab:CreateSlider({
    Name = "Velocidade do Fly",
    Range = {1, 50},
    Increment = 1,
    Suffix = "x",
    CurrentValue = Config.FlySpeed,
    Callback = function(Value)
        Config.FlySpeed = Value
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
   Content = "Fly e Aimbot carregados!",
   Duration = 5,
   Image = 4483362458,
})
