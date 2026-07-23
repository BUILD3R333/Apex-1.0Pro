--[[
    MM2 Advanced GUI | Часть 1/4
    Инициализация, настройки, темы, мультиязычность
--]]

-- // Сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- // Предотвращение повторного запуска
if LocalPlayer:FindFirstChild("MM2GUI_Loaded") then return end
local flag = Instance.new("BoolValue")
flag.Name = "MM2GUI_Loaded"
flag.Parent = LocalPlayer

if not game:IsLoaded() then game.Loaded:Wait() end

-- // Глобальные настройки
local Settings = {
    Invisible = false, WalkSpeed = 16, Noclip = false, Fly = false, FlySpeed = 50,
    InfiniteJump = false, SpeedGlitch = false, SpeedGlitchValue = 50,
    Aimbot = false, KillAura = false, KillAuraRadius = 30, KillAuraDelay = 0.3,
    HitboxExpander = 1, GodMode = false, ESP = false, AutoFarm = false,
    AutoFarmSpeed = 1, AntiKick = false, Language = "RUS", Theme = "Чёрный"
}

-- Загрузка/сохранение
local success, result = pcall(function() return readfile("MM2_GUI_Settings.json") end)
if success and result then
    local decoded = game:GetService("HttpService"):JSONDecode(result)
    for k,v in pairs(decoded) do if Settings[k] ~= nil then Settings[k] = v end end
end

function SaveSettings()
    local json = game:GetService("HttpService"):JSONEncode(Settings)
    pcall(function() writefile("MM2_GUI_Settings.json", json) end)
end

-- // Палитра тем
local Themes = {
    ["Чёрный"] = { Background = Color3.fromRGB(25,25,28), Border = Color3.fromRGB(55,55,60), Button = Color3.fromRGB(40,40,44), ButtonHover = Color3.fromRGB(60,60,65), Text = Color3.fromRGB(240,240,240), Accent = Color3.fromRGB(80,130,255) },
    ["Серый"] = { Background = Color3.fromRGB(60,60,65), Border = Color3.fromRGB(90,90,95), Button = Color3.fromRGB(80,80,85), ButtonHover = Color3.fromRGB(100,100,105), Text = Color3.fromRGB(230,230,230), Accent = Color3.fromRGB(140,140,255) },
    ["Синий"] = { Background = Color3.fromRGB(15,25,50), Border = Color3.fromRGB(40,60,100), Button = Color3.fromRGB(25,40,75), ButtonHover = Color3.fromRGB(40,70,120), Text = Color3.fromRGB(200,220,255), Accent = Color3.fromRGB(80,140,255) },
    ["Белый"] = { Background = Color3.fromRGB(245,245,248), Border = Color3.fromRGB(200,200,210), Button = Color3.fromRGB(220,220,230), ButtonHover = Color3.fromRGB(190,190,210), Text = Color3.fromRGB(20,20,30), Accent = Color3.fromRGB(60,100,255) },
    ["Океан"] = { Background = Color3.fromRGB(10,35,55), Border = Color3.fromRGB(30,80,110), Button = Color3.fromRGB(20,55,80), ButtonHover = Color3.fromRGB(40,90,130), Text = Color3.fromRGB(180,230,255), Accent = Color3.fromRGB(0,180,200) },
    ["Летняя"] = { Background = Color3.fromRGB(40,55,30), Border = Color3.fromRGB(90,120,60), Button = Color3.fromRGB(60,80,45), ButtonHover = Color3.fromRGB(100,130,70), Text = Color3.fromRGB(230,250,200), Accent = Color3.fromRGB(255,200,50) },
    ["Новогодняя"] = { Background = Color3.fromRGB(35,15,20), Border = Color3.fromRGB(120,40,50), Button = Color3.fromRGB(70,25,35), ButtonHover = Color3.fromRGB(130,45,55), Text = Color3.fromRGB(255,220,220), Accent = Color3.fromRGB(255,60,60) },
    ["Конфетная"] = { Background = Color3.fromRGB(60,30,55), Border = Color3.fromRGB(150,70,130), Button = Color3.fromRGB(100,45,90), ButtonHover = Color3.fromRGB(170,80,150), Text = Color3.fromRGB(255,200,240), Accent = Color3.fromRGB(255,120,200) },
    ["Шоколадная"] = { Background = Color3.fromRGB(55,40,25), Border = Color3.fromRGB(130,90,45), Button = Color3.fromRGB(85,60,35), ButtonHover = Color3.fromRGB(150,100,55), Text = Color3.fromRGB(240,210,170), Accent = Color3.fromRGB(210,140,70) },
    ["Золотая"] = { Background = Color3.fromRGB(50,40,10), Border = Color3.fromRGB(150,120,20), Button = Color3.fromRGB(90,70,15), ButtonHover = Color3.fromRGB(170,130,30), Text = Color3.fromRGB(255,240,150), Accent = Color3.fromRGB(255,200,0) }
}
local CurrentTheme = Themes[Settings.Theme]

