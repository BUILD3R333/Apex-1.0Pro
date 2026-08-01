-- =====================================================
-- APEX V7 - FULL PACKAGE (with number input for walkspeed)
-- =====================================================

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local cam = workspace.CurrentCamera
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- ===== НАСТРОЙКИ ПО УМОЛЧАНИЮ =====
local Settings = {
    XRayMode = 1,
    AimbotMode = 1,
    AimbotSmooth = 0.12,
    FlySpeed = 50,
    WalkSpeedVal = 50,
}

-- ===== GUI - ОКНО С ВКЛАДКАМИ =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ApexV7"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 550, 0, 450)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = screenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.Text = "🔴 APEX V7"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- ===== СОЗДАНИЕ ВКЛАДОК =====
local Tabs = {"X-Ray", "Aimbot", "Movement"}
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

local function createDropdown(parent, text, y, options, callback)
    local lbl = createLabel(parent, text, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.4, 0, 0, 25)
    btn.Position = UDim2.new(0.55, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = options[1]
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    local index = 1
    btn.MouseButton1Click:Connect(function()
        index = index % #options + 1
        btn.Text = options[index]
        callback(index)
    end)
    return btn
end

-- НОВАЯ ФУНКЦИЯ: текстовое поле + кнопки +/-
local function createNumberInput(parent, text, y, default, step, minVal, maxVal, callback)
    local lbl = createLabel(parent, text .. ": " .. tostring(default), y)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.5, 0, 0, 30)
    frame.Position = UDim2.new(0.45, 0, 0, y-2)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local minus = Instance.new("TextButton")
    minus.Size = UDim2.new(0.2, 0, 1, 0)
    minus.Position = UDim2.new(0, 0, 0, 0)
    minus.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    minus.Text = "-"
    minus.TextColor3 = Color3.fromRGB(255, 255, 255)
    minus.TextScaled = true
    minus.Font = Enum.Font.GothamBold
    minus.Parent = frame

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.6, 0, 1, 0)
    textBox.Position = UDim2.new(0.2, 0, 0, 0)
    textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    textBox.Text = tostring(default)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.TextScaled = true
    textBox.Font = Enum.Font.GothamBold
    textBox.ClearTextOnFocus = false
    textBox.Parent = frame

    local plus = Instance.new("TextButton")
    plus.Size = UDim2.new(0.2, 0, 1, 0)
    plus.Position = UDim2.new(0.8, 0, 0, 0)
    plus.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    plus.Text = "+"
    plus.TextColor3 = Color3.fromRGB(255, 255, 255)
    plus.TextScaled = true
    plus.Font = Enum.Font.GothamBold
    plus.Parent = frame

    local val = default
    local function updateDisplay()
        textBox.Text = tostring(val)
        lbl.Text = text .. ": " .. tostring(val)
        callback(val)
    end

    minus.MouseButton1Click:Connect(function()
        val = math.max(minVal, val - step)
        updateDisplay()
    end)

    plus.MouseButton1Click:Connect(function()
        val = math.min(maxVal, val + step)
        updateDisplay()
    end)

    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local num = tonumber(textBox.Text)
            if num then
                val = math.max(minVal, math.min(maxVal, num))
                updateDisplay()
            else
                textBox.Text = tostring(val)
            end
        end
    end)

    return textBox
end

-- ===== ФУНКЦИЯ ПОИСКА РОЗЫСКА =====
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
--  ВКЛАДКА X-RAY
-- =====================================================
local xrayTab = TabContents[1]
local xrayHighlights = {}
local xrayActive = false
local xrayMode = Settings.XRayMode

local function getColorsForPlayer(p)
    if xrayMode == 1 then
        if isWanted(p) then return Color3.fromRGB(255, 0, 0), 0.2 else return nil, nil end
    elseif xrayMode == 2 then
        if isWanted(p) then return Color3.fromRGB(255, 0, 0), 0.2 else return Color3.fromRGB(0, 200, 255), 0.2 end
    elseif xrayMode == 3 then
        if isWanted(p) then return Color3.fromRGB(255, 0, 0), 0.2 else return Color3.fromRGB(0, 100, 255), 0.15 end
    end
    return nil, nil
end

