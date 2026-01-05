-- [[ KA HUB | ULTIMATE BUNDLE (FIXED) ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    Aimbot = false,
    FOV = 150,
    ESP = false,
    Clicking = false,
    ClickDelay = 0.05,
    MiraVisivel = true
}

-- [[ MIRA ]]
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

-- [[ FOV ]]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.new(1, 1, 1)
FOVCircle.Transparency = 0.7
FOVCircle.Filled = false

-- [[ UI ]]
local Window = Rayfield:CreateWindow({
    Name = "KA Hub | Premium Edition",
    LoadingTitle = "Injetando Sistema...",
    LoadingSubtitle = "Aimbot + ESP + Clicker",
    ConfigurationSaving = { Enabled = false }
})

-- COMBATE
local CombatTab = Window:CreateTab("Combate", 4483362458)

CombatTab:CreateToggle({
    Name = "Ativar Aimbot",
    Callback = function(v) Config.Aimbot = v end
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

-- AUTO CLICKER
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
                    local pos = UserInputService:GetMouseLocation()
                    VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 0)
                    VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0)
                    cCount += 1
                    task.wait(Config.ClickDelay)
                end
            end)
        end

        if not v then
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
    Callback = function(v) Mira.Visible = v end
})

-- [[ CORE ]]
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

    Mira.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y)
    FOVCircle.Position = mousePos
    FOVCircle.Radius = Config.FOV
    FOVCircle.Visible = Config.Aimbot

    if Config.Aimbot then
        local t = GetTarget()
        if t then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position)
        end
    end

    if Config.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChild("KA_ESP") or Instance.new("Highlight")
                h.Name = "KA_ESP"
                h.Parent = p.Character
                h.FillColor = Color3.new(1, 0, 0)
                h.OutlineColor = Color3.new(1, 1, 1)
                h.FillTransparency = 0.5
            end
        end
    end

    if tick() - lastUpdate >= 1 then
        CPSLabel:Set("CPS Atual: " .. cCount)
        cCount = 0
        lastUpdate = tick()
    end
end)

Rayfield:Notify({
    Title = "KA HUB CARREGADO",
    Content = "Tudo funcionando corretamente.",
    Duration = 3
})
