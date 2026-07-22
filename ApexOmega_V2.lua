-- ==========================================
-- 🔺 ApexOmega V2 (ФИНАЛ) — ЧАСТЬ 1/2
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ==========================================
-- 1. ПЕРЕМЕННЫЕ
-- ==========================================

local states = {
    Invisible = false, WalkSpeed = 16, Noclip = false, ESP = false,
    Fly = false, FlySpeed = 50, InfJump = false, SpeedGlitch = false,
    GlitchSpeed = 50, Aimbot = false, AntiAFK = false, GodMode = false,
    AimbotFOV = 50, AutoFarmCoins = false, FarmSpeed = 1.5,
    Language = "RUS", CurrentTheme = "Тёмный"
}
local murdererPlayer = nil
local espObjects = {}
local flyBV, flyBG
local highlight = nil
local uiElements = {btns = {}, themeBtns = {}, labels = {}}

-- ==========================================
-- 2. ТЕМЫ (СТИЛЬНЫЕ И ЯРКИЕ)
-- ==========================================

local themes = {
    -- Стильные
    ["Тёмный"] = {bg = Color3.fromRGB(18,18,26), side = Color3.fromRGB(14,14,22), btn = Color3.fromRGB(45,45,60), text = Color3.fromRGB(255,255,255), accent = Color3.fromRGB(0,150,255)},
    ["Светлый"] = {bg = Color3.fromRGB(238,238,243), side = Color3.fromRGB(218,218,223), btn = Color3.fromRGB(198,198,208), text = Color3.fromRGB(30,30,40), accent = Color3.fromRGB(100,100,120)},
    ["Кибер"] = {bg = Color3.fromRGB(10,10,20), side = Color3.fromRGB(20,10,30), btn = Color3.fromRGB(40,30,60), text = Color3.fromRGB(0,255,200), accent = Color3.fromRGB(255,0,200)},
    -- Яркие
    ["Океан"] = {bg = Color3.fromRGB(8,28,52), side = Color3.fromRGB(4,18,42), btn = Color3.fromRGB(20,70,120), text = Color3.fromRGB(190,230,255), accent = Color3.fromRGB(0,200,255)},
    ["Конфетный"] = {bg = Color3.fromRGB(255,175,195), side = Color3.fromRGB(255,145,175), btn = Color3.fromRGB(215,115,155), text = Color3.fromRGB(255,255,255), accent = Color3.fromRGB(255,80,150)},
}

-- ==========================================
-- 3. ЛОКАЛИЗАЦИЯ
-- ==========================================

local lang = {
    RUS = {
        ["Teleport to Murderer"] = "Телепорт к убийце",
        ["God Mode"] = "Режим Бога",
        ["Anti-AFK"] = "Анти-AFK",
        ["Invisible"] = "Невидимость",
        ["Noclip"] = "Ноклип",
        ["ESP"] = "ESP",
        ["Aimbot"] = "Аимбот",
        ["Fly"] = "Полёт",
        ["Inf Jump"] = "Беск. прыжки",
        ["Speed Glitch"] = "Глитч скорости",
        ["Auto-Farm Coins"] = "Автофарм монет",
        ["Commands"] = "Команды",
        ["Farm"] = "Фарм",
        ["Design"] = "Дизайн",
        ["Settings"] = "Настройки",
        ["ON"] = "ВКЛ",
        ["OFF"] = "ВЫКЛ",
        ["Hide UI"] = "Скрыть UI",
        ["WalkSpeed"] = "Скорость бега",
        ["Fly Speed"] = "Скорость полёта",
        ["Glitch Speed"] = "Скорость глитча",
        ["Farm Speed"] = "Скорость фарма",
        ["Aimbot FOV"] = "Дальность аимбота",
    },
    ENG = {
        ["Teleport to Murderer"] = "Teleport to Murderer",
        ["God Mode"] = "God Mode",
        ["Anti-AFK"] = "Anti-AFK",
        ["Invisible"] = "Invisible",
        ["Noclip"] = "Noclip",
        ["ESP"] = "ESP",
        ["Aimbot"] = "Aimbot",
        ["Fly"] = "Fly",
        ["Inf Jump"] = "Inf Jump",
        ["Speed Glitch"] = "Speed Glitch",
        ["Auto-Farm Coins"] = "Auto-Farm Coins",
        ["Commands"] = "Commands",
        ["Farm"] = "Farm",
        ["Design"] = "Design",
        ["Settings"] = "Settings",
        ["ON"] = "ON",
        ["OFF"] = "OFF",
        ["Hide UI"] = "Hide UI",
        ["WalkSpeed"] = "WalkSpeed",
        ["Fly Speed"] = "Fly Speed",
        ["Glitch Speed"] = "Glitch Speed",
        ["Farm Speed"] = "Farm Speed",
        ["Aimbot FOV"] = "Aimbot FOV",
    }
}

