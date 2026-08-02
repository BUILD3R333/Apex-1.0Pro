--[[
    Project: San Diego Border RP Script (Ultimate v3 - Часть 1)
    Настройки, сохранение, скорость, ESP
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Конфиг
local GlobalEnv = (getgenv and getgenv()) or _G
if not GlobalEnv.BorderRP_Config then
    GlobalEnv.BorderRP_Config = {
        SpeedEnabled = false,
        WalkSpeedValue = 16,
        XRayEnabled = false,
        XRayTarget = "Все",
        AimbotEnabled = false,
        AimbotTarget = "Все",
        AimbotMaxDistance = 500,
        AimbotWallCheck = true,
        SavedWaypoints = {}
    }
end
local Config = GlobalEnv.BorderRP_Config

-- Сохранение в файл
local function saveConfigToFile()
    if writefile and HttpService then
        pcall(function()
            writefile("BorderRP_Config.json", HttpService:JSONEncode(Config.SavedWaypoints))
        end)
    end
end

if readfile and isfile and isfile("BorderRP_Config.json") then
    pcall(function()
        local data = readfile("BorderRP_Config.json")
        local decoded = HttpService:JSONDecode(data)
        if decoded then
            Config.SavedWaypoints = decoded
        end
    end)
end

-- Скорость (не сбрасывается после смерти)
RunService.Stepped:Connect(function()
    if Config.SpeedEnabled then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = Config.WalkSpeedValue
            end
        end
    end
end)

-- Роли для ESP
local function getPlayerRole(player)
    local team = player.Team and player.Team.Name or ""
    if team:match("Police") or team:match("Cop") or team:match("Шериф") or team:match("Полиция") then
        return "Полицейские"
    elseif player:GetAttribute("Wanted") or player:GetAttribute("IsCriminal") or team:match("Criminal") or team:match("Преступник") or team:match("Бандит") then
        return "Преступники"
    else
        return "Граждане"
    end
end

local function matchesFilter(targetPlayer, filterType)
    if filterType == "Все" then return true end
    local role = getPlayerRole(targetPlayer)
    return role == filterType
end

local function getRoleColor(role)
    if role == "Преступники" then
        return Color3.fromRGB(255, 0, 0)
    elseif role == "Полицейские" then
        return Color3.fromRGB(0, 100, 255)
    else
        return Color3.fromRGB(0, 255, 0)
    end
end

-- UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BorderRP_GUI_v3"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 50, 0, 200)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ToggleButton.Text = "RP"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 380)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TopBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -70, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "San Diego RP | Ultimate v3"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 2)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseButton.TextSize = 16
CloseButton.Parent = TopBar
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleButton.Visible = false
end)

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -70, 0, 2)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Text = "─"
MinimizeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeButton.TextSize = 16
MinimizeButton.Parent = TopBar
MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleButton.Visible = true
end)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

LocalPlayer.Chatted:Connect(function(msg)
    if msg:lower() == "/rp" then
        ToggleButton.Visible = true
        MainFrame.Visible = true
    end
end)

-- Перетаскивание
local function makeDraggable(obj)
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

makeDraggable(MainFrame)
makeDraggable(ToggleButton)

-- Вкладки
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.Position = UDim2.new(0, 0, 0, 35)
TabBar.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
TabBar.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -65)
ContentFrame.Position = UDim2.new(0, 0, 0, 65)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local tabs = {"Speed", "X-Ray", "Aimbot", "Teleport"}
local tabFrames = {}

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/#tabs, 0, 1, 0)
    btn.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = TabBar
    
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = (i == 1)
    frame.CanvasSize = UDim2.new(0, 0, 2, 0)
    frame.Parent = ContentFrame
    tabFrames[name] = frame
    
    btn.MouseButton1Click:Connect(function()
        for _, f in pairs(tabFrames) do f.Visible = false end
        frame.Visible = true
    end)
end

-- Speed
local speedFrame = tabFrames["Speed"]
local speedToggle = Instance.new("TextButton")
speedToggle.Size = UDim2.new(0, 200, 0, 35)
speedToggle.Position = UDim2.new(0, 15, 0, 15)
speedToggle.BackgroundColor3 = Config.SpeedEnabled and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
speedToggle.Text = Config.SpeedEnabled and "Speed: ON" or "Speed: OFF"
speedToggle.TextColor3 = Color3.fromRGB(255,255,255)
speedToggle.Font = Enum.Font.GothamBold
speedToggle.Parent = speedFrame

speedToggle.MouseButton1Click:Connect(function()
    Config.SpeedEnabled = not Config.SpeedEnabled
    speedToggle.BackgroundColor3 = Config.SpeedEnabled and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
    speedToggle.Text = Config.SpeedEnabled and "Speed: ON" or "Speed: OFF"
end)

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 200, 0, 35)
speedInput.Position = UDim2.new(0, 15, 0, 60)
speedInput.BackgroundColor3 = Color3.fromRGB(50,50,50)
speedInput.Text = tostring(Config.WalkSpeedValue)
speedInput.TextColor3 = Color3.fromRGB(255,255,255)
speedInput.Font = Enum.Font.Gotham
speedInput.Parent = speedFrame
speedInput.FocusLost:Connect(function()
    local val = tonumber(speedInput.Text)
    if val then Config.WalkSpeedValue = val end
end)

