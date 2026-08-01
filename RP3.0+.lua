-- =====================================================
-- APEX V7.5 - СКОРОСТЬ + NOCLIP (БАГ-ФИКС)
-- Тот самый UI, который ты хотел
-- =====================================================

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- ===== НАСТРОЙКИ =====
local SPEED_VALUE = 300 -- СКОРОСТЬ (МЕНЯЙ)
local NOCLIP_ACTIVE = false -- ВКЛЮЧАТЬ БУДЕШЬ КНОПКОЙ

-- ===== GUI - ОКНО С ВКЛАДКАМИ (КАК ТЫ ЛЮБИШЬ) =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ApexV7_5"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = screenGui

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.Text = "🔴 APEX V7.5"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- ===== СОЗДАНИЕ ВКЛАДОК =====
local Tabs = {"Speed", "Noclip"}
local TabButtons = {}
local TabContents = {}

for i, name in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/#Tabs, 0, 0, 30)
    btn.Position = UDim2.new((i-1)/#Tabs, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = MainFrame
    table.insert(TabButtons, btn)
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, -65)
    content.Position = UDim2.new(0, 0, 0, 65)
    content.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    content.Visible = (i == 1)
    content.Parent = MainFrame
    table.insert(TabContents, content)
    
    btn.MouseButton1Click:Connect(function()
        for _, c in ipairs(TabContents) do c.Visible = false end
        content.Visible = true
        for _, b in ipairs(TabButtons) do b.BackgroundColor3 = Color3.fromRGB(40, 40, 40) end
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    end)
end
TabButtons[1].BackgroundColor3 = Color3.fromRGB(0, 150, 255)

-- ===== ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ =====
local function createLabel(parent, text, y)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.9, 0, 0, 25)
    lbl.Position = UDim2.new(0.05, 0, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextScaled = true
    lbl.Font = Enum.Font.Gotham
    lbl.Parent = parent
    return lbl
end

local function createButton(parent, text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = text .. " OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(50, 50, 50)
        btn.Text = text .. (state and " ON" or " OFF")
        callback(state)
    end)
    return btn, state
end

-- =====================================================
--  ВКЛАДКА SPEED
-- =====================================================
local speedTab = TabContents[1]
local speedActive = false

-- Функция установки скорости (при респавне)
local function applySpeed(char)
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid and speedActive then
        humanoid.WalkSpeed = SPEED_VALUE
        print("✅ Скорость установлена: " .. SPEED_VALUE)
    end
end

-- Кнопка включения скорости
createButton(speedTab, "Speed (после смерти)", 10, function(state)
    speedActive = state
    if state and player.Character then
        applySpeed(player.Character)
    end
end)

-- Ползунок скорости
local speedLabel = createLabel(speedTab, "Скорость: " .. SPEED_VALUE, 50)
local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(0.3, 0, 0, 25)
speedBtn.Position = UDim2.new(0.6, 0, 0, 50)
speedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedBtn.Text = tostring(SPEED_VALUE)
speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBtn.TextScaled = true
speedBtn.Font = Enum.Font.GothamBold
speedBtn.Parent = speedTab

speedBtn.MouseButton1Click:Connect(function()
    SPEED_VALUE = SPEED_VALUE + 50
    if SPEED_VALUE > 500 then SPEED_VALUE = 50 end
    speedBtn.Text = tostring(SPEED_VALUE)
    speedLabel.Text = "Скорость: " .. SPEED_VALUE
    if speedActive and player.Character then
        applySpeed(player.Character)
    end
end)

-- =====================================================
--  ВКЛАДКА NOCLIP (РАБОЧИЙ)
-- =====================================================
local noclipTab = TabContents[2]
local noclipActive = false
local noclipConnection = nil

local function startNoclip()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CanCollide = false
    end
    -- ОБХОД АНТИЧИТА: постоянно обновляем позицию
    noclipConnection = runService.Heartbeat:Connect(function()
        if char and char.PrimaryPart then
            char.PrimaryPart.CanCollide = false
            -- Небольшое смещение, чтобы сервер не успел телепортировать
            char.PrimaryPart.Position = char.PrimaryPart.Position + Vector3.new(0, 0.01, 0)
        end
    end)
end

local function stopNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CanCollide = true
    end
end

createButton(noclipTab, "Noclip", 10, function(state)
    noclipActive = state
    if state then
        startNoclip()
    else
        stopNoclip()
    end
end)

-- =====================================================
--  АВТО-СМЕРТЬ ДЛЯ АКТИВАЦИИ СКОРОСТИ
-- =====================================================
local function respawn()
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Health = 0
    end
end

-- Кнопка "Умереть" (чтобы активировать скорость)
local respawnBtn = Instance.new("TextButton")
respawnBtn.Size = UDim2.new(0.4, 0, 0, 30)
respawnBtn.Position = UDim2.new(0.3, 0, 0, 90)
respawnBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
respawnBtn.Text = "💀 Умереть (активировать скорость)"
respawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
respawnBtn.TextScaled = true
respawnBtn.Font = Enum.Font.GothamBold
respawnBtn.Parent = speedTab

respawnBtn.MouseButton1Click:Connect(function()
    respawn()
end)

-- =====================================================
--  ОБРАБОТКА ПЕРЕРОЖДЕНИЯ (СКОРОСТЬ АКТИВИРУЕТСЯ)
-- =====================================================
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    wait(0.5) -- Даём игре время на спавн
    if speedActive then
        applySpeed(newChar)
    end
    if noclipActive then
        startNoclip()
    end
end)

-- Если персонаж уже есть (при первом запуске)
if player.Character then
    wait(0.5)
    if speedActive then
        applySpeed(player.Character)
    end
    if noclipActive then
        startNoclip()
    end
end

print("✅ APEX V7.5 ЗАГРУЖЕН! Speed + Noclip (с обходом античита).")
