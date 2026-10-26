-- CeboFinder Mobile REAL SCAN v2
-- LocalScript for an experience you own/manage. Place in StarterPlayerScripts.
-- Detects only Model objects, prioritizes explicit IsPet/IsEgg attributes, and avoids
-- counting every MeshPart/BasePart as a separate result.
-- This scans the CURRENT server only. Cross-server spawns require an authorized server-side feed.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local old = playerGui:FindFirstChild("CeboFinderRealSpawns")
if old then old:Destroy() end

local C = {
    bg = Color3.fromRGB(16,17,22), panel = Color3.fromRGB(25,27,34),
    card = Color3.fromRGB(34,36,45), line = Color3.fromRGB(63,66,80),
    text = Color3.fromRGB(245,246,250), muted = Color3.fromRGB(163,168,183),
    blue = Color3.fromRGB(65,105,255), green = Color3.fromRGB(70,205,130)
}
local function make(class, props, parent)
    local obj = Instance.new(class)
    for k,v in pairs(props) do obj[k] = v end
    obj.Parent = parent
    return obj
end
local function corner(obj, radius)
    Instance.new("UICorner", obj).CornerRadius = UDim.new(0, radius or 10)
end

local gui = make("ScreenGui", {
    Name="CeboFinderRealSpawns", ResetOnSpawn=false, IgnoreGuiInset=false,
    DisplayOrder=100, ZIndexBehavior=Enum.ZIndexBehavior.Sibling
}, playerGui)

-- Small floating reopen button; visible when panel is minimized.
local reopen = make("TextButton", {
    Name="ReopenButton", Size=UDim2.fromOffset(54,54), Position=UDim2.new(0,16,0.45,0),
    BackgroundColor3=C.blue, Text="CF", TextColor3=C.text, Font=Enum.Font.GothamBold,
    TextSize=18, BorderSizePixel=0, Visible=false, Active=true
}, gui)
corner(reopen, 27)
make("UIStroke", {Color=C.green, Thickness=2}, reopen)

local main = make("Frame", {
    Name="Main", AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5),
    Size=UDim2.new(0.88,0,0.58,0), BackgroundColor3=C.bg, BorderSizePixel=0,
    Active=true
}, gui)
main.Size = UDim2.new(0.88,0,0,390)
main.Position = UDim2.new(0.5,0,0.5,0)
corner(main, 15)
make("UIStroke", {Color=C.line, Thickness=1.3}, main)

local header = make("Frame", {Size=UDim2.new(1,0,0,46), BackgroundColor3=C.panel, BorderSizePixel=0, Active=true}, main)
corner(header, 15)
make("TextLabel", {
    Position=UDim2.new(0,12,0,0), Size=UDim2.new(1,-104,1,0), BackgroundTransparency=1,
    Text="CeboFinder • REAL SCAN", TextColor3=C.text, Font=Enum.Font.GothamBold,
    TextSize=15, TextXAlignment=Enum.TextXAlignment.Left
}, header)

local minimize = make("TextButton", {
    AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-8,0.5,0), Size=UDim2.fromOffset(34,32),
    BackgroundColor3=C.card, Text="—", TextColor3=C.text, Font=Enum.Font.GothamBold,
    TextSize=19, BorderSizePixel=0
}, header)
corner(minimize, 9)

local status = make("TextLabel", {
    Position=UDim2.new(0,12,0,51), Size=UDim2.new(1,-24,0,30), BackgroundTransparency=1,
    Text="Scannt sichtbare Eier/Pets in diesem Server …", TextColor3=C.muted,
    Font=Enum.Font.Gotham, TextSize=11, TextWrapped=true, TextXAlignment=Enum.TextXAlignment.Left
}, main)

local refresh = make("TextButton", {
    Position=UDim2.new(0,12,0,84), Size=UDim2.new(0.56,-8,0,36), BackgroundColor3=C.blue,
    Text="Jetzt scannen", TextColor3=C.text, Font=Enum.Font.GothamBold, TextSize=13, BorderSizePixel=0
}, main)
corner(refresh, 9)
local auto = make("TextButton", {
    AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,-12,0,84), Size=UDim2.new(0.44,-8,0,36),
    BackgroundColor3=C.card, Text="Auto: AUS", TextColor3=C.text, Font=Enum.Font.GothamBold,
    TextSize=12, BorderSizePixel=0
}, main)
corner(auto, 9)

local list = make("ScrollingFrame", {
    Position=UDim2.new(0,10,0,128), Size=UDim2.new(1,-20,1,-138),
    BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=3,
    ScrollBarImageColor3=C.line, CanvasSize=UDim2.new(0,0,0,0),
    AutomaticCanvasSize=Enum.AutomaticSize.Y
}, main)
make("UIListLayout", {Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder}, list)
make("UIPadding", {PaddingBottom=UDim.new(0,6), PaddingTop=UDim.new(0,2)}, list)

local function getIcon(obj)
    local icon = obj:GetAttribute("IconImage") or obj:GetAttribute("Image")
    if typeof(icon) == "number" then return "rbxassetid://"..icon end
    if typeof(icon) == "string" and icon ~= "" then
        if string.find(icon, "rbxassetid://", 1, true) then return icon end
        if tonumber(icon) then return "rbxassetid://"..icon end
    end
    for _, d in ipairs(obj:GetDescendants()) do
        if d:IsA("Decal") and d.Texture ~= "" then return d.Texture end
        if d:IsA("ImageLabel") and d.Image ~= "" then return d.Image end
    end
    return ""
