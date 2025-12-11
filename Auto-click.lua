-- Carregar Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Criar janela simples
local Window = Rayfield:CreateWindow({
   Name = "Auto Click Pro",
   Icon = 0,
   LoadingTitle = "Auto Click Pro",
   LoadingSubtitle = "Sistema de Clique Automático",
   Theme = "Default",
   ToggleUIKeybind = "RightControl",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "AutoClickConfig",
      FileName = "Settings"
   }
})

-- Serviços necessários
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Variáveis do Auto Click
local AutoClickEnabled = false
local AutoClickSpeed = 10 -- Clicks por segundo
local AutoClickDelay = 0.1 -- Delay entre cliques
local AutoClickConnection = nil
local AutoClickMode = "Center" -- "Center" ou "Mouse"
local ClickHotkey = "F" -- Tecla para ativar/desativar rapidamente
local ClickButton = 0 -- 0 = Left, 1 = Right, 2 = Middle

-- Função para calcular delay baseado na velocidade
function CalculateDelay(speed)
    if speed > 0 then
        return 1 / speed
    end
    return 0.1
end

-- Sistema de Auto Click
function StartAutoClick()
    if AutoClickConnection then
        AutoClickConnection:Disconnect()
        AutoClickConnection = nil
    end
    
    AutoClickConnection = RunService.RenderStepped:Connect(function()
        if AutoClickEnabled then
            local x, y
            
            if AutoClickMode == "Center" then
                -- Clique no centro da tela
                local viewportSize = workspace.CurrentCamera.ViewportSize
                x = viewportSize.X / 2
                y = viewportSize.Y / 2
            else
                -- Clique na posição atual do mouse
                local mousePos = UserInputService:GetMouseLocation()
                x = mousePos.X
                y = mousePos.Y
            end
            
            -- Simular clique do mouse
            VirtualInputManager:SendMouseButtonEvent(x, y, ClickButton, true, game, 1)
            task.wait(0.001) -- Pequeno delay entre pressionar e soltar
            VirtualInputManager:SendMouseButtonEvent(x, y, ClickButton, false, game, 1)
            
            -- Delay entre cliques
            if AutoClickDelay > 0 then
                task.wait(AutoClickDelay)
            end
        end
    end)
end

function StopAutoClick()
    if AutoClickConnection then
        AutoClickConnection:Disconnect()
        AutoClickConnection = nil
    end
end

-- Criar aba principal
local MainTab = Window:CreateTab("Auto Click", 0)

-- Notificação de início
Rayfield:Notify({
   Title = "Auto Click Pro Carregado",
   Content = "Sistema de clique automático pronto!",
   Duration = 3,
   Image = 0,
})

-- Toggle principal para Auto Click
local AutoClickToggle = MainTab:CreateToggle({
   Name = "Auto Click: DESLIGADO",
   CurrentValue = false,
   Flag = "AutoClickToggle",
   Callback = function(Value)
       AutoClickEnabled = Value
       
       if Value then
           StartAutoClick()
           AutoClickToggle:Set("Auto Click: LIGADO ✅")
           Rayfield:Notify({
               Title = "✅ Auto Click Ativado",
               Content = "Clique automático ativado!",
               Duration = 3,
               Image = 0,
           })
       else
           StopAutoClick()
           AutoClickToggle:Set("Auto Click: DESLIGADO ❌")
           Rayfield:Notify({
               Title = "❌ Auto Click Desativado",
               Content = "Clique automático desativado!",
               Duration = 3,
               Image = 0,
           })
       end
   end,
})

-- Configuração de velocidade
MainTab:CreateSlider({
   Name = "Velocidade (CPS)",
   Range = {1, 100},
   Increment = 1,
   Suffix = "clicks/segundo",
   CurrentValue = 10,
   Flag = "ClickSpeed",
   Callback = function(Value)
       AutoClickSpeed = Value
       AutoClickDelay = CalculateDelay(Value)
       
       Rayfield:Notify({
           Title = "⚡ Velocidade Alterada",
           Content = "Velocidade: " .. Value .. " CPS",
           Duration = 2,
           Image = 0,
       })
   end,
})

-- Modo de clique
MainTab:CreateDropdown({
   Name = "Modo de Clique",
   Options = {"Centro da Tela", "Posição do Mouse"},
   CurrentOption = {"Centro da Tela"},
   MultipleOptions = false,
   Flag = "ClickMode",
   Callback = function(Option)
       if Option[1] == "Centro da Tela" then
           AutoClickMode = "Center"
       else
           AutoClickMode = "Mouse"
       end
       
       Rayfield:Notify({
           Title = "🎯 Modo Alterado",
           Content = "Modo: " .. Option[1],
           Duration = 2,
           Image = 0,
       })
   end,
})

