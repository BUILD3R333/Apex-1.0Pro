-- ==========================================
-- 🚀 ApexZen.lua V5 (ФИНАЛ + ВКЛАДКА ФАРМ)
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 🔹 ПЕРЕМЕННЫЕ СОСТОЯНИЙ
local states = {
    Invisible = false, WalkSpeed = 16, Noclip = false, ESP = false,
    Fly = false, FlySpeed = 50, InfJump = false, SpeedGlitch = false,
    GlitchSpeed = 50, Aimbot = false, AntiAFK = false, GodMode = false,
    AimbotFOV = 50, AutoFarmCoins = false, FarmMode = "Везде",
    Language = "RUS", CurrentTheme = "Деловой: Чёрный"
}
local murdererPlayer = nil

-- 🔹 БАЗА ИНТЕРФЕЙСА
local ApexGui = Instance.new("ScreenGui")
ApexGui.Name = "ApexZen"
ApexGui.ResetOnSpawn = false
if gethui then ApexGui.Parent = gethui() elseif syn and syn.protect_gui then syn.protect_gui(ApexGui); ApexGui.Parent = CoreGui else ApexGui.Parent = CoreGui end

local OpenBtn = Instance.new("TextButton", ApexGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50); OpenBtn.Position = UDim2.new(0, 20, 0, 20)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 85, 255); OpenBtn.Text = "⚙️"; OpenBtn.TextSize = 24
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

local MainWindow = Instance.new("Frame", ApexGui)
MainWindow.Size = UDim2.new(0, 400, 0, 440); MainWindow.Position = UDim2.new(0.5, -200, 0.5, -220)
MainWindow.BackgroundColor3 = Color3.fromRGB(25, 25, 25); MainWindow.Visible = false
Instance.new("UICorner", MainWindow).CornerRadius = UDim.new(0, 16)

local DragBar = Instance.new("Frame", MainWindow)
DragBar.Size = UDim2.new(1, 0, 0, 20); DragBar.Position = UDim2.new(0, 0, 1, -20)
DragBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40); DragBar.BorderSizePixel = 0
Instance.new("UICorner", DragBar).CornerRadius = UDim.new(0, 16)

local dragging, dragInput, dragStart, startPos
DragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainWindow.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
DragBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

OpenBtn.MouseButton1Click:Connect(function() MainWindow.Visible = not MainWindow.Visible end)

-- Скрытие/Показ UI на Tab
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Tab then
        ApexGui.Enabled = not ApexGui.Enabled
    end
end)

-- 🔹 СИСТЕМА ВКЛАДОК
local Sidebar = Instance.new("Frame", MainWindow)
Sidebar.Size = UDim2.new(0, 110, 1, -20); Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 16)

local ContentArea = Instance.new("Frame", MainWindow)
ContentArea.Size = UDim2.new(1, -110, 1, -20); ContentArea.Position = UDim2.new(0, 110, 0, 0); ContentArea.BackgroundTransparency = 1

local Tabs, TabButtons = {}, {}
local function createTab(name, icon, isFirst)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, 0, 0, 40); btn.Position = UDim2.new(0, 0, 0, (#TabButtons * 40) + 10)
    btn.BackgroundTransparency = isFirst and 0 or 1; btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = icon .. " " .. name; btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Font = Enum.Font.GothamBold; btn.TextSize = 12
    table.insert(TabButtons, btn)
    
    local scroll = Instance.new("ScrollingFrame", ContentArea)
    scroll.Size = UDim2.new(1, 0, 1, 0); scroll.BackgroundTransparency = 1; scroll.ScrollBarThickness = 4; scroll.Visible = isFirst
    Tabs[name] = scroll
    
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 10); layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; layout.SortOrder = Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding", scroll).PaddingTop = UDim.new(0, 10)
    
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Visible = false end
        for _, b in pairs(TabButtons) do b.BackgroundTransparency = 1 end
        scroll.Visible = true; btn.BackgroundTransparency = 0
    end)
    return scroll
end

local TabCmds = createTab("Команды", "⚡", true)
local TabFarm = createTab("Фарм", "🪙", false)
local TabDesign = createTab("Дизайн", "🎨", false)
local TabSettings = createTab("Настройки", "⚙️", false)

