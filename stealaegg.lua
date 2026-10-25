-- CeboFinder - Globaler Live-Scanner, Icons & Auto-Base-Return
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Altes UI sicher entfernen
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
StatusLabel.Size = UDim2.new(0, 220, 0, 20)
StatusLabel.Position = UDim2.new(0, 15, 0, 32)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "■ Global Live Egg Scanner"
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

local FCorner = Instance.new("UICorner")
FCorner.CornerRadius = UDim.new(1, 0)
FCorner.Parent = FloatingBtn

local dragging, dragInput, dragStart, startPos
FloatingBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = FloatingBtn.Position
    end
end)
FloatingBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        FloatingBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 0, 250)
Sidebar.Position = UDim2.new(0, 15, 0, 55)
Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 6)
SidebarCorner.Parent = Sidebar

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
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    btn.Activated:Connect(function()
        if tabName == "Hide" then
            MainFrame.Visible = false
            FloatingBtn.Visible = true
        end
    end)
end

FloatingBtn.Activated:Connect(function()
    MainFrame.Visible = true
    FloatingBtn.Visible = false
end)

-- Feed
local FeedScroll = Instance.new("ScrollingFrame")
FeedScroll.Size = UDim2.new(0, 365, 0, 250)
FeedScroll.Position = UDim2.new(0, 140, 0, 55)
FeedScroll.BackgroundTransparency = 1
FeedScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
FeedScroll.ScrollBarThickness = 4
FeedScroll.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = FeedScroll
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    FeedScroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end)

-- Strikter Blacklist-Filter gegen FireInternal, EggIspotBottom, Wände, Meshes etc.
local function isRealGlobalEgg(obj)
    if not obj or not obj.Parent then return false end
    local name = obj.Name:lower()
    
    -- Komplett ausschließen: Interne Skripte, Spawns, Spots, Wände, Müll
    if name:find("fireinternal") or name:find("ispot") or name:find("spot") or name:find("internal") or name:find("holder") or name:find("spawn") or name:find("zone") or name:find("area") or name:find("mesh") or name:find("plane") or name:find("cube") or name:find("pad") or name:find("room") or name:find("monkey") or name:find("gorilla") or name:find("batch") or name:find("ceiling") or name:find("pipe") or name:find("light") or name:find("whirlpool") or name:find("rock") or name:find("section") or name:find("panel") or name:find("wall") or name:find("floor") or name:find("interior") or name:find("point") then
        return false
    end
    
    -- Muss explizit "egg" oder "ei" im Namen haben und ein greifbares Objekt sein
    if (name:find("egg") or name:find("ei")) and (obj:IsA("Model") or obj:IsA("BasePart")) then
        return true
    end
    
    return false
end

-- Eigene Base ermitteln
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
    if char and char:FindFirstChild("HumanoidRootPart") then
        return char.HumanoidRootPart.Position
    end
    return Vector3.new(0, 5, 0)
end

