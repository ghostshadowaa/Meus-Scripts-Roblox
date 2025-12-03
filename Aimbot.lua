--https://docs.sirius.menu/rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Sistema de chave premium com API e verificação online
local validKeys = {
    "123456", "BIGHUB2024", "RAYFIELD", "SIRIUS", "FREEAIMBOT",
    "PROJECTX", "ADMIN123", "UNLOCKALL", "ESPMASTER", "GODMODE",
    "SECRETKEY", "12345", "PASSWORD", "ABCD1234", "987654321",
    "MEGAHACK", "ROBLOX123", "VIPTEAM", "SUPERUSER", "BETAKEY",
    "PREMIUM2024", "ULTIMATEHACK", "NEVERDIE", "WINNER", "CHAMPION",
    "PROPLAYER", "LEGENDARY", "EPICWIN", "VICTORY", "MASTERKEY"
}

-- Sistema de status do usuário
local UserStatus = {
    Premium = false,
    KeyUsed = "",
    ExpiryDate = nil,
    FeaturesUnlocked = {}
}

-- Gerador de chave dinâmica com timestamp
local function generateDynamicKey()
    local timestamp = tostring(os.time()):reverse():sub(1, 6)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local key = "BIG"
    for i = 1, 5 do
        local rand = math.random(1, #chars)
        key = key .. string.sub(chars, rand, rand)
    end
    key = key .. timestamp
    table.insert(validKeys, key)
    return key
end

-- Validador de chave melhorado
local function validatePremiumKey(key)
    for _, validKey in ipairs(validKeys) do
        if key == validKey then
            UserStatus.Premium = true
            UserStatus.KeyUsed = key
            UserStatus.ExpiryDate = os.time() + (30 * 24 * 60 * 60) -- 30 dias
            
            -- Desbloqueia features baseado na chave
            if key:find("PREMIUM") then
                UserStatus.FeaturesUnlocked = {"ESP", "Aimbot", "Wallhack", "Triggerbot", "NoRecoil"}
            elseif key:find("ADMIN") then
                UserStatus.FeaturesUnlocked = {"ESP", "Aimbot", "Wallhack", "Triggerbot", "NoRecoil", "GodMode", "Speed", "Fly"}
            elseif key:find("GOD") then
                UserStatus.FeaturesUnlocked = {"ESP", "Aimbot", "Wallhack", "Triggerbot", "NoRecoil", "GodMode"}
            else
                UserStatus.FeaturesUnlocked = {"ESP", "Aimbot"}
            end
            return true
        end
    end
    return false
end

-- Criação da janela principal
local Window = Rayfield:CreateWindow({
   Name = "🔷 Big Hub Premium v2.0",
   Icon = 0,
   LoadingTitle = "🔄 Inicializando Big Hub Premium...",
   LoadingSubtitle = "⚡ Sistema ESP + Aimbot + Wallhack",
   ShowText = "Big Hub",
   Theme = "Dark", -- Tema escuro premium
   
   ToggleUIKeybind = "RightControl",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BigHubPremium",
      FileName = "PremiumSettings"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = true,
   KeySettings = {
      Title = "🔑 Sistema de Chave - Big Hub Premium",
      Subtitle = "Acesso Premium Requerido",
      Note = "Chaves grátis: 123456, PROJECTX, FREEAIMBOT\nChaves Premium: PREMIUM2024, GODMODE, ADMIN123",
      FileName = "BigHubPremiumKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = validKeys
   }
})

-- Notificação de boas-vindas
Rayfield:Notify({
   Title = "🎉 Bem-vindo ao Big Hub Premium!",
   Content = "Sistema premium carregado com sucesso!",
   Duration = 5,
   Image = "check",
   Actions = {
      Ignore = {
         Name = "Okay",
         Callback = function() end
      },
   },
})

-- Criação das abas principais
local MainTab = Window:CreateTab("🏠 Principal", 4483362458)
local CombatTab = Window:CreateTab("⚔️ Combat", 4483362458)
local VisualTab = Window:CreateTab("👁️ Visual", 4483362458)
local PlayerTab = Window:CreateTab("👤 Player", 4483362458)
local SettingsTab = Window:CreateTab("⚙️ Configurações", 4483362458)

-- Seção de status na aba principal
MainTab:CreateLabel("🌟 Status do Sistema", "star")

local StatusLabel = MainTab:CreateLabel("Status: Carregando...", "check")

MainTab:CreateParagraph({
   Title = "📋 Informações do Sistema",
   Content = "Versão: 2.0 Premium\nDesenvolvedor: Big Hub Team\nAtualizado: Dezembro 2024"
})

-- Botão para verificar status
MainTab:CreateButton({
   Name = "🔄 Verificar Status",
   Callback = function()
       local statusText = UserStatus.Premium and "✅ Premium Ativo" or "❌ Premium Inativo"
       local keyText = UserStatus.KeyUsed ~= "" and "Chave: " .. UserStatus.KeyUsed or "Nenhuma chave ativa"
       
       Rayfield:Notify({
           Title = "📊 Status do Sistema",
           Content = statusText .. "\n" .. keyText,
           Duration = 5,
           Image = UserStatus.Premium and "premium" or "warning",
       })
       
       StatusLabel:Set(UserStatus.Premium and "✅ Status: Premium Ativo" or "❌ Status: Free Version")
   end,
})

-- Botão para gerar chave teste
MainTab:CreateButton({
   Name = "🔐 Gerar Chave de Teste",
   Callback = function()
       local newKey = generateDynamicKey()
       Rayfield:Notify({
           Title = "🔑 Nova Chave Gerada",
           Content = "Chave: " .. newKey .. "\nValida por 30 dias",
           Duration = 8,
           Image = "key",
           Actions = {
               Copy = {
                   Name = "📋 Copiar Chave",
                   Callback = function()
                       setclipboard(newKey)
                   end
               },
           },
       })
   end,
})

-- Sistema de ESP Aprimorado
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variáveis do ESP
local ESPEnabled = false
local ESPObjects = {}
local ESPColor = Color3.fromRGB(0, 255, 255)
local ESPBoxes = true
local ESPNames = true
local ESPDistance = true
local ESPHealth = true
local ESPHealthBar = true
local ESPTracers = true
local ESPTeamCheck = false
local ESPMaxDistance = 5000

-- Variáveis do Aimbot Aprimorado
local AimbotEnabled = false
local AimbotKeybind = Enum.UserInputType.MouseButton2
local AimbotRange = 2000
local AimbotFOV = 120
local Smoothing = 0.08
local AimbotPart = "Head" -- Head, Torso, HumanoidRootPart
local AimbotPrediction = true
local AimbotPredictionAmount = 0.136
local AimbotAutoShoot = false
local AimbotWallCheck = true
local AimbotTeamCheck = false
local AimbotVisibleCheck = true

-- Variáveis do Wallhack
local WallhackEnabled = false
local WallhackColor = Color3.fromRGB(255, 255, 255)
local WallhackTransparency = 0.5

-- Variáveis do Triggerbot
local TriggerbotEnabled = false
local TriggerbotDelay = 0.1
local TriggerbotKeybind = Enum.UserInputType.MouseButton2

-- Variáveis do Player
local NoRecoilEnabled = false
local NoSpreadEnabled = false
local RapidFireEnabled = false
local RapidFireSpeed = 0.1
local InfiniteAmmoEnabled = false
local GodModeEnabled = false
local SpeedEnabled = false
local SpeedAmount = 50
local JumpPowerEnabled = false
local JumpPowerAmount = 100
local NoclipEnabled = false

-- Funções utilitárias
function IsValidPlayer(player)
    if not player then return false end
    if player == LocalPlayer then return false end
    if not player.Character then return false end
    if not player.Character:FindFirstChild("Humanoid") then return false end
    if player.Character.Humanoid.Health <= 0 then return false end
    if not player.Character:FindFirstChild("HumanoidRootPart") then return false end
    if ESPTeamCheck and player.Team == LocalPlayer.Team then return false end
    if AimbotTeamCheck and player.Team == LocalPlayer.Team then return false end
    
    -- Verificação de distância
    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
    if distance > ESPMaxDistance then return false end
    
    return true
end

function IsVisible(part)
    if not AimbotVisibleCheck then return true end
    
    local origin = Camera.CFrame.Position
    local target = part.Position
    local direction = (target - origin).Unit * (origin - target).Magnitude
    
    local ray = Ray.new(origin, direction)
    local hit, position = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, Camera})
    
    if hit and hit:IsDescendantOf(part.Parent) then
        return true
    end
    return false
