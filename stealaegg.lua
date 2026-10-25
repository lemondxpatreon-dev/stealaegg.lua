
--==================================================
-- Steal a Egg - Mobile Egg Finder
-- Für dein eigenes Roblox-Spiel
-- Als LocalScript verwenden
-- Echte Eier müssen den CollectionService-Tag "Egg" haben
--==================================================

local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Altes Menü entfernen
local oldGui = playerGui:FindFirstChild("StealAEggFinder")
if oldGui then
    oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "StealAEggFinder"
gui.ResetOnSpawn = false
gui.DisplayOrder = 20
gui.Parent = playerGui

-- Hauptfenster
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0.9, 0, 0, 370)
main.Position = UDim2.new(0.05, 0, 0.25, 0)
main.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
main.BorderSizePixel = 0
main.Parent = gui

local sizeLimit = Instance.new("UISizeConstraint")
sizeLimit.MaxSize = Vector2.new(430, 500)
sizeLimit.MinSize = Vector2.new(260, 300)
sizeLimit.Parent = main

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

-- Titel
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -55, 0, 45)
title.Position = UDim2.fromOffset(12, 3)
title.BackgroundTransparency = 1
title.Text = "🥚 Steal a Egg Finder"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 19
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

-- Schließen
local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(35, 35)
close.Position = UDim2.new(1, -42, 0, 7)
close.BackgroundColor3 = Color3.fromRGB(180, 55, 55)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.TextSize = 17
close.Font = Enum.Font.GothamBold
close.Parent = main

Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 25)
status.Position = UDim2.fromOffset(10, 45)
status.BackgroundTransparency = 1
status.Text = "Bereit zum Scannen"
status.TextColor3 = Color3.fromRGB(170, 200, 170)
status.TextSize = 13
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = main

-- Aktualisieren
local refresh = Instance.new("TextButton")
refresh.Size = UDim2.new(1, -20, 0, 40)
refresh.Position = UDim2.fromOffset(10, 73)
refresh.BackgroundColor3 = Color3.fromRGB(45, 135, 90)
refresh.Text = "🔎 Eier aktualisieren"
refresh.TextColor3 = Color3.new(1, 1, 1)
refresh.TextSize = 15
refresh.Font = Enum.Font.GothamBold
refresh.Parent = main

Instance.new("UICorner", refresh).CornerRadius = UDim.new(0, 8)

-- Ergebnisliste
local list = Instance.new("ScrollingFrame")
list.Name = "EggList"
list.Size = UDim2.new(1, -20, 1, -125)
list.Position = UDim2.fromOffset(10, 120)
list.BackgroundColor3 = Color3.fromRGB(18, 20, 27)
list.BorderSizePixel = 0
list.ScrollBarThickness = 5
list.CanvasSize = UDim2.new()
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.Parent = main

Instance.new("UICorner", list).CornerRadius = UDim.new(0, 8)

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = list

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 7)
padding.PaddingLeft = UDim.new(0, 7)
padding.PaddingRight = UDim.new(0, 7)
padding.PaddingBottom = UDim.new(0, 7)
padding.Parent = list

-- Kleine Schaltfläche zum Ein-/Ausblenden
local toggle = Instance.new("TextButton")
toggle.Name = "OpenButton"
toggle.Size = UDim2.fromOffset(55, 55)
toggle.Position = UDim2.new(0, 12, 0.5, 0)
toggle.BackgroundColor3 = Color3.fromRGB(45, 135, 90)
toggle.Text = "🥚"
toggle.TextSize = 25
toggle.Visible = false
toggle.Parent = gui

Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

close.Activated:Connect(function()
    main.Visible = false
    toggle.Visible = true
end)

toggle.Activated:Connect(function()
    main.Visible = true
    toggle.Visible = false
end)

-- Hilfsfunktion: Position eines Eis ermitteln
local function getPosition(obj)
    if not obj or not obj.Parent then
        return nil
    end

    if obj:IsA("BasePart") then
        return obj.Position
    elseif obj:IsA("Model") then
        return obj:GetPivot().Position
    end

    return nil
end

-- Markierung des ausgewählten Eis
local currentHighlight

