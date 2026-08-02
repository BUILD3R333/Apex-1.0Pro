--[[
    Project: San Diego Border RP Script (Ultimate Version)
    Features: Speed, X-Ray, Aimbot, Teleport, Dynamic Player Support
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Сохранение настроек
local GlobalEnv = (getgenv and getgenv()) or _G
if not GlobalEnv.BorderRP_Config then
    GlobalEnv.BorderRP_Config = {
        SpeedEnabled = false,
        WalkSpeedValue = 16,
        XRayEnabled = false,
        XRayTarget = "All",
        XRayColor = Color3.fromRGB(255, 0, 0),
        AimbotEnabled = false,
        AimbotTarget = "All",
        AimbotSmoothness = 5,
        AimbotMaxDistance = 500,
        AimbotWallCheck = true,
        SavedWaypoints = {}
    }
end
local Config = GlobalEnv.BorderRP_Config

-- Обновление персонажа при смерти
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    if Config.SpeedEnabled then
        task.wait(0.5)
        Humanoid.WalkSpeed = Config.WalkSpeedValue
    end
end)

-- Фильтр ролей
local function getPlayerRole(player)
    local team = player.Team and player.Team.Name or ""
    if team:match("Police") or team:match("Cop") or team:match("Шериф") then
        return "Police"
    elseif player:GetAttribute("Wanted") or player:GetAttribute("IsCriminal") or team:match("Criminal") or team:match("Преступник") then
        return "Criminals"
    else
        return "Civilians"
    end
end

local function matchesFilter(targetPlayer, filterType)
    if filterType == "All" then return true end
    local role = getPlayerRole(targetPlayer)
    return role == filterType
end

-- UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BorderRP_GUI_Ultimate"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 50, 0, 200)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ToggleButton.Text = "RP"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 380)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -70, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "San Diego Border RP | Ultimate Menu"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 2)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseButton.TextSize = 16
CloseButton.Parent = TopBar

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleButton.Visible = false
end)

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -70, 0, 2)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Text = "─"
MinimizeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeButton.TextSize = 16
MinimizeButton.Parent = TopBar

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleButton.Visible = true
end)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

LocalPlayer.Chatted:Connect(function(msg)
    if msg:lower() == "/rp" then
        ToggleButton.Visible = true
        MainFrame.Visible = true
    end
end)

local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
-- Вкладки
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.Position = UDim2.new(0, 0, 0, 35)
TabBar.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
TabBar.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -65)
ContentFrame.Position = UDim2.new(0, 0, 0, 65)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local tabs = {"Speed", "X-Ray", "Aimbot", "Teleport"}
local tabFrames = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1 / #tabs, 0, 1, 0)
    btn.Position = UDim2.new((i - 1) / #tabs, 0, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = TabBar

    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = (i == 1)
    frame.CanvasSize = UDim2.new(0, 0, 2, 0)
    frame.Parent = ContentFrame
    tabFrames[tabName] = frame

    btn.MouseButton1Click:Connect(function()
        for _, f in pairs(tabFrames) do f.Visible = false end
        frame.Visible = true
    end)
end

-- Speed
local speedFrame = tabFrames["Speed"]

local speedToggle = Instance.new("TextButton")
speedToggle.Size = UDim2.new(0, 200, 0, 35)
speedToggle.Position = UDim2.new(0, 15, 0, 15)
speedToggle.BackgroundColor3 = Config.SpeedEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
speedToggle.Text = Config.SpeedEnabled and "Speed: ON" or "Speed: OFF"
speedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
speedToggle.Font = Enum.Font.GothamBold
speedToggle.Parent = speedFrame

speedToggle.MouseButton1Click:Connect(function()
    Config.SpeedEnabled = not Config.SpeedEnabled
    speedToggle.BackgroundColor3 = Config.SpeedEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    speedToggle.Text = Config.SpeedEnabled and "Speed: ON" or "Speed: OFF"
end)

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 200, 0, 35)
speedInput.Position = UDim2.new(0, 15, 0, 60)
speedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedInput.Text = tostring(Config.WalkSpeedValue)
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.Font = Enum.Font.Gotham
speedInput.Parent = speedFrame

speedInput.FocusLost:Connect(function()
    local val = tonumber(speedInput.Text)
    if val then Config.WalkSpeedValue = val end
end)

RunService.Stepped:Connect(function()
    if Config.SpeedEnabled and Humanoid then
        Humanoid.WalkSpeed = Config.WalkSpeedValue
    end
end)

