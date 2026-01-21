-- ROBLOX HACK SCRIPT - Ultimate Character Control (Phiên bản cải thiện)
-- Đặt trong LocalScript (StarterPlayerScripts)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Biến toàn cục
local hackEnabled = true
local originalWalkSpeed = humanoid.WalkSpeed
local originalJumpPower = humanoid.JumpPower
local originalGravity = workspace.Gravity
local originalMaxHealth = humanoid.MaxHealth
local godMode = false
local speedHack = false
local flyEnabled = false
local noclipEnabled = false
local infiniteJump = false
local espEnabled = false
local xrayEnabled = false
local espConnections = {}
local flyBodyVelocity = nil

-- FIX: Biến để theo dõi kết nối God Mode
local godModeConnection = nil
local godModeLoop = nil

-- ==================== CẢI THIỆN UI ====================

-- Tạo GUI hiện đại với theme tối xanh dương
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateHackUI_" .. HttpService:GenerateGUID(false):sub(1, 8)
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999

-- Frame chính với hiệu ứng thủy tinh
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 550)
MainFrame.Position = UDim2.new(0.02, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

-- Hiệu ứng thủy tinh (Glassmorphism)
local BackgroundBlur = Instance.new("BlurEffect")
BackgroundBlur.Size = 8
BackgroundBlur.Parent = MainFrame

local GlassEffect = Instance.new("Frame")
GlassEffect.Size = UDim2.new(1, 0, 1, 0)
GlassEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GlassEffect.BackgroundTransparency = 0.95
GlassEffect.BorderSizePixel = 0
GlassEffect.Parent = MainFrame

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 40, 60)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 45, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 35, 55))
})
Gradient.Rotation = 45
Gradient.Transparency = NumberSequence.new(0.3)
Gradient.Parent = MainFrame

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 16)
Corner.Parent = MainFrame

-- Viền neon xung quanh
local NeonBorder = Instance.new("Frame")
NeonBorder.Size = UDim2.new(1, 4, 1, 4)
NeonBorder.Position = UDim2.new(0, -2, 0, -2)
NeonBorder.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
NeonBorder.BackgroundTransparency = 0.7
NeonBorder.BorderSizePixel = 0
NeonBorder.ZIndex = 0

local NeonCorner = Instance.new("UICorner")
NeonCorner.CornerRadius = UDim.new(0, 18)
NeonCorner.Parent = NeonBorder

-- Hiệu ứng nhấp nháy cho viền
spawn(function()
    while true do
        TweenService:Create(NeonBorder, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 
            {BackgroundTransparency = 0.5}):Play()
        wait(0.8)
        TweenService:Create(NeonBorder, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 
            {BackgroundTransparency = 0.7}):Play()
        wait(0.8)
    end
end)

NeonBorder.Parent = MainFrame

-- Tiêu đề với hiệu ứng gradient động
local TitleFrame = Instance.new("Frame")
TitleFrame.Size = UDim2.new(1, 0, 0, 70)
TitleFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
TitleFrame.BackgroundTransparency = 0.3
TitleFrame.BorderSizePixel = 0

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = TitleFrame

local Title = Instance.new("TextLabel")
Title.Text = "⚡ ULTIMATE HACK v2.0 ⚡"
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 22
Title.TextStrokeTransparency = 0.5
Title.TextStrokeColor3 = Color3.fromRGB(0, 100, 255)

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255))
})
TitleGradient.Rotation = 0
TitleGradient.Parent = Title

local SubTitle = Instance.new("TextLabel")
SubTitle.Text = "Control Panel"
SubTitle.Size = UDim2.new(1, -20, 0, 20)
SubTitle.Position = UDim2.new(0, 10, 0, 40)
SubTitle.BackgroundTransparency = 1
SubTitle.TextColor3 = Color3.fromRGB(150, 200, 255)
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 14
SubTitle.TextTransparency = 0.3
SubTitle.Parent = TitleFrame

-- ScrollFrame cải tiến
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -90)
ScrollFrame.Position = UDim2.new(0, 10, 0, 80)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
ScrollFrame.ScrollBarImageTransparency = 0.5
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 12)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Parent = ScrollFrame