local function registerGlobalEgg(obj)
    if not isRealGlobalEgg(obj) then return end
    if FeedScroll:FindFirstChild(obj.Name .. "_" .. tostring(obj)) then return end

    local itemFrame = Instance.new("Frame")
    itemFrame.Name = obj.Name .. "_" .. tostring(obj)
    itemFrame.Size = UDim2.new(1, -10, 0, 50)
    itemFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    itemFrame.BorderSizePixel = 0
    itemFrame.Parent = FeedScroll
    
    local iCorner = Instance.new("UICorner")
    iCorner.CornerRadius = UDim.new(0, 6)
    iCorner.Parent = itemFrame

    -- Bild / Icon neben dem Namen
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 36, 0, 36)
    icon.Position = UDim2.new(0, 7, 0, 7)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://6031094678" -- Standard Ei/Item Icon Asset
    icon.Parent = itemFrame
    
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(0, 150, 0, 20)
    t.Position = UDim2.new(0, 50, 0, 8)
    t.BackgroundTransparency = 1
    t.Text = obj.Name
    t.TextColor3 = Color3.fromRGB(241, 196, 15)
    t.TextSize = 12
    t.Font = Enum.Font.GothamBold
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = itemFrame
    
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(0, 150, 0, 15)
    sub.Position = UDim2.new(0, 50, 0, 26)
    sub.BackgroundTransparency = 1
    sub.Text = "Global Live Egg"
    sub.TextColor3 = Color3.fromRGB(150, 150, 150)
    sub.TextSize = 11
    sub.Font = Enum.Font.Gotham
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Parent = itemFrame
    
    -- STEHL Button
    local stealBtn = Instance.new("TextButton")
    stealBtn.Size = UDim2.new(0, 50, 0, 28)
    stealBtn.Position = UDim2.new(1, -115, 0, 11)
    stealBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    stealBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    stealBtn.TextSize = 11
    stealBtn.Font = Enum.Font.GothamBold
    stealBtn.Text = "STEHL"
    stealBtn.Parent = itemFrame
    
    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(0, 4)
    sCorner.Parent = stealBtn

    -- JOIN Button
    local joinBtn = Instance.new("TextButton")
    joinBtn.Size = UDim2.new(0, 50, 0, 28)
    joinBtn.Position = UDim2.new(1, -58, 0, 11)
    joinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    joinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    joinBtn.TextSize = 11
    joinBtn.Font = Enum.Font.GothamBold
    joinBtn.Text = "JOIN"
    joinBtn.Parent = itemFrame
    
    local jCorner = Instance.new("UICorner")
    jCorner.CornerRadius = UDim.new(0, 4)
    jCorner.Parent = joinBtn
    
    -- HINGEHEN, GREIFEN UND ZUR BASE ZURÜCKKEHREN
    stealBtn.Activated:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
            local humanoid = char.Humanoid
            local rootPart = char.HumanoidRootPart
            
            local targetPart = nil
            if obj:IsA("BasePart") then
                targetPart = obj
            elseif obj:IsA("Model") then
                targetPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            end
            
            if targetPart then
                -- 1. Zum Ei hinlaufen
                humanoid:MoveTo(targetPart.Position)
                
                local conn
                conn = RunService.Heartbeat:Connect(function()
                    if not targetPart or not targetPart.Parent then
                        if conn then conn:Disconnect() end
                        return
                    end
                    
                    local distance = (rootPart.Position - targetPart.Position).Magnitude
                    if distance <= 7 then
                        -- 2. Greifen / Einsammeln
                        pcall(function()
                            for _, prompt in ipairs(obj:GetDescendants()) do
                                if prompt:IsA("ProximityPrompt") then
                                    fireproximityprompt(prompt)
                                end
                            end
                        end)
                        pcall(function()
                            if firetouchinterest then
                                firetouchinterest(rootPart, targetPart, 0)
                                task.wait(0.05)
                                firetouchinterest(rootPart, targetPart, 1)
                            end
                        end)
                        
                        -- 3. Automatisch zurück zur Base
                        task.wait(0.2)
                        local basePos = getPlayerBasePosition()
                        humanoid:MoveTo(basePos)
                        
                        if conn then conn:Disconnect() end
                    end
                end)
            end
        end
    end)
    
    joinBtn.Activated:Connect(function()
        pcall(function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end)
    end)
    
    obj.AncestryChanged:Connect(function()
        if not obj.Parent then
            itemFrame:Destroy()
        end
    end)
end

-- Globaler Workspace-Scan
for _, obj in ipairs(Workspace:GetDescendants()) do
    pcall(function() registerGlobalEgg(obj) end)
end

Workspace.DescendantAdded:Connect(function(obj)
    task.wait(0.1)
    pcall(function() registerGlobalEgg(obj) end)
end)

print("CeboFinder Global Live Egg Scanner erfolgreich geladen!")
