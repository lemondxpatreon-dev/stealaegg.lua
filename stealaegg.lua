-- CeboFinder Mobile - real visible-spawn scanner for an experience you own/manage.
-- Install as a LocalScript in StarterPlayer > StarterPlayerScripts.
-- It scans replicated Workspace objects in THIS server only. It does not fabricate pets.
-- Optional attributes on pet Models/Parts:
--   IsPet (boolean true), DisplayName (string), Rarity (string), Income (string/number), IconImage (string asset id)
-- Alternatively, models with names containing "pet" or "egg" are detected as candidates.
-- Cross-server spawn data requires a server-owned backend/RemoteEvent; a LocalScript cannot see other servers.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("CeboFinderRealSpawns")
if old then old:Destroy() end

local C = {
    bg = Color3.fromRGB(16, 17, 22),
    panel = Color3.fromRGB(25, 27, 34),
    card = Color3.fromRGB(34, 36, 45),
    line = Color3.fromRGB(63, 66, 80),
    text = Color3.fromRGB(245, 246, 250),
    muted = Color3.fromRGB(163, 168, 183),
    blue = Color3.fromRGB(65, 105, 255),
    green = Color3.fromRGB(70, 205, 130),
    red = Color3.fromRGB(255, 100, 100),
}

local gui = Instance.new("ScreenGui")
gui.Name = "CeboFinderRealSpawns"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.DisplayOrder = 100
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.new(0.94, 0, 0.78, 0)
main.BackgroundColor3 = C.bg
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)
local stroke = Instance.new("UIStroke", main)
stroke.Color = C.line
stroke.Thickness = 1.5

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local header = make("Frame", {Size=UDim2.new(1,0,0,56), BackgroundColor3=C.panel, BorderSizePixel=0}, main)
Instance.new("UICorner", header).CornerRadius = UDim.new(0,16)
make("TextLabel", {Position=UDim2.new(0,14,0,0), Size=UDim2.new(0.7,0,1,0), BackgroundTransparency=1,
    Text="CeboFinder  •  REAL SCAN", TextColor3=C.text, Font=Enum.Font.GothamBold, TextSize=17,
    TextXAlignment=Enum.TextXAlignment.Left}, header)
local close = make("TextButton", {AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-10,0.5,0), Size=UDim2.new(0,38,0,36),
    BackgroundColor3=C.card, Text="×", TextColor3=C.text, Font=Enum.Font.GothamBold, TextSize=25, BorderSizePixel=0}, header)
Instance.new("UICorner", close).CornerRadius = UDim.new(0,10)
close.Activated:Connect(function() gui.Enabled = false end)

local status = make("TextLabel", {Position=UDim2.new(0,14,0,64), Size=UDim2.new(1,-28,0,28), BackgroundTransparency=1,
    Text="Scanning visible objects in this server…", TextColor3=C.muted, Font=Enum.Font.Gotham, TextSize=12,
    TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true}, main)

local refresh = make("TextButton", {Position=UDim2.new(0,14,0,96), Size=UDim2.new(0.5,-18,0,38), BackgroundColor3=C.blue,
    Text="Refresh scan", TextColor3=C.text, Font=Enum.Font.GothamBold, TextSize=14, BorderSizePixel=0}, main)
Instance.new("UICorner", refresh).CornerRadius = UDim.new(0,10)
local auto = make("TextButton", {AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,-14,0,96), Size=UDim2.new(0.5,-18,0,38),
    BackgroundColor3=C.card, Text="Auto-refresh: OFF", TextColor3=C.text, Font=Enum.Font.GothamBold, TextSize=13, BorderSizePixel=0}, main)
Instance.new("UICorner", auto).CornerRadius = UDim.new(0,10)

local list = make("ScrollingFrame", {Position=UDim2.new(0,12,0,144), Size=UDim2.new(1,-24,1,-156), BackgroundTransparency=1,
    BorderSizePixel=0, ScrollBarThickness=4, ScrollBarImageColor3=C.line, CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y}, main)
make("UIListLayout", {Padding=UDim.new(0,8), SortOrder=Enum.SortOrder.LayoutOrder}, list)
make("UIPadding", {PaddingBottom=UDim.new(0,8), PaddingTop=UDim.new(0,2), PaddingLeft=UDim.new(0,1), PaddingRight=UDim.new(0,4)}, list)

local function getIcon(obj)
    local icon = obj:GetAttribute("IconImage")
    if typeof(icon) == "number" then return "rbxassetid://" .. tostring(icon) end
    if typeof(icon) == "string" and icon ~= "" then
        if string.find(icon, "rbxassetid://", 1, true) then return icon end
        if tonumber(icon) then return "rbxassetid://" .. icon end
    end
    for _, d in ipairs(obj:GetDescendants()) do
        if d:IsA("Decal") and d.Texture ~= "" then return d.Texture end
        if d:IsA("ImageLabel") and d.Image ~= "" then return d.Image end
    end
    return ""