local function updateXRay()
    if not xrayActive then
        for _, hl in pairs(xrayHighlights) do if hl and hl.Parent then hl:Destroy() end end
        xrayHighlights = {}
        return
    end
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p == player then continue end
        local color, transp = getColorsForPlayer(p)
        if not color then
            if xrayHighlights[p] then xrayHighlights[p]:Destroy(); xrayHighlights[p] = nil end
            continue
        end
        local char = p.Character
        if char then
            local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
            if torso then
                if not xrayHighlights[p] then
                    local hl = Instance.new("Highlight")
                    hl.Adornee = torso
                    hl.FillTransparency = transp
                    hl.OutlineTransparency = 1
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Enabled = true
                    hl.Parent = torso
                    xrayHighlights[p] = hl
                end
                xrayHighlights[p].FillColor = color
                xrayHighlights[p].FillTransparency = transp
            end
        end
    end
    for p, hl in pairs(xrayHighlights) do
        if not p.Parent then hl:Destroy(); xrayHighlights[p] = nil end
    end
end

createButton(xrayTab, "X-Ray", 10, function(state)
    xrayActive = state
    updateXRay()
end)

local modeOptions = {"Только розыск", "Все игроки", "Розыск/Мирные"}
createDropdown(xrayTab, "Режим:", 50, modeOptions, function(idx)
    xrayMode = idx
    if xrayActive then updateXRay() end
end)

game.Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() if xrayActive then updateXRay() end end)
end)
game.Players.PlayerRemoving:Connect(function(p)
    if xrayHighlights[p] then xrayHighlights[p]:Destroy(); xrayHighlights[p] = nil end
end)

-- =====================================================
--  ВКЛАДКА AIMBOT
-- =====================================================
local aimbotTab = TabContents[2]
local aimbotActive = false
local aimbotMode = Settings.AimbotMode
local aimbotSmooth = Settings.AimbotSmooth
local currentTarget = nil

local function canSee(position)
    local origin = cam.CFrame.Position
    local dir = (position - origin).Unit
    local dist = (position - origin).Magnitude
    local ray = Ray.new(origin, dir * dist)
    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {player.Character})
    if hit then
        local hitChar = hit.Parent
        while hitChar and hitChar.Parent do
            if hitChar:IsA("Model") and hitChar:FindFirstChild("Humanoid") then
                return true
            end
            hitChar = hitChar.Parent
        end
        return false
    end
    return true
end

local function getTarget()
    local bestTarget, bestAngle = nil, 90
    local origin = cam.CFrame.Position
    local fov = 60
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p == player then continue end
        if aimbotMode == 2 and not isWanted(p) then continue end
        if aimbotMode == 3 and isWanted(p) then continue end
        local char = p.Character
        if not char then continue end
        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        if not torso then continue end
        if not canSee(torso.Position) then continue end
        local dir = (torso.Position - origin).Unit
        local angle = math.deg(math.acos(cam.CFrame.LookVector:Dot(dir)))
        if angle < fov and angle < bestAngle then
            bestAngle = angle
            bestTarget = torso
        end
    end
    return bestTarget
end

runService.RenderStepped:Connect(function()
    if not aimbotActive then return end
    if currentTarget and currentTarget.Parent and currentTarget.Parent:FindFirstChild("Humanoid") and currentTarget.Parent.Humanoid.Health > 0 then
        local targetPos = currentTarget.Position
        local offset = Vector3.new((math.random()-0.5)*0.5, (math.random()-0.5)*0.5, 0)
        local aimPos = targetPos + offset
        local newCF = CFrame.new(cam.CFrame.Position, aimPos)
        cam.CFrame = cam.CFrame:Lerp(newCF, aimbotSmooth)
    else
        currentTarget = getTarget()
    end
end)

createButton(aimbotTab, "Aimbot", 10, function(state)
    aimbotActive = state
    if not state then currentTarget = nil end
end)

createDropdown(aimbotTab, "Цель:", 50, {"Все", "Только розыск", "Мирные"}, function(idx)
    aimbotMode = idx
end)

createSlider(aimbotTab, "Плавность", 90, 0.05, 0.3, 0.01, aimbotSmooth, function(val)
    aimbotSmooth = val
end)

-- =====================================================
--  ВКЛАДКА MOVEMENT (Fly, Noclip, Invisible, WalkSpeed)
-- =====================================================
local movTab = TabContents[3]
local yPos = 10

-- Fly
local flyActive = false
local flyBodyVelocity = nil
local flySpeed = Settings.FlySpeed

local function startFly()
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    humanoid.PlatformStand = true
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyBodyVelocity.Parent = hrp
        hrp.Gravity = 0
    end
end

local function stopFly()
    if flyBodyVelocity then
        flyBodyVelocity:Destroy()
        flyBodyVelocity = nil
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.Gravity = 196.2 end
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then humanoid.PlatformStand = false end
end

