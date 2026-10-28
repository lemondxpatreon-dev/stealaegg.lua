
--[[
    STEAL AN EGG - FREE SERVER FINDER
    GUI + SERVER LIST + PLAYER FILTER + JOIN
    PlaceId: 107778070777162

    Hinweis:
    Die öffentliche Roblox-API liefert Server-IDs
    und Spielerzahlen, keine Live-Egg-Spawn-Daten.
]]

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local PLACE_ID = 107778070777162

if not player then
    return
end

local oldGui = player.PlayerGui:FindFirstChild("EggFinder")
if oldGui then
    oldGui:Destroy()
end

local state = {
    servers = {},
    filtered = {},
    selectedPet = "",
    busy = false,
    minPlayers = 0,
    maxPlayers = 100
}

local gui = Instance.new("ScreenGui")
gui.Name = "EggFinder"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(390, 470)
frame.Position = UDim2.new(0.5, -195, 0.5, -235)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius =
    UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 42)
title.Position = UDim2.fromOffset(10, 2)
title.BackgroundTransparency = 1
title.Text = "EGG FINDER | FREE"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 21
title.Font = Enum.Font.GothamBold
title.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(32, 32)
close.Position = UDim2.new(1, -38, 0, 7)
close.Text = "X"
close.TextSize = 18
close.TextColor3 = Color3.new(1, 1, 1)
close.BackgroundColor3 = Color3.fromRGB(180, 55, 65)
close.Parent = frame

local function createBox(placeholder, y)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -20, 0, 34)
    box.Position = UDim2.fromOffset(10, y)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.ClearTextOnFocus = false
    box.TextSize = 14
    box.Font = Enum.Font.Gotham
    box.TextColor3 = Color3.new(1, 1, 1)
    box.BackgroundColor3 = Color3.fromRGB(42, 42, 55)
    box.Parent = frame
    Instance.new("UICorner", box).CornerRadius =
        UDim.new(0, 7)
    return box
end

local function createButton(text, x, y, width)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(width, 35)
    b.Position = UDim2.fromOffset(x, y)
    b.Text = text
    b.TextSize = 13
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1, 1, 1)
    b.BackgroundColor3 = Color3.fromRGB(100, 75, 180)
    b.Parent = frame
    Instance.new("UICorner", b).CornerRadius =
        UDim.new(0, 7)
    return b
end

local petBox = createBox(
    "Pet- oder Egg-Name (z. B. Divine)",
    48
)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 26)
status.Position = UDim2.fromOffset(10, 86)
status.BackgroundTransparency = 1
status.Text = "Status: Bereit"
status.TextColor3 = Color3.fromRGB(210, 210, 220)
status.TextSize = 13
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = frame

local refreshButton = createButton(
    "SERVER LADEN", 10, 116, 180
)

local filterButton = createButton(
    "FILTER", 200, 116, 180
)

local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, -20, 0, 250)
list.Position = UDim2.fromOffset(10, 158)
list.BackgroundColor3 = Color3.fromRGB(32, 32, 43)
list.BorderSizePixel = 0
list.ScrollBarThickness = 6
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.Parent = frame

Instance.new("UICorner", list).CornerRadius =
    UDim.new(0, 8)

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = list

local function clearList()
    for _, child in ipairs(list:GetChildren()) do
        if child:IsA("TextButton")
            or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
end

local function showMessage(text)
    clearList()

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -12, 0, 50)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextWrapped = true
    label.TextSize = 14
    label.Text = text
    label.Parent = list

    list.CanvasSize = UDim2.new(0, 0, 0, 55)
end

local function renderServers()
    clearList()

    local count = 0

    for _, server in ipairs(state.servers) do
        local matchesPet = state.selectedPet == ""
        local matchesPlayers =
            server.Players >= state.minPlayers
            and server.Players <= state.maxPlayers

        -- Die öffentliche API liefert keine Pet-Namen.
        -- Ein gesetzter Pet-Filter kann daher nicht
        -- anhand der Serverliste bestätigt werden.

        if matchesPet and matchesPlayers then
            count += 1

            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -8, 0, 48)
            b.BackgroundColor3 = Color3.fromRGB(48, 48, 64)
            b.TextColor3 = Color3.new(1, 1, 1)
            b.TextSize = 13
            b.Font = Enum.Font.Gotham
            b.TextWrapped = true
            b.Text = string.format(
                "Server %d | Spieler: %d/%d | Join",
                count,
                server.playing,
                server.maxPlayers
            )
            b.Parent = list

            b.Activated:Connect(function()
                if state.busy then
                    return
                end

                state.busy = true
                status.Text = "Teleport wird gestartet..."

                local ok, err = pcall(function()
                    TeleportService:TeleportToPlaceInstance(
                        PLACE_ID,
                        server.id,
                        player
                    )
                end)

                if not ok then
                    status.Text = "Teleport fehlgeschlagen"
                    warn(err)
                    state.busy = false
                end
            end)
        end
    end

    list.CanvasSize = UDim2.new(0, 0, 0, count * 53)

    if count == 0 then
        showMessage("Keine Server gefunden.")
    else
        status.Text = "Server gefunden: " .. count
    end
end

local function loadServers()
    if state.busy then
        return
    end

    status.Text = "Lade öffentliche Server..."
    refreshButton.Text = "LÄDT..."

    local url =
        "https://games.roblox.com/v1/games/"
        .. tostring(PLACE_ID)
        .. "/servers/Public?sortOrder=Asc&limit=100"

    local ok, response = pcall(function()
        return game:HttpGet(url)
    end)

    refreshButton.Text = "SERVER LADEN"

    if not ok then
        status.Text = "HTTP-Anfrage fehlgeschlagen"
        showMessage(
            "Serverliste nicht erreichbar. "
            .. "Prüfe die HTTP-Unterstützung."
        )
        warn(response)
        return
    end

    local decoded, data = pcall(function()
        return HttpService:JSONDecode(response)
    end)

    if not decoded or type(data) ~= "table"
        or type(data.data) ~= "table" then
        status.Text = "Antwort konnte nicht gelesen werden"
        showMessage("Die API lieferte keine gültige Serverliste.")
        return
    end

    state.servers = data.data
    status.Text = "Server geladen: "
        .. tostring(#state.servers)

    renderServers()
end

filterButton.Activated:Connect(function()
    state.selectedPet = petBox.Text:lower()

    if state.selectedPet ~= "" then
        status.Text =
            "Pet-Filter gespeichert: " .. petBox.Text
        showMessage(
            "Für Pet-Filter fehlen Spawn-Daten. "
            .. "Die öffentliche Serverliste enthält "
            .. "nur Serverinformationen."
        )
    else
        status.Text = "Pet-Filter deaktiviert"
        renderServers()
    end
end)

refreshButton.Activated:Connect(loadServers)

close.Activated:Connect(function()
    gui:Destroy()
end)

-- GUI beim Start anzeigen
showMessage("Klicke auf SERVER LADEN.")
loadServers()
