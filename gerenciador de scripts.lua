-- Shadow Hub: Versão Profissional
local Player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- ==========================================================
--  TABELA DE SCRIPTS (ADICIONE AQUI)
-- ==========================================================
local MEUS_SCRIPTS = {
    ["Don't Steal Famous"] = "https://raw.githubusercontent.com/ghostshadowaa/Shadow/main/Don%27t%20steal%20a%20famous.lua",
    
}
-- ==========================================================

-- Criar GUI (Protegida para evitar detecção simples)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ShadowHubPro"
ScreenGui.Parent = Player.PlayerGui -- Use CoreGui se o seu executor suportar

-- --- TELA DE CARREGAMENTO (SPLASH) ---
local SplashFrame = Instance.new("Frame", ScreenGui)
SplashFrame.Size = UDim2.new(1, 0, 1, 0)
SplashFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
SplashFrame.ZIndex = 100

local Logo = Instance.new("TextLabel", SplashFrame)
Logo.Size = UDim2.new(0, 200, 0, 50)
Logo.Position = UDim2.new(0.5, -100, 0.45, -25)
Logo.Text = "SHADOW HUB"
Logo.Font = Enum.Font.GothamBold
Logo.TextColor3 = Color3.fromRGB(0, 170, 255)
Logo.TextSize = 30
Logo.BackgroundTransparency = 1

local BarBG = Instance.new("Frame", SplashFrame)
BarBG.Size = UDim2.new(0, 250, 0, 4)
BarBG.Position = UDim2.new(0.5, -125, 0.55, 0)
BarBG.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
BarBG.BorderSizePixel = 0

local BarFill = Instance.new("Frame", BarBG)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
BarFill.BorderSizePixel = 0

local Status = Instance.new("TextLabel", SplashFrame)
Status.Size = UDim2.new(0, 200, 0, 20)
Status.Position = UDim2.new(0.5, -100, 0.58, 0)
Status.Text = "Verificando arquivos..."
Status.Font = Enum.Font.Gotham
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.TextSize = 12
Status.BackgroundTransparency = 1

-- --- PAINEL PRINCIPAL ---
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 380)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 170, 255)
Stroke.Thickness = 1.5

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "SHADOW HUB v2"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -70)
Scroll.Position = UDim2.new(0, 10, 0, 55)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 8)

-- Função de Execução Profissional
local function Executar(nome, url)
    local s, conteudo = pcall(function() return game:HttpGet(url) end)
    if s and conteudo ~= "" then
        local func, err = loadstring(conteudo)
        if func then
            -- Efeito de fechar suave
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}):Play()
            task.wait(0.3)
            ScreenGui:Destroy()
            func()
        else
            warn("Erro de sintaxe no script.")
        end
    else
        warn("Erro ao baixar o script.")
    end
end

-- Criar Botões Estilizados
local count = 0
for nome, link in pairs(MEUS_SCRIPTS) do
    count = count + 1
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, -5, 0, 42)
    btn.Text = "  " .. nome
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = true
    Instance.new("UICorner", btn)
    
    local bStroke = Instance.new("UIStroke", btn)
    bStroke.Color = Color3.fromRGB(40, 40, 40)
    
    -- Efeito de Hover (Passar o mouse)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35), TextColor3 = Color3.new(1,1,1)}):Play()
        TweenService:Create(bStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 170, 255)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        TweenService:Create(bStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40, 40, 40)}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        Executar(nome, link)
    end)
end
Scroll.CanvasSize = UDim2.new(0, 0, 0, count * 50)

-- Lógica da Tela de Carregamento
task.spawn(function()
    task.wait(0.5)
    TweenService:Create(BarFill, TweenInfo.new(1.5, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    task.wait(0.5)
    Status.Text = "Carregando Scripts..."
    task.wait(1.2)
    
    -- Fade Out Splash
    TweenService:Create(SplashFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Logo, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(Status, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(BarBG, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(BarFill, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    
    task.wait(0.5)
    SplashFrame.Visible = false
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 280, 0, 380)}):Play()
end)
