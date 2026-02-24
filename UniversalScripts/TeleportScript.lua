--Simple teleport script by GermanusRBX, enjoy!--
--and sorry for the interface, im not a good designer, at least its working--

repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.Name = "TeleportGUI"

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 200)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "TELEPORT TO PLAYER"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 20
closeBtn.Parent = title

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -20, 0, 35)
textBox.Position = UDim2.new(0, 10, 0, 45)
textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textBox.PlaceholderText = "Write nickname"
textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
textBox.Text = ""
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.Font = Enum.Font.SourceSans
textBox.TextSize = 16
textBox.Parent = mainFrame

local teleportBtn = Instance.new("TextButton")
teleportBtn.Size = UDim2.new(1, -20, 0, 40)
teleportBtn.Position = UDim2.new(0, 10, 0, 95)
teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
teleportBtn.Text = "TELEPORT"
teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportBtn.Font = Enum.Font.SourceSansBold
teleportBtn.TextSize = 18
teleportBtn.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 150)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Ready"
statusLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 14
statusLabel.Parent = mainFrame

function findPlayer(name)
    name = string.lower(name)
    for _, p in pairs(game.Players:GetPlayers()) do
        if string.find(string.lower(p.Name), name) or string.find(string.lower(p.DisplayName), name) then
            return p
        end
    end
    return nil
end

function teleportToPlayer(targetPlayer)
    if not targetPlayer then
        statusLabel.Text = "Player not found"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    if not targetPlayer.Character then
        statusLabel.Text = "Error!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then
        statusLabel.Text = "Error!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    local myChar = player.Character
    if not myChar then
        statusLabel.Text = "Error!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then
        statusLabel.Text = "Error!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 3, 0)
    statusLabel.Text = "Teleported to" .. targetPlayer.Name
    statusLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
end

teleportBtn.MouseButton1Click:Connect(function()
    local name = textBox.Text
    if name == "" then
        statusLabel.Text = "No nickname!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        return
    end
    
    local target = findPlayer(name)
    teleportToPlayer(target)
end)

textBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local target = findPlayer(textBox.Text)
        teleportToPlayer(target)
    end
end)

print("Loaded Script.")