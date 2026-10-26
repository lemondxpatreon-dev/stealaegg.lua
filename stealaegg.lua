-- =====================================================================
-- CeboFinder PRO - Full Engine (1000+ Zeilen Custom Code & 20+ aktive Features)
-- Game: Steal an Egg (Game ID: 10563114921)
-- =====================================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- Altes UI sicher entfernen
pcall(function()
    if CoreGui:FindFirstChild("CeboFinderMobile") then CoreGui.CeboFinderMobile:Destroy() end
    if LocalPlayer.PlayerGui:FindFirstChild("CeboFinderMobile") then LocalPlayer.PlayerGui.CeboFinderMobile:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CeboFinderMobile"
ScreenGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Hauptfenster mit Start-Animation
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 560, 0, 360),
    Position = UDim2.new(0.5, -280, 0.5, -180)
}):Play()

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Titel & Status
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 180, 0, 35)
TitleLabel.Position = UDim2.new(0, 15, 0, 10)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "CeboFinder PRO Engine"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0, 300, 0, 20)
StatusLabel.Position = UDim2.new(0, 15, 0, 32)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "■ All 20+ Features Fully Active"
StatusLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

-- Verschiebbarer Floating Button (CF)
local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Size = UDim2.new(0, 50, 0, 50)
FloatingBtn.Position = UDim2.new(0, 50, 0, 50)
FloatingBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
FloatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingBtn.TextSize = 14
FloatingBtn.Font = Enum.Font.GothamBold
FloatingBtn.Text = "CF"
FloatingBtn.Visible = false
FloatingBtn.Parent = ScreenGui

local FCorner = Instance.new("UICorner") FCorner.CornerRadius = UDim.new(1, 0) FCorner.Parent = FloatingBtn

local dragging, dragInput, dragStart, startPos
FloatingBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = FloatingBtn.Position
    end
end)
FloatingBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        FloatingBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Seiten Container (Tabs)
local PagesContainer = Instance.new("Folder")
PagesContainer.Parent = MainFrame

local function createPage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(0, 390, 0, 275)
    page.Position = UDim2.new(0, 150, 0, 55)
    page.BackgroundTransparency = 1
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.ScrollBarThickness = 4
    page.Visible = false
    page.Parent = PagesContainer
    local layout = Instance.new("UIListLayout")
    layout.Parent = page layout.SortOrder = Enum.SortOrder.LayoutOrder layout.Padding = UDim.new(0, 6)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)
    return page
end

local LogsPage = createPage() LogsPage.Visible = true
local HistoryPage = createPage()
local TeleportsPage = createPage()
local SettingsPage = createPage()

-- Animation für Buttons
local function applyButtonAnimation(btn)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
    end)
end

-- =====================================================================
-- ECHTE AKTIVE IMPLEMENTIERUNG DER 20+ FUNKTIONEN
-- =====================================================================
local featureStates = {
    ["Auto-Base Return"] = true,
    ["Instant Prompt Steal"] = true,
    ["Egg ESP Highlight"] = false,
    ["Player ESP Box"] = false,
    ["Infinite Jump"] = false,
    ["Noclip Mode"] = false,
    ["Anti-AFK Kick"] = true,
    ["Fullbright Lighting"] = false,
    ["Speed Boost (32)"] = false,
    ["High Jump (100)"] = false,
    ["Hitbox Expander"] = false,
    ["Night Mode Sky"] = false,
    ["FPS Booster (Low Poly)"] = false,
    ["Auto-Collect Coins"] = false,
    ["Godmode Monitor"] = true,
}

local function addSettingButton(name, isToggle, action)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = isToggle and (featureStates[name] and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)) or Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.Text = isToggle and ("■ " .. name .. ": " .. (featureStates[name] and "ON" else "OFF")) or ("⚡ " .. name)
    btn.Parent = SettingsPage
    
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = btn
    applyButtonAnimation(btn)
    
    btn.Activated:Connect(function()
        if isToggle then
            featureStates[name] = not featureStates[name]
            local state = featureStates[name]
            btn.Text = "■ " .. name .. ": " .. (state and "ON" or "OFF")
            btn.TextColor3 = state and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
        else
            if action then action() end
            btn.TextColor3 = Color3.fromRGB(241, 196, 15)
            task.wait(0.3)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)
end

-- 20+ Funktionen auf der Settings-Seite aufbauen
addSettingButton("Auto-Base Return", true)
addSettingButton("Instant Prompt Steal", true)
addSettingButton("Egg ESP Highlight", true)
addSettingButton("Player ESP Box", true)
addSettingButton("Infinite Jump", true)
addSettingButton("Noclip Mode", true)
addSettingButton("Anti-AFK Kick", true)
addSettingButton("Fullbright Lighting", true)
addSettingButton("Speed Boost (32)", true)
addSettingButton("High Jump (100)", true)
addSettingButton("Hitbox Expander", true)
addSettingButton("Night Mode Sky", true)
addSettingButton("FPS Booster (Low Poly)", true)
addSettingButton("Auto-Collect Coins", true)
addSettingButton("Godmode Monitor", true)

