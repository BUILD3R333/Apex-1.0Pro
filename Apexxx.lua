-- =============================================
-- APEX V9 - SPEED + NOCLIP (ФИНАЛ)
-- =============================================

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local runService = game:GetService("RunService")

-- ===== НАСТРОЙКИ =====
local SPEED_VALUE = 50 -- Стартовая скорость

-- ===== GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ApexV9"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = screenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.Text = "⚡ APEX V9"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- ===== ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ =====
local function createButton(parent, text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 28)
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
    return btn
end

-- ===== SPEED =====
local speedActive = false
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.9, 0, 0, 25)
speedLabel.Position = UDim2.new(0.05, 0, 0, 40)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Скорость: " .. SPEED_VALUE
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = MainFrame

local function updateSpeedLabel()
    speedLabel.Text = "Скорость: " .. SPEED_VALUE
end

local function applySpeed(char)
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid and speedActive then
        humanoid.WalkSpeed = SPEED_VALUE
        print("⚡ Скорость установлена: " .. SPEED_VALUE)
    end
end

-- Кнопки +5 / -5
local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0.2, 0, 0, 25)
plusBtn.Position = UDim2.new(0.05, 0, 0, 70)
plusBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
plusBtn.Text = "+5"
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.TextScaled = true
plusBtn.Font = Enum.Font.GothamBold
plusBtn.Parent = MainFrame
plusBtn.MouseButton1Click:Connect(function()
    SPEED_VALUE = SPEED_VALUE + 5
    updateSpeedLabel()
    if speedActive and player.Character then
        applySpeed(player.Character)
    end
end)

local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0.2, 0, 0, 25)
minusBtn.Position = UDim2.new(0.3, 0, 0, 70)
minusBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
minusBtn.Text = "-5"
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.TextScaled = true
minusBtn.Font = Enum.Font.GothamBold
minusBtn.Parent = MainFrame
minusBtn.MouseButton1Click:Connect(function()
    SPEED_VALUE = math.max(0, SPEED_VALUE - 5)
    updateSpeedLabel()
    if speedActive and player.Character then
        applySpeed(player.Character)
    end
end)

createButton(MainFrame, "Speed", 105, function(state)
    speedActive = state
    if state and player.Character then
        applySpeed(player.Character)
    end
end)

-- Кнопка "Умереть"
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

-- ===== NOCLIP =====
local noclipActive = false
local noclipConnection = nil

local function startNoclip()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CanCollide = false end
    noclipConnection = runService.Heartbeat:Connect(function()
        if char and char.PrimaryPart then
            char.PrimaryPart.CanCollide = false
            local pos = char.PrimaryPart.Position
            char.PrimaryPart.Position = pos + Vector3.new(0, 0.01, 0)
            if pos.Y < -10 then
                char.PrimaryPart.Position = Vector3.new(pos.X, 10, pos.Z)
            end
        end
    end)
end

local function stopNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CanCollide = true end
end

createButton(MainFrame, "Noclip", 145, function(state)
    noclipActive = state
    if state then startNoclip() else stopNoclip() end
end)

-- ===== ПЕРЕРОЖДЕНИЕ =====
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    wait(0.5)
    if speedActive then applySpeed(newChar) end
    if noclipActive then startNoclip() end
end)

if player.Character then
    wait(0.5)
    if speedActive then applySpeed(player.Character) end
    if noclipActive then startNoclip() end
end

print("✅ APEX V9 загружен! Speed + Noclip.")
