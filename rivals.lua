local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local guiEnabled = true
local espEnabled = false
local aimbotEnabled = false

local themes = {
    Purple = {bg = Color3.fromRGB(30,20,50), stroke = Color3.fromRGB(180,100,255), title = Color3.fromRGB(200,120,255), text = Color3.fromRGB(220,220,255), btnIdle = Color3.fromRGB(50,40,70), btnActive = Color3.fromRGB(90,50,120), btnText = Color3.fromRGB(220,180,255), fovColor = Color3.fromRGB(180,100,255)},
    Orange = {bg = Color3.fromRGB(50,30,20), stroke = Color3.fromRGB(255,160,60), title = Color3.fromRGB(255,180,80), text = Color3.fromRGB(255,220,180), btnIdle = Color3.fromRGB(70,45,30), btnActive = Color3.fromRGB(120,70,40), btnText = Color3.fromRGB(255,200,140), fovColor = Color3.fromRGB(255,160,60)},
    Blue = {bg = Color3.fromRGB(15,20,40), stroke = Color3.fromRGB(80,150,255), title = Color3.fromRGB(120,180,255), text = Color3.fromRGB(200,220,255), btnIdle = Color3.fromRGB(25,35,70), btnActive = Color3.fromRGB(40,70,120), btnText = Color3.fromRGB(180,200,255), fovColor = Color3.fromRGB(100,160,255)}
}

local currentThemeName = "Purple"
local currentTheme = themes[currentThemeName]

local AimbotSettings = {
    TeamCheck = true,
    WallCheck = true, 
    FOV = 120,
    Smoothness = 0.2, 
    Part = "Head",
    Prediction = 0.01, 
    UseMouse = true
}

local function applyTheme(theme)
    currentTheme = theme
    MainFrame.BackgroundColor3 = theme.bg
    UIStroke.Color = theme.stroke
    Title.TextColor3 = theme.title
    Stats.TextColor3 = theme.text
    HintLabel.TextColor3 = theme.text
    WatermarkLabel.TextColor3 = theme.text
    ESPBtn.BackgroundColor3 = espEnabled and theme.btnActive or theme.btnIdle
    ESPBtn.TextColor3 = theme.btnText
    AimbotBtn.BackgroundColor3 = aimbotEnabled and theme.btnActive or theme.btnIdle
    AimbotBtn.TextColor3 = theme.btnText
    DiscordBtn.BackgroundColor3 = theme.btnIdle
    DiscordBtn.TextColor3 = theme.btnText
    ThemeBtn.BackgroundColor3 = theme.btnIdle
    ThemeBtn.TextColor3 = theme.btnText
    HideBtn.BackgroundColor3 = theme.btnIdle
    HideBtn.TextColor3 = theme.btnText
    if fovCircle then
        fovCircle.Color = theme.fovColor
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Taka1337FreeCheat"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 290)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -145)
MainFrame.BackgroundColor3 = currentTheme.bg
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = currentTheme.stroke
UIStroke.Thickness = 3
UIStroke.Transparency = 0.3
UIStroke.Parent = MainFrame

local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    local newPositionX = startPos.X.Offset + delta.X
    local newPositionY = startPos.Y.Offset + delta.Y
    
    MainFrame.Position = UDim2.new(
        startPos.X.Scale,
        newPositionX,
        startPos.Y.Scale,
        newPositionY
    )
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Position = UDim2.new(0, 0, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "ZKIZ's cheat"
Title.TextColor3 = currentTheme.title
Title.TextSize = 18
Title.Font = Enum.Font.GothamBlack
Title.TextStrokeTransparency = 0.7
Title.TextStrokeColor3 = Color3.new(0,0,0)
Title.TextWrapped = true
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = MainFrame

local Stats = Instance.new("TextLabel")
Stats.Size = UDim2.new(1, -20, 0, 40)
Stats.Position = UDim2.new(0, 10, 0, 80)
Stats.BackgroundTransparency = 1
Stats.Text = "FPS: ...\nPing: ... ms"
Stats.TextColor3 = currentTheme.text
Stats.TextSize = 14
Stats.Font = Enum.Font.Gotham
Stats.TextXAlignment = Enum.TextXAlignment.Left
Stats.TextYAlignment = Enum.TextYAlignment.Top
Stats.Parent = MainFrame

local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0.9, 0, 0, 32)
ESPBtn.Position = UDim2.new(0.05, 0, 0, 125)
ESPBtn.BackgroundColor3 = currentTheme.btnIdle
ESPBtn.Text = "B - ESP" 
ESPBtn.TextColor3 = currentTheme.btnText
ESPBtn.Font = Enum.Font.GothamBold
ESPBtn.TextSize = 13
ESPBtn.TextWrapped = true
ESPBtn.Parent = MainFrame

