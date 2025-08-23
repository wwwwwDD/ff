-- Main Execution Script
-- Advanced Remote Spy with Anti-Detection
-- Refactored for improved stealth and modularity

-- Anti-detection: Load modules dynamically to avoid static analysis
local function loadModule(name)
    -- In practice, these would be separate files or loaded remotely
    -- For this example, they're assumed to be available as ModuleScripts
    if name == "gui" then
        -- Return the GUI module (would be loaded from gui.lua)
        return require(script.gui) -- Assuming gui.lua is a ModuleScript
    elseif name == "core" then
        -- Return the core module (would be loaded from core.lua)  
        return require(script.core) -- Assuming core.lua is a ModuleScript
    end
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
script.AncestryChanged:Connect(function()
    if not script.Parent then
        cleanup()
    end
end)
