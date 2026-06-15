--[[
 .d8888b.           888               888      d8b 888      
d88P  Y88b          888               888      Y8P 888      
888    888          888               888          888      
888         8888b.  888 88888b.d88b.  888      888 88888b.  
888            "88b 888 888 "888 "88b 888      888 888 "88b 
888    888 .d888888 888 888  888  888 888      888 888  888 
Y88b  d88P 888  888 888 888  888  888 888      888 888 d88P 
 "Y8888P"  "Y888888 888 888  888  888 88888888 888 88888P"  
                                                            
                                                            
============ Made by esore aka vaehz ============
-- free for whatever, use it steal it remake it idrc, credits would be cool tho
]]

local module = {}
local ts = cloneref(game:GetService("TweenService"))
local cg = cloneref(game:GetService("CoreGui"))
local ui = cloneref(game:GetService("UserInputService"))

function module:win(title)
    local window = game:GetObjects("rbxassetid://96576283085736")[1]
    local elements = game:GetObjects("rbxassetid://83539751566719")[1]

    local hui = gethui or get_hidden_gui or nil
    if hui then
        window.Parent = hui()
    else
        window.Parent = cg
    end

    local topbar = window.Frame.topbar
    topbar.title.Text = title

    local closeBtn = topbar.btns.Close
    local miniBtn = topbar.btns.Minimize

    local toggleCon = nil
    local isVisible = true

    local function fadebtn(btn, isIn)
        ts:Create(
            btn,
            TweenInfo.new(
                0.15
            ),
            {
                BackgroundTransparency = isIn and 0.8 or 1
            }
        ):Play()
    end

    local function togglewin(isIn)
        isVisible = isIn
        
        ts:Create(
            window.Frame,
            TweenInfo.new(
                0.25,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            {
                GroupTransparency = isIn and 0 or 1
            }
        ):Play()
        ts:Create(
            window.Frame,
            TweenInfo.new(
                0.25,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            {
                Size = isIn and UDim2.new(0.37, 0, 0.407, 0) or UDim2.new(0.37, 0, 0.376, 0)
            }
        ):Play()

        window.Frame.Interactable = isIn and true or false
    end

    local function fadetopbar(isIn)
        ts:Create(
            topbar,
            TweenInfo.new(0.15),
            {
                BackgroundTransparency = isIn and 0.7 or 0.8
            }
        ):Play()
    end

    closeBtn.MouseEnter:Connect(function() fadebtn(closeBtn, true) end)
    miniBtn.MouseEnter:Connect(function() fadebtn(miniBtn, true) end)
    closeBtn.MouseLeave:Connect(function() fadebtn(closeBtn, false) end)
    miniBtn.MouseLeave:Connect(function() fadebtn(miniBtn, false) end)

    topbar.MouseEnter:Connect(function() fadetopbar(true) end)
    topbar.MouseLeave:Connect(function() fadetopbar(false) end)

    closeBtn.MouseButton1Click:Connect(function()
        window:Destroy()
        elements:Destroy()
        if toggleCon then toggleCon:Disconnect() end
    end)

    miniBtn.MouseButton1Click:Connect(function()
        togglewin(false)
    end)

    -- Right Ctrl toggle functionality
    toggleCon = ui.InputBegan:Connect(function(keyc, gamep)
        if not gamep and keyc.KeyCode == Enum.KeyCode.RightControl then
            togglewin(not isVisible)
        end
    end)

    local sections = {}
    local curSelected = nil

    local dragging = false
    local dragInput, mousePos, framePos

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = window.Frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    ui.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            window.Frame.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)

    local function toggletab(tab, isIn)
        ts:Create(
            tab,
            TweenInfo.new(
                0.25
            ),
            {
                GroupTransparency = isIn and 0 or 1
            }
        ):Play()
        ts:Create(
            tab,
            TweenInfo.new(
                0.25
            ),
            {
                Position = isIn and UDim2.new(0.5, 0, 1, 0) or UDim2.new(0.5, 0, 1.1, 0)
            }
        ):Play()
        tab.Interactable = isIn and true or false
    end

    local function fadeelement(which, isIn)
        ts:Create(
            which,
            TweenInfo.new(0.15),
            {
                BackgroundTransparency = isIn and 0.7 or 0.8
            }
        ):Play()
    end

    function sections:tab(title, ico)
        local newBtn = elements.tabelement:Clone()
        newBtn.Name = title

        newBtn.Image = ico
        newBtn.title.Text = title

        newBtn.Parent = window.Frame.tabscontainer

        local newSect = elements.sectioncanvas:Clone()
        newSect.Parent = window.Frame.sectionsholder
        newSect.GroupTransparency = 1
        newSect.Position = UDim2.new(0.5, 0, 1.1, 0)
        newSect.Interactable = false

        local function fadetab(isIn)
            ts:Create(
                newBtn,
                TweenInfo.new(0.15),
                {ImageTransparency = isIn and 0.25 or 0.5}
            ):Play()
            ts:Create(
                newBtn.title,
                TweenInfo.new(0.15),
                {
                    TextTransparency = isIn and 0.5 or 1
                }
            ):Play()
        end

        newBtn.MouseEnter:Connect(function() fadetab(true) end)
        newBtn.MouseLeave:Connect(function() fadetab(false) end)

        newBtn.MouseButton1Click:Connect(function()
            if curSelected == newSect then return end
            if curSelected ~= nil then
                toggletab(curSelected, false)
            end

            toggletab(newSect, true)
            curSelected = newSect
        end)

        local contents = {}

        function contents:label(title)
            local newLabel = elements.LabelElement:Clone()
            newLabel.lbl.Text = title
            newLabel.Parent = newSect.sectioncontainer
        end

        function contents:button(title, cb)
            local newButton = elements.ButtonElement:Clone()
            newButton.btn.lbl.Text = title
            newButton.Parent = newSect.sectioncontainer

            newButton.btn.MouseEnter:Connect(function() fadeelement(newButton.btn, true) end)
            newButton.btn.MouseLeave:Connect(function() fadeelement(newButton.btn, false) end)
            newButton.btn.MouseButton1Click:Connect(cb)
        end

        function contents:toggle(title, default, cb)
            local toggled = default

            local newToggle = elements.ToggleElement:Clone()
            newToggle.btn.lbl.Text = title
            newToggle.Parent = newSect.sectioncontainer

            newToggle.btn.MouseEnter:Connect(function() fadeelement(newToggle.btn, true) end)
            newToggle.btn.MouseLeave:Connect(function() fadeelement(newToggle.btn, false) end)

            local togglebg = newToggle.btn.togglebg
            local sidetog = togglebg.Frame

            if toggled then
                togglebg.BackgroundColor3 = Color3.fromRGB(74, 255, 89)
                sidetog.AnchorPoint = Vector2.new(1, 0.5)
                sidetog.Position = UDim2.new(1, 0, 0.5, 0)
                task.defer(cb, toggled)
            end

            newToggle.btn.MouseButton1Click:Connect(function()
                toggled = not toggled

                ts:Create(
                    sidetog,
                    TweenInfo.new(
                        0.15
                    ),
                    {
                        AnchorPoint = toggled and Vector2.new(1,0.5) or Vector2.new(0,0.5)
                    }
                ):Play()

                ts:Create(
                    sidetog,
                    TweenInfo.new(
                        0.15
                    ),
                    {
                        Position = toggled and UDim2.new(1, 0, 0.5, 0) or UDim2.new(0,0,0.5,0)
                    }
                ):Play()
                
                togglebg.BackgroundColor3 = toggled and Color3.fromRGB(74, 255, 89) or Color3.fromRGB(255, 75, 75)

                cb(toggled)
            end)
        end

        function contents:textbox(title, default, cb)
            local newtb = elements.TextboxElement:Clone()
            newtb.frame.lbl.Text = title
            newtb.Parent = newSect.sectioncontainer

            local inp = newtb.frame.inp.lbl
            inp.Text = default

            if default ~= "" then
                task.defer(cb, default)
            end

            inp.FocusLost:Connect(function(ep)
                if ep then
                    cb(inp.Text)
                end
            end)
        end

        function contents:slider(title, min, max, default, cb)
            local newsl = elements.SliderElement:Clone()
            newsl.lbl.Text = title .. " : " .. tostring(default)
            newsl.Parent = newSect.sectioncontainer

            local slbtn = newsl.btn
            local prog = slbtn.prog
            local lastval = 0
            local dragging = false

            local function setFromAlpha(alpha)
                alpha = math.clamp(alpha, 0, 1)
                local value = math.floor(min + (max - min) * alpha + 0.5)
                prog.Size = UDim2.new(alpha, 0, 1, 0)
                lastval = value
            end

            local function updateFromInput(x)
                local rel = (x - slbtn.AbsolutePosition.X) / slbtn.AbsoluteSize.X
                setFromAlpha(rel)
            end

            setFromAlpha((default - min) / (max - min))

            slbtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then

                    dragging = true
                    updateFromInput(input.Position.X)
                end
            end)

            ui.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch) then

                    updateFromInput(input.Position.X)
                end
            end)

            ui.InputEnded:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch) then

                    dragging = false
                    if cb then
                        newsl.lbl.Text = title .. " : " .. tostring(lastval)
                        pcall(cb, lastval)
                    end
                end
            end)
        end

        -- NEW: Dropdown Menu
        function contents:dropdown(title, options, default, cb)
            local newDropdown = elements.DropdownElement or createDropdownElement(elements)
            if not newDropdown then
                -- Fallback creation if element doesn't exist in your assets
                newDropdown = createDropdownElement()
            end
            
            newDropdown.frame.lbl.Text = title
            newDropdown.Parent = newSect.sectioncontainer
            
            local dropdownBtn = newDropdown.btn
            local dropdownList = newDropdown.dropdownlist
            local selectedText = newDropdown.selected
            
            local isOpen = false
            local currentOption = default or options[1]
            selectedText.Text = currentOption
            
            -- Fade effects for dropdown button
            dropdownBtn.MouseEnter:Connect(function() fadeelement(dropdownBtn, true) end)
            dropdownBtn.MouseLeave:Connect(function() fadeelement(dropdownBtn, false) end)
            
            -- Clear existing options
            for _, child in ipairs(dropdownList:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            
            -- Create dropdown options
            local optionButtons = {}
            for i, option in ipairs(options) do
                local optBtn = elements.DropdownOption:Clone()
                optBtn.Text = option
                optBtn.Parent = dropdownList
                optBtn.Visible = false
                optBtn.BackgroundTransparency = 0.8
                
                optBtn.MouseEnter:Connect(function()
                    ts:Create(optBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.7}):Play()
                end)
                
                optBtn.MouseLeave:Connect(function()
                    ts:Create(optBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.8}):Play()
                end)
                
                optBtn.MouseButton1Click:Connect(function()
                    currentOption = option
                    selectedText.Text = currentOption
                    toggleDropdown(false)
                    if cb then cb(currentOption) end
                end)
                
                optionButtons[option] = optBtn
            end
            
            -- Toggle dropdown function
            local function toggleDropdown(open)
                isOpen = open
                local targetHeight = open and (#options * 30) or 0
                local targetTransparency = open and 0 or 1
                
                for _, btn in pairs(optionButtons) do
                    btn.Visible = open
                end
                
                ts:Create(dropdownList, TweenInfo.new(0.2), {
                    Size = UDim2.new(1, 0, 0, targetHeight),
                    BackgroundTransparency = targetTransparency
                }):Play()
            end
            
            -- Click dropdown button to toggle
            dropdownBtn.MouseButton1Click:Connect(function()
                toggleDropdown(not isOpen)
            end)
            
            -- Close dropdown when clicking outside
            local closeConnection
            closeConnection = ui.InputBegan:Connect(function(input, gameProcessed)
                if isOpen and input.UserInputType == Enum.UserInputType.MouseButton1 and not gameProcessed then
                    local mousePos = ui:GetMouseLocation()
                    local dropdownAbsPos = dropdownList.AbsolutePosition
                    local dropdownAbsSize = dropdownList.AbsoluteSize
                    
                    if not (mousePos.X >= dropdownAbsPos.X and mousePos.X <= dropdownAbsPos.X + dropdownAbsSize.X and
                            mousePos.Y >= dropdownAbsPos.Y and mousePos.Y <= dropdownAbsPos.Y + dropdownAbsSize.Y) then
                        toggleDropdown(false)
                    end
                end
            end)
            
            -- Call callback with default
            if default then task.defer(cb, default) end
        end
        
        -- NEW: Color Picker
        function contents:colorpicker(title, default, cb)
            local newColorPicker = elements.ColorPickerElement or createColorPickerElement(elements)
            if not newColorPicker then
                newColorPicker = createColorPickerElement()
            end
            
            newColorPicker.frame.lbl.Text = title
            newColorPicker.Parent = newSect.sectioncontainer
            
            local colorBtn = newColorPicker.colorbtn
            local colorDisplay = newColorPicker.colordisplay
            local currentColor = default or Color3.fromRGB(255, 255, 255)
            
            colorDisplay.BackgroundColor3 = currentColor
            
            colorBtn.MouseEnter:Connect(function() fadeelement(colorBtn, true) end)
            colorBtn.MouseLeave:Connect(function() fadeelement(colorBtn, false) end)
            
            local colorPickerFrame = newColorPicker.colorpickerframe
            local hueSlider = newColorPicker.hueslider
            local saturationPicker = newColorPicker.saturationpicker
            local rgbInputs = newColorPicker.rgbinputs
            local hexInput = newColorPicker.hexinput
            
            -- Hide picker initially
            colorPickerFrame.Visible = false
            
            colorBtn.MouseButton1Click:Connect(function()
                colorPickerFrame.Visible = not colorPickerFrame.Visible
                if colorPickerFrame.Visible then
                    updateColorPicker(currentColor)
                end
            end)
            
            local function updateColorPicker(color)
                -- Update display
                colorDisplay.BackgroundColor3 = color
                currentColor = color
                
                -- Update RGB inputs if they exist
                if rgbInputs then
                    rgbInputs.r.Value = math.floor(color.R * 255)
                    rgbInputs.g.Value = math.floor(color.G * 255)
                    rgbInputs.b.Value = math.floor(color.B * 255)
                end
                
                -- Update hex input
                if hexInput then
                    hexInput.Text = string.format("#%02x%02x%02x", 
                        math.floor(color.R * 255), 
                        math.floor(color.G * 255), 
                        math.floor(color.B * 255))
                end
                
                if cb then cb(color) end
            end
            
            -- Simplified color picking (you can expand this)
            saturationPicker.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local connection
                    connection = ui.InputChanged:Connect(function(moveInput)
                        if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
                            local relativeX = math.clamp((moveInput.Position.X - saturationPicker.AbsolutePosition.X) / saturationPicker.AbsoluteSize.X, 0, 1)
                            local relativeY = math.clamp((moveInput.Position.Y - saturationPicker.AbsolutePosition.Y) / saturationPicker.AbsoluteSize.Y, 0, 1)
                            
                            local hue = 0 -- Get from hue slider
                            local color = Color3.fromHSV(hue, relativeX, 1 - relativeY)
                            updateColorPicker(color)
                        end
                    end)
                    
                    ui.InputEnded:Connect(function(endInput)
                        if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
                            connection:Disconnect()
                        end
                    end)
                end
            end)
            
            -- Call callback with default
            if default then task.defer(cb, default) end
        end
        
        -- NEW: Keybind Picker
        function contents:keybind(title, default, cb)
            local newKeybind = elements.KeybindElement or createKeybindElement(elements)
            if not newKeybind then
                newKeybind = createKeybindElement()
            end
            
            newKeybind.frame.lbl.Text = title
            newKeybind.Parent = newSect.sectioncontainer
            
            local keybindBtn = newKeybind.keybtn
            local currentKey = default or Enum.KeyCode.None
            local isListening = false
            
            keybindBtn.Text = currentKey.Name ~= "None" and currentKey.Name or "Click to bind"
            
            keybindBtn.MouseEnter:Connect(function() fadeelement(keybindBtn, true) end)
            keybindBtn.MouseLeave:Connect(function() fadeelement(keybindBtn, false) end)
            
            local function startListening()
                isListening = true
                keybindBtn.Text = "..."
                keybindBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
                
                local connection
                connection = ui.InputBegan:Connect(function(input, gameProcessed)
                    if not gameProcessed and isListening then
                        if input.KeyCode ~= Enum.KeyCode.Unknown then
                            currentKey = input.KeyCode
                            keybindBtn.Text = currentKey.Name
                            keybindBtn.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
                            isListening = false
                            connection:Disconnect()
                            if cb then cb(currentKey) end
                        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                            -- Allow mouse buttons too
                            currentKey = input.UserInputType
                            keybindBtn.Text = tostring(currentKey.Name):gsub("MouseButton", "Mouse ")
                            keybindBtn.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
                            isListening = false
                            connection:Disconnect()
                            if cb then cb(currentKey) end
                        end
                    end
                end)
            end
            
            keybindBtn.MouseButton1Click:Connect(function()
                if isListening then
                    isListening = false
                    keybindBtn.Text = currentKey.Name ~= "None" and currentKey.Name or "Click to bind"
                    keybindBtn.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
                else
                    startListening()
                end
            end)
        end
        
        -- NEW: Progress Bar
        function contents:progressbar(title, default, max)
            local newProgress = elements.ProgressElement or createProgressElement(elements)
            if not newProgress then
                newProgress = createProgressElement()
            end
            
            newProgress.lbl.Text = title
            newProgress.Parent = newSect.sectioncontainer
            
            local progressBar = newProgress.progressbar
            local progressFill = newProgress.progressfill
            local progressText = newProgress.progresstext
            
            local currentValue = default or 0
            local maximum = max or 100
            
            local function updateProgress(value)
                currentValue = math.clamp(value, 0, maximum)
                local percent = currentValue / maximum
                progressFill.Size = UDim2.new(percent, 0, 1, 0)
                progressText.Text = string.format("%d/%d", currentValue, maximum)
            end
            
            updateProgress(currentValue)
            
            -- Return methods to update progress
            return {
                update = function(value)
                    updateProgress(value)
                end,
                setMax = function(newMax)
                    maximum = newMax
                    updateProgress(currentValue)
                end
            }
        end
        
        -- NEW: Paragraph / Text Area
        function contents:paragraph(title, text)
            local newParagraph = elements.ParagraphElement or createParagraphElement(elements)
            if not newParagraph then
                newParagraph = createParagraphElement()
            end
            
            newParagraph.title.Text = title
            newParagraph.content.Text = text
            newParagraph.Parent = newSect.sectioncontainer
            
            -- Auto-resize based on text
            local textBounds = game:GetService("TextService"):GetTextSize(
                text,
                newParagraph.content.TextSize,
                newParagraph.content.Font,
                Vector2.new(300, math.huge)
            )
            newParagraph.Size = UDim2.new(1, 0, 0, textBounds.Y + 40)
        end
        
        -- NEW: Separator Line
        function contents:separator()
            local newSeparator = elements.SeparatorElement or createSeparatorElement(elements)
            if not newSeparator then
                newSeparator = createSeparatorElement()
            end
            
            newSeparator.Parent = newSect.sectioncontainer
        end

        return contents
    end

    return sections
