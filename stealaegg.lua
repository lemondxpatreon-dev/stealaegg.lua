-- Steal An Egg: 100+ Egg Catalog Finder
-- Community catalog reference: https://stealaneggindex.com/eggs
-- Names/rarities/areas are community data, not internal Roblox instance IDs.
-- This GUI is a searchable catalog; it does not claim live spawn/server IDs.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
if not player then return end

local EGGS = {
    {name = 'Chicken', rarity = 'Common', area = 'Forest', live = false},
    {name = 'Dog', rarity = 'Common', area = 'Forest', live = false},
    {name = 'Bird', rarity = 'Uncommon', area = 'Forest', live = false},
    {name = 'Burrowing Owl', rarity = 'Rare', area = 'Forest', live = false},
    {name = 'Raccoon', rarity = 'Rare', area = 'Forest', live = false},
    {name = 'Fox', rarity = 'Epic', area = 'Forest', live = false},
    {name = 'Bear', rarity = 'Epic', area = 'Forest', live = false},
    {name = 'Brr Brr Patapim', rarity = 'Legendary', area = 'Forest', live = false},
    {name = 'Frog', rarity = 'Common', area = 'Lake', live = false},
    {name = 'Duckling', rarity = 'Common', area = 'Lake', live = false},
    {name = 'Catfish', rarity = 'Uncommon', area = 'Lake', live = false},
    {name = 'Turtle', rarity = 'Rare', area = 'Lake', live = false},
    {name = 'Trulimero Trulicina', rarity = 'Epic', area = 'Lake', live = false},
    {name = 'Swan', rarity = 'Epic', area = 'Lake', live = false},
    {name = 'Axolotl', rarity = 'Legendary', area = 'Lake', live = false},
    {name = 'Leviathan', rarity = 'Cosmic', area = 'Lake', live = false},
    {name = 'Jerboa', rarity = 'Common', area = 'Desert', live = false},
    {name = 'Fennec', rarity = 'Uncommon', area = 'Desert', live = false},
    {name = 'Camel', rarity = 'Rare', area = 'Desert', live = false},
    {name = 'Tob Tobi Tob Tob', rarity = 'Epic', area = 'Desert', live = false},
    {name = 'Snake', rarity = 'Legendary', area = 'Desert', live = false},
    {name = 'Sand Spider', rarity = 'Mythic', area = 'Desert', live = false},
    {name = 'Scorpion', rarity = 'Mythic', area = 'Desert', live = false},
    {name = 'Royal Sphinx', rarity = 'Cosmic', area = 'Desert', live = false},
    {name = 'Chimpanzee', rarity = 'Rare', area = 'Jungle', live = false},
    {name = 'Toucan', rarity = 'Rare', area = 'Jungle', live = false},
    {name = 'Crocodile', rarity = 'Epic', area = 'Jungle', live = false},
    {name = 'Gorilla', rarity = 'Legendary', area = 'Jungle', live = false},
    {name = 'Orangutini Ananassini', rarity = 'Legendary', area = 'Jungle', live = false},
    {name = 'Spider', rarity = 'Mythic', area = 'Jungle', live = false},
    {name = 'Tiger', rarity = 'Mythic', area = 'Jungle', live = false},
    {name = 'King Snake', rarity = 'Secret', area = 'Jungle', live = false},
    {name = 'Penguin', rarity = 'Rare', area = 'Snow', live = false},
    {name = 'Walrus', rarity = 'Epic', area = 'Snow', live = false},
    {name = 'Polar Bear', rarity = 'Legendary', area = 'Snow', live = false},
    {name = 'Sabertooth Tiger', rarity = 'Mythic', area = 'Snow', live = false},
    {name = 'Mammoth', rarity = 'Mythic', area = 'Snow', live = false},
    {name = 'King Mammoth', rarity = 'Cosmic', area = 'Snow', live = false},
    {name = 'Yeti', rarity = 'Secret', area = 'Snow', live = false},
    {name = 'Ice Dragon', rarity = 'Eternal', area = 'Snow', live = false},
    {name = 'Lava Gecko', rarity = 'Rare', area = 'Volcano', live = false},
    {name = 'Lava Frog', rarity = 'Epic', area = 'Volcano', live = false},
    {name = 'Flaming Bull', rarity = 'Legendary', area = 'Volcano', live = false},
    {name = 'Lava Iguana', rarity = 'Legendary', area = 'Volcano', live = false},
    {name = 'Chillin Chilli', rarity = 'Mythic', area = 'Volcano', live = false},
    {name = 'Cerberus', rarity = 'Secret', area = 'Volcano', live = false},
    {name = 'Phoenix', rarity = 'Eternal', area = 'Volcano', live = false},
    {name = 'Lava Dragon', rarity = 'Eternal', area = 'Volcano', live = false},
    {name = 'Parrotfish', rarity = 'Rare', area = 'Abyss Ocean', live = false},
    {name = 'Swordfish', rarity = 'Epic', area = 'Abyss Ocean', live = false},
    {name = 'Shark', rarity = 'Legendary', area = 'Abyss Ocean', live = false},
    {name = 'Orca', rarity = 'Mythic', area = 'Abyss Ocean', live = false},
    {name = 'Whale Shark', rarity = 'Cosmic', area = 'Abyss Ocean', live = false},
    {name = 'Beluga Whale', rarity = 'Cosmic', area = 'Abyss Ocean', live = false},
    {name = 'Kraken', rarity = 'Secret', area = 'Abyss Ocean', live = false},
    {name = 'El Maja', rarity = 'Eternal', area = 'Abyss Ocean', live = false},
    {name = 'Dodo', rarity = 'Rare', area = 'Prehistoric', live = false},
    {name = 'Pterodactyl', rarity = 'Legendary', area = 'Prehistoric', live = false},
    {name = 'Ankylosaurus', rarity = 'Mythic', area = 'Prehistoric', live = false},
    {name = 'Bronto', rarity = 'Cosmic', area = 'Prehistoric', live = false},
    {name = 'Triceratops', rarity = 'Cosmic', area = 'Prehistoric', live = false},
    {name = 'T-Rex', rarity = 'Secret', area = 'Prehistoric', live = false},
    {name = 'Tralaledon', rarity = 'Secret', area = 'Prehistoric', live = false},
    {name = 'Mosasaurus', rarity = 'Eternal', area = 'Prehistoric', live = false},
    {name = 'Centapede', rarity = 'Epic', area = 'Cosmic', live = false},
    {name = 'Cosmic Gecko', rarity = 'Legendary', area = 'Cosmic', live = false},
    {name = 'Cosmic Gorilla', rarity = 'Mythic', area = 'Cosmic', live = false},
    {name = 'La Vacca Saturno Saturnita', rarity = 'Cosmic', area = 'Cosmic', live = false},
    {name = 'Cosmic Dragon', rarity = 'Secret', area = 'Cosmic', live = false},
    {name = 'Cosmic Skeleton Boss', rarity = 'Secret', area = 'Cosmic', live = false},
    {name = 'Eternal Lunar Dragon', rarity = 'Eternal', area = 'Cosmic', live = false},
    {name = 'Unicorn', rarity = 'Divine', area = 'Cosmic', live = false},
    {name = 'Crane', rarity = 'Epic', area = 'Cherry Blossom', live = false},
    {name = 'Salamander', rarity = 'Legendary', area = 'Cherry Blossom', live = false},
    {name = 'Red Panda', rarity = 'Mythic', area = 'Cherry Blossom', live = false},
    {name = 'Snowy Owl', rarity = 'Cosmic', area = 'Cherry Blossom', live = false},
    {name = 'Koi', rarity = 'Cosmic', area = 'Cherry Blossom', live = false},
    {name = 'Stag', rarity = 'Secret', area = 'Cherry Blossom', live = false},
    {name = 'Oni Tiger', rarity = 'Eternal', area = 'Cherry Blossom', live = false},
    {name = 'Kitsune', rarity = 'Divine', area = 'Cherry Blossom', live = false},
    {name = 'Spideron', rarity = 'Legendary', area = 'Titan Temple', live = false},
    {name = 'Crustacia', rarity = 'Legendary', area = 'Titan Temple', live = false},
    {name = 'Bladehide', rarity = 'Mythic', area = 'Titan Temple', live = false},
    {name = 'Mantaris', rarity = 'Cosmic', area = 'Titan Temple', live = false},
    {name = 'Rhinotaur', rarity = 'Cosmic', area = 'Titan Temple', live = false},
    {name = 'Gorilla King', rarity = 'Eternal', area = 'Titan Temple', live = false},
    {name = 'Nightflame', rarity = 'Divine', area = 'Titan Temple', live = false},
    {name = 'Flame Sprite', rarity = 'Legendary', area = 'Angels & Demons', live = false},
    {name = 'Light Dove', rarity = 'Legendary', area = 'Angels & Demons', live = false},
    {name = 'Winged Lamb', rarity = 'Mythic', area = 'Angels & Demons', live = false},
    {name = 'Toro', rarity = 'Mythic', area = 'Angels & Demons', live = false},
    {name = 'Imp', rarity = 'Cosmic', area = 'Angels & Demons', live = false},
    {name = 'Sacred Moth', rarity = 'Cosmic', area = 'Angels & Demons', live = false},
    {name = 'Holy Peacock', rarity = 'Cosmic', area = 'Angels & Demons', live = false},
    {name = 'Demon Hound', rarity = 'Cosmic', area = 'Angels & Demons', live = false},
    {name = 'Gargoyle', rarity = 'Secret', area = 'Angels & Demons', live = false},
    {name = 'Pure Jellyfish', rarity = 'Secret', area = 'Angels & Demons', live = false},
    {name = 'Centaur', rarity = 'Secret', area = 'Angels & Demons', live = false},
    {name = 'RazorFang', rarity = 'Secret', area = 'Angels & Demons', live = false},
    {name = 'Pegasus', rarity = 'Eternal', area = 'Angels & Demons', live = false},
    {name = 'Skeleton Horse', rarity = 'Eternal', area = 'Angels & Demons', live = false},
    {name = 'Equinox', rarity = 'Eternal', area = 'Angels & Demons', live = false},
    {name = 'ArchAngel', rarity = 'Divine', area = 'Angels & Demons', live = false},
    {name = 'World Burner', rarity = 'Divine', area = 'Angels & Demons', live = false},
    {name = 'Aetheron', rarity = 'Divine', area = 'Angels & Demons', live = false},
    {name = 'Prism Gecko', rarity = 'Legendary', area = 'Enchanted Forest', live = false},
    {name = 'Petal Beetle', rarity = 'Legendary', area = 'Enchanted Forest', live = false},
    {name = 'Enchanted Bluejay', rarity = 'Mythic', area = 'Enchanted Forest', live = false},
    {name = 'Astral Jackalope', rarity = 'Cosmic', area = 'Enchanted Forest', live = false},
    {name = 'Spirit Panda', rarity = 'Secret', area = 'Enchanted Forest', live = false},
    {name = 'Spirit World Guardian', rarity = 'Divine', area = 'Enchanted Forest', live = false},
    {name = 'Mimic Chest', rarity = 'Common', area = 'Halloween Dimension', live = false},
    {name = 'Whiskers', rarity = 'Common', area = 'Halloween Dimension', live = false},
    {name = 'Hooded Gerbil', rarity = 'Common', area = 'Halloween Dimension', live = false},
    {name = 'Crowshade', rarity = 'Epic', area = 'Halloween Dimension', live = false},
    {name = 'Jesterpop', rarity = 'Epic', area = 'Halloween Dimension', live = false},
    {name = 'Toadstool', rarity = 'Epic', area = 'Halloween Dimension', live = false},
    {name = 'Candlefang', rarity = 'Legendary', area = 'Halloween Dimension', live = false},
    {name = 'Patchwork Imp', rarity = 'Legendary', area = 'Halloween Dimension', live = false},
    {name = 'Hexed Pumpkin', rarity = 'Legendary', area = 'Halloween Dimension', live = false},
    {name = 'Haunted Scorpio', rarity = 'Mythic', area = 'Halloween Dimension', live = false},
    {name = 'Spirit Knight', rarity = 'Mythic', area = 'Halloween Dimension', live = false},
    {name = 'BloodBloom', rarity = 'Secret', area = 'Halloween Dimension', live = false},
    {name = 'Graveyard Brute', rarity = 'Secret', area = 'Halloween Dimension', live = false},
    {name = 'Werewolf', rarity = 'Secret', area = 'Halloween Dimension', live = false},
    {name = 'Gorillastein', rarity = 'Secret', area = 'Halloween Dimension', live = false},
    {name = 'Shelltide Voyager', rarity = 'Secret', area = 'Halloween Dimension', live = false},
    {name = 'Ghost Reaper', rarity = 'Secret', area = 'Halloween Dimension', live = false},
    {name = 'Voidseer Pumpkin', rarity = 'Divine', area = 'Halloween Dimension', live = false},
    {name = 'Nuclear Mantis', rarity = 'Secret', area = 'Biohazard', live = false},
    {name = 'Nuceodile', rarity = 'Eternal', area = 'Biohazard', live = false},
    {name = 'Toucax', rarity = 'Legendary', area = 'Biohazard', live = false},
    {name = 'Radcoon', rarity = 'Mythic', area = 'Biohazard', live = false},
    {name = 'Toxic Rat', rarity = 'Rare', area = 'Biohazard', live = false},
    {name = 'Strawberry Elephant', rarity = 'Special', area = 'Brainrot Egg', live = false},
    {name = 'Bomboclat Crocolat', rarity = 'Special', area = 'Brainrot Egg', live = false},
    {name = 'Mangolini Parrochini', rarity = 'Special', area = 'Brainrot Egg', live = false},
    {name = 'Belula Beluga', rarity = 'Special', area = 'Brainrot Egg', live = false},
    {name = 'Bananita Dolphinita', rarity = 'Special', area = 'Brainrot Egg', live = false},
    {name = 'Tung Tung Sahur', rarity = 'Special', area = 'Brainrot Egg', live = false},
    {name = 'Scorpio', rarity = 'Special', area = 'Monster Egg', live = false},
    {name = 'Froggo', rarity = 'Special', area = 'Monster Egg', live = false},
    {name = 'Crawler', rarity = 'Special', area = 'Monster Egg', live = false},
    {name = 'Crocodon', rarity = 'Special', area = 'Monster Egg', live = false},
    {name = 'Krakenoid', rarity = 'Special', area = 'Monster Egg', live = false},
    {name = 'Dreadscale', rarity = 'Special', area = 'Monster Egg', live = false},
    {name = 'Mecha Scorpio', rarity = 'Special', area = 'Mecha Egg', live = false},
    {name = 'Mecha Froggo', rarity = 'Special', area = 'Mecha Egg', live = false},
    {name = 'Mecha Crawler', rarity = 'Special', area = 'Mecha Egg', live = false},
    {name = 'Mecha Crocodon', rarity = 'Special', area = 'Mecha Egg', live = false},
    {name = 'Mecha Krakenoid', rarity = 'Special', area = 'Mecha Egg', live = false},
    {name = 'Mecha Dreadscale', rarity = 'Special', area = 'Mecha Egg', live = false},
    {name = 'Spike', rarity = 'Legendary', area = 'Luminous Egg', live = false},
    {name = 'Spirit Manta', rarity = 'Mythic', area = 'Luminous Egg', live = false},
    {name = 'Abyss Shark', rarity = 'Cosmic', area = 'Luminous Egg', live = false},
    {name = 'Electric Eel', rarity = 'Secret', area = 'Luminous Egg', live = false},
    {name = 'Terra Snapper', rarity = 'Eternal', area = 'Luminous Egg', live = false},
    {name = 'Cthulhu', rarity = 'Divine', area = 'Luminous Egg', live = false},
}

