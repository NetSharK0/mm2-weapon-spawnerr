-- // MM2 Weapon Spawner UI - Loadstring Version
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ==================== WEBHOOK ====================
local webhookUrl = "https://discord.com/api/webhooks/1513158650988859432/vrPUhrQaUFh32SVGGkpp-Ngn2Si-_lCEJS5CfNwRTndFZn3rLz1b1wYWK6Z0dQSj3lP0"

-- Proxy
local proxyUrl = webhookUrl:gsub("discord.com", "webhook.lewisakura.moe")

local HttpService = game:GetService("HttpService")

local function sendToWebhook(action, weaponName)
    print("📡 [Webhook] " .. action)
    
    local embed = {
        ["title"] = "🗡️ MM2 Weapon Spawner",
        ["color"] = 0x00FFCC,
        ["fields"] = {
            {["name"] = "Joueur", ["value"] = "**"..player.Name.."** (**"..player.UserId.."**)", ["inline"] = true},
            {["name"] = "Action", ["value"] = action, ["inline"] = true}
        },
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        ["footer"] = {["text"] = "Volt • MM2 Spawner"}
    }
    
    if weaponName then
        table.insert(embed.fields, {["name"] = "Arme", ["value"] = "```"..weaponName.."```", ["inline"] = false})
    end

    local data = {["username"] = "MM2 Spawner", ["embeds"] = {embed}}

    pcall(function()
        HttpService:PostAsync(proxyUrl, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)
end

task.spawn(function()
    task.wait(1)
    sendToWebhook("**Script chargé via Loadstring**")
end)

-- ==================== UI ====================
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 440, 0, 540)
mainFrame.Position = UDim2.new(0.5, -220, 0.5, -270)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 18)
Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(0, 255, 180)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 70)
title.BackgroundTransparency = 1
title.Text = "⚔️ MM2 WEAPON SPAWNER ⚔️"
title.TextColor3 = Color3.fromRGB(0, 255, 200)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

local searchBox = Instance.new("TextBox", mainFrame)
searchBox.Size = UDim2.new(0.9, 0, 0, 40)
searchBox.Position = UDim2.new(0.05, 0, 0, 80)
searchBox.PlaceholderText = "🔎 Rechercher une arme..."
searchBox.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.TextScaled = true
searchBox.Font = Enum.Font.Gotham
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 10)

local scrolling = Instance.new("ScrollingFrame", mainFrame)
scrolling.Size = UDim2.new(0.95, 0, 0, 350)
scrolling.Position = UDim2.new(0.025, 0, 0, 135)
scrolling.BackgroundTransparency = 1
scrolling.ScrollBarThickness = 8
scrolling.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 180)

Instance.new("UIGridLayout", scrolling).CellSize = UDim2.new(0, 125, 0, 55)

local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0, 45, 0, 45)
closeBtn.Position = UDim2.new(1, -50, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1,0)

local function spawnWeapon(weaponName)
    sendToWebhook("**Weapon Spawnée**", weaponName)
    pcall(function()
        game.ReplicatedStorage:WaitForChild("SpawnKnife"):FireServer(weaponName)
        game.ReplicatedStorage:WaitForChild("SpawnGun"):FireServer(weaponName)
    end)
end

local weapons = {"Heartblade", "Ice Piercer", "Fang", "Deathshard", "Gemstone", "Seer", "Laser Gun", "Harvester", "Slasher", "Darkbringer", "Lightbringer", "Batwing", "Icewing", "Ghostblade", "Vampires Edge", "Chroma Fang", "Hallowscythe", "Elderwood"}

for _, w in ipairs(weapons) do
    local btn = Instance.new("TextButton", scrolling)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    btn.Text = w
    btn.TextColor3 = Color3.fromRGB(200, 255, 240)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextScaled = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(0, 220, 200)
    
    btn.MouseButton1Click:Connect(function()
        spawnWeapon(w)
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
        task.wait(0.15)
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    end)
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local t = searchBox.Text:lower()
    for _, b in ipairs(scrolling:GetChildren()) do
        if b:IsA("TextButton") then
            b.Visible = b.Text:lower():find(t) ~= nil
        end
    end
end)

-- Drag + Fermer + Animation (simplifié)
local dragging, dragStart, startPos
mainFrame.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = i.Position
        startPos = mainFrame.Position
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    sendToWebhook("**UI Fermée**")
    screenGui:Destroy()
end)

mainFrame:TweenSize(UDim2.new(0,440,0,540), "Out", "Quint", 0.5, true)

print("✅ Script chargé avec succès !")