end

-- Helper functions to create UI elements if they don't exist in your assets
function createDropdownElement()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 1, -5)
    btn.Position = UDim2.new(0, 5, 0, 2.5)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.BackgroundTransparency = 0.8
    btn.BorderSizePixel = 0
    btn.Text = ""
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = "Dropdown"
    lbl.Parent = btn
    
    local selected = Instance.new("TextLabel")
    selected.Size = UDim2.new(0.4, 0, 1, 0)
    selected.Position = UDim2.new(0.5, 0, 0, 0)
    selected.BackgroundTransparency = 1
    selected.TextColor3 = Color3.fromRGB(200, 200, 200)
    selected.TextXAlignment = Enum.TextXAlignment.Right
    selected.Text = ""
    selected.Parent = btn
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(150, 150, 150)
    arrow.Parent = btn
    
    local dropdownList = Instance.new("ScrollingFrame")
    dropdownList.Size = UDim2.new(1, -10, 0, 0)
    dropdownList.Position = UDim2.new(0, 5, 0, 40)
    dropdownList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    dropdownList.BorderSizePixel = 0
    dropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
    dropdownList.ScrollBarThickness = 4
    dropdownList.Parent = frame
    
    frame.btn = btn
    frame.frame = {lbl = lbl}
    frame.dropdownlist = dropdownList
    frame.selected = selected
    
    btn.Parent = frame
    return frame
