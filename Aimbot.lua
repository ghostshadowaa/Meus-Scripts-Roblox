--https://docs.sirius.menu/rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Sistema de chave simples e funcional
local validKeys = {
    "123456", -- Chave padrão 1
    "BIGHUB2024", -- Chave padrão 2
    "RAYFIELD", -- Chave padrão 3
    "SIRIUS", -- Chave padrão 4
    "FREEAIMBOT", -- Chave padrão 5
    "PROJECTX", -- Chave para teste
    "ADMIN123", -- Chave para administradores
    "UNLOCKALL", -- Chave especial
    "ESPMASTER", -- Chave para ESP
    "GODMODE", -- Chave premium
    "SECRETKEY", -- Chave secreta
    "12345", -- Chave simples
    "PASSWORD", -- Chave comum
    "ABCD1234", -- Chave alfanumérica
    "987654321", -- Chave numérica longa
    "MEGAHACK", -- Chave para hacks
    "ROBLOX123", -- Chave genérica
    "VIPTEAM", -- Chave para equipe
    "SUPERUSER", -- Chave super usuário
    "BETAKEY" -- Chave beta
}

-- Gerador de chave dinâmica (opcional para produção)
local function generateDynamicKey()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local key = ""
    for i = 1, 8 do
        local rand = math.random(1, #chars)
        key = key .. string.sub(chars, rand, rand)
    end
    table.insert(validKeys, key)
    return key
end

-- Adiciona algumas chaves dinâmicas ao iniciar
for i = 1, 5 do
    generateDynamicKey()
end

local Window = Rayfield:CreateWindow({
   Name = "Big Hub Premium",
   Icon = 0,
   LoadingTitle = "Carregando Big Hub...",
   LoadingSubtitle = "Sistema ESP + Aimbot Premium",
   ShowText = "Big Hub",
   Theme = "Default",

   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BigHubConfig",
      FileName = "BigHubSettings"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = true,
   KeySettings = {
      Title = "Big Hub Key System",
      Subtitle = "Entre com sua chave de acesso",
      Note = "Chaves válidas: 123456, BIGHUB2024, RAYFIELD, SIRIUS, FREEAIMBOT\nPara key grátis use: PROJECTX",
      FileName = "BigHubKey",
      SaveKey = true, -- Salva a chave para não precisar digitar sempre
      GrabKeyFromSite = false,
      Key = validKeys -- Usa nossa lista de chaves válidas
   }
})

-- Verificação adicional de chave (opcional)
local function validateKey(key)
    for _, validKey in ipairs(validKeys) do
        if key == validKey then
            return true
        end
    end
    return false
end

-- Exemplo de como usar a verificação adicional
Rayfield:Notify({
   Title = "Bem-vindo ao Big Hub!",
   Content = "Sistema ESP + Aimbot carregado com sucesso!",
   Duration = 5,
   Image = "check",
})

local Tab = Window:CreateTab("Menu Principal", 4483362458)

Rayfield:Notify({
   Title = "Sistema Ativo",
   Content = "ESP e Aimbot disponíveis na aba Combat!",
   Duration = 4,
   Image = "success",
})

-- ... (o resto do seu código permanece igual a partir daqui)

-- Elementos da GUI ESP
local CombatTab = Window:CreateTab("Combat", 4483362458)

-- Serviços necessários
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variáveis globais para ESP
local ESPEnabled = false
local ESPObjects = {}
local ESPColor = Color3.fromRGB(255, 0, 0)

-- Variáveis globais para Aimbot
local AimbotEnabled = false
local AimbotKeybind = Enum.UserInputType.MouseButton2
local AimbotRange = 1000
local AimbotFOV = 100
local Smoothing = 0.1

-- Função para verificar se um jogador é válido
function IsValidPlayer(player)
    return player ~= LocalPlayer and 
           player.Character and 
           player.Character:FindFirstChild("Humanoid") and 
           player.Character.Humanoid.Health > 0 and
           player.Character:FindFirstChild("HumanoidRootPart")
end

-- Função para obter a posição na tela
function GetScreenPosition(part)
    local vector, onScreen = Camera:WorldToViewportPoint(part.Position)
    return Vector2.new(vector.X, vector.Y), onScreen, vector.Z
end

-- Sistema ESP
function CreateESP(player)
    if ESPObjects[player] then return end
    
    local esp = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        HealthBar = Drawing.new("Square"),
        HealthText = Drawing.new("Text")
    }
    
    -- Configurar caixa
    esp.Box.Thickness = 2
    esp.Box.Filled = false
    esp.Box.Color = ESPColor
    esp.Box.Visible = false
    
    -- Configurar nome
    esp.Name.Text = player.Name
    esp.Name.Size = 13
    esp.Name.Center = true
    esp.Name.Outline = true
    esp.Name.Color = ESPColor
    esp.Name.Visible = false
    
    -- Configurar distância
    esp.Distance.Size = 13
    esp.Distance.Center = true
    esp.Distance.Outline = true
    esp.Distance.Color = ESPColor
    esp.Distance.Visible = false
    
    -- Configurar barra de vida
    esp.HealthBar.Thickness = 1
    esp.HealthBar.Filled = true
    esp.HealthBar.Color = Color3.fromRGB(0, 255, 0)
    esp.HealthBar.Visible = false
    
    -- Configurar texto de vida
    esp.HealthText.Size = 11
    esp.HealthText.Center = true
    esp.HealthText.Outline = true
    esp.HealthText.Color = Color3.fromRGB(255, 255, 255)
    esp.HealthText.Visible = false
    
    ESPObjects[player] = esp
