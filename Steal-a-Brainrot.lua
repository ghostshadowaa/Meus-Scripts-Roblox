local button = script.Parent
local player = game.Players.LocalPlayer

button.MouseButton1Click:Connect(function()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    humanoidRootPart.CFrame = CFrame.new(
        -345.083679, 0.0248937607, 113.94593,
        0, 0, -1,
        0, 1, 0,
        1, 0, 0
    )
end)