local function markEgg(obj)
    if currentHighlight then
        currentHighlight:Destroy()
        currentHighlight = nil
    end

    if not obj or not obj:IsDescendantOf(Workspace) then
        status.Text = "Ei ist nicht mehr verfügbar"
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "EggFinderHighlight"
    highlight.Adornee = obj
    highlight.FillColor = Color3.fromRGB(255, 200, 30)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.65
    highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    highlight.Parent = Workspace

    currentHighlight = highlight
    status.Text = "Markiert: " .. obj.Name
end

-- Vorherige Einträge löschen
local function clearList()
    for _, child in ipairs(list:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
end

-- Eier anhand offizieller Tags suchen
local function scanEggs()
    clearList()

    local found = {}
    local seen = {}

    for _, obj in ipairs(CollectionService:GetTagged("Egg")) do
        if obj:IsDescendantOf(Workspace)
            and (obj:IsA("Model") or obj:IsA("BasePart"))
            and not seen[obj] then

            seen[obj] = true
            table.insert(found, obj)
        end
    end

    table.sort(found, function(a, b)
        return a.Name:lower() < b.Name:lower()
    end)

    for index, egg in ipairs(found) do
        local item = Instance.new("Frame")
        item.Name = "EggEntry" .. index
        item.Size = UDim2.new(1, -4, 0, 62)
        item.BackgroundColor3 = Color3.fromRGB(38, 41, 52)
        item.BorderSizePixel = 0
        item.LayoutOrder = index
        item.Parent = list

        Instance.new("UICorner", item).CornerRadius = UDim.new(0, 7)

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -100, 0, 28)
        nameLabel.Position = UDim2.fromOffset(8, 5)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = "🥚 " .. egg.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
        nameLabel.Parent = item

        local pos = getPosition(egg)
        local distanceText = "Position unbekannt"

        if pos and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                distanceText = "Entfernung: "
                    .. math.floor((root.Position - pos).Magnitude)
                    .. " Studs"
            end
        end

        local detail = Instance.new("TextLabel")
        detail.Size = UDim2.new(1, -100, 0, 20)
        detail.Position = UDim2.fromOffset(8, 32)
        detail.BackgroundTransparency = 1
        detail.Text = distanceText
        detail.TextColor3 = Color3.fromRGB(190, 195, 205)
        detail.TextSize = 11
        detail.Font = Enum.Font.Gotham
        detail.TextXAlignment = Enum.TextXAlignment.Left
        detail.Parent = item

        local selectButton = Instance.new("TextButton")
        selectButton.Size = UDim2.fromOffset(78, 38)
        selectButton.Position = UDim2.new(1, -85, 0, 12)
        selectButton.BackgroundColor3 = Color3.fromRGB(55, 115, 180)
        selectButton.Text = "MARKIEREN"
        selectButton.TextColor3 = Color3.new(1, 1, 1)
        selectButton.TextSize = 10
        selectButton.Font = Enum.Font.GothamBold
        selectButton.Parent = item

        Instance.new("UICorner", selectButton).CornerRadius = UDim.new(0, 6)

        selectButton.Activated:Connect(function()
            if egg.Parent and egg:IsDescendantOf(Workspace) then
                markEgg(egg)
            else
                status.Text = "Ei wurde entfernt"
            end
        end)
    end

    status.Text = "Gefundene markierte Eier: " .. #found

    if #found == 0 then
        local empty = Instance.new("TextLabel")
        empty.Name = "EmptyMessage"
        empty.Size = UDim2.new(1, -8, 0, 65)
        empty.BackgroundTransparency = 1
        empty.TextWrapped = true
        empty.Text = "Keine Eier mit Tag 'Egg' gefunden.\nMarkiere deine echten Eier in Studio."
        empty.TextColor3 = Color3.fromRGB(200, 200, 210)
        empty.TextSize = 13
        empty.Font = Enum.Font.Gotham
        empty.Parent = list
    end
end

refresh.Activated:Connect(scanEggs)

-- Automatisch aktualisieren, wenn neue getaggte Eier erscheinen
CollectionService:GetInstanceAddedSignal("Egg"):Connect(function()
    task.defer(scanEggs)
end)

CollectionService:GetInstanceRemovedSignal("Egg"):Connect(function()
    task.defer(scanEggs)
end)

scanEggs()
print("Steal a Egg Finder geladen")
