-- =====================================================
-- APEX V7.1 - SPEED + X-RAY + СМАЙЛИК (РАБОЧАЯ ВЕРСИЯ)
-- Основано на RP2.0.lua, только нужные функции
-- =====================================================

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local runService = game:GetService("RunService")

-- ===== НАСТРОЙКИ =====
local SPEED_VALUE = 50 -- Стартовая скорость
local XRAY_DISTANCE = 1000 -- Дальность X-Ray (можно увеличить)

-- ===== GUI - ОКНО С ВКЛАДКАМИ =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ApexV7_1"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = screenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.Text = "⚡ APEX V7.1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- ===== ВКЛАДКИ =====
local Tabs = {"Speed", "X-Ray", "Смайлик"}
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

-- ===== ФУНКЦИЯ ПОИСКА РОЗЫСКА (из RP2.0) =====
local function isWanted(p)
    local char = p.Character
    if not char then return false end
    local markers = {"Wanted", "Criminal", "Bounty", "Arrested", "Suspect", "Crime"}
    for _, name in ipairs(markers) do
        if p:FindFirstChild(name) or char:FindFirstChild(name) then
            return true
        end
    end
    if p:GetAttribute("Wanted") or p:GetAttribute("Criminal") then
        return true
    end
    if char:FindFirstChild("tags") and char.tags:FindFirstChild("Wanted") then
        return true
    end
    return false
end

-- =====================================================
--  ВКЛАДКА SPEED (с кнопками +5/-5)
-- =====================================================
local speedTab = TabContents[1]
local speedActive = false
local speedVal = SPEED_VALUE

local speedLabel = createLabel(speedTab, "Скорость: " .. speedVal, 10)

local function applySpeed(char)
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid and speedActive then
        humanoid.WalkSpeed = speedVal
        print("⚡ Скорость установлена: " .. speedVal)
    end
end

-- Кнопки +5 / -5
local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0.2, 0, 0, 25)
plusBtn.Position = UDim2.new(0.05, 0, 0, 40)
plusBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
plusBtn.Text = "+5"
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.TextScaled = true
plusBtn.Font = Enum.Font.GothamBold
plusBtn.Parent = speedTab
plusBtn.MouseButton1Click:Connect(function()
    speedVal = speedVal + 5
    speedLabel.Text = "Скорость: " .. speedVal
    if speedActive and player.Character then
        applySpeed(player.Character)
    end
end)

local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0.2, 0, 0, 25)
minusBtn.Position = UDim2.new(0.3, 0, 0, 40)
minusBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
minusBtn.Text = "-5"
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.TextScaled = true
minusBtn.Font = Enum.Font.GothamBold
minusBtn.Parent = speedTab
minusBtn.MouseButton1Click:Connect(function()
    speedVal = math.max(0, speedVal - 5)
    speedLabel.Text = "Скорость: " .. speedVal
    if speedActive and player.Character then
        applySpeed(player.Character)
    end
end)

createButton(speedTab, "Speed", 75, function(state)
    speedActive = state
    if state and player.Character then
        applySpeed(player.Character)
    end
end)

-- =====================================================
--  ВКЛАДКА X-RAY (улучшенная дальность)
-- =====================================================
local xrayTab = TabContents[2]
local xrayHighlights = {}
local xrayActive = false

local function updateXRay()
    if not xrayActive then
        for _, hl in pairs(xrayHighlights) do
            if hl and hl.Parent then hl:Destroy() end
        end
        xrayHighlights = {}
        return
    end

    for _, p in ipairs(game.Players:GetPlayers()) do
        if p == player then continue end
        if not isWanted(p) then
            if xrayHighlights[p] then
                xrayHighlights[p]:Destroy()
                xrayHighlights[p] = nil
            end
            continue
        end
        local char = p.Character
        if char then
            local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
            if torso then
                if not xrayHighlights[p] then
                    local hl = Instance.new("Highlight")
                    hl.Adornee = torso
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.FillTransparency = 0.2
                    hl.OutlineTransparency = 1
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Enabled = true
                    hl.Parent = torso
                    xrayHighlights[p] = hl
                end
            end
        end
    end

    for p, hl in pairs(xrayHighlights) do
        if not p.Parent or not isWanted(p) then
            hl:Destroy()
            xrayHighlights[p] = nil
        end
    end
end

createButton(xrayTab, "X-Ray", 10, function(state)
    xrayActive = state
    updateXRay()
end)

-- =====================================================
--  ВКЛАДКА СМАЙЛИК 👮
-- =====================================================
local smileTab = TabContents[3]
local smileActive = false
local smileLabels = {}

local function updateSmile()
    if not smileActive then
        for _, lbl in pairs(smileLabels) do
            if lbl and lbl.Parent then lbl:Destroy() end
        end
        smileLabels = {}
        return
    end

    for _, p in ipairs(game.Players:GetPlayers()) do
        if p == player then continue end
        if not isWanted(p) then
            if smileLabels[p] then
                smileLabels[p]:Destroy()
                smileLabels[p] = nil
            end
            continue
        end
        local char = p.Character
        if char then
            local head = char:FindFirstChild("Head")
            if head then
                if not smileLabels[p] then
                    local label = Instance.new("BillboardGui")
                    label.Name = "SmileLabel"
                    label.Size = UDim2.new(0, 80, 0, 80)
                    label.Adornee = head
                    label.AlwaysOnTop = true
                    label.StudsOffset = Vector3.new(0, 3, 0)
                    label.Parent = head

                    local text = Instance.new("TextLabel")
                    text.Size = UDim2.new(1, 0, 1, 0)
                    text.BackgroundTransparency = 1
                    text.Text = "👮"
                    text.TextColor3 = Color3.fromRGB(255, 255, 255)
                    text.TextScaled = true
                    text.Font = Enum.Font.GothamBold
                    text.Parent = label

                    smileLabels[p] = label
                end
            end
        end
    end

    for p, lbl in pairs(smileLabels) do
        if not p.Parent or not isWanted(p) then
            lbl:Destroy()
            smileLabels[p] = nil
        end
    end
end

createButton(smileTab, "Смайлик 👮", 10, function(state)
    smileActive = state
    updateSmile()
end)

-- =====================================================
--  ОБРАБОТКА ПЕРЕРОЖДЕНИЯ (скорость не сбрасывается)
-- =====================================================
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    wait(0.5)
    if speedActive then applySpeed(newChar) end
    if xrayActive then updateXRay() end
    if smileActive then updateSmile() end
end)

-- Если персонаж уже есть
if player.Character then
    wait(0.5)
    if speedActive then applySpeed(player.Character) end
    if xrayActive then updateXRay() end
    if smileActive then updateSmile() end
end

print("✅ APEX V7.1 загружен! Speed + X-Ray + Смайлик.")
