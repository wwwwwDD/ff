-- Конфигурационные переменные
local var_EventsCount = 0
local var_EncryptStrings = false
local var_MonitoringActive = true

-- Списки для подсветки синтаксиса
local var_LuaKeywords = {"and", "break", "do", "else", "elseif", "end", "false", "for", "function", "goto", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while"}
local var_GlobalEnvironment = {"game", "workspace", "script", "math", "string", "table", "print", "wait", "BrickColor", "Color3", "next", "pairs", "ipairs", "select", "unpack", "Instance", "Vector2", "Vector3", "CFrame", "Ray", "UDim2", "Enum", "assert", "error", "warn", "tick", "loadstring", "_G", "shared", "getfenv", "setfenv", "newproxy", "setmetatable", "getmetatable", "os", "debug", "pcall", "ypcall", "xpcall", "rawequal", "rawset", "rawget", "tonumber", "tostring", "type", "typeof", "_VERSION", "coroutine", "delay", "require", "spawn", "LoadLibrary", "settings", "stats", "time", "UserSettings", "version", "Axes", "ColorSequence", "Faces", "ColorSequenceKeypoint", "NumberRange", "NumberSequence", "NumberSequenceKeypoint", "gcinfo", "elapsedTime", "collectgarbage", "PhysicalProperties", "Rect", "Region3", "Region3int16", "UDim", "Vector2int16", "Vector3int16"}

-- Сервисы
local var_TweenService = game:GetService("TweenService")
local var_RunService = game:GetService("RunService")
local var_OriginalSize = MainContainer.Size
local var_OriginalPosition = MainContainer.Position
local var_IsMinimized = false
local var_PendingEvents = {}
local var_CurrentRemote = nil
local var_CallerScript = nil
local var_FunctionResult = nil

-- Вспомогательные функции
local function CheckSpecialCharacters(str)
    return (str:match("%c") or str:match("%s") or str:match("%p") or tonumber(str:sub(1,1))) ~= nil
end

local function GetInstancePath(instance)
    local current = instance
    local pathParts = {}
    local errorOccurred = false

    while current ~= game do
        if current == nil then
            errorOccurred = true
            break
        end
        table.insert(pathParts, current.Parent == game and current.ClassName or tostring(current))
        current = current.Parent
    end

    local result = {"game:GetService(\"" .. pathParts[#pathParts] .. "\")"}
    
    for i = #pathParts - 1, 1, -1 do
        table.insert(result, CheckSpecialCharacters(pathParts[i]) and "[\"" .. pathParts[i] .. "\"]" or "." .. pathParts[i])
    end

    return errorOccurred and "nil -- Invalid instance path" or table.concat(result, "")
end

local function ConvertToLuaType(value)
    local typeHandlers = {
        EnumItem = function()
            return "Enum." .. tostring(value.EnumType) .. "." .. tostring(value.Name)
        end,
        Instance = function()
            return GetInstancePath(value)
        end,
        CFrame = function()
            return "CFrame.new(" .. tostring(value) .. ")"
        end,
        Vector3 = function()
            return "Vector3.new(" .. tostring(value) .. ")"
        end,
        BrickColor = function()
            return "BrickColor.new(\"" .. tostring(value) .. "\")"
        end,
        Color3 = function()
            return "Color3.new(" .. tostring(value) .. ")"
        end,
        string = function()
            local str = tostring(value)
            return "\"" .. (var_EncryptStrings and str:gsub(".", function(c) return "\\" .. c:byte() end) or str) .. "\""
        end,
        Ray = function()
            return "Ray.new(Vector3.new(" .. tostring(value.Origin) .. "), Vector3.new(" .. tostring(value.Direction) .. "))"
        end
    }

    return typeHandlers[typeof(value)] ~= nil and typeHandlers[typeof(value)]() or tostring(value)
end

-- Функции анимации
local function AnimateSize(element, targetSize)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local tween = var_TweenService:Create(element, tweenInfo, {Size = targetSize})
    tween:Play()
    tween.Completed:Wait()
end

local function AnimatePosition(element, targetPosition)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local tween = var_TweenService:Create(element, tweenInfo, {Position = targetPosition})
    tween:Play()
    tween.Completed:Wait()
end

-- Обработчики интерфейса
local function ToggleMinimize()
    print("ToggleMinimize called")
    var_IsMinimized = not var_IsMinimized
    if var_IsMinimized then
        AnimateSize(MainContainer, UDim2.new(0, 200, 0, 18))
        AnimatePosition(MainContainer, UDim2.new(0, 10, 0, 10))
        AnimatePosition(HeaderTitle, UDim2.new(0, 0, 0, 0))
        EventsList.Visible = false
        CodeView.Visible = false
        ControlPanel.Visible = false
        var_RemoteSettings.Visible = false
        var_SettingsTab.Visible = false
        MinimizeButton.Text = "[]"
    else
        AnimateSize(MainContainer, var_OriginalSize)
        AnimatePosition(MainContainer, var_OriginalPosition)
        AnimatePosition(HeaderTitle, UDim2.new(0.5, -75, 0, 0))
        EventsList.Visible = true
        CodeView.Visible = true
        ControlPanel.Visible = true
        MinimizeButton.Text = "_"
    end
end

local function ToggleSettings()
    print("ToggleSettings called")
    CodeView.Visible = not CodeView.Visible
    var_RemoteSettings.Visible = not CodeView.Visible
    var_SettingsTab.Visible = not CodeView.Visible
end

local function ToggleMonitoring()
    print("ToggleMonitoring called")
    var_MonitoringActive = not var_MonitoringActive
    var_EnableMonitoring.TextColor3 = var_MonitoringActive and Color3.fromRGB(60, 200, 60) or Color3.fromRGB(200, 60, 60)
    var_EnableMonitoring.BorderColor3 = var_MonitoringActive and Color3.fromRGB(30, 100, 30) or Color3.fromRGB(100, 30, 30)
end

local function ToggleStringEncryption()
    print("ToggleStringEncryption called")
    var_EncryptStrings = not var_EncryptStrings
    StringEncryptionButton.TextColor3 = var_EncryptStrings and Color3.fromRGB(60, 200, 60) or Color3.fromRGB(200, 60, 60)
    StringEncryptionButton.BorderColor3 = var_EncryptStrings and Color3.fromRGB(30, 100, 30) or Color3.fromRGB(100, 30, 30)
end

local function ClearEventLogs()
    print("ClearEventLogs called")
    EventsList:ClearAllChildren()
    var_EventsCount = 0
    var_TotalEventsLabel.Text = "0"
end

local function CopyCode()
    print("CopyCode called")
    if var_CurrentRemote and var_PendingEvents[var_CurrentRemote] then
        local script = var_PendingEvents[var_CurrentRemote].script
        setclipboard(script)
        print("Copied to clipboard:", script)
    end
end

local function GetResult()
    print("GetResult called")
    if var_CurrentRemote and var_PendingEvents[var_CurrentRemote] then
        local result = var_PendingEvents[var_CurrentRemote].result or "No result available"
        setclipboard(result)
        print("Result copied:", result)
    end
end

-- Функции для работы с кодом
local function SerializeTable(data)
    local result = {}
    for key, value in pairs(data) do
        local keyStr = type(key) == "number" and "[" .. key .. "] = " or "[\"" .. key .. "\"] = "
        table.insert(result, "\n\t" .. keyStr .. (type(value) == "table" and SerializeTable(value) or ConvertToLuaType(value)))
    end
    return "\n{" .. table.concat(result, ", ") .. "\n}"
end

local function GenerateEventScript(object, method, ...)
    local scriptLines = {"-- Script generated by EventMonitor", "-- EventMonitor developed by Luckyxero", "\32"}
    local arguments = {}
    
    for i, arg in pairs({...}) do
        table.insert(scriptLines, "local Arg_" .. i .. " = " .. (type(arg) == "table" and SerializeTable(arg) or ConvertToLuaType(arg)))
        table.insert(arguments, "Arg_" .. i)
    end
    
    table.insert(scriptLines, "local Event = " .. GetInstancePath(object))
    table.insert(scriptLines, "")
    table.insert(scriptLines, "Event:" .. method .. "(" .. table.concat(arguments, ", ") .. ")")
    
    return table.concat(scriptLines, "\n")
end

-- Подключение обработчиков событий
MinimizeButton.MouseButton1Click:Connect(ToggleMinimize)
var_SettingsButton.MouseButton1Click:Connect(ToggleSettings)
ClearButton.MouseButton1Click:Connect(ClearEventLogs)
var_EnableMonitoring.MouseButton1Click:Connect(ToggleMonitoring)
StringEncryptionButton.MouseButton1Click:Connect(ToggleStringEncryption)
CopyButton.MouseButton1Click:Connect(CopyCode)
GetResultButton.MouseButton1Click:Connect(GetResult)

-- Основная логика мониторинга
local var_GameMeta = getrawmetatable(game)
local var_OriginalNamecall = var_GameMeta.__namecall

-- Перехватчик вызовов
local function NamecallHandler(object, ...)
    local success, result = pcall(function()
        local methodName = tostring(getnamecallmethod())
        local arguments = {...}
        
        if var_MonitoringActive and (methodName == "FireServer" or methodName == "InvokeServer") then
            print("Intercepted:", object.Name, methodName, arguments) -- Отладка
            local eventData = {
                script = GenerateEventScript(object, methodName, ...),
                caller = getfenv(2).script,
                object = object,
                method = methodName,
                result = nil
            }
            
            if methodName == "InvokeServer" then
                local success, invokeResult = pcall(object.InvokeServer, object, ...)
                if success then
                    eventData.result = type(invokeResult) == "table" and SerializeTable(invokeResult) or tostring(invokeResult)
                else
                    eventData.result = "Error: " .. invokeResult
                end
            end
            
            table.insert(var_PendingEvents, eventData)
            var_CurrentRemote = #var_PendingEvents
        end
        
        return var_OriginalNamecall(object, ...)
    end)
    
    if not success then
        warn("Error in NamecallHandler:", result)
        return var_OriginalNamecall(object, ...)
    end
    return result
end

-- Используем hookmetamethod, если доступно
if hookmetamethod then
    hookmetamethod(game, "__namecall", NamecallHandler)
else
    warn("hookmetamethod not available, falling back to direct metatable modification")
    local function MakeWritable()
        if setreadonly then
            setreadonly(var_GameMeta, false)
        elseif make_writeable then
            make_writeable(var_GameMeta)
        end
    end
    MakeWritable()
    var_GameMeta.__namecall = NamecallHandler
end

-- Обработка накопленных событий
var_RunService.Stepped:Connect(function()
    while #var_PendingEvents > 0 do
        local event = table.remove(var_PendingEvents, 1)
        var_EventsCount = var_EventsCount + 1
        var_TotalEventsLabel.Text = tostring(var_EventsCount)
        var_LastEventLabel.Text = event.object.Name
        
        -- Создание нового элемента в EventsList
        local newEvent = var_EventTemplate:Clone()
        newEvent.Parent = EventsList
        newEvent.Visible = true
        newEvent.Position = UDim2.new(0, 5, 0, (var_EventsCount - 1) * 20)
        newEvent.var_EventNameLabel.Text = event.object.Name
        newEvent.var_EventIdLabel.Text = tostring(var_EventsCount)
        
        -- Обновление CanvasSize
        EventsList.CanvasSize = UDim2.new(0, 0, 0, var_EventsCount * 20)
        
        -- Отображение скрипта в CodeView
        CodeView:ClearAllChildren()
        local lines = event.script:split("\n")
        for i, line in ipairs(lines) do
            local codeLine = var_CodeLineTemplate:Clone()
            codeLine.Parent = CodeView
            codeLine.Position = UDim2.new(0, 0, 0, (i - 1) * 15)
            codeLine.var_LineNumber.Text = tostring(i)
            codeLine.var_CodeText.Text = line
            codeLine.Visible = true
        end
        CodeView.CanvasSize = UDim2.new(0, 0, 0, #lines * 15)
    end
end)
