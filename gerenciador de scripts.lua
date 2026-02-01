local HttpService = game:GetService("HttpService")
local Player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")

-- CONFIGURAÇÃO DO REPOSITÓRIO
local OWNER = "ghostshadowaa"
local REPO = "Shadow"
local BRANCH = "main"

local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "ShadowManagerFinal"
ScreenGui.DisplayOrder = 999 -- Garante que fique por cima de tudo

-- --- TELA DE CARREGAMENTO (SPLASH) ---
local Splash = Instance.new("Frame", ScreenGui)
Splash.Size = UDim2.new(1, 0, 1, 0)
Splash.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Splash.ZIndex = 100

local SplashText = Instance.new("TextLabel", Splash)
SplashText.Size = UDim2.new(1, 0, 1, 0)
SplashText.Text = "SHADOW MANAGER\nLOADING ASSETS..."
SplashText.Font = Enum.Font.GothamBold
SplashText.TextColor3 = Color3.fromRGB(0, 170, 255)
SplashText.TextSize = 24
SplashText.BackgroundTransparency = 1

-- --- PAINEL PRINCIPAL ---
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 280, 0, 380)
Main.Position = UDim2.new(0.5, -140, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Visible = false
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 170, 255)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "SHADOW HUB"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18
Title.BackgroundTransparency = 1

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -70)
Scroll.Position = UDim2.new(0, 10, 0, 60)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 7)

-- --- FUNÇÃO DE EXECUÇÃO E AUTO-CLOSE ---
local function ExecutarScript(url)
    -- Fecha e deleta o menu instantaneamente
    ScreenGui:Destroy() 
    
    -- Busca o código atualizado (Anti-Cache)
    local targetUrl = url .. "?t=" .. os.time()
    local s, conteudo = pcall(function() return game:HttpGet(targetUrl) end)
    
    if s and conteudo then
        local rodar = loadstring(conteudo)
        if rodar then
            rodar()
        end
    end
end

-- --- CARREGAR VIA API ---
local function LoadAPI()
    local apiUrl = "https://api.github.com/repos/"..OWNER.."/"..REPO.."/contents?t="..os.time()
    local success, response = pcall(function() return game:HttpGet(apiUrl) end)

    if success then
        local files = HttpService:JSONDecode(response)
        local count = 0
        for _, file in pairs(files) do
            if file.name:match("%.lua$") then
                count = count + 1
                local btn = Instance.new("TextButton", Scroll)
                btn.Size = UDim2.new(1, 0, 0, 40)
                btn.Text = file.name:gsub(".lua", "")
                btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                btn.TextColor3 = Color3.new(1, 1, 1)
                btn.Font = Enum.Font.GothamSemibold
                Instance.new("UICorner", btn)

                btn.MouseButton1Click:Connect(function()
                    local rawUrl = "https://raw.githubusercontent.com/"..OWNER.."/"..REPO.."/"..BRANCH.."/"..file.name
                    ExecutarScript(rawUrl)
                end)
            end
        end
        Scroll.CanvasSize = UDim2.new(0, 0, 0, count * 47)
    end
end

-- --- INICIALIZAÇÃO COM TELA DE LOADING ---
task.spawn(function()
    -- Garante que a Splash apareça antes de qualquer processamento
    Splash.Visible = true 
    LoadAPI()
    task.wait(2) -- Tempo para o usuário ver a tela de loading profissional
    
    -- Transição para o Menu
    TweenService:Create(Splash, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(SplashText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    task.wait(0.5)
    Splash.Visible = false
    Main.Visible = true
end)
