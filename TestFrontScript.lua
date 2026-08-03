-- =====================================================
-- LOST FRONT - APEX X (FULL EDITION) - ЧАСТЬ 1
-- ESP + HP Display
-- =====================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ===== НАСТРОЙКИ =====
local Settings = {
    ESP = false,
    ESPMode = "All", -- "All", "Enemy", "Team"
    Aimbot = false,
    AimbotLevel = 3,
    WallHack = false,
    NoRecoil = false,
    HP = false,
    HPMode = "All", -- "All", "Enemy", "Team"
    HPFontSize = 14,
}

-- ===== СОХРАНЕНИЕ =====
local GlobalEnv = (getgenv and getgenv()) or _G
if not GlobalEnv.LostFrontApex then
    GlobalEnv.LostFrontApex = Settings
end
Settings = GlobalEnv.LostFrontApex

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LostFrontApex"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Чёрный круг
local CircleBtn = Instance.new("ImageButton")
CircleBtn.Size = UDim2.new(0, 45, 0, 45)
CircleBtn.Position = UDim2.new(0.01, 0, 0.5, -22)
CircleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CircleBtn.Image = "rbxassetid://5816666308"
CircleBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
CircleBtn.ScaleType = Enum.ScaleType.Fit
CircleBtn.Parent = ScreenGui

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

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 340)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(50, 50, 60)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Title.Text = "LOST FRONT MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

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

-- ===== СОЗДАНИЕ КНОПОК =====
local function createToggle(parent, text, y, settingKey)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.9, 0, 0, 28)
    frame.Position = UDim2.new(0.05, 0, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, 0, 1, -4)
    btn.Position = UDim2.new(0.72, 0, 0, 2)
    btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    btn.Text = "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = frame

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        Settings[settingKey] = state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(255, 0, 0)
        btn.Text = state and "ON" or "OFF"
    end)
    return btn
end