-- X-Ray
local xrayFrame = tabFrames["X-Ray"]

local xrayToggle = Instance.new("TextButton")
xrayToggle.Size = UDim2.new(0, 200, 0, 35)
xrayToggle.Position = UDim2.new(0, 15, 0, 15)
xrayToggle.BackgroundColor3 = Config.XRayEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
xrayToggle.Text = Config.XRayEnabled and "X-Ray: ON" or "X-Ray: OFF"
xrayToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
xrayToggle.Font = Enum.Font.GothamBold
xrayToggle.Parent = xrayFrame

xrayToggle.MouseButton1Click:Connect(function()
    Config.XRayEnabled = not Config.XRayEnabled
    xrayToggle.BackgroundColor3 = Config.XRayEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    xrayToggle.Text = Config.XRayEnabled and "X-Ray: ON" or "X-Ray: OFF"
end)

local targets = {"All", "Criminals", "Police", "Civilians"}
for idx, tName in ipairs(targets) do
    local tBtn = Instance.new("TextButton")
    tBtn.Size = UDim2.new(0, 100, 0, 30)
    tBtn.Position = UDim2.new(0, 15 + ((idx - 1) * 110), 0, 65)
    tBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tBtn.Text = tName
    tBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tBtn.Font = Enum.Font.Gotham
    tBtn.Parent = xrayFrame

    tBtn.MouseButton1Click:Connect(function()
        Config.XRayTarget = tName
    end)
end

local colors = {
    {"Красный", Color3.fromRGB(255, 0, 0)},
    {"Синий", Color3.fromRGB(0, 100, 255)},
    {"Зеленый", Color3.fromRGB(0, 255, 0)},
    {"Желтый", Color3.fromRGB(255, 255, 0)}
}

for idx, colData in ipairs(colors) do
    local cBtn = Instance.new("TextButton")
    cBtn.Size = UDim2.new(0, 100, 0, 30)
    cBtn.Position = UDim2.new(0, 15 + ((idx - 1) * 110), 0, 110)
    cBtn.BackgroundColor3 = colData[2]
    cBtn.Text = colData[1]
    cBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    cBtn.Font = Enum.Font.GothamBold
    cBtn.Parent = xrayFrame

    cBtn.MouseButton1Click:Connect(function()
        Config.XRayColor = colData[2]
    end)
end

RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local highlight = char:FindFirstChild("RP_Highlight")

            if Config.XRayEnabled and matchesFilter(player, Config.XRayTarget) then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "RP_Highlight"
                    highlight.FillColor = Config.XRayColor
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Parent = char
                else
                    highlight.FillColor = Config.XRayColor
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if Config.XRayEnabled and player.Character then
            local char = player.Character
            if matchesFilter(player, Config.XRayTarget) and not char:FindFirstChild("RP_Highlight") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "RP_Highlight"
                highlight.FillColor = Config.XRayColor
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = char
            end
        end
    end)
end)
-- Aimbot
local aimbotFrame = tabFrames["Aimbot"]

local aimToggle = Instance.new("TextButton")
aimToggle.Size = UDim2.new(0, 200, 0, 35)
aimToggle.Position = UDim2.new(0, 15, 0, 15)
aimToggle.BackgroundColor3 = Config.AimbotEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
aimToggle.Text = Config.AimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
aimToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
aimToggle.Font = Enum.Font.GothamBold
aimToggle.Parent = aimbotFrame

aimToggle.MouseButton1Click:Connect(function()
    Config.AimbotEnabled = not Config.AimbotEnabled
    aimToggle.BackgroundColor3 = Config.AimbotEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    aimToggle.Text = Config.AimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
end)

local distInput = Instance.new("TextBox")
distInput.Size = UDim2.new(0, 200, 0, 30)
distInput.Position = UDim2.new(0, 15, 0, 60)
distInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
distInput.Text = "Дистанция: " .. tostring(Config.AimbotMaxDistance)
distInput.TextColor3 = Color3.fromRGB(255, 255, 255)
distInput.Font = Enum.Font.Gotham
distInput.Parent = aimbotFrame

distInput.FocusLost:Connect(function()
    local cleanNum = tonumber(distInput.Text:match("%d+"))
    if cleanNum then
        Config.AimbotMaxDistance = cleanNum
        distInput.Text = "Дистанция: " .. tostring(Config.AimbotMaxDistance)
    end
end)

