local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Criar janela principal
local Window = Rayfield:CreateWindow({
    Name = "Auto Clicker Rayfield",
    LoadingTitle = "Carregando Auto Clicker",
    LoadingSubtitle = "Por favor, aguarde...",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "AutoClickerConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    }
})

-- Variável para controlar o estado do auto click
local autoClickEnabled = false

-- Função para clicar na posição relativa da tela
local function clickAtRelativePosition(relativeX, relativeY)
    local UserInputService = game:GetService("UserInputService")
    local GuiService = game:GetService("GuiService")
    local RunService = game:GetService("RunService")

    -- Obter tamanho da tela
    local screenSize = workspace.CurrentCamera.ViewportSize

    -- Calcular posição absoluta do clique
    local clickPos = Vector2.new(screenSize.X * relativeX, screenSize.Y * relativeY)

    -- Criar evento de clique do mouse
    local mouse = game.Players.LocalPlayer:GetMouse()

    -- Simular clique do mouse na posição calculada
    -- Em Roblox, não há função oficial para clicar em uma posição arbitrária,
    -- mas podemos usar eventos para simular clique em GUIs ou usar ferramentas específicas.
    -- Aqui, vamos usar um método simples para disparar um evento de clique no mouse.

    -- Mover o mouse para a posição (não oficial, só para referência)
    -- mouse.X = clickPos.X
    -- mouse.Y = clickPos.Y

    -- Simular clique (não oficial, depende do exploit usado)
    -- Se estiver usando um exploit que suporte mouse1click:
    pcall(function()
        mouse1click()
    end)
end

-- Criar toggle para ativar/desativar auto click
local AutoClickToggle = Window:CreateToggle({
    Name = "Ativar Auto Click",
    CurrentValue = false,
    Flag = "AutoClickToggle",
    Callback = function(value)
        autoClickEnabled = value
        if autoClickEnabled then
            -- Loop para clicar repetidamente
            spawn(function()
                while autoClickEnabled do
                    clickAtRelativePosition(0.5, 0)
                    wait(0.1) -- intervalo entre cliques, ajustar conforme necessário
                end
            end)
        end
    end
})
