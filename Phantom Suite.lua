-- Часть 1: Инициализация, настройки, темы, языки, построение GUI
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
if LocalPlayer:FindFirstChild("MM2GUI_Loaded") then return end
Instance.new("BoolValue", LocalPlayer).Name = "MM2GUI_Loaded"
if not game:IsLoaded() then game.Loaded:Wait() end

-- Настройки по умолчанию
local Settings = {
    Invisible = false, WalkSpeed = 16, Noclip = false, Fly = false, FlySpeed = 50,
    InfiniteJump = false, SpeedGlitch = false, SpeedGlitchValue = 50,
    Aimbot = false, KillAura = false, KillAuraRadius = 30, KillAuraDelay = 0.3,
    HitboxExpander = 1, GodMode = false, ESP = false, AutoFarm = false,
    AutoFarmSpeed = 1, AntiKick = false, Language = "RUS", Theme = "Чёрный"
}

-- Загрузка сохранённых настроек
local success, result = pcall(readfile, "MM2_GUI_Settings.json")
if success and result then
    local decoded = game:GetService("HttpService"):JSONDecode(result)
    for k,v in pairs(decoded) do if Settings[k] ~= nil then Settings[k] = v end end
end

function SaveSettings()
    pcall(function() writefile("MM2_GUI_Settings.json", game:GetService("HttpService"):JSONEncode(Settings)) end)
end

-- Темы (Bg-фон, Border-рамка, Btn-кнопка, BtnH-кнопка при наведении, Txt-текст, Acc-акцент)
local Themes = {
    ["Чёрный"] =     {Bg=Color3.fromRGB(20,20,24),   Border=Color3.fromRGB(50,50,56),  Btn=Color3.fromRGB(38,38,44),   BtnH=Color3.fromRGB(58,58,65),  Txt=Color3.fromRGB(235,235,240), Acc=Color3.fromRGB(70,120,255)},
    ["Серый"] =      {Bg=Color3.fromRGB(55,55,62),   Border=Color3.fromRGB(85,85,92),  Btn=Color3.fromRGB(75,75,82),   BtnH=Color3.fromRGB(95,95,103), Txt=Color3.fromRGB(225,225,230), Acc=Color3.fromRGB(130,130,255)},
    ["Синий"] =      {Bg=Color3.fromRGB(12,22,48),   Border=Color3.fromRGB(38,58,96),  Btn=Color3.fromRGB(22,38,72),   BtnH=Color3.fromRGB(38,68,118), Txt=Color3.fromRGB(195,215,255), Acc=Color3.fromRGB(75,135,255)},
    ["Белый"] =      {Bg=Color3.fromRGB(240,240,245),Border=Color3.fromRGB(195,195,205),Btn=Color3.fromRGB(215,215,225),BtnH=Color3.fromRGB(185,185,205),Txt=Color3.fromRGB(18,18,28),   Acc=Color3.fromRGB(55,95,255)},
    ["Океан"] =      {Bg=Color3.fromRGB(8,32,52),    Border=Color3.fromRGB(28,76,106), Btn=Color3.fromRGB(18,52,78),   BtnH=Color3.fromRGB(38,86,126), Txt=Color3.fromRGB(175,225,255), Acc=Color3.fromRGB(0,175,195)},
    ["Летняя"] =     {Bg=Color3.fromRGB(38,52,28),   Border=Color3.fromRGB(86,114,58), Btn=Color3.fromRGB(58,78,44),   BtnH=Color3.fromRGB(96,126,68), Txt=Color3.fromRGB(225,245,195), Acc=Color3.fromRGB(250,195,48)},
    ["Новогодняя"] = {Bg=Color3.fromRGB(32,12,18),   Border=Color3.fromRGB(115,38,48), Btn=Color3.fromRGB(66,22,32),   BtnH=Color3.fromRGB(125,42,52), Txt=Color3.fromRGB(250,215,215), Acc=Color3.fromRGB(250,55,55)},
    ["Конфетная"] =  {Bg=Color3.fromRGB(56,28,52),   Border=Color3.fromRGB(145,66,125),Btn=Color3.fromRGB(96,42,86),   BtnH=Color3.fromRGB(165,76,145),Txt=Color3.fromRGB(250,195,235), Acc=Color3.fromRGB(250,115,195)},
    ["Шоколадная"] = {Bg=Color3.fromRGB(52,38,22),   Border=Color3.fromRGB(125,85,42), Btn=Color3.fromRGB(82,58,32),   BtnH=Color3.fromRGB(145,95,52), Txt=Color3.fromRGB(235,205,165), Acc=Color3.fromRGB(205,135,65)},
    ["Золотая"] =    {Bg=Color3.fromRGB(48,38,8),    Border=Color3.fromRGB(145,115,18),Btn=Color3.fromRGB(86,66,14),   BtnH=Color3.fromRGB(165,125,28),Txt=Color3.fromRGB(250,235,145), Acc=Color3.fromRGB(250,195,0)}
}
local T = Themes[Settings.Theme]

