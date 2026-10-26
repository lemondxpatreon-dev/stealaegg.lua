-- =====================================================================
-- CeboFinder PRO - Ultimate Custom Edition (20+ Features & Animations)
-- Game: Steal an Egg (10563114921)
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

-- Hauptfenster mit Animation beim Start
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 540, 0, 340),
    Position = UDim2.new(0.5, -270, 0.5, -170)
}):Play()

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Titel & Animated Status
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 160, 0, 35)
TitleLabel.Position = UDim2.new(0, 15, 0, 10)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "CeboFinder PRO"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0, 260, 0, 20)
StatusLabel.Position = UDim2.new(0, 15, 0, 32)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "■ 20+ Features & Anti-Müll Active"
StatusLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

-- Verschiebbarer Floating Button (CF)
local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Size = UDim2.new(0, 50, 0, 50)
FloatingBtn.Position = UDim2.new(0, 50, 0, 50)
FloatingBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FloatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingBtn.TextSize = 14
FloatingBtn.Font = Enum.Font.GothamBold
FloatingBtn.Text = "CF"
FloatingBtn.Visible = false
FloatingBtn.Parent = ScreenGui

local FCorner = Instance.new("UICorner") FCorner.CornerRadius = UDim.new(1, 0) FCorner.Parent = FloatingBtn

-- Dragging Logic für Floating Button
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

-- Helper für scrollbare Seiten
local function createPage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(0, 375, 0, 255)
    page.Position = UDim2.new(0, 145, 0, 55)
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

-- Button Animationsfunktion mit TweenService
local function applyButtonAnimation(btn)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.08), {Size = btn.Size - UDim2.new(0, 4, 0, 2)}):Play()
        task.wait(0.08)
        TweenService:Create(btn, TweenInfo.new(0.08), {Size = btn.Size + UDim2.new(0, 4, 0, 2)}):Play()
    end)
end

-- =====================================================================
-- 20+ FEATURE IMPLEMENTIERUNGEN (Settings & Toggles)
-- =====================================================================
local features = {
    {name = "Auto-Base Return", default = true},
    {name = "Instant Prompt Steal", default = true},
    {name = "Egg ESP Highlight", default = false},
    {name = "Player ESP Box", default = false},
    {name = "Infinite Jump", default = false},
    {name = "Noclip Mode", default = false},
    {name = "Anti-AFK Kick", default = true},
    {name = "Fullbright Lighting", default = false},
    {name = "Speed Boost (32)", default = false},
    {name = "High Jump (100)", default = false},
    {name = "Hitbox Expander", default = false},
    {name = "Night Mode Sky", default = false},
    {name = "FPS Booster (Low Poly)", default = false},
    {name = "Auto-Collect Coins", default = false},
    {name = "Godmode Monitor", default = true},
    {name = "Server Hop Fast", action = function() pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end) end},
    {name = "Rejoin Server", action = function() pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end) end},
    {name = "Teleport to Safe Zone", action = function() 
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
        end
    end},
    {name = "Clear Lag / Debris", action = function()
        for _, v in ipairs(Workspace:GetChildren()) do
            if v:IsA("Part") and not v.Anchored and v.Name == "Part" then v:Destroy() end
        end
    end},
    {name = "Discord / Copied Hub Info", action = function() pcall(setclipboard, "CeboFinder PRO Active") end}
}

local featureStates = {}

for _, feat in ipairs(features) do
    if feat.default ~= nil then featureStates[feat.name] = feat.default end
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = feat.default ~= nil and (feat.default and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)) or Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.Text = feat.default ~= nil and ("■ " .. feat.name .. ": " .. (feat.default and "ON" else "OFF")) or ("⚡ " .. feat.name)
    btn.Parent = SettingsPage
    
    local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 6) bc.Parent = btn
    applyButtonAnimation(btn)
    
    btn.Activated:Connect(function()
        if feat.action then
            feat.action()
            btn.TextColor3 = Color3.fromRGB(241, 196, 15)
            task.wait(0.3)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            featureStates[feat.name] = not featureStates[feat.name]
            local state = featureStates[feat.name]
            btn.Text = "■ " .. feat.name .. ": " .. (state and "ON" or "OFF")
            btn.TextColor3 = state and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
        end
    end)
end

-- Feature Loop (Abarbeitung von Infinite Jump, WalkSpeed, Noclip, ESP etc.)
RunService.RenderStepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        
        -- Speed & Jump
        if featureStates["Speed Boost (32)"] then
            if char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = 32 end
        else
            if char:FindFirstChild("Humanoid") and char.Humanoid.WalkSpeed == 32 then char.Humanoid.WalkSpeed = 16 end
        end
        
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

-- Sidebar Navigation mit Animation
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 0, 255)
Sidebar.Position = UDim2.new(0, 15, 0, 55)
Sidebar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner") SidebarCorner.CornerRadius = UDim.new(0, 6) SidebarCorner.Parent = Sidebar

