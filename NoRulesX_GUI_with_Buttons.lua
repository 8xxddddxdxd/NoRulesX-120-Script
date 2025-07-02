local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

if CoreGui:FindFirstChild("NoRulesX_GUI") then
    CoreGui.NoRulesX_GUI:Destroy()
end

local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "NoRulesX_GUI"
screenGui.ResetOnSpawn = false

-- الإطار الرئيسي
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 400, 0, 320)  -- زدت الارتفاع عشان تستوعب الأزرار الجديدة
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
    end)
end

toggleButton.MouseButton1Click:Connect(function()
    if guiVisible then
        guiVisible = false
        fadeOut()
        devFrame.Visible = false  -- اخفاء واجهة المطورين مع الواجهة الرئيسية
    else
        guiVisible = true
        fadeIn()
    end
end)

-- مربع النص للبحث
local searchBox = Instance.new("TextBox", mainFrame)
searchBox.Size = UDim2.new(0, 250, 0, 40)
searchBox.Position = UDim2.new(0, 20, 0, 20)
searchBox.PlaceholderText = "Search scripts..."
searchBox.ClearTextOnFocus = false
searchBox.TextColor3 = Color3.new(1,1,1)
searchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
searchBox.BorderSizePixel = 0
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 20

-- زر Search
local searchButton = Instance.new("TextButton", mainFrame)
searchButton.Size = UDim2.new(0, 90, 0, 40)
searchButton.Position = UDim2.new(0, 280, 0, 20)
searchButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
searchButton.Text = "Search"
searchButton.Font = Enum.Font.GothamBold
searchButton.TextSize = 20
searchButton.TextColor3 = Color3.new(1,1,1)
searchButton.BorderSizePixel = 0

-- زر تشغيل سكربت Slap Tower 4 Teleport
local slapTowerButton = Instance.new("TextButton", mainFrame)
slapTowerButton.Size = UDim2.new(0, 180, 0, 40)
slapTowerButton.Position = UDim2.new(0, 20, 0, 70)
slapTowerButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
slapTowerButton.Text = "SlapTower4 Teleport"
slapTowerButton.Font = Enum.Font.GothamBold
slapTowerButton.TextSize = 18
slapTowerButton.TextColor3 = Color3.new(1,1,1)
slapTowerButton.BorderSizePixel = 0

-- زر تشغيل سكربت Team EVIL Speed GUI
local teamEvilButton = Instance.new("TextButton", mainFrame)
teamEvilButton.Size = UDim2.new(0, 180, 0, 40)
teamEvilButton.Position = UDim2.new(0, 210, 0, 70)
teamEvilButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
teamEvilButton.Text = "Team EVIL Speed GUI"
teamEvilButton.Font = Enum.Font.GothamBold
teamEvilButton.TextSize = 18
teamEvilButton.TextColor3 = Color3.new(1,1,1)
teamEvilButton.BorderSizePixel = 0

-- عرض نتائج البحث
local resultsLabel = Instance.new("TextLabel", mainFrame)
resultsLabel.Size = UDim2.new(0, 360, 0, 140)
resultsLabel.Position = UDim2.new(0, 20, 0, 120)
resultsLabel.BackgroundTransparency = 1
resultsLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
resultsLabel.TextWrapped = true
resultsLabel.Text = "No scripts available."
resultsLabel.Font = Enum.Font.Gotham
resultsLabel.TextSize = 18
resultsLabel.TextXAlignment = Enum.TextXAlignment.Left

-- قائمة المطورين داخل mainFrame يمينها
local devFrame = Instance.new("Frame", mainFrame)
devFrame.Size = UDim2.new(0, 150, 0, 200)
devFrame.Position = UDim2.new(1, -155, 0, 120)
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
devsButton.Position = UDim2.new(0, 280, 0, 120)
devsButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
devsButton.Text = "Developers"
devsButton.Font = Enum.Font.GothamBold
devsButton.TextSize = 18
devsButton.TextColor3 = Color3.new(1,1,1)
devsButton.BorderSizePixel = 0

devsButton.MouseButton1Click:Connect(function()
    devFrame.Visible = not devFrame.Visible
end)

-- وظيفة البحث (فارغة حالياً)
searchButton.MouseButton1Click:Connect(function()
    local query = searchBox.Text:lower()
    if query == "" then
        resultsLabel.Text = "Please enter a search term."
        return
    end
    resultsLabel.Text = "Searching for: " .. query .. "\nNo scripts found."
end)

-- تشغيل سكربت Slap Tower 4 Teleport
slapTowerButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/8xxddddxdxd/Slap-Tower-4-Teleport-By-Team-EVIL/main/SlapTower4_Teleport.lua"))()
end)

-- تشغيل سكربت Team EVIL Speed GUI
teamEvilButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/8xxddddxdxd/Team-Evil-Speed-Gui/refs/heads/main/TeamEVIL_SpeedGUI.lua"))()
end)