local BtnCornerESP = Instance.new("UICorner")
BtnCornerESP.CornerRadius = UDim.new(0, 8)
BtnCornerESP.Parent = ESPBtn

local AimbotBtn = Instance.new("TextButton")
AimbotBtn.Size = UDim2.new(0.9, 0, 0, 32)
AimbotBtn.Position = UDim2.new(0.05, 0, 0, 162)
AimbotBtn.BackgroundColor3 = currentTheme.btnIdle
AimbotBtn.Text = "Q - Aimbot"
AimbotBtn.TextColor3 = currentTheme.btnText
AimbotBtn.Font = Enum.Font.GothamBold
AimbotBtn.TextSize = 13
AimbotBtn.TextWrapped = true
AimbotBtn.Parent = MainFrame

local BtnCornerAim = Instance.new("UICorner")
BtnCornerAim.CornerRadius = UDim.new(0, 8)
BtnCornerAim.Parent = AimbotBtn

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(0.9, 0, 0, 32)
DiscordBtn.Position = UDim2.new(0.05, 0, 0, 199)
DiscordBtn.BackgroundColor3 = currentTheme.btnIdle
DiscordBtn.Text = "Discord Server"
DiscordBtn.TextColor3 = currentTheme.btnText
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.TextSize = 13
DiscordBtn.TextWrapped = true
DiscordBtn.Parent = MainFrame

local BtnCornerDiscord = Instance.new("UICorner")
BtnCornerDiscord.CornerRadius = UDim.new(0, 8)
BtnCornerDiscord.Parent = DiscordBtn

local ThemeBtn = Instance.new("TextButton")
ThemeBtn.Size = UDim2.new(0.9, 0, 0, 32)
ThemeBtn.Position = UDim2.new(0.05, 0, 0, 236)
ThemeBtn.BackgroundColor3 = currentTheme.btnIdle
ThemeBtn.Text = "Theme: Purple"
ThemeBtn.TextColor3 = currentTheme.btnText
ThemeBtn.Font = Enum.Font.GothamBold
ThemeBtn.TextSize = 13
ThemeBtn.TextWrapped = true
ThemeBtn.Parent = MainFrame

local BtnCornerTheme = Instance.new("UICorner")
BtnCornerTheme.CornerRadius = UDim.new(0, 8)
BtnCornerTheme.Parent = ThemeBtn

local HintLabel = Instance.new("TextLabel")
HintLabel.Size = UDim2.new(1, -20, 0, 25)
HintLabel.Position = UDim2.new(0, 10, 1, -30)
HintLabel.BackgroundTransparency = 1
HintLabel.Text = "RightShift"
HintLabel.TextColor3 = currentTheme.text
HintLabel.TextSize = 11
HintLabel.Font = Enum.Font.Gotham
HintLabel.TextWrapped = true
HintLabel.TextXAlignment = Enum.TextXAlignment.Center
HintLabel.Parent = MainFrame