-- ==================== HÀM TIỆN ÍCH UI ====================

-- Hàm tạo toggle button cải tiến
function createToggle(name, description, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(0.95, 0, 0, 60)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
    ToggleFrame.BackgroundTransparency = 0.5
    
    local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Text = "  " .. name
    ToggleLabel.Size = UDim2.new(0.7, 0, 0, 30)
    ToggleLabel.Position = UDim2.new(0, 0, 0.1, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.Font = Enum.Font.GothamSemibold
    ToggleLabel.TextSize = 16
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleDesc = Instance.new("TextLabel")
    ToggleDesc.Text = "  " .. description
    ToggleDesc.Size = UDim2.new(0.7, 0, 0, 20)
    ToggleDesc.Position = UDim2.new(0, 0, 0.6, 0)
    ToggleDesc.BackgroundTransparency = 1
    ToggleDesc.TextColor3 = Color3.fromRGB(180, 200, 220)
    ToggleDesc.Font = Enum.Font.Gotham
    ToggleDesc.TextSize = 12
    ToggleDesc.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 50, 0, 28)
    ToggleButton.Position = UDim2.new(0.85, -25, 0.5, -14)
    ToggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = false
    
    local ToggleButtonCorner = Instance.new("UICorner")
    ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
    ToggleButtonCorner.Parent = ToggleButton
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
    ToggleCircle.Position = default and UDim2.new(0.6, -10, 0.5, -10) or UDim2.new(0.1, -10, 0.5, -10)
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleCircle.ZIndex = 3
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle
    
    -- Hiệu ứng hover
    ToggleButton.MouseEnter:Connect(function()
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = default and Color3.fromRGB(0, 230, 120) or Color3.fromRGB(80, 80, 100)
        }):Play()
    end)
    
    ToggleButton.MouseLeave:Connect(function()
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = default and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
        }):Play()
    end)
    
    ToggleButton.MouseButton1Click:Connect(function()
        local state = ToggleButton.BackgroundColor3 == Color3.fromRGB(0, 200, 100)
        local newState = not state
        
        if newState then
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            }):Play()
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                Position = UDim2.new(0.6, -10, 0.5, -10)
            }):Play()
        else
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            }):Play()
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                Position = UDim2.new(0.1, -10, 0.5, -10)
            }):Play()
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

-- Hàm tạo slider cải tiến
function createSlider(name, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(0.95, 0, 0, 80)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
    SliderFrame.BackgroundTransparency = 0.5
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 10)
    SliderCorner.Parent = SliderFrame
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Text = "  " .. name
    SliderLabel.Size = UDim2.new(1, -20, 0, 25)
    SliderLabel.Position = UDim2.new(0, 0, 0, 5)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.Font = Enum.Font.GothamSemibold
    SliderLabel.TextSize = 16
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Text = tostring(default)
    ValueLabel.Size = UDim2.new(0, 60, 0, 25)
    ValueLabel.Position = UDim2.new(1, -65, 0, 5)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 16
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(0.9, 0, 0, 8)
    SliderBar.Position = UDim2.new(0.05, 0, 0, 40)
    SliderBar.BackgroundColor3 = Color3.fromRGB(40, 50, 70)
    SliderBar.BorderSizePixel = 0
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    SliderFill.ZIndex = 2
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 24, 0, 24)
    SliderButton.Position = UDim2.new((default - min) / (max - min), -12, 0.5, -12)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.Text = ""
    SliderButton.ZIndex = 3
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = SliderButton
    
    -- Hiệu ứng cho nút slider
    local ButtonGlow = Instance.new("ImageLabel")
    ButtonGlow.Size = UDim2.new(1, 10, 1, 10)
    ButtonGlow.Position = UDim2.new(0, -5, 0, -5)
    ButtonGlow.Image = "rbxassetid://8992230677"
    ButtonGlow.ImageColor3 = Color3.fromRGB(0, 150, 255)
    ButtonGlow.ImageTransparency = 0.7
    ButtonGlow.BackgroundTransparency = 1
    ButtonGlow.ZIndex = 2
    ButtonGlow.Parent = SliderButton
    
    local dragging = false
    
    local function updateSlider(input)
        local pos = UDim2.new(
            math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1),
            0,
            0,
            0
        )
        local value = math.floor(min + (pos.X.Scale * (max - min)))
        
        SliderFill.Size = UDim2.new(pos.X.Scale, 0, 1, 0)
        SliderButton.Position = UDim2.new(pos.X.Scale, -12, 0.5, -12)
        ValueLabel.Text = tostring(value)
        
        callback(value)
    end
    
    SliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            TweenService:Create(SliderButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 28, 0, 28)}):Play()
        end
    end)
    
    SliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            TweenService:Create(SliderButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 24, 0, 24)}):Play()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
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