-- X-Ray
local xrayFrame = tabFrames["X-Ray"]
local xrayToggle = Instance.new("TextButton")
xrayToggle.Size = UDim2.new(0, 200, 0, 35)
xrayToggle.Position = UDim2.new(0, 15, 0, 15)
xrayToggle.BackgroundColor3 = Config.XRayEnabled and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
xrayToggle.Text = Config.XRayEnabled and "X-Ray: ON" or "X-Ray: OFF"
xrayToggle.TextColor3 = Color3.fromRGB(255,255,255)
xrayToggle.Font = Enum.Font.GothamBold
xrayToggle.Parent = xrayFrame

xrayToggle.MouseButton1Click:Connect(function()
    Config.XRayEnabled = not Config.XRayEnabled
    xrayToggle.BackgroundColor3 = Config.XRayEnabled and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
    xrayToggle.Text = Config.XRayEnabled and "X-Ray: ON" or "X-Ray: OFF"
end)

local targets = {"Все", "Преступники", "Полицейские", "Граждане"}
for i, name in ipairs(targets) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 30)
    btn.Position = UDim2.new(0, 15 + ((i-1) * 110), 0, 65)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.Gotham
    btn.Parent = xrayFrame
    btn.MouseButton1Click:Connect(function()
        Config.XRayTarget = name
    end)
end

-- ESP цикл
RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hl = char:FindFirstChild("RP_Highlight")
            if Config.XRayEnabled and matchesFilter(player, Config.XRayTarget) then
                local color = getRoleColor(getPlayerRole(player))
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "RP_Highlight"
                    hl.FillColor = color
                    hl.OutlineColor = Color3.fromRGB(255,255,255)
                    hl.Parent = char
                else
                    hl.FillColor = color
                end
            else
                if hl then hl:Destroy() end
            end
        end
    end
end)
--[[
    Project: San Diego Border RP Script (Ultimate v3 - Часть 2)
    Аимбот с удержанием цели
]]

local currentTarget = nil

-- Проверка: есть ли оружие
local function hasWeapon()
    local char = LocalPlayer.Character
    if not char then return false end
    return char:FindFirstChildOfClass("Tool") ~= nil
end

-- Проверка: жива ли цель
local function isValidTarget(part)
    if not part or not part.Parent then return false end
    local char = part.Parent
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    
    local dist = (part.Position - root.Position).Magnitude
    if dist > Config.AimbotMaxDistance then return false end
    return true
end

-- Поиск ближайшей цели
local function getClosestTarget()
    local closest, closestDist = nil, math.huge
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and matchesFilter(player, Config.AimbotTarget) then
            local head = player.Character:FindFirstChild("Head")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if head and hum and hum.Health > 0 then
                local dist = (head.Position - root.Position).Magnitude
                if dist <= Config.AimbotMaxDistance then
                    if Config.AimbotWallCheck then
                        local params = RaycastParams.new()
                        params.FilterDescendantsInstances = {LocalPlayer.Character, player.Character}
                        params.FilterType = Enum.RaycastFilterType.Exclude
                        local result = Workspace:Raycast(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * dist, params)
                        if result then continue end
                    end
                    
                    local screenPoint = Camera:WorldToViewportPoint(head.Position)
                    if screenPoint then
                        local mousePos = UserInputService:GetMouseLocation()
                        local screenDist = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                        if screenDist < closestDist then
                            closestDist = screenDist
                            closest = head
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- Аимбот цикл
RunService.RenderStepped:Connect(function()
    if not Config.AimbotEnabled then
        currentTarget = nil
        return
    end
    
    local active = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or hasWeapon()
    if not active then
        currentTarget = nil
        return
    end
    
    if not isValidTarget(currentTarget) then
        currentTarget = getClosestTarget()
    end
    
    if currentTarget then
        local newCF = CFrame.new(Camera.CFrame.Position, currentTarget.Position)
        Camera.CFrame = Camera.CFrame:Lerp(newCF, 0.25)
    end
end)

-- Кнопка Aimbot в UI
local aimbotFrame = tabFrames["Aimbot"]
local aimToggle = Instance.new("TextButton")
aimToggle.Size = UDim2.new(0, 200, 0, 35)
aimToggle.Position = UDim2.new(0, 15, 0, 15)
aimToggle.BackgroundColor3 = Config.AimbotEnabled and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
aimToggle.Text = Config.AimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
aimToggle.TextColor3 = Color3.fromRGB(255,255,255)
aimToggle.Font = Enum.Font.GothamBold
aimToggle.Parent = aimbotFrame

