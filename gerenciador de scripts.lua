-- Shadow Hub: Gerenciador Profissional (ghostshadowaa/Shadow)
local HttpService = game:GetService("HttpService")
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- CONFIGURAÇÃO
local OWNER = "ghostshadowaa"
local REPO = "Shadow"
local BRANCH = "main"

local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "ShadowManager_Pro"
ScreenGui.DisplayOrder = 1000

-- --- INTERFACE DE CARREGAMENTO PROFISSIONAL ---
local SplashFrame = Instance.new("Frame", ScreenGui)
SplashFrame.Size = UDim2.new(1, 0, 1, 100)
SplashFrame.Position = UDim2.new(0, 0, 0, -50)
SplashFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
SplashFrame.ZIndex = 2000

local SplashGradient = Instance.new("UIGradient", SplashFrame)
SplashGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 15)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 5))
})

local Content = Instance.new("Frame", SplashFrame)
Content.Size = UDim2.new(0, 300, 0, 200)
Content.Position = UDim2.new(0.5, -150, 0.5, -100)
Content.BackgroundTransparency = 1
Content.ZIndex = 2001

local Logo = Instance.new("TextLabel", Content)
Logo.Size = UDim2.new(1, 0, 0, 50)
Logo.Text = "SHADOW"
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 45
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.BackgroundTransparency = 1
Logo.ZIndex = 2002

local Subtitle = Instance.new("TextLabel", Content)
Subtitle.Size = UDim2.new(1, 0, 0, 20)
Subtitle.Position = UDim2.new(0, 0, 0.25, 0)
Subtitle.Text = "MANAGER SYSTEM"
Subtitle.Font = Enum.Font.GothamSemibold
Subtitle.TextSize = 12
Subtitle.TextColor3 = Color3.fromRGB(0, 120, 255)
Subtitle.TextStrokeTransparency = 0.8
Subtitle.BackgroundTransparency = 1
Subtitle.ZIndex = 2002

local StatusLabel = Instance.new("TextLabel", Content)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 0.8, 0)
StatusLabel.Text = "Verificando conexão..."
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.BackgroundTransparency = 1
StatusLabel.ZIndex = 2002

-- Spinner (Círculo de Carregamento)
local Spinner = Instance.new("ImageLabel", Content)
Spinner.Size = UDim2.new(0, 40, 0, 40)
Spinner.Position = UDim2.new(0.5, -20, 0.55, 0)
Spinner.BackgroundTransparency = 1
Spinner.Image = "rbxassetid://123456789" -- Use IDs de círculos como 11419713314
Spinner.ImageColor3 = Color3.fromRGB(0, 120, 255)
Spinner.ZIndex = 2002

-- --- PAINEL PRINCIPAL (INVISÍVEL) ---
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 350)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(40, 40, 40)

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -70)
Scroll.Position = UDim2.new(0, 10, 0, 60)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 7)

-- LÓGICA DE TRANSIÇÃO E CARREGAMENTO
local function StartGerenciador()
    task.spawn(function()
        while SplashFrame.Visible do
            Spinner.Rotation = Spinner.Rotation + 8
            task.wait()
        end
    end)

    task.wait(1)
    StatusLabel.Text = "Conectando ao GitHub API..."
    task.wait(0.8)
    StatusLabel.Text = "Buscando repositório: " .. REPO
    
    local apiUrl = "https://api.github.com/repos/"..OWNER.."/"..REPO.."/contents"
    local success, response = pcall(function() return game:HttpGet(apiUrl) end)

    if success then
        StatusLabel.Text = "Scripts encontrados! Preparando interface..."
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
                    ScreenGui:Destroy()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/"..OWNER.."/"..REPO.."/"..BRANCH.."/"..file.name))()
                end)
            end
        end
        Scroll.CanvasSize = UDim2.new(0, 0, 0, count * 47)
        task.wait(1)
        
        -- Fade Out
        TweenService:Create(SplashFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        for _, v in pairs(Content:GetChildren()) do
            if v:IsA("TextLabel") or v:IsA("ImageLabel") then
                TweenService:Create(v, TweenInfo.new(0.5), {ImageTransparency = 1, TextTransparency = 1}):Play()
            end
        end
        task.wait(0.5)
        SplashFrame.Visible = false
        MainFrame.Visible = true
        MainFrame:TweenSize(UDim2.new(0, 260, 0, 350), "Out", "Back", 0.3, true)
    else
        StatusLabel.Text = "Erro ao conectar. Verifique o Repositório."
        StatusLabel.TextColor3 = Color3.new(1, 0, 0)
    end
end

StartGerenciador()
