-- [[ KA HUB | ULTIMATE BUNDLE | DELTA FIXED ]]

-- Rayfield (link estável)
local Rayfield = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/shlexware/Rayfield/main/source"
))()

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Config
local Config = {
    Aimbot = false,
    FOV = 150,
    ESP = false,
    Clicking = false,
    ClickDelay = 0.05,
    MiraVisivel = true,
    AimSmooth = 0.15
}

-- ================= MIRA =================
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

local l1 = Instance.new("Frame", Mira)
l1.Size = UDim2.new(0, 2, 1, 0)
l1.Position = UDim2.new(0.5, -1, 0, 0)
l1.BackgroundColor3 = Color3.new(1, 0, 0)
l1.BorderSizePixel = 0

local l2 = Instance.new("Frame", Mira)
l2.Size = UDim2.new(1, 0, 0, 2)
l2.Position = UDim2.new(0, 0, 0.5, -1)
l2.BackgroundColor3 = Color3.new(1, 0, 0)
l2.BorderSizePixel = 0

-- ================= FOV =================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.new(1, 1, 1)
FOVCircle.Transparency = 0.7
FOVCircle.Filled = false
FOVCircle.Visible = false

-- ================= UI =================
local Window = Rayfield:CreateWindow({
    Name = "KA Hub | Premium Edition",
    LoadingTitle = "Injetando Sistema...",
    LoadingSubtitle = "Aimbot + ESP + Clicker",
    ConfigurationSaving = { Enabled = false }
})

-- ============ COMBATE ============
local CombatTab = Window:CreateTab("Combate", 4483362458)

CombatTab:CreateToggle({
    Name = "Ativar Aimbot",
    Callback = function(v)
        Config.Aimbot = v
        FOVCircle.Visible = v
    end
})

CombatTab:CreateToggle({
    Name = "Ativar ESP",
    Callback = function(v)
        Config.ESP = v
        if not v then
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
    CurrentValue = 150,
    Callback = function(v) Config.FOV = v end
})

-- ============ AUTO CLICKER ============
local ClickTab = Window:CreateTab("Auto Clicker", 4483362458)

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
                    mouse1press()
                    task.wait(0.01)
                    mouse1release()

                    cCount += 1
                    task.wait(Config.ClickDelay)
                end
            end)
        end

        if not v then
            Config.Clicking = false
            clickThread = nil
        end
    end
})

ClickTab:CreateSlider({
    Name = "Delay (Velocidade)",
    Range = {0.01, 0.5},
    Increment = 0.01,
    CurrentValue = 0.05,
    Callback = function(v) Config.ClickDelay = v end
})

ClickTab:CreateToggle({
    Name = "Mostrar Mira",
    CurrentValue = true,
    Callback = function(v)
        Config.MiraVisivel = v
        Mira.Visible = v
    end
})

-- ================= CORE =================
local function GetTarget()
    local target, shortest = nil, Config.FOV
    local mousePos = UserInputService:GetMouseLocation()

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos, visible = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if visible then
                local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if dist < shortest then
                    shortest = dist
                    target = p
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    local inset = GuiService:GetGuiInset()

    Mira.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y - inset.Y)

    FOVCircle.Position = mousePos
    FOVCircle.Radius = Config.FOV

    -- Aimbot suave
    if Config.Aimbot then
        local t = GetTarget()
        if t and t.Character and t.Character:FindFirstChild("Head") then
            local goal = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position)
            Camera.CFrame = Camera.CFrame:Lerp(goal, Config.AimSmooth)
        end
    end

    -- ESP (sem lag)
    if Config.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if not p.Character:FindFirstChild("KA_ESP") then
                    local h = Instance.new("Highlight")
                    h.Name = "KA_ESP"
                    h.Parent = p.Character
                    h.FillColor = Color3.new(1, 0, 0)
                    h.OutlineColor = Color3.new(1, 1, 1)
                    h.FillTransparency = 0.5
                end
            end
        end
    end

    -- CPS
    if tick() - lastUpdate >= 1 then
        CPSLabel:Set("CPS Atual: " .. cCount)
        cCount = 0
        lastUpdate = tick()
    end
end)

Rayfield:Notify({
    Title = "KA HUB CARREGADO",
    Content = "Tudo corrigido e funcionando no Delta.",
    Duration = 3
})
