--// Auto Skill Upgrade GUI Toggle Script with Counters + Fire Speed Control
-- Works with executors like Synapse, Fluxus, etc.
-- Updated by MonboSoNasty + ChatGPT

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SkillUpgrade = ReplicatedStorage:WaitForChild("Skills"):WaitForChild("Upgrade")

--// Skills to Upgrade
local skillList = {
    "Bullet Penetration",
    "Bullet Damage",
    "Bullet Speed",
    "Body Damage",
    "Health Regen",
    "Max Health",
    "Shield",
    "Reload"
}

--// Counter Table (Persistent)
local counters = {}
for _, skill in ipairs(skillList) do
    counters[skill] = counters[skill] or 0
end

--// Default Fire Speed
local fireSpeed = 0

--// GUI Setup
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local CounterLabel = Instance.new("TextLabel")
local SpeedBox = Instance.new("TextBox")
local SpeedLabel = Instance.new("TextLabel")

ScreenGui.Name = "AutoSkillGUI"
ScreenGui.Parent = game:GetService("CoreGui")

-- Toggle button
ToggleButton.Size = UDim2.new(0, 160, 0, 50)
ToggleButton.Position = UDim2.new(0.5, -80, 0.9, -25)
ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 18
ToggleButton.Text = "Auto Skill: OFF"
ToggleButton.Parent = ScreenGui
ToggleButton.Active = true
ToggleButton.Draggable = true

-- Counter label
CounterLabel.Size = UDim2.new(0, 220, 0, 200)
CounterLabel.Position = UDim2.new(0.5, -110, 0.9, -260)
CounterLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
CounterLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
CounterLabel.Font = Enum.Font.Code
CounterLabel.TextSize = 16
CounterLabel.Text = "Counters:\n"
CounterLabel.TextYAlignment = Enum.TextYAlignment.Top
CounterLabel.Parent = ScreenGui

-- Fire speed label
SpeedLabel.Size = UDim2.new(0, 200, 0, 25)
SpeedLabel.Position = UDim2.new(0.5, -100, 0.9, -65)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
SpeedLabel.Font = Enum.Font.SourceSansBold
SpeedLabel.TextSize = 16
SpeedLabel.Text = "Fire Speed (sec):"
SpeedLabel.Parent = ScreenGui

-- Fire speed box
SpeedBox.Size = UDim2.new(0, 80, 0, 25)
SpeedBox.Position = UDim2.new(0.5, 30, 0.9, -65)
SpeedBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.Font = Enum.Font.Code
SpeedBox.TextSize = 16
SpeedBox.Text = tostring(fireSpeed)
SpeedBox.Parent = ScreenGui

--// Update counter display
local function updateCounterLabel()
    local text = "Counters:\n"
    for _, skill in ipairs(skillList) do
        text = text .. skill .. ": " .. tostring(counters[skill]) .. "\n"
    end
    CounterLabel.Text = text
end
updateCounterLabel()

--// Logic
local autoUpgrade = false

-- Update fire speed when text changes
SpeedBox.FocusLost:Connect(function(enterPressed)
    local newSpeed = tonumber(SpeedBox.Text)
    if newSpeed and newSpeed >= 0 then
        fireSpeed = newSpeed
        SpeedBox.Text = tostring(fireSpeed)
    else
        SpeedBox.Text = tostring(fireSpeed)
    end
end)

-- Toggle button click
ToggleButton.MouseButton1Click:Connect(function()
    autoUpgrade = not autoUpgrade
    ToggleButton.Text = autoUpgrade and "Auto Skill: ON" or "Auto Skill: OFF"
    ToggleButton.BackgroundColor3 = autoUpgrade and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(45, 45, 45)

    if autoUpgrade then
        task.spawn(function()
            while autoUpgrade do
                for _, skillName in ipairs(skillList) do
                    if not autoUpgrade then break end
                    SkillUpgrade:FireServer(skillName)
                    counters[skillName] += 1
                    updateCounterLabel()
                    task.wait(fireSpeed)
                end
                task.wait(1)
            end
        end)
    end
end)