-- Мультиязычность
local Lang = {
    RUS = {Commands="Команды",Visual="Визуал",Farm="Фарм",Design="Дизайн",Settings="Настройки",Invisible="Невидимость",WalkSpeed="Скорость",Noclip="Ноклип",Fly="Полёт",FlySpeed="Скорость полёта",InfiniteJump="Беск.прыжок",SpeedGlitch="Спид глитч",Speed="Скорость",Aimbot="Аимбот",KillAura="Килл аура",Radius="Радиус",Delay="Задержка",HitboxExpander="Хитбокс",TeleportMurder="ТП к убийце",GodMode="Годмод",ESP="ESP (X-Ray)",AutoFarm="Автофарм",FarmSpeed="Скорость сбора",AntiKick="Анти-кик",Business="Деловой",Unique="Уникальный",LangSwitch="Язык",Save="Сохранить",Reset="Сброс",On="Вкл",Off="Выкл"},
    ENG = {Commands="Commands",Visual="Visual",Farm="Farm",Design="Design",Settings="Settings",Invisible="Invisible",WalkSpeed="WalkSpeed",Noclip="Noclip",Fly="Fly",FlySpeed="Fly Speed",InfiniteJump="Infinite Jump",SpeedGlitch="Speed Glitch",Speed="Speed",Aimbot="Aimbot",KillAura="Kill Aura",Radius="Radius",Delay="Delay",HitboxExpander="Hitbox",TeleportMurder="TP to Murderer",GodMode="God Mode",ESP="ESP (X-Ray)",AutoFarm="Auto Farm",FarmSpeed="Farm Speed",AntiKick="Anti Kick",Business="Business",Unique="Unique",LangSwitch="Language",Save="Save",Reset="Reset",On="ON",Off="OFF"}
}
function _(key) return (Lang[Settings.Language] or Lang.RUS)[key] or key end

-- Создание GUI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "MM2AdvancedGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if CoreGui:FindFirstChild("MM2AdvancedGUI") then CoreGui.MM2AdvancedGUI:Destroy() end

-- Главная кнопка (увеличена до 60x60)
local MainBtn = Instance.new("TextButton", gui)
MainBtn.Size = UDim2.new(0,60,0,60)
MainBtn.Position = UDim2.new(0.82,0,0.48,0)
MainBtn.BackgroundColor3 = Color3.fromRGB(55,115,255)
MainBtn.Text = "⚙"
MainBtn.TextColor3 = Color3.new(1,1,1)
MainBtn.TextScaled = true
MainBtn.Font = Enum.Font.GothamBold
MainBtn.AutoButtonColor = false
Instance.new("UICorner", MainBtn).CornerRadius = UDim.new(1,0)
Instance.new("UIDragDetector", MainBtn)

-- Главное окно
local Window = Instance.new("Frame", gui)
Window.Size = UDim2.new(0,340,0,480)
Window.Position = UDim2.new(0.5,-170,0.5,-240)
Window.BackgroundColor3 = T.Bg
Window.Visible = false
Instance.new("UICorner", Window).CornerRadius = UDim.new(0,14)

-- Верхняя панель (перетаскивание за неё)
local topBar = Instance.new("Frame", Window)
topBar.Size = UDim2.new(1,0,0,40)
topBar.BackgroundColor3 = T.Border
local title = Instance.new("TextLabel", topBar)
title.Text = "MM2 Advanced"
title.Font = Enum.Font.GothamBold
title.TextColor3 = T.Txt
title.Size = UDim2.new(1,-90,1,0)
title.Position = UDim2.new(0,12,0,0)
title.TextScaled = true
title.BackgroundTransparency = 1
local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0,34,0,34)
closeBtn.Position = UDim2.new(1,-38,0,3)
closeBtn.BackgroundColor3 = Color3.fromRGB(240,70,70)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.TextScaled = true
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,8)
-- Drag за верхнюю панель
local dragUI = Instance.new("UIDragDetector", topBar)

