-- Shadow Hub: Gerenciador de Scripts (Modificado)
local HttpService = game:GetService("HttpService")
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- ==========================================================
-- SEÇÃO DE CONFIGURAÇÃO MANUAL (ADICIONE SEUS LINKS AQUI)
-- ==========================================================
local SCRIPTS_MANUAIS = {
    
    ["Don't Steal Famous"] = "https://raw.githubusercontent.com/ghostshadowaa/Shadow/main/Don%27t%20steal%20a%20famous.lua",
    
    -- Adicione quantos quiser seguindo o padrão acima
}
-- ==========================================================

local OWNER = "ghostshadowaa"
local REPO = "Shadow"
local BRANCH = "main"

local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "ShadowManager"

-- --- TELA DE ABERTURA ---
local SplashFrame = Instance.new("Frame", ScreenGui)
SplashFrame.Size = UDim2.new(0, 300, 0, 100)
SplashFrame.Position = UDim2.new(0.5, -150, 0.5, -50)
SplashFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
SplashFrame.BorderSizePixel = 0
SplashFrame.ZIndex = 10
Instance.new("UICorner", SplashFrame)
local SplashStroke = Instance.new("UIStroke", SplashFrame)
SplashStroke.Color = Color3.fromRGB(0, 150, 255)
SplashStroke.Thickness = 2

local SplashText = Instance.new("TextLabel", SplashFrame)
SplashText.Size = UDim2.new(1, 0, 1, 0)
SplashText.Text = "Carregando Shadow Hub..."
SplashText.Font = Enum.Font.GothamBold
SplashText.TextColor3 = Color3.new(1, 1, 1)
SplashText.TextSize = 16
SplashText.BackgroundTransparency = 1
SplashText.ZIndex = 11

-- --- PAINEL PRINCIPAL ---
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 380)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(0, 150, 255)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "SHADOW MANAGER"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18
Title.BackgroundTransparency = 1

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -70)
Scroll.Position = UDim2.new(0, 10, 0, 60)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 7)

local function CloseManager()
    ScreenGui:Destroy()
end

-- Função para Criar Botão
local function CriarBotao(nome, url)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Text = nome
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.TextColor3 = Color3.new(0, 0.6, 1) -- Cor azulada para destacar
    btn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        CloseManager()
        loadstring(game:HttpGet(url))()
    end)
end

-- Carregar Scripts
local function LoadScripts()
    local total = 0
    
    -- 1. Carrega os manuais primeiro
    for nome, url in pairs(SCRIPTS_MANUAIS) do
        CriarBotao("[M] " .. nome, url)
        total = total + 1
    end

    -- 2. Carrega os do GitHub automaticamente
    local apiUrl = "https://api.github.com/repos/"..OWNER.."/"..REPO.."/contents"
    local s, r = pcall(function() return game:HttpGet(apiUrl) end)
    if s then
        local files = HttpService:JSONDecode(r)
        for _, file in pairs(files) do
            if file.name:match("%.lua$") then
                local rawUrl = "https://raw.githubusercontent.com/"..OWNER.."/"..REPO.."/"..BRANCH.."/"..file.name
                CriarBotao(file.name:gsub(".lua", ""), rawUrl)
                total = total + 1
            end
        end
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, total * 47)
end

-- Animação e Start
task.spawn(function()
    task.wait(1)
    SplashFrame.Visible = false
    MainFrame.Visible = true
    LoadScripts()
end)
