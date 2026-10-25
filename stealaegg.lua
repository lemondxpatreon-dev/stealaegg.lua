-- CeboFinder Mobile UI - Dynamischer Live-Feed für Spawns
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Altes UI entfernen falls vorhanden
if CoreGui:FindFirstChild("CeboFinderMobile") then
    CoreGui.CeboFinderMobile:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CeboFinderMobile"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Hauptfenster
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 540, 0, 320)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
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
StatusLabel.Size = UDim2.new(0, 100, 0, 20)
StatusLabel.Position = UDim2.new(0, 15, 0, 32)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "■ Connected"
StatusLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

-- Sidebar (Tabs)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 110, 0, 250)
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
    
    if tabName == "Hide" then
        btn.Activated:Connect(function()
            MainFrame.Visible = not MainFrame.Visible
        end)
    end
end

-- Live Feed Scroll-Container
local FeedScroll = Instance.new("ScrollingFrame")
FeedScroll.Size = UDim2.new(0, 395, 0, 250)
FeedScroll.Position = UDim2.new(0, 130, 0, 55)
FeedScroll.BackgroundTransparency = 1
FeedScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
FeedScroll.ScrollBarThickness = 4
FeedScroll.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = FeedScroll
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

-- Automatische Anpassung der Scroll-Größe bei neuen Einträgen
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    FeedScroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end)

-- Funktion, die dynamisch ein Tier/Ei in den Feed einträgt
local function addFeedItem(petName, valueText, subText, targetJobId)
    local itemFrame = Instance.new("Frame")
    itemFrame.Size = UDim2.new(1, -10, 0, 50)
    itemFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    itemFrame.BorderSizePixel = 0
    itemFrame.Parent = FeedScroll
    
    local iCorner = Instance.new("UICorner")
    iCorner.CornerRadius = UDim.new(0, 6)
    iCorner.Parent = itemFrame
    
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(0, 180, 0, 20)
    t.Position = UDim2.new(0, 10, 0, 8)
    t.BackgroundTransparency = 1
    t.Text = petName .. " [ " .. valueText .. " ]"
    t.TextColor3 = Color3.fromRGB(52, 152, 219)
    t.TextSize = 12
    t.Font = Enum.Font.GothamBold
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = itemFrame
    
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(0, 180, 0, 15)
    sub.Position = UDim2.new(0, 10, 0, 26)
    sub.BackgroundTransparency = 1
    sub.Text = subText
    sub.TextColor3 = Color3.fromRGB(150, 150, 150)
    sub.TextSize = 11
    sub.Font = Enum.Font.Gotham
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Parent = itemFrame
    
    -- STEHL Button (Standardmäßig Grau / Deaktiviert)
    local stealBtn = Instance.new("TextButton")
    stealBtn.Size = UDim2.new(0, 50, 0, 28)
    stealBtn.Position = UDim2.new(1, -115, 0, 11)
    stealBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    stealBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
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
    
    -- Prüfen, ob man sich aktuell auf exakt diesem Server befindet
    if game.JobId == targetJobId then
        stealBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113) -- Wird Grün, wenn man im Server ist
        stealBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    -- Server-Wechsel beim Klick auf JOIN
    joinBtn.Activated:Connect(function()
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, targetJobId, LocalPlayer)
        end)
    end)
    
    -- Aktion beim Klick auf STEHL
    stealBtn.Activated:Connect(function()
        if game.JobId == targetJobId then
            print("Aktion ausgeführt: Stehlen für " .. petName)
            -- Hier greift die Mechanik, sobald man im richtigen Server ist
        else
            print("Du musst erst in diesen Server joinen!")
        end
    end)
end

-- Beispiel: Lauschen auf echte Remote-Ereignisse aus dem Spiel, die Spawns melden
local success, remoteEvent = pcall(function()
    return ReplicatedStorage:WaitForChild("RareSpawnEvent", 2)
end)

if success and remoteEvent then
    remoteEvent.OnClientEvent:Connect(function(data)
    -- Hier werden die Spawns vollautomatisch eingefügt, wenn sie vom Spiel empfangen werden
        addFeedItem(data.PetName, data.Value, data.SubText, data.JobId)
    end)
else
    -- Fall zur Ansicht, falls kein Event verbunden ist (Testmodus)
    addFeedItem("Starry Fox", "$18.4B/s", "7/4 • 0:11 • Secret", game.JobId) -- Ist grün, da aktueller Server
    addFeedItem("Starry Fox", "$6.1B/s", "7/7 • 0:12 • Secret", "fremde-server-id-xyz") -- Bleibt grau bis zum Join
end

print("CeboFinder Dynamischer Feed geladen!")