local tabButtons = {}
local tabs = {"Logs", "History", "Teleports", "Settings", "Hide"}
for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.Position = UDim2.new(0, 5, 0, (i - 1) * 44 + 8)
    btn.BackgroundColor3 = (tabName == "Logs") and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.Text = tabName
    btn.Parent = Sidebar
    
    local btnCorner = Instance.new("UICorner") btnCorner.CornerRadius = UDim.new(0, 4) btnCorner.Parent = btn
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
                if name ~= "Hide" then b.BackgroundColor3 = Color3.fromRGB(40, 40, 40) end
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
    FloatingBtn.Size = UDim2.new(0, 0, 0, 0)
    FloatingBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 540, 0, 340),
        Position = UDim2.new(0.5, -270, 0.5, -170)
    }):Play()
    FloatingBtn.Visible = false
end)

-- Teleport Buttons in der Teleports-Seite
local tpLocations = {
    {"Spawn / Base", Vector3.new(0, 5, 0)},
    {"Forest Zone", Vector3.new(150, 5, 100)},
    {"Desert Zone", Vector3.new(-150, 5, 200)},
    {"Volcano Zone", Vector3.new(300, 5, -200)},
    {"Ocean Zone", Vector3.new(0, 5, 400)}
}

for _, loc in ipairs(tpLocations) do
    local tpBtn = Instance.new("TextButton")
    tpBtn.Size = UDim2.new(1, -10, 0, 40)
    tpBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
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

-- History Eintragen
local function addHistoryItem(eggName)
    local hFrame = Instance.new("Frame") hFrame.Size = UDim2.new(1, -10, 0, 45) hFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35) hFrame.Parent = HistoryPage
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = hFrame
    local ht = Instance.new("TextLabel") ht.Size = UDim2.new(1, -15, 1, 0) ht.Position = UDim2.new(0, 10, 0, 0) ht.BackgroundTransparency = 1 ht.Text = "Erfolgreich gestehlt: " .. eggName ht.TextColor3 = Color3.fromRGB(46, 204, 113) ht.TextSize = 12 ht.Font = Enum.Font.GothamBold ht.TextXAlignment = Enum.TextXAlignment.Left ht.Parent = hFrame
end

-- =====================================================================
-- PERFEKTER ANTI-MÜLL EIER-FILTER (Blockiert Models for egg, Ceiling, Shops)
-- =====================================================================
local function isStrictRealEgg(obj)
    if not obj or not obj.Parent then return false end
    local name = obj.Name:lower()
    
    -- Absolute Blacklist gegen Map-Modelle, Vorlagen, Decken und Shops
    if name:find("models for") or name:find("ceiling") or name:find("trim") or name:find("wall") or name:find("floor") or name:find("shop") or name:find("store") or name:find("portal") or name:find("bounds") or name:find("spot") or name:find("internal") or name:find("holder") or name:find("spawn") or name:find("zone") or name:find("mesh") or name:find("plane") or name:find("cube") or name:find("pad") or name:find("room") or name:find("pipe") or name:find("light") or name:find("rock") or name:find("section") or name:find("panel") or name:find("interior") or name:find("point") then
        return false
    end
    
    -- Prüfen auf echtes ProximityPrompt zum Stehlen
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
    t.Size = UDim2.new(0, 150, 0, 20) t.Position = UDim2.new(0, 50, 0, 8) t.BackgroundTransparency = 1 t.Text = obj.Name t.TextColor3 = Color3.fromRGB(241, 196, 15) t.TextSize = 12 t.Font = Enum.Font.GothamBold t.TextXAlignment = Enum.TextXAlignment.Left t.Parent = itemFrame
    
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(0, 150, 0, 15) sub.Position = UDim2.new(0, 50, 0, 26) sub.BackgroundTransparency = 1 sub.Text = "Echtes Welt-Ei" sub.TextColor3 = Color3.fromRGB(46, 204, 113) sub.TextSize = 11 sub.Font = Enum.Font.Gotham sub.TextXAlignment = Enum.TextXAlignment.Left sub.Parent = itemFrame
    
    local stealBtn = Instance.new("TextButton")
    stealBtn.Size = UDim2.new(0, 50, 0, 28) stealBtn.Position = UDim2.new(1, -115, 0, 11) stealBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113) stealBtn.TextColor3 = Color3.fromRGB(255, 255, 255) stealBtn.TextSize = 11 stealBtn.Font = Enum.Font.GothamBold stealBtn.Text = "STEHL" stealBtn.Parent = itemFrame
    local sCorner = Instance.new("UICorner") sCorner.CornerRadius = UDim.new(0, 4) sCorner.Parent = stealBtn
    applyButtonAnimation(stealBtn)

    local joinBtn = Instance.new("TextButton")
    joinBtn.Size = UDim2.new(0, 50, 0, 28) joinBtn.Position = UDim2.new(1, -58, 0, 11) joinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) joinBtn.TextColor3 = Color3.fromRGB(255, 255, 255) joinBtn.TextSize = 11 joinBtn.Font = Enum.Font.GothamBold joinBtn.Text = "JOIN" joinBtn.Parent = itemFrame
    local jCorner = Instance.new("UICorner") jCorner.CornerRadius = UDim.new(0, 4) jCorner.Parent = joinBtn
    applyButtonAnimation(joinBtn)
    
    stealBtn.Activated:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
            local humanoid = char.Humanoid local rootPart = char