local function createDropdown(parent, text, y, settingKey, options, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0, 22)
    label.Position = UDim2.new(0.05, 0, 0, y)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. options[1]
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = parent

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.3, 0, 0, 22)
    btn.Position = UDim2.new(0.6, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    btn.Text = options[1]
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent

    local idx = 1
    btn.MouseButton1Click:Connect(function()
        idx = idx % #options + 1
        btn.Text = options[idx]
        label.Text = text .. ": " .. options[idx]
        Settings[settingKey] = options[idx]
        if callback then callback(options[idx]) end
    end)
    return btn
end

-- ===== КНОПКИ МЕНЮ =====
local y = 40
createToggle(MainFrame, "ESP", y, "ESP")
y = y + 35

local espModes = {"All", "Enemy", "Team"}
createDropdown(MainFrame, "ESP Mode", y, "ESPMode", espModes)
y = y + 35

createToggle(MainFrame, "AIMBOT", y, "Aimbot")
y = y + 35

local levels = {"VERY WEAK", "WEAK", "NORMAL", "STRONG", "VERY STRONG"}
createDropdown(MainFrame, "Aimbot Level", y, "AimbotLevel", levels, function(val)
    for i, v in ipairs(levels) do
        if v == val then Settings.AimbotLevel = i end
    end
end)
y = y + 35

createToggle(MainFrame, "WALLHACK", y, "WallHack")
y = y + 35

createToggle(MainFrame, "NO RECOIL", y, "NoRecoil")
y = y + 35

-- HP
createToggle(MainFrame, "HP DISPLAY", y, "HP")
y = y + 35

local hpModes = {"All", "Enemy", "Team"}
createDropdown(MainFrame, "HP Mode", y, "HPMode", hpModes)
y = y + 35

-- Ползунок размера шрифта HP
local fontLabel = Instance.new("TextLabel")
fontLabel.Size = UDim2.new(0.5, 0, 0, 22)
fontLabel.Position = UDim2.new(0.05, 0, 0, y)
fontLabel.BackgroundTransparency = 1
fontLabel.Text = "HP Size: " .. Settings.HPFontSize
fontLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
fontLabel.TextScaled = true
fontLabel.Font = Enum.Font.Gotham
fontLabel.Parent = MainFrame

local fontBtn = Instance.new("TextButton")
fontBtn.Size = UDim2.new(0.2, 0, 0, 22)
fontBtn.Position = UDim2.new(0.7, 0, 0, y)
fontBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
fontBtn.Text = tostring(Settings.HPFontSize)
fontBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fontBtn.TextScaled = true
fontBtn.Font = Enum.Font.GothamBold
fontBtn.Parent = MainFrame

fontBtn.MouseButton1Click:Connect(function()
    Settings.HPFontSize = Settings.HPFontSize + 2
    if Settings.HPFontSize > 30 then Settings.HPFontSize = 8 end
    fontLabel.Text = "HP Size: " .. Settings.HPFontSize
    fontBtn.Text = tostring(Settings.HPFontSize)
end)

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

-- ===== ESP + HP =====
local espHighlights = {}
local hpLabels = {}

local function updateESPAndHP()
    -- Чистка мёртвых
    for p, hl in pairs(espHighlights) do
        if not p.Parent then
            hl:Destroy()
            espHighlights[p] = nil
        end
    end
    for p, lbl in pairs(hpLabels) do
        if not p.Parent or not lbl.Parent then
            lbl:Destroy()
            hpLabels[p] = nil
        end
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
            local color = Color3.fromRGB(255, 255, 0)
            if Settings.ESPMode == "All" then
                show = true
                color = Color3.fromRGB(255, 255, 0)
            elseif Settings.ESPMode == "Enemy" and isEnemy then
                show = true
                color = Color3.fromRGB(255, 0, 0)
            elseif Settings.ESPMode == "Team" and not isEnemy then
                show = true
                color = Color3.fromRGB(0, 100, 255)
            end

            local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
            if show and root then
                if not espHighlights[player] then
                    local hl = Instance.new("Highlight")
                    hl.FillColor = color
                    hl.FillTransparency = 0.3
                    hl.OutlineTransparency = 0.5
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
print("✅ Part 1 Loaded")
-- =====================================================
-- LOST FRONT - APEX X (FULL EDITION) - ЧАСТЬ 2
-- Aimbot + NoRecoil
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

        -- Проверка видимости
        local ray = Ray.new(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 500)
        local hit = Workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
        if hit and hit.Parent ~= char then continue end

        -- Фильтр по команде
        if Settings.ESPMode == "Enemy" then
            local team = getTeam(player)
            if team == myTeam then continue end
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
    return acc[Settings.AimbotLevel] or 0.60
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
                local offset = Vector3.new(
                    (math.random() - 0.5) * (5 - Settings.AimbotLevel),
                    (math.random() - 0.5) * (5 - Settings.AimbotLevel),
                    0
                )
                local newCF = CFrame.new(Camera.CFrame.Position, targetPos + offset)
                Camera.CFrame = Camera.CFrame:Lerp(newCF, 0.2 + Settings.AimbotLevel * 0.05)
            end
        end
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

print("✅ Part 2 Loaded")
-- =====================================================
-- LOST FRONT - APEX X (FULL EDITION) - ЧАСТЬ 3
-- WallHack + Запуск
-- =====================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

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

-- ===== НОВЫЕ ИГРОКИ =====
Players.PlayerAdded:Connect(function()
    wait(1)
    updateESPAndHP()
end)

-- ===== ОБРАБОТЧИК WallHack =====
-- Переопределяем кнопку WallHack для связи с функцией
local wallhackState = false
local wallhackBtn = nil

for _, child in ipairs(MainFrame:GetDescendants()) do
    if child:IsA("TextButton") and child.Text == "WallHack OFF" then
        wallhackBtn = child
        break
    end
end

if wallhackBtn then
    local oldClick = wallhackBtn.MouseButton1Click
    wallhackBtn.MouseButton1Click:Connect(function()
        wallhackState = not wallhackState
        Settings.WallHack = wallhackState
        toggleWallhack(wallhackState)
        wallhackBtn.BackgroundColor3 = wallhackState and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(255, 0, 0)
        wallhackBtn.Text = wallhackState and "WallHack ON" or "WallHack OFF"
    end)
end

-- ===== АВТОЗАПУСК =====
wait(0.5)
updateESPAndHP()
if Settings.WallHack then
    toggleWallhack(true)
end

print("✅ LOST FRONT APEX X FULL загружен!")
print("📌 Настройки сохраняются автоматически")
