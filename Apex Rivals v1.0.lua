-- ==========================================
-- 🔺 Apex Rivals | Cyber Apex UI — ЧАСТЬ 1/3
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- ==========================================
-- 1. СОСТОЯНИЯ
-- ==========================================

local states = {
    SilentAim = false, Aimbot = false, Triggerbot = false, Wallbang = false,
    NoRecoil = false, NoSpread = false, Ragebot = false, HitboxExpand = false,
    SpeedHack = false, Fly = false, Noclip = false, InfiniteJump = false,
    AutoBhop = false, AntiAim = false, PlayerESP = false, BoxESP = false,
    SkeletonESP = false, Chams = false, BulletTracers = false, SkinChanger = false,
    AutoQueue = false, AutoOpenCases = false, FPSBooster = false, InfiniteStamina = false,
    AntiKick = false, AimPart = "Head",
    WalkSpeed = 16, FlySpeed = 50, AimbotFOV = 60, HitboxSize = 2
}
local espObjects = {}
local flyBV, flyBG
local uiElements = {btns = {}, labels = {}}
local currentWeapon = nil
local tracerObjects = {}

-- ==========================================
-- 2. GUI (КИБЕР-СТИЛЬ)
-- ==========================================

local ApexGui = Instance.new("ScreenGui")
ApexGui.Name = "ApexRivals"
ApexGui.ResetOnSpawn = false
if gethui then ApexGui.Parent = gethui() elseif syn and syn.protect_gui then syn.protect_gui(ApexGui); ApexGui.Parent = CoreGui else ApexGui.Parent = CoreGui end

-- Главная кнопка
local OpenBtn = Instance.new("ImageButton", ApexGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0, 100)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
OpenBtn.BackgroundTransparency = 0.1
OpenBtn.BorderSizePixel = 0
OpenBtn.Image = "rbxassetid://6031093079"
OpenBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

local shadowBtn = Instance.new("ImageLabel", OpenBtn)
shadowBtn.Size = UDim2.new(1, 8, 1, 8)
shadowBtn.Position = UDim2.new(0, -4, 0, -4)
shadowBtn.BackgroundTransparency = 1
shadowBtn.Image = "rbxassetid://1316048950"
shadowBtn.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadowBtn.ImageTransparency = 0.6

-- Главное окно
local MainWindow = Instance.new("Frame", ApexGui)
MainWindow.Size = UDim2.new(0, 380, 0, 450)
MainWindow.Position = UDim2.new(0.5, -190, 0.5, -225)
MainWindow.BackgroundColor3 = Color3.fromRGB(10, 12, 25)
MainWindow.BackgroundTransparency = 0.08
MainWindow.Visible = false
MainWindow.ClipsDescendants = true
Instance.new("UICorner", MainWindow).CornerRadius = UDim.new(0, 14)

local windowShadow = Instance.new("ImageLabel", MainWindow)
windowShadow.Size = UDim2.new(1, 24, 1, 24)
windowShadow.Position = UDim2.new(0, -12, 0, -12)
windowShadow.BackgroundTransparency = 1
windowShadow.Image = "rbxassetid://1316048950"
windowShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
windowShadow.ImageTransparency = 0.7
windowShadow.ZIndex = 0

-- Перетаскивание окна
local function makeWindowDraggable()
    local dragging = false
    local dragStart, startPos
    MainWindow.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainWindow.Position
        end
    end)
    MainWindow.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    MainWindow.InputEnded:Connect(function()
        dragging = false
    end)
end
makeWindowDraggable()

local closeBtn = Instance.new("TextButton", MainWindow)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(0.94, 0, 0.02, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 70)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

OpenBtn.MouseButton1Click:Connect(function() MainWindow.Visible = not MainWindow.Visible end)
closeBtn.MouseButton1Click:Connect(function() MainWindow.Visible = false end)

-- Боковая панель (аккордеон)
local Sidebar = Instance.new("Frame", MainWindow)
Sidebar.Size = UDim2.new(0, 110, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(8, 10, 20)
Sidebar.BackgroundTransparency = 0.2
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 0, 0, 14)

local ContentArea = Instance.new("Frame", MainWindow)
ContentArea.Size = UDim2.new(1, -110, 1, 0)
ContentArea.Position = UDim2.new(0, 110, 0, 0)
ContentArea.BackgroundTransparency = 1
-- ==========================================
-- 🔺 Apex Rivals | Cyber Apex UI — ЧАСТЬ 2/3
-- ==========================================