-- Вкладки
local tabBar = Instance.new("Frame", Window)
tabBar.Size = UDim2.new(1,0,0,34)
tabBar.Position = UDim2.new(0,0,0,40)
tabBar.BackgroundColor3 = T.Btn
local tabs = {}
local tabNames = {"Commands","Visual","Farm","Design","Settings"}
for i,k in ipairs(tabNames) do
    local b = Instance.new("TextButton", tabBar)
    b.Size = UDim2.new(0.2,0,1,0)
    b.Position = UDim2.new((i-1)*0.2,0,0,0)
    b.BackgroundColor3 = T.Btn
    b.Text = _(k)
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = T.Txt
    b.TextSize = 13
    b.AutoButtonColor = false
    tabs[i] = b
end

-- Контейнер страниц
local pages = {}
local pageContainer = Instance.new("Frame", Window)
pageContainer.Size = UDim2.new(1,0,1,-74)
pageContainer.Position = UDim2.new(0,0,0,74)
pageContainer.BackgroundTransparency = 1

for i,k in ipairs(tabNames) do
    local page = Instance.new("ScrollingFrame", pageContainer)
    page.Size = UDim2.new(1,-6,1,0)
    page.Position = UDim2.new(0,3,0,0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = T.Acc
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ClipsDescendants = true
    page.Visible = (i == 1)
    pages[k] = page
end

local currentTab = "Commands"
function SwitchTab(tab)
    if currentTab == tab then return end
    pages[currentTab].Visible = false
    pages[tab].Visible = true
    for i,k in ipairs(tabNames) do
        tabs[i].BackgroundColor3 = (k == tab) and T.Acc or T.Btn
        tabs[i].TextColor3 = (k == tab) and Color3.new(1,1,1) or T.Txt
    end
    currentTab = tab
end
for i,k in ipairs(tabNames) do
    tabs[i].MouseButton1Click:Connect(function() SwitchTab(k) end)
end

-- Анимации и стили
function addButtonAnimation(btn)
    local origColor = btn.BackgroundColor3
    local origSize = btn.Size
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = T.BtnH, Size = origSize - UDim2.new(0,4,0,4)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = origColor, Size = origSize}):Play()
    end)
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = origSize - UDim2.new(0,6,0,6)}):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = origSize}):Play()
    end)
end
addButtonAnimation(closeBtn)

-- Утилита создания переключателя (Toggle)
function CreateToggle(parent, text, callback, y)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1,-16,0,42)
    frame.Position = UDim2.new(0,8,0,y)
    frame.BackgroundColor3 = T.Btn
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,8)
    local label = Instance.new("TextLabel", frame)
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextColor3 = T.Txt
    label.Size = UDim2.new(0.7,0,1,0)
    label.TextSize = 13
    label.BackgroundTransparency = 1
    local toggle = Instance.new("TextButton", frame)
    toggle.Size = UDim2.new(0,50,0,28)
    toggle.Position = UDim2.new(1,-58,0,7)
    toggle.BackgroundColor3 = Color3.fromRGB(200,50,50)
    toggle.Text = _("Off")
    toggle.Font = Enum.Font.GothamBold
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.TextSize = 12
    toggle.AutoButtonColor = false
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1,0)
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

-- Утилита создания слайдера с полем ввода
function CreateSlider(parent, text, min, max, default, callback, y)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1,-16,0,46)
    frame.Position = UDim2.new(0,8,0,y)
    frame.BackgroundColor3 = T.Btn
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,8)
    local label = Instance.new("TextLabel", frame)
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextColor3 = T.Txt
    label.Size = UDim2.new(1,0,0,18)
    label.TextSize = 12
    label.BackgroundTransparency = 1
    local sliderFrame = Instance.new("Frame", frame)
    sliderFrame.Size = UDim2.new(0.6,0,0,18)
    sliderFrame.Position = UDim2.new(0,2,0,24)
    sliderFrame.BackgroundColor3 = T.Border
    Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0,9)
    local fill = Instance.new("Frame", sliderFrame)
    fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = T.Acc
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0,9)
    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(0.35,0,0,20)
    input.Position = UDim2.new(0.62,2,0,24)
    input.BackgroundColor3 = T.Border
    input.Text = tostring(default)
    input.Font = Enum.Font.Gotham
    input.TextColor3 = T.Txt
    input.TextSize = 12
    Instance.new("UICorner", input).CornerRadius = UDim.new(0,4)
    local val = default
    local function setValue(newVal)
        newVal = math.clamp(tonumber(newVal) or default, min, max)
        val = newVal
        fill.Size = UDim2.new((val-min)/(max-min),0,1,0)
        input.Text = tostring(val)
        callback(val)
    end
    input.FocusLost:Connect(function() setValue(tonumber(input.Text)) end)
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
-- Часть 2: Элементы интерфейса внутри вкладок
local cmdPage = pages["Commands"]
local visPage = pages["Visual"]
local farmPage = pages["Farm"]
local designPage = pages["Design"]
local settPage = pages["Settings"]
local y = 0

