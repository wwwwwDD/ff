-- GUI Components Module
-- Separated UI creation and styling

local GuiModule = {}

-- Anti-detection: Dynamic property names and indirect references
local function createUI()
    local services = {
        core = game:GetService("CoreGui"),
        tween = game:GetService("TweenService"),
        run = game:GetService("RunService"),
        players = game:GetService("Players")
    }
    
    -- Main container structure
    local components = {}
    
    -- Create main screen GUI
    components.main = Instance.new("ScreenGui")
    components.main.Name = "RemoteSpy"
    components.main.Parent = services.core
    components.main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Background frame
    components.bg = Instance.new("Frame")
    components.bg.Name = "BG"
    components.bg.Parent = components.main
    components.bg.Active = true
    components.bg.BackgroundColor3 = Color3.new(0.141176, 0.141176, 0.141176)
    components.bg.BorderColor3 = Color3.new(0.243137, 0.243137, 0.243137)
    components.bg.Draggable = true
    components.bg.Position = UDim2.new(0.3, 0, 0.2, 0)
    components.bg.Size = UDim2.new(0.4, 0, 0.6, 0)
    components.bg.ClipsDescendants = true

    -- Top ribbon
    components.ribbon = Instance.new("Frame")
    components.ribbon.Name = "Ribbon"
    components.ribbon.Parent = components.bg
    components.ribbon.BackgroundColor3 = Color3.new(0.760784, 0.0117647, 0.317647)
    components.ribbon.BorderSizePixel = 0
    components.ribbon.Size = UDim2.new(1, 0, 0, 18)
    components.ribbon.ZIndex = 2

    -- Hide button
    components.hideBtn = Instance.new("TextButton")
    components.hideBtn.Name = "Hide"
    components.hideBtn.Parent = components.ribbon
    components.hideBtn.BackgroundColor3 = Color3.new(1, 0, 0)
    components.hideBtn.BorderSizePixel = 0
    components.hideBtn.Position = UDim2.new(1, -30, 0, 0)
    components.hideBtn.Size = UDim2.new(0, 30, 0, 18)
    components.hideBtn.ZIndex = 3
    components.hideBtn.Font = Enum.Font.SourceSansBold
    components.hideBtn.FontSize = Enum.FontSize.Size12
    components.hideBtn.Text = "_"
    components.hideBtn.TextColor3 = Color3.new(1, 1, 1)
    components.hideBtn.TextSize = 12

    -- Title label
    components.title = Instance.new("TextLabel")
    components.title.Name = "Title"
    components.title.Parent = components.ribbon
    components.title.BackgroundColor3 = Color3.new(1, 0.0117647, 0.423529)
    components.title.BorderSizePixel = 0
    components.title.Position = UDim2.new(0.5, -75, 0, 0)
    components.title.Size = UDim2.new(0, 150, 0, 18)
    components.title.ZIndex = 3
    components.title.Font = Enum.Font.SourceSansBold
    components.title.FontSize = Enum.FontSize.Size12
    components.title.Text = "Remote2Script v2"
    components.title.TextColor3 = Color3.new(1, 1, 1)
    components.title.TextSize = 12

    -- Fullscreen button
    components.fullscreen = Instance.new("TextButton")
    components.fullscreen.Name = "FullScreen"
    components.fullscreen.Parent = components.ribbon
    components.fullscreen.BackgroundColor3 = Color3.new(1, 0, 0)
    components.fullscreen.BorderSizePixel = 0
    components.fullscreen.Position = UDim2.new(1, -65, 0, 0)
    components.fullscreen.Size = UDim2.new(0, 30, 0, 18)
    components.fullscreen.ZIndex = 3
    components.fullscreen.Font = Enum.Font.SourceSansBold
    components.fullscreen.FontSize = Enum.FontSize.Size12
    components.fullscreen.Text = "[~]"
    components.fullscreen.TextColor3 = Color3.new(1, 1, 1)
    components.fullscreen.TextSize = 12

    -- Remotes list scroll frame
    components.remotesList = Instance.new("ScrollingFrame")
    components.remotesList.Name = "Remotes"
    components.remotesList.Parent = components.bg
    components.remotesList.BackgroundColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314)
    components.remotesList.BorderColor3 = Color3.new(0.243137, 0.243137, 0.243137)
    components.remotesList.Position = UDim2.new(0, 5, 0, 60)
    components.remotesList.CanvasSize = UDim2.new(0, 0, 40, 0)
    components.remotesList.Size = UDim2.new(0, 180, 1, -65)
    components.remotesList.ZIndex = 2
    components.remotesList.BottomImage = "rbxassetid://148970562"
    components.remotesList.MidImage = "rbxassetid://148970562"
    components.remotesList.ScrollBarThickness = 4
    components.remotesList.TopImage = "rbxassetid://148970562"

    -- Source code display
    components.sourceDisplay = Instance.new("ScrollingFrame")
    components.sourceDisplay.Name = "Source"
    components.sourceDisplay.Parent = components.bg
    components.sourceDisplay.BackgroundColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314)
    components.sourceDisplay.BorderColor3 = Color3.new(0.243137, 0.243137, 0.243137)
    components.sourceDisplay.Position = UDim2.new(0, 190, 0, 60)
    components.sourceDisplay.Size = UDim2.new(1, -195, 1, -65)
    components.sourceDisplay.ZIndex = 2
    components.sourceDisplay.BottomImage = "rbxassetid://148970562"
    components.sourceDisplay.CanvasSize = UDim2.new(3, 0, 160, 0)
    components.sourceDisplay.MidImage = "rbxassetid://148970562"
    components.sourceDisplay.ScrollBarThickness = 4
    components.sourceDisplay.TopImage = "rbxassetid://148970562"

    -- Buttons frame
    components.buttonsFrame = Instance.new("Frame")
    components.buttonsFrame.Name = "ButtonsFrame"
    components.buttonsFrame.Parent = components.bg
    components.buttonsFrame.BackgroundColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314)
    components.buttonsFrame.BorderColor3 = Color3.new(0.243137, 0.243137, 0.243137)
    components.buttonsFrame.Position = UDim2.new(0, 5, 0, 25)
    components.buttonsFrame.Size = UDim2.new(1, -10, 0, 30)
    components.buttonsFrame.ZIndex = 2
    components.buttonsFrame.ClipsDescendants = true

    -- Control buttons
    local buttonConfigs = {
        {name = "ToClipboard", text = "COPY", pos = UDim2.new(0, 5, 0.5, -10), 
         color = Color3.new(0.235294, 0.784314, 0.235294), border = Color3.new(0.117647, 0.392157, 0.117647)},
        {name = "GetReturn", text = "RETURN", pos = UDim2.new(0, 80, 0.5, -10), 
         color = Color3.new(0.784314, 0.784314, 0.784314), border = Color3.new(0.384314, 0.384314, 0.384314)},
        {name = "ClearList", text = "CLEAR", pos = UDim2.new(0, 155, 0.5, -10), 
         color = Color3.new(0.784314, 0.784314, 0.784314), border = Color3.new(0.384314, 0.384314, 0.384314)},
        {name = "CryptStrings", text = "CRYPT", pos = UDim2.new(0, 230, 0.5, -10), 
         color = Color3.new(0.784314, 0.235294, 0.235294), border = Color3.new(0.392157, 0.117647, 0.117647)},
        {name = "EnableSpy", text = "SPY", pos = UDim2.new(0, 305, 0.5, -10), 
         color = Color3.fromRGB(60, 200, 60), border = Color3.fromRGB(30, 100, 30)},
        {name = "Settings", text = "REMOTES", pos = UDim2.new(1, -75, 0.5, -10), 
         color = Color3.new(0.235294, 0.784314, 0.784314), border = Color3.new(0.117647, 0.392157, 0.392157)}
    }

    for _, config in ipairs(buttonConfigs) do
        local btn = Instance.new("TextButton")
        btn.Name = config.name
        btn.Parent = components.buttonsFrame
        btn.BackgroundColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314)
        btn.BorderColor3 = config.border
        btn.Position = config.pos
        btn.Size = UDim2.new(0, 70, 0, 18)
        btn.ZIndex = 3
        btn.Font = Enum.Font.SourceSansBold
        btn.FontSize = Enum.FontSize.Size12
        btn.Text = config.text
        btn.TextColor3 = config.color
        btn.TextSize = 12
        components[config.name:lower()] = btn
    end

    -- Status labels
    components.lastLabel = Instance.new("TextLabel")
    components.lastLabel.Name = "Last"
    components.lastLabel.Parent = components.buttonsFrame
    components.lastLabel.BackgroundColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314)
    components.lastLabel.BorderColor3 = Color3.new(0.384314, 0.384314, 0.384314)
    components.lastLabel.Position = UDim2.new(0, 380, 0.5, -10)
    components.lastLabel.Size = UDim2.new(0, 120, 0, 18)
    components.lastLabel.ZIndex = 3
    components.lastLabel.Font = Enum.Font.SourceSansBold
    components.lastLabel.FontSize = Enum.FontSize.Size12
    components.lastLabel.Text = ""
    components.lastLabel.TextColor3 = Color3.new(1, 1, 1)
    components.lastLabel.TextSize = 12
    components.lastLabel.TextWrapped = true

    components.totalLabel = Instance.new("TextLabel")
    components.totalLabel.Name = "Total"
    components.totalLabel.Parent = components.buttonsFrame
    components.totalLabel.BackgroundColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314)
    components.totalLabel.BorderColor3 = Color3.new(0.384314, 0.384314, 0.384314)
    components.totalLabel.Position = UDim2.new(0, 505, 0.5, -10)
    components.totalLabel.Size = UDim2.new(0, 40, 0, 18)
    components.totalLabel.ZIndex = 3
    components.totalLabel.Font = Enum.Font.SourceSansBold
    components.totalLabel.FontSize = Enum.FontSize.Size12
    components.totalLabel.Text = "0"
    components.totalLabel.TextColor3 = Color3.new(1, 1, 1)
    components.totalLabel.TextSize = 12
    components.totalLabel.TextWrapped = true

    -- Settings panel
    components.settingsPanel = Instance.new("ScrollingFrame")
    components.settingsPanel.Name = "SetRemotes"
    components.settingsPanel.Parent = components.bg
    components.settingsPanel.BackgroundColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314)
    components.settingsPanel.BorderColor3 = Color3.new(0.243137, 0.243137, 0.243137)
    components.settingsPanel.Position = UDim2.new(0, 190, 0, 60)
    components.settingsPanel.Size = UDim2.new(1, -195, 1, -100)
    components.settingsPanel.Visible = false
    components.settingsPanel.ZIndex = 2
    components.settingsPanel.BottomImage = "rbxassetid://148970562"
    components.settingsPanel.CanvasSize = UDim2.new(0, 0, 25, 0)
    components.settingsPanel.MidImage = "rbxassetid://148970562"
    components.settingsPanel.ScrollBarThickness = 4
    components.settingsPanel.TopImage = "rbxassetid://148970562"

    -- Settings tab
    components.settingsTab = Instance.new("Frame")
    components.settingsTab.Name = "SetRemotesTab"
    components.settingsTab.Parent = components.bg
    components.settingsTab.Visible = false
    components.settingsTab.BackgroundColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314)
    components.settingsTab.BorderColor3 = Color3.new(0.243137, 0.243137, 0.243137)
    components.settingsTab.ClipsDescendants = true
    components.settingsTab.Position = UDim2.new(0, 190, 1, -40)
    components.settingsTab.Size = UDim2.new(1, -195, 0, 35)
    components.settingsTab.ZIndex = 2

    -- Filter buttons in settings tab
    local filterConfigs = {
        {name = "FilterE", text = "FILTER EVT", pos = UDim2.new(0, 5, 0.5, -10), size = UDim2.new(0, 80, 0, 18)},
        {name = "FilterF", text = "FILTER FUNC", pos = UDim2.new(0, 90, 0.5, -10), size = UDim2.new(0, 90, 0, 18)}
    }

    for _, config in ipairs(filterConfigs) do
        local btn = Instance.new("TextButton")
        btn.Name = config.name
        btn.Parent = components.settingsTab
        btn.BackgroundColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314)
        btn.BorderColor3 = Color3.new(0.392157, 0.117647, 0.117647)
        btn.Position = config.pos
        btn.Size = config.size
        btn.ZIndex = 3
        btn.Font = Enum.Font.SourceSansBold
        btn.FontSize = Enum.FontSize.Size12
        btn.Text = config.text
        btn.TextColor3 = Color3.new(0.784314, 0.235294, 0.235294)
        btn.TextSize = 12
        components[config.name:lower()] = btn
    end

    -- Search box
    components.searchBox = Instance.new("TextBox")
    components.searchBox.Name = "Search"
    components.searchBox.Parent = components.settingsTab
    components.searchBox.BackgroundColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314)
    components.searchBox.BorderColor3 = Color3.new(0.243137, 0.243137, 0.243137)
    components.searchBox.Position = UDim2.new(0, 185, 0.5, -10)
    components.searchBox.Selectable = true
    components.searchBox.Size = UDim2.new(1, -190, 0, 18)
    components.searchBox.ZIndex = 3
    components.searchBox.Font = Enum.Font.SourceSansBold
    components.searchBox.FontSize = Enum.FontSize.Size12
    components.searchBox.Text = "[SEARCH]"
    components.searchBox.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
    components.searchBox.TextSize = 12

    -- Storage for templates
    components.storage = Instance.new("Frame")
    components.storage.Name = "Storage"
    components.storage.Parent = components.main
    components.storage.BackgroundColor3 = Color3.new(1, 1, 1)
    components.storage.Size = UDim2.new(0, 100, 0, 100)
    components.storage.Visible = false

    return components, services