-- Hàm tạo button cải tiến
function createButton(name, callback, icon)
    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Size = UDim2.new(0.95, 0, 0, 45)
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(30, 45, 70)
    ButtonFrame.BackgroundTransparency = 0.5
    ButtonFrame.Text = ""
    ButtonFrame.AutoButtonColor = false
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = ButtonFrame
    
    local ButtonLabel = Instance.new("TextLabel")
    ButtonLabel.Text = (icon or "✨") .. "  " .. name
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
    
    local ClickEffect = Instance.new("Frame")
    ClickEffect.Size = UDim2.new(0, 0, 0, 0)
    ClickEffect.Position = UDim2.new(0.5, 0, 0.5, 0)
    ClickEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ClickEffect.BackgroundTransparency = 0.7
    ClickEffect.Visible = false
    
    local ClickCorner = Instance.new("UICorner")
    ClickCorner.CornerRadius = UDim.new(1, 0)
    ClickCorner.Parent = ClickEffect
    
    ButtonFrame.MouseEnter:Connect(function()
        HoverEffect.Visible = true
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 60, 90)
        }):Play()
    end)
    
    ButtonFrame.MouseLeave:Connect(function()
        HoverEffect.Visible = false
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(30, 45, 70)
        }):Play()
    end)
    
    ButtonFrame.MouseButton1Click:Connect(function()
        -- Hiệu ứng click
        ClickEffect.Visible = true
        ClickEffect.Size = UDim2.new(0, 0, 0, 0)
        ClickEffect.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        TweenService:Create(ClickEffect, TweenInfo.new(0.3), {
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        
        -- Hiệu ứng nén
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {
            Size = UDim2.new(0.93, 0, 0, 43)
        }):Play()
        
        wait(0.1)
        
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {
            Size = UDim2.new(0.95, 0, 0, 45)
        }):Play()
        
        callback()
    end)
    
    HoverEffect.Parent = ButtonFrame
    ClickEffect.Parent = ButtonFrame
    ButtonLabel.Parent = ButtonFrame
    ButtonFrame.Parent = ScrollFrame
    
    return ButtonFrame
end

-- ==================== TÍNH NĂNG HACK (ĐÃ SỬA) ====================

