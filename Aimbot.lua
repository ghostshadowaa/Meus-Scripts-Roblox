
-- Carregando a biblioteca Rayfield (Link corrigido e oficial)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Rayfield Example Window",
   Icon = 0, 
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "KA_Hub_Config", 
      FileName = "Premium Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true 
   },
   KeySystem = true, 
   KeySettings = {
      Title = "KA Hub",
      Subtitle = "Key System",
      Note = "A chave é: hub", 
      FileName = "KA_Key", 
      SaveKey = true, 
      GrabKeyFromSite = false, 
      Key = {"hub"} 
   }
})
[[
  BOTÃO DE VOO (FLY MODE) EM LUA
  
  Este código define a lógica por trás do modo de voo e o botão 
  que o controla. Ele é compatível com o sistema de UI anterior.
]]--

-- 1. VARIÁVEL DE ESTADO
local is_flying = false

-- 2. VARIÁVEL DE CONFIGURAÇÃO (Exemplo: A velocidade que o jogador ganha ao voar)
local fly_speed_multiplier = 2.0

-- 3. FUNÇÃO DE AÇÃO PRINCIPAL: ALTERNAR O MODO DE VOO

function toggle_fly_mode()
    -- Alterna o estado (True vira False, e False vira True)
    is_flying = not is_flying
    
    if is_flying then
        print("MODO DE VOO ATIVADO!")
        print(string.format("Velocidade aumentada em %.1fx.", fly_speed_multiplier))
        
        -- **[CÓDIGO DE IMPLEMENTAÇÃO DO JOGO AQUI]**
        -- Exemplo:
        -- player.can_fly = true
        -- player.movement_speed = player.base_speed * fly_speed_multiplier
        -- player.gravity_enabled = false
        
    else
        print("MODO DE VOO DESATIVADO!")
        
        -- **[CÓDIGO DE IMPLEMENTAÇÃO DO JOGO AQUI]**
        -- Exemplo:
        -- player.can_fly = false
        -- player.movement_speed = player.base_speed
        -- player.gravity_enabled = true
        
    end
    
    -- Atualiza o texto do botão para refletir o novo estado
    update_fly_button_text()
end

-- 4. FUNÇÃO AUXILIAR: ATUALIZAR O TEXTO DO BOTÃO

-- (Assumindo que você está usando a estrutura 'ui_elements' do exemplo anterior)
-- Esta função é conceitual e depende de como sua UI armazena referências.
local fly_button_index = nil -- Você precisaria armazenar a referência/índice

function update_fly_button_text()
    -- Encontra o elemento do botão de voo (usando um índice ou busca)
    local button = _G.ui_elements and _G.ui_elements[fly_button_index]
    
    -- Se o botão for encontrado, atualiza o texto
    if button and button.type == 'button' then
        if is_flying then
            button.text = "Voo: LIGADO (Clique para DESLIGAR)"
        else
            button.text = "Voo: DESLIGADO (Clique para LIGAR)"
        end
        print("Texto do Botão Atualizado: " .. button.text)
    end
end

-- 5. FUNÇÃO PARA ADICIONAR O BOTÃO AO PAINEL (Conceitual)

-- Se você estiver usando a função 'add_ui_element' do exemplo anterior:
function create_fly_button()
    local x = 200
    local y = 50
    local width = 250
    local height = 40
    
    -- Inicializa o texto baseado no estado inicial (DESLIGADO)
    local initial_text = "Voo: DESLIGADO (Clique para LIGAR)"
    
    -- Adiciona o botão, definindo a função 'toggle_fly_mode' como a ação
    -- Se estiver usando o painel anterior, você usaria algo como:
    -- fly_button_index = #_G.ui_elements + 1
    -- _G.add_ui_element('button', x, y, width, height, initial_text, toggle_fly_mode)
    
    print(string.format("\n[Botão de Voo Criado em X:%d, Y:%d]", x, y))
    
    -- Chamamos a função de atualização para garantir que o texto inicial esteja correto
    update_fly_button_text() 
end

-- 6. EXEMPLO DE USO / SIMULAÇÃO DE CLIQUE

-- Simular a criação do botão (para fins de demonstração)
create_fly_button()

print("\n--- Simulação de um clique: Ligar Voo ---")
toggle_fly_mode() 

print("\n--- Simulação de outro clique: Desligar Voo ---")
toggle_fly_mode() 
-- Notificação de Sucesso
Rayfield:Notify({
   Title = "Sucesso!",
   Content = "O script foi carregado com sucesso.",
   Duration = 5,
   Image = 4483362458,
})
