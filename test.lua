--// Auto Skill Upgrade GUI Toggle Script with Counters
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

--// GUI Setup
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local CounterLabel = Instance.new("TextLabel")

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
CounterLabel.Size = UDim2.new(0, 200, 0, 180)
CounterLabel.Position = UDim2.new(0.5, -100, 0.9, -220)
CounterLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
CounterLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
CounterLabel.Font = Enum.Font.Code
CounterLabel.TextSize = 16
CounterLabel.Text = "Counters:\n"
CounterLabel.TextYAlignment = Enum.TextYAlignment.Top
CounterLabel.Parent = ScreenGui

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

ToggleButton.MouseButton1Click:Connect(function()
    autoUpgrade = not autoUpgrade
    ToggleButton.Text = autoUpgrade and "Auto Skill: ON" or "Auto Skill: OFF"
    ToggleButton.BackgroundColor3 = autoUpgrade and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(45, 45, 45)

    if autoUpgrade then
        task.spawn(function()
            while autoUpgrade do
                for _, skillName in ipairs(skillList) do
                    SkillUpgrade:FireServer(skillName)
                    counters[skillName] += 1
                    updateCounterLabel()
                    task.wait(0.25)
                end
                task.wait(1)
            end
        end)
    end
end)