-- === Команды ===
y = 0
local invisToggle = CreateToggle(cmdPage, _("Invisible"), function(on) Settings.Invisible = on; pcall(function() local c=LocalPlayer.Character; if c then for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.Transparency = on and 1 or 0 end end end end) end, y)
invisToggle.SetState(Settings.Invisible); y = y+46

local wsSlider = CreateSlider(cmdPage, _("WalkSpeed"),1,100,Settings.WalkSpeed,function(v) Settings.WalkSpeed=v; pcall(function() local c=LocalPlayer.Character; if c and c:FindFirstChild("Humanoid") then c.Humanoid.WalkSpeed=v end end) end, y)
y = y+50

local noclipToggle = CreateToggle(cmdPage, _("Noclip"), function(on) Settings.Noclip=on end, y)
noclipToggle.SetState(Settings.Noclip); y = y+46

local flyToggle = CreateToggle(cmdPage, _("Fly"), function(on) Settings.Fly=on; if on then StartFly() else StopFly() end end, y)
flyToggle.SetState(Settings.Fly); y = y+46

local flySpeedSlider = CreateSlider(cmdPage, _("FlySpeed"),10,200,Settings.FlySpeed,function(v) Settings.FlySpeed=v end, y)
y = y+50

local infJumpToggle = CreateToggle(cmdPage, _("InfiniteJump"), function(on) Settings.InfiniteJump=on end, y)
infJumpToggle.SetState(Settings.InfiniteJump); y = y+46

local speedGlitchToggle = CreateToggle(cmdPage, _("SpeedGlitch"), function(on) Settings.SpeedGlitch=on end, y)
speedGlitchToggle.SetState(Settings.SpeedGlitch); y = y+46

local speedGlitchSlider = CreateSlider(cmdPage, _("Speed"),20,200,Settings.SpeedGlitchValue,function(v) Settings.SpeedGlitchValue=v end, y)
y = y+50

local aimbotToggle = CreateToggle(cmdPage, _("Aimbot"), function(on) Settings.Aimbot=on end, y)
aimbotToggle.SetState(Settings.Aimbot); y = y+46

local killAuraToggle = CreateToggle(cmdPage, _("KillAura"), function(on) Settings.KillAura=on end, y)
killAuraToggle.SetState(Settings.KillAura); y = y+46

local killAuraRadiusSlider = CreateSlider(cmdPage, _("Radius"),10,50,Settings.KillAuraRadius,function(v) Settings.KillAuraRadius=v end, y)
y = y+50

local killAuraDelaySlider = CreateSlider(cmdPage, _("Delay"),0.1,1,Settings.KillAuraDelay,function(v) Settings.KillAuraDelay=v end, y)
y = y+50

local hitboxSlider = CreateSlider(cmdPage, _("HitboxExpander"),1,10,Settings.HitboxExpander,function(v) Settings.HitboxExpander=v; pcall(function() ApplyHitbox() end) end, y)
y = y+50

-- Телепорт к убийце
local tpBtn = Instance.new("TextButton", cmdPage)
tpBtn.Size = UDim2.new(1,-16,0,36)
tpBtn.Position = UDim2.new(0,8,0,y)
tpBtn.BackgroundColor3 = T.Btn
tpBtn.Text = _("TeleportMurder")
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextColor3 = T.Txt
tpBtn.TextSize = 13
tpBtn.AutoButtonColor = false
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0,8)
addButtonAnimation(tpBtn)
tpBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local murd = FindMurderer()
        if murd and murd.Character and murd.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:MoveTo(murd.Character.HumanoidRootPart.Position)
        end
    end)
end)
y = y+40

local godToggle = CreateToggle(cmdPage, _("GodMode"), function(on) Settings.GodMode=on; pcall(function() local c=LocalPlayer.Character; if c and c:FindFirstChild("Humanoid") then c.Humanoid.MaxHealth=on and math.huge or 100; c.Humanoid.Health=on and math.huge or c.Humanoid.Health end end) end, y)
godToggle.SetState(Settings.GodMode); y = y+46

-- === Визуал ===
local espToggle = CreateToggle(visPage, _("ESP"), function(on) Settings.ESP=on; if not on then ClearESP() else UpdateESP() end end, 0)
espToggle.SetState(Settings.ESP)

