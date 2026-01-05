--[[
  PAINEL DE UI INTERATIVO BÁSICO EM LUA
  
  Estrutura:
  - 'ui_elements' armazena botões, campos de texto, etc.
  - Funções para Manipulação (Adicionar, Desenhar, Clicar).
  - Um espaço para 'Funções de Ação' que são chamadas quando um botão é pressionado.
  
  NOTA: Este código é genérico. Ele precisará de uma biblioteca de UI
  ou framework (como LÖVE2D ou um ambiente de jogo) para desenhar
  os retângulos e textos na tela e detectar cliques de mouse.
]]--

-- 1. ESTRUTURA DE DADOS DO PAINEL
local ui_elements = {}

-- 2. VARIÁVEL DE ESTADO DA UI (Opcional, útil para mostrar/esconder o painel)
local is_panel_visible = true

-- --- LUGAR PARA COLOCAR CÓDIGOS DE FUNÇÕES DE AÇÃO ---

-- 3. FUNÇÕES DE AÇÃO (As funções chamadas pelos botões do painel)
-- Por favor, adicione suas funções de ação aqui.

function my_action_function_1()
    print("Ação 1 Executada: O botão 'Ação Principal' foi pressionado!")
    -- **[SEU CÓDIGO PERSONALIZADO PARA AÇÃO 1 VAI AQUI]**
    -- Exemplo: Abrir um menu, mudar uma variável de jogo, etc.
end

function my_action_function_2(param1)
    print("Ação 2 Executada: O botão 'Ação Secundária' foi pressionado com parâmetro: " .. tostring(param1))
    -- **[SEU CÓDIGO PERSONALIZADO PARA AÇÃO 2 VAI AQUI]**
    -- Exemplo: Salvar o jogo, fechar a UI, etc.
end

-- --- FIM DAS FUNÇÕES DE AÇÃO ---

-- 4. FUNÇÕES DE MANIPULAÇÃO DA UI

-- Função para adicionar um elemento (como um botão) ao painel
function add_ui_element(type, x, y, width, height, text, action_func)
    local element = {
        type = type,       -- 'button', 'label', 'textbox', etc.
        x = x,             -- Posição X
        y = y,             -- Posição Y
        width = width,     -- Largura
        height = height,   -- Altura
        text = text,       -- Texto exibido
        action = action_func -- A função de ação a ser chamada (nil para labels)
    }
    table.insert(ui_elements, element)
end

-- Função que simula o desenho/renderização do painel (Dependente do Framework!)
function draw_ui()
    if not is_panel_visible then return end

    -- 

    -- Exemplo conceitual de como o painel principal seria desenhado
    print("--- Desenhando Painel Principal (Conceitual) ---")
    -- Você usaria draw.rectangle ou similar aqui no seu framework
    
    for _, element in ipairs(ui_elements) do
        if element.type == 'button' then
            -- Conceito: Desenhar Retângulo do Botão em (x, y) com (width, height)
            print(string.format("  [Botão]: (%d, %d) - %s", element.x, element.y, element.text))
            
            -- Conceito: Desenhar Texto do Botão (element.text)
        elseif element.type == 'label' then
            -- Conceito: Desenhar Texto do Label
            print(string.format("  [Label]: (%d, %d) - %s", element.x, element.y, element.text))
        end
    end
    print("---------------------------------------------")
end

-- Função que simula a detecção de clique em um elemento
function handle_click(mouse_x, mouse_y)
    if not is_panel_visible then return end

    for _, element in ipairs(ui_elements) do
        if element.type == 'button' then
            -- Verifica se o clique está dentro dos limites do botão
            if mouse_x >= element.x and mouse_x <= element.x + element.width and
               mouse_y >= element.y and mouse_y <= element.y + element.height then
                
                print("Botão clicado: " .. element.text)
                
                -- Se houver uma função de ação, chame-a!
                if element.action and type(element.action) == 'function' then
                    -- Você pode passar parâmetros se quiser
                    element.action() 
                end
                
                -- Parar a busca depois de encontrar o elemento clicado
                return true
            end
        end
    end
    return false
end

-- 5. INICIALIZAÇÃO E MONTAGEM DO PAINEL

-- Limpa os elementos existentes
ui_elements = {}

-- Adicionar um título/rótulo
add_ui_element('label', 10, 10, 200, 30, "Menu Principal do Jogo/App")

-- Adicionar o Botão 1, chamando my_action_function_1
add_ui_element('button', 10, 50, 180, 40, "Ação Principal", my_action_function_1)

-- Adicionar o Botão 2, chamando my_action_function_2 (poderia ser uma função anônima ou passar parâmetros)
-- Neste exemplo, chamo my_action_function_2 dentro de uma função anônima para passar um parâmetro.
add_ui_element('button', 10, 100, 180, 40, "Ação Secundária", function() my_action_function_2("Feito!") end)

-- Adicionar um botão para esconder o painel
add_ui_element('button', 10, 150, 180, 40, "Toggle Painel", function() is_panel_visible = not is_panel_visible end)


-- 6. EXEMPLO DE USO (Simulando o loop principal)

print("--- Inicialização do Painel Concluída ---")
draw_ui() -- Desenha o estado inicial

print("\n--- Simulação de um clique no botão 'Ação Principal' ---")
handle_click(20, 60) -- Coordenadas (20, 60) estão dentro do Botão 1 (10, 50 até 190, 90)

print("\n--- Simulação de um clique no botão 'Ação Secundária' ---")
handle_click(150, 110) -- Coordenadas (150, 110) estão dentro do Botão 2 (10, 100 até 190, 140)

print("\n--- Simulação de um clique no botão 'Toggle Painel' ---")
handle_click(50, 160)
draw_ui() -- O painel não deve mais desenhar nada

print("\n--- Simulação de um clique FORA dos botões ---")
handle_click(500, 500)

