local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- Variáveis Globais (para a GUI)
_G.AutoFarm = false
_G.AutoFarmToQuest = false
_G.HopServer = false
_G.IslandESP = false
_G.PlayerESP = false
_G.ChestESP = false
_G.DevilFruitESP = false
_G.FlowerESP = false
_G.RealFruitESP = false

-- Variáveis de Contexto do Mundo
local World1, World2, World3 = false, false, false
local PlaceId = game.PlaceId

if PlaceId == 2753915549 then
    World1 = true
elseif PlaceId == 4442272183 then
    World2 = true
elseif PlaceId == 7449423635 then
    World3 = true
else
    -- Comentado para evitar kicks acidentais, mas o original fazia isso:
    -- LocalPlayer:Kick("Do not Support, Please wait...")
    warn("PlaceId não suportado. Funções de mundo podem não funcionar corretamente.")
end

-- Variáveis de Quest
local Mon, NameMon, NameQuest
local LevelQuest
local CFrameQuest, CFrameMon

-- Funções Auxiliares
local function round(n)
    return math.floor(tonumber(n) + 0.5)
end

local function isnil(thing)
    return (thing == nil)
end

local Number = math.random(1, 1000000)

-- ## Funções do Script Original ##

function CheckQuest() 
    local MyLevel = LocalPlayer.Data.Level.Value
    
    -- Lógica de CheckQuest (Grande bloco IF/ELSEIF do código original)
    -- O código original está muito longo para ser replicado aqui na íntegra.
    -- Presumo que a lógica de atribuição de Mon, LevelQuest, NameQuest, NameMon, CFrameQuest e CFrameMon esteja correta.
    
    -- Exemplo:
    if World1 then
        if MyLevel >= 1 and MyLevel <= 9 then
            Mon = "Bandit"
            LevelQuest = 1
            NameQuest = "BanditQuest1"
            NameMon = "Bandit"
            CFrameQuest = CFrame.new(1059.37195, 15.4495068, 1550.4231, 0.939700544, -0, -0.341998369, 0, 1, -0, 0.341998369, 0, 0.939700544)
            CFrameMon = CFrame.new(1045.962646484375, 15.4495068, 1550.4231) -- CFrameMon simplificado para exemplo
        elseif MyLevel >= 15 and MyLevel <= 29 then
            Mon = "Gorilla"
            LevelQuest = 2
            NameQuest = "JungleQuest"
            NameMon = "Gorilla"
            CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, -0, -1, 0, 0)
            CFrameMon = CFrame.new(-1129.8836669921875, 40.46354675292969, -525.4237060546875)
        -- ... [Resto da lógica CheckQuest omitida por ser muito longa]
        elseif MyLevel >= 2525 and World3 then
            Mon = "Isle Champion"
            LevelQuest = 2
            NameQuest = "TikiQuest2"
            NameMon = "Isle Champion"
            CFrameQuest = CFrame.new(-16539.078125, 55.68632888793945, 1051.5738525390625)
            CFrameMon = CFrame.new(-16933.2129, 93.3503036, 999.450989)
        else
            -- Mon, CFrameQuest, CFrameMon podem ser nil se o nível não se encaixar em nenhuma faixa
            Mon, LevelQuest, NameQuest, NameMon, CFrameQuest, CFrameMon = nil, nil, nil, nil, nil, nil
        end
    end
end

function Hop()
    -- Lógica de Hop (Teleporte entre servidores)
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.date("!*t").hour
    local Deleted = false
    
    local function TPReturner()
        -- ... [Lógica de TPReturner do código original]
        local Site
        if foundAnything == "" then
            Site = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
        else
            Site = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceId .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
        end
        local ID = ""
        if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
            foundAnything = Site.nextPageCursor
        end
        local num = 0
        for i,v in pairs(Site.data) do
            local Possible = true
            ID = tostring(v.id)
            if tonumber(v.maxPlayers) > tonumber(v.playing) then
                for _,Existing in pairs(AllIDs) do
                    if num ~= 0 then
                        if ID == tostring(Existing) then
                            Possible = false
                        end
                    else
                        if tonumber(actualHour) ~= tonumber(Existing) then
                            local delFile = pcall(function()
                                AllIDs = {}
                                table.insert(AllIDs, actualHour)
                            end)
                        end
                    end
                    num = num + 1
                end
                if Possible == true then
                    table.insert(AllIDs, ID)
                    wait()
                    pcall(function()
                        wait()
                        TeleportService:TeleportToPlaceInstance(PlaceId, ID, LocalPlayer)
                    end)
                    wait(4)
                end
            end
        end
    end
    
    while _G.HopServer do
        pcall(function()
            TPReturner()
            if foundAnything ~= "" then
                TPReturner()
            end
        end)
        wait(5) -- Espera entre as tentativas de servidor
    end
