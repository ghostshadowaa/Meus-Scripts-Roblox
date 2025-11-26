--========================================================--
--====================== DARK HUB =========================--
--======================= TEMA AZUL =======================--
--========================================================--

--== CONFIG ==--
local targetCFrame = CFrame.new(
    -345.083679, 0.0248937607, 113.94593,
    0, 0, -1,
    0, 1, 0,
    1, 0, 0
)

-- Services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")

--========================================================--
--==================== CRIA GUI PRINCIPAL =================--
--========================================================--

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DarkHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 180)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 80)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 120)
Title.BorderSizePixel = 0
Title.Text = "Dark Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Parent = MainFrame

local UICorner2 = Instance.new("UICorner", Title)

-- ---------------- BUTTON: MOVER ATÉ O CFRAME ----------------

local MoveButton = Instance.new("TextButton")
MoveButton.Size = UDim2.new(1, -20, 0, 40)
MoveButton.Position = UDim2.new(0, 10, 0, 60)
MoveButton.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
MoveButton.Text = "Ir até o local"
MoveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MoveButton.TextScaled = true
MoveButton.Parent = MainFrame

local UICorner3 = Instance.new("UICorner", MoveButton)

-- ---------------- BUTTON: FECHAR HUB ----------------
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -45, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(0, 0, 120)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Parent = MainFrame
local UICornerClose = Instance.new("UICorner", CloseButton)

--========================================================--
--============== BOTÃO FLOTANTE (REABRIR HUB) ============--
--========================================================--

local FloatingButton = Instance.new("Frame")
FloatingButton.Size = UDim2.new(0, 60, 0, 60)
FloatingButton.Position = UDim2.new(0.05, 0, 0.5, -30)
FloatingButton.BackgroundColor3 = Color3.fromRGB(20, 20, 80)
FloatingButton.Visible = false
FloatingButton.Parent = ScreenGui
FloatingButton.Active = true
FloatingButton.Draggable = true

local UICornerFloat = Instance.new("UICorner", FloatingButton)
UICornerFloat.CornerRadius = UDim.new(1, 0)

local LabelFloat = Instance.new("TextButton")
LabelFloat.Size = UDim2.new(1, 0, 1, 0)
LabelFloat.BackgroundTransparency = 1
LabelFloat.Text = "Dark"
LabelFloat.TextScaled = true
LabelFloat.TextColor3 = Color3.fromRGB(255, 255, 255)
LabelFloat.Parent = FloatingButton


--========================================================--
--=================== FUNÇÕES DO FLY ======================--
--========================================================--

local flying = false
local noclip = false
local speed = 40

local function startFly()
    flying = true
    noclip = true

    task.spawn(function()
        while flying do
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                hrp.Velocity = Vector3.new(0, 0, 0)

                local moveDirection = Vector3.zero

                if Mouse.KeyDown:Wait() == "w" then moveDirection = moveDirection + Mouse.Hit.lookVector end
                if Mouse.KeyDown:Wait() == "s" then moveDirection = moveDirection - Mouse.Hit.lookVector end

                hrp.CFrame = hrp.CFrame + moveDirection * (speed * RunService.Heartbeat:Wait())
            end
        end
    end)
end

local function stopFly()
    flying = false
    noclip = false
end

--========================================================--
--============== MOVER ATÉ O CFRAME SUAVEMENTE ============--
--========================================================--

local function moveToPoint(cf)
    startFly()

    local character = Player.Character or Player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    local done = false

    local connection
    connection = RunService.Heartbeat:Connect(function()
        if (hrp.Position - cf.Position).Magnitude < 3 then
            connection:Disconnect()
            done = true
            stopFly()
        else
            hrp.CFrame = hrp.CFrame:Lerp(cf, 0.07)
        end
    end)
end

--========================================================--
--===================== EVENTOS ============================--
--========================================================--

MoveButton.MouseButton1Click:Connect(function()
    moveToPoint(targetCFrame)
end)

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatingButton.Visible = true
end)

LabelFloat.MouseButton1Click:Connect(function()
    FloatingButton.Visible = false
    MainFrame.Visible = true
end)