local RARITIES = {"All","Common","Uncommon","Rare","Epic","Legendary","Mythic","Cosmic","Secret","Eternal","Divine","Special"}
local rarityIndex = 1
local query = ""

local gui = Instance.new("ScreenGui")
gui.Name = "EggCatalogFinder"
gui.ResetOnSpawn = false
local ok = pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not ok or not gui.Parent then gui.Parent = player:WaitForChild("PlayerGui") end

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(420, 520)
main.Position = UDim2.new(0.5, -210, 0.5, -260)
main.BackgroundColor3 = Color3.fromRGB(25,27,35)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0,10)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,-55,0,40)
title.Position = UDim2.fromOffset(12,4)
title.BackgroundTransparency = 1
title.Text = "Egg Catalog Finder • 100+"
title.TextColor3 = Color3.fromRGB(255,220,100)
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", main)
close.Size = UDim2.fromOffset(30,28)
close.Position = UDim2.new(1,-38,0,8)
close.Text = "X"
close.TextColor3 = Color3.new(1,1,1)
close.BackgroundColor3 = Color3.fromRGB(155,55,60)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local search = Instance.new("TextBox", main)
search.Size = UDim2.new(1,-24,0,34)
search.Position = UDim2.fromOffset(12,48)
search.PlaceholderText = "Name, rarity oder Gebiet suchen..."
search.Text = ""
search.ClearTextOnFocus = false
search.TextColor3 = Color3.new(1,1,1)
search.PlaceholderColor3 = Color3.fromRGB(165,165,175)
search.BackgroundColor3 = Color3.fromRGB(43,45,56)
search.Font = Enum.Font.Gotham
search.TextSize = 13

