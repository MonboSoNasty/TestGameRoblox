--// Advanced Auto Skill Upgrade GUI
-- Each skill has its own toggle + fire count textbox
-- Fires instantly (no delay)
-- By MonboSoNasty + ChatGPT (Draggable + Centered Toggles Fix)

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SkillUpgrade = ReplicatedStorage:WaitForChild("Skills"):WaitForChild("Upgrade")

--// Skills to Upgrade
local skillList = {
	"Bullet Penetration",
	"Bullet Damage",
	"Bullet Speed",
	"Body Damage",
	"Health Regeneration",
	"Max Health",
	"Shield",
	"Reload"
}

--// Counters
local counters, running, fireAmounts = {}, {}, {}
for _, skill in ipairs(skillList) do
	counters[skill] = 0
	running[skill] = false
	fireAmounts[skill] = 1
end

--// GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdvancedSkillGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Background Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, (#skillList * 45) + 50)
MainFrame.Position = UDim2.new(0.5, -170, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- Make draggable
local UIS = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	MainFrame.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- Title bar
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Text = "⚙️ Auto Skill Control"
Title.Parent = MainFrame

-- Skill entries
for i, skill in ipairs(skillList) do
	local yPos = 35 + (i - 1) * 45

	-- Skill Label
	local SkillLabel = Instance.new("TextLabel")
	SkillLabel.Size = UDim2.new(0, 130, 0, 40)
	SkillLabel.Position = UDim2.new(0, 10, 0, yPos)
	SkillLabel.BackgroundTransparency = 1
	SkillLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	SkillLabel.Font = Enum.Font.SourceSansBold
	SkillLabel.TextSize = 16
	SkillLabel.Text = skill
	SkillLabel.TextXAlignment = Enum.TextXAlignment.Left
	SkillLabel.Parent = MainFrame

	-- Fire amount box
	local FireBox = Instance.new("TextBox")
	FireBox.Size = UDim2.new(0, 50, 0, 30)
	FireBox.Position = UDim2.new(0, 150, 0, yPos + 5)
	FireBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	FireBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	FireBox.Font = Enum.Font.Code
	FireBox.TextSize = 16
	FireBox.Text = "1"
	FireBox.Parent = MainFrame

	-- Counter Label
	local CounterLabel = Instance.new("TextLabel")
	CounterLabel.Size = UDim2.new(0, 60, 0, 30)
	CounterLabel.Position = UDim2.new(0, 210, 0, yPos + 5)
	CounterLabel.BackgroundTransparency = 1
	CounterLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
	CounterLabel.Font = Enum.Font.Code
	CounterLabel.TextSize = 14
	CounterLabel.Text = "0"
	CounterLabel.Parent = MainFrame

	-- Toggle Button (fits cleanly inside)
	local Toggle = Instance.new("TextButton")
	Toggle.Size = UDim2.new(0, 60, 0, 30)
	Toggle.Position = UDim2.new(0, 280, 0, yPos + 5)
	Toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
	Toggle.Font = Enum.Font.SourceSansBold
	Toggle.TextSize = 16
	Toggle.Text = "OFF"
	Toggle.Parent = MainFrame

	-- Input behavior
	FireBox.FocusLost:Connect(function()
		local val = tonumber(FireBox.Text)
		if val and val > 0 then
			fireAmounts[skill] = val
		else
			FireBox.Text = tostring(fireAmounts[skill])
		end
	end)

	-- Toggle behavior
	Toggle.MouseButton1Click:Connect(function()
		running[skill] = not running[skill]
		Toggle.Text = running[skill] and "ON" or "OFF"
		Toggle.BackgroundColor3 = running[skill] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(45, 45, 45)

		if running[skill] then
			task.spawn(function()
				for _ = 1, fireAmounts[skill] do
					if not running[skill] then break end
					SkillUpgrade:FireServer(skill)
					counters[skill] += 1
					CounterLabel.Text = tostring(counters[skill])
					task.wait() -- runs instantly but yields for other processes
				end
				running[skill] = false
				Toggle.Text = "OFF"
				Toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			end)
		end
	end)
end