aimToggle.MouseButton1Click:Connect(function()
    Config.AimbotEnabled = not Config.AimbotEnabled
    aimToggle.BackgroundColor3 = Config.AimbotEnabled and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
    aimToggle.Text = Config.AimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
end)

local distInput = Instance.new("TextBox")
distInput.Size = UDim2.new(0, 200, 0, 30)
distInput.Position = UDim2.new(0, 15, 0, 60)
distInput.BackgroundColor3 = Color3.fromRGB(50,50,50)
distInput.Text = "Дистанция: " .. tostring(Config.AimbotMaxDistance)
distInput.TextColor3 = Color3.fromRGB(255,255,255)
distInput.Font = Enum.Font.Gotham
distInput.Parent = aimbotFrame
distInput.FocusLost:Connect(function()
    local num = tonumber(distInput.Text:match("%d+"))
    if num then
        Config.AimbotMaxDistance = num
        distInput.Text = "Дистанция: " .. tostring(num)
    end
end)
--[[
    Project: San Diego Border RP Script (Ultimate v3 - Часть 3)
    Телепорт (Hyper обход) + сохранение точек
]]

local tpFrame = tabFrames["Teleport"]

-- Поле ввода названия
local tpInput = Instance.new("TextBox")
tpInput.Size = UDim2.new(0, 200, 0, 30)
tpInput.Position = UDim2.new(0, 15, 0, 15)
tpInput.BackgroundColor3 = Color3.fromRGB(50,50,50)
tpInput.PlaceholderText = "Название точки"
tpInput.Text = ""
tpInput.TextColor3 = Color3.fromRGB(255,255,255)
tpInput.Font = Enum.Font.Gotham
tpInput.Parent = tpFrame

-- Кнопка сохранения
local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0, 200, 0, 30)
saveBtn.Position = UDim2.new(0, 15, 0, 55)
saveBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
saveBtn.Text = "Сохранить точку"
saveBtn.TextColor3 = Color3.fromRGB(255,255,255)
saveBtn.Font = Enum.Font.GothamBold
saveBtn.Parent = tpFrame

-- Список точек
local listFrame = Instance.new("ScrollingFrame")
listFrame.Size = UDim2.new(0, 270, 0, 200)
listFrame.Position = UDim2.new(0, 220, 0, 15)
listFrame.BackgroundTransparency = 1
listFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
listFrame.Parent = tpFrame

-- Безопасный телепорт (Hyper метод)
local function safeTeleport(targetCF)
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    
    -- Заморозка
    hum.PlatformStand = true
    root.AssemblyLinearVelocity = Vector3.new(0,0,0)
    root.AssemblyAngularVelocity = Vector3.new(0,0,0)
    
    -- Мгновенный перенос
    if char.PrimaryPart then
        char:SetPrimaryPartCFrame(targetCF)
    else
        root.CFrame = targetCF
    end
    
    -- Повторная фиксация через 0.05 сек
    task.delay(0.05, function()
        if char and root and hum then
            if char.PrimaryPart then
                char:SetPrimaryPartCFrame(targetCF)
            else
                root.CFrame = targetCF
            end
            root.AssemblyLinearVelocity = Vector3.new(0,0,0)
            root.AssemblyAngularVelocity = Vector3.new(0,0,0)
            hum.PlatformStand = false
        end
    end)
end

-- Обновление списка точек
local function updateList()
    for _, child in ipairs(listFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    local y = 0
    for name, data in pairs(Config.SavedWaypoints) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 30)
        row.Position = UDim2.new(0, 0, 0, y)
        row.BackgroundTransparency = 1
        row.Parent = listFrame
        
        local tpBtn = Instance.new("TextButton")
        tpBtn.Size = UDim2.new(0, 180, 1, 0)
        tpBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
        tpBtn.Text = "TP: " .. name
        tpBtn.TextColor3 = Color3.fromRGB(255,255,255)
        tpBtn.Font = Enum.Font.Gotham
        tpBtn.Parent = row
        tpBtn.MouseButton1Click:Connect(function()
            safeTeleport(CFrame.new(unpack(data)))
        end)
        
        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0, 70, 1, 0)
        delBtn.Position = UDim2.new(0, 185, 0, 0)
        delBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
        delBtn.Text = "Удалить"
        delBtn.TextColor3 = Color3.fromRGB(255,255,255)
        delBtn.Font = Enum.Font.GothamBold
        delBtn.Parent = row
        delBtn.MouseButton1Click:Connect(function()
            Config.SavedWaypoints[name] = nil
            saveConfigToFile()
            updateList()
        end)
        
        y = y + 35
    end
end

saveBtn.MouseButton1Click:Connect(function()
    local name = tpInput.Text
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if name ~= "" and root then
        local p = root.Position
        Config.SavedWaypoints[name] = {p.X, p.Y, p.Z}
        saveConfigToFile()
        updateList()
        tpInput.Text = ""
    end
end)

updateList()
print("✅ Ultimate v3 загружен! /rp - восстановить UI.")