local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0, 140, 0, 36)
HideBtn.Position = UDim2.new(1, -150, 0, 10)
HideBtn.AnchorPoint = Vector2.new(1, 0)
HideBtn.BackgroundColor3 = currentTheme.btnIdle
HideBtn.Text = "Hide / Show GUI"
HideBtn.TextColor3 = currentTheme.btnText
HideBtn.Font = Enum.Font.GothamBold
HideBtn.TextSize = 14
HideBtn.Parent = ScreenGui

local HideCorner = Instance.new("UICorner")
HideCorner.CornerRadius = UDim.new(0, 10)
HideCorner.Parent = HideBtn

local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.NumSides = 100
fovCircle.Radius = AimbotSettings.FOV
fovCircle.Filled = false
fovCircle.Transparency = 0.75
fovCircle.Visible = false
fovCircle.Color = currentTheme.fovColor

RunService.RenderStepped:Connect(function()
    fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
end)

-- Функция для копирования Discord ссылки
local function copyDiscordLink()
    -- Пытаемся скопировать в буфер обмена
    pcall(function()
        -- Для Synapse X и других исполнителей
        if setclipboard then
            setclipboard("https://discord.gg/A4GSu4KDU3")
            
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Discord Server",
                Text = "Ссылка скопирована в буфер обмена!\nhttps://discord.gg/A4GSu4KDU3",
                Duration = 5,
                Icon = "rbxassetid://3222877"
            })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Discord Server",
                Text = "Ссылка: https://discord.gg/A4GSu4KDU3",
                Duration = 5,
                Icon = "rbxassetid://3222877"
            })
        end
    end)
    
    pcall(function()
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Join our Discord: https://discord.gg/3JMgTcKmCN", "All")
    end)
end

DiscordBtn.MouseButton1Click:Connect(copyDiscordLink)

local function GetClosestTarget()
    if not LocalPlayer.Character then return nil end
    
    local closest = nil
    local shortestDistance = AimbotSettings.FOV
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not player.Character then continue end
        
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end
        
        if AimbotSettings.TeamCheck and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then continue end
        
        local targetPart = player.Character:FindFirstChild(AimbotSettings.Part)
        if not targetPart then continue end
        
        local partPos = targetPart.Position
        
        if player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            partPos = partPos + (hrp.Velocity * AimbotSettings.Prediction)
        end
        
        local screenPos, onScreen = Camera:WorldToViewportPoint(partPos)
        
        if onScreen then
            local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
            
            if distance < shortestDistance then
                shortestDistance = distance
                closest = targetPart
            end
        end
    end
    
    return closest
end

local aimbotConnection
local function StartAimbot()
    if aimbotConnection then aimbotConnection:Disconnect() end
    
    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not aimbotEnabled or not LocalPlayer.Character then return end
        
        local target = GetClosestTarget()
        if target then
            local targetPosition = target.Position
            
            -- Добавляем предсказание
            if target.Parent:FindFirstChild("HumanoidRootPart") then
                local hrp = target.Parent.HumanoidRootPart
                targetPosition = targetPosition + (hrp.Velocity * AimbotSettings.Prediction)
            end
            
            -- Конвертируем мировые координаты в экранные
            local screenPoint = Camera:WorldToScreenPoint(targetPosition)
            
            -- Перемещаем курсор к цели с плавностью
            if screenPoint.Z > 0 then
                local newMousePos = Vector2.new(screenPoint.X, screenPoint.Y)
                local delta = newMousePos - Vector2.new(Mouse.X, Mouse.Y)
                local smoothedDelta = delta * AimbotSettings.Smoothness
                mousemoverel(smoothedDelta.X, smoothedDelta.Y)
            end
        end
    end)
end

local function StopAimbot()
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
end

-- Toggle функции
local function toggleESP()
    espEnabled = not espEnabled
    if not espEnabled then 
        clearAllESP() 
    end
    ESPBtn.BackgroundColor3 = espEnabled and currentTheme.btnActive or currentTheme.btnIdle
end

ESPBtn.MouseButton1Click:Connect(toggleESP)