-- // Языки
local Lang = {
    RUS = {
        Commands = "Команды", Visual = "Визуал", Farm = "Фарм", Design = "Дизайн", Settings = "Настройки",
        Invisible = "Невидимость", WalkSpeed = "Скорость", Noclip = "Ноклип", Fly = "Полёт", FlySpeed = "Скорость полёта",
        InfiniteJump = "Беск. прыжок", SpeedGlitch = "Спид глитч", Speed = "Скорость", Aimbot = "Аимбот",
        KillAura = "Килл аура", Radius = "Радиус", Delay = "Задержка", HitboxExpander = "Хитбокс",
        TeleportMurder = "ТП к убийце", GodMode = "Годмод", ESP = "ESP (X-Ray)", AutoFarm = "Автофарм монет",
        FarmSpeed = "Скорость сбора", AntiKick = "Анти-кик", Business = "Деловой", Unique = "Уникальный",
        LangSwitch = "Язык", Save = "Сохр.", On = "Вкл", Off = "Выкл"
    },
    ENG = {
        Commands = "Commands", Visual = "Visual", Farm = "Farm", Design = "Design", Settings = "Settings",
        Invisible = "Invisible", WalkSpeed = "WalkSpeed", Noclip = "Noclip", Fly = "Fly", FlySpeed = "Fly Speed",
        InfiniteJump = "Infinite Jump", SpeedGlitch = "Speed Glitch", Speed = "Speed", Aimbot = "Aimbot",
        KillAura = "Kill Aura", Radius = "Radius", Delay = "Delay", HitboxExpander = "Hitbox",
        TeleportMurder = "TP to Murderer", GodMode = "God Mode", ESP = "ESP (X-Ray)", AutoFarm = "Auto Farm Coins",
        FarmSpeed = "Farm Speed", AntiKick = "Anti Kick", Business = "Business", Unique = "Unique",
        LangSwitch = "Language", Save = "Save", On = "ON", Off = "OFF"
    }
}
local function _(key) local t = Lang[Settings.Language] or Lang.RUS; return t[key] or key end
--[[
    MM2 Advanced GUI | Часть 2/4
    Построение интерфейса: главное окно, кнопка-шестерёнка, вкладки, элементы управления
--]]

local gui = Instance.new("ScreenGui")
gui.Name = "MM2AdvancedGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if CoreGui:FindFirstChild("MM2AdvancedGUI") then CoreGui:FindFirstChild("MM2AdvancedGUI"):Destroy() end
gui.Parent = CoreGui

-- Главная кнопка
local MainButton = Instance.new("TextButton")
MainButton.Size = UDim2.new(0,50,0,50)
MainButton.Position = UDim2.new(0.85,0,0.5,0)
MainButton.BackgroundColor3 = Color3.fromRGB(60,120,255)
MainButton.Text = "⚙️"
MainButton.TextColor3 = Color3.new(1,1,1)
MainButton.TextScaled = true
MainButton.Font = Enum.Font.GothamBold
MainButton.AutoButtonColor = false
Instance.new("UICorner", MainButton).CornerRadius = UDim.new(1,0)
MainButton.Parent = gui
local dragDetector = Instance.new("UIDragDetector")
dragDetector.ActivationMode = Enum.ActivationMode.Automatic
dragDetector.ResponseStyle = Enum.ResponseStyle.Smooth
dragDetector.Parent = MainButton

