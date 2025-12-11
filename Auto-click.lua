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
    "123456", "PROJECTX", "FREEAIMBOT", "BIGHUB2024", "TEST123", "AUTOCLICK"
}

-- Criar janela com configurações CORRETAS
local Window = Rayfield:CreateWindow({
   Name = "Big Hub Premium v3.0",
   Icon = 4483362458,
   LoadingTitle = "Big Hub Premium",
   LoadingSubtitle = "ESP + Aimbot + Auto Click System",
   Theme = "Dark",
   
   ToggleUIKeybind = "RightControl",

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BigHubConfig",
      FileName = "BigHubSettings"
   },

   Discord = {
      Enabled = false
   },

   KeySystem = true,
   KeySettings = {
      Title = "Sistema de Chave Premium",
      Subtitle = "Digite sua chave de acesso",
      Note = "Chaves válidas: 123456, PROJECTX, AUTOCLICK",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = validKeys
   }
})

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
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

-- Variáveis do Auto Click
local AutoClickEnabled = false
local AutoClickSpeed = 10 -- Clicks por segundo
local AutoClickDelay = 0.1 -- Delay entre cliques
local AutoClickConnection = nil
local AutoClickMode = "Center" -- "Center" ou "Mouse"
local ClickHotkey = "F" -- Tecla para ativar/desativar rapidamente

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

-- Sistema de Auto Click
function StartAutoClick()
    if AutoClickConnection then
        AutoClickConnection:Disconnect()
        AutoClickConnection = nil
    end
    
    AutoClickConnection = RunService.RenderStepped:Connect(function()
        if AutoClickEnabled then
            local x, y
            
            if AutoClickMode == "Center" then
                -- Clique no centro da tela
                local viewportSize = Camera.ViewportSize
                x = viewportSize.X / 2
                y = viewportSize.Y / 2
            else
                -- Clique na posição atual do mouse
                local mousePos = UserInputService:GetMouseLocation()
                x = mousePos.X
                y = mousePos.Y
            end
            
            -- Simular clique do mouse
            VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
            
            -- Delay entre cliques
            if AutoClickDelay > 0 then
                task.wait(AutoClickDelay)
            end
        end
    end)
end

function StopAutoClick()
    if AutoClickConnection then
        AutoClickConnection:Disconnect()
        AutoClickConnection = nil
    end
end

-- Criar abas
local MainTab = Window:CreateTab("🏠 Principal", 4483362458)
local CombatTab = Window:CreateTab("⚔️ Combat", 4483362458)
local AutoTab = Window:CreateTab("🖱️ Auto Click", 4483362458)
local VisualTab = Window:CreateTab("👁️ Visual", 4483362458)

-- Notificação de início
Rayfield:Notify({
   Title = "🚀 Big Hub Premium Carregado",
   Content = "Sistema ESP + Aimbot + Auto Click pronto!",
   Duration = 5,
   Image = 4483362458,
})

-- Aba Principal
MainTab:CreateLabel("🌟 Sistema Premium", "star")

MainTab:CreateParagraph({
   Title = "📋 Informações do Sistema",
   Content = "Big Hub Premium v3.0\nInclui:\n✅ ESP Player\n✅ Aimbot Suave\n✅ Auto Click\n✅ Interface Moderna"
})

MainTab:CreateButton({
   Name = "🔧 Status do Sistema",
   Callback = function()
       local status = "✅ Sistema Funcionando\n"
       status = status .. "ESP: " .. (ESPEnabled and "✅" or "❌") .. "\n"
       status = status .. "Aimbot: " .. (AimbotEnabled and "✅" or "❌") .. "\n"
       status = status .. "Auto Click: " .. (AutoClickEnabled and "✅" or "❌")
       
       Rayfield:Notify({
           Title = "📊 Status do Sistema",
           Content = status,
           Duration = 6,
           Image = 4483362458,
       })
   end,
})

-- Aba Combat
CombatTab:CreateToggle({
   Name = "🎯 Ativar Aimbot",
   CurrentValue = false,
   Flag = "AimbotToggle",
   Callback = function(Value)
       AimbotEnabled = Value
       if Value then
           Rayfield:Notify({
               Title = "🎯 Aimbot Ativado",
               Content = "Segure botão direito para usar",
               Duration = 3,
               Image = 4483362458,
           })
       end
   end,
})

CombatTab:CreateSlider({
   Name = "🎯 Campo de Visão (FOV)",
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
   Name = "🎯 Suavização",
   Range = {0.01, 0.5},
   Increment = 0.01,
   Suffix = "",
   CurrentValue = 0.1,
   Flag = "AimbotSmooth",
   Callback = function(Value)
       Smoothing = Value
   end,
})

