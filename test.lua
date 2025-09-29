-- UI + Fire Toggle + Fire Rate for ByteNet Script
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Path
local Remote = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ByteNet"):WaitForChild("system"):WaitForChild("ByteNetReliable")

-- Args
local args = {
    buffer.fromstring("\017\005\000Earth\t\000handLaser\159\224\030C\205\204\005B\187\167\003C\v\000Basic Laser")
}

-- State
local firing = false
local fireRate = 0.5 -- default seconds between fires

-- UI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local RateBox = Instance.new("TextBox")
local UIStroke = Instance.new("UIStroke")

ScreenGui.Parent = game:GetService("CoreGui")

Frame.Size = UDim2.new(0, 200, 0, 120)
Frame.Position = UDim2.new(0.5, -100, 0.5, -60)
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

-- Fire loop
task.spawn(function()
    while true do
        if firing then
            Remote:FireServer(unpack(args))
        end
        task.wait(fireRate)
    end
end)

-- Toggle firing
ToggleButton.MouseButton1Click:Connect(function()
    firing = not firing
    if firing then
        ToggleButton.Text = "Stop Firing"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    else
        ToggleButton.Text = "Start Firing"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end)

-- Change fire rate
RateBox.FocusLost:Connect(function(enterPressed)
    local val = tonumber(RateBox.Text)
    if val and val > 0 then
        fireRate = val
    else
        RateBox.Text = tostring(fireRate)
    end
end)
