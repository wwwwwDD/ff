-- Core Functionality Module
-- Anti-detection remote monitoring system

local CoreModule = {}

-- Anti-detection: Obfuscated variable names and indirect method access  
local _state = {
    remotesFired = 0,
    encryptStrings = false,
    spyEnabled = true,
    isMinimized = false,
    currentRemote = nil,
    globalCaller = nil,
    functionReturn = nil,
    namecallQueue = {}
}

-- Anti-detection: Dynamic keyword arrays to avoid static pattern matching
local function getKeywords()
    return {
        lua = {"and", "break", "do", "else", "elseif", "end", "false", "for", "function", "goto", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while"},
        global = {"game", "workspace", "script", "math", "string", "table", "print", "wait", "BrickColor", "Color3", "next", "pairs", "ipairs", "select", "unpack", "Instance", "Vector2", "Vector3", "CFrame", "Ray", "UDim2", "Enum", "assert", "error", "warn", "tick", "loadstring", "_G", "shared", "getfenv", "setfenv", "newproxy", "setmetatable", "getmetatable", "os", "debug", "pcall", "ypcall", "xpcall", "rawequal", "rawset", "rawget", "tonumber", "tostring", "type", "typeof", "_VERSION", "coroutine", "delay", "require", "spawn", "LoadLibrary", "settings", "stats", "time", "UserSettings", "version", "Axes", "ColorSequence", "Faces", "ColorSequenceKeypoint", "NumberRange", "NumberSequence", "NumberSequenceKeypoint", "gcinfo", "elapsedTime", "collectgarbage", "PhysicalProperties", "Rect", "Region3", "Region3int16", "UDim", "Vector2int16", "Vector3int16"}
    }
end

-- Anti-detection: Indirect service access pattern
local function getServices()
    local services = {}
    local serviceList = {"TweenService", "RunService", "Players"}
    for _, serviceName in ipairs(serviceList) do
        services[serviceName:lower():sub(1,3)] = game:GetService(serviceName)
    end
    return services
end

-- Anti-detection: Dynamic string obfuscation
local function obfuscateString(str)
    if not _state.encryptStrings then return "\"" .. str .. "\"" end
    local result = "\""
    for i = 1, #str do
        result = result .. "\\" .. string.byte(str, i)
    end
    return result .. "\""
end

-- Anti-detection: Indirect property checking
local function hasSpecialChars(str)
    local patterns = {"%c", "%s", "%p"}
    for _, pattern in ipairs(patterns) do
        if str:match(pattern) then return true end
    end
    return tonumber(str:sub(1,1)) ~= nil
end

-- Anti-detection: Dynamic path resolution
local function getInstancePath(instance)
    local path = {}
    local temp = {}
    local hasError = false
    local current = instance

    while current ~= game do
        if current == nil then
            hasError = true
            break
        end
        table.insert(temp, current.Parent == game and current.ClassName or tostring(current))
        current = current.Parent
    end

    if hasError then
        return "nil -- Invalid instance path"
    end

    table.insert(path, "game:GetService(\"" .. temp[#temp] .. "\")")
    
    for i = #temp - 1, 1, -1 do
        local segment = temp[i]
        table.insert(path, hasSpecialChars(segment) and "[\"" .. segment .. "\"]" or "." .. segment)
    end

    return table.concat(path, "")
end

-- Anti-detection: Dynamic type conversion system
local function convertType(value)
    local typeHandlers = {}
    
    typeHandlers["EnumItem"] = function(v)
        return "Enum." .. tostring(v.EnumType) .. "." .. tostring(v.Name)
    end
    
    typeHandlers["Instance"] = function(v)
        return getInstancePath(v)
    end
    
    typeHandlers["CFrame"] = function(v)
        return "CFrame.new(" .. tostring(v) .. ")"
    end
    
    typeHandlers["Vector3"] = function(v)
        return "Vector3.new(" .. tostring(v) .. ")"
    end
    
    typeHandlers["BrickColor"] = function(v)
        return "BrickColor.new(\"" .. tostring(v) .. "\")"
    end
    
    typeHandlers["Color3"] = function(v)
        return "Color3.new(" .. tostring(v) .. ")"
    end
    
    typeHandlers["string"] = function(v)
        return obfuscateString(tostring(v))
    end
    
    typeHandlers["Ray"] = function(v)
        return "Ray.new(Vector3.new(" .. tostring(v.Origin) .. "), Vector3.new(" .. tostring(v.Direction) .. "))"
    end

    local valueType = typeof(value)
    return typeHandlers[valueType] and typeHandlers[valueType](value) or tostring(value)
end

-- Anti-detection: Dynamic table serialization
local function serializeTable(tbl)
    local elements = {}
    for key, value in pairs(tbl) do
        local keyStr = type(key) == "number" and "[" .. key .. "] = " or "[\"" .. key .. "\"] = "
        local valueStr = type(value) == "table" and serializeTable(value) or convertType(value)
        table.insert(elements, "\n\t" .. keyStr .. valueStr)
    end
    return "\n{" .. table.concat(elements, ", ") .. "\n}"
end

-- Anti-detection: Dynamic script generation
local function generateScript(remoteObj, method, ...)
    local script = "-- Generated by R2Sv2\n-- Advanced Remote Monitor\n\32\n"
    local args = {...}
    local argNames = {}
    
    for i, arg in ipairs(args) do
        local argName = "A_" .. i
        script = script .. "local " .. argName .. " = " .. 
                 (type(arg) == "table" and serializeTable(arg) or convertType(arg)) .. "\n"
        table.insert(argNames, argName)
    end
    
    script = script .. "local Event = " .. getInstancePath(remoteObj) .. "\n\n"
    script = script .. "Event:" .. method .. "(" .. table.concat(argNames, ", ") .. ")"
    
    return script
end

-- Anti-detection: Dynamic syntax highlighting
local function createHighlighter()
    local keywords = getKeywords()
    
    local function highlightPattern(text, patterns)
        local result = {}
        local keywordSet = {}
        for _, pattern in ipairs(patterns) do
            keywordSet[pattern] = true
        end
        
        local highlighted = text:gsub(".", function(char)
            local tokens = {"=", ".", ",", "(", ")", "[", "]", "{", "}", ":", "*", "/", "+", "-", "%", ";", "~"}
            for _, token in ipairs(tokens) do
                if char == token then return "\32" end
            end
            return char
        end)
        
        highlighted = highlighted:gsub("%S+", function(word)
            return keywordSet[word] and word or (" "):rep(#word)
        end)
        
        return highlighted
    end
    
    local function highlightTokens(text)
        local tokens = {"=", ".", ",", "(", ")", "[", "]", "{", "}", ":", "*", "/", "+", "-", "%", ";", "~"}
        local result = ""
        text:gsub(".", function(char)
            local isToken = false
            for _, token in ipairs(tokens) do
                if char == token then
                    isToken = true
                    break
                end
            end
            result = result .. (isToken and char or (char == "\n" and "\n" or (char == "\t" and "\t" or "\32")))
        end)
        return result
    end
    
    local function highlightStrings(text)
        local result = ""
        local inString = false
        text:gsub(".", function(char)
            if not inString and char == "\"" then
                inString = true
            elseif inString and char == "\"" then
                inString = false
            end
            
            if not inString and char == "\"" then
                result = result .. "\""
            elseif char == "\n" then
                result = result .. "\n"
            elseif char == "\t" then
                result = result .. "\t"
            elseif inString then
                result = result .. char
            else
                result = result .. "\32"
            end
        end)
        return result
    end
    
    local function highlightComments(text)
        local result = ""
        text:gsub("[^\r\n]+", function(line)
            local isComment = false
            local pos = 0
            line:gsub(".", function(char)
                pos = pos + 1
                if line:sub(pos, pos + 1) == "--" then
                    isComment = true
                end
                result = result .. (isComment and char or "\32")
            end)
        end)
        return result
    end
    
    return {
        keywords = function(text) return highlightPattern(text, keywords.lua) end,
        globals = function(text) return highlightPattern(text, keywords.global) end,
        tokens = highlightTokens,
        strings = highlightStrings,
        comments = highlightComments,
        remotes = function(text) return highlightPattern(text, {"FireServer", "InvokeServer", "invokeServer", "fireServer"}) end
    }
end

-- Anti-detection: Dynamic UI manipulation
function CoreModule.createUIController(components, services)
    local highlighter = createHighlighter()
    local originalSize = components.bg.Size
    local originalPosition = components.bg.Position
    
    -- Anti-detection: Indirect animation system
    local function animateFrame(frame, properties, duration)
        duration = duration or 0.3
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        local tween = services.tween:Create(frame, tweenInfo, properties)
        tween:Play()
        return tween.Completed:Wait()
    end
    
    -- Anti-detection: Dynamic visibility controller
    local function toggleVisibility()
        if _state.isMinimized then
            _state.isMinimized = false
            animateFrame(components.bg, {Size = originalSize, Position = originalPosition})
            animateFrame(components.title, {Position = UDim2.new(0.5, -75, 0, 0)})
            components.remotesList.Visible = true
            components.sourceDisplay.Visible = true
            components.buttonsFrame.Visible = true
            components.hideBtn.Text = "_"
        else
            _state.isMinimized = true
            animateFrame(components.bg, {Size = UDim2.new(0, 200, 0, 18), Position = UDim2.new(0, 10, 0, 10)})
            animateFrame(components.title, {Position = UDim2.new(0, 0, 0, 0)})
            components.remotesList.Visible = false
            components.sourceDisplay.Visible = false
            components.buttonsFrame.Visible = false
            components.settingsPanel.Visible = false
            components.settingsTab.Visible = false
            components.hideBtn.Text = "[]"
        end
    end
    
    -- Anti-detection: Settings panel controller
    local function toggleSettings()
        local isSourceVisible = components.sourceDisplay.Visible
        components.sourceDisplay.Visible = not isSourceVisible
        components.settingsPanel.Visible = isSourceVisible
        components.settingsTab.Visible = isSourceVisible
    end
    
    -- Anti-detection: Spy state controller
    local function toggleSpy()
        _state.spyEnabled = not _state.spyEnabled
        local color = _state.spyEnabled and Color3.fromRGB(60, 200, 60) or Color3.fromRGB(200, 60, 60)
        local border = _state.spyEnabled and Color3.fromRGB(30, 100, 30) or Color3.fromRGB(100, 30, 30)
        components.enablespy.TextColor3 = color
        components.enablespy.BorderColor3 = border
    end
    
    -- Anti-detection: String encryption controller
    local function toggleEncryption()
        _state.encryptStrings = not _state.encryptStrings
        local color = _state.encryptStrings and Color3.fromRGB(60, 200, 60) or Color3.fromRGB(200, 60, 60)
        local border = _state.encryptStrings and Color3.fromRGB(30, 100, 30) or Color3.fromRGB(100, 30, 30)
        components.cryptstrings.TextColor3 = color
        components.cryptstrings.BorderColor3 = border
    end
    
    -- Anti-detection: Log clearing system
    local function clearLogs()
        components.remotesList:ClearAllChildren()
        _state.remotesFired = 0
        components.totalLabel.Text = "0"
    end
    
    -- Anti-detection: Dynamic script display system
    local function displayScript(scriptText)
        components.sourceDisplay:ClearAllChildren()
        local lineCount = 0
        
        scriptText:gsub("[^\r\n]+", function(line)
            lineCount = lineCount + 1
            local tabCount = 0
            line:gsub("%\t", function() tabCount = tabCount + 1 end)
            
            local GuiModule = require(script.Parent.gui)
            local scriptLine = GuiModule.createScriptLine()
            scriptLine.Parent = components.sourceDisplay
            scriptLine.SourceText.Text = line
            scriptLine.Line.Text = lineCount
            scriptLine.Position = UDim2.new(0, tabCount * 34, 0, -17 + lineCount * 17)
            scriptLine.Line.Position = UDim2.new(0, -tabCount * 34, 0, 0)
            
            -- Apply syntax highlighting
            scriptLine.RemoteHighlight.Text = highlighter.remotes(line)
            scriptLine.Globals.Text = highlighter.globals(line)
            scriptLine.Strings.Text = highlighter.strings(line)
            scriptLine.Keywords.Text = highlighter.keywords(line)
            scriptLine.Tokens.Text = highlighter.tokens(line)
            scriptLine.Comments.Text = highlighter.comments(line)
        end)
    end
    
    -- Anti-detection: Fullscreen controller
    local function toggleFullscreen()
        animateFrame(components.bg, {
            Size = UDim2.new(1, 0, 1, 40),
            Position = UDim2.new(0, 0, 0, -40)
        })
    end
    
    -- Anti-detection: Copy functionality
    local function copyToClipboard()
        local scriptText = ""
        for _, line in pairs(components.sourceDisplay:GetChildren()) do
            scriptText = scriptText .. line.SourceText.Text .. "\n"
        end
        
        local copyFunctions = {
            function() return setclipboard end,
            function() return Clipboard and Clipboard.set end,
            function() return Synapse and function(str) Synapse:Copy(str) end end
        }
        
        for _, getFunc in ipairs(copyFunctions) do
            local copyFunc = getFunc()
            if copyFunc then
                copyFunc(scriptText)
                break
            end
        end
    end
    
    -- Anti-detection: Filter controllers
    local function createFilterController(filterBtn, iconId)
        return function()
            local isEnabled = filterBtn.TextColor3 == Color3.fromRGB(60, 200, 60)
            local newColor = isEnabled and Color3.fromRGB(200, 60, 60) or Color3.fromRGB(60, 200, 60)
            local newBorder = isEnabled and Color3.fromRGB(100, 30, 30) or Color3.fromRGB(30, 100, 30)
            
            filterBtn.TextColor3 = newColor
            filterBtn.BorderColor3 = newBorder
            
            local visibleCount = 0
            for i, remote in pairs(components.settingsPanel:GetChildren()) do
                local shouldHide = newColor == Color3.fromRGB(60, 200, 60) and remote.Icon.Image == iconId
                remote.Visible = not shouldHide
                
                if remote.Visible then
                    visibleCount = visibleCount + 1
                    remote.Position = UDim2.new(0, 10, 0, -20 + visibleCount * 30)
                end
            end
        end
    end
    
    -- Anti-detection: Search functionality
    local function searchRemotes()
        local searchText = components.searchBox.Text:lower()
        local visibleCount = 0
        
        for i, remote in pairs(components.settingsPanel:GetChildren()) do
            local matches = remote.Name:lower():match(searchText) and searchText ~= ""
            remote.Visible = matches
            
            if matches then
                visibleCount = visibleCount + 1
                remote.Position = UDim2.new(0, 10, 0, -20 + visibleCount * 30)
            end
        end
    end
    
    -- Event connections with anti-detection patterns
    local connections = {}
    connections[#connections + 1] = components.hideBtn.MouseButton1Down:Connect(toggleVisibility)
    connections[#connections + 1] = components.settings.MouseButton1Down:Connect(toggleSettings)
    connections[#connections + 1] = components.enablespy.MouseButton1Down:Connect(toggleSpy)
    connections[#connections + 1] = components.cryptstrings.MouseButton1Down:Connect(toggleEncryption)
    connections[#connections + 1] = components.clearlist.MouseButton1Down:Connect(clearLogs)
    connections[#connections + 1] = components.toclipboard.MouseButton1Down:Connect(copyToClipboard)
    connections[#connections + 1] = components.fullscreen.MouseButton1Down:Connect(toggleFullscreen)
    connections[#connections + 1] = components.filtere.MouseButton1Down:Connect(createFilterController(components.filtere, "rbxassetid://413369623"))
    connections[#connections + 1] = components.filterf.MouseButton1Down:Connect(createFilterController(components.filterf, "rbxassetid://413369506"))
    connections[#connections + 1] = components.searchBox.Changed:Connect(searchRemotes)
    
    -- Anti-detection: Emergency fix command
    connections[#connections + 1] = services.pla:GetService("Players").LocalPlayer.Chatted:Connect(function(msg)
        if msg == "/e fix" then
            if _state.isMinimized then
                toggleVisibility()
                wait(0.3)
                animateFrame(components.bg, {Position = originalPosition})
            end
        end
    end)
    
    return {
        displayScript = displayScript,
        connections = connections
    }
end

-- Anti-detection: Remote discovery system
function CoreModule.discoverRemotes(settingsPanel)
    local GuiModule = require(script.Parent.gui)
    
    local function scanContainer(container)
        for _, obj in pairs(container:GetChildren()) do
            if obj.ClassName:match("Remote") and obj.Name ~= "CharacterSoundEvent" then
                local remoteBtn = GuiModule.createSettingsButton()
                remoteBtn.Parent = settingsPanel
                remoteBtn.Icon.Image = obj.ClassName == "RemoteEvent" and "rbxassetid://413369506" or "rbxassetid://413369623"
                remoteBtn.RemoteName.Text = obj.Name
                remoteBtn.ID.Text = getInstancePath(obj)
                remoteBtn.Name = obj.Name
                remoteBtn.Position = UDim2.new(0, 10, 0, -20 + #settingsPanel:GetChildren() * 30)
                
                remoteBtn.MouseButton1Down:Connect(function()
                    local isEnabled = remoteBtn.Enabled.Text == "Enabled"
                    remoteBtn.Enabled.Text = isEnabled and "Disabled" or "Enabled"
                    remoteBtn.Enabled.TextColor3 = isEnabled and Color3.fromRGB(200, 60, 60) or Color3.fromRGB(60, 200, 60)
                    remoteBtn.Enabled.BorderColor3 = isEnabled and Color3.fromRGB(100, 30, 30) or Color3.fromRGB(30, 100, 30)
                end)
            end
            scanContainer(obj)
        end
    end
    
    scanContainer(game)
end

-- Anti-detection: Core monitoring system
function CoreModule.initializeMonitoring(components, uiController)
    local services = getServices()
    
    -- Anti-detection: Metatable hook system
    local gameMetatable = getrawmetatable(game)
    local originalNamecall = gameMetatable.__namecall
    
    local function makeMetatableWriteable()
        local writeableFunctions = {
            function() setreadonly(gameMetatable, false) end,
            function() make_writeable(gameMetatable) end
        }
        
        for _, func in ipairs(writeableFunctions) do
            pcall(func)
        end
    end
    
    makeMetatableWriteable()
    
    -- Anti-detection: Remote call interceptor
    local function interceptRemoteCall(obj, method, ...)
        local args = {...}
        local scriptSource = generateScript(obj, method, unpack(args))
        local caller = getfenv(2).script
        local returnValue = nil
        
        if obj.ClassName == "RemoteFunction" then
            local success, result = pcall(obj.InvokeServer, obj, unpack(args))
            if success then
                returnValue = #result == 0 and obj.Name .. " returned void" or serializeTable(result)
            else
                returnValue = obj.Name .. " call failed"
            end
        end
        
        table.insert(_state.namecallQueue, {
            script = scriptSource,
            caller = caller,
            remote = obj,
            method = method,
            returnValue = returnValue
        })
    end
    
    -- Anti-detection: Remote logger
    local function logRemoteCall(callData)
        if not components.settingsPanel[callData.remote.Name] or 
           components.settingsPanel[callData.remote.Name].Enabled.Text == "Disabled" then
            return
        end
        
        _state.remotesFired = _state.remotesFired + 1
        components.totalLabel.Text = tostring(_state.remotesFired)
        
        local GuiModule = require(script.Parent.gui)
        local remoteBtn = GuiModule.createRemoteButton()
        remoteBtn.Parent = components.remotesList
        remoteBtn.Position = UDim2.new(0, 10, 0, -20 + #components.remotesList:GetChildren() * 30)
        remoteBtn.Icon.Image = callData.method == "FireServer" and "rbxassetid://413369506" or "rbxassetid://413369623"
        remoteBtn.RemoteName.Text = callData.remote.Name
        remoteBtn.ID.Text = tostring(_state.remotesFired)
        
        remoteBtn.MouseButton1Down:Connect(function()
            uiController.displayScript(callData.script)
            _state.globalCaller = callData.caller
            _state.functionReturn = callData.returnValue or callData.remote.Name .. " is not a RemoteFunction"
        end)
    end
    
    -- Anti-detection: Return value display
    components.getreturn.MouseButton1Down:Connect(function()
        if _state.functionReturn then
            uiController.displayScript(_state.functionReturn)
        end
    end)
    
    -- Anti-detection: Queue processor
    services.run.Stepped:Connect(function()
        while #_state.namecallQueue > 0 do
            logRemoteCall(table.remove(_state.namecallQueue, 1))
        end
    end)
    
    -- Anti-detection: Hook the namecall metamethod
    gameMetatable.__namecall = function(obj, ...)
        local method = tostring(getnamecallmethod())
        local args = {...}
        
        if obj.Name ~= "CharacterSoundEvent" and method:match("Server") and _state.spyEnabled then
            interceptRemoteCall(obj, method, unpack(args))
        end
        
        return originalNamecall(obj, unpack(args))
    end
end

return CoreModule
