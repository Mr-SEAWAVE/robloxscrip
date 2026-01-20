-- ROBLOX HACK SCRIPT - Ultimate Character Control
-- Đặt trong LocalScript (StarterPlayerScripts)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Biến toàn cục
local hackEnabled = true
local originalWalkSpeed = humanoid.WalkSpeed
local originalJumpPower = humanoid.JumpPower
local originalGravity = workspace.Gravity
local godMode = false
local speedHack = false
local flyEnabled = false
local noclipEnabled = false
local infiniteJump = false
local espEnabled = false
local xrayEnabled = false

-- Tạo GUI hiện đại
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateHackUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.02, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

-- Hiệu ứng gradient
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
})
Gradient.Rotation = 45
Gradient.Parent = MainFrame

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

local DropShadow = Instance.new("ImageLabel")
DropShadow.Name = "DropShadow"
DropShadow.Image = "rbxassetid://6014261993"
DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
DropShadow.ImageTransparency = 0.8
DropShadow.ScaleType = Enum.ScaleType.Slice
DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
DropShadow.Size = UDim2.new(1, 44, 1, 44)
DropShadow.Position = UDim2.new(0, -22, 0, -22)
DropShadow.BackgroundTransparency = 1
DropShadow.Parent = MainFrame

-- Tiêu đề với hiệu ứng
local TitleFrame = Instance.new("Frame")
TitleFrame.Size = UDim2.new(1, 0, 0, 60)
TitleFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TitleFrame.BorderSizePixel = 0

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleFrame

local Title = Instance.new("TextLabel")
Title.Text = "⚡ ULTIMATE HACK ⚡"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextStrokeTransparency = 0.8
Title.TextStrokeColor3 = Color3.fromRGB(0, 150, 255)

local TitleGlow = Instance.new("UIGradient")
TitleGlow.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
})
TitleGlow.Rotation = 90
TitleGlow.Parent = Title

-- ScrollFrame cho nội dung
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -80)
ScrollFrame.Position = UDim2.new(0, 10, 0, 70)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ScrollFrame

-- Hàm tạo toggle button đẹp
function createToggle(name, description, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 50)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    ToggleFrame.BackgroundTransparency = 0.5
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Text = name
    ToggleLabel.Size = UDim2.new(0.7, 0, 0, 30)
    ToggleLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.Font = Enum.Font.GothamSemibold
    ToggleLabel.TextSize = 16
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleDesc = Instance.new("TextLabel")
    ToggleDesc.Text = description
    ToggleDesc.Size = UDim2.new(0.7, 0, 0, 20)
    ToggleDesc.Position = UDim2.new(0.05, 0, 0.6, 0)
    ToggleDesc.BackgroundTransparency = 1
    ToggleDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
    ToggleDesc.Font = Enum.Font.Gotham
    ToggleDesc.TextSize = 12
    ToggleDesc.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    ToggleButton.Position = UDim2.new(0.85, -20, 0.5, -10)
    ToggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
    ToggleButton.Text = ""
    
    local ToggleButtonCorner = Instance.new("UICorner")
    ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
    ToggleButtonCorner.Parent = ToggleButton
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
    ToggleCircle.Position = default and UDim2.new(0.8, -8, 0.5, -8) or UDim2.new(0.2, -8, 0.5, -8)
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle
    
    ToggleButton.MouseButton1Click:Connect(function()
        local state = ToggleButton.BackgroundColor3 == Color3.fromRGB(0, 255, 100)
        local newState = not state
        
        if newState then
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 255, 100)}):Play()
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0.8, -8, 0.5, -8)}):Play()
        else
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}):Play()
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0.2, -8, 0.5, -8)}):Play()
        end
        
        callback(newState)
    end)
    
    ToggleCircle.Parent = ToggleButton
    ToggleButton.Parent = ToggleFrame
    ToggleDesc.Parent = ToggleFrame
    ToggleLabel.Parent = ToggleFrame
    ToggleFrame.Parent = ScrollFrame
    
    return ToggleFrame
