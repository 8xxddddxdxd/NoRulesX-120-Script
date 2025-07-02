local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- حذف الواجهة لو كانت موجودة
if CoreGui:FindFirstChild("NoRulesX_GUI") then
    CoreGui.NoRulesX_GUI:Destroy()
end

local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "NoRulesX_GUI"
screenGui.ResetOnSpawn = false

-- الإطار الرئيسي
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 400, 0, 320)
mainFrame.Position = UDim2.new(0.5, 0, 0.15, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 40)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Active = true

-- تحريك الواجهة (دراغ)
local dragging = false
local dragInput, mousePos, framePos

local function update(input)
    local delta = input.Position - mousePos
    local newX = math.clamp(framePos.X.Offset + delta.X, 0, workspace.CurrentCamera.ViewportSize.X - mainFrame.AbsoluteSize.X)
    local newY = math.clamp(framePos.Y.Offset + delta.Y, 0, workspace.CurrentCamera.ViewportSize.Y - mainFrame.AbsoluteSize.Y)
    mainFrame.Position = UDim2.new(framePos.X.Scale, newX, framePos.Y.Scale, newY)
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- زر النجمة الزرقاء (مستقل فوق)
local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0.5, -25, 0, 20)
toggleButton.AnchorPoint = Vector2.new(0.5, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
toggleButton.Text = "★"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextScaled = true
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.BorderSizePixel = 0
toggleButton.AutoButtonColor = true
toggleButton.ZIndex = 1000

local guiVisible = false

local function fadeIn()
    mainFrame.Visible = true
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 400, 0, 320)}):Play()
end

local function fadeOut()
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1})
    tween:Play()
    tween.Completed:Connect(function()
        mainFrame.Visible = false
        followButton.Visible = false
        devFrame.Visible = false
    end)
end

toggleButton.MouseButton1Click:Connect(function()
    if guiVisible then
        guiVisible = false
        fadeOut()
    else
        guiVisible = true
        fadeIn()
        followButton.Visible = true
    end
end)

-- مربع النص للبحث
local searchBox = Instance.new("TextBox", mainFrame)
searchBox.Size = UDim2.new(0, 360, 0, 40)
searchBox.Position = UDim2.new(0, 20, 0, 20)
searchBox.PlaceholderText = "Search scripts..."
searchBox.ClearTextOnFocus = false
searchBox.TextColor3 = Color3.new(1,1,1)
searchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
searchBox.BorderSizePixel = 0
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 20

-- عرض نتائج البحث (كمجموعة أزرار)
local resultsFrame = Instance.new("Frame", mainFrame)
resultsFrame.Size = UDim2.new(0, 360, 0, 180)
resultsFrame.Position = UDim2.new(0, 20, 0, 70)
resultsFrame.BackgroundTransparency = 1
resultsFrame.ClipsDescendants = true

-- السكربتات اللي نعرضها كمقترحات بحث
local scriptsList = {
    {
        name = "SlapTower4 Teleport",
        url = "https://raw.githubusercontent.com/8xxddddxdxd/Slap-Tower-4-Teleport-By-Team-EVIL/main/SlapTower4_Teleport.lua"
    },
    {
        name = "Team EVIL Speed GUI",
        url = "https://raw.githubusercontent.com/8xxddddxdxd/Team-Evil-Speed-Gui/refs/heads/main/TeamEVIL_SpeedGUI.lua"
    }
}

