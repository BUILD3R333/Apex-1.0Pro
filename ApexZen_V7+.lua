-- ==========================================
-- 🚀 ApexZen V7 (ПОЛНАЯ ПЕРЕРАБОТКА)
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 🔹 НАСТРОЙКИ ГРАФИКИ ИНТЕРФЕЙСА
local graphicsLevel = "Ультра" -- "Низкая", "Средняя", "Высокая", "Ультра"

-- 🔹 ПЕРЕМЕННЫЕ СОСТОЯНИЙ
local states = {
    Invisible = false, WalkSpeed = 16, Noclip = false, ESP = false,
    Fly = false, FlySpeed = 50, InfJump = false, SpeedGlitch = false,
    GlitchSpeed = 50, Aimbot = false, AntiAFK = false, GodMode = false,
    AimbotFOV = 50, AutoFarmCoins = false, FarmMode = "Над землёй",
    FarmSpeed = 1.5, Language = "RUS", CurrentTheme = "Деловой: Чёрный",
    Graphics = "Ультра"
}
local murdererPlayer = nil

-- ==========================================
-- 1. БАЗОВЫЙ GUI
-- ==========================================

local ApexGui = Instance.new("ScreenGui")
ApexGui.Name = "ApexZen"
ApexGui.ResetOnSpawn = false
ApexGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Защита GUI
local function protectGui(gui)
    if gethui then
        gui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = CoreGui
    else
        gui.Parent = CoreGui
    end
end
protectGui(ApexGui)

-- ==========================================
-- 2. ГЛАВНАЯ КНОПКА
-- ==========================================

local OpenBtn = Instance.new("ImageButton")
OpenBtn.Size = UDim2.new(0, 55, 0, 55)
OpenBtn.Position = UDim2.new(0, 15, 0, 100)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
OpenBtn.BackgroundTransparency = 0.3
OpenBtn.BorderSizePixel = 0
OpenBtn.Image = "rbxassetid://6031093079"
OpenBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Parent = ApexGui

local shadowBtn = Instance.new("ImageLabel")
shadowBtn.Size = UDim2.new(1, 10, 1, 10)
shadowBtn.Position = UDim2.new(0, -5, 0, -5)
shadowBtn.BackgroundTransparency = 1
shadowBtn.Image = "rbxassetid://1316048950"
shadowBtn.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadowBtn.ImageTransparency = 0.5
shadowBtn.Parent = OpenBtn

local cornerBtn = Instance.new("UICorner")
cornerBtn.CornerRadius = UDim.new(1, 0)
cornerBtn.Parent = OpenBtn

-- ==========================================
-- 3. ГЛАВНОЕ ОКНО (с тенью)
-- ==========================================

local MainShadow = Instance.new("ImageLabel")
MainShadow.Size = UDim2.new(1, 20, 1, 20)
MainShadow.Position = UDim2.new(0, -10, 0, -10)
MainShadow.BackgroundTransparency = 1
MainShadow.Image = "rbxassetid://1316048950"
MainShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
MainShadow.ImageTransparency = 0.6
MainShadow.ZIndex = 0
MainShadow.Parent = ApexGui

local MainWindow = Instance.new("Frame")
MainWindow.Size = UDim2.new(0, 420, 0, 480)
MainWindow.Position = UDim2.new(0.5, -210, 0.5, -240)
MainWindow.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MainWindow.Visible = false
MainWindow.ClipsDescendants = true
MainWindow.ZIndex = 1
MainWindow.Parent = ApexGui

local cornerMain = Instance.new("UICorner")
cornerMain.CornerRadius = UDim.new(0, 16)
cornerMain.Parent = MainWindow

-- Обновление тени при перемещении окна
local function updateShadow()
    MainShadow.Position = UDim2.new(MainWindow.Position.X.Scale, MainWindow.Position.X.Offset - 10, 
                                    MainWindow.Position.Y.Scale, MainWindow.Position.Y.Offset - 10)
end

-- Перетаскивание окна
local function makeWindowDraggable()
    local dragging = false
    local dragStart, startPos
    
    MainWindow.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainWindow.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    updateShadow()
                end
            end)
        end
    end)
    
    MainWindow.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                         input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            updateShadow()
        end
    end)
