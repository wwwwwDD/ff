-- Main Execution Script - GitHub Version
-- Advanced Remote Spy with Anti-Detection
-- Refactored for GitHub deployment

-- Anti-detection: Load modules dynamically from GitHub
local function loadModule(name)
    local baseUrl = "https://raw.githubusercontent.com/wwwwwDD/ff/main/"
    local urls = {
        gui = baseUrl .. "gui.lua",
        core = baseUrl .. "core.lua"
    }
    
    if urls[name] then
        local success, result = pcall(function()
            return loadstring(game:HttpGet(urls[name]))()
        end)
        
        if success then
            return result
        else
            warn("Failed to load module " .. name .. ": " .. tostring(result))
            return nil
        end
    end
    
    return nil
end

-- Anti-detection: Initialize with obfuscated execution flow
local function initialize()
    -- Load modules with anti-detection patterns
    local GuiModule = loadModule("gui")
    local CoreModule = loadModule("core")
    
    if not GuiModule or not CoreModule then
        warn("Failed to load required modules")
        return
    end
    
    -- Anti-detection: Create GUI components
    local components, services = GuiModule.init()
    
    -- Anti-detection: Initialize UI controller  
    local uiController = CoreModule.createUIController(components, services)
    
    -- Anti-detection: Discover and populate remote list
    CoreModule.discoverRemotes(components.settingsPanel)
    
    -- Anti-detection: Initialize monitoring system
    CoreModule.initializeMonitoring(components, uiController)
    
    -- Anti-detection: Success indicator
    print("Remote monitoring system initialized")
end

-- Anti-detection: Execute with error handling and retry logic
local function safeExecute()
    local success, error = pcall(initialize)
    
    if not success then
        warn("Initialization failed: " .. tostring(error))
        -- Anti-detection: Retry mechanism
        wait(1)
        pcall(initialize)
    end
end

-- Anti-detection: Launch the system
safeExecute()

-- Anti-detection: Optional cleanup function
local function cleanup()
    -- Clean up connections and GUI elements if needed
    local coreGui = game:GetService("CoreGui")
    local remoteSpyGui = coreGui:FindFirstChild("RemoteSpy")
    if remoteSpyGui then
        remoteSpyGui:Destroy()
    end
end

-- Anti-detection: Register cleanup for script termination
if script and script.AncestryChanged then
    script.AncestryChanged:Connect(function()
        if not script.Parent then
            cleanup()
        end
    end)
end
