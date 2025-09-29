-- UI for ClickEvent + UpgradeEvent spam with true toggles
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Remotes
local ClickRemote = ReplicatedStorage:WaitForChild("ClickEvent")
local UpgradeRemote = ReplicatedStorage:WaitForChild("UpgradeEvent")

-- State
local clickSpamming = false
local upgradeSpamming = false
local fireRate = 0.1 -- default seconds
local lastClick = 0
local lastUpgrade = 0

-- UI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ClickToggle = Instance.new("TextButton")
local UpgradeToggle = Instance.new("TextButton")
local RateBox = Instance.new("TextBox")
local UIStroke = Instance.new("UIStroke")

ScreenGui.Parent = game:GetService("CoreGui")

Frame.Size = UDim2.new(0, 240, 0, 160)
Frame.Position = UDim2.new(0.5, -120, 0.5, -80)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

UIStroke.Parent = Frame
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Color = Color3.fromRGB(0, 255, 100)
UIStroke.Thickness = 2

-- Click toggle
ClickToggle.Size = UDim2.new(1, -20, 0, 40)
ClickToggle.Position = UDim2.new(0, 10, 0, 10)
ClickToggle.Text = "ClickEvent: OFF"
ClickToggle.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
ClickToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ClickToggle.Parent = Frame

-- Upgrade toggle
UpgradeToggle.Size = UDim2.new(1, -20, 0, 40)
UpgradeToggle.Position = UDim2.new(0, 10, 0, 60)
UpgradeToggle.Text = "UpgradeEvent: OFF"
UpgradeToggle.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
UpgradeToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
UpgradeToggle.Parent = Frame

-- Shared box
RateBox.Size = UDim2.new(1, -20, 0, 30)
RateBox.Position = UDim2.new(0, 10, 0, 110)
RateBox.PlaceholderText = "Fire rate / Amount"
RateBox.Text = tostring(fireRate)
RateBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
RateBox.TextColor3 = Color3.fromRGB(255, 255, 255)
RateBox.Parent = Frame

-- Fire logic
RunService.Heartbeat:Connect(function()
    local now = tick()
    local amount = tonumber(RateBox.Text) or 1

    if clickSpamming and (now - lastClick) >= fireRate then
        lastClick = now
        ClickRemote:FireServer()
    end

    if upgradeSpamming and (now - lastUpgrade) >= fireRate then
        lastUpgrade = now
        local args = {
            "AmourPerClick",
            amount,
            1,
            "AmourPerClickUpgrageCount",
            1
        }
        UpgradeRemote:FireServer(unpack(args))
    end
end)

-- Toggle clicking
ClickToggle.MouseButton1Click:Connect(function()
    clickSpamming = not clickSpamming
    if clickSpamming then
        ClickToggle.Text = "ClickEvent: ON"
        ClickToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        lastClick = 0
    else
        ClickToggle.Text = "ClickEvent: OFF"
        ClickToggle.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    end
end)

-- Toggle upgrade
UpgradeToggle.MouseButton1Click:Connect(function()
    upgradeSpamming = not upgradeSpamming
    if upgradeSpamming then
        UpgradeToggle.Text = "UpgradeEvent: ON"
        UpgradeToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        lastUpgrade = 0
    else
        UpgradeToggle.Text = "UpgradeEvent: OFF"
        UpgradeToggle.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    end
end)

-- Change fire rate / amount
RateBox.FocusLost:Connect(function()
    local val = tonumber(RateBox.Text)
    if val and val > 0 then
        fireRate = val -- controls click delay
    else
        RateBox.Text = tostring(fireRate)
    end
end)