-- 1. God Mode (ĐÃ SỬA LỖI)
local godModeToggle = createToggle("🛡️ GOD MODE", "Bất tử - Vô địch tuyệt đối", false, function(state)
    godMode = state
    
    -- Hủy kết nối cũ nếu có
    if godModeConnection then
        godModeConnection:Disconnect()
        godModeConnection = nil
    end
    
    if godModeLoop then
        coroutine.close(godModeLoop)
        godModeLoop = nil
    end
    
    if state then
        -- Lưu giá trị máu gốc
        originalMaxHealth = humanoid.MaxHealth
        
        -- Đặt máu tối đa cao và máu hiện tại
        humanoid.MaxHealth = 9e9
        humanoid.Health = 9e9
        
        -- Kết nối sự kiện khi máu thay đổi
        godModeConnection = humanoid.HealthChanged:Connect(function(newHealth)
            if godMode and newHealth < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
        
        -- Vòng lặp kiểm tra sức khỏe
        godModeLoop = coroutine.create(function()
            while godMode and humanoid do
                if humanoid.Health < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
                
                -- Ngăn chặn các trạng thái chết
                if humanoid:GetState() == Enum.HumanoidStateType.Dead then
                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
                
                task.wait(0.1)
            end
        end)
        
        coroutine.resume(godModeLoop)
        
        -- Thông báo
        game.StarterGui:SetCore("SendNotification", {
            Title = "GOD MODE ACTIVATED",
            Text = "Bạn đã bật chế độ bất tử!",
            Duration = 3,
            Icon = "rbxassetid://4483345998"
        })
    else
        -- Khôi phục giá trị gốc
        humanoid.MaxHealth = originalMaxHealth
        humanoid.Health = math.min(humanoid.Health, originalMaxHealth)
        
        -- Thông báo
        game.StarterGui:SetCore("SendNotification", {
            Title = "GOD MODE DEACTIVATED",
            Text = "Chế độ bất tử đã tắt!",
            Duration = 3,
            Icon = "rbxassetid://4483345998"
        })
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
        local value = tonumber(speedSlider:FindFirstChild("ValueLabel").Text) or originalWalkSpeed
        humanoid.WalkSpeed = value
    else
        humanoid.WalkSpeed = originalWalkSpeed
    end
end)

-- 3. Fly Hack (ĐÃ CẢI THIỆN)
local flyToggle = createToggle("✈️ FLY HACK", "Bay tự do (Space: Lên, Shift: Xuống)", false, function(state)
    flyEnabled = state
    
    if state then
        -- Tạo BodyVelocity cho bay
        if character:FindFirstChild("HumanoidRootPart") then
            flyBodyVelocity = Instance.new("BodyVelocity")
            flyBodyVelocity.Name = "FlyVelocity"
            flyBodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
            flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            flyBodyVelocity.Parent = rootPart
            
            -- Kết nối điều khiển bay
            local flyConnection
            flyConnection = RunService.Heartbeat:Connect(function()
                if flyEnabled and character and rootPart then
                    local velocity = Vector3.new(0, 0, 0)
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        velocity = velocity + (rootPart.CFrame.LookVector * 50)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        velocity = velocity + (rootPart.CFrame.LookVector * -50)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        velocity = velocity + (rootPart.CFrame.RightVector * -50)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        velocity = velocity + (rootPart.CFrame.RightVector * 50)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        velocity = velocity + Vector3.new(0, 50, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
                        velocity = velocity + Vector3.new(0, -50, 0)
                    end
                    
                    flyBodyVelocity.Velocity = velocity
                else
                    if flyConnection then
                        flyConnection:Disconnect()
                    end
                end
            end)
        end
    else
        -- Xóa BodyVelocity
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
        
        -- Tắt NoClip nếu đang bật
        if noclipEnabled then
            if noclipToggle:FindFirstChild("TextButton") then
                noclipToggle:FindFirstChild("TextButton"):Click()
            end
        end
    end
end)

-- 4. NoClip (ĐÃ CẢI THIỆN)
local noclipToggle = createToggle("👻 NO CLIP", "Xuyên qua mọi vật thể", false, function(state)
    noclipEnabled = state
    
    if state then
        -- Bật NoClip
        local noclipConnection
        noclipConnection = RunService.Stepped:Connect(function()
            if noclipEnabled and character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            else
                if noclipConnection then
                    noclipConnection:Disconnect()
                end
            end
        end)
    else
        -- Tắt NoClip
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- 5. Infinite Jump
local jumpToggle = createToggle("🦘 VÔ HẠN NHẢY", "Nhảy liên tục không giới hạn", false, function(state)
    infiniteJump = state
end)

-- Kết nối sự kiện nhảy vô hạn
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if infiniteJump and input.KeyCode == Enum.KeyCode.Space then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 6. ESP Hack (ĐÃ CẢI THIỆN)
local espToggle = createToggle("👁️ ESP HACK", "Nhìn xuyên tường thấy người chơi", false, function(state)
    espEnabled = state
    
    -- Xóa ESP cũ
    for _, connection in pairs(espConnections) do
        if connection then
            connection:Disconnect()
        end
    end
    espConnections = {}
    
    if state then
        -- Hàm tạo ESP cho người chơi
        local function createESP(plr)
            if plr == player then return end
            
            local connection
            connection = plr.CharacterAdded:Connect(function(char)
                wait(1) -- Đợi character load
                
                if not espEnabled then return end
                
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESP_Highlight"
                highlight.Adornee = char:WaitForChild("HumanoidRootPart")
                highlight.FillColor = Color3.fromRGB(255, 50, 50)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = char
                
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "ESP_Billboard"
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 3.5, 0)
                billboard.AlwaysOnTop = true
                billboard.Adornee = char:WaitForChild("HumanoidRootPart")
                billboard.Parent = char
                
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = plr.Name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextSize = 14
                nameLabel.TextStrokeTransparency = 0.5
                nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                nameLabel.Parent = billboard
                
                local distanceLabel = Instance.new("TextLabel")
                distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
                distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
                distanceLabel.BackgroundTransparency = 1
                distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                distanceLabel.Font = Enum.Font.Gotham
                distanceLabel.TextSize = 12
                distanceLabel.TextStrokeTransparency = 0.5
                distanceLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                distanceLabel.Parent = billboard
                
                -- Cập nhật khoảng cách
                local distanceUpdate
                distanceUpdate = RunService.Heartbeat:Connect(function()
                    if espEnabled and char and char:FindFirstChild("HumanoidRootPart") and character and character:FindFirstChild("HumanoidRootPart") then
                        local distance = (char.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                        distanceLabel.Text = math.floor(distance) .. " studs"
                    else
                        distanceUpdate:Disconnect()
                    end
                end)
                
                table.insert(espConnections, distanceUpdate)
            end)
            
            -- Tạo ESP cho character hiện tại nếu có
            if plr.Character then
                createESP(plr)
            end
            
            table.insert(espConnections, connection)
        end
        
        -- Tạo ESP cho tất cả người chơi
        for _, plr in pairs(Players:GetPlayers()) do
            createESP(plr)
        end
        
        -- Thêm ESP cho người chơi mới
        local newPlayerConnection = Players.PlayerAdded:Connect(function(plr)
            if espEnabled then
                createESP(plr)
            end
        end)
        
        table.insert(espConnections, newPlayerConnection)
    else
        -- Xóa tất cả ESP
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character then
                for _, obj in pairs(plr.Character:GetDescendants()) do
                    if obj.Name == "ESP_Highlight" or obj.Name == "ESP_Billboard" then
                        obj:Destroy()
                    end
                end
            end
        end
    end
end)

-- 7. X-Ray Vision (ĐÃ CẢI THIỆN)
local xrayToggle = createToggle("🔍 X-RAY VISION", "Nhìn thấy vật thể ẩn", false, function(state)
    xrayEnabled = state
    
    if state then
        -- Lưu độ trong suốt gốc
        local originalTransparency = {}
        
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency < 0.5 then
                originalTransparency[part] = part.Transparency
                part.LocalTransparencyModifier = 0.7
            end
        end
    else
        -- Khôi phục độ trong suốt gốc
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

-- ==================== CÁC NÚT CHỨC NĂNG ====================

-- Tạo separator
local function createSeparator(text)
    local SeparatorFrame = Instance.new("Frame")
    SeparatorFrame.Size = UDim2.new(0.95, 0, 0, 30)
    SeparatorFrame.BackgroundTransparency = 1
    
    local SeparatorLine = Instance.new("Frame")
    SeparatorLine.Size = UDim2.new(1, 0, 0, 1)
    SeparatorLine.Position = UDim2.new(0, 0, 0.5, 0)
    SeparatorLine.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    SeparatorLine.BackgroundTransparency = 0.5
    SeparatorLine.BorderSizePixel = 0
    
    local SeparatorText = Instance.new("TextLabel")
    SeparatorText.Text = "  " .. text .. "  "
    SeparatorText.Size = UDim2.new(0, 0, 1, 0)
    SeparatorText.Position = UDim2.new(0.5, 0, 0, 0)
    SeparatorText.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
    SeparatorText.BackgroundTransparency = 0.5
    SeparatorText.TextColor3 = Color3.fromRGB(150, 200, 255)
    SeparatorText.Font = Enum.Font.Gotham
    SeparatorText.TextSize = 12
    SeparatorText.TextXAlignment = Enum.TextXAlignment.Center
    
    SeparatorText.Parent = SeparatorFrame
    SeparatorLine.Parent = SeparatorFrame
    SeparatorFrame.Parent = ScrollFrame
    
    return SeparatorFrame
end

-- Thêm separator
createSeparator("CHỨC NĂNG TẤN CÔNG")

-- 10. Kill All Players
createButton("💀 GIẾT TẤT CẢ NGƯỜI CHƠI", function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local targetHumanoid = plr.Character:FindFirstChild("Humanoid")
            if targetHumanoid then
                targetHumanoid.Health = 0
            end
        end
    end
end, "💀")

-- 11. Teleport to Spawn
createButton("📍 DỊCH CHUYỂN VỀ SPAWN", function()
    local spawnLocation = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChildOfClass("SpawnLocation")
    if spawnLocation then
        character:MoveTo(spawnLocation.Position + Vector3.new(0, 5, 0))
    else
        character:MoveTo(Vector3.new(0, 10, 0))
    end
end, "📍")

createSeparator("CHỨC NĂNG HỖ TRỢ")

-- 12. Reset Character
createButton("🔄 RESET NHÂN VẬT", function()
    humanoid.Health = 0
end, "🔄")

-- 13. Full Heal
createButton("❤️ HỒI PHỤC MÁU", function()
    humanoid.Health = humanoid.MaxHealth
end, "❤️")

-- 14. Give All Tools
createButton("🛠️ NHẬN TẤT CẢ VŨ KHÍ", function()
    for _, tool in pairs(workspace:GetDescendants()) do
        if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
            local clone = tool:Clone()
            clone.Parent = character
        end
    end
end, "🛠️")

-- 15. Anti-AFK
local antiAFKEnabled = false
createButton("⏰ ANTI-AFK", function()
    antiAFKEnabled = not antiAFKEnabled
    
    if antiAFKEnabled then
        -- Ngăn chặn AFK
        local VirtualInputManager = game:GetService("VirtualInputManager")
        
        spawn(function()
            while antiAFKEnabled do
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, nil)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, nil)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.S, false, nil)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.S, false, nil)
                task.wait(59.7) -- Tổng cộng 60 giây
            end
        end)
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "ANTI-AFK ENABLED",
            Text = "Bạn sẽ không bị kick do AFK!",
            Duration = 3,
            Icon = "rbxassetid://4483345998"
        })
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "ANTI-AFK DISABLED",
            Text = "Anti-AFK đã tắt!",
            Duration = 3,
            Icon = "rbxassetid://4483345998"
        })
    end
