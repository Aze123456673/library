-- GitanX UI Library
-- Bibliothèque d'interface utilisateur moderne pour Roblox
-- Inspirée de Luna Interface Suite

local GitanX = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Couleurs du thème
local Theme = {
	Background = Color3.fromRGB(20, 20, 25),
	Secondary = Color3.fromRGB(25, 25, 30),
	Accent = Color3.fromRGB(88, 101, 242),
	Text = Color3.fromRGB(255, 255, 255),
	SubText = Color3.fromRGB(180, 180, 190),
	Border = Color3.fromRGB(40, 40, 50),
	Success = Color3.fromRGB(67, 181, 129),
	Warning = Color3.fromRGB(250, 166, 26),
	Error = Color3.fromRGB(237, 66, 69)
}

-- Fonction d'animation
local function Tween(obj, props, duration, style, direction)
	duration = duration or 0.3
	style = style or Enum.EasingStyle.Quad
	direction = direction or Enum.EasingDirection.Out
	
	local tween = TweenService:Create(obj, TweenInfo.new(duration, style, direction), props)
	tween:Play()
	return tween
end

-- Fonction de création d'éléments UI
local function Create(class, props)
	local obj = Instance.new(class)
	for k, v in pairs(props) do
		if k ~= "Parent" then
			obj[k] = v
		end
	end
	if props.Parent then
		obj.Parent = props.Parent
	end
	return obj
end

-- Fonction pour créer des coins arrondis
local function AddCorner(parent, radius)
	return Create("UICorner", {
		CornerRadius = UDim.new(0, radius or 8),
		Parent = parent
	})
end

-- Fonction pour créer un contour
local function AddStroke(parent, color, thickness)
	return Create("UIStroke", {
		Color = color or Theme.Border,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = parent
	})
end

-- Fonction pour rendre un élément draggable
local function MakeDraggable(frame, handle)
	local dragging = false
	local dragInput, mousePos, framePos
	
	handle = handle or frame
	
	handle.InputBegan:Connect(function(input)
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
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	
	RunService.Heartbeat:Connect(function()
		if dragging and dragInput then
			local delta = dragInput.Position - mousePos
			Tween(frame, {Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)}, 0.1)
		end
	end)
end

-- Fonction de notification
function GitanX:Notification(settings)
	settings = settings or {}
	local Title = settings.Title or "Notification"
	local Content = settings.Content or "Contenu de la notification"
	local Duration = settings.Duration or 5
	local Icon = settings.Icon or "bell"
	
	local NotifContainer = Create("ScreenGui", {
		Name = "GitanXNotification",
		Parent = CoreGui,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	})
	
	local Notif = Create("Frame", {
		Size = UDim2.new(0, 350, 0, 0),
		Position = UDim2.new(1, -370, 1, 20),
		BackgroundColor3 = Theme.Secondary,
		BorderSizePixel = 0,
		Parent = NotifContainer
	})
	AddCorner(Notif, 10)
	AddStroke(Notif, Theme.Accent, 2)
	
	local IconLabel = Create("TextLabel", {
		Size = UDim2.new(0, 40, 0, 40),
		Position = UDim2.new(0, 10, 0, 10),
		BackgroundTransparency = 1,
		Text = "🔔",
		TextColor3 = Theme.Accent,
		TextSize = 24,
		Font = Enum.Font.GothamBold,
		Parent = Notif
	})
	
	local TitleLabel = Create("TextLabel", {
		Size = UDim2.new(1, -70, 0, 25),
		Position = UDim2.new(0, 60, 0, 10),
		BackgroundTransparency = 1,
		Text = Title,
		TextColor3 = Theme.Text,
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Notif
	})
	
	local ContentLabel = Create("TextLabel", {
		Size = UDim2.new(1, -70, 1, -45),
		Position = UDim2.new(0, 60, 0, 35),
		BackgroundTransparency = 1,
		Text = Content,
		TextColor3 = Theme.SubText,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		Parent = Notif
	})
	
	-- Animation d'entrée
	Tween(Notif, {Size = UDim2.new(0, 350, 0, 100), Position = UDim2.new(1, -370, 1, -120)}, 0.5, Enum.EasingStyle.Back)
	
	-- Fermeture automatique
	task.wait(Duration)
	Tween(Notif, {Position = UDim2.new(1, -370, 1, 20)}, 0.3)
	task.wait(0.3)
	NotifContainer:Destroy()
