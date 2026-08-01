-- =============================================
-- SPEED ONLY (БЕЗ ОГРАНИЧЕНИЙ)
-- Старая рабочая версия, только скорость
-- =============================================

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

-- ===== НАСТРОЙКИ =====
local SPEED_VALUE = 50 -- Стартовая скорость

-- ===== GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedOnly"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 180)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = screenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.Text = "⚡ SPEED (БЕЗ ЛИМИТА)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- ===== SPEED =====
local speedActive = false
local speedVal = SPEED_VALUE

-- Отображение скорости
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.9, 0, 0, 25)
speedLabel.Position = UDim2.new(0.05, 0, 0, 40)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Скорость: " .. speedVal
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = MainFrame

-- Функция применения скорости (при респавне)
local function applySpeedOnRespawn(char)
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid and speedActive then
        humanoid.WalkSpeed = speedVal
        print("⚡ Скорость установлена: " .. speedVal)
    end
end

-- Кнопка включения
local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(0.9, 0, 0, 28)
speedBtn.Position = UDim2.new(0.05, 0, 0, 70)
speedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedBtn.Text = "Speed OFF"
speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBtn.TextScaled = true
speedBtn.Font = Enum.Font.GothamBold
speedBtn.Parent = MainFrame

speedBtn.MouseButton1Click:Connect(function()
    speedActive = not speedActive
    speedBtn.BackgroundColor3 = speedActive and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(50, 50, 50)
    speedBtn.Text = speedActive and "Speed ON" or "Speed OFF"
    if speedActive and player.Character then
        applySpeedOnRespawn(player.Character)
    end
end)

-- Кнопки +5 / -5 (без ограничений)
local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0.2, 0, 0, 25)
plusBtn.Position = UDim2.new(0.05, 0, 0, 105)
plusBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
plusBtn.Text = "+5"
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.TextScaled = true
plusBtn.Font = Enum.Font.GothamBold
plusBtn.Parent = MainFrame
plusBtn.MouseButton1Click:Connect(function()
    speedVal = speedVal + 5
    speedLabel.Text = "Скорость: " .. speedVal
    if speedActive and player.Character then
        applySpeedOnRespawn(player.Character) -- Применяем сразу, если скорость включена
    end
end)

local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0.2, 0, 0, 25)
minusBtn.Position = UDim2.new(0.3, 0, 0, 105)
minusBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
minusBtn.Text = "-5"
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.TextScaled = true
minusBtn.Font = Enum.Font.GothamBold
minusBtn.Parent = MainFrame
minusBtn.MouseButton1Click:Connect(function()
    speedVal = speedVal - 5
    if speedVal < 0 then speedVal = 0 end
    speedLabel.Text = "Скорость: " .. speedVal
    if speedActive and player.Character then
        applySpeedOnRespawn(player.Character)
    end
end)

-- Кнопка "Умереть" (для активации бага)
local respawnBtn = Instance.new("TextButton")
respawnBtn.Size = UDim2.new(0.3, 0, 0, 25)
respawnBtn.Position = UDim2.new(0.6, 0, 0, 105)
respawnBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
respawnBtn.Text = "💀 Умереть"
respawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
respawnBtn.TextScaled = true
respawnBtn.Font = Enum.Font.GothamBold
respawnBtn.Parent = MainFrame
respawnBtn.MouseButton1Click:Connect(function()
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid then humanoid.Health = 0 end
end)

-- ===== ОБРАБОТКА ПЕРЕРОЖДЕНИЯ =====
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    wait(0.5)
    if speedActive then
        applySpeedOnRespawn(newChar)
    end
end)

-- Если персонаж уже есть
if player.Character then
    wait(0.5)
    if speedActive then
        applySpeedOnRespawn(player.Character)
    end
end

print("✅ SPEED ONLY загружен! Без ограничений.")
