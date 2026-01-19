--// GitanX UI Library v3
--// Multi-theme, Luna-like, glass, premium

local GitanX = {}
GitanX.__index = GitanX

--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

--// THEME ENGINE

local Themes = {
    LunaGlass = {
        Name = "LunaGlass",
        Font = Enum.Font.Gotham,
        FontBold = Enum.Font.GothamBold,

        Background = Color3.fromRGB(10, 12, 18),
        BackgroundAlt = Color3.fromRGB(16, 18, 26),
        BackgroundDeep = Color3.fromRGB(6, 8, 12),

        Accent = Color3.fromRGB(255, 120, 90),
        AccentSoft = Color3.fromRGB(255, 160, 130),
        AccentDark = Color3.fromRGB(180, 70, 50),

        Text = Color3.fromRGB(235, 235, 245),
        TextMuted = Color3.fromRGB(150, 150, 170),

        Outline = Color3.fromRGB(40, 40, 60),
        Shadow = Color3.fromRGB(0, 0, 0),

        Success = Color3.fromRGB(80, 220, 120),
        Warning = Color3.fromRGB(255, 200, 80),
        Error = Color3.fromRGB(255, 80, 80),

        CornerRadius = UDim.new(0, 10),
        SmallCornerRadius = UDim.new(0, 6),

        TransitionSpeed = 0.22,
        HoverSpeed = 0.14,

        GlassEnabled = true,
        BlurIntensity = 12,
    },

    LunaMinimal = {
        Name = "LunaMinimal",
        Font = Enum.Font.Gotham,
        FontBold = Enum.Font.GothamBold,

        Background = Color3.fromRGB(12, 12, 16),
        BackgroundAlt = Color3.fromRGB(18, 18, 24),
        BackgroundDeep = Color3.fromRGB(8, 8, 12),

        Accent = Color3.fromRGB(120, 180, 255),
        AccentSoft = Color3.fromRGB(150, 200, 255),
        AccentDark = Color3.fromRGB(70, 120, 200),

        Text = Color3.fromRGB(235, 235, 245),
        TextMuted = Color3.fromRGB(150, 150, 170),

        Outline = Color3.fromRGB(40, 40, 60),
        Shadow = Color3.fromRGB(0, 0, 0),

        Success = Color3.fromRGB(80, 220, 120),
        Warning = Color3.fromRGB(255, 200, 80),
        Error = Color3.fromRGB(255, 80, 80),

        CornerRadius = UDim.new(0, 8),
        SmallCornerRadius = UDim.new(0, 5),

        TransitionSpeed = 0.18,
        HoverSpeed = 0.12,

        GlassEnabled = false,
        BlurIntensity = 0,
    },

    LunaNeon = {
        Name = "LunaNeon",
        Font = Enum.Font.Gotham,
        FontBold = Enum.Font.GothamBold,

        Background = Color3.fromRGB(8, 8, 16),
        BackgroundAlt = Color3.fromRGB(12, 12, 24),
        BackgroundDeep = Color3.fromRGB(4, 4, 10),

        Accent = Color3.fromRGB(120, 255, 200),
        AccentSoft = Color3.fromRGB(160, 255, 220),
        AccentDark = Color3.fromRGB(60, 200, 160),

        Text = Color3.fromRGB(230, 240, 255),
        TextMuted = Color3.fromRGB(150, 170, 190),

        Outline = Color3.fromRGB(40, 60, 80),
        Shadow = Color3.fromRGB(0, 0, 0),

        Success = Color3.fromRGB(80, 220, 120),
        Warning = Color3.fromRGB(255, 200, 80),
        Error = Color3.fromRGB(255, 80, 80),

        CornerRadius = UDim.new(0, 10),
        SmallCornerRadius = UDim.new(0, 6),

        TransitionSpeed = 0.22,
        HoverSpeed = 0.14,

        GlassEnabled = true,
        BlurIntensity = 10,
    },

    GitanXRedline = {
        Name = "GitanXRedline",
        Font = Enum.Font.Gotham,
        FontBold = Enum.Font.GothamBold,

        Background = Color3.fromRGB(10, 8, 10),
        BackgroundAlt = Color3.fromRGB(18, 10, 14),
        BackgroundDeep = Color3.fromRGB(6, 4, 8),

        Accent = Color3.fromRGB(255, 80, 80),
        AccentSoft = Color3.fromRGB(255, 130, 110),
        AccentDark = Color3.fromRGB(180, 40, 40),

        Text = Color3.fromRGB(240, 230, 235),
        TextMuted = Color3.fromRGB(160, 130, 140),

        Outline = Color3.fromRGB(60, 30, 40),
        Shadow = Color3.fromRGB(0, 0, 0),

        Success = Color3.fromRGB(80, 220, 120),
        Warning = Color3.fromRGB(255, 200, 80),
        Error = Color3.fromRGB(255, 80, 80),

        CornerRadius = UDim.new(0, 10),
        SmallCornerRadius = UDim.new(0, 6),

        TransitionSpeed = 0.22,
        HoverSpeed = 0.14,

        GlassEnabled = true,
        BlurIntensity = 14,
    },

    GitanXFrost = {
        Name = "GitanXFrost",
        Font = Enum.Font.Gotham,
        FontBold = Enum.Font.GothamBold,

        Background = Color3.fromRGB(12, 16, 22),
        BackgroundAlt = Color3.fromRGB(18, 24, 32),
        BackgroundDeep = Color3.fromRGB(8, 12, 18),

        Accent = Color3.fromRGB(140, 200, 255),
        AccentSoft = Color3.fromRGB(180, 220, 255),
        AccentDark = Color3.fromRGB(90, 150, 210),

        Text = Color3.fromRGB(235, 240, 250),
        TextMuted = Color3.fromRGB(160, 170, 190),

        Outline = Color3.fromRGB(50, 70, 90),
        Shadow = Color3.fromRGB(0, 0, 0),

        Success = Color3.fromRGB(80, 220, 120),
        Warning = Color3.fromRGB(255, 200, 80),
        Error = Color3.fromRGB(255, 80, 80),

        CornerRadius = UDim.new(0, 12),
        SmallCornerRadius = UDim.new(0, 8),

        TransitionSpeed = 0.24,
        HoverSpeed = 0.14,

        GlassEnabled = true,
        BlurIntensity = 16,
    },

    GitanXCyberwave = {
        Name = "GitanXCyberwave",
        Font = Enum.Font.Gotham,
        FontBold = Enum.Font.GothamBold,

        Background = Color3.fromRGB(8, 8, 18),
        BackgroundAlt = Color3.fromRGB(14, 10, 30),
        BackgroundDeep = Color3.fromRGB(6, 4, 18),

        Accent = Color3.fromRGB(160, 120, 255),
        AccentSoft = Color3.fromRGB(200, 160, 255),
        AccentDark = Color3.fromRGB(110, 70, 210),

        Text = Color3.fromRGB(235, 230, 255),
        TextMuted = Color3.fromRGB(160, 150, 190),

        Outline = Color3.fromRGB(60, 40, 90),
        Shadow = Color3.fromRGB(0, 0, 0),

        Success = Color3.fromRGB(80, 220, 120),
        Warning = Color3.fromRGB(255, 200, 80),
        Error = Color3.fromRGB(255, 80, 80),

        CornerRadius = UDim.new(0, 10),
        SmallCornerRadius = UDim.new(0, 6),

        TransitionSpeed = 0.2,
        HoverSpeed = 0.12,

        GlassEnabled = true,
        BlurIntensity = 10,
    },
}