createButton(movTab, "Fly", yPos, function(state)
    flyActive = state
    if state then startFly() else stopFly() end
end)
yPos = yPos + 40

-- Вместо слайдера для скорости полёта – числовой ввод
createNumberInput(movTab, "Скорость полёта", yPos, flySpeed, 5, 1, 10000, function(val)
    flySpeed = val
end)
yPos = yPos + 40

-- Управление Fly
uis.InputBegan:Connect(function(input)
    if flyActive and flyBodyVelocity and input.UserInputType == Enum.UserInputType.Keyboard then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local speed = flySpeed
        local dir = Vector3.new(0,0,0)
        if input.KeyCode == Enum.KeyCode.W then dir = cam.CFrame.LookVector end
        if input.KeyCode == Enum.KeyCode.S then dir = -cam.CFrame.LookVector end
        if input.KeyCode == Enum.KeyCode.A then dir = -cam.CFrame.RightVector end
        if input.KeyCode == Enum.KeyCode.D then dir = cam.CFrame.RightVector end
        if input.KeyCode == Enum.KeyCode.Space then dir = Vector3.new(0, 1, 0) end
        if input.KeyCode == Enum.KeyCode.LeftShift then dir = Vector3.new(0, -1, 0) end
        flyBodyVelocity.Velocity = dir * speed
    end
end)

-- Noclip
local noclipActive = false
local noclipConnection = nil

local function startNoclip()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CanCollide = false end
    noclipConnection = runService.Heartbeat:Connect(function()
        if char and char.PrimaryPart then
            char.PrimaryPart.CanCollide = false
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

createButton(movTab, "Noclip", yPos, function(state)
    noclipActive = state
    if state then startNoclip() else stopNoclip() end
end)
yPos = yPos + 40

-- Invisible
local invisibleActive = false

local function setInvisible(state)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.LocalTransparencyModifier = state and 1 or 0
        end
    end
end

createButton(movTab, "Invisible", yPos, function(state)
    invisibleActive = state
    setInvisible(state)
end)
yPos = yPos + 40

-- WalkSpeed – ЗАМЕНЯЕМ СЛАЙДЕР НА ЧИСЛОВОЙ ВВОД
local speedActive = false
local speedVal = Settings.WalkSpeedVal
local speedConnection = nil

local function applySpeed(state)
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    if state then
        speedConnection = runService.Heartbeat:Connect(function()
            if char and char.PrimaryPart and humanoid.MoveDirection.Magnitude > 0.1 then
                local moveDir = humanoid.MoveDirection.Unit * speedVal
                char.PrimaryPart.Velocity = Vector3.new(moveDir.X, char.PrimaryPart.Velocity.Y, moveDir.Z)
            end
        end)
    else
        if speedConnection then
            speedConnection:Disconnect()
            speedConnection = nil
        end
        if char and char.PrimaryPart then
            char.PrimaryPart.Velocity = Vector3.new(0, char.PrimaryPart.Velocity.Y, 0)
        end
        humanoid.WalkSpeed = 16
    end
end

createButton(movTab, "WalkSpeed", yPos, function(state)
    speedActive = state
    applySpeed(state)
end)
yPos = yPos + 40

-- ВОТ ЗДЕСЬ ВСТАВЛЯЕМ ЧИСЛОВОЙ ВВОД ВМЕСТО СЛАЙДЕРА
createNumberInput(movTab, "Скорость ходьбы", yPos, speedVal, 5, 1, 10000, function(val)
    speedVal = val
    if speedActive then
        applySpeed(false)
        wait(0.1)
        applySpeed(true)
    end
end)

-- =====================================================
--  ОБРАБОТКА ПЕРЕРОЖДЕНИЯ
-- =====================================================
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    if flyActive then startFly() end
    if noclipActive then startNoclip() end
    if invisibleActive then setInvisible(true) end
    if speedActive then applySpeed(true) end
    if xrayActive then updateXRay() end
end)

-- =====================================================
--  ЗАЩИТА ОТ ТЕЛЕПОРТАЦИИ
-- =====================================================
runService.Heartbeat:Connect(function()
    if flyActive or noclipActive then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CanCollide = not noclipActive
            if flyActive then
                hrp.Velocity = Vector3.new(0, 0, 0)
                hrp.Gravity = 0
            end
        end
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid and flyActive then
            humanoid.PlatformStand = true
        end
    end
end)

print("✅ APEX V7 ЗАГРУЖЕН! Для скорости ходьбы можно вводить любое число до 10000.")
