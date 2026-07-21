--[[ Apex Lite 2.0 ]] return(function()
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    local rootPart = char:WaitForChild("HumanoidRootPart")
    
    -- ===== ТЕМЫ =====
    local themes = {
        -- Деловые
        ["Деловой (Чёрный)"] = {bg = Color3.fromRGB(10,10,12), frame = Color3.fromRGB(20,20,25), btn = Color3.fromRGB(40,40,45), text = Color3.fromRGB(200,200,200)},
        ["Деловой (Серый)"] = {bg = Color3.fromRGB(30,30,35), frame = Color3.fromRGB(50,50,55), btn = Color3.fromRGB(70,70,75), text = Color3.fromRGB(220,220,220)},
        ["Деловой (Синий)"] = {bg = Color3.fromRGB(8,12,28), frame = Color3.fromRGB(16,24,48), btn = Color3.fromRGB(30,50,100), text = Color3.fromRGB(200,220,255)},
        ["Деловой (Белый)"] = {bg = Color3.fromRGB(200,200,205), frame = Color3.fromRGB(220,220,225), btn = Color3.fromRGB(180,180,185), text = Color3.fromRGB(30,30,35)},
        -- Уникальные
        ["Океан"] = {bg = Color3.fromRGB(0, 20, 40), frame = Color3.fromRGB(0, 60, 80), btn = Color3.fromRGB(0, 100, 120), text = Color3.fromRGB(150, 230, 255)},
        ["Летняя"] = {bg = Color3.fromRGB(60, 40, 20), frame = Color3.fromRGB(100, 70, 30), btn = Color3.fromRGB(140, 100, 50), text = Color3.fromRGB(255, 230, 150)},
        ["Новогодняя"] = {bg = Color3.fromRGB(10, 30, 10), frame = Color3.fromRGB(20, 60, 20), btn = Color3.fromRGB(30, 100, 30), text = Color3.fromRGB(200, 255, 200)},
        ["Конфетная"] = {bg = Color3.fromRGB(60, 20, 40), frame = Color3.fromRGB(90, 30, 60), btn = Color3.fromRGB(140, 50, 100), text = Color3.fromRGB(255, 200, 230)},
        ["Шоколадная"] = {bg = Color3.fromRGB(25,15,10), frame = Color3.fromRGB(45,30,20), btn = Color3.fromRGB(65,45,30), text = Color3.fromRGB(230,210,190)},
        ["Золотая"] = {bg = Color3.fromRGB(40, 30, 10), frame = Color3.fromRGB(70, 50, 15), btn = Color3.fromRGB(110, 80, 30), text = Color3.fromRGB(255, 215, 0)}
    }
    local currentTheme = "Деловой (Серый)"
    
    -- ===== GUI =====
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = player.PlayerGui
    
    -- Главная кнопка (перетаскиваемая)
    local mainBtn = Instance.new("ImageButton")
    mainBtn.Size = UDim2.new(0, 55, 0, 55)
    mainBtn.Position = UDim2.new(0, 15, 0, 100)
    mainBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    mainBtn.BackgroundTransparency = 0.2
    mainBtn.BorderSizePixel = 0
    mainBtn.Parent = screenGui
    mainBtn.Image = "rbxassetid://6031093079"
    mainBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
    
    local cornerMain = Instance.new("UICorner")
    cornerMain.CornerRadius = UDim.new(1, 0)
    cornerMain.Parent = mainBtn
    
    -- Перетаскивание кнопки
    local dragging = false
    local dragStart, startPos
    mainBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainBtn.Position
        end
    end)
    mainBtn.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            mainBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    mainBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    -- Меню (скруглённое)
    local menu = Instance.new("Frame")
    menu.Size = UDim2.new(0, 320, 0, 440)
    menu.Position = UDim2.new(0.5, -160, 0.5, -220)
    menu.BackgroundColor3 = themes[currentTheme].bg
    menu.BackgroundTransparency = 0.05
    menu.BorderSizePixel = 0
    menu.Visible = false
    menu.Parent = screenGui
    menu.ClipsDescendants = true
    
    local cornerMenu = Instance.new("UICorner")
    cornerMenu.CornerRadius = UDim.new(0, 16)
    cornerMenu.Parent = menu
    
    -- Полоса перетаскивания окна (внизу)
    local dragBar = Instance.new("Frame")
    dragBar.Size = UDim2.new(1, 0, 0, 20)
    dragBar.Position = UDim2.new(0, 0, 1, -20)
    dragBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    dragBar.BackgroundTransparency = 0.2
    dragBar.BorderSizePixel = 0
    dragBar.Parent = menu
    
    local cornerDragBar = Instance.new("UICorner")
    cornerDragBar.CornerRadius = UDim.new(0, 0, 0, 16)
    cornerDragBar.Parent = dragBar
    
    -- Перетаскивание окна
    local menuDragging = false
    local menuDragStart, menuStartPos
    dragBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            menuDragging = true
            menuDragStart = input.Position
            menuStartPos = menu.Position
        end
    end)
    dragBar.InputChanged:Connect(function(input)
        if menuDragging and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - menuDragStart
            menu.Position = UDim2.new(menuStartPos.X.Scale, menuStartPos.X.Offset + delta.X, menuStartPos.Y.Scale, menuStartPos.Y.Offset + delta.Y)
        end
    end)
    dragBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            menuDragging = false
        end
    end)
    
    -- Заголовок
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = themes[currentTheme].frame
    titleBar.BorderSizePixel = 0
    titleBar.Parent = menu
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(0.7, 0, 1, 0)
    titleText.Position = UDim2.new(0.05, 0, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "🔺 Apex Lite 2.0"
    titleText.TextColor3 = themes[currentTheme].text
    titleText.Font = Enum.Font.SourceSansBold
    titleText.TextSize = 18
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(0.93, 0, 0.1, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.TextSize = 16
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    
    local cornerClose = Instance.new("UICorner")
    cornerClose.CornerRadius = UDim.new(0, 6)
    cornerClose.Parent = closeBtn
    
    -- ===== ВКЛАДКИ =====
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(0.25, 0, 1, -35)
    tabFrame.Position = UDim2.new(0, 0, 0, 35)
    tabFrame.BackgroundColor3 = themes[currentTheme].frame
    tabFrame.BorderSizePixel = 0
    tabFrame.Parent = menu
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(0.75, 0, 1, -35)
    contentFrame.Position = UDim2.new(0.25, 0, 0, 35)
    contentFrame.BackgroundColor3 = themes[currentTheme].bg
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = menu
    
    -- Кнопки вкладок
    local commandsTab = Instance.new("TextButton")
    commandsTab.Size = UDim2.new(1, 0, 0, 40)
    commandsTab.Position = UDim2.new(0, 0, 0, 0)
    commandsTab.BackgroundColor3 = themes[currentTheme].btn
    commandsTab.Text = "Команды"
    commandsTab.TextColor3 = themes[currentTheme].text
    commandsTab.Font = Enum.Font.SourceSansBold
    commandsTab.TextSize = 14
    commandsTab.BorderSizePixel = 0
    commandsTab.Parent = tabFrame
    
    local designTab = Instance.new("TextButton")
    designTab.Size = UDim2.new(1, 0, 0, 40)
    designTab.Position = UDim2.new(0, 0, 0, 45)
    designTab.BackgroundColor3 = themes[currentTheme].frame
    designTab.Text = "Дизайн"
    designTab.TextColor3 = themes[currentTheme].text
    designTab.Font = Enum.Font.SourceSansBold
    designTab.TextSize = 14
    designTab.BorderSizePixel = 0
    designTab.Parent = tabFrame
    
    local settingsTab = Instance.new("TextButton")
    settingsTab.Size = UDim2.new(1, 0, 0, 40)
    settingsTab.Position = UDim2.new(0, 0, 0, 90)
    settingsTab.BackgroundColor3 = themes[currentTheme].frame
    settingsTab.Text = "Настройки"
    settingsTab.TextColor3 = themes[currentTheme].text
    settingsTab.Font = Enum.Font.SourceSansBold
    settingsTab.TextSize = 14
    settingsTab.BorderSizePixel = 0
    settingsTab.Parent = tabFrame
    
    -- Контент "Команды"
    local commandsContent = Instance.new("ScrollingFrame")
    commandsContent.Size = UDim2.new(1, 0, 1, 0)
    commandsContent.BackgroundTransparency = 1
    commandsContent.BorderSizePixel = 0
    commandsContent.Parent = contentFrame
    commandsContent.CanvasSize = UDim2.new(0, 0, 0, 650)
    commandsContent.ScrollBarThickness = 4
    
    -- Контент "Дизайн"
    local designContent = Instance.new("ScrollingFrame")
    designContent.Size = UDim2.new(1, 0, 1, 0)
    designContent.BackgroundTransparency = 1
    designContent.BorderSizePixel = 0
    designContent.Visible = false
    designContent.Parent = contentFrame
    designContent.CanvasSize = UDim2.new(0, 0, 0, 500)
    designContent.ScrollBarThickness = 4
    
    -- Контент "Настройки"
    local settingsContent = Instance.new("ScrollingFrame")
    settingsContent.Size = UDim2.new(1, 0, 1, 0)
    settingsContent.BackgroundTransparency = 1
    settingsContent.BorderSizePixel = 0
    settingsContent.Visible = false
    settingsContent.Parent = contentFrame
    settingsContent.CanvasSize = UDim2.new(0, 0, 0, 100)
    settingsContent.ScrollBarThickness = 4
    
    -- ===== ФУНКЦИИ КНОПОК =====
    local function createCommandBtn(text, yPos, callback, color)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 32)
        btn.Position = UDim2.new(0.05, 0, 0, yPos)
        btn.BackgroundColor3 = color or themes[currentTheme].btn
        btn.Text = text
        btn.TextColor3 = themes[currentTheme].text
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 14
        btn.BorderSizePixel = 0
        btn.Parent = commandsContent
        
        local cornerBtn = Instance.new("UICorner")
        cornerBtn.CornerRadius = UDim.new(0, 6)
        cornerBtn.Parent = btn
        
        -- Анимация нажатия
        btn.MouseButton1Down:Connect(function()
            btn.Size = UDim2.new(0.85, 0, 0, 30)
            btn.Position = UDim2.new(0.075, 0, 0, yPos + 1)
        end)
        btn.MouseButton1Up:Connect(function()
            btn.Size = UDim2.new(0.9, 0, 0, 32)
            btn.Position = UDim2.new(0.05, 0, 0, yPos)
        end)
        
        btn.MouseButton1Click:Connect(callback)
        return btn
    end
    
    local function createTextBox(placeholder, yPos, callback)
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0.9, 0, 0, 30)
        box.Position = UDim2.new(0.05, 0, 0, yPos)
        box.BackgroundColor3 = themes[currentTheme].btn
        box.Text = placeholder
        box.TextColor3 = themes[currentTheme].text
        box.Font = Enum.Font.SourceSans
        box.TextSize = 14
        box.BorderSizePixel = 0
        box.Parent = commandsContent
        
        local cornerBox = Instance.new("UICorner")
        cornerBox.CornerRadius = UDim.new(0, 6)
        cornerBox.Parent = box
        
        box.FocusLost:Connect(function()
            callback(box)
        end)
        return box
    end
    
    -- ===== ПЕРЕМЕННЫЕ =====
    local invisibleEnabled = false
    local espEnabled = false
    local espLines = {}
    local murderer = nil
    local aimbotActive = false
    local noclipEnabled = false
    local noclipConnection = nil
    local flyEnabled = false
    local flyBody = nil
    local flyGyro = nil
    local flySpeed = 50
    local infiniteJumpEnabled = false
    local speedGlitchEnabled = false
    local speedGlitchSpeed = 50
    local jumpConnection = nil
    local speedGlitchConnection = nil
    local language = "RUS"
    
    -- ===== ESP =====
    local function clearESP()
        for _, esp in pairs(espLines) do esp:Destroy() end
        espLines = {}
        murderer = nil
    end
    
    local function updateESP()
        clearESP()
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player then
                local plrChar = plr.Character
                local plrBackpack = plr.Backpack
                local color = Color3.fromRGB(0, 255, 0)
                
                local hasKnife = false
                if plrChar then
                    if plrChar:FindFirstChild("Knife") or plrChar:FindFirstChild("Murderer") then
                        hasKnife = true
                    end
                end
                if not hasKnife and plrBackpack then
                    if plrBackpack:FindFirstChild("Knife") or plrBackpack:FindFirstChild("Murderer") then
                        hasKnife = true
                    end
                end
                
                if hasKnife then
                    color = Color3.fromRGB(255, 0, 0)
                    murderer = plr
                end
                
                local hasGun = false
                if plrChar then
                    if plrChar:FindFirstChild("Gun") or plrChar:FindFirstChild("Sheriff") then
                        hasGun = true
                    end
                end
                if not hasGun and plrBackpack then
                    if plrBackpack:FindFirstChild("Gun") or plrBackpack:FindFirstChild("Sheriff") then
                        hasGun = true
                    end
                end
                
                if hasGun then
                    color = Color3.fromRGB(0, 0, 255)
                end
                
                if plrChar then
                    local esp = Instance.new("BoxHandleAdornment")
                    esp.Size = Vector3.new(4, 5, 2)
                    esp.Color3 = color
                    esp.Transparency = 0.3
                    esp.AlwaysOnTop = true
                    esp.ZIndex = 10
                    esp.Adornee = plrChar:FindFirstChild("HumanoidRootPart")
                    esp.Parent = screenGui
                    table.insert(espLines, esp)
                end
            end
        end
    end
    
    -- ===== INVISIBLE =====
    local invisBtn = createCommandBtn("👻 Invisible: OFF", 10, function()
        invisibleEnabled = not invisibleEnabled
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = invisibleEnabled and 1 or 0
            end
        end
        invisBtn.Text = invisibleEnabled and "👻 Invisible: ON" or "👻 Invisible: OFF"
    end)
    
    -- ===== WALKSPEED =====
    local wsBox = createTextBox("WalkSpeed: 16", 50, function(box)
        local speed = tonumber(box.Text)
        if speed and speed > 0 and speed <= 100 then
            hum.WalkSpeed = speed
            box.Text = "WalkSpeed: " .. speed
        else
            box.Text = "WalkSpeed: " .. hum.WalkSpeed
        end
    end)
    
    -- ===== ESP =====
    local espBtn = createCommandBtn("👁️ ESP: OFF", 90, function()
        espEnabled = not espEnabled
        if espEnabled then
            updateESP()
            espBtn.Text = "👁️ ESP: ON"
            game:GetService("RunService").Heartbeat:Connect(function()
                if espEnabled then
                    updateESP()
                end
            end)
        else
            clearESP()
            espBtn.Text = "👁️ ESP: OFF"
        end
    end)
        -- ===== NOCLIP (с подсветкой) =====
    local noclipBtn = createCommandBtn("🚪 Noclip: OFF", 130, function()
        noclipEnabled = not noclipEnabled
        if noclipEnabled then
            noclipConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if noclipEnabled and char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            noclipBtn.Text = "🚪 Noclip: ON"
            noclipBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
            noclipBtn.Text = "🚪 Noclip: OFF"
            noclipBtn.BackgroundColor3 = themes[currentTheme].btn
        end
    end)
    
    -- ===== FLY (ПОЛНОСТЬЮ РАБОТАЕТ) =====
    local flyBtn = createCommandBtn("🕊️ Fly: OFF", 170, function()
        flyEnabled = not flyEnabled
        if flyEnabled then
            -- Тело для полёта
            flyBody = Instance.new("BodyVelocity")
            flyBody.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            flyBody.Velocity = Vector3.new(0, 0, 0)
            flyBody.Parent = rootPart
            
            -- Гироскоп для стабильности
            flyGyro = Instance.new("BodyGyro")
            flyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
            flyGyro.P = 20000
            flyGyro.D = 1000
            flyGyro.CFrame = rootPart.CFrame
            flyGyro.Parent = rootPart
            
            flyBtn.Text = "🕊️ Fly: ON"
        else
            if flyBody then flyBody:Destroy() flyBody = nil end
            if flyGyro then flyGyro:Destroy() flyGyro = nil end
            flyBtn.Text = "🕊️ Fly: OFF"
        end
    end)
    
    local flySpeedBox = createTextBox("FlySpeed: 50", 210, function(box)
        local speed = tonumber(box.Text)
        if speed and speed > 0 then
            flySpeed = speed
            box.Text = "FlySpeed: " .. flySpeed
        else
            box.Text = "FlySpeed: " .. flySpeed
        end
    end)
    
    -- Обновление FLY (управление)
    game:GetService("RunService").Heartbeat:Connect(function()
        if flyEnabled and rootPart and flyBody then
            local moveVector = Vector3.new(0, 0, 0)
            local uis = game:GetService("UserInputService")
            
            -- Вперёд/назад
            if uis:IsKeyDown(Enum.KeyCode.W) then
                moveVector = moveVector + rootPart.CFrame.LookVector
            end
            if uis:IsKeyDown(Enum.KeyCode.S) then
                moveVector = moveVector - rootPart.CFrame.LookVector
            end
            -- Влево/вправо
            if uis:IsKeyDown(Enum.KeyCode.A) then
                moveVector = moveVector - rootPart.CFrame.RightVector
            end
            if uis:IsKeyDown(Enum.KeyCode.D) then
                moveVector = moveVector + rootPart.CFrame.RightVector
            end
            -- Вверх/вниз
            if uis:IsKeyDown(Enum.KeyCode.Space) then
                moveVector = moveVector + Vector3.new(0, 1, 0)
            end
            if uis:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveVector = moveVector - Vector3.new(0, 1, 0)
            end
            
            if moveVector.Magnitude > 0 then
                moveVector = moveVector.Unit * flySpeed
            end
            flyBody.Velocity = moveVector
            
            -- Обновляем гироскоп
            if flyGyro then
                flyGyro.CFrame = rootPart.CFrame
            end
        end
    end)
    
    -- ===== INFINITE JUMP =====
    local jumpBtn = createCommandBtn("🦘 Infinite Jump: OFF", 250, function()
        infiniteJumpEnabled = not infiniteJumpEnabled
        if infiniteJumpEnabled then
            jumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                if infiniteJumpEnabled then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
            jumpBtn.Text = "🦘 Infinite Jump: ON"
        else
            if jumpConnection then jumpConnection:Disconnect() jumpConnection = nil end
            jumpBtn.Text = "🦘 Infinite Jump: OFF"
        end
    end)
    
    -- ===== SPEED GLITCH =====
    local speedGlitchBtn = createCommandBtn("💨 Speed Glitch: OFF", 290, function()
        speedGlitchEnabled = not speedGlitchEnabled
        if speedGlitchEnabled then
            speedGlitchConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if speedGlitchEnabled and hum then
                    if hum:GetState() == Enum.HumanoidStateType.Jumping then
                        hum.WalkSpeed = speedGlitchSpeed
                    elseif hum:GetState() == Enum.HumanoidStateType.Landed or hum:GetState() == Enum.HumanoidStateType.Running then
                        hum.WalkSpeed = 16
                    end
                end
            end)
            speedGlitchBtn.Text = "💨 Speed Glitch: ON"
        else
            if speedGlitchConnection then speedGlitchConnection:Disconnect() speedGlitchConnection = nil end
            hum.WalkSpeed = 16
            speedGlitchBtn.Text = "💨 Speed Glitch: OFF"
        end
    end)
    
    local speedGlitchBox = createTextBox("Speed: 50", 330, function(box)
        local speed = tonumber(box.Text)
        if speed and speed > 0 then
            speedGlitchSpeed = speed
            box.Text = "Speed: " .. speed
        else
            box.Text = "Speed: " .. speedGlitchSpeed
        end
    end)
    
    -- ===== AIMBOT =====
    local aimBtn = createCommandBtn("🎯 Aimbot (наведение): OFF", 370, function()
        if not espEnabled then
            aimBtn.Text = "🎯 Включи ESP!"
            task.wait(1)
            aimBtn.Text = "🎯 Aimbot (наведение): OFF"
            return
        end
        aimbotActive = not aimbotActive
        if aimbotActive then
            aimBtn.Text = "🎯 Aimbot (наведение): ON"
        else
            aimBtn.Text = "🎯 Aimbot (наведение): OFF"
        end
    end)
    
    game:GetService("RunService").Heartbeat:Connect(function()
        if aimbotActive and espEnabled and murderer and murderer.Character then
            local targetRoot = murderer.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local targetPos = targetRoot.Position
                local camera = workspace.CurrentCamera
                camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
            end
        end
    end)
    
    -- ===== НАСТРОЙКИ =====
    local langBtn = createCommandBtn("Язык: RUS 🇷🇺", 10, function()
        if language == "RUS" then
            language = "ENG"
            langBtn.Text = "Язык: ENG 🇬🇧"
        else
            language = "RUS"
            langBtn.Text = "Язык: RUS 🇷🇺"
        end
    end)
    
    -- ===== ДИЗАЙН =====
    local designAccordion = Instance.new("TextButton")
    designAccordion.Size = UDim2.new(0.9, 0, 0, 32)
    designAccordion.Position = UDim2.new(0.05, 0, 0, 10)
    designAccordion.BackgroundColor3 = themes[currentTheme].btn
    designAccordion.Text = "▼ Деловой"
    designAccordion.TextColor3 = themes[currentTheme].text
    designAccordion.Font = Enum.Font.SourceSansBold
    designAccordion.TextSize = 14
    designAccordion.BorderSizePixel = 0
    designAccordion.Parent = designContent
    
    local cornerAccordion = Instance.new("UICorner")
    cornerAccordion.CornerRadius = UDim.new(0, 6)
    cornerAccordion.Parent = designAccordion
    
    local designPanel = Instance.new("Frame")
    designPanel.Size = UDim2.new(0.9, 0, 0, 100)
    designPanel.Position = UDim2.new(0.05, 0, 0, 45)
    designPanel.BackgroundColor3 = themes[currentTheme].bg
    designPanel.BackgroundTransparency = 0.3
    designPanel.BorderSizePixel = 0
    designPanel.Visible = true
    designPanel.Parent = designContent
    
    local cornerPanel = Instance.new("UICorner")
    cornerPanel.CornerRadius = UDim.new(0, 6)
    cornerPanel.Parent = designPanel
    
    local businessThemes = {"Деловой (Чёрный)", "Деловой (Серый)", "Деловой (Синий)", "Деловой (Белый)"}
    for i, themeName in ipairs(businessThemes) do
        local themeBtn = Instance.new("TextButton")
        themeBtn.Size = UDim2.new(0.9, 0, 0, 25)
        themeBtn.Position = UDim2.new(0.05, 0, 0, 5 + (i-1) * 30)
        themeBtn.BackgroundColor3 = themes[themeName].btn
        themeBtn.Text = themeName
        themeBtn.TextColor3 = themes[themeName].text
        themeBtn.Font = Enum.Font.SourceSans
        themeBtn.TextSize = 12
        themeBtn.BorderSizePixel = 0
        themeBtn.Parent = designPanel
        
        local cornerThemeBtn = Instance.new("UICorner")
        cornerThemeBtn.CornerRadius = UDim.new(0, 4)
        cornerThemeBtn.Parent = themeBtn
        
        themeBtn.MouseButton1Click:Connect(function()
            applyTheme(themeName)
            designAccordion.Text = "▼ " .. themeName
        end)
    end
    
    local uniqueAccordion = Instance.new("TextButton")
    uniqueAccordion.Size = UDim2.new(0.9, 0, 0, 32)
    uniqueAccordion.Position = UDim2.new(0.05, 0, 0, 160)
    uniqueAccordion.BackgroundColor3 = themes[currentTheme].btn
    uniqueAccordion.Text = "▼ Уникальный"
    uniqueAccordion.TextColor3 = themes[currentTheme].text
    uniqueAccordion.Font = Enum.Font.SourceSansBold
    uniqueAccordion.TextSize = 14
    uniqueAccordion.BorderSizePixel = 0
    uniqueAccordion.Parent = designContent
    
    local cornerUnique = Instance.new("UICorner")
    cornerUnique.CornerRadius = UDim.new(0, 6)
    cornerUnique.Parent = uniqueAccordion
    
    local uniquePanel = Instance.new("Frame")
    uniquePanel.Size = UDim2.new(0.9, 0, 0, 220)
    uniquePanel.Position = UDim2.new(0.05, 0, 0, 195)
    uniquePanel.BackgroundColor3 = themes[currentTheme].bg
    uniquePanel.BackgroundTransparency = 0.3
    uniquePanel.BorderSizePixel = 0
    uniquePanel.Visible = true
    uniquePanel.Parent = designContent
    
    local cornerUniquePanel = Instance.new("UICorner")
    cornerUniquePanel.CornerRadius = UDim.new(0, 6)
    cornerUniquePanel.Parent = uniquePanel
    
    local uniqueThemes = {"Океан", "Летняя", "Новогодняя", "Конфетная", "Шоколадная", "Золотая"}
    for i, themeName in ipairs(uniqueThemes) do
        local themeBtn = Instance.new("TextButton")
        themeBtn.Size = UDim2.new(0.9, 0, 0, 30)
        themeBtn.Position = UDim2.new(0.05, 0, 0, 5 + (i-1) * 35)
        themeBtn.BackgroundColor3 = themes[themeName].btn
        themeBtn.Text = themeName
        themeBtn.TextColor3 = themes[themeName].text
        themeBtn.Font = Enum.Font.SourceSans
        themeBtn.TextSize = 13
        themeBtn.BorderSizePixel = 0
        themeBtn.Parent = uniquePanel
        
        local cornerThemeBtn = Instance.new("UICorner")
        cornerThemeBtn.CornerRadius = UDim.new(0, 4)
        cornerThemeBtn.Parent = themeBtn
        
        themeBtn.MouseButton1Click:Connect(function()
            applyTheme(themeName)
            uniqueAccordion.Text = "▼ " .. themeName
        end)
    end
    
    local uniqueOpen = true
    uniqueAccordion.MouseButton1Click:Connect(function()
        uniqueOpen = not uniqueOpen
        uniquePanel.Visible = uniqueOpen
        uniqueAccordion.Text = uniqueOpen and "▼ Уникальный" or "▶ Уникальный"
    end)
    
    local businessOpen = true
    designAccordion.MouseButton1Click:Connect(function()
        businessOpen = not businessOpen
        designPanel.Visible = businessOpen
        designAccordion.Text = businessOpen and "▼ Деловой" or "▶ Деловой"
    end)
    
    -- ===== ПРИМЕНЕНИЕ ТЕМЫ =====
    local function applyTheme(themeName)
        currentTheme = themeName
        local theme = themes[themeName]
        menu.BackgroundColor3 = theme.bg
        titleBar.BackgroundColor3 = theme.frame
        titleText.TextColor3 = theme.text
        dragBar.BackgroundColor3 = theme.frame
        tabFrame.BackgroundColor3 = theme.frame
        contentFrame.BackgroundColor3 = theme.bg
        commandsTab.BackgroundColor3 = theme.btn
        designTab.BackgroundColor3 = theme.frame
        settingsTab.BackgroundColor3 = theme.frame
        designAccordion.BackgroundColor3 = theme.btn
        uniqueAccordion.BackgroundColor3 = theme.btn
        
        for _, child in pairs(commandsContent:GetChildren()) do
            if child:IsA("TextButton") and child ~= noclipBtn then
                child.TextColor3 = theme.text
                child.BackgroundColor3 = theme.btn
            elseif child:IsA("TextBox") then
                child.TextColor3 = theme.text
                child.BackgroundColor3 = theme.btn
            end
        end
        if noclipEnabled then
            noclipBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            noclipBtn.BackgroundColor3 = theme.btn
        end
        
        for _, child in pairs(designPanel:GetChildren()) do
            if child:IsA("TextButton") then
                local themeNameForBtn = child.Text
                if themes[themeNameForBtn] then
                    child.BackgroundColor3 = themes[themeNameForBtn].btn
                    child.TextColor3 = themes[themeNameForBtn].text
                end
            end
        end
        for _, child in pairs(uniquePanel:GetChildren()) do
            if child:IsA("TextButton") then
                local themeNameForBtn = child.Text
                if themes[themeNameForBtn] then
                    child.BackgroundColor3 = themes[themeNameForBtn].btn
                    child.TextColor3 = themes[themeNameForBtn].text
                end
            end
        end
        for _, child in pairs(settingsContent:GetChildren()) do
            if child:IsA("TextButton") then
                child.TextColor3 = theme.text
                child.BackgroundColor3 = theme.btn
            elseif child:IsA("TextBox") then
                child.TextColor3 = theme.text
                child.BackgroundColor3 = theme.btn
            end
        end
    end
    
    -- ===== УПРАВЛЕНИЕ ВКЛАДКАМИ =====
    commandsTab.MouseButton1Click:Connect(function()
        commandsContent.Visible = true
        designContent.Visible = false
        settingsContent.Visible = false
        commandsTab.BackgroundColor3 = themes[currentTheme].btn
        designTab.BackgroundColor3 = themes[currentTheme].frame
        settingsTab.BackgroundColor3 = themes[currentTheme].frame
    end)
    
    designTab.MouseButton1Click:Connect(function()
        commandsContent.Visible = false
        designContent.Visible = true
        settingsContent.Visible = false
        commandsTab.BackgroundColor3 = themes[currentTheme].frame
        designTab.BackgroundColor3 = themes[currentTheme].btn
        settingsTab.BackgroundColor3 = themes[currentTheme].frame
    end)
    
    settingsTab.MouseButton1Click:Connect(function()
        commandsContent.Visible = false
        designContent.Visible = false
        settingsContent.Visible = true
        commandsTab.BackgroundColor3 = themes[currentTheme].frame
        designTab.BackgroundColor3 = themes[currentTheme].frame
        settingsTab.BackgroundColor3 = themes[currentTheme].btn
    end)
    
    -- ===== УПРАВЛЕНИЕ ОКНОМ =====
    mainBtn.MouseButton1Click:Connect(function()
        menu.Visible = not menu.Visible
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        menu.Visible = false
    end)
    
    -- Сохранение GUI при смерти
    player.CharacterAdded:Connect(function(newChar)
        char = newChar
        hum = char:WaitForChild("Humanoid")
        rootPart = char:WaitForChild("HumanoidRootPart")
        if flyBody then flyBody.Parent = rootPart end
        if flyGyro then flyGyro.Parent = rootPart end
        
        if screenGui and screenGui.Parent ~= player.PlayerGui then
            screenGui.Parent = player.PlayerGui
        end
    end)
    
    print("🔺 Apex Lite 2.0 загружен")
end)()
