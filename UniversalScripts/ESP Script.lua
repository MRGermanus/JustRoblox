--Hi! Cool ESP, credits to Germanus
--Second script that i ever made for executors

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse()

local ESP_SETTINGS = {
    BoxEnabled = true,          
    BoxColor = Color3.fromRGB(255, 50, 50),  
    BoxThickness = 2,            
    
    NameEnabled = true,          
    NameColor = Color3.fromRGB(255, 255, 255),
    
    HealthEnabled = true,        
    HealthBarEnabled = true,     
    
    DistanceEnabled = true,      
    DistanceColor = Color3.fromRGB(200, 200, 200),
    
    PredictionEnabled = false,    
    PredictionColor = Color3.fromRGB(255, 100, 0),
    PredictionDotSize = 8,       
    
    TracerEnabled = false,       
    TracerColor = Color3.fromRGB(255, 0, 0),
    
    ShowOnlyWhenAlive = true,    
    
    MaxDistance = 1000,          
    ShowTeam = false,            
}

local espObjects = {}
local playersHistory = {}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESP_System"
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
screenGui.IgnoreGuiInset = true

local controlPanel = Instance.new("Frame")
controlPanel.Size = UDim2.new(0, 220, 0, 280)
controlPanel.Position = UDim2.new(0, 10, 0.5, -140)
controlPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
controlPanel.BackgroundTransparency = 0.15
controlPanel.BorderSizePixel = 1
controlPanel.BorderColor3 = Color3.fromRGB(0, 200, 255)
controlPanel.Active = true
controlPanel.Draggable = true
controlPanel.Visible = true
controlPanel.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
title.Text = "ESP By Germanus"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 15
title.Font = Enum.Font.GothamBold
title.Parent = controlPanel


local toggleBoxBtn = Instance.new("TextButton")
toggleBoxBtn.Size = UDim2.new(0.9, 0, 0, 30)
toggleBoxBtn.Position = UDim2.new(0.05, 0, 0, 40)
toggleBoxBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
toggleBoxBtn.Text = "Show USP is enabled"
toggleBoxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBoxBtn.TextSize = 12
toggleBoxBtn.Parent = controlPanel

local toggleNameBtn = Instance.new("TextButton")
toggleNameBtn.Size = UDim2.new(0.9, 0, 0, 30)
toggleNameBtn.Position = UDim2.new(0.05, 0, 0, 75)
toggleNameBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
toggleNameBtn.Text = "Show Nickname is enabled"
toggleNameBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleNameBtn.TextSize = 12
toggleNameBtn.Parent = controlPanel

local toggleHealthBtn = Instance.new("TextButton")
toggleHealthBtn.Size = UDim2.new(0.9, 0, 0, 30)
toggleHealthBtn.Position = UDim2.new(0.05, 0, 0, 110)
toggleHealthBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
toggleHealthBtn.Text = "Show Health is enable"
toggleHealthBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleHealthBtn.TextSize = 12
toggleHealthBtn.Parent = controlPanel

local togglePredictionBtn = Instance.new("TextButton")
togglePredictionBtn.Size = UDim2.new(0.9, 0, 0, 30)
togglePredictionBtn.Position = UDim2.new(0.05, 0, 0, 145)
togglePredictionBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
togglePredictionBtn.Text = "test function is enabled "
togglePredictionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
togglePredictionBtn.TextSize = 12
togglePredictionBtn.Parent = controlPanel

local toggleTracerBtn = Instance.new("TextButton")
toggleTracerBtn.Size = UDim2.new(0.9, 0, 0, 30)
toggleTracerBtn.Position = UDim2.new(0.05, 0, 0, 180)
toggleTracerBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
toggleTracerBtn.Text = "Tracer is disabled"
toggleTracerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleTracerBtn.TextSize = 12
toggleTracerBtn.Parent = controlPanel


local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0.9, 0, 0, 35)
closeBtn.Position = UDim2.new(0.05, 0, 1, -45)
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
closeBtn.Text = "Close menu"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Parent = controlPanel

