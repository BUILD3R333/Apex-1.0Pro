-- =====================================================
-- APEX V4 - ВСЕ ФУНКЦИИ В ОДНОМ
-- X-Ray + Aimbot + Fly + Noclip + Invisible
-- Для ролевых игр (San Diego Border и др.)
-- =====================================================

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local cam = workspace.CurrentCamera
local mouse = player:GetMouse()
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- ===== НАСТРОЙКИ =====
local SETTINGS = {
    XRayColor = Color3.fromRGB(255, 0, 0),
    XRayTransparency = 0.25,
    AimbotSmooth = 0.12,
    AimbotFOV = 60,
    MaxDistance = 500,
    FlySpeed = 50,
    NoclipSpeed = 30,
}

-- ===== GUI (КРУГ + МЕНЮ) =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ApexV4"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- КНОПКА-КРУГ (перетаскиваемая)
local circleBtn = Instance.new("ImageButton")
circleBtn.Size = UDim2.new(0, 45, 0, 45)
circleBtn.Position = UDim2.new(0.01, 0, 0.5, -22)
circleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
circleBtn.BackgroundTransparency = 0.1
circleBtn.Image = "rbxassetid://5816666308"
circleBtn.ImageColor3 = Color3.fromRGB(255, 0, 0)
circleBtn.ScaleType = Enum.ScaleType.Fit
circleBtn.Parent = screenGui

-- Перетаскивание
local dragging = false
local dragStart, startPos
circleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = circleBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
uis.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        circleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- МЕНЮ (появляется при клике на круг)
local menuOpen = false
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 170, 0, 200)
menu.Position = UDim2.new(0, 55, 0, -30)
menu.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
menu.BackgroundTransparency = 0.15
menu.BorderSizePixel = 0
menu.Visible = false
menu.Parent = circleBtn

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Text = "🔴 APEX V4"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = menu

-- Функция создания кнопки в меню
local function createMenuButton(text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 22)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = text .. " OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = menu
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(50, 50, 50)
        btn.Text = text .. (state and " ON" or " OFF")
        callback(state)
    end)
    return btn
end

circleBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    menu.Visible = menuOpen
end)

-- ===== ФУНКЦИЯ ПОИСКА РОЗЫСКА =====
local function isWanted(player)
    local char = player.Character
    if not char then return false end
    -- Проверка различных маркеров
    local markers = {"Wanted", "Criminal", "Bounty", "Arrested", "Suspect", "Crime"}
    for _, name in ipairs(markers) do
        if player:FindFirstChild(name) or char:FindFirstChild(name) then
            return true
        end
    end
    -- Проверка атрибутов
    if player:GetAttribute("Wanted") or player:GetAttribute("Criminal") then
        return true
    end
    -- Проверка папок / тегов
    if char:FindFirstChild("tags") and char.tags:FindFirstChild("Wanted") then
        return true
    end
    return false
end

-- ===== X-RAY (КРАСНЫЙ ТОРС, ДАЛЬНОСТЬ БЕЗ ОГРАНИЧЕНИЙ) =====
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
        if p ~= player and isWanted(p) then
            local char = p.Character
            if char then
                local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                if torso and not xrayHighlights[p] then
                    local hl = Instance.new("Highlight")
                    hl.Adornee = torso
                    hl.FillColor = SETTINGS.XRayColor
                    hl.FillTransparency = SETTINGS.XRayTransparency
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

createMenuButton("X-Ray", 28, function(state)
    xrayActive = state
    updateXRay()
end)

-- Обновление при появлении игроков
game.Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(updateXRay)
end)
game.Players.PlayerRemoving:Connect(function(p)
    if xrayHighlights[p] then
        xrayHighlights[p]:Destroy()
        xrayHighlights[p] = nil
    end
end)

-- ===== AIMBOT (УДЕРЖАНИЕ ЦЕЛИ, ПРОВЕРКА ВИДИМОСТИ) =====
local aimbotActive = false
local currentTarget = nil

local function canSee(position)
    local origin = cam.CFrame.Position
    local direction = (position - origin).Unit
    local distance = (position - origin).Magnitude
    local ray = Ray.new(origin, direction * distance)
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
    local bestTarget, bestAngle = nil, SETTINGS.AimbotFOV
    local origin = cam.CFrame.Position
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= player and isWanted(p) and p.Character then
            local torso = p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("Torso")
            if torso and canSee(torso.Position) then
                local dir = (torso.Position - origin).Unit
                local angle = math.deg(math.acos(cam.CFrame.LookVector:Dot(dir)))
                local dist = (torso.Position - origin).Magnitude
                if angle < bestAngle and dist < SETTINGS.MaxDistance then
                    bestAngle = angle
                    bestTarget = torso
                end
            end
        end
    end
    return bestTarget