-- 🔹 ТЕМЫ И БЕЗОПАСНОЕ СОХРАНЕНИЕ (pcall)
local themes = {
    ["Деловой: Чёрный"] = {bg = Color3.fromRGB(25,25,25), side = Color3.fromRGB(20,20,20), btn = Color3.fromRGB(45,45,45), text = Color3.fromRGB(255,255,255)},
    ["Деловой: Серый"] = {bg = Color3.fromRGB(50,50,50), side = Color3.fromRGB(40,40,40), btn = Color3.fromRGB(70,70,70), text = Color3.fromRGB(250,250,250)},
    ["Уникал: Океан"] = {bg = Color3.fromRGB(15,35,55), side = Color3.fromRGB(10,25,45), btn = Color3.fromRGB(30,70,100), text = Color3.fromRGB(200,230,255)},
    ["Уникал: Конфетная"]= {bg = Color3.fromRGB(255,182,193), side = Color3.fromRGB(255,105,180), btn = Color3.fromRGB(219,112,147), text = Color3.fromRGB(255,255,255)},
}
local uiElements = {btns = {}, themeBtns = {}, inputs = {}}

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
                for k, v in pairs(decoded) do if states[k] ~= nil then states[k] = v end end
            end
        end
    end)
end
loadConfig()

local function applyTheme(themeName)
    local t = themes[themeName]; if not t then return end
    states.CurrentTheme = themeName; saveConfig()
    MainWindow.BackgroundColor3 = t.bg; Sidebar.BackgroundColor3 = t.side
    
    for _, data in pairs(uiElements.btns) do
        if not (data.stateKey and states[data.stateKey]) then data.btn.BackgroundColor3 = t.btn; data.btn.TextColor3 = t.text end
    end
    
    for name, btn in pairs(uiElements.themeBtns) do
        if name == themeName then
            btn.Text = "✅ " .. name; btn.UIStroke.Color = Color3.fromRGB(0, 255, 100); btn.UIStroke.Thickness = 2
        else
            btn.Text = name; btn.UIStroke.Thickness = 0
        end
    end
end
-- ==========================================
-- 🚀 ApexZen.lua V5 (ФИНАЛ + ВКЛАДКА ФАРМ) — ЧАСТЬ 2
-- ==========================================

-- 🔹 ФУНКЦИОНАЛ КОМАНД

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    if states.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- God Mode с проверкой жизни
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
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.Transparency = state and 1 or 0
            elseif part:IsA("Decal") then part.Transparency = state and 1 or 0 end
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
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end
    end
end
RunService.Stepped:Connect(function()
    if states.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
    end
end)

-- ESP & Murderer Detection
local espObjects = {}
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
                        if item.Name == "Knife" or item.Name == "Murderer" then roleColor = Color3.fromRGB(255, 0, 0)
                        elseif item.Name == "Gun" or item.Name == "Sheriff" then roleColor = Color3.fromRGB(0, 0, 255) end
                    end
                end
            end
            local box = Instance.new("BoxHandleAdornment")
            box.Size = player.Character:GetExtentsSize(); box.Adornee = player.Character.HumanoidRootPart; box.AlwaysOnTop = true
            box.ZIndex = 5; box.Transparency = 0.6; box.Color3 = roleColor; box.Parent = CoreGui
            table.insert(espObjects, box)
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

-- Aimbot с FOV
RunService.RenderStepped:Connect(function()
    if states.Aimbot and states.ESP then
        local target = getActiveMurderer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = target.Character.HumanoidRootPart.Position
            local myPos = LocalPlayer.Character.HumanoidRootPart.Position
            
            if (targetPos - myPos).Magnitude <= states.AimbotFOV then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
            end
        end
    end
end)

-- Безопасный телепорт к убийце
local function teleportToMurderer(btnInstance)
    local target = getActiveMurderer()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetHRP = target.Character.HumanoidRootPart
        local safeOffset = Vector3.new(math.random(-5, 5), 0, math.random(5, 8))
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetHRP.CFrame + safeOffset
        
        if btnInstance then
            local oldText = btnInstance.Text
            btnInstance.Text = "✅ Телепорт!"
            task.delay(0.5, function()
                if btnInstance then btnInstance.Text = oldText end
            end)
        end
    end
end

-- Авто-телепорт к пистолету
local lastGunObj = nil
RunService.Heartbeat:Connect(function()
    for _, obj in pairs(workspace:GetChildren()) do
        if (obj.Name == "Gun" or obj.Name == "DroppedGun") and obj ~= lastGunObj then
            local part = obj:IsA("Tool") and obj.Handle or obj:FindFirstChild("Handle") or (obj:IsA("BasePart") and obj)
            if part and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                lastGunObj = obj
                local hrp = LocalPlayer.Character.HumanoidRootPart
                local origCF = hrp.CFrame
                hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                task.wait(0.15)
                hrp.CFrame = origCF
                task.delay(5, function() if lastGunObj == obj then lastGunObj = nil end end)
            end
        end
    end
end)