end

-- Template creation functions
function GuiModule.createRemoteButton()
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314)
    btn.BorderColor3 = Color3.new(0.243137, 0.243137, 0.243137)
    btn.Size = UDim2.new(1, -10, 0, 18)
    btn.ZIndex = 3
    btn.Font = Enum.Font.SourceSansBold
    btn.FontSize = Enum.FontSize.Size12
    btn.Text = ""
    btn.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left

    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Parent = btn
    icon.BackgroundTransparency = 1
    icon.Size = UDim2.new(0, 18, 0, 18)
    icon.ZIndex = 4

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Name = "RemoteName"
    nameLbl.Parent = btn
    nameLbl.BackgroundColor3 = Color3.new(0.713726, 0.00392157, 0.298039)
    nameLbl.BorderSizePixel = 0
    nameLbl.Position = UDim2.new(0, 25, 0, 0)
    nameLbl.Size = UDim2.new(0, 100, 0, 18)
    nameLbl.ZIndex = 4
    nameLbl.Font = Enum.Font.SourceSansBold
    nameLbl.FontSize = Enum.FontSize.Size12
    nameLbl.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
    nameLbl.TextSize = 12

    local idLbl = Instance.new("TextLabel")
    idLbl.Name = "ID"
    idLbl.Parent = btn
    idLbl.BackgroundColor3 = Color3.new(0.458824, 0.00392157, 0.192157)
    idLbl.BorderSizePixel = 0
    idLbl.Position = UDim2.new(1, -40, 0, 0)
    idLbl.Size = UDim2.new(0, 40, 0, 18)
    idLbl.ZIndex = 4
    idLbl.Font = Enum.Font.SourceSansBold
    idLbl.FontSize = Enum.FontSize.Size12
    idLbl.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
    idLbl.TextSize = 12

    return btn