end

-- Hàm tạo slider đẹp
function createSlider(name, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 70)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    SliderFrame.BackgroundTransparency = 0.5
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = SliderFrame
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Text = name
    SliderLabel.Size = UDim2.new(1, -20, 0, 25)
    SliderLabel.Position = UDim2.new(0, 10, 0, 5)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.Font = Enum.Font.GothamSemibold
    SliderLabel.TextSize = 16
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Text = tostring(default)
    ValueLabel.Size = UDim2.new(0, 50, 0, 25)
    ValueLabel.Position = UDim2.new(1, -60, 0, 5)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 16
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -20, 0, 6)
    SliderBar.Position = UDim2.new(0, 10, 0, 40)
    SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 20, 0, 20)
    SliderButton.Position = UDim2.new((default - min) / (max - min), -10, 0, -7)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.Text = ""
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = SliderButton
    
    local dragging = false
    
    local function updateSlider(input)
        local pos = UDim2.new(
            math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1),
            0,
            0,
            0
        )
        local value = math.floor(min + (pos.X.Scale * (max - min)))
        
        SliderFill.Size = pos
        SliderButton.Position = UDim2.new(pos.X.Scale, -10, 0, -7)
        ValueLabel.Text = tostring(value)
        
        callback(value)
    end
    
    SliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    SliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateSlider(input)
        end
    end)
    
    SliderFill.Parent = SliderBar
    SliderButton.Parent = SliderBar
    ValueLabel.Parent = SliderFrame
    SliderBar.Parent = SliderFrame
    SliderLabel.Parent = SliderFrame
    SliderFrame.Parent = ScrollFrame
    
    return SliderFrame
end

-- Hàm tạo button đẹp
function createButton(name, callback)
    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    ButtonFrame.BackgroundTransparency = 0.5
    ButtonFrame.Text = ""
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = ButtonFrame
    
    local ButtonLabel = Instance.new("TextLabel")
    ButtonLabel.Text = name
    ButtonLabel.Size = UDim2.new(1, 0, 1, 0)
    ButtonLabel.BackgroundTransparency = 1
    ButtonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ButtonLabel.Font = Enum.Font.GothamSemibold
    ButtonLabel.TextSize = 16
    
    local HoverEffect = Instance.new("Frame")
    HoverEffect.Size = UDim2.new(1, 0, 1, 0)
    HoverEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HoverEffect.BackgroundTransparency = 0.9
    HoverEffect.Visible = false
    
    ButtonFrame.MouseEnter:Connect(function()
        HoverEffect.Visible = true
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
    end)
    
    ButtonFrame.MouseLeave:Connect(function()
        HoverEffect.Visible = false
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
    end)
    
    ButtonFrame.MouseButton1Click:Connect(function()
        callback()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {Size = UDim2.new(0.95, 0, 0, 38)}):Play()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 40)}):Play()
    end)
    
    HoverEffect.Parent = ButtonFrame
    ButtonLabel.Parent = ButtonFrame
    ButtonFrame.Parent = ScrollFrame
    
    return ButtonFrame
end

-- Các tính năng hack