end

runService.RenderStepped:Connect(function()
    if aimbotActive then
        -- Если цель мертва или пропала, ищем новую
        if currentTarget and currentTarget.Parent and currentTarget.Parent:FindFirstChild("Humanoid") and currentTarget.Parent.Humanoid.Health > 0 then
            -- Удерживаем текущую цель
            local targetPos = currentTarget.Position
            -- Случайное отклонение (имитация руки)
            local offset = Vector3.new((math.random()-0.5)*0.5, (math.random()-0.5)*0.5, 0)
            local aimPos = targetPos + offset
            local newCF = CFrame.new(cam.CFrame.Position, aimPos)
            cam.CFrame = cam.CFrame:Lerp(newCF, SETTINGS.AimbotSmooth)
        else
            -- Ищем новую цель
            currentTarget = getTarget()
        end
    end
end)

createMenuButton("Aimbot", 53, function(state)
    aimbotActive = state
    if not state then currentTarget = nil end
end)

-- ===== FLY (БЕЗ АНТИФЛАЯ) =====
local flyActive = false
local flyBodyVelocity = nil

local function startFly()
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    humanoid.PlatformStand = true
    -- Создаём BodyVelocity для управления
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
    -- Отключаем гравитацию
    char:FindFirstChild("HumanoidRootPart").Gravity = 0
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

uis.InputBegan:Connect(function(input)
    if flyActive and input.UserInputType == Enum.UserInputType.Keyboard then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp or not flyBodyVelocity then return end
        local speed = SETTINGS.FlySpeed
        local moveDir = Vector3.new(0,0,0)
        if input.KeyCode == Enum.KeyCode.W then moveDir = cam.CFrame.LookVector * speed end
        if input.KeyCode == Enum.KeyCode.S then moveDir = -cam.CFrame.LookVector * speed end
        if input.KeyCode == Enum.KeyCode.A then moveDir = -cam.CFrame.RightVector * speed end
        if input.KeyCode == Enum.KeyCode.D then moveDir = cam.CFrame.RightVector * speed end
        if input.KeyCode == Enum.KeyCode.Space then moveDir = Vector3.new(0, speed, 0) end
        if input.KeyCode == Enum.KeyCode.LeftShift then moveDir = Vector3.new(0, -speed, 0) end
        flyBodyVelocity.Velocity = moveDir
    end
end)

createMenuButton("Fly", 78, function(state)
    flyActive = state
    if state then
        startFly()
    else
        stopFly()
    end
end)

-- ===== NOCLIP (БЕЗ ПЕРЕКИДЫВАНИЯ) =====
local noclipActive = false
local noclipConnection = nil

local function startNoclip()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CanCollide = false
    -- Каждые 0.1 сек обновляем позицию, чтобы сервер не вернул
    noclipConnection = runService.Heartbeat:Connect(function()
        if char and char.PrimaryPart then
            char.PrimaryPart.CanCollide = false
            -- Небольшое смещение, чтобы "обмануть" сервер
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

createMenuButton("Noclip", 103, function(state)
    noclipActive = state
    if state then
        startNoclip()
    else
        stopNoclip()
    end
end)

-- ===== INVISIBLE (НЕВИДИМОСТЬ) =====
local invisibleActive = false

local function setInvisible(state)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.LocalTransparencyModifier = state and 1 or 0
        end
    end
end

createMenuButton("Invisible", 128, function(state)
    invisibleActive = state
    setInvisible(state)
end)

-- ===== ОБРАБОТКА ПЕРЕРОЖДЕНИЯ ПЕРСОНАЖА =====
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    -- Перезапускаем активные функции
    if flyActive then startFly() end
    if noclipActive then startNoclip() end
    if invisibleActive then setInvisible(true) end
    updateXRay()
end)

-- ===== ОБРАБОТКА СМЕРТИ (уберегаем от падений) =====
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    wait(0.5) -- ждём появления персонажа
    if flyActive then startFly() end
    if noclipActive then startNoclip() end
end)

-- ===== ЗАЩИТА ОТ ВЫКИДЫВАНИЯ =====
-- Отключаем стандартные коллизии и падения при включённом Fly/Noclip
runService.Heartbeat:Connect(function()
    if flyActive or noclipActive then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CanCollide = (not noclipActive)
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

print("✅ Apex V4 загружен! Все функции активны.")
