local Rayfield = loadstring(game:HttpGet('sirius.menu'))()

local Window = Rayfield:CreateWindow({
   Name = "Rayfield Example Window",
   Icon = 0, 
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
   ShowText = "Rayfield",
   Theme = "Default", 

   ToggleUIKeybind = Enum.KeyCode.K, -- Recomendado usar Enum para melhor compatibilidade

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, 

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "KA_Hub_Config", -- Pasta criada em workspace
      FileName = "Premium Hub"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true 
   },

   KeySystem = true, -- Ativado para testar as configurações abaixo
   KeySettings = {
      Title = "KA Hub", -- Corrigido: Removida aspas extra
      Subtitle = "Key System", -- Corrigido: Adicionada vírgula antes
      Note = "A chave é: hub", 
      FileName = "KA_Key", 
      SaveKey = true, 
      GrabKeyFromSite = false,
      Key = {"hub"} 
   }
})

-- Exemplo de Notificação para confirmar que carregou
Rayfield:Notify({
   Title = "Sucesso!",
   Content = "O script foi carregado com sucesso.",
   Duration = 5,
   Image = 4483362458,
})