-- === Фарм ===
local autoFarmToggle = CreateToggle(farmPage, _("AutoFarm"), function(on) Settings.AutoFarm=on; if on then StartFarm() else StopFarm() end end, 0)
autoFarmToggle.SetState(Settings.AutoFarm)
local farmSpeedSlider = CreateSlider(farmPage, _("FarmSpeed"),0.5,5,Settings.AutoFarmSpeed,function(v) Settings.AutoFarmSpeed=v end, 50)
local antiKickToggle = CreateToggle(farmPage, _("AntiKick"), function(on) Settings.AntiKick=on end, 100)
antiKickToggle.SetState(Settings.AntiKick)

-- === Дизайн ===
local function createAccordion(parent, title, items, yPos)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1,-16,0,32)
    frame.Position = UDim2.new(0,8,0,yPos)
    frame.BackgroundColor3 = T.Btn
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,8)
    local header = Instance.new("TextButton", frame)
    header.Size = UDim2.new(1,0,0,32)
    header.BackgroundTransparency = 1
    header.Text = "▼ "..title
    header.Font = Enum.Font.GothamBold
    header.TextColor3 = T.Txt
    header.TextSize = 13
    header.AutoButtonColor = false
    local content = Instance.new("Frame", frame)
    content.Size = UDim2.new(1,0,0,0)
    content.Position = UDim2.new(0,0,0,32)
    content.BackgroundTransparency = 1
    content.ClipsDescendants = true
    local opened = false
    local buttons = {}
    local function layout()
        local btnY = 0
        for _, btn in ipairs(buttons) do
            btn.Position = UDim2.new(0,4,0,btnY)
            btnY = btnY + 28
        end
        content.Size = UDim2.new(1,0,0,btnY)
    end
    for _, item in ipairs(items) do
        local btn = Instance.new("TextButton", content)
        btn.Size = UDim2.new(1,-8,0,26)
        btn.BackgroundColor3 = T.Btn
        btn.Text = item
        btn.Font = Enum.Font.Gotham
        btn.TextColor3 = T.Txt
        btn.TextSize = 12
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
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
        frame.Size = UDim2.new(1,-16,0, opened and 32+content.Size.Y.Offset or 32)
    end)
    return frame
end
createAccordion(designPage, _("Business"), {"Чёрный","Серый","Синий","Белый"}, 0)
createAccordion(designPage, _("Unique"), {"Океан","Летняя","Новогодняя","Конфетная","Шоколадная","Золотая"}, 38)

-- === Настройки ===
y = 0
local langToggle = CreateToggle(settPage, _("LangSwitch").." 🇷🇺/🇬🇧", function(on)
    Settings.Language = on and "ENG" or "RUS"
    RefreshLanguage()
    SaveSettings()
end, y)
langToggle.SetState(Settings.Language == "ENG"); y = y+46

-- Кнопка сброса настроек
local resetBtn = Instance.new("TextButton", settPage)
resetBtn.Size = UDim2.new(1,-16,0,36)
resetBtn.Position = UDim2.new(0,8,0,y)
resetBtn.BackgroundColor3 = T.Btn
resetBtn.Text = _("Reset")
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextColor3 = T.Txt
resetBtn.TextSize = 13
Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0,8)
addButtonAnimation(resetBtn)
resetBtn.MouseButton1Click:Connect(function()
    -- Простое подтверждение через изменение текста
    resetBtn.Text = "Точно?"
    task.delay(2, function() resetBtn.Text = _("Reset") end)
    local clickCount = 0
    local conn; conn = resetBtn.MouseButton1Click:Connect(function()
        clickCount = clickCount + 1
        if clickCount >= 2 then
            Settings = {
                Invisible = false, WalkSpeed = 16, Noclip = false, Fly = false, FlySpeed = 50,
                InfiniteJump = false, SpeedGlitch = false, SpeedGlitchValue = 50,
                Aimbot = false, KillAura = false, KillAuraRadius = 30, KillAuraDelay = 0.3,
                HitboxExpander = 1, GodMode = false, ESP = false, AutoFarm = false,
                AutoFarmSpeed = 1, AntiKick = false, Language = "RUS", Theme = "Чёрный"
            }
            ApplyTheme()
            RefreshLanguage()
            SaveSettings()
            -- Обновить все элементы интерфейса
            invisToggle.SetState(false); wsSlider.SetValue(16); noclipToggle.SetState(false)
            flyToggle.SetState(false); flySpeedSlider.SetValue(50); infJumpToggle.SetState(false)
            speedGlitchToggle.SetState(false); speedGlitchSlider.SetValue(50); aimbotToggle.SetState(false)
            killAuraToggle.SetState(false); killAuraRadiusSlider.SetValue(30); killAuraDelaySlider.SetValue(0.3)
            hitboxSlider.SetValue(1); godToggle.SetState(false); espToggle.SetState(false)
            autoFarmToggle.SetState(false); farmSpeedSlider.SetValue(1); antiKickToggle.SetState(false)
            langToggle.SetState(false)
            resetBtn.Text = _("Reset")
            conn:Disconnect()
        end
    end)
end)
y = y+40