end

-- Fonction pour créer une fenêtre
function GitanX:CreateWindow(settings)
	settings = settings or {}
	local WindowName = settings.Name or "GitanX UI"
	local Subtitle = settings.Subtitle or ""
	local LoadingEnabled = settings.LoadingEnabled or false
	local LoadingTitle = settings.LoadingTitle or "GitanX Interface"
	local LoadingSubtitle = settings.LoadingSubtitle or "Chargement en cours..."
	
	local ScreenGui = Create("ScreenGui", {
		Name = "GitanXUI",
		Parent = CoreGui,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn = false
	})
	
	-- Écran de chargement
	if LoadingEnabled then
		local LoadingFrame = Create("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Theme.Background,
			BorderSizePixel = 0,
			Parent = ScreenGui
		})
		
		local LoadingText = Create("TextLabel", {
			Size = UDim2.new(0, 400, 0, 50),
			Position = UDim2.new(0.5, -200, 0.5, -50),
			BackgroundTransparency = 1,
			Text = LoadingTitle,
			TextColor3 = Theme.Text,
			TextSize = 32,
			Font = Enum.Font.GothamBold,
			Parent = LoadingFrame
		})
		
		local LoadingSubText = Create("TextLabel", {
			Size = UDim2.new(0, 400, 0, 30),
			Position = UDim2.new(0.5, -200, 0.5, 10),
			BackgroundTransparency = 1,
			Text = LoadingSubtitle,
			TextColor3 = Theme.SubText,
			TextSize = 16,
			Font = Enum.Font.Gotham,
			Parent = LoadingFrame
		})
		
		local LoadingBar = Create("Frame", {
			Size = UDim2.new(0, 0, 0, 4),
			Position = UDim2.new(0.5, -200, 0.5, 60),
			BackgroundColor3 = Theme.Accent,
			BorderSizePixel = 0,
			Parent = LoadingFrame
		})
		AddCorner(LoadingBar, 2)
		
		-- Animation de la barre
		Tween(LoadingBar, {Size = UDim2.new(0, 400, 0, 4)}, 2)
		task.wait(2)
		Tween(LoadingFrame, {BackgroundTransparency = 1}, 0.5)
		for _, v in pairs(LoadingFrame:GetChildren()) do
			if v:IsA("TextLabel") or v:IsA("Frame") then
				Tween(v, {BackgroundTransparency = 1, TextTransparency = 1}, 0.5)
			end
		end
		task.wait(0.5)
		LoadingFrame:Destroy()
	end
	
	-- Fenêtre principale
	local MainFrame = Create("Frame", {
		Size = UDim2.new(0, 700, 0, 500),
		Position = UDim2.new(0.5, -350, 0.5, -250),
		BackgroundColor3 = Theme.Background,
		BorderSizePixel = 0,
		Parent = ScreenGui
	})
	AddCorner(MainFrame, 12)
	AddStroke(MainFrame, Theme.Border, 2)
	
	-- Barre de titre
	local TitleBar = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 50),
		BackgroundColor3 = Theme.Secondary,
		BorderSizePixel = 0,
		Parent = MainFrame
	})
	AddCorner(TitleBar, 12)
	
	local TitleMask = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 25),
		Position = UDim2.new(0, 0, 1, -25),
		BackgroundColor3 = Theme.Secondary,
		BorderSizePixel = 0,
		Parent = TitleBar
	})
	
	local Title = Create("TextLabel", {
		Size = UDim2.new(1, -100, 1, 0),
		Position = UDim2.new(0, 20, 0, 0),
		BackgroundTransparency = 1,
		Text = WindowName,
		TextColor3 = Theme.Text,
		TextSize = 18,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = TitleBar
	})
	
	if Subtitle ~= "" then
		local SubtitleLabel = Create("TextLabel", {
			Size = UDim2.new(0, 200, 1, 0),
			Position = UDim2.new(0, Title.TextBounds.X + 30, 0, 0),
			BackgroundTransparency = 1,
			Text = Subtitle,
			TextColor3 = Theme.SubText,
			TextSize = 14,
			Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = TitleBar
		})
	end
	
	-- Bouton de fermeture
	local CloseButton = Create("TextButton", {
		Size = UDim2.new(0, 40, 0, 40),
		Position = UDim2.new(1, -50, 0, 5),
		BackgroundColor3 = Theme.Error,
		Text = "✕",
		TextColor3 = Theme.Text,
		TextSize = 20,
		Font = Enum.Font.GothamBold,
		Parent = TitleBar
	})
	AddCorner(CloseButton, 8)
	
	CloseButton.MouseButton1Click:Connect(function()
		Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
		task.wait(0.3)
		ScreenGui:Destroy()
	end)
	
	CloseButton.MouseEnter:Connect(function()
		Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}, 0.2)
	end)
	
	CloseButton.MouseLeave:Connect(function()
		Tween(CloseButton, {BackgroundColor3 = Theme.Error}, 0.2)
	end)
	
	-- Navigation
	local Navigation = Create("Frame", {
		Size = UDim2.new(0, 180, 1, -70),
		Position = UDim2.new(0, 10, 0, 60),
		BackgroundColor3 = Theme.Secondary,
		BorderSizePixel = 0,
		Parent = MainFrame
	})
	AddCorner(Navigation, 10)
	
	local NavList = Create("UIListLayout", {
		Padding = UDim.new(0, 5),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = Navigation
	})
	
	Create("UIPadding", {
		PaddingTop = UDim.new(0, 10),
		PaddingBottom = UDim.new(0, 10),
		PaddingLeft = UDim.new(0, 10),
		PaddingRight = UDim.new(0, 10),
		Parent = Navigation
	})
	
	-- Conteneur de contenu
	local ContentContainer = Create("Frame", {
		Size = UDim2.new(1, -210, 1, -70),
		Position = UDim2.new(0, 200, 0, 60),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = MainFrame
	})
	
	MakeDraggable(MainFrame, TitleBar)
	
	local Window = {}
	Window.Tabs = {}
	Window.CurrentTab = nil
	
	function Window:CreateTab(settings)
		settings = settings or {}
		local TabName = settings.Name or "Tab"
		local Icon = settings.Icon or "📄"
		
		local TabButton = Create("TextButton", {
			Size = UDim2.new(1, 0, 0, 40),
			BackgroundColor3 = Theme.Background,
			Text = "",
			Parent = Navigation
		})
		AddCorner(TabButton, 8)
		
		local TabIcon = Create("TextLabel", {
			Size = UDim2.new(0, 30, 0, 30),
			Position = UDim2.new(0, 5, 0, 5),
			BackgroundTransparency = 1,
			Text = Icon,
			TextColor3 = Theme.SubText,
			TextSize = 18,
			Font = Enum.Font.GothamBold,
			Parent = TabButton
		})
		
		local TabLabel = Create("TextLabel", {
			Size = UDim2.new(1, -45, 1, 0),
			Position = UDim2.new(0, 40, 0, 0),
			BackgroundTransparency = 1,
			Text = TabName,
			TextColor3 = Theme.SubText,
			TextSize = 14,
			Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = TabButton
		})
		
		local TabContent = Create("ScrollingFrame", {
			Size = UDim2.new(1, -10, 1, -10),
			Position = UDim2.new(0, 5, 0, 5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 4,
			ScrollBarImageColor3 = Theme.Accent,
			Visible = false,
			Parent = ContentContainer
		})
		
		local ContentList = Create("UIListLayout", {
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = TabContent
		})
		
		ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
		end)
		
		local Tab = {}
		Tab.Content = TabContent
		Tab.Button = TabButton
		
		TabButton.MouseButton1Click:Connect(function()
			for _, tab in pairs(Window.Tabs) do
				tab.Content.Visible = false
				Tween(tab.Button, {BackgroundColor3 = Theme.Background}, 0.2)
				tab.Button.TextLabel.TextColor3 = Theme.SubText
				tab.Button.TextLabel_2.TextColor3 = Theme.SubText
			end
			
			TabContent.Visible = true
			Tween(TabButton, {BackgroundColor3 = Theme.Accent}, 0.2)
			TabLabel.TextColor3 = Theme.Text
			TabIcon.TextColor3 = Theme.Text
			Window.CurrentTab = Tab
		end)
		
		TabButton.MouseEnter:Connect(function()
			if Window.CurrentTab ~= Tab then
				Tween(TabButton, {BackgroundColor3 = Theme.Border}, 0.2)
			end
		end)
		
		TabButton.MouseLeave:Connect(function()
			if Window.CurrentTab ~= Tab then
				Tween(TabButton, {BackgroundColor3 = Theme.Background}, 0.2)
			end
		end)
		
		function Tab:CreateButton(settings)
			settings = settings or {}
			local ButtonName = settings.Name or "Button"
			local Description = settings.Description or nil
			local Callback = settings.Callback or function() end
			
			local ButtonHeight = Description and 60 or 40
			
			local Button = Create("TextButton", {
				Size = UDim2.new(1, 0, 0, ButtonHeight),
				BackgroundColor3 = Theme.Secondary,
				Text = "",
				Parent = TabContent
			})
			AddCorner(Button, 8)
			AddStroke(Button, Theme.Border)
			
			local ButtonLabel = Create("TextLabel", {
				Size = UDim2.new(1, -20, 0, 20),
				Position = UDim2.new(0, 10, 0, Description and 5 or 10),
				BackgroundTransparency = 1,
				Text = ButtonName,
				TextColor3 = Theme.Text,
				TextSize = 14,
				Font = Enum.Font.GothamBold,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = Button
			})
			
			if Description then
				local DescLabel = Create("TextLabel", {
					Size = UDim2.new(1, -20, 0, 25),
					Position = UDim2.new(0, 10, 0, 28),
					BackgroundTransparency = 1,
					Text = Description,
					TextColor3 = Theme.SubText,
					TextSize = 11,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					Parent = Button
				})
			end
			
			Button.MouseButton1Click:Connect(function()
				Tween(Button, {BackgroundColor3 = Theme.Accent}, 0.1)
				task.wait(0.1)
				Tween(Button, {BackgroundColor3 = Theme.Secondary}, 0.1)
				
				local success, err = pcall(Callback)
				if not success then
					warn("GitanX Button Error:", err)
				end
			end)
			
			Button.MouseEnter:Connect(function()
				Tween(Button, {BackgroundColor3 = Theme.Border}, 0.2)
			end)
			
			Button.MouseLeave:Connect(function()
				Tween(Button, {BackgroundColor3 = Theme.Secondary}, 0.2)
			end)
			
			return Button
		end
		
		function Tab:CreateToggle(settings)
			settings = settings or {}
			local ToggleName = settings.Name or "Toggle"
			local Description = settings.Description or nil
			local Default = settings.Default or false
			local Callback = settings.Callback or function() end
			
			local ToggleHeight = Description and 60 or 40
			local Toggled = Default
			
			local ToggleFrame = Create("Frame", {
				Size = UDim2.new(1, 0, 0, ToggleHeight),
				BackgroundColor3 = Theme.Secondary,
				BorderSizePixel = 0,
				Parent = TabContent
			})
			AddCorner(ToggleFrame, 8)
			AddStroke(ToggleFrame, Theme.Border)
			
			local ToggleLabel = Create("TextLabel", {
				Size = UDim2.new(1, -70, 0, 20),
				Position = UDim2.new(0, 10, 0, Description and 5 or 10),
				BackgroundTransparency = 1,
				Text = ToggleName,
				TextColor3 = Theme.Text,
				TextSize = 14,
				Font = Enum.Font.GothamBold,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = ToggleFrame
			})
			
			if Description then
				local DescLabel = Create("TextLabel", {
					Size = UDim2.new(1, -70, 0, 25),
					Position = UDim2.new(0, 10, 0, 28),
					BackgroundTransparency = 1,
					Text = Description,
					TextColor3 = Theme.SubText,
					TextSize = 11,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					Parent = ToggleFrame
				})
			end
			
			local ToggleButton = Create("TextButton", {
				Size = UDim2.new(0, 45, 0, 24),
				Position = UDim2.new(1, -55, 0, Description and 18 or 8),
				BackgroundColor3 = Toggled and Theme.Accent or Theme.Border,
				Text = "",
				Parent = ToggleFrame
			})
			AddCorner(ToggleButton, 12)
			
			local ToggleCircle = Create("Frame", {
				Size = UDim2.new(0, 18, 0, 18),
				Position = Toggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
				BackgroundColor3 = Theme.Text,
				BorderSizePixel = 0,
				Parent = ToggleButton
			})
			AddCorner(ToggleCircle, 9)
			
			local function Toggle()
				Toggled = not Toggled
				
				Tween(ToggleButton, {BackgroundColor3 = Toggled and Theme.Accent or Theme.Border}, 0.3)
				Tween(ToggleCircle, {Position = Toggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)}, 0.3)
				
				local success, err = pcall(Callback, Toggled)
				if not success then
					warn("GitanX Toggle Error:", err)
				end
			end
			
			ToggleButton.MouseButton1Click:Connect(Toggle)
			
			local ToggleObj = {}
			ToggleObj.Value = Toggled
			
			function ToggleObj:Set(value)
				if Toggled ~= value then
					Toggle()
				end
			end
			
			return ToggleObj
		end
		
		function Tab:CreateSlider(settings)
			settings = settings or {}
			local SliderName = settings.Name or "Slider"
			local Min = settings.Min or 0
			local Max = settings.Max or 100
			local Default = settings.Default or Min
			local Increment = settings.Increment or 1
			local Callback = settings.Callback or function() end
			
			local SliderValue = Default
			
			local SliderFrame = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 50),
				BackgroundColor3 = Theme.Secondary,
				BorderSizePixel = 0,
				Parent = TabContent
			})
			AddCorner(SliderFrame, 8)
			AddStroke(SliderFrame, Theme.Border)
			
			local SliderLabel = Create("TextLabel", {
				Size = UDim2.new(1, -70, 0, 20),
				Position = UDim2.new(0, 10, 0, 5),
				BackgroundTransparency = 1,
				Text = SliderName,
				TextColor3 = Theme.Text,
				TextSize = 14,
				Font = Enum.Font.GothamBold,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = SliderFrame
			})
			
			local ValueLabel = Create("TextLabel", {
				Size = UDim2.new(0, 60, 0, 20),
				Position = UDim2.new(1, -65, 0, 5),
				BackgroundTransparency = 1,
				Text = tostring(SliderValue),
				TextColor3 = Theme.Accent,
				TextSize = 14,
				Font = Enum.Font.GothamBold,
				TextXAlignment = Enum.TextXAlignment.Right,
				Parent = SliderFrame
			})
			
			local SliderBar = Create("Frame", {
				Size = UDim2.new(1, -20, 0, 4),
				Position = UDim2.new(0, 10, 1, -15),
				BackgroundColor3 = Theme.Border,
				BorderSizePixel = 0,
				Parent = SliderFrame
			})
			AddCorner(SliderBar, 2)
			
			local SliderFill = Create("Frame", {
				Size = UDim2.new((SliderValue - Min) / (Max - Min), 0, 1, 0),
				BackgroundColor3 = Theme.Accent,
				BorderSizePixel = 0,
				Parent = SliderBar
			})
			AddCorner(SliderFill, 2)
			
			local SliderButton = Create("TextButton", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = "",
				Parent = SliderBar
			})
			
			local function UpdateSlider(input)
				local relativeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
				SliderValue = math.floor(((relativeX * (Max - Min) + Min) / Increment) + 0.5) * Increment
				SliderValue = math.clamp(SliderValue, Min, Max)
				
				ValueLabel.Text = tostring(SliderValue)
				Tween(SliderFill, {Size = UDim2.new((SliderValue - Min) / (Max - Min), 0, 1, 0)}, 0.1)
				
				local success, err = pcall(Callback, SliderValue)
				if not success then
					warn("GitanX Slider Error:", err)
				end
			end
			
			SliderButton.MouseButton1Down:Connect(function()
				local connection
				connection = UserInputService.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						UpdateSlider(input)
					end
				end)
				
				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						connection:Disconnect()
					end
				end)
			end)
			
			SliderButton.MouseButton1Click:Connect(function(input)
				UpdateSlider(input)
			end)
			
			local SliderObj = {}
			SliderObj.Value = SliderValue
			
			function SliderObj:Set(value)
				SliderValue = math.clamp(value, Min, Max)
				ValueLabel.Text = tostring(SliderValue)
				Tween(SliderFill, {Size = UDim2.new((SliderValue - Min) / (Max - Min), 0, 1, 0)}, 0.2)
			end
			
			return SliderObj
		end
		
		function Tab:CreateInput(settings)
			settings = settings or {}
			local InputName = settings.Name or "Input"
			local Placeholder = settings.Placeholder or "Entrez du texte..."
			local Description = settings.Description or nil
			local Callback = settings.Callback or function() end
			
			local InputHeight = Description and 70 or 50
			
			local InputFrame = Create("Frame", {
				Size = UDim2.new(1, 0, 0, InputHeight),
				BackgroundColor3 = Theme.Secondary,
				BorderSizePixel = 0,
				Parent = TabContent
			})
			AddCorner(InputFrame, 8)
			AddStroke(InputFrame, Theme.Border)
			
			local InputLabel = Create("TextLabel", {
				Size = UDim2.new(1, -20, 0, 20),
				Position = UDim2.new(0, 10, 0, 5),
				BackgroundTransparency = 1,
				Text = InputName,
				TextColor3 = Theme.Text,
				TextSize = 14,
				Font = Enum.Font.GothamBold,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = InputFrame
			})
			
			if Description then
				local DescLabel = Create("TextLabel", {
					Size = UDim2.new(1, -20, 0, 15),
					Position = UDim2.new(0, 10, 0, 23),
					BackgroundTransparency = 1,
					Text = Description,
					TextColor3 = Theme.SubText,
					TextSize = 11,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					Parent = InputFrame
				})
			end
			
			local InputBox = Create("TextBox", {
				Size = UDim2.new(1, -20, 0, 28),
				Position = UDim2.new(0, 10, 1, -33),
				BackgroundColor3 = Theme.Background,
				Text = "",
				PlaceholderText = Placeholder,
				TextColor3 = Theme.Text,
				PlaceholderColor3 = Theme.SubText,
				TextSize = 13,
				Font = Enum.Font.Gotham,
				ClearTextOnFocus = false,
				Parent = InputFrame
			})
			AddCorner(InputBox, 6)
			Create("UIPadding", {PaddingLeft = UDim.new(0, 10), Parent = InputBox})
			
			InputBox.FocusLost:Connect(function(enterPressed)
				if enterPressed then
					local success, err = pcall(Callback, InputBox.Text)
					if not success then
						warn("GitanX Input Error:", err)
					end
				end
			end)
			
			local InputObj = {}
			
			function InputObj:Set(text)
				InputBox.Text = text
			end
			
			function InputObj:Get()
				return InputBox.Text
			end
			
			return InputObj
		end
		
		function Tab:CreateDropdown(settings)
			settings = settings or {}
			local DropdownName = settings.Name or "Dropdown"
			local Options = settings.Options or {"Option 1", "Option 2"}
			local Default = settings.Default or Options[1]
			local Callback = settings.Callback or function() end
			
			local Selected = Default
			local Opened = false
			
			local DropdownFrame = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 40),
				BackgroundColor3 = Theme.Secondary,
				BorderSizePixel = 0,
				Parent = TabContent
			})
			AddCorner(DropdownFrame, 8)
			AddStroke(DropdownFrame, Theme.Border)
			
			local DropdownLabel = Create("TextLabel", {
				Size = UDim2.new(0.5, -10, 1, 0),
				Position = UDim2.new(0, 10, 0, 0),
				BackgroundTransparency = 1,
				Text = DropdownName,
				TextColor3 = Theme.Text,
				TextSize = 14,
				Font = Enum.Font.GothamBold,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = DropdownFrame
			})
			
			local DropdownButton = Create("TextButton", {
				Size = UDim2.new(0.5, -20, 0, 30),
				Position = UDim2.new(0.5, 10, 0, 5),
				BackgroundColor3 = Theme.Background,
				Text = Selected,
				TextColor3 = Theme.Text,
				TextSize = 13,
				Font = Enum.Font.Gotham,
				Parent = DropdownFrame
			})
			AddCorner(DropdownButton, 6)
			
			local Arrow = Create("TextLabel", {
				Size = UDim2.new(0, 20, 1, 0),
				Position = UDim2.new(1, -25, 0, 0),
				BackgroundTransparency = 1,
				Text = "▼",
				TextColor3 = Theme.SubText,
				TextSize = 12,
				Parent = DropdownButton
			})
			
			local DropdownList = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 0),
				Position = UDim2.new(0, 0, 1, 5),
				BackgroundColor3 = Theme.Secondary,
				BorderSizePixel = 0,
				Visible = false,
				ZIndex = 10,
				Parent = DropdownFrame
			})
			AddCorner(DropdownList, 8)
			AddStroke(DropdownList, Theme.Border)
			
			local ListLayout = Create("UIListLayout", {
				Padding = UDim.new(0, 2),
				Parent = DropdownList
			})
			
			Create("UIPadding", {
				PaddingTop = UDim.new(0, 5),
				PaddingBottom = UDim.new(0, 5),
				PaddingLeft = UDim.new(0, 5),
				PaddingRight = UDim.new(0, 5),
				Parent = DropdownList
			})
			
			for _, option in ipairs(Options) do
				local OptionButton = Create("TextButton", {
					Size = UDim2.new(1, -10, 0, 30),
					BackgroundColor3 = option == Selected and Theme.Accent or Theme.Background,
					Text = option,
					TextColor3 = Theme.Text,
					TextSize = 12,
					Font = Enum.Font.Gotham,
					Parent = DropdownList
				})
				AddCorner(OptionButton, 6)
				
				OptionButton.MouseButton1Click:Connect(function()
					Selected = option
					DropdownButton.Text = option
					
					for _, btn in pairs(DropdownList:GetChildren()) do
						if btn:IsA("TextButton") then
							Tween(btn, {BackgroundColor3 = Theme.Background}, 0.2)
						end
					end
					
					Tween(OptionButton, {BackgroundColor3 = Theme.Accent}, 0.2)
					
					Opened = false
					Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
					Tween(Arrow, {Rotation = 0}, 0.3)
					task.wait(0.3)
					DropdownList.Visible = false
					
					local success, err = pcall(Callback, option)
					if not success then
						warn("GitanX Dropdown Error:", err)
					end
				end)
				
				OptionButton.MouseEnter:Connect(function()
					if option ~= Selected then
						Tween(OptionButton, {BackgroundColor3 = Theme.Border}, 0.2)
					end
				end)
				
				OptionButton.MouseLeave:Connect(function()
					if option ~= Selected then
						Tween(OptionButton, {BackgroundColor3 = Theme.Background}, 0.2)
					end
				end)
			end
			
			DropdownButton.MouseButton1Click:Connect(function()
				Opened = not Opened
				
				if Opened then
					DropdownList.Visible = true
					local listHeight = (#Options * 32) + 14
					Tween(DropdownList, {Size = UDim2.new(1, 0, 0, listHeight)}, 0.3)
					Tween(Arrow, {Rotation = 180}, 0.3)
				else
					Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
					Tween(Arrow, {Rotation = 0}, 0.3)
					task.wait(0.3)
					DropdownList.Visible = false
				end
			end)
			
			local DropdownObj = {}
			DropdownObj.Value = Selected
			
			function DropdownObj:Set(option)
				if table.find(Options, option) then
					Selected = option
					DropdownButton.Text = option
				end
			end
			
			return DropdownObj
		end
		
		function Tab:CreateLabel(settings)
			settings = settings or {}
			local Text = settings.Text or "Label"
			local Size = settings.Size or 14
			local Bold = settings.Bold or false
			
			local Label = Create("TextLabel", {
				Size = UDim2.new(1, 0, 0, Size + 10),
				BackgroundTransparency = 1,
				Text = Text,
				TextColor3 = Theme.Text,
				TextSize = Size,
				Font = Bold and Enum.Font.GothamBold or Enum.Font.Gotham,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true,
				Parent = TabContent
			})
			
			local LabelObj = {}
			
			function LabelObj:Set(text)
				Label.Text = text
			end
			
			return LabelObj
		end
		
		function Tab:CreateDivider()
			local Divider = Create("Frame", {
				Size = UDim2.new(1, -20, 0, 1),
				Position = UDim2.new(0, 10, 0, 0),
				BackgroundColor3 = Theme.Border,
				BorderSizePixel = 0,
				Parent = TabContent
			})
			
			return Divider
		end
		
		table.insert(Window.Tabs, Tab)
		
		if #Window.Tabs == 1 then
			TabButton.MouseButton1Click:Fire()
		end
		
		return Tab
	end
	
	return Window
end

return GitanX
