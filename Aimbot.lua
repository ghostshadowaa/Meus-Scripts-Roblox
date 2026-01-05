--[[ 🛠️ KA HUB | ULTIMATE BUNDLE | DELTA FIXED 🛠️ ]]

-- Rayfield UI Library
-- (O link estável de Rayfield é mantido, pois é o padrão para exploits)
local Rayfield = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/shlexware/Rayfield/main/source"
))()

-- ⚙️ Serviços Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local TeleportService = game:GetService("TeleportService") -- Adicionado, pode ser útil

local LocalPlayer = Players.LocalPlayer or Players.LocalPlayer or TeleportService.LocalPlayer or Players.PlayerAdded:Wait()
local Camera = workspace.CurrentCamera

-- ⚙️ Configurações Principais
local Config = {
    -- Aimbot
    Aimbot = false,
    FOV = 150,
    AimSmooth = 0.15,
    -- ESP
    ESP = false,
    -- Clicker
    Clicking = false,
    ClickDelay = 0.05, -- 0.05s = 20 CPS
    -- UI/Visual
    MiraVisivel = true,
}

-- 🎯 ================= MIRA (CROSSHAIR) ================= 🎯
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KA_Crosshair"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Mira = Instance.new("Frame")
Mira.Size = UDim2.new(0, 40, 0, 40)
Mira.BackgroundTransparency = 1
Mira.AnchorPoint = Vector2.new(0.5, 0.5)
Mira.Visible = Config.MiraVisivel
Mira.Parent = ScreenGui

-- Linhas da mira
local function createCrosshairLine(parent, size, position, color)
    local line = Instance.new("Frame", parent)
    line.Size = size
    line.Position = position
    line.BackgroundColor3 = color or Color3.new(1, 0, 0) -- Vermelho
    line.BorderSizePixel = 0
    return line
end

-- Linhas da mira (mantendo a cor vermelha original)
createCrosshairLine(Mira, UDim2.new(0, 2, 1, 0), UDim2.new(0.5, -1, 0, 0)) -- Vertical
createCrosshairLine(Mira, UDim2.new(1, 0, 0, 2), UDim2.new(0, 0, 0.5, -1)) -- Horizontal

-- ⭕ ================= FOV CÍRCULO ================= ⭕
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.new(1, 1, 1) -- Branco
FOVCircle.Transparency = 0.7
FOVCircle.Filled = false
FOVCircle.Visible = false -- Inicia invisível

-- 🖥️ ================= INTERFACE GRÁFICA (UI) ================= 🖥️
local Window = Rayfield:CreateWindow({
    Name = "KA Hub | Premium Edition",
    LoadingTitle = "Injetando Sistema...",
    LoadingSubtitle = "Aimbot + ESP + Clicker",
    ConfigurationSaving = { Enabled = false }
})

-- ============ ABA COMBATE ============
local CombatTab = Window:CreateTab("Combate", "rbxassetid://4483362458") -- Icone (mantido o original)

CombatTab:CreateToggle({
    Name = "Ativar Aimbot",
    Callback = function(v)
        Config.Aimbot = v
        FOVCircle.Visible = v
    end
})

CombatTab:CreateToggle({
    Name = "Ativar ESP (Destaque)",
    Callback = function(v)
        Config.ESP = v
        if not v then
            -- Remove os Highlights existentes quando desativado
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("KA_ESP") then
                    p.Character.KA_ESP:Destroy()
                end
            end
        end
    end
})

CombatTab:CreateSlider({
    Name = "Raio do FOV",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = Config.FOV,
    Callback = function(v) Config.FOV = v end
})

CombatTab:CreateSlider({
    Name = "Suavidade da Mira (Smooth)",
    Range = {0.05, 0.5},
    Increment = 0.05,
    CurrentValue = Config.AimSmooth,
    Callback = function(v) Config.AimSmooth = v end
})

-- ============ ABA AUTO CLICKER ============
local ClickTab = Window:CreateTab("Auto Clicker", "rbxassetid://4483362458")

local CPSLabel = ClickTab:CreateLabel("CPS Atual: 0")
local cCount = 0
local lastUpdate = tick()
local clickThread = nil

