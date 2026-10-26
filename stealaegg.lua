-- CeboFinder-style mobile menu for YOUR OWN Roblox experience.
-- Put this in a LocalScript (StarterPlayer > StarterPlayerScripts).
-- Upload each pet picture as a Roblox image/decal, then replace the image IDs below.
-- This is a UI template: connect Join/Force buttons to your own server-side game systems.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Replace these example entries with pets that exist in YOUR game.
-- image must be a Roblox image asset ID, e.g. "rbxassetid://1234567890".
local PETS = {
    {name = "Starry Fox", rate = "$18.4B/s", rarity = "Secret", age = "7/4 · 0:11", image = "rbxassetid://0"},
    {name = "Starry Fox", rate = "$6.1B/s", rarity = "Secret", age = "7/7 · 0:12", image = "rbxassetid://0"},
    {name = "Starry Fox", rate = "$2.9B/s", rarity = "Secret", age = "7/5 · 0:11", image = "rbxassetid://0"},
    {name = "Starry Fox", rate = "$2.4B/s", rarity = "Secret", age = "7/2 · 0:10", image = "rbxassetid://0"},
    {name = "Starry Fox", rate = "$1.8B/s", rarity = "Secret", age = "7/5 · 0:10", image = "rbxassetid://0"},
    {name = "Starry Fox", rate = "$1.4B/s", rarity = "Secret", age = "7/2 · 0:09", image = "rbxassetid://0"},
}

local COLORS = {
    panel = Color3.fromRGB(15, 18, 15),
    card = Color3.fromRGB(20, 20, 20),
    stroke = Color3.fromRGB(110, 110, 110),
    white = Color3.fromRGB(245, 245, 245),
    muted = Color3.fromRGB(170, 170, 170),
    green = Color3.fromRGB(90, 210, 60),
}

local gui = Instance.new("ScreenGui")
gui.Name = "CeboFinderMobile"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.new(0.96, 0, 0.82, 0)
main.BackgroundColor3 = COLORS.panel
main.BackgroundTransparency = 0.04
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = COLORS.stroke
mainStroke.Thickness = 2

local scale = Instance.new("UIScale")
scale.Scale = 1
scale.Parent = main

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0.19, 0, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
sidebar.BorderSizePixel = 0
sidebar.Parent = main

local brand = Instance.new("TextLabel")
brand.Size = UDim2.new(1, -12, 0, 38)
brand.Position = UDim2.new(0, 8, 0, 8)
brand.BackgroundTransparency = 1
brand.Text = "CeboFinder"
brand.TextColor3 = COLORS.white
brand.TextScaled = true
brand.Font = Enum.Font.GothamBold
brand.Parent = sidebar

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -12, 0, 26)
status.Position = UDim2.new(0, 8, 0, 48)
status.BackgroundTransparency = 1
status.Text = "●  Connected"
status.TextColor3 = COLORS.white
status.TextScaled = true
status.Font = Enum.Font.Gotham
status.Parent = sidebar

local hide = Instance.new("TextButton")
hide.Size = UDim2.new(1, -18, 0, 38)
hide.Position = UDim2.new(0, 9, 1, -48)
hide.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
hide.Text = "Hide"
hide.TextColor3 = COLORS.white
hide.TextScaled = true
hide.Font = Enum.Font.GothamBold
hide.Parent = sidebar
Instance.new("UICorner", hide).CornerRadius = UDim.new(0, 9)
hide.Activated:Connect(function()
    main.Visible = false
end)

local reopen = Instance.new("TextButton")
reopen.Name = "ReopenMenu"
reopen.Size = UDim2.fromOffset(76, 42)
reopen.Position = UDim2.new(0, 12, 0.5, -21)
reopen.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
reopen.Text = "OPEN"
reopen.TextColor3 = COLORS.white
reopen.TextScaled = true
reopen.Font = Enum.Font.GothamBold
reopen.Visible = false
reopen.Parent = gui
Instance.new("UICorner", reopen).CornerRadius = UDim.new(0, 10)
reopen.Activated:Connect(function()
    main.Visible = true
    reopen.Visible = false
end)
hide.Activated:Connect(function()
    main.Visible = false
    reopen.Visible = true
end)