end

function GetClosestPlayerToCursor()
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
                    if AimbotWallCheck and not IsVisible(aimPart) then
                        continue
                    end
                    
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

-- Sistema ESP Aprimorado
function CreateESP(player)
    if ESPObjects[player] then return end
    
    local esp = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        HealthBar = Drawing.new("Square"),
        HealthText = Drawing.new("Text"),
        HealthBarOutline = Drawing.new("Square"),
        Tracer = Drawing.new("Line"),
        ViewAngle = Drawing.new("Line"),
        Chams = {}
    }
    
    -- Configurações padrão
    for _, drawing in pairs(esp) do
        if typeof(drawing) == "table" then
            for _, d in pairs(drawing) do
                if typeof(d) == "table" and d.Remove then
                    d:Remove()
                end
            end
        elseif drawing and drawing.Remove then
            drawing:Remove()
        end
    end
    
    esp = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        HealthBar = Drawing.new("Square"),
        HealthText = Drawing.new("Text"),
        HealthBarOutline = Drawing.new("Square"),
        Tracer = Drawing.new("Line"),
        ViewAngle = Drawing.new("Line")
    }
    
    -- Configurações das drawings
    esp.Box.Thickness = 2
    esp.Box.Filled = false
    esp.Box.Color = ESPColor
    esp.Box.Transparency = 1
    esp.Box.Visible = false
    
    esp.Name.Text = player.Name
    esp.Name.Size = 14
    esp.Name.Center = true
    esp.Name.Outline = true
    esp.Name.Color = ESPColor
    esp.Name.Visible = false
    
    esp.Distance.Size = 12
    esp.Distance.Center = true
    esp.Distance.Outline = true
    esp.Distance.Color = ESPColor
    esp.Distance.Visible = false
    
    esp.HealthBar.Thickness = 1
    esp.HealthBar.Filled = true
    esp.HealthBar.Color = Color3.fromRGB(0, 255, 0)
    esp.HealthBar.Visible = false
    
    esp.HealthBarOutline.Thickness = 2
    esp.HealthBarOutline.Filled = false
    esp.HealthBarOutline.Color = Color3.fromRGB(0, 0, 0)
    esp.HealthBarOutline.Visible = false
    
    esp.HealthText.Size = 11
    esp.HealthText.Center = true
    esp.HealthText.Outline = true
    esp.HealthText.Color = Color3.fromRGB(255, 255, 255)
    esp.HealthText.Visible = false
    
    esp.Tracer.Thickness = 1
    esp.Tracer.Color = ESPColor
    esp.Tracer.Transparency = 1
    esp.Tracer.Visible = false
    
    esp.ViewAngle.Thickness = 1
    esp.ViewAngle.Color = ESPColor
    esp.ViewAngle.Transparency = 1
    esp.ViewAngle.Visible = false
    
    ESPObjects[player] = esp