end
makeWindowDraggable()

-- ==========================================
-- 4. ЗАГОЛОВОК ОКНА (без перетаскивания)
-- ==========================================

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
titleBar.BackgroundTransparency = 0.3
titleBar.BorderSizePixel = 0
titleBar.Parent = MainWindow

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 16, 0, 0)
titleCorner.Parent = titleBar

-- Название
local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0.7, 0, 1, 0)
titleText.Position = UDim2.new(0.04, 0, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🔺 ApexZen V7"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 17
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Кнопка закрыть
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(0.94, 0, 0.05, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.BackgroundTransparency = 0.2
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    MainWindow.Visible = false
end)

-- ==========================================
-- 5. БОКОВАЯ ПАНЕЛЬ (ВКЛАДКИ)
-- ==========================================

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 110, 1, -36)
Sidebar.Position = UDim2.new(0, 0, 0, 36)
Sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
Sidebar.BackgroundTransparency = 0.2
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainWindow

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 0, 0, 16)
sideCorner.Parent = Sidebar

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -110, 1, -36)
ContentArea.Position = UDim2.new(0, 110, 0, 36)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainWindow

local Tabs = {}
local TabButtons = {}
local function createTab(name, icon, isFirst)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, (#TabButtons * 40) + 12)
    btn.BackgroundTransparency = isFirst and 0.8 or 1
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    btn.Text = icon .. " " .. name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Parent = Sidebar
    table.insert(TabButtons, btn)
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
    scroll.Visible = isFirst
    scroll.Parent = ContentArea
    Tabs[name] = scroll
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = scroll
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.Parent = scroll
    
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

-- ==========================================
-- 6. ТЕМЫ И ЛОКАЛИЗАЦИЯ
-- ==========================================

local themes = {
    ["Деловой: Чёрный"] = {bg = Color3.fromRGB(18,18,26), side = Color3.fromRGB(14,14,22), btn = Color3.fromRGB(45,45,60), text = Color3.fromRGB(255,255,255), accent = Color3.fromRGB(0,150,255)},
    ["Деловой: Серый"] = {bg = Color3.fromRGB(48,48,56), side = Color3.fromRGB(38,38,46), btn = Color3.fromRGB(72,72,84), text = Color3.fromRGB(255,255,255), accent = Color3.fromRGB(180,180,200)},
    ["Уникал: Океан"] = {bg = Color3.fromRGB(8,28,52), side = Color3.fromRGB(4,18,42), btn = Color3.fromRGB(20,70,120), text = Color3.fromRGB(190,230,255), accent = Color3.fromRGB(0,200,255)},
    ["Уникал: Конфетная"] = {bg = Color3.fromRGB(255,175,195), side = Color3.fromRGB(255,145,175), btn = Color3.fromRGB(215,115,155), text = Color3.fromRGB(255,255,255), accent = Color3.fromRGB(255,80,150)},
    ["Уникал: Белая"] = {bg = Color3.fromRGB(238,238,243), side = Color3.fromRGB(218,218,223), btn = Color3.fromRGB(198,198,208), text = Color3.fromRGB(30,30,40), accent = Color3.fromRGB(100,100,120)},
    ["Уникал: Летняя"] = {bg = Color3.fromRGB(255,195,75), side = Color3.fromRGB(255,155,35), btn = Color3.fromRGB(255,115,15), text = Color3.fromRGB(255,255,255), accent = Color3.fromRGB(255,215,0)},
    ["Уникал: Новогодняя"] = {bg = Color3.fromRGB(18,98,28), side = Color3.fromRGB(160,28,28), btn = Color3.fromRGB(48,158,48), text = Color3.fromRGB(255,255,210), accent = Color3.fromRGB(255,215,0)},
}

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
        ["Above Ground"] = "Над землёй",
        ["Underground"] = "Под землёй",
        ["Everywhere"] = "Везде",
        ["Collection mode:"] = "Режим сбора:",
        ["Commands"] = "Команды",
        ["Farm"] = "Фарм",
        ["Design"] = "Дизайн",
        ["Settings"] = "Настройки",
        ["Language: RUS 🇷🇺"] = "Язык: RUS 🇷🇺",
        ["Language: ENG 🇬🇧"] = "Язык: ENG 🇬🇧",
        ["Aimbot FOV (Distance)"] = "FOV аимбота (Дистанция)",
        ["WalkSpeed"] = "Скорость бега",
        ["Fly Speed"] = "Скорость полёта",
        ["Glitch Speed"] = "Скорость глитча",
        ["ON"] = "ВКЛ",
        ["OFF"] = "ВЫКЛ",
        ["Hide UI (Press TAB)"] = "Скрыть UI (нажми TAB)",
        ["Graphics"] = "Графика",
        ["Low"] = "Низкая",
        ["Medium"] = "Средняя",
        ["High"] = "Высокая",
        ["Ultra"] = "Ультра",
        ["Farm Speed"] = "Скорость фарма",
        ["✅ Teleport!"] = "✅ Телепорт!",
        ["Business: Black"] = "Деловой: Чёрный",
        ["Business: Gray"] = "Деловой: Серый",
        ["Unique: Ocean"] = "Уникал: Океан",
        ["Unique: Candy"] = "Уникал: Конфетная",
        ["Unique: White"] = "Уникал: Белая",
        ["Unique: Summer"] = "Уникал: Летняя",
        ["Unique: New Year"] = "Уникал: Новогодняя",
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
        ["Above Ground"] = "Above Ground",
        ["Underground"] = "Underground",
        ["Everywhere"] = "Everywhere",
        ["Collection mode:"] = "Collection mode:",
        ["Commands"] = "Commands",
        ["Farm"] = "Farm",
        ["Design"] = "Design",
        ["Settings"] = "Settings",
        ["Language: RUS 🇷🇺"] = "Language: RUS 🇷🇺",
        ["Language: ENG 🇬🇧"] = "Language: ENG 🇬🇧",
        ["Aimbot FOV (Distance)"] = "Aimbot FOV (Distance)",
        ["WalkSpeed"] = "WalkSpeed",
        ["Fly Speed"] = "Fly Speed",
        ["Glitch Speed"] = "Glitch Speed",
        ["ON"] = "ON",
        ["OFF"] = "OFF",
        ["Hide UI (Press TAB)"] = "Hide UI (Press TAB)",
        ["Graphics"] = "Graphics",
        ["Low"] = "Low",
        ["Medium"] = "Medium",
        ["High"] = "High",
        ["Ultra"] = "Ultra",
        ["Farm Speed"] = "Farm Speed",
        ["✅ Teleport!"] = "✅ Teleport!",
        ["Business: Black"] = "Business: Black",
        ["Business: Gray"] = "Business: Gray",
        ["Unique: Ocean"] = "Unique: Ocean",
        ["Unique: Candy"] = "Unique: Candy",
        ["Unique: White"] = "Unique: White",
        ["Unique: Summer"] = "Unique: Summer",
        ["Unique: New Year"] = "Unique: New Year",
    }
}