-- Главное окно
local Window = Instance.new("Frame")
Window.Size = UDim2.new(0,320,0,440)
Window.Position = UDim2.new(0.5,-160,0.5,-220)
Window.BackgroundColor3 = CurrentTheme.Background
Window.BackgroundTransparency = 0.05
Window.Visible = false
Window.Parent = gui
Instance.new("UICorner", Window).CornerRadius = UDim.new(0,16)

-- Тень
local shadow = Instance.new("ImageLabel")
shadow.AnchorPoint = Vector2.new(0.5,0.5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://6014261993"
shadow.ImageTransparency = 0.7
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(49,49,450,450)
shadow.Size = UDim2.new(1,30,1,30)
shadow.Position = UDim2.new(0.5,0,0.5,0)
shadow.Parent = Window

-- Полоса перетаскивания (низ)
local DragBar = Instance.new("TextButton")
DragBar.Size = UDim2.new(1,0,0,30)
DragBar.Position = UDim2.new(0,0,1,-30)
DragBar.BackgroundColor3 = CurrentTheme.Border
DragBar.Text = "≡  Перетащить"
DragBar.Font = Enum.Font.GothamBold
DragBar.TextColor3 = CurrentTheme.Text
DragBar.TextScaled = true
DragBar.AutoButtonColor = false
DragBar.Parent = Window

-- Верхняя панель
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1,0,0,36)
TopBar.BackgroundColor3 = CurrentTheme.Border
TopBar.Parent = Window

local title = Instance.new("TextLabel")
title.Text = "MM2 Advanced GUI"
title.Font = Enum.Font.GothamBold
title.TextColor3 = CurrentTheme.Text
title.Size = UDim2.new(1,-80,1,0)
title.Position = UDim2.new(0,10,0,0)
title.TextScaled = true
title.BackgroundTransparency = 1
title.Parent = TopBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0,3)
closeBtn.BackgroundColor3 = Color3.fromRGB(255,80,80)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.TextScaled = true
local cCorner = Instance.new("UICorner")
cCorner.CornerRadius = UDim.new(0,6)
cCorner.Parent = closeBtn
closeBtn.Parent = TopBar

-- Вкладки
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1,0,0,32)
TabContainer.Position = UDim2.new(0,0,0,36)
TabContainer.BackgroundColor3 = CurrentTheme.Button
TabContainer.Parent = Window

local tabs = {}
local tabNames = {"Commands","Visual","Farm","Design","Settings"}
for i, key in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.2,0,1,0)
    btn.Position = UDim2.new((i-1)*0.2,0,0,0)
    btn.BackgroundColor3 = CurrentTheme.Button
    btn.Text = _(key)
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = CurrentTheme.Text
    btn.TextScaled = true
    btn.AutoButtonColor = false
    btn.Parent = TabContainer
    table.insert(tabs, btn)
end

-- Контейнер страниц
local Pages = {}
local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1,0,1,-68)
PageContainer.Position = UDim2.new(0,0,0,68)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = Window

for i, key in ipairs(tabNames) do
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1,-6,1,0)
    page.Position = UDim2.new(0,3,0,0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = CurrentTheme.Accent
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ClipsDescendants = true
    page.Parent = PageContainer
    page.Visible = (i == 1)
    Pages[key] = page
end

-- Переключение вкладок
local currentTab = "Commands"
function SwitchTab(tab)
    if currentTab == tab then return end
    Pages[currentTab].Visible = false
    Pages[tab].Visible = true
    for i, key in ipairs(tabNames) do
        tabs[i].BackgroundColor3 = (key == tab) and CurrentTheme.Accent or CurrentTheme.Button
    end
    currentTab = tab
end
for i, key in ipairs(tabNames) do
    tabs[i].MouseButton1Click:Connect(function() SwitchTab(key) end)
end

-- Анимация нажатия кнопок
function addButtonAnimation(button)
    local orig = button.Size
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {Size = orig - UDim2.new(0,4,0,4)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {Size = orig}):Play()
    end)
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {Size = orig - UDim2.new(0,6,0,6)}):Play()
    end)
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {Size = orig}):Play()
    end)
end
addButtonAnimation(closeBtn)

