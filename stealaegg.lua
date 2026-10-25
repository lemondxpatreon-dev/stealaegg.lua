
--==============================================================
-- STEAL A EGG - MOBILE EGG FINDER PRO
-- Vollständiger LocalScript für dein eigenes Roblox-Spiel
--
-- Funktionen:
--   * Mobile GUI
--   * Verschieben per Touch/Maus
--   * Öffnen / Schließen
--   * Eierliste ohne doppelte Einträge
--   * Entfernung zum Spieler
--   * Markierung ausgewählter Eier
--   * Automatische Aktualisierung
--
-- Voraussetzung:
-- Echte Ei-Modelle oder BaseParts erhalten in Studio
-- den CollectionService-Tag "Egg".
--==============================================================

local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Einstellungen
local TAG_NAME = "Egg"
local SCAN_INTERVAL = 3

-- Altes Menü entfernen
local previous = playerGui:FindFirstChild("StealAEggFinderPro")
if previous then
    previous:Destroy()
end

--==============================================================
-- GUI
--==============================================================

local gui = Instance.new("ScreenGui")
gui.Name = "StealAEggFinderPro"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.DisplayOrder = 100
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.new(0.9, 0, 0.65, 0)
main.BackgroundColor3 = Color3.fromRGB(23, 25, 33)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui

local sizeLimit = Instance.new("UISizeConstraint")
sizeLimit.MinSize = Vector2.new(270, 290)
sizeLimit.MaxSize = Vector2.new(500, 560)
sizeLimit.Parent = main

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(65, 75, 90)
mainStroke.Thickness = 1
mainStroke.Parent = main

-- Kopfbereich: als Drag-Fläche verwendbar
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 54)
header.BackgroundColor3 = Color3.fromRGB(32, 35, 46)
header.BorderSizePixel = 0
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 14)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Position = UDim2.fromOffset(13, 0)
title.Size = UDim2.new(1, -65, 1, 0)
title.BackgroundTransparency = 1
title.Text = "🥚  Steal a Egg Finder"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeButton = Instance.new("TextButton")
closeButton.Name = "Close"
closeButton.Size = UDim2.fromOffset(38, 38)
closeButton.Position = UDim2.new(1, -46, 0, 8)
closeButton.BackgroundColor3 = Color3.fromRGB(190, 60, 65)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextSize = 28
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = header

Instance.new("UICorner", closeButton).CornerRadius =
    UDim.new(0, 9)

local status = Instance.new("TextLabel")
status.Name = "Status"
status.Position = UDim2.fromOffset(12, 59)
status.Size = UDim2.new(1, -24, 0, 25)
status.BackgroundTransparency = 1
status.Text = "Bereit"
status.TextColor3 = Color3.fromRGB(180, 195, 190)
status.TextSize = 13
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = main

local refreshButton = Instance.new("TextButton")
refreshButton.Name = "Refresh"
refreshButton.Position = UDim2.fromOffset(12, 88)
refreshButton.Size = UDim2.new(1, -24, 0, 42)
refreshButton.BackgroundColor3 = Color3.fromRGB(40, 135, 90)
refreshButton.Text = "🔎  Eier aktualisieren"
refreshButton.TextColor3 = Color3.new(1, 1, 1)
refreshButton.TextSize = 15
refreshButton.Font = Enum.Font.GothamBold
refreshButton.Parent = main

Instance.new("UICorner", refreshButton).CornerRadius =
    UDim.new(0, 9)

local list = Instance.new("ScrollingFrame")
list.Name = "EggList"
list.Position = UDim2.fromOffset(12, 140)
list.Size = UDim2.new(1, -24, 1, -152)
list.BackgroundColor3 = Color3.fromRGB(17, 19, 26)
list.BorderSizePixel = 0
list.ScrollBarThickness = 5
list.ScrollBarImageColor3 = Color3.fromRGB(110, 120, 140)
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.Parent = main

