local players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local httpService = game:GetService("HttpService")
local tweenService = game:GetService("TweenService")
local teleportService = game:GetService("TeleportService")
local soundService = game:GetService("SoundService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local workspaceService = game:GetService("Workspace")
local coreGui = game:GetService("CoreGui")

repeat
    task.wait()
until game:IsLoaded()

local localPlayer = players.LocalPlayer
local touchEnabled = userInputService.TouchEnabled

local function f1()
    pcall(
        function()
            if writefile then
                writefile("175_AutoJoiner_Key.txt", "CeboOnTop")
            end
        end
    )
end

local function f2()
    local ok, result = pcall(
        function()
            if readfile and isfile and isfile("175_AutoJoiner_Key.txt") then
                return tostring(readfile("175_AutoJoiner_Key.txt")):gsub("%s+", "")
            end
        end
    )

    return ok and result == "CeboOnTop"
end

local v1 = f2()

local function f3()
    local ok2, result2 = pcall(
        function()
            if type(gethui) == "function" then
                return gethui()
            end
        end
    )

    if ok2 and result2 then
        return result2
    end

    local ok3, result3 = pcall(
        function()
            return coreGui
        end
    )

    if ok3 and result3 then
        return result3
    end

    return localPlayer:WaitForChild("PlayerGui")
end

local screenGui, instance, instance2, v2, f4

if not v1 then
    local parent = f3()
    local findFirstChild = parent:FindFirstChild("175_KeyPrompt")

    if findFirstChild then
        findFirstChild:Destroy()
    end

    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "175_KeyPrompt"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = parent

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local frame2 = Instance.new("Frame")
    frame2.AnchorPoint = Vector2.new(0.5, 0.5)
    frame2.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame2.Size = UDim2.new(0, 340, 0, 200)
    frame2.BackgroundColor3 = Color3.fromRGB(20, 5, 5)
    frame2.BorderSizePixel = 0
    frame2.Parent = frame

    Instance.new("UICorner", frame2).CornerRadius = UDim.new(0, 14)

    local instance3 = Instance.new("UIStroke", frame2)
    instance3.Color = Color3.fromRGB(255, 80, 80)
    instance3.Thickness = 1.5
    instance3.Transparency = 0.2

    local instance4 = Instance.new("TextLabel", frame2)
    instance4.Size = UDim2.new(1, -30, 0, 28)
    instance4.Position = UDim2.new(0, 15, 0, 18)
    instance4.BackgroundTransparency = 1
    instance4.Text = "Noahs Hub | SAE"
    instance4.TextColor3 = Color3.fromRGB(255, 220, 220)
    instance4.TextSize = 18
    instance4.Font = Enum.Font.GothamBlack
    instance4.TextXAlignment = Enum.TextXAlignment.Left

    local instance5 = Instance.new("TextLabel", frame2)
    instance5.Size = UDim2.new(1, -30, 0, 18)
    instance5.Position = UDim2.new(0, 15, 0, 48)
    instance5.BackgroundTransparency = 1
    instance5.Text = "Enter your key to continue"
    instance5.TextColor3 = Color3.fromRGB(200, 100, 100)
    instance5.TextSize = 12
    instance5.Font = Enum.Font.Gotham
    instance5.TextXAlignment = Enum.TextXAlignment.Left

    instance = Instance.new("TextBox", frame2)
    instance.Size = UDim2.new(1, -30, 0, 36)
    instance.Position = UDim2.new(0, 15, 0, 80)
    instance.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
    instance.Text = ""
    instance.PlaceholderText = "Key..."
    instance.TextColor3 = Color3.fromRGB(255, 220, 220)
    instance.PlaceholderColor3 = Color3.fromRGB(150, 60, 60)
    instance.TextSize = 14
    instance.Font = Enum.Font.GothamBold
    instance.ClearTextOnFocus = false

    Instance.new("UICorner", instance).CornerRadius = UDim.new(0, 8)

    instance2 = Instance.new("TextLabel", frame2)
    instance2.Size = UDim2.new(1, -30, 0, 16)
    instance2.Position = UDim2.new(0, 15, 0, 122)
    instance2.BackgroundTransparency = 1
    instance2.Text = ""
    instance2.TextColor3 = Color3.fromRGB(255, 80, 80)
    instance2.TextSize = 11
    instance2.Font = Enum.Font.Gotham
    instance2.TextXAlignment = Enum.TextXAlignment.Left

    local instance6 = Instance.new("TextButton", frame2)
    instance6.Size = UDim2.new(1, -30, 0, 36)
    instance6.Position = UDim2.new(0, 15, 0, 148)
    instance6.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    instance6.Text = "Unlock"
    instance6.TextColor3 = Color3.fromRGB(255, 255, 255)
    instance6.TextSize = 14
    instance6.Font = Enum.Font.GothamBold
    instance6.AutoButtonColor = false

    Instance.new("UICorner", instance6).CornerRadius = UDim.new(0, 8)
    v2 = false

    function f4()
        if tostring(instance.Text):gsub("%s+", "") == "CeboOnTop" then
            instance2.TextColor3 = Color3.fromRGB(80, 255, 120)
            instance2.Text = "Key accepted!"

            f1()
            v2 = true
            task.wait(0.35)
            screenGui:Destroy()
        else
            instance2.TextColor3 = Color3.fromRGB(255, 80, 80)
            instance2.Text = "Invalid key"
            instance.Text = ""
        end
    end

    instance6.MouseButton1Click:Connect(f4)

    instance.FocusLost:Connect(
        function(p1)
            if p1 then
                f4()
            end
        end
    )

    repeat
        task.wait(0.1)
    until v2
end

local v3 = {}

local v4 = {hub = false, TTL = 120, BEAT = 30, srvFirst = true,}

local v5 = {
    autoJoin = false, autoForce = false, forceTime = 10, threshold = "1B",
    logSoundId = "125621644257669", logSoundEnabled = true, logNotify = true, antiGuard = false,
    autoSteal = false,
}

local function f5()
    if not writefile then
        return
    end

    pcall(
        function()
            writefile("175_AutoJoiner_Config.json", httpService:JSONEncode(v5))
        end
    )
end

local function f6()
    if not (readfile and isfile and isfile("175_AutoJoiner_Config.json")) then
        return
    end

    pcall(
        function()
            for key, value in pairs(
                (httpService:JSONDecode(readfile("175_AutoJoiner_Config.json")))
            ) do
                if v5[key] ~= nil then
                    v5[key] = value
                end
            end
        end
    )
end

f6()

local v6 = syn and syn.request or http and http.request or http_request or request

local function f7(p2)
    if type(p2) ~= "string" or p2 == "" then
        return nil
    end

    local ok, result = pcall(function()
        if v6 then
            local response = v6({
                Url = p2,
                Method = "GET",
                Headers = {["Content-Type"] = "application/json"},
            })
            if type(response) == "table" then
                local status = tonumber(response.StatusCode or response.status_code)
                if status and (status < 200 or status >= 300) then
                    return nil
                end
                return response.Body or response.body
            end
            return nil
        end

        return game:HttpGet(p2)
    end)

    if ok and type(result) == "string" and result ~= "" then
        return result
    end
    return nil
end

local function getBody(p3)
    local url = "https://newera-32edd-default-rtdb.firebaseio.com" .. p3
    local body

    pcall(
        function()
            if v6 then
                local v8 = v6(
                    {Url = url, Method = "GET", Headers = {["Content-Type"] = "application/json"},}
                )

                body = v8 and v8.Body
            else
                body = game:HttpGet(url)
            end
        end
    )

    return body
end

local function f8(url2, p4)
    if not v6 then
        return nil
    end

    local ok4, result4 = pcall(
        function()
            return v6(
                {
                    Url = url2, Method = "POST", Headers = {["Content-Type"] = "application/json"},
                    Body = httpService:JSONEncode(p4),
                }
            )
        end
    )

    if ok4 and type(result4) == "table" then
        return tonumber(result4.StatusCode), result4.Body or result4.body
    end

    return nil
end

local function f9()
    local httpsPrivatedontleakorelsejejjkeo3333LovableAppApiGetPets = f7(
        "https://privatedontleakorelsejejjkeo3333.lovable.app/api/getPets"
    )

    if not httpsPrivatedontleakorelsejejjkeo3333LovableAppApiGetPets or httpsPrivatedontleakorelsejejjkeo3333LovableAppApiGetPets == "" then
        return {}
    end

    local ok5, result5 = pcall(
        function()
            return httpService:JSONDecode(httpsPrivatedontleakorelsejejjkeo3333LovableAppApiGetPets)
        end
    )

    if not ok5 or type(result5) ~= "table" then
        return {}
    end

    local list = {}

    for _, value2 in ipairs(result5) do
        if type(value2) == "table" and value2.petName and value2.jobId and tonumber(value2.value) then
            local mps = tonumber(value2.value) or 0
            local v9 = tonumber(value2.timestamp)

            local v10 = v9
            v10 = v9 or os.time() * 1000

            local d = value2.iconId and tostring(value2.iconId):match("%d+") or nil

            list[#list + 1] = {
                name = tostring(value2.petName), mps = mps, jobId = tostring(value2.jobId),
                placeId = tostring(value2.placeId or game.PlaceId),
                icon = d and "rbxassetid://" .. d or "", iconId = d,
                eggUid = "hub_" .. tostring(value2.jobId) .. "_" .. tostring(value2.petName),
                lastSeen = math.floor(v10 / 1000), spawnedAt = math.floor(v10 / 1000),
                silent = mps < 50000000,
            }
        end
    end

    return list
end

local function f10(p5)
    if not v4.hub then
        return
    end

    if type(p5) ~= "table" then
        return
    end

    local v11 = tonumber(p5.mps or p5.value) or 0

    if v11 < 50000000 then
        return
    end

    local v12 = tostring(p5.name or p5.petName or "")
    local v13 = tostring(p5.jobId or game.JobId or "")

    if v12 == "" or v13 == "" then
        return
    end

    local v14 = v13 .. "|" .. v12 .. "|" .. tostring(math.floor(v11))
    local v15 = v3[v14]

    if v15 and os.clock() - v15 < 120 then
        return
    end

    v3[v14] = os.clock()
    local text = tostring(p5.icon or p5.iconId or "")
    local d2 = text:match("(%d+)") or text

    task.spawn(
        function()
            f8(
                "https://privatedontleakorelsejejjkeo3333.lovable.app/api/addPet",
                {petName = v12, value = v11, jobId = v13, iconId = d2, timestamp = os.time() * 1000,}
            )
        end
    )
end

local function f11(p6)
    if not p6 then
        return
    end

    pcall(
        f10,
        {
            name = tostring(p6.name or "Unknown"), mps = tonumber(p6.mps) or 0,
            jobId = tostring(p6.jobId or game.JobId or ""),
            placeId = tostring(p6.placeId or game.PlaceId or ""), icon = tostring(p6.icon or ""),
        }
    )
end

v4.TTL = 120
v4.BEAT = 30
v4.runId = tostring(os.clock()) .. tostring(math.random(1, 1000000000))

_G.__AJ_RUN = v4.runId

v4.last = {ok = nil, code = nil, msg = "", at = 0, players = 0, money = 0,}

function v4.httpPutRes(p7, p8)
    if not v6 then
        return nil, "sin request()"
    end

    local ok6, result6 = pcall(
        function()
            return v6(
                {
                    Url = "https://newera-32edd-default-rtdb.firebaseio.com" .. p7, Method = "PUT",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = httpService:JSONEncode(p8),
                }
            )
        end
    )

    if ok6 and type(result6) == "table" then
        return
            tonumber(result6.StatusCode or result6.status_code),
            tostring(result6.Body or result6.body or "")
    end

    return nil, tostring(result6)
end

function v4.httpDelete(p9)
    if not v6 then
        return
    end

    pcall(
        function()
            v6({Url = "https://newera-32edd-default-rtdb.firebaseio.com" .. p9, Method = "DELETE"})
        end
    )
end

v4.MONEY_KEYS = {"cash", "money", "coins", "dinero"}
v4.moneyDiag = false

function v4.readPlayerMoney(instance7)
    local v16 = 0
    local flag = false

    pcall(
        function()
            local leaderstats = instance7:FindFirstChild("leaderstats")

            if leaderstats then
                for _, value3 in ipairs(leaderstats:GetChildren()) do
                    if value3:IsA("NumberValue") or value3:IsA("IntValue") then
                        local lower = string.lower(value3.Name)

                        for _, value4 in ipairs(v4.MONEY_KEYS) do
                            if string.find(lower, value4, 1, true) then
                                v16 = tonumber(value3.Value) or 0
                                flag = true
                                return
                            end
                        end
                    end
                end
            end

            for _, value5 in ipairs({"Cash", "Money", "Coins"}) do
                local getAttribute = instance7:GetAttribute(value5)

                if type(getAttribute) == "number" then
                    v16 = getAttribute
                    flag = true
                    return
                end
            end
        end
    )

    return v16, flag
end

function v4.getServerMoney()
    local v17 = 0
    local v18 = false

    for _, value6 in ipairs(players:GetPlayers()) do
        local v19, v20 = v4.readPlayerMoney(value6)
        v17 = v17 + v19
        v18 = v18 or v20
    end

    if not v18 and not v4.moneyDiag then
        v4.moneyDiag = true

        pcall(
            function()
                local localPlayer2 = players.LocalPlayer
                local leaderstats2 = localPlayer2
                local list2 = {}

                if localPlayer2 then
                    leaderstats2 = localPlayer2:FindFirstChild("leaderstats")
                end

                local instance8 = leaderstats2

                if instance8 then
                    for _, value7 in ipairs(instance8:GetChildren()) do
                        list2[#list2 + 1] = value7.Name .. "(" .. value7.ClassName .. ")"
                    end
                end

                warn(
                    "[AJ] No encontre el dinero. leaderstats: " .. (#list2 > 0 and table.concat(
                        list2, ", "
                    ) or "no existe")
                )
            end
        )
    end

    if v17 ~= v17 or v17 < 0 then
        v17 = 0
    end

    return math.min(v17, 1000000000000000000), v18
end

v4.reportedOnce = false

function v4.reportServerToFirebase()
    local v21 = tostring(game.JobId or "")

    if v21 == "" then
        return
    end

    local money = v4.getServerMoney()

    local v22 = {
        jobId = v21, placeId = tostring(game.PlaceId), players = #players:GetPlayers(),
        money = money, lastSeen = os.time(),
    }

    local v23, v24 = v4.httpPutRes("/servers/" .. v21 .. ".json", v22)

    v4.last = {
        ok = v23 == 200, code = v23, msg = tostring(v24 or ""), at = os.time(),
        players = v22.players, money = money,
    }

    if v23 == 200 then
        if not v4.reportedOnce then
            v4.reportedOnce = true
            print(
                ("[AJ] Firebase OK -> %d jugadores, dinero %s"):format(v22.players, tostring(money))
            )
        end
    else
        warn(
            "[AJ] Firebase NO acepto el reporte. code=" .. tostring(v23) .. " body=" .. tostring(
                v24
            )
        )
    end
end

function v4.cleanupStaleServers()
    local body2 = getBody(
        "/servers.json?orderBy=%22lastSeen%22&endAt=" .. tostring(os.time() - 700)
    )

    if not body2 or body2 == "null" or body2 == "" then
        return
    end

    local ok7, result7 = pcall(
        function()
            return httpService:JSONDecode(body2)
        end
    )

    if not ok7 or type(result7) ~= "table" or result7.error then
        return
    end

    local count = 0

    for key2 in pairs(result7) do
        count = count + 1

        if count > 10 then
            break
        end

        v4.httpDelete("/servers/" .. tostring(key2) .. ".json")
    end
end

local flag2 = false

local function f12()
    if flag2 then
        return
    end

    flag2 = true

    task.delay(
        3,
        function()
            flag2 = false

            if _G.__AJ_RUN == v4.runId then
                task.spawn(
                    function()
                        pcall(v4.reportServerToFirebase)
                    end
                )
            end
        end
    )
end

players.PlayerAdded:Connect(f12)
players.PlayerRemoving:Connect(f12)

task.spawn(
    function()
        task.wait(2)
        local count2 = 0

        while _G.__AJ_RUN == v4.runId do
            pcall(v4.reportServerToFirebase)
            count2 = count2 + 1

            if count2 % 10 == 0 then
                pcall(v4.cleanupStaleServers)
            end

            task.wait(v4.BEAT)
        end
    end
)

function v4.decodeServers(p10, p11, p12)
    local list3 = {}

    if not p10 or p10 == "" or p10 == "null" then
        return list3
    end

    local ok8, result8 = pcall(
        function()
            return httpService:JSONDecode(p10)
        end
    )

    if not ok8 or type(result8) ~= "table" or result8.error then
        return list3
    end

    local now = os.time()
    local v25 = tostring(game.JobId)

    for key3, value8 in pairs(result8) do
        if type(value8) == "table" then
            local v26 = tostring(value8.jobId or key3)
            local v27 = tonumber(value8.lastSeen) or 0
            local v28 = tonumber(value8.players) or 0
            local v29 = tonumber(value8.money) or 0

            if v26 ~= "" and now - v27 <= p11 and v28 > 0 and v28 <= 60 and v29 >= 0 then
                local own = v26 == v25

                if p12 or not own then
                    list3[#list3 + 1] = {
                        eggUid = "srv_" .. v26, name = "Server " .. string.sub(v26, 1, 6),
                        kind = "server", mps = v29, money = v29, jobId = v26,
                        placeId = tostring(value8.placeId or game.PlaceId), players = v28,
                        lastSeen = v27, time = v27, own = own, icon = "",
                    }
                end
            end
        end
    end

    return list3
end

function v4.fetchServersFromFirebase()
    local v30 = v4.decodeServers(getBody("/servers.json"), 600, true)

    table.sort(
        v30,
        function(p13, p14)
            return (tonumber(p13.money) or 0) > (tonumber(p14.money) or 0)
        end
    )

    return v30
end

local function f13(mps2)
    local v31 = tonumber(mps2) or 0

    if v31 >= 1000000000000000 then
        return ("$%.1fQ/s"):format(v31 / 1000000000000000):gsub("%.0", "")
    elseif v31 >= 1000000000000 then
        return ("$%.1fT/s"):format(v31 / 1000000000000):gsub("%.0", "")
    elseif v31 >= 1000000000 then
        return ("$%.1fB/s"):format(v31 / 1000000000):gsub("%.0", "")
    elseif v31 >= 1000000 then
        return ("$%.1fM/s"):format(v31 / 1000000):gsub("%.0", "")
    end

    if v31 >= 1000 then
        return ("$%.1fK/s"):format(v31 / 1000):gsub("%.0", "")
    end

    return "$" .. math.floor(v31) .. "/s"
end

function v4.fmtMoney(p15)
    local v32 = tonumber(p15) or 0

    for _, value9 in ipairs(
        {{1000000000000000, "Qa"}, {1000000000000, "T"}, {1000000000, "B"}, {1000000, "M"}, {
            1000, "K"
        },}
    ) do
        if v32 >= value9[1] then
            return "$" .. string.format("%.2f", v32 / value9[1]):gsub("%.?0+$", "") .. value9[2]
        end
    end

    return "$" .. tostring(math.floor(v32))
end

function v4.entryGenText(p16)
    if p16 and p16.kind == "server" then
        return v4.fmtMoney(p16.money or p16.mps)
    end

    return f13(p16 and p16.mps)
end

function v4.entrySubParts(p17)
    if p17 and p17.kind == "server" then
        return {
            tostring(p17.players or "?") .. "/" .. tostring(p17.maxPlayers or "?") .. " players",
        }
    end

    return {tostring(p17 and p17.players or "?") .. "/" .. tostring(p17 and p17.maxPlayers or "?"),}
end

local function getFormat(spawnedAt)
    local highest = math.max(0, os.time() - (tonumber(spawnedAt) or os.time()))
    return ("%d:%02d"):format(math.floor(highest / 60), highest % 60)
end

local function f14(mps3)
    return true
end

local list4 = {
    "ceboscripts", "cebo scripts", "cebo_scripts", "ceboscript", "cebofinder", "cebo finder",
    "raid", "spam", "test egg", "null", "undefined", "unknown",
}

local function f15(p18)
    if type(p18) ~= "table" then
        return true
    end

    local gsub = tostring(p18.name or p18.eggName or ""):lower():gsub("%s+", " "):gsub("^%s+", ""):gsub(
        "%s+$", ""
    )

    if gsub == "" then
        return true
    end

    for _, value10 in ipairs(list4) do
        if gsub == value10 or gsub:find(value10, 1, true) then
            return true
        end
    end

    if (tonumber(p18.mps or p18.value) or 0) < 0 then
        return true
    end

    return false
end

local function getColor(mps4)
    local v33 = tonumber(mps4) or 0

    if v33 >= 1000000000 then
        return Color3.fromRGB(255, 220, 220)
    end

    if v33 >= 100000000 then
        return Color3.fromRGB(255, 120, 120)
    end

    return Color3.fromRGB(180, 60, 60)
end

local function makeSound(logSoundId, volume)
    task.spawn(
        function()
            pcall(
                function()
                    local sound = Instance.new("Sound")
                    sound.SoundId = "rbxassetid://" .. tostring(logSoundId)
                    sound.Volume = volume or 0.3
                    sound.Parent = soundService
                    sound:Play()
                    sound.Ended:Wait()
                    sound:Destroy()
                end
            )
        end
    )
end

local color = Color3.fromRGB(255, 220, 220)
local color2 = Color3.fromRGB(200, 80, 80)
local color3 = Color3.fromRGB(120, 30, 30)
local color4 = Color3.fromRGB(25, 5, 5)
local color5 = Color3.fromRGB(50, 12, 12)
local color6 = Color3.fromRGB(40, 8, 8)
local color7 = Color3.fromRGB(45, 10, 10)
local color8 = Color3.fromRGB(180, 30, 30)
local gothamBlack = Enum.Font.GothamBlack
local gothamBold = Enum.Font.GothamBold
local gothamMedium = Enum.Font.GothamMedium
local gotham = Enum.Font.Gotham

local function getColorSequence(color9, color10)
    return ColorSequence.new(
        {
            ColorSequenceKeypoint.new(0, color9), ColorSequenceKeypoint.new(0.25, color10),
            ColorSequenceKeypoint.new(0.5, color9), ColorSequenceKeypoint.new(0.75, color10),
            ColorSequenceKeypoint.new(1, color9),
        }
    )
end

local list5 = {}

local function makeCorner(parent2, p19)
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, p19)
    uiCorner.Parent = parent2

    return uiCorner