local uiElements = {btns = {}, themeBtns = {}, labels = {}, inputs = {}}

local function getText(key)
    return lang[states.Language][key] or key
end

-- Функция применения графики
local function applyGraphics(level)
    graphicsLevel = level
    local shadowTransparency = 0.8
    local cornerRadius = 0
    local bgTransparency = 0.05
    local btnTransparency = 0
    
    if level == "Низкая" then
        shadowTransparency = 1
        cornerRadius = 0
        bgTransparency = 0.2
        btnTransparency = 0
    elseif level == "Средняя" then
        shadowTransparency = 0.7
        cornerRadius = 8
        bgTransparency = 0.1
        btnTransparency = 0
    elseif level == "Высокая" then
        shadowTransparency = 0.5
        cornerRadius = 12
        bgTransparency = 0.05
        btnTransparency = 0
    else -- Ультра
        shadowTransparency = 0.4
        cornerRadius = 16
        bgTransparency = 0.03
        btnTransparency = 0
    end
    
    MainShadow.ImageTransparency = shadowTransparency
    cornerMain.CornerRadius = UDim.new(0, cornerRadius)
    MainWindow.BackgroundTransparency = bgTransparency
    Sidebar.BackgroundTransparency = bgTransparency + 0.1
end

applyGraphics(states.Graphics)

