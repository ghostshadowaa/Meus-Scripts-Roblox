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

-- [[ INTEGRAÇÃO COM RAYFIELD UI (Substituindo a UI Mobile) ]]
-- Carrega a biblioteca Rayfield
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Configuração da Janela (Baseado no seu input de Rayfield)
local Window = Rayfield:CreateWindow({
   Name = "Auxílio de Combate e Visual",
   Icon = 0, 
   LoadingTitle = "Carregando Auxílio",
   LoadingSubtitle = "Pronto para a ação",
   ShowText = "MENU", 
   Theme = "Default", 

   ToggleUIKeybind = "Insert", -- Trocado para Insert, que é o padrão do seu primeiro script.
   -- Use "K" se preferir a configuração original do Rayfield que você forneceu.

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, 

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "AuxilioMobileAdaptado", 
      FileName = "Config"
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
local AimbotSection = CombatTab:CreateSection("Aimbot")

-- Toggle para Aimbot (Usando a lógica de ativação/desativação do seu script original)
CombatTab:CreateToggle({
    Name = "Ativar Aimbot",
    CurrentValue = Config.Aimbot,
    Flag = "AimbotToggle",
    Callback = function(state)
        Config.Aimbot = state
    end,
})

-- Cria a Seção "Visual"
local VisualSection = CombatTab:CreateSection("Visual")

-- Toggle para ESP (Usando a lógica de ativação/desativação do seu script original)
CombatTab:CreateToggle({
    Name = "Ativar ESP (Destaque)",
    CurrentValue = Config.ESP,
    Flag = "ESPToggle",
    Callback = function(state)
        Config.ESP = state
        -- Se o ESP for desativado, remove todos os Highlights existentes imediatamente
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

-- [[ LÓGICA DAS FUNCIONALIDADES (Mantida e Otimizada) ]]

local function GetClosestPlayer()
    local closest = nil
    local shortestDistance = math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) 

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                -- Usa a lógica de distância da tela (ideal para Aimbot)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                    
                    -- Limite de distância mantido em 400 pixels para filtrar alvos fora do campo de visão
                    if distance < shortestDistance and distance < 400 then 
                        closest = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    return closest
end

-- LOOP ÚNICO DE RENDERIZAÇÃO 
RunService.RenderStepped:Connect(function()
    
    -- Lógica de Aimbot
    if Config.Aimbot then
        local target = GetClosestPlayer()
        if target and target.Character:FindFirstChild("Head") then
            local targetPos = target.Character.Head.Position
            local lookCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
            
            -- Interpolação suave mantida (0.15)
            Camera.CFrame = Camera.CFrame:Lerp(lookCFrame, 0.15) 
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
                    highlight.FillColor = Color3.fromRGB(255, 0, 0) 
                    highlight.OutlineColor = Color3.new(1, 1, 1) 
                    highlight.DepthMode = Enum.DepthMode.AlwaysOnTop
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end)

print("Script Rayfield de Combate e Visual carregado com sucesso! Use a tecla configurada ('Insert' ou 'K') para abrir o menu.")