end

local function f16(instance9, p20, p21, p22, out)
    if not instance9 or not instance9.Parent then
        return
    end

    pcall(
        function()
            tweenService:Create(
                instance9,
                TweenInfo.new(
                    p21 or 0.35, p22 or Enum.EasingStyle.Quint, out or Enum.EasingDirection.Out
                ), p20
            ):Play()
        end
    )
end

local function getUiStroke(parent3, thickness, p23)
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Thickness = thickness or 1
    uiStroke.Color = color
    uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    uiStroke.Parent = parent3

    local uiGradient = Instance.new("UIGradient")
    uiGradient.Rotation = 45
    uiGradient.Color = getColorSequence(p23 and color or color2, color3)
    uiGradient.Parent = uiStroke

    table.insert(list5, uiGradient)
    return uiStroke, uiGradient
end

local function getInstance(p24, instance10)
    local instance11 = Instance.new(p24)

    for key4, value11 in pairs(instance10 or {}) do
        if key4 ~= "Parent" then
            instance11[key4] = value11
        end
    end

    if instance10 and instance10.Parent then
        instance11.Parent = instance10.Parent
    end

    return instance11
end

local parent4 = f3()

for _, value12 in ipairs(
    {"175_AutoJoiner_UI", "175_KeyPrompt", "CeboFinder_UI", "CeboFinder", "CeboEggFinder",}
) do
    local findFirstChild2 = parent4:FindFirstChild(value12)

    if findFirstChild2 then
        findFirstChild2:Destroy()
    end