Instance.new("UICorner", list).CornerRadius =
    UDim.new(0, 9)

local listPadding = Instance.new("UIPadding")
listPadding.PaddingTop = UDim.new(0, 8)
listPadding.PaddingBottom = UDim.new(0, 8)
listPadding.PaddingLeft = UDim.new(0, 8)
listPadding.PaddingRight = UDim.new(0, 8)
listPadding.Parent = list

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 7)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = list

-- Kleiner Button zum erneuten Öffnen
local openButton = Instance.new("TextButton")
openButton.Name = "OpenButton"
openButton.Size = UDim2.fromOffset(58, 58)
openButton.Position = UDim2.new(0, 16, 0.5, -29)
openButton.BackgroundColor3 = Color3.fromRGB(40, 135, 90)
openButton.Text = "🥚"
openButton.TextSize = 27
openButton.Visible = false
openButton.Parent = gui

Instance.new("UICorner", openButton).CornerRadius =
    UDim.new(1, 0)

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(255, 255, 255)
openStroke.Thickness = 1
openStroke.Parent = openButton

--==============================================================
-- DRAG: Kopfbereich mit Touch oder Maus verschieben
--==============================================================

local dragging = false
local dragInput = nil
local dragStart = nil
local startPosition = nil

header.Active = true

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragInput = input
        dragStart = input.Position
        startPosition = main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

    local isMouseMove =
        input.UserInputType == Enum.UserInputType.MouseMovement

    local isTouchMove =
        input.UserInputType == Enum.UserInputType.Touch
        and input == dragInput

    if isMouseMove or isTouchMove then
        local delta = input.Position - dragStart

        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input == dragInput
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
        dragInput = nil
    end
end)

closeButton.Activated:Connect(function()
    main.Visible = false
    openButton.Visible = true
end)

openButton.Activated:Connect(function()
    main.Visible = true
    openButton.Visible = false
end)

--==============================================================
-- EIER-FINDER
--==============================================================

local currentHighlight = nil
local lastEggCount = 0
local scanning = false

local function getEggPosition(egg)
    if not egg or not egg.Parent then
        return nil
    end

    if egg:IsA("BasePart") then
        return egg.Position
    elseif egg:IsA("Model") then
        local success, pivot = pcall(function()
            return egg:GetPivot()
        end)

        if success then
            return pivot.Position
        end
    end

    return nil
end

local function getRoot()
    local character = player.Character
    if not character then
        return nil
    end

    return character:FindFirstChild("HumanoidRootPart")
end

local function clearEntries()
    for _, child in ipairs(list:GetChildren()) do
        if child:GetAttribute("EggFinderEntry") == true then
            child:Destroy()
        end
    end
end

local function createMessage(message)
    local label = Instance.new("TextLabel")
    label.Name = "Message"
    label:SetAttribute("EggFinderEntry", true)
    label.Size = UDim2.new(1, -4, 0, 70)
    label.BackgroundTransparency = 1
    label.Text = message
    label.TextWrapped = true
    label.TextColor3 = Color3.fromRGB(190, 195, 205)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.LayoutOrder = 1
    label.Parent = list
end

local function markEgg(egg)
    if currentHighlight then
        currentHighlight:Destroy()
        currentHighlight = nil
    end

    if not egg or not egg:IsDescendantOf(Workspace) then
        status.Text = "Das Ei ist nicht mehr verfügbar"
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "EggFinderHighlight"
    highlight.Adornee = egg
    highlight.FillColor = Color3.fromRGB(255, 205, 55)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.55
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    highlight.Parent = Workspace

    currentHighlight = highlight
    status.Text = "Markiert: " .. egg.Name
end