local function getText(key)
    return lang[states.Language][key] or key
end

-- ==========================================
-- 4. GUI (КРАСИВЫЙ И ЛЁГКИЙ)
-- ==========================================

local ApexGui = Instance.new("ScreenGui")
ApexGui.Name = "ApexOmega"
ApexGui.ResetOnSpawn = false
if gethui then
    ApexGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ApexGui)
    ApexGui.Parent = CoreGui
else
    ApexGui.Parent = CoreGui
end

-- Главная кнопка
local OpenBtn = Instance.new("ImageButton", ApexGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0, 100)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
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
shadowBtn.ImageTransparency = 0.5

-- Главное окно
local MainWindow = Instance.new("Frame", ApexGui)
MainWindow.Size = UDim2.new(0, 380, 0, 420)
MainWindow.Position = UDim2.new(0.5, -190, 0.5, -210)
MainWindow.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainWindow.BackgroundTransparency = 0.05
MainWindow.Visible = false
MainWindow.ClipsDescendants = true
Instance.new("UICorner", MainWindow).CornerRadius = UDim.new(0, 12)

-- Тень окна
local windowShadow = Instance.new("ImageLabel", MainWindow)
windowShadow.Size = UDim2.new(1, 20, 1, 20)
windowShadow.Position = UDim2.new(0, -10, 0, -10)
windowShadow.BackgroundTransparency = 1
windowShadow.Image = "rbxassetid://1316048950"
windowShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
windowShadow.ImageTransparency = 0.6
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

-- Боковая панель
local Sidebar = Instance.new("Frame", MainWindow)
Sidebar.Size = UDim2.new(0, 110, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
Sidebar.BackgroundTransparency = 0.2
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 0, 0, 12)

local ContentArea = Instance.new("Frame", MainWindow)
ContentArea.Size = UDim2.new(1, -110, 1, 0)
ContentArea.Position = UDim2.new(0, 110, 0, 0)
ContentArea.BackgroundTransparency = 1

local Tabs = {}
local TabButtons = {}
local function createTab(name, icon, isFirst)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, (#TabButtons * 40) + 12)
    btn.BackgroundTransparency = isFirst and 0.8 or 1
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    btn.Text = icon .. " " .. name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    table.insert(TabButtons, btn)
    
    local scroll = Instance.new("ScrollingFrame", ContentArea)
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.Visible = isFirst
    Tabs[name] = scroll
    Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 8)
    Instance.new("UIPadding", scroll).PaddingTop = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Visible = false end
        for _, b in pairs(TabButtons) do b.BackgroundTransparency = 1 end
        scroll.Visible = true
        btn.BackgroundTransparency = 0.8
    end)
    return scroll
end

local TabCmds = createTab("Команды", "⚡", true)
local TabFarm = createTab("Фарм", "🪙", false)
local TabDesign = createTab("Дизайн", "🎨", false)
local TabSettings = createTab("Настройки", "⚙️", false)

-- Кнопка закрыть (в углу)
local closeBtn = Instance.new("TextButton", MainWindow)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(0.93, 0, 0.02, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.BackgroundTransparency = 0.2
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)

OpenBtn.MouseButton1Click:Connect(function()
    MainWindow.Visible = not MainWindow.Visible
end)
closeBtn.MouseButton1Click:Connect(function()
    MainWindow.Visible = false
end)

-- ==========================================
-- 5. ФУНКЦИИ
-- ==========================================

-- Подсветка контуром (только для тебя)
local function updateHighlight()
    if highlight then highlight:Destroy() end
    if LocalPlayer.Character then
        highlight = Instance.new("Highlight")
        highlight.Adornee = LocalPlayer.Character
        highlight.FillTransparency = 1
        highlight.OutlineTransparency = 0
        highlight.OutlineColor = Color3.fromRGB(0, 200, 255)
        highlight.Parent = CoreGui
    end
