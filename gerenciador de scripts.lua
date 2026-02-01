-- Shadow Hub v2 (Fix: Loadstring & UI)
local Player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local MEUS_SCRIPTS = {
    ["Don't Steal Famous"] = "https://raw.githubusercontent.com/ghostshadowaa/Shadow/main/Don%27t%20steal%20a%20famous.lua",
}

local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "ShadowSystem"
ScreenGui.ResetOnSpawn = false

-- --- BOTÃO FLUTUANTE (ABRIR/FECHAR) ---
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
OpenBtn.Text = "S"
OpenBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 25
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local BtnStroke = Instance.new("UIStroke", OpenBtn)
BtnStroke.Color = Color3.fromRGB(0, 170, 255)
BtnStroke.Thickness = 2

-- --- TELA DE CARREGAMENTO ---
local Splash = Instance.new("Frame", ScreenGui)
Splash.Size = UDim2.new(1, 0, 1, 0)
Splash.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Splash.ZIndex = 10

local SplashText = Instance.new("TextLabel", Splash)
SplashText.Size = UDim2.new(1, 0, 1, 0)
SplashText.Text = "SHADOW HUB"
SplashText.Font = Enum.Font.GothamBold
SplashText.TextColor3 = Color3.fromRGB(0, 170, 255)
SplashText.TextSize = 35
SplashText.BackgroundTransparency = 1

-- --- PAINEL PRINCIPAL ---
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 350)
Main.Position = UDim2.new(0.5, -130, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Visible = false
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 170, 255)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -60)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 7)

-- --- FUNÇÃO DE EXECUÇÃO (ULTRA FIX) ---
local function Executar(url)
    local s, conteudo = pcall(function() 
        -- Adicionamos um número aleatório ao final para evitar Cache do GitHub
        return game:HttpGet(url .. "?nocache=" .. tostring(math.random(1,100000))) 
    end)
    
    if s and conteudo then
        local carregar, erro = loadstring(conteudo)
        if carregar then
            Main.Visible = false
            carregar()
        else
            warn("Erro no script: " .. tostring(erro))
        end
    else
        warn("Erro ao baixar script.")
    end
end

-- Criar Botões
for nome, link in pairs(MEUS_SCRIPTS) do
    local b = Instance.new("TextButton", Scroll)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.Text = nome
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", b)
    
    b.MouseButton1Click:Connect(function()
        Executar(link)
    end)
end

-- Alternar Menu
OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Animação Inicial
task.spawn(function()
    task.wait(1)
    TweenService:Create(SplashText, TweenInfo.new(1), {TextTransparency = 1}):Play()
    TweenService:Create(Splash, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
    task.wait(1)
    Splash.Visible = false
end)
