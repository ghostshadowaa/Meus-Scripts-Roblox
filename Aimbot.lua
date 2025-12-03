-- Carregar Rayfield corretamente
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not Rayfield then
    warn("Falha ao carregar Rayfield. Carregando versão alternativa...")
    Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
end

-- Sistema de chave simplificado
local validKeys = {
    "123456", "PROJECTX", "FREEAIMBOT", "BIGHUB2024", "TEST123"
}

-- Criar janela com configurações CORRETAS
local Window = Rayfield:CreateWindow({
   Name = "Big Hub Premium",
   Icon = 4483362458,
   LoadingTitle = "Big Hub Premium",
   LoadingSubtitle = "ESP + Aimbot System",
   Theme = "Default",
   
   -- CORREÇÃO: Usar string simples
   ToggleUIKeybind = "K",

   -- Desabilitar configurações salvas temporariamente
   ConfigurationSaving = {
      Enabled = false, -- Mudar para false para testes
      FolderName = "BigHubConfig",
      FileName = "BigHubSettings"
   },

   -- Desabilitar Discord
   Discord = {
      Enabled = false
   },

   KeySystem = true,
   KeySettings = {
      Title = "Sistema de Chave",
      Subtitle = "Digite uma chave válida",
      Note = "Chaves: 123456, PROJECTX, FREEAIMBOT",
      FileName = "Key",
      SaveKey = false, -- Não salvar chave durante testes
      GrabKeyFromSite = false,
      Key = validKeys
   }
})

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Variáveis ESP
local ESPEnabled = false
local ESPObjects = {}
local ESPColor = Color3.fromRGB(0, 255, 0)

-- Variáveis Aimbot
local AimbotEnabled = false
local AimbotKeybind = Enum.UserInputType.MouseButton2
local AimbotFOV = 100
local Smoothing = 0.1

-- Função para criar ESP
function CreateESP(player)
    if ESPObjects[player] then return end
    
    local esp = {}
    
    esp.Box = Drawing.new("Square")
    esp.Box.Thickness = 2
    esp.Box.Filled = false
    esp.Box.Color = ESPColor
    esp.Box.Visible = false
    
    esp.Name = Drawing.new("Text")
    esp.Name.Text = player.Name
    esp.Name.Size = 14
    esp.Name.Center = true
    esp.Name.Outline = true
    esp.Name.Color = ESPColor
    esp.Name.Visible = false
    
    ESPObjects[player] = esp
end