end, "⏰")

-- ==================== NÚT ĐÓNG/MỞ UI ====================

local ToggleUIButton = Instance.new("TextButton")
ToggleUIButton.Size = UDim2.new(0, 50, 0, 50)
ToggleUIButton.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleUIButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
ToggleUIButton.Text = "⚡"
ToggleUIButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleUIButton.Font = Enum.Font.GothamBlack
ToggleUIButton.TextSize = 24
ToggleUIButton.AutoButtonColor = false

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleUIButton

-- Hiệu ứng cho nút toggle
local ToggleGlow = Instance.new("ImageLabel")
ToggleGlow.Size = UDim2.new(1, 10, 1, 10)
ToggleGlow.Position = UDim2.new(0, -5, 0, -5)
ToggleGlow.Image = "rbxassetid://8992230677"
ToggleGlow.ImageColor3 = Color3.fromRGB(0, 150, 255)
ToggleGlow.ImageTransparency = 0.5
ToggleGlow.BackgroundTransparency = 1
ToggleGlow.ZIndex = 0
ToggleGlow.Parent = ToggleUIButton

local uiVisible = true

ToggleUIButton.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    if uiVisible then
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.02, 0, 0.25, 0)
        }):Play()
        TweenService:Create(ToggleUIButton, TweenInfo.new(0.3), {
            Position = UDim2.new(0.02, 0, 0.2, 0),
            Rotation = 0
        }):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(-0.5, 0, 0.25, 0)
        }):Play()
        TweenService:Create(ToggleUIButton, TweenInfo.new(0.3), {
            Position = UDim2.new(0, 0, 0.2, 0),
            Rotation = 360
        }):Play()
    end
