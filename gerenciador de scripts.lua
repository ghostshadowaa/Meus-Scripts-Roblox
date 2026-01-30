-- Shadow Hub: Gerenciador de Scripts (ghostshadowaa/Shadow)
local HttpService = game:GetService("HttpService")
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- CONFIGURAÇÃO
local OWNER = "ghostshadowaa"
local REPO = "Shadow"
local BRANCH = "main"

-- Interface Principal
local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "ShadowManager"

-- --- TELA DE ABERTURA (SPLASH SCREEN) ---
local SplashFrame = Instance.new("Frame", ScreenGui)
SplashFrame.Size = UDim2.new(0, 300, 0, 100)
SplashFrame.Position = UDim2.new(0.5, -150, 0.5, -50)
SplashFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
SplashFrame.BorderSizePixel = 0
SplashFrame.ZIndex = 10

local SplashCorner = Instance.new("UICorner", SplashFrame)
local SplashStroke = Instance.new("UIStroke", SplashFrame)
SplashStroke.Color = Color3.fromRGB(0, 150, 255)
SplashStroke.Thickness = 2

local SplashText = Instance.new("TextLabel", SplashFrame)
SplashText.Size = UDim2.new(1, 0, 1, 0)
SplashText.Text = "Iniciando Gerenciador de Scripts..."
SplashText.Font = Enum.Font.GothamBold
SplashText.TextColor3 = Color3.new(1, 1, 1)
SplashText.TextSize = 16
SplashText.BackgroundTransparency = 1
SplashText.ZIndex = 11

-- --- PAINEL DO GERENCIADOR ---
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 350)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Visible = false -- Começa invisível
MainFrame.Draggable = true
MainFrame.Active = true

local MainCorner = Instance.new("UICorner", MainFrame)
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

-- Função para fechar o gerenciador e limpar a GUI
local function CloseManager()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1})
    -- Faz o fade out de todos os componentes
    for _, v in pairs(MainFrame:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            TweenService:Create(v, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        end
    end
    tween:Play()
    tween.Completed:Wait()
    ScreenGui:Destroy()
end

-- Busca de arquivos no GitHub
local function LoadScripts()
    local apiUrl = "https://api.github.com/repos/"..OWNER.."/"..REPO.."/contents"
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
                    print("Shadow Hub: Executando " .. file.name)
                    
                    -- Fecha o gerenciador ANTES de executar para garantir limpeza
                    spawn(CloseManager) 
                    
                    loadstring(game:HttpGet(rawUrl))()
                end)
            end
        end
        Scroll.CanvasSize = UDim2.new(0, 0, 0, count * 47)
    end
end

-- ANIMAÇÃO DE ABERTURA
task.spawn(function()
    task.wait(0.5)
    -- Piscar o texto
    for i = 1, 3 do
        SplashText.TextTransparency = 0.5
        task.wait(0.2)
        SplashText.TextTransparency = 0
        task.wait(0.2)
    end
    
    -- Sumir Splash e mostrar Main
    local fadeSplash = TweenService:Create(SplashFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
    TweenService:Create(SplashText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(SplashStroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
    fadeSplash:Play()
    fadeSplash.Completed:Wait()
    SplashFrame.Visible = false
    
    -- Mostrar o Gerenciador
    MainFrame.Visible = true
    LoadScripts()
end)