end

local function candidate(obj)
    if not (obj:IsA("Model") or obj:IsA("BasePart")) then return false end
    if obj:GetAttribute("IsPet") == true then return true end
    local n = string.lower(obj.Name)
    return string.find(n, "pet", 1, true) ~= nil or string.find(n, "egg", 1, true) ~= nil
end

local function clearCards()
    for _, child in ipairs(list:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then child:Destroy() end
    end
end

local function addCard(obj, index)
    local displayName = obj:GetAttribute("DisplayName")
    if typeof(displayName) ~= "string" or displayName == "" then displayName = obj.Name end
    local rarity = obj:GetAttribute("Rarity")
    if typeof(rarity) ~= "string" or rarity == "" then rarity = "Rarity not provided" end
    local income = obj:GetAttribute("Income")
    if income == nil then income = "Income not provided" end

    local card = make("Frame", {Size=UDim2.new(1,-4,0,88), BackgroundColor3=C.card, BorderSizePixel=0, LayoutOrder=index}, list)
    Instance.new("UICorner", card).CornerRadius = UDim.new(0,12)
    make("UIStroke", {Color=C.line, Thickness=1, Transparency=0.25}, card)
    local img = make("ImageLabel", {Position=UDim2.new(0,8,0,8), Size=UDim2.new(0,72,0,72), BackgroundColor3=C.panel,
        BorderSizePixel=0, ScaleType=Enum.ScaleType.Crop, Image=getIcon(obj)}, card)
    Instance.new("UICorner", img).CornerRadius = UDim.new(0,9)
    if img.Image == "" then
        make("TextLabel", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="NO\nIMAGE", TextColor3=C.muted,
            Font=Enum.Font.GothamBold, TextSize=11, TextWrapped=true}, img)
    end
    make("TextLabel", {Position=UDim2.new(0,90,0,8), Size=UDim2.new(1,-98,0,24), BackgroundTransparency=1,
        Text=displayName, TextColor3=C.text, Font=Enum.Font.GothamBold, TextSize=15, TextXAlignment=Enum.TextXAlignment.Left,
        TextTruncate=Enum.TextTruncate.AtEnd}, card)
    make("TextLabel", {Position=UDim2.new(0,90,0,33), Size=UDim2.new(1,-98,0,20), BackgroundTransparency=1,
        Text="Rarity: "..rarity, TextColor3=C.muted, Font=Enum.Font.Gotham, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left,
        TextTruncate=Enum.TextTruncate.AtEnd}, card)
    make("TextLabel", {Position=UDim2.new(0,90,0,55), Size=UDim2.new(1,-98,0,22), BackgroundTransparency=1,
        Text="Income: "..tostring(income), TextColor3=C.green, Font=Enum.Font.GothamSemibold, TextSize=12,
        TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd}, card)
end

local function scan()
    clearCards()
    local found, seen = {}, {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if candidate(obj) and not seen[obj] then
            seen[obj] = true
            table.insert(found, obj)
        end
    end
    table.sort(found, function(a,b) return a.Name:lower() < b.Name:lower() end)
    for i, obj in ipairs(found) do addCard(obj, i) end
    if #found == 0 then
        local empty = make("TextLabel", {Size=UDim2.new(1,-4,0,84), BackgroundColor3=C.card, BorderSizePixel=0,
            Text="No matching pet/egg objects found.\nYour game's object names may need a detection rule.", TextColor3=C.muted,
            Font=Enum.Font.Gotham, TextSize=13, TextWrapped=true, LayoutOrder=1}, list)
        Instance.new("UICorner", empty).CornerRadius = UDim.new(0,12)
        status.Text = "0 matching objects • current server only"
    else
        status.Text = tostring(#found).." matching objects • current server only • images need IconImage or an image/decal"
    end
end

local autoOn = false
local scanBusy = false
refresh.Activated:Connect(scan)
auto.Activated:Connect(function()
    autoOn = not autoOn
    auto.Text = autoOn and "Auto-refresh: ON" or "Auto-refresh: OFF"
    auto.BackgroundColor3 = autoOn and Color3.fromRGB(38,91,69) or C.card
end)

task.spawn(function()
    scan()
    while gui.Parent do
        task.wait(3)
        if autoOn and not scanBusy then
            scanBusy = true
            pcall(scan)
            scanBusy = false
        end
    end
end)