-- Утилиты создания элементов
function CreateToggle(parent, text, callback, yOff)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-16,0,38)
    frame.Position = UDim2.new(0,8,0,yOff)
    frame.BackgroundColor3 = CurrentTheme.Button
    frame.BackgroundTransparency = 0.2
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,8)
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextColor3 = CurrentTheme.Text
    label.Size = UDim2.new(0.7,0,1,0)
    label.TextScaled = true
    label.BackgroundTransparency = 1
    label.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0,46,0,26)
    toggle.Position = UDim2.new(1,-54,0,6)
    toggle.BackgroundColor3 = Color3.fromRGB(200,50,50)
    toggle.Text = _("Off")
    toggle.Font = Enum.Font.GothamBold
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.TextScaled = true
    toggle.AutoButtonColor = false
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1,0)
    toggle.Parent = frame

    local isOn = false
    local function update()
        toggle.Text = isOn and _("On") or _("Off")
        toggle.BackgroundColor3 = isOn and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
        callback(isOn)
    end
    toggle.MouseButton1Click:Connect(function() isOn = not isOn; update() end)
    addButtonAnimation(toggle)
    return { SetState = function(on) isOn = on; update() end, GetState = function() return isOn end }
end

function CreateSlider(parent, text, min, max, default, callback, yOff)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-16,0,42)
    frame.Position = UDim2.new(0,8,0,yOff)
    frame.BackgroundColor3 = CurrentTheme.Button
    frame.BackgroundTransparency = 0.2
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,8)
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextColor3 = CurrentTheme.Text
    label.Size = UDim2.new(1,0,0,18)
    label.TextScaled = true
    label.BackgroundTransparency = 1
    label.Parent = frame

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.6,0,0,16)
    sliderFrame.Position = UDim2.new(0,2,0,22)
    sliderFrame.BackgroundColor3 = CurrentTheme.Border
    Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0,8)
    sliderFrame.Parent = frame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = CurrentTheme.Accent
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0,8)
    fill.Parent = sliderFrame

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.35,0,0,18)
    input.Position = UDim2.new(0.62,2,0,22)
    input.BackgroundColor3 = CurrentTheme.Border
    input.Text = tostring(default)
    input.Font = Enum.Font.Gotham
    input.TextColor3 = CurrentTheme.Text
    input.TextScaled = true
    Instance.new("UICorner", input).CornerRadius = UDim.new(0,4)
    input.Parent = frame

    local val = default
    local function setValue(newVal)
        newVal = math.clamp(tonumber(newVal) or default, min, max)
        val = newVal
        fill.Size = UDim2.new((val-min)/(max-min),0,1,0)
        input.Text = tostring(val)
        callback(val)
    end
    input.FocusLost:Connect(function(enter) setValue(tonumber(input.Text)) end)
    local dragging = false
    sliderFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    sliderFrame.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    sliderFrame.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((inp.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
            setValue(min + pos*(max-min))
        end
    end)
    return { SetValue = setValue, GetValue = function() return val end }
end
--[[
    MM2 Advanced GUI | Часть 3/4
    Создание всех элементов интерфейса внутри вкладок
--]]

local cmdPage = Pages["Commands"]
local visPage = Pages["Visual"]
local farmPage = Pages["Farm"]
local designPage = Pages["Design"]
local settPage = Pages["Settings"]

-- // ================= Команды =================
local cmdY = 0
local invisToggle = CreateToggle(cmdPage, _("Invisible"), function(on) Settings.Invisible = on; local c=LocalPlayer.Character; if c then for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.Transparency = on and 1 or 0 end end end end, cmdY)
invisToggle.SetState(Settings.Invisible); cmdY = cmdY+42

local wsSlider = CreateSlider(cmdPage, _("WalkSpeed"),1,100,Settings.WalkSpeed,function(v) Settings.WalkSpeed=v; local c=LocalPlayer.Character; if c and c:FindFirstChild("Humanoid") then c.Humanoid.WalkSpeed=v end end, cmdY)
cmdY = cmdY+46

local noclipToggle = CreateToggle(cmdPage, _("Noclip"), function(on) Settings.Noclip=on end, cmdY)
noclipToggle.SetState(Settings.Noclip); cmdY = cmdY+42

local flyToggle = CreateToggle(cmdPage, _("Fly"), function(on) Settings.Fly=on; if on then StartFly() else StopFly() end end, cmdY)
flyToggle.SetState(Settings.Fly); cmdY = cmdY+42

local flySpeedSlider = CreateSlider(cmdPage, _("FlySpeed"),10,200,Settings.FlySpeed,function(v) Settings.FlySpeed=v end, cmdY)
cmdY = cmdY+46

local infJumpToggle = CreateToggle(cmdPage, _("InfiniteJump"), function(on) Settings.InfiniteJump=on end, cmdY)
infJumpToggle.SetState(Settings.InfiniteJump); cmdY = cmdY+42

local speedGlitchToggle = CreateToggle(cmdPage, _("SpeedGlitch"), function(on) Settings.SpeedGlitch=on end, cmdY)
speedGlitchToggle.SetState(Settings.SpeedGlitch); cmdY = cmdY+42

local speedGlitchSlider = CreateSlider(cmdPage, _("Speed"),20,200,Settings.SpeedGlitchValue,function(v) Settings.SpeedGlitchValue=v end, cmdY)
cmdY = cmdY+46

local aimbotToggle = CreateToggle(cmdPage, _("Aimbot"), function(on) Settings.Aimbot=on end, cmdY)
aimbotToggle.SetState(Settings.Aimbot); cmdY = cmdY+42

local killAuraToggle = CreateToggle(cmdPage, _("KillAura"), function(on) Settings.KillAura=on end, cmdY)
killAuraToggle.SetState(Settings.KillAura); cmdY = cmdY+42

local killAuraRadiusSlider = CreateSlider(cmdPage, _("Radius"),10,50,Settings.KillAuraRadius,function(v) Settings.KillAuraRadius=v end, cmdY)
cmdY = cmdY+46

local killAuraDelaySlider = CreateSlider(cmdPage, _("Delay"),0.1,1,Settings.KillAuraDelay,function(v) Settings.KillAuraDelay=v end, cmdY)
cmdY = cmdY+46

local hitboxSlider = CreateSlider(cmdPage, _("HitboxExpander"),1,10,Settings.HitboxExpander,function(v) Settings.HitboxExpander=v end, cmdY)
cmdY = cmdY+46

local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(1,-16,0,34)
tpBtn.Position = UDim2.new(0,8,0,cmdY)
tpBtn.BackgroundColor3 = CurrentTheme.Button
tpBtn.Text = _("TeleportMurder")
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextColor3 = CurrentTheme.Text
tpBtn.TextScaled = true
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0,8)
tpBtn.Parent = cmdPage
addButtonAnimation(tpBtn)
tpBtn.MouseButton1Click:Connect(function()
    local murd = FindMurderer()
    if murd and murd.Character and murd.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character:MoveTo(murd.Character.HumanoidRootPart.Position)
    end
end)
cmdY = cmdY+38

