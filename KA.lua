--[[ 🛠️ KA HUB | ULTIMATE V8 REBORN - ESP FIX EDITION 🛠️ ]]

-- Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ⚙️ SERVIÇOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager") -- Usado para o Auto Clicker
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ⚙️ CONFIGURAÇÕES
local Config = {
    Aimbot = false,
    FOV = 150,
    ESP = false,
    -- Clicker
    Clicking = false,
    ClickCount = 0,
    LastClickCount = 0,
    LastUpdate = tick(),
    -- Movimento
    SpeedHack = false,
    WalkSpeed = 16,
    InfiniteJump = false,
    Fly = false,
    FlySpeed = 50,
}

local heartbeatConn = nil
-- CFrame de Teleporte para "Uncloked All Islands"
local ISLANDS_CFRAME = CFrame.new(
    -264.195801, 14361.75, 188.697403, 
    0.999998212, 0, 0.00189908384, 
    0, 1, 0, 
    -0.00189908384, 0, 0.999998212
)

-- [[ MIRA FÍSICA V8 (ARRASTÁVEL) ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KA_V8_Final"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local CursorHitbox = Instance.new("Frame", ScreenGui)
CursorHitbox.Size = UDim2.new(0, 60, 0, 60)
CursorHitbox.Position = UDim2.new(0.5, -30, 0.5, -30)
CursorHitbox.BackgroundTransparency = 1
CursorHitbox.Active = true
CursorHitbox.Draggable = true -- Mantém a mira arrastável

local CursorVisual = Instance.new("Frame", CursorHitbox)
CursorVisual.Size = UDim2.new(0, 40, 0, 40)
CursorVisual.Position = UDim2.new(0.5, -20, 0.5, -20)
CursorVisual.BackgroundTransparency = 1

local function createLine(size, pos)
    local l = Instance.new("Frame", CursorVisual)
    l.Size = size
    l.Position = pos
    l.BackgroundColor3 = Color3.new(1, 1, 1) -- Branco
    l.BorderSizePixel = 0
    return l
end
createLine(UDim2.new(1, 0, 0, 2), UDim2.new(0, 0, 0.5, -1)) -- Horizontal
createLine(UDim2.new(0, 2, 1, 0), UDim2.new(0.5, -1, 0, 0)) -- Vertical

-- [[ JANELA PRINCIPAL ]]
local Window = Rayfield:CreateWindow({
   Name = "KA Hub | Ultimate V8",
   LoadingTitle = "Injetando Funções...",
   LoadingSubtitle = "AutoClick + Combat + Fly + Jump + Teleport",
   ConfigurationSaving = { Enabled = false }
})

-- ============ ABA AUTO CLICKER ============
local ClickTab = Window:CreateTab("Auto Clicker", "rbxassetid://4483362458")
local CPSLabel = ClickTab:CreateLabel("CPS Atual: 0")

ClickTab:CreateToggle({
   Name = "ATIVAR MODO V8",
   CurrentValue = false,
   Callback = function(v)
      Config.Clicking = v
      if v and not heartbeatConn then
          -- Usa Heartbeat para máxima velocidade de clique (menos lag que RenderStepped)
          heartbeatConn = RunService.Heartbeat:Connect(function()
              local pos = CursorHitbox.AbsolutePosition + (CursorHitbox.AbsoluteSize / 2)
              
              -- Envia eventos de clique do mouse (mouse down e mouse up)
              VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 0) -- Pressiona
              VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0) -- Solta

              Config.ClickCount = Config.ClickCount + 1
          end)
      elseif not v and heartbeatConn then 
          heartbeatConn:Disconnect()
          heartbeatConn = nil
      end
   end,
})

-- ============ ABA MOVIMENTO ============
local MoveTab = Window:CreateTab("Movimento", "rbxassetid://4483362458")

MoveTab:CreateToggle({
   Name = "Speed Hack",
   CurrentValue = false,
   Callback = function(v) Config.SpeedHack = v end,
})