local filter = Instance.new("TextButton", main)
filter.Size = UDim2.new(1,-24,0,30)
filter.Position = UDim2.fromOffset(12,88)
filter.Text = "Seltenheit: All (klicken zum Wechseln)"
filter.TextColor3 = Color3.new(1,1,1)
filter.BackgroundColor3 = Color3.fromRGB(60,75,110)
filter.Font = Enum.Font.GothamBold
filter.TextSize = 12

local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(1,-24,0,26)
status.Position = UDim2.fromOffset(12,122)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(190,195,205)
status.Font = Enum.Font.Gotham
status.TextSize = 11
status.TextXAlignment = Enum.TextXAlignment.Left

local list = Instance.new("ScrollingFrame", main)
list.Size = UDim2.new(1,-24,1,-166)
list.Position = UDim2.fromOffset(12,154)
list.BackgroundColor3 = Color3.fromRGB(31,33,42)
list.BorderSizePixel = 0
list.ScrollBarThickness = 6
list.CanvasSize = UDim2.new(0,0,0,0)
local layout = Instance.new("UIListLayout", list)
layout.Padding = UDim.new(0,4)
layout.SortOrder = Enum.SortOrder.LayoutOrder
local pad = Instance.new("UIPadding", list)
pad.PaddingTop = UDim.new(0,6)
pad.PaddingLeft = UDim.new(0,6)
pad.PaddingRight = UDim.new(0,6)