local function clearResults()
    for _, child in pairs(resultsFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

local function updateResults(query)
    clearResults()
    if query == "" then return end
    local y = 0
    local loweredQuery = query:lower()
    local found = false
    for _, scriptInfo in pairs(scriptsList) do
        if scriptInfo.name:lower():find(loweredQuery) then
            found = true
            local btn = Instance.new("TextButton", resultsFrame)
            btn.Size = UDim2.new(1, 0, 0, 40)
            btn.Position = UDim2.new(0, 0, 0, y)
            btn.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
            btn.Text = scriptInfo.name
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 18
            btn.TextColor3 = Color3.new(1,1,1)
            btn.BorderSizePixel = 0
            btn.AutoButtonColor = true

            btn.MouseButton1Click:Connect(function()
                loadstring(game:HttpGet(scriptInfo.url))()
            end)

            y = y + 45
        end
    end
    if not found then
        local lbl = Instance.new("TextLabel", resultsFrame)
        lbl.Size = UDim2.new(1, 0, 0, 40)
        lbl.Position = UDim2.new(0, 0, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
        lbl.Text = "No scripts found."
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 18
        lbl.TextXAlignment = Enum.TextXAlignment.Left
    end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    updateResults(searchBox.Text)
end)

-- قائمة المطورين داخل mainFrame يمينها
local devFrame = Instance.new("Frame", mainFrame)
devFrame.Size = UDim2.new(0, 150, 0, 200)
devFrame.Position = UDim2.new(1, -155, 0, 70)
devFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
devFrame.BackgroundTransparency = 0.1
devFrame.BorderSizePixel = 0
devFrame.Visible = false

local title = Instance.new("TextLabel", devFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Hack Developers"
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.fromRGB(0, 162, 255)
title.TextStrokeTransparency = 0.7

local devs = {
    {role = "Owner", name = "Evil", size = 26},
    {role = "FE Bypasser", name = "bakalon", size = 18},
    {role = "Scripter", name = "Omarion", size = 18},
    {role = "Scripter", name = "Gray Ahmed", size = 18},
}

local yPos = 40
for _, dev in pairs(devs) do
    local label = Instance.new("TextLabel", devFrame)
    label.Size = UDim2.new(1, -20, 0, 30)
    label.Position = UDim2.new(0, 10, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = dev.role .. ": " .. dev.name
    label.Font = Enum.Font.Gotham
    label.TextSize = dev.size
    label.TextColor3 = Color3.new(1,1,1)
    label.TextStrokeTransparency = 0.8
    label.TextXAlignment = Enum.TextXAlignment.Left
    yPos = yPos + 35
end

-- زر عرض/إخفاء قائمة المطورين
local devsButton = Instance.new("TextButton", mainFrame)
devsButton.Size = UDim2.new(0, 90, 0, 40)
devsButton.Position = UDim2.new(0, 280, 0, 260)
devsButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
devsButton.Text = "Developers"
devsButton.Font = Enum.Font.GothamBold
devsButton.TextSize = 18
devsButton.TextColor3 = Color3.new(1,1,1)
devsButton.BorderSizePixel = 0

devsButton.MouseButton1Click:Connect(function()
    devFrame.Visible = not devFrame.Visible
end)

-- ===========================
-- سكربت المتابعة FollowGui
-- ===========================

local followGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
followGui.Name = "FollowGui"
followGui.ResetOnSpawn = false

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 60, 0, 60)
button.Position = UDim2.new(1, -70, 0, 10)
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.TextColor3 = Color3.new(1, 1, 1)
button.Text = "تشغيل"
button.Font = Enum.Font.GothamBold
button.TextScaled = true
button.Name = "FollowButton"
button.Parent = followGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = button

local following = false
local isPlayerMoving = false
local pressedKeys = {}

UIS.InputBegan:Connect(function(input, gpe)
	if not gpe and input.UserInputType == Enum.UserInputType.Keyboard then
		pressedKeys[input.KeyCode] = true
		isPlayerMoving = true
	end
end)

UIS.InputEnded:Connect(function(input, gpe)
	if not gpe and input.UserInputType == Enum.UserInputType.Keyboard then
		pressedKeys[input.KeyCode] = nil
		if next(pressedKeys) == nil then
			isPlayerMoving = false
		end
	end
end)

local function getNearestPlayer()
	local closest, shortest = nil, math.huge
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local myChar = player.Character
			if myChar and myChar:FindFirstChild("HumanoidRootPart") then
				local dist = (myChar.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
				if dist < shortest then
					shortest = dist
					closest = p
				end
			end
		end
	end
	return closest
end

local followConnection
local function followNearest()
	local char = player.Character or player.CharacterAdded:Wait()
	local humanoid = char:WaitForChild("Humanoid")
	local hrp = char:WaitForChild("HumanoidRootPart")

	followConnection = RunService.Heartbeat:Connect(function()
		if not following then return end
		if isPlayerMoving then return end

		local target = getNearestPlayer()
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			local destination = target.Character.HumanoidRootPart.Position
			humanoid:MoveTo(destination)
		end
	end)
end

button.MouseButton1Click:Connect(function()
	following = not following
	button.Text = following and "إيقاف" or "تشغيل"
	if following then
		if not followConnection then
			followNearest()
		end
	else
		if followConnection then
			followConnection:Disconnect()
			followConnection = nil
		end
	end
end)
