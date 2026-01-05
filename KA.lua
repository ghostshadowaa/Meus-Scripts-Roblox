-- [[ KA HUB | QUEST SYSTEM UI ]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- =========================
-- WORLD CHECK (ORIGINAL)
-- =========================
if game.PlaceId == 2753915549 then
    World1 = true
elseif game.PlaceId == 4442272183 then
    World2 = true
elseif game.PlaceId == 7449423635 then
    World3 = true
else
    LocalPlayer:Kick("Do not Support, Please wait...")
end

-- =========================
-- CHECK QUEST (ORIGINAL)
-- =========================
function CheckQuest()
    MyLevel = LocalPlayer.Data.Level.Value

    if World1 then
        if MyLevel >= 1 and MyLevel <= 9 then
            Mon = "Bandit"
            LevelQuest = 1
            NameQuest = "BanditQuest1"
            NameMon = "Bandit"
            CFrameQuest = CFrame.new(1059.37, 15.44, 1550.42)
            CFrameMon = CFrame.new(1045.96, 27.00, 1560.82)

        elseif MyLevel >= 10 and MyLevel <= 14 then
            Mon = "Monkey"
            LevelQuest = 1
            NameQuest = "JungleQuest"
            NameMon = "Monkey"
            CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37)
            CFrameMon = CFrame.new(-1448.51, 67.85, 11.46)

        elseif MyLevel >= 15 and MyLevel <= 29 then
            Mon = "Gorilla"
            LevelQuest = 2
            NameQuest = "JungleQuest"
            NameMon = "Gorilla"
            CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37)
            CFrameMon = CFrame.new(-1129.88, 40.46, -525.42)

        elseif MyLevel >= 30 and MyLevel <= 39 then
            Mon = "Pirate"
            LevelQuest = 1
            NameQuest = "BuggyQuest1"
            NameMon = "Pirate"
            CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54)
            CFrameMon = CFrame.new(-1103.51, 13.75, 3896.09)

        elseif MyLevel >= 40 and MyLevel <= 59 then
            Mon = "Brute"
            LevelQuest = 2
            NameQuest = "BuggyQuest1"
            NameMon = "Brute"
            CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54)
            CFrameMon = CFrame.new(-1140.08, 14.80, 4322.92)

        elseif MyLevel >= 60 and MyLevel <= 74 then
            Mon = "Desert Bandit"
            LevelQuest = 1
            NameQuest = "DesertQuest"
            NameMon = "Desert Bandit"
            CFrameQuest = CFrame.new(894.48, 5.14, 4392.43)
            CFrameMon = CFrame.new(924.79, 6.44, 4481.58)

        elseif MyLevel >= 75 and MyLevel <= 89 then
            Mon = "Desert Officer"
            LevelQuest = 2
            NameQuest = "DesertQuest"
            NameMon = "Desert Officer"
            CFrameQuest = CFrame.new(894.48, 5.14, 4392.43)
            CFrameMon = CFrame.new(1608.28, 8.61, 4371.00)

        elseif MyLevel >= 90 and MyLevel <= 99 then
            Mon = "Snow Bandit"
            LevelQuest = 1
            NameQuest = "SnowQuest"
            NameMon = "Snow Bandit"
            CFrameQuest = CFrame.new(1389.74, 88.15, -1298.90)
            CFrameMon = CFrame.new(1354.34, 87.27, -1393.94)

        elseif MyLevel >= 100 and MyLevel <= 119 then
            Mon = "Snowman"
            LevelQuest = 2
            NameQuest = "SnowQuest"
            NameMon = "Snowman"
            CFrameQuest = CFrame.new(1389.74, 88.15, -1298.90)
            CFrameMon = CFrame.new(1201.64, 144.57, -1550.06)

        elseif MyLevel >= 120 and MyLevel <= 149 then
            Mon = "Chief Petty Officer"
            LevelQuest = 1
            NameQuest = "MarineQuest2"
            NameMon = "Chief Petty Officer"
            CFrameQuest = CFrame.new(-5039.58, 27.35, 4324.68)
            CFrameMon = CFrame.new(-4881.23, 22.65, 4273.75)

        elseif MyLevel >= 150 then
            Mon = "Sky Bandit"
            LevelQuest = 1
            NameQuest = "SkyQuest"
            NameMon = "Sky Bandit"
            CFrameQuest = CFrame.new(-4839.53, 716.36, -2619.44)
            CFrameMon = CFrame.new(-4953.20, 295.74, -2899.22)
        end
    end
end

-- =========================
-- UI RAYFIELD (SÓ PARA QUEST)
-- =========================
local Window = Rayfield:CreateWindow({
   Name = "KA HUB | Quest System",
   LoadingTitle = "CheckQuest Loader",
   LoadingSubtitle = "Blox Fruits",
   ConfigurationSaving = { Enabled = false }
})

local QuestTab = Window:CreateTab("Quest", 4483362458)

QuestTab:CreateButton({
    Name = "Ver Quest Atual",
    Callback = function()
        CheckQuest()

        Rayfield:Notify({
            Title = "Quest Detectada",
            Content =
                "Monstro: ".. tostring(Mon) ..
                "\nQuest: ".. tostring(NameQuest) ..
                "\nLevel Quest: ".. tostring(LevelQuest),
            Duration = 6
        })
    end
})

QuestTab:CreateButton({
    Name = "Teleportar para Quest",
    Callback = function()
        CheckQuest()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:PivotTo(CFrameQuest)
        end
    end
})

QuestTab:CreateButton({
    Name = "Teleportar para Monstro",
    Callback = function()
        CheckQuest()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:PivotTo(CFrameMon)
        end
    end
})

Rayfield:Notify({
    Title = "KA HUB",
    Content = "Sistema de Quest carregado com sucesso!",
    Duration = 5
})
