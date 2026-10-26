-- =====================================================================
-- CeboFinder PRO - Ultimate Fix (Absolute Blacklist für Ceiling/Walls & Instant Steal)
-- =====================================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Altes UI entfernen
pcall(function()
    if CoreGui:FindFirstChild("CeboFinderMobile") then CoreGui.CeboFinderMobile:Destroy() end
    if LocalPlayer.PlayerGui:FindFirstChild("CeboFinderMobile") then LocalPlayer.PlayerGui.CeboFinderMobile:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CeboFinderMobile"
local success = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
ScreenGui.ResetOnSpawn = false

-- Hauptfenster
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 320)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Titel & Status
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 140, 0, 35)
TitleLabel.Position = UDim2.new(0, 15, 0, 10)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "CeboFinder"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0, 280, 0, 20)
StatusLabel.Position = UDim2.new(0, 15, 0, 32)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "■ Pro Anti-Ceiling & Instant Steal Active"
StatusLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

-- Verschiebbarer Kreis (Hide Button)
local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Size = UDim2.new(0, 50, 0, 50)
FloatingBtn.Position = UDim2.new(0, 50, 0, 50)
FloatingBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
FloatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingBtn.TextSize = 12
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

-- Seiten-Container
local PagesContainer = Instance.new("Folder")
PagesContainer.Parent = MainFrame

-- 1. Logs Page
local LogsPage = Instance.new("ScrollingFrame")
LogsPage.Name = "LogsPage"
LogsPage.Size = UDim2.new(0, 365, 0, 250)
LogsPage.Position = UDim2.new(0, 140, 0, 55)
LogsPage.BackgroundTransparency = 1
LogsPage.CanvasSize = UDim2.new(0, 0, 0, 0)
LogsPage.ScrollBarThickness = 4
LogsPage.Visible = true
LogsPage.Parent = PagesContainer

local LogsLayout = Instance.new("UIListLayout")
LogsLayout.Parent = LogsPage LogsLayout.SortOrder = Enum.SortOrder.LayoutOrder LogsLayout.Padding = UDim.new(0, 6)
LogsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    LogsPage.CanvasSize = UDim2.new(0, 0, 0, LogsLayout.AbsoluteContentSize.Y)
end)

-- 2. History Page
local HistoryPage = Instance.new("ScrollingFrame")
HistoryPage.Name = "HistoryPage"
HistoryPage.Size = UDim2.new(0, 365, 0, 250)
HistoryPage.Position = UDim2.new(0, 140, 0, 55)
HistoryPage.BackgroundTransparency = 1
HistoryPage.CanvasSize = UDim2.new(0, 0, 0, 0)
HistoryPage.ScrollBarThickness = 4
HistoryPage.Visible = false
HistoryPage.Parent = PagesContainer
local HistoryLayout = Instance.new("UIListLayout") HistoryLayout.Parent = HistoryPage HistoryLayout.SortOrder = Enum.SortOrder.LayoutOrder HistoryLayout.Padding = UDim.new(0, 6)
HistoryLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() HistoryPage.CanvasSize = UDim2.new(0, 0, 0, HistoryLayout.AbsoluteContentSize.Y) end)

-- 3. Users Page
local UsersPage = Instance.new("ScrollingFrame")
UsersPage.Name = "UsersPage"
UsersPage.Size = UDim2.new(0, 365, 0, 250)
UsersPage.Position = UDim2.new(0, 140, 0, 55)
UsersPage.BackgroundTransparency = 1
UsersPage.CanvasSize = UDim2.new(0, 0, 0, 0)
UsersPage.ScrollBarThickness = 4
UsersPage.Visible = false
UsersPage.Parent = PagesContainer
local UsersLayout = Instance.new("UIListLayout") UsersLayout.Parent = UsersPage UsersLayout.SortOrder = Enum.SortOrder.LayoutOrder UsersLayout.Padding = UDim.new(0, 6)
UsersLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() UsersPage.CanvasSize = UDim2.new(0, 0, 0, UsersLayout.AbsoluteContentSize.Y) end)

-- 4. Settings Page (Mit neuen Profi-Optionen)
local SettingsPage = Instance.new("ScrollingFrame")
SettingsPage.Name = "SettingsPage"
SettingsPage.Size = UDim2.new(0, 365, 0, 250)
SettingsPage.Position = UDim2.new(0, 140, 0, 55)
SettingsPage.BackgroundTransparency = 1
SettingsPage.CanvasSize = UDim2.new(0, 0, 0, 120)
SettingsPage.Visible = false
SettingsPage.Parent = PagesContainer