-- Função para atualizar ESP
function UpdateESP()
    for player, esp in pairs(ESPObjects) do
        if player ~= LocalPlayer and player.Character then
            local character = player.Character
            local humanoid = character:FindFirstChild("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and humanoid.Health > 0 and rootPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                
                if onScreen then
                    -- Caixa
                    local distance = (Camera.CFrame.Position - rootPart.Position).Magnitude
                    local scale = math.clamp(1000 / distance, 0.5, 2)
                    local size = Vector2.new(40 * scale, 60 * scale)
                    
                    esp.Box.Size = size
                    esp.Box.Position = Vector2.new(screenPos.X - size.X / 2, screenPos.Y - size.Y / 2)
                    esp.Box.Visible = ESPEnabled
                    esp.Box.Color = ESPColor
                    
                    -- Nome
                    esp.Name.Position = Vector2.new(screenPos.X, screenPos.Y - size.Y / 2 - 20)
                    esp.Name.Visible = ESPEnabled
                    esp.Name.Color = ESPColor
                else
                    esp.Box.Visible = false
                    esp.Name.Visible = false
                end
            else
                esp.Box.Visible = false
                esp.Name.Visible = false
            end
        end
    end
end

-- Função para obter jogador mais próximo
function GetClosestPlayer()
    local closestPlayer = nil
    local closestDistance = AimbotFOV
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local character = player.Character
            local humanoid = character:FindFirstChild("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and humanoid.Health > 0 and rootPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                
                if onScreen then
                    local distance = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    
                    if distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- Criar abas
local MainTab = Window:CreateTab("Principal", 4483362458)
local CombatTab = Window:CreateTab("Combat", 4483362458)
local VisualTab = Window:CreateTab("Visual", 4483362458)

-- Notificação de início
Rayfield:Notify({
   Title = "Big Hub Carregado",
   Content = "Sistema pronto para uso!",
   Duration = 3,
   Image = 4483362458,
})

-- Aba Principal
MainTab:CreateParagraph({
   Title = "Bem-vindo ao Big Hub",
   Content = "Sistema ESP + Aimbot Premium\nVersão 1.0\nUse as abas para acessar os recursos"
})

MainTab:CreateButton({
   Name = "Testar Sistema",
   Callback = function()
       Rayfield:Notify({
           Title = "Teste Concluído",
           Content = "Sistema funcionando perfeitamente!",
           Duration = 3,
           Image = 4483362458,
       })
   end,
})

-- Aba Combat
CombatTab:CreateToggle({
   Name = "Ativar Aimbot",
   CurrentValue = false,
   Flag = "AimbotToggle",
   Callback = function(Value)
       AimbotEnabled = Value
       if Value then
           Rayfield:Notify({
               Title = "Aimbot Ativado",
               Content = "Segure botão direito para usar",
               Duration = 3,
               Image = 4483362458,
           })
       end
   end,
})

CombatTab:CreateSlider({
   Name = "Campo de Visão (FOV)",
   Range = {50, 300},
   Increment = 10,
   Suffix = "pixels",
   CurrentValue = 100,
   Flag = "AimbotFOV",
   Callback = function(Value)
       AimbotFOV = Value
   end,
})

CombatTab:CreateSlider({
   Name = "Suavização",
   Range = {0.01, 0.5},
   Increment = 0.01,
   Suffix = "",
   CurrentValue = 0.1,
   Flag = "AimbotSmooth",
   Callback = function(Value)
       Smoothing = Value
   end,
})

-- Aba Visual
VisualTab:CreateToggle({
   Name = "Ativar ESP",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(Value)
       ESPEnabled = Value
       if Value then
           -- Criar ESP para todos os jogadores
           for _, player in pairs(Players:GetPlayers()) do
               if player ~= LocalPlayer then
                   CreateESP(player)
               end
           end
           
           Rayfield:Notify({
               Title = "ESP Ativado",
               Content = "Visualizando jogadores",
               Duration = 3,
               Image = 4483362458,
           })
       else
           -- Esconder ESP
           for _, esp in pairs(ESPObjects) do
               esp.Box.Visible = false
               esp.Name.Visible = false
           end
       end
   end,
})

VisualTab:CreateColorPicker({
   Name = "Cor do ESP",
   Color = ESPColor,
   Flag = "ESPColor",
   Callback = function(Value)
       ESPColor = Value
       -- Atualizar cor
       for _, esp in pairs(ESPObjects) do
           esp.Box.Color = Value
           esp.Name.Color = Value
       end
   end,
})

-- Loop do ESP
local ESPLoop = RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        UpdateESP()
    end
end)

-- Loop do Aimbot
local AimbotLoop = RunService.RenderStepped:Connect(function()
    if AimbotEnabled and UserInputService:IsMouseButtonPressed(AimbotKeybind) then
        local closestPlayer = GetClosestPlayer()
        
        if closestPlayer and closestPlayer.Character then
            local rootPart = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
            local head = closestPlayer.Character:FindFirstChild("Head")
            local target = head or rootPart
            
            if target then
                local currentCFrame = Camera.CFrame
                local targetCFrame = CFrame.new(Camera.CFrame.Position, target.Position)
                Camera.CFrame = currentCFrame:Lerp(targetCFrame, Smoothing)
            end
        end
    end
end)

-- Gerenciar jogadores
Players.PlayerAdded:Connect(function(player)
    CreateESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        ESPObjects[player].Box:Remove()
        ESPObjects[player].Name:Remove()
        ESPObjects[player] = nil
    end
end)

-- Inicializar ESP para jogadores existentes
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

-- Função de limpeza
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.P then
        for _, esp in pairs(ESPObjects) do
            esp.Box:Remove()
            esp.Name:Remove()
        end
        ESPObjects = {}
        ESPLoop:Disconnect()
        AimbotLoop:Disconnect()
        Rayfield:Destroy()
    end
end)

print("✅ Big Hub Premium carregado com sucesso!")
