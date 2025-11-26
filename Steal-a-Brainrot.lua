-- Sistema principal que carrega ambos os scripts
local function LoadDarkHub()
    -- Primeiro carrega o script do GitHub
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ghostshadowaa/Meus-Scripts-Roblox/refs/heads/main/Steal-a-Brainrot.lua"))()
    
    -- Aguarda um pouco para o script anterior carregar
    wait(2)
    
    -- Agora carrega o Dark Hub
    local DarkHubScript = [[
        -- Dark Hub - Sistema de Teleporte Avançado
        local Players = game:GetService("Players")
        local TweenService = game:GetService("TweenService")
        local RunService = game:GetService("RunService")
        local UserInputService = game:GetService("UserInputService")

        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        -- Configurações do Hub
        local HUB_CONFIG = {
            Name = "Dark Hub",
            MainColor = Color3.fromRGB(25, 25, 35),
            SecondaryColor = Color3.fromRGB(45, 45, 60),
            AccentColor = Color3.fromRGB(0, 170, 255),
            TextColor = Color3.fromRGB(255, 255, 255)
        }

        -- Lista de destinos com Cframes
        local DESTINATIONS = {
            {
                Name = "Base Principal",
                CFrame = CFrame.new(-474.108063, 0.024892807, 220.268066, 0, 0, 1, 0, 1, -0, -1, 0, 0),
                IsBase = true
            },
            {
                Name = "Área 1",
                CFrame = CFrame.new(-473.938141, -9.72606945, 113.607124, 0, -1, 0, 0, 0, -1, 1, 0, 0)
            },
            {
                Name = "Área 2", 
                CFrame = CFrame.new(-473.938141, -9.72606945, 6.60712433, 0, -1, 0, 0, 0, -1, 1, 0, 0)
            },
            {
                Name = "Área 3",
                CFrame = CFrame.new(-473.938263, -9.66027164, -100.392632, 0, -1, 0, 0, 0, -1, 1, 0, 0)
            },
            {
                Name = "Área 4",
                CFrame = CFrame.new(-345.253479, -9.66027069, -100.393364, 0, 1, 0, 0, 0, -1, -1, 0, 0)
            },
            {
                Name = "Área 5",
                CFrame = CFrame.new(-345.253601, -9.7260685, 6.60688019, 0, 1, 0, 0, 0, -1, -1, 0, 0)
            },
            {
                Name = "Área 6",
                CFrame = CFrame.new(-346.503601, -9.9760685, 113.606819, 1, 0, 0, 0, 0, -1, 0, 1, 0)
            },
            {
                Name = "Área 7",
                CFrame = CFrame.new(-345.253876, -9.72620678, 220.606873, 0, 1, 0, 0, 0, -1, -1, 0, 0)
            }
        }

        -- Criar a interface do Hub
        local function createDarkHub()
            -- ScreenGui principal
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "DarkHub"
            screenGui.Parent = player.PlayerGui
            
            -- Círculo flutuante de ativação
            local activationCircle = Instance.new("Frame")
            activationCircle.Name = "ActivationCircle"
            activationCircle.Size = UDim2.new(0, 80, 0, 80)
            activationCircle.Position = UDim2.new(0.5, -40, 0.9, -40)
            activationCircle.BackgroundColor3 = HUB_CONFIG.MainColor
            activationCircle.BorderSizePixel = 0
            activationCircle.ZIndex = 10
            activationCircle.Parent = screenGui
            
            -- Arredondar o círculo
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = activationCircle
            
            -- Efeito de brilho no círculo
            local glow = Instance.new("UIStroke")
            glow.Color = HUB_CONFIG.AccentColor
            glow.Thickness = 3
            glow.Parent = activationCircle
            
            -- Texto do círculo
            local circleText = Instance.new("TextLabel")
            circleText.Name = "Title"
            circleText.Size = UDim2.new(1, 0, 1, 0)
            circleText.BackgroundTransparency = 1
            circleText.Text = HUB_CONFIG.Name
            circleText.TextColor3 = HUB_CONFIG.TextColor
            circleText.TextScaled = true
            circleText.Font = Enum.Font.GothamBold
            circleText.Parent = activationCircle
            
            -- Container principal do menu
            local mainFrame = Instance.new("Frame")
            mainFrame.Name = "MainFrame"
            mainFrame.Size = UDim2.new(0, 400, 0, 500)
            mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
            mainFrame.BackgroundColor3 = HUB_CONFIG.MainColor
            mainFrame.BorderSizePixel = 0
            mainFrame.Visible = false
            mainFrame.ZIndex = 5
            mainFrame.Parent = screenGui
            
            -- Arredondar o menu
            local menuCorner = Instance.new("UICorner")
            menuCorner.CornerRadius = UDim.new(0, 12)
            menuCorner.Parent = mainFrame
            
            -- Sombra do menu
            local shadow = Instance.new("UIStroke")
            shadow.Color = Color3.new(0, 0, 0)
            shadow.Thickness = 2
            shadow.Parent = mainFrame
            
            -- Cabeçalho do menu
            local header = Instance.new("Frame")
            header.Name = "Header"
            header.Size = UDim2.new(1, 0, 0, 60)
            header.BackgroundColor3 = HUB_CONFIG.SecondaryColor
            header.BorderSizePixel = 0
            header.Parent = mainFrame
            
            local headerCorner = Instance.new("UICorner")
            headerCorner.CornerRadius = UDim.new(0, 12)
            headerCorner.Parent = header
            
            -- Título do menu
            local title = Instance.new("TextLabel")
            title.Name = "Title"
            title.Size = UDim2.new(1, -20, 1, 0)
            title.Position = UDim2.new(0, 10, 0, 0)
            title.BackgroundTransparency = 1
            title.Text = HUB_CONFIG.Name
            title.TextColor3 = HUB_CONFIG.TextColor
            title.TextScaled = true
            title.Font = Enum.Font.GothamBlack
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = header
            
            -- Botão de fechar
            local closeButton = Instance.new("TextButton")
            closeButton.Name = "CloseButton"
            closeButton.Size = UDim2.new(0, 30, 0, 30)
            closeButton.Position = UDim2.new(1, -40, 0.5, -15)
            closeButton.BackgroundColor3 = HUB_CONFIG.AccentColor
            closeButton.Text = "X"
            closeButton.TextColor3 = HUB_CONFIG.TextColor
            closeButton.TextScaled = true
            closeButton.Font = Enum.Font.GothamBold
            closeButton.Parent = header
            
            local closeCorner = Instance.new("UICorner")
            closeCorner.CornerRadius = UDim.new(1, 0)
            closeCorner.Parent = closeButton
            
            -- Área de rolagem para os botões
            local scrollFrame = Instance.new("ScrollingFrame")
            scrollFrame.Name = "ScrollFrame"
            scrollFrame.Size = UDim2.new(1, -20, 1, -80)
            scrollFrame.Position = UDim2.new(0, 10, 0, 70)
            scrollFrame.BackgroundTransparency = 1
            scrollFrame.BorderSizePixel = 0
            scrollFrame.ScrollBarThickness = 5
            scrollFrame.Parent = mainFrame
            
            -- Layout dos botões
            local listLayout = Instance.new("UIListLayout")
            listLayout.Padding = UDim.new(0, 10)
            listLayout.Parent = scrollFrame
            
            return {
                ScreenGui = screenGui,
                ActivationCircle = activationCircle,
                MainFrame = mainFrame,
                ScrollFrame = scrollFrame,
                CloseButton = closeButton
            }
        end

        -- Sistema de teleporte seguro
        local function safeTeleport(destinationCFrame)
            local character = player.Character
            if not character then return false end
            
            local humanoid = character:FindFirstChild("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            if not humanoid or not rootPart then return false end
            
            -- Verificar se o personagem está em um estado válido para teleporte
            if humanoid.Health <= 0 then
                return false
            end
            
            -- Efeito visual de teleporte (opcional)
            local teleportEffect = Instance.new("Part")
            teleportEffect.Size = Vector3.new(4, 4, 4)
            teleportEffect.Position = rootPart.Position
            teleportEffect.Anchored = true
            teleportEffect.CanCollide = false
            teleportEffect.Material = Enum.Material.Neon
            teleportEffect.BrickColor = BrickColor.new("Bright blue")
            teleportEffect.Parent = workspace
            
            -- Teleporte suave usando Tween
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = destinationCFrame})
            
            -- Executar teleporte
            rootPart.CFrame = destinationCFrame
            
            -- Limpar efeito
            game:GetService("Debris"):AddItem(teleportEffect, 1)
            
            return true
        end

        -- Identificar qual é a base do jogador
        local function identifyPlayerBase()
            local playerPosition = humanoidRootPart.Position
            local closestBase = nil
            local minDistance = math.huge
            
            for _, destination in pairs(DESTINATIONS) do
                if destination.IsBase then
                    local distance = (playerPosition - destination.CFrame.Position).Magnitude
                    if distance < minDistance then
                        minDistance = distance
                        closestBase = destination.Name
                    end
                end
            end
            
            return closestBase or "Base Principal"
        end

        -- Criar botões de teleporte
        local function createTeleportButtons(scrollFrame, hubElements)
            local playerBase = identifyPlayerBase()
            
            for index, destination in pairs(DESTINATIONS) do
                local button = Instance.new("TextButton")
                button.Name = "TeleportButton_" .. index
                button.Size = UDim2.new(1, 0, 0, 50)
                button.BackgroundColor3 = HUB_CONFIG.SecondaryColor
                button.Text = ""
                button.AutoButtonColor = false
                button.Parent = scrollFrame
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 8)
                buttonCorner.Parent = button
                
                local buttonStroke = Instance.new("UIStroke")
                buttonStroke.Color = HUB_CONFIG.AccentColor
                buttonStroke.Thickness = 1
                buttonStroke.Parent = button
                
                -- Nome do destino
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Name = "Name"
                nameLabel.Size = UDim2.new(0.7, 0, 1, 0)
                nameLabel.Position = UDim2.new(0, 10, 0, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = destination.Name
                nameLabel.TextColor3 = HUB_CONFIG.TextColor
                nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                nameLabel.TextScaled = true
                nameLabel.Font = Enum.Font.Gotham
                nameLabel.Parent = button
                
                -- Indicador de base atual
                if destination.Name == playerBase then
                    local baseIndicator = Instance.new("TextLabel")
                    baseIndicator.Name = "BaseIndicator"
                    baseIndicator.Size = UDim2.new(0.25, 0, 0, 20)
                    baseIndicator.Position = UDim2.new(0.7, 10, 0.5, -10)
                    baseIndicator.BackgroundColor3 = HUB_CONFIG.AccentColor
                    baseIndicator.Text = "SUA BASE"
                    baseIndicator.TextColor3 = HUB_CONFIG.TextColor
                    baseIndicator.TextScaled = true
                    baseIndicator.Font = Enum.Font.GothamBold
                    baseIndicator.Parent = button
                    
                    local indicatorCorner = Instance.new("UICorner")
                    indicatorCorner.CornerRadius = UDim.new(0, 4)
                    indicatorCorner.Parent = baseIndicator
                end
                
                -- Efeito hover do botão
                button.MouseEnter:Connect(function()
                    game:GetService("TweenService"):Create(
                        button,
                        TweenInfo.new(0.2),
                        {BackgroundColor3 = HUB_CONFIG.AccentColor}
                    ):Play()
                end)
                
                button.MouseLeave:Connect(function()
                    game:GetService("TweenService"):Create(
                        button,
                        TweenInfo.new(0.2),
                        {BackgroundColor3 = HUB_CONFIG.SecondaryColor}
                    ):Play()
                end)
                
                -- Ação de teleporte
                button.MouseButton1Click:Connect(function()
                    if safeTeleport(destination.CFrame) then
                        -- Fechar o hub após teleporte
                        hubElements.MainFrame.Visible = false
                    else
                        -- Feedback de erro
                        local originalText = nameLabel.Text
                        nameLabel.Text = "ERRO - Tente novamente"
                        nameLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
                        
                        wait(1)
                        nameLabel.Text = originalText
                        nameLabel.TextColor3 = HUB_CONFIG.TextColor
                    end
                end)
            end
            
            -- Ajustar tamanho do canvas
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, (#DESTINATIONS * 60) + 10)
        end

        -- Sistema de animação do círculo
        local function setupCircleAnimation(circle)
            local rotation = 0
            local pulseDirection = 1
            local pulseValue = 0
            
            RunService.Heartbeat:Connect(function(deltaTime)
                rotation = (rotation + 30 * deltaTime) % 360
                pulseValue = pulseValue + (2 * deltaTime * pulseDirection)
                
                if pulseValue >= 1 then
                    pulseDirection = -1
                elseif pulseValue <= 0 then
                    pulseDirection = 1
                end
                
                -- Aplicar rotação e pulso
                circle.Rotation = rotation
                circle.UIStroke.Transparency = 0.5 + (pulseValue * 0.5)
            end)
        end

        -- Inicializar o Hub
        local function initializeDarkHub()
            local hubElements = createDarkHub()
            createTeleportButtons(hubElements.ScrollFrame, hubElements)
            setupCircleAnimation(hubElements.ActivationCircle)
            
            -- Controle de abertura/fechamento
            hubElements.ActivationCircle.MouseButton1Click:Connect(function()
                hubElements.MainFrame.Visible = not hubElements.MainFrame.Visible
            end)
            
            hubElements.CloseButton.MouseButton1Click:Connect(function()
                hubElements.MainFrame.Visible = false
            end)
            
            -- Fechar com ESC
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if input.KeyCode == Enum.KeyCode.Escape and hubElements.MainFrame.Visible then
                    hubElements.MainFrame.Visible = false
                end
            end)
            
            print("Dark Hub carregado com sucesso!")
            print("Base identificada: " .. identifyPlayerBase())
        end

        -- Executar inicialização
        initializeDarkHub()
    ]]
    
    -- Executa o script do Dark Hub
    loadstring(DarkHubScript)()
end

-- Inicia o carregamento
LoadDarkHub()
