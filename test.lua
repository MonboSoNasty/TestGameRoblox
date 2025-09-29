-- UI + Fire Toggle + Custom Fire Rate + Instant Spam Mode
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Path
local Remote = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ByteNet"):WaitForChild("system"):WaitForChild("ByteNetReliable")

-- Args
local args = {
    buffer.fromstring("\017\005\000Earth\t\000handLaser\159\224\030C\205\204\005B\187\167\003C\v\000Basic Laser")
}

-- State
local firing = false
local instantSpam = false
local fireRate = 0.001 -- default seconds
local lastFire = 0

-- UI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local RateBox = Instance.new("TextBox")
local SpamButton = Instance.new("TextButton")
local UIStroke = Instance.new("UIStroke")

ScreenGui.Parent = game:GetService("CoreGui")

Frame.Size = UDim2.new(0, 240, 0, 180)
Frame.Position = UDim2.new(0.5, -120, 0.5, -90)
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
ToggleButton.Text = "Start Firing"
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

SpamButton.Size = UDim2.new(1, -20, 0, 40)
SpamButton.Position = UDim2.new(0, 10, 0, 100)
SpamButton.Text = "Instant Spam: OFF"
SpamButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
SpamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpamButton.Parent = Frame

-- Fire logic
RunService.Heartbeat:Connect(function()
    if firing then
        if instantSpam then
            Remote:FireServer(unpack(args))
        elseif (tick() - lastFire) >= fireRate then
            lastFire = tick()
            Remote:FireServer(unpack(args))
        end
    end
end)

-- Toggle firing
ToggleButton.MouseButton1Click:Connect(function()
    firing = not firing
    if firing then
        ToggleButton.Text = "Stop Firing"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        lastFire = 0
    else
        ToggleButton.Text = "Start Firing"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end)

-- Toggle instant spam
SpamButton.MouseButton1Click:Connect(function()
    instantSpam = not instantSpam
    if instantSpam then
        SpamButton.Text = "Instant Spam: ON"
        SpamButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    else
        SpamButton.Text = "Instant Spam: OFF"
        SpamButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
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