-- 1. God Mode (Bất Tử)
local godModeToggle = createToggle("🛡️ GOD MODE", "Bất tử - Vô địch tuyệt đối", false, function(state)
    godMode = state
    if state then
        spawn(function()
            while godMode and humanoid do
                humanoid.Health = humanoid.MaxHealth
                humanoid.MaxHealth = math.huge
                wait(0.1)
            end
        end)
        
        -- Chặn tất cả sát thương
        humanoid.HealthChanged:Connect(function()
            if godMode then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
        
        -- Vô hiệu hóa ragdoll
        if character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart:GetPropertyChangedSignal("Position"):Connect(function()
                if godMode then
                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end)
        end
    else
        humanoid.MaxHealth = 100
        humanoid.Health = 100
    end
end)

-- 2. Speed Hack
local speedSlider = createSlider("🚀 TỐC ĐỘ", 16, 500, originalWalkSpeed, function(value)
    if speedHack then
        humanoid.WalkSpeed = value
    end
end)

local speedToggle = createToggle("💨 SPEED HACK", "Di chuyển siêu tốc", false, function(state)
    speedHack = state
    if state then
        humanoid.WalkSpeed = tonumber(speedSlider:FindFirstChild("TextLabel").Text)
    else
        humanoid.WalkSpeed = originalWalkSpeed
    end
end)

-- 3. Fly Hack
local flyToggle = createToggle("✈️ FLY HACK", "Bay tự do trên không trung", false, function(state)
    flyEnabled = state
    if state then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = character:WaitForChild("HumanoidRootPart")
        
        UserInputService.InputBegan:Connect(function(input)
            if flyEnabled and input.KeyCode == Enum.KeyCode.Space then
                bodyVelocity.Velocity = Vector3.new(0, 50, 0)
            elseif flyEnabled and input.KeyCode == Enum.KeyCode.LeftShift then
                bodyVelocity.Velocity = Vector3.new(0, -50, 0)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if flyEnabled and (input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftShift) then
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            for _, v in pairs(root:GetChildren()) do
                if v:IsA("BodyVelocity") then
                    v:Destroy()
                end
            end
        end
    end
end)

-- 4. NoClip
local noclipToggle = createToggle("👻 NO CLIP", "Xuyên qua mọi vật thể", false, function(state)
    noclipEnabled = state
    if state then
        spawn(function()
            while noclipEnabled and character do
                wait()
                for _, v in pairs(character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    else
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
    end
end)

-- 5. Infinite Jump
local jumpToggle = createToggle("🦘 VÔ HẠN NHẢY", "Nhảy liên tục không giới hạn", false, function(state)
    infiniteJump = state
    if state then
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if infiniteJump and input.KeyCode == Enum.KeyCode.Space and not gameProcessed then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

-- 6. ESP Hack
local espToggle = createToggle("👁️ ESP HACK", "Nhìn xuyên tường thấy người chơi", false, function(state)
    espEnabled = state
    if state then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = plr.Character
                
                local billboard = Instance.new("BillboardGui")
                billboard.Size = UDim2.new(0, 100, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = plr.Character
                
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = plr.Name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextSize = 14
                nameLabel.Parent = billboard
                
                local distanceLabel = Instance.new("TextLabel")
                distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
                distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
                distanceLabel.BackgroundTransparency = 1
                distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                distanceLabel.Font = Enum.Font.Gotham
                distanceLabel.TextSize = 12
                distanceLabel.Parent = billboard
                
                spawn(function()
                    while espEnabled and plr.Character do
                        local distance = (character.HumanoidRootPart.Position - plr.Character:WaitForChild("HumanoidRootPart").Position).Magnitude
                        distanceLabel.Text = math.floor(distance) .. " studs"
                        wait(0.1)
                    end
                end)
            end
        end
    else
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                for _, obj in pairs(plr.Character:GetDescendants()) do
                    if obj:IsA("Highlight") or obj:IsA("BillboardGui") then
                        obj:Destroy()
                    end
                end
            end
        end
    end
end)

-- 7. X-Ray Vision
local xrayToggle = createToggle("🔍 X-RAY VISION", "Nhìn thấy vật thể ẩn", false, function(state)
    xrayEnabled = state
    if state then
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency ~= 1 then
                part.LocalTransparencyModifier = 0.7
            end
        end
    else
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0
            end
        end
    end
end)

-- 8. High Jump
local jumpPowerSlider = createSlider("🦘 LỰC NHẢY", 50, 500, originalJumpPower, function(value)
    humanoid.JumpPower = value
end)

-- 9. Low Gravity
local gravityToggle = createToggle("🌌 LOW GRAVITY", "Trọng lực thấp", false, function(state)
    if state then
        workspace.Gravity = 30
    else
        workspace.Gravity = originalGravity
    end
end)

-- 10. Kill All Players
createButton("💀 GIẾT TẤT CẢ NGƯỜI CHƠI", function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local humanoid = plr.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
        end
    end
end)

-- 11. Teleport to Spawn
createButton("📍 DỊCH CHUYỂN VỀ SPAWN", function()
    local spawnLocation = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChildOfClass("SpawnLocation")
    if spawnLocation then
        character:MoveTo(spawnLocation.Position + Vector3.new(0, 5, 0))
    else
        character:MoveTo(Vector3.new(0, 10, 0))
    end
end)

-- 12. Reset Character
createButton("🔄 RESET NHÂN VẬT", function()
    humanoid.Health = 0
end)

-- 13. Full Heal
createButton("❤️ HỒI PHỤC MÁU", function()
    humanoid.Health = humanoid.MaxHealth
end)

-- 14. Give All Tools
createButton("🛠️ NHẬN TẤT CẢ VŨ KHÍ", function()
    for _, tool in pairs(workspace:GetDescendants()) do
        if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
            tool:Clone().Parent = character
        end
    end
end)

-- Button đóng/mở UI
local ToggleUIButton = Instance.new("TextButton")
ToggleUIButton.Size = UDim2.new(0, 40, 0, 40)
ToggleUIButton.Position = UDim2.new(0.02, 0, 0.25, 0)
ToggleUIButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
ToggleUIButton.Text = "⚡"
ToggleUIButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleUIButton.Font = Enum.Font.GothamBold
ToggleUIButton.TextSize = 20

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleUIButton

local uiVisible = true

ToggleUIButton.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    if uiVisible then
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Position = UDim2.new(0.02, 0, 0.3, 0)}):Play()
        TweenService:Create(ToggleUIButton, TweenInfo.new(0.3), {Position = UDim2.new(0.02, 0, 0.25, 0)}):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Position = UDim2.new(-0.5, 0, 0.3, 0)}):Play()
        TweenService:Create(ToggleUIButton, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 0.25, 0)}):Play()
    end