end
updateHighlight()
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    updateHighlight()
end)

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    if states.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- God Mode
RunService.Heartbeat:Connect(function()
    if states.GodMode and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum and hum.Health > 0 and hum.Health < hum.MaxHealth then
            hum.Health = hum.MaxHealth
        end
    end
end)

-- Invisible
local function setInvisibility(state)
    states.Invisible = state
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = state and 1 or 0
            elseif part:IsA("Decal") then
                part.Transparency = state and 1 or 0
            end
        end
    end
end

-- WalkSpeed & Speed Glitch
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        if states.SpeedGlitch and hum:GetState() == Enum.HumanoidStateType.Freefall then
            hum.WalkSpeed = states.GlitchSpeed
        else
            hum.WalkSpeed = states.WalkSpeed
        end
    end
end)

-- Noclip
local function toggleNoclip(state)
    states.Noclip = state
    if not state and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end
RunService.Stepped:Connect(function()
    if states.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- ESP (X-Ray)
local function updateESP()
    for _, obj in pairs(espObjects) do obj:Destroy() end
    espObjects = {}
    if not states.ESP then return end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local roleColor = Color3.fromRGB(0, 255, 0)
            local checkList = {player.Character, player:FindFirstChild("Backpack")}
            for _, container in pairs(checkList) do
                if container then
                    for _, item in pairs(container:GetChildren()) do
                        if item.Name == "Knife" or item.Name == "Murderer" then
                            roleColor = Color3.fromRGB(255, 0, 0)
                        elseif item.Name == "Gun" or item.Name == "Sheriff" then
                            roleColor = Color3.fromRGB(0, 0, 255)
                        end
                    end
                end
            end
            local box = Instance.new("BoxHandleAdornment")
            box.Size = Vector3.new(4, 5.5, 2.5)
            box.Adornee = player.Character.HumanoidRootPart
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Transparency = 0.4
            box.Color3 = roleColor
            box.Parent = CoreGui
            table.insert(espObjects, box)
            
            local box2 = Instance.new("BoxHandleAdornment")
            box2.Size = Vector3.new(4.3, 5.8, 2.8)
            box2.Adornee = player.Character.HumanoidRootPart
            box2.AlwaysOnTop = true
            box2.ZIndex = 5
            box2.Transparency = 0.7
            box2.Color3 = Color3.fromRGB(255, 255, 255)
            box2.Parent = CoreGui
            table.insert(espObjects, box2)
        end
    end
end
RunService.Heartbeat:Connect(function() if states.ESP then updateESP() end end)

local function getActiveMurderer()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local checkList = {player.Character, player:FindFirstChild("Backpack")}
            for _, container in pairs(checkList) do
                if container then
                    for _, item in pairs(container:GetChildren()) do
                        if item.Name == "Knife" or item.Name == "Murderer" then
                            local hum = player.Character:FindFirstChild("Humanoid")
                            if hum and hum.Health > 0 then return player end
                        end
                    end
                end
            end
        end
    end
    return nil
end

-- Aimbot (наведение)
RunService.RenderStepped:Connect(function()
    if states.Aimbot and states.ESP then
        local target = getActiveMurderer()
        if target and target.Character then
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp and LocalPlayer.Character then
                local myPos = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if myPos and (hrp.Position - myPos.Position).Magnitude <= states.AimbotFOV then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, hrp.Position)
                end
            end
        end
    end
end)

-- Teleport to Murderer
local function teleportToMurderer(btnInstance)
    local target = getActiveMurderer()
    if target and target.Character then
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        if hrp and LocalPlayer.Character then
            local myHrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myHrp then
                myHrp.CFrame = hrp.CFrame + Vector3.new(math.random(-5,5), 0, math.random(5,8))
                if btnInstance then
                    local old = btnInstance.Text
                    btnInstance.Text = "✅ Teleport!"
                    task.delay(0.5, function() btnInstance.Text = old end)
                end
            end
        end
    end
end

-- Auto Farm Coins
local function collectCoins()
    if not states.AutoFarmCoins or not LocalPlayer.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local speed = states.FarmSpeed or 1.5
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "Coin" or obj.Name == "Coin_Server" or obj.BrickColor == BrickColor.new("Bright orange") or string.lower(obj.Name):find("coin")) then
            if (obj.Position - hrp.Position).Magnitude < 200 then
                hrp.CFrame = CFrame.new(obj.Position + Vector3.new(0, 2, 0))
                task.wait(0.1 / speed)
                break
            end
        end
    end