end

function createColorPickerElement()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 1, -5)
    btn.Position = UDim2.new(0, 5, 0, 2.5)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.BackgroundTransparency = 0.8
    btn.BorderSizePixel = 0
    btn.Text = ""
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = "Color Picker"
    lbl.Parent = btn
    
    local colorDisplay = Instance.new("Frame")
    colorDisplay.Size = UDim2.new(0, 30, 0, 20)
    colorDisplay.Position = UDim2.new(1, -40, 0.5, -10)
    colorDisplay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    colorDisplay.BorderSizePixel = 0
    colorDisplay.Parent = btn
    
    frame.colorbtn = btn
    frame.frame = {lbl = lbl}
    frame.colordisplay = colorDisplay
    frame.colorpickerframe = Instance.new("Frame")
    frame.colorpickerframe.Size = UDim2.new(1, -10, 0, 150)
    frame.colorpickerframe.Position = UDim2.new(0, 5, 0, 40)
    frame.colorpickerframe.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.colorpickerframe.BorderSizePixel = 0
    frame.colorpickerframe.Visible = false
    frame.colorpickerframe.Parent = frame
    
    btn.Parent = frame
    return frame
end

function createKeybindElement()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = "Keybind"
    lbl.Parent = frame
    
    local keybtn = Instance.new("TextButton")
    keybtn.Size = UDim2.new(0.35, 0, 1, -10)
    keybtn.Position = UDim2.new(0.65, 0, 0, 5)
    keybtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    keybtn.BackgroundTransparency = 0.8
    keybtn.BorderSizePixel = 0
    keybtn.Text = "Click to bind"
    keybtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    keybtn.Parent = frame
    
    frame.frame = {lbl = lbl}
    frame.keybtn = keybtn
    
    return frame
