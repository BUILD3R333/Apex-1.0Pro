--[[ MM2 SCRIPT (MOBILE) v1.1 ]] return(function()
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    local rootPart = char:WaitForChild("HumanoidRootPart")
    
    -- ===== GUI =====
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = player.PlayerGui
    
    -- Кнопка выстрела (появляется когда убийца рядом)
    local shootBtn = Instance.new("TextButton")
    shootBtn.Size = UDim2.new(0, 80, 0, 80)
    shootBtn.Position = UDim2.new(0.5, -40, 0.7, 0)
    shootBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    shootBtn.Text = "🔫"
    shootBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    shootBtn.Font = Enum.Font.SourceSansBold
    shootBtn.TextSize = 30
    shootBtn.BorderSizePixel = 0
    shootBtn.Visible = false
    shootBtn.Parent = screenGui
    
    local cornerShoot = Instance.new("UICorner")
    cornerShoot.CornerRadius = UDim.new(1, 0)
    cornerShoot.Parent = shootBtn
    
    -- Тень для кнопки
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316048950"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.Parent = shootBtn
    
    -- ===== ОСНОВНЫЕ ФУНКЦИИ =====
    
    -- Noclip
    local noclipEnabled = false
    local noclipBtn = Instance.new("TextButton")
    noclipBtn.Size = UDim2.new(0, 50, 0, 50)
    noclipBtn.Position = UDim2.new(0, 10, 0, 10)
    noclipBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    noclipBtn.Text = "🚪"
    noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    noclipBtn.Font = Enum.Font.SourceSansBold
    noclipBtn.TextSize = 20
    noclipBtn.BorderSizePixel = 0
    noclipBtn.Parent = screenGui
    
    local cornerNoclip = Instance.new("UICorner")
    cornerNoclip.CornerRadius = UDim.new(0, 8)
    cornerNoclip.Parent = noclipBtn
    
    noclipBtn.MouseButton1Click:Connect(function()
        noclipEnabled = not noclipEnabled
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not noclipEnabled
            end
        end
        noclipBtn.BackgroundColor3 = noclipEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(50, 50, 50)
    end)
    
    -- Anti-Slip (отключаем скольжение)
    hum.AutoRotate = true
    hum.WalkSpeed = 16
    
    -- Fly (полёт)
    local flyEnabled = false
    local flyBody = nil
    local flyGyro = nil
    local flySpeed = 50
    
    local flyBtn = Instance.new("TextButton")
    flyBtn.Size = UDim2.new(0, 50, 0, 50)
    flyBtn.Position = UDim2.new(0, 70, 0, 10)
    flyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    flyBtn.Text = "🕊️"
    flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyBtn.Font = Enum.Font.SourceSansBold
    flyBtn.TextSize = 20
    flyBtn.BorderSizePixel = 0
    flyBtn.Parent = screenGui
    
    local cornerFly = Instance.new("UICorner")
    cornerFly.CornerRadius = UDim.new(0, 8)
    cornerFly.Parent = flyBtn
    
    flyBtn.MouseButton1Click:Connect(function()
        flyEnabled = not flyEnabled
        if flyEnabled then
            flyBody = Instance.new("BodyVelocity")
            flyBody.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            flyBody.Velocity = Vector3.new(0, 0, 0)
            flyBody.Parent = rootPart
            
            flyGyro = Instance.new("BodyGyro")
            flyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
            flyGyro.CFrame = rootPart.CFrame
            flyGyro.Parent = rootPart
            
            flyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        else
            if flyBody then flyBody:Destroy() flyBody = nil end
            if flyGyro then flyGyro:Destroy() flyGyro = nil end
            flyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
    end)
    
    -- Fly Speed (поле ввода)
    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0, 80, 0, 30)
    speedBox.Position = UDim2.new(0, 130, 0, 15)
    speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    speedBox.Text = "Fly: 50"
    speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedBox.Font = Enum.Font.SourceSans
    speedBox.TextSize = 14
    speedBox.BorderSizePixel = 0
    speedBox.Parent = screenGui
    
    local cornerSpeed = Instance.new("UICorner")
    cornerSpeed.CornerRadius = UDim.new(0, 4)
    cornerSpeed.Parent = speedBox
    
    speedBox.FocusLost:Connect(function()
        local speed = tonumber(speedBox.Text)
        if speed and speed > 0 then
            flySpeed = speed
            speedBox.Text = "Fly: " .. flySpeed
        else
            speedBox.Text = "Fly: " .. flySpeed
        end
    end)
    
    -- WalkSpeed
    local wsBox = Instance.new("TextBox")
    wsBox.Size = UDim2.new(0, 80, 0, 30)
    wsBox.Position = UDim2.new(0, 220, 0, 15)
    wsBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    wsBox.Text = "WS: 16"
    wsBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    wsBox.Font = Enum.Font.SourceSans
    wsBox.TextSize = 14
    wsBox.BorderSizePixel = 0
    wsBox.Parent = screenGui
    
    local cornerWs = Instance.new("UICorner")
    cornerWs.CornerRadius = UDim.new(0, 4)
    cornerWs.Parent = wsBox
    
    wsBox.FocusLost:Connect(function()
        local speed = tonumber(wsBox.Text)
        if speed and speed > 0 and speed <= 100 then
            hum.WalkSpeed = speed
            wsBox.Text = "WS: " .. speed
        else
            wsBox.Text = "WS: " .. hum.WalkSpeed
        end
    end)
    
    -- ===== ESP (X-Ray) =====
    local espEnabled = false
    local espLines = {}
    local murderer = nil
    local sheriff = nil
    
    local espBtn = Instance.new("TextButton")
    espBtn.Size = UDim2.new(0, 50, 0, 50)
    espBtn.Position = UDim2.new(0, 10, 0, 70)
    espBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    espBtn.Text = "👁️"
    espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    espBtn.Font = Enum.Font.SourceSansBold
    espBtn.TextSize = 20
    espBtn.BorderSizePixel = 0
    espBtn.Parent = screenGui
    
    local cornerEsp = Instance.new("UICorner")
    cornerEsp.CornerRadius = UDim.new(0, 8)
    cornerEsp.Parent = espBtn
    
    espBtn.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(50, 50, 50)
        
        if espEnabled then
            -- Очищаем старые ESP
            for _, esp in pairs(espLines) do
                esp:Destroy()
            end
            espLines = {}
            
            -- Определяем роли (упрощённо: убийца — тот, кто держит нож)
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr ~= player then
                    local charPlr = plr.Character
                    if charPlr then
                        local color = Color3.fromRGB(0, 255, 0) -- Мирный
                        
                        -- Проверяем, есть ли у игрока нож (убийца)
                        local knife = charPlr:FindFirstChild("Knife") or charPlr:FindFirstChild("Murderer")
                        if knife then
                            color = Color3.fromRGB(255, 0, 0) -- Красный (убийца)
                            murderer = plr
                        end
                        
                        -- Проверяем, шериф ли это
                        local gun = charPlr:FindFirstChild("Gun") or charPlr:FindFirstChild("Sheriff")
                        if gun then
                            color = Color3.fromRGB(0, 0, 255) -- Синий (шериф)
                            sheriff = plr
                        end
                        
                        -- Создаём ESP
                        local esp = Instance.new("BoxHandleAdornment")
                        esp.Size = Vector3.new(4, 5, 2)
                        esp.Color3 = color
                        esp.Transparency = 0.4
                        esp.AlwaysOnTop = true
                        esp.ZIndex = 10
                        esp.Adornee = charPlr:FindFirstChild("HumanoidRootPart")
                        esp.Parent = screenGui
                        table.insert(espLines, esp)
                    end
                end
            end
        else
            for _, esp in pairs(espLines) do
                esp:Destroy()
            end
            espLines = {}
            murderer = nil
            sheriff = nil
        end
    end)
    
    -- ===== AIMBOT (кнопка-выстрел) =====
    local shootConnection = nil
    
    local function updateAimbot()
        if not espEnabled or not murderer or not murderer.Character then
            shootBtn.Visible = false
            if shootConnection then
                shootConnection:Disconnect()
                shootConnection = nil
            end
            return
        end
        
        local targetRoot = murderer.Character:FindFirstChild("HumanoidRootPart")
        if not targetRoot then
            shootBtn.Visible = false
            if shootConnection then
                shootConnection:Disconnect()
                shootConnection = nil
            end
            return
        end
        
        -- Проверяем, виден ли убийца (не за стеной)
        local ray = Ray.new(rootPart.Position, (targetRoot.Position - rootPart.Position).Unit * 100)
        local hit = workspace:FindPartOnRay(ray, char)
        if hit and hit.Parent and hit.Parent:FindFirstChild("Humanoid") then
            -- Убийца виден, показываем кнопку
            shootBtn.Visible = true
            
            -- Отключаем старый обработчик, чтобы не было дублей
            if shootConnection then
                shootConnection:Disconnect()
                shootConnection = nil
            end
            
            -- Подключаем новый обработчик
            shootConnection = shootBtn.MouseButton1Click:Connect(function()
                -- Симулируем выстрел через клик мышью
                local vim = game:GetService("VirtualInputManager")
                local targetScreenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(targetRoot.Position)
                if onScreen then
                    vim:SendMouseButtonEvent(targetScreenPos.X, targetScreenPos.Y, 0, true, game, 1)
                    task.wait(0.05)
                    vim:SendMouseButtonEvent(targetScreenPos.X, targetScreenPos.Y, 0, false, game, 1)
                end
                shootBtn.Visible = false
            end)
        else
            shootBtn.Visible = false
            if shootConnection then
                shootConnection:Disconnect()
                shootConnection = nil
            end
        end
    end
    
    -- Проверяем каждые 0.3 секунды
    game:GetService("RunService").Heartbeat:Connect(function()
        updateAimbot()
    end)
    
    -- ===== ОБНОВЛЕНИЕ ПЕРСОНАЖА =====
    player.CharacterAdded:Connect(function(newChar)
        char = newChar
        hum = char:WaitForChild("Humanoid")
        rootPart = char:WaitForChild("HumanoidRootPart")
        if flyBody then flyBody.Parent = rootPart end
        if flyGyro then flyGyro.Parent = rootPart end
    end)
    
    print("🔫 MM2 SCRIPT (MOBILE) v1.1 загружен!")
end)()