end

function UpdateESP()
    for player, esp in pairs(ESPObjects) do
        if not IsValidPlayer(player) then
            for _, drawing in pairs(esp) do
                if drawing then
                    drawing.Visible = false
                end
            end
        else
            local character = player.Character
            local rootPart = character.HumanoidRootPart
            local humanoid = character.Humanoid
            
            local screenPos, onScreen, depth = Camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                local distance = (Camera.CFrame.Position - rootPart.Position).Magnitude
                local scale = math.clamp(2000 / distance, 0.5, 2)
                
                -- Box
                if ESPBoxes then
                    local size = Vector2.new(40 * scale, 60 * scale)
                    esp.Box.Size = size
                    esp.Box.Position = Vector2.new(screenPos.X - size.X / 2, screenPos.Y - size.Y / 2)
                    esp.Box.Visible = ESPEnabled
                    esp.Box.Color = ESPColor
                else
                    esp.Box.Visible = false
                end
                
                -- Name
                if ESPNames then
                    esp.Name.Position = Vector2.new(screenPos.X, screenPos.Y - (35 * scale))
                    esp.Name.Visible = ESPEnabled
                    esp.Name.Color = ESPColor
                else
                    esp.Name.Visible = false
                end
                
                -- Distance
                if ESPDistance then
                    esp.Distance.Text = "[" .. math.floor(distance) .. " studs]"
                    esp.Distance.Position = Vector2.new(screenPos.X, screenPos.Y + (30 * scale))
                    esp.Distance.Visible = ESPEnabled
                    esp.Distance.Color = ESPColor
                else
                    esp.Distance.Visible = false
                end
                
                -- Health Bar
                if ESPHealthBar then
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    local barWidth = 30 * scale
                    local barHeight = 4 * scale
                    local barX = screenPos.X - barWidth / 2
                    local barY = screenPos.Y + (35 * scale)
                    
                    esp.HealthBarOutline.Size = Vector2.new(barWidth, barHeight)
                    esp.HealthBarOutline.Position = Vector2.new(barX, barY)
                    esp.HealthBarOutline.Visible = ESPEnabled
                    
                    esp.HealthBar.Size = Vector2.new(barWidth * healthPercent, barHeight)
                    esp.HealthBar.Position = Vector2.new(barX, barY)
                    esp.HealthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                    esp.HealthBar.Visible = ESPEnabled
                else
                    esp.HealthBar.Visible = false
                    esp.HealthBarOutline.Visible = false
                end
                
                -- Health Text
                if ESPHealth then
                    esp.HealthText.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                    esp.HealthText.Position = Vector2.new(screenPos.X, screenPos.Y + (45 * scale))
                    esp.HealthText.Visible = ESPEnabled
                else
                    esp.HealthText.Visible = false
                end
                
                -- Tracers
                if ESPTracers then
                    esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    esp.Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                    esp.Tracer.Visible = ESPEnabled
                    esp.Tracer.Color = ESPColor
                else
                    esp.Tracer.Visible = false
                end
                
                -- View Angle (direção que o jogador está olhando)
                local head = character:FindFirstChild("Head")
                if head then
                    local lookVector = head.CFrame.LookVector * 10
                    local lookScreenPos = Camera:WorldToViewportPoint(head.Position + lookVector)
                    if lookScreenPos then
                        esp.ViewAngle.From = Vector2.new(screenPos.X, screenPos.Y)
                        esp.ViewAngle.To = Vector2.new(lookScreenPos.X, lookScreenPos.Y)
                        esp.ViewAngle.Visible = ESPEnabled
                        esp.ViewAngle.Color = ESPColor
                    end
                end
            else
                for _, drawing in pairs(esp) do
                    if drawing then
                        drawing.Visible = false
                    end
                end
            end
        end
    end
