-- Shadow Hub PRO: API Edition (Auto-Update)
local HttpService = game:GetService("HttpService")
local Player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")

-- CONFIGURAÇÃO DO SEU GITHUB
local OWNER = "ghostshadowaa"
local REPO = "Shadow"
local BRANCH = "main"

local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "ShadowSystemAPI"
ScreenGui.ResetOnSpawn = false

-- --- BOTÃO FLUTUANTE ---
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -22)
OpenBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
OpenBtn.Text = "S"
OpenBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 20
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local BtnStroke = Instance.new("UIStroke", OpenBtn)
BtnStroke.Color = Color3.fromRGB(0, 170, 255)

-- --- PAINEL PRINCIPAL ---
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 280, 0, 380)
Main.Position = UDim2.new(0.5, -140, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Visible = false
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 170, 255)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "SHADOW MANAGER"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -70)
Scroll.Position = UDim2.new(0, 10, 0, 60)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 7)

-- --- FUNÇÃO DE EXECUÇÃO COM ANTI-CACHE ---
local function ExecutarScript(url, nome)
    print("Shadow Hub: Atualizando e Executando " .. nome)
    -- O 'nocache' garante que ele baixe a versão que você acabou de salvar no GitHub
    local antiCacheUrl = url .. "?t=" .. os.time() 
    local s, conteudo = pcall(function() return game:HttpGet(antiCacheUrl) end)
    
    if s and conteudo then
        local rodar, erro = loadstring(conteudo)
        if rodar then
            Main.Visible = false
            rodar()
        else
            warn("Erro no script: " .. tostring(erro))
        end
    else
        warn("Erro ao baixar o arquivo do GitHub.")
    end
end

-- --- BUSCA AUTOMÁTICA PELA API ---
local function LoadFromAPI()
    for _, child in pairs(Scroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

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
                    ExecutarScript(rawUrl, file.name)
                end)
            end
        end
        Scroll.CanvasSize = UDim2.new(0, 0, 0, count * 47)
    end
end

-- Abrir/Fechar
OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    if Main.Visible then LoadFromAPI() end -- Atualiza a lista toda vez que abrir
end)

-- Tela de Loading Inicial
local Splash = Instance.new("Frame", ScreenGui)
Splash.Size = UDim2.new(1, 0, 1, 0)
Splash.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Splash.ZIndex = 100
local STxt = Instance.new("TextLabel", Splash)
STxt.Size = UDim2.new(1, 0, 1, 0)
STxt.Text = "SYNCING WITH GITHUB..."
STxt.TextColor3 = Color3.fromRGB(0, 170, 255)
STxt.Font = Enum.Font.GothamBold
STxt.TextSize = 20
STxt.BackgroundTransparency = 1

task.spawn(function()
    LoadFromAPI()
    task.wait(1.5)
    TweenService:Create(Splash, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(STxt, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    task.wait(0.5)
    Splash.Visible = false
end)
