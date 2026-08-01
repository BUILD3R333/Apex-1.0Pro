-- =============================================
-- APEX LITE - SPEED + NOCLIP
-- Маленькое меню, только нужные функции
-- =============================================

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local runService = game:GetService("RunService")

-- ===== НАСТРОЙКИ (МЕНЯЙ ЗНАЧЕНИЯ) =====
local SPEED_VALUE = 300 -- СЮДА ПИШИ ЛЮБУЮ СКОРОСТЬ

-- ===== GUI - МАЛЕНЬКОЕ МЕНЮ =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ApexLite"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 150)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = screenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.Text = "⚡ SPEED + NOCLIP"
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

-- ===== SPEED (БАГ ПОСЛЕ СМЕРТИ) =====
local speedActive = false

local function applySpeed(char)
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid and speedActive then
        humanoid.WalkSpeed = SPEED_VALUE
        print("⚡ Скорость установлена: " .. SPEED_VALUE)
    end
end

createButton(MainFrame, "Speed (после смерти)", 35, function(state)
    speedActive = state
    if state and player.Character then
        applySpeed(player.Character)
    end
end)

-- КНОПКА "УМЕРЕТЬ" (активирует баг)
local respawnBtn = Instance.new("TextButton")
respawnBtn.Size = UDim2.new(0.4, 0, 0, 25)
respawnBtn.Position = UDim2.new(0.55, 0, 0, 35)
respawnBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
respawnBtn.Text = "💀 Умереть"
respawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
respawnBtn.TextScaled = true
respawnBtn.Font = Enum.Font.GothamBold
respawnBtn.Parent = MainFrame
respawnBtn.MouseButton1Click:Connect(function()
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid then humanoid.Health = 0 end
end)

-- ===== NOCLIP (РАБОЧИЙ) =====
local noclipActive = false
local noclipConnection = nil

local function startNoclip()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CanCollide = false end
    noclipConnection = runService.Heartbeat:Connect(function()
        if char and char.PrimaryPart then
            char.PrimaryPart.CanCollide = false
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
    if hrp then hrp.CanCollide = true end
end

createButton(MainFrame, "Noclip", 70, function(state)
    noclipActive = state
    if state then
        startNoclip()
    else
        stopNoclip()
    end
end)

-- ===== ОБРАБОТКА ПЕРЕРОЖДЕНИЯ =====
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    wait(0.5)
    if speedActive then applySpeed(newChar) end
    if noclipActive then startNoclip() end
end)

-- Если персонаж уже есть
if player.Character then
    wait(0.5)
    if speedActive then applySpeed(player.Character) end
    if noclipActive then startNoclip() end
end

print("✅ APEX LITE загружен! Speed + Noclip.")
