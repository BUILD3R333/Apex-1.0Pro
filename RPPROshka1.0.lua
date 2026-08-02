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
