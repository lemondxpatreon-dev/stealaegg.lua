-- CeboFinder - Live Workspace Scanner & Auto-Steal für dein Spiel ("Steal a Egg")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")

-- Altes UI entfernen falls vorhanden
if CoreGui:FindFirstChild("CeboFinderMobile") then
    CoreGui.CeboFinderMobile:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CeboFinderMobile"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Hauptfenster (CeboFinder Design)
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
StatusLabel.Text = "■ Live Scanning"
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

-- Feed ScrollingFrame
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

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    FeedScroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end)

-- Funktion, die ein echtes Ei/Pet aus dem Spiel im Live-Feed anzeigt
local function addFoundEgg(eggInstance)
    if not eggInstance or not eggInstance:IsA("BasePart") and not eggInstance:IsA("Model") then return end
    
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
    t.Text = eggInstance.Name -- Echter Name aus deinem Spiel!
    t.TextColor3 = Color3.fromRGB(52, 152, 219)
    t.TextSize = 12
    t.Font = Enum.Font.GothamBold
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = itemFrame
    
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(0, 180, 0, 15)
    sub.Position = UDim2.new(0, 10, 0, 26)
    sub.BackgroundTransparency = 1
    sub.Text = "Spawns im Spiel • Aktiv"
    sub.TextColor3 = Color3.fromRGB(150, 150, 150)
    sub.TextSize = 11
    sub.Font = Enum.Font.Gotham
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Parent = itemFrame
    
    -- STEHL Button (Grün, da das Ei direkt im aktuellen Server ist)
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

    -- Auto-Steal: Bewegt den Charakter automatisch zum Ei hin!
    stealBtn.Activated:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
            local humanoid = char.Humanoid
            local rootPart = char.HumanoidRootPart
            
            -- Position des Eis ermitteln
            local targetPos = nil
            if eggInstance:IsA("BasePart") then
                targetPos = eggInstance.Position
            elseif eggInstance:IsA("Model") then
                if eggInstance.PrimaryPart then
                    targetPos = eggInstance.PrimaryPart.Position
                else
                    local p = eggInstance:FindFirstChildWhichIsA("BasePart")
                    if p then targetPos = p.Position end
                end
            end
            
            if targetPos then
                print("Auto-Steal gestartet zum Ei: " .. eggInstance.Name)
                humanoid:MoveTo(targetPos) -- Läuft automatisch zum Ei
                
                -- Berührung simulieren (falls das Ei per .Touched eingesammelt wird)
                pcall(function()
                    local p = eggInstance:IsA("BasePart") and eggInstance or eggInstance:FindFirstChildWhichIsA("BasePart")
                    if p and firetouchinterest then
                        firetouchinterest(rootPart, p, 0)
                        task.wait(0.1)
                        firetouchinterest(rootPart, p, 1)
                    end
                end)
            end
        end
    end)
    
    joinBtn.Activated:Connect(function()
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end)
    end)
    
    -- Wenn das Ei eingesammelt wird oder verschwindet, fliegt es aus dem Feed raus
    eggInstance.AncestryChanged:Connect(function()
        if not eggInstance.Parent then
            itemFrame:Destroy()
        end
    end)
end

-- 1. Bereits vorhandene Eier im Workspace beim Start scannen
for _, obj in ipairs(Workspace:GetDescendants()) do
    if obj.Name:lower():find("egg") or obj.Name:lower():find("pet") or obj.Name:lower():find("divine") or obj.Name:lower():find("eternal") then
        if (obj:IsA("BasePart") or obj:IsA("Model")) and obj.Parent == Workspace then
            addFoundEgg(obj)
        end
    end
end

-- 2. Live überwachen: Wenn neue Eier im Spiel spawnen, direkt im Feed anzeigen
Workspace.DescendantAdded:Connect(function(obj)
    if obj.Name:lower():find("egg") or obj.Name:lower():find("pet") or obj.Name:lower():find("divine") or obj.Name:lower():find("eternal") then
        if obj:IsA("BasePart") or obj:IsA("Model") then
            task.wait(0.2)
            addFoundEgg(obj)
        end
    end
end)

print("CeboFinder Live Scanner aktiv!")