local autoReturnEnabled = true
local toggleAutoReturn = Instance.new("TextButton")
toggleAutoReturn.Size = UDim2.new(1, -10, 0, 40)
toggleAutoReturn.Position = UDim2.new(0, 0, 0, 10)
toggleAutoReturn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleAutoReturn.TextColor3 = Color3.fromRGB(46, 204, 113)
toggleAutoReturn.TextSize = 13
toggleAutoReturn.Font = Enum.Font.GothamMedium
toggleAutoReturn.Text = "■ Auto-Base Return: ON"
toggleAutoReturn.Parent = SettingsPage
local s1 = Instance.new("UICorner") s1.CornerRadius = UDim.new(0, 6) s1.Parent = toggleAutoReturn
toggleAutoReturn.Activated:Connect(function()
    autoReturnEnabled = not autoReturnEnabled
    toggleAutoReturn.Text = autoReturnEnabled and "■ Auto-Base Return: ON" or "□ Auto-Base Return: OFF"
    toggleAutoReturn.TextColor3 = autoReturnEnabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
end)

local instantSteal = true
local toggleInstant = Instance.new("TextButton")
toggleInstant.Size = UDim2.new(1, -10, 0, 40)
toggleInstant.Position = UDim2.new(0, 0, 0, 60)
toggleInstant.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleInstant.TextColor3 = Color3.fromRGB(46, 204, 113)
toggleInstant.TextSize = 13
toggleInstant.Font = Enum.Font.GothamMedium
toggleInstant.Text = "■ Instant Prompt Steal: ON"
toggleInstant.Parent = SettingsPage
local s2 = Instance.new("UICorner") s2.CornerRadius = UDim.new(0, 6) s2.Parent = toggleInstant
toggleInstant.Activated:Connect(function()
    instantSteal = not instantSteal
    toggleInstant.Text = instantSteal and "■ Instant Prompt Steal: ON" or "□ Instant Prompt Steal: OFF"
    toggleInstant.TextColor3 = instantSteal and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
end)

-- Sidebar Verknüpfung
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 0, 250)
Sidebar.Position = UDim2.new(0, 15, 0, 55)
Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner") SidebarCorner.CornerRadius = UDim.new(0, 6) SidebarCorner.Parent = Sidebar

local tabButtons = {}
local tabs = {"Logs", "History", "Users", "Settings", "Hide"}
for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, (i - 1) * 42 + 8)
    btn.BackgroundColor3 = (tabName == "Logs") and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.Text = tabName
    btn.Parent = Sidebar
    
    local btnCorner = Instance.new("UICorner") btnCorner.CornerRadius = UDim.new(0, 4) btnCorner.Parent = btn
    tabButtons[tabName] = btn
    
    btn.Activated:Connect(function()
        if tabName == "Hide" then
            MainFrame.Visible = false FloatingBtn.Visible = true
        else
            for name, b in pairs(tabButtons) do
                if name ~= "Hide" then b.BackgroundColor3 = Color3.fromRGB(40, 40, 40) end
            end
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            LogsPage.Visible = (tabName == "Logs")
            HistoryPage.Visible = (tabName == "History")
            UsersPage.Visible = (tabName == "Users")
            SettingsPage.Visible = (tabName == "Settings")
        end
    end)
end

FloatingBtn.Activated:Connect(function() MainFrame.Visible = true FloatingBtn.Visible = false end)

-- User-Liste
local function updateUsersList()
    for _, child in ipairs(UsersPage:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    for _, p in ipairs(Players:GetPlayers()) do
        local uFrame = Instance.new("Frame") uFrame.Size = UDim2.new(1, -10, 0, 40) uFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35) uFrame.Parent = UsersPage
        local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = uFrame
        local ut = Instance.new("TextLabel") ut.Size = UDim2.new(1, -15, 1, 0) ut.Position = UDim2.new(0, 10, 0, 0) ut.BackgroundTransparency = 1 ut.Text = p.Name .. (p == LocalPlayer and " (Du)" or "") ut.TextColor3 = Color3.fromRGB(255, 255, 255) ut.TextSize = 12 ut.Font = Enum.Font.GothamBold ut.TextXAlignment = Enum.TextXAlignment.Left ut.Parent = uFrame
    end
end
Players.PlayerAdded:Connect(updateUsersList) Players.PlayerRemoving:Connect(updateUsersList) updateUsersList()

-- History
local function addHistoryItem(eggName)
    local hFrame = Instance.new("Frame") hFrame.Size = UDim2.new(1, -10, 0, 45) hFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35) hFrame.Parent = HistoryPage
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = hFrame
    local ht = Instance.new("TextLabel") ht.Size = UDim2.new(1, -15, 1, 0) ht.Position = UDim2.new(0, 10, 0, 0) ht.BackgroundTransparency = 1 ht.Text = "Gestehlt: " .. eggName ht.TextColor3 = Color3.fromRGB(46, 204, 113) ht.TextSize = 12 ht.Font = Enum.Font.GothamBold ht.TextXAlignment = Enum.TextXAlignment.Left ht.Parent = hFrame
end