end)

-- Hiệu ứng hover cho nút toggle
ToggleUIButton.MouseEnter:Connect(function()
    TweenService:Create(ToggleUIButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(0, 150, 255),
        Size = UDim2.new(0, 55, 0, 55)
    }):Play()
end)

ToggleUIButton.MouseLeave:Connect(function()
    TweenService:Create(ToggleUIButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(0, 100, 255),
        Size = UDim2.new(0, 50, 0, 50)
    }):Play()
end)

-- ==================== HOTKEYS ====================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- F1: Toggle UI
    if input.KeyCode == Enum.KeyCode.F1 then
        ToggleUIButton:Click()
    end
    
    -- F2: God Mode
    if input.KeyCode == Enum.KeyCode.F2 then
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
    
    -- F5: NoClip
    if input.KeyCode == Enum.KeyCode.F5 then
        if noclipToggle:FindFirstChild("TextButton") then
            noclipToggle:FindFirstChild("TextButton"):Click()
        end
    end
    
    -- F6: ESP
    if input.KeyCode == Enum.KeyCode.F6 then
        if espToggle:FindFirstChild("TextButton") then
            espToggle:FindFirstChild("TextButton"):Click()
        end
    end
end)

-- ==================== XỬ LÝ SỰ KIỆN NHÂN VẬT ====================

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Khôi phục giá trị gốc
    originalWalkSpeed = humanoid.WalkSpeed
    originalJumpPower = humanoid.JumpPower
    originalMaxHealth = humanoid.MaxHealth
    
    -- Áp dụng lại các hack đang bật
    if speedHack then
        local value = tonumber(speedSlider:FindFirstChild("ValueLabel").Text) or originalWalkSpeed
        humanoid.WalkSpeed = value
    end
    
    if godMode then
        -- Áp dụng lại God Mode
        coroutine.wrap(function()
            wait(1) -- Đợi character load hoàn toàn
            humanoid.MaxHealth = 9e9
            humanoid.Health = 9e9
        end)()
    end
    
    -- Áp dụng lại jump power
    if jumpPowerSlider then
        local value = tonumber(jumpPowerSlider:FindFirstChild("ValueLabel").Text) or originalJumpPower
        humanoid.JumpPower = value
    end