local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(0, 260, 0, 30)
statusBar.Position = UDim2.new(1, -270, 0, 10)
statusBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
statusBar.BackgroundTransparency = 0.6
statusBar.BorderSizePixel = 1
statusBar.BorderColor3 = Color3.fromRGB(0, 255, 0)
statusBar.Parent = screenGui

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, 0, 1, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "ESP is active | " .. #Players:GetPlayers() .. " players"
statusText.TextColor3 = Color3.fromRGB(0, 255, 0)
statusText.TextSize = 12
statusText.Font = Enum.Font.GothamBold
statusText.Parent = statusBar

local function createEspObject(player)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 100, 0, 100)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = screenGui
    frame.ZIndex = 10
    
    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 0, 0, 0)
    box.BackgroundTransparency = 0.7
    box.BorderSizePixel = ESP_SETTINGS.BoxThickness
    box.BorderColor3 = ESP_SETTINGS.BoxColor
    box.Visible = ESP_SETTINGS.BoxEnabled
    box.Parent = frame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 100, 0, 16)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = ESP_SETTINGS.NameColor
    nameLabel.TextSize = 11
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Visible = ESP_SETTINGS.NameEnabled
    nameLabel.Parent = frame
    
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(0, 80, 0, 14)
    healthLabel.BackgroundTransparency = 1
    healthLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    healthLabel.TextSize = 10
    healthLabel.Visible = ESP_SETTINGS.HealthEnabled
    healthLabel.Parent = frame
    
    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(0, 0, 0, 3)
    healthBar.Position = UDim2.new(0, 0, 1, 2)
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthBar.BorderSizePixel = 0
    healthBar.Visible = ESP_SETTINGS.HealthBarEnabled
    healthBar.Parent = frame
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(0, 60, 0, 12)
    distanceLabel.Position = UDim2.new(0, 0, 1, 18)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = ESP_SETTINGS.DistanceColor
    distanceLabel.TextSize = 9
    distanceLabel.Visible = ESP_SETTINGS.DistanceEnabled
    distanceLabel.Parent = frame
    
    local predictionDot = Instance.new("Frame")
    predictionDot.Size = UDim2.new(0, ESP_SETTINGS.PredictionDotSize, 0, ESP_SETTINGS.PredictionDotSize)
    predictionDot.BackgroundColor3 = ESP_SETTINGS.PredictionColor
    predictionDot.BackgroundTransparency = 0.3
    predictionDot.BorderSizePixel = 1
    predictionDot.BorderColor3 = Color3.fromRGB(255, 255, 255)
    predictionDot.Visible = ESP_SETTINGS.PredictionEnabled
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = predictionDot
    predictionDot.Parent = screenGui
    
    return {
        frame = frame,
        box = box,
        nameLabel = nameLabel,
        healthLabel = healthLabel,
        healthBar = healthBar,
        distanceLabel = distanceLabel,
        predictionDot = predictionDot
    }
end

local function getTargetVelocity(character, playerName)
    if not character then return Vector3.new(0, 0, 0) end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return Vector3.new(0, 0, 0) end
    
    local currentPos = rootPart.Position
    local currentTime = tick()
    local velocity = rootPart.Velocity
    
    if not playersHistory[playerName] then
        playersHistory[playerName] = {}
    end
    
    local history = playersHistory[playerName]
    table.insert(history, {pos = currentPos, time = currentTime, vel = velocity})
    
    while #history > 10 do
        table.remove(history, 1)
    end
    
    if velocity.Magnitude < 0.5 and #history >= 3 then
        local velSum = Vector3.new(0, 0, 0)
        local count = 0
        for i = #history, 2, -1 do
            local dt = history[i].time - history[i-1].time
            if dt > 0 and dt < 0.2 then
                velSum = velSum + ((history[i].pos - history[i-1].pos) / dt)
                count = count + 1
            end
        end
        if count > 0 then
            velocity = velSum / count
        end
    end
    
    return velocity
end