-- 🔹 СОХРАНЕНИЕ
local function saveConfig()
    pcall(function()
        if writefile then
            writefile("ApexZen_Config.json", HttpService:JSONEncode(states))
        end
    end)
end

local function loadConfig()
    pcall(function()
        if isfile and isfile("ApexZen_Config.json") and readfile then
            local success, decoded = pcall(function() return HttpService:JSONDecode(readfile("ApexZen_Config.json")) end)
            if success and type(decoded) == "table" then
                for k, v in pairs(decoded) do
                    if states[k] ~= nil then states[k] = v
                end
            end
        end
    end)
end
loadConfig()

local function applyTheme(themeName)
    local t = themes[themeName]; if not t then return end
    states.CurrentTheme = themeName; saveConfig()
    MainWindow.BackgroundColor3 = t.bg
    Sidebar.BackgroundColor3 = t.side
    titleBar.BackgroundColor3 = t.side
    OpenBtn.BackgroundColor3 = t.accent or Color3.fromRGB(0,120,255)
    
    for _, data in pairs(uiElements.btns) do
        if not (data.stateKey and states[data.stateKey]) then
            data.btn.BackgroundColor3 = t.btn
            data.btn.TextColor3 = t.text
        end
    end
    
    for name, btn in pairs(uiElements.themeBtns) do
        if name == themeName then
            btn.Text = "✅ " .. getText(name)
            btn.UIStroke.Color = Color3.fromRGB(0, 255, 100)
            btn.UIStroke.Thickness = 2
        else
            btn.Text = getText(name)
            btn.UIStroke.Thickness = 0
        end
    end
end
-- ==========================================
-- 🚀 ApexZen V7 — ЧАСТЬ 2/3 (ЛОГИКА)
-- ==========================================

-- 🔹 ФУНКЦИОНАЛ

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
    states.Invisible = state; saveConfig()
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

-- WalkSpeed
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
    states.Noclip = state; saveConfig()
    if not state and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end
RunService.Stepped:Connect(function()
    if states.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ==========================================
-- ESP (X-Ray) с обводкой по контуру
-- ==========================================

local espObjects = {}
local function updateESP()
    for _, obj in pairs(espObjects) do
        obj:Destroy()
    end
    espObjects = {}
    if not states.ESP then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local plrChar = player.Character
            if plrChar:FindFirstChild("HumanoidRootPart") and plrChar:FindFirstChild("Humanoid") then
                local roleColor = Color3.fromRGB(0, 255, 0)
                local checkList = {plrChar, player:FindFirstChild("Backpack")}
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
                
                -- Обводка по контуру (BoxHandleAdornment)
                local box = Instance.new("BoxHandleAdornment")
                box.Size = Vector3.new(4, 5.5, 2.5)
                box.Adornee = plrChar.HumanoidRootPart
                box.AlwaysOnTop = true
                box.ZIndex = 10
                box.Transparency = 0.4
                box.Color3 = roleColor
                box.Parent = CoreGui
                table.insert(espObjects, box)
                
                -- Дополнительная обводка (красивая)
                local box2 = Instance.new("BoxHandleAdornment")
                box2.Size = Vector3.new(4.3, 5.8, 2.8)
                box2.Adornee = plrChar.HumanoidRootPart
                box2.AlwaysOnTop = true
                box2.ZIndex = 5
                box2.Transparency = 0.7
                box2.Color3 = Color3.fromRGB(255, 255, 255)
                box2.Parent = CoreGui
                table.insert(espObjects, box2)
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if states.ESP then
        updateESP()
    end
end)

-- ==========================================
-- MURDERER DETECTION
-- ==========================================

local function getActiveMurderer()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local checkList = {player.Character, player:FindFirstChild("Backpack")}
            for _, container in pairs(checkList) do
                if container then
                    for _, item in pairs(container:GetChildren()) do
                        if item.Name == "Knife" or item.Name == "Murderer" then
                            local hum = player.Character:FindFirstChild("Humanoid")
                            if hum and hum.Health > 0 then
                                return player
                            end
                        end
                    end
                end
            end
        end
    end
    return nil