-- Функция для создания групп (аккордеонов)
local function createGroup(parent, title, icon)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Position = UDim2.new(0, 0, 0, (#parent:GetChildren() * 35) + 5)
    btn.BackgroundColor3 = Color3.fromRGB(20, 22, 40)
    btn.BackgroundTransparency = 0.3
    btn.Text = icon .. " " .. title
    btn.TextColor3 = Color3.fromRGB(180, 200, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local panel = Instance.new("Frame", parent)
    panel.Size = UDim2.new(1, 0, 0, 0)
    panel.Position = UDim2.new(0, 0, 0, (#parent:GetChildren() * 35) + 5)
    panel.BackgroundTransparency = 1
    panel.Visible = true
    panel.ClipsDescendants = true
    local layout = Instance.new("UIListLayout", panel)
    layout.Padding = UDim.new(0, 4)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local open = true
    btn.MouseButton1Click:Connect(function()
        open = not open
        panel.Visible = open
        btn.Text = (open and "▼ " or "▶ ") .. icon .. " " .. title
    end)

    return panel
end

-- Создаём группы
local groupCombat = createGroup(Sidebar, "Бой", "⚔️")
local groupMovement = createGroup(Sidebar, "Движение", "🏃")
local groupVisuals = createGroup(Sidebar, "Визуал", "👁️")
local groupAutomation = createGroup(Sidebar, "Авто", "🤖")

-- ==========================================
-- 3. ФУНКЦИИ СОЗДАНИЯ КНОПОК
-- ==========================================

local function createToggle(parent, name, stateKey, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.9, 0, 0, 28)
    btn.BackgroundColor3 = states[stateKey] and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(25, 28, 45)
    btn.BackgroundTransparency = 0.2
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name .. " [" .. (states[stateKey] and "ON" or "OFF") .. "]"
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    table.insert(uiElements.btns, {btn = btn, stateKey = stateKey})
    btn.MouseButton1Click:Connect(function()
        local newState = not states[stateKey]
        if callback then callback(newState) else states[stateKey] = newState end
        btn.Text = name .. " [" .. (states[stateKey] and "ON" or "OFF") .. "]"
        btn.BackgroundColor3 = states[stateKey] and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(25, 28, 45)
    end)
    return btn
end

local function createInput(parent, labelText, stateKey)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(0.9, 0, 0, 28)
    container.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(180, 200, 255)
    label.Text = labelText
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left

    local input = Instance.new("TextBox", container)
    input.Size = UDim2.new(0.35, 0, 1, 0)
    input.Position = UDim2.new(0.65, 0, 0, 0)
    input.BackgroundColor3 = Color3.fromRGB(20, 22, 40)
    input.BackgroundTransparency = 0.3
    input.TextColor3 = Color3.fromRGB(0, 200, 255)
    input.Text = tostring(states[stateKey])
    input.Font = Enum.Font.Gotham
    input.TextSize = 12
    input.BorderSizePixel = 0
    Instance.new("UICorner", input).CornerRadius = UDim.new(0, 4)
    input.FocusLost:Connect(function()
        local val = tonumber(input.Text)
        if val then states[stateKey] = val else input.Text = tostring(states[stateKey]) end
    end)
end

-- ==========================================
-- 4. НАПОЛНЕНИЕ ГРУПП
-- ==========================================

-- Группа "Бой"
createToggle(groupCombat, "Silent Aim", "SilentAim")
createToggle(groupCombat, "Aimbot", "Aimbot")
createToggle(groupCombat, "Triggerbot", "Triggerbot")
createToggle(groupCombat, "Wallbang", "Wallbang")
createToggle(groupCombat, "No Recoil", "NoRecoil")
createToggle(groupCombat, "No Spread", "NoSpread")
createToggle(groupCombat, "Ragebot", "Ragebot")
createToggle(groupCombat, "Hitbox Expand", "HitboxExpand")
createInput(groupCombat, "Hitbox Size", "HitboxSize")
createInput(groupCombat, "Aimbot FOV", "AimbotFOV")
-- Выбор части тела для аима
local aimPartBtn = Instance.new("TextButton", groupCombat)
aimPartBtn.Size = UDim2.new(0.9, 0, 0, 28)
aimPartBtn.BackgroundColor3 = Color3.fromRGB(25, 28, 45)
aimPartBtn.BackgroundTransparency = 0.2
aimPartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
aimPartBtn.Text = "🎯 Aim: " .. (states.AimPart == "Head" and "Голова" or "Торс")
aimPartBtn.Font = Enum.Font.Gotham
aimPartBtn.TextSize = 12
aimPartBtn.BorderSizePixel = 0
Instance.new("UICorner", aimPartBtn).CornerRadius = UDim.new(0, 6)
table.insert(uiElements.btns, {btn = aimPartBtn})
aimPartBtn.MouseButton1Click:Connect(function()
    if states.AimPart == "Head" then
        states.AimPart = "UpperTorso"
        aimPartBtn.Text = "🎯 Aim: Торс"
    else
        states.AimPart = "Head"
        aimPartBtn.Text = "🎯 Aim: Голова"
    end
end)

-- Группа "Движение"
createToggle(groupMovement, "Speed Hack", "SpeedHack")
createInput(groupMovement, "Walk Speed", "WalkSpeed")
createToggle(groupMovement, "Fly", "Fly")
createInput(groupMovement, "Fly Speed", "FlySpeed")
createToggle(groupMovement, "Noclip", "Noclip")
createToggle(groupMovement, "Infinite Jump", "InfiniteJump")
createToggle(groupMovement, "Auto-Bhop", "AutoBhop")
createToggle(groupMovement, "Anti-Aim", "AntiAim")
createToggle(groupMovement, "Infinite Stamina", "InfiniteStamina")

-- Группа "Визуал"
createToggle(groupVisuals, "Player ESP", "PlayerESP")
createToggle(groupVisuals, "Box ESP", "BoxESP")
createToggle(groupVisuals, "Skeleton ESP", "SkeletonESP")
createToggle(groupVisuals, "Chams", "Chams")
createToggle(groupVisuals, "Bullet Tracers", "BulletTracers")
createToggle(groupVisuals, "Skin Changer", "SkinChanger")
createToggle(groupVisuals, "FPS Booster", "FPSBooster")

-- Группа "Авто"
createToggle(groupAutomation, "🛡️ Anti-Kick", "AntiKick")
createToggle(groupAutomation, "Auto-Queue", "AutoQueue")
createToggle(groupAutomation, "Auto-Open Cases", "AutoOpenCases")
-- ==========================================
-- 🔺 Apex Rivals | Cyber Apex UI — ЧАСТЬ 3/3
-- ==========================================

-- ==========================================
-- 5. ФУНКЦИИ
-- ==========================================

-- Anti-Kick
LocalPlayer.Idled:Connect(function()
    if states.AntiKick then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(0.1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

-- God Mode (локальный)
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum and hum.Health > 0 then
            hum.Health = hum.MaxHealth
        end
    end
end)

-- No Recoil & No Spread
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            for _, child in pairs(tool:GetDescendants()) do
                if child:IsA("NumberValue") and child.Name == "Recoil" and states.NoRecoil then
                    child.Value = 0
                end
                if child:IsA("NumberValue") and child.Name == "Spread" and states.NoSpread then
                    child.Value = 0
                end
            end
        end
    end
end)

-- Infinite Stamina
RunService.Heartbeat:Connect(function()
    if states.InfiniteStamina and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            local stamina = hum:FindFirstChild("Stamina")
            if stamina then
                stamina.Value = 100
            end
        end
    end
end)

-- Speed Hack
RunService.Heartbeat:Connect(function()
    if states.SpeedHack and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = states.WalkSpeed
        end
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if states.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Fly
local function setFly(state)
    states.Fly = state
    if not LocalPlayer.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if state then
        flyBV = Instance.new("BodyVelocity", hrp)
        flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        flyBV.Velocity = Vector3.zero
        flyBG = Instance.new("BodyGyro", hrp)
        flyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        flyBG.P = 10000
        flyBG.CFrame = hrp.CFrame
    else
        if flyBV then flyBV:Destroy() end
        if flyBG then flyBG:Destroy() end
    end
end

RunService.RenderStepped:Connect(function()
    if states.Fly and flyBV and flyBG and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local move = Vector3.zero
            local cf = Camera.CFrame
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cf.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cf.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cf.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cf.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 1, 0) end
            if move.Magnitude > 0 then move = move.Unit end
            flyBV.Velocity = move * states.FlySpeed
            flyBG.CFrame = cf
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if states.InfiniteJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ESP (бокс)
local function updateESP()
    for _, obj in pairs(espObjects) do obj:Destroy() end
    espObjects = {}
    if not states.BoxESP then return end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local box = Instance.new("BoxHandleAdornment")
                box.Size = Vector3.new(4, 5, 2)
                box.Adornee = hrp
                box.AlwaysOnTop = true
                box.ZIndex = 10
                box.Transparency = 0.5
                box.Color3 = Color3.fromRGB(255, 0, 0)
                box.Parent = CoreGui
                table.insert(espObjects, box)
            end
        end
    end
end
RunService.Heartbeat:Connect(function() if states.BoxESP then updateESP() end end)

-- Aimbot (с выбором части тела)
RunService.RenderStepped:Connect(function()
    if states.Aimbot then
        local target = getTarget()
        if target and target.Character then
            local targetPart = target.Character:FindFirstChild(states.AimPart)
            if not targetPart then
                targetPart = target.Character:FindFirstChild("HumanoidRootPart")
            end
            if targetPart and LocalPlayer.Character then
                local myPos = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if myPos and (targetPart.Position - myPos.Position).Magnitude <= states.AimbotFOV then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
                end
            end
        end
    end
end)

-- Получение цели для аимбота
local function getTarget()
    local closest = nil
    local dist = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hum = player.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp and LocalPlayer.Character then
                    local myPos = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if myPos then
                        local d = (hrp.Position - myPos.Position).Magnitude
                        if d < dist then
                            dist = d
                            closest = player
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- Respawn
LocalPlayer.CharacterAdded:Connect(function(newChar)
    newChar:WaitForChild("HumanoidRootPart")
    task.wait(0.5)
    if states.Fly then setFly(true) end
end)

-- Инициализация
task.spawn(function()
    task.wait(0.1)
    if states.Fly then setFly(true) end
end)

print("🔺 Apex Rivals загружен")