local function calculatePrediction(targetPos, targetVel, projectileSpeed)
    local shooterPos = Camera.CFrame.Position
    local distance = (targetPos - shooterPos).Magnitude
    local travelTime = distance / projectileSpeed
    
    if travelTime > 2 then return nil end
    
    local ping = localPlayer:GetNetworkPing()
    local predictedPos = targetPos + (targetVel * (travelTime + ping))
    
    return predictedPos
end

local function updateESP()
    local playersCount = 0
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local character = player.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChild("Humanoid")
            
            local isAlive = humanoid and humanoid.Health > 0
            if ESP_SETTINGS.ShowOnlyWhenAlive and not isAlive then
                if espObjects[player] then
                    espObjects[player].frame.Visible = false
                    espObjects[player].predictionDot.Visible = false
                end
                continue
            end
            
            if rootPart and humanoid then
                playersCount = playersCount + 1
                
                local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
                
                if onScreen and distance <= ESP_SETTINGS.MaxDistance and screenPos.Z > 0 then
                    
                    if not espObjects[player] then
                        espObjects[player] = createEspObject(player)
                    end
                    
                    local esp = espObjects[player]
                    
                    local size = character:GetExtentsSize()
                    local height = size.Y * 1.5
                    local width = size.X * 1.2
                    
                    local topPoint = Camera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, height/2, 0))
                    local bottomPoint = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, height/2, 0))
                    local boxHeight = math.abs(topPoint.Y - bottomPoint.Y)
                    local boxWidth = boxHeight * 0.6
                    
                    local x = screenPos.X - boxWidth / 2
                    local y = topPoint.Y
                    
                    if ESP_SETTINGS.BoxEnabled then
                        esp.box.Visible = true
                        esp.box.Size = UDim2.new(0, boxWidth, 0, boxHeight)
                        esp.box.Position = UDim2.new(0, x, 0, y)
                        
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        esp.box.BorderColor3 = Color3.fromRGB(
                            255 * (1 - healthPercent),
                            255 * healthPercent,
                            0
                        )
                    else
                        esp.box.Visible = false
                    end
                    
                    if ESP_SETTINGS.NameEnabled then
                        esp.nameLabel.Visible = true
                        esp.nameLabel.Text = player.Name
                        esp.nameLabel.Position = UDim2.new(0, x + boxWidth/2 - 40, 0, y - 18)
                    end
                    
                    if ESP_SETTINGS.HealthEnabled then
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        esp.healthLabel.Visible = true
                        esp.healthLabel.Text = string.format("❤️ %.0f%%", healthPercent * 100)
                        esp.healthLabel.Position = UDim2.new(0, x + boxWidth/2 - 30, 0, y + boxHeight + 2)
                        esp.healthLabel.TextColor3 = Color3.fromRGB(
                            255 * (1 - healthPercent),
                            255 * healthPercent,
                            0
                        )
                    end
                    
                    if ESP_SETTINGS.HealthBarEnabled then
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        esp.healthBar.Visible = true
                        esp.healthBar.Size = UDim2.new(0, boxWidth * healthPercent, 0, 3)
                        esp.healthBar.Position = UDim2.new(0, x, 0, y + boxHeight + 16)
                        esp.healthBar.BackgroundColor3 = Color3.fromRGB(
                            255 * (1 - healthPercent),
                            255 * healthPercent,
                            0
                        )
                    end
                    
                    if ESP_SETTINGS.DistanceEnabled then
                        esp.distanceLabel.Visible = true
                        esp.distanceLabel.Text = string.format("%.0f studs", distance)
                        esp.distanceLabel.Position = UDim2.new(0, x + boxWidth/2 - 25, 0, y + boxHeight + 28)
                    end
                    
                    if ESP_SETTINGS.PredictionEnabled then
                        local velocity = getTargetVelocity(character, player.Name)
                        local speed = velocity.Magnitude
                        
                        if speed > 5 then 
                            local predictedPos = calculatePrediction(rootPart.Position, velocity, 150)
                            if predictedPos then
                                local predScreenPos = Camera:WorldToViewportPoint(predictedPos)
                                if predScreenPos.Z > 0 then
                                    esp.predictionDot.Visible = true
                                    esp.predictionDot.Position = UDim2.new(0, predScreenPos.X - ESP_SETTINGS.PredictionDotSize/2, 0, predScreenPos.Y - ESP_SETTINGS.PredictionDotSize/2)
                                    
                                    local dotSize = ESP_SETTINGS.PredictionDotSize + math.min(speed / 20, 10)
                                    esp.predictionDot.Size = UDim2.new(0, dotSize, 0, dotSize)
                                else
                                    esp.predictionDot.Visible = false
                                end
                            else
                                esp.predictionDot.Visible = false
                            end
                        else
                            esp.predictionDot.Visible = false
                        end
                    end
                    
                    if ESP_SETTINGS.TracerEnabled then
                    --test function it do nothing
                    end
                    
                    esp.frame.Visible = true
                    
                else
                    if espObjects[player] then
                        espObjects[player].frame.Visible = false
                        if espObjects[player].predictionDot then
                            espObjects[player].predictionDot.Visible = false
                        end
                    end
                end
            else
                if espObjects[player] then
                    espObjects[player].frame.Visible = false
                    if espObjects[player].predictionDot then
                        espObjects[player].predictionDot.Visible = false
                    end
                end
            end
        end
    end
    
    statusText.Text = string.format("ESP ACTIVE | %d players | Range: %.0f", playersCount, ESP_SETTINGS.MaxDistance)