end

function UpdateESP()
    for player, esp in pairs(ESPObjects) do
        if not IsValidPlayer(player) then
            esp.Box.Visible = false
            esp.Name.Visible = false
            esp.Distance.Visible = false
            esp.HealthBar.Visible = false
            esp.HealthText.Visible = false
        else
            local character = player.Character
            local rootPart = character.HumanoidRootPart
            local humanoid = character.Humanoid
            
            local screenPos, onScreen, depth = GetScreenPosition(rootPart)
            
            if onScreen then
                -- Calcular tamanho da caixa baseado na distância
                local distance = (Camera.CFrame.Position - rootPart.Position).Magnitude
                local scale = 100 / distance
                
                -- Atualizar caixa
                local size = Vector2.new(50 * scale, 80 * scale)
                esp.Box.Size = size
                esp.Box.Position = screenPos - size / 2
                esp.Box.Visible = ESPEnabled
                
                -- Atualizar nome
                esp.Name.Position = Vector2.new(screenPos.X, screenPos.Y - size.Y / 2 - 20)
                esp.Name.Visible = ESPEnabled
                
                -- Atualizar distância
                esp.Distance.Text = math.floor(distance) .. " studs"
                esp.Distance.Position = Vector2.new(screenPos.X, screenPos.Y + size.Y / 2 + 5)
                esp.Distance.Visible = ESPEnabled
                
                -- Atualizar barra de vida
                local healthPercent = humanoid.Health / humanoid.MaxHealth
                local healthBarWidth = 40 * scale
                local healthBarHeight = 4
                local healthBarX = screenPos.X - healthBarWidth / 2
                local healthBarY = screenPos.Y - size.Y / 2 - 10
                
                esp.HealthBar.Size = Vector2.new(healthBarWidth * healthPercent, healthBarHeight)
                esp.HealthBar.Position = Vector2.new(healthBarX, healthBarY)
                esp.HealthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                esp.HealthBar.Visible = ESPEnabled
                
                -- Atualizar texto de vida
                esp.HealthText.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                esp.HealthText.Position = Vector2.new(screenPos.X, healthBarY - 12)
                esp.HealthText.Visible = ESPEnabled
            else
                esp.Box.Visible = false
                esp.Name.Visible = false
                esp.Distance.Visible = false
                esp.HealthBar.Visible = false
                esp.HealthText.Visible = false
            end
        end
    end
end

function RemoveESP(player)
    if ESPObjects[player] then
        ESPObjects[player].Box:Remove()
        ESPObjects[player].Name:Remove()
        ESPObjects[player].Distance:Remove()
        ESPObjects[player].HealthBar:Remove()
        ESPObjects[player].HealthText:Remove()
        ESPObjects[player] = nil
    end
end

-- Sistema Aimbot
function GetClosestPlayer()
    local closestPlayer = nil
    local closestDistance = AimbotRange
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in pairs(Players:GetPlayers()) do
        if IsValidPlayer(player) then
            local character = player.Character
            local rootPart = character.HumanoidRootPart
            
            local screenPos, onScreen = GetScreenPosition(rootPart)
            
            if onScreen then
                local distance = (mousePos - screenPos).Magnitude
                
                -- Verificar se está dentro do FOV
                if distance < AimbotFOV and distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    
    return closestPlayer
end

-- Loop de ESP
local ESPLoop
function StartESPLoop()
    if ESPLoop then return end
    
    ESPLoop = RunService.RenderStepped:Connect(function()
        if ESPEnabled then
            UpdateESP()
        end
    end)
end

-- Loop de Aimbot
local AimbotLoop
function StartAimbotLoop()
    if AimbotLoop then return end
    
    AimbotLoop = RunService.RenderStepped:Connect(function()
        if AimbotEnabled and UserInputService:IsMouseButtonPressed(AimbotKeybind) then
            local closestPlayer = GetClosestPlayer()
            
            if closestPlayer then
                local character = closestPlayer.Character
                local rootPart = character.HumanoidRootPart
                
                -- Calcular a posição para mirar (cabeça)
                local head = character:FindFirstChild("Head")
                local targetPosition = head and head.Position or rootPart.Position + Vector3.new(0, 2, 0)
                
                -- Suavizar o movimento da câmera
                local currentCFrame = Camera.CFrame
                local newCFrame = CFrame.new(currentCFrame.Position, targetPosition)
                Camera.CFrame = currentCFrame:Lerp(newCFrame, Smoothing)
            end
        end
    end)
end