end

local scale = touchEnabled and 0.85 or 1

local instance12 = getInstance(
    "ScreenGui",
    {
        Name = "175_AutoJoiner_UI", ResetOnSpawn = false, IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = parent4,
    }
)

local instance13 = getInstance(
    "Frame",
    {
        Name = "Main", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = touchEnabled and UDim2.new(0, 420, 0, 280) or UDim2.new(0, 520, 0, 340),
        BackgroundColor3 = color4, BackgroundTransparency = 0.55, BorderSizePixel = 0,
        ClipsDescendants = true, ZIndex = 1, Parent = instance12,
    }
)

makeCorner(instance13, 12)
local instance14 = getInstance("UIScale", {Scale = scale, Parent = instance13})
getUiStroke(instance13, 1.5, true)

getInstance(
    "ImageLabel",
    {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        Image = "rbxassetid://105742354838493", ImageColor3 = Color3.fromRGB(255, 180, 180),
        ImageTransparency = 0.08, ScaleType = Enum.ScaleType.Crop, ZIndex = 0, Parent = instance13,
    }
)

getInstance(
    "ImageLabel",
    {
        Size = UDim2.new(1.5, 0, 1.5, 0), Position = UDim2.new(-0.25, 0, -0.25, 0),
        BackgroundTransparency = 1, Image = "rbxassetid://105742354838493",
        ImageColor3 = Color3.fromRGB(255, 100, 100), ImageTransparency = 0.45,
        ScaleType = Enum.ScaleType.Fit, ZIndex = 1, Parent = instance13,
    }
)

getInstance(
    "ImageLabel",
    {
        Size = UDim2.new(1.2, 0, 1.2, 0), Position = UDim2.new(0.1, 0, 0.1, 0),
        BackgroundTransparency = 1, Image = "rbxassetid://105742354838493",
        ImageColor3 = Color3.fromRGB(200, 40, 40), ImageTransparency = 0.55,
        ScaleType = Enum.ScaleType.Fit, ZIndex = 1, Parent = instance13,
    }
)

local v34 = touchEnabled and 100 or 130

local parent5 = getInstance(
    "Frame",
    {
        Size = UDim2.new(0, v34, 1, 0), BackgroundColor3 = color4, BackgroundTransparency = 0.35,
        BorderSizePixel = 0, ZIndex = 2, Parent = instance13,
    }
)

makeCorner(parent5, 12)

getInstance(
    "Frame",
    {
        Size = UDim2.new(0, 1, 0.9, 0), AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0), BackgroundColor3 = color, BackgroundTransparency = 0.7,
        BorderSizePixel = 0, ZIndex = 3, Parent = parent5,
    }
)

local parent6 = getInstance(
    "Frame",
    {
        Size = UDim2.new(1, -(v34 + 4), 1, 0), Position = UDim2.new(0, v34 + 4, 0, 0),
        BackgroundTransparency = 1, ZIndex = 2, Parent = instance13,
    }
)

local parent7 = getInstance(
    "Frame",
    {Size = UDim2.new(1, 0, 0, 60), BackgroundTransparency = 1, ZIndex = 3, Parent = parent5,}
)

local parent8 = getInstance(
    "TextLabel",
    {
        Size = UDim2.new(1, -20, 0, 22), Position = UDim2.new(0, 14, 0, 10),
        BackgroundTransparency = 1, Text = "Noahs Hub | SAE", TextColor3 = color, TextSize = 14,
        Font = gothamBlack, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = parent7,
    }
)

local uiGradient2 = Instance.new("UIGradient")
uiGradient2.Color = getColorSequence(color, color2)
uiGradient2.Parent = parent8

table.insert(list5, uiGradient2)

local instance15 = getInstance(
    "Frame",
    {
        Size = UDim2.new(0, 6, 0, 6), Position = UDim2.new(0, 16, 0, 44), BackgroundColor3 = color3,
        BorderSizePixel = 0, ZIndex = 4, Parent = parent7,
    }
)

makeCorner(instance15, 1)

local instance16 = getInstance(
    "TextLabel",
    {
        Size = UDim2.new(1, -30, 0, 16), Position = UDim2.new(0, 28, 0, 39),
        BackgroundTransparency = 1, Text = "Offline", TextColor3 = color3, TextSize = 11,
        Font = gotham, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = parent7,
    }
)

local function f17(text2, text3)
    local v35 = text2 and color or color3

    f16(instance15, {BackgroundColor3 = v35})
    f16(instance16, {TextColor3 = v35})

    instance16.Text = text3 or text2 and "Connected" or "Offline"
end

local parent9 = getInstance(
    "Frame",
    {
        Size = UDim2.new(1, 0, 1, -120), Position = UDim2.new(0, 0, 0, 70),
        BackgroundTransparency = 1, ZIndex = 3, Parent = parent5,
    }
)

getInstance(
    "UIListLayout",
    {
        Padding = UDim.new(0, 4), HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder, Parent = parent9,
    }
)

local instance17 = getInstance(
    "Frame",
    {
        Size = UDim2.new(1, -16, 0, 36), Position = UDim2.new(0, 8, 0, 70),
        BackgroundColor3 = color, BackgroundTransparency = 0.8, BorderSizePixel = 0, ZIndex = 2,
        Parent = parent5,
    }
)

makeCorner(instance17, 8)
getUiStroke(instance17, 1, true)
local map = {}
local v36 = {}
local list6 = {"Logs", "History", "Firebase", "Settings"}
local v37

local function f18(p25)
    if p25 == v37 then
        return
    end

    v37 = p25

    for key5, value13 in pairs(map) do
        local v38 = key5 == p25
        f16(value13, {TextColor3 = v38 and color or color2})
        value13.Font = v38 and gothamBold or gothamMedium

        if v36[key5] then
            v36[key5].Visible = v38

            if v38 then
                v36[key5].GroupTransparency = 1
                f16(v36[key5], {GroupTransparency = 0}, 0.3)
            end
        end
    end

    local v39 = 0

    for index, value14 in ipairs(list6) do
        if value14 == p25 then
            v39 = index - 1
            break
        end
    end

    f16(
        instance17, {Position = UDim2.new(0, 8, 0, 70 + v39 * 40), Size = UDim2.new(1, -16, 0, 36)},
        0.35
    )
end

for index2, value15 in ipairs(list6) do
    local instance18 = getInstance(
        "TextButton",
        {
            Size = UDim2.new(1, -20, 0, 36), BackgroundTransparency = 1, Text = value15,
            TextColor3 = color2, TextSize = 12, Font = gothamBold, AutoButtonColor = false,
            LayoutOrder = index2, ZIndex = 4, Parent = parent9,
        }
    )

    instance18.MouseEnter:Connect(
        function()
            if value15 ~= v37 then
                f16(instance18, {TextColor3 = color})
            end
        end
    )

    instance18.MouseLeave:Connect(
        function()
            if value15 ~= v37 then
                f16(instance18, {TextColor3 = color2})
            end
        end
    )

    instance18.MouseButton1Click:Connect(
        function()
            f18(value15)
        end
    )

    map[value15] = instance18