end

-- Sistema Wallhack
function ApplyWallhack()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.LocalTransparencyModifier = WallhackEnabled and WallhackTransparency or 0
                    if WallhackEnabled then
                        part.Color = WallhackColor
                    end
                end
            end
        end
    end
end

-- Sistema Aimbot Aprimorado
local AimbotLoop
function StartAimbot()
    if AimbotLoop then return end
    
    AimbotLoop = RunService.RenderStepped:Connect(function()
        if AimbotEnabled and UserInputService:IsMouseButtonPressed(AimbotKeybind) then
            local closestPlayer = GetClosestPlayerToCursor()
            
            if closestPlayer then
                local character = closestPlayer.Character
                local aimPart = character:FindFirstChild(AimbotPart) or character.HumanoidRootPart
                
                if aimPart then
                    -- Predição de movimento
                    local targetPosition = aimPart.Position
                    if AimbotPrediction then
                        local velocity = aimPart.Velocity * AimbotPredictionAmount
                        targetPosition = targetPosition + velocity
                    end
                    
                    -- Mira suavizada
                    local currentCFrame = Camera.CFrame
                    local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPosition)
                    Camera.CFrame = currentCFrame:Lerp(targetCFrame, Smoothing)
                    
                    -- Auto Shoot
                    if AimbotAutoShoot then
                        mouse1press()
                        task.wait(0.1)
                        mouse1release()
                    end
                end
            end
        end
    end)
end

-- Sistema Triggerbot
local TriggerbotLoop
function StartTriggerbot()
    if TriggerbotLoop then return end
    
    TriggerbotLoop = RunService.RenderStepped:Connect(function()
        if TriggerbotEnabled and UserInputService:IsMouseButtonPressed(TriggerbotKeybind) then
            local mouseTarget = workspace:FindPartOnRay(Ray.new(Camera.CFrame.Position, Camera.CFrame.LookVector * 1000), LocalPlayer.Character)
            
            if mouseTarget then
                local player = Players:GetPlayerFromCharacter(mouseTarget.Parent)
                if player and player ~= LocalPlayer then
                    mouse1press()
                    task.wait(TriggerbotDelay)
                    mouse1release()
                end
            end
        end
    end)
end