ClickTab:CreateToggle({
    Name = "Ativar Auto Clicker",
    Callback = function(v)
        Config.Clicking = v

        if v and not clickThread then
            clickThread = task.spawn(function()
                while Config.Clicking do
                    -- Assume que mouse1press/mouse1release estão disponíveis
                    mouse1press()
                    task.wait(0.01) -- Pequeno delay para simular um clique
                    mouse1release()

                    cCount += 1
                    task.wait(Config.ClickDelay)
                end
                clickThread = nil -- Reseta o thread quando o loop parar
            end)
        end
    end
})

ClickTab:CreateSlider({
    Name = "Delay (Velocidade)",
    Range = {0.01, 0.5},
    Increment = 0.01,
    CurrentValue = Config.ClickDelay,
    Callback = function(v)
        Config.ClickDelay = v
        -- Tenta reiniciar o thread para aplicar o novo delay imediatamente
        if Config.Clicking and clickThread then
            task.cancel(clickThread)
            clickThread = nil
            ClickTab:FindFirstChildOfClass("Toggle"):Set(false) -- Desliga visualmente
            ClickTab:FindFirstChildOfClass("Toggle"):Set(true) -- Liga visualmente (forçando a Callback a rodar)
        end
    end
})

ClickTab:CreateToggle({
    Name = "Mostrar Mira",
    CurrentValue = Config.MiraVisivel,
    Callback = function(v)
        Config.MiraVisivel = v
        Mira.Visible = v
    end
})

-- ⚙️ ================= FUNÇÕES CORE ================= ⚙️

-- Encontra o alvo mais próximo dentro do FOV
local function GetTarget()
    local target, shortestDistance = nil, Config.FOV
    -- Posição do mouse (Centro da tela se for Aimbot de Câmera)
    local mousePos = UserInputService:GetMouseLocation()

    for _, p in pairs(Players:GetPlayers()) do
        -- Verifica se é um inimigo, está vivo e tem cabeça
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character.Parent then
            local pos, visible = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if visible then
                -- Calcula a distância 2D do alvo até a posição do mouse/centro
                local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    target = p
                end
            end
        end
    end
    return target
end

-- 🔄 ================= LOOP PRINCIPAL (RENDERSTEPPED) ================= 🔄
RunService.RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    local inset = GuiService:GetGuiInset()

    -- Atualiza a posição da mira para seguir o mouse
    Mira.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y - inset.Y)

    -- Atualiza a posição e tamanho do círculo FOV
    FOVCircle.Position = mousePos
    FOVCircle.Radius = Config.FOV

    -- Aimbot Suave
    if Config.Aimbot then
        local t = GetTarget()
        if t and t.Character and t.Character:FindFirstChild("Head") then
            -- Calcula o CFrame alvo olhando para a cabeça
            local goal = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position)
            -- Interpola suavemente a CFrame da Câmera
            Camera.CFrame = Camera.CFrame:Lerp(goal, Config.AimSmooth)
        end
    end

    -- ESP (Highlight)
    if Config.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            -- Checa se é um inimigo válido e se o Character existe
            if p ~= LocalPlayer and p.Character and p.Character.Parent then
                if not p.Character:FindFirstChild("KA_ESP") then
                    -- Cria um Highlight para o ESP
                    local h = Instance.new("Highlight")
                    h.Name = "KA_ESP"
                    h.Parent = p.Character
                    h.FillColor = Color3.new(1, 0, 0) -- Vermelho
                    h.OutlineColor = Color3.new(1, 1, 1) -- Branco
                    h.FillTransparency = 0.5
                end
            else
                -- Limpeza: Remove Highlights de jogadores que saíram/não têm Character
                if p.Character and p.Character:FindFirstChild("KA_ESP") then
                    p.Character.KA_ESP:Destroy()
                end
            end
        end
    end

    -- Atualização de CPS
    if tick() - lastUpdate >= 1 then
        CPSLabel:Set("CPS Atual: " .. cCount)
        cCount = 0
        lastUpdate = tick()
    end
end)

-- Notificação de Carregamento
Rayfield:Notify({
    Title = "KA HUB CARREGADO",
    Content = "Tudo corrigido e funcionando no Delta.",
    Duration = 3
})
