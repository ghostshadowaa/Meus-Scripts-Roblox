--https://docs.sirius.menu/rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Sistema de chave simplificado e funcional
local validKeys = {
    "123456", "BIGHUB2024", "RAYFIELD", "SIRIUS", "FREEAIMBOT",
    "PROJECTX", "ADMIN123", "UNLOCKALL", "ESPMASTER", "GODMODE",
    "SECRETKEY", "12345", "PASSWORD", "ABCD1234", "987654321",
    "MEGAHACK", "ROBLOX123", "VIPTEAM", "SUPERUSER", "BETAKEY",
    "PREMIUM2024", "ULTIMATEHACK", "NEVERDIE", "WINNER", "CHAMPION"
}

-- Criação da janela principal SIMPLIFICADA
local Window = Rayfield:CreateWindow({
   Name = "Big Hub Premium",
   Icon = 0,
   LoadingTitle = "Carregando Big Hub...",
   LoadingSubtitle = "ESP + Aimbot System",
   ShowText = "Big Hub",
   Theme = "Default",
   
   ToggleUIKeybind = "RightControl",

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BigHub",
      FileName = "Settings"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = true,
   KeySettings = {
      Title = "Key System",
      Subtitle = "Enter Key to Continue",
      Note = "Use: 123456, PROJECTX, or FREEAIMBOT",
      FileName = "BigHubKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = validKeys
   }
})

-- Serviços necessários
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Variáveis do ESP
local ESPEnabled = false
local ESPObjects = {}
local ESPColor = Color3.fromRGB(0, 255, 255)
local ESPBoxes = true
local ESPNames = true
local ESPDistance = true

-- Variáveis do Aimbot
local AimbotEnabled = false
local AimbotKeybind = "RightMouse"
local AimbotRange = 2000
local AimbotFOV = 120
local Smoothing = 0.1
local AimbotPart = "Head"

-- Função para verificar jogador válido
function IsValidPlayer(player)
    if player == LocalPlayer then return false end
    if not player.Character then return false end
    if not player.Character:FindFirstChild("Humanoid") then return false end
    if player.Character.Humanoid.Health <= 0 then return false end
    if not player.Character:FindFirstChild("HumanoidRootPart") then return false end
    return true
end

-- Sistema ESP SIMPLIFICADO
function CreateESP(player)
    if ESPObjects[player] then return end
    
    local esp = {}
    
    -- Criar componentes do ESP
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
    
    esp.Distance = Drawing.new("Text")
    esp.Distance.Size = 12
    esp.Distance.Center = true
    esp.Distance.Outline = true
    esp.Distance.Color = ESPColor
    esp.Distance.Visible = false
    
    ESPObjects[player] = esp
end

function UpdateESP()
    for player, esp in pairs(ESPObjects) do
        if not IsValidPlayer(player) then
            esp.Box.Visible = false
            esp.Name.Visible = false
            esp.Distance.Visible = false
        else
            local character = player.Character
            local rootPart = character.HumanoidRootPart
            
            local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                local distance = (Camera.CFrame.Position - rootPart.Position).Magnitude
                local scale = math.clamp(1000 / distance, 0.5, 2)
                
                -- Atualizar caixa
                if ESPBoxes then
                    local size = Vector2.new(40 * scale, 60 * scale)
                    esp.Box.Size = size
                    esp.Box.Position = Vector2.new(screenPos.X - size.X / 2, screenPos.Y - size.Y / 2)
                    esp.Box.Visible = ESPEnabled
                else
                    esp.Box.Visible = false
                end
                
                -- Atualizar nome
                if ESPNames then
                    esp.Name.Position = Vector2.new(screenPos.X, screenPos.Y - (35 * scale))
                    esp.Name.Visible = ESPEnabled
                else
                    esp.Name.Visible = false
                end
                
                -- Atualizar distância
                if ESPDistance then
                    esp.Distance.Text = math.floor(distance) .. " studs"
                    esp.Distance.Position = Vector2.new(screenPos.X, screenPos.Y + (35 * scale))
                    esp.Distance.Visible = ESPEnabled
                else
                    esp.Distance.Visible = false
                end
            else
                esp.Box.Visible = false
                esp.Name.Visible = false
                esp.Distance.Visible = false
            end
        end
    end
end

-- Sistema Aimbot SIMPLIFICADO
function GetClosestPlayer()
    local closestPlayer = nil
    local closestDistance = AimbotFOV
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in pairs(Players:GetPlayers()) do
        if IsValidPlayer(player) then
            local character = player.Character
            local aimPart = character:FindFirstChild(AimbotPart) or character.HumanoidRootPart
            
            if aimPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
                
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

