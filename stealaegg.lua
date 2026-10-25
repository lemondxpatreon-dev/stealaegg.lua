
--========================================================
-- EGG FINDER PRO | MOBILE + PC
-- Für dein eigenes Roblox-Spiel in Roblox Studio
--========================================================

local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local TAG_NAME = "Egg"
local SCAN_INTERVAL = 5

-- Altes GUI entfernen
local old = playerGui:FindFirstChild("EggFinderPro")
if old then
    old:Destroy()
end

-- Farben
local BG = Color3.fromRGB(19, 23, 33)
local PANEL = Color3.fromRGB(29, 35, 48)
local GREEN = Color3.fromRGB(43, 190, 125)
local WHITE = Color3.fromRGB(245, 247, 255)
local MUTED = Color3.fromRGB(165, 177, 194)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "EggFinderPro"
gui.ResetOnSpawn = false
gui.DisplayOrder = 20
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.zero
main.Size = UDim2.new(0.88, 0, 0, 390)
main.Position = UDim2.new(0.06, 0, 0.2, 0)
main.BackgroundColor3 = BG
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui

local sizeLimit = Instance.new("UISizeConstraint")
sizeLimit.MinSize = Vector2.new(260, 300)
sizeLimit.MaxSize = Vector2.new(430, 520)
sizeLimit.Parent = main

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(65, 85, 105)
stroke.Thickness = 1.3
stroke.Parent = main

-- Kopfzeile
local header = Instance.new("Frame")
header.Name = "DragHeader"
header.Size = UDim2.new(1, 0, 0, 58)
header.BackgroundColor3 = PANEL
header.BorderSizePixel = 0
header.Active = true
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -65, 1, 0)
title.Position = UDim2.fromOffset(14, 0)
title.BackgroundTransparency = 1
title.Text = "🥚  EGG FINDER PRO"
title.TextColor3 = WHITE
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local close = Instance.new("TextButton")
close.Name = "Close"
close.Size = UDim2.fromOffset(36, 36)
close.Position = UDim2.new(1, -45, 0, 11)
close.BackgroundColor3 = Color3.fromRGB(210, 72, 82)
close.Text = "×"
close.TextColor3 = WHITE
close.TextSize = 26
close.Font = Enum.Font.GothamBold
close.Parent = header

Instance.new("UICorner", close).CornerRadius = UDim.new(0, 10)

-- Status
local status = Instance.new("TextLabel")
status.Position = UDim2.fromOffset(14, 65)
status.Size = UDim2.new(1, -28, 0, 28)
status.BackgroundTransparency = 1
status.Text = "Bereit zum Suchen"
status.TextColor3 = MUTED
status.TextSize = 13
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = main

-- Aktualisieren
local refresh = Instance.new("TextButton")
refresh.Position = UDim2.fromOffset(12, 98)
refresh.Size = UDim2.new(1, -24, 0, 42)
refresh.BackgroundColor3 = GREEN
refresh.Text = "⌕   EIER SUCHEN"
refresh.TextColor3 = Color3.fromRGB(12, 35, 27)
refresh.TextSize = 15
refresh.Font = Enum.Font.GothamBold
refresh.Parent = main

Instance.new("UICorner", refresh).CornerRadius = UDim.new(0, 11)

-- Eierliste
local list = Instance.new("ScrollingFrame")
list.Name = "EggList"
list.Position = UDim2.fromOffset(12, 151)
list.Size = UDim2.new(1, -24, 1, -163)
list.BackgroundColor3 = Color3.fromRGB(14, 17, 25)
list.BorderSizePixel = 0
list.ScrollBarThickness = 4
list.ScrollBarImageColor3 = GREEN
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.Parent = main

Instance.new("UICorner", list).CornerRadius = UDim.new(0, 11)

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 8)
padding.PaddingBottom = UDim.new(0, 8)
padding.PaddingLeft = UDim.new(0, 8)
padding.PaddingRight = UDim.new(0, 8)
padding.Parent = list

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 7)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = list

-- Kleiner Button zum Wiederöffnen
local reopen = Instance.new("TextButton")
reopen.Name = "Reopen"
reopen.Size = UDim2.fromOffset(54, 54)
reopen.Position = UDim2.new(0, 12, 0.5, -27)
reopen.BackgroundColor3 = GREEN
reopen.Text = "🥚"
reopen.TextSize = 25
reopen.Visible = false
reopen.Parent = gui

Instance.new("UICorner", reopen).CornerRadius = UDim.new(1, 0)

-- Fenster verschieben: Maus und Touch
local dragging = false
local dragInput
local dragStart
local startPosition

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragInput = input
        dragStart = input.Position
        startPosition = main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                dragInput = nil
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input == dragInput then

        local delta = input.Position - dragStart
        local camera = Workspace.CurrentCamera
        if not camera then return end

        local viewport = camera.ViewportSize
        local width = main.AbsoluteSize.X
        local height = main.AbsoluteSize.Y

        local x = startPosition.X.Offset + delta.X
        local y = startPosition.Y.Offset + delta.Y

        x = math.clamp(x, 0, math.max(0, viewport.X - width))
        y = math.clamp(y, 0, math.max(0, viewport.Y - height))

        main.Position = UDim2.fromOffset(x, y)
    end
