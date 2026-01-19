--[[
    ██████╗ ██╗████████╗ █████╗ ███╗   ██╗██╗  ██╗
    ██╔════╝ ██║╚══██╔══╝██╔══██╗████╗  ██║╚██╗██╔╝
    ██║  ███╗██║   ██║   ███████║██╔██╗ ██║ ╚███╔╝ 
    ██║   ██║██║   ██║   ██╔══██║██║╚██╗██║ ██╔██╗ 
    ╚██████╔╝██║   ██║   ██║  ██║██║ ╚████║██╔╝ ██╗
     ╚═════╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝
    
    GitanX - Premium UI Library for Roblox
    Version: 2.0.0
]]

local GitanX = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- Utility Functions
local function CreateInstance(class, properties)
    local instance = Instance.new(class)
    for property, value in pairs(properties) do
        if property ~= "Parent" then
            instance[property] = value
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

local function Tween(object, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quint,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput, mousePos, framePos
    
    dragHandle = dragHandle or frame
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - mousePos
            Tween(frame, {
                Position = UDim2.new(
                    framePos.X.Scale,
                    framePos.X.Offset + delta.X,
                    framePos.Y.Scale,
                    framePos.Y.Offset + delta.Y
                )
            }, 0.15, Enum.EasingStyle.Sine)
        end
    end)
end

-- Enhanced Theme System with Gradients
local Themes = {
    Dark = {
        Primary = Color3.fromRGB(147, 51, 234),
        Secondary = Color3.fromRGB(168, 85, 247),
        Background = Color3.fromRGB(10, 10, 15),
        Surface = Color3.fromRGB(20, 20, 30),
        SurfaceVariant = Color3.fromRGB(30, 30, 45),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(160, 160, 180),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(234, 179, 8),
        Error = Color3.fromRGB(239, 68, 68),
        Accent = Color3.fromRGB(217, 70, 239),
        Shadow = Color3.fromRGB(0, 0, 0),
        Glow = Color3.fromRGB(147, 51, 234),
    },
    Ocean = {
        Primary = Color3.fromRGB(6, 182, 212),
        Secondary = Color3.fromRGB(14, 165, 233),
        Background = Color3.fromRGB(8, 15, 25),
        Surface = Color3.fromRGB(15, 25, 40),
        SurfaceVariant = Color3.fromRGB(25, 40, 60),
        Text = Color3.fromRGB(240, 249, 255),
        TextSecondary = Color3.fromRGB(148, 199, 236),
        Success = Color3.fromRGB(16, 185, 129),
        Warning = Color3.fromRGB(251, 191, 36),
        Error = Color3.fromRGB(239, 68, 68),
        Accent = Color3.fromRGB(59, 130, 246),
        Shadow = Color3.fromRGB(0, 5, 10),
        Glow = Color3.fromRGB(6, 182, 212),
    },
    Sunset = {
        Primary = Color3.fromRGB(251, 146, 60),
        Secondary = Color3.fromRGB(249, 115, 22),
        Background = Color3.fromRGB(20, 10, 25),
        Surface = Color3.fromRGB(40, 20, 35),
        SurfaceVariant = Color3.fromRGB(55, 30, 50),
        Text = Color3.fromRGB(254, 243, 199),
        TextSecondary = Color3.fromRGB(253, 186, 116),
        Success = Color3.fromRGB(132, 204, 22),
        Warning = Color3.fromRGB(234, 179, 8),
        Error = Color3.fromRGB(220, 38, 38),
        Accent = Color3.fromRGB(236, 72, 153),
        Shadow = Color3.fromRGB(10, 0, 5),
        Glow = Color3.fromRGB(251, 146, 60),
    },
    Cyberpunk = {
        Primary = Color3.fromRGB(255, 0, 102),
        Secondary = Color3.fromRGB(0, 255, 255),
        Background = Color3.fromRGB(5, 5, 15),
        Surface = Color3.fromRGB(15, 15, 30),
        SurfaceVariant = Color3.fromRGB(25, 25, 45),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 220),
        Success = Color3.fromRGB(0, 255, 157),
        Warning = Color3.fromRGB(255, 191, 0),
        Error = Color3.fromRGB(255, 0, 102),
        Accent = Color3.fromRGB(138, 43, 255),
        Shadow = Color3.fromRGB(0, 0, 5),
        Glow = Color3.fromRGB(255, 0, 255),
    },
}

