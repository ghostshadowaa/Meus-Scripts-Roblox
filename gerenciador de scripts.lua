-- Shadow Hub: Gerenciador Profissional Corrigido (ghostshadowaa/Shadow)
local HttpService = game:GetService("HttpService")
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- CONFIGURAÇÃO
local OWNER = "ghostshadowaa"
local REPO = "Shadow"
local BRANCH = "main"

local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "ShadowManager_Fixed"
ScreenGui.DisplayOrder = 1000

-- --- TELA DE CARREGAMENTO (SPLASH) ---
local SplashFrame = Instance.new("Frame", ScreenGui)
SplashFrame.Size = UDim2.new(1, 0, 1, 100)
SplashFrame.Position = UDim2.new(0, 0, 0, -50)
SplashFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
SplashFrame.ZIndex = 2000

local SplashText = Instance.new("TextLabel", SplashFrame)
SplashText.Size = UDim2.new(1, 0, 0, 50)
SplashText.Position = UDim2.new(0, 0, 0.45, 0)
SplashText.Text = "SHADOW MANAGER"
SplashText.Font = Enum.Font.GothamBold
SplashText.TextSize = 35
SplashText.TextColor3 = Color3.fromRGB(255, 255, 255)
SplashText.BackgroundTransparency = 1
SplashText.ZIndex = 2001

local StatusLabel = Instance.new("TextLabel", SplashFrame)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 0.55, 0)
StatusLabel.Text = "Sincronizando com GitHub..."
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.TextColor3 = Color3.fromRGB(0, 120, 255)
StatusLabel.BackgroundTransparency = 1
StatusLabel.ZIndex = 2001

-- --- PAINEL PRINCIPAL ---
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 380)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(40, 40, 40)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "SHADOW HUB V2"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1

-- Aba de Changelog (Log de Versão)
local LogFrame = Instance.new("Frame", MainFrame)
LogFrame.Size = UDim2.new(1, -20, 0, 60)
LogFrame.Position = UDim2.new(0, 10, 0, 45)
LogFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", LogFrame)

local LogTitle = Instance.new("TextLabel", LogFrame)
LogTitle.Size = UDim2.new(1, -10, 0, 20)
LogTitle.Position = UDim2.new(0, 5, 0, 5)
LogTitle.Text = "O QUE HÁ DE NOVO:"
LogTitle.Font = Enum.Font.GothamBold
LogTitle.TextSize = 10
LogTitle.TextColor3 = Color3.fromRGB(0, 120, 255)
LogTitle.TextXAlignment = Enum.TextXAlignment.Left
LogTitle.BackgroundTransparency = 1

local LogText = Instance.new("TextLabel", LogFrame)
LogText.Size = UDim2.new(1, -10, 0, 30)
LogText.Position = UDim2.new(0, 5, 0, 22)
LogText.Text = "• Nova tela de boot profissional\n• Auto-close ao executar script"
LogText.Font = Enum.Font.Gotham
LogText.TextSize = 10
LogText.TextColor3 = Color3.fromRGB(180, 180, 180)
LogText.TextXAlignment = Enum.TextXAlignment.Left
LogText.BackgroundTransparency = 1

-- Container de Scripts
local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -120)
Scroll.Position = UDim2.new(0, 10, 0, 110)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 7)

-- FUNÇÃO PARA CARREGAR SCRIPTS (CORRIGIDA)
local function FetchScripts()
    local apiUrl = "https://api.github.com/repos/"..OWNER.."/"..REPO.."/contents"
    
    local success, response = pcall(function()
        return game:HttpGet(apiUrl)
    end)

    if success then
        local files = HttpService:JSONDecode(response)
        local count = 0
        
        for _, file in pairs(files) do
            if file.name:match("%.lua$") then
                count = count + 1
                local btn = Instance.new("TextButton", Scroll)
                btn.Size = UDim2.new(1, 0, 0, 40)
                btn.Text = "  " .. file.name:gsub(".lua", "")
                btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                btn.TextColor3 = Color3.new(1, 1, 1)
                btn.Font = Enum.Font.GothamSemibold
                btn.TextXAlignment = Enum.TextXAlignment.Left
                Instance.new("UICorner", btn)

                btn.MouseButton1Click:Connect(function()
                    local raw = "https://raw.githubusercontent.com/"..OWNER.."/"..REPO.."/"..BRANCH.."/"..file.name
                    ScreenGui:Destroy()
                    loadstring(game:HttpGet(raw))()
                end)
            end
        end
        Scroll.CanvasSize = UDim2.new(0, 0, 0, count * 47)
        return true
    else
        return false
    end
end

-- SEQUÊNCIA DE BOOT
task.spawn(function()
    task.wait(1)
    StatusLabel.Text = "Lendo repositório..."
    
    local scriptsLoaded = FetchScripts()
    
    if scriptsLoaded then
        StatusLabel.Text = "Tudo pronto!"
        task.wait(0.5)
        
        -- Animação de Saída do Splash
        TweenService:Create(SplashFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(SplashText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(StatusLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        
        task.wait(0.5)
        SplashFrame.Visible = false
        MainFrame.Visible = true
        
        -- Animação de Entrada do Painel
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame:TweenSize(UDim2.new(0, 280, 0, 380), "Out", "Back", 0.4, true)
    else
        StatusLabel.Text = "Erro ao carregar. Verifique sua internet."
        StatusLabel.TextColor3 = Color3.new(1, 0, 0)
    end
end)
