--// Auto Skill Upgrade GUI Toggle Script
-- Works with executors like Synapse, Fluxus, etc.

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
	"Reload"
}

--// GUI Setup
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Name = "AutoSkillGUI"
ScreenGui.Parent = game:GetService("CoreGui")

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
                    task.wait(0.25)
                end
                task.wait(1)
            end
        end)
    end
end)
