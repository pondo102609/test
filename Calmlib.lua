local module = {}
local ts = cloneref(game:GetService("TweenService"))
local cg = cloneref(game:GetService("CoreGui"))
local ui = cloneref(game:GetService("UserInputService"))

function module:win(title, openKey)
    openKey = openKey or Enum.KeyCode.RightControl
    
    local window = Instance.new("ScreenGui")
    window.Name = "CalmLib_Window"
    window.ResetOnSpawn = false
    window.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local hui = gethui or get_hidden_gui or nil
    if hui then
        window.Parent = hui()
    else
        window.Parent = cg
    end
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = window
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 35)
    topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    topBar.BackgroundTransparency = 0.5
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 12)
    topCorner.Parent = topBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -60, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = topBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 1, 0)
    closeBtn.Position = UDim2.new(1, -35, 0, 0)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BackgroundTransparency = 1
    closeBtn.Parent = topBar
    
    local miniBtn = Instance.new("TextButton")
    miniBtn.Size = UDim2.new(0, 30, 1, 0)
    miniBtn.Position = UDim2.new(1, -65, 0, 0)
    miniBtn.Text = "_"
    miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    miniBtn.TextSize = 14
    miniBtn.Font = Enum.Font.GothamBold
    miniBtn.BackgroundTransparency = 1
    miniBtn.Parent = topBar
    
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 120, 1, -35)
    tabContainer.Position = UDim2.new(0, 0, 0, 35)
    tabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    tabContainer.BackgroundTransparency = 0.3
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 0)
    tabCorner.Parent = tabContainer
    
    local tabList = Instance.new("ScrollingFrame")
    tabList.Size = UDim2.new(1, 0, 1, 0)
    tabList.BackgroundTransparency = 1
    tabList.BorderSizePixel = 0
    tabList.ScrollBarThickness = 0
    tabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabList.Parent = tabContainer
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabList
    
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -120, 1, -35)
    contentContainer.Position = UDim2.new(0, 120, 0, 35)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = mainFrame
    
    local sectionsHolder = Instance.new("Frame")
    sectionsHolder.Name = "SectionsHolder"
    sectionsHolder.Size = UDim2.new(1, 0, 1, 0)
    sectionsHolder.BackgroundTransparency = 1
    sectionsHolder.Parent = contentContainer
    
    local isMinimized = false
    local isVisible = true
    
    local function toggleMinimize()
        isMinimized = not isMinimized
        if isMinimized then
            ts:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 500, 0, 45)
            }):Play()
            tabContainer.Visible = false
            contentContainer.Visible = false
        else
            ts:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 500, 0, 400)
            }):Play()
            tabContainer.Visible = true
            contentContainer.Visible = true
        end
    end
    
    local function toggleWindow()
        isVisible = not isVisible
        mainFrame.Visible = isVisible
    end
    
    closeBtn.MouseButton1Click:Connect(function()
        window:Destroy()
    end)
    
    miniBtn.MouseButton1Click:Connect(toggleMinimize)
    
    ui.InputBegan:Connect(function(key, gameProcessed)
        if not gameProcessed and key.KeyCode == openKey then
            toggleWindow()
        end
    end)
    
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    local function onDragStart(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local btn = input.Parent
            if btn and (btn:IsA("TextButton") or btn:IsA("ImageButton")) then
                return
            end
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end
    
    local function onDragMove(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newX = startPos.X.Offset + delta.X
            local newY = startPos.Y.Offset + delta.Y
            mainFrame.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
        end
    end
    
    local function onDragEnd()
        dragging = false
    end
    
    mainFrame.InputBegan:Connect(onDragStart)
    ui.InputChanged:Connect(onDragMove)
    ui.InputEnded:Connect(onDragEnd)
    
    local sections = {}
    local currentSection = nil
    local tabButtons = {}
    
    function sections:tab(name, icon)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = name
        tabBtn.Size = UDim2.new(1, -10, 0, 35)
        tabBtn.Position = UDim2.new(0, 5, 0, 0)
        tabBtn.Text = name
        tabBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
        tabBtn.TextSize = 12
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        tabBtn.BackgroundTransparency = 0.5
        tabBtn.BorderSizePixel = 0
        tabBtn.Parent = tabList
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = tabBtn
        
        local sectionFrame = Instance.new("ScrollingFrame")
        sectionFrame.Name = name .. "_Section"
        sectionFrame.Size = UDim2.new(1, -20, 1, -10)
        sectionFrame.Position = UDim2.new(0, 10, 0, 5)
        sectionFrame.BackgroundTransparency = 1
        sectionFrame.BorderSizePixel = 0
        sectionFrame.ScrollBarThickness = 4
        sectionFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        sectionFrame.Visible = false
        sectionFrame.Parent = sectionsHolder
        
        local sectionLayout = Instance.new("UIListLayout")
        sectionLayout.Padding = UDim.new(0, 8)
        sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
        sectionLayout.Parent = sectionFrame
        
        local function updateCanvas()
            task.wait(0.05)
            sectionFrame.CanvasSize = UDim2.new(0, 0, 0, sectionLayout.AbsoluteContentSize.Y + 10)
        end
        
        sectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
        
        tabBtn.MouseButton1Click:Connect(function()
            for _, btn in pairs(tabButtons) do
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                btn.BackgroundTransparency = 0.5
                btn.TextColor3 = Color3.fromRGB(180, 180, 200)
            end
            tabBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
            tabBtn.BackgroundTransparency = 0.3
            tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            
            if currentSection then
                currentSection.Visible = false
            end
            sectionFrame.Visible = true
            currentSection = sectionFrame
        end)
        
        table.insert(tabButtons, tabBtn)
        
        if not currentSection then
            tabBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
            tabBtn.BackgroundTransparency = 0.3
            tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            sectionFrame.Visible = true
            currentSection = sectionFrame
        end
        
        local content = {}
        
        function content:label(text)
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -10, 0, 25)
            label.Text = text
            label.TextColor3 = Color3.fromRGB(200, 200, 220)
            label.TextSize = 12
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.BackgroundTransparency = 1
            label.Parent = sectionFrame
        end
        
        function content:button(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 35)
            btn.Text = text
            btn.TextColor3 = Color3.fromRGB(220, 220, 240)
            btn.TextSize = 13
            btn.Font = Enum.Font.GothamSemibold
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            btn.BackgroundTransparency = 0.3
            btn.BorderSizePixel = 0
            btn.Parent = sectionFrame
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(callback)
            
            btn.MouseEnter:Connect(function()
                ts:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.1}):Play()
            end)
            btn.MouseLeave:Connect(function()
                ts:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play()
            end)
        end
        
        function content:toggle(text, defaultValue, callback)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, -10, 0, 35)
            toggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            toggleFrame.BackgroundTransparency = 0.3
            toggleFrame.BorderSizePixel = 0
            toggleFrame.Parent = sectionFrame
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 6)
            toggleCorner.Parent = toggleFrame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -70, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.Text = text
            label.TextColor3 = Color3.fromRGB(200, 200, 220)
            label.TextSize = 12
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.BackgroundTransparency = 1
            label.Parent = toggleFrame
            
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Size = UDim2.new(0, 50, 0, 25)
            toggleBtn.Position = UDim2.new(1, -60, 0.5, -12.5)
            toggleBtn.Text = defaultValue and "ON" or "OFF"
            toggleBtn.TextColor3 = defaultValue and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
            toggleBtn.TextSize = 11
            toggleBtn.Font = Enum.Font.GothamBold
            toggleBtn.BackgroundColor3 = defaultValue and Color3.fromRGB(50, 100, 50) or Color3.fromRGB(100, 50, 50)
            toggleBtn.BackgroundTransparency = 0.3
            toggleBtn.BorderSizePixel = 0
            toggleBtn.Parent = toggleFrame
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 4)
            btnCorner.Parent = toggleBtn
            
            local toggled = defaultValue
            
            toggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                toggleBtn.Text = toggled and "ON" or "OFF"
                toggleBtn.TextColor3 = toggled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
                toggleBtn.BackgroundColor3 = toggled and Color3.fromRGB(50, 100, 50) or Color3.fromRGB(100, 50, 50)
                callback(toggled)
            end)
            
            callback(toggled)
        end
        
        function content:slider(text, min, max, default, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, -10, 0, 55)
            sliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            sliderFrame.BackgroundTransparency = 0.3
            sliderFrame.BorderSizePixel = 0
            sliderFrame.Parent = sectionFrame
            
            local sliderCorner = Instance.new("UICorner")
            sliderCorner.CornerRadius = UDim.new(0, 6)
            sliderCorner.Parent = sliderFrame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -10, 0, 20)
            label.Position = UDim2.new(0, 10, 0, 5)
            label.Text = text .. ": " .. tostring(default)
            label.TextColor3 = Color3.fromRGB(200, 200, 220)
            label.TextSize = 12
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.BackgroundTransparency = 1
            label.Parent = sliderFrame
            
            local sliderBg = Instance.new("Frame")
            sliderBg.Size = UDim2.new(1, -20, 0, 4)
            sliderBg.Position = UDim2.new(0, 10, 0, 35)
            sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            sliderBg.BorderSizePixel = 0
            sliderBg.Parent = sliderFrame
            
            local bgCorner = Instance.new("UICorner")
            bgCorner.CornerRadius = UDim.new(1, 0)
            bgCorner.Parent = sliderBg
            
            local sliderFill = Instance.new("Frame")
            local percent = (default - min) / (max - min)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            sliderFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderBg
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = sliderFill
            
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 12, 0, 12)
            knob.Position = UDim2.new(percent, -6, 0.5, -6)
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            knob.BorderSizePixel = 0
            knob.Parent = sliderBg
            
            local knobCorner = Instance.new("UICorner")
            knobCorner.CornerRadius = UDim.new(1, 0)
            knobCorner.Parent = knob
            
            local dragging = false
            local currentValue = default
            
            local function updateValue(inputPos)
                local rel = (inputPos - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
                rel = math.clamp(rel, 0, 1)
                local newValue = min + (max - min) * rel
                currentValue = newValue
                sliderFill.Size = UDim2.new(rel, 0, 1, 0)
                knob.Position = UDim2.new(rel, -6, 0.5, -6)
                label.Text = text .. ": " .. string.format("%.1f", newValue)
                callback(newValue)
            end
            
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateValue(input.Position.X)
                    
                    local conn
                    conn = input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                            conn:Disconnect()
                        end
                    end)
                end
            end)
            
            ui.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateValue(input.Position.X)
                end
            end)
        end
        
        function content:textbox(text, placeholder, default, callback)
            local textboxFrame = Instance.new("Frame")
            textboxFrame.Size = UDim2.new(1, -10, 0, 55)
            textboxFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            textboxFrame.BackgroundTransparency = 0.3
            textboxFrame.BorderSizePixel = 0
            textboxFrame.Parent = sectionFrame
            
            local tbCorner = Instance.new("UICorner")
            tbCorner.CornerRadius = UDim.new(0, 6)
            tbCorner.Parent = textboxFrame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -10, 0, 20)
            label.Position = UDim2.new(0, 10, 0, 5)
            label.Text = text
            label.TextColor3 = Color3.fromRGB(200, 200, 220)
            label.TextSize = 12
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.BackgroundTransparency = 1
            label.Parent = textboxFrame
            
            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, -20, 0, 25)
            box.Position = UDim2.new(0, 10, 0, 28)
            box.PlaceholderText = placeholder
            box.Text = default or ""
            box.TextColor3 = Color3.fromRGB(220, 220, 240)
            box.TextSize = 12
            box.Font = Enum.Font.Gotham
            box.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            box.BorderSizePixel = 0
            box.Parent = textboxFrame
            
            local boxCorner = Instance.new("UICorner")
            boxCorner.CornerRadius = UDim.new(0, 4)
            boxCorner.Parent = box
            
            box.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    callback(box.Text)
                end
            end)
            
            if default and default ~= "" then
                callback(default)
            end
        end
        
        function content:dropdown(text, options, default, callback)
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Size = UDim2.new(1, -10, 0, 55)
            dropdownFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            dropdownFrame.BackgroundTransparency = 0.3
            dropdownFrame.BorderSizePixel = 0
            dropdownFrame.Parent = sectionFrame
            
            local ddCorner = Instance.new("UICorner")
            ddCorner.CornerRadius = UDim.new(0, 6)
            ddCorner.Parent = dropdownFrame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -10, 0, 20)
            label.Position = UDim2.new(0, 10, 0, 5)
            label.Text = text
            label.TextColor3 = Color3.fromRGB(200, 200, 220)
            label.TextSize = 12
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.BackgroundTransparency = 1
            label.Parent = dropdownFrame
            
            local dropdownBtn = Instance.new("TextButton")
            dropdownBtn.Size = UDim2.new(1, -20, 0, 25)
            dropdownBtn.Position = UDim2.new(0, 10, 0, 28)
            dropdownBtn.Text = default or options[1]
            dropdownBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
            dropdownBtn.TextSize = 12
            dropdownBtn.Font = Enum.Font.Gotham
            dropdownBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            dropdownBtn.BorderSizePixel = 0
            dropdownBtn.Parent = dropdownFrame
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 4)
            btnCorner.Parent = dropdownBtn
            
            local dropdownMenu = Instance.new("Frame")
            dropdownMenu.Size = UDim2.new(1, 0, 0, #options * 25)
            dropdownMenu.Position = UDim2.new(0, 0, 1, 2)
            dropdownMenu.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            dropdownMenu.BackgroundTransparency = 0.1
            dropdownMenu.BorderSizePixel = 0
            dropdownMenu.Visible = false
            dropdownMenu.Parent = dropdownBtn
            
            local menuCorner = Instance.new("UICorner")
            menuCorner.CornerRadius = UDim.new(0, 4)
            menuCorner.Parent = dropdownMenu
            
            local isOpen = false
            
            for i, opt in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 25)
                optBtn.Position = UDim2.new(0, 0, 0, (i-1) * 25)
                optBtn.Text = opt
                optBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
                optBtn.TextSize = 11
                optBtn.Font = Enum.Font.Gotham
                optBtn.BackgroundTransparency = 1
                optBtn.Parent = dropdownMenu
                
                optBtn.MouseButton1Click:Connect(function()
                    dropdownBtn.Text = opt
                    dropdownMenu.Visible = false
                    isOpen = false
                    callback(opt)
                end)
            end
            
            dropdownBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                dropdownMenu.Visible = isOpen
            end)
        end
        
        return content
    end
    
    return sections
end

return module
