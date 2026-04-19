--noclip by Germanus
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer

RunService.Stepped:Connect(function()
    if Player.Character then
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)