end

function GuiModule.createSettingsButton()
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314)
    btn.BorderColor3 = Color3.new(0.243137, 0.243137, 0.243137)
    btn.Size = UDim2.new(1, -10, 0, 18)
    btn.ZIndex = 3
    btn.Font = Enum.Font.SourceSansBold
    btn.FontSize = Enum.FontSize.Size12
    btn.Text = ""
    btn.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left

    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Parent = btn
    icon.BackgroundTransparency = 1
    icon.Size = UDim2.new(0, 18, 0, 18)
    icon.ZIndex = 4
    icon.Image = "rbxassetid://413369506"

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Name = "RemoteName"
    nameLbl.Parent = btn
    nameLbl.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    nameLbl.BorderSizePixel = 1
    nameLbl.BorderColor3 = Color3.fromRGB(62, 62, 62)
    nameLbl.Position = UDim2.new(0, 25, 0, 0)
    nameLbl.Size = UDim2.new(0, 100, 0, 18)
    nameLbl.ZIndex = 4
    nameLbl.Font = Enum.Font.SourceSansBold
    nameLbl.FontSize = Enum.FontSize.Size12
    nameLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    nameLbl.TextSize = 11

    local idLbl = Instance.new("TextLabel")
    idLbl.Name = "ID"
    idLbl.Parent = btn
    idLbl.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    idLbl.BorderSizePixel = 1
    idLbl.BorderColor3 = Color3.fromRGB(62, 62, 62)
    idLbl.Position = UDim2.new(1, -500, 0, 0)
    idLbl.Size = UDim2.new(0, 500, 0, 18)
    idLbl.ZIndex = 3
    idLbl.Font = Enum.Font.SourceSansBold
    idLbl.FontSize = Enum.FontSize.Size12
    idLbl.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
    idLbl.TextSize = 12

    local enabledLbl = Instance.new("TextLabel")
    enabledLbl.Name = "Enabled"
    enabledLbl.Parent = btn
    enabledLbl.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    enabledLbl.BorderSizePixel = 1
    enabledLbl.BorderColor3 = Color3.fromRGB(30, 100, 30)
    enabledLbl.Position = UDim2.new(0, 150, 0, 0)
    enabledLbl.Size = UDim2.new(0, 70, 1, 0)
    enabledLbl.ZIndex = 4
    enabledLbl.Font = Enum.Font.SourceSansBold
    enabledLbl.FontSize = Enum.FontSize.Size12
    enabledLbl.Text = "Enabled"
    enabledLbl.TextColor3 = Color3.fromRGB(60, 200, 60)
    enabledLbl.TextSize = 12

    return btn
