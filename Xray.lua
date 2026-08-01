local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local folder = Instance.new("Folder", CoreGui)
folder.Name = "XRay_Belly"

local function addHighlight(player)
    if player == LocalPlayer then return end
    
    local function onChar(char)
        local torso = char:WaitForChild("Torso", 5) or char:WaitForChild("UpperTorso", 5)
        if not torso then return end
        
        local highlight = Instance.new("Highlight", folder)
        highlight.Name = player.Name
        highlight.Adornee = torso
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = Color3.fromRGB(0, 255, 0)
        highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
        highlight.FillTransparency = 0.7
        highlight.OutlineTransparency = 0.5
        
        player.CharacterRemoving:Connect(function()
            highlight:Destroy()
        end)
    end
    
    if player.Character then
        onChar(player.Character)
    end
    player.CharacterAdded:Connect(onChar)
end

for _, p in pairs(Players:GetPlayers()) do
    addHighlight(p)
end
Players.PlayerAdded:Connect(addHighlight)
