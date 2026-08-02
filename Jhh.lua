--[[
    Project: San Diego Border RP Script (Ultimate v4 - Часть 1)
    Настройки, скорость, полёт (Fly), ESP
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
if not GlobalEnv.BorderRP_Config_v4 then
    GlobalEnv.BorderRP_Config_v4 = {
        SpeedEnabled = false,
        WalkSpeedValue = 16,
        FlyEnabled = false,
        FlySpeedValue = 150,
        XRayEnabled = false,
        XRayTarget = "Все",
        AimbotEnabled = false,
        AimbotMode = "Оружие",
        AimbotTarget = "Все",
        AimbotMaxDistance = 500,
        AimbotWallCheck = true,
        SavedWaypoints = {}
    }
end
local Config = GlobalEnv.BorderRP_Config_v4

-- Сохранение
local function saveConfig()
    if writefile and HttpService then
        pcall(function()
            writefile("BorderRP_Config_v4.json", HttpService:JSONEncode(Config.SavedWaypoints))
        end)
    end
end

if readfile and isfile and isfile("BorderRP_Config_v4.json") then
    pcall(function()
        local data = readfile("BorderRP_Config_v4.json")
        local decoded = HttpService:JSONDecode(data)
        if decoded then
            Config.SavedWaypoints = decoded
        end
    end)
end

-- ===== СКОРОСТЬ (БЕЗ СМЕРТИ) =====
local function applySpeed(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = Config.WalkSpeedValue
    end
end

RunService.Stepped:Connect(function()
    if Config.SpeedEnabled then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed ~= Config.WalkSpeedValue then
                hum.WalkSpeed = Config.WalkSpeedValue
            end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    if Config.SpeedEnabled then
        task.wait(0.5)
        applySpeed(char)
    end
    if Config.FlyEnabled then
        task.wait(0.5)
        startFly()
    end
end)

-- ===== ПОЛЁТ (FLY) =====
local flyConnection = nil
local flyBodyVelocity = nil
local flyBodyGyro = nil

local function startFly()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    if root:FindFirstChild("RP_FlyVelocity") then root.RP_FlyVelocity:Destroy() end
    if root:FindFirstChild("RP_FlyGyro") then root.RP_FlyGyro:Destroy() end
    
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.Name = "RP_FlyVelocity"
    flyBodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = root
    
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.Name = "RP_FlyGyro"
    flyBodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    flyBodyGyro.CFrame = Camera.CFrame
    flyBodyGyro.Parent = root
end

local function stopFly()
    if flyBodyVelocity then
        flyBodyVelocity:Destroy()
        flyBodyVelocity = nil
    end
    if flyBodyGyro then
        flyBodyGyro:Destroy()
        flyBodyGyro = nil
    end
end

flyConnection = RunService.RenderStepped:Connect(function()
    if Config.FlyEnabled then
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then
            stopFly()
            return
        end
        
        if not root:FindFirstChild("RP_FlyVelocity") then
            startFly()
        end
        
        local moveDir = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
        
        local bv = root:FindFirstChild("RP_FlyVelocity")
        local bg = root:FindFirstChild("RP_FlyGyro")
        if bv and bg then
            if moveDir.Magnitude > 0 then
                bv.Velocity = moveDir.Unit * Config.FlySpeedValue
            else
                bv.Velocity = Vector3.new(0, 0.1, 0)
            end
            bg.CFrame = Camera.CFrame
        end
    else
        stopFly()
    end
end)

-- ===== ESP (X-RAY) =====
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

local function matchesFilter(player, filter)
    if filter == "Все" then return true end
    return getPlayerRole(player) == filter
end

local function getRoleColor(role)
    if role == "Преступники" then return Color3.fromRGB(255,0,0)
    elseif role == "Полицейские" then return Color3.fromRGB(0,100,255)
    else return Color3.fromRGB(0,255,0) end
end

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
    Project: San Diego Border RP Script (Ultimate v4 - Часть 2)
    Аимбот с режимами: Оружие, ЛКМ, Всегда
]]

local currentTarget = nil

local function hasWeapon()
    local char = LocalPlayer.Character
    if not char then return false end
    return char:FindFirstChildOfClass("Tool") ~= nil
end

local function isValidTarget(part)
    if not part or not part.Parent then return false end
    local char = part.Parent
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    return (part.Position - root.Position).Magnitude <= Config.AimbotMaxDistance
end

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

RunService.RenderStepped:Connect(function()
    if not Config.AimbotEnabled then
        currentTarget = nil
        return
    end
    
    local shouldAim = false
    if Config.AimbotMode == "Всегда" then
        shouldAim = true
    elseif Config.AimbotMode == "ЛКМ" then
        shouldAim = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
    elseif Config.AimbotMode == "Оружие" then
        shouldAim = hasWeapon()
    end
    
    if not shouldAim then
        currentTarget = nil
        return
    end
    
    if not isValidTarget(currentTarget) then
        currentTarget = getClosestTarget()
    end
    
    if currentTarget then
        local newCF = CFrame.new(Camera.CFrame.Position, currentTarget.Position)
        Camera.CFrame = Camera.CFrame:Lerp(newCF, 0.3)
    end
end)
--[[
    Project: San Diego Border RP Script (Ultimate v4 - Часть 3)
    UI + Телепорт с защитой
]]

-- ===== UI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BorderRP_GUI_v4"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0, 40, 0, 150)
ToggleButton.BackgroundColor3 = Color3.fromRGB(240, 50, 50)
ToggleButton.Text = "RP"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 15
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 300)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 28)
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TopBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Position = UDim2.new(0, 8, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "San Diego RP | v4"
TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
TitleLabel.TextSize = 12
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -26, 0, 1)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(180, 180, 180)
CloseButton.TextSize = 14
CloseButton.Parent = TopBar
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleButton.Visible = true
end)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
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
TabBar.Size = UDim2.new(1, 0, 0, 26)
TabBar.Position = UDim2.new(0, 0, 0, 28)
TabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TabBar.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -54)
ContentFrame.Position = UDim2.new(0, 0, 0, 54)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local tabs = {"Speed", "Fly", "X-Ray", "Aimbot", "Teleport"}
local tabFrames = {}

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/#tabs, 0, 1, 0)
    btn.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(170, 170, 170)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = TabBar
    
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = (i == 1)
    frame.CanvasSize = UDim2.new(0, 0, 1.5, 0)
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
speedToggle.Size = UDim2.new(0, 150, 0, 28)
speedToggle.Position = UDim2.new(0, 10, 0, 10)
speedToggle.BackgroundColor3 = Config.SpeedEnabled and Color3.fromRGB(40,170,40) or Color3.fromRGB(170,40,40)
speedToggle.Text = Config.SpeedEnabled and "Speed: ON" or "Speed: OFF"
speedToggle.TextColor3 = Color3.fromRGB(255,255,255)
speedToggle.Font = Enum.Font.GothamBold
speedToggle.TextSize = 11
speedToggle.Parent = speedFrame
speedToggle.MouseButton1Click:Connect(function()
    Config.SpeedEnabled = not Config.SpeedEnabled
    speedToggle.BackgroundColor3 = Config.SpeedEnabled and Color3.fromRGB(40,170,40) or Color3.fromRGB(170,40,40)
    speedToggle.Text = Config.SpeedEnabled and "Speed: ON" or "Speed: OFF"
    if Config.SpeedEnabled and LocalPlayer.Character then applySpeed(LocalPlayer.Character) end
end)

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 150, 0, 28)
speedInput.Position = UDim2.new(0, 10, 0, 45)
speedInput.BackgroundColor3 = Color3.fromRGB(40,40,40)
speedInput.Text = tostring(Config.WalkSpeedValue)
speedInput.TextColor3 = Color3.fromRGB(255,255,255)
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 11
speedInput.Parent = speedFrame
speedInput.FocusLost:Connect(function()
    local val = tonumber(speedInput.Text)
    if val then Config.WalkSpeedValue = val end
end)

