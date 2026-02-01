-- Shadow Hub: Gerenciador Manual
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- ==========================================================
--  COMO ADICIONAR SEUS SCRIPTS:
--  Adicione abaixo seguindo o padrão: ["Nome"] = "Link Raw"
-- ==========================================================
local MEUS_SCRIPTS = {
    ["Don't Steal Famous"] = "https://raw.githubusercontent.com/ghostshadowaa/Shadow/main/Don%27t%20steal%20a%20famous.lua",
    ["Blox Fruits Hub"]    = "https://raw.githubusercontent.com/exemplo/blox.lua", -- Exemplo
}
-- ==========================================================

local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "ShadowManager"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 350)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(0, 150, 255)
MainStroke.Thickness = 2

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "SHADOW HUB"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18
Title.BackgroundTransparency = 1

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -70)
Scroll.Position = UDim2.new(0, 10, 0, 60)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 3

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 8)

-- Função de Execução
local function Rodar(nome, url)
    ScreenGui:Destroy()
    print("Executando: " .. nome)
    loadstring(game:HttpGet(url))()
end

-- Gerar Botões
local count = 0
for nome, link in pairs(MEUS_SCRIPTS) do
    count = count + 1
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, -5, 0, 40)
    btn.Text = nome
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        Rodar(nome, link)
    end)
end

Scroll.CanvasSize = UDim2.new(0, 0, 0, count * 48)