end

local instance19 = getInstance(
    "TextButton",
    {
        Size = UDim2.new(1, -24, 0, 34), Position = UDim2.new(0, 12, 1, -42),
        BackgroundColor3 = color5, BackgroundTransparency = 0.4, Text = "Hide", TextColor3 = color2,
        TextSize = 12, Font = gothamBold, AutoButtonColor = false, ZIndex = 4, Parent = parent5,
    }
)

makeCorner(instance19, 10)
getUiStroke(instance19, 1, false)

instance19.MouseEnter:Connect(
    function()
        f16(instance19, {BackgroundTransparency = 0.1, TextColor3 = color})
    end
)

instance19.MouseLeave:Connect(
    function()
        f16(instance19, {BackgroundTransparency = 0.4, TextColor3 = color2})
    end
)

local instance20 = getInstance(
    "Frame",
    {
        Size = UDim2.new(0, 56, 0, 56), AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 18, 0.58, 0), BackgroundColor3 = color4,
        BackgroundTransparency = 0.1, Visible = false, ClipsDescendants = true, ZIndex = 100,
        Parent = instance12,
    }
)

makeCorner(instance20, 28)
getUiStroke(instance20, 2, true)

local instance21 = getInstance(
    "TextButton",
    {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "175", TextColor3 = color,
        Font = gothamBlack, TextSize = 16, Parent = instance20,
    }
)

local uiGradient3 = Instance.new("UIGradient")
uiGradient3.Color = getColorSequence(color, color2)
uiGradient3.Parent = instance21

table.insert(list5, uiGradient3)

instance19.MouseButton1Click:Connect(
    function()
        f16(instance14, {Scale = 0}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)

        task.delay(
            0.4,
            function()
                instance13.Visible = false

                instance20.Visible = true
                instance20.Size = UDim2.new(0, 0, 0, 0)

                f16(instance20, {Size = UDim2.new(0, 56, 0, 56)}, 0.4, Enum.EasingStyle.Back)
            end
        )
    end
)

local inputBegan = instance21.InputBegan
local v40, v41, v42, v43

inputBegan:Connect(
    function(p26)
        if p26.UserInputType == Enum.UserInputType.MouseButton1 or p26.UserInputType == Enum.UserInputType.Touch then
            v40 = true
            v43 = false
            local position = p26.Position
            local position2 = instance20.Position
            v41 = position
            v42 = position2
        end
    end
)

userInputService.InputEnded:Connect(
    function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            v40 = false
        end
    end
)

userInputService.InputChanged:Connect(
    function(input2)
        if not v40 then
            return
        end

        if input2.UserInputType ~= Enum.UserInputType.MouseMovement and input2.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local v44 = input2.Position - v41

        if v44.Magnitude > 10 then
            v43 = true

            instance20.Position = UDim2.new(
                v42.X.Scale, v42.X.Offset + v44.X, v42.Y.Scale, v42.Y.Offset + v44.Y
            )
        end
    end
)

instance21.MouseButton1Click:Connect(
    function()
        if v43 then
            return
        end

        f16(
            instance20, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back,
            Enum.EasingDirection.In
        )

        task.delay(
            0.3,
            function()
                instance20.Visible = false
                instance13.Visible = true
                f16(
                    instance14, {Scale = scale}, 0.4, Enum.EasingStyle.Back,
                    Enum.EasingDirection.Out
                )
            end
        )
    end
)

local instance22 = getInstance(
    "TextButton",
    {
        Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Text = "", ZIndex = 10,
        Parent = instance13,
    }
)

local v45, v46, v47

instance22.InputBegan:Connect(
    function(input3)
        if input3.UserInputType == Enum.UserInputType.MouseButton1 or input3.UserInputType == Enum.UserInputType.Touch then
            local position3 = input3.Position
            local position4 = instance13.Position
            v45 = true
            v46 = position3
            v47 = position4
        end
    end
)

instance22.InputEnded:Connect(
    function(input4)
        if input4.UserInputType == Enum.UserInputType.MouseButton1 or input4.UserInputType == Enum.UserInputType.Touch then
            v45 = false
        end
    end
)

userInputService.InputChanged:Connect(
    function(input5)
        if not v45 then
            return
        end

        if input5.UserInputType ~= Enum.UserInputType.MouseMovement and input5.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local v48 = (input5.Position - v46) / instance14.Scale

        instance13.Position = UDim2.new(
            v47.X.Scale, v47.X.Offset + v48.X, v47.Y.Scale, v47.Y.Offset + v48.Y
        )
    end
)

local function f19(parent10, p27, text4, key6)
    local instance23 = getInstance(
        "Frame",
        {
            Size = UDim2.new(1, 0, 0, 48), Position = UDim2.new(0, 0, 0, p27),
            BackgroundColor3 = color6, BackgroundTransparency = 0.3, BorderSizePixel = 0,
            ZIndex = 3, Parent = parent10,
        }
    )

    makeCorner(instance23, 10)
    getUiStroke(instance23, 1, true)

    getInstance(
        "TextLabel",
        {
            Size = UDim2.new(1, -70, 1, 0), Position = UDim2.new(0, 14, 0, 0),
            BackgroundTransparency = 1, Text = text4, TextColor3 = color, TextSize = 12,
            Font = gothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4,
            Parent = instance23,
        }
    )

    local instance24 = getInstance(
        "TextButton",
        {
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0),
            Size = UDim2.new(0, 46, 0, 24), BackgroundColor3 = color7, BorderSizePixel = 0,
            Text = "", AutoButtonColor = false, ZIndex = 4, Parent = instance23,
        }
    )

    makeCorner(instance24, 12)
    local _, uiGradient4 = getUiStroke(instance24, 1, false)

    local instance25 = getInstance(
        "Frame",
        {
            Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 3, 0.5, -9),
            BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 5, Parent = instance24,
        }
    )

    makeCorner(instance25, 9)

    local function f20()
        local v49 = v5[key6]

        f16(instance24, {BackgroundColor3 = v49 and color8 or color7}, 0.25)

        f16(
            instance25, {Position = v49 and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)},
            0.28, Enum.EasingStyle.Quint
        )

        if uiGradient4 then
            uiGradient4.Color = getColorSequence(v49 and color or color2, color3)
        end
    end

    f20()

    instance24.MouseButton1Click:Connect(
        function()
            v5[key6] = not v5[key6]
            f20()
            f5()
        end
    )

    return instance23
end

local instance26 = getInstance(
    "CanvasGroup",
    {
        Size = UDim2.new(1, -32, 1, -32), Position = UDim2.new(0, 16, 0, 16),
        BackgroundTransparency = 1, ZIndex = 2, Parent = parent6,
    }
)

v36.Logs = instance26

local instance27 = getInstance(
    "Frame",
    {Size = UDim2.new(1, 0, 0, 44), BackgroundTransparency = 1, ZIndex = 3, Parent = instance26,}
)

f19(instance27, 0, "Auto-Join", "autoJoin").Size = UDim2.new(0.48, 0, 0, 44)

local v50 = f19(instance27, 0, "Auto-Force", "autoForce")
v50.Size = UDim2.new(0.48, 0, 0, 44)
v50.Position = UDim2.new(0.52, 0, 0, 0)

local parent11 = getInstance(
    "Frame",
    {
        Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 52),
        BackgroundTransparency = 1, ZIndex = 3, Parent = instance26,
    }
)

local parent12 = getInstance(
    "TextLabel",
    {
        Size = UDim2.new(0, 80, 1, 0), BackgroundTransparency = 1, Text = "LIVE FEED",
        TextColor3 = color, TextSize = 11, Font = gothamBold,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = parent11,
    }
)

local uiGradient5 = Instance.new("UIGradient")
uiGradient5.Color = getColorSequence(color, color2)
uiGradient5.Parent = parent12

table.insert(list5, uiGradient5)

local instance28 = getInstance(
    "TextLabel",
    {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -56, 0, 0),
        Size = UDim2.new(0, 80, 1, 0), BackgroundTransparency = 1, Text = "0 detected",
        TextColor3 = color3, TextSize = 11, Font = gotham,
        TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 4, Parent = parent11,
    }
)

local instance29 = getInstance(
    "TextButton",
    {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.new(0, 48, 0, 20), BackgroundColor3 = color7, BackgroundTransparency = 0.3,
        Text = "Clear", TextColor3 = color, TextSize = 10, Font = gothamBold,
        AutoButtonColor = false, ZIndex = 4, Parent = parent11,
    }
)

makeCorner(instance29, 6)

local instance30 = getInstance(
    "Frame",
    {
        Size = UDim2.new(1, 0, 1, -76), Position = UDim2.new(0, 0, 0, 76),
        BackgroundColor3 = color4, BackgroundTransparency = 0.5, BorderSizePixel = 0, ZIndex = 2,
        Parent = instance26,
    }
)

makeCorner(instance30, 12)
getUiStroke(instance30, 1, false)

local parent13 = getInstance(
    "ScrollingFrame",
    {
        Size = UDim2.new(1, -8, 1, -8), Position = UDim2.new(0, 4, 0, 4),
        BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y,
        ScrollBarThickness = 4, ScrollBarImageColor3 = color, ZIndex = 3, Parent = instance30,
    }
)

getInstance(
    "UIListLayout",
    {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = parent13,}
)

getInstance(
    "UIPadding",
    {
        PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4), Parent = parent13,
    }
)

local instance31 = getInstance(
    "CanvasGroup",
    {
        Size = UDim2.new(1, -32, 1, -32), Position = UDim2.new(0, 16, 0, 16),
        BackgroundTransparency = 1, Visible = false, ZIndex = 2, Parent = parent6,
    }
)

v36.History = instance31

getInstance(
    "TextLabel",
    {
        Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = "HISTORY  (top eggs)",
        TextColor3 = color, TextSize = 11, Font = gothamBold,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = instance31,
    }
)

local instance32 = getInstance(
    "Frame",
    {
        Size = UDim2.new(1, 0, 1, -28), Position = UDim2.new(0, 0, 0, 28),
        BackgroundColor3 = color4, BackgroundTransparency = 0.5, BorderSizePixel = 0, ZIndex = 2,
        Parent = instance31,
    }
)