local ActiveTheme = Themes.LunaGlass

--// Utils

local function tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function quickTween(obj, time, props)
    return tween(obj, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
end

local function makeDraggable(frame, dragHandle)
    dragHandle = dragHandle or frame
    local dragging = false
    local dragStart, startPos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    dragHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function createCorner(radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = radius or ActiveTheme.CornerRadius
    return c
end

local function createStroke(color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or ActiveTheme.Outline
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0.2
    return s
end

local function createPadding(pad)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, pad)
    p.PaddingRight = UDim.new(0, pad)
    p.PaddingTop = UDim.new(0, pad)
    p.PaddingBottom = UDim.new(0, pad)
    return p
end

local function createList(direction, padding)
    local l = Instance.new("UIListLayout")
    l.FillDirection = direction or Enum.FillDirection.Vertical
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Padding = UDim.new(0, padding or 6)
    return l
end

local function createTextLabel(parent, text, size, bold, color)
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Font = bold and ActiveTheme.FontBold or ActiveTheme.Font
    lbl.Text = text or ""
    lbl.TextSize = size or 14
    lbl.TextColor3 = color or ActiveTheme.Text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Center
    lbl.Parent = parent
    return lbl
end

local function ripple(button, x, y)
    local circle = Instance.new("Frame")
    circle.BackgroundColor3 = ActiveTheme.AccentSoft
    circle.BackgroundTransparency = 0.6
    circle.Size = UDim2.new(0, 0, 0, 0)
    circle.Position = UDim2.new(0, x, 0, y)
    circle.AnchorPoint = Vector2.new(0.5, 0.5)
    circle.ZIndex = button.ZIndex + 1
    circle.Parent = button

    createCorner(UDim.new(1, 0)).Parent = circle

    quickTween(circle, 0.4, {
        Size = UDim2.new(0, 180, 0, 180),
        BackgroundTransparency = 1
    })

    task.delay(0.4, function()
        circle:Destroy()
    end)
end

local function createButtonBase(parent, height)
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = ActiveTheme.BackgroundAlt
    btn.AutoButtonColor = false
    btn.Text = ""
    btn.Size = UDim2.new(1, 0, 0, height or 32)
    btn.Parent = parent

    createCorner(ActiveTheme.SmallCornerRadius).Parent = btn
    createStroke(ActiveTheme.Outline, 1, 0.45).Parent = btn

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 220))
    })
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.96),
        NumberSequenceKeypoint.new(1, 1)
    })
    gradient.Rotation = 90
    gradient.Parent = btn

    local hover = Instance.new("Frame")
    hover.BackgroundColor3 = ActiveTheme.Accent
    hover.BackgroundTransparency = 1
    hover.Size = UDim2.new(1, 0, 1, 0)
    hover.ZIndex = 0
    hover.Parent = btn
    createCorner(ActiveTheme.SmallCornerRadius).Parent = hover

    btn.MouseEnter:Connect(function()
        quickTween(hover, ActiveTheme.HoverSpeed, {BackgroundTransparency = 0.9})
    end)

    btn.MouseLeave:Connect(function()
        quickTween(hover, ActiveTheme.HoverSpeed, {BackgroundTransparency = 1})
    end)

    return btn