local function getClosestTarget()
    local closestTarget = nil
    local shortestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and matchesFilter(player, Config.AimbotTarget) then
            local head = player.Character:FindFirstChild("Head")
            if head and HumanoidRootPart then
                local distToPlayer = (head.Position - HumanoidRootPart.Position).Magnitude
                if distToPlayer <= Config.AimbotMaxDistance then
                    if Config.AimbotWallCheck then
                        local rayParams = RaycastParams.new()
                        rayParams.FilterDescendantsInstances = {LocalPlayer.Character, player.Character}
                        rayParams.FilterType = Enum.RaycastFilterType.Exclude
                        local result = Workspace:Raycast(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * distToPlayer, rayParams)
                        if result then continue end
                    end

                    local screenPoint, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local mousePos = UserInputService:GetMouseLocation()
                        local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                        if dist < shortestDistance then
                            shortestDistance = dist
                            closestTarget = head
                        end
                    end
                end
            end
        end
    end
    return closestTarget
end

RunService.RenderStepped:Connect(function()
    if Config.AimbotEnabled then
        local targetHead = getClosestTarget()
        if targetHead then
            local currentCF = Camera.CFrame
            local targetCF = CFrame.new(currentCF.Position, targetHead.Position)
            Camera.CFrame = currentCF:Lerp(targetCF, 1 / math.max(Config.AimbotSmoothness, 1))
        end
    end
end)

-- Teleport
local tpFrame = tabFrames["Teleport"]

local tpInput = Instance.new("TextBox")
tpInput.Size = UDim2.new(0, 200, 0, 30)
tpInput.Position = UDim2.new(0, 15, 0, 15)
tpInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tpInput.PlaceholderText = "Название точки"
tpInput.Text = ""
tpInput.TextColor3 = Color3.fromRGB(255, 255, 255)
tpInput.Font = Enum.Font.Gotham
tpInput.Parent = tpFrame

local saveTpBtn = Instance.new("TextButton")
saveTpBtn.Size = UDim2.new(0, 200, 0, 30)
saveTpBtn.Position = UDim2.new(0, 15, 0, 55)
saveTpBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
saveTpBtn.Text = "Сохранить координаты"
saveTpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveTpBtn.Font = Enum.Font.GothamBold
saveTpBtn.Parent = tpFrame

local waypointsListFrame = Instance.new("ScrollingFrame")
waypointsListFrame.Size = UDim2.new(0, 270, 0, 200)
waypointsListFrame.Position = UDim2.new(0, 220, 0, 15)
waypointsListFrame.BackgroundTransparency = 1
waypointsListFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
waypointsListFrame.Parent = tpFrame

local function updateWaypointsUI()
    for _, child in ipairs(waypointsListFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local yOffset = 0
    for name, cfData in pairs(Config.SavedWaypoints) do
        local rowFrame = Instance.new("Frame")
        rowFrame.Size = UDim2.new(1, 0, 0, 30)
        rowFrame.Position = UDim2.new(0, 0, 0, yOffset)
        rowFrame.BackgroundTransparency = 1
        rowFrame.Parent = waypointsListFrame

        local wpBtn = Instance.new("TextButton")
        wpBtn.Size = UDim2.new(0, 180, 1, 0)
        wpBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        wpBtn.Text = "TP: " .. name
        wpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        wpBtn.Font = Enum.Font.Gotham
        wpBtn.Parent = rowFrame

        wpBtn.MouseButton1Click:Connect(function()
            if HumanoidRootPart then
                local targetCF = CFrame.new(unpack(cfData))
                local tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {CFrame = targetCF})
                tween:Play()
            end
        end)

        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0, 70, 1, 0)
        delBtn.Position = UDim2.new(0, 185, 0, 0)
        delBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        delBtn.Text = "Удалить"
        delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        delBtn.Font = Enum.Font.GothamBold
        delBtn.Parent = rowFrame

        delBtn.MouseButton1Click:Connect(function()
            Config.SavedWaypoints[name] = nil
            updateWaypointsUI()
        end)

        yOffset = yOffset + 35
    end
end

saveTpBtn.MouseButton1Click:Connect(function()
    local name = tpInput.Text
    if name ~= "" and HumanoidRootPart then
        local p = HumanoidRootPart.Position
        Config.SavedWaypoints[name] = {p.X, p.Y, p.Z}
        updateWaypointsUI()
        tpInput.Text = ""
    end
end)

updateWaypointsUI()

print("✅ San Diego Border RP Ultimate Script Loaded! Type /rp to restore GUI.")