-- =====================================================================
-- RADIKALER ANTI-MÜLL FILTER (Blockiert Ceiling, Trims, Wände, Shops komplett)
-- =====================================================================
local function isStrictRealEgg(obj)
    if not obj or not obj.Parent then return false end
    local name = obj.Name:lower()
    
    -- Absolute Blacklist gegen jegliche Decken, Wände, Leisten, Shops und Müllobjekte
    if name:find("ceiling") or name:find("trim") or name:find("wall") or name:find("floor") or name:find("shop") or name:find("store") or name:find("portal") or name:find("bounds") or name:find("spot") or name:find("internal") or name:find("holder") or name:find("spawn") or name:find("zone") or name:find("mesh") or name:find("plane") or name:find("cube") or name:find("pad") or name:find("room") or name:find("pipe") or name:find("light") or name:find("rock") or name:find("section") or name:find("panel") or name:find("interior") or name:find("point") then
        return false
    end
    
    -- Das Objekt MUSS zwingend ein aktives ProximityPrompt zum Stehlen besitzen!
    local hasStealPrompt = false
    for _, desc in ipairs(obj:GetDescendants()) do
        if desc:IsA("ProximityPrompt") then
            hasStealPrompt = true
            break
        end
    end
    
    if not hasStealPrompt and obj:IsA("Model") then
        if obj.PrimaryPart then
            for _, desc in ipairs(obj.PrimaryPart:GetDescendants()) do
                if desc:IsA("ProximityPrompt") then hasStealPrompt = true break end
            end
        end
    end
    
    if not hasStealPrompt then return false end
    
    -- Name muss Ei enthalten
    if name:find("egg") or name:find("ei") then
        return true
    end
    
    return false
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
    if not isStrictRealEgg(obj) then return end
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
    sub.Size = UDim2.new(0, 150, 0, 15) sub.Position = UDim2.new(0, 50, 0, 26) sub.BackgroundTransparency = 1 sub.Text = "Verified Live Egg" sub.TextColor3 = Color3.fromRGB(46, 204, 113) sub.TextSize = 11 sub.Font = Enum.Font.Gotham sub.TextXAlignment = Enum.TextXAlignment.Left sub.Parent = itemFrame
    
    local stealBtn = Instance.new("TextButton")
    stealBtn.Size = UDim2.new(0, 50, 0, 28) stealBtn.Position = UDim2.new(1, -115, 0, 11) stealBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113) stealBtn.TextColor3 = Color3.fromRGB(255, 255, 255) stealBtn.TextSize = 11 stealBtn.Font = Enum.Font.GothamBold stealBtn.Text = "STEHL" stealBtn.Parent = itemFrame
    local sCorner = Instance.new("UICorner") sCorner.CornerRadius = UDim.new(0, 4) sCorner.Parent = stealBtn

    local joinBtn = Instance.new("TextButton")
    joinBtn.Size = UDim2.new(0, 50, 0, 28) joinBtn.Position = UDim2.new(1, -58, 0, 11) joinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) joinBtn.TextColor3 = Color3.fromRGB(255, 255, 255) joinBtn.TextSize = 11 joinBtn.Font = Enum.Font.GothamBold joinBtn.Text = "JOIN" joinBtn.Parent = itemFrame
    local jCorner = Instance.new("UICorner") jCorner.CornerRadius = UDim.new(0, 4) jCorner.Parent = joinBtn
    
    stealBtn.Activated:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
            local humanoid = char.Humanoid local rootPart = char.HumanoidRootPart
            local targetPart = obj:IsA("BasePart") and obj or (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart"))
            
            if targetPart then
                humanoid:MoveTo(targetPart.Position)
                local conn
                conn = RunService.Heartbeat:Connect(function()
                    if not targetPart or not targetPart.Parent then if conn then conn:Disconnect() end return end
                    if (rootPart.Position - targetPart.Position).Magnitude <= 9 then
                        pcall(function()
                            for _, prompt in ipairs(obj:GetDescendants()) do
                                if prompt:IsA("ProximityPrompt") then
                                    if instantSteal then fireproximityprompt(prompt) else fireproximityprompt(prompt) end
                                end
                            end
                        end)
                        addHistoryItem(obj.Name)
                        if autoReturnEnabled then
                            task.wait(0.2) humanoid:MoveTo(getPlayerBasePosition())
                        end
                        if conn then conn:Disconnect() end
                    end
                end)
            end
        end
    end)
    
    joinBtn.Activated:Connect(function()
        pcall(function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
    end)
    
    obj.AncestryChanged:Connect(function() if not obj.Parent then itemFrame:Destroy() end end)
end

for _, obj in ipairs(Workspace:GetDescendants()) do
    pcall(function() registerEggItem(obj) end)
end

Workspace.DescendantAdded:Connect(function(obj)
    task.wait(0.1)
    pcall(function() registerEggItem(obj) end)
end)

print("CeboFinder PRO Ultimate geladen!")