end

--// Notification Manager

local NotificationManager = {}
NotificationManager.__index = NotificationManager

function NotificationManager.new(screenGui)
    local self = setmetatable({}, NotificationManager)

    local holder = Instance.new("Frame")
    holder.BackgroundTransparency = 1
    holder.Size = UDim2.new(0, 320, 1, -80)
    holder.Position = UDim2.new(1, -340, 0, 40)
    holder.AnchorPoint = Vector2.new(0, 0)
    holder.Parent = screenGui

    local list = createList(Enum.FillDirection.Vertical, 8)
    list.HorizontalAlignment = Enum.HorizontalAlignment.Right
    list.VerticalAlignment = Enum.VerticalAlignment.Top
    list.Parent = holder

    self.Holder = holder
    self.List = list

    return self
end

function NotificationManager:Notify(title, message, duration, kind)
    duration = duration or 4
    kind = kind or "Info"

    local color = ActiveTheme.Accent
    if kind == "Success" then
        color = ActiveTheme.Success
    elseif kind == "Warning" then
        color = ActiveTheme.Warning
    elseif kind == "Error" then
        color = ActiveTheme.Error
    end

    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = ActiveTheme.BackgroundAlt
    frame.BackgroundTransparency = 0.1
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.Position = UDim2.new(1, 320, 0, 0)
    frame.Parent = self.Holder
    frame.ClipsDescendants = true

    createCorner(ActiveTheme.CornerRadius).Parent = frame
    createStroke(ActiveTheme.Outline, 1, 0.35).Parent = frame
    createPadding(10).Parent = frame

    local bar = Instance.new("Frame")
    bar.BackgroundColor3 = color
    bar.Size = UDim2.new(1, 0, 0, 3)
    bar.Position = UDim2.new(0, 0, 1, -3)
    bar.Parent = frame
    createCorner(UDim.new(0, 3)).Parent = bar

    local titleLbl = createTextLabel(frame, title or "Notification", 14, true, ActiveTheme.Text)
    titleLbl.Size = UDim2.new(1, -10, 0, 18)
    titleLbl.Position = UDim2.new(0, 8, 0, 2)

    local msgLbl = createTextLabel(frame, message or "", 13, false, ActiveTheme.TextMuted)
    msgLbl.Size = UDim2.new(1, -10, 0, 32)
    msgLbl.Position = UDim2.new(0, 8, 0, 20)
    msgLbl.TextWrapped = true
    msgLbl.TextYAlignment = Enum.TextYAlignment.Top

    quickTween(frame, ActiveTheme.TransitionSpeed, {
        Size = UDim2.new(1, 0, 0, 60),
        Position = UDim2.new(0, 0, 0, 0)
    })

    task.spawn(function()
        local startTime = tick()
        while tick() - startTime < duration do
            local alpha = 1 - ((tick() - startTime) / duration)
            bar.Size = UDim2.new(alpha, 0, 0, 3)
            RunService.RenderStepped:Wait()
        end
        quickTween(frame, ActiveTheme.TransitionSpeed, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
        task.wait(ActiveTheme.TransitionSpeed + 0.05)
        frame:Destroy()
    end)
end

--// Tab / Section

local Tab = {}
Tab.__index = Tab

function Tab:CreateSection(name)
    local section = {}
    section.__index = section

    local container = Instance.new("Frame")
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.Parent = self.Scroll

    local titleLbl = createTextLabel(container, name or "Section", 14, true, ActiveTheme.TextMuted)
    titleLbl.Size = UDim2.new(1, -4, 0, 18)
    titleLbl.Position = UDim2.new(0, 2, 0, 0)

    local holder = Instance.new("Frame")
    holder.BackgroundColor3 = ActiveTheme.BackgroundDeep
    holder.BackgroundTransparency = 0.05
    holder.Size = UDim2.new(1, 0, 0, 0)
    holder.Position = UDim2.new(0, 0, 0, 22)
    holder.AutomaticSize = Enum.AutomaticSize.Y
    holder.Parent = container

    createCorner(ActiveTheme.CornerRadius).Parent = holder
    createStroke(ActiveTheme.Outline, 1, 0.5).Parent = holder
    createPadding(10).Parent = holder

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 210, 230))
    })
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.96),
        NumberSequenceKeypoint.new(1, 1)
    })
    gradient.Rotation = 90
    gradient.Parent = holder

    local innerShadow = Instance.new("ImageLabel")
    innerShadow.BackgroundTransparency = 1
    innerShadow.Image = "rbxassetid://5028857084"
    innerShadow.ImageColor3 = ActiveTheme.Shadow
    innerShadow.ImageTransparency = 0.85
    innerShadow.ScaleType = Enum.ScaleType.Slice
    innerShadow.SliceCenter = Rect.new(24, 24, 276, 276)
    innerShadow.Size = UDim2.new(1, 12, 1, 12)
    innerShadow.Position = UDim2.new(0, -6, 0, -6)
    innerShadow.ZIndex = holder.ZIndex - 1
    innerShadow.Parent = holder

    local list = createList(Enum.FillDirection.Vertical, 6)
    list.Parent = holder

    section.Container = container
    section.Holder = holder
    section.List = list
    section.Tab = self

    -- Label
    function section:CreateLabel(text)
        local lbl = createTextLabel(self.Holder, text or "Label", 14, false, ActiveTheme.Text)
        lbl.Size = UDim2.new(1, -4, 0, 18)
        lbl.TextWrapped = true
        return lbl
    end

    -- Button
    function section:CreateButton(options)
        options = options or {}
        local name = options.Name or "Button"
        local callback = options.Callback or function() end

        local btn = createButtonBase(self.Holder, 30)

        local lbl = createTextLabel(btn, name, 14, false, ActiveTheme.Text)
        lbl.Size = UDim2.new(1, -16, 1, 0)
        lbl.Position = UDim2.new(0, 8, 0, 0)

        btn.MouseButton1Click:Connect(function(x, y)
            ripple(btn, x - btn.AbsolutePosition.X, y - btn.AbsolutePosition.Y)
            quickTween(btn, 0.08, {BackgroundColor3 = ActiveTheme.Background})
            task.delay(0.08, function()
                quickTween(btn, 0.16, {BackgroundColor3 = ActiveTheme.BackgroundAlt})
            end)
            task.spawn(callback)
        end)

        return btn
    end

    -- Toggle
    function section:CreateToggle(options)
        options = options or {}
        local name = options.Name or "Toggle"
        local default = options.CurrentValue or false
        local callback = options.Callback or function() end

        local holder = Instance.new("Frame")
        holder.BackgroundTransparency = 1
        holder.Size = UDim2.new(1, 0, 0, 30)
        holder.Parent = self.Holder

        local lbl = createTextLabel(holder, name, 14, false, ActiveTheme.Text)
        lbl.Size = UDim2.new(1, -60, 1, 0)
        lbl.Position = UDim2.new(0, 2, 0, 0)

        local toggleBtn = Instance.new("TextButton")
        toggleBtn.BackgroundColor3 = ActiveTheme.BackgroundAlt
        toggleBtn.AutoButtonColor = false
        toggleBtn.Text = ""
        toggleBtn.Size = UDim2.new(0, 40, 0, 20)
        toggleBtn.Position = UDim2.new(1, -44, 0.5, -10)
        toggleBtn.AnchorPoint = Vector2.new(0, 0)
        toggleBtn.Parent = holder

        createCorner(UDim.new(1, 0)).Parent = toggleBtn
        createStroke(ActiveTheme.Outline, 1, 0.4).Parent = toggleBtn

        local knob = Instance.new("Frame")
        knob.BackgroundColor3 = ActiveTheme.Text
        knob.Size = UDim2.new(0, 16, 0, 16)
        knob.Position = UDim2.new(0, 2, 0.5, -8)
        knob.Parent = toggleBtn
        createCorner(UDim.new(1, 0)).Parent = knob

        local glow = Instance.new("ImageLabel")
        glow.BackgroundTransparency = 1
        glow.Image = "rbxassetid://5028857084"
        glow.ImageColor3 = ActiveTheme.Accent
        glow.ImageTransparency = 1
        glow.ScaleType = Enum.ScaleType.Slice
        glow.SliceCenter = Rect.new(24, 24, 276, 276)
        glow.Size = UDim2.new(1.4, 0, 1.8, 0)
        glow.Position = UDim2.new(-0.2, 0, -0.4, 0)
        glow.ZIndex = toggleBtn.ZIndex - 1
        glow.Parent = toggleBtn

        local state = default

        local function refresh(animated)
            local targetColor = state and ActiveTheme.Accent or ActiveTheme.BackgroundAlt
            local targetPos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            local glowTransparency = state and 0.85 or 1

            if animated then
                tween(toggleBtn, TweenInfo.new(ActiveTheme.TransitionSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = targetColor
                })
                tween(knob, TweenInfo.new(ActiveTheme.TransitionSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Position = targetPos
                })
                tween(glow, TweenInfo.new(ActiveTheme.TransitionSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    ImageTransparency = glowTransparency
                })
            else
                toggleBtn.BackgroundColor3 = targetColor
                knob.Position = targetPos
                glow.ImageTransparency = glowTransparency
            end
        end

        refresh(false)
        task.spawn(function()
            callback(state)
        end)

        toggleBtn.MouseButton1Click:Connect(function()
            state = not state
            refresh(true)
            task.spawn(callback, state)
        end)

        local toggleObject = {}

        function toggleObject:Set(value)
            state = value and true or false
            refresh(true)
            task.spawn(callback, state)
        end

        function toggleObject:Get()
            return state
        end

        return toggleObject
    end

    -- Slider
    function section:CreateSlider(options)
        options = options or {}
        local name = options.Name or "Slider"
        local min = options.Min or 0
        local max = options.Max or 100
        local default = options.CurrentValue or min
        local callback = options.Callback or function() end

        local holder = Instance.new("Frame")
        holder.BackgroundTransparency = 1
        holder.Size = UDim2.new(1, 0, 0, 46)
        holder.Parent = self.Holder

        local lbl = createTextLabel(holder, name, 14, false, ActiveTheme.Text)
        lbl.Size = UDim2.new(1, -60, 0, 18)
        lbl.Position = UDim2.new(0, 2, 0, 0)

        local valueLbl = createTextLabel(holder, tostring(default), 13, false, ActiveTheme.TextMuted)
        valueLbl.Size = UDim2.new(0, 60, 0, 18)
        valueLbl.Position = UDim2.new(1, -62, 0, 0)
        valueLbl.TextXAlignment = Enum.TextXAlignment.Right

        local bar = Instance.new("Frame")
        bar.BackgroundColor3 = ActiveTheme.BackgroundAlt
        bar.Size = UDim2.new(1, -4, 0, 6)
        bar.Position = UDim2.new(0, 2, 0, 24)
        bar.Parent = holder
        createCorner(UDim.new(0, 3)).Parent = bar

        local barGradient = Instance.new("UIGradient")
        barGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 210, 230))
        })
        barGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.96),
            NumberSequenceKeypoint.new(1, 1)
        })
        barGradient.Rotation = 90
        barGradient.Parent = bar

        local fill = Instance.new("Frame")
        fill.BackgroundColor3 = ActiveTheme.Accent
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.Parent = bar
        createCorner(UDim.new(0, 3)).Parent = fill

        local handle = Instance.new("Frame")
        handle.BackgroundColor3 = ActiveTheme.Background
        handle.Size = UDim2.new(0, 14, 0, 14)
        handle.Position = UDim2.new(0, -7, 0.5, -7)
        handle.Parent = bar
        createCorner(UDim.new(1, 0)).Parent = handle
        createStroke(ActiveTheme.Accent, 1, 0.1).Parent = handle

        local handleGlow = Instance.new("ImageLabel")
        handleGlow.BackgroundTransparency = 1
        handleGlow.Image = "rbxassetid://5028857084"
        handleGlow.ImageColor3 = ActiveTheme.Accent
        handleGlow.ImageTransparency = 0.8
        handleGlow.ScaleType = Enum.ScaleType.Slice
        handleGlow.SliceCenter = Rect.new(24, 24, 276, 276)
        handleGlow.Size = UDim2.new(2, 0, 2, 0)
        handleGlow.Position = UDim2.new(-0.5, 0, -0.5, 0)
        handleGlow.ZIndex = handle.ZIndex - 1
        handleGlow.Parent = handle

        local dragging = false
        local value = default

        local function setValueFromX(x, animated)
            local rel = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local v = math.floor(min + (max - min) * rel + 0.5)
            value = v
            valueLbl.Text = tostring(v)

            local targetFill = UDim2.new(rel, 0, 1, 0)
            local targetHandle = UDim2.new(rel, -7, 0.5, -7)

            if animated then
                tween(fill, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = targetFill
                })
                tween(handle, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Position = targetHandle
                })
            else
                fill.Size = targetFill
                handle.Position = targetHandle
            end

            task.spawn(callback, v)
        end

        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                setValueFromX(input.Position.X, true)
            end
        end)

        bar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                setValueFromX(input.Position.X, false)
            end
        end)

        local sliderObject = {}

        function sliderObject:Set(v)
            v = math.clamp(v, min, max)
            local rel = (v - min) / (max - min)
            value = v
            valueLbl.Text = tostring(v)

            local targetFill = UDim2.new(rel, 0, 1, 0)
            local targetHandle = UDim2.new(rel, -7, 0.5, -7)

            tween(fill, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = targetFill
            })
            tween(handle, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = targetHandle
            })

            task.spawn(callback, v)
        end

        function sliderObject:Get()
            return value
        end

        sliderObject:Set(default)

        return sliderObject
    end

    -- Dropdown
    function section:CreateDropdown(options)
        options = options or {}
        local name = options.Name or "Dropdown"
        local list = options.Options or {}
        local default = options.CurrentOption or list[1]
        local callback = options.Callback or function() end

        local holder = Instance.new("Frame")
        holder.BackgroundTransparency = 1
        holder.Size = UDim2.new(1, 0, 0, 36)
        holder.Parent = self.Holder

        local lbl = createTextLabel(holder, name, 14, false, ActiveTheme.Text)
        lbl.Size = UDim2.new(1, -4, 0, 18)
        lbl.Position = UDim2.new(0, 2, 0, 0)

        local btn = createButtonBase(holder, 22)
        btn.Size = UDim2.new(1, -4, 0, 22)
        btn.Position = UDim2.new(0, 2, 0, 18)

        local valueLbl = createTextLabel(btn, default or "Select", 13, false, ActiveTheme.TextMuted)
        valueLbl.Size = UDim2.new(1, -20, 1, 0)
        valueLbl.Position = UDim2.new(0, 8, 0, 0)

        local arrow = createTextLabel(btn, "▼", 12, false, ActiveTheme.TextMuted)
        arrow.Size = UDim2.new(0, 16, 1, 0)
        arrow.Position = UDim2.new(1, -18, 0, 0)
        arrow.TextXAlignment = Enum.TextXAlignment.Center

        local open = false
        local dropdownFrame

        local function closeDropdown()
            if dropdownFrame then
                quickTween(dropdownFrame, ActiveTheme.TransitionSpeed, {Size = UDim2.new(1, 0, 0, 0)})
                task.delay(ActiveTheme.TransitionSpeed + 0.05, function()
                    if dropdownFrame then
                        dropdownFrame:Destroy()
                        dropdownFrame = nil
                    end
                end)
            end
            open = false
            arrow.Text = "▼"
        end

        local function openDropdown()
            if open then
                closeDropdown()
                return
            end
            open = true
            arrow.Text = "▲"

            dropdownFrame = Instance.new("Frame")
            dropdownFrame.BackgroundColor3 = ActiveTheme.BackgroundDeep
            dropdownFrame.Size = UDim2.new(1, 0, 0, 0)
            dropdownFrame.Position = UDim2.new(0, 0, 1, 2)
            dropdownFrame.Parent = btn
            dropdownFrame.ClipsDescendants = true

            createCorner(ActiveTheme.CornerRadius).Parent = dropdownFrame
            createStroke(ActiveTheme.Outline, 1, 0.4).Parent = dropdownFrame

            local listLayout = createList(Enum.FillDirection.Vertical, 0)
            listLayout.Parent = dropdownFrame

            local totalHeight = 0

            for _, opt in ipairs(list) do
                local optBtn = Instance.new("TextButton")
                optBtn.BackgroundColor3 = ActiveTheme.BackgroundDeep
                optBtn.AutoButtonColor = false
                optBtn.Text = ""
                optBtn.Size = UDim2.new(1, 0, 0, 22)
                optBtn.Parent = dropdownFrame

                local optLbl = createTextLabel(optBtn, tostring(opt), 13, false, ActiveTheme.Text)
                optLbl.Size = UDim2.new(1, -10, 1, 0)
                optLbl.Position = UDim2.new(0, 6, 0, 0)

                optBtn.MouseEnter:Connect(function()
                    quickTween(optBtn, ActiveTheme.HoverSpeed, {BackgroundColor3 = ActiveTheme.BackgroundAlt})
                end)

                optBtn.MouseLeave:Connect(function()
                    quickTween(optBtn, ActiveTheme.HoverSpeed, {BackgroundColor3 = ActiveTheme.BackgroundDeep})
                end)

                optBtn.MouseButton1Click:Connect(function()
                    valueLbl.Text = tostring(opt)
                    valueLbl.TextColor3 = ActiveTheme.Text
                    task.spawn(callback, opt)
                    closeDropdown()
                end)

                totalHeight = totalHeight + 22
            end

            quickTween(dropdownFrame, ActiveTheme.TransitionSpeed, {Size = UDim2.new(1, 0, 0, math.min(totalHeight, 150))})
        end

        btn.MouseButton1Click:Connect(function()
            openDropdown()
        end)

        local dropdownObject = {}

        function dropdownObject:SetOptions(newList)
            list = newList or {}
            if open then
                closeDropdown()
            end
        end

        function dropdownObject:Set(option)
            valueLbl.Text = tostring(option)
            valueLbl.TextColor3 = ActiveTheme.Text
            task.spawn(callback, option)
        end

        function dropdownObject:Get()
            return valueLbl.Text
        end

        if default then
            dropdownObject:Set(default)
        end

        return dropdownObject
    end

    -- Keybind
    function section:CreateKeybind(options)
        options = options or {}
        local name = options.Name or "Keybind"
        local default = options.CurrentKey or Enum.KeyCode.F
        local callback = options.Callback or function() end

        local holder = Instance.new("Frame")
        holder.BackgroundTransparency = 1
        holder.Size = UDim2.new(1, 0, 0, 30)
        holder.Parent = self.Holder

        local lbl = createTextLabel(holder, name, 14, false, ActiveTheme.Text)
        lbl.Size = UDim2.new(1, -80, 1, 0)
        lbl.Position = UDim2.new(0, 2, 0, 0)

        local btn = createButtonBase(holder, 22)
        btn.Size = UDim2.new(0, 70, 0, 22)
        btn.Position = UDim2.new(1, -72, 0.5, -11)

        local keyLbl = createTextLabel(btn, default.Name, 13, false, ActiveTheme.TextMuted)
        keyLbl.Size = UDim2.new(1, -4, 1, 0)
        keyLbl.Position = UDim2.new(0, 2, 0, 0)
        keyLbl.TextXAlignment = Enum.TextXAlignment.Center

        local binding = false
        local currentKey = default

        btn.MouseButton1Click:Connect(function()
            if not binding then
                binding = true
                keyLbl.Text = "..."
                keyLbl.TextColor3 = ActiveTheme.Accent
            end
        end)

        UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if binding then
                if input.KeyCode ~= Enum.KeyCode.Unknown then
                    currentKey = input.KeyCode
                    keyLbl.Text = currentKey.Name
                    keyLbl.TextColor3 = ActiveTheme.Text
                    binding = false
                end
            else
                if input.KeyCode == currentKey then
                    task.spawn(callback)
                end
            end
        end)

        local keyObject = {}

        function keyObject:Set(keycode)
            currentKey = keycode
            keyLbl.Text = keycode.Name
            keyLbl.TextColor3 = ActiveTheme.Text
        end

        function keyObject:Get()
            return currentKey
        end

        return keyObject
    end

    return setmetatable(section, section)