-- Main Library
function GitanX:CreateWindow(config)
    config = config or {}
    local WindowName = config.Name or "GitanX"
    local CurrentTheme = config.Theme or "Dark"
    local Theme = Themes[CurrentTheme]
    local LoadingEnabled = config.LoadingEnabled ~= false
    local MinimizeKey = config.MinimizeKey or Enum.KeyCode.RightControl
    
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.Minimized = false
    Window.Notifications = {}
    Window.CurrentTheme = CurrentTheme
    
    -- Create ScreenGui
    local ScreenGui = CreateInstance("ScreenGui", {
        Name = "GitanX",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
    })
    
    -- Main Frame with enhanced visuals
    local MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, -325, 0.5, -250),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Parent = ScreenGui,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 16),
        Parent = MainFrame,
    })
    
    -- Enhanced shadow with multiple layers
    local Shadow1 = CreateInstance("ImageLabel", {
        Name = "Shadow1",
        Size = UDim2.new(1, 60, 1, 60),
        Position = UDim2.new(0, -30, 0, -30),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = Theme.Shadow,
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        Parent = MainFrame,
        ZIndex = 0,
    })
    
    local Shadow2 = CreateInstance("ImageLabel", {
        Name = "Shadow2",
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -20),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = Theme.Shadow,
        ImageTransparency = 0.7,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        Parent = MainFrame,
        ZIndex = 0,
    })
    
    -- Animated glow effect
    local Glow = CreateInstance("ImageLabel", {
        Name = "Glow",
        Size = UDim2.new(1, 50, 1, 50),
        Position = UDim2.new(0, -25, 0, -25),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = Theme.Glow,
        ImageTransparency = 0.85,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        Parent = MainFrame,
        ZIndex = 0,
    })
    
    -- Pulsing glow animation
    spawn(function()
        while MainFrame.Parent do
            Tween(Glow, {ImageTransparency = 0.75}, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            wait(1.5)
            Tween(Glow, {ImageTransparency = 0.9}, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            wait(1.5)
        end
    end)
    
    -- Glass effect overlay
    local GlassEffect = CreateInstance("Frame", {
        Name = "GlassEffect",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.Surface,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Parent = MainFrame,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 16),
        Parent = GlassEffect,
    })
    
    -- Gradient overlay for depth
    local GradientOverlay = CreateInstance("Frame", {
        Name = "GradientOverlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = MainFrame,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 16),
        Parent = GradientOverlay,
    })
    
    CreateInstance("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 100)),
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.95),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Rotation = 90,
        Parent = GradientOverlay,
    })
    
    -- Enhanced TopBar
    local TopBar = CreateInstance("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 55),
        BackgroundColor3 = Theme.SurfaceVariant,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = MainFrame,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 16),
        Parent = TopBar,
    })
    
    -- TopBar gradient
    CreateInstance("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 150)),
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.9),
            NumberSequenceKeypoint.new(1, 0.95),
        }),
        Rotation = 90,
        Parent = TopBar,
    })
    
    -- Logo/Icon
    local Logo = CreateInstance("Frame", {
        Name = "Logo",
        Size = UDim2.new(0, 35, 0, 35),
        Position = UDim2.new(0, 15, 0, 10),
        BackgroundColor3 = Theme.Primary,
        BorderSizePixel = 0,
        Parent = TopBar,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = Logo,
    })
    
    CreateInstance("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.Primary),
            ColorSequenceKeypoint.new(1, Theme.Secondary),
        }),
        Rotation = 45,
        Parent = Logo,
    })
    
    local LogoGlow = CreateInstance("ImageLabel", {
        Size = UDim2.new(1, 20, 1, 20),
        Position = UDim2.new(0, -10, 0, -10),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = Theme.Primary,
        ImageTransparency = 0.7,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        Parent = Logo,
        ZIndex = 0,
    })
    
    local Title = CreateInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(0.5, -100, 1, 0),
        Position = UDim2.new(0, 60, 0, 0),
        BackgroundTransparency = 1,
        Text = WindowName,
        TextColor3 = Theme.Text,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar,
    })
    
    -- Animated accent line with gradient
    local AccentLine = CreateInstance("Frame", {
        Name = "AccentLine",
        Size = UDim2.new(1, 0, 0, 3),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme.Primary,
        BorderSizePixel = 0,
        Parent = TopBar,
    })
    
    CreateInstance("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.Primary),
            ColorSequenceKeypoint.new(0.5, Theme.Accent),
            ColorSequenceKeypoint.new(1, Theme.Secondary),
        }),
        Parent = AccentLine,
    })
    
    -- Animated gradient rotation
    spawn(function()
        local rotation = 0
        while AccentLine.Parent do
            rotation = (rotation + 1) % 360
            AccentLine.UIGradient.Rotation = rotation
            wait(0.05)
        end
    end)
    
    -- Enhanced Close Button
    local CloseButton = CreateInstance("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 38, 0, 38),
        Position = UDim2.new(1, -50, 0, 8.5),
        BackgroundColor3 = Theme.Error,
        BackgroundTransparency = 0.85,
        Text = "✕",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Parent = TopBar,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = CloseButton,
    })
    
    CreateInstance("UIStroke", {
        Color = Theme.Error,
        Transparency = 0.7,
        Thickness = 1.5,
        Parent = CloseButton,
    })
    
    CloseButton.MouseButton1Click:Connect(function()
        Tween(CloseButton, {Rotation = 90, BackgroundTransparency = 0.3}, 0.2)
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        wait(0.4)
        ScreenGui:Destroy()
    end)
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {BackgroundTransparency = 0.5, Size = UDim2.new(0, 42, 0, 42)}, 0.2)
        Tween(CloseButton.UIStroke, {Transparency = 0.3}, 0.2)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {BackgroundTransparency = 0.85, Size = UDim2.new(0, 38, 0, 38)}, 0.2)
        Tween(CloseButton.UIStroke, {Transparency = 0.7}, 0.2)
    end)
    
    -- Enhanced Minimize Button
    local MinimizeButton = CreateInstance("TextButton", {
        Name = "MinimizeButton",
        Size = UDim2.new(0, 38, 0, 38),
        Position = UDim2.new(1, -100, 0, 8.5),
        BackgroundColor3 = Theme.Warning,
        BackgroundTransparency = 0.85,
        Text = "−",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 22,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Parent = TopBar,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = MinimizeButton,
    })
    
    CreateInstance("UIStroke", {
        Color = Theme.Warning,
        Transparency = 0.7,
        Thickness = 1.5,
        Parent = MinimizeButton,
    })
    
    MinimizeButton.MouseButton1Click:Connect(function()
        Window:Minimize()
    end)
    
    MinimizeButton.MouseEnter:Connect(function()
        Tween(MinimizeButton, {BackgroundTransparency = 0.5, Size = UDim2.new(0, 42, 0, 42)}, 0.2)
        Tween(MinimizeButton.UIStroke, {Transparency = 0.3}, 0.2)
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        Tween(MinimizeButton, {BackgroundTransparency = 0.85, Size = UDim2.new(0, 38, 0, 38)}, 0.2)
        Tween(MinimizeButton.UIStroke, {Transparency = 0.7}, 0.2)
    end)
    
    -- Enhanced Tabs Container
    local TabsContainer = CreateInstance("Frame", {
        Name = "TabsContainer",
        Size = UDim2.new(0, 160, 1, -70),
        Position = UDim2.new(0, 12, 0, 62),
        BackgroundTransparency = 1,
        Parent = MainFrame,
    })
    
    CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = TabsContainer,
    })
    
    local ContentContainer = CreateInstance("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, -185, 1, -70),
        Position = UDim2.new(0, 177, 0, 62),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = MainFrame,
    })
    
    MakeDraggable(MainFrame, TopBar)
    
    function Window:Minimize()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            Tween(MainFrame, {Size = UDim2.new(0, 650, 0, 55)}, 0.4, Enum.EasingStyle.Back)
            MinimizeButton.Text = "+"
            TabsContainer.Visible = false
            ContentContainer.Visible = false
        else
            Tween(MainFrame, {Size = UDim2.new(0, 650, 0, 500)}, 0.4, Enum.EasingStyle.Back)
            MinimizeButton.Text = "−"
            TabsContainer.Visible = true
            ContentContainer.Visible = true
        end
    end
    
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == MinimizeKey then
            Window:Minimize()
        end
    end)
    
    function Window:SetTheme(themeName)
        if not Themes[themeName] then return end
        
        Window.CurrentTheme = themeName
        Theme = Themes[themeName]
        
        Tween(MainFrame, {BackgroundColor3 = Theme.Background}, 0.4)
        Tween(GlassEffect, {BackgroundColor3 = Theme.Surface}, 0.4)
        Tween(Glow, {ImageColor3 = Theme.Glow}, 0.4)
        Tween(TopBar, {BackgroundColor3 = Theme.SurfaceVariant}, 0.4)
        Tween(Title, {TextColor3 = Theme.Text}, 0.4)
        Tween(AccentLine, {BackgroundColor3 = Theme.Primary}, 0.4)
        Tween(Logo, {BackgroundColor3 = Theme.Primary}, 0.4)
        
        Window:Notify({
            Title = "Thème Modifié",
            Content = "Le thème " .. themeName .. " a été appliqué avec succès !",
            Duration = 2.5,
            Type = "Success"
        })
    end
    
    if not LoadingEnabled then
        Tween(MainFrame, {Size = UDim2.new(0, 650, 0, 500)}, 0.6, Enum.EasingStyle.Back)
    else
        -- Enhanced Loading Screen
        local LoadingFrame = CreateInstance("Frame", {
            Name = "LoadingFrame",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Theme.Background,
            BorderSizePixel = 0,
            Parent = MainFrame,
            ZIndex = 10,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 16),
            Parent = LoadingFrame,
        })
        
        local LoadingText = CreateInstance("TextLabel", {
            Size = UDim2.new(0, 250, 0, 60),
            Position = UDim2.new(0.5, -125, 0.5, -60),
            BackgroundTransparency = 1,
            Text = "GitanX",
            TextColor3 = Theme.Text,
            TextSize = 32,
            Font = Enum.Font.GothamBold,
            Parent = LoadingFrame,
        })
        
        local LoadingSubtext = CreateInstance("TextLabel", {
            Size = UDim2.new(0, 250, 0, 30),
            Position = UDim2.new(0.5, -125, 0.5, -10),
            BackgroundTransparency = 1,
            Text = "Chargement en cours...",
            TextColor3 = Theme.TextSecondary,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Parent = LoadingFrame,
        })
        
        local LoadingBarBg = CreateInstance("Frame", {
            Size = UDim2.new(0, 250, 0, 6),
            Position = UDim2.new(0.5, -125, 0.5, 40),
            BackgroundColor3 = Theme.Surface,
            BorderSizePixel = 0,
            Parent = LoadingFrame,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = LoadingBarBg,
        })
        
        local LoadingBar = CreateInstance("Frame", {
            Size = UDim2.new(0, 0, 1, 0),
            BackgroundColor3 = Theme.Primary,
            BorderSizePixel = 0,
            Parent = LoadingBarBg,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = LoadingBar,
        })
        
        CreateInstance("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Theme.Primary),
                ColorSequenceKeypoint.new(0.5, Theme.Accent),
                ColorSequenceKeypoint.new(1, Theme.Secondary),
            }),
            Parent = LoadingBar,
        })
        
        MainFrame.Size = UDim2.new(0, 650, 0, 500)
        
        Tween(LoadingBar, {Size = UDim2.new(1, 0, 1, 0)}, 1.8, Enum.EasingStyle.Sine)
        wait(1.8)
        
        Tween(LoadingFrame, {BackgroundTransparency = 1}, 0.4)
        Tween(LoadingText, {TextTransparency = 1}, 0.4)
        Tween(LoadingSubtext, {TextTransparency = 1}, 0.4)
        Tween(LoadingBarBg, {BackgroundTransparency = 1}, 0.4)
        Tween(LoadingBar, {BackgroundTransparency = 1}, 0.4)
        
        wait(0.4)
        LoadingFrame:Destroy()
    end
    
    function Window:CreateTab(config)
        config = config or {}
        local TabName = config.Name or "Tab"
        local TabIconText = config.Icon or "⚡"
        
        local Tab = {}
        Tab.Elements = {}
        
        -- Enhanced Tab Button
        local TabButton = CreateInstance("TextButton", {
            Name = TabName,
            Size = UDim2.new(1, 0, 0, 45),
            BackgroundColor3 = Theme.Surface,
            BackgroundTransparency = 0.6,
            BorderSizePixel = 0,
            Text = "",
            Parent = TabsContainer,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 12),
            Parent = TabButton,
        })
        
        CreateInstance("UIStroke", {
            Color = Theme.Primary,
            Transparency = 0.85,
            Thickness = 1.5,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Parent = TabButton,
        })
        
        local TabIconBg = CreateInstance("Frame", {
            Size = UDim2.new(0, 32, 0, 32),
            Position = UDim2.new(0, 8, 0, 6.5),
            BackgroundColor3 = Theme.Primary,
            BackgroundTransparency = 0.85,
            BorderSizePixel = 0,
            Parent = TabButton,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = TabIconBg,
        })
        
        local TabIcon = CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = TabIconText,
            TextColor3 = Theme.Primary,
            TextSize = 18,
            Font = Enum.Font.GothamBold,
            Parent = TabIconBg,
        })
        
        local TabLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -50, 1, 0),
            Position = UDim2.new(0, 45, 0, 0),
            BackgroundTransparency = 1,
            Text = TabName,
            TextColor3 = Theme.Text,
            TextSize = 14,
            Font = Enum.Font.GothamSemibold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabButton,
        })
        
        local TabContent = CreateInstance("ScrollingFrame", {
            Name = TabName .. "Content",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 5,
            ScrollBarImageColor3 = Theme.Primary,
            BorderSizePixel = 0,
            Visible = false,
            Parent = ContentContainer,
        })
        
        CreateInstance("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10),
            Parent = TabContent,
        })
        
        CreateInstance("UIPadding", {
            PaddingTop = UDim.new(0, 8),
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 12),
            Parent = TabContent,
        })
        
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                Tween(tab.Button, {BackgroundTransparency = 0.6}, 0.3)
                Tween(tab.Button.UIStroke, {Transparency = 0.85}, 0.3)
                Tween(tab.IconBg, {BackgroundTransparency = 0.85}, 0.3)
            end
            TabContent.Visible = true
            Tween(TabButton, {BackgroundTransparency = 0.2}, 0.3)
            Tween(TabButton.UIStroke, {Transparency = 0.4}, 0.3)
            Tween(TabIconBg, {BackgroundTransparency = 0.5}, 0.3)
            Window.CurrentTab = Tab
        end)
        
        TabButton.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundTransparency = 0.4}, 0.2)
                Tween(TabButton.UIStroke, {Transparency = 0.6}, 0.2)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundTransparency = 0.6}, 0.2)
                Tween(TabButton.UIStroke, {Transparency = 0.85}, 0.2)
            end
        end)
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        Tab.IconBg = TabIconBg
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                Tween(tab.Button, {BackgroundTransparency = 0.6}, 0.3)
            end
            TabContent.Visible = true
            Tween(TabButton, {BackgroundTransparency = 0.2}, 0.3)
            Tween(TabButton.UIStroke, {Transparency = 0.4}, 0.3)
            Tween(TabIconBg, {BackgroundTransparency = 0.5}, 0.3)
            Window.CurrentTab = Tab
        end
        
        function Tab:CreateButton(config)
            config = config or {}
            local ButtonName = config.Name or "Button"
            local Callback = config.Callback or function() end
            
            local ButtonFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, -5, 0, 45),
                BackgroundColor3 = Theme.Surface,
                BackgroundTransparency = 0.4,
                BorderSizePixel = 0,
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = ButtonFrame,
            })
            
            CreateInstance("UIStroke", {
                Color = Theme.Primary,
                Transparency = 0.85,
                Thickness = 1.5,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Parent = ButtonFrame,
            })
            
            CreateInstance("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200)),
                }),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.95),
                    NumberSequenceKeypoint.new(1, 0.98),
                }),
                Rotation = 90,
                Parent = ButtonFrame,
            })
            
            local Button = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = ButtonName,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamSemibold,
                Parent = ButtonFrame,
            })
            
            local ButtonRipple = CreateInstance("Frame", {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Theme.Primary,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Parent = ButtonFrame,
                ZIndex = 2,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = ButtonRipple,
            })
            
            Button.MouseButton1Click:Connect(function()
                ButtonRipple.Size = UDim2.new(0, 0, 0, 0)
                ButtonRipple.BackgroundTransparency = 0.5
                
                Tween(ButtonRipple, {Size = UDim2.new(2, 0, 2, 0), BackgroundTransparency = 1}, 0.5)
                Tween(ButtonFrame, {BackgroundColor3 = Theme.Primary}, 0.1)
                Tween(ButtonFrame.UIStroke, {Transparency = 0.3}, 0.1)
                
                wait(0.1)
                Tween(ButtonFrame, {BackgroundColor3 = Theme.Surface}, 0.2)
                Tween(ButtonFrame.UIStroke, {Transparency = 0.85}, 0.2)
                
                Callback()
            end)
            
            Button.MouseEnter:Connect(function()
                Tween(ButtonFrame, {BackgroundTransparency = 0.2}, 0.2)
                Tween(ButtonFrame.UIStroke, {Transparency = 0.6}, 0.2)
                Tween(Button, {TextSize = 15}, 0.2)
            end)
            
            Button.MouseLeave:Connect(function()
                Tween(ButtonFrame, {BackgroundTransparency = 0.4}, 0.2)
                Tween(ButtonFrame.UIStroke, {Transparency = 0.85}, 0.2)
                Tween(Button, {TextSize = 14}, 0.2)
            end)
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y + 16)
            
            return Button
        end
        
        function Tab:CreateLabel(text)
            text = text or "Label"
            
            local LabelFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, -5, 0, 35),
                BackgroundTransparency = 1,
                Parent = TabContent,
            })
            
            local Label = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -15, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Theme.TextSecondary,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = LabelFrame,
            })
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y + 16)
            
            local LabelObject = {}
            function LabelObject:Set(newText)
                Label.Text = newText
            end
            
            return LabelObject
        end
        
        function Tab:CreateToggle(config)
            config = config or {}
            local ToggleName = config.Name or "Toggle"
            local Default = config.Default or false
            local Callback = config.Callback or function() end
            
            local ToggleState = Default
            
            local ToggleFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, -5, 0, 45),
                BackgroundColor3 = Theme.Surface,
                BackgroundTransparency = 0.4,
                BorderSizePixel = 0,
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = ToggleFrame,
            })
            
            CreateInstance("UIStroke", {
                Color = Default and Theme.Success or Theme.Primary,
                Transparency = 0.85,
                Thickness = 1.5,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Parent = ToggleFrame,
            })
            
            local ToggleLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -75, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = ToggleName,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ToggleFrame,
            })
            
            local ToggleButton = CreateInstance("TextButton", {
                Size = UDim2.new(0, 52, 0, 28),
                Position = UDim2.new(1, -60, 0.5, -14),
                BackgroundColor3 = Default and Theme.Success or Theme.SurfaceVariant,
                Text = "",
                BorderSizePixel = 0,
                Parent = ToggleFrame,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = ToggleButton,
            })
            
            CreateInstance("UIStroke", {
                Color = Default and Theme.Success or Theme.TextSecondary,
                Transparency = 0.7,
                Thickness = 2,
                Parent = ToggleButton,
            })
            
            local ToggleCircle = CreateInstance("Frame", {
                Size = UDim2.new(0, 22, 0, 22),
                Position = Default and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Parent = ToggleButton,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = ToggleCircle,
            })
            
            local CircleShadow = CreateInstance("ImageLabel", {
                Size = UDim2.new(1, 10, 1, 10),
                Position = UDim2.new(0, -5, 0, -5),
                BackgroundTransparency = 1,
                Image = "rbxassetid://5028857084",
                ImageColor3 = Color3.fromRGB(0, 0, 0),
                ImageTransparency = 0.8,
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(24, 24, 276, 276),
                Parent = ToggleCircle,
                ZIndex = 0,
            })
            
            ToggleButton.MouseButton1Click:Connect(function()
                ToggleState = not ToggleState
                
                if ToggleState then
                    Tween(ToggleButton, {BackgroundColor3 = Theme.Success}, 0.3)
                    Tween(ToggleButton.UIStroke, {Color = Theme.Success}, 0.3)
                    Tween(ToggleCircle, {Position = UDim2.new(1, -25, 0.5, -11)}, 0.3, Enum.EasingStyle.Back)
                    Tween(ToggleFrame.UIStroke, {Color = Theme.Success, Transparency = 0.6}, 0.3)
                else
                    Tween(ToggleButton, {BackgroundColor3 = Theme.SurfaceVariant}, 0.3)
                    Tween(ToggleButton.UIStroke, {Color = Theme.TextSecondary}, 0.3)
                    Tween(ToggleCircle, {Position = UDim2.new(0, 3, 0.5, -11)}, 0.3, Enum.EasingStyle.Back)
                    Tween(ToggleFrame.UIStroke, {Color = Theme.Primary, Transparency = 0.85}, 0.3)
                end
                
                Callback(ToggleState)
            end)
            
            ToggleFrame.MouseEnter:Connect(function()
                Tween(ToggleFrame, {BackgroundTransparency = 0.2}, 0.2)
            end)
            
            ToggleFrame.MouseLeave:Connect(function()
                Tween(ToggleFrame, {BackgroundTransparency = 0.4}, 0.2)
            end)
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y + 16)
            
            local ToggleObject = {}
            function ToggleObject:Set(value)
                ToggleState = value
                if ToggleState then
                    Tween(ToggleButton, {BackgroundColor3 = Theme.Success}, 0.3)
                    Tween(ToggleButton.UIStroke, {Color = Theme.Success}, 0.3)
                    Tween(ToggleCircle, {Position = UDim2.new(1, -25, 0.5, -11)}, 0.3, Enum.EasingStyle.Back)
                    Tween(ToggleFrame.UIStroke, {Color = Theme.Success, Transparency = 0.6}, 0.3)
                else
                    Tween(ToggleButton, {BackgroundColor3 = Theme.SurfaceVariant}, 0.3)
                    Tween(ToggleButton.UIStroke, {Color = Theme.TextSecondary}, 0.3)
                    Tween(ToggleCircle, {Position = UDim2.new(0, 3, 0.5, -11)}, 0.3, Enum.EasingStyle.Back)
                    Tween(ToggleFrame.UIStroke, {Color = Theme.Primary, Transparency = 0.85}, 0.3)
                end
                Callback(ToggleState)
            end
            
            return ToggleObject
        end
        
        function Tab:CreateSlider(config)
            config = config or {}
            local SliderName = config.Name or "Slider"
            local Min = config.Min or 0
            local Max = config.Max or 100
            local Default = config.Default or 50
            local Callback = config.Callback or function() end
            
            local SliderValue = Default
            
            local SliderFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, -5, 0, 55),
                BackgroundColor3 = Theme.Surface,
                BackgroundTransparency = 0.4,
                BorderSizePixel = 0,
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = SliderFrame,
            })
            
            CreateInstance("UIStroke", {
                Color = Theme.Primary,
                Transparency = 0.85,
                Thickness = 1.5,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Parent = SliderFrame,
            })
            
            local SliderLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -70, 0, 22),
                Position = UDim2.new(0, 12, 0, 8),
                BackgroundTransparency = 1,
                Text = SliderName,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SliderFrame,
            })
            
            local SliderValueLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0, 55, 0, 22),
                Position = UDim2.new(1, -62, 0, 8),
                BackgroundTransparency = 1,
                Text = tostring(Default),
                TextColor3 = Theme.Primary,
                TextSize = 15,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = SliderFrame,
            })
            
            local SliderBackground = CreateInstance("Frame", {
                Size = UDim2.new(1, -24, 0, 8),
                Position = UDim2.new(0, 12, 1, -18),
                BackgroundColor3 = Theme.SurfaceVariant,
                BackgroundTransparency = 0.3,
                BorderSizePixel = 0,
                Parent = SliderFrame,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SliderBackground,
            })
            
            CreateInstance("UIStroke", {
                Color = Theme.Primary,
                Transparency = 0.9,
                Thickness = 1,
                Parent = SliderBackground,
            })
            
            local SliderFill = CreateInstance("Frame", {
                Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0),
                BackgroundColor3 = Theme.Primary,
                BorderSizePixel = 0,
                Parent = SliderBackground,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SliderFill,
            })
            
            CreateInstance("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Theme.Primary),
                    ColorSequenceKeypoint.new(1, Theme.Secondary),
                }),
                Parent = SliderFill,
            })
            
            local SliderButton = CreateInstance("TextButton", {
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new((Default - Min) / (Max - Min), -9, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Text = "",
                Parent = SliderBackground,
                ZIndex = 2,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SliderButton,
            })
            
            CreateInstance("UIStroke", {
                Color = Theme.Primary,
                Transparency = 0.5,
                Thickness = 2,
                Parent = SliderButton,
            })
            
            local ButtonGlow = CreateInstance("ImageLabel", {
                Size = UDim2.new(1, 12, 1, 12),
                Position = UDim2.new(0, -6, 0, -6),
                BackgroundTransparency = 1,
                Image = "rbxassetid://5028857084",
                ImageColor3 = Theme.Primary,
                ImageTransparency = 0.7,
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(24, 24, 276, 276),
                Parent = SliderButton,
                ZIndex = 1,
            })
            
            local dragging = false
            
            SliderButton.MouseButton1Down:Connect(function()
                dragging = true
                Tween(SliderButton, {Size = UDim2.new(0, 22, 0, 22)}, 0.2)
                Tween(ButtonGlow, {ImageTransparency = 0.4}, 0.2)
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    Tween(SliderButton, {Size = UDim2.new(0, 18, 0, 18)}, 0.2)
                    Tween(ButtonGlow, {ImageTransparency = 0.7}, 0.2)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = UserInputService:GetMouseLocation().X
                    local sliderPos = SliderBackground.AbsolutePosition.X
                    local sliderSize = SliderBackground.AbsoluteSize.X
                    
                    local value = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
                    SliderValue = math.floor(((Max - Min) * value + Min))
                    SliderValue = math.clamp(SliderValue, Min, Max)
                    
                    SliderFill.Size = UDim2.new(value, 0, 1, 0)
                    SliderButton.Position = UDim2.new(value, -9, 0.5, -9)
                    SliderValueLabel.Text = tostring(SliderValue)
                    
                    Callback(SliderValue)
                end
            end)
            
            SliderFrame.MouseEnter:Connect(function()
                Tween(SliderFrame, {BackgroundTransparency = 0.2}, 0.2)
                Tween(SliderFrame.UIStroke, {Transparency = 0.6}, 0.2)
            end)
            
            SliderFrame.MouseLeave:Connect(function()
                Tween(SliderFrame, {BackgroundTransparency = 0.4}, 0.2)
                Tween(SliderFrame.UIStroke, {Transparency = 0.85}, 0.2)
            end)
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y + 16)
            
            local SliderObject = {}
            function SliderObject:Set(value)
                value = math.clamp(value, Min, Max)
                SliderValue = value
                local percent = (value - Min) / (Max - Min)
                SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                SliderButton.Position = UDim2.new(percent, -9, 0.5, -9)
                SliderValueLabel.Text = tostring(value)
                Callback(value)
            end
            
            return SliderObject
        end
        
        function Tab:CreateDropdown(config)
            config = config or {}
            local DropdownName = config.Name or "Dropdown"
            local Options = config.Options or {"Option 1", "Option 2"}
            local Default = config.Default or Options[1]
            local Callback = config.Callback or function() end
            
            local DropdownValue = Default
            local DropdownOpen = false
            
            local DropdownFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, -5, 0, 45),
                BackgroundColor3 = Theme.Surface,
                BackgroundTransparency = 0.4,
                BorderSizePixel = 0,
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = DropdownFrame,
            })
            
            CreateInstance("UIStroke", {
                Color = Theme.Primary,
                Transparency = 0.85,
                Thickness = 1.5,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Parent = DropdownFrame,
            })
            
            local DropdownLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -145, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = DropdownName,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DropdownFrame,
            })
            
            local DropdownButton = CreateInstance("TextButton", {
                Size = UDim2.new(0, 130, 0, 32),
                Position = UDim2.new(1, -138, 0, 6.5),
                BackgroundColor3 = Theme.Primary,
                BackgroundTransparency = 0.8,
                Text = Default,
                TextColor3 = Theme.Text,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                BorderSizePixel = 0,
                Parent = DropdownFrame,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = DropdownButton,
            })
            
            CreateInstance("UIStroke", {
                Color = Theme.Primary,
                Transparency = 0.6,
                Thickness = 1.5,
                Parent = DropdownButton,
            })
            
            local DropdownArrow = CreateInstance("TextLabel", {
                Size = UDim2.new(0, 20, 1, 0),
                Position = UDim2.new(1, -22, 0, 0),
                BackgroundTransparency = 1,
                Text = "▼",
                TextColor3 = Theme.Text,
                TextSize = 10,
                Font = Enum.Font.GothamBold,
                Parent = DropdownButton,
            })
            
            local DropdownContainer = CreateInstance("Frame", {
                Size = UDim2.new(0, 130, 0, 0),
                Position = UDim2.new(1, -138, 0, 45),
                BackgroundColor3 = Theme.SurfaceVariant,
                BackgroundTransparency = 0.1,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Visible = false,
                Parent = DropdownFrame,
                ZIndex = 5,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = DropdownContainer,
            })
            
            CreateInstance("UIStroke", {
                Color = Theme.Primary,
                Transparency = 0.7,
                Thickness = 1.5,
                Parent = DropdownContainer,
            })
            
            CreateInstance("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 3),
                Parent = DropdownContainer,
            })
            
            CreateInstance("UIPadding", {
                PaddingTop = UDim.new(0, 6),
                PaddingBottom = UDim.new(0, 6),
                PaddingLeft = UDim.new(0, 6),
                PaddingRight = UDim.new(0, 6),
                Parent = DropdownContainer,
            })
            
            for _, option in pairs(Options) do
                local OptionButton = CreateInstance("TextButton", {
                    Size = UDim2.new(1, -12, 0, 28),
                    BackgroundColor3 = Theme.Primary,
                    BackgroundTransparency = 0.85,
                    Text = option,
                    TextColor3 = Theme.Text,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    BorderSizePixel = 0,
                    Parent = DropdownContainer,
                })
                
                CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = OptionButton,
                })
                
                OptionButton.MouseButton1Click:Connect(function()
                    DropdownValue = option
                    DropdownButton.Text = option
                    DropdownOpen = false
                    
                    Tween(DropdownArrow, {Rotation = 0}, 0.3)
                    Tween(DropdownContainer, {Size = UDim2.new(0, 130, 0, 0)}, 0.3)
                    wait(0.3)
                    DropdownContainer.Visible = false
                    
                    Callback(option)
                end)
                
                OptionButton.MouseEnter:Connect(function()
                    Tween(OptionButton, {BackgroundTransparency = 0.5}, 0.2)
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    Tween(OptionButton, {BackgroundTransparency = 0.85}, 0.2)
                end)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                DropdownOpen = not DropdownOpen
                if DropdownOpen then
                    DropdownContainer.Visible = true
                    local contentSize = DropdownContainer.UIListLayout.AbsoluteContentSize.Y + 12
                    Tween(DropdownArrow, {Rotation = 180}, 0.3)
                    Tween(DropdownContainer, {Size = UDim2.new(0, 130, 0, contentSize)}, 0.3, Enum.EasingStyle.Back)
                else
                    Tween(DropdownArrow, {Rotation = 0}, 0.3)
                    Tween(DropdownContainer, {Size = UDim2.new(0, 130, 0, 0)}, 0.3)
                    wait(0.3)
                    DropdownContainer.Visible = false
                end
            end)
            
            DropdownButton.MouseEnter:Connect(function()
                Tween(DropdownButton, {BackgroundTransparency = 0.6}, 0.2)
                Tween(DropdownButton.UIStroke, {Transparency = 0.4}, 0.2)
            end)
            
            DropdownButton.MouseLeave:Connect(function()
                Tween(DropdownButton, {BackgroundTransparency = 0.8}, 0.2)
                Tween(DropdownButton.UIStroke, {Transparency = 0.6}, 0.2)
            end)
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y + 16)
            
            local DropdownObject = {}
            function DropdownObject:Set(value)
                DropdownValue = value
                DropdownButton.Text = value
                Callback(value)
            end
            
            return DropdownObject
        end
        
        function Tab:CreateInput(config)
            config = config or {}
            local InputName = config.Name or "Input"
            local Placeholder = config.Placeholder or "Entrer du texte..."
            local Callback = config.Callback or function() end
            
            local InputFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, -5, 0, 45),
                BackgroundColor3 = Theme.Surface,
                BackgroundTransparency = 0.4,
                BorderSizePixel = 0,
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = InputFrame,
            })
            
            CreateInstance("UIStroke", {
                Color = Theme.Primary,
                Transparency = 0.85,
                Thickness = 1.5,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Parent = InputFrame,
            })
            
            local InputLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0.35, 0, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = InputName,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = InputFrame,
            })
            
            local InputBox = CreateInstance("TextBox", {
                Size = UDim2.new(0.65, -24, 0, 32),
                Position = UDim2.new(0.35, 0, 0, 6.5),
                BackgroundColor3 = Theme.SurfaceVariant,
                BackgroundTransparency = 0.5,
                PlaceholderText = Placeholder,
                PlaceholderColor3 = Theme.TextSecondary,
                Text = "",
                TextColor3 = Theme.Text,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                BorderSizePixel = 0,
                ClearTextOnFocus = false,
                Parent = InputFrame,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = InputBox,
            })
            
            CreateInstance("UIStroke", {
                Color = Theme.Primary,
                Transparency = 0.85,
                Thickness = 1.5,
                Parent = InputBox,
            })
            
            CreateInstance("UIPadding", {
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
                Parent = InputBox,
            })
            
            InputBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    Callback(InputBox.Text)
                end
            end)
            
            InputBox.Focused:Connect(function()
                Tween(InputBox, {BackgroundTransparency = 0.3}, 0.2)
                Tween(InputBox.UIStroke, {Transparency = 0.5}, 0.2)
                Tween(InputFrame.UIStroke, {Transparency = 0.6, Color = Theme.Accent}, 0.2)
            end)
            
            InputBox.FocusLost:Connect(function()
                Tween(InputBox, {BackgroundTransparency = 0.5}, 0.2)
                Tween(InputBox.UIStroke, {Transparency = 0.85}, 0.2)
                Tween(InputFrame.UIStroke, {Transparency = 0.85, Color = Theme.Primary}, 0.2)
            end)
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y + 16)
            
            return InputBox
        end
        
        return Tab
    end
    
    function Window:Notify(config)
        config = config or {}
        local Title = config.Title or "Notification"
        local Content = config.Content or "Ceci est une notification"
        local Duration = config.Duration or 3
        local Type = config.Type or "Info"
        
        local NotificationColor = Theme.Primary
        if Type == "Success" then
            NotificationColor = Theme.Success
        elseif Type == "Warning" then
            NotificationColor = Theme.Warning
        elseif Type == "Error" then
            NotificationColor = Theme.Error
        end
        
        local NotificationFrame = CreateInstance("Frame", {
            Size = UDim2.new(0, 0, 0, 90),
            Position = UDim2.new(1, -330, 1, -110 - (#Window.Notifications * 100)),
            BackgroundColor3 = Theme.Surface,
            BackgroundTransparency = 0.2,
            BorderSizePixel = 0,
            Parent = ScreenGui,
            ClipsDescendants = true,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 12),
            Parent = NotificationFrame,
        })
        
        CreateInstance("UIStroke", {
            Color = NotificationColor,
            Transparency = 0.6,
            Thickness = 2,
            Parent = NotificationFrame,
        })
        
        local NotificationGlow = CreateInstance("ImageLabel", {
            Size = UDim2.new(1, 30, 1, 30),
            Position = UDim2.new(0, -15, 0, -15),
            BackgroundTransparency = 1,
            Image = "rbxassetid://5028857084",
            ImageColor3 = NotificationColor,
            ImageTransparency = 0.8,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(24, 24, 276, 276),
            Parent = NotificationFrame,
            ZIndex = 0,
        })
        
        local AccentBar = CreateInstance("Frame", {
            Size = UDim2.new(0, 5, 1, 0),
            BackgroundColor3 = NotificationColor,
            BorderSizePixel = 0,
            Parent = NotificationFrame,
        })
        
        CreateInstance("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, NotificationColor),
                ColorSequenceKeypoint.new(1, Theme.Secondary),
            }),
            Rotation = 90,
            Parent = AccentBar,
        })
        
        local IconBg = CreateInstance("Frame", {
            Size = UDim2.new(0, 38, 0, 38),
            Position = UDim2.new(0, 15, 0, 12),
            BackgroundColor3 = NotificationColor,
            BackgroundTransparency = 0.85,
            BorderSizePixel = 0,
            Parent = NotificationFrame,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 10),
            Parent = IconBg,
        })
        
        local Icon = CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = Type == "Success" and "✓" or Type == "Warning" and "⚠" or Type == "Error" and "✕" or "ℹ",
            TextColor3 = NotificationColor,
            TextSize = 20,
            Font = Enum.Font.GothamBold,
            Parent = IconBg,
        })
        
        local NotificationTitle = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -100, 0, 28),
            Position = UDim2.new(0, 63, 0, 12),
            BackgroundTransparency = 1,
            Text = Title,
            TextColor3 = Theme.Text,
            TextSize = 15,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = NotificationFrame,
        })
        
        local NotificationContent = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -100, 0, 42),
            Position = UDim2.new(0, 63, 0, 40),
            BackgroundTransparency = 1,
            Text = Content,
            TextColor3 = Theme.TextSecondary,
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = NotificationFrame,
        })
        
        local CloseBtn = CreateInstance("TextButton", {
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(1, -34, 0, 12),
            BackgroundTransparency = 1,
            Text = "✕",
            TextColor3 = Theme.TextSecondary,
            TextSize = 16,
            Font = Enum.Font.GothamBold,
            Parent = NotificationFrame,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = CloseBtn,
        })
        
        table.insert(Window.Notifications, NotificationFrame)
        
        Tween(NotificationFrame, {Size = UDim2.new(0, 320, 0, 90)}, 0.4, Enum.EasingStyle.Back)
        
        CloseBtn.MouseEnter:Connect(function()
            Tween(CloseBtn, {BackgroundTransparency = 0.9}, 0.2)
            CloseBtn.BackgroundColor3 = Theme.Error
        end)
        
        CloseBtn.MouseLeave:Connect(function()
            Tween(CloseBtn, {BackgroundTransparency = 1}, 0.2)
        end)
        
        CloseBtn.MouseButton1Click:Connect(function()
            Tween(NotificationFrame, {Size = UDim2.new(0, 0, 0, 90)}, 0.3)
            wait(0.3)
            NotificationFrame:Destroy()
            for i, notif in pairs(Window.Notifications) do
                if notif == NotificationFrame then
                    table.remove(Window.Notifications, i)
                    break
                end
            end
        end)
        
        spawn(function()
            wait(Duration)
            Tween(NotificationFrame, {Size = UDim2.new(0, 0, 0, 90)}, 0.3)
            wait(0.3)
            NotificationFrame:Destroy()
            for i, notif in pairs(Window.Notifications) do
                if notif == NotificationFrame then
                    table.remove(Window.Notifications, i)
                    break
                end
            end
        end)
    end
    
    return Window
end

return GitanX