local saveBtn = Instance.new("TextButton", settPage)
saveBtn.Size = UDim2.new(1,-16,0,36)
saveBtn.Position = UDim2.new(0,8,0,y)
saveBtn.BackgroundColor3 = T.Btn
saveBtn.Text = _("Save")
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextColor3 = T.Txt
saveBtn.TextSize = 13
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0,8)
addButtonAnimation(saveBtn)
saveBtn.MouseButton1Click:Connect(function()
    SaveSettings()
    TweenService:Create(saveBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50,200,50)}):Play()
    task.wait(0.5)
    TweenService:Create(saveBtn, TweenInfo.new(0.3), {BackgroundColor3 = T.Btn}):Play()
end)
-- Часть 3: Игровая логика, Fly, ESP, Kill Aura, фарм и события
-- Поиск убийцы по оружию в рюкзаке
function FindMurderer()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local backpack = plr:FindFirstChild("Backpack") or plr.Character:FindFirstChild("Backpack")
            if backpack then
                for _, item in pairs(backpack:GetChildren()) do
                    if item:IsA("Tool") and (item.Name:lower():find("knife") or item.Name:lower():find("murder")) then
                        return plr
                    end
                end
            end
            for _, tool in pairs(plr.Character:GetChildren()) do
                if tool:IsA("Tool") and (tool.Name:lower():find("knife") or tool.Name:lower():find("murder")) then
                    return plr
                end
            end
        end
    end
    return nil
end

-- Fly (поддержка ПК и мобильных кнопок)
local flyBodyGyro, flyBodyVelocity, flyConnection, flyButtons = nil, nil, nil, {}
local function createMobileFlyButtons()
    if flyButtons.Parent then return end
    local container = Instance.new("Frame", gui)
    container.Size = UDim2.new(0,140,0,100)
    container.Position = UDim2.new(0,10,0.7,0)
    container.BackgroundTransparency = 1
    container.Name = "FlyControls"
    flyButtons = container
    -- WASD
    local function makeBtn(text, pos, code)
        local btn = Instance.new("TextButton", container)
        btn.Size = UDim2.new(0,40,0,40)
        btn.Position = pos
        btn.Text = text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 20
        btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
        btn.BackgroundTransparency = 0.6
        btn.TextColor3 = Color3.new(0,0,0)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
        btn.MouseButton1Click:Connect(function() -- одноразовое нажатие не подходит, используем InputBegan/Ended
        end)
        btn.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                if flyBodyVelocity then
                    local vel = flyBodyVelocity.Velocity
                    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        if code == "W" then vel += root.CFrame.LookVector * Settings.FlySpeed
                        elseif code == "S" then vel -= root.CFrame.LookVector * Settings.FlySpeed
                        elseif code == "A" then vel -= root.CFrame.RightVector * Settings.FlySpeed
                        elseif code == "D" then vel += root.CFrame.RightVector * Settings.FlySpeed
                        elseif code == "Space" then vel += Vector3.new(0,Settings.FlySpeed,0)
                        elseif code == "Shift" then vel -= Vector3.new(0,Settings.FlySpeed,0)
                        end
                    end
                    flyBodyVelocity.Velocity = vel
                end
            end
        end)
        btn.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                if flyBodyVelocity then
                    -- Сброс только соответствующей компоненты
                end
            end
        end)
        return btn
    end
    makeBtn("W", UDim2.new(0.5,-20,0,0), "W")
    makeBtn("A", UDim2.new(0,0,0,40), "A")
    makeBtn("S", UDim2.new(0.5,-20,0,40), "S")
    makeBtn("D", UDim2.new(1,-40,0,40), "D")
    -- Space и Shift отдельно
    local spaceBtn = Instance.new("TextButton", container)
    spaceBtn.Size = UDim2.new(0,120,0,30)
    spaceBtn.Position = UDim2.new(0.5,-60,0,90)
    spaceBtn.Text = "↑ Прыжок"
    spaceBtn.Font = Enum.Font.GothamBold
    spaceBtn.TextSize = 12
    spaceBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    spaceBtn.BackgroundTransparency = 0.6
    Instance.new("UICorner", spaceBtn).CornerRadius = UDim.new(0,8)
    spaceBtn.InputBegan:Connect(function(inp)
        if (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) and flyBodyVelocity then
            flyBodyVelocity.Velocity += Vector3.new(0,Settings.FlySpeed,0)
        end
    end)
    local shiftBtn = spaceBtn:Clone(); shiftBtn.Text = "↓ Спуск"; shiftBtn.Position = UDim2.new(0.5,-60,0,125)
    shiftBtn.Parent = container
    shiftBtn.InputBegan:Connect(function(inp)
        if (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) and flyBodyVelocity then
            flyBodyVelocity.Velocity -= Vector3.new(0,Settings.FlySpeed,0)
        end
    end)