local content = Instance.new("Frame")
content.Name = "Content"
content.Position = UDim2.new(0.20, 0, 0, 0)
content.Size = UDim2.new(0.80, -8, 1, 0)
content.BackgroundTransparency = 1
content.Parent = main

local function makeToggle(text, xScale, widthScale)
    local holder = Instance.new("Frame")
    holder.Position = UDim2.new(xScale, 0, 0, 10)
    holder.Size = UDim2.new(widthScale, -8, 0, 48)
    holder.BackgroundColor3 = Color3.fromRGB(20, 22, 20)
    holder.Parent = content
    Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 12)
    local border = Instance.new("UIStroke", holder)
    border.Color = COLORS.stroke
    border.Thickness = 1.5

    local label = Instance.new("TextLabel")
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(0.62, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = COLORS.white
    label.TextScaled = true
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder

    local toggle = Instance.new("TextButton")
    toggle.AnchorPoint = Vector2.new(1, 0.5)
    toggle.Position = UDim2.new(1, -8, 0.5, 0)
    toggle.Size = UDim2.new(0, 48, 0, 27)
    toggle.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    toggle.Text = "●"
    toggle.TextColor3 = COLORS.white
    toggle.TextScaled = true
    toggle.Font = Enum.Font.GothamBold
    toggle.Parent = holder
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

    local enabled = false
    toggle.Activated:Connect(function()
        enabled = not enabled
        toggle.BackgroundColor3 = enabled and COLORS.green or Color3.fromRGB(55, 55, 55)
        toggle.Text = enabled and "●" or "●"
        label.Text = text .. (enabled and "  ON" or "  OFF")
        -- UI-only toggles: attach your own game logic here.
    end)
    return holder
end

makeToggle("Auto-Join", 0, 0.5)
makeToggle("Auto-Force", 0.5, 0.5)

local feedTitle = Instance.new("TextLabel")
feedTitle.Position = UDim2.new(0, 0, 0, 64)
feedTitle.Size = UDim2.new(1, -4, 0, 30)
feedTitle.BackgroundTransparency = 1
feedTitle.Text = "LIVE FEED                                  " .. tostring(#PETS) .. " detected"
feedTitle.TextColor3 = COLORS.muted
feedTitle.TextScaled = true
feedTitle.Font = Enum.Font.GothamSemibold
feedTitle.TextXAlignment = Enum.TextXAlignment.Left
feedTitle.Parent = content

local clear = Instance.new("TextButton")
clear.AnchorPoint = Vector2.new(1, 0)
clear.Position = UDim2.new(1, -4, 0, 66)
clear.Size = UDim2.new(0, 54, 0, 25)
clear.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
clear.Text = "Clear"
clear.TextColor3 = COLORS.white
clear.TextScaled = true
clear.Font = Enum.Font.Gotham
clear.Parent = content
Instance.new("UICorner", clear).CornerRadius = UDim.new(0, 7)

local feed = Instance.new("ScrollingFrame")
feed.Name = "LiveFeed"
feed.Position = UDim2.new(0, 0, 0, 100)
feed.Size = UDim2.new(1, -4, 1, -112)
feed.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
feed.BorderSizePixel = 0
feed.ScrollBarThickness = 5
feed.ScrollBarImageColor3 = COLORS.muted
feed.CanvasSize = UDim2.new(0, 0, 0, 0)
feed.AutomaticCanvasSize = Enum.AutomaticSize.Y
feed.Parent = content
Instance.new("UICorner", feed).CornerRadius = UDim.new(0, 12)
local feedStroke = Instance.new("UIStroke", feed)
feedStroke.Color = Color3.fromRGB(75, 75, 75)
feedStroke.Thickness = 1.5

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 7)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = feed

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 8)
padding.PaddingBottom = UDim.new(0, 8)
padding.PaddingLeft = UDim.new(0, 8)
padding.PaddingRight = UDim.new(0, 8)
padding.Parent = feed