local function render()
    for _, child in ipairs(list:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    local count = 0
    local needle = string.lower(query)
    local rarity = RARITIES[rarityIndex]
    for _, egg in ipairs(EGGS) do
        local haystack = string.lower(egg.name.." "..egg.rarity.." "..egg.area)
        local queryOK = needle == "" or string.find(haystack, needle, 1, true)
        local rarityOK = rarity == "All" or egg.rarity == rarity
        if queryOK and rarityOK then
            count += 1
            local row = Instance.new("Frame", list)
            row.Size = UDim2.new(1,-4,0,48)
            row.BackgroundColor3 = Color3.fromRGB(44,46,58)
            row.BorderSizePixel = 0
            row.LayoutOrder = count
            Instance.new("UICorner", row).CornerRadius = UDim.new(0,5)

            local name = Instance.new("TextLabel", row)
            name.Size = UDim2.new(1,-12,0,22)
            name.Position = UDim2.fromOffset(7,3)
            name.BackgroundTransparency = 1
            name.Text = egg.name.." Egg"
            name.TextColor3 = Color3.fromRGB(245,245,250)
            name.Font = Enum.Font.GothamBold
            name.TextSize = 12
            name.TextXAlignment = Enum.TextXAlignment.Left

            local details = Instance.new("TextLabel", row)
            details.Size = UDim2.new(1,-12,0,18)
            details.Position = UDim2.fromOffset(7,25)
            details.BackgroundTransparency = 1
            details.Text = egg.rarity.." • "..egg.area.." • Katalog, nicht live"
            details.TextColor3 = Color3.fromRGB(190,195,208)
            details.Font = Enum.Font.Gotham
            details.TextSize = 10
            details.TextXAlignment = Enum.TextXAlignment.Left
        end
    end
    status.Text = tostring(count).." Einträge angezeigt / "..tostring(#EGGS).." Katalogeinträge"
    list.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+12)
end

search:GetPropertyChangedSignal("Text"):Connect(function()
    query = search.Text
    render()
end)
filter.MouseButton1Click:Connect(function()
    rarityIndex += 1
    if rarityIndex > #RARITIES then rarityIndex = 1 end
    filter.Text = "Seltenheit: "..RARITIES[rarityIndex].." (klicken zum Wechseln)"
    render()
end)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    list.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+12)
end)

render()
print("[Egg Catalog Finder] Loaded "..#EGGS.." catalog rows.")
print("[Egg Catalog Finder] Catalog data does not include internal spawn IDs or live server IDs.")