-- Botão de clique
MainTab:CreateDropdown({
   Name = "Botão do Mouse",
   Options = {"Botão Esquerdo", "Botão Direito", "Botão do Meio"},
   CurrentOption = {"Botão Esquerdo"},
   MultipleOptions = false,
   Flag = "ClickButtonSelect",
   Callback = function(Option)
       if Option[1] == "Botão Esquerdo" then
           ClickButton = 0
       elseif Option[1] == "Botão Direito" then
           ClickButton = 1
       else
           ClickButton = 2
       end
       
       Rayfield:Notify({
           Title = "🖱️ Botão Alterado",
           Content = "Usando: " .. Option[1],
           Duration = 2,
           Image = 0,
       })
   end,
})

-- Tecla rápida
MainTab:CreateKeybind({
   Name = "Tecla Rápida",
   CurrentKeybind = "F",
   HoldToInteract = false,
   Flag = "QuickToggleKey",
   Callback = function(Keybind)
       ClickHotkey = Keybind
       Rayfield:Notify({
           Title = "🔧 Tecla Configurada",
           Content = "Tecla rápida: " .. Keybind,
           Duration = 2,
           Image = 0,
       })
   end,
})

-- Botão de teste
MainTab:CreateButton({
   Name = "Testar Clique",
   Callback = function()
       local x, y
       
       if AutoClickMode == "Center" then
           local viewportSize = workspace.CurrentCamera.ViewportSize
           x = viewportSize.X / 2
           y = viewportSize.Y / 2
       else
           local mousePos = UserInputService:GetMouseLocation()
           x = mousePos.X
           y = mousePos.Y
       end
       
       -- Simular um clique de teste
       VirtualInputManager:SendMouseButtonEvent(x, y, ClickButton, true, game, 1)
       task.wait(0.05)
       VirtualInputManager:SendMouseButtonEvent(x, y, ClickButton, false, game, 1)
       
       Rayfield:Notify({
           Title = "🖱️ Teste Concluído",
           Content = "Clique de teste executado!",
           Duration = 2,
           Image = 0,
       })
   end,
})

-- Informações
MainTab:CreateParagraph({
   Title = "Instruções de Uso",
   Content = "1. Ajuste a velocidade desejada\n2. Escolha o modo de clique\n3. Ative com o botão principal ou tecla rápida\n4. Use o botão de teste para verificar"
})

-- Sistema de tecla rápida
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        -- Converter string para KeyCode
        local keyCode
        if ClickHotkey == "F" then
            keyCode = Enum.KeyCode.F
        elseif ClickHotkey == "G" then
            keyCode = Enum.KeyCode.G
        elseif ClickHotkey == "H" then
            keyCode = Enum.KeyCode.H
        elseif ClickHotkey == "X" then
            keyCode = Enum.KeyCode.X
        elseif ClickHotkey == "C" then
            keyCode = Enum.KeyCode.C
        elseif ClickHotkey == "V" then
            keyCode = Enum.KeyCode.V
        else
            keyCode = Enum.KeyCode.F -- Padrão
        end
        
        if input.KeyCode == keyCode then
            AutoClickEnabled = not AutoClickEnabled
            
            if AutoClickEnabled then
                StartAutoClick()
                AutoClickToggle:Set("Auto Click: LIGADO ✅")
                Rayfield:Notify({
                    Title = "⚡ Auto Click Ativado",
                    Content = "Pressione " .. ClickHotkey .. " novamente para desligar",
                    Duration = 2,
                    Image = 0,
                })
            else
                StopAutoClick()
                AutoClickToggle:Set("Auto Click: DESLIGADO ❌")
                Rayfield:Notify({
                    Title = "❌ Auto Click Desativado",
                    Content = "Clique automático desativado",
                    Duration = 2,
                    Image = 0,
                })
            end
        end
        
        -- Tecla P para desligar tudo
        if input.KeyCode == Enum.KeyCode.P then
            StopAutoClick()
            Rayfield:Destroy()
            warn("Auto Click Pro desligado!")
        end
    end
end)

-- Informações no console
print("=====================================")
print("Auto Click Pro v1.0")
print("=====================================")
print("Teclas rápidas:")
print("  RightControl - Abrir/Fechar menu")
print("  " .. ClickHotkey .. " - Ligar/Desligar Auto Click")
print("  P - Desligar tudo")
print("=====================================")

-- Configuração inicial
AutoClickDelay = CalculateDelay(AutoClickSpeed)