end

-- ==========================================
-- AIMBOT (точный)
-- ==========================================

RunService.RenderStepped:Connect(function()
    if states.Aimbot and states.ESP then
        local target = getActiveMurderer()
        if target and target.Character then
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp and LocalPlayer.Character then
                local myPos = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if myPos then
                    local targetPos = hrp.Position
                    local myPos = myPos.Position
                    if (targetPos - myPos).Magnitude <= states.AimbotFOV then
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
                    end
                end
            end
        end
    end
end)

-- ==========================================
-- TELEPORT TO MURDERER
-- ==========================================

local function teleportToMurderer(btnInstance)
    local target = getActiveMurderer()
    if target and target.Character then
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        if hrp and LocalPlayer.Character then
            local myHrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myHrp then
                local safeOffset = Vector3.new(math.random(-5, 5), 0, math.random(5, 8))
                myHrp.CFrame = hrp.CFrame + safeOffset
                if btnInstance then
                    local oldText = btnInstance.Text
                    btnInstance.Text = getText("✅ Teleport!")
                    task.delay(0.5, function()
                        if btnInstance then
                            btnInstance.Text = oldText
                        end
                    end)
                end
            end
        end
    end
end

-- ==========================================
-- AUTO TELEPORT TO GUN
-- ==========================================

local lastGunObj = nil
RunService.Heartbeat:Connect(function()
    for _, obj in pairs(workspace:GetChildren()) do
        if (obj.Name == "Gun" or obj.Name == "DroppedGun") and obj ~= lastGunObj then
            local part = obj:IsA("Tool") and obj.Handle or obj:FindFirstChild("Handle") or (obj:IsA("BasePart") and obj)
            if part and LocalPlayer.Character then
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    lastGunObj = obj
                    local origCF = hrp.CFrame
                    hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.15)
                    hrp.CFrame = origCF
                    task.delay(5, function()
                        if lastGunObj == obj then
                            lastGunObj = nil
                        end
                    end)
                end
            end
        end
    end
end)

-- ==========================================
-- AUTO FARM COINS (с регулировкой скорости)
-- ==========================================

local function collectCoins()
    if not states.AutoFarmCoins then return end
    if not LocalPlayer.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local myPos = hrp.Position
    local farmMode = states.FarmMode
    local farmSpeed = states.FarmSpeed or 1.5
    
    for _, obj in pairs(workspace:GetDescendants()) do
        local isCoin = false
        if obj:IsA("BasePart") then
            if obj.Name == "Coin" or obj.Name == "Coin_Server" then
                isCoin = true
            elseif obj.BrickColor == BrickColor.new("Bright orange") then
                isCoin = true
            elseif string.lower(obj.Name):find("coin") then
                isCoin = true
            end
        end
        
        if isCoin then
            local coinPos = obj.Position
            local distance = (coinPos - myPos).Magnitude
            
            if farmMode == "Над землёй" and coinPos.Y < 0 then
                -- пропускаем
            elseif farmMode == "Под землёй" and coinPos.Y >= 0 then
                -- пропускаем
            elseif distance < 200 then
                hrp.CFrame = CFrame.new(coinPos + Vector3.new(0, 2, 0))
                task.wait(0.1 / farmSpeed)
                break
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if states.AutoFarmCoins then
        collectCoins()
    end
end)

-- ==========================================
-- FLY (ИСПРАВЛЕН)
-- ==========================================

local flyBV, flyBG
local function setFly(state)
    states.Fly = state
    saveConfig()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
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
            local camCF = Camera.CFrame
            local moveDir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + camCF.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - camCF.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - camCF.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + camCF.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end
            if moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit
            end
            flyBV.Velocity = moveDir * states.FlySpeed
            flyBG.CFrame = camCF
        end
    end
end)

-- ==========================================
-- INFINITE JUMP
-- ==========================================