MoveTab:CreateSlider({
   Name = "Velocidade (WalkSpeed)",
   Range = {16, 250},
   Increment = 1,
   CurrentValue = Config.WalkSpeed,
   Callback = function(v) Config.WalkSpeed = v end,
})

MoveTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(v) Config.InfiniteJump = v end,
})

MoveTab:CreateToggle({
   Name = "Ativar Fly (Voar)",
   CurrentValue = false,
   Callback = function(v) Config.Fly = v end,
})

-- ============ ABA COMBATE ============
local CombatTab = Window:CreateTab("Combate", "rbxassetid://4483362458")

CombatTab:CreateToggle({
    Name = "Aimbot (Head)", 
    CurrentValue = false, 
    Callback = function(v) Config.Aimbot = v end
})

CombatTab:CreateToggle({
    Name = "ESP Highlights", 
    CurrentValue = false, 
    Callback = function(v) 
        Config.ESP = v 
        if not v then
            -- Limpa o ESP de todos os jogadores quando desliga
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("V8_ESP") then
                    p.Character.V8_ESP:Destroy()
                end
            end
        end
    end
})

-- ============ ABA TELEPORTE (NOVA) ============
local TeleportTab = Window:CreateTab("Teleporte", "rbxassetid://6033092823") -- Ícone de teleporte

TeleportTab:CreateButton({
    Name = "Uncloked All Islands",
    Callback = function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if hrp then
            hrp.CFrame = ISLANDS_CFRAME
            Rayfield:Notify({
                Title = "TELEPORTE SUCESSO",
                Content = "Teleportado para a ilha secreta.",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "ERRO DE TELEPORTE",
                Content = "Character ou HumanoidRootPart não encontrado.",
                Duration = 3
            })
        end
    end
})

-- [[ LÓGICA DE MOVIMENTO ]]
UserInputService.JumpRequest:Connect(function()
    if Config.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    end
end)

-- [[ LOOP PRINCIPAL (RENDERSTEPPED) ]]
RunService.RenderStepped:Connect(function()
    -- 1. Atualiza CPS
    if tick() - Config.LastUpdate >= 1 then
        CPSLabel:Set("CPS Atual: " .. (Config.ClickCount - Config.LastClickCount))
        Config.LastClickCount = Config.ClickCount
        Config.LastUpdate = tick()
    end

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if hum and hrp then
        -- 2. Speed Hack
        hum.WalkSpeed = Config.SpeedHack and Config.WalkSpeed or 16
        
        -- 3. Fly (Voar)
        if Config.Fly then
            local moveDir = hum.MoveDirection
            local flyVel = Vector3.new(0,0,0)
            -- Cima/Baixo
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then flyVel = Vector3.new(0, Config.FlySpeed, 0)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then flyVel = Vector3.new(0, -Config.FlySpeed, 0) end
            
            hrp.Velocity = (moveDir * Config.FlySpeed) + flyVel
        end
    end

    -- 4. Lógica de ESP (Atualização contínua)
    if Config.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character.Parent then
                local h = p.Character:FindFirstChild("V8_ESP") or Instance.new("Highlight")
                if h.Parent ~= p.Character then h.Parent = p.Character end -- Garante que o Parent está correto
                h.Name = "V8_ESP"
                h.FillColor = Color3.fromRGB(255, 0, 0) -- Vermelho
                h.OutlineColor = Color3.new(1, 1, 1) -- Branco
                h.FillTransparency = 0.5
            end
        end
    end

    -- 5. Aimbot
    if Config.Aimbot then
        local target = nil
        local shortestDist = Config.FOV
        local mousePos = UserInputService:GetMouseLocation()

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character.Parent then
                local pos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if onScreen then
                    -- Distância 2D do centro da tela/cursor até o alvo
                    local mag = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if mag < shortestDist then 
                        shortestDist = mag 
                        target = p 
                    end
                end
            end
        end
        -- Move a CFrame da Câmera para mirar no alvo
        if target then 
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position) 
        end
    end
end)

Rayfield:Notify({Title = "KA HUB ATUALIZADO", Content = "ESP e Teleporte Adicionados!", Duration = 5})