local godToggle = CreateToggle(cmdPage, _("GodMode"), function(on) Settings.GodMode=on; local c=LocalPlayer.Character; if c and c:FindFirstChild("Humanoid") then c.Humanoid.MaxHealth=on and math.huge or 100; c.Humanoid.Health=on and math.huge or c.Humanoid.Health end end, cmdY)
godToggle.SetState(Settings.GodMode); cmdY = cmdY+42

-- // ================= Визуал =================
local espToggle = CreateToggle(visPage, _("ESP"), function(on) Settings.ESP=on; if not on then ClearESP() else UpdateESP() end end, 0)
espToggle.SetState(Settings.ESP)

-- // ================= Фарм =================
local autoFarmToggle = CreateToggle(farmPage, _("AutoFarm"), function(on) Settings.AutoFarm=on; if on then StartFarm() else StopFarm() end end, 0)
autoFarmToggle.SetState(Settings.AutoFarm)
local farmSpeedSlider = CreateSlider(farmPage, _("FarmSpeed"),0.5,5,Settings.AutoFarmSpeed,function(v) Settings.AutoFarmSpeed=v end, 46)
local antiKickToggle = CreateToggle(farmPage, _("AntiKick"), function(on) Settings.AntiKick=on end, 92)
antiKickToggle.SetState(Settings.AntiKick)