end)

-- ==================== HIỆU ỨNG UI ĐỘNG ====================

-- Hiệu ứng gradient động cho tiêu đề
spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            TitleGradient.Offset = Vector2.new(i, 0)
            task.wait(0.05)
        end
    end
end)

-- Hiệu ứng nhấp nháy cho nút toggle
spawn(function()
    while true do
        TweenService:Create(ToggleGlow, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            ImageTransparency = 0.3
        }):Play()
        task.wait(1)
        TweenService:Create(ToggleGlow, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            ImageTransparency = 0.5
        }):Play()
        task.wait(1)
    end
end)

-- ==================== KẾT NỐI UI ====================

Title.Parent = TitleFrame
SubTitle.Parent = TitleFrame
TitleFrame.Parent = MainFrame
ScrollFrame.Parent = MainFrame
MainFrame.Parent = ScreenGui
ToggleUIButton.Parent = ScreenGui
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- ==================== THÔNG BÁO KHI LOAD ====================

task.wait(1)
game.StarterGui:SetCore("SendNotification", {
    Title = "⚡ ULTIMATE HACK v2.0 LOADED",
    Text = "Nhấn F1: Mở/đóng menu\nF2: God Mode\nF3: Speed Hack\nF4: Fly Hack\nF5: NoClip\nF6: ESP",
    Duration = 10,
    Icon = "rbxassetid://4483345998"
})

print("⚡ Ultimate Hack Script v2.0 đã được kích hoạt thành công!")
print("📊 Tính năng: God Mode (Đã sửa), Fly Hack, ESP, NoClip, Speed Hack, và nhiều tính năng khác!")