UserInputService.JumpRequest:Connect(function()
    if states.InfJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ==========================================
-- CHARACTER RESPAWN
-- ==========================================

LocalPlayer.CharacterAdded:Connect(function(newChar)
    newChar:WaitForChild("HumanoidRootPart")
    task.wait(0.5)
    if states.Invisible then
        setInvisibility(true)
    end
    if states.Fly then
        setFly(true)
    end
end)
-- ==========================================
-- 🚀 ApexZen V7 — ЧАСТЬ 3/3 (ИНТЕРФЕЙС)
-- ==========================================

local function getText(key)
    return lang[states.Language][key] or key
end

-- ГЕНЕРАТОРЫ ЭЛЕМЕНТОВ GUI

local function createToggle(parent, name, stateKey, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = getText(name) .. ": " .. (states[stateKey] and getText("ON") or getText("OFF"))
    btn.BackgroundColor3 = states[stateKey] and Color3.fromRGB(40, 160, 60) or Color3.fromRGB(45, 45, 45)
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    table.insert(uiElements.btns, {btn = btn, stateKey = stateKey})
    table.insert(uiElements.labels, {btn = btn, key = name, isToggle = true, stateKey = stateKey})

    btn.MouseButton1Click:Connect(function()
        local newState = not states[stateKey]
        if callback then
            callback(newState)
        else
            states[stateKey] = newState
            saveConfig()
        end
        btn.Text = getText(name) .. ": " .. (states[stateKey] and getText("ON") or getText("OFF"))
        btn.BackgroundColor3 = states[stateKey] and Color3.fromRGB(40, 160, 60) or themes[states.CurrentTheme].btn
        btn.Size = UDim2.new(0.85, 0, 0, 33)
        task.wait(0.08)
        btn.Size = UDim2.new(0.9, 0, 0, 35)
    end)
    return btn
end

local function createButton(parent, name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = getText(name)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    table.insert(uiElements.btns, {btn = btn})
    table.insert(uiElements.labels, {btn = btn, key = name, isToggle = false})

    btn.MouseButton1Click:Connect(function()
        btn.Size = UDim2.new(0.85, 0, 0, 33)
        task.wait(0.08)
        btn.Size = UDim2.new(0.9, 0, 0, 35)
        if callback then
            callback(btn)
        end
    end)
    return btn
end

local function createInputOnly(parent, labelText, stateKey)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.9, 0, 0, 35)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = " " .. getText(labelText)
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BorderSizePixel = 0
    label.Parent = container
    
    local labelCorner = Instance.new("UICorner")
    labelCorner.CornerRadius = UDim.new(0, 8)
    labelCorner.Parent = label
    
    table.insert(uiElements.btns, {btn = label})
    table.insert(uiElements.labels, {btn = label, key = labelText, isToggle = false})
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.32, 0, 1, 0)
    input.Position = UDim2.new(0.68, 0, 0, 0)
    input.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    input.TextColor3 = Color3.fromRGB(200, 255, 200)
    input.Text = tostring(states[stateKey])
    input.Font = Enum.Font.GothamBold
    input.ClearTextOnFocus = false
    input.BorderSizePixel = 0
    input.Parent = container
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = input
    
    input.FocusLost:Connect(function()
        local val = tonumber(input.Text)
        if val then
            states[stateKey] = val
            saveConfig()
        else
            input.Text = tostring(states[stateKey])
        end
    end)
end

local function createFarmModeButton(parent, modeName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = (states.FarmMode == modeName) and Color3.fromRGB(40, 160, 60) or Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = getText(modeName)
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    table.insert(uiElements.btns, {btn = btn})
    table.insert(uiElements.labels, {btn = btn, key = modeName, isToggle = false})

    btn.MouseButton1Click:Connect(function()
        states.FarmMode = modeName
        saveConfig()
        for _, child in pairs(parent:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = (child.Text == getText(modeName)) and Color3.fromRGB(40, 160, 60) or Color3.fromRGB(45, 45, 45)
            end
        end
        btn.Size = UDim2.new(0.85, 0, 0, 33)
        task.wait(0.08)
        btn.Size = UDim2.new(0.9, 0, 0, 35)
    end)
    return btn
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
        if states.CurrentTheme == name then
            btn.Text = "✅ " .. getText(name)
        else
            btn.Text = getText(name)
        end
    end
end

-- ==========================================
-- НАПОЛНЕНИЕ ВКЛАДОК
-- ==========================================

-- Команды
createButton(TabCmds, "Teleport to Murderer", function(btn) teleportToMurderer(btn) end)
createToggle(TabCmds, "God Mode", "GodMode")
createToggle(TabCmds, "Anti-AFK", "AntiAFK")
createToggle(TabCmds, "Invisible", "Invisible", setInvisibility)
createToggle(TabCmds, "Noclip", "Noclip", toggleNoclip)
createToggle(TabCmds, "ESP", "ESP", function(s)
    states.ESP = s
    saveConfig()
    if not s then
        updateESP()
    end
end)
createToggle(TabCmds, "Aimbot", "Aimbot")
createToggle(TabCmds, "Fly", "Fly", setFly)
createToggle(TabCmds, "Inf Jump", "InfJump")
createToggle(TabCmds, "Speed Glitch", "SpeedGlitch")

-- Фарм
createToggle(TabFarm, "Auto-Farm Coins", "AutoFarmCoins")

local farmLabel = Instance.new("TextLabel")
farmLabel.Size = UDim2.new(0.9, 0, 0, 25)
farmLabel.BackgroundTransparency = 1
farmLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
farmLabel.Text = getText("Collection mode:")
farmLabel.Font = Enum.Font.GothamBold
farmLabel.TextSize = 14
farmLabel.Parent = TabFarm
table.insert(uiElements.labels, {btn = farmLabel, key = "Collection mode:", isToggle = false})

createFarmModeButton(TabFarm, "Above Ground")
createFarmModeButton(TabFarm, "Underground")
createFarmModeButton(TabFarm, "Everywhere")

-- Скорость фарма
local farmSpeedContainer = Instance.new("Frame")
farmSpeedContainer.Size = UDim2.new(0.9, 0, 0, 35)
farmSpeedContainer.BackgroundTransparency = 1
farmSpeedContainer.Parent = TabFarm

local farmSpeedLabel = Instance.new("TextLabel")
farmSpeedLabel.Size = UDim2.new(0.65, 0, 1, 0)
farmSpeedLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
farmSpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
farmSpeedLabel.Text = " " .. getText("Farm Speed")
farmSpeedLabel.Font = Enum.Font.GothamSemibold
farmSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
farmSpeedLabel.BorderSizePixel = 0
farmSpeedLabel.Parent = farmSpeedContainer
table.insert(uiElements.labels, {btn = farmSpeedLabel, key = "Farm Speed", isToggle = false})

local farmSpeedInput = Instance.new("TextBox")
farmSpeedInput.Size = UDim2.new(0.32, 0, 1, 0)
farmSpeedInput.Position = UDim2.new(0.68, 0, 0, 0)
farmSpeedInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
farmSpeedInput.TextColor3 = Color3.fromRGB(200, 255, 200)
farmSpeedInput.Text = tostring(states.FarmSpeed or 1.5)
farmSpeedInput.Font = Enum.Font.GothamBold
farmSpeedInput.ClearTextOnFocus = false
farmSpeedInput.BorderSizePixel = 0
farmSpeedInput.Parent = farmSpeedContainer

local farmSpeedCorner = Instance.new("UICorner")
farmSpeedCorner.CornerRadius = UDim.new(0, 8)
farmSpeedCorner.Parent = farmSpeedInput

farmSpeedInput.FocusLost:Connect(function()
    local val = tonumber(farmSpeedInput.Text)
    if val and val > 0 then
        states.FarmSpeed = val
        saveConfig()
    else
        farmSpeedInput.Text = tostring(states.FarmSpeed or 1.5)
    end
end)

-- ==========================================
-- ДИЗАЙН
-- ==========================================

for themeName, _ in pairs(themes) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = getText(themeName)
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    btn.Parent = TabDesign
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = 0
    stroke.Parent = btn
    
    table.insert(uiElements.btns, {btn = btn})
    uiElements.themeBtns[themeName] = btn
    btn.MouseButton1Click:Connect(function()
        applyTheme(themeName)
    end)
end

-- ==========================================
-- НАСТРОЙКИ
-- ==========================================

createButton(TabSettings, "Hide UI (Press TAB)", function()
    ApexGui.Enabled = not ApexGui.Enabled
end)

createInputOnly(TabSettings, "Aimbot FOV (Distance)", "AimbotFOV")
createInputOnly(TabSettings, "WalkSpeed", "WalkSpeed")
createInputOnly(TabSettings, "Fly Speed", "FlySpeed")
createInputOnly(TabSettings, "Glitch Speed", "GlitchSpeed")

-- Графика
local graphicsContainer = Instance.new("Frame")
graphicsContainer.Size = UDim2.new(0.9, 0, 0, 35)
graphicsContainer.BackgroundTransparency = 1
graphicsContainer.Parent = TabSettings

local graphicsLabel = Instance.new("TextLabel")
graphicsLabel.Size = UDim2.new(0.65, 0, 1, 0)
graphicsLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
graphicsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
graphicsLabel.Text = " " .. getText("Graphics")
graphicsLabel.Font = Enum.Font.GothamSemibold
graphicsLabel.TextXAlignment = Enum.TextXAlignment.Left
graphicsLabel.BorderSizePixel = 0
graphicsLabel.Parent = graphicsContainer
table.insert(uiElements.labels, {btn = graphicsLabel, key = "Graphics", isToggle = false})

local graphicsInput = Instance.new("TextBox")
graphicsInput.Size = UDim2.new(0.32, 0, 1, 0)
graphicsInput.Position = UDim2.new(0.68, 0, 0, 0)
graphicsInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
graphicsInput.TextColor3 = Color3.fromRGB(200, 255, 200)
graphicsInput.Text = states.Graphics or "Ультра"
graphicsInput.Font = Enum.Font.GothamBold
graphicsInput.ClearTextOnFocus = false
graphicsInput.BorderSizePixel = 0
graphicsInput.Parent = graphicsContainer

local graphicsCorner = Instance.new("UICorner")
graphicsCorner.CornerRadius = UDim.new(0, 8)
graphicsCorner.Parent = graphicsInput

graphicsInput.FocusLost:Connect(function()
    local val = graphicsInput.Text
    if val == "Низкая" or val == "Low" then
        states.Graphics = "Низкая"
        applyGraphics("Низкая")
    elseif val == "Средняя" or val == "Medium" then
        states.Graphics = "Средняя"
        applyGraphics("Средняя")
    elseif val == "Высокая" or val == "High" then
        states.Graphics = "Высокая"
        applyGraphics("Высокая")
    elseif val == "Ультра" or val == "Ultra" then
        states.Graphics = "Ультра"
        applyGraphics("Ультра")
    else
        graphicsInput.Text = states.Graphics
    end
    saveConfig()
end)

-- Язык
local langBtn = Instance.new("TextButton")
langBtn.Size = UDim2.new(0.9, 0, 0, 35)
langBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
langBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
langBtn.Text = (states.Language == "RUS") and "Язык: RUS 🇷🇺" or "Language: ENG 🇬🇧"
langBtn.Font = Enum.Font.GothamSemibold
langBtn.BorderSizePixel = 0
langBtn.Parent = TabSettings

local langCorner = Instance.new("UICorner")
langCorner.CornerRadius = UDim.new(0, 8)
langCorner.Parent = langBtn

table.insert(uiElements.btns, {btn = langBtn})
table.insert(uiElements.labels, {btn = langBtn, key = (states.Language == "RUS") and "Язык: RUS 🇷🇺" or "Language: ENG 🇬🇧", isToggle = false})

langBtn.MouseButton1Click:Connect(function()
    if states.Language == "RUS" then
        states.Language = "ENG"
        langBtn.Text = "Language: ENG 🇬🇧"
    else
        states.Language = "RUS"
        langBtn.Text = "Язык: RUS 🇷🇺"
    end
    saveConfig()
    updateLanguage()
end)

-- ==========================================
-- ИНИЦИАЛИЗАЦИЯ
-- ==========================================

task.spawn(function()
    task.wait(0.1)
    applyTheme(states.CurrentTheme)
    if states.Invisible then setInvisibility(true) end
    if states.Fly then setFly(true) end
    updateLanguage()
    applyGraphics(states.Graphics or "Ультра")
end)

print("🔺 ApexZen V7 загружен")
