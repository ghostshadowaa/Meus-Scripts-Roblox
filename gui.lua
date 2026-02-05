-- 1. CRIAR OS ELEMENTOS (A estrutura)
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- O Container principal
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "Shadow Hub"
ScreenGui.ResetOnSpawn = false -- Para a GUI não sumir quando você morrer

-- O Menu que vai abrir e fechar
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 500)
MainFrame.Position = UDim2.new(0.5, -125, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true -- Começa aberto

-- Arredondar os cantos (UI Corner)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Botão de Fechar (X)
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CloseBtn)

-- Botão de Abrir (Fica na tela quando o menu fecha)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Name = "OpenBtn"
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -25)
OpenBtn.Text = "ABRIR"
OpenBtn.Visible = false -- Começa escondido
OpenBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
Instance.new("UICorner", OpenBtn)

-- 2. A LÓGICA DE ABRIR E FECHAR (O "Cérebro")

-- Função para Fechar
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false  -- Esconde o menu
    OpenBtn.Visible = true     -- Mostra o botão de abrir
end)

-- Função para Abrir
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true   -- Mostra o menu
    OpenBtn.Visible = false    -- Esconde o botão de abrir
end)

-- 3. TORNAR O MENU ARRASTÁVEL (Draggable)
-- Essencial para celular para o menu não ficar em cima dos botões do jogo
MainFrame.Active = true
MainFrame.Draggable = true 