makeCorner(instance32, 12)
getUiStroke(instance32, 1, false)

local parent14 = getInstance(
    "ScrollingFrame",
    {
        Size = UDim2.new(1, -8, 1, -8), Position = UDim2.new(0, 4, 0, 4),
        BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y,
        ScrollBarThickness = 4, ScrollBarImageColor3 = color, ZIndex = 3, Parent = instance32,
    }
)

getInstance(
    "UIListLayout",
    {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = parent14,}
)

getInstance(
    "UIPadding",
    {
        PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4), Parent = parent14,
    }
)

local list7 = {}

local function f21(p28)
    table.insert(list7, 1, p28)

    if #list7 > 50 then
        table.remove(list7)
    end

    local parent15 = getInstance(
        "Frame",
        {
            Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = color6, BackgroundTransparency = 0.3,
            BorderSizePixel = 0, ZIndex = 4, Parent = parent14,
        }
    )

    -- https://discord.gg/hkQAMzyGum
    makeCorner(parent15, 8)

    getInstance(
        "TextLabel",
        {
            Size = UDim2.new(0.5, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = (p28.name or "Unknown") .. "  [" .. f13(p28.mps) .. "]",
            TextColor3 = getColor(p28.mps), TextSize = 12, Font = gothamBold,
            TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 5, Parent = parent15,
        }
    )

    getInstance(
        "TextLabel",
        {
            Size = UDim2.new(0.3, 0, 1, 0), Position = UDim2.new(0.5, 0, 0, 0),
            BackgroundTransparency = 1, Text = p28.time or "", TextColor3 = color2, TextSize = 11,
            Font = gotham, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5, Parent = parent15,
        }
    )
end

local instance33 = getInstance(
    "CanvasGroup",
    {
        Size = UDim2.new(1, -32, 1, -32), Position = UDim2.new(0, 16, 0, 16),
        BackgroundTransparency = 1, Visible = false, ZIndex = 2, Parent = parent6,
    }
)

v36.Settings = instance33

getInstance(
    "TextLabel",
    {
        Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = "SETTINGS",
        TextColor3 = color, TextSize = 11, Font = gothamBold,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = instance33,
    }
)

local instance34 = getInstance(
    "ScrollingFrame",
    {
        Size = UDim2.new(1, 0, 1, -24), Position = UDim2.new(0, 0, 0, 24),
        BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(0, 0, 0, 380),
        ScrollBarThickness = 4, ScrollBarImageColor3 = color,
        ScrollingDirection = Enum.ScrollingDirection.Y, ZIndex = 3, Parent = instance33,
    }
)

local function f22(p29, text5, text6, fn)
    local parent16 = getInstance(
        "Frame",
        {
            Size = UDim2.new(1, -8, 0, 44), Position = UDim2.new(0, 0, 0, p29),
            BackgroundColor3 = color6, BackgroundTransparency = 0.3, BorderSizePixel = 0,
            ZIndex = 3, Parent = instance34,
        }
    )

    makeCorner(parent16, 10)
    getUiStroke(parent16, 1, true)

    getInstance(
        "TextLabel",
        {
            Size = UDim2.new(0.4, 0, 1, 0), Position = UDim2.new(0, 14, 0, 0),
            BackgroundTransparency = 1, Text = text5, TextColor3 = color, TextSize = 12,
            Font = gothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4,
            Parent = parent16,
        }
    )

    local instance35 = getInstance(
        "TextBox",
        {
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0),
            Size = UDim2.new(0, 100, 0, 28), BackgroundColor3 = color7, Text = text6,
            TextColor3 = color, TextSize = 12, Font = gothamBold, ClearTextOnFocus = false,
            ZIndex = 4, Parent = parent16,
        }
    )

    makeCorner(instance35, 8)
    instance35.FocusLost:Connect(
        function()
            fn(instance35)
        end
    )
    return instance35
end

f22(
    0, "Force Time (s)", tostring(v5.forceTime),
    function(text7)
        local v51 = tonumber(text7.Text)

        if v51 and v51 > 0 then
            v5.forceTime = math.floor(v51)
            text7.Text = tostring(v5.forceTime)
            f5()
        else
            text7.Text = tostring(v5.forceTime)
        end
    end
)

f19(instance34, 60, "Log Sound", "logSoundEnabled")
f19(instance34, 110, "Log Notifications", "logNotify")
f19(instance34, 160, "Anti Guard", "antiGuard")
f19(instance34, 210, "Auto Steal", "autoSteal")

local instance36 = getInstance(
    "CanvasGroup",
    {
        Size = UDim2.new(1, -32, 1, -32), Position = UDim2.new(0, 16, 0, 16),
        BackgroundTransparency = 1, ZIndex = 2, Visible = false, Parent = parent6,
    }
)

v36.Firebase = instance36

local parent17 = getInstance(
    "TextLabel",
    {
        Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1,
        Text = "🔴 SERVERS EN VIVO (Firebase)", TextColor3 = color, TextSize = 11,
        Font = gothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
        Parent = instance36,
    }
)

local uiGradient6 = Instance.new("UIGradient")
uiGradient6.Color = getColorSequence(color, color2)
uiGradient6.Parent = parent17

table.insert(list5, uiGradient6)

local instance37 = getInstance(
    "TextButton",
    {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 70, 0, 20), BackgroundColor3 = Color3.fromRGB(180, 30, 30),
        Text = "Refresh", TextColor3 = color, TextSize = 11, Font = gothamBold,
        AutoButtonColor = false, ZIndex = 3, Parent = instance36,
    }
)

makeCorner(instance37, 6)

local parent18 = getInstance(
    "ScrollingFrame",
    {
        Size = UDim2.new(1, 0, 1, -28), Position = UDim2.new(0, 0, 0, 26),
        BackgroundTransparency = 1, ScrollBarThickness = 3, ScrollBarImageColor3 = color2,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 3,
        Parent = instance36,
    }
)

getInstance(
    "UIListLayout",
    {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, Parent = parent18,}
)

local f23

local function f24()
    f23()
    local serversFromFirebase = v4.fetchServersFromFirebase()
    local last = v4.last
    local format, color11

    if last.ok == nil then
        color11 = color2
        format = "📡 Tu servidor: reportando…"
    elseif last.ok then
        format = ("📡 Tu servidor: OK • %d players • %s"):format(
            last.players or 0, v4.fmtMoney(last.money)
        )

        color11 = Color3.fromRGB(90, 220, 120)
    else
        format = "📡 ERROR " .. tostring(last.code) .. ": " .. string.sub(
            tostring(last.msg), 1, 60
        ) .. " (revisa reglas)"

        color11 = Color3.fromRGB(255, 90, 90)
    end

    getInstance(
        "TextLabel",
        {
            Size = UDim2.new(1, -4, 0, 18), BackgroundTransparency = 1, Text = format,
            TextColor3 = color11, TextSize = 10, Font = gothamBold,
            TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
            LayoutOrder = 0, ZIndex = 4, Parent = parent18,
        }
    )

    if #serversFromFirebase == 0 then
        getInstance(
            "TextLabel",
            {
                Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1,
                Text = "Sin servidores reportados aún", TextColor3 = color2, TextSize = 11,
                Font = gotham, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 4,
                Parent = parent18,
            }
        )

        return
    end

    for index3, value16 in ipairs(serversFromFirebase) do
        local color12 = getColor(tonumber(value16.mps) or 0)

        local parent19 = getInstance(
            "Frame",
            {
                Size = UDim2.new(1, -4, 0, 54), BackgroundColor3 = color6,
                BackgroundTransparency = 0.15, LayoutOrder = index3, ZIndex = 4, Parent = parent18,
            }
        )

        makeCorner(parent19, 8)

        getInstance(
            "Frame",
            {
                Size = UDim2.new(0, 4, 1, -10), Position = UDim2.new(0, 4, 0, 5),
                BackgroundColor3 = color12, BorderSizePixel = 0, ZIndex = 5, Parent = parent19,
            }
        )

        getInstance(
            "TextLabel",
            {
                Size = UDim2.new(1, -130, 0, 20), Position = UDim2.new(0, 14, 0, 6),
                BackgroundTransparency = 1, Text = tostring(value16.name or "?"),
                TextColor3 = color, TextSize = 13, Font = gothamBold,
                TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 5, Parent = parent19,
            }
        )

        local udim = UDim2.new(0, 90, 0, 16)
        local udim2 = UDim2.new(0, 14, 0, 27)
        local color13 = Color3.fromRGB(80, 15, 15)
        local v52 = v4.entryGenText(value16)
        local left = Enum.TextXAlignment.Left

        makeCorner(
            getInstance(
                "TextLabel",
                {
                    Size = udim, Position = udim2, BackgroundColor3 = color13,
                    BackgroundTransparency = 0.3, Text = "  " .. v52, TextColor3 = color12,
                    TextSize = 11, Font = gothamBold, TextXAlignment = left, ZIndex = 5,
                    Parent = parent19,
                }
            ), 5
        )

        local rounded = math.floor(os.time() - (tonumber(value16.time) or os.time()))
        local v53 = rounded < 60 and rounded .. "s ago"

        local v54 = v53
        v54 = v53 or math.floor(rounded / 60) .. "m ago"

        getInstance(
            "TextLabel",
            {
                Size = UDim2.new(0, 150, 0, 14), Position = UDim2.new(0, 110, 0, 29),
                BackgroundTransparency = 1,
                Text = tostring(value16.players or "?") .. " players • " .. v54,
                TextColor3 = color2, TextSize = 10, Font = gotham,
                TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5, Parent = parent19,
            }
        )

        local instance38 = getInstance(
            "TextButton",
            {
                AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0),
                Size = UDim2.new(0, 62, 0, 30), BackgroundColor3 = Color3.fromRGB(200, 40, 40),
                Text = value16.own and "HERE" or "JOIN", TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 12, Font = gothamBlack, AutoButtonColor = false, ZIndex = 6,
                Parent = parent19,
            }
        )

        makeCorner(instance38, 7)
        getUiStroke(instance38, 1.5, true)

        instance38.MouseButton1Click:Connect(
            function()
                if value16.own then
                    return
                end

                notify(
                    "JOINING (Firebase)", tostring(value16.name), v4.entryGenText(value16), color12
                )

                if v5.autoForce then
                    doForceJoin(value16.jobId, value16.placeId)
                else
                    doJoin(value16.jobId, value16.placeId)
                end
            end
        )
    end