-- Fly
local flyFrame = tabFrames["Fly"]
local flyToggle = Instance.new("TextButton")
flyToggle.Size = UDim2.new(0, 150, 0, 28)
flyToggle.Position = UDim2.new(0, 10, 0, 10)
flyToggle.BackgroundColor3 = Config.FlyEnabled and Color3.fromRGB(40,170,40) or Color3.fromRGB(170,40,40)
flyToggle.Text = Config.FlyEnabled and "Fly: ON" or "Fly: OFF"
flyToggle.TextColor3 = Color3.fromRGB(255,255,255)
flyToggle.Font = Enum.Font.GothamBold
flyToggle.TextSize = 11
flyToggle.Parent = flyFrame
flyToggle.MouseButton1Click:Connect(function()
    Config.FlyEnabled = not Config.FlyEnabled
    flyToggle.BackgroundColor3 = Config.FlyEnabled and Color3.fromRGB(40,170,40) or Color3.fromRGB(170,40,40)
    flyToggle.Text = Config.FlyEnabled and "Fly: ON" or "Fly: OFF"
end)

local flyInput = Instance.new("TextBox")
flyInput.Size = UDim2.new(0, 150, 0, 28)
flyInput.Position = UDim2.new(0, 10, 0, 45)
flyInput.BackgroundColor3 = Color3.fromRGB(40,40,40)
flyInput.Text = tostring(Config.FlySpeedValue)
flyInput.TextColor3 = Color3.fromRGB(255,255,255)
flyInput.Font = Enum.Font.Gotham
flyInput.TextSize = 11
flyInput.Parent = flyFrame
flyInput.FocusLost:Connect(function()
    local val = tonumber(flyInput.Text)
    if val then Config.FlySpeedValue = val end
end)

