-- =====================================================
-- LOST FRONT - APEX X (ПОЛНАЯ ПЕРЕРАБОТКА)
-- Русский UI, все функции работают
-- =====================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ===== НАСТРОЙКИ (СОХРАНЯЮТСЯ) =====
local Settings = {
    ESP = false,
    ESPColorEnemy = Color3.fromRGB(255, 0, 0),
    ESPColorTeam = Color3.fromRGB(0, 100, 255),
    ESPColorAll = Color3.fromRGB(255, 255, 0),
    ESPMode = "All", -- "All", "Enemy", "Team"
    Aimbot = false,
    AimbotLevel = 3,
    Speed = false,
    SpeedValue = 30,
    WallHack = false,
    NoRecoil = false,
    HP = false,
    HPMode = "All",
    HPFontSize = 14,
}

-- Сохранение
local GlobalEnv = (getgenv and getgenv()) or _G
if not GlobalEnv.LostFrontApex2 then
    GlobalEnv.LostFrontApex2 = Settings
end
Settings = GlobalEnv.LostFrontApex2

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LostFrontApex"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Круг
local CircleBtn = Instance.new("ImageButton")
CircleBtn.Size = UDim2.new(0, 45, 0, 45)
CircleBtn.Position = UDim2.new(0.01, 0, 0.5, -22)
CircleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CircleBtn.Image = "rbxassetid://5816666308"
CircleBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
CircleBtn.ScaleType = Enum.ScaleType.Fit
CircleBtn.Parent = ScreenGui

-- Перетаскивание круга
local dragCircle = false
local dragStart, startPos
CircleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragCircle = true
        dragStart = input.Position
        startPos = CircleBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragCircle = false
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragCircle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        CircleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Главное окно (с прокруткой)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 380)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Скругление
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Title.Text = "LOST FRONT MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Кнопки управления
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -28, 0, 2)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Title
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    CircleBtn.Visible = false
end)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -56, 0, 2)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "─"
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinBtn.TextSize = 14
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Parent = Title
MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

CircleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ScrollFrame для содержимого
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -30)
ScrollFrame.Position = UDim2.new(0, 0, 0, 30)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.Parent = MainFrame

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 0, 0)
Content.BackgroundTransparency = 1
Content.Parent = ScrollFrame

-- Функции создания элементов
local y = 5
local function addToggle(text, settingKey)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.9, 0, 0, 28)
    frame.Position = UDim2.new(0.05, 0, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    frame.BorderSizePixel = 0
    frame.Parent = Content
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, 0, 1, -4)
    btn.Position = UDim2.new(0.72, 0, 0, 2)
    btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    btn.Text = "ВЫКЛ"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = frame
    local corner2 = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(0, 4)
    corner2.Parent = btn

    local state = Settings[settingKey] or false
    if state then
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        btn.Text = "ВКЛ"
    end

    btn.MouseButton1Click:Connect(function()
        state = not state
        Settings[settingKey] = state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(255, 0, 0)
        btn.Text = state and "ВКЛ" or "ВЫКЛ"
    end)
    y = y + 35
    return btn
end

local function addDropdown(text, settingKey, options)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0, 22)
    label.Position = UDim2.new(0.05, 0, 0, y)
    label.BackgroundTransparency = 1
    local curVal = Settings[settingKey]
    local curIdx = 1
    for i, v in ipairs(options) do
        if v == curVal then curIdx = i end
    end
    label.Text = text .. ": " .. options[curIdx]
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = Content

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.3, 0, 0, 22)
    btn.Position = UDim2.new(0.6, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    btn.Text = options[curIdx]
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = Content
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn

    local idx = curIdx
    btn.MouseButton1Click:Connect(function()
        idx = idx % #options + 1
        btn.Text = options[idx]
        label.Text = text .. ": " .. options[idx]
        Settings[settingKey] = options[idx]
    end)
    y = y + 35
    return btn
end

local function addColorPicker(text, settingKey)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0, 22)
    label.Position = UDim2.new(0.05, 0, 0, y)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = Content

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.3, 0, 0, 22)
    btn.Position = UDim2.new(0.6, 0, 0, y)
    btn.BackgroundColor3 = Settings[settingKey]
    btn.Text = ""
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = Content
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn

    local colors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(0, 100, 255),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(255, 0, 255),
        Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(255, 255, 255),
    }
    local idx = 1
    btn.MouseButton1Click:Connect(function()
        idx = idx % #colors + 1
        btn.BackgroundColor3 = colors[idx]
        Settings[settingKey] = colors[idx]
    end)
    y = y + 35
    return btn