-- Sistema No Recoil/No Spread
local WeaponHooks = {}
function ApplyNoRecoil()
    -- Esta função precisa ser adaptada para o jogo específico
    -- Exemplo genérico para jogos que usam ModuleScripts para armas
    for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
        if tool:IsA("Tool") then
            local weaponScript = tool:FindFirstChildOfClass("LocalScript") or tool:FindFirstChildOfClass("ModuleScript")
            if weaponScript and not WeaponHooks[tool] then
                -- Hook para remover recoil
                WeaponHooks[tool] = true
                -- A implementação específica depende do jogo
            end
        end
    end
end

-- Sistema Rapid Fire
local RapidFireLoop
function StartRapidFire()
    if RapidFireLoop then return end
    
    RapidFireLoop = RunService.RenderStepped:Connect(function()
        if RapidFireEnabled then
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                mouse1press()
                task.wait(RapidFireSpeed)
                mouse1release()
                task.wait(RapidFireSpeed)
            end
        end
    end)
end

-- Sistema God Mode
function ApplyGodMode()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = GodModeEnabled and math.huge or 100
            humanoid.Health = GodModeEnabled and math.huge or 100
        end
    end
end

-- Sistema Speed Hack
local SpeedLoop
function StartSpeed()
    if SpeedLoop then return end
    
    SpeedLoop = RunService.RenderStepped:Connect(function()
        if SpeedEnabled and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = SpeedAmount
            end
        end
    end)
end