end


local menuVisible = true

toggleBoxBtn.MouseButton1Click:Connect(function()
    ESP_SETTINGS.BoxEnabled = not ESP_SETTINGS.BoxEnabled
    toggleBoxBtn.Text = ESP_SETTINGS.BoxEnabled and "Box Enabled" or "Box Disabled"
    for _, esp in pairs(espObjects) do
        esp.box.Visible = ESP_SETTINGS.BoxEnabled
    end
end)

toggleNameBtn.MouseButton1Click:Connect(function()
    ESP_SETTINGS.NameEnabled = not ESP_SETTINGS.NameEnabled
    toggleNameBtn.Text = ESP_SETTINGS.NameEnabled and "Nickname Enabled" or "Nickname Disabled"
end)

toggleHealthBtn.MouseButton1Click:Connect(function()
    ESP_SETTINGS.HealthEnabled = not ESP_SETTINGS.HealthEnabled
    ESP_SETTINGS.HealthBarEnabled = ESP_SETTINGS.HealthEnabled
    toggleHealthBtn.Text = ESP_SETTINGS.HealthEnabled and "Show Health enabled" or "Show Health disabled"
end)

togglePredictionBtn.MouseButton1Click:Connect(function()
    ESP_SETTINGS.PredictionEnabled = not ESP_SETTINGS.PredictionEnabled
    togglePredictionBtn.Text = ESP_SETTINGS.PredictionEnabled and "test func enabled" or "test func disabled"
    if not ESP_SETTINGS.PredictionEnabled then
        for _, esp in pairs(espObjects) do
            if esp.predictionDot then
                esp.predictionDot.Visible = false
            end
        end
    end
end)

toggleTracerBtn.MouseButton1Click:Connect(function()
    ESP_SETTINGS.TracerEnabled = not ESP_SETTINGS.TracerEnabled
    toggleTracerBtn.Text = ESP_SETTINGS.TracerEnabled and "Tracer enabled" or "Tracer disabled"
end)

closeBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    controlPanel.Visible = menuVisible
    closeBtn.Text = menuVisible and "Close menu" or "Show menu"
end)

Players.PlayerRemoving:Connect(function(player)
    if espObjects[player] then
        espObjects[player].frame:Destroy()
        if espObjects[player].predictionDot then
            espObjects[player].predictionDot:Destroy()
        end
        espObjects[player] = nil
    end
end)

local function cleanupHistory()
    for name, history in pairs(playersHistory) do
        local player = Players:FindFirstChild(name)
        if not player or not player.Character then
            playersHistory[name] = nil
        end
    end
end

RunService.RenderStepped:Connect(function()
    updateESP()
    cleanupHistory()
end)

print("Loaded ESP")
print("Enjoy!")