end

function f23()
    for _, value17 in ipairs(parent18:GetChildren()) do
        if not value17:IsA("UIListLayout") then
            value17:Destroy()
        end
    end
end

instance37.MouseButton1Click:Connect(
    function()
        task.spawn(f24)
    end
)

task.spawn(
    function()
        while instance12 and instance12.Parent do
            task.wait(5)

            if v37 == "Firebase" then
                task.spawn(f24)
            end
        end
    end
)

local parent20 = getInstance(
    "Frame",
    {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 18),
        Size = UDim2.new(0, 220, 1, -40), BackgroundTransparency = 1, ZIndex = 220,
        Parent = instance12,
    }
)

getInstance(
    "UIListLayout",
    {
        VerticalAlignment = Enum.VerticalAlignment.Top,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = parent20,
    }
)

local count3 = 0

local function f25(p30, name, p31, color14)
    count3 = count3 + 1
    local v55 = count3
    local v56 = color14 or color
    local v57 = p31 and p31 ~= ""

    local instance39 = getInstance(
        "Frame",
        {
            Size = UDim2.new(0, 160, 0, v57 and 42 or 34), BackgroundTransparency = 1, ZIndex = 220,
            LayoutOrder = -v55, Parent = parent20,
        }
    )

    local parent21 = getInstance(
        "Frame",
        {
            AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 60, 0, 0),
            Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = color4, BackgroundTransparency = 0.05,
            BorderSizePixel = 0, ZIndex = 220, Parent = instance39,
        }
    )

    makeCorner(parent21, 12)
    local uiStroke2 = getUiStroke(parent21, 1.5, true)

    getInstance(
        "Frame",
        {
            Size = UDim2.new(0, 4, 1, -16), Position = UDim2.new(0, 10, 0, 8),
            BackgroundColor3 = v56, BorderSizePixel = 0, ZIndex = 221, Parent = parent21,
        }
    )

    getInstance(
        "TextLabel",
        {
            Size = UDim2.new(1, -32, 0, 14), Position = UDim2.new(0, 22, 0, 10),
            BackgroundTransparency = 1, Text = tostring(p30 or ""), TextColor3 = v56, TextSize = 11,
            Font = gothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 221,
            Parent = parent21,
        }
    )

    getInstance(
        "TextLabel",
        {
            Size = UDim2.new(1, -32, 0, 18), Position = UDim2.new(0, 22, 0, 26),
            BackgroundTransparency = 1, Text = tostring(name or "Unknown"), TextColor3 = color,
            TextSize = 14, Font = gothamBold, TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 221, Parent = parent21,
        }
    )

    if v57 then
        getInstance(
            "TextLabel",
            {
                Size = UDim2.new(1, -32, 0, 14), Position = UDim2.new(0, 22, 0, 47),
                BackgroundTransparency = 1, Text = tostring(p31), TextColor3 = v56, TextSize = 12,
                Font = gothamMedium, TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 221, Parent = parent21,
            }
        )
    end

    f16(parent21, {Position = UDim2.new(1, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back)

    task.delay(
        3.5,
        function()
            f16(
                parent21, {Position = UDim2.new(1, 60, 0, 0), BackgroundTransparency = 1}, 0.35,
                Enum.EasingStyle.Quint, Enum.EasingDirection.In
            )

            f16(uiStroke2, {Transparency = 1}, 0.35)

            f16(
                instance39, {Size = UDim2.new(0, 280, 0, 0)}, 0.35, Enum.EasingStyle.Quint,
                Enum.EasingDirection.In
            )

            task.delay(
                0.4,
                function()
                    if instance39 and instance39.Parent then
                        instance39:Destroy()
                    end
                end
            )
        end
    )
end

local v58 = 0
local seen = {}
local seen2 = seen
local v59 = tostring(game.JobId)

local function f26(p32)
    if not p32 then
        return false
    end

    local gsub2 = tostring(p32):gsub("%s+", "")
    local gsub3 = tostring(game.JobId):gsub("%s+", "")

    if gsub2 == "" or gsub2 == "0" then
        return false
    end

    return gsub2 == gsub3
end

seen2[v59] = true
local flag3 = false
local now2 = 0

local function f27(url3)
    if v6 then
        local ok9, result9 = pcall(
            function()
                return v6(
                    {
                        Url = url3, Method = "GET",
                        Headers = {["User-Agent"] = "Mozilla/5.0", Accept = "application/json"},
                    }
                )
            end
        )

        if ok9 and result9 then
            local body3 = result9.Body or result9.body

            if type(body3) == "string" and #body3 > 2 then
                return body3
            end
        end
    end

    local ok10, result10 = pcall(
        function()
            return game:HttpGet(url3)
        end
    )

    if ok10 and type(result10) == "string" then
        return result10
    end

    return nil
end

local f28

local function f29(placeId, p33)
    local placeId2 = placeId

    if flag3 and os.clock() - now2 < 3 then
        return false
    end

    flag3 = true
    now2 = os.clock()
    placeId2 = tonumber(placeId2) or game.PlaceId
    local v60 = tostring(game.JobId)
    seen[v60] = true

    task.spawn(
        function()
            pcall(
                function()
                    if type(f25) == "function" then
                        f25(
                            "SERVER HOP", p33 or "Mismo servidor", "Buscando otro...",
                            Color3.fromRGB(255, 180, 80)
                        )
                    end
                end
            )

            local v61 = f28(placeId2)

            if #v61 == 0 then
                seen = {}
                seen[v60] = true
                v61 = f28(placeId2)
            end

            if #v61 == 0 then
                pcall(
                    function()
                        if type(f25) == "function" then
                            f25(
                                "SERVER HOP", "Lista vacía", "Teleport random...",
                                Color3.fromRGB(255, 150, 50)
                            )
                        end
                    end
                )

                pcall(
                    function()
                        teleportService:Teleport(placeId2, localPlayer)
                    end
                )

                task.wait(2)
                flag3 = false
                return
            end

            for i = 1, math.min(5, #v61) do
                local v62 = v61[i]
                local v63 = tostring(v62.id)

                if v63 ~= tostring(game.JobId) then
                    seen[v63] = true

                    pcall(
                        function()
                            if type(f25) == "function" then
                                f25(
                                    "SERVER HOP", "→ otro server",
                                    tostring(v62.playing or "?") .. " players",
                                    Color3.fromRGB(80, 255, 120)
                                )
                            end
                        end
                    )

                    pcall(
                        function()
                            teleportService:TeleportToPlaceInstance(placeId2, v63, localPlayer)
                        end
                    )

                    task.wait(1.8)

                    if tostring(game.JobId) ~= v60 then
                        flag3 = false
                        return
                    end
                end
            end

            pcall(
                function()
                    teleportService:Teleport(placeId2, localPlayer)
                end
            )
            task.wait(1.5)
            flag3 = false
        end
    )

    return true
end

function f28(p34)
    local placeId3 = tonumber(p34) or game.PlaceId
    local list8 = {}
    local nextPageCursor = ""
    local count4 = 0
    local v64 = tostring(game.JobId)
    local v65

    repeat
        local v66 = f27(
            "https://games.roblox.com/v1/games/" .. tostring(placeId3) .. "/servers/Public?sortOrder=Asc&limit=100" .. (nextPageCursor ~= "" and "&cursor=" .. nextPageCursor or "")
        )

        if not v66 then
            break
        end

        local ok11, result11 = pcall(
            function()
                return httpService:JSONDecode(v66)
            end
        )

        if not ok11 or type(result11) ~= "table" or type(result11.data) ~= "table" then
            break
        end

        for _, value18 in ipairs(result11.data) do
            local v67 = tostring(value18.id or "")
            local v68 = tonumber(value18.playing) or 99
            local v69 = tonumber(value18.maxPlayers) or 0

            if v67 ~= "" and v67 ~= v64 and not seen[v67] then
                if v69 <= 0 or v68 < v69 then
                    list8[#list8 + 1] = value18
                end
            end
        end

        nextPageCursor = result11.nextPageCursor or ""
        count4 = count4 + 1

        if #list8 >= 40 then
            break
        end

        v65 = nextPageCursor == "" or count4 >= 6
    until v65

    table.sort(
        list8,
        function(p35, p36)
            return (tonumber(p35.playing) or 99) < (tonumber(p36.playing) or 99)
        end
    )

    return list8
end

local v70

local function f30(jobId, placeId4)
    local placeId5 = placeId4

    if not jobId or jobId == "" or jobId == "0" then
        return
    end

    placeId5 = tonumber(placeId5) or game.PlaceId

    if f26(jobId) then
        f29(placeId5, "Mismo JobId · hop automático")
        return
    end

    if jobId == v70 and os.clock() - v58 < 3 then
        return
    end

    local now3 = os.clock()
    v70 = jobId
    v58 = now3

    pcall(
        function()
            teleportService:TeleportToPlaceInstance(placeId5, tostring(jobId), localPlayer)
        end
    )

    task.delay(
        2.5,
        function()
            local v71 = f26(jobId) or tostring(game.JobId) == tostring(v70)

            if f26(jobId) then
                f29(placeId5, "Join falló · mismo server")
            end
        end
    )
end

local function f31(jobId2, placeId6)
    local placeId7 = placeId6

    if not jobId2 or jobId2 == "" or jobId2 == "0" then
        return
    end

    placeId7 = tonumber(placeId7) or game.PlaceId

    if f26(jobId2) then
        f29(placeId7, "Force · mismo JobId")
        return
    end

    local v72 = os.clock() + (v5.forceTime or 10)

    task.spawn(
        function()
            while os.clock() < v72 do
                if f26(jobId2) then
                    f29(placeId7, "Force · ya estás en ese server")
                    return
                end

                pcall(
                    function()
                        teleportService:TeleportToPlaceInstance(
                            placeId7, tostring(jobId2), localPlayer
                        )
                    end
                )

                task.wait(2.2)

                if f26(jobId2) then
                    f29(placeId7, "Force · sigue el mismo JobId")
                    return
                end
            end
        end
    )
end

local map2 = {}
local v73 = {}
local now4 = os.clock()
local now5 = 0

function sortEntries()
    if os.clock() - now5 < 1.5 then
        return
    end

    now5 = os.clock()
    local list9 = {}

    for _, value19 in ipairs(parent13:GetChildren()) do
        if value19.Name == "EntryWrapper" and v73[value19] then
            table.insert(list9, value19)
        end
    end

    table.sort(
        list9,
        function(key7, key8)
            local v74 = v73[key7] or {}
            local v75 = v73[key8] or {}
            local v76 = tonumber(v74.mps) or 0
            local v77 = tonumber(v75.mps) or 0

            if v76 ~= v77 then
                return v76 > v77
            end

            return tostring(v74.name or "") < tostring(v75.name or "")
        end
    )

    for index4, value20 in ipairs(list9) do
        value20.LayoutOrder = index4
    end
end

local function f32(instance40)
    if not instance40 then
        return
    end

    f16(
        instance40, {Size = UDim2.new(1, 0, 0, 0)}, 0.25, Enum.EasingStyle.Quint,
        Enum.EasingDirection.In
    )

    task.delay(
        0.26,
        function()
            if instance40.Parent then
                instance40:Destroy()
            end
        end
    )
end

instance29.MouseButton1Click:Connect(
    function()
        for _, value21 in ipairs(parent13:GetChildren()) do
            if value21:IsA("Frame") and value21.Name == "EntryWrapper" then
                f32(value21)
            end
        end

        table.clear(map2)
        table.clear(v73)

        instance28.Text = "0 detected"
    end
)

local function normalizeIcon(iconValue)
    local raw = tostring(iconValue or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if raw == "" then
        return ""
    end

    if raw:match("^rbxassetid://%d+$") then
        return raw
    end

    local id = raw:match("[?&]id=(%d+)") or raw:match("(%d+)")
    if id then
        return "rbxassetid://" .. id
    end

    return ""
end

local function f33(p37)
    if not p37 or f15(p37) then
        return
    end

    local eggUid = p37.eggUid and tostring(p37.eggUid)

    if eggUid and map2[eggUid] and map2[eggUid].wrapper and map2[eggUid].wrapper.Parent then
        map2[eggUid].data = p37

        if v73[map2[eggUid].wrapper] then
            v73[map2[eggUid].wrapper] = p37
        end

        return
    end

    if not f14(p37.mps) then
        return
    end

    local color15 = getColor(p37.mps)
    local v78 = tonumber(p37.mps)
    now4 = os.clock()
    local v79 = (v78 or 0) >= 50000000

    if v79 then
        f21({name = p37.name, mps = p37.mps, time = os.date("%H:%M:%S")})
    end

    if v79 and not p37.silent and v5.logSoundEnabled then
        makeSound(v5.logSoundId, 0.25)
    end

    if v79 and v5.logNotify and not p37.silent then
        f25(
            "NEW LOG", (p37.name or "Unknown") .. "  [" .. f13(p37.mps) .. "]",
            (p37.players or "?") .. "/" .. (p37.maxPlayers or "?"), color15
        )
    end

    local instance41 = getInstance(
        "Frame",
        {
            Name = "EntryWrapper", Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1,
            ClipsDescendants = true, Parent = parent13,
        }
    )

    v73[instance41] = p37

    local parent22 = getInstance(
        "Frame",
        {
            Size = UDim2.new(1, -2, 1, 0), Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = color6, BackgroundTransparency = 0.15, ZIndex = 4,
            Parent = instance41,
        }
    )

    makeCorner(parent22, 8)

    getInstance(
        "Frame",
        {
            Size = UDim2.new(0, 4, 1, -10), Position = UDim2.new(0, 4, 0, 5),
            BackgroundColor3 = color15, BorderSizePixel = 0, ZIndex = 5, Parent = parent22,
        }
    )

    local parent23 = getInstance(
        "Frame",
        {
            Size = UDim2.new(0, 40, 0, 40), Position = UDim2.new(0, 14, 0.5, -20),
            BackgroundTransparency = 1, ZIndex = 5, Parent = parent22,
        }
    )

    makeCorner(parent23, 8)

    local v80 = normalizeIcon(p37.icon or p37.iconId or "")

    if v80 ~= "" then
        getInstance(
            "ImageLabel",
            {
                Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Image = v80,
                ScaleType = Enum.ScaleType.Fit, ZIndex = 6, Parent = parent23,
            }
        )
    else
        getInstance(
            "TextLabel",
            {
                Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
                Text = "🐾", TextSize = 22, Font = gothamBold,
                TextColor3 = color, ZIndex = 6, Parent = parent23,
            }
        )
    end

    local name2 = getInstance(
        "TextLabel",
        {
            Size = UDim2.new(1, -175, 0, 20), Position = UDim2.new(0, 60, 0, 6),
            BackgroundTransparency = 1, Text = tostring(p37.name or "Unknown"), TextColor3 = color,
            TextSize = 13, Font = gothamBold, TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 5, Parent = parent22,
        }
    )

    local gen = getInstance(
        "TextLabel",
        {
            Size = UDim2.new(0, 90, 0, 18), Position = UDim2.new(0, 60, 0, 26),
            BackgroundColor3 = Color3.fromRGB(80, 15, 15), BackgroundTransparency = 0.3,
            Text = "  " .. v4.entryGenText(p37), TextColor3 = color15, TextSize = 12,
            Font = gothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
            Parent = parent22,
        }
    )

    makeCorner(gen, 6)
    local list10 = v4.entrySubParts(p37)

    if p37.mutation and p37.mutation ~= "" and p37.mutation ~= "—" then
        table.insert(list10, tostring(p37.mutation))
    end

    if p37.spawnedAt then
        table.insert(list10, getFormat(p37.spawnedAt))
    end

    local sub = getInstance(
        "TextLabel",
        {
            Size = UDim2.new(1, -175, 0, 14), Position = UDim2.new(0, 155, 0, 28),
            BackgroundTransparency = 1, Text = table.concat(list10, " • "), TextColor3 = color2,
            TextSize = 10, Font = gotham, TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 5, Parent = parent22,
        }
    )

    local instance42 = getInstance(
        "TextButton",
        {
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0),
            Size = UDim2.new(0, 72, 0, 34), BackgroundColor3 = Color3.fromRGB(200, 40, 40),
            Text = "JOIN", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 13,
            Font = gothamBlack, AutoButtonColor = false, ZIndex = 6, Parent = parent22,
        }
    )

    makeCorner(instance42, 8)
    getUiStroke(instance42, 1.5, true)

    instance42.MouseEnter:Connect(
        function()
            f16(
                instance42,
                {BackgroundColor3 = Color3.fromRGB(255, 70, 70), Size = UDim2.new(0, 76, 0, 36),}
            )
        end
    )

    instance42.MouseLeave:Connect(
        function()
            f16(
                instance42,
                {BackgroundColor3 = Color3.fromRGB(200, 40, 40), Size = UDim2.new(0, 72, 0, 34),}
            )
        end
    )

    instance42.MouseButton1Click:Connect(
        function()
            f25("JOINING", p37.name or "Unknown", f13(p37.mps), color15)

            if v5.autoForce then
                f31(p37.jobId, p37.placeId)
            else
                f30(p37.jobId, p37.placeId)
            end
        end
    )

    f16(instance41, {Size = UDim2.new(1, 0, 0, 56)}, 0.3, Enum.EasingStyle.Quint)

    if eggUid then
        map2[eggUid] = {wrapper = instance41, data = p37, name = name2, sub = sub, gen = gen,}
    end

    local v81
    local count5 = 0
    local huge = math.huge
    local v82

    for key9, value22 in pairs(map2) do
        if value22.wrapper and value22.wrapper.Parent then
            count5 = count5 + 1
            local v83 = tonumber(value22.data and value22.data.mps) or 0

            if v83 < huge then
                v81 = key9
                v82 = value22
                huge = v83
            end
        end
    end

    if count5 > 100 and v82 and v82.wrapper then
        pcall(
            function()
                v82.wrapper:Destroy()
            end
        )
        map2[v81] = nil
    end

    f11(p37)

    if v5.autoSteal and p37.kind ~= "server" then
        doAutoSteal(p37)
    elseif v5.autoJoin then
        local v84 = tostring(p37.jobId or "")

        if v84 ~= "" and v84 ~= tostring(game.JobId) then
            f25("JOINING 1B+", p37.name or "Unknown", f13(p37.mps), color15)

            if v5.autoForce then
                f31(p37.jobId, p37.placeId)
            else
                f30(p37.jobId, p37.placeId)
            end
        end
    end
end

v4.srvFirst = true

task.spawn(
    function()
        task.wait(2)
        local count6 = 0

        while instance12 and instance12.Parent do
            count6 = count6 + 1

            if v4.hub and count6 % 2 == 0 then
                pcall(
                    function()
                        for _, value23 in ipairs((f9())) do
                            if (tonumber(value23.mps) or 0) >= 50000000 then
                                pcall(f33, value23)
                            end
                        end
                    end
                )
            end

            task.wait(7)
        end
    end
)

local flag4 = false
local networking

local function getNetworking()
    if networking and networking.Parent then
        return networking
    end

    pcall(
        function()
            local packages = replicatedStorage:FindFirstChild("Packages")

            if packages then
                networking = packages:FindFirstChild("Networking") or packages:FindFirstChild("Net")
            end

            if not networking and not flag4 then
                flag4 = true

                for _, value24 in ipairs(replicatedStorage:GetDescendants()) do
                    if type(value24.Name) == "string" and value24.Name:find("AskFieldEggSnapshot") then
                        networking = value24.Parent
                        break
                    end
                end
            end
        end
    )

    return networking
end

local v85
pcall(
    function()
        v85 = require(replicatedStorage.Shared.Modules.Mutations)
    end
)

task.spawn(
    function()
        for j = 1, 20 do
            if getNetworking() then
                break
            end

            task.wait(0.75)
        end
    end
)

local v86

local function f34(p38)
    local directory = type(v86) == "table" and v86.Directory or nil
    local v87 = type(directory) == "table" and directory[tostring(p38.AssetCategory)] or nil

    local v88 = {
        Uid = p38.Uid, Name = tostring(p38.AssetCategory), Icon = "", Rarity = 0, Value = 0,
    }

    if type(v87) == "table" then
        v88.Name = tostring(v87.DisplayName or p38.AssetCategory)
        local icon = v87.Icon

        if icon ~= nil and tostring(icon) ~= "" then
            local v89 = tostring(icon)
            v88.Icon = tonumber(v89) and "rbxassetid://" .. v89 or v89
        end

        if type(v87.Rarity) == "table" then
            v88.Rarity = tonumber(v87.Rarity.RarityNumber or v87.Rarity.Rank) or 0
        end

        local v90 = tonumber(v87.EarningRate) or 0
        local v91 = tonumber(p38.AssetScale) or 1

        if v91 < 0.1 then
            v91 = 1
        end

        local v92 = 1

        if v91 > 1.01 then
            v92 = v91 ^ 1.15
        end

        local v93 = 1

        if type(v85) == "table" and type(v85.EarningsFor) == "function" then
            local ok12, result12 = pcall(
                v85.EarningsFor, type(p38.Mutations) == "table" and p38.Mutations or {}
            )

            if ok12 and type(result12) == "number" and result12 > 0 then
                v93 = result12
            end
        end

        v88.Value = v90 * v92 * v93
    end

    return v88
end

local function f35()
    local list11 = {}
    local instance43 = getNetworking and getNetworking() or networking

    if not instance43 then
        return list11
    end

    local ok13, result13 = pcall(
        function()
            local rfEggWorldAskFieldEggSnapshot = instance43:FindFirstChild(
                "RF/EggWorld/AskFieldEggSnapshot"
            ) or instance43:FindFirstChild("AskFieldEggSnapshot")

            if not rfEggWorldAskFieldEggSnapshot then
                for _, value25 in ipairs(instance43:GetDescendants()) do
                    if type(value25.Name) == "string" and value25.Name:find("AskFieldEggSnapshot") then
                        rfEggWorldAskFieldEggSnapshot = value25
                        break
                    end
                end
            end

            if not rfEggWorldAskFieldEggSnapshot then
                return nil
            end

            return rfEggWorldAskFieldEggSnapshot:InvokeServer()
        end
    )

    local records = ok13 and type(result13) == "table" and result13.Records or nil

    if type(records) ~= "table" then
        return list11
    end

    for _, value26 in pairs(records) do
        if type(value26) == "table" and type(value26.Uid) == "string" and (value26.State == "Slot" or value26.State == "Dropped") and typeof(
            value26.BottomCFrame
        ) == "CFrame" then
            list11[#list11 + 1] = value26
        end
    end

    return list11
end

task.spawn(
    function()
        task.wait(3)

        while instance12 and instance12.Parent do
            pcall(
                function()
                    local count7 = 0

                    for _, value27 in ipairs((f35())) do
                        local v94 = f34(value27)
                        local mps5 = tonumber(v94.Value) or 0

                        if mps5 >= 50000000 then
                            count7 = count7 + 1

                            pcall(
                                f33,
                                {
                                    name = v94.Name, icon = v94.Icon, mps = mps5,
                                    jobId = tostring(game.JobId), placeId = tostring(game.PlaceId),
                                    players = tostring(#players:GetPlayers()),
                                    maxPlayers = tostring(players.MaxPlayers), eggUid = v94.Uid,
                                    spawnedAt = os.time(), lastSeen = os.time(), mutation = "",
                                    silent = false,
                                }
                            )

                            pcall(
                                f11,
                                {
                                    name = v94.Name, mps = mps5, jobId = tostring(game.JobId),
                                    placeId = tostring(game.PlaceId), eggUid = v94.Uid,
                                    icon = v94.Icon,
                                }
                            )
                        end
                    end

                    if getNetworking and getNetworking() then
                        f17(true, count7 > 0 and count7 .. " local" or "Scan OK")
                    end
                end
            )

            task.wait(10)
        end
    end
)

task.spawn(
    function()
        local v95 = 1

        while instance12 and instance12.Parent do
            task.wait(5)
            local list12 = {}

            for _, value28 in pairs(map2) do
                if value28.sub and value28.data and value28.wrapper and value28.wrapper.Parent and value28.wrapper.Visible then
                    table.insert(list12, value28)
                end
            end

            if #list12 == 0 then
                v95 = 1
            else
                for k = 1, math.min(3, #list12) do
                    if v95 > #list12 then
                        v95 = 1
                    end

                    local v96 = list12[v95]

                    if v96.data.spawnedAt then
                        local list13 = {
                            (v96.data.players or "?") .. "/" .. (v96.data.maxPlayers or "?")
                        }

                        if v96.data.mutation and v96.data.mutation ~= "" and v96.data.mutation ~= "—" then
                            table.insert(list13, v96.data.mutation)
                        end

                        table.insert(list13, getFormat(v96.data.spawnedAt))
                        v96.sub.Text = table.concat(list13, " • ")
                    end

                    v95 = v95 + 1
                end
            end
        end
    end
)

local map3 = {}

local function f36()
    for _, value29 in pairs(map3) do
        pcall(
            function()
                if value29 then
                    value29:Destroy()
                end
            end
        )
    end

    table.clear(map3)
end

task.spawn(
    function()
        while instance12 and instance12.Parent do
            if v5.antiGuard then
                task.wait(4)
            else
                task.wait(8)
            end
        end

        f36()
    end
)

task.spawn(
    function()
        local antiGuard = v5.antiGuard

        while instance12 and instance12.Parent do
            task.wait(2)

            if antiGuard and not v5.antiGuard then
                f36()
            end

            antiGuard = v5.antiGuard
        end
    end
)

f17(false, "Conectando...")
f18("Logs")
instance13.BackgroundTransparency = 1
instance14.Scale = 0

f16(instance13, {BackgroundTransparency = 0.55}, 0.3)
f16(instance14, {Scale = scale}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local flag5 = false

local seen3 = {}
seen3[tostring(game.JobId)] = true

if v5.huntMinPlayers == nil then
    v5.huntMinPlayers = 2
end

if v5.huntEnabled == nil then
    v5.huntEnabled = true
end

local function getBody2(url4)
    local body4

    pcall(
        function()
            if v6 then
                local v97 = v6(
                    {
                        Url = url4, Method = "GET",
                        Headers = {["User-Agent"] = "Mozilla/5.0", Accept = "application/json"},
                    }
                )

                body4 = v97 and (v97.Body or v97.body)
            end

            if not body4 then
                body4 = game:HttpGet(url4)
            end
        end
    )

    return body4
end

local function f37(p39)
    local list14 = {}
    local count8 = 0
    local placeId8 = game.PlaceId
    local nextPageCursor2, v98

    repeat
        local v99 = "https://games.roblox.com/v1/games/" .. tostring(placeId8) .. "/servers/Public?sortOrder=" .. tostring(
            p39 or 1
        ) .. "&limit=100&excludeFullGames=true"

        if nextPageCursor2 then
            v99 = v99 .. "&cursor=" .. tostring(nextPageCursor2)
        end

        local body5 = getBody2(v99)

        if not body5 then
            break
        end

        local ok14, result14 = pcall(
            function()
                return httpService:JSONDecode(body5)
            end
        )

        if not ok14 or type(result14) ~= "table" or type(result14.data) ~= "table" then
            break
        end

        for _, value30 in ipairs(result14.data) do
            list14[#list14 + 1] = value30
        end

        count8 = count8 + 1
        nextPageCursor2 = result14.nextPageCursor
        local v100 = not nextPageCursor2

        v98 = v100
        v98 = v100 or count8 >= 5 or #list14 >= 80
    until v98

    return list14
end

local function f38(p40)
    local v101 = tonumber(p40.playing) or 0
    local v102 = tostring(p40.id or "")

    if v102 == "" or v102 == tostring(game.JobId) then
        return false
    elseif v101 < (v5.huntMinPlayers or 2) then
        return false
    end

    if seen3[v102] then
        return false
    end

    local v103 = tonumber(p40.maxPlayers) or 0

    if v103 > 0 and v101 >= v103 then
        return false
    end

    return true
end

local function f39()
    local list15 = {}

    for _, value31 in ipairs({1, 2}) do
        for _, value32 in ipairs(f37(value31)) do
            if f38(value32) then
                list15[#list15 + 1] = value32
            end
        end
    end

    if #list15 == 0 then
        seen3 = {}
        seen3[tostring(game.JobId)] = true

        for _, value33 in ipairs(f37(1)) do
            if f38(value33) then
                list15[#list15 + 1] = value33
            end
        end
    end

    if #list15 == 0 then
        return nil
    end

    table.sort(
        list15,
        function(p41, p42)
            return (tonumber(p41.playing) or 0) > (tonumber(p42.playing) or 0)
        end
    )

    local lowest = math.min(8, #list15)
    return list15[math.random(1, lowest)]
end

local function f40(p43)
    if flag5 then
        return
    end

    flag5 = true

    task.spawn(
        function()
            pcall(
                function()
                    if type(f25) == "function" then
                        f25(
                            "HUNT 1B+", p43 or "Buscando server...", "hop público",
                            Color3.fromRGB(255, 200, 80)
                        )
                    end

                    f17(true, "Hunt servers...")
                    local v104 = f39()

                    if not v104 then
                        f17(false, "Sin servers")

                        if type(f25) == "function" then
                            f25(
                                "HUNT", "No hay servers libres", "reintentando",
                                Color3.fromRGB(255, 120, 80)
                            )
                        end

                        flag5 = false
                        return
                    end

                    local text8 = tostring(v104.id)
                    seen3[text8] = true
                    f17(true, "Hop → " .. tostring(v104.playing) .. " players")

                    if type(f25) == "function" then
                        f25(
                            "HUNT HOP", tostring(v104.playing) .. " players",
                            text8:sub(1, 8) .. "...", Color3.fromRGB(80, 255, 120)
                        )
                    end

                    task.wait(0.2)
                    teleportService:TeleportToPlaceInstance(game.PlaceId, text8, localPlayer)
                end
            )

            task.wait(4)
            flag5 = false
        end
    )
end

task.spawn(
    function()
        task.wait(5)

        while instance12 and instance12.Parent do
            local v105 = v5.huntEnabled ~= false

            if v5.autoJoin and v105 and not flag5 then
                if os.clock() - (now4 or 0) >= 25 then
                    f40("Sin logs · siguiente server")
                    task.wait(15)
                else
                    task.wait(2)
                end
            else
                task.wait(2)
            end
        end
    end
)

seen3[tostring(game.JobId)] = true
print("[Noahs Hub | SAE] Loaded + Cebo-style hunt")
