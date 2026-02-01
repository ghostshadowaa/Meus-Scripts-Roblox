-- Shadow Manager: Versão Estabilizada & Limpa
local HttpService = game:GetService("HttpService")
local Player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")

-- CONFIGURAÇÃO DO GITHUB
local OWNER = "ghostshadowaa"
local REPO = "Shadow"
local BRANCH = "main"

-- Criar a Interface Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ShadowSystem"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.DisplayOrder = 999
ScreenGui.ResetOnSpawn = false

-- --- TELA DE CARREGAMENTO (FIXED) ---
local Splash = Instance.new("Frame", ScreenGui)
Splash.Size = UDim2.new(1, 0, 1, 100)
Splash.Position = UDim2.new(0, 0, 0, -50)
Splash.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Splash.ZIndex = 100
Splash.BorderSizePixel = 0

local SplashText = Instance.new("TextLabel", Splash)
SplashText.Size = UDim2.new(1, 0, 1, 0)
SplashText.Text = "SHADOW HUB\nSINCRONIZANDO REPOSITÓRIO..."
SplashText.Font = Enum.Font.GothamBold
SplashText.TextColor3 = Color3.fromRGB(0, 170, 255)
SplashText.TextSize = 25
SplashText.BackgroundTransparency = 1
SplashText.ZIndex = 101

-- --- PAINEL DO MENU ---
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 350)
Main.Position = UDim2.new(0.5, -130, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Visible = false 
Instance.new("UICorner", Main)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 170, 255)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "SHADOW MANAGER"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = 16
Title.BackgroundTransparency = 1

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -60)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 5)

-- --- FUNÇÃO DE EXECUÇÃO ---
local function Executar(url)
    -- Efeito de fechar antes de rodar
    TweenService:Create(Main, TweenInfo.new(0.3), {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}):Play()
    task.wait(0.3)
    ScreenGui:Destroy()
    
    local s, conteudo = pcall(function() 
        return game:HttpGet(url .. "?t=" .. os.time()) 
    end)
    
    if s and conteudo then
        local func = loadstring(conteudo)
        if func then func() end
    end
end

-- --- CARREGAR DADOS DA API ---
local function SincronizarAPI()
    local url = "https://api.github.com/repos/"..OWNER.."/"..REPO.."/contents?t="..os.time()
    local s, r = pcall(function() return game:HttpGet(url) end)
    
    if s then
        local dados = HttpService:JSONDecode(r)
        local total = 0
        for _, arquivo in pairs(dados) do
            if arquivo.name:match("%.lua$") then
                total = total + 1
                local btn = Instance.new("TextButton", Scroll)
                btn.Size = UDim2.new(1, -5, 0, 40)
                btn.Text = "📁 " .. arquivo.name:gsub(".lua", "")
                btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                btn.Font = Enum.Font.GothamSemibold
                btn.TextSize = 13
                Instance.new("UICorner", btn)
                
                local bStroke = Instance.new("UIStroke", btn)
                bStroke.Color = Color3.fromRGB(40, 40, 40)

                btn.MouseButton1Click:Connect(function()
                    local rawUrl = "https://raw.githubusercontent.com/"..OWNER.."/"..REPO.."/"..BRANCH.."/"..arquivo.name
                    Executar(rawUrl)
                end)
            end
        end
        Scroll.CanvasSize = UDim2.new(0, 0, 0, total * 45)
        return true
    end
    return false
end

-- --- SEQUÊNCIA DE INICIALIZAÇÃO ---
task.spawn(function()
    -- Garante que a Splash apareça
    Splash.Visible = true
    task.wait(1)
    
    local carregou = SincronizarAPI()
    
    if not carregou then
        SplashText.Text = "ERRO AO CONECTAR AO GITHUB"
        SplashText.TextColor3 = Color3.new(1, 0, 0)
        task.wait(3)
        ScreenGui:Destroy()
        return
    end
    
    SplashText.Text = "SINCRONIZADO!"
    task.wait(0.5)
    
    -- Transição suave
    TweenService:Create(Splash, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(SplashText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    task.wait(0.5)
    
    Splash.Visible = false
    Main.Visible = true
end)