end)

close.Activated:Connect(function()
    main.Visible = false
    reopen.Visible = true
end)

reopen.Activated:Connect(function()
    main.Visible = true
    reopen.Visible = false
end)

-- Eierfinder
local scanning = false
local currentHighlight

local function getRoot()
    local character = player.Character
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function getPosition(egg)
    if egg:IsA("BasePart") then
        return egg.Position
    elseif egg:IsA("Model") then
        return egg:GetPivot().Position
    end
end

local function clearEntries()
    for _, child in ipairs(list:GetChildren()) do
        if child:GetAttribute("FinderEntry") then
            child:Destroy()
        end
    end
end

local function message(text)
    local label = Instance.new("TextLabel")
    label.Name = "EmptyMessage"
    label:SetAttribute("FinderEntry", true)
    label.Size = UDim2.new(1, -4, 0, 90)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = MUTED
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextWrapped = true
    label.LayoutOrder = 1
    label.Parent = list
end

local function highlightEgg(egg)
    if currentHighlight then
        currentHighlight:Destroy()
        currentHighlight = nil
    end

    if not egg:IsDescendantOf(Workspace) then
        status.Text = "Dieses Ei ist nicht mehr verfügbar"
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "FinderHighlight"
    highlight.Adornee = egg
    highlight.FillColor = Color3.fromRGB(255, 205, 65)
    highlight.OutlineColor = WHITE
    highlight.FillTransparency = 0.45
    highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    highlight.Parent = Workspace

    currentHighlight = highlight
    status.Text = "Markiert: " .. egg.Name
end

local function createEntry(egg, index)
    local item = Instance.new("Frame")
    item.Name = "EggEntry"
    item:SetAttribute("FinderEntry", true)
    item.Size = UDim2.new(1, -4, 0, 66)
    item.BackgroundColor3 = PANEL
    item.BorderSizePixel = 0
    item.LayoutOrder = index
    item.Parent = list

    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 9)

    local name = Instance.new("TextLabel")
    name.Position = UDim2.fromOffset(9, 5)
    name.Size = UDim2.new(1, -100, 0, 25)
    name.BackgroundTransparency = 1
    name.Text = "🥚  " .. egg.Name
    name.TextColor3 = Color3.fromRGB(255, 220, 120)
    name.TextSize = 13
    name.Font = Enum.Font.GothamBold
    name.TextXAlignment = Enum.TextXAlignment.Left
    name.TextTruncate = Enum.TextTruncate.AtEnd
    name.Parent = item

    local detail = Instance.new("TextLabel")
    detail.Position = UDim2.fromOffset(9, 32)
    detail.Size = UDim2.new(1, -100, 0, 22)
    detail.BackgroundTransparency = 1
    detail.TextColor3 = MUTED
    detail.TextSize = 11
    detail.Font = Enum.Font.Gotham
    detail.TextXAlignment = Enum.TextXAlignment.Left
    detail.Parent = item

    local function updateDistance()
        if not egg.Parent then
            detail.Text = "Nicht mehr vorhanden"
            return
        end

        local root = getRoot()
        local ok, pos = pcall(getPosition, egg)

        if ok and pos and root then
            detail.Text = "Entfernung: "
                .. math.floor((root.Position - pos).Magnitude)
                .. " Studs"
        else
            detail.Text = "Position nicht verfügbar"
        end
    end

    updateDistance()

    local mark = Instance.new("TextButton")
    mark.Position = UDim2.new(1, -88, 0, 16)
    mark.Size = UDim2.fromOffset(79, 34)
    mark.BackgroundColor3 = Color3.fromRGB(52, 115, 185)
    mark.Text = "ANZEIGEN"
    mark.TextColor3 = WHITE
    mark.TextSize = 10
    mark.Font = Enum.Font.GothamBold
    mark.Parent = item

    Instance.new("UICorner", mark).CornerRadius = UDim.new(0, 7)

    mark.Activated:Connect(function()
        highlightEgg(egg)
    end)
end

local function scanEggs()
    if scanning then return end
    scanning = true

    refresh.Text = "SUCHE ..."
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

    if #found == 0 then
        message(
            "Keine Eier gefunden.\n\n" ..
            "Füge deinen Ei-Modellen in Studio " ..
            "den CollectionService-Tag 'Egg' hinzu."
        )
    else
        for i, egg in ipairs(found) do
            createEntry(egg, i)
        end
    end

    status.Text = "Gefundene Eier: " .. #found
    refresh.Text = "⌕   EIER SUCHEN"
    scanning = false
end

refresh.Activated:Connect(scanEggs)

-- Automatische Aktualisierung bei Tag-Änderungen
CollectionService:GetInstanceAddedSignal(TAG_NAME):Connect(function()
    task.defer(scanEggs)
end)

CollectionService:GetInstanceRemovedSignal(TAG_NAME):Connect(function()
    task.defer(scanEggs)
end)

-- Regelmäßig Entfernungen aktualisieren
task.spawn(function()
    while gui.Parent do
        task.wait(SCAN_INTERVAL)
        if main.Visible then
            scanEggs()
        end
    end
end)

-- Erster Scan
scanEggs()

print("[EggFinderPro] Erfolgreich gestartet")