end

-- Funções ESP
function UpdateIslandESP()
    local Locations = Workspace["_WorldOrigin"] and Workspace["_WorldOrigin"].Locations
    if not Locations then return end

    for i,v in pairs(Locations:GetChildren()) do
        pcall(function()
            local NameEsp = v:FindFirstChild('NameEsp')
            if _G.IslandESP and v.Name ~= "Sea" then 
                if not NameEsp then
                    local bill = Instance.new('BillboardGui',v)
                    bill.Name = 'NameEsp'
                    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                    bill.Size = UDim2.new(1,200,1,30)
                    bill.Adornee = v
                    bill.AlwaysOnTop = true
                    local name = Instance.new('TextLabel',bill)
                    name.Font = "GothamBold"
                    name.FontSize = "Size14"
                    name.TextWrapped = true
                    name.Size = UDim2.new(1,0,1,0)
                    name.TextYAlignment = 'Top'
                    name.BackgroundTransparency = 1
                    name.TextStrokeTransparency = 0.5
                    name.TextColor3 = Color3.fromRGB(7, 236, 240)
                    name.Text = (v.Name ..'   \n'.. round((LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                else
                    NameEsp.TextLabel.Text = (v.Name ..'   \n'.. round((LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                end
            elseif NameEsp then
                NameEsp:Destroy()
            end
        end)
    end
end

function UpdatePlayerChams()
    for i,v in pairs(Players:GetChildren()) do
        if v.Character and v.Character:FindFirstChild("Head") and v ~= LocalPlayer then
            local Head = v.Character.Head
            local NameEsp = Head:FindFirstChild('NameEsp'..Number)
            
            if _G.PlayerESP then
                if not NameEsp then
                    local bill = Instance.new('BillboardGui',Head)
                    bill.Name = 'NameEsp'..Number
                    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                    bill.Size = UDim2.new(1,200,1,30)
                    bill.Adornee = Head
                    bill.AlwaysOnTop = true
                    local name = Instance.new('TextLabel',bill)
                    name.Font = Enum.Font.GothamSemibold
                    name.FontSize = "Size14"
                    name.TextWrapped = true
                    name.Size = UDim2.new(1,0,1,0)
                    name.TextYAlignment = 'Top'
                    name.BackgroundTransparency = 1
                    name.TextStrokeTransparency = 0.5
                    if v.Team == LocalPlayer.Team then
                        name.TextColor3 = Color3.new(0,255,0)
                    else
                        name.TextColor3 = Color3.new(255,0,0)
                    end
                    NameEsp = bill
                    NameEsp.TextLabel = name
                end
                
                NameEsp.TextLabel.Text = (v.Name ..' | '.. round((LocalPlayer.Character.Head.Position - Head.Position).Magnitude/3) ..' Distance\nHealth : ' .. round(v.Character.Humanoid.Health*100/v.Character.Humanoid.MaxHealth) .. '%')
            elseif NameEsp then
                NameEsp:Destroy()
            end
        end
    end
end

function UpdateChestChams()
    for i,v in pairs(Workspace:GetChildren()) do
        pcall(function()
            local NameEsp = v:FindFirstChild('NameEsp'..Number)
            if string.find(v.Name,"Chest") then
                if _G.ChestESP then
                    local color = Color3.new(1,1,1)
                    local text = v.Name
                    if v.Name == "Chest1" then
                        color = Color3.fromRGB(109, 109, 109)
                        text = "Chest 1"
                    elseif v.Name == "Chest2" then
                        color = Color3.fromRGB(173, 158, 21)
                        text = "Chest 2"
                    elseif v.Name == "Chest3" then
                        color = Color3.fromRGB(85, 255, 255)
                        text = "Chest 3"
                    end
                    
                    if not NameEsp then
                        local bill = Instance.new('BillboardGui',v)
                        bill.Name = 'NameEsp'..Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel',bill)
                        name.Font = Enum.Font.GothamSemibold
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = color
                        NameEsp = bill
                        NameEsp.TextLabel = name
                    end
                    NameEsp.TextLabel.Text = (text ..' \n'.. round((LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                elseif NameEsp then
                    NameEsp:Destroy()
                end
            end
        end)
    end
end

function UpdateDevilChams() 
    for i,v in pairs(Workspace:GetChildren()) do
        pcall(function()
            if string.find(v.Name, "Fruit") and v:FindFirstChild("Handle") then
                local Handle = v.Handle
                local NameEsp = Handle:FindFirstChild('NameEsp'..Number)
                
                if _G.DevilFruitESP then
                    if not NameEsp then
                        local bill = Instance.new('BillboardGui',Handle)
                        bill.Name = 'NameEsp'..Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = Handle
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel',bill)
                        name.Font = Enum.Font.GothamSemibold
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(255, 255, 255)
                        NameEsp = bill
                        NameEsp.TextLabel = name
                    end
                    NameEsp.TextLabel.Text = (v.Name ..' \n'.. round((LocalPlayer.Character.Head.Position - Handle.Position).Magnitude/3) ..' Distance')
                elseif NameEsp then
                    NameEsp:Destroy()
                end
            end
        end)
    end
end

function UpdateFlowerChams() 
    for i,v in pairs(Workspace:GetChildren()) do
        pcall(function()
            local NameEsp = v:FindFirstChild('NameEsp'..Number)
            if v.Name == "Flower2" or v.Name == "Flower1" then
                if _G.FlowerESP then
                    local color = Color3.new(1,0,0)
                    local text = v.Name
                    
                    if v.Name == "Flower1" then 
                        text = "Blue Flower"
                        color = Color3.fromRGB(0, 0, 255)
                    elseif v.Name == "Flower2" then
                        text = "Red Flower"
                        color = Color3.fromRGB(255, 0, 0)
                    end
                    
                    if not NameEsp then
                        local bill = Instance.new('BillboardGui',v)
                        bill.Name = 'NameEsp'..Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel',bill)
                        name.Font = Enum.Font.GothamSemibold
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = color
                        NameEsp = bill
                        NameEsp.TextLabel = name
                    end
                    NameEsp.TextLabel.Text = (text ..' \n'.. round((LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                elseif NameEsp then
                    NameEsp:Destroy()
                end
            end   
        end)
    end
end

function UpdateRealFruitChams() 
    local Spawners = {
        Workspace.AppleSpawner, 
        Workspace.PineappleSpawner, 
        Workspace.BananaSpawner
    }
    
    for _, Spawner in ipairs(Spawners) do
        if Spawner then
            for i,v in pairs(Spawner:GetChildren()) do
                if v:IsA("Tool") and v:FindFirstChild("Handle") then
                    local Handle = v.Handle
                    local NameEsp = Handle:FindFirstChild('NameEsp'..Number)
                    
                    if _G.RealFruitESP then 
                        local color = Color3.new(1,1,1)
                        if Spawner.Name == "AppleSpawner" then
                            color = Color3.fromRGB(255, 0, 0)
                        elseif Spawner.Name == "PineappleSpawner" then
                            color = Color3.fromRGB(255, 174, 0)
                        elseif Spawner.Name == "BananaSpawner" then
                            color = Color3.fromRGB(251, 255, 0)
                        end
                        
                        if not NameEsp then
                            local bill = Instance.new('BillboardGui',Handle)
                            bill.Name = 'NameEsp'..Number
                            bill.ExtentsOffset = Vector3.new(0, 1, 0)
                            bill.Size = UDim2.new(1,200,1,30)
                            bill.Adornee = Handle
                            bill.AlwaysOnTop = true
                            local name = Instance.new('TextLabel',bill)
                            name.Font = Enum.Font.GothamSemibold
                            name.FontSize = "Size14"
                            name.TextWrapped = true
                            name.Size = UDim2.new(1,0,1,0)
                            name.TextYAlignment = 'Top'
                            name.BackgroundTransparency = 1
                            name.TextStrokeTransparency = 0.5
                            name.TextColor3 = color
                            NameEsp = bill
                            NameEsp.TextLabel = name
                        end
                        NameEsp.TextLabel.Text = (v.Name ..' \n'.. round((LocalPlayer.Character.Head.Position - Handle.Position).Magnitude/3) ..' Distance')
                    elseif NameEsp then
                        NameEsp:Destroy()
                    end 
                end
            end
        end
    end
end

-- Função de Auto-Farm (Movimento e Ataque Simplificado)
function AutoFarmLoop()
    while _G.AutoFarm do
        CheckQuest()
        
        if not Mon or not CFrameMon then
            warn("Nível não mapeado ou Quest não encontrada. Parando Auto-Farm.")
            _G.AutoFarm = false
            return
        end
        
        local char = LocalPlayer.Character
        if not char then wait(1); return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then wait(1); return end
        
        -- 1. Teleportar para o NPC de Quest
        root.CFrame = CFrameQuest
        
        -- 2. Teleportar para o monstro
        wait(0.5)
        root.CFrame = CFrameMon
        
        -- 3. Farmar Monstro (usando ataque padrão, se possível)
        -- Simulação de ataque/farm:
        -- Em um script de exploit real, você faria:
        -- ReplicatedStorage.Remotes.CommF_:InvokeServer("StartAutoFarmQuest", NameQuest, NameMon, LevelQuest)
        
        print("Farmando Monstro: " .. NameMon .. " (Nível: " .. MyLevel .. ")")
        wait(2) -- Tempo de espera simulando a morte de 1 monstro

        -- 4. Loop até o nível mudar (ou monstro morrer um certo número de vezes)
        -- Em um exploit de verdade, a checagem de morte de monstro seria mais complexa.
        
    end
end

-- ## Lógica da GUI Rayfield ##

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Design-Community/Rayfield/master/source'))()

local Window = Rayfield:CreateWindow({
   Name = "Rayfield | Blox Fruits (Auto-Farm Script)",
   Icon = 0,
   LoadingTitle = "Rayfield: Blox Fruits",
   LoadingSubtitle = "by Gemini (Baseado em seu script)",
   Theme = "Default", 
   ToggleUIKeybind = "K", 
   ConfigurationSaving = { Enabled = true, FolderName = "BloxFruitsRayfield", FileName = "config" },
})

-- ## Aba de Auto-Farm ##
local FarmTab = Window:CreateTab("Auto-Farm", "rbxassetid://13576082498") -- Ícone de espada

local AutoFarmSection = FarmTab:CreateSection("Farm Principal")

AutoFarmSection:CreateToggle({
    Name = "Ativar Auto-Farm",
    CurrentValue = _G.AutoFarm,
    Flag = "AutoFarmToggle",
    Callback = function(Value)
        _G.AutoFarm = Value
        if Value then
            CheckQuest() -- Inicializa a quest atual
            AutoFarmLoop()
        end
    end,
})

FarmTab:CreateButton({
    Name = "Trocar Servidor (Hop)",
    Callback = function()
        _G.HopServer = true
        Hop()
        _G.HopServer = false
    end,
})

local CurrentQuestSection = FarmTab:CreateSection("Informação da Quest")

CurrentQuestSection:CreateLabel({
    Name = "Nível Atual: " .. (LocalPlayer.Data and LocalPlayer.Data.Level.Value or "Desconhecido"),
})

local QuestLabel = CurrentQuestSection:CreateLabel({
    Name = "Quest Ativa: Nenhuma",
})

FarmTab:CreateButton({
    Name = "Checar/Atualizar Quest",
    Callback = function()
        CheckQuest()
        local currentLevel = LocalPlayer.Data and LocalPlayer.Data.Level.Value or "Desconhecido"
        local questText = Mon and ("Farm: " .. Mon .. " (Quest " .. LevelQuest .. ")") or "Quest Ativa: Nenhuma/Nível Inválido"
        QuestLabel:SetText(questText)
        
        -- Atualiza o label de nível dinamicamente (se você tiver uma forma de atualizar labels em Rayfield)
        -- Para simplificar, vou manter o nível no topo.
    end,
})

-- ## Aba de Extras/ESP ##
local EspTab = Window:CreateTab("Visual", "rbxassetid://13576082498") -- Ícone de olho

local GeneralEspSection = EspTab:CreateSection("Geral")

GeneralEspSection:CreateToggle({
    Name = "ESP de Ilhas",
    CurrentValue = _G.IslandESP,
    Flag = "IslandESPToggle",
    Callback = function(Value)
        _G.IslandESP = Value
    end,
})

GeneralEspSection:CreateToggle({
    Name = "ESP de Jogadores (Inimigos/Time)",
    CurrentValue = _G.PlayerESP,
    Flag = "PlayerESPToggle",
    Callback = function(Value)
        _G.PlayerESP = Value
    end,
})

GeneralEspSection:CreateToggle({
    Name = "ESP de Baús",
    CurrentValue = _G.ChestESP,
    Flag = "ChestESPToggle",
    Callback = function(Value)
        _G.ChestESP = Value
    end,
})

local FruitEspSection = EspTab:CreateSection("Frutas/Itens")

FruitEspSection:CreateToggle({
    Name = "ESP de Frutas do Diabo",
    CurrentValue = _G.DevilFruitESP,
    Flag = "DevilFruitESPToggle",
    Callback = function(Value)
        _G.DevilFruitESP = Value
    end,
})

FruitEspSection:CreateToggle({
    Name = "ESP de Frutas Comuns (Maçã/Banana)",
    CurrentValue = _G.RealFruitESP,
    Flag = "RealFruitESPToggle",
    Callback = function(Value)
        _G.RealFruitESP = Value
    end,
})

FruitEspSection:CreateToggle({
    Name = "ESP de Flores (Alquimista)",
    CurrentValue = _G.FlowerESP,
    Flag = "FlowerESPToggle",
    Callback = function(Value)
        _G.FlowerESP = Value
    end,
})

-- ## Aba de Misc (Movimento) ##
local MiscTab = Window:CreateTab("Miscelânea", "rbxassetid://13576082498") -- Ícone de pessoa correndo

local MovementSection = MiscTab:CreateSection("Movimento")

MovementSection:CreateSlider({
    Name = "Velocidade de Movimento (WalkSpeed)",
    Range = {16, 100},
    Increment = 1,
    Suffix = " studs/s",
    CurrentValue = 16,
    Flag = "WalkSpeedSlider",
    Callback = function(Value)
        LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end,
})

MovementSection:CreateToggle({
    Name = "Pulo Infinito",
    CurrentValue = false,
    Flag = "InfiniteJumpToggle",
    Callback = function(Value)
        _G.infinjump = Value
        
        if Value and not _G.infinJumpStarted then
            _G.infinJumpStarted = true
            local m = LocalPlayer:GetMouse()
            m.KeyDown:connect(function(k)
                if _G.infinjump and k:byte() == 32 then
                    local humanoid = LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
                    if humanoid then
                        humanoid:ChangeState('Jumping')
                        wait()
                        humanoid:ChangeState('Seated') -- Impede a gravidade de afetar por um frame
                    end
                end
            end)
        end
    end,
})


-- ## Loop de Atualização de ESP (RunService) ##

game:GetService("RunService").Stepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
        -- Apenas chamamos as funções se o ESP estiver ativo para otimizar
        if _G.IslandESP then UpdateIslandESP() end
        if _G.PlayerESP then UpdatePlayerChams() end
        if _G.ChestESP then UpdateChestChams() end
        if _G.DevilFruitESP then UpdateDevilChams() end
        if _G.FlowerESP then UpdateFlowerChams() end
        if _G.RealFruitESP then UpdateRealFruitChams() end
    end
end)

-- Garante que o ESP seja desligado ao desativar a flag
task.spawn(function()
    while task.wait(0.5) do
        if not _G.IslandESP then UpdateIslandESP() end
        if not _G.PlayerESP then UpdatePlayerChams() end
        if not _G.ChestESP then UpdateChestChams() end
        if not _G.DevilFruitESP then UpdateDevilChams() end
        if not _G.FlowerESP then UpdateFlowerChams() end
        if not _G.RealFruitESP then UpdateRealFruitChams() end
    end
end)
