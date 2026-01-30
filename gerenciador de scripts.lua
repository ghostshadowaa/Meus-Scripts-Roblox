-- Shadow Hub: Gerenciador Profissional (FIXED VISIBILITY)
local HttpService = game:GetService("HttpService")
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- CONFIGURAÇÃO
local OWNER = "ghostshadowaa"
local REPO = "Shadow"
local BRANCH = "main"

local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "ShadowManager_UltraFix"
ScreenGui.DisplayOrder = 9999 -- Valor máximo para garantir prioridade

-- --- TELA DE CARREGAMENTO ---
local SplashFrame = Instance.new("Frame", ScreenGui)
SplashFrame.Size = UDim2.new(1, 0, 1, 100)
SplashFrame.Position = UDim2.new(0, 0, 0, -50)
SplashFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
SplashFrame.ZIndex = 10 -- Camada alta

local SplashText = Instance.new("TextLabel", SplashFrame)
SplashText.Size = UDim2.new(1, 0, 0, 50)
SplashText.Position = UDim2.new(0, 0, 0.45, 0)
SplashText.Text = "SHADOW"
SplashText.Font = Enum.Font.GothamBold
SplashText.TextSize = 40
SplashText.TextColor3 = Color3.new(1, 1, 1)
SplashText.BackgroundTransparency = 1
SplashText.ZIndex = 11

local StatusLabel = Instance.new("TextLabel", SplashFrame)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 0.55, 0)
StatusLabel.Text = "Iniciando sistema..."
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.TextColor3 = Color3.fromRGB(0, 120, 255)
StatusLabel.BackgroundTransparency = 1
StatusLabel.ZIndex = 11

-- --- PAINEL PRINCIPAL ---
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 380)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.Visible = false
MainFrame.ZIndex = 5 -- Fica atrás da Splash inicialmente
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -120)
Scroll.Position = UDim2.new(0, 10, 0, 110)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.ZIndex = 6
local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 7)

-- Função de Saída Suave
local function FinalizeLoading()
    local t = TweenService:Create(SplashFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
    TweenService:Create(SplashText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(StatusLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    t:Play()
    t.Completed:Wait()
    SplashFrame.Visible = false
    MainFrame.Visible = true
    MainFrame:TweenSize(UDim2.new(0, 280, 0, 380), "Out", "Back", 0.4, true)
end

-- LÓGICA DE CARREGAMENTO COM TIMEOUT
task.spawn(function()
    StatusLabel.Text = "Conectando ao GitHub..."
    
    local scriptsFound = false
    local apiUrl = "https://api.github.com/repos/"..OWNER.."/"..REPO.."/contents"
    
    -- Tenta carregar os scripts
    task.spawn(function()
        local success, response = pcall(function() return game:HttpGet(apiUrl) end)
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
                    btn.ZIndex = 7
                    Instance.new("UICorner", btn)
                    btn.MouseButton1Click:Connect(function()
                        ScreenGui:Destroy()
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/"..OWNER.."/"..REPO.."/"..BRANCH.."/"..file.name))()
                    end)
                end
            end
            Scroll.CanvasSize = UDim2.new(0, 0, 0, count * 47)
            scriptsFound = true
        end
    end)

    -- Timeout: Se em 4 segundos não carregar, ele força a entrada
    task.wait(4)
    if not scriptsFound then
        StatusLabel.Text = "Aviso: Conexão lenta, forçando abertura..."
        task.wait(1)
    else
        StatusLabel.Text = "Scripts sincronizados!"
        task.wait(0.5)
    end
    
    FinalizeLoading()
end)
