--[[
CEBOFINDER - ONE-FILE INSTALLER
Run this in Roblox Studio's Command Bar (Edit mode).
It creates the required server Script and client LocalScript.
A single Roblox Script cannot run both server and client code in the
correct security contexts, so this installer keeps everything in one
.lua file while installing the two runtime scripts automatically.

After installation:
  ServerScriptService/CeboFinder.server
  StarterPlayer/StarterPlayerScripts/CeboFinder.client

Requires MemoryStore API access in a published experience.
Actual egg collection still needs your game's inventory/safe-zone handler.
]]

local ServerScriptSource = [====[
--[[
    CEBOFINDER - ServerScriptService/CeboFinder.server.lua

    Global egg discovery for YOUR Roblox experience.
    Egg models must have:
      Rarity (string): Rare / Legendary / Secret
    Optional attributes:
      IsEgg (boolean), EggId (string), AnimalName (string),
      ImageId (string or number), IncomePerSecond (number)

    For collection, create a BindableFunction named CeboCollectHandler
    under ServerScriptService. Its OnInvoke(player, eggModel) must call
    your existing inventory/reward/safe-zone logic and return true/false.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local MemoryStoreService = game:GetService("MemoryStoreService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local CONFIG = {
    ScanInterval = 5,
    FeedLimit = 80,
    EntryTTL = 120,
    MaxCollectDistance = 14,
    AllowedRarities = {
        Rare = true,
        Legendary = true,
        Secret = true,
    },
    -- Optional: set to a folder name in Workspace, e.g. "Eggs".
    -- Leave nil to scan Workspace descendants.
    EggFolderName = nil,
}

local MAP_NAME = "CeboFinder_GlobalEggs_v1"
local globalEggs = MemoryStoreService:GetSortedMap(MAP_NAME)

local remotes = ReplicatedStorage:FindFirstChild("CeboFinderRemotes")
if not remotes then
    remotes = Instance.new("Folder")
    remotes.Name = "CeboFinderRemotes"
    remotes.Parent = ReplicatedStorage
end

local function getRemote(className, name)
    local obj = remotes:FindFirstChild(name)
    if obj and obj.ClassName ~= className then
        obj:Destroy()
        obj = nil
    end
    if not obj then
        obj = Instance.new(className)
        obj.Name = name
        obj.Parent = remotes
    end
    return obj
end

local GetFeed = getRemote("RemoteFunction", "GetFeed")
local JoinServer = getRemote("RemoteFunction", "JoinServer")
local CollectEgg = getRemote("RemoteFunction", "CollectEgg")

local localEggKeys = {} -- [Instance] = MemoryStore key
local lastRequest = {} -- simple per-player rate limit

local function isValidRarity(value)
    return typeof(value) == "string" and CONFIG.AllowedRarities[value] == true
end

local function getEggRoot()
    if CONFIG.EggFolderName then
        local folder = Workspace:FindFirstChild(CONFIG.EggFolderName)
        if folder then return folder end
    end
    return Workspace
end

local function isEggModel(inst)
    if not inst:IsA("Model") then return false end
    local rarity = inst:GetAttribute("Rarity")
    if not isValidRarity(rarity) then return false end

    -- Explicit attribute is preferred. EggId is also an explicit marker.
    if inst:GetAttribute("IsEgg") == true then return true end
    if inst:GetAttribute("EggId") ~= nil then return true end

    -- Conservative fallback: require "egg" in the model name.
    return string.find(string.lower(inst.Name), "egg", 1, true) ~= nil
end

local function getPosition(model)
    local part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
    if not part then return nil end
    return part.Position
end

local function getEggId(model)
    local id = model:GetAttribute("EggId")
    if typeof(id) ~= "string" or id == "" then
        id = HttpService:GenerateGUID(false)
        model:SetAttribute("EggId", id)
    end
    return id
end

local function makeKey(eggId)
    return tostring(game.JobId) .. ":" .. eggId
end

local function publishEgg(model)
    local pos = getPosition(model)
    if not pos then return end

    local eggId = getEggId(model)
    local key = makeKey(eggId)
    local rarity = model:GetAttribute("Rarity")
    local animalName = model:GetAttribute("AnimalName") or model.Name
    local imageId = model:GetAttribute("ImageId")
    local income = model:GetAttribute("IncomePerSecond")

    local record = {
        key = key,
        eggId = eggId,
        eggName = model.Name,
        animalName = tostring(animalName),
        rarity = rarity,
        imageId = imageId and tostring(imageId) or "",
        incomePerSecond = typeof(income) == "number" and income or 0,
        placeId = game.PlaceId,
        jobId = game.JobId,
        x = math.floor(pos.X),
        y = math.floor(pos.Y),
        z = math.floor(pos.Z),
        updatedAt = os.time(),
    }

    local ok, err = pcall(function()
        globalEggs:SetAsync(key, record, CONFIG.EntryTTL, os.time())
    end)
    if not ok then
        warn("[CeboFinder] MemoryStore publish failed:", err)
    end
    localEggKeys[model] = key
end

local function removeEgg(model)
    local key = localEggKeys[model]
    if key then
        pcall(function()
            globalEggs:RemoveAsync(key)
        end)
        localEggKeys[model] = nil
    end
end

local function scanEggs()
    local root = getEggRoot()
    local seen = {}

    for _, inst in ipairs(root:GetDescendants()) do
        if isEggModel(inst) then
            seen[inst] = true
            publishEgg(inst)
        end
    end

    for model in pairs(localEggKeys) do
        if not model.Parent or not seen[model] then
            removeEgg(model)
        end
    end
end

GetFeed.OnServerInvoke = function(player)
    local ok, result = pcall(function()
        return globalEggs:GetRangeAsync(Enum.SortDirection.Descending, CONFIG.FeedLimit)
    end)
    if not ok then
        warn("[CeboFinder] Feed read failed:", result)
        return {}
    end

    local output = {}
    for _, item in ipairs(result) do
        local value = item.value
        if typeof(value) == "table" and isValidRarity(value.rarity) then
            table.insert(output, value)
        end
    end
    return output
end

JoinServer.OnServerInvoke = function(player, key)
    if typeof(key) ~= "string" or #key > 180 then
        return false, "Ungültiger Fund."
    end

    local ok, record = pcall(function()
        return globalEggs:GetAsync(key)
    end)
    if not ok or typeof(record) ~= "table" then
        return false, "Der Fund ist abgelaufen. Bitte aktualisieren."
    end

    if record.placeId ~= game.PlaceId then
        return false, "Der Fund gehört nicht zu diesem Spiel-Place."
    end
    if typeof(record.jobId) ~= "string" or record.jobId == "" then
        return false, "Server-ID fehlt."
    end
    if record.jobId == game.JobId then
        return true, "Du bist bereits auf diesem Server."
    end

    local success, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(record.placeId, record.jobId, player)
    end)
    if not success then
        warn("[CeboFinder] Teleport failed:", err)
        return false, "Teleport fehlgeschlagen: " .. tostring(err)
    end
    return true, "Teleport wird gestartet."
end

CollectEgg.OnServerInvoke = function(player, eggId)
    if typeof(eggId) ~= "string" or #eggId > 100 then
        return false, "Ungültige Ei-ID."
    end

    local now = os.clock()
    if lastRequest[player] and now - lastRequest[player] < 0.7 then
        return false, "Bitte kurz warten."
    end
    lastRequest[player] = now

    local target
    for model in pairs(localEggKeys) do
        if model.Parent and model:GetAttribute("EggId") == eggId then
            target = model
            break
        end
    end
    if not target then
        return false, "Ei ist nicht mehr auf diesem Server."
    end

    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local eggPosition = getPosition(target)
    if not root or not eggPosition then
        return false, "Spieler- oder Ei-Position nicht verfügbar."
    end
    if (root.Position - eggPosition).Magnitude > CONFIG.MaxCollectDistance then
        return false, "Du bist zu weit vom Ei entfernt."
    end

    local handler = ServerScriptService:FindFirstChild("CeboCollectHandler")
    if not handler or not handler:IsA("BindableFunction") then
        return false, "CeboCollectHandler fehlt. Verbinde hier deine Inventar-/Safe-Zone-Logik."
    end

    local success, result = pcall(function()
        return handler:Invoke(player, target)
    end)
    if not success then
        warn("[CeboFinder] Collect handler error:", result)
        return false, "Sammeln fehlgeschlagen. Siehe Server-Output."
    end
    if result ~= true then
        return false, typeof(result) == "string" and result or "Sammeln wurde abgelehnt."
    end

    removeEgg(target)
    return true, "Ei erfolgreich eingesammelt."
end

Players.PlayerRemoving:Connect(function(player)
    lastRequest[player] = nil
end)

task.spawn(function()
    while true do
        scanEggs()
        task.wait(CONFIG.ScanInterval)
    end
end)

game:BindToClose(function()
    for model in pairs(localEggKeys) do
        removeEgg(model)
    end
end)

print("[CeboFinder] Server gestartet. PlaceId:", game.PlaceId)

]====]

local ClientScriptSource = [====[
--[[
    CEBOFINDER - StarterPlayerScripts/CeboFinder.client.lua

    Dark dashboard with Live Feed, rarity filters, Logs, History,
    Auto-Join, and optional same-server Auto-Collect navigation.

    Auto-Collect only works after the server-side CeboCollectHandler
    is connected to your actual inventory/reward/safe-zone logic.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("CeboFinderRemotes")
local GetFeed = remotes:WaitForChild("GetFeed")
local JoinServer = remotes:WaitForChild("JoinServer")
local CollectEgg = remotes:WaitForChild("CollectEgg")

local state = {
    autoJoin = false,
    autoCollect = false,
    showRare = true,
    showLegendary = true,
    showSecret = true,
    currentTab = "LIVE FEED",
    feed = {},
    history = {},
    busy = false,
    minimized = false,
}

local function make(class, props, parent)
    local obj = Instance.new(class)
    for key, value in pairs(props or {}) do
        obj[key] = value
    end
    obj.Parent = parent
    return obj
end

local function corner(parent, radius)
    make("UICorner", {CornerRadius = UDim.new(0, radius or 10)}, parent)
end

local function stroke(parent, color, transparency)
    make("UIStroke", {
        Color = color or Color3.fromRGB(75, 70, 90),
        Transparency = transparency or 0.2,
        Thickness = 1
    }, parent)
end

local gui = make("ScreenGui", {
    Name = "CeboFinder",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, player:WaitForChild("PlayerGui"))

local main = make("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(790, 510),
    Position = UDim2.new(0.5, -395, 0.5, -255),
    BackgroundColor3 = Color3.fromRGB(15, 14, 20),
    BackgroundTransparency = 0.06,
    BorderSizePixel = 0
}, gui)
corner(main, 18)
stroke(main, Color3.fromRGB(105, 92, 140), 0.1)

local top = make("Frame", {
    Size = UDim2.new(1, 0, 0, 58),
    BackgroundColor3 = Color3.fromRGB(25, 22, 33),
    BorderSizePixel = 0
}, main)
corner(top, 18)

make("TextLabel", {
    Position = UDim2.fromOffset(20, 0),
    Size = UDim2.fromOffset(260, 58),
    BackgroundTransparency = 1,
    Text = "CEBOFINDER",
    TextColor3 = Color3.fromRGB(245, 235, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    TextXAlignment = Enum.TextXAlignment.Left
}, top)

local status = make("TextLabel", {
    Position = UDim2.new(1, -160, 0, 0),
    Size = UDim2.fromOffset(140, 58),
    BackgroundTransparency = 1,
    Text = "● CONNECTED",
    TextColor3 = Color3.fromRGB(100, 235, 145),
    Font = Enum.Font.GothamBold,
    TextSize = 12
}, top)

local hideButton = make("TextButton", {
    Position = UDim2.new(1, -48, 0, 13),
    Size = UDim2.fromOffset(34, 32),
    BackgroundColor3 = Color3.fromRGB(55, 48, 68),
    Text = "—",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 18
}, top)
corner(hideButton, 8)

local sidebar = make("Frame", {
    Position = UDim2.fromOffset(12, 70),
    Size = UDim2.new(0, 145, 1, -84),
    BackgroundColor3 = Color3.fromRGB(20, 19, 26),
    BorderSizePixel = 0
}, main)
corner(sidebar, 12)

local content = make("Frame", {
    Position = UDim2.fromOffset(169, 70),
    Size = UDim2.new(1, -181, 1, -84),
    BackgroundTransparency = 1
}, main)

local feedTitle = make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundTransparency = 1,
    Text = "LIVE FEED",
    TextColor3 = Color3.fromRGB(220, 215, 235),
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left
}, content)

local toggleArea = make("Frame", {
    Position = UDim2.fromOffset(0, 34),
    Size = UDim2.new(1, 0, 0, 42),
    BackgroundTransparency = 1
}, content)

local function makeToggle(text, x, initial, callback)
    local button = make("TextButton", {
        Position = UDim2.fromOffset(x, 0),
        Size = UDim2.fromOffset(175, 36),
        BackgroundColor3 = Color3.fromRGB(40, 36, 50),
        Text = text .. ": " .. (initial and "ON" or "OFF"),
        TextColor3 = Color3.fromRGB(235, 230, 245),
        Font = Enum.Font.GothamBold,
        TextSize = 12
    }, toggleArea)
    corner(button, 9)
    button.MouseButton1Click:Connect(function()
        local newValue = callback()
        button.Text = text .. ": " .. (newValue and "ON" or "OFF")
        button.BackgroundColor3 = newValue and Color3.fromRGB(44, 77, 61)
            or Color3.fromRGB(40, 36, 50)
    end)
    return button
end

makeToggle("AUTO-JOIN", 0, false, function()
    state.autoJoin = not state.autoJoin
    return state.autoJoin
end)

makeToggle("AUTO-COLLECT", 185, false, function()
    state.autoCollect = not state.autoCollect
    return state.autoCollect
end)

local list = make("ScrollingFrame", {
    Position = UDim2.fromOffset(0, 84),
    Size = UDim2.new(1, 0, 1, -84),
    BackgroundColor3 = Color3.fromRGB(20, 19, 25),
    BorderSizePixel = 0,
    ScrollBarThickness = 5,
    CanvasSize = UDim2.new()
}, content)
corner(list, 12)

local listLayout = make("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder
}, list)
make("UIPadding", {
    PaddingTop = UDim.new(0, 10),
    PaddingBottom = UDim.new(0, 10),
    PaddingLeft = UDim.new(0, 10),
    PaddingRight = UDim.new(0, 10)
}, list)

local function clearList()
    for _, child in ipairs(list:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
end

local function rarityColor(rarity)
    if rarity == "Secret" then
        return Color3.fromRGB(190, 105, 255)
    elseif rarity == "Legendary" then
        return Color3.fromRGB(255, 195, 75)
    end
    return Color3.fromRGB(85, 190, 255)
end

local function formatIncome(value)
    value = tonumber(value) or 0
    if value >= 1e12 then return string.format("%.2fT/s", value / 1e12) end
    if value >= 1e9 then return string.format("%.2fB/s", value / 1e9) end
    if value >= 1e6 then return string.format("%.2fM/s", value / 1e6) end
    if value >= 1e3 then return string.format("%.2fK/s", value / 1e3) end
    return tostring(math.floor(value)) .. "/s"
end

local function allowed(record)
    if record.rarity == "Rare" then return state.showRare end
    if record.rarity == "Legendary" then return state.showLegendary end
    if record.rarity == "Secret" then return state.showSecret end
    return false
end

local function addEggCard(record, index)
    local card = make("Frame", {
        Size = UDim2.new(1, -8, 0, 86),
        BackgroundColor3 = Color3.fromRGB(31, 29, 38),
        BorderSizePixel = 0,
        LayoutOrder = index
    }, list)
    corner(card, 11)
    stroke(card, rarityColor(record.rarity), 0.55)

    make("Frame", {
        Size = UDim2.fromOffset(5, 62),
        Position = UDim2.fromOffset(0, 12),
        BackgroundColor3 = rarityColor(record.rarity),
        BorderSizePixel = 0
    }, card)
    corner(card:FindFirstChildOfClass("Frame"), 3)

    local image = make("ImageLabel", {
        Position = UDim2.fromOffset(15, 12),
        Size = UDim2.fromOffset(62, 62),
        BackgroundColor3 = Color3.fromRGB(45, 41, 54),
        Image = "",
        ScaleType = Enum.ScaleType.Fit
    }, card)
    corner(image, 8)
    if record.imageId and record.imageId ~= "" then
        local id = tostring(record.imageId)
        image.Image = string.find(id, "rbxassetid://", 1, true) and id or ("rbxassetid://" .. id)
    end

    make("TextLabel", {
        Position = UDim2.fromOffset(88, 10),
        Size = UDim2.new(1, -285, 0, 24),
        BackgroundTransparency = 1,
        Text = tostring(record.animalName or record.eggName or "Unknown Egg"),
        TextColor3 = Color3.fromRGB(245, 240, 250),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd
    }, card)

    make("TextLabel", {
        Position = UDim2.fromOffset(88, 36),
        Size = UDim2.new(1, -285, 0, 20),
        BackgroundTransparency = 1,
        Text = string.upper(tostring(record.rarity)) .. "  •  " .. formatIncome(record.incomePerSecond),
        TextColor3 = rarityColor(record.rarity),
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    }, card)

    make("TextLabel", {
        Position = UDim2.fromOffset(88, 57),
        Size = UDim2.new(1, -285, 0, 17),
        BackgroundTransparency = 1,
        Text = "Server: " .. string.sub(tostring(record.jobId or ""), 1, 12),
        TextColor3 = Color3.fromRGB(155, 150, 170),
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left
    }, card)

    local join = make("TextButton", {
        Position = UDim2.new(1, -174, 0.5, -16),
        Size = UDim2.fromOffset(76, 32),
        BackgroundColor3 = Color3.fromRGB(62, 57, 77),
        Text = "JOIN",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 11
    }, card)
    corner(join, 8)

    join.MouseButton1Click:Connect(function()
        join.Text = "..."
        local ok, success, message = pcall(function()
            return JoinServer:InvokeServer(record.key)
        end)
        join.Text = ok and (success and "SENT" or "ERROR") or "ERROR"
        if not success then
            warn("[CeboFinder] Join:", message)
        end
    end)

    local log = make("TextButton", {
        Position = UDim2.new(1, -88, 0.5, -16),
        Size = UDim2.fromOffset(76, 32),
        BackgroundColor3 = Color3.fromRGB(47, 43, 59),
        Text = "LOG",
        TextColor3 = Color3.fromRGB(225, 220, 240),
        Font = Enum.Font.GothamBold,
        TextSize = 11
    }, card)
    corner(log, 8)
    log.MouseButton1Click:Connect(function()
        table.insert(state.history, 1, record)
        log.Text = "SAVED"
    end)
end

local function render()
    clearList()

    if state.currentTab == "SETTINGS" then
        local settings = {
            {"RARE", "showRare"},
            {"LEGENDARY", "showLegendary"},
            {"SECRET", "showSecret"},
        }
        for i, item in ipairs(settings) do
            local key = item[2]
            local button = make("TextButton", {
                Size = UDim2.new(1, -10, 0, 48),
                BackgroundColor3 = Color3.fromRGB(38, 34, 49),
                Text = item[1] .. ": " .. (state[key] and "ON" or "OFF"),
                TextColor3 = Color3.new(1, 1, 1),
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                LayoutOrder = i
            }, list)
            corner(button, 9)
            button.MouseButton1Click:Connect(function()
                state[key] = not state[key]
                button.Text = item[1] .. ": " .. (state[key] and "ON" or "OFF")
            end)
        end
        return
    end

    local records = state.currentTab == "HISTORY" and state.history or state.feed
    local count = 0
    for _, record in ipairs(records) do
        if state.currentTab == "HISTORY" or allowed(record) then
            count += 1
            addEggCard(record, count)
        end
    end

    if count == 0 then
        make("TextLabel", {
            Size = UDim2.new(1, -10, 0, 55),
            BackgroundTransparency = 1,
            Text = "Keine passenden Eier gefunden.",
            TextColor3 = Color3.fromRGB(165, 158, 180),
            Font = Enum.Font.Gotham,
            TextSize = 13
        }, list)
    end

    task.defer(function()
        list.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
    end)
end

local function setTab(tabName)
    state.currentTab = tabName
    feedTitle.Text = tabName
    render()
end

local tabs = {"LIVE FEED", "LOGS", "HISTORY", "SETTINGS", "USERS"}
for index, name in ipairs(tabs) do
    local button = make("TextButton", {
        Position = UDim2.fromOffset(9, 12 + (index - 1) * 49),
        Size = UDim2.new(1, -18, 0, 40),
        BackgroundColor3 = name == "LIVE FEED" and Color3.fromRGB(65, 55, 82) or Color3.fromRGB(32, 30, 39),
        Text = name,
        TextColor3 = Color3.fromRGB(230, 225, 240),
        Font = Enum.Font.GothamBold,
        TextSize = 11
    }, sidebar)
    corner(button, 8)
    button.MouseButton1Click:Connect(function()
        setTab(name)
    end)
end

hideButton.MouseButton1Click:Connect(function()
    state.minimized = not state.minimized
    for _, child in ipairs(main:GetChildren()) do
        if child ~= top then child.Visible = not state.minimized end
    end
    main.Size = state.minimized and UDim2.fromOffset(790, 58) or UDim2.fromOffset(790, 510)
    hideButton.Text = state.minimized and "+" or "—"
end)

-- Drag window by its top bar.
do
    local dragging = false
    local dragStart, startPosition
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    top.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
            )
        end
    end)
end

local function refreshFeed()
    local ok, result = pcall(function()
        return GetFeed:InvokeServer()
    end)
    if ok and typeof(result) == "table" then
        state.feed = result
        if state.currentTab == "LIVE FEED" or state.currentTab == "LOGS" then
            render()
        end
        status.Text = "● " .. tostring(#result) .. " FOUND"
    else
        status.Text = "● FEED ERROR"
        status.TextColor3 = Color3.fromRGB(255, 110, 110)
    end
end

local function findLocalEgg(eggId)
    for _, inst in ipairs(workspace:GetDescendants()) do
        if inst:IsA("Model") and inst:GetAttribute("EggId") == eggId then
            return inst
        end
    end
    return nil
end

local function moveToEgg(egg)
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local part = egg and (egg.PrimaryPart or egg:FindFirstChildWhichIsA("BasePart", true))
    if not humanoid or not root or not part then return false end

    local path = PathfindingService:CreatePath()
    local ok = pcall(function()
        path:ComputeAsync(root.Position, part.Position)
    end)
    if not ok or path.Status ~= Enum.PathStatus.Success then
        humanoid:MoveTo(part.Position)
        return (root.Position - part.Position).Magnitude < 14
    end

    for _, waypoint in ipairs(path:GetWaypoints()) do
        if not state.autoCollect or not egg.Parent then return false end
        humanoid:MoveTo(waypoint.Position)
        local reached = humanoid.MoveToFinished:Wait()
        if not reached then return false end
    end
    return true
end

task.spawn(function()
    while gui.Parent do
        refreshFeed()
        task.wait(8)
    end
end)

-- Auto-join: join the highest-tier result on another server.
task.spawn(function()
    while gui.Parent do
        if state.autoJoin and not state.busy then
            local selected
            local rank = {Secret = 3, Legendary = 2, Rare = 1}
            for _, record in ipairs(state.feed) do
                if allowed(record) and record.jobId ~= game.JobId then
                    if not selected or (rank[record.rarity] or 0) > (rank[selected.rarity] or 0) then
                        selected = record
                    end
                end
            end
            if selected then
                state.busy = true
                pcall(function()
                    JoinServer:InvokeServer(selected.key)
                end)
                task.wait(10)
                state.busy = false
            end
        end
        task.wait(3)
    end
end)

-- Auto-collect only for eggs on this server. The server validates range
-- and delegates the actual reward/carry logic to CeboCollectHandler.
task.spawn(function()
    while gui.Parent do
        if state.autoCollect and not state.busy then
            local target
            for _, record in ipairs(state.feed) do
                if allowed(record) and record.jobId == game.JobId then
                    target = record
                    break
                end
            end

            if target then
                state.busy = true
                local egg = findLocalEgg(target.eggId)
                if egg and moveToEgg(egg) then
                    local ok, success, message = pcall(function()
                        return CollectEgg:InvokeServer(target.eggId)
                    end)
                    if not ok or not success then
                        warn("[CeboFinder] Auto-collect:", message)
                    end
                    task.wait(2)
                end
                state.busy = false
            end
        end
        task.wait(2)
    end
end)

render()
refreshFeed()
print("[CeboFinder] Client gestartet.")

]====]

local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayer = game:GetService("StarterPlayer")
local StarterPlayerScripts = StarterPlayer:WaitForChild("StarterPlayerScripts")

local function replaceScript(parent, name, className, source)
    local existing = parent:FindFirstChild(name)
    if existing then
        existing:Destroy()
    end

    local scriptObject = Instance.new(className)
    scriptObject.Name = name
    scriptObject.Source = source
    scriptObject.Parent = parent
    return scriptObject
end

local serverScript = replaceScript(
    ServerScriptService,
    "CeboFinder.server",
    "Script",
    ServerScriptSource
)

local clientScript = replaceScript(
    StarterPlayerScripts,
    "CeboFinder.client",
    "LocalScript",
    ClientScriptSource
)

print("======================================")
print("[CeboFinder] Installation completed.")
print("Server: ServerScriptService/CeboFinder.server")
print("Client: StarterPlayerScripts/CeboFinder.client")
print("Reminder: configure MemoryStore API access.")
print("Reminder: connect CeboCollectHandler to your")
print("existing inventory / egg / safe-zone system.")
print("======================================")
