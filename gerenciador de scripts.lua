-- Shadow Manager: Versão Estabilizada
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

-- --- TELA DE CARREGAMENTO (FORÇADA) ---
local Splash = Instance.new("Frame", ScreenGui)
Splash.Size = UDim2.new(1, 0, 1, 0)
Splash.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Splash.ZIndex = 100
Splash.BorderSizePixel = 0

local SplashText = Instance.new("TextLabel", Splash)
SplashText.Size = UDim2.new(1, 0, 1, 0)
SplashText.Text = "SHADOW HUB\nSINCRONIZANDO..."
SplashText.Font = Enum.Font.GothamBold
SplashText.TextColor3 = Color3.fromRGB(0, 170, 255)
SplashText.TextSize = 25
SplashText.BackgroundTransparency = 1

-- --- PAINEL DO MENU ---
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 350)
Main.Position = UDim2.new(0.5, -130, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Visible = false -- Fica invisível durante o loading
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 170, 255)
Stroke.Thickness = 2

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -60)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 5)

-- --- FUNÇÃO DE EXECUÇÃO E FECHAMENTO ---
local function Executar(url)
    -- Fecha o menu IMEDIATAMENTE
    ScreenGui:Destroy()
    
    -- Tenta baixar e rodar o script
    local s, conteudo = pcall(function() 
        return game:HttpGet(url .. "?t=" .. os.time()) 
    end)
    
    if s and conteudo then
        local func = loadstring(conteudo)
        if func then
            func()
        end
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
                btn.Size = UDim2.new(1, 0, 0, 40)
                btn.Text = arquivo.name:gsub(".lua", "")
                btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                btn.TextColor3 = Color3.new(1, 1, 1)
                btn.Font = Enum.Font.GothamSemibold
                Instance.new("UICorner", btn)

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
    -- 1. Mostra a Splash
    Splash.Visible = true
    task.wait(0.5)
    
    -- 2. Tenta carregar os dados
    local carregou = SincronizarAPI()
    
    if not carregou then
        SplashText.Text = "ERRO NA CONEXÃO!"
        SplashText.TextColor3 = Color3.new(1, 0, 0)
        task.wait(2)
        ScreenGui:Destroy()
        return
    end
    
    SplashText.Text = "PRONTO!"
    task.wait(1)
    
    -- 3. Transição para o Menu
    Splash.Visible = false
    Main.Visible = true
end)