end

local function addSlider(text, settingKey, min, max, step)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0, 22)
    label.Position = UDim2.new(0.05, 0, 0, y)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(Settings[settingKey])
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = Content

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.3, 0, 0, 22)
    btn.Position = UDim2.new(0.6, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    btn.Text = tostring(Settings[settingKey])
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = Content
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn

    local val = Settings[settingKey]
    btn.MouseButton1Click:Connect(function()
        val = val + step
        if val > max then val = min end
        Settings[settingKey] = val
        btn.Text = tostring(val)
        label.Text = text .. ": " .. tostring(val)
    end)
    y = y + 35
    return btn
end

-- ===== СОЗДАНИЕ МЕНЮ =====
addToggle("ESP", "ESP")
addColorPicker("Цвет врагов", "ESPColorEnemy")
addColorPicker("Цвет союзников", "ESPColorTeam")
addColorPicker("Цвет всех", "ESPColorAll")
addDropdown("Режим ESP", "ESPMode", {"All", "Enemy", "Team"})

addToggle("Аимбот", "Aimbot")
addDropdown("Уровень аимбота", "AimbotLevel", {"Очень слабый", "Слабый", "Нормальный", "Сильный", "Очень сильный"})

addToggle("Скорость", "Speed")
addSlider("Скорость бега", "SpeedValue", 16, 100, 2)

addToggle("WallHack", "WallHack")
addToggle("No Recoil", "NoRecoil")

addToggle("HP Display", "HP")
addDropdown("Режим HP", "HPMode", {"All", "Enemy", "Team"})
addSlider("Размер HP", "HPFontSize", 8, 30, 2)

-- Обновляем CanvasSize
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, y + 10)

print("✅ Part 1 Loaded")
-- =====================================================
-- LOST FRONT - APEX X (ЧАСТЬ 2) - ESP + HP
-- =====================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

-- ===== ОПРЕДЕЛЕНИЕ КОМАНДЫ =====
local function getTeam(player)
    if player.Team then return player.Team.Name end
    local char = player.Character
    if char then
        local head = char:FindFirstChild("Head")
        if head then
            for _, child in ipairs(head:GetChildren()) do
                if child:IsA("BasePart") and child.BrickColor then
                    return child.BrickColor.Name
                end
            end
        end
    end
    return "Unknown"
end

local espHighlights = {}
local hpLabels = {}

