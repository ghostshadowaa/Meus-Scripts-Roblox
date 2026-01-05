-- [[ CONFIGURAÇÕES E VARIÁVEIS DE CONTROLE ]]
local _g = getgenv and getgenv() or _G
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Prevenção de execução dupla
if _g.ScriptJaCarregado then 
    warn("O script já está em execução!")
    return 
end
_g.ScriptJaCarregado = true

-- Estados das Funções
local Config = {
    ESP = false,
    Aimbot = false
}

-- [[ INTEGRAÇÃO COM RAYFIELD UI ]]
-- Carrega a biblioteca Rayfield
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Destruição da UI Antiga (Garante que a UI padrão não interfira)
local oldUI = game:GetService("CoreGui"):FindFirstChild("PainelMelhorado")
if oldUI then oldUI:Destroy() end

-- Configuração da Janela (Baseado no seu input de Rayfield)
local Window = Rayfield:CreateWindow({
   Name = "Menu de Auxílio Rayfield",
   Icon = 0, 
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "Pronto para Carregar Funções",
   ShowText = "MENU", -- Para usuários de celular (se estiverem usando um executor móvel)
   Theme = "Default", 

   ToggleUIKeybind = "K", -- Keybind para alternar a visibilidade (Teclado)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, 

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "RayfieldAuxilioConfig", 
      FileName = "Main"
   },

   Discord = {
      Enabled = false, 
      Invite = "noinvitelink", 
      RememberJoins = true 
   },

   KeySystem = false, 
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", 
      FileName = "Key", 
      SaveKey = true, 
      GrabKeyFromSite = false, 
      Key = {"Hello"} 
   }
})

-- Cria a Aba "Combate"
local CombatTab = Window:CreateTab("Combate", "rbxassetid://4483362458") -- Icone de espada/luta

-- Cria a Seção "Aimbot"
CombatTab:CreateSection("Aimbot")

-- Toggle para Aimbot
CombatTab:CreateToggle({
    Name = "Ativar Aimbot",
    CurrentValue = Config.Aimbot,
    Flag = "AimbotToggle",
    Callback = function(state)
        Config.Aimbot = state
    end,
})

-- Cria a Seção "Visual"
CombatTab:CreateSection("Visual")

-- Toggle para ESP
CombatTab:CreateToggle({
    Name = "Ativar ESP (Destaque)",
    CurrentValue = Config.ESP,
    Flag = "ESPToggle",
    Callback = function(state)
        Config.ESP = state
        -- Remove highlights imediatamente se desligar
        if not state then
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    local highlight = player.Character:FindFirstChild("ESPHighlight")
                    if highlight then highlight:Destroy() end
                end
            end
        end
    end,
})


-- [[ LÓGICA DAS FUNCIONALIDADES ]]

local function GetClosestPlayer()
    local closest = nil
    local shortestDistance = math.huge
    -- Usando o centro da tela para calcular a distância, tornando-o um "Aim Assist"
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) 

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            if player.Character.Humanoid.Health > 0 then
                local head = player.Character:FindFirstChild("Head") -- Visar a cabeça é melhor
                if head then
                    local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local distance = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                        
                        -- Opcional: Adicionar limite de FOV (Campo de Visão) aqui, por exemplo, distance < 300
                        if distance < shortestDistance then
                            closest = player
                            shortestDistance = distance
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- LOOP ÚNICO DE RENDERIZAÇÃO (Controla Aimbot e ESP)
RunService.RenderStepped:Connect(function()
    
    -- Lógica de Aimbot
    if Config.Aimbot then
        local target = GetClosestPlayer()
        if target and target.Character:FindFirstChild("Head") then
            local targetPos = target.Character.Head.Position
            local lookCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
            
            -- Interpolação suave para um movimento de câmera mais natural
            Camera.CFrame = Camera.CFrame:Lerp(lookCFrame, 0.1) 
        end
    end

    -- Lógica de ESP (Highlight)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = player.Character:FindFirstChild("ESPHighlight")
            
            if Config.ESP then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "ESPHighlight"
                    highlight.Parent = player.Character
                    highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Vermelho
                    highlight.OutlineColor = Color3.new(1, 1, 1) -- Branco
                    highlight.DepthMode = Enum.DepthMode.AlwaysOnTop -- Visto através de paredes
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end)

print("Script carregado com sucesso! Menu Rayfield pronto. Use a tecla configurada (padrão 'K') para abrir/fechar.")
