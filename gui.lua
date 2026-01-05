
local menu_aberto = false -- Estado do painel (aberto/fechado)

-- Variáveis de Funções
local esp_ativado = false
local esp_distancia = 200 -- Distância máxima para renderizar ESP

local fov_ativado = false
local fov_valor = 90 -- Valor do FOV desejado

-- ===================================
--           Configurações de Tecla
-- ===================================

-- Esta função precisa ser adaptada para como seu jogo lida com o input de teclado.
function OnKeyPress(key)
    -- Exemplo: Se a tecla 'INSERT' (ou outra tecla) for pressionada
    if key == "INSERT" or key == 45 then 
        menu_aberto = not menu_aberto -- Inverte o estado
    end
end

-- ===================================
--           Função de Renderização da GUI
-- ===================================

function RenderGUI()
    -- Verifica se o menu está aberto
    if not menu_aberto then
        return
    end

    -- Inicia a Janela da GUI (usando uma função de exemplo)
    -- Os parâmetros seriam: Título, Posição X, Posição Y, Largura, Altura
    if GUI.BeginWindow("🚀 Painel Flutuante", 50, 50, 300, 200) then
        
        GUI.Text("--- Funções de Visualização ---")
        
        -- 1. Checkbox para ESP
        if GUI.Checkbox("🔍 Visualização Aprimorada (ESP)", esp_ativado) then
            esp_ativado = not esp_ativado
        end
        
        -- Slider para configurar a distância do ESP (só visível se o ESP estiver ativo)
        if esp_ativado then
            -- Note: O controle deslizante (Slider) precisa de uma função para atualizar 'esp_distancia'
            esp_distancia = GUI.Slider("Distância Máx.", esp_distancia, 50, 500)
            GUI.Text("Distância: " .. math.floor(esp_distancia) .. "m")
        end
        
        GUI.Separator() -- Linha divisória
        
        -- 2. Checkbox para FOV
        if GUI.Checkbox("📐 Campo de Visão (FOV)", fov_ativado) then
            fov_ativado = not fov_ativado
        end
        
        -- Slider para configurar o valor do FOV
        if fov_ativado then
            -- O slider atualiza 'fov_valor'
            fov_valor = GUI.Slider("Valor do FOV", fov_valor, 60, 150)
            GUI.Text("FOV: " .. math.floor(fov_valor) .. "°")
        end
        
        GUI.EndWindow() -- Fecha a Janela
    end
end

-- ===================================
--           Função Principal do Jogo (Loop de Atualização)
-- ===================================

function OnGameUpdate()
    
    -- --- Lógica do FOV ---
    if fov_ativado then
        -- Assume que 'Game.SetFOV(value)' existe para mudar o FOV.
        Game.SetFOV(fov_valor)
    else
        -- Opcional: Voltar ao FOV padrão quando desativado
        Game.SetFOV(Game.DefaultFOV()) 
    end
    
    -- --- Lógica do ESP ---
    if esp_ativado then
        -- 1. Obter todos os jogadores no mapa
        local players = Game.GetPlayers() -- Assume que esta função retorna uma lista
        
        for i, player in ipairs(players) do
            -- 2. Verificar distância e se o jogador está vivo
            local dist = Game.GetDistance(Game.LocalPlayer(), player)
            
            if dist <= esp_distancia and player.IsAlive and not player.IsLocalPlayer then
                -- 3. Renderizar o ESP (Exemplo: um box 2D ou 3D)
                local screen_pos = Game.WorldToScreen(player.Position)
                
                -- Exemplo de desenho: caixa retangular na tela
                if screen_pos.IsValid then
                    Draw.Box(screen_pos.X, screen_pos.Y, player.Width, player.Height, {0, 255, 0, 255}) -- Verde
                end
            end
        end
    end
end

-- ===================================
--           Registro de Funções
-- ===================================

-- Registra as funções nos "Hooks" do framework de scripting
-- Você precisará adaptar os nomes das funções de hook!

-- Seu framework de scripting deve ter funções como estas:
-- RegisterHook("OnRender", RenderGUI)       -- Chamado toda vez que o frame é renderizado
-- RegisterHook("OnUpdate", OnGameUpdate)     -- Chamado no loop de atualização do jogo
-- RegisterHook("OnInput", OnKeyPress)        -- Chamado quando há input de teclado