end
RunService.Heartbeat:Connect(function() if states.AutoFarmCoins then collectCoins() end end)
-- ==========================================
-- 🔺 ApexOmega V2 (ФИНАЛ) — ЧАСТЬ 2/2
-- ==========================================

-- ==========================================
-- 6. FLY (ИСПРАВЛЕННЫЙ)
-- ==========================================

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
    if states.InfJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Respawn
LocalPlayer.CharacterAdded:Connect(function(newChar)
    newChar:WaitForChild("HumanoidRootPart")
    task.wait(0.5)
    updateHighlight()
    if states.Invisible then setInvisibility(true) end
    if states.Fly then setFly(true) end
end)

-- ==========================================
-- 7. СОХРАНЕНИЕ И ТЕМЫ
-- ==========================================

local function saveConfig()
    pcall(function()
        if writefile then
            writefile("ApexOmega_Config.json", HttpService:JSONEncode(states))
        end
    end)
end

local function loadConfig()
    pcall(function()
        if isfile and isfile("ApexOmega_Config.json") and readfile then
            local success, decoded = pcall(function() return HttpService:JSONDecode(readfile("ApexOmega_Config.json")) end)
            if success and type(decoded) == "table" then
                for k, v in pairs(decoded) do
                    if states[k] ~= nil then states[k] = v end
                end
            end
        end
    end)
end
loadConfig()

local function applyTheme(themeName)
    local t = themes[themeName]
    if not t then return end
    states.CurrentTheme = themeName
    saveConfig()
    MainWindow.BackgroundColor3 = t.bg
    Sidebar.BackgroundColor3 = t.side
    OpenBtn.BackgroundColor3 = t.accent
    
    for _, data in pairs(uiElements.btns) do
        if not (data.stateKey and states[data.stateKey]) then
            data.btn.BackgroundColor3 = t.btn
            data.btn.TextColor3 = t.text
        end
    end
    
    for name, btn in pairs(uiElements.themeBtns) do
        if name == themeName then
            btn.Text = "✅ " .. name
            btn.UIStroke.Color = Color3.fromRGB(0, 255, 100)
            btn.UIStroke.Thickness = 2
        else
            btn.Text = name
            btn.UIStroke.Thickness = 0
        end
    end
end

-- ==========================================
-- 8. ГЕНЕРАТОРЫ GUI
-- ==========================================

