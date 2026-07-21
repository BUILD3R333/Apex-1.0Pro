--[[ Apex 1.0 Pro ]] return(function()
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    local rootPart = char:WaitForChild("HumanoidRootPart")
    
    -- ===== ТЕМЫ =====
    local themes = {
        black = {
            bg = Color3.fromRGB(10, 10, 15),
            frame = Color3.fromRGB(20, 20, 30),
            button = Color3.fromRGB(40, 40, 60),
            buttonHover = Color3.fromRGB(70, 70, 100),
            text = Color3.fromRGB(255, 255, 255),
            accent = Color3.fromRGB(0, 200, 255)
        },
        gray = {
            bg = Color3.fromRGB(200, 200, 210),
            frame = Color3.fromRGB(230, 230, 240),
            button = Color3.fromRGB(180, 180, 195),
            buttonHover = Color3.fromRGB(210, 210, 225),
            text = Color3.fromRGB(30, 30, 40),
            accent = Color3.fromRGB(100, 100, 120)
        },
        blue = {
            bg = Color3.fromRGB(5, 10, 30),
            frame = Color3.fromRGB(15, 30, 60),
            button = Color3.fromRGB(30, 60, 120),
            buttonHover = Color3.fromRGB(60, 100, 200),
            text = Color3.fromRGB(200, 230, 255),
            accent = Color3.fromRGB(0, 150, 255)
        }
    }
    local currentTheme = "black"
    
    -- ===== GUI =====
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = player.PlayerGui
    
    -- Кнопка с шестерёнкой
    local toggleBtn = Instance.new("ImageButton")
    toggleBtn.Size = UDim2.new(0, 55, 0, 55)
    toggleBtn.Position = UDim2.new(0, 15, 0, 100)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    toggleBtn.BackgroundTransparency = 0.2
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = screenGui
    toggleBtn.Image = "rbxassetid://6031093079"
    toggleBtn.ImageColor3 = Color3.fromRGB(200, 200, 210)
    toggleBtn.ImageTransparency = 0.1
    
    local cornerBtn = Instance.new("UICorner")
    cornerBtn.CornerRadius = UDim.new(1, 0)
    cornerBtn.Parent = toggleBtn
    
    -- Тень
    local shadowBtn = Instance.new("ImageLabel")
    shadowBtn.Size = UDim2.new(1, 8, 1, 8)
    shadowBtn.Position = UDim2.new(0, -4, 0, -4)
    shadowBtn.BackgroundTransparency = 1
    shadowBtn.Image = "rbxassetid://1316048950"
    shadowBtn.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadowBtn.ImageTransparency = 0.7
    shadowBtn.Parent = toggleBtn
    
    -- Анимация вращения
    local rotation = 0
    local rotating = false
    toggleBtn.MouseEnter:Connect(function()
        rotating = true
        while rotating and toggleBtn.Parent do
            rotation = (rotation + 3) % 360
            toggleBtn.Rotation = rotation
            game:GetService("RunService").Heartbeat:Wait()
        end
    end)
    toggleBtn.MouseLeave:Connect(function()
        rotating = false
        toggleBtn.Rotation = 0
    end)
    
    -- Меню
    local menu = Instance.new("Frame")
    menu.Size = UDim2.new(0, 350, 0, 450)
    menu.Position = UDim2.new(0.5, -175, 0.5, -225)
    menu.BackgroundColor3 = themes[currentTheme].bg
    menu.BackgroundTransparency = 0.05
    menu.BorderSizePixel = 0
    menu.Visible = false
    menu.Parent = screenGui
    menu.ClipsDescendants = true
    
    local cornerMenu = Instance.new("UICorner")
    cornerMenu.CornerRadius = UDim.new(0, 12)
    cornerMenu.Parent = menu
    
    -- Заголовок
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = themes[currentTheme].frame
    titleBar.BackgroundTransparency = 0.3
    titleBar.BorderSizePixel = 0
    titleBar.Parent = menu
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(0.7, 0, 1, 0)
    titleText.Position = UDim2.new(0.05, 0, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "🔺 Apex 1.0 Pro"
    titleText.TextColor3 = themes[currentTheme].text
    titleText.Font = Enum.Font.SourceSansBold
    titleText.TextSize = 18
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- Минус (свернуть)
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 30, 0, 30)
    minBtn.Position = UDim2.new(0.85, 0, 0.125, 0)
    minBtn.BackgroundColor3 = themes[currentTheme].button
    minBtn.Text = "—"
    minBtn.TextColor3 = themes[currentTheme].text
    minBtn.Font = Enum.Font.SourceSansBold
    minBtn.TextSize = 20
    minBtn.BorderSizePixel = 0
    minBtn.Parent = titleBar
    
    local cornerMin = Instance.new("UICorner")
    cornerMin.CornerRadius = UDim.new(0, 6)
    cornerMin.Parent = minBtn
    
    -- Крестик (закрыть)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(0.93, 0, 0.125, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.TextSize = 16
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    
    local cornerClose = Instance.new("UICorner")
    cornerClose.CornerRadius = UDim.new(0, 6)
    cornerClose.Parent = closeBtn
    
    -- Скролл
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 1, -40)
    scrollFrame.Position = UDim2.new(0, 0, 0, 40)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.Parent = menu
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 620)
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = themes[currentTheme].accent
    
    -- Функции создания элементов
    local function createButton(text, yPos, callback, color)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 36)
        btn.Position = UDim2.new(0.05, 0, 0, yPos)
        btn.BackgroundColor3 = color or themes[currentTheme].button
        btn.Text = text
        btn.TextColor3 = themes[currentTheme].text
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 14
        btn.BorderSizePixel = 0
        btn.Parent = scrollFrame
        
        local cornerBtn = Instance.new("UICorner")
        cornerBtn.CornerRadius = UDim.new(0, 8)
        cornerBtn.Parent = btn
        
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = themes[currentTheme].buttonHover
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = color or themes[currentTheme].button
        end)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end
    
    local function createTextBox(placeholder, yPos, callback)
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0.9, 0, 0, 30)
        box.Position = UDim2.new(0.05, 0, 0, yPos)
        box.BackgroundColor3 = themes[currentTheme].button
        box.Text = placeholder
        box.TextColor3 = themes[currentTheme].text
        box.Font = Enum.Font.SourceSans
        box.TextSize = 14
        box.BorderSizePixel = 0
        box.Parent = scrollFrame
        
        local cornerBox = Instance.new("UICorner")
        cornerBox.CornerRadius = UDim.new(0, 6)
        cornerBox.Parent = box
        
        box.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                callback(box)
            end
        end)
        return box
    end
    
    -- Применить тему
    local function applyTheme(themeName)
        currentTheme = themeName
        local theme = themes[themeName]
        menu.BackgroundColor3 = theme.bg
        titleBar.BackgroundColor3 = theme.frame
        titleText.TextColor3 = theme.text
        minBtn.BackgroundColor3 = theme.button
        minBtn.TextColor3 = theme.text
        scrollFrame.ScrollBarImageColor3 = theme.accent
        
        for _, child in pairs(scrollFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child.TextColor3 = theme.text
                child.BackgroundColor3 = theme.button
            elseif child:IsA("TextBox") then
                child.TextColor3 = theme.text
                child.BackgroundColor3 = theme.button
            end
        end
    end
    
    -- ===== ПЕРЕМЕННЫЕ =====
    local flyEnabled = false
    local invisibleEnabled = false
    local noclipEnabled = false
    local infiniteJump = false
    local godMode = false
    local espEnabled = false
    local aimbotEnabled = false
    local antiAFK = false
    local flyingBody = nil
    local flySpeed = 50
    local noclipConnection = nil
    local espLines = {}
    local jumpConnection = nil
    
    -- ===== КНОПКИ МЕНЮ =====
    
    -- Смена темы
    local themeBtn = createButton("🎨 Сменить тему", 580, function()
        local themesList = {"black", "gray", "blue"}
        local currentIndex = table.find(themesList, currentTheme)
        local nextIndex = currentIndex % #themesList + 1
        applyTheme(themesList[nextIndex])
    end, Color3.fromRGB(150, 50, 200))
    
    -- Fly
    local flyBtn = createButton("🕊️ Fly: OFF", 10, function()
        flyEnabled = not flyEnabled
        if flyEnabled then
            flyingBody = Instance.new("BodyVelocity")
            flyingBody.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            flyingBody.Velocity = Vector3.new(0, 0, 0)
            flyingBody.Parent = rootPart
            flyBtn.Text = "🕊️ Fly: ON"
        else
            if flyingBody then flyingBody:Destroy() flyingBody = nil end
            flyBtn.Text = "🕊️ Fly: OFF"
        end
    end, Color3.fromRGB(0, 150, 255))
    
    -- FlySpeed
    local flySpeedBox = createTextBox("FlySpeed: 50", 50, function(box)
        local speed = tonumber(box.Text)
        if speed and speed > 0 then
            flySpeed = speed
            box.Text = "FlySpeed: " .. flySpeed
        else
            box.Text = "FlySpeed: " .. flySpeed
        end
    end)
    
    -- Invisible
    local invisBtn = createButton("👻 Invisible: OFF", 90, function()
        invisibleEnabled = not invisibleEnabled
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = invisibleEnabled and 1 or 0
            end
        end
        invisBtn.Text = invisibleEnabled and "👻 Invisible: ON" or "👻 Invisible: OFF"
    end, Color3.fromRGB(200, 0, 200))
    
    -- Noclip
    local noclipBtn = createButton("🚪 Noclip: OFF", 130, function()
        noclipEnabled = not noclipEnabled
        if noclipEnabled then
            noclipConnection = game:GetService("RunService").Stepped:Connect(function()
                if noclipEnabled and rootPart then
                    rootPart.CanCollide = false
                end
            end)
        else
            if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
            if rootPart then rootPart.CanCollide = true end
        end
        noclipBtn.Text = noclipEnabled and "🚪 Noclip: ON" or "🚪 Noclip: OFF"
    end, Color3.fromRGB(0, 200, 100))
    
    -- WalkSpeed
    local speedBox = createTextBox("WalkSpeed: 16", 170, function(box)
        local newSpeed = tonumber(box.Text)
        if newSpeed and newSpeed > 0 then
            hum.WalkSpeed = math.min(newSpeed, 500)
            box.Text = "WalkSpeed: " .. hum.WalkSpeed
        else
            box.Text = "WalkSpeed: " .. hum.WalkSpeed
        end
    end)
    
    -- Infinite Jump
    local jumpBtn = createButton("🦘 Infinite Jump: OFF", 210, function()
        infiniteJump = not infiniteJump
        jumpBtn.Text = infiniteJump and "🦘 Infinite Jump: ON" or "🦘 Infinite Jump: OFF"
        if infiniteJump then
            if not jumpConnection then
                jumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                    if infiniteJump then
                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            end
        else
            if jumpConnection then
                jumpConnection:Disconnect()
                jumpConnection = nil
            end
        end
    end, Color3.fromRGB(255, 200, 0))
    
    -- Teleport
    local teleportBtn = createButton("📍 Teleport (вперёд)", 250, function()
        local forward = rootPart.CFrame.LookVector * 50
        rootPart.CFrame = rootPart.CFrame + forward
    end, Color3.fromRGB(0, 200, 200))
    
    -- Anti-AFK
    local afkBtn = createButton("💤 Anti-AFK: OFF", 290, function()
        antiAFK = not antiAFK
        afkBtn.Text = antiAFK and "💤 Anti-AFK: ON" or "💤 Anti-AFK: OFF"
        if antiAFK then
            game:GetService("Players").LocalPlayer.Idled:Connect(function()
                game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                wait(1)
                game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        end
    end, Color3.fromRGB(255, 150, 0))
    
    -- God Mode
    local godBtn = createButton("🛡️ God Mode: OFF", 330, function()
        godMode = not godMode
        godBtn.Text = godMode and "🛡️ God Mode: ON" or "🛡️ God Mode: OFF"
        if godMode then
            char:BreakJoints()
            wait(0.1)
            char = player.Character or player.CharacterAdded:Wait()
            hum = char:WaitForChild("Humanoid")
            rootPart = char:WaitForChild("HumanoidRootPart")
            hum.MaxHealth = math.huge
            hum.Health = math.huge
        else
            hum.MaxHealth = 100
            hum.Health = 100
        end
    end, Color3.fromRGB(255, 50, 50))
    
    -- ESP
    local espBtn = createButton("👁️ ESP: OFF", 370, function()
        espEnabled = not espEnabled
        espBtn.Text = espEnabled and "👁️ ESP: ON" or "👁️ ESP: OFF"
        if espEnabled then
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr ~= player then
                    local esp = Instance.new("BoxHandleAdornment")
                    esp.Size = Vector3.new(4, 5, 2)
                    esp.Color3 = Color3.fromRGB(0, 255, 0)
                    esp.Transparency = 0.5
                    esp.AlwaysOnTop = true
                    esp.ZIndex = 10
                    esp.Adornee = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    esp.Parent = screenGui
                    table.insert(espLines, esp)
                end
            end
        else
            for _, esp in pairs(espLines) do
                esp:Destroy()
            end
            espLines = {}
        end
    end, Color3.fromRGB(0, 255, 100))
    
    -- Aimbot
    local aimBtn = createButton("🎯 Aimbot: OFF", 410, function()
        aimbotEnabled = not aimbotEnabled
        aimBtn.Text = aimbotEnabled and "🎯 Aimbot: ON" or "🎯 Aimbot: OFF"
    end, Color3.fromRGB(255, 100, 0))
    
    -- ===== УПРАВЛЕНИЕ ОКНОМ =====
    minBtn.MouseButton1Click:Connect(function()
        menu.Visible = false
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        menu.Visible = false
        screenGui:Destroy()
        print("Apex 1.0 Pro закрыт")
    end)
    
    toggleBtn.MouseButton1Click:Connect(function()
        menu.Visible = not menu.Visible
    end)
    
    -- Обновление при смене персонажа
    player.CharacterAdded:Connect(function(newChar)
        char = newChar
        hum = char:WaitForChild("Humanoid")
        rootPart = char:WaitForChild("HumanoidRootPart")
        if flyingBody then flyingBody.Parent = rootPart end
    end)
    
    print("🔺 Apex 1.0 Pro загружен")
end)()