end

local function isCandidate(obj)
    -- Never show standalone MeshParts/Parts as individual pets.
    if not obj:IsA("Model") then return false end
    if obj:GetAttribute("IsPet") == true or obj:GetAttribute("IsEgg") == true then return true end

    local n = string.lower(obj.Name)
    -- Fallback only for model names that clearly identify an egg or pet.
    local nameMatch = string.find(n, "egg", 1, true) or string.find(n, "pet", 1, true)
    if not nameMatch then return false end

    -- Ignore generic model containers and models with no physical contents.
    local hasGeometry = false
    for _, d in ipairs(obj:GetDescendants()) do
        if d:IsA("BasePart") then hasGeometry = true break end
    end
    if not hasGeometry then return false end

    -- If this is a nested model inside another matching egg/pet model, count only the outer model.
    local parent = obj.Parent
    while parent and parent ~= Workspace do
        if parent:IsA("Model") then
            if parent:GetAttribute("IsPet") == true or parent:GetAttribute("IsEgg") == true then return false end
            local pn = string.lower(parent.Name)
            if string.find(pn, "egg", 1, true) or string.find(pn, "pet", 1, true) then return false end
        end
        parent = parent.Parent
    end
    return true
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
    if typeof(rarity) ~= "string" or rarity == "" then rarity = "Not provided" end
    local income = obj:GetAttribute("Income")
    if income == nil then income = "Not provided" end

    local card = make("Frame", {Size=UDim2.new(1,-3,0,68), BackgroundColor3=C.card, BorderSizePixel=0, LayoutOrder=index}, list)
    corner(card, 10)
    make("UIStroke", {Color=C.line, Thickness=1, Transparency=0.25}, card)
    local img = make("ImageLabel", {
        Position=UDim2.new(0,6,0,6), Size=UDim2.fromOffset(56,56), BackgroundColor3=C.panel,
        BorderSizePixel=0, ScaleType=Enum.ScaleType.Crop, Image=getIcon(obj)
    }, card)
    corner(img, 8)
    if img.Image == "" then
        make("TextLabel", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="NO\nIMAGE",
            TextColor3=C.muted, Font=Enum.Font.GothamBold, TextSize=9, TextWrapped=true}, img)
    end
    make("TextLabel", {
        Position=UDim2.new(0,70,0,5), Size=UDim2.new(1,-76,0,20), BackgroundTransparency=1,
        Text=displayName, TextColor3=C.text, Font=Enum.Font.GothamBold, TextSize=13,
        TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd
    }, card)
    make("TextLabel", {
        Position=UDim2.new(0,70,0,26), Size=UDim2.new(1,-76,0,17), BackgroundTransparency=1,
        Text="Rarity: "..rarity, TextColor3=C.muted, Font=Enum.Font.Gotham, TextSize=10,
        TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd
    }, card)
    make("TextLabel", {
        Position=UDim2.new(0,70,0,43), Size=UDim2.new(1,-76,0,17), BackgroundTransparency=1,
        Text="Income: "..tostring(income), TextColor3=C.green, Font=Enum.Font.GothamSemibold, TextSize=10,
        TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd
    }, card)
end

local function scan()
    clearCards()
    local found, seen = {}, {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if not seen[obj] and isCandidate(obj) then
            seen[obj] = true
            table.insert(found, obj)
        end
    end
    table.sort(found, function(a,b) return a.Name:lower() < b.Name:lower() end)
    for i,obj in ipairs(found) do addCard(obj, i) end

    if #found == 0 then
        local empty = make("TextLabel", {
            Size=UDim2.new(1,-3,0,62), BackgroundColor3=C.card, BorderSizePixel=0,
            Text="Keine klar erkennbaren Ei-/Pet-Modelle gefunden.\nObjektnamen oder Attribute müssen angepasst werden.",
            TextColor3=C.muted, Font=Enum.Font.Gotham, TextSize=11, TextWrapped=true, LayoutOrder=1
        }, list)
        corner(empty, 10)
        status.Text = "0 Eier/Pets • nur aktueller Server"
    else
        status.Text = tostring(#found).." Ei-/Pet-Modelle • nur aktueller Server"
    end
end

local autoOn = false
refresh.Activated:Connect(function() pcall(scan) end)
auto.Activated:Connect(function()
    autoOn = not autoOn
    auto.Text = autoOn and "Auto: AN" or "Auto: AUS"
    auto.BackgroundColor3 = autoOn and Color3.fromRGB(38,91,69) or C.card
end)
minimize.Activated:Connect(function()
    main.Visible = false
    reopen.Visible = true
end)
reopen.Activated:Connect(function()
    main.Visible = true
    reopen.Visible = false
end)

-- Drag by header: supports mouse and touch on mobile.
local dragging, dragStart, startPos, dragInput = false, nil, nil, nil
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

task.spawn(function()
    pcall(scan)
    while gui.Parent do
        task.wait(4)
        if autoOn then pcall(scan) end
    end
end)