end

function GuiModule.createScriptLine()
    local line = Instance.new("Frame")
    line.BackgroundTransparency = 1
    line.Size = UDim2.new(1, 0, 0, 15)
    line.ZIndex = 2

    local lineNum = Instance.new("TextLabel")
    lineNum.Name = "Line"
    lineNum.Parent = line
    lineNum.BackgroundTransparency = 1
    lineNum.Size = UDim2.new(0, 30, 1, 0)
    lineNum.ZIndex = 3
    lineNum.Font = Enum.Font.SourceSansBold
    lineNum.FontSize = Enum.FontSize.Size14
    lineNum.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
    lineNum.TextSize = 14

    local sourceText = Instance.new("TextLabel")
    sourceText.Name = "SourceText"
    sourceText.Parent = line
    sourceText.BackgroundTransparency = 1
    sourceText.Position = UDim2.new(0, 30, 0, 0)
    sourceText.Size = UDim2.new(1, -30, 1, 0)
    sourceText.ZIndex = 3
    sourceText.Font = Enum.Font.Code
    sourceText.FontSize = Enum.FontSize.Size14
    sourceText.TextColor3 = Color3.new(1, 1, 1)
    sourceText.TextSize = 14
    sourceText.TextXAlignment = Enum.TextXAlignment.Left

    -- Syntax highlighting layers
    local highlightTypes = {
        {name = "Tokens", color = Color3.new(0.392157, 0.392157, 0.392157)},
        {name = "Strings", color = Color3.new(1, 0.615686, 0)},
        {name = "Comments", color = Color3.fromRGB(60, 200, 60)},
        {name = "Keywords", color = Color3.new(0.231373, 1, 0)},
        {name = "Globals", color = Color3.new(1, 0, 0)},
        {name = "RemoteHighlight", color = Color3.fromRGB(0, 145, 255)}
    }

    for _, hType in ipairs(highlightTypes) do
        local highlight = Instance.new("TextLabel")
        highlight.Name = hType.name
        highlight.Parent = line
        highlight.BackgroundTransparency = 1
        highlight.Position = UDim2.new(0, 30, 0, 0)
        highlight.Size = UDim2.new(1, -30, 1, 0)
        highlight.ZIndex = hType.name == "RemoteHighlight" and 3 or (hType.name == "Strings" or hType.name == "Comments") and 5 or 3
        highlight.Font = Enum.Font.Code
        highlight.FontSize = Enum.FontSize.Size14
        highlight.TextColor3 = hType.color
        highlight.TextSize = 14
        highlight.TextXAlignment = Enum.TextXAlignment.Left
    end

    return line
end

-- Initialize the GUI
function GuiModule.init()
    return createUI()
end

return GuiModule