local function createToggle(parent, name, stateKey, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = getText(name) .. ": " .. (states[stateKey] and getText("ON") or getText("OFF"))
    btn.BackgroundColor3 = states[stateKey] and Color3.fromRGB(40, 160, 60) or Color3.fromRGB(45, 45, 45)
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    table.insert(uiElements.btns, {btn = btn, stateKey = stateKey})
    table.insert(uiElements.labels, {btn = btn, key = name, isToggle = true, stateKey = stateKey})
    btn.MouseButton1Click:Connect(function()
        local newState = not states[stateKey]
        if callback then callback(newState) else states[stateKey] = newState; saveConfig() end
        btn.Text = getText(name) .. ": " .. (states[stateKey] and getText("ON") or getText("OFF"))
        btn.BackgroundColor3 = states[stateKey] and Color3.fromRGB(40, 160, 60) or themes[states.CurrentTheme].btn
        btn.Size = UDim2.new(0.85, 0, 0, 33)
        task.wait(0.08)
        btn.Size = UDim2.new(0.9, 0, 0, 35)
    end)
    return btn
end

local function createButton(parent, name, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = getText(name)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    table.insert(uiElements.btns, {btn = btn})
    table.insert(uiElements.labels, {btn = btn, key = name, isToggle = false})
    btn.MouseButton1Click:Connect(function()
        btn.Size = UDim2.new(0.85, 0, 0, 33)
        task.wait(0.08)
        btn.Size = UDim2.new(0.9, 0, 0, 35)
        if callback then callback(btn) end
    end)
    return btn
end

local function createInputOnly(parent, labelText, stateKey)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(0.9, 0, 0, 35)
    container.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = " " .. getText(labelText)
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BorderSizePixel = 0
    Instance.new("UICorner", label).CornerRadius = UDim.new(0, 8)
    table.insert(uiElements.btns, {btn = label})
    table.insert(uiElements.labels, {btn = label, key = labelText, isToggle = false})
    local input = Instance.new("TextBox", container)
    input.Size = UDim2.new(0.32, 0, 1, 0)
    input.Position = UDim2.new(0.68, 0, 0, 0)
    input.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    input.TextColor3 = Color3.fromRGB(200, 255, 200)
    input.Text = tostring(states[stateKey])
    input.Font = Enum.Font.GothamBold
    input.ClearTextOnFocus = false
    input.BorderSizePixel = 0
    Instance.new("UICorner", input).CornerRadius = UDim.new(0, 8)
    input.FocusLost:Connect(function()
        local val = tonumber(input.Text)
        if val then states[stateKey] = val; saveConfig() else input.Text = tostring(states[stateKey]) end
    end)
end

local function updateLanguage()
    for _, data in pairs(uiElements.labels) do
        if data.isToggle then
            data.btn.Text = getText(data.key) .. ": " .. (states[data.stateKey] and getText("ON") or getText("OFF"))
        else
            data.btn.Text = getText(data.key)
        end
    end
    for name, btn in pairs(uiElements.themeBtns) do
        if states.CurrentTheme == name then btn.Text = "✅ " .. name else btn.Text = name end
    end
end

-- ==========================================
-- 9. НАПОЛНЕНИЕ ВКЛАДОК
-- ==========================================

-- Команды
createButton(TabCmds, "Teleport to Murderer", function(btn) teleportToMurderer(btn) end)
createToggle(TabCmds, "God Mode", "GodMode")
createToggle(TabCmds, "Anti-AFK", "AntiAFK")
createToggle(TabCmds, "Invisible", "Invisible", setInvisibility)
createToggle(TabCmds, "Noclip", "Noclip", toggleNoclip)
createToggle(TabCmds, "ESP", "ESP", function(s) states.ESP = s; saveConfig(); if not s then updateESP() end)
createToggle(TabCmds, "Aimbot", "Aimbot")
createToggle(TabCmds, "Fly", "Fly", setFly)
createToggle(TabCmds, "Inf Jump", "InfJump")
createToggle(TabCmds, "Speed Glitch", "SpeedGlitch")

-- Фарм
createToggle(TabFarm, "Auto-Farm Coins", "AutoFarmCoins")
createInputOnly(TabFarm, "Farm Speed", "FarmSpeed")

-- Дизайн
for themeName, _ in pairs(themes) do
    local btn = Instance.new("TextButton", TabDesign)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = themeName
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", btn)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = 0
    table.insert(uiElements.btns, {btn = btn})
    uiElements.themeBtns[themeName] = btn
    btn.MouseButton1Click:Connect(function() applyTheme(themeName) end)
end

-- Настройки
createButton(TabSettings, "Hide UI", function() ApexGui.Enabled = not ApexGui.Enabled end)
createInputOnly(TabSettings, "WalkSpeed", "WalkSpeed")
createInputOnly(TabSettings, "Fly Speed", "FlySpeed")
createInputOnly(TabSettings, "Glitch Speed", "GlitchSpeed")
createInputOnly(TabSettings, "Aimbot FOV", "AimbotFOV")

-- Язык
local langBtn = Instance.new("TextButton", TabSettings)
langBtn.Size = UDim2.new(0.9, 0, 0, 35)
langBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
langBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
langBtn.Text = (states.Language == "RUS") and "Язык: RUS 🇷🇺" or "Language: ENG 🇬🇧"
langBtn.Font = Enum.Font.GothamSemibold
langBtn.BorderSizePixel = 0
Instance.new("UICorner", langBtn).CornerRadius = UDim.new(0, 8)
table.insert(uiElements.btns, {btn = langBtn})
table.insert(uiElements.labels, {btn = langBtn, key = (states.Language == "RUS") and "Язык: RUS 🇷🇺" or "Language: ENG 🇬🇧", isToggle = false})
langBtn.MouseButton1Click:Connect(function()
    if states.Language == "RUS" then states.Language = "ENG"; langBtn.Text = "Language: ENG 🇬🇧"
    else states.Language = "RUS"; langBtn.Text = "Язык: RUS 🇷🇺" end
    saveConfig()
    updateLanguage()
end)

-- Инициализация
task.spawn(function()
    task.wait(0.1)
    applyTheme(states.CurrentTheme)
    if states.Invisible then setInvisibility(true) end
    if states.Fly then setFly(true) end
    updateLanguage()
end)

print("🔺 ApexOmega V2 загружен")
