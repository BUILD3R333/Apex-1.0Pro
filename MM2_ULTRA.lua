--[[ MM2 ULTRA v1.0 ]] return(function()
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    local rootPart = char:WaitForChild("HumanoidRootPart")
    
    -- ===== ТЕМЫ =====
    local themes = {
        ["Gray"] = {bg = Color3.fromRGB(30,30,35), frame = Color3.fromRGB(50,50,55), btn = Color3.fromRGB(70,70,75), text = Color3.fromRGB(220,220,220)},
        ["Black"] = {bg = Color3.fromRGB(10,10,12), frame = Color3.fromRGB(20,20,25), btn = Color3.fromRGB(40,40,45), text = Color3.fromRGB(200,200,200)},
        ["Chocolate"] = {bg = Color3.fromRGB(25,15,10), frame = Color3.fromRGB(45,30,20), btn = Color3.fromRGB(65,45,30), text = Color3.fromRGB(230,210,190)},
        ["Caramel"] = {bg = Color3.fromRGB(45,35,20), frame = Color3.fromRGB(70,55,35), btn = Color3.fromRGB(95,75,50), text = Color3.fromRGB(255,240,210)},
        ["Blue"] = {bg = Color3.fromRGB(8,12,28), frame = Color3.fromRGB(16,24,48), btn = Color3.fromRGB(30,50,100), text = Color3.fromRGB(200,220,255)}
    }
    local currentTheme = "Gray"
    
    -- ===== GUI =====
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = player.PlayerGui
    
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
    
    -- Меню
    local menu = Instance.new("Frame")
    menu.Size = UDim2.new(0, 300, 0, 400)
    menu.Position = UDim2.new(0.5, -150, 0.5, -200)
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
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = themes[currentTheme].frame
    titleBar.BorderSizePixel = 0
    titleBar.Parent = menu
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(0.7, 0, 1, 0)
    titleText.Position = UDim2.new(0.05, 0, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "🔺 MM2 ULTRA"
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
    
    -- Контент "Команды"
    local commandsContent = Instance.new("ScrollingFrame")
    commandsContent.Size = UDim2.new(1, 0, 1, 0)
    commandsContent.BackgroundTransparency = 1
    commandsContent.BorderSizePixel = 0
    commandsContent.Parent = contentFrame
    commandsContent.CanvasSize = UDim2.new(0, 0, 0, 350)
    commandsContent.ScrollBarThickness = 4
    
    -- Контент "Дизайн"
    local designContent = Instance.new("ScrollingFrame")
    designContent.Size = UDim2.new(1, 0, 1, 0)
    designContent.BackgroundTransparency = 1
    designContent.BorderSizePixel = 0
    designContent.Visible = false
    designContent.Parent = contentFrame
    designContent.CanvasSize = UDim2.new(0, 0, 0, 300)
    designContent.ScrollBarThickness = 4
    
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
    local aimbotConnection = nil
    local teleportConnection = nil
    
    -- ===== ФУНКЦИИ ESP =====
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
                if plrChar then
                    local color = Color3.fromRGB(0, 255, 0)
                    if plrChar:FindFirstChild("Knife") or plrChar:FindFirstChild("Murderer") then
                        color = Color3.fromRGB(255, 0, 0)
                        murderer = plr
                    end
                    if plrChar:FindFirstChild("Gun") or plrChar:FindFirstChild("Sheriff") then
                        color = Color3.fromRGB(0, 0, 255)
                    end
                    
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
        else
            clearESP()
            espBtn.Text = "👁️ ESP: OFF"
        end
    end)
    
    -- ===== AIMBOT =====
    local aimBtn = createCommandBtn("🎯 Aimbot: OFF (нужен ESP)", 130, function()
        if not espEnabled then
            aimBtn.Text = "🎯 Сначала включи ESP!"
            task.wait(1)
            aimBtn.Text = "🎯 Aimbot: OFF (нужен ESP)"
            return
        end
        
        if aimbotConnection then
            aimbotConnection:Disconnect()
            aimbotConnection = nil
            aimBtn.Text = "🎯 Aimbot: OFF"
            return
        end
        
        aimBtn.Text = "🎯 Aimbot: ON"
        aimbotConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if espEnabled and murderer and murderer.Character then
                local targetRoot = murderer.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    local direction = (targetRoot.Position - rootPart.Position).Unit
                    local ray = Ray.new(rootPart.Position, direction * 100)
                    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {char})
                    if hit and hit.Parent and hit.Parent:FindFirstChild("Humanoid") then
                        local vim = game:GetService("VirtualInputManager")
                        local screenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(targetRoot.Position)
                        if onScreen then
                            vim:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, true, game, 1)
                            task.wait(0.05)
                            vim:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, false, game, 1)
                        end
                    end
                end
            end
        end)
    end, Color3.fromRGB(200, 100, 0))
    
    -- ===== ТЕЛЕПОРТ К УБИЙЦЕ =====
    local teleportBtn = createCommandBtn("👤 Teleport to Murderer (нужен ESP)", 170, function()
        if not espEnabled or not murderer or not murderer.Character then
            teleportBtn.Text = "👤 Включи ESP!"
            task.wait(1)
            teleportBtn.Text = "👤 Teleport to Murderer (нужен ESP)"
            return
        end
        
        local targetRoot = murderer.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            local distance = 15
            local direction = (targetRoot.Position - rootPart.Position).Unit
            local newPos = targetRoot.Position - direction * distance
            rootPart.CFrame = CFrame.new(newPos)
            teleportBtn.Text = "✅ Телепорт!"
            task.wait(0.5)
            teleportBtn.Text = "👤 Teleport to Murderer (нужен ESP)"
        end
    end, Color3.fromRGB(200, 150, 0))
    
    -- ===== ДИЗАЙН =====
    local function applyTheme(themeName)
        currentTheme = themeName
        local theme = themes[themeName]
        menu.BackgroundColor3 = theme.bg
        titleBar.BackgroundColor3 = theme.frame
        titleText.TextColor3 = theme.text
        tabFrame.BackgroundColor3 = theme.frame
        contentFrame.BackgroundColor3 = theme.bg
        commandsTab.BackgroundColor3 = theme.btn
        designTab.BackgroundColor3 = theme.frame
        
        for _, child in pairs(commandsContent:GetChildren()) do
            if child:IsA("TextButton") then
                child.TextColor3 = theme.text
                child.BackgroundColor3 = theme.btn
            elseif child:IsA("TextBox") then
                child.TextColor3 = theme.text
                child.BackgroundColor3 = theme.btn
            end
        end
        
        for _, child in pairs(designContent:GetChildren()) do
            if child:IsA("TextButton") then
                child.TextColor3 = theme.text
                child.BackgroundColor3 = theme.btn
            end
        end
    end
    
    -- Кнопки тем в "Дизайн"
    local yPos = 10
    for themeName, _ in pairs(themes) do
        local themeBtn = Instance.new("TextButton")
        themeBtn.Size = UDim2.new(0.9, 0, 0, 32)
        themeBtn.Position = UDim2.new(0.05, 0, 0, yPos)
        themeBtn.BackgroundColor3 = themes[themeName].btn
        themeBtn.Text = themeName
        themeBtn.TextColor3 = themes[themeName].text
        themeBtn.Font = Enum.Font.SourceSans
        themeBtn.TextSize = 14
        themeBtn.BorderSizePixel = 0
        themeBtn.Parent = designContent
        
        local cornerTheme = Instance.new("UICorner")
        cornerTheme.CornerRadius = UDim.new(0, 6)
        cornerTheme.Parent = themeBtn
        
        themeBtn.MouseButton1Click:Connect(function()
            applyTheme(themeName)
        end)
        
        yPos = yPos + 40
    end
    
    -- ===== УПРАВЛЕНИЕ ВКЛАДКАМИ =====
    commandsTab.MouseButton1Click:Connect(function()
        commandsContent.Visible = true
        designContent.Visible = false
        commandsTab.BackgroundColor3 = themes[currentTheme].btn
        designTab.BackgroundColor3 = themes[currentTheme].frame
    end)
    
    designTab.MouseButton1Click:Connect(function()
        commandsContent.Visible = false
        designContent.Visible = true
        commandsTab.BackgroundColor3 = themes[currentTheme].frame
        designTab.BackgroundColor3 = themes[currentTheme].btn
    end)
    
    -- ===== УПРАВЛЕНИЕ ОКНОМ =====
    mainBtn.MouseButton1Click:Connect(function()
        menu.Visible = not menu.Visible
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        menu.Visible = false
    end)
    
    player.CharacterAdded:Connect(function(newChar)
        char = newChar
        hum = char:WaitForChild("Humanoid")
        rootPart = char:WaitForChild("HumanoidRootPart")
    end)
    
    print("🔺 MM2 ULTRA v1.0 загружен")
end)()