-- X-Ray
local xrayFrame = tabFrames["X-Ray"]
local xrayToggle = Instance.new("TextButton")
xrayToggle.Size = UDim2.new(0, 150, 0, 28)
xrayToggle.Position = UDim2.new(0, 10, 0, 10)
xrayToggle.BackgroundColor3 = Config.XRayEnabled and Color3.fromRGB(40,170,40) or Color3.fromRGB(170,40,40)
xrayToggle.Text = Config.XRayEnabled and "X-Ray: ON" or "X-Ray: OFF"
xrayToggle.TextColor3 = Color3.fromRGB(255,255,255)
xrayToggle.Font = Enum.Font.GothamBold
xrayToggle.TextSize = 11
xrayToggle.Parent = xrayFrame
xrayToggle.MouseButton1Click:Connect(function()
    Config.XRayEnabled = not Config.XRayEnabled
    xrayToggle.BackgroundColor3 = Config.XRayEnabled and Color3.fromRGB(40,170,40) or Color3.fromRGB(170,40,40)
    xrayToggle.Text = Config.XRayEnabled and "X-Ray: ON" or "X-Ray: OFF"
end)

local targets = {"Все", "Преступники", "Полицейские", "Граждане"}
for i, name in ipairs(targets) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 0, 24)
    btn.Position = UDim2.new(0, 10 + ((i-1) * 85), 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(220,220,220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 10
    btn.Parent = xrayFrame
    btn.MouseButton1Click:Connect(function()
        Config.XRayTarget = name
    end)
end

-- Aimbot
local aimbotFrame = tabFrames["Aimbot"]
local aimToggle = Instance.new("TextButton")
aimToggle.Size = UDim2.new(0, 150, 0, 28)
aimToggle.Position = UDim2.new(0, 10, 0, 10)
aimToggle.BackgroundColor3 = Config.AimbotEnabled and Color3.fromRGB(40,170,40) or Color3.fromRGB(170,40,40)
aimToggle.Text = Config.AimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
aimToggle.TextColor3 = Color3.fromRGB(255,255,255)
aimToggle.Font = Enum.Font.GothamBold
aimToggle.TextSize = 11
aimToggle.Parent = aimbotFrame
aimToggle.MouseButton1Click:Connect(function()
    Config.AimbotEnabled = not Config.AimbotEnabled
    aimToggle.BackgroundColor3 = Config.AimbotEnabled and Color3.fromRGB(40,170,40) or Color3.fromRGB(170,40,40)
    aimToggle.Text = Config.AimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
end)

local modes = {"Оружие", "ЛКМ", "Всегда"}
for i, name in ipairs(modes) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 0, 24)
    btn.Position = UDim2.new(0, 10 + ((i-1) * 85), 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(220,220,220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 10
    btn.Parent = aimbotFrame
    btn.MouseButton1Click:Connect(function()
        Config.AimbotMode = name
    end)
end

-- Teleport
local tpFrame = tabFrames["Teleport"]

local tpInput = Instance.new("TextBox")
tpInput.Size = UDim2.new(0, 150, 0, 26)
tpInput.Position = UDim2.new(0, 10, 0, 10)
tpInput.BackgroundColor3 = Color3.fromRGB(40,40,40)
tpInput.PlaceholderText = "Название точки"
tpInput.Text = ""
tpInput.TextColor3 = Color3.fromRGB(255,255,255)
tpInput.Font = Enum.Font.Gotham
tpInput.TextSize = 10
tpInput.Parent = tpFrame

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0, 150, 0, 26)
saveBtn.Position = UDim2.new(0, 10, 0, 40)
saveBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
saveBtn.Text = "Сохранить точку"
saveBtn.TextColor3 = Color3.fromRGB(255,255,255)
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 10
saveBtn.Parent = tpFrame

local listFrame = Instance.new("ScrollingFrame")
listFrame.Size = UDim2.new(0, 190, 0, 160)
listFrame.Position = UDim2.new(0, 170, 0, 10)
listFrame.BackgroundTransparency = 1
listFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
listFrame.Parent = tpFrame

-- Телепорт (без античита)
local function safeTeleport(targetCF)
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    
    hum.PlatformStand = true
    root.AssemblyLinearVelocity = Vector3.new(0,0,0)
    root.CFrame = targetCF
    
    task.delay(0.05, function()
        if root and hum then
            root.CFrame = targetCF
            hum.PlatformStand = false
        end
    end)
end

-- Обновление списка
local function updateList()
    for _, child in ipairs(listFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    local y = 0
    for name, data in pairs(Config.SavedWaypoints) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 26)
        row.Position = UDim2.new(0, 0, 0, y)
        row.BackgroundTransparency = 1
        row.Parent = listFrame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 90, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(255,255,255)
        label.TextSize = 10
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = row
        
        -- TP
        local tpBtn = Instance.new("TextButton")
        tpBtn.Size = UDim2.new(0, 45, 1, 0)
        tpBtn.Position = UDim2.new(0, 92, 0, 0)
        tpBtn.BackgroundColor3 = Color3.fromRGB(40,120,40)
        tpBtn.Text = "TP"
        tpBtn.TextColor3 = Color3.fromRGB(255,255,255)
        tpBtn.Font = Enum.Font.GothamBold
        tpBtn.TextSize = 10
        tpBtn.Parent = row
        tpBtn.MouseButton1Click:Connect(function()
            safeTeleport(CFrame.new(unpack(data)))
        end)
        
        -- Удалить (удержание 2 сек)
        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0, 45, 1, 0)
        delBtn.Position = UDim2.new(0, 140, 0, 0)
        delBtn.BackgroundColor3 = Color3.fromRGB(150,40,40)
        delBtn.Text = "Удалить"
        delBtn.TextColor3 = Color3.fromRGB(255,255,255)
        delBtn.Font = Enum.Font.Gotham
        delBtn.TextSize = 9
        delBtn.Parent = row
        
        local holdTime = 2
        local holding = false
        delBtn.MouseButton1Down:Connect(function()
            holding = true
            local startTick = tick()
            task.spawn(function()
                while holding do
                    local elapsed = tick() - startTick
                    if elapsed >= holdTime then
                        Config.SavedWaypoints[name] = nil
                        saveConfig()
                        updateList()
                        break
                    end
                    delBtn.Text = string.Format("%.1fs", holdTime - elapsed)
                    task.wait(0.1)
                end
                delBtn.Text = "Удалить"
            end)
        end)
        delBtn.MouseButton1Up:Connect(function()
            holding = false
            delBtn.Text = "Удалить"
        end)
        
        y = y + 30
    end
end

saveBtn.MouseButton1Click:Connect(function()
    local name = tpInput.Text
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if name ~= "" and root then
        local p = root.Position
        Config.SavedWaypoints[name] = {p.X, p.Y, p.Z}
        saveConfig()
        updateList()
        tpInput.Text = ""
    end
end)

updateList()

print("✅ Ultimate v4 загружен! /rp - восстановить UI.")
