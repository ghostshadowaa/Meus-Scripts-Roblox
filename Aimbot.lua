--https://docs.sirius.menu/rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Rayfield Example Window",
   Icon = 0, -- Use 0 for no icon
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
   ShowText = "Rayfield", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default",

   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = true,
   KeySettings = {
      Title = "Example Key",
      Subtitle = "Key System",
      Note = "This is to showcase the Rayfield Key System! Type 1 to continue",
      FileName = "Key",
      SaveKey = false,
      GrabKeyFromSite = false,
      Key = {"1"}
   }
})

local Tab = Window:CreateTab("Tab Example", 4483362458) -- Title, Image

Rayfield:Notify({
   Title = "Notification",
   Content = "Hii",
   Duration = 6.5,
   Image = "home",
})

local Button = Tab:CreateButton({
   Name = "Button Example",
   Callback = function()
      print("button clicked")
   end,
})

local Toggle = Tab:CreateToggle({
   Name = "Toggle Example",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
      print(Value)
   end,
})

local ColorPicker = Tab:CreateColorPicker({
   Name = "Color Picker",
   Color = Color3.fromRGB(255,255,255),
   Flag = "ColorPicker1",
   Callback = function(Value)
      local r = math.floor(Value.R * 255)
      local g = math.floor(Value.G * 255)
      local b = math.floor(Value.B * 255)
      print("RGB:", r, g, b)
   end,
})

local Slider = Tab:CreateSlider({
   Name = "Slider Example",
   Range = {0, 100},
   Increment = 10,
   Suffix = "Bananas",
   CurrentValue = 10,
   Flag = "Slider1",
   Callback = function(Value)
      print("Current Banana:", Value)
   end,
})

local Input = Tab:CreateInput({
   Name = "Input Example",
   CurrentValue = "",
   PlaceholderText = "Input Placeholder",
   RemoveTextAfterFocusLost = false,
   Flag = "Input1",
   Callback = function(Text)
      -- Runs when input changes
      print("Input text:", Text)
   end,
})

local Dropdown = Tab:CreateDropdown({
   Name = "Dropdown Example",
   Options = {"Option 1","Option 2"},
   CurrentOption = {"Option 1"},
   MultipleOptions = false,
   Flag = "Dropdown1",
   Callback = function(Options)
      -- Runs when dropdown selection changes
      print("Selected options:", table.concat(Options, ", "))
   end,
})

local Keybind = Tab:CreateKeybind({
   Name = "Keybind Example",
   CurrentKeybind = "Q",
   HoldToInteract = false,
   Flag = "Keybind1",
   Callback = function(Keybind)
      -- Runs when keybind is pressed or released
      print("Keybind active:", Keybind)
   end,
})

local Label = Tab:CreateLabel("Label Example", "rewind")