-- 🔹 НОВАЯ СИСТЕМА ФАРМА (С РЕЖИМАМИ)
local function collectCoins()
    if not states.AutoFarmCoins then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

    local hrp = LocalPlayer.Character.HumanoidRootPart
    local myPos = hrp.Position
    local farmMode = states.FarmMode

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

            -- Проверка режима сбора
            if farmMode == "Над землёй" and coinPos.Y < 0 then
                continue
            elseif farmMode == "Под землёй" and coinPos.Y >= 0 then
                continue
            end

            if distance < 200 then
                local origCF = hrp.CFrame
                hrp.CFrame = CFrame.new(coinPos + Vector3.new(0, 2, 0))
                task.wait(0.05)
                hrp.CFrame = origCF
                break
            end
        end
    end
end

-- Запуск фарма
RunService.Heartbeat:Connect(function()
    if states.AutoFarmCoins then
        collectCoins()
    end
end)

-- Fly
local flyBV, flyBG
local function setFly(state)
    states.Fly = state; saveConfig()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    if state then
        flyBV = Instance.new("BodyVelocity", hrp); flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge); flyBV.Velocity = Vector3.zero
        flyBG = Instance.new("BodyGyro", hrp); flyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); flyBG.P = 10000; flyBG.CFrame = hrp.CFrame
    else
        if flyBV then flyBV:Destroy() end; if flyBG then flyBG:Destroy() end
    end
end

RunService.RenderStepped:Connect(function()
    if states.Fly and flyBV and flyBG and LocalPlayer.Character then
        local camCF = Camera.CFrame; local moveDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
        if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end
        flyBV.Velocity = moveDir * states.FlySpeed; flyBG.CFrame = camCF
    end
end)

UserInputService.JumpRequest:Connect(function()
    if states.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
    newChar:WaitForChild("HumanoidRootPart")
    task.wait(0.5)
    if states.Invisible then setInvisibility(true) end
    if states.Fly then setFly(true) end
end)

-- 🔹 ГЕНЕРАТОРЫ ИНТЕРФЕЙСА
local function createToggle(parent, name, stateKey, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.9, 0, 0, 35); btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name .. ": " .. (states[stateKey] and "ON" or "OFF")
    btn.BackgroundColor3 = states[stateKey] and Color3.fromRGB(40, 160, 60) or Color3.fromRGB(45, 45, 45)
    btn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    table.insert(uiElements.btns, {btn = btn, stateKey = stateKey})

    btn.MouseButton1Click:Connect(function()
        local newState = not states[stateKey]
        if callback then callback(newState) else states[stateKey] = newState; saveConfig() end
        btn.Text = name .. ": " .. (states[stateKey] and "ON" or "OFF")
        btn.BackgroundColor3 = states[stateKey] and Color3.fromRGB(40, 160, 60) or themes[states.CurrentTheme].btn
        btn.Size = UDim2.new(0.85, 0, 0, 33); task.wait(0.1); btn.Size = UDim2.new(0.9, 0, 0, 35)
    end)
end

local function createButton(parent, name, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.9, 0, 0, 35); btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    table.insert(uiElements.btns, {btn = btn})

    btn.MouseButton1Click:Connect(function()
        btn.Size = UDim2.new(0.85, 0, 0, 33); task.wait(0.1); btn.Size = UDim2.new(0.9, 0, 0, 35)
        if callback then callback(btn) end
    end)
end

local function createInputOnly(parent, labelText, stateKey)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(0.9, 0, 0, 35); container.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(0.65, 0, 1, 0); label.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    label.TextColor3 = Color3.fromRGB(255, 255, 255); label.Text = " " .. labelText
    label.Font = Enum.Font.GothamSemibold; label.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", label).CornerRadius = UDim.new(0, 8)
    table.insert(uiElements.btns, {btn = label})
    
    local input = Instance.new("TextBox", container)
    input.Size = UDim2.new(0.32, 0, 1, 0); input.Position = UDim2.new(0.68, 0, 0, 0)
    input.BackgroundColor3 = Color3.fromRGB(30, 30, 30); input.TextColor3 = Color3.fromRGB(200, 255, 200)
    input.Text = tostring(states[stateKey]); input.Font = Enum.Font.GothamBold; input.ClearTextOnFocus = false
    Instance.new("UICorner", input).CornerRadius = UDim.new(0, 8)
    
    input.FocusLost:Connect(function()
        local val = tonumber(input.Text)
        if val then states[stateKey] = val; saveConfig() else input.Text = tostring(states[stateKey]) end
    end)
