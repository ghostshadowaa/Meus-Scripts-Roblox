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
--[[
  CÓDIGO LUA (LocalScript) PARA O BOTÃO DE AUTOCLICKER EM MOBILE
  
  Este script deve ser colocado DENTRO do TextButton da GUI.
--]]

-- Serviços
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local task = task

-- Elementos
local Button = script.Parent -- Referencia o próprio botão (TextButton)
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()


-- --- Configurações ---
local delay_seconds = 0.1  -- Atraso entre os cliques em segundos (0.1s)
local is_clicking = false -- Variavel de controle: 'true' = clicando automaticamente
-- ---------------------


-- Função que ativa a ferramenta equipada
local function ActivateEquippedTool()
    -- Espera pelo Character, se necessário
    if not Character or Character.Parent == nil then
        Character = Player.Character or Player.CharacterAdded:Wait()
    end
    
    -- Procura a Tool (ferramenta) que o jogador está segurando
    local EquippedTool = Character:FindFirstChildOfClass("Tool")
    
    if EquippedTool then
        -- Simula o uso/toque/clique na ferramenta
        EquippedTool:Activate()
    end
end


-- Coroutine (Loop de Clique Automático)
local click_loop_thread = coroutine.wrap(function()
    while true do
        if is_clicking then
            -- Se 'is_clicking' for TRUE, o clique é disparado
            ActivateEquippedTool()
        end
        -- Pausa o script
        task.wait(delay_seconds)
    end
end)

-- Inicia o loop de verificação
click_loop_thread()


-- Monitora o clique/toque no botão
Button.MouseButton1Click:Connect(function()
    -- 1. Inverte o estado
    is_clicking = not is_clicking 
    
    -- 2. Atualiza o texto do botão para mostrar o estado
    if is_clicking then
        Button.Text = "Clique Automático: LIGADO"
        print("Autoclicker: **LIGADO** por toque.")
    else
        Button.Text = "Clique Automático: DESLIGADO"
        print("Autoclicker: **DESLIGADO** por toque.")
    end
end)


-- Adicional: Mantém o suporte à tecla 'F' para usuários de PC/teclado,
-- garantindo que o texto do botão seja atualizado corretamente.
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end 

    if input.KeyCode == Enum.KeyCode.F then
        -- Ação de ativação: inverte o estado de 'is_clicking'
        is_clicking = not is_clicking 
        
        -- Atualiza o texto do botão, independentemente de ter sido ativado por tecla ou toque.
        if is_clicking then
            Button.Text = "Clique Automático: LIGADO"
        else
            Button.Text = "Clique Automático: DESLIGADO"
        end
        
        print("Autoclicker: Estado alterado por tecla F.")
    end
end)