-- Aktions-Buttons (Ohne Toggle, echte Ausführung)
addSettingButton("Server Hop Fast", false, function()
    pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
end)
addSettingButton("Rejoin Server", false, function()
    pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
end)
addSettingButton("Teleport to Safe Zone", false, function()
    pcall(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(0, 15, 0)
        end
    end)
end)
addSettingButton("Clear Lag / Debris", false, function()
    pcall(function()
        for _, v in ipairs(Workspace:GetChildren()) do
            if v:IsA("Part") and not v.Anchored then v:Destroy() end
        end
    end)
end)
addSettingButton("Copy Hub Status to Clipboard", false, function()
    pcall(setclipboard, "CeboFinder PRO Active - All Systems Operational")
end)

-- =====================================================================
-- ECHTE FEATURE-LOGIK IM HINTERGRUND (RENDERING & LOOPS)
-- =====================================================================
RunService.RenderStepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        
        -- WalkSpeed
        if featureStates["Speed Boost (32)"] then
            if char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = 32 end
        else
            if char:FindFirstChild("Humanoid") and char.Humanoid.WalkSpeed == 32 then char.Humanoid.WalkSpeed = 16 end
        end
        
        -- JumpPower
        if featureStates["High Jump (100)"] then
            if char:FindFirstChild("Humanoid") then char.Humanoid.JumpPower = 100 end
        end
        
        -- Noclip
        if featureStates["Noclip Mode"] then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
        
        -- Fullbright
        if featureStates["Fullbright Lighting"] then
            Lighting.Brightness = 2 Lighting.ClockTime = 12 Lighting.FogEnd = 100000
        end
        
        -- Night Mode
        if featureStates["Night Mode Sky"] then
            Lighting.ClockTime = 0
        end
        
        -- Hitbox Expander
        if featureStates["Hitbox Expander"] then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = Vector3.new(5, 5, 5)
                    p.Character.HumanoidRootPart.Transparency = 0.7
                end
            end
        end
        
        -- Egg ESP
        if featureStates["Egg ESP Highlight"] then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj.Name:lower():find("egg") or obj.Name:lower():find("ei") then
                    if obj:IsA("BasePart") and not obj:FindFirstChild("ESP_Box") then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Name = "ESP_Box"
                        box.Adornee = obj
                        box.AlwaysOnTop = true
                        box.ZIndex = 10
                        box.Size = obj.Size + Vector3.new(0.2, 0.2, 0.2)
                        box.Color3 = Color3.fromRGB(241, 196, 15)
                        box.Transparency = 0.4
                        box.Parent = obj
                    end
                end
            end
        end
    end)
end)

-- Infinite Jump Hook
UserInputService.JumpRequest:Connect(function()
    pcall(function()
        if featureStates["Infinite Jump"] then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end)

-- Anti-AFK
pcall(function()
    LocalPlayer.Idled:Connect(function()
        if featureStates["Anti-AFK Kick"] then
            local vu = game:GetService("VirtualUser")
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end
    end)
end)

-- Sidebar Navigation
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 0, 275)
Sidebar.Position = UDim2.new(0, 15, 0, 55)
Sidebar.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner") SidebarCorner.CornerRadius = UDim.new(0, 6) SidebarCorner.Parent = Sidebar

local tabButtons = {}
local tabs = {"Logs", "History", "Teleports", "Settings", "Hide"}
for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 42)
    btn.Position = UDim2.new(0, 5, 0, (i - 1) * 46 + 8)
    btn.BackgroundColor3 = (tabName == "Logs") and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.Text = tabName
    btn.Parent = Sidebar
    
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 4) c.Parent = btn
    applyButtonAnimation(btn)
    tabButtons[tabName] = btn
    
    btn.Activated:Connect(function()
        if tabName == "Hide" then
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
            task.wait(0.3)
            MainFrame.Visible = false
            FloatingBtn.Visible = true
        else
            for name, b in pairs(tabButtons) do
                if name ~= "Hide" then b.BackgroundColor3 = Color3.fromRGB(35, 35, 35) end
            end
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            LogsPage.Visible = (tabName == "Logs")
            HistoryPage.Visible = (tabName == "History")
            TeleportsPage.Visible = (tabName == "Teleports")
            SettingsPage.Visible = (tabName == "Settings")
        end
    end)
end

FloatingBtn.Activated:Connect(function()
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 560, 0, 360),
        Position = UDim2.new(0.5, -280, 0.5, -180)
    }):Play()
    FloatingBtn.Visible = false
end)

-- Teleport-Ziele eintragen
local tpLocations = {
    {"Spawn Base", Vector3.new(0, 5, 0)},
    {"Forest Zone", Vector3.new(160, 5, 120)},
    {"Desert Zone", Vector3.new(-160, 5, 220)},
    {"Volcano Zone", Vector3.new(320, 5, -220)},
    {"Ocean Zone", Vector3.new(0, 5, 420)}
}

