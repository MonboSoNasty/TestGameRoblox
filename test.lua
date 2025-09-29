-- Auto-Refreshing Search + Edit Value UI for workspace.Tycoon.Drops
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- UI Elements
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local SearchBox = Instance.new("TextBox")
local Results = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local ValueBox = Instance.new("TextBox")
local ApplyButton = Instance.new("TextButton")

-- Store search query and selected object
local SearchQuery = ""
local SelectedObject = nil

-- UI Setup
ScreenGui.Parent = game:GetService("CoreGui")

Frame.Size = UDim2.new(0, 400, 0, 450)
Frame.Position = UDim2.new(0.5, -200, 0.5, -225)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Parent = ScreenGui

SearchBox.Size = UDim2.new(1, -20, 0, 30)
SearchBox.Position = UDim2.new(0, 10, 0, 10)
SearchBox.PlaceholderText = "Search for instance..."
SearchBox.Text = ""
SearchBox.Parent = Frame

Results.Size = UDim2.new(1, -20, 0, 280)
Results.Position = UDim2.new(0, 10, 0, 50)
Results.CanvasSize = UDim2.new(0, 0, 0, 0)
Results.ScrollBarThickness = 8
Results.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Results.Parent = Frame

UIListLayout.Parent = Results
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

ValueBox.Size = UDim2.new(1, -20, 0, 30)
ValueBox.Position = UDim2.new(0, 10, 0, 350)
ValueBox.PlaceholderText = "Enter new value..."
ValueBox.Text = ""
ValueBox.Parent = Frame

ApplyButton.Size = UDim2.new(1, -20, 0, 30)
ApplyButton.Position = UDim2.new(0, 10, 0, 390)
ApplyButton.Text = "Apply Value"
ApplyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 60)
ApplyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyButton.Parent = Frame

-- Search + Display Function
local function RefreshResults()
    Results:ClearAllChildren()
    UIListLayout.Parent = Results
    SelectedObject = nil

    for _, obj in pairs(workspace.Tycoon.Drops:GetDescendants()) do
        if string.find(string.lower(obj.Name), string.lower(SearchQuery)) then
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, -10, 0, 25)
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.Text = obj:GetFullName()
            button.Parent = Results

            button.MouseButton1Click:Connect(function()
                SelectedObject = obj

                -- Auto-fill current value
                if obj:IsA("ValueBase") then
                    ValueBox.Text = tostring(obj.Value)
                elseif obj:IsA("BasePart") then
                    ValueBox.Text = tostring(obj.Size.X) -- show X size as example
                else
                    ValueBox.Text = ""
                end
            end)
        end
    end
end

-- Apply New Value
ApplyButton.MouseButton1Click:Connect(function()
    if SelectedObject and ValueBox.Text ~= "" then
        local newVal = tonumber(ValueBox.Text)

        if SelectedObject:IsA("ValueBase") then
            -- Supports NumberValue, IntValue, BoolValue, StringValue
            if newVal ~= nil then
                SelectedObject.Value = newVal
            elseif SelectedObject:IsA("BoolValue") then
                SelectedObject.Value = (ValueBox.Text:lower() == "true")
            else
                SelectedObject.Value = ValueBox.Text
            end
        elseif SelectedObject:IsA("BasePart") and newVal ~= nil then
            SelectedObject.Size = Vector3.new(newVal, newVal, newVal)
        end
    end
end)

-- Search Updates
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    SearchQuery = SearchBox.Text
    RefreshResults()
end)

-- Auto-refresh when new stuff spawns or is removed
workspace.Tycoon.Drops.DescendantAdded:Connect(function()
    RefreshResults()
end)
workspace.Tycoon.Drops.DescendantRemoving:Connect(function()
    RefreshResults()
end)

-- Initial Load
RefreshResults()