end

--// Window

local Window = {}
Window.__index = Window

function Window:CreateTab(name)
    local tab = setmetatable({}, Tab)

    local tabButton = createButtonBase(self.TabHolder, 28)
    tabButton.Size = UDim2.new(1, 0, 0, 28)

    local lbl = createTextLabel(tabButton, name or "Tab", 14, false, ActiveTheme.TextMuted)
    lbl.Size = UDim2.new(1, -10, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)

    local indicator = Instance.new("Frame")
    indicator.BackgroundColor3 = ActiveTheme.Accent
    indicator.Size = UDim2.new(0, 3, 1, 0)
    indicator.Position = UDim2.new(0, -3, 0, 0)
    indicator.Visible = false
    indicator.Parent = tabButton
    createCorner(UDim.new(0, 3)).Parent = indicator

    local content = Instance.new("ScrollingFrame")
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 3
    content.ScrollBarImageColor3 = ActiveTheme.AccentSoft
    content.Size = UDim2.new(1, -140, 1, -50)
    content.Position = UDim2.new(0, 140, 0, 40)
    content.Visible = false
    content.Parent = self.Main

    local list = createList(Enum.FillDirection.Vertical, 8)
    list.Parent = content

    local padding = createPadding(10)
    padding.Parent = content

    tab.Button = tabButton
    tab.Label = lbl
    tab.Content = content
    tab.Scroll = content
    tab.Window = self
    tab.Indicator = indicator

    table.insert(self.Tabs, tab)

    local function selectTab()
        for _, t in ipairs(self.Tabs) do
            t.Content.Visible = false
            quickTween(t.Label, ActiveTheme.TransitionSpeed, {TextColor3 = ActiveTheme.TextMuted})
            t.Indicator.Visible = false
        end
        content.Visible = true
        quickTween(lbl, ActiveTheme.TransitionSpeed, {TextColor3 = ActiveTheme.Accent})
        indicator.Visible = true
    end

    tabButton.MouseButton1Click:Connect(function(x, y)
        ripple(tabButton, x - tabButton.AbsolutePosition.X, y - tabButton.AbsolutePosition.Y)
        selectTab()
    end)

    if #self.Tabs == 1 then
        selectTab()
    end

    return tab
