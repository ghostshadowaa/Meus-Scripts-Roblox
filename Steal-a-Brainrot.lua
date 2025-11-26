-- D A R K   H U B ---------------------------------------------------------

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

---------------------------------------------------------------------------
-- C F R A M E S   D A S   B A S E S
---------------------------------------------------------------------------

local Bases = {
    [1] = CFrame.new(-474.108063, 0.024892807, 220.268066, 0,0,1, 0,1,0, -1,0,0),
    [2] = CFrame.new(-473.938141, -9.72606945, 113.607124, 0,-1,0, 0,0,-1, 1,0,0),
    [3] = CFrame.new(-473.938141, -9.72606945, 6.60712433, 0,-1,0, 0,0,-1, 1,0,0),
    [4] = CFrame.new(-473.938263, -9.66027164, -100.392632, 0,-1,0, 0,0,-1, 1,0,0),
    [5] = CFrame.new(-345.253479, -9.66027069, -100.393364, 0,1,0, 0,0,-1, -1,0,0),
    [6] = CFrame.new(-345.253601, -9.7260685, 6.60688019, 0,1,0, 0,0,-1, -1,0,0),
    [7] = CFrame.new(-346.503601, -9.9760685, 113.606819, 1,0,0, 0,0,-1, 0,1,0),
    [8] = CFrame.new(-345.253876, -9.72620678, 220.606873, 0,1,0, 0,0,-1, -1,0,0),
}

---------------------------------------------------------------------------
-- D E T E C T A R   B A S E   D O   J O G A D O R
---------------------------------------------------------------------------

local function GetPlayerBase()
    if not Character or not HumanoidRootPart then return nil end

    for i, cf in ipairs(Bases) do
        if (HumanoidRootPart.Position - cf.Position).Magnitude < 20 then
            return i
        end
    end
    return nil
end

local PlayerBase = GetPlayerBase()

---------------------------------------------------------------------------
-- I U  -  H U B
---------------------------------------------------------------------------

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.ResetOnSpawn = false

-- Janela principal
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 280, 0, 350)
Frame.Position = UDim2.new(0.1, 0, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(0, 70, 150)
Frame.BorderSizePixel = 0
Frame.Visible = true

-- Título
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "DARK HUB"
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Botão Fechar
local Close = Instance.new("TextButton", Frame)
Close.Size = UDim2.new(0, 40, 0, 40)
Close.Position = UDim2.new(1, -45, 0, 5)
Close.Text = "X"
Close.TextColor3 = Color3.new(1,1,1)
Close.BackgroundColor3 = Color3.fromRGB(20,20,20)

-- Ícone flutuante
local Icon = Instance.new("TextButton", ScreenGui)
Icon.Size = UDim2.new(0, 80, 0, 80)
Icon.Position = UDim2.new(0.03, 0, 0.4, 0)
Icon.Text = "Dark Hub"
Icon.Font = Enum.Font.GothamBold
Icon.TextScaled = true
Icon.BackgroundColor3 = Color3.fromRGB(0, 70, 150)
Icon.Visible = false

Close.MouseButton1Click:Connect(function()
    Frame.Visible = false
    Icon.Visible = true
end)

Icon.MouseButton1Click:Connect(function()
    Frame.Visible = true
    Icon.Visible = false
end)

---------------------------------------------------------------------------
-- V O O   +   N O C L I P   P A R A   I R   À   B A S E
---------------------------------------------------------------------------

local flying = false
local noclip = false

local function GoToBase(cf)
    flying = true
    noclip = true

    task.spawn(function()
        while flying do
            if Character and HumanoidRootPart then
                HumanoidRootPart.CFrame = HumanoidRootPart.CFrame:Lerp(cf, 0.08)
            end
            RunService.RenderStepped:Wait()
        end
    end)

    task.delay(1.6, function()
        flying = false
        noclip = false
    end)
end

RunService.Stepped:Connect(function()
    if noclip and Character then
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

---------------------------------------------------------------------------
-- B O T Õ E S   D A S   B A S E S
---------------------------------------------------------------------------

local List = Instance.new("Frame", Frame)
List.Size = UDim2.new(1, -20, 1, -60)
List.Position = UDim2.new(0, 10, 0, 50)
List.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", List)
UIList.Padding = UDim.new(0, 6)

local function MakeButton(i)
    local btn = Instance.new("TextButton", List)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true

    btn.Text = "Base " .. i

    if PlayerBase == i then
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        btn.BackgroundColor3 = Color3.fromRGB(0, 40, 90)
    end

    btn.TextColor3 = Color3.new(1,1,1)

    btn.MouseButton1Click:Connect(function()
        GoToBase(Bases[i])
    end)
end

for i = 1, 8 do
    MakeButton(i)
end

---------------------------------------------------------------------------

print("Dark Hub carregado!")
