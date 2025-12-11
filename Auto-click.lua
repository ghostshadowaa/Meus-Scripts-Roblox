local intervalo = 0.05 -- velocidade do autoclick (quanto menor, mais rápido)
local autoClickAtivo = true -- você pode mudar isso depois

while task.wait(intervalo) do
    if autoClickAtivo then
        -- ESTA É A PARTE QUE VOCÊ DEVE MODIFICAR!
        -- O que você quer que ele “clique”?
        game:GetService("Players").LocalPlayer:ClickDetectorMouseClick() -- exemplo NÃO funcional, só placeholder
    end
end
