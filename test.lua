-- UI + ClickEvent Spam
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Remote = ReplicatedStorage:WaitForChild("ClickEvent")

-- State
local spamming = false
local fireRate = 0.1 -- default seconds
local lastFire = 0

-- UI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local RateBox = Instance.new("TextBox")
local UIStroke = Instance.new("UIStroke")

ScreenGui.Parent = game:GetService("CoreGui")

Frame.Size = UDim2.new(0, 220, 0, 120)
Frame.Position = UDim2.new(0.5, -110, 0.5, -60)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

UIStroke.Parent = Frame
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Color = Color3.fromRGB(0, 255, 100)
UIStroke.Thickness = 2

ToggleButton.Size = UDim2.new(1, -20, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.Text = "Start Clicking"
ToggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Parent = Frame

RateBox.Size = UDim2.new(1, -20, 0, 30)
RateBox.Position = UDim2.new(0, 10, 0, 60)
RateBox.PlaceholderText = "Fire rate (seconds)"
RateBox.Text = tostring(fireRate)
RateBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
RateBox.TextColor3 = Color3.fromRGB(255, 255, 255)
RateBox.Parent = Frame

-- Fire logic
RunService.Heartbeat:Connect(function()
    if spamming and (tick() - lastFire) >= fireRate then
        lastFire = tick()
        Remote:FireServer()
    end
end)

-- Toggle clicking
ToggleButton.MouseButton1Click:Connect(function()
    spamming = not spamming
    if spamming then
        ToggleButton.Text = "Stop Clicking"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        lastFire = 0
    else
        ToggleButton.Text = "Start Clicking"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end)

-- Change fire rate
RateBox.FocusLost:Connect(function()
    local val = tonumber(RateBox.Text)
    if val and val > 0 then
        fireRate = val
    else
        RateBox.Text = tostring(fireRate)
    end
end)