local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    fovCircle.Visible = aimbotEnabled
    AimbotBtn.BackgroundColor3 = aimbotEnabled and currentTheme.btnActive or currentTheme.btnIdle
    
    if aimbotEnabled then
        StartAimbot()
    else
        StopAimbot()
    end
end

AimbotBtn.MouseButton1Click:Connect(toggleAimbot)

-- Смена темы
local themeOrder = {"Purple", "Orange", "Blue"}
local themeIndex = 1

ThemeBtn.MouseButton1Click:Connect(function()
    themeIndex = (themeIndex % #themeOrder) + 1
    currentThemeName = themeOrder[themeIndex]
    ThemeBtn.Text = "Theme: " .. currentThemeName
    applyTheme(themes[currentThemeName])
end)

-- Hide/Show GUI
HideBtn.MouseButton1Click:Connect(function()
    guiEnabled = not guiEnabled
    MainFrame.Visible = guiEnabled
end)

-- Клавиши
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.B then 
        toggleESP()
    elseif input.KeyCode == Enum.KeyCode.Q then 
        toggleAimbot()
    elseif input.KeyCode == Enum.KeyCode.RightShift then
        guiEnabled = not guiEnabled
        MainFrame.Visible = guiEnabled
    elseif aimbotEnabled then
        if input.KeyCode == Enum.KeyCode.E then
            AimbotSettings.FOV = math.clamp(AimbotSettings.FOV + 10, 50, 300)
            fovCircle.Radius = AimbotSettings.FOV
        elseif input.KeyCode == Enum.KeyCode.R then
            AimbotSettings.FOV = math.clamp(AimbotSettings.FOV - 10, 50, 300)
            fovCircle.Radius = AimbotSettings.FOV
        end
    end
end)

-- ESP
local function clearAllESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("Head") then
            local esp = plr.Character.Head:FindFirstChild("TakaESP")
            if esp then esp:Destroy() end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if not espEnabled then
        clearAllESP()
        return
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not plr.Character or not plr.Character:FindFirstChild("Head") then 
            continue 
        end
        local head = plr.Character.Head
        if not head:FindFirstChild("TakaESP") then
            local bb = Instance.new("BillboardGui")
            bb.Name = "TakaESP"
            bb.Adornee = head
            bb.Size = UDim2.new(0, 200, 0, 50)
            bb.StudsOffset = Vector3.new(0, 4.2, 0)
            bb.AlwaysOnTop = true
            bb.LightInfluence = 0
            bb.Parent = head
            
            local txt = Instance.new("TextLabel")
            txt.Size = UDim2.new(1, 0, 1, 0)
            txt.BackgroundTransparency = 1
            txt.Text = plr.Name
            txt.TextColor3 = currentTheme.title
            txt.TextStrokeTransparency = 0.4
            txt.TextStrokeColor3 = Color3.new(0, 0, 0)
            txt.Font = Enum.Font.GothamBlack
            txt.TextSize = 18
            txt.TextWrapped = true
            txt.Parent = bb
        end
    end
end)

-- FPS + Ping
local lastTick = tick()
RunService.RenderStepped:Connect(function()
    local dt = tick() - lastTick
    lastTick = tick()
    local fps = math.floor(1 / dt + 0.5)
    local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000 + 0.5) or "???"
    Stats.Text = "FPS: " .. fps .. "\nPing: " .. ping .. " ms"
end)

-- Очистка при выходе игрока
Players.PlayerRemoving:Connect(function(plr)
    if plr.Character and plr.Character:FindFirstChild("Head") then
        local esp = plr.Character.Head:FindFirstChild("TakaESP")
        if esp then esp:Destroy() end
    end
end)

-- Очистка при удалении персонажа
LocalPlayer.CharacterRemoving:Connect(function()
    clearAllESP()
    if aimbotEnabled then StopAimbot() end
end)

-- Применяем начальную тему
applyTheme(currentTheme)

print("ZKIZ's cheat loaded | B - ESP | Q - Aimbot | RightShift - Menu")
print("Join Discord: https://discord.gg/A4GSu4KDU3")