end

--// THEME SWITCHING

local function applyThemeToWindow(window)
    if not window or not window.Root then return end

    local t = ActiveTheme

    quickTween(window.Root, 0.25, {BackgroundColor3 = t.Background})
    if window.Main then
        quickTween(window.Main, 0.25, {BackgroundColor3 = t.Background})
    end
    if window.Topbar then
        quickTween(window.Topbar, 0.25, {BackgroundColor3 = t.BackgroundAlt})
    end
end

function GitanX:SetTheme(themeName)
    local theme = Themes[themeName]
    if not theme then
        warn("[GitanX] Theme not found:", themeName)
        return
    end

    ActiveTheme = theme
    if self._windows then
        for _, w in ipairs(self._windows) do
            applyThemeToWindow(w)
        end
    end
end

function GitanX:GetThemes()
    local list = {}
    for name, _ in pairs(Themes) do
        table.insert(list, name)
    end
    table.sort(list)
    return list
end

--// GitanX:CreateWindow

function GitanX:CreateWindow(options)
    options = options or {}
    local name = options.Name or "GitanX"
    local subtitle = options.Subtitle or "UI Library"

    if not self._windows then
        self._windows = {}
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GitanX_UI"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = gethui and gethui() or game.CoreGui

    local main = Instance.new("Frame")
    main.BackgroundColor3 = ActiveTheme.Background
    main.BackgroundTransparency = ActiveTheme.GlassEnabled and 0.05 or 0
    main.Size = UDim2.new(0, 650, 0, 420)
    main.Position = UDim2.new(0.5, -325, 0.5, -210)
    main.ClipsDescendants = true
    main.Parent = screenGui

    createCorner(ActiveTheme.CornerRadius).Parent = main
    createStroke(ActiveTheme.Outline, 1, 0.5).Parent = main

    local shadow = Instance.new("ImageLabel")
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5028857084"
    shadow.ImageColor3 = ActiveTheme.Shadow
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(24, 24, 276, 276)
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.ZIndex = 0
    shadow.Parent = main

    local topbar = Instance.new("Frame")
    topbar.BackgroundColor3 = ActiveTheme.BackgroundAlt
    topbar.Size = UDim2.new(1, 0, 0, 38)
    topbar.Parent = main
    createCorner(UDim.new(0, 10)).Parent = topbar
    createStroke(ActiveTheme.Outline, 1, 0.5).Parent = topbar

    local accentBar = Instance.new("Frame")
    accentBar.BackgroundColor3 = ActiveTheme.Accent
    accentBar.Size = UDim2.new(0, 0, 0, 2)
    accentBar.Position = UDim2.new(0, 0, 1, -2)
    accentBar.Parent = topbar
    quickTween(accentBar, 0.4, {Size = UDim2.new(1, 0, 0, 2)})

    local titleLbl = createTextLabel(topbar, name, 16, true, ActiveTheme.Text)
    titleLbl.Size = UDim2.new(0.5, -10, 1, 0)
    titleLbl.Position = UDim2.new(0, 12, 0, 0)

    local subLbl = createTextLabel(topbar, subtitle, 13, false, ActiveTheme.TextMuted)
    subLbl.Size = UDim2.new(0.5, -10, 1, 0)
    subLbl.Position = UDim2.new(0, 12, 0, 18)

    local closeBtn = createButtonBase(topbar, 22)
    closeBtn.Size = UDim2.new(0, 26, 0, 22)
    closeBtn.Position = UDim2.new(1, -30, 0.5, -11)

    local closeLbl = createTextLabel(closeBtn, "X", 13, true, ActiveTheme.Error)
    closeLbl.Size = UDim2.new(1, 0, 1, 0)
    closeLbl.Position = UDim2.new(0, 0, 0, 0)
    closeLbl.TextXAlignment = Enum.TextXAlignment.Center

    closeBtn.MouseButton1Click:Connect(function(x, y)
        ripple(closeBtn, x - closeBtn.AbsolutePosition.X, y - closeBtn.AbsolutePosition.Y)
        quickTween(main, ActiveTheme.TransitionSpeed, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1})
        task.delay(ActiveTheme.TransitionSpeed + 0.05, function()
            screenGui:Destroy()
        end)
    end)

    local leftPanel = Instance.new("Frame")
    leftPanel.BackgroundColor3 = ActiveTheme.BackgroundDeep
    leftPanel.BackgroundTransparency = 0.05
    leftPanel.Size = UDim2.new(0, 140, 1, -40)
    leftPanel.Position = UDim2.new(0, 0, 0, 38)
    leftPanel.Parent = main
    createStroke(ActiveTheme.Outline, 1, 0.5).Parent = leftPanel

    local leftPadding = createPadding(10)
    leftPadding.Parent = leftPanel

    local tabHolder = Instance.new("Frame")
    tabHolder.BackgroundTransparency = 1
    tabHolder.Size = UDim2.new(1, 0, 1, -20)
    tabHolder.Position = UDim2.new(0, 0, 0, 10)
    tabHolder.Parent = leftPanel

    local tabList = createList(Enum.FillDirection.Vertical, 6)
    tabList.Parent = tabHolder

    local mainContent = Instance.new("Frame")
    mainContent.BackgroundColor3 = ActiveTheme.Background
    mainContent.BackgroundTransparency = 0.02
    mainContent.Size = UDim2.new(1, -140, 1, -40)
    mainContent.Position = UDim2.new(0, 140, 0, 38)
    mainContent.Parent = main
    createStroke(ActiveTheme.Outline, 1, 0.5).Parent = mainContent

    local notifManager = NotificationManager.new(screenGui)

    makeDraggable(main, topbar)

    quickTween(main, 0.25, {Size = UDim2.new(0, 650, 0, 420)})

    local window = setmetatable({}, Window)
    window.ScreenGui = screenGui
    window.Main = mainContent
    window.Root = main
    window.Topbar = topbar
    window.TabHolder = tabHolder
    window.Tabs = {}
    window.Notify = function(_, title, msg, duration, kind)
        notifManager:Notify(title, msg, duration, kind)
    end

    table.insert(self._windows, window)

    -- Optional: Settings tab pour changer de thème
    if options.WithThemeTab then
        local themeTab = window:CreateTab("Settings")
        local section = themeTab:CreateSection("Theme")

        local themesList = self:GetThemes()
        section:CreateDropdown({
            Name = "UI Theme",
            Options = themesList,
            CurrentOption = ActiveTheme.Name,
            Callback = function(themeName)
                self:SetTheme(themeName)
            end
        })
    end

    return window
end

--// API

function GitanX.CreateWindow(options)
    local selfObj = setmetatable(GitanX, GitanX)
    return selfObj:CreateWindow(options)
end

return GitanX