local function updateESPAndHP()
    -- Чистка
    for p, hl in pairs(espHighlights) do
        if not p.Parent then hl:Destroy(); espHighlights[p] = nil end
    end
    for p, lbl in pairs(hpLabels) do
        if not p.Parent or not lbl.Parent then lbl:Destroy(); hpLabels[p] = nil end
    end

    local myTeam = getTeam(LocalPlayer)

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local char = player.Character
        if not char then continue end

        local team = getTeam(player)
        local isEnemy = (myTeam ~= "Unknown" and team ~= myTeam)

        -- ESP
        if Settings.ESP then
            local show = false
            local color = Settings.ESPColorAll
            if Settings.ESPMode == "All" then
                show = true
                color = Settings.ESPColorAll
            elseif Settings.ESPMode == "Enemy" and isEnemy then
                show = true
                color = Settings.ESPColorEnemy
            elseif Settings.ESPMode == "Team" and not isEnemy then
                show = true
                color = Settings.ESPColorTeam
            end

            local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
            if show and root then
                if not espHighlights[player] then
                    local hl = Instance.new("Highlight")
                    hl.FillColor = color
                    hl.FillTransparency = 0.25
                    hl.OutlineTransparency = 0.3
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = char
                    espHighlights[player] = hl
                end
                espHighlights[player].FillColor = color
            else
                if espHighlights[player] then
                    espHighlights[player]:Destroy()
                    espHighlights[player] = nil
                end
            end
        end

        -- HP
        if Settings.HP then
            local showHP = false
            if Settings.HPMode == "All" then
                showHP = true
            elseif Settings.HPMode == "Enemy" and isEnemy then
                showHP = true
            elseif Settings.HPMode == "Team" and not isEnemy then
                showHP = true
            end

            if showHP then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local head = char:FindFirstChild("Head")
                if hum and head then
                    local hp = math.floor(hum.Health / hum.MaxHealth * 100)
                    if not hpLabels[player] then
                        local label = Instance.new("BillboardGui")
                        label.Size = UDim2.new(0, 100, 0, 30)
                        label.Adornee = head
                        label.StudsOffset = Vector3.new(0, 2.5, 0)
                        label.AlwaysOnTop = true
                        label.Parent = head

                        local text = Instance.new("TextLabel")
                        text.Size = UDim2.new(1, 0, 1, 0)
                        text.BackgroundTransparency = 1
                        text.Text = hp .. "%"
                        text.TextColor3 = Color3.fromRGB(255, 255, 255)
                        text.TextScaled = true
                        text.Font = Enum.Font.GothamBold
                        text.TextSize = Settings.HPFontSize
                        text.Parent = label
                        hpLabels[player] = label
                    end
                    local text = hpLabels[player]:FindFirstChildOfClass("TextLabel")
                    if text then
                        text.Text = hp .. "%"
                        text.TextSize = Settings.HPFontSize
                        if hp > 60 then
                            text.TextColor3 = Color3.fromRGB(0, 255, 0)
                        elseif hp > 30 then
                            text.TextColor3 = Color3.fromRGB(255, 255, 0)
                        else
                            text.TextColor3 = Color3.fromRGB(255, 0, 0)
                        end
                    end
                end
            else
                if hpLabels[player] then
                    hpLabels[player]:Destroy()
                    hpLabels[player] = nil
                end
            end
        else
            if hpLabels[player] then
                hpLabels[player]:Destroy()
                hpLabels[player] = nil
            end
        end
    end
end

RunService.RenderStepped:Connect(updateESPAndHP)

-- Новые игроки
Players.PlayerAdded:Connect(function()
    wait(0.5)
    updateESPAndHP()
end)

print("✅ Part 2 Loaded")
-- =====================================================
-- LOST FRONT - APEX X (ЧАСТЬ 3) - Aimbot + Speed + WallHack + NoRecoil
-- =====================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ===== AIMBOT =====
local currentTarget = nil

local function getAimbotTarget()
    local best, bestDist = nil, math.huge
    local origin = Camera.CFrame.Position
    local myTeam = getTeam(LocalPlayer)

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local char = player.Character
        if not char then continue end
        local head = char:FindFirstChild("Head")
        if not head then continue end

        -- Проверка видимости (Raycast)
        local ray = Ray.new(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 500)
        local hit = Workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
        if hit and hit.Parent ~= char then
            continue -- не видим
        end

        -- Фильтр по режиму ESP (для аимбота используем тот же фильтр)
        if Settings.ESPMode == "Enemy" then
            local team = getTeam(player)
            if team == myTeam then continue end
        elseif Settings.ESPMode == "Team" then
            local team = getTeam(player)
            if team ~= myTeam then continue end
        end

        local screenPoint = Camera:WorldToViewportPoint(head.Position)
        local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
        if dist < bestDist and dist < 300 then
            bestDist = dist
            best = head
        end
    end
    return best