end

-- Создание кнопок выбора режима фарма
local function createFarmModeButton(parent, modeName)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = (states.FarmMode == modeName) and Color3.fromRGB(40, 160, 60) or Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = modeName
    btn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    table.insert(uiElements.btns, {btn = btn})

    btn.MouseButton1Click:Connect(function()
        states.FarmMode = modeName
        saveConfig()
        -- Обновляем все кнопки режимов
        for _, child in pairs(parent:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = (child.Text == modeName) and Color3.fromRGB(40, 160, 60) or Color3.fromRGB(45, 45, 45)
            end
        end
        -- Анимация
        btn.Size = UDim2.new(0.85, 0, 0, 33); task.wait(0.1); btn.Size = UDim2.new(0.9, 0, 0, 35)
    end)
    return btn
end

-- 🔹 НАПОЛНЕНИЕ ВКЛАДОК

-- Команды
createButton(TabCmds, "👤 Teleport to Murderer", function(btn) teleportToMurderer(btn) end)
createToggle(TabCmds, "🛡️ God Mode", "GodMode")
createToggle(TabCmds, "⏳ Anti-AFK", "AntiAFK")
createToggle(TabCmds, "👻 Invisible", "Invisible", setInvisibility)
createToggle(TabCmds, "🚪 Noclip", "Noclip", toggleNoclip)
createToggle(TabCmds, "👁️ ESP", "ESP", function(s) states.ESP = s; saveConfig(); if not s then updateESP() end end)
createToggle(TabCmds, "🎯 Aimbot", "Aimbot")
createToggle(TabCmds, "🕊️ Fly (Вкл/Выкл)", "Fly", setFly)
createToggle(TabCmds, "🦘 Inf Jump", "InfJump")
createToggle(TabCmds, "💨 Speed Glitch", "SpeedGlitch")

-- Фарм
createToggle(TabFarm, "🪙 Автофарм монет", "AutoFarmCoins")
-- Кнопки выбора режима
local farmLabel = Instance.new("TextLabel", TabFarm)
farmLabel.Size = UDim2.new(0.9, 0, 0, 25)
farmLabel.BackgroundTransparency = 1
farmLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
farmLabel.Text = "Режим сбора:"
farmLabel.Font = Enum.Font.GothamBold
farmLabel.TextSize = 14

createFarmModeButton(TabFarm, "Над землёй")
createFarmModeButton(TabFarm, "Под землёй")
createFarmModeButton(TabFarm, "Везде")

-- Дизайн
for themeName, _ in pairs(themes) do
    local btn = Instance.new("TextButton", TabDesign)
    btn.Size = UDim2.new(0.9, 0, 0, 35); btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Text = themeName; btn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; stroke.Thickness = 0
    
    table.insert(uiElements.btns, {btn = btn}); uiElements.themeBtns[themeName] = btn
    btn.MouseButton1Click:Connect(function() applyTheme(themeName) end)
end

-- Настройки
createButton(TabSettings, "🔄 Hide UI (Press TAB)", function() ApexGui.Enabled = not ApexGui.Enabled end)
createInputOnly(TabSettings, "🎯 Aimbot FOV (Дистанция)", "AimbotFOV")
createInputOnly(TabSettings, "🚶 WalkSpeed", "WalkSpeed")
createInputOnly(TabSettings, "✈️ Скорость Полёта", "FlySpeed")
createInputOnly(TabSettings, "⚡ Скорость Глитча", "GlitchSpeed")

-- Язык
local langBtn = Instance.new("TextButton", TabSettings)
langBtn.Size = UDim2.new(0.9, 0, 0, 35)
langBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
langBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
langBtn.Text = (states.Language == "RUS") and "Язык: RUS 🇷🇺" or "Language: ENG 🇬🇧"
langBtn.Font = Enum.Font.GothamSemibold
Instance.new("UICorner", langBtn).CornerRadius = UDim.new(0, 8)
table.insert(uiElements.btns, {btn = langBtn})

langBtn.MouseButton1Click:Connect(function()
    if states.Language == "RUS" then
        states.Language = "ENG"
        langBtn.Text = "Language: ENG 🇬🇧"
    else
        states.Language = "RUS"
        langBtn.Text = "Язык: RUS 🇷🇺"
    end
    saveConfig()
end)

-- Инициализация
task.spawn(function()
    task.wait(0.1)
    applyTheme(states.CurrentTheme)
    if states.Invisible then setInvisibility(true) end
    if states.Fly then setFly(true) end
end)