end

function createProgressElement()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundTransparency = 1
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = "Progress"
    lbl.Parent = frame
    
    local progressbar = Instance.new("Frame")
    progressbar.Size = UDim2.new(1, -10, 0, 20)
    progressbar.Position = UDim2.new(0, 5, 0, 25)
    progressbar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    progressbar.BorderSizePixel = 0
    progressbar.Parent = frame
    
    local progressfill = Instance.new("Frame")
    progressfill.Size = UDim2.new(0, 0, 1, 0)
    progressfill.BackgroundColor3 = Color3.fromRGB(74, 255, 89)
    progressfill.BorderSizePixel = 0
    progressfill.Parent = progressbar
    
    local progresstext = Instance.new("TextLabel")
    progresstext.Size = UDim2.new(1, 0, 1, 0)
    progresstext.BackgroundTransparency = 1
    progresstext.TextColor3 = Color3.fromRGB(255, 255, 255)
    progresstext.Text = "0/100"
    progresstext.Parent = progressbar
    
    frame.lbl = lbl
    frame.progressbar = progressbar
    frame.progressfill = progressfill
    frame.progresstext = progresstext
    
    return frame
end

function createParagraphElement()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 80)
    frame.BackgroundTransparency = 1
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamSemibold
    title.Text = "Title"
    title.Parent = frame
    
    local content = Instance.new("TextLabel")
    content.Size = UDim2.new(1, -10, 0, 50)
    content.Position = UDim2.new(0, 5, 0, 25)
    content.BackgroundTransparency = 1
    content.TextColor3 = Color3.fromRGB(200, 200, 200)
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.TextYAlignment = Enum.TextYAlignment.Top
    content.TextWrapped = true
    content.Text = ""
    content.Parent = frame
    
    frame.title = title
    frame.content = content
    
    return frame
end

function createSeparatorElement()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 2)
    frame.Position = UDim2.new(0, 10, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    frame.BorderSizePixel = 0
    
    return frame
end

return module