local function addPetCard(pet, index)
    local card = Instance.new("Frame")
    card.Name = "PetCard" .. index
    card.Size = UDim2.new(1, -6, 0, 76)
    card.BackgroundColor3 = COLORS.card
    card.BorderSizePixel = 0
    card.LayoutOrder = index
    card.Parent = feed
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
    local edge = Instance.new("UIStroke", card)
    edge.Color = COLORS.stroke
    edge.Thickness = 1.4

    local stripe = Instance.new("Frame")
    stripe.Position = UDim2.new(0, 7, 0, 8)
    stripe.Size = UDim2.new(0, 4, 1, -16)
    stripe.BackgroundColor3 = COLORS.white
    stripe.BorderSizePixel = 0
    stripe.Parent = card
    Instance.new("UICorner", stripe).CornerRadius = UDim.new(1, 0)

    -- The pet is displayed as a PICTURE in an ImageLabel, not as a 3D object or mesh.
    local picture = Instance.new("ImageLabel")
    picture.Name = "PetPicture"
    picture.Position = UDim2.new(0, 18, 0.5, -22)
    picture.Size = UDim2.fromOffset(44, 44)
    picture.BackgroundTransparency = 1
    picture.ScaleType = Enum.ScaleType.Fit
    picture.Image = pet.image
    picture.Parent = card

    local name = Instance.new("TextLabel")
    name.Position = UDim2.new(0, 68, 0, 8)
    name.Size = UDim2.new(1, -220, 0, 32)
    name.BackgroundTransparency = 1
    name.Text = pet.name .. "  [ " .. pet.rate .. " ]"
    name.TextColor3 = COLORS.white
    name.TextScaled = true
    name.Font = Enum.Font.GothamBold
    name.TextXAlignment = Enum.TextXAlignment.Left
    name.Parent = card

    local details = Instance.new("TextLabel")
    details.Position = UDim2.new(0, 68, 0, 40)
    details.Size = UDim2.new(1, -220, 0, 22)
    details.BackgroundTransparency = 1
    details.Text = pet.age .. " · " .. pet.rarity
    details.TextColor3 = COLORS.muted
    details.TextScaled = true
    details.Font = Enum.Font.Gotham
    details.TextXAlignment = Enum.TextXAlignment.Left
    details.Parent = card

    local join = Instance.new("TextButton")
    join.AnchorPoint = Vector2.new(1, 0.5)
    join.Position = UDim2.new(1, -72, 0.5, 0)
    join.Size = UDim2.new(0, 58, 0, 32)
    join.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    join.Text = "VIEW"
    join.TextColor3 = COLORS.white
    join.TextScaled = true
    join.Font = Enum.Font.GothamBold
    join.Parent = card
    Instance.new("UICorner", join).CornerRadius = UDim.new(0, 8)
    local joinStroke = Instance.new("UIStroke", join)
    joinStroke.Color = COLORS.stroke
    join.Activated:Connect(function()
        status.Text = "Selected: " .. pet.name
        -- Connect this to your own experience's legitimate view/teleport logic.
    end)

    local force = Instance.new("TextButton")
    force.AnchorPoint = Vector2.new(1, 0.5)
    force.Position = UDim2.new(1, -8, 0.5, 0)
    force.Size = UDim2.new(0, 56, 0, 32)
    force.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    force.Text = "TRACK"
    force.TextColor3 = COLORS.white
    force.TextScaled = true
    force.Font = Enum.Font.GothamBold
    force.Parent = card
    Instance.new("UICorner", force).CornerRadius = UDim.new(0, 8)
    force.Activated:Connect(function()
        status.Text = "Tracking: " .. pet.name
        -- UI-only example; connect to your own game's tracking feature.
    end)
end

local function renderPets()
    for _, child in ipairs(feed:GetChildren()) do
        if child:IsA("Frame") and child.Name:match("^PetCard") then
            child:Destroy()
        end
    end
    for index, pet in ipairs(PETS) do
        addPetCard(pet, index)
    end
    feedTitle.Text = "LIVE FEED                                  " .. tostring(#PETS) .. " detected"
end

clear.Activated:Connect(function()
    for _, child in ipairs(feed:GetChildren()) do
        if child:IsA("Frame") and child.Name:match("^PetCard") then
            child:Destroy()
        end
    end
    feedTitle.Text = "LIVE FEED                                  0 detected"
end)

renderPets()