-- Criação das abas
local MainTab = Window:CreateTab("Main", 4483362458)
local CombatTab = Window:CreateTab("Combat", 4483362458)
local VisualTab = Window:CreateTab("Visual", 4483362458)

-- Notificação de início
Rayfield:Notify({
   Title = "Big Hub Loaded",
   Content = "ESP & Aimbot System Ready!",
   Duration = 3,
   Image = "check",
})

-- Aba principal
MainTab:CreateParagraph({
    Title = "Big Hub Premium",
    Content = "ESP + Aimbot System\nVersion 1.0\nUse the tabs to access features"
})

MainTab:CreateButton({
   Name = "Test Button",
   Callback = function()
       Rayfield:Notify({
           Title = "Test",
           Content = "System is working!",
           Duration = 3,
           Image = "check",
       })
   end,
})

-- Aba Combat (Aimbot)
CombatTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = AimbotEnabled,
    Flag = "AimbotToggle",
    Callback = function(Value)
        AimbotEnabled = Value
        if Value then
            Rayfield:Notify({
                Title = "Aimbot Enabled",
                Content = "Hold Right Mouse to aim",
                Duration = 3,
                Image = "target",
            })
        end
    end,
})

CombatTab:CreateDropdown({
    Name = "Aimbot Part",
    Options = {"Head", "Torso", "HumanoidRootPart"},
    CurrentOption = {AimbotPart},
    MultipleOptions = false,
    Flag = "AimbotPart",
    Callback = function(Option)
        AimbotPart = Option[1]
    end,
})

CombatTab:CreateSlider({
    Name = "Aimbot FOV",
    Range = {0, 500},
    Increment = 10,
    Suffix = "pixels",
    CurrentValue = AimbotFOV,
    Flag = "AimbotFOV",
    Callback = function(Value)
        AimbotFOV = Value
    end,
})

CombatTab:CreateSlider({
    Name = "Smoothing",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = Smoothing,
    Flag = "AimbotSmoothing",
    Callback = function(Value)
        Smoothing = Value
    end,
})

-- Aba Visual (ESP)
VisualTab:CreateToggle({
    Name = "ESP",
    CurrentValue = ESPEnabled,
    Flag = "ESPToggle",
    Callback = function(Value)
        ESPEnabled = Value
        if Value then
            -- Criar ESP para jogadores existentes
            for _, player in pairs(Players:GetPlayers()) do
                CreateESP(player)
            end
            Rayfield:Notify({
                Title = "ESP Enabled",
                Content = "Player ESP activated",
                Duration = 3,
                Image = "eye",
            })
        else
            -- Desativar ESP
            for _, esp in pairs(ESPObjects) do
                esp.Box.Visible = false
                esp.Name.Visible = false
                esp.Distance.Visible = false
            end
        end
    end,
})

VisualTab:CreateColorPicker({
    Name = "ESP Color",
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

VisualTab:CreateToggle({
    Name = "ESP Boxes",
    CurrentValue = ESPBoxes,
    Flag = "ESPBoxes",
    Callback = function(Value)
        ESPBoxes = Value
    end,
})

VisualTab:CreateToggle({
    Name = "ESP Names",
    CurrentValue = ESPNames,
    Flag = "ESPNames",
    Callback = function(Value)
        ESPNames = Value
    end,
})

VisualTab:CreateToggle({
    Name = "ESP Distance",
    CurrentValue = ESPDistance,
    Flag = "ESPDistance",
    Callback = function(Value)
        ESPDistance = Value
    end,
})

-- Loop principal do ESP
local ESPLoop = RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        UpdateESP()
    end
end)

-- Loop principal do Aimbot
local AimbotLoop = RunService.RenderStepped:Connect(function()
    if AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local closestPlayer = GetClosestPlayer()
        
        if closestPlayer then
            local character = closestPlayer.Character
            local aimPart = character:FindFirstChild(AimbotPart) or character.HumanoidRootPart
            
            if aimPart then
                local targetPosition = aimPart.Position
                local currentCFrame = Camera.CFrame
                local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPosition)
                Camera.CFrame = currentCFrame:Lerp(targetCFrame, Smoothing)
            end
        end
    end
end)

-- Gerenciamento de jogadores
Players.PlayerAdded:Connect(function(player)
    CreateESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        ESPObjects[player].Box:Remove()
        ESPObjects[player].Name:Remove()
        ESPObjects[player].Distance:Remove()
        ESPObjects[player] = nil
    end
end)

-- Criar ESP para jogadores iniciais
for _, player in pairs(Players:GetPlayers()) do
    CreateESP(player)
end

print("✅ Big Hub loaded successfully!")