-- // ================= Дизайн =================
local function createAccordion(parent, title, items, y)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-16,0,30)
    frame.Position = UDim2.new(0,8,0,y)
    frame.BackgroundColor3 = CurrentTheme.Button
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,8)
    frame.Parent = parent

    local header = Instance.new("TextButton")
    header.Size = UDim2.new(1,0,0,30)
    header.BackgroundTransparency = 1
    header.Text = "▼ "..title
    header.Font = Enum.Font.GothamBold
    header.TextColor3 = CurrentTheme.Text
    header.TextScaled = true
    header.AutoButtonColor = false
    header.Parent = frame

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1,0,0,0)
    content.Position = UDim2.new(0,0,0,30)
    content.BackgroundTransparency = 1
    content.ClipsDescendants = true
    content.Parent = frame

    local opened = false
    local buttons = {}
    local function layout()
        local btnY = 0
        for _, btn in ipairs(buttons) do
            btn.Position = UDim2.new(0,4,0,btnY)
            btnY = btnY + 26
        end
        content.Size = UDim2.new(1,0,0,btnY)
    end
    for _, item in ipairs(items) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,-8,0,24)
        btn.BackgroundColor3 = CurrentTheme.Button
        btn.BackgroundTransparency = 0.2
        btn.Text = item
        btn.Font = Enum.Font.Gotham
        btn.TextColor3 = CurrentTheme.Text
        btn.TextScaled = true
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
        btn.Parent = content
        addButtonAnimation(btn)
        btn.MouseButton1Click:Connect(function()
            Settings.Theme = item
            ApplyTheme()
            SaveSettings()
        end)
        table.insert(buttons, btn)
    end
    layout()
    header.MouseButton1Click:Connect(function()
        opened = not opened
        header.Text = (opened and "▲ " or "▼ ")..title
        content.Visible = opened
        frame.Size = UDim2.new(1,-16,0, opened and 30+content.Size.Y.Offset or 30)
    end)
    return frame
end
createAccordion(designPage, _("Business"), {"Чёрный","Серый","Синий","Белый"}, 0)
createAccordion(designPage, _("Unique"), {"Океан","Летняя","Новогодняя","Конфетная","Шоколадная","Золотая"}, 36)

-- // ================= Настройки =================
local langToggle = CreateToggle(settPage, _("LangSwitch").." 🇷🇺/🇬🇧", function(on)
    Settings.Language = on and "ENG" or "RUS"
    RefreshLanguage()
    SaveSettings()
end, 0)
langToggle.SetState(Settings.Language == "ENG")

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(1,-16,0,34)
saveBtn.Position = UDim2.new(0,8,0,44)
saveBtn.BackgroundColor3 = CurrentTheme.Button
saveBtn.Text = _("Save")
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextColor3 = CurrentTheme.Text
saveBtn.TextScaled = true
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0,8)
saveBtn.Parent = settPage
addButtonAnimation(saveBtn)
saveBtn.MouseButton1Click:Connect(function()
    SaveSettings()
    TweenService:Create(saveBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50,200,50)}):Play()
    task.wait(0.5)
    TweenService:Create(saveBtn, TweenInfo.new(0.3), {BackgroundColor3 = CurrentTheme.Button}):Play()
end)
--[[
    MM2 Advanced GUI | Часть 4/4
    Игровая логика: Fly, Noclip, ESP, Kill Aura, фарм, сохранение и обновление интерфейса
--]]

-- // Поиск убийцы
function FindMurderer()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local backpack = player:FindFirstChild("Backpack") or player.Character:FindFirstChild("Backpack")
            if backpack then
                for _, item in pairs(backpack:GetChildren()) do
                    if item:IsA("Tool") and (item.Name:lower():find("knife") or item.Name:lower():find("murder")) then
                        return player
                    end
                end
            end
            for _, child in pairs(player.Character:GetChildren()) do
                if child:IsA("Tool") and (child.Name:lower():find("knife") or child.Name:lower():find("murder")) then
                    return player
                end
            end
        end
    end
    return nil
end