end)

-- Hotkeys
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- F1: Toggle UI
    if input.KeyCode == Enum.KeyCode.F1 then
        ToggleUIButton:Click()
    end
    
    -- F2: God Mode
    if input.KeyCode == Enum.KeyCode.F2 then
        godMode = not godMode
        if godModeToggle:FindFirstChild("TextButton") then
            godModeToggle:FindFirstChild("TextButton"):Click()
        end
    end
    
    -- F3: Speed Hack
    if input.KeyCode == Enum.KeyCode.F3 then
        if speedToggle:FindFirstChild("TextButton") then
            speedToggle:FindFirstChild("TextButton"):Click()
        end
    end
    
    -- F4: Fly Hack
    if input.KeyCode == Enum.KeyCode.F4 then
        if flyToggle:FindFirstChild("TextButton") then
            flyToggle:FindFirstChild("TextButton"):Click()
        end
    end
end)

-- Cập nhật khi nhân vật thay đổi
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    originalWalkSpeed = humanoid.WalkSpeed
    originalJumpPower = humanoid.JumpPower
end)

-- Hiệu ứng cho UI
spawn(function()
    while true do
        TitleGlow.Offset = Vector2.new(math.sin(tick()), math.cos(tick()))
        wait(0.1)
    end
end)

-- Kết nối các phần tử UI
Title.Parent = TitleFrame
TitleFrame.Parent = MainFrame
ScrollFrame.Parent = MainFrame
MainFrame.Parent = ScreenGui
ToggleUIButton.Parent = ScreenGui
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Cập nhật kích thước ScrollFrame
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
end)

-- Thông báo khi load xong
wait(1)
game.StarterGui:SetCore("SendNotification", {
    Title = "ULTIMATE HACK LOADED",
    Text = "Nhấn F1 để mở/đóng menu\nF2: God Mode\nF3: Speed Hack\nF4: Fly Hack",
    Duration = 10,
    Icon = "rbxassetid://4483345998"
})

print("⚡ Ultimate Hack Script đã được kích hoạt thành công!") 