local function createEggEntry(egg, order)
    local item = Instance.new("Frame")
    item.Name = "EggEntry"
    item:SetAttribute("EggFinderEntry", true)
    item.Size = UDim2.new(1, -4, 0, 68)
    item.BackgroundColor3 = Color3.fromRGB(37, 41, 53)
    item.BorderSizePixel = 0
    item.LayoutOrder = order
    item.Parent = list

    Instance.new("UICorner", item).CornerRadius =
        UDim.new(0, 8)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Position = UDim2.fromOffset(9, 5)
    nameLabel.Size = UDim2.new(1, -104, 0, 26)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "🥚 " .. egg.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 220, 115)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.Parent = item

    local detail = Instance.new("TextLabel")
    detail.Position = UDim2.fromOffset(9, 32)
    detail.Size = UDim2.new(1, -104, 0, 23)
    detail.BackgroundTransparency = 1
    detail.TextColor3 = Color3.fromRGB(185, 192, 205)
    detail.TextSize = 11
    detail.Font = Enum.Font.Gotham
    detail.TextXAlignment = Enum.TextXAlignment.Left
    detail.Parent = item

    local function updateDistance()
        if not egg.Parent then
            detail.Text = "Nicht mehr vorhanden"
            return
        end

        local position = getEggPosition(egg)
        local root = getRoot()

        if position and root then
            local distance = (root.Position - position).Magnitude
            detail.Text = "Entfernung: "
                .. math.floor(distance) .. " Studs"
        else
            detail.Text = "Position nicht verfügbar"
        end
    end

    updateDistance()

    local markButton = Instance.new("TextButton")
    markButton.Position = UDim2.new(1, -91, 0, 16)
    markButton.Size = UDim2.fromOffset(82, 36)
    markButton.BackgroundColor3 = Color3.fromRGB(55, 110, 180)
    markButton.Text = "MARKIEREN"
    markButton.TextColor3 = Color3.new(1, 1, 1)
    markButton.TextSize = 10
    markButton.Font = Enum.Font.GothamBold
    markButton.Parent = item

    Instance.new("UICorner", markButton).CornerRadius =
        UDim.new(0, 7)

    markButton.Activated:Connect(function()
        markEgg(egg)
    end)

    return item
end

local function scanEggs()
    if scanning then
        return
    end

    scanning = true
    refreshButton.Text = "Suche..."
    clearEntries()

    local found = {}
    local seen = {}

    for _, egg in ipairs(CollectionService:GetTagged(TAG_NAME)) do
        if egg:IsDescendantOf(Workspace)
            and (egg:IsA("Model") or egg:IsA("BasePart"))
            and not seen[egg] then

            seen[egg] = true
            table.insert(found, egg)
        end
    end

    table.sort(found, function(a, b)
        return a.Name:lower() < b.Name:lower()
    end)

    lastEggCount = #found

    if #found == 0 then
        createMessage(
            "Keine Eier mit dem Tag 'Egg' gefunden.\n\n" ..
            "Deine Spiel-Objekte müssen in Roblox Studio " ..
            "mit dem CollectionService-Tag 'Egg' markiert sein."
        )
    else
        for index, egg in ipairs(found) do
            createEggEntry(egg, index)
        end
    end

    status.Text = "Gefundene markierte Eier: " .. lastEggCount
    refreshButton.Text = "🔎  Eier aktualisieren"
    scanning = false
end

refreshButton.Activated:Connect(scanEggs)

-- Neue oder entfernte Tags automatisch aktualisieren
CollectionService:GetInstanceAddedSignal(TAG_NAME):Connect(function()
    task.defer(scanEggs)
end)

CollectionService:GetInstanceRemovedSignal(TAG_NAME):Connect(function()
    task.defer(scanEggs)
end)

-- Entfernung regelmäßig aktualisieren
task.spawn(function()
    while gui.Parent do
        task.wait(SCAN_INTERVAL)

        if main.Visible then
            scanEggs()
        end
    end
end)

-- Initialer Scan
scanEggs()

print("[StealAEggFinderPro] Mobile Egg Finder gestartet")
