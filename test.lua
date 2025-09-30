-- Simple UI Auto Fire Click Remote
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClickRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Click")

-- UI Library (basic Instance creation)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 120)
Frame.Position = UDim2.new(0.4, 0, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

local Toggle = Instance.new("TextButton", Frame)
Toggle.Size = UDim2.new(0, 180, 0, 40)
Toggle.Position = UDim2.new(0, 10, 0, 10)
Toggle.Text = "Start Firing"
Toggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
Toggle.TextColor3 = Color3.new(1,1,1)

local SpeedBox = Instance.new("TextBox", Frame)
SpeedBox.Size = UDim2.new(0, 180, 0, 40)
SpeedBox.Position = UDim2.new(0, 10, 0, 60)
SpeedBox.PlaceholderText = "Firespeed (sec)"
SpeedBox.Text = "0.1"
SpeedBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
SpeedBox.TextColor3 = Color3.new(1,1,1)

-- Toggle logic
local firing = false
Toggle.MouseButton1Click:Connect(function()
	firing = not firing
	Toggle.Text = firing and "Stop Firing" or "Start Firing"
	if firing then
		task.spawn(function()
			while firing do
				local delayTime = tonumber(SpeedBox.Text) or 0.1
				ClickRemote:FireServer()
				task.wait(delayTime)
			end
		end)
	end
end)