-- // Fly
local flyBodyGyro, flyBodyVelocity, flyConnection
function StartFly()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(400000,400000,400000)
    flyBodyGyro.CFrame = root.CFrame
    flyBodyGyro.Parent = root
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(100000,100000,100000)
    flyBodyVelocity.Velocity = Vector3.zero
    flyBodyVelocity.Parent = root
    local function onInput(input, gp)
        if gp then return end
        if not Settings.Fly then return end
        local vel = Vector3.zero
        if input.KeyCode == Enum.KeyCode.W then vel += root.CFrame.LookVector * Settings.FlySpeed end
        if input.KeyCode == Enum.KeyCode.S then vel -= root.CFrame.LookVector * Settings.FlySpeed end
        if input.KeyCode == Enum.KeyCode.A then vel -= root.CFrame.RightVector * Settings.FlySpeed end
        if input.KeyCode == Enum.KeyCode.D then vel += root.CFrame.RightVector * Settings.FlySpeed end
        if input.KeyCode == Enum.KeyCode.Space then vel += Vector3.new(0, Settings.FlySpeed, 0) end
        if input.KeyCode == Enum.KeyCode.LeftShift then vel -= Vector3.new(0, Settings.FlySpeed, 0) end
        if flyBodyVelocity then flyBodyVelocity.Velocity = vel end
    end
    flyConnection = UserInputService.InputChanged:Connect(function(input, gp)
        if input.UserInputType == Enum.UserInputType.Keyboard then onInput(input, gp) end
    end)
    RunService.Heartbeat:Connect(function()
        if flyBodyGyro and flyBodyGyro.Parent then
            flyBodyGyro.CFrame = workspace.CurrentCamera.CFrame
        end
    end)
end
function StopFly()
    if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
    if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
end

-- // Noclip в Heartbeat
RunService.Heartbeat:Connect(function()
    if Settings.Noclip then
        local char = LocalPlayer.Character
        if char then for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
    end
end)

-- // Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum and (hum:GetState() == Enum.HumanoidStateType.Landed or hum:GetState() == Enum.HumanoidStateType.Running) then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- // Speed Glitch
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Space and Settings.SpeedGlitch then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            local hum = char.Humanoid
            local orig = hum.WalkSpeed
            hum.WalkSpeed = Settings.SpeedGlitchValue
            task.delay(0.2, function() hum.WalkSpeed = orig end)
        end
    end
end)

-- // Aimbot
RunService.RenderStepped:Connect(function()
    if Settings.Aimbot then
        local murderer = FindMurderer()
        if murderer and murderer.Character and murderer.Character:FindFirstChild("Head") then
            workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, murderer.Character.Head.Position)
        end
    end
end)

-- // Kill Aura
local lastKillTime = 0
RunService.Heartbeat:Connect(function()
    if not Settings.KillAura then return end
    if time() - lastKillTime < Settings.KillAuraDelay then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local bestTarget, bestDist = nil, Settings.KillAuraRadius
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - root.Position).Magnitude
            if dist <= bestDist then bestDist = dist; bestTarget = player end
        end
    end
    if bestTarget then
        lastKillTime = time()
        root.CFrame = bestTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,2)
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Handle") then
            firetouchinterest(tool.Handle, bestTarget.Character.HumanoidRootPart, 0)
            firetouchinterest(tool.Handle, bestTarget.Character.HumanoidRootPart, 1)
        end
    end
end)

-- // Hitbox Expander
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local scale = Settings.HitboxExpander
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Size = part.Size * scale
        end
    end
end)

-- // God Mode
LocalPlayer.CharacterAdded:Connect(function(char)
    if Settings.GodMode then
        local hum = char:WaitForChild("Humanoid")
        hum.MaxHealth = math.huge
        hum.Health = math.huge
    end
end)

-- // ESP
local espFolder = Instance.new("Folder")
espFolder.Name = "ESP_Folder"
espFolder.Parent = CoreGui

function ClearESP()
    for _, v in pairs(espFolder:GetChildren()) do v:Destroy() end
end