end

function StartFly()
    StopFly()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    flyBodyGyro = Instance.new("BodyGyro", root)
    flyBodyGyro.MaxTorque = Vector3.new(400000,400000,400000)
    flyBodyGyro.CFrame = root.CFrame
    flyBodyVelocity = Instance.new("BodyVelocity", root)
    flyBodyVelocity.MaxForce = Vector3.new(100000,100000,100000)
    flyBodyVelocity.Velocity = Vector3.zero

    -- ПК-управление клавишами
    flyConnection = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if flyBodyVelocity and input.UserInputType == Enum.UserInputType.Keyboard then
            local vel = flyBodyVelocity.Velocity
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                if input.KeyCode == Enum.KeyCode.W then vel += root.CFrame.LookVector * Settings.FlySpeed
                elseif input.KeyCode == Enum.KeyCode.S then vel -= root.CFrame.LookVector * Settings.FlySpeed
                elseif input.KeyCode == Enum.KeyCode.A then vel -= root.CFrame.RightVector * Settings.FlySpeed
                elseif input.KeyCode == Enum.KeyCode.D then vel += root.CFrame.RightVector * Settings.FlySpeed
                elseif input.KeyCode == Enum.KeyCode.Space then vel += Vector3.new(0,Settings.FlySpeed,0)
                elseif input.KeyCode == Enum.KeyCode.LeftShift then vel -= Vector3.new(0,Settings.FlySpeed,0)
                end
            end
            flyBodyVelocity.Velocity = vel
        end
    end)
    local endConn
    endConn = UserInputService.InputEnded:Connect(function(input, gp)
        if gp then return end
        if flyBodyVelocity and input.UserInputType == Enum.UserInputType.Keyboard then
            local vel = flyBodyVelocity.Velocity
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                if input.KeyCode == Enum.KeyCode.W then vel -= root.CFrame.LookVector * Settings.FlySpeed
                elseif input.KeyCode == Enum.KeyCode.S then vel += root.CFrame.LookVector * Settings.FlySpeed
                elseif input.KeyCode == Enum.KeyCode.A then vel += root.CFrame.RightVector * Settings.FlySpeed
                elseif input.KeyCode == Enum.KeyCode.D then vel -= root.CFrame.RightVector * Settings.FlySpeed
                elseif input.KeyCode == Enum.KeyCode.Space then vel -= Vector3.new(0,Settings.FlySpeed,0)
                elseif input.KeyCode == Enum.KeyCode.LeftShift then vel += Vector3.new(0,Settings.FlySpeed,0)
                end
            end
            flyBodyVelocity.Velocity = vel
        end
    end)
    flyConnection = {flyConnection, endConn}
    -- Стабилизация гироскопа
    RunService.Heartbeat:Connect(function()
        if flyBodyGyro and flyBodyGyro.Parent then
            flyBodyGyro.CFrame = workspace.CurrentCamera.CFrame
        end
    end)
    if UserInputService.TouchEnabled then
        createMobileFlyButtons()
    end
end

function StopFly()
    if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
    if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
    if flyConnection then
        for _, conn in ipairs(flyConnection) do conn:Disconnect() end
        flyConnection = nil
    end
    if flyButtons.Parent then flyButtons:Destroy() end
end

-- Hitbox Expander: расширяем только HumanoidRootPart, остальное не трогаем для избежания глюков
function ApplyHitbox()
    pcall(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            root.Size = Vector3.new(2,2,2) * Settings.HitboxExpander
        end
    end)
end

-- Noclip
RunService.Heartbeat:Connect(function()
    if Settings.Noclip then
        pcall(function()
            local char = LocalPlayer.Character
            if char then for _,p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
        end)
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump then
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                local hum = char.Humanoid
                if hum:GetState() == Enum.HumanoidStateType.Landed or hum:GetState() == Enum.HumanoidStateType.Running then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    end
end)

-- Speed Glitch
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Space and Settings.SpeedGlitch then
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                local hum = char.Humanoid
                local orig = hum.WalkSpeed
                hum.WalkSpeed = Settings.SpeedGlitchValue
                task.delay(0.2, function() hum.WalkSpeed = orig end)
            end
        end)
    end