-- Elementos da GUI para ESP
local ESPToggle = CombatTab:CreateToggle({
    Name = "ESP (Visualizar Jogadores)",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(Value)
        ESPEnabled = Value
        
        if Value then
            StartESPLoop()
            -- Criar ESP para todos os jogadores existentes
            for _, player in pairs(Players:GetPlayers()) do
                CreateESP(player)
            end
        else
            -- Esconder todos os ESPs
            for _, esp in pairs(ESPObjects) do
                esp.Box.Visible = false
                esp.Name.Visible = false
                esp.Distance.Visible = false
                esp.HealthBar.Visible = false
                esp.HealthText.Visible = false
            end
        end
    end,
})

local ESPColorPicker = CombatTab:CreateColorPicker({
    Name = "Cor do ESP",
    Color = ESPColor,
    Flag = "ESPColor",
    Callback = function(Value)
        ESPColor = Value
        -- Atualizar cor de todos os ESPs
        for _, esp in pairs(ESPObjects) do
            esp.Box.Color = Value
            esp.Name.Color = Value
            esp.Distance.Color = Value
        end
    end,
})

-- Elementos da GUI para Aimbot
local AimbotToggle = CombatTab:CreateToggle({
    Name = "Aimbot (Mira Automática)",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(Value)
        AimbotEnabled = Value
        
        if Value then
            StartAimbotLoop()
            Rayfield:Notify({
                Title = "Aimbot Ativado",
                Content = "Segure Botão Direito para travar no inimigo",
                Duration = 3,
                Image = "target",
            })
        end
    end,
})

local AimbotRangeSlider = CombatTab:CreateSlider({
    Name = "Alcance do Aimbot",
    Range = {0, 5000},
    Increment = 100,
    Suffix = "studs",
    CurrentValue = AimbotRange,
    Flag = "AimbotRange",
    Callback = function(Value)
        AimbotRange = Value
    end,
})

local AimbotFOVSlider = CombatTab:CreateSlider({
    Name = "Campo de Visão (FOV)",
    Range = {0, 500},
    Increment = 10,
    Suffix = "pixels",
    CurrentValue = AimbotFOV,
    Flag = "AimbotFOV",
    Callback = function(Value)
        AimbotFOV = Value
    end,
})

local SmoothingSlider = CombatTab:CreateSlider({
    Name = "Suavização da Mira",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = Smoothing,
    Flag = "AimbotSmoothing",
    Callback = function(Value)
        Smoothing = Value
    end,
})

-- Botão para testar chave
CombatTab:CreateButton({
    Name = "Gerar Nova Chave (Teste)",
    Callback = function()
        local newKey = generateDynamicKey()
        Rayfield:Notify({
            Title = "Nova Chave Gerada",
            Content = "Chave: " .. newKey,
            Duration = 10,
            Image = "key",
        })
    end,
})

-- Botão para limpar ESP
CombatTab:CreateButton({
    Name = "Limpar ESP",
    Callback = function()
        for player, _ in pairs(ESPObjects) do
            RemoveESP(player)
        end
        ESPObjects = {}
        Rayfield:Notify({
            Title = "ESP Limpo",
            Content = "Todos os ESPs foram removidos",
            Duration = 3,
            Image = "trash",
        })
    end,
})

-- Informações
CombatTab:CreateParagraph({
    Title = "Instruções de Uso",
    Content = "ESP: Mostra caixas, nomes, distância e vida dos jogadores\nAimbot: Segure Botão Direito para mirar automaticamente\nAjuste o FOV para controlar a área de mira\nUse suavização para movimentos mais naturais"
})

-- Gerenciamento de jogadores
Players.PlayerAdded:Connect(function(player)
    if ESPEnabled then
        CreateESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

-- Adiciona ESP para jogadores existentes quando ativado
task.spawn(function()
    wait(2) -- Espera a UI carregar
    for _, player in pairs(Players:GetPlayers()) do
        CreateESP(player)
    end
end)

-- Tab de Configurações
local SettingsTab = Window:CreateTab("Configurações", 4483362458)

SettingsTab:CreateLabel("Configurações do Sistema", "settings")

SettingsTab:CreateButton({
    Name = "Salvar Configurações",
    Callback = function()
        Rayfield:Notify({
            Title = "Configurações Salvas",
            Content = "Suas configurações foram salvas com sucesso!",
            Duration = 3,
            Image = "save",
        })
    end,
})

SettingsTab:CreateButton({
    Name = "Resetar Configurações",
    Callback = function()
        ESPEnabled = false
        AimbotEnabled = false
        ESPColor = Color3.fromRGB(255, 0, 0)
        AimbotRange = 1000
        AimbotFOV = 100
        Smoothing = 0.1
        
        Rayfield:Notify({
            Title = "Configurações Resetadas",
            Content = "Todas as configurações foram resetadas",
            Duration = 3,
            Image = "refresh",
        })
    end,
})

SettingsTab:CreateParagraph({
    Title = "Chaves Válidas",
    Content = "Use uma destas chaves para acesso:\n- 123456\n- BIGHUB2024\n- RAYFIELD\n- SIRIUS\n- FREEAIMBOT\n- PROJECTX (recomendada para teste)"
})
