-- Shadow Hub: Gerenciador de Scripts (APENAS MANUAL)
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- ==========================================================
--  COMO ADICIONAR SEUS SCRIPTS:
--  Basta seguir o modelo abaixo dentro da tabela 'MEUS_SCRIPTS'.
--  ["Nome no Botão"] = "Link do Script Raw",
-- ==========================================================
local MEUS_SCRIPTS = {
    ["Don't Steal Famous"] = "https://raw.githubusercontent.com/ghostshadowaa/Shadow/main/Don%27t%20steal%20a%20famous.lua",
  ==========================================================

-- Interface Principal
local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "ShadowManagerManual"

-- --- PAINEL DO GERENCIADOR ---
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 350)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner", MainFrame)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(0, 150, 255)
MainStroke.Thickness = 2

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "SHADOW HUB (Manual)"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18
Title.BackgroundTransparency = 1

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -70)
Scroll.Position = UDim2.new(0, 10, 0, 60)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 8)

-- Função para fechar e executar
local function ExecutarScript(nome, url)
    print("Shadow Hub: A carregar " .. nome)
    ScreenGui:Destroy() -- Fecha o menu ao clicar
    
    local success, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    
    if not success then
        warn("Erro ao carregar o script: " .. tostring(err))
    end
end

-- Criar botões com base na tabela MEUS_SCRIPTS
local count = 0
for nome, link in pairs(MEUS_SCRIPTS) do
    count = count + 1
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, -5, 0, 40)
    btn.Text = nome
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.AutoButtonColor = true
    
    local btnCorner = Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        ExecutarScript(nome, link)
    end)
end

Scroll.CanvasSize = UDim2.new(0, 0, 0, count * 48)

-- Pequena animação de entrada
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame:TweenSize(UDim2.new(0, 260, 0, 350), "Out", "Back", 0.5)