end)

-- Aimbot
RunService.RenderStepped:Connect(function()
    if Settings.Aimbot then
        pcall(function()
            local murderer = FindMurderer()
            if murderer and murderer.Character and murderer.Character:FindFirstChild("Head") then
                workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, murderer.Character.Head.Position)
            end
        end)
    end
end)

-- Kill Aura
local lastKillTime = 0
RunService.Heartbeat:Connect(function()
    if not Settings.KillAura then return end
    if time() - lastKillTime < Settings.KillAuraDelay then return end
    pcall(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local root = char.HumanoidRootPart
        local bestTarget, bestDist = nil, Settings.KillAuraRadius
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (plr.Character.HumanoidRootPart.Position - root.Position).Magnitude
                if dist <= bestDist then bestDist = dist; bestTarget = plr end
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
end)

-- God Mode
LocalPlayer.CharacterAdded:Connect(function(char)
    if Settings.GodMode then
        pcall(function()
            local hum = char:WaitForChild("Humanoid")
            hum.MaxHealth = math.huge
            hum.Health = math.huge
        end)
    end
    if Settings.Invisible then
        pcall(function() for _,p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.Transparency = 1 end end end)
    end
    if Settings.Fly then StopFly(); StartFly() end
    UpdateESP()
    ApplyHitbox()
end)

-- ESP
local espFolder = Instance.new("Folder", CoreGui)
espFolder.Name = "ESP_Folder"

function ClearESP()
    for _,v in pairs(espFolder:GetChildren()) do v:Destroy() end
end

function CreateESP(player)
    if player == LocalPlayer then return end
    local highlight = Instance.new("Highlight", espFolder)
    highlight.Name = player.Name
    highlight.Adornee = player.Character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = 0.4
    highlight.OutlineTransparency = 0.2

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
    -- Обновление роли при изменениях в рюкзаке
    local backpack = player:FindFirstChild("Backpack") or (player.Character and player.Character:FindFirstChild("Backpack"))
    if backpack then
        backpack.ChildAdded:Connect(updateRole)
        backpack.ChildRemoved:Connect(updateRole)
    end
    player.ChildAdded:Connect(function(child)
        if child.Name == "Backpack" then
            child.ChildAdded:Connect(updateRole)
            child.ChildRemoved:Connect(updateRole)
        end
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

-- Auto Farm
local farmConnection
function StartFarm()
    StopFarm()
    farmConnection = RunService.Heartbeat:Connect(function()
        if not Settings.AutoFarm then return end
        pcall(function()
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
    end)
end
function StopFarm() if farmConnection then farmConnection:Disconnect(); farmConnection = nil end end

-- Смена темы
function ApplyTheme()
    T = Themes[Settings.Theme]
    Window.BackgroundColor3 = T.Bg
    topBar.BackgroundColor3 = T.Border
    tabBar.BackgroundColor3 = T.Btn
    for i,k in ipairs(tabNames) do
        tabs[i].BackgroundColor3 = (k == currentTab) and T.Acc or T.Btn
        tabs[i].TextColor3 = (k == currentTab) and Color3.new(1,1,1) or T.Txt
    end
    title.TextColor3 = T.Txt
end

function RefreshLanguage()
    title.Text = "MM2 Advanced"
    for i,k in ipairs(tabNames) do tabs[i].Text = _(k) end
    -- Просто обновим тексты вручную для некоторых элементов (основные переключатели уже созданы, нужно пересоздавать или хранить ссылки)
    -- В данном примере для полной смены языка лучше перезапустить GUI, но оставим как есть.
end

-- Открытие/закрытие
MainBtn.MouseButton1Click:Connect(function() Window.Visible = not Window.Visible end)
closeBtn.MouseButton1Click:Connect(function() Window.Visible = false end)

-- Инициализация при запуске
if LocalPlayer.Character then
    if Settings.Invisible then pcall(function() for _,p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.Transparency = 1 end end end) end
    if Settings.Fly then StartFly() end
    if Settings.GodMode then pcall(function() local hum = LocalPlayer.Character:FindFirstChild("Humanoid"); if hum then hum.MaxHealth = math.huge; hum.Health = math.huge end end) end
    ApplyHitbox()
    UpdateESP()
end
if Settings.AutoFarm then StartFarm() end

SwitchTab("Commands")
ApplyTheme()

-- Автосохранение при закрытии игры
game:BindToClose(function() SaveSettings() end)
print("MM2 Advanced GUI загружен. Автор: [Ваше имя]")