function CreateESP(player)
    if player == LocalPlayer then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = player.Name
    highlight.Adornee = player.Character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = 0.5
    highlight.Parent = espFolder

    local function updateRole()
        local role = "innocent"
        local char = player.Character
        if not char then return end
        local backpack = player:FindFirstChild("Backpack") or char:FindFirstChild("Backpack")
        if backpack then
            for _, item in pairs(backpack:GetChildren()) do
                if item:IsA("Tool") then
                    local name = item.Name:lower()
                    if name:find("knife") or name:find("murder") then role = "murderer"
                    elseif name:find("gun") or name:find("sheriff") then role = "sheriff" end
                end
            end
        end
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                if name:find("knife") then role = "murderer"
                elseif name:find("gun") then role = "sheriff" end
            end
        end
        if role == "murderer" then
            highlight.OutlineColor = Color3.fromRGB(255,0,0)
            highlight.FillColor = Color3.fromRGB(255,0,0)
        elseif role == "sheriff" then
            highlight.OutlineColor = Color3.fromRGB(0,100,255)
            highlight.FillColor = Color3.fromRGB(0,100,255)
        else
            highlight.OutlineColor = Color3.fromRGB(0,255,0)
            highlight.FillColor = Color3.fromRGB(0,255,0)
        end
    end
    updateRole()
    player.CharacterAdded:Connect(function(newChar)
        highlight.Adornee = newChar
        updateRole()
    end)
    player.CharacterRemoving:Connect(function() highlight.Adornee = nil end)
    RunService.Heartbeat:Connect(function()
        if not player.Parent then highlight:Destroy(); return end
        updateRole()
    end)
end

function UpdateESP()
    ClearESP()
    if Settings.ESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then CreateESP(player) end
        end
    end
end
Players.PlayerAdded:Connect(function(player)
    if Settings.ESP then CreateESP(player) end
end)
Players.PlayerRemoving:Connect(function(player)
    local obj = espFolder:FindFirstChild(player.Name)
    if obj then obj:Destroy() end
end)

-- // Auto Farm
local farmConnection
function StartFarm()
    farmConnection = RunService.Heartbeat:Connect(function()
        if not Settings.AutoFarm then return end
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local root = char.HumanoidRootPart
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("coin") then
                if (obj.Position - root.Position).Magnitude <= 20 then
                    root.CFrame = CFrame.new(obj.Position + Vector3.new(0,2,0))
                    task.wait(0.1 / Settings.AutoFarmSpeed)
                end
            end
        end
    end)
end
function StopFarm() if farmConnection then farmConnection:Disconnect(); farmConnection = nil end end

-- // Перетаскивание окна
local dragStart, startPos
DragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragStart = input.Position
        startPos = Window.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragStart = nil end
        end)
    end
end)
DragBar.InputChanged:Connect(function(input)
    if dragStart and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
    end
end)

-- // Смена темы и языка
function ApplyTheme()
    CurrentTheme = Themes[Settings.Theme]
    Window.BackgroundColor3 = CurrentTheme.Background
    DragBar.BackgroundColor3 = CurrentTheme.Border
    TopBar.BackgroundColor3 = CurrentTheme.Border
    TabContainer.BackgroundColor3 = CurrentTheme.Button
    for i, key in ipairs(tabNames) do
        tabs[i].BackgroundColor3 = (key == currentTab) and CurrentTheme.Accent or CurrentTheme.Button
        tabs[i].TextColor3 = CurrentTheme.Text
    end
    title.TextColor3 = CurrentTheme.Text
end

function RefreshLanguage()
    for i, key in ipairs(tabNames) do tabs[i].Text = _(key) end
    title.Text = "MM2 Advanced GUI"
end

-- // Открытие/закрытие
MainButton.MouseButton1Click:Connect(function() Window.Visible = not Window.Visible end)
closeBtn.MouseButton1Click:Connect(function() Window.Visible = false end)

-- // Возрождение персонажа
LocalPlayer.CharacterAdded:Connect(function(char)
    if Settings.Invisible then for _,p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.Transparency = 1 end end end
    if Settings.GodMode then
        local hum = char:WaitForChild("Humanoid")
        hum.MaxHealth = math.huge; hum.Health = math.huge
    end
    if Settings.Fly then StopFly(); StartFly() end
    UpdateESP()
end)

-- // Инициализация при запуске
if LocalPlayer.Character then
    if Settings.Invisible then for _,p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.Transparency = 1 end end end
    if Settings.Fly then StartFly() end
    if Settings.GodMode then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.MaxHealth = math.huge; hum.Health = math.huge end
    end
    UpdateESP()
end
if Settings.AutoFarm then StartFarm() end

SwitchTab("Commands")
ApplyTheme()

-- // Автосохранение при выходе
game:BindToClose(function() SaveSettings() end)
print("MM2 Advanced GUI загружен. Автор: [Ваше имя]")