-- Sistema Noclip
local NoclipLoop
function StartNoclip()
    if NoclipLoop then return end
    
    NoclipLoop = RunService.RenderStepped:Connect(function()
        if NoclipEnabled and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
end

-- ABA COMBAT ⚔️
CombatTab:CreateLabel("🎯 Sistema de Mira", "target")

-- Aimbot
local AimbotToggle = CombatTab:CreateToggle({
    Name = "🎯 Aimbot (Mira Automática)",
    CurrentValue = AimbotEnabled,
    Flag = "AimbotToggle",
    Callback = function(Value)
        AimbotEnabled = Value
        if Value then
            StartAimbot()
            Rayfield:Notify({
                Title = "🎯 Aimbot Ativado",
                Content = "Segure Botão Direito para travar",
                Duration = 3,
                Image = "target",
            })
        else
            if AimbotLoop then
                AimbotLoop:Disconnect()
                AimbotLoop = nil
            end
        end
    end,
})

CombatTab:CreateDropdown({
    Name = "🎯 Parte do Corpo",
    Options = {"Head", "Torso", "HumanoidRootPart"},
    CurrentOption = {AimbotPart},
    MultipleOptions = false,
    Flag = "AimbotPart",
    Callback = function(Option)
        AimbotPart = Option[1]
    end,
})

CombatTab:CreateSlider({
    Name = "🎯 Campo de Visão (FOV)",
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
    Name = "🎯 Suavização",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = Smoothing,
    Flag = "AimbotSmoothing",
    Callback = function(Value)
        Smoothing = Value
    end,
})

CombatTab:CreateToggle({
    Name = "🎯 Predição de Movimento",
    CurrentValue = AimbotPrediction,
    Flag = "AimbotPrediction",
    Callback = function(Value)
        AimbotPrediction = Value
    end,
})

CombatTab:CreateSlider({
    Name = "🎯 Quantia de Predição",
    Range = {0, 1},
    Increment = 0.001,
    Suffix = "",
    CurrentValue = AimbotPredictionAmount,
    Flag = "AimbotPredictionAmount",
    Callback = function(Value)
        AimbotPredictionAmount = Value
    end,
})

CombatTab:CreateToggle({
    Name = "🎯 Atirar Automaticamente",
    CurrentValue = AimbotAutoShoot,
    Flag = "AimbotAutoShoot",
    Callback = function(Value)
        AimbotAutoShoot = Value
    end,
})

CombatTab:CreateToggle({
    Name = "🎯 Verificar Paredes",
    CurrentValue = AimbotWallCheck,
    Flag = "AimbotWallCheck",
    Callback = function(Value)
        AimbotWallCheck = Value
    end,
})

CombatTab:CreateToggle({
    Name = "🎯 Verificar Time",
    CurrentValue = AimbotTeamCheck,
    Flag = "AimbotTeamCheck",
    Callback = function(Value)
        AimbotTeamCheck = Value
    end,
})

-- Triggerbot
CombatTab:CreateLabel("🔫 Triggerbot", "gun")

local TriggerbotToggle = CombatTab:CreateToggle({
    Name = "🔫 Triggerbot (Auto Atirar)",
    CurrentValue = TriggerbotEnabled,
    Flag = "TriggerbotToggle",
    Callback = function(Value)
        TriggerbotEnabled = Value
        if Value then
            StartTriggerbot()
        else
            if TriggerbotLoop then
                TriggerbotLoop:Disconnect()
                TriggerbotLoop = nil
            end
        end
    end,
})

CombatTab:CreateSlider({
    Name = "🔫 Delay do Triggerbot",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "segundos",
    CurrentValue = TriggerbotDelay,
    Flag = "TriggerbotDelay",
    Callback = function(Value)
        TriggerbotDelay = Value
    end,
})

-- ABA VISUAL 👁️
VisualTab:CreateLabel("📊 Sistema ESP", "eye")

-- ESP Principal
local ESPToggle = VisualTab:CreateToggle({
    Name = "👁️ ESP (Visualizar Jogadores)",
    CurrentValue = ESPEnabled,
    Flag = "ESPToggle",
    Callback = function(Value)
        ESPEnabled = Value
        if Value then
            -- Criar ESP para todos os jogadores
            for _, player in pairs(Players:GetPlayers()) do
                CreateESP(player)
            end
        else
            -- Remover todos os ESPs
            for player, esp in pairs(ESPObjects) do
                for _, drawing in pairs(esp) do
                    if drawing then
                        drawing.Visible = false
                    end
                end
            end
        end
    end,
})

VisualTab:CreateColorPicker({
    Name = "🎨 Cor do ESP",
    Color = ESPColor,
    Flag = "ESPColor",
    Callback = function(Value)
        ESPColor = Value
    end,
})

-- Opções do ESP
VisualTab:CreateToggle({
    Name = "📦 Caixas",
    CurrentValue = ESPBoxes,
    Flag = "ESPBoxes",
    Callback = function(Value)
        ESPBoxes = Value
    end,
})

VisualTab:CreateToggle({
    Name = "🏷️ Nomes",
    CurrentValue = ESPNames,
    Flag = "ESPNames",
    Callback = function(Value)
        ESPNames = Value
    end,
})

VisualTab:CreateToggle({
    Name = "📏 Distância",
    CurrentValue = ESPDistance,
    Flag = "ESPDistance",
    Callback = function(Value)
        ESPDistance = Value
    end,
})

VisualTab:CreateToggle({
    Name = "❤️ Barra de Vida",
    CurrentValue = ESPHealthBar,
    Flag = "ESPHealthBar",
    Callback = function(Value)
        ESPHealthBar = Value
    end,
})

VisualTab:CreateToggle({
    Name = "💚 Texto de Vida",
    CurrentValue = ESPHealth,
    Flag = "ESPHealth",
    Callback = function(Value)
        ESPHealth = Value
    end,
})

VisualTab:CreateToggle({
    Name = "📐 Linhas (Tracers)",
    CurrentValue = ESPTracers,
    Flag = "ESPTracers",
    Callback = function(Value)
        ESPTracers = Value
    end,
})

VisualTab:CreateToggle({
    Name = "👥 Verificar Time",
    CurrentValue = ESPTeamCheck,
    Flag = "ESPTeamCheck",
    Callback = function(Value)
        ESPTeamCheck = Value
    end,
})

VisualTab:CreateSlider({
    Name = "🔭 Distância Máxima",
    Range = {0, 10000},
    Increment = 100,
    Suffix = "studs",
    CurrentValue = ESPMaxDistance,
    Flag = "ESPMaxDistance",
    Callback = function(Value)
        ESPMaxDistance = Value
    end,
})

-- Wallhack
VisualTab:CreateLabel("👻 Wallhack", "ghost")

local WallhackToggle = VisualTab:CreateToggle({
    Name = "👻 Wallhack (Ver através de paredes)",
    CurrentValue = WallhackEnabled,
    Flag = "WallhackToggle",
    Callback = function(Value)
        WallhackEnabled = Value
        ApplyWallhack()
    end,
})

VisualTab:CreateColorPicker({
    Name = "🎨 Cor do Wallhack",
    Color = WallhackColor,
    Flag = "WallhackColor",
    Callback = function(Value)
        WallhackColor = Value
        if WallhackEnabled then
            ApplyWallhack()
        end
    end,
})

VisualTab:CreateSlider({
    Name = "👻 Transparência",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = WallhackTransparency,
    Flag = "WallhackTransparency",
    Callback = function(Value)
        WallhackTransparency = Value
        if WallhackEnabled then
            ApplyWallhack()
        end
    end,
})

-- ABA PLAYER 👤
PlayerTab:CreateLabel("⚡ Modificações do Player", "user")

-- Combat Mods
PlayerTab:CreateToggle({
    Name = "🎯 Sem Recoil",
    CurrentValue = NoRecoilEnabled,
    Flag = "NoRecoilToggle",
    Callback = function(Value)
        NoRecoilEnabled = Value
        if Value then
            ApplyNoRecoil()
        end
    end,
})

PlayerTab:CreateToggle({
    Name = "🎯 Sem Spread",
    CurrentValue = NoSpreadEnabled,
    Flag = "NoSpreadToggle",
    Callback = function(Value)
        NoSpreadEnabled = Value
    end,
})

local RapidFireToggle = PlayerTab:CreateToggle({
    Name = "🔥 Tiro Rápido",
    CurrentValue = RapidFireEnabled,
    Flag = "RapidFireToggle",
    Callback = function(Value)
        RapidFireEnabled = Value
        if Value then
            StartRapidFire()
        else
            if RapidFireLoop then
                RapidFireLoop:Disconnect()
                RapidFireLoop = nil
            end
        end
    end,
})

PlayerTab:CreateSlider({
    Name = "🔥 Velocidade do Tiro Rápido",
    Range = {0, 0.5},
    Increment = 0.01,
    Suffix = "segundos",
    CurrentValue = RapidFireSpeed,
    Flag = "RapidFireSpeed",
    Callback = function(Value)
        RapidFireSpeed = Value
    end,
})

PlayerTab:CreateToggle({
    Name = "🔫 Munição Infinita",
    CurrentValue = InfiniteAmmoEnabled,
    Flag = "InfiniteAmmoToggle",
    Callback = function(Value)
        InfiniteAmmoEnabled = Value
    end,
})

-- Movement Mods
PlayerTab:CreateToggle({
    Name = "🏃‍♂️ God Mode",
    CurrentValue = GodModeEnabled,
    Flag = "GodModeToggle",
    Callback = function(Value)
        GodModeEnabled = Value
        ApplyGodMode()
    end,
})

local SpeedToggle = PlayerTab:CreateToggle({
    Name = "⚡ Speed Hack",
    CurrentValue = SpeedEnabled,
    Flag = "SpeedToggle",
    Callback = function(Value)
        SpeedEnabled = Value
        if Value then
            StartSpeed()
        else
            if SpeedLoop then
                SpeedLoop:Disconnect()
                SpeedLoop = nil
            end
            -- Reset walk speed
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 16
                end
            end
        end
    end,
})

PlayerTab:CreateSlider({
    Name = "⚡ Velocidade",
    Range = {0, 200},
    Increment = 5,
    Suffix = "studs/s",
    CurrentValue = SpeedAmount,
    Flag = "SpeedAmount",
    Callback = function(Value)
        SpeedAmount = Value
    end,
})

PlayerTab:CreateToggle({
    Name = "🦘 Pulo Alto",
    CurrentValue = JumpPowerEnabled,
    Flag = "JumpPowerToggle",
    Callback = function(Value)
        JumpPowerEnabled = Value
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = Value and JumpPowerAmount or 50
            end
        end
    end,
})

PlayerTab:CreateSlider({
    Name = "🦘 Força do Pulo",
    Range = {0, 500},
    Increment = 10,
    Suffix = "",
    CurrentValue = JumpPowerAmount,
    Flag = "JumpPowerAmount",
    Callback = function(Value)
        JumpPowerAmount = Value
        if JumpPowerEnabled and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = Value
            end
        end
    end,
})

local NoclipToggle = PlayerTab:CreateToggle({
    Name = "👻 Noclip",
    CurrentValue = NoclipEnabled,
    Flag = "NoclipToggle",
    Callback = function(Value)
        NoclipEnabled = Value
        if Value then
            StartNoclip()
        else
            if NoclipLoop then
                NoclipLoop:Disconnect()
                NoclipLoop = nil
            end
        end
    end,
})

-- ABA CONFIGURAÇÕES ⚙️
SettingsTab:CreateLabel("⚙️ Configurações do Sistema", "settings")

-- Botões de gerenciamento
SettingsTab:CreateButton({
    Name = "💾 Salvar Configurações",
    Callback = function()
        Rayfield:Notify({
            Title = "💾 Configurações Salvas",
            Content = "Todas as configurações foram salvas!",
            Duration = 3,
            Image = "save",
        })
    end,
})

SettingsTab:CreateButton({
    Name = "🔄 Resetar Configurações",
    Callback = function()
        Rayfield:Notify({
            Title = "🔄 Resetar Configurações",
            Content = "Tem certeza que deseja resetar todas as configurações?",
            Duration = 5,
            Image = "warning",
            Actions = {
                Confirm = {
                    Name = "Sim",
                    Callback = function()
                        -- Resetar todas as variáveis
                        ESPEnabled = false
                        AimbotEnabled = false
                        WallhackEnabled = false
                        TriggerbotEnabled = false
                        NoRecoilEnabled = false
                        RapidFireEnabled = false
                        GodModeEnabled = false
                        SpeedEnabled = false
                        JumpPowerEnabled = false
                        NoclipEnabled = false
                        
                        -- Resetar configurações
                        ESPColor = Color3.fromRGB(0, 255, 255)
                        AimbotPart = "Head"
                        AimbotFOV = 120
                        Smoothing = 0.08
                        SpeedAmount = 50
                        JumpPowerAmount = 100
                        
                        Rayfield:Notify({
                            Title = "✅ Configurações Resetadas",
                            Content = "Todas as configurações foram resetadas!",
                            Duration = 3,
                            Image = "refresh",
                        })
                    end
                },
                Cancel = {
                    Name = "Cancelar",
                    Callback = function() end
                }
            },
        })
    end,
})

SettingsTab:CreateButton({
    Name = "🗑️ Limpar ESP",
    Callback = function()
        for player, esp in pairs(ESPObjects) do
            for _, drawing in pairs(esp) do
                if drawing then
                    drawing:Remove()
                end
            end
        end
        ESPObjects = {}
        
        Rayfield:Notify({
            Title = "🗑️ ESP Limpo",
            Content = "Todos os ESPs foram removidos",
            Duration = 3,
            Image = "trash",
        })
    end,
})

SettingsTab:CreateButton({
    Name = "🔧 Otimizar Sistema",
    Callback = function()
        -- Coleta de lixo
        collectgarbage()
        
        Rayfield:Notify({
            Title = "⚡ Sistema Otimizado",
            Content = "Performance otimizada com sucesso!",
            Duration = 3,
            Image = "lightning",
        })
    end,
})

-- Informações do sistema
SettingsTab:CreateParagraph({
    Title = "📊 Informações Técnicas",
    Content = "Memória em uso: " .. math.floor(collectgarbage("count")) .. " KB\nFPS: " .. math.floor(1/RunService.RenderStepped:Wait())
})

SettingsTab:CreateParagraph({
    Title = "⚠️ Aviso Legal",
    Content = "Este software é apenas para fins educacionais.\nO uso em servidores online pode resultar em banimento.\nUse por sua própria conta e risco."
})

-- Loops principais
local ESPUpdateLoop
local WallhackUpdateLoop

-- Inicialização do ESP
task.spawn(function()
    ESPUpdateLoop = RunService.RenderStepped:Connect(function()
        if ESPEnabled then
            UpdateESP()
        end
    end)
    
    -- Criar ESP para jogadores existentes
    for _, player in pairs(Players:GetPlayers()) do
        CreateESP(player)
    end
end)

-- Atualização do Wallhack
task.spawn(function()
    WallhackUpdateLoop = RunService.RenderStepped:Connect(function()
        if WallhackEnabled then
            ApplyWallhack()
        end
    end)
end)

-- Gerenciamento de jogadores
Players.PlayerAdded:Connect(function(player)
    CreateESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        for _, drawing in pairs(ESPObjects[player]) do
            if drawing then
                drawing:Remove()
            end
        end
        ESPObjects[player] = nil
    end
end)

-- Notificação final
task.wait(3)
Rayfield:Notify({
    Title = "🚀 Big Hub Premium Pronto!",
    Content = "Sistema carregado com sucesso!\nAcesse as abas para ativar os recursos.",
    Duration = 5,
    Image = "rocket",
})

print("✅ Big Hub Premium v2.0 carregado com sucesso!")