-- Aba Auto Click
AutoTab:CreateLabel("🖱️ Sistema de Auto Click", "mouse")

-- Botão principal de Auto Click
local AutoClickButton = AutoTab:CreateToggle({
   Name = "🟢 Auto Click: DESLIGADO",
   CurrentValue = false,
   Flag = "AutoClickMain",
   Callback = function(Value)
       AutoClickEnabled = Value
       
       if Value then
           StartAutoClick()
           AutoClickButton:Set("🔴 Auto Click: LIGADO")
           Rayfield:Notify({
               Title = "✅ Auto Click Ativado",
               Content = "Clique automático ativado!\nPressione " .. ClickHotkey .. " para desligar rapidamente",
               Duration = 5,
               Image = 4483362458,
           })
       else
           StopAutoClick()
           AutoClickButton:Set("🟢 Auto Click: DESLIGADO")
           Rayfield:Notify({
               Title = "❌ Auto Click Desativado",
               Content = "Clique automático desativado!",
               Duration = 3,
               Image = 4483362458,
           })
       end
   end,
})

AutoTab:CreateSlider({
   Name = "⚡ Velocidade de Clique",
   Range = {1, 100},
   Increment = 1,
   Suffix = "clicks/segundo",
   CurrentValue = 10,
   Flag = "AutoClickSpeed",
   Callback = function(Value)
       AutoClickSpeed = Value
       AutoClickDelay = 1 / Value
   end,
})

AutoTab:CreateDropdown({
   Name = "🎯 Modo de Clique",
   Options = {"Centro da Tela", "Posição do Mouse"},
   CurrentOption = {"Centro da Tela"},
   MultipleOptions = false,
   Flag = "AutoClickMode",
   Callback = function(Option)
       if Option[1] == "Centro da Tela" then
           AutoClickMode = "Center"
       else
           AutoClickMode = "Mouse"
       end
   end,
})

AutoTab:CreateKeybind({
   Name = "🔗 Tecla Rápida",
   CurrentKeybind = "F",
   HoldToInteract = false,
   Flag = "AutoClickHotkey",
   Callback = function(Keybind)
       ClickHotkey = Keybind
   end,
})

AutoTab:CreateButton({
   Name = "🔄 Testar Auto Click",
   Callback = function()
       local viewportSize = Camera.ViewportSize
       local x = viewportSize.X / 2
       local y = viewportSize.Y / 2
       
       -- Simular um único clique de teste
       VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
       task.wait(0.05)
       VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
       
       Rayfield:Notify({
           Title = "🖱️ Teste Concluído",
           Content = "Clique de teste executado no centro da tela!",
           Duration = 3,
           Image = 4483362458,
       })
   end,
})

AutoTab:CreateParagraph({
   Title = "📝 Instruções",
   Content = "Modo Centro: Clique no meio da tela\nModo Mouse: Clique na posição atual do cursor\nUse a tecla rápida para ligar/desligar durante o jogo"
})

-- Aba Visual
VisualTab:CreateToggle({
   Name = "👁️ Ativar ESP",
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
               Title = "✅ ESP Ativado",
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
   Name = "🎨 Cor do ESP",
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

-- Tecla rápida para Auto Click
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode[ClickHotkey] then
            AutoClickEnabled = not AutoClickEnabled
            
            if AutoClickEnabled then
                StartAutoClick()
                AutoClickButton:Set("🔴 Auto Click: LIGADO")
                Rayfield:Notify({
                    Title = "⚡ Auto Click Ativado",
                    Content = "Pressione " .. ClickHotkey .. " novamente para desligar",
                    Duration = 3,
                    Image = 4483362458,
                })
            else
                StopAutoClick()
                AutoClickButton:Set("🟢 Auto Click: DESLIGADO")
            end
        end
        
        -- Tecla P para limpar tudo
        if input.KeyCode == Enum.KeyCode.P then
            -- Limpar ESP
            for _, esp in pairs(ESPObjects) do
                esp.Box:Remove()
                esp.Name:Remove()
            end
            ESPObjects = {}
            
            -- Desconectar loops
            ESPLoop:Disconnect()
            AimbotLoop:Disconnect()
            StopAutoClick()
            
            -- Destruir Rayfield
            Rayfield:Destroy()
            
            warn("🔧 Sistema Big Hub desligado!")
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

print("✅ Big Hub Premium v3.0 carregado com sucesso!")
print("📌 Teclas rápidas:")
print("   RightControl = Abrir/Fechar Menu")
print("   " .. ClickHotkey .. " = Ligar/Desligar Auto Click")
print("   P = Desligar tudo")