end

local function getAccuracy()
    local acc = {0.15, 0.35, 0.60, 0.85, 0.98}
    local level = Settings.AimbotLevel
    if type(level) == "string" then
        local map = {"Очень слабый", "Слабый", "Нормальный", "Сильный", "Очень сильный"}
        for i, v in ipairs(map) do
            if v == level then level = i end
        end
    end
    return acc[tonumber(level) or 3] or 0.60
end

RunService.RenderStepped:Connect(function()
    if Settings.Aimbot then
        if not currentTarget or not currentTarget.Parent then
            currentTarget = getAimbotTarget()
        end

        if currentTarget then
            local acc = getAccuracy()
            if math.random() < acc then
                local targetPos = currentTarget.Position
                local level = Settings.AimbotLevel
                if type(level) == "string" then
                    local map = {"Очень слабый", "Слабый", "Нормальный", "Сильный", "Очень сильный"}
                    for i, v in ipairs(map) do
                        if v == level then level = i end
                    end
                end
                local lvl = tonumber(level) or 3
                local offset = Vector3.new(
                    (math.random() - 0.5) * (5 - lvl),
                    (math.random() - 0.5) * (5 - lvl),
                    0
                )
                local newCF = CFrame.new(Camera.CFrame.Position, targetPos + offset)
                Camera.CFrame = Camera.CFrame:Lerp(newCF, 0.15 + lvl * 0.05)
            end
        end
    end
end)

-- ===== SPEED (БЕЗ ТЕЛЕПОРТАЦИИ) =====
local speedConn = nil
local function applySpeed()
    if Settings.Speed then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = Settings.SpeedValue
            end
        end
    else
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed ~= 16 then
                hum.WalkSpeed = 16
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    applySpeed()
end)

LocalPlayer.CharacterAdded:Connect(function()
    wait(0.5)
    applySpeed()
end)

-- ===== WALLHACK =====
local wallhackConn = nil

local function toggleWallhack(state)
    if wallhackConn then
        wallhackConn:Disconnect()
        wallhackConn = nil
    end
    if state then
        wallhackConn = RunService.RenderStepped:Connect(function()
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Material ~= Enum.Material.Neon then
                    part.LocalTransparencyModifier = 0.3
                end
            end
        end)
    else
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0
            end
        end
    end
end

-- Отслеживаем WallHack через Settings
local oldWallhack = false
RunService.RenderStepped:Connect(function()
    if Settings.WallHack ~= oldWallhack then
        toggleWallhack(Settings.WallHack)
        oldWallhack = Settings.WallHack
    end
end)

-- ===== NO RECOIL =====
local oldRecoil = {}

local function applyNoRecoil()
    if not Settings.NoRecoil then
        for _, tool in ipairs(LocalPlayer.Character and LocalPlayer.Character:GetChildren() or {}) do
            if tool:IsA("Tool") then
                local recoil = tool:FindFirstChild("Recoil") or tool:FindFirstChild("CameraRecoil")
                if recoil and oldRecoil[tool] then
                    recoil.Value = oldRecoil[tool]
                    oldRecoil[tool] = nil
                end
            end
        end
        return
    end

    for _, tool in ipairs(LocalPlayer.Character and LocalPlayer.Character:GetChildren() or {}) do
        if tool:IsA("Tool") then
            local recoil = tool:FindFirstChild("Recoil") or tool:FindFirstChild("CameraRecoil")
            if recoil and not oldRecoil[tool] then
                oldRecoil[tool] = recoil.Value
                recoil.Value = 0
            elseif recoil then
                recoil.Value = 0
            end
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    wait(0.5)
    applyNoRecoil()
end)

RunService.RenderStepped:Connect(applyNoRecoil)

print("✅ LOST FRONT APEX X FULL загружен!")
print("📌 Все настройки сохраняются автоматически")