local Paragraph = Tab:CreateParagraph({
   Title = "Paragraph Example",
   Content = "Paragraph Example! This auto wraps text, example:Methionylthreonylthreonylglutaminylarginyltyrosylglutamylserylleucylphenylalanylalanylglutaminylleucyllysylglutamylarginyllysylglutamylglycylalanylphenylalanylvalylprolylphenylalanylvalylthreonylleucylglycylaspartylprolylglycylisoleucylglutamylglutaminylserylleucyllysylisoleucylaspartylthreonylleucylisoleucylglutamylalanylglycylalanylaspartylalanylleucylglutamylleucylglycylisoleucylprolylphenylalanylserylaspartylprolylleucylalanylaspartylglycylprolylthreonylisoleucylglutaminylasparaginylalanylthreonylleucylarginylalanylphenylalanylalanylalanylglycylvalylthreonylprolylalanylglutaminylcysteinylphenylalanylglutamylmethionylleucylalanylleucylisoleucylarginylglutaminyllysylhistidylprolylthreonylisoleucylprolylisoleucylglycylleucylleucylmethionyltyrosylalanylasparaginylleucylvalylphenylalanylasparaginyllysylglycylisoleucylaspartylglutamylphenylalanyltyrosylalanylglutaminylcysteinylglutamyllysylvalylglycylvalylaspartylserylvalylleucylvalylalanylaspartylvalylprolylvalylglutaminylglutamylserylalanylprolylphenylalanylarginylglutaminylalanylalanylleucylarginylhistidylasparaginylvalylalanylprolylisoleucylphenylalanylisoleucylcysteinylprolylprolylaspartylalanylaspartylaspartylaspartylleucylleucylarginylglutaminylisoleucylalanylseryltyrosylglycylarginylglycyltyrosylthreonyltyrosylleucylleucylserylarginylalanylglycylvalylthreonylglycylalanylglutamylasparaginylarginylalanylalanylleucylprolylleucylasparaginylhistidylleucylvalylalanyllysylleucyllysylglutamyltyrosylasparaginylalanylalanylprolylprolylleucylglutaminylglycylphenylalanylglycylisoleucylserylalanylprolylaspartylglutaminylvalyllysylalanylalanylisoleucylaspartylalanylglycylalanylalanylglycylalanylisoleucylserylglycylserylalanylisoleucylvalyllysylisoleucylisoleucylglutamylglutaminylhistidylasparaginylisoleucylglutamylprolylglutamyllysylmethionylleucylalanylalanylleucyllysylvalylphenylanylvalylglutaminylprolylmethionyllysylalanylalanylthreonylarginylacetylseryltyrosylserylisoleucylthreonylserylprolylserylglutaminylphenylalanylvalylphenylalanylleucylserylserylvalyltryptophylalanylaspartylprolylisoleucylglutamylleucylleucylasparaginylvalylcysteinylthreonylserylserylleucylglycylasparaginylglutaminylphenylalanylglutaminylthreonylglutaminylglutaminylalanylarginylthreonylthreonylglutaminylvalylglutaminylglutaminylphenylalanylserylglutaminylvalyltryptophyllysylprolylphenylalanylprolylglutaminylserylthreonylvalylarginylphenylalanylprolylglycylaspartylvalyltyrosyllysylvalyltyrosylarginyltyrosylasparaginylalanylvalylleucylaspartylprolylleucylisoleucylthreonylalanylleucylleucylglycylthreonylphenylalanylaspartylthreonylarginylasparaginylarginylisoleucylisoleucylglutamylvalylglutamylasparaginylglutaminylglutaminylserylprolylthreonylthreonylalanylglutamylthreonylleucylaspartylalanylthreonylarginylarginylvalylaspartylaspartylalanylthreonylvalylalanylisoleucylarginylserylalanylasparaginylisoleucylasparaginylleucylvalylasparaginylglutamylleucylvalylarginylglycylthreonylglycylleucyltyrosylasparaginylglutaminylasparaginylthreonylphenylalanylglutamylserylmethionylserylglycylleucylvalyltryptophylthreonylserylalanylprolylalanyltitinmethionylglutaminylarginyltyrosylglutamylserylleucylphenylalanylalanylisoleucylcysteinylprolylprolylaspartylalanylaspartylaspartylaspartylleucylleucylarginylglutaminylisoleucylalanylseryltyrosylglycylarginylglycyltyrosylthreonyltyrosylleucylleucylserylarginylalanylglycylvalylthreonylglycylalanylglutamylasparaginylarginylalanylalanylleucylprolylleucylasparaginylhistidylleucylvalylalanyllysylleucyllysylglutamyltyrosylas"
})

-- Criação da aba para ESP e Aimbot
local CombatTab = Window:CreateTab("Combat", 4483362458) -- Ícone pode ser alterado

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
local AimbotKeybind = Enum.UserInputType.MouseButton2 -- Mouse direito
local AimbotRange = 1000 -- Alcance máximo
local AimbotFOV = 100 -- Campo de visão
local Smoothing = 0.1 -- Suavização do movimento

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
        Distance = Drawing.new("Text")
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
            else
                esp.Box.Visible = false
                esp.Name.Visible = false
                esp.Distance.Visible = false
            end
        end
    end
end

function RemoveESP(player)
    if ESPObjects[player] then
        ESPObjects[player].Box:Remove()
        ESPObjects[player].Name:Remove()
        ESPObjects[player].Distance:Remove()
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
                
                -- Calcular a posição para mirar (um pouco acima da raiz)
                local targetPosition = rootPart.Position + Vector3.new(0, 2, 0)
                
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
    Name = "ESP",
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
            end
        end
    end,
})

local ESPColorPicker = CombatTab:CreateColorPicker({
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

-- Elementos da GUI para Aimbot
local AimbotToggle = CombatTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(Value)
        AimbotEnabled = Value
        
        if Value then
            StartAimbotLoop()
        end
    end,
})

local AimbotRangeSlider = CombatTab:CreateSlider({
    Name = "Aimbot Range",
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

local SmoothingSlider = CombatTab:CreateSlider({
    Name = "Aimbot Smoothing",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = Smoothing,
    Flag = "AimbotSmoothing",
    Callback = function(Value)
        Smoothing = Value
    end,
})

local AimbotKeybindSelector = CombatTab:CreateKeybind({
    Name = "Aimbot Keybind",
    CurrentKeybind = "RightMouse",
    HoldToInteract = false,
    Flag = "AimbotKeybind",
    Callback = function(Keybind)
        if Keybind == "LeftMouse" then
            AimbotKeybind = Enum.UserInputType.MouseButton1
        elseif Keybind == "RightMouse" then
            AimbotKeybind = Enum.UserInputType.MouseButton2
        elseif Keybind == "MiddleMouse" then
            AimbotKeybind = Enum.UserInputType.MouseButton3
        end
    end,
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

-- Botão para limpar ESP
CombatTab:CreateButton({
    Name = "Clear ESP",
    Callback = function()
        for player, _ in pairs(ESPObjects) do
            RemoveESP(player)
        end
        ESPObjects = {}
    end,
})

-- Informações
CombatTab:CreateParagraph({
    Title = "ESP & Aimbot Features",
    Content = "ESP: Shows player boxes, names, and distances\nAimbot: Hold right mouse button to lock onto nearest player\nAdjust settings to your preference"
})