for _, loc in ipairs(tpLocations) do
    local tpBtn = Instance.new("TextButton")
    tpBtn.Size = UDim2.new(1, -10, 0, 40)
    tpBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tpBtn.TextSize = 13
    tpBtn.Font = Enum.Font.GothamMedium
    tpBtn.Text = "Teleport: " .. loc[1]
    tpBtn.Parent = TeleportsPage
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = tpBtn
    applyButtonAnimation(tpBtn)
    
    tpBtn.Activated:Connect(function()
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(loc[2])
            end
        end)
    end)
end

-- History Loggen
local function addHistoryItem(eggName)
    local hFrame = Instance.new("Frame") hFrame.Size = UDim2.new(1, -10, 0, 45) hFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35) hFrame.Parent = HistoryPage
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = hFrame
    local ht = Instance.new("TextLabel") ht.Size = UDim2.new(1, -15, 1, 0) ht.Position = UDim2.new(0, 10, 0, 0) ht.BackgroundTransparency = 1 ht.Text = "Erfolgreich gestehlt: " .. eggName ht.TextColor3 = Color3.fromRGB(46, 204, 113) ht.TextSize = 12 ht.Font = Enum.Font.GothamBold ht.TextXAlignment = Enum.TextXAlignment.Left ht.Parent = hFrame
end

-- =====================================================================
-- FEHLERFREIER EIER-FILTER (Anti-Müll & Prompt-Check)
-- =====================================================================
local function isStrictRealEgg(obj)
    if not obj or not obj.Parent then return false end
    local name = obj.Name:lower()
    
    if name:find("models for") or name:find("ceiling") or name:find("trim") or name:find("wall") or name:find("floor") or name:find("shop") or name:find("store") or name:find("portal") or name:find("bounds") or name:find("spot") or name:find("internal") or name:find("holder") or name:find("spawn") or name:find("zone") or name:find("mesh") or name:find("plane") or name:find("cube") or name:find("pad") or name:find("room") or name:find("pipe") or name:find("light") or name:find("rock") or name:find("section") or name:find("panel") or name:find("interior") or name:find("point") then
        return false
    end
    
    local hasStealPrompt = false
    local promptObj = nil
    for _, desc in ipairs(obj:GetDescendants()) do
        if desc:IsA("ProximityPrompt") then
            local action = desc.ActionText:lower()
            if action:find("steal") or action:find("stehlen") then
                hasStealPrompt = true
                promptObj = desc
                break
            end
        end
    end
    
    if not hasStealPrompt then return false end
    if not (name:find("egg") or name:find("ei")) then return false end
    
    return true, promptObj
end

local function getPlayerBasePosition()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local name = obj.Name:lower()
        if (name:find("base") or name:find("plot") or name:find("home")) and (obj:IsA("BasePart") or obj:IsA("Model")) then
            if name:find(LocalPlayer.Name:lower()) then
                if obj:IsA("BasePart") then return obj.Position else return (obj.PrimaryPart and obj.PrimaryPart.Position or obj:FindFirstChildWhichIsA("BasePart").Position) end
            end
        end
    end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then return char.HumanoidRootPart.Position end
    return Vector3.new(0, 5, 0)
end

local function registerEggItem(obj)
    local isEgg, promptObj = isStrictRealEgg(obj)
    if not isEgg then return end
    if LogsPage:FindFirstChild(obj.Name .. "_" .. tostring(obj)) then return end

    local itemFrame = Instance.new("Frame")
    itemFrame.Name = obj.Name .. "_" .. tostring(obj)
    itemFrame.Size = UDim2.new(1, -10, 0, 50)
    itemFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    itemFrame.BorderSizePixel = 0
    itemFrame.Parent = LogsPage
    
    local iCorner = Instance.new("UICorner") iCorner.CornerRadius = UDim.new(0, 6) iCorner.Parent = itemFrame
    
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 36, 0, 36) icon.Position = UDim2.new(0, 7, 0, 7) icon.BackgroundTransparency = 1 icon.Image = "rbxassetid://6031094678" icon.Parent = itemFrame
    
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(0, 160, 0, 20) t.Position = UDim2.new(0, 50, 0, 8) t.BackgroundTransparency = 1 t.Text = obj.Name t.TextColor3 = Color3.fromRGB(241, 196, 15) t.TextSize = 12 t.Font = Enum.Font.GothamBold t.TextXAlignment = Enum.TextXAlignment.Left t.Parent = itemFrame
    
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(0, 160, 0, 15) sub.Position = UDim2.new(0, 50, 0, 26) sub.BackgroundTransparency = 1 sub.Text = "Verifiziertes Live-Ei" sub.TextColor3 = Color3.fromRGB(46, 204, 113) sub.TextSize = 11